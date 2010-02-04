From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 28/30] hpsa: eliminate lock_kernel in compat_ioctl
Date: Thu, 04 Feb 2010 08:43:46 -0600
Message-ID: <20100204144346.10406.76704.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: eliminate lock_kernel in compat_ioctl
The use of the big kernel lock here  appears
to be ancient cruft that is no longer needed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b40221..225a787 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2287,16 +2287,6 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
 
 #ifdef CONFIG_COMPAT
 
-static int do_ioctl(struct scsi_device *dev, int cmd, void *arg)
-{
-	int ret;
-
-	lock_kernel();
-	ret = hpsa_ioctl(dev, cmd, arg);
-	unlock_kernel();
-	return ret;
-}
-
 static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg);
 static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 	int cmd, void *arg);
@@ -2319,7 +2309,7 @@ static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg)
 	case CCISS_REGNEWD:
 	case CCISS_RESCANDISK:
 	case CCISS_GETLUNINFO:
-		return do_ioctl(dev, cmd, arg);
+		return hpsa_ioctl(dev, cmd, arg);
 
 	case CCISS_PASSTHRU32:
 		return hpsa_ioctl32_passthru(dev, cmd, arg);
@@ -2355,7 +2345,7 @@ static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(dev, CCISS_PASSTHRU, (void *)p);
+	err = hpsa_ioctl(dev, CCISS_PASSTHRU, (void *)p);
 	if (err)
 		return err;
 	err |= copy_in_user(&arg32->error_info, &p->error_info,
@@ -2392,7 +2382,7 @@ static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(dev, CCISS_BIG_PASSTHRU, (void *)p);
+	err = hpsa_ioctl(dev, CCISS_BIG_PASSTHRU, (void *)p);
 	if (err)
 		return err;
 	err |= copy_in_user(&arg32->error_info, &p->error_info,
