Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73473C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 11:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350829AbhK0Lv6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 06:51:58 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:52340 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbhK0Lt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 06:49:57 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id qwADm6yszOvR0qwADmtlCQ; Sat, 27 Nov 2021 12:46:42 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 27 Nov 2021 12:46:42 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] scsi: cxlflash: Use 'bitmap_set()' to simplify the code
Date:   Sat, 27 Nov 2021 12:46:39 +0100
Message-Id: <00ffdfddd892c40542db1012658a58934161fb58.1638013435.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'lun_alloc_map' bitmap is zalloc'ed, so initially all its bits are
zeroed.

So use 'bitmap_set()' which will only set bits in the given range. The
upper bits are left unmodified. (i.e. zero)

This simplifies a lot the logic when initializing this bitmap.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The mix-up of 'unsigned long', BITS_PER_LONG, 'u64' and ULL is puzzling.
I guess that 'struct ba_lun_info' and its 'u64 *lun_alloc_map' should
remain as is because the file is also used outside Linux.

I also guess that on the system that uses this driver, u64 = unsigned long.

Finally, this is only partially compile tested because I don't have the
needed cross-compiling tool chain.
---
 drivers/scsi/cxlflash/vlun.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 01917b28cdb6..5600082145bc 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -59,9 +59,7 @@ static void marshal_clone_to_rele(struct dk_cxlflash_clone *clone,
 static int ba_init(struct ba_lun *ba_lun)
 {
 	struct ba_lun_info *bali = NULL;
-	int lun_size_au = 0, i = 0;
-	int last_word_underflow = 0;
-	u64 *lam;
+	int lun_size_au = 0;
 
 	pr_debug("%s: Initializing LUN: lun_id=%016llx "
 		 "ba_lun->lsize=%lx ba_lun->au_size=%lX\n",
@@ -100,20 +98,7 @@ static int ba_init(struct ba_lun *ba_lun)
 
 	/* Initialize the bit map size and set all bits to '1' */
 	bali->free_aun_cnt = lun_size_au;
-
-	for (i = 0; i < bali->lun_bmap_size; i++)
-		bali->lun_alloc_map[i] = 0xFFFFFFFFFFFFFFFFULL;
-
-	/* If the last word not fully utilized, mark extra bits as allocated */
-	last_word_underflow = (bali->lun_bmap_size * BITS_PER_LONG);
-	last_word_underflow -= bali->free_aun_cnt;
-	if (last_word_underflow > 0) {
-		lam = &bali->lun_alloc_map[bali->lun_bmap_size - 1];
-		for (i = (HIBIT - last_word_underflow + 1);
-		     i < BITS_PER_LONG;
-		     i++)
-			clear_bit(i, (ulong *)lam);
-	}
+	bitmap_set((ulong *)bali->lun_alloc_map, 0, bali->free_aun_cnt);
 
 	/* Initialize high elevator index, low/curr already at 0 from kzalloc */
 	bali->free_high_idx = bali->lun_bmap_size;
-- 
2.30.2

