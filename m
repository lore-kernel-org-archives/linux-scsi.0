From: Dan Carpenter <error27@gmail.com>
Subject: [patch 4/4] SCSI: target: off by one in tcm_loop_make_naa_tpg()
Date: Mon, 13 Jun 2011 23:12:19 +0300
Message-ID: <20110613201219.GK3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53396 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FMUN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 16:13:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

There are TL_TPGS_PER_HBA elements in the ->tl_hba_tpgs[] array so
this test is off by one.  Later when we take the pointer, it would
be one past the end and we'd crash:

	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
	tl_tpg->tl_hba = tl_hba;

I think this can only be triggered by root.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 7329d0e..4fedb58 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1227,7 +1227,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	tpgt_str += 5; /* Skip ahead of "tpgt_" */
 	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
 
-	if (tpgt > TL_TPGS_PER_HBA) {
+	if (tpgt >= TL_TPGS_PER_HBA) {
 		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
 				" %u\n", tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
