From: Robert Hancock <hancockrwd@gmail.com>
Subject: [PATCH] scsi: properly export media change notification capability
 in block device flags
Date: Sun, 11 Oct 2009 13:54:11 -0600
Message-ID: <4AD237E3.6000206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752009AbZJKTyw@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

Due to some oversight, the SCSI capability for reporting media change
notifications was never actually translated into setting the appropriate
GENHD_FL_MEDIA_CHANGE_NOTIFY flag. HAL uses this flag to detect whether the
block device supports change notifications and so it never actually got
detected. Set the flag when appropriate in sd and sr.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

---

Gaah, am I disappointed in finding this one. Apparently people went to the
trouble of adding ATAPI AN support, and adding the appropriate flags to indicate
to userspace that it was supported, but nobody ever tested to make sure that
the support worked all the way through to actually make HAL stop polling
optical drives that support AN, which to my dismay, it doesn't. In fact even
with this patch it still doesn't seem to, but that's presumably some HAL bug.
HAL does now report that storage.removable.support_async_notification = true,
however.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8dd96dc..c1f474e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2012,6 +2012,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
+	if (test_bit(SDEV_EVT_MEDIA_CHANGE, sdp->supported_events))
+		gd->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index eb61f7a..485898e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -642,6 +642,8 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
+	if (test_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events))
+		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
