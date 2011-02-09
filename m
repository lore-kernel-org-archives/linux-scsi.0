From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 12/31] target: Convert backend ->create_virtdevice() call to return ERR_PTR
Date: Wed,  9 Feb 2011 15:34:47 -0800
Message-ID: <1297294506-23579-13-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.67]:24151 "HELO
	nm9-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755755Ab1BIXf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:29 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the target_core_store_dev_enable() -> struct
se_subsystem_api->create_virtdevice() call to return proper ERR_PTR values
back up to configfs logic during backend dependent struct se_device ENABLE
exception conditions.

Along with the change to target_core_configfs.c, this includes converting IBLOCK,
FILEIO, pSCSI, and RAMDISK_* backend subsystem plugins to obtain upper level
PTR_ERR return codes (where available), and return via ERR_PTR during a
*_create_virtdev() failure.

Reported-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    4 +++-
 drivers/target/target_core_file.c     |   13 +++++++++----
 drivers/target/target_core_iblock.c   |   15 ++++++++-------
 drivers/target/target_core_pscsi.c    |   18 +++++++++---------
 drivers/target/target_core_rd.c       |    8 +++++---
 5 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 96b87da..80fec9a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1829,7 +1829,9 @@ static ssize_t target_core_store_dev_enable(
 		return -EINVAL;
 
 	dev = t->create_virtdevice(hba, se_dev, se_dev->se_dev_su_ptr);
-	if (!(dev) || IS_ERR(dev))
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+	else if (!dev)
 		return -EINVAL;
 
 	se_dev->se_dev_ptr = dev;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 676a010..ae2bf71 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -135,7 +135,7 @@ static struct se_device *fd_create_virtdevice(
 	mm_segment_t old_fs;
 	struct file *file;
 	struct inode *inode = NULL;
-	int dev_flags = 0, flags;
+	int dev_flags = 0, flags, ret = -EINVAL;
 
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 
@@ -147,6 +147,7 @@ static struct se_device *fd_create_virtdevice(
 	if (IS_ERR(dev_p)) {
 		printk(KERN_ERR "getname(%s) failed: %lu\n",
 			fd_dev->fd_dev_name, IS_ERR(dev_p));
+		ret = PTR_ERR(dev_p);
 		goto fail;
 	}
 #if 0
@@ -166,8 +167,12 @@ static struct se_device *fd_create_virtdevice(
 		flags |= O_SYNC;
 
 	file = filp_open(dev_p, flags, 0600);
-
-	if (IS_ERR(file) || !file || !file->f_dentry) {
+	if (IS_ERR(file)) {
+		printk(KERN_ERR "filp_open(%s) failed\n", dev_p);
+		ret = PTR_ERR(file);
+		goto fail;
+	}
+	if (!file || !file->f_dentry) {
 		printk(KERN_ERR "filp_open(%s) failed\n", dev_p);
 		goto fail;
 	}
@@ -242,7 +247,7 @@ fail:
 		fd_dev->fd_file = NULL;
 	}
 	putname(dev_p);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 /*	fd_free_device(): (Part of se_subsystem_api_t template)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 422187b..9140be3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -130,10 +130,11 @@ static struct se_device *iblock_create_virtdevice(
 	struct request_queue *q;
 	struct queue_limits *limits;
 	u32 dev_flags = 0;
+	int ret = -EINVAL;
 
 	if (!(ib_dev)) {
 		printk(KERN_ERR "Unable to locate struct iblock_dev parameter\n");
-		return 0;
+		return ERR_PTR(ret);
 	}
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 	/*
@@ -142,7 +143,7 @@ static struct se_device *iblock_create_virtdevice(
 	ib_dev->ibd_bio_set = bioset_create(32, 64);
 	if (!(ib_dev->ibd_bio_set)) {
 		printk(KERN_ERR "IBLOCK: Unable to create bioset()\n");
-		return 0;
+		return ERR_PTR(-ENOMEM);
 	}
 	printk(KERN_INFO "IBLOCK: Created bio_set()\n");
 	/*
@@ -154,8 +155,10 @@ static struct se_device *iblock_create_virtdevice(
 
 	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
-	if (IS_ERR(bd))
+	if (IS_ERR(bd)) {
+		ret = PTR_ERR(bd);
 		goto failed;
+	}
 	/*
 	 * Setup the local scope queue_limits from struct request_queue->limits
 	 * to pass into transport_add_device_to_core_hba() as struct se_dev_limits.
@@ -185,9 +188,7 @@ static struct se_device *iblock_create_virtdevice(
 	 * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
 	 * in ATA and we need to set TPE=1
 	 */
-	if (blk_queue_discard(bdev_get_queue(bd))) {
-		struct request_queue *q = bdev_get_queue(bd);
-
+	if (blk_queue_discard(q)) {
 		DEV_ATTRIB(dev)->max_unmap_lba_count =
 				q->limits.max_discard_sectors;
 		/*
@@ -213,7 +214,7 @@ failed:
 	ib_dev->ibd_bd = NULL;
 	ib_dev->ibd_major = 0;
 	ib_dev->ibd_minor = 0;
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static void iblock_free_device(void *p)
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f596cb7..e795f7d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -556,7 +556,7 @@ static struct se_device *pscsi_create_virtdevice(
 	if (!(pdv)) {
 		printk(KERN_ERR "Unable to locate struct pscsi_dev_virt"
 				" parameter\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	/*
 	 * If not running in PHV_LLD_SCSI_HOST_NO mode, locate the
@@ -566,7 +566,7 @@ static struct se_device *pscsi_create_virtdevice(
 		if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
 			printk(KERN_ERR "pSCSI: Unable to locate struct"
 				" Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
-			return NULL;
+			return ERR_PTR(-ENODEV);
 		}
 		/*
 		 * For the newer PHV_VIRUTAL_HOST_ID struct scsi_device
@@ -575,7 +575,7 @@ static struct se_device *pscsi_create_virtdevice(
 		if (!(se_dev->su_dev_flags & SDF_USING_UDEV_PATH)) {
 			printk(KERN_ERR "pSCSI: udev_path attribute has not"
 				" been set before ENABLE=1\n");
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
 		/*
 		 * If no scsi_host_id= was passed for PHV_VIRUTAL_HOST_ID,
@@ -588,12 +588,12 @@ static struct se_device *pscsi_create_virtdevice(
 				printk(KERN_ERR "pSCSI: Unable to set hba_mode"
 					" with active devices\n");
 				spin_unlock(&hba->device_lock);
-				return NULL;
+				return ERR_PTR(-EEXIST);
 			}
 			spin_unlock(&hba->device_lock);
 
 			if (pscsi_pmode_enable_hba(hba, 1) != 1)
-				return NULL;
+				return ERR_PTR(-ENODEV);
 
 			legacy_mode_enable = 1;
 			hba->hba_flags |= HBA_FLAGS_PSCSI_MODE;
@@ -603,14 +603,14 @@ static struct se_device *pscsi_create_virtdevice(
 			if (!(sh)) {
 				printk(KERN_ERR "pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return NULL;
+				return ERR_PTR(-ENODEV);
 			}
 		}
 	} else {
 		if (phv->phv_mode == PHV_VIRUTAL_HOST_ID) {
 			printk(KERN_ERR "pSCSI: PHV_VIRUTAL_HOST_ID set while"
 				" struct Scsi_Host exists\n");
-			return NULL;
+			return ERR_PTR(-EEXIST);
 		}
 	}
 
@@ -645,7 +645,7 @@ static struct se_device *pscsi_create_virtdevice(
 				hba->hba_flags &= ~HBA_FLAGS_PSCSI_MODE;
 			}
 			pdv->pdv_sd = NULL;
-			return NULL;
+			return ERR_PTR(-ENODEV);
 		}
 		return dev;
 	}
@@ -661,7 +661,7 @@ static struct se_device *pscsi_create_virtdevice(
 		hba->hba_flags &= ~HBA_FLAGS_PSCSI_MODE;
 	}
 
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 /*	pscsi_free_device(): (Part of se_subsystem_api_t template)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 979aebf..0d0a583 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -254,13 +254,15 @@ static struct se_device *rd_create_virtdevice(
 	struct se_dev_limits dev_limits;
 	struct rd_dev *rd_dev = p;
 	struct rd_host *rd_host = hba->hba_ptr;
-	int dev_flags = 0;
+	int dev_flags = 0, ret = -EINVAL;
 	char prod[16], rev[4];
 
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 
-	if (rd_build_device_space(rd_dev) < 0)
+	if (rd_build_device_space(rd_dev) < 0) {
+		ret = -ENOMEM;
 		goto fail;
+	}
 
 	snprintf(prod, 16, "RAMDISK-%s", (rd_dev->rd_direct) ? "DR" : "MCP");
 	snprintf(rev, 4, "%s", (rd_dev->rd_direct) ? RD_DR_VERSION :
@@ -293,7 +295,7 @@ static struct se_device *rd_create_virtdevice(
 
 fail:
 	rd_release_device_space(rd_dev);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static struct se_device *rd_DIRECT_create_virtdevice(
-- 
1.7.4

