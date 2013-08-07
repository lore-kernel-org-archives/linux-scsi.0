From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 8/8] [SCSI] aic94xx: fix bit masking
Date: Wed, 07 Aug 2013 13:00:31 +0900
Message-ID: <001801ce9322$a91638a0$fb42a9e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11963 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3HGEAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 00:00:32 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR500EPF74UR7K0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 07 Aug 2013 13:00:31 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'Jesper Juhl' <jj@chaosbits.net>, Jingoo Han <jg1.han@samsung.com>

Bit masking should happen before casting (u16), thus parentheses
are necessary in order to fix the following sparse warning:

drivers/scsi/aic94xx/aic94xx_seq.c:748:35: warning: cast truncates bits from constant value (93ef7f becomes ef7f)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/aic94xx/aic94xx_seq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 5fdca93..6b0a881 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -745,7 +745,7 @@ static void asd_init_lseq_mdp(struct asd_ha_struct *asd_ha,  int lseq)
 	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq),
 			    (u16) ((LmM0INTEN_MASK & 0xFFFF0000) >> 16));
 	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq) + 2,
-			    (u16) LmM0INTEN_MASK & 0xFFFF);
+			    (u16) (LmM0INTEN_MASK & 0xFFFF));
 	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_FRM_LEN(lseq), 0);
 	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_PROTOCOL(lseq), 0);
 	asd_write_reg_byte(asd_ha, LmSEQ_RESP_STATUS(lseq), 0);
-- 
1.7.10.4


