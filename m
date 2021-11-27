Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBBDC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 11:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354079AbhK0LwH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 06:52:07 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:62662 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237849AbhK0LuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 06:50:06 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id qwANm6ywkOvR0qwANmtlDw; Sat, 27 Nov 2021 12:46:51 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 27 Nov 2021 12:46:51 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] scsi: cxlflash: Simplify usage of 'test_bit()'
Date:   Sat, 27 Nov 2021 12:46:49 +0100
Message-Id: <118d5b49e1341e4fed45b03d64a083a34556667f.1638013435.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <00ffdfddd892c40542db1012658a58934161fb58.1638013435.git.christophe.jaillet@wanadoo.fr>
References: <00ffdfddd892c40542db1012658a58934161fb58.1638013435.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'test_bit()' can access any bit of a bitmap. There is no need to precompute
anything. This just duplicate some computations and is more verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This is only partially compile tested because I don't have the needed
cross-compiling tool chain.
---
 drivers/scsi/cxlflash/vlun.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5600082145bc..39de9ae49aaf 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -221,12 +221,7 @@ static u64 ba_alloc(struct ba_lun *ba_lun)
  */
 static int validate_alloc(struct ba_lun_info *bali, u64 aun)
 {
-	int idx = 0, bit_pos = 0;
-
-	idx = aun / BITS_PER_LONG;
-	bit_pos = aun % BITS_PER_LONG;
-
-	if (test_bit(bit_pos, (ulong *)&bali->lun_alloc_map[idx]))
+	if (test_bit(aun, (ulong *)bali->lun_alloc_map))
 		return -1;
 
 	return 0;
-- 
2.30.2

