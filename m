From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: Redundant memset in scsi_alloc_sgtable
Date: Tue, 12 Jul 2005 17:06:14 -0700
Message-ID: <200507130006.j6D06Ig07714@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr24.intel.com ([143.183.121.16]:8941 "EHLO
	scsfmr004.sc.intel.com") by vger.kernel.org with ESMTP
	id S262469AbVGMAGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 20:06:22 -0400
Received: from scsfmr100.sc.intel.com (scsfmr100.sc.intel.com [10.3.253.9])
	by scsfmr004.sc.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j6D06Iod007951
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 00:06:18 GMT
Received: from unix-os.sc.intel.com (unix-os.sc.intel.com [172.25.110.7])
	by scsfmr100.sc.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with ESMTP id j6D08PoV020646
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 00:08:25 GMT
Received: from kwchenmobl1 (kwchen-mobl1.amr.corp.intel.com [143.183.251.71])
	by unix-os.sc.intel.com (8.11.6/8.11.2) with ESMTP id j6D06Ig07714
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 17:06:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_init_io calls scsi_alloc_sgtable and then calls blk_rq_map_sg
to initialize the scatterlist structure.  blk_rq_map_sg() already
memset the structure for every new segment.  That makes the memset
in scsi_alloc_sgtable unnecessary.

Patch to delete the extra memset in scsi_alloc_sgtable.  Tested on
a x86_64 machine.  Looks stable to me.


Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>

--- linux-2.6.12/drivers/scsi/scsi_lib.c.orig	2005-07-12 16:34:46.051647933 -0700
+++ linux-2.6.12/drivers/scsi/scsi_lib.c	2005-07-12 16:37:10.601450849 -0700
@@ -615,8 +615,6 @@ static struct scatterlist *scsi_alloc_sg
 
 	sgp = scsi_sg_pools + cmd->sglist_len;
 	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	if (sgl)
-		memset(sgl, 0, sgp->size);
 	return sgl;
 }
 


