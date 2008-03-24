From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/5] ps3rom: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 01:54:55 +0900
Message-ID: <1206377695-26084-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206377695-26084-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41709 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbYCXQ5U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 12:57:20 -0400
In-Reply-To: <1206377695-26084-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
index d1e7845..150e5cd 100644
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
+	scsi_build_sense_buffer(0, cmd->sense_buffer, sense_key, asc, ascq, 10);
 	cmd->result = SAM_STAT_CHECK_CONDITION;
 
 done:
-- 
1.5.3.7

