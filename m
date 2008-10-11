From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] 3w-9xxx: remove unnecessary local_irq_save/restore for
 scsi sg copy API
Date: Sat, 11 Oct 2008 16:00:00 +0900
Message-ID: <20081011155729X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36190 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763922AbYJKHA1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Oct 2008 03:00:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linuxraid@amcc.com, aradford@gmail.com, linux-scsi@vger.kernel.org

Since the commit 50bed2e2862a8f3a4f7d683d0d27292e71ef18b9 (sg: disable
interrupts inside sg_copy_buffer), no need to disable interrupts
before calling scsi_sg_copy_from_buffer. So we can simplify
twa_scsiop_execute_scsi_complete() a bit, which disables interrupts
just for scsi_sg_copy_from_buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/3w-9xxx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b92c19b..5311317 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1924,12 +1924,9 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 	    (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	     cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
 		if (scsi_sg_count(cmd) == 1) {
-			unsigned long flags;
 			void *buf = tw_dev->generic_buffer_virt[request_id];
 
-			local_irq_save(flags);
 			scsi_sg_copy_from_buffer(cmd, buf, TW_SECTOR_SIZE);
-			local_irq_restore(flags);
 		}
 	}
 } /* End twa_scsiop_execute_scsi_complete() */
-- 
1.5.5.GIT

