From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mvsas: fix a && vs & bug
Date: Thu, 16 Aug 2012 14:04:02 +0300
Message-ID: <20120816110401.GA12318@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "1 << (slot_idx % 32)" condition is always true.  The intent was to
test a bit field here using bitwise AND.  We do the test correctly a few
lines later in the do while loop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker fix.  Untested.  Would apply to the -stable kernel.

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 7e423e5..16349aa 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -622,7 +622,7 @@ static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 {
 	u32 tmp;
 	tmp = mvs_cr32(mvi, MVS_COMMAND_ACTIVE+(slot_idx >> 3));
-	if (tmp && 1 << (slot_idx % 32)) {
+	if (tmp & 1 << (slot_idx % 32)) {
 		mv_printk("command active %08X,  slot [%x].\n", tmp, slot_idx);
 		mvs_cw32(mvi, MVS_COMMAND_ACTIVE + (slot_idx >> 3),
 			1 << (slot_idx % 32));
