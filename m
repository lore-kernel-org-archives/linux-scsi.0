From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bnx2fc: fix incorrect cast to u64 on shift operation
Date: Sat,  4 May 2019 17:48:29 +0100
Message-ID: <20190504164829.26631-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently an int is being shifted and the result is being cast to a u64
which leads to undefined behaviour if the shift is more than 31 bits. Fix
this by casting the integer value 1 to u64 before the shift operation.

Addresses-Coverity: ("Bad shift operation")
Fixes: 7b594769120b ("[SCSI] bnx2fc: Handle REC_TOV error code from firmware")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 19734ec7f42e..747f019fb393 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -830,7 +830,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 			((u64)err_entry->data.err_warn_bitmap_hi << 32) |
 			(u64)err_entry->data.err_warn_bitmap_lo;
 		for (i = 0; i < BNX2FC_NUM_ERR_BITS; i++) {
-			if (err_warn_bit_map & (u64) (1 << i)) {
+			if (err_warn_bit_map & ((u64)1 << i)) {
 				err_warn = i;
 				break;
 			}
-- 
2.20.1
