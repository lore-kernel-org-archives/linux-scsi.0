From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/9] zfcp: Fix check whether unchained ct_els is possible
Date: Thu, 08 Jul 2010 09:53:02 +0200
Message-ID: <20100708080109.894357000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:32949 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0GHIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:12 -0400
Content-Disposition: inline; filename=701-zfcp-fallout.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

A false check was performed whether an unchained ct_els 
is possible or not.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2010-06-21 09:37:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-06-21 09:37:40.000000000 +0200
@@ -981,7 +981,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 	}
 
 	/* use single, unchained SBAL if it can hold the request */
-	if (zfcp_qdio_sg_one_sbale(sg_req) || zfcp_qdio_sg_one_sbale(sg_resp)) {
+	if (zfcp_qdio_sg_one_sbale(sg_req) && zfcp_qdio_sg_one_sbale(sg_resp)) {
 		zfcp_fsf_setup_ct_els_unchained(adapter->qdio, &req->qdio_req,
 						sg_req, sg_resp);
 		return 0;

