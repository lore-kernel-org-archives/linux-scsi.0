From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/13] zfcp: Use -EIO for SBAL allocation failures
Date: Mon, 13 Jul 2009 15:06:07 +0200
Message-ID: <20090713131043.454211000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:37726 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbZGMNL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:11:26 -0400
Content-Disposition: inline; filename=711-zfcp-sbal-alloc-failuer.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

-ENOMEM is for memory allocation problems, -EIO for queue/SBAL
allocation problems.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:46:05.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 14:03:14.000000000 +0200
@@ -1053,14 +1053,14 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
-		return -ENOMEM;
+		return -EIO;
 	req->qtcb->bottom.support.req_buf_length = bytes;
 	req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
 
 	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
 	if (bytes <= 0)
-		return -ENOMEM;
+		return -EIO;
 	req->qtcb->bottom.support.resp_buf_length = bytes;
 
 	return 0;
@@ -2559,7 +2559,6 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	bytes = zfcp_qdio_sbals_from_sg(req, direction, fsf_cfdc->sg,
 					FSF_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
-		retval = -ENOMEM;
 		zfcp_fsf_req_free(req);
 		goto out;
 	}

