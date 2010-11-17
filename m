From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/5] zfcp: Correct false abort data assignment.
Date: Wed, 17 Nov 2010 14:23:41 +0100
Message-ID: <20101117132655.856976821@de.ibm.com>
References: <20101117132339.429099463@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:60921 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0KQN05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 08:26:57 -0500
Content-Disposition: inline; filename=706-zfcp-false-abort.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The request data assignment between the fsf abort initiator and its
corresponding handler is not consistent and leads to an unpredictable
behaviour, e.g. kernel panic.  This patch fixes this issue and assigns
the correct value.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -851,7 +851,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	req->data = zfcp_sdev;
+	req->data = sdev;
 	req->handler = zfcp_fsf_abort_fcp_command_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;

