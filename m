From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/3] multipath: Add new SPC-3 ALUA hardware handler
Date: Thu, 15 Nov 2007 10:16:34 +0100
Message-ID: <20071115091634.4568D347401@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXKOJQf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2007 04:16:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org


This adds a new SPC-3 ALUA hardware handler for multipathing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/Kconfig         |    7 +
 drivers/md/Makefile        |    2 +
 drivers/md/dm-mpath-alua.c |  681 ++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi.h        |    3 +
 4 files changed, 693 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-mpath-alua.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 9b6fbf0..2044fb4 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -273,6 +273,13 @@ config DM_MULTIPATH_HP
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 
+config DM_MULTIPATH_ALUA
+	tristate "SPC-3 ALUA multipath support (EXPERIMENTAL)"
+	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Multipath support for SPC-3 Asymmetric Logical Unit
+	  Access (ALUA).
+
 config DM_DELAY
 	tristate "I/O delaying target (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index d9aa7ed..6b8fd78 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -8,6 +8,7 @@ dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-log.o dm-raid1.o
 dm-rdac-objs	:= dm-mpath-rdac.o
+dm-alua-objs	:= dm-mpath-alua.o
 dm-hp-sw-objs	:= dm-mpath-hp-sw.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
@@ -38,6 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o
 obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rdac.o
+obj-$(CONFIG_DM_MULTIPATH_ALUA)	+= dm-alua.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
diff --git a/drivers/md/dm-mpath-alua.c b/drivers/md/dm-mpath-alua.c
new file mode 100644
index 0000000..cc954f2
--- /dev/null
+++ b/drivers/md/dm-mpath-alua.c
@@ -0,0 +1,681 @@
+/*
+ * Generic SCSI-3 ALUA DM HW handler
+ *
+ * Copyright (C) 2007 Hannes Reinecke, SUSE Linux Products GmbH.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
+
+#define DM_MSG_PREFIX "multipath alua"
+
+#include "dm.h"
+#include "dm-hw-handler.h"
+
+#define DM_ALUA_HWH_NAME "alua"
+#define DM_ALUA_HWH_VER "1.0"
+
+#define TPGS_STATE_OPTIMIZED		0x0
+#define TPGS_STATE_NONOPTIMIZED		0x1
+#define TPGS_STATE_STANDBY		0x2
+#define TPGS_STATE_UNAVAILABLE		0x3
+#define TPGS_STATE_OFFLINE		0xe
+#define TPGS_STATE_TRANSITIONING	0xf
+
+#define TPGS_SUPPORT_NONE		0x00
+#define TPGS_SUPPORT_OPTIMIZED		0x01
+#define TPGS_SUPPORT_NONOPTIMIZED	0x02
+#define TPGS_SUPPORT_STANDBY		0x04
+#define TPGS_SUPPORT_UNAVAILABLE	0x08
+#define TPGS_SUPPORT_OFFLINE		0x40
+#define TPGS_SUPPORT_TRANSITION		0x80
+
+#define TPGS_MODE_UNINITIALIZED		 -1
+#define TPGS_MODE_NONE			0x0
+#define TPGS_MODE_IMPLICIT		0x1
+#define TPGS_MODE_EXPLICIT		0x2
+
+#define ALUA_INQUIRY_SIZE		36
+#define ALUA_FAILOVER_TIMEOUT		(60 * HZ)
+
+struct alua_handler {
+	struct dm_path		*path;
+	int			group_id;
+	int			rel_port;
+	int			tpgs;
+	int			state;
+	int			retry;
+	unsigned char		inq[ALUA_INQUIRY_SIZE];
+	unsigned char		*buff;
+	int			bufflen;
+	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+#define ALUA_POLICY_SWITCH_CURRENT	0
+#define ALUA_POLICY_SWITCH_ALL		1
+
+static inline int had_failures(struct request *req, int error)
+{
+	return (error || host_byte(req->errors) != DID_OK ||
+			msg_byte(req->errors) != COMMAND_COMPLETE);
+}
+
+static int realloc_buffer(struct alua_handler *h, unsigned len)
+{
+	if (h->buff && h->buff != h->inq)
+		kfree(h->buff);
+
+	h->buff = kzalloc(len, GFP_KERNEL);
+	if (!h->buff) {
+		DMINFO("%s: kmalloc buffer failed",__FUNCTION__);
+		h->buff = h->inq;
+		h->bufflen = ALUA_INQUIRY_SIZE;
+		return 1;
+	}
+	h->bufflen = len;
+	return 0;
+}
+
+static struct request *prepare_req(struct hw_handler *hwh,
+				   void *buffer, unsigned buflen, int rw)
+{
+	struct alua_handler *h = hwh->context;
+	struct request *rq;
+	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
+
+	if (!q) {
+		DMWARN("%s: no queue", __FUNCTION__);
+		return NULL;
+	}
+
+	rq = blk_get_request(q, rw, GFP_KERNEL);
+
+	if (!rq) {
+		DMINFO("%s: blk_get_request failed", __FUNCTION__);
+		return NULL;
+	}
+
+	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
+		blk_put_request(rq);
+		DMINFO("%s: blk_rq_map_kern failed", __FUNCTION__);
+		return NULL;
+	}
+
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+
+	rq->timeout = ALUA_FAILOVER_TIMEOUT;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE | REQ_QUIET;
+	rq->end_io_data = hwh;
+
+	return rq;
+}
+
+/*
+ * Standard INQUIRY endio handler
+ *
+ * Just extract the TPGS setting to find out if ALUA
+ * is supported.
+ */
+static void std_inquiry_endio(struct request *req, int error)
+{
+	struct hw_handler *hwh = req->end_io_data;
+	struct alua_handler *h = hwh->context;
+
+	if (had_failures(req, error)) {
+		DMWARN("%s: std inquiry error %x %x",
+		       h->path->dev->name, req->errors, error);
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		goto done;
+	}
+
+	/* Check TPGS setting */
+	h->tpgs = (h->inq[5] >> 4) & 0x3;
+	switch (h->tpgs) {
+	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
+		DMWARN("%s: supports implicit and explicit TPGS",
+		       h->path->dev->name);
+		break;
+	case TPGS_MODE_EXPLICIT:
+		DMWARN("%s: supports explicit TPGS",
+		       h->path->dev->name);
+		break;
+	case TPGS_MODE_IMPLICIT:
+		DMWARN("%s: supports implicit TPGS",
+		       h->path->dev->name);
+		break;
+	default:
+		DMWARN("%s: TPGS not supported (%x)",
+		       h->path->dev->name, h->inq[5] >> 4);
+		h->tpgs = TPGS_MODE_NONE;
+		break;
+	}
+
+	if (h->tpgs == TPGS_MODE_NONE) {
+		/*
+		 * ALUA not supported
+		 */
+		dm_pg_init_complete(h->path, 0);
+	} else
+		dm_enqueue_hw_workq(hwh);
+
+ done:
+	__blk_put_request(req->q, req);
+}
+
+/*
+ * Issue a standard INQUIRY command
+ */
+static void submit_std_inquiry(struct hw_handler *hwh)
+{
+	struct alua_handler *h = hwh->context;
+	struct request *rq;
+
+	if (h->buff && h->buff != h->inq) {
+		DMWARN("%s: std inq free buf", h->path->dev->name);
+		kfree(h->buff);
+	}
+
+	h->buff = h->inq;
+	h->bufflen = ALUA_INQUIRY_SIZE;
+
+	rq = prepare_req(hwh, h->inq, ALUA_INQUIRY_SIZE, READ);
+	if (!rq) {
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		return;
+	}
+
+	/* Prepare the command. */
+	rq->cmd[0] = INQUIRY;
+	rq->cmd[1] = 0;
+	rq->cmd[2] = 0;
+	rq->cmd[3] = 0;
+	rq->cmd[4] = ALUA_INQUIRY_SIZE;
+	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+
+	DMINFO("%s: submit std inq %x %x %x %x %x %x",
+	       h->path->dev->name, rq->cmd[0], rq->cmd[1],
+	       rq->cmd[2], rq->cmd[3], rq->cmd[4], rq->cmd[5]);
+
+	blk_execute_rq_nowait(rq->q, NULL, rq, 1, std_inquiry_endio);
+}
+
+/*
+ * INQUIRY vpd page 0x83 endio handler
+ *
+ * Extract the relative target port and the target port group
+ * descriptor from the list of identificators.
+ */
+static void vpd_inquiry_endio(struct request *req, int error)
+{
+	struct hw_handler *hwh = req->end_io_data;
+	struct alua_handler *h = hwh->context;
+	int len;
+	unsigned char *d;
+
+	if (had_failures(req, error)) {
+		DMWARN("%s: vpd inquiry error %x %x",
+		       h->path->dev->name, req->errors, error);
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		goto out;
+	}
+
+	/* Check if vpd page exceeds initial buffer */
+	len = (h->buff[2] << 8) + h->buff[3] + 4;
+	if (len > h->bufflen) {
+		/* Resubmit with the correct length */
+		if (realloc_buffer(h, len)) {
+			DMINFO("%s: kmalloc buffer failed",__FUNCTION__);
+			/* Temporary failure, bypass */
+			dm_pg_init_complete(h->path, MP_BYPASS_PG);
+		} else {
+			dm_enqueue_hw_workq(hwh);
+		}
+		goto out;
+	}
+
+	/*
+	 * Now look for the correct descriptor.
+	 */
+	d = h->buff + 4;
+	while (d < h->buff + len) {
+		switch (d[1] & 0xf) {
+		case 0x4:
+			/* Relative target port */
+			h->rel_port = (d[6] << 8) + d[7];
+			break;
+		case 0x5:
+			/* Target port group */
+			h->group_id = (d[6] << 8) + d[7];
+			break;
+		default:
+			break;
+		}
+		d += d[3] + 4;
+	}
+
+	if (h->group_id == -1) {
+		/*
+		 * Internal error; TPGS supported but required
+		 * VPD identification descriptors not present.
+		 * Disable ALUA support
+		 */
+		DMWARN("%s: No target port descriptors in VPD page 0x83\n",
+		       h->path->dev->name);
+		h->state = TPGS_STATE_OPTIMIZED;
+		h->tpgs = TPGS_MODE_NONE;
+		dm_pg_init_complete(h->path, 0);
+	} else {
+		DMWARN("%s: port group %02x rel port %02x",
+		       h->path->dev->name, h->group_id, h->rel_port);
+		dm_enqueue_hw_workq(hwh);
+	}
+
+ out:
+	__blk_put_request(req->q, req);
+}
+
+/*
+ * Issue an INQUIRY VPD page 0x83 command
+ */
+static void submit_vpd_inquiry(struct hw_handler *hwh)
+{
+	struct alua_handler *h = hwh->context;
+	struct request *rq;
+
+	rq = prepare_req(hwh, h->buff, h->bufflen, READ);
+	if (!rq) {
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		return;
+	}
+
+	/* Prepare the command. */
+	rq->cmd[0] = INQUIRY;
+	rq->cmd[1] = 1;
+	rq->cmd[2] = 0x83;
+	rq->cmd[4] = h->bufflen;
+	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+
+	DMINFO("%s: submit vpd inq %x %x %x %x %x %x",
+	       h->path->dev->name, rq->cmd[0], rq->cmd[1],
+	       rq->cmd[2], rq->cmd[3], rq->cmd[4], rq->cmd[5]);
+
+	blk_execute_rq_nowait(rq->q, NULL, rq, 1, vpd_inquiry_endio);
+}
+
+static char print_alua_state(int state)
+{
+	switch (state) {
+	case TPGS_STATE_OPTIMIZED:
+		return 'A';
+	case TPGS_STATE_NONOPTIMIZED:
+		return 'N';
+	case TPGS_STATE_STANDBY:
+		return 'S';
+	case TPGS_STATE_UNAVAILABLE:
+		return 'U';
+	case TPGS_STATE_OFFLINE:
+		return 'O';
+	case TPGS_STATE_TRANSITIONING:
+		return 'T';
+	default:
+		return 'X';
+	}
+}
+
+/*
+ * REPORT TARGET GROUP STATES endio handler
+ *
+ * Set the Target Port Group State. If the state
+ * is not 'active/optimized' we will try to activate
+ * this group by sending a 'SET TARGET GROUP STATES'
+ * command.
+ * If the state is 'offline' we will just fail the
+ * path.
+ */
+static void rtpg_endio(struct request *req, int error)
+{
+	struct hw_handler *hwh = req->end_io_data;
+	struct alua_handler *h = hwh->context;
+	struct scsi_sense_hdr sense_hdr;
+	int len, k, off, valid_states = 0, sense = 0;
+	char *ucp;
+
+	if (had_failures(req, error)) {
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		goto done;
+	}
+
+	if (status_byte(error) == CHECK_CONDITION) {
+		scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+				     &sense_hdr);
+		/* Retry if not ready */
+		if (sense_hdr.sense_key == NOT_READY) {
+			DMWARN("%s: device not ready, retry",
+			       h->path->dev->name);
+			dm_enqueue_hw_workq(hwh);
+			goto done;
+		}
+		/* Retry on Unit Attention */
+		sense = (sense_hdr.sense_key << 16) | (sense_hdr.asc << 8) |
+				sense_hdr.ascq;
+		if (sense == 0x62a06) {
+			DMWARN("%s: unit attention after state transition",
+			       h->path->dev->name);
+			dm_enqueue_hw_workq(hwh);
+			goto done;
+		}
+	}
+
+	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
+		(h->buff[2] << 8) + h->buff[3] + 4;
+
+	if (len > h->bufflen) {
+		/* Resubmit with the correct length */
+		if (realloc_buffer(h, len)) {
+			DMINFO("%s: kmalloc buffer failed",__FUNCTION__);
+			/* Temporary failure, bypass */
+			dm_pg_init_complete(h->path, MP_BYPASS_PG);
+		} else {
+			dm_enqueue_hw_workq(hwh);
+		}
+		goto done;
+	}
+
+	for (k = 4, ucp = h->buff + 4; k < len; k += off, ucp += off) {
+		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
+			h->state = ucp[0] & 0x0f;
+			valid_states = ucp[1];
+		}
+		off = 8 + (ucp[7] * 4);
+	}
+
+	DMWARN("%s: port group %02x state %c supports %c%c%c%c%c%c",
+	       h->path->dev->name, h->group_id, print_alua_state(h->state),
+	       valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
+	       valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+	       valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
+	       valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
+	       valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
+	       valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+
+	if (h->tpgs & TPGS_MODE_EXPLICIT) {
+		switch (h->state) {
+		case TPGS_STATE_TRANSITIONING:
+			/* State transition, retry */
+			dm_enqueue_hw_workq(hwh);
+			break;
+		case TPGS_STATE_OPTIMIZED:
+			/* Path in Active/Optmized state, all done */
+			dm_pg_init_complete(h->path, 0);
+			break;
+		case TPGS_STATE_OFFLINE:
+			/* Path is offline, fail */
+			dm_pg_init_complete(h->path, MP_FAIL_PATH);
+			break;
+		default:
+			/* Switch path to Active/Optimized */
+			dm_enqueue_hw_workq(hwh);
+			break;
+		}
+	} else {
+		/* Only Implicit ALUA support */
+		if (h->state == TPGS_STATE_OPTIMIZED ||
+		    h->state == TPGS_STATE_NONOPTIMIZED ||
+		    h->state == TPGS_STATE_STANDBY)
+			/* Useable path if active */
+			dm_pg_init_complete(h->path, 0);
+		else
+			/* Path unuseable for unavailable/offline */
+			dm_pg_init_complete(h->path, MP_FAIL_PATH);
+	}
+
+ done:
+	__blk_put_request(req->q, req);
+}
+
+/*
+ * Issue a REPORT TARGET GROUP STATES command.
+ */
+static void submit_rtpg(struct hw_handler *hwh)
+{
+	struct alua_handler *h = hwh->context;
+	struct request *rq;
+
+	rq = prepare_req(hwh, h->buff, h->bufflen, READ);
+	if (!rq) {
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		return;
+	}
+
+	/* Prepare the command. */
+	rq->cmd[0] = MAINTENANCE_IN;
+	rq->cmd[1] = MI_REPORT_TARGET_PGS;
+	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
+	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
+	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
+	rq->cmd[9] = h->bufflen & 0xff;
+	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
+
+	blk_execute_rq_nowait(rq->q, NULL, rq, 1, rtpg_endio);
+}
+
+/*
+ * SET TARGET GROUP STATES endio handler
+ *
+ * We only have to test here if we should resubmit the command;
+ * any other error is assumed as a failure.
+ * Maybe we should analyze the sensebuffer here, too.
+ */
+static void stpg_endio(struct request *req, int error)
+{
+	struct hw_handler *hwh = req->end_io_data;
+	struct alua_handler *h = hwh->context;
+
+	switch(host_byte(error)) {
+	case DID_BUS_BUSY:
+		if (!h->retry)
+			break;
+		h->retry--;
+	case DID_REQUEUE:
+	case DID_IMM_RETRY:
+		dm_enqueue_hw_workq(hwh);
+		goto done;
+	}
+
+	if (had_failures(req, error)) {
+		if (h->tpgs & TPGS_MODE_IMPLICIT) {
+			/* Ignore errors; the array will figure it out */
+			DMWARN("%s: stpg failed %x, disabling explicit mode",
+			       h->path->dev->name, error);
+			h->tpgs &= ~TPGS_MODE_EXPLICIT;
+			dm_enqueue_hw_workq(hwh);
+		} else {
+			DMWARN("%s: stpg failed %x, disable path",
+			       h->path->dev->name, error);
+			dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		}
+	} else {
+		DMWARN("%s: port group %02x new state %c",
+		       h->path->dev->name, h->group_id,
+		       print_alua_state(h->state) );
+		dm_pg_init_complete(h->path, 0);
+	}
+
+ done:
+	__blk_put_request(req->q, req);
+}
+
+/*
+ * Issue a SET TARGET GROUP STATES command.
+ *
+ * Currently we're only setting the current target port group state
+ * to 'active/optimized' and let the array firmware figure out
+ * the states of the remaining groups.
+ */
+static void submit_stpg(struct hw_handler *hwh)
+{
+	struct alua_handler *h = hwh->context;
+	struct request *rq;
+	int stpg_len = 8;
+
+	/* Prepare the data buffer */
+	memset(h->buff, 0, stpg_len);
+	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
+	h->buff[6] = (h->group_id >> 8) & 0x0f;
+	h->buff[7] = h->group_id & 0x0f;
+
+	rq = prepare_req(hwh, h->buff, stpg_len, WRITE);
+	if (!rq) {
+		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		return;
+	}
+
+	/* Prepare the command. */
+	rq->cmd[0] = MAINTENANCE_OUT;
+	rq->cmd[1] = MO_SET_TARGET_PGS;
+	rq->cmd[6] = (stpg_len >> 24) & 0xff;
+	rq->cmd[7] = (stpg_len >> 16) & 0xff;
+	rq->cmd[8] = (stpg_len >>  8) & 0xff;
+	rq->cmd[9] = stpg_len & 0xff;
+	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
+
+	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
+}
+
+/*
+ * State machine for submitting ALUA commands
+ */
+static void alua_submit_cmd(struct hw_handler *hwh)
+{
+	struct alua_handler *h = hwh->context;
+
+	DMINFO("%s: tpgs %d group_id %d state %d",
+	       h->path->dev->name, h->tpgs, h->group_id, h->state);
+
+	if (h->tpgs == TPGS_MODE_UNINITIALIZED)
+		submit_std_inquiry(hwh);
+	else if (h->tpgs & (TPGS_MODE_IMPLICIT | TPGS_MODE_EXPLICIT) &&
+	    h->group_id == -1)
+		submit_vpd_inquiry(hwh);
+	else if (h->group_id != -1)
+		submit_rtpg(hwh);
+	else if (h->state != TPGS_STATE_OPTIMIZED)
+		submit_stpg(hwh);
+}
+
+/*
+ * We're currently switching the port group to be activated only and
+ * let the array figure out the rest.
+ * There may be others arrays which require us to switch all port groups
+ * based on a certain policy. But until we actually encounter them it
+ * should be okay.
+ */
+static int alua_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	struct alua_handler *h;
+
+	/* No arguments */
+	if (argc != 0) {
+		DMWARN("incorrect number of arguments");
+		return -EINVAL;
+	}
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+
+	hwh->context = h;
+	h->tpgs = TPGS_MODE_UNINITIALIZED;
+	h->group_id = -1;
+	h->rel_port = -1;
+	h->buff = h->inq;
+	h->bufflen = ALUA_INQUIRY_SIZE;
+
+	return 0;
+}
+
+static void alua_destroy(struct hw_handler *hwh)
+{
+	struct alua_handler *h = hwh->context;
+
+	if (h->buff && h->inq != h->buff)
+		kfree(h->buff);
+	kfree(h);
+	hwh->context = NULL;
+}
+
+static unsigned alua_error(struct hw_handler *hwh, struct bio *bio)
+{
+	/* Try default handler */
+	return dm_scsi_err_handler(hwh, bio);
+}
+
+static void alua_pg_init(struct hw_handler *hwh, unsigned bypassed,
+			struct dm_path *path)
+{
+	struct alua_handler *h = hwh->context;
+
+	h->path = path;
+	h->retry = 5;
+	h->state = TPGS_STATE_OPTIMIZED;
+	dm_enqueue_hw_workq(hwh);
+}
+
+static struct hw_handler_type alua_handler = {
+	.name = DM_ALUA_HWH_NAME,
+	.module = THIS_MODULE,
+	.create = alua_create,
+	.destroy = alua_destroy,
+	.pg_init = alua_pg_init,
+	.error = alua_error,
+	.workq_fn = alua_submit_cmd,
+};
+
+static int __init alua_init(void)
+{
+	int r = dm_register_hw_handler(&alua_handler);
+
+	if (r < 0) {
+		DMERR("%s: register failed %d", DM_ALUA_HWH_NAME, r);
+		return r;
+	}
+
+	DMINFO("%s: version %s loaded", DM_ALUA_HWH_NAME, DM_ALUA_HWH_VER);
+	return 0;
+}
+
+static void __exit alua_exit(void)
+{
+	int r = dm_unregister_hw_handler(&alua_handler);
+
+	if (r < 0)
+		DMERR("%s: unregister failed %d", DM_ALUA_HWH_NAME, r);
+}
+
+module_init(alua_init);
+module_exit(alua_exit);
+
+MODULE_DESCRIPTION("DM Multipath ALUA support");
+MODULE_AUTHOR("Hannes Reinecke");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DM_ALUA_HWH_VER);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 702fcfe..cdd15c8 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -91,6 +91,7 @@ extern const unsigned char scsi_command_size[8];
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define REPORT_LUNS           0xa0
 #define MAINTENANCE_IN        0xa3
+#define MAINTENANCE_OUT       0xa4
 #define MOVE_MEDIUM           0xa5
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
@@ -110,6 +111,8 @@ extern const unsigned char scsi_command_size[8];
 #define	SAI_READ_CAPACITY_16  0x10
 /* values for maintenance in */
 #define MI_REPORT_TARGET_PGS  0x0a
+/* values for maintenance out */
+#define MO_SET_TARGET_PGS     0x0a
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
-- 
1.5.3.2

