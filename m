From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix msleep in scsi netlink
Date: Tue, 2 Nov 2010 21:01:12 +0800
Message-ID: <AANLkTikoZfbGu4bp62n3pkTKO8255prSPxeQnzNT6DZ9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34456 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0KBNBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 09:01:13 -0400
Received: by wwe15 with SMTP id 15so7338452wwe.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2010 06:01:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

After sleep it is not certain that the scsi netlink state is no longer busy.

The uncertainty is fixed as possible as 20 ticks permit.

And the state word of scsi netlink is redefined to be the native word
of most hardwares.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_netlink.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_netlink.c	2010-11-02 20:48:02.000000000 +0800
@@ -35,7 +35,8 @@ EXPORT_SYMBOL_GPL(scsi_nl_sock);
 static DEFINE_SPINLOCK(scsi_nl_lock);
 static struct list_head scsi_nl_drivers;

-static u32	scsi_nl_state;
+static unsigned long scsi_nl_state;
+
 #define STATE_EHANDLER_BSY		0x00000001

 struct scsi_nl_transport {
@@ -315,16 +316,21 @@ scsi_nl_add_transport(u8 tport,
 {
 	unsigned long flags;
 	int err = 0;
+	unsigned int msecs = jiffies_to_msecs(20);

 	if (tport >= SCSI_NL_MAX_TRANSPORTS)
 		return -EINVAL;

+check_busy:
 	spin_lock_irqsave(&scsi_nl_lock, flags);

 	if (scsi_nl_state & STATE_EHANDLER_BSY) {
 		spin_unlock_irqrestore(&scsi_nl_lock, flags);
-		msleep(1);
-		spin_lock_irqsave(&scsi_nl_lock, flags);
+		if (msecs--) {
+			msleep(1);
+			goto check_busy;
+		}
+		return -EBUSY;
 	}

 	if (transports[tport].msg_handler || transports[tport].event_handler) {
@@ -407,6 +413,7 @@ scsi_nl_add_driver(u64 vendor_id, struct
 {
 	struct scsi_nl_drvr *driver;
 	unsigned long flags;
+	unsigned int msecs = jiffies_to_msecs(20);

 	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
 	if (unlikely(!driver)) {
@@ -419,11 +426,16 @@ scsi_nl_add_driver(u64 vendor_id, struct
 	driver->hostt = hostt;
 	driver->vendor_id = vendor_id;

+check_busy:
 	spin_lock_irqsave(&scsi_nl_lock, flags);
 	if (scsi_nl_state & STATE_EHANDLER_BSY) {
 		spin_unlock_irqrestore(&scsi_nl_lock, flags);
-		msleep(1);
-		spin_lock_irqsave(&scsi_nl_lock, flags);
+		if (msecs--) {
+			msleep(1);
+			goto check_busy;
+		}
+		kfree(driver);
+		return -EBUSY;
 	}
 	list_add_tail(&driver->next, &scsi_nl_drivers);
 	spin_unlock_irqrestore(&scsi_nl_lock, flags);
