From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 1/3] scsi: set to WCE if usb cache quirk is present.
Date: Sat,  7 Jul 2012 23:05:08 -0400
Message-ID: <1341716708-6665-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org, akpm@linux-foundation.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Make use of USB quirk method to identify such HDD while reading
the cache status in sd_probe(). If cache quirk is present for
the HDD, lets assume that cache is enabled and make WCE bit
equal to 1.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 drivers/scsi/sd.c          |    9 +++++++--
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f72b80..4225064 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2261,8 +2261,13 @@ bad_sense:
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
 
 defaults:
-	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
-	sdkp->WCE = 0;
+	if (sdp->wce_default_on) {
+		sd_printk(KERN_NOTICE, sdkp, "Assuming drive cache: write back\n");
+		sdkp->WCE = 1;
+	} else {
+		sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+		sdkp->WCE = 0;
+	}
 	sdkp->RCD = 0;
 	sdkp->DPOFUA = 0;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b6cf0cf..61ff671 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -156,6 +156,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wakeup_by_user:1;	/* user wakes up the ODD */
+	unsigned wce_default_on:1; /* Cache is ON by default */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.9.5
