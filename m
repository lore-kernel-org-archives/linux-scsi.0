From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/4] USB Storage: Make driver less chatty when it finds a
	new device
Date: Thu, 24 Sep 2009 16:19:49 -0600
Message-ID: <20090924221949.GD7943@parisc-linux.org>
References: <20090920225348.GB3690@parisc-linux.org> <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org> <20090924221702.GA7943@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41292 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZIXWTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 18:19:46 -0400
Content-Disposition: inline
In-Reply-To: <20090924221702.GA7943@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

Use dev_dbg() instead of an unconditional printk(KERN_DEBUG).  This has
two benefits; one is that it identifies the USB device which the messages
related to, and the other is that the messages won't be produced unless
debug is turned on.

Enable the debug messages when CONFIG_USB_STORAGE_DEBUG is set.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/storage/usb.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 39d3e54..92ca3c5 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -45,6 +45,10 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#ifdef CONFIG_USB_STORAGE_DEBUG
+#define DEBUG
+#endif
+
 #include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/freezer.h>
@@ -808,14 +812,13 @@ static int usb_stor_scan_thread(void * __us)
 {
 	struct us_data *us = (struct us_data *)__us;
 
-	printk(KERN_DEBUG
-		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
+	dev_dbg(&us->pusb_intf->dev, "device found\n");
 
 	set_freezable();
 	/* Wait for the timeout to expire or for a disconnect */
 	if (delay_use > 0) {
-		printk(KERN_DEBUG "usb-storage: waiting for device "
-				"to settle before scanning\n");
+		dev_dbg(&us->pusb_intf->dev, "waiting for device to settle "
+				"before scanning\n");
 		wait_event_freezable_timeout(us->delay_wait,
 				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
 				delay_use * HZ);
@@ -832,7 +835,7 @@ static int usb_stor_scan_thread(void * __us)
 			mutex_unlock(&us->dev_mutex);
 		}
 		scsi_scan_host(us_to_host(us));
-		printk(KERN_DEBUG "usb-storage: device scan complete\n");
+		dev_dbg(&us->pusb_intf->dev, "scan complete\n");
 
 		/* Should we unbind if no devices were detected? */
 	}
-- 
1.6.3.3

