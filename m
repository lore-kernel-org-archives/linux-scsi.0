From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/13] zfcp: Return -ENOMEM for allocation failures in zfcp_fsf
Date: Mon, 13 Jul 2009 15:06:04 +0200
Message-ID: <20090713131043.044386000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54802 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbZGMNKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:44 -0400
Content-Disposition: inline; filename=708-zfcp-enomem.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When a fsf_req or a qtcb cannot be allocated return -ENOMEM instead of
-EIO.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:17:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:17:49.000000000 +0200
@@ -722,7 +722,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 		req = zfcp_fsf_alloc_qtcb(pool);
 
 	if (unlikely(!req))
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-ENOMEM);
 
 	if (adapter->req_no == 0)
 		adapter->req_no++;

