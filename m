From: Gabriele Gorla <gorlik@yahoo.com>
Subject: [PATCH 2.6.22] 3w-xxxx: Fix bad unaligned accesses on alpha SMP
Date: Sun, 2 Sep 2007 02:28:00 -0700 (PDT)
Message-ID: <755901.75056.qm@web53706.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:40931 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755147AbXIBJel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Sep 2007 05:34:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com
Cc: linux-scsi@vger.kernel.org

disable packing of the TAG_TW_Device_Extension
structure to prevent kernel unaligned accesses when
accessing ioctl_wqueue.
Fixes smartmontools kernel panic on alpha SMP

Signed-off-by: Gabriele Gorla <gorlik@yahoo.com>
---


--- linux-2.6.22/drivers/scsi/3w-xxxx.h.orig
2007-09-01 17:49:22.000000000 -0700
+++ linux-2.6.22/drivers/scsi/3w-xxxx.h 2007-09-01
17:49:45.000000000 -0700
@@ -392,6 +392,8 @@ typedef struct TAG_TW_Passthru
        unsigned char padding[12];
 } TW_Passthru;
 
+#pragma pack()
+
 typedef struct TAG_TW_Device_Extension {
        u32                     base_addr;
        unsigned long
*alignment_virtual_address[TW_Q_LENGTH];
@@ -430,6 +432,4 @@ typedef struct
TAG_TW_Device_Extension {
        wait_queue_head_t       ioctl_wqueue;
 } TW_Device_Extension;
 
-#pragma pack()
-
 #endif /* _3W_XXXX_H */



       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
