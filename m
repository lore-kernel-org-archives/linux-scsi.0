From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 9/9] scsi_dh: add scsi device handler to dm
Date: Wed, 23 Jan 2008 16:32:35 -0800
Message-ID: <20080124003235.18871.72293.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45912 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYAXAci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:32:38 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0O0WbYG017366
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:32:37 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0Wbo8081392
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:32:37 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0WaTS002670
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:32:37 -0700
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Subject: scsi_dh: add scsi device handler to dm

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds a dm hardware handler that can control SCSI device
handlers.

SCSI Hardware handler for a specific device type can be invokes by using
this handler.

For example, to use the lsi_rdac SCSI hardware handler, one would specify
        hardware_handler        "2 scsi_dh lsi_rdac"
in the device section of /etc/multipath.conf.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/md/Kconfig            |    6 	6 +	0 -	0 !
 drivers/md/Makefile           |    2 	2 +	0 -	0 !
 drivers/md/dm-mpath-scsi-dh.c |  185 	185 +	0 -	0 !
 3 files changed, 193 insertions(+)

Index: linux-2.6.24-rc8/drivers/md/Kconfig
===================================================================
--- linux-2.6.24-rc8.orig/drivers/md/Kconfig
+++ linux-2.6.24-rc8/drivers/md/Kconfig
@@ -273,6 +273,12 @@ config DM_MULTIPATH_HP
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 
+config DM_MULTIPATH_SCSI_DH
+        tristate "SCSI Device Handler support (EXPERIMENTAL)"
+        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        ---help---
+          Multipath support for SCSI Device Handlers.
+
 config DM_DELAY
 	tristate "I/O delaying target (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
Index: linux-2.6.24-rc8/drivers/md/Makefile
===================================================================
--- linux-2.6.24-rc8.orig/drivers/md/Makefile
+++ linux-2.6.24-rc8/drivers/md/Makefile
@@ -9,6 +9,7 @@ dm-snapshot-objs := dm-snap.o dm-excepti
 dm-mirror-objs	:= dm-log.o dm-raid1.o
 dm-rdac-objs	:= dm-mpath-rdac.o
 dm-hp-sw-objs	:= dm-mpath-hp-sw.o
+dm-scsi-dh-objs := dm-mpath-scsi-dh.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
 		   raid6int1.o raid6int2.o raid6int4.o \
@@ -38,6 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipa
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o
 obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rdac.o
+obj-$(CONFIG_DM_MULTIPATH_SCSI_DH) += dm-scsi-dh.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
Index: linux-2.6.24-rc8/drivers/md/dm-mpath-scsi-dh.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/drivers/md/dm-mpath-scsi-dh.c
@@ -0,0 +1,185 @@
+/*
+ * SCSI Device handler
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
+ */
+
+#define DM_MSG_PREFIX "multipath scsi_dh"
+
+#include "dm.h"
+#include "dm-hw-handler.h"
+
+struct scsi_dh_context {
+	char		*hw_handler_name;
+	struct dm_path	*path;
+};
+
+static int scsi_dh_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	struct scsi_dh_context *c;
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+	if (argc == 1) {
+		c->hw_handler_name = kstrdup(argv[0], GFP_KERNEL);
+		if (c->hw_handler_name)
+			request_module("scsi_dh_%s", c->hw_handler_name);
+	}
+
+	hwh->context = c;
+
+	return 0;
+}
+
+static void scsi_dh_destroy(struct hw_handler *hwh)
+{
+	struct scsi_dh_context *c = hwh->context;
+	kfree(c->hw_handler_name);
+	kfree(c);
+	hwh->context = NULL;
+	return;
+}
+
+static unsigned scsi_dh_error(struct hw_handler *hwh, struct bio *bio)
+{
+	/* Try default handler */
+	return dm_scsi_err_handler(hwh, bio);
+}
+
+
+static void pg_init_done(struct request *req, int err)
+{
+	struct scsi_dh_context *c = req->end_io_data;
+	int ret = 0;
+
+	if (blkerr_transport_err(req->errors)) {
+		/*
+		 * Old dm behavior had us fail a path on any error.
+		 * In future patches, since we have finer grained errors now,
+		 * we do not have to fail the path on the first transient
+		 * error.
+		 */
+		ret = MP_FAIL_PATH;
+		goto out;
+	}
+
+	/* device or driver problems */
+	switch (req->errors) {
+	case BLKERR_OK:
+		break;
+	case BLKERR_NOSYS:
+		if (!c->hw_handler_name)
+			break;
+		DMERR("Cannot failover device because hw-%s may not be "
+		      "loaded.", c->hw_handler_name);
+		/*
+		 * Fail path for now, so we do not ping poing
+		 */
+		ret = MP_FAIL_PATH;
+		break;
+	case BLKERR_DEV_TEMP_BUSY:
+		/*
+		 * Probably doing something like FW upgrade on the
+		 * controller so try the other pg.
+		 */
+		ret = MP_BYPASS_PG;
+		break;
+	/* TODO: For BLKERR_RETRY we should wait a couple seconds */
+	case BLKERR_RETRY:
+	case BLKERR_IMM_RETRY:
+	case BLKERR_RES_TEMP_UNAVAIL:
+		break;
+	default:
+		/*
+		 * We probably do not want to fail the path for a device
+		 * error, but this is what the old dm did. In future
+		 * patches we can do more advanced handling.
+		 */
+		ret = MP_FAIL_PATH;
+	}
+
+out:
+	dm_pg_init_complete(c->path, ret);
+	__blk_put_request(req->q, req);
+	return;
+}
+
+static void scsi_dh_pg_init(struct hw_handler *hwh, unsigned bypassed,
+			struct dm_path *path)
+{
+	struct scsi_dh_context *c = hwh->context;
+	struct request *req;
+
+	req = blk_get_request(bdev_get_queue(path->dev->bdev), 1, GFP_NOIO);
+	if (!req) {
+		/* FIXME: Add retry */
+		dm_pg_init_complete(path, MP_FAIL_PATH);
+		return;
+	}
+
+	req->cmd[0] = REQ_LB_OP_TRANSITION;
+	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	c->path = path;
+	req->end_io_data = c;
+	/* TODO: does this need to be configurable or is it HW specific? */
+	req->retries = 5;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, pg_init_done);
+}
+
+#define SCSI_DH_NAME "scsi_dh"
+#define SCSI_DH_VER "0.1"
+
+static struct hw_handler_type scsi_dh_handler = {
+	.name = SCSI_DH_NAME,
+	.module = THIS_MODULE,
+	.create = scsi_dh_create,
+	.destroy = scsi_dh_destroy,
+	.pg_init = scsi_dh_pg_init,
+	.error = scsi_dh_error,
+};
+
+static int __init scsi_dh_init(void)
+{
+	int r;
+
+	r = dm_register_hw_handler(&scsi_dh_handler);
+	if (r < 0) {
+		DMERR("%s: register failed %d", SCSI_DH_NAME, r);
+		return r;
+	}
+
+	DMINFO("%s: version %s loaded", SCSI_DH_NAME, SCSI_DH_VER);
+	return 0;
+}
+
+static void __exit scsi_dh_exit(void)
+{
+	int r = dm_unregister_hw_handler(&scsi_dh_handler);
+
+	if (r < 0)
+		DMERR("%s: unregister failed %d", SCSI_DH_NAME, r);
+}
+
+module_init(scsi_dh_init);
+module_exit(scsi_dh_exit);
+
+MODULE_DESCRIPTION("DM Multipath SCSI Device Handler support");
+MODULE_AUTHOR("Mike Anderson <andmike@linux.vnet.ibm.com");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(SCSI_DH_VER);

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
