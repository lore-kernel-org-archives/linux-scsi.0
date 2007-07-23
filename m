From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] ibmvscsi: remove unnecessary map_sg check
Date: Mon, 23 Jul 2007 09:28:39 +0900
Message-ID: <20070723092839D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59823 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbXGWA2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:28:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, santil@us.ibm.com

No need to check use_sg since sg_tablesize is set appropriately in the
scsi host template.

Brian King's patch (2a7309372fe56ae46c499b772d811ad31c501dd9) did this
cleanup but the data buffer accessors patch (written before the patch
and merged after it) restored the check.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 5870866..6735260 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -393,12 +393,6 @@ static int map_sg_data(struct scsi_cmnd *cmd,
 		return 1;
 	else if (sg_mapped < 0)
 		return 0;
-	else if (sg_mapped > SG_ALL) {
-		printk(KERN_ERR
-		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
-		       SG_ALL, sg_mapped);
-		return 0;
-	}
 
 	set_srp_direction(cmd, srp_cmd, sg_mapped);
 
-- 
1.5.2.4

