From: mchristi@redhat.com
Subject: [PATCH 3/5] target: call queue reset if supported
Date: Wed, 25 May 2016 02:55:01 -0500
Message-ID: <1464162903-14735-4-git-send-email-mchristi@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbcEYHzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 03:55:10 -0400
In-Reply-To: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

Instead of waiting for commands, map the lun reset operation
to a queue reset.

We do not check the result of blk_reset_queue because if
it works then we need to wait for the bio/request completions
and if it failed we might as wait and hope like we did before.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_file.c    | 12 ++++++++++++
 drivers/target/target_core_iblock.c  |  8 ++++++++
 drivers/target/target_core_pscsi.c   |  8 ++++++++
 drivers/target/target_core_tmr.c     |  3 +++
 include/target/target_core_backend.h |  1 +
 5 files changed, 32 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 75f0f08..d6af1f2 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -97,6 +97,17 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static int fd_reset_device(struct se_device *dev)
+{
+	struct fd_dev *fd_dev = FD_DEV(dev);
+	struct inode *inode;
+
+	inode = fd_dev->fd_file->f_mapping->host;
+	if (!S_ISBLK(inode->i_mode))
+		return -EOPNOTSUPP;
+	return blk_reset_queue(bdev_get_queue(inode->i_bdev));
+}
+
 static int fd_configure_device(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -813,6 +824,7 @@ static const struct target_backend_ops fileio_ops = {
 	.attach_hba		= fd_attach_hba,
 	.detach_hba		= fd_detach_hba,
 	.alloc_device		= fd_alloc_device,
+	.reset_device		= fd_reset_device,
 	.configure_device	= fd_configure_device,
 	.free_device		= fd_free_device,
 	.parse_cdb		= fd_parse_cdb,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7c4efb4..0a7dd59 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -79,6 +79,13 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	return &ib_dev->dev;
 }
 
+static int iblock_reset_device(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+	return blk_reset_queue(bdev_get_queue(ib_dev->ibd_bd));
+}
+
 static int iblock_configure_device(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -848,6 +855,7 @@ static const struct target_backend_ops iblock_ops = {
 	.detach_hba		= iblock_detach_hba,
 	.alloc_device		= iblock_alloc_device,
 	.configure_device	= iblock_configure_device,
+	.reset_device		= iblock_reset_device,
 	.free_device		= iblock_free_device,
 	.parse_cdb		= iblock_parse_cdb,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de18790..fa0505b 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -455,6 +455,13 @@ static int pscsi_create_type_other(struct se_device *dev,
 	return 0;
 }
 
+static int pscsi_reset_device(struct se_device *dev)
+{
+	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
+
+	return blk_reset_queue(pdv->pdv_sd->request_queue);
+}
+
 static int pscsi_configure_device(struct se_device *dev)
 {
 	struct se_hba *hba = dev->se_hba;
@@ -1131,6 +1138,7 @@ static const struct target_backend_ops pscsi_ops = {
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
 	.alloc_device		= pscsi_alloc_device,
+	.reset_device		= pscsi_reset_device,
 	.configure_device	= pscsi_configure_device,
 	.free_device		= pscsi_free_device,
 	.transport_complete	= pscsi_transport_complete,
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 4f229e7..609ec53 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -431,6 +431,9 @@ int core_tmr_lun_reset(
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
 		dev->transport->name, tas);
 
+	if (dev->transport->reset_device(dev))
+		dev->transport->reset_device(dev);
+
 	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
 	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 28ee5c2..a055e4f 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -17,6 +17,7 @@ struct target_backend_ops {
 
 	struct se_device *(*alloc_device)(struct se_hba *, const char *);
 	int (*configure_device)(struct se_device *);
+	int (*reset_device)(struct se_device *);
 	void (*free_device)(struct se_device *device);
 
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
-- 
2.7.2

