From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] scsi/aacraid: user upper/lower_address() macro to avoid "right shift count >= width of type" warning.
Date: Wed, 21 Nov 2012 21:50:21 +0100
Message-ID: <1353531021-10410-1-git-send-email-sebastian@breakpoint.cc>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34825 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964771Ab2KUUu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 15:50:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Avoids the following warning:
|drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
|drivers/scsi/aacraid/src.c:410:3: warning: right shift count >= width of type [enabled by default]
|    BUG_ON((u32)(address >> 32) != 0L);
|    ^
|drivers/scsi/aacraid/src.c:434:2: warning: right shift count >= width of type [enabled by default]
|   src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/scsi/aacraid/src.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..4f6388e 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp = 0;
-		BUG_ON((u32)(address >> 32) != 0L);
+		BUG_ON((upper_32_bits(address) != 0L));
 		address |= fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,8 +431,8 @@ static int aac_src_deliver_message(struct fib *fib)
 		address |= fibsize;
 	}
 
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
-	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, upper_32_bits(address));
+	src_writel(dev, MUnit.IQ_L, lower_32_bits(address));
 
 	return 0;
 }
-- 
1.7.10.4

