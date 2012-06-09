From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 1/4]  scsi: set to WCE if usb cache quirk is present.
Date: Sat,  9 Jun 2012 13:40:27 -0400
Message-ID: <1339263627-4003-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Make use of USB quirk method to identify such HDD while reading
the cache status in sd_probe(). If cache quirk is present for
the HDD, lets assume that cache is enabled and make WCE bit
equal to 1.

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/sd.c          |    9 +++++++--
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f0a4c6..e63e363 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2259,8 +2259,13 @@ bad_sense:
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
index 6efb2e1..8be0247 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -152,6 +152,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned wce_default_on:1; /* Cache is ON by default */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
