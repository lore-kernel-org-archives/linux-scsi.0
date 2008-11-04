From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 7/8] zfcp: fix erp timeout cleanup for port open requests
Date: Tue, 04 Nov 2008 16:35:11 +0100
Message-ID: <20081104153630.280169000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:53224 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYKDPgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:36:33 -0500
Content-Disposition: inline; filename=708-zfcp-erp-timeout.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin.petermann@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin.petermann@de.ibm.com>

If an open port fsf request times out (in erp) the 
corresponding erp_action member of the fsf 
request need to set to NULL. If the port structure
will be removed later-on there will be still a 
reference in the fsf request to the non existing
erp_action otherwise.

Signed-off-by: Martin Petermann <martin.petermann@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-11-04 14:44:04.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-11-04 14:44:29.000000000 +0100
@@ -472,6 +472,7 @@ static void zfcp_erp_strategy_check_fsfr
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			act->fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
 			zfcp_rec_dbf_event_action(142, act);
+			act->fsf_req->erp_action = NULL;
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			zfcp_rec_dbf_event_action(143, act);

-- 
