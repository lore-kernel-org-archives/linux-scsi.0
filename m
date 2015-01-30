From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] bnx2fc: fix test of "err_warn_bit_map"
Date: Fri, 30 Jan 2015 11:49:40 +0300
Message-ID: <20150130084940.GF21357@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The bug in this code is "if (err_warn_bit_map & (u64) (1 << i)) {".
The cast to u64 happens after we have already shift wrapped so it's too
late.  Presumably this means some warnings are ignored.

I also cleanup the other err_warn_bit_map check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index c6688d7..a0cb702 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -734,7 +734,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 			((u64)err_entry->data.err_warn_bitmap_hi << 32) |
 			(u64)err_entry->data.err_warn_bitmap_lo;
 		for (i = 0; i < BNX2FC_NUM_ERR_BITS; i++) {
-			if (err_warn_bit_map & (u64)((u64)1 << i)) {
+			if (err_warn_bit_map & 1ULL << i) {
 				err_warn = i;
 				break;
 			}
@@ -829,7 +829,7 @@ ret_err_rqe:
 			((u64)err_entry->data.err_warn_bitmap_hi << 32) |
 			(u64)err_entry->data.err_warn_bitmap_lo;
 		for (i = 0; i < BNX2FC_NUM_ERR_BITS; i++) {
-			if (err_warn_bit_map & (u64) (1 << i)) {
+			if (err_warn_bit_map & 1ULL << i) {
 				err_warn = i;
 				break;
 			}
