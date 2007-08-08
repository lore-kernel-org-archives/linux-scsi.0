From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 4/4] zfcp: fix the data buffer accessor patch
Date: Wed, 8 Aug 2007 10:47:26 +0200
Message-ID: <200708081047.26905.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:9919 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689AbXHHIp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 04:45:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix the data buffer accessor patch.

For request without a data buffer nothing was written into
a SBALE.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux_jb/drivers/s390/scsi/zfcp_qdio.c
===================================================================
--- linux_jb.orig/drivers/s390/scsi/zfcp_qdio.c
+++ linux_jb/drivers/s390/scsi/zfcp_qdio.c
@@ -640,13 +640,9 @@ int
 zfcp_qdio_sbals_from_scsicmnd(struct zfcp_fsf_req *fsf_req,
 			      unsigned long sbtype, struct scsi_cmnd *scsi_cmnd)
 {
-	if (scsi_sg_count(scsi_cmnd))
-		return zfcp_qdio_sbals_from_sg(fsf_req,	sbtype,
-					       scsi_sglist(scsi_cmnd),
-					       scsi_sg_count(scsi_cmnd),
-					       ZFCP_MAX_SBALS_PER_REQ);
-	else
-		return 0;
+	return zfcp_qdio_sbals_from_sg(fsf_req,	sbtype, scsi_sglist(scsi_cmnd),
+				       scsi_sg_count(scsi_cmnd),
+				       ZFCP_MAX_SBALS_PER_REQ);
 }
 
 /**
