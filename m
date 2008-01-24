From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 8/9] scsi_dh: add lsi rdac device handler
Date: Wed, 23 Jan 2008 16:32:19 -0800
Message-ID: <20080124003219.18871.24083.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:52405 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYAXAcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:32:22 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0O0WL1D024822
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:32:21 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0WLv7095978
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:32:21 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0WKxO001875
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:32:21 -0700
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Subject: scsi_dh: add lsi rdac device handler

From: Chandra Seetharaman <sekharan@us.ibm.com>

add LSI RDAC SCSI device handler

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/device_handler/Kconfig            |    5 	5 +	0 -	0 !
 drivers/scsi/device_handler/Makefile           |    1 	1 +	0 -	0 !
 drivers/scsi/device_handler/scsi_dh_lsi_rdac.c |  766 	766 +	0 -	0 !
 3 files changed, 772 insertions(+)

Index: linux-2.6.24-rc8/drivers/scsi/device_handler/Kconfig
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/device_handler/Kconfig
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/Kconfig
@@ -25,4 +25,9 @@ config SCSI_DH_HP_SW
 	be sent to start it and cannot upgrade the firmware then select y.
 	Otherwise, say N.
 
+config SCSI_DH_LSI_RDAC
+	tristate "LSI RDAC Device Handler"
+	help
+	If you have a LSI RDAC select y. Otherwise, say N.
+
 endif #SCSI_DH
Index: linux-2.6.24-rc8/drivers/scsi/device_handler/Makefile
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/device_handler/Makefile
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_SCSI_DH_EMC)	+= scsi_dh_emc.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+= scsi_dh_hp_sw.o
+obj-$(CONFIG_SCSI_DH_LSI_RDAC)	+= scsi_dh_lsi_rdac.o
Index: linux-2.6.24-rc8/drivers/scsi/device_handler/scsi_dh_lsi_rdac.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/scsi_dh_lsi_rdac.c
@@ -0,0 +1,766 @@
+/*
+ * Engenio/LSI RDAC SCSI Device Handler
+ *
+ * Copyright (C) 2005 Mike Christie. All rights reserved.
+ * Copyright (C) Chandra Seetharaman, IBM Corp. 2007
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
+#include <linux/blkdev.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+
+#define RDAC_NAME "lsi_rdac"
+
+/*
+ * LSI mode page stuff
+ *
+ * These struct definitions and the forming of the
+ * mode page were taken from the LSI RDAC 2.4 GPL'd
+ * driver, and then converted to Linux conventions.
+ */
+#define RDAC_QUIESCENCE_TIME 20;
+/*
+ * Page Codes
+ */
+#define RDAC_PAGE_CODE_REDUNDANT_CONTROLLER 0x2c
+
+/*
+ * Controller modes definitions
+ */
+#define RDAC_MODE_TRANSFER_ALL_LUNS		0x01
+#define RDAC_MODE_TRANSFER_SPECIFIED_LUNS	0x02
+
+/*
+ * RDAC Options field
+ */
+#define RDAC_FORCED_QUIESENCE 0x02
+
+#define RDAC_TIMEOUT	(60 * HZ)
+#define RDAC_RETRIES	3
+
+struct rdac_mode_6_hdr {
+	u8	data_len;
+	u8	medium_type;
+	u8	device_params;
+	u8	block_desc_len;
+};
+
+struct rdac_mode_10_hdr {
+	u16	data_len;
+	u8	medium_type;
+	u8	device_params;
+	u16	reserved;
+	u16	block_desc_len;
+};
+
+struct rdac_mode_common {
+	u8	controller_serial[16];
+	u8	alt_controller_serial[16];
+	u8	rdac_mode[2];
+	u8	alt_rdac_mode[2];
+	u8	quiescence_timeout;
+	u8	rdac_options;
+};
+
+struct rdac_pg_legacy {
+	struct rdac_mode_6_hdr hdr;
+	u8	page_code;
+	u8	page_len;
+	struct rdac_mode_common common;
+#define MODE6_MAX_LUN	32
+	u8	lun_table[MODE6_MAX_LUN];
+	u8	reserved2[32];
+	u8	reserved3;
+	u8	reserved4;
+};
+
+struct rdac_pg_expanded {
+	struct rdac_mode_10_hdr hdr;
+	u8	page_code;
+	u8	subpage_code;
+	u8	page_len[2];
+	struct rdac_mode_common common;
+	u8	lun_table[256];
+	u8	reserved3;
+	u8	reserved4;
+};
+
+struct c9_inquiry {
+	u8	peripheral_info;
+	u8	page_code;	/* 0xC9 */
+	u8	reserved1;
+	u8	page_len;
+	u8	page_id[4];	/* "vace" */
+	u8	avte_cvp;
+	u8	path_prio;
+	u8	reserved2[38];
+};
+
+#define SUBSYS_ID_LEN	16
+#define SLOT_ID_LEN	2
+
+struct c4_inquiry {
+	u8	peripheral_info;
+	u8	page_code;	/* 0xC4 */
+	u8	reserved1;
+	u8	page_len;
+	u8	page_id[4];	/* "subs" */
+	u8	subsys_id[SUBSYS_ID_LEN];
+	u8	revision[4];
+	u8	slot_id[SLOT_ID_LEN];
+	u8	reserved[2];
+};
+
+struct rdac_controller {
+	u8			subsys_id[SUBSYS_ID_LEN];
+	u8			slot_id[SLOT_ID_LEN];
+	int			use_10_ms;
+	struct kref		kref;
+	struct list_head	node; /* list of all controllers */
+	spinlock_t		lock;
+	int			submitted;
+	struct list_head	cmd_list; /* list of commands to be submitted */
+	union			{
+		struct rdac_pg_legacy legacy;
+		struct rdac_pg_expanded expanded;
+	} mode_select;
+};
+struct c8_inquiry {
+	u8	peripheral_info;
+	u8	page_code; /* 0xC8 */
+	u8	reserved1;
+	u8	page_len;
+	u8	page_id[4]; /* "edid" */
+	u8	reserved2[3];
+	u8	vol_uniq_id_len;
+	u8	vol_uniq_id[16];
+	u8	vol_user_label_len;
+	u8	vol_user_label[60];
+	u8	array_uniq_id_len;
+	u8	array_unique_id[16];
+	u8	array_user_label_len;
+	u8	array_user_label[60];
+	u8	lun[8];
+};
+
+struct c2_inquiry {
+	u8	peripheral_info;
+	u8	page_code;	/* 0xC2 */
+	u8	reserved1;
+	u8	page_len;
+	u8	page_id[4];	/* "swr4" */
+	u8	sw_version[3];
+	u8	sw_date[3];
+	u8	features_enabled;
+	u8	max_lun_supported;
+	u8	partitions[239]; /* Total allocation length should be 0xFF */
+};
+
+struct rdac_dh_data {
+	struct list_head	entry; /* list waiting to submit MODE SELECT */
+	struct rdac_controller	*ctlr;
+#define UNINITIALIZED_LUN	(1 << 8)
+	unsigned		lun;
+	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
+	struct request		*act_req;
+	struct work_struct	work;
+#define	SEND_C2_INQUIRY		1
+#define	SEND_C4_INQUIRY		2
+#define	SEND_C8_INQUIRY		3
+#define	SEND_C9_INQUIRY		4
+#define	SEND_MODE_SELECT	5
+	int			cmd_to_send;
+	union			{
+		struct c2_inquiry c2;
+		struct c4_inquiry c4;
+		struct c8_inquiry c8;
+		struct c9_inquiry c9;
+	} inq;
+};
+
+static LIST_HEAD(ctlr_list);
+static DEFINE_SPINLOCK(list_lock);
+static struct workqueue_struct *rdac_wkqd;
+
+static inline int had_failures(int result)
+{
+	return (host_byte(result) != DID_OK ||
+			msg_byte(result) != COMMAND_COMPLETE);
+}
+
+static void rdac_resubmit_all(struct rdac_dh_data *h)
+{
+	struct rdac_controller *ctlr = h->ctlr;
+	struct rdac_dh_data *tmp, *h1;
+
+	spin_lock(&ctlr->lock);
+	list_for_each_entry_safe(h1, tmp, &ctlr->cmd_list, entry) {
+		h1->cmd_to_send = SEND_C9_INQUIRY;
+		queue_work(rdac_wkqd, &h1->work);
+		list_del(&h1->entry);
+	}
+	ctlr->submitted = 0;
+	spin_unlock(&ctlr->lock);
+}
+
+static void mode_select_endio(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct scsi_device *sdev = req->q->queuedata;
+	struct scsi_sense_hdr sense_hdr;
+	int sense, err = BLKERR_OK, result = req->errors;
+
+	if (had_failures(result)) {
+		err = BLKERR_DEV_FAILED;
+		goto failed;
+	}
+
+	if (status_byte(result) == CHECK_CONDITION) {
+		scsi_normalize_sense(req->sense, SCSI_SENSE_BUFFERSIZE,
+				&sense_hdr);
+		sense = (sense_hdr.sense_key << 16) | (sense_hdr.asc << 8) |
+				sense_hdr.ascq;
+		/* If it is retryable failure, submit the c9 inquiry again */
+		if (sense == 0x59136 || sense == 0x68b02 || sense == 0xb8b02 ||
+				    sense == 0x62900) {
+			/* 0x59136    - Command lock contention
+			 * 0x[6b]8b02 - Quiesense in progress or achieved
+			 * 0x62900    - Power On, Reset, or Bus Device Reset
+			 */
+			err = BLKERR_DEV_TEMP_BUSY;
+		}
+		if (sense)
+			sdev_printk(KERN_INFO, sdev,
+				"MODE_SELECT failed with sense 0x%x", sense);
+	} else if (result) {
+		sdev_printk(KERN_ERR, sdev, "Error 0x%x while sending "
+			"MODE_SELECT.\n", result);
+		err = BLKERR_IO;
+	}
+
+	scsi_device_set_state(sdev, SDEV_RUNNING);
+failed:
+	scsi_blk_linux_cmd_done(act_req, err);
+	rdac_resubmit_all(sdev->sdev_dh_data);
+	__blk_put_request(req->q, req);
+}
+
+static struct request *get_rdac_req(struct request *act_req,
+			void *buffer, unsigned buflen, int rw)
+{
+	struct request *rq;
+	struct request_queue *q = act_req->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+
+	rq = blk_get_request(q, rw, GFP_KERNEL);
+
+	if (!rq) {
+		sdev_printk(KERN_INFO, sdev,
+				"get_rdac_req: blk_get_request failed");
+		return NULL;
+	}
+
+	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
+		blk_put_request(rq);
+		sdev_printk(KERN_INFO, sdev,
+				"get_rdac_req: blk_rq_map_kern failed");
+		return NULL;
+	}
+
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
+	rq->retries = RDAC_RETRIES;
+	rq->timeout = RDAC_TIMEOUT;
+	rq->end_io_data = act_req;
+
+	return rq;
+}
+
+static struct request *rdac_failover_get(struct request *act_req)
+{
+	struct request *rq;
+	struct rdac_mode_common *common;
+	unsigned data_size;
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+
+	if (h->ctlr->use_10_ms) {
+		struct rdac_pg_expanded *rdac_pg;
+
+		data_size = sizeof(struct rdac_pg_expanded);
+		rdac_pg = &h->ctlr->mode_select.expanded;
+		memset(rdac_pg, 0, data_size);
+		common = &rdac_pg->common;
+		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER + 0x40;
+		rdac_pg->subpage_code = 0x1;
+		rdac_pg->page_len[0] = 0x01;
+		rdac_pg->page_len[1] = 0x28;
+		rdac_pg->lun_table[h->lun] = 0x81;
+	} else {
+		struct rdac_pg_legacy *rdac_pg;
+
+		data_size = sizeof(struct rdac_pg_legacy);
+		rdac_pg = &h->ctlr->mode_select.legacy;
+		memset(rdac_pg, 0, data_size);
+		common = &rdac_pg->common;
+		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
+		rdac_pg->page_len = 0x68;
+		rdac_pg->lun_table[h->lun] = 0x81;
+	}
+	common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
+	common->quiescence_timeout = RDAC_QUIESCENCE_TIME;
+	common->rdac_options = RDAC_FORCED_QUIESENCE;
+
+	/* get request for block layer packet command */
+	rq = get_rdac_req(act_req, &h->ctlr->mode_select, data_size, WRITE);
+	if (!rq)
+		return NULL;
+
+	/* Prepare the command. */
+	if (h->ctlr->use_10_ms) {
+		rq->cmd[0] = MODE_SELECT_10;
+		rq->cmd[7] = data_size >> 8;
+		rq->cmd[8] = data_size & 0xff;
+	} else {
+		rq->cmd[0] = MODE_SELECT;
+		rq->cmd[4] = data_size;
+	}
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+
+	return rq;
+}
+
+/* Acquires h->ctlr->lock */
+static void submit_mode_select(struct request *act_req)
+{
+	struct request *rq;
+	struct request_queue *q = act_req->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+
+	spin_lock(&h->ctlr->lock);
+	if (h->ctlr->submitted) {
+		list_add(&h->entry, &h->ctlr->cmd_list);
+		goto drop_lock;
+	}
+
+	rq = rdac_failover_get(act_req);
+	if (!rq)
+		goto fail_path;
+
+	sdev_printk(KERN_INFO, sdev, "queueing MODE_SELECT command");
+
+	blk_execute_rq_nowait(q, NULL, rq, 1, mode_select_endio);
+	h->ctlr->submitted = 1;
+	goto drop_lock;
+fail_path:
+	scsi_blk_linux_cmd_done(act_req, BLKERR_RES_TEMP_UNAVAIL);
+drop_lock:
+	spin_unlock(&h->ctlr->lock);
+}
+
+static void release_ctlr(struct kref *kref)
+{
+	struct rdac_controller *ctlr;
+	ctlr = container_of(kref, struct rdac_controller, kref);
+
+	spin_lock(&list_lock);
+	list_del(&ctlr->node);
+	spin_unlock(&list_lock);
+	kfree(ctlr);
+}
+
+static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
+{
+	struct rdac_controller *ctlr, *tmp;
+
+	spin_lock(&list_lock);
+
+	list_for_each_entry(tmp, &ctlr_list, node) {
+		if ((memcmp(tmp->subsys_id, subsys_id, SUBSYS_ID_LEN) == 0) &&
+			  (memcmp(tmp->slot_id, slot_id, SLOT_ID_LEN) == 0)) {
+			kref_get(&tmp->kref);
+			spin_unlock(&list_lock);
+			return tmp;
+		}
+	}
+	ctlr = kmalloc(sizeof(*ctlr), GFP_ATOMIC);
+	if (!ctlr)
+		goto done;
+
+	/* initialize fields of controller */
+	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
+	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
+	kref_init(&ctlr->kref);
+	spin_lock_init(&ctlr->lock);
+	ctlr->submitted = 0;
+	ctlr->use_10_ms = -1;
+	INIT_LIST_HEAD(&ctlr->cmd_list);
+	list_add(&ctlr->node, &ctlr_list);
+done:
+	spin_unlock(&list_lock);
+	return ctlr;
+}
+
+static void c4_endio(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+	struct c4_inquiry *sp;
+	int result = req->errors;
+
+	__blk_put_request(req->q, req);
+	if (had_failures(result)) {
+		scsi_blk_linux_cmd_done(act_req, BLKERR_IO);
+		return;
+	}
+
+	sp = &h->inq.c4;
+
+	h->ctlr = get_controller(sp->subsys_id, sp->slot_id);
+
+	if (h->ctlr) {
+		h->cmd_to_send = SEND_C9_INQUIRY;
+		queue_work(rdac_wkqd, &h->work);
+	} else
+		scsi_blk_linux_cmd_done(act_req, BLKERR_RES_TEMP_UNAVAIL);
+}
+
+static void c2_endio(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+	struct c2_inquiry *sp;
+	int result = req->errors;
+
+	__blk_put_request(req->q, req);
+	if (had_failures(result)) {
+		scsi_blk_linux_cmd_done(act_req, BLKERR_IO);
+		return;
+	}
+
+	sp = &h->inq.c2;
+
+	/* If more than MODE6_MAX_LUN luns are supported, use mode select 10 */
+	if (sp->max_lun_supported >= MODE6_MAX_LUN)
+		h->ctlr->use_10_ms = 1;
+	else
+		h->ctlr->use_10_ms = 0;
+
+	h->cmd_to_send = SEND_MODE_SELECT;
+	queue_work(rdac_wkqd, &h->work);
+}
+
+static void c9_endio(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+	struct c9_inquiry *sp;
+	int result = req->errors;
+
+	__blk_put_request(req->q, req);
+	if (had_failures(result)) {
+		scsi_blk_linux_cmd_done(act_req, BLKERR_IO);
+		return;
+	}
+
+	/* We need to look at the sense keys here to take clear action.
+	 * For now simple logic: If the host is in AVT mode or if controller
+	 * owns the lun, return dm_pg_init_complete(), otherwise submit
+	 * MODE SELECT.
+	 */
+	sp = &h->inq.c9;
+
+	/* If in AVT mode, return success */
+	if ((sp->avte_cvp >> 7) == 0x1) {
+		scsi_blk_linux_cmd_done(act_req, BLKERR_OK);
+		return;
+	}
+
+	/* If the controller on this path owns the LUN, return success */
+	if (sp->avte_cvp & 0x1) {
+		scsi_blk_linux_cmd_done(act_req, BLKERR_OK);
+		return;
+	}
+
+	if (h->ctlr) {
+		if (h->ctlr->use_10_ms == -1)
+			h->cmd_to_send = SEND_C2_INQUIRY;
+		else
+			h->cmd_to_send = SEND_MODE_SELECT;
+	} else
+		h->cmd_to_send = SEND_C4_INQUIRY;
+	queue_work(rdac_wkqd, &h->work);
+}
+
+static void c8_endio(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+	struct c8_inquiry *sp;
+	int result = req->errors;
+
+	__blk_put_request(req->q, req);
+	if (had_failures(result)) {
+		scsi_blk_linux_cmd_done(act_req, BLKERR_IO);
+		return;
+	}
+
+	/* We need to look at the sense keys here to take clear action.
+	 * For now simple logic: Get the lun from the inquiry page.
+	 */
+	sp = &h->inq.c8;
+	h->lun = sp->lun[7]; /* currently it uses only one byte */
+	h->cmd_to_send = SEND_C9_INQUIRY;
+	queue_work(rdac_wkqd, &h->work);
+}
+
+static void submit_inquiry(struct request *act_req, int page_code,
+		unsigned int len, rq_end_io_fn endio)
+{
+	struct request *rq;
+	struct request_queue *q = act_req->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+
+	rq = get_rdac_req(act_req, &h->inq, len, READ);
+	if (!rq)
+		goto fail_path;
+
+	/* Prepare the command. */
+	rq->cmd[0] = INQUIRY;
+	rq->cmd[1] = 1;
+	rq->cmd[2] = page_code;
+	rq->cmd[4] = len;
+	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+	blk_execute_rq_nowait(q, NULL, rq, 1, endio);
+	return;
+
+fail_path:
+	scsi_blk_linux_cmd_done(act_req, BLKERR_IO);
+}
+
+static void service_wkq(struct work_struct *work)
+{
+	struct rdac_dh_data *h = container_of(work, struct rdac_dh_data, work);
+
+	switch (h->cmd_to_send) {
+	case SEND_C2_INQUIRY:
+		submit_inquiry(h->act_req, 0xC2,
+					sizeof(struct c2_inquiry), c2_endio);
+		break;
+	case SEND_C4_INQUIRY:
+		submit_inquiry(h->act_req, 0xC4,
+					sizeof(struct c4_inquiry), c4_endio);
+		break;
+	case SEND_C8_INQUIRY:
+		submit_inquiry(h->act_req, 0xC8,
+					sizeof(struct c8_inquiry), c8_endio);
+		break;
+	case SEND_C9_INQUIRY:
+		submit_inquiry(h->act_req, 0xC9,
+					sizeof(struct c9_inquiry), c9_endio);
+		break;
+	case SEND_MODE_SELECT:
+		submit_mode_select(h->act_req);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static int rdac_check_sense(struct scsi_device *sdev,
+				struct scsi_sense_hdr *sense_hdr)
+{
+	switch (sense_hdr->sense_key) {
+	case NOT_READY:
+#if 0
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x81)
+			/* LUN Not Ready - Storage firmware incompatible
+			 * Manual code synchonisation required.
+			 *
+			 * Nothing we can do here. Try to bypass the path.
+			 */
+			return SUCCESS;
+#endif
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0xA1)
+			/* LUN Not Ready - Quiescense in progress
+			 *
+			 * Just retry and wait.
+			 */
+			return NEEDS_RETRY;
+		break;
+	case ILLEGAL_REQUEST:
+		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01)
+			/* Invalid Request - Current Logical Unit Ownership.
+			 * Controller is not the current owner of the LUN,
+			 * Fail the path, so that the other path be used.
+			 */
+			scsi_device_set_state(sdev, SDEV_PASSIVE);
+		break;
+	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+			/*
+			 * Power On, Reset, or Bus Device Reset, just retry.
+			 */
+			return NEEDS_RETRY;
+		break;
+	}
+	/* success just means we do not care what scsi-ml does */
+	return SUCCESS;
+}
+
+static void rdac_transition(struct request *act_req)
+{
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct rdac_dh_data *h = sdev->sdev_dh_data;
+
+	h->act_req = act_req;
+	switch (h->lun) {
+	case UNINITIALIZED_LUN:
+		submit_inquiry(h->act_req, 0xC8, sizeof(struct c8_inquiry),
+								 c8_endio);
+		break;
+	default:
+		submit_inquiry(h->act_req, 0xC9, sizeof(struct c9_inquiry),
+								c9_endio);
+	}
+}
+
+static const struct {
+	char *vendor;
+	char *model;
+} rdac_dev_list[] = {
+	{"IBM", "1815"},
+	{NULL, NULL},
+};
+
+static int rdac_bus_notify(struct notifier_block *, unsigned long, void *);
+
+static struct scsi_device_handler rdac_dh = {
+	.name = RDAC_NAME,
+	.module = THIS_MODULE,
+	.nb.notifier_call = rdac_bus_notify,
+	.check_sense = rdac_check_sense,
+	.transition = rdac_transition,
+};
+
+/*
+ * TODO: need some interface so we can set trespass values
+ */
+static int rdac_bus_notify(struct notifier_block *nb,
+			    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct rdac_dh_data *dh_data;
+	int i, found = 0;
+	unsigned long flags;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		for (i = 0; rdac_dev_list[i].vendor; i++) {
+			if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
+				     strlen(rdac_dev_list[i].vendor)) &&
+			    !strncmp(sdev->model, rdac_dev_list[i].model,
+				     strlen(rdac_dev_list[i].model))) {
+				found = 1;
+				break;
+			}
+		}
+		if (!found)
+			goto out;
+
+		dh_data = kzalloc(sizeof(*dh_data), GFP_KERNEL);
+		if (!dh_data) {
+			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+				    RDAC_NAME);
+			goto out;
+		}
+
+		dh_data->lun = UNINITIALIZED_LUN;
+		INIT_WORK(&dh_data->work, service_wkq);
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		sdev->sdev_dh_data = dh_data;
+		sdev->sdev_dh = &rdac_dh;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", RDAC_NAME);
+
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		if (sdev->sdev_dh != &rdac_dh)
+			goto out;
+
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		dh_data = sdev->sdev_dh_data;
+		sdev->sdev_dh_data = NULL;
+		sdev->sdev_dh = NULL;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+		if (dh_data->ctlr)
+			kref_put(&dh_data->ctlr->kref, release_ctlr);
+		kfree(dh_data);
+		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
+			    RDAC_NAME);
+	}
+
+out:
+	return 0;
+}
+
+static int __init rdac_init(void)
+{
+	int r;
+
+	rdac_wkqd = create_singlethread_workqueue("rdac_wkqd");
+	if (!rdac_wkqd) {
+		printk(KERN_ERR "Failed to create workqueue rdac_wkqd.");
+		return -ENOMEM;
+	}
+
+	r = scsi_register_device_handler(&rdac_dh);
+	if (r != 0) {
+		destroy_workqueue(rdac_wkqd);
+		printk(KERN_ERR "Failed to register scsi device handler.");
+	}
+	return r;
+}
+
+static void __exit rdac_exit(void)
+{
+	scsi_unregister_device_handler(&rdac_dh);
+	destroy_workqueue(rdac_wkqd);
+}
+
+module_init(rdac_init);
+module_exit(rdac_exit);
+
+MODULE_DESCRIPTION("Multipath LSI/Engenio RDAC driver");
+MODULE_AUTHOR("Mike Christie, Chandra Seetharaman");
+MODULE_LICENSE("GPL");

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
