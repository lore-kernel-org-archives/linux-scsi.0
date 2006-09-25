From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] fix idiocy in asd_init_lseq_mdp()
Date: Mon, 25 Sep 2006 02:57:22 +0100
Message-ID: <20060925015722.GF29920@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48529 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1750843AbWIYB5W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 21:57:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

To whoever had written that code:

a) priority of >> is higher than that of &
b) priority of typecast is higher than that of any binary operator
c) learn the fscking C

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/aic94xx/aic94xx_seq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index d9b6da5..56e4b3b 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -764,7 +764,7 @@ static void asd_init_lseq_mdp(struct asd
 	asd_write_reg_word(asd_ha, LmSEQ_FIRST_INV_SCB_SITE(lseq),
 			   (u16)last_scb_site_no+1);
 	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq),
-			    (u16) LmM0INTEN_MASK & 0xFFFF0000 >> 16);
+			    (u16) ((LmM0INTEN_MASK & 0xFFFF0000) >> 16));
 	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq) + 2,
 			    (u16) LmM0INTEN_MASK & 0xFFFF);
 	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_FRM_LEN(lseq), 0);
-- 
1.4.2.GIT

