From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: sg: Free data buffers after calling blk_rq_unmap_user
Date: Tue, 15 Sep 2009 18:53:57 +0200
Message-ID: <20090915165356.GA2356@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:46207 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZIOQyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 12:54:20 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate7.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n8FGs8SJ212522
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2009 16:54:13 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8FGrwtn3199178
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2009 17:53:58 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8FGrwU6003122
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2009 17:53:58 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dgilbert@interlog.com

This patch fixes a problem with the sg driver that is only visible
with the CONFIG_DEBUG_PAGEALLOC kernel config option. The patch works
for me, but i would appreciate the review of somebody with more
knowledge about the interactions between the sg driver and the block
layer.

Christof
---
sg: Free data buffers after calling blk_rq_unmap_user

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
