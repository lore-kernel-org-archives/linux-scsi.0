From: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Date: Mon,  5 Nov 2012 14:53:02 -0500
Message-ID: <1352145183-29355-3-git-send-email-xi.wang@gmail.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35664 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2KETxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2012 14:53:45 -0500
In-Reply-To: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Xi Wang <xi.wang@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Invoking bit(n) with n >= 64 is undefined behavior, since bit(n) does
a 64-bit shift.  This patch adds a check on the shifting amount.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/scsi/mvsas/mv_94xx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 7e423e5..e1f35d4 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -715,11 +715,13 @@ static void mvs_94xx_free_reg_set(struct mvs_info *mvi, u8 *tfs)
 	if (*tfs == MVS_ID_NOT_MAPPED)
 		return;
 
-	mvi->sata_reg_set &= ~bit(reg_set);
-	if (reg_set < 32)
+	if (reg_set < 32) {
+		mvi->sata_reg_set &= ~bit(reg_set);
 		w_reg_set_enable(reg_set, (u32)mvi->sata_reg_set);
-	else
+	} else if (reg_set < 64) {
+		mvi->sata_reg_set &= ~bit(reg_set);
 		w_reg_set_enable(reg_set, (u32)(mvi->sata_reg_set >> 32));
+	}
 
 	*tfs = MVS_ID_NOT_MAPPED;
 
-- 
1.7.10.4

