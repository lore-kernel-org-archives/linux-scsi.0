Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33788C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DCF060E93
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhGXGsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhGXGsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:48:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D172DC061575;
        Sat, 24 Jul 2021 00:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B3E0FjmV8CqktOKShZhVdiOfAzQuNk9THGeVWIzAWvM=; b=tnyaJ2L6MaMiaphUQgq0W5v9og
        Ay0V+7lN/o+TVz25HQg4PjwPbxwHUoXyz0XV0v+FODNIDlSITH/X2F5BCxy9tIJOOPDQNk9y6s9M0
        wvs001gZkVKTgQVnjD8eSzh4I0HDd5w4BA25RKvuQynuzb0myCpA90bolEsVn92N8OR40l10oUgZH
        qDJgqH6ygEg5nWrH3UOLVfej9TLaxZ9g5Shr1bd783HGgiPfYaBCH4i5RTUhzkC9ZwweG7ibZbQOj
        DjnJrw63tx4ntyCGnqMQEmbXBz8ZqcTiM1TqhJ2JDgVKhQAG07g0g/tRI2wWQgjuESFey+dnkt0G2
        W1bsO/dg==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C2e-00C5HW-Sy; Sat, 24 Jul 2021 07:26:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 14/24] bsg: move bsg_scsi_ops to drivers/scsi/
Date:   Sat, 24 Jul 2021 09:20:23 +0200
Message-Id: <20210724072033.1284840-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the SCSI-specific bsg code in the SCSI midlayer instead of in the
common bsg code.  This just keeps the common bsg code block/ and also
allows building it as a module.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Kconfig             | 23 ++--------
 block/Makefile            |  2 +-
 block/bsg.c               | 95 +--------------------------------------
 drivers/scsi/Kconfig      | 13 ++++++
 drivers/scsi/Makefile     |  1 +
 drivers/scsi/scsi_bsg.c   | 95 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  | 10 +++++
 drivers/scsi/scsi_sysfs.c |  2 +-
 include/linux/blkdev.h    |  2 +-
 include/linux/bsg.h       | 11 ++---
 10 files changed, 129 insertions(+), 125 deletions(-)
 create mode 100644 drivers/scsi/scsi_bsg.c

diff --git a/block/Kconfig b/block/Kconfig
index fd732aede922..88aa88241795 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -35,29 +35,12 @@ config BLK_SCSI_REQUEST
 config BLK_CGROUP_RWSTAT
 	bool
 
-config BLK_DEV_BSG
-	bool "Block layer SG support v4"
-	default y
-	select BLK_SCSI_REQUEST
-	help
-	  Saying Y here will enable generic SG (SCSI generic) v4 support
-	  for any block device.
-
-	  Unlike SG v3 (aka block/scsi_ioctl.c drivers/scsi/sg.c), SG v4
-	  can handle complicated SCSI commands: tagged variable length cdbs
-	  with bidirectional data transfers and generic request/response
-	  protocols (e.g. Task Management Functions and SMP in Serial
-	  Attached SCSI).
-
-	  This option is required by recent UDEV versions to properly
-	  access device serial numbers, etc.
-
-	  If unsure, say Y.
+config BLK_DEV_BSG_COMMON
+	tristate
 
 config BLK_DEV_BSGLIB
 	bool "Block layer SG support v4 helper lib"
-	select BLK_DEV_BSG
-	select BLK_SCSI_REQUEST
+	select BLK_DEV_BSG_COMMON
 	help
 	  Subsystems will normally enable this if needed. Users will not
 	  normally need to manually enable this.
diff --git a/block/Makefile b/block/Makefile
index bfbe4e13ca1e..f37d532c8da5 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
 
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
-obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
+obj-$(CONFIG_BLK_DEV_BSG_COMMON) += bsg.o
 obj-$(CONFIG_BLK_DEV_BSGLIB)	+= bsg-lib.o
 obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
 obj-$(CONFIG_BLK_CGROUP_RWSTAT)	+= blk-cgroup-rwstat.o
diff --git a/block/bsg.c b/block/bsg.c
index 38dd434636d8..6a8f518abe39 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -15,9 +15,6 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_driver.h>
 #include <scsi/sg.h>
 
 #define BSG_DESCRIPTION	"Block layer SCSI generic (bsg) driver"
@@ -54,86 +51,6 @@ static inline struct hlist_head *bsg_dev_idx_hash(int index)
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
-static int bsg_scsi_check_proto(struct sg_io_v4 *hdr)
-{
-	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
-	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
-		return -EINVAL;
-	return 0;
-}
-
-static int bsg_scsi_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
-		fmode_t mode)
-{
-	struct scsi_request *sreq = scsi_req(rq);
-
-	if (hdr->dout_xfer_len && hdr->din_xfer_len) {
-		pr_warn_once("BIDI support in bsg has been removed.\n");
-		return -EOPNOTSUPP;
-	}
-
-	sreq->cmd_len = hdr->request_len;
-	if (sreq->cmd_len > BLK_MAX_CDB) {
-		sreq->cmd = kzalloc(sreq->cmd_len, GFP_KERNEL);
-		if (!sreq->cmd)
-			return -ENOMEM;
-	}
-
-	if (copy_from_user(sreq->cmd, uptr64(hdr->request), sreq->cmd_len))
-		return -EFAULT;
-	if (blk_verify_command(sreq->cmd, mode))
-		return -EPERM;
-	return 0;
-}
-
-static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
-{
-	struct scsi_request *sreq = scsi_req(rq);
-	int ret = 0;
-
-	/*
-	 * fill in all the output members
-	 */
-	hdr->device_status = sreq->result & 0xff;
-	hdr->transport_status = host_byte(sreq->result);
-	hdr->driver_status = 0;
-	if (scsi_status_is_check_condition(sreq->result))
-		hdr->driver_status = DRIVER_SENSE;
-	hdr->info = 0;
-	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
-		hdr->info |= SG_INFO_CHECK;
-	hdr->response_len = 0;
-
-	if (sreq->sense_len && hdr->response) {
-		int len = min_t(unsigned int, hdr->max_response_len,
-					sreq->sense_len);
-
-		if (copy_to_user(uptr64(hdr->response), sreq->sense, len))
-			ret = -EFAULT;
-		else
-			hdr->response_len = len;
-	}
-
-	if (rq_data_dir(rq) == READ)
-		hdr->din_resid = sreq->resid_len;
-	else
-		hdr->dout_resid = sreq->resid_len;
-
-	return ret;
-}
-
-static void bsg_scsi_free_rq(struct request *rq)
-{
-	scsi_req_free_cmd(scsi_req(rq));
-}
-
-static const struct bsg_ops bsg_scsi_ops = {
-	.check_proto		= bsg_scsi_check_proto,
-	.fill_hdr		= bsg_scsi_fill_hdr,
-	.complete_rq		= bsg_scsi_complete_rq,
-	.free_rq		= bsg_scsi_free_rq,
-};
-
 static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 {
 	struct request *rq;
@@ -487,17 +404,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	mutex_unlock(&bsg_mutex);
 	return ret;
 }
-
-int bsg_scsi_register_queue(struct request_queue *q, struct device *parent)
-{
-	if (!blk_queue_scsi_passthrough(q)) {
-		WARN_ONCE(true, "Attempt to register a non-SCSI queue\n");
-		return -EINVAL;
-	}
-
-	return bsg_register_queue(q, parent, dev_name(parent), &bsg_scsi_ops);
-}
-EXPORT_SYMBOL_GPL(bsg_scsi_register_queue);
+EXPORT_SYMBOL_GPL(bsg_register_queue);
 
 static struct cdev bsg_cdev;
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8f44d433e06e..86ecab196dfd 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -20,6 +20,7 @@ config SCSI
 	select SCSI_DMA if HAS_DMA
 	select SG_POOL
 	select BLK_SCSI_REQUEST
+	select BLK_DEV_BSG_COMMON if BLK_DEV_BSG
 	help
 	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
 	  any other SCSI device under Linux, say Y and make sure that you know
@@ -140,6 +141,18 @@ config CHR_DEV_SG
 
 	  If unsure, say N.
 
+config BLK_DEV_BSG
+	bool "/dev/bsg support (SG v4)"
+	depends on SCSI
+	default y
+	help
+	  Saying Y here will enable generic SG (SCSI generic) v4 support
+	  for any SCSI device.
+
+	  This option is required by UDEV to access device serial numbers, etc.
+
+	  If unsure, say Y.
+
 config CHR_DEV_SCH
 	tristate "SCSI media changer support"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1748d1ec1338..240b831b5a11 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-$(CONFIG_BLK_DEBUG_FS)	+= scsi_debugfs.o
 scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
+scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
new file mode 100644
index 000000000000..3bdb28940460
--- /dev/null
+++ b/drivers/scsi/scsi_bsg.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bsg.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/sg.h>
+#include "scsi_priv.h"
+
+#define uptr64(val) ((void __user *)(uintptr_t)(val))
+
+static int scsi_bsg_check_proto(struct sg_io_v4 *hdr)
+{
+	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
+	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
+		return -EINVAL;
+	return 0;
+}
+
+static int scsi_bsg_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
+		fmode_t mode)
+{
+	struct scsi_request *sreq = scsi_req(rq);
+
+	if (hdr->dout_xfer_len && hdr->din_xfer_len) {
+		pr_warn_once("BIDI support in bsg has been removed.\n");
+		return -EOPNOTSUPP;
+	}
+
+	sreq->cmd_len = hdr->request_len;
+	if (sreq->cmd_len > BLK_MAX_CDB) {
+		sreq->cmd = kzalloc(sreq->cmd_len, GFP_KERNEL);
+		if (!sreq->cmd)
+			return -ENOMEM;
+	}
+
+	if (copy_from_user(sreq->cmd, uptr64(hdr->request), sreq->cmd_len))
+		return -EFAULT;
+	if (blk_verify_command(sreq->cmd, mode))
+		return -EPERM;
+	return 0;
+}
+
+static int scsi_bsg_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
+{
+	struct scsi_request *sreq = scsi_req(rq);
+	int ret = 0;
+
+	/*
+	 * fill in all the output members
+	 */
+	hdr->device_status = sreq->result & 0xff;
+	hdr->transport_status = host_byte(sreq->result);
+	hdr->driver_status = 0;
+	if (scsi_status_is_check_condition(sreq->result))
+		hdr->driver_status = DRIVER_SENSE;
+	hdr->info = 0;
+	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
+		hdr->info |= SG_INFO_CHECK;
+	hdr->response_len = 0;
+
+	if (sreq->sense_len && hdr->response) {
+		int len = min_t(unsigned int, hdr->max_response_len,
+					sreq->sense_len);
+
+		if (copy_to_user(uptr64(hdr->response), sreq->sense, len))
+			ret = -EFAULT;
+		else
+			hdr->response_len = len;
+	}
+
+	if (rq_data_dir(rq) == READ)
+		hdr->din_resid = sreq->resid_len;
+	else
+		hdr->dout_resid = sreq->resid_len;
+
+	return ret;
+}
+
+static void scsi_bsg_free_rq(struct request *rq)
+{
+	scsi_req_free_cmd(scsi_req(rq));
+}
+
+static const struct bsg_ops scsi_bsg_ops = {
+	.check_proto		= scsi_bsg_check_proto,
+	.fill_hdr		= scsi_bsg_fill_hdr,
+	.complete_rq		= scsi_bsg_complete_rq,
+	.free_rq		= scsi_bsg_free_rq,
+};
+
+int scsi_bsg_register_queue(struct request_queue *q, struct device *parent)
+{
+	return bsg_register_queue(q, parent, dev_name(parent), &scsi_bsg_ops);
+}
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index eae2235f79b5..0a0db35bab04 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -180,6 +180,16 @@ static inline void scsi_dh_add_device(struct scsi_device *sdev) { }
 static inline void scsi_dh_release_device(struct scsi_device *sdev) { }
 #endif
 
+#ifdef CONFIG_BLK_DEV_BSG
+int scsi_bsg_register_queue(struct request_queue *q, struct device *parent);
+#else
+static inline int scsi_bsg_register_queue(struct request_queue *q,
+		struct device *parent)
+{
+	return 0;
+}
+#endif
+
 extern int scsi_device_max_queue_depth(struct scsi_device *sdev);
 
 /* 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 32489d25158f..4ff9ac3296d8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1366,7 +1366,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
-	error = bsg_scsi_register_queue(rq, &sdev->sdev_gendev);
+	error = scsi_bsg_register_queue(rq, &sdev->sdev_gendev);
 	if (error)
 		/* we're treating error on bsg register as non-fatal,
 		 * so pretend nothing went wrong */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9971796819ef..d36b67bd7267 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -537,7 +537,7 @@ struct request_queue {
 
 	int			mq_freeze_depth;
 
-#if defined(CONFIG_BLK_DEV_BSG)
+#if IS_ENABLED(CONFIG_BLK_DEV_BSG_COMMON)
 	struct bsg_class_device bsg_dev;
 #endif
 
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index dac37b6e00ec..b887da20bd41 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -5,8 +5,9 @@
 #include <uapi/linux/bsg.h>
 
 struct request;
+struct request_queue;
 
-#ifdef CONFIG_BLK_DEV_BSG
+#ifdef CONFIG_BLK_DEV_BSG_COMMON
 struct bsg_ops {
 	int	(*check_proto)(struct sg_io_v4 *hdr);
 	int	(*fill_hdr)(struct request *rq, struct sg_io_v4 *hdr,
@@ -24,16 +25,10 @@ struct bsg_class_device {
 
 int bsg_register_queue(struct request_queue *q, struct device *parent,
 		const char *name, const struct bsg_ops *ops);
-int bsg_scsi_register_queue(struct request_queue *q, struct device *parent);
 void bsg_unregister_queue(struct request_queue *q);
 #else
-static inline int bsg_scsi_register_queue(struct request_queue *q,
-		struct device *parent)
-{
-	return 0;
-}
 static inline void bsg_unregister_queue(struct request_queue *q)
 {
 }
-#endif /* CONFIG_BLK_DEV_BSG */
+#endif /* CONFIG_BLK_DEV_BSG_COMMON */
 #endif /* _LINUX_BSG_H */
-- 
2.30.2

