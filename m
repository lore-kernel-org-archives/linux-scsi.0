From: "Gabriele Gorla" <gorlik@penguintown.net>
Subject: [PATCH 2.6.23] 3w-xxxx: Fix bad unaligned accesses on alpha SMP
Date: Thu, 6 Dec 2007 18:07:01 -0800 (PST)
Message-ID: <15555.216.228.112.21.1196993221.squirrel@penguintown.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [69.3.150.202] ([69.3.150.202]:43779 "EHLO
	alpha.penguintown.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXLGCuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 21:50:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com
Cc: linux-scsi@vger.kernel.org, aradford@gmail.com

disable packing of the TAG_TW_Device_Extension
structure to prevent kernel unaligned accesses when
accessing the spinlock inside the ioctl_wqueue structure.
Fixes smartmontools kernel panic on alpha SMP

Signed-off-by: Gabriele Gorla <gorlik@yahoo.com>
---

--- linux-2.6.23/drivers/scsi/3w-xxxx.h 2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23a/drivers/scsi/3w-xxxx.h 2007-12-06 17:46:05.000000000 -0800
@@ -392,6 +392,8 @@
        unsigned char padding[12];
 } TW_Passthru;

+#pragma pack()
+
 typedef struct TAG_TW_Device_Extension {
        u32             base_addr;
        unsigned long           *alignment_virtual_address[TW_Q_LENGTH];
@@ -430,6 +432,4 @@
        wait_queue_head_t       ioctl_wqueue;
 } TW_Device_Extension;

-#pragma pack()
-
 #endif /* _3W_XXXX_H */


