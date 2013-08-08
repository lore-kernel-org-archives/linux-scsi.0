From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 6/8] [SCSI] 3w-sas: add missing __iomem annotation
Date: Thu, 08 Aug 2013 10:16:58 +0900
Message-ID: <002901ce93d4$faaa55e0$efff01a0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63823 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3HHBRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 21:17:00 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR6002LNU8BVED0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Aug 2013 10:16:59 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'Adam Radford' <linuxraid@lsi.com>, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

Added missing __iomem annotation in order to fix the following
sparse warnings:

drivers/scsi/3w-sas.c:1291:21: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/3w-sas.c:1291:21:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/3w-sas.c:1291:21:    got void *reg
drivers/scsi/3w-sas.c:1295:29: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/3w-sas.c:1295:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/3w-sas.c:1295:29:    got void *reg
drivers/scsi/3w-sas.c:1323:55: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/3w-sas.c:1323:55:    expected void *reg
drivers/scsi/3w-sas.c:1323:55:    got unsigned char [noderef] <asn:2>*
drivers/scsi/3w-sas.c:1328:55: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/3w-sas.c:1328:55:    expected void *reg
drivers/scsi/3w-sas.c:1328:55:    got unsigned char [noderef] <asn:2>*

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/scsi/3w-sas.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index c845bdb..0d9c722 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1282,7 +1282,8 @@ twl_interrupt_bail:
 } /* End twl_interrupt() */
 
 /* This function will poll for a register change */
-static int twl_poll_register(TW_Device_Extension *tw_dev, void *reg, u32 value, u32 result, int seconds)
+static int twl_poll_register(TW_Device_Extension *tw_dev, void __iomem *reg,
+			     u32 value, u32 result, int seconds)
 {
 	unsigned long before;
 	int retval = 1;
-- 
1.7.10.4


