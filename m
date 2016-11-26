From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] bnx2fc: shift wrapping bug in bnx2fc_process_unsol_compl()
Date: Sat, 26 Nov 2016 19:36:29 +0100
Message-ID: <20161126183629.9969-1-christophe.jaillet@wanadoo.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

BNX2FC_NUM_ERR_BITS is 63. err_warn_bit_map is a u64. So, to make sure that
no shift wrapping will occur, we need need additionnal casting.

The same test is already done a few lines above and '(u64)1' is already
used there. So just do the same here.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I guess that this could also be written with a '1ULL << i' which would be
cleaner and less verbose IMHO, but apparently this driver does not use
such things yet. So keep the current style with casting.
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 5ff9f89c17c7..a9dccb3b49cc 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -829,7 +829,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 			((u64)err_entry->data.err_warn_bitmap_hi << 32) |
 			(u64)err_entry->data.err_warn_bitmap_lo;
 		for (i = 0; i < BNX2FC_NUM_ERR_BITS; i++) {
-			if (err_warn_bit_map & (u64) (1 << i)) {
+			if (err_warn_bit_map & (u64)((u64)1 << i)) {
 				err_warn = i;
 				break;
 			}
-- 
2.9.3

