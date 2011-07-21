From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 081/103] target/iblock: Remove unused iblock_dev members
Date: Thu, 21 Jul 2011 00:12:04 -0700
Message-ID: <1311232346-6674-82-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm15-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.254]:39339 "HELO
	nm15-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752202Ab1GUHIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:40 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

ibd_depth and ibd_force are used write-only.  Remove them.
ibd_major/minor can be easily retrieved from ibd_bd, so get
rid of them too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   17 +++--------------
 drivers/target/target_core_iblock.h |    5 -----
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d43fc91..160c484 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -167,8 +167,6 @@ static struct se_device *iblock_create_virtdevice(
 	dev_limits.hw_queue_depth = q->nr_requests;
 	dev_limits.queue_depth = q->nr_requests;
 
-	ib_dev->ibd_major = MAJOR(bd->bd_dev);
-	ib_dev->ibd_minor = MINOR(bd->bd_dev);
 	ib_dev->ibd_bd = bd;
 
 	dev = transport_add_device_to_core_hba(hba,
@@ -177,8 +175,6 @@ static struct se_device *iblock_create_virtdevice(
 	if (!(dev))
 		goto failed;
 
-	ib_dev->ibd_depth = dev->queue_depth;
-
 	/*
 	 * Check if the underlying struct block_device request_queue supports
 	 * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
@@ -208,8 +204,6 @@ failed:
 		ib_dev->ibd_bio_set = NULL;
 	}
 	ib_dev->ibd_bd = NULL;
-	ib_dev->ibd_major = 0;
-	ib_dev->ibd_minor = 0;
 	return ERR_PTR(ret);
 }
 
@@ -467,7 +461,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 	struct iblock_dev *ib_dev = se_dev->se_dev_su_ptr;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, arg, token;
+	int ret = 0, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -501,10 +495,6 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
 			break;
 		case Opt_force:
-			match_int(args, &arg);
-			ib_dev->ibd_force = arg;
-			printk(KERN_INFO "IBLOCK: Set force=%d\n",
-				ib_dev->ibd_force);
 			break;
 		default:
 			break;
@@ -552,12 +542,11 @@ static ssize_t iblock_show_configfs_dev_params(
 	bl += sprintf(b + bl, "        ");
 	if (bd) {
 		bl += sprintf(b + bl, "Major: %d Minor: %d  %s\n",
-			ibd->ibd_major, ibd->ibd_minor, (!bd->bd_contains) ?
+			MAJOR(bd->bd_dev), MINOR(bd->bd_dev), (!bd->bd_contains) ?
 			"" : (bd->bd_holder == (struct iblock_dev *)ibd) ?
 			"CLAIMED: IBLOCK" : "CLAIMED: OS");
 	} else {
-		bl += sprintf(b + bl, "Major: %d Minor: %d\n",
-			ibd->ibd_major, ibd->ibd_minor);
+		bl += sprintf(b + bl, "Major: 0 Minor: 0\n");
 	}
 
 	return bl;
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index a69b7c2..2aa1d27 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -16,14 +16,9 @@ struct iblock_req {
 } ____cacheline_aligned;
 
 #define IBDF_HAS_UDEV_PATH		0x01
-#define IBDF_HAS_FORCE			0x02
 
 struct iblock_dev {
 	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
-	int	ibd_force;
-	int	ibd_major;
-	int	ibd_minor;
-	u32	ibd_depth;
 	u32	ibd_flags;
 	struct bio_set	*ibd_bio_set;
 	struct block_device *ibd_bd;
-- 
1.7.6

