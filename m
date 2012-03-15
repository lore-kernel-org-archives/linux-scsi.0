From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ipr: Increase alignment boundary of command blocks
Date: Wed, 14 Mar 2012 21:20:12 -0500
Message-ID: <201203150220.q2F2K7aY003015@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:44443 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071Ab2COCUN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 22:20:13 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 20:20:12 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 220E819D8050
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:03 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F2K9Y9176274
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:09 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F2K8Sw003053
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


The latest generation of ipr hardware performs best when command blocks
are aligned to a boundary equal to the size of the command block. Ensure
512 byte alignment, since this is the largest size command block we
can send.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_cmd_blk_align drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_cmd_blk_align	2012-03-10 13:45:06.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2012-03-10 13:45:25.000000000 -0600
@@ -8360,7 +8360,7 @@ static int __devinit ipr_alloc_cmd_blks(
 	int i;
 
 	ioa_cfg->ipr_cmd_pool = pci_pool_create (IPR_NAME, ioa_cfg->pdev,
-						 sizeof(struct ipr_cmnd), 16, 0);
+						 sizeof(struct ipr_cmnd), 512, 0);
 
 	if (!ioa_cfg->ipr_cmd_pool)
 		return -ENOMEM;
_

