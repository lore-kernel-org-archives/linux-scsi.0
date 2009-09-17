From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] sg: Free data buffers after calling blk_rq_unmap_user
Date: Thu, 17 Sep 2009 09:10:14 +0200
Message-ID: <20090917071553.766054000@de.ibm.com>
References: <20090917071013.472963000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50098 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZIQHPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 03:15:52 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id n8H7FsSk003861
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 07:15:54 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8H7FsGv2613276
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 09:15:54 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8H7FriC022948
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 09:15:54 +0200
Content-Disposition: inline; filename=fix.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stable@kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Running sg_luns on s390x with CONFIG_DEBUG_PAGEALLOC enabled fails
with EFAULT from the SG_IO ioctl. The EFAULT is the result from
copy_to_user failing in this call chain:

sg_ioctl
sg_new_read
sg_finish_rem_req
blk_rq_unmap_user
__blk_rq_unmap_user
bio_uncopy_user
__bio_copy_iov
copy_to_user

The sg driver calls sg_remove_scat to free the memory pages before
calling blk_rq_unmap_user that tries to copy the data back to
userspace. Change the order to first call blk_rq_unmap_user before
freeing the pages in sg_remove_scat.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stable@kernel.org
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/sg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/scsi/sg.c	2009-09-15 18:18:11.000000000 +0200
+++ b/drivers/scsi/sg.c	2009-09-15 18:18:45.000000000 +0200
@@ -1708,11 +1708,6 @@ static int sg_finish_rem_req(Sg_request 
 	Sg_scatter_hold *req_schp = &srp->data;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
-	if (srp->res_used)
-		sg_unlink_reserve(sfp, srp);
-	else
-		sg_remove_scat(req_schp);
-
 	if (srp->rq) {
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
@@ -1720,6 +1715,11 @@ static int sg_finish_rem_req(Sg_request 
 		blk_put_request(srp->rq);
 	}
 
+	if (srp->res_used)
+		sg_unlink_reserve(sfp, srp);
+	else
+		sg_remove_scat(req_schp);
+
 	sg_remove_request(sfp, srp);
 
 	return ret;


