From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/6] zfcp: returning an ERR_PTR where a NULL value is expected
Date: Wed, 26 Nov 2008 18:07:37 +0100
Message-ID: <20081126171019.703658000@de.ibm.com>
References: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46480 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYKZRKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:22 -0500
Content-Disposition: inline; filename=710-zfcp-err-ptr.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Aborting a SCSI cmnd might requrie to send a abort_fsf_cmnd. If the 
creation of this fsf_req fails an ERR_PTR is returned where a NULL
value would be expected as an error indicator. This ERR_PTR is 
dereferenced as valid fsf_req in succeeding processing leading to
an error.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-11-26 16:42:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-11-26 16:42:38.000000000 +0100
@@ -930,8 +930,10 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
 				  req_flags, adapter->pool.fsf_req_abort);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		req = NULL;
 		goto out;
+	}
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
@@ -2443,8 +2445,10 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		req = NULL;
 		goto out;
+	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
 	req->data = unit;

-- 
