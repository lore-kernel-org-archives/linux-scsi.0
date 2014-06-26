From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [scsi] 3w-xxxx: fix mis-aligned struct accesses
Date: Thu, 26 Jun 2014 14:58:29 +0200
Message-ID: <4791230.CGnay5CMcb@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:57988 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaFZM6i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 08:58:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Adam Radford <linuxraid@lsi.com>

Building an allmodconfig ARM kernel, I get multiple such
warnings because of a spinlock contained in packed structure
in the 3w-xxxx driver:

../drivers/scsi/3w-xxxx.c: In function 'tw_chrdev_ioctl':
../drivers/scsi/3w-xxxx.c:1001:68: warning: mis-aligned access used for structure member [-fstrict-volatile-bitfields]
    timeout = wait_event_timeout(tw_dev->ioctl_wqueue, tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
                                                                    ^
../drivers/scsi/3w-xxxx.c:1001:68: note: when a volatile object spans multiple type-sized locations, the compiler must choose between using a single mis-aligned access to preserve the volatility, or using multiple aligned accesses to avoid runtime faults; this code may fail at runtime if the hardware does not allow this access

The same bug apparently was present in 3w-sas and 3w-9xxx, but has been
fixed in the past. This patch uses the same fix by moving the pragma
in front of the TW_Device_Extension definition, so it only covers
hardware structures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Adam Radford <linuxraid@lsi.com>
---
diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
index 49dcf03..29b0b84e 100644
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -392,6 +392,8 @@ typedef struct TAG_TW_Passthru
 	unsigned char padding[12];
 } TW_Passthru;
 
+#pragma pack()
+
 typedef struct TAG_TW_Device_Extension {
 	u32			base_addr;
 	unsigned long		*alignment_virtual_address[TW_Q_LENGTH];
@@ -430,6 +432,4 @@ typedef struct TAG_TW_Device_Extension {
 	wait_queue_head_t	ioctl_wqueue;
 } TW_Device_Extension;
 
-#pragma pack()
-
 #endif /* _3W_XXXX_H */

