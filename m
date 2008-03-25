From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 5/5] ps3rom: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 09:26:53 +0900
Message-ID: <1206404816-21710-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 1206378609.3494.50.camel@localhost.localdomain
 <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37888 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbYCYAxP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 20:53:15 -0400
In-Reply-To: <1206404816-21710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ps3rom.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index d1e7845..ce48e2d 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include <asm/lv1call.h>
 #include <asm/ps3stor.h>
@@ -330,11 +331,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		goto done;
 	}
 
-	cmd->sense_buffer[0]  = 0x70;
-	cmd->sense_buffer[2]  = sense_key;
-	cmd->sense_buffer[7]  = 16 - 6;
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	scsi_build_sense_buffer(0, cmd->sense_buffer, sense_key, asc, ascq);
 	cmd->result = SAM_STAT_CHECK_CONDITION;
 
 done:
-- 
1.5.3.7

