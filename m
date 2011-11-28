From: Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] [SCSI] sd: Lower printk level for drive cache information
Date: Mon, 28 Nov 2011 11:31:55 -0500
Message-ID: <20111128163053.GA24618@zod.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Numerous devices don't present cache data, particularly USB sticks.  The
devices operate correctly despite this, so lower the printk severity to
KERN_NOTICE.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..7cf9ec5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2119,7 +2119,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		}
 
 		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
+			sd_printk(KERN_NOTICE, sdkp, "No Caching mode page "
 				  "present\n");
 			goto defaults;
 		} else if ((buffer[offset] & 0x3f) != modepage) {
@@ -2164,7 +2164,7 @@ bad_sense:
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
 
 defaults:
-	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+	sd_printk(KERN_NOTICE, sdkp, "Assuming drive cache: write through\n");
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->DPOFUA = 0;
