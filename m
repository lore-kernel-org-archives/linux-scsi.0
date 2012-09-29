From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/16] lpfc 8.3.35: Fix error with fabric service parameters
 causing performance issues
Date: Sat, 29 Sep 2012 11:32:27 -0400
Message-ID: <1348932747.23909.33.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33797 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab2I2PiA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:38:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix error with fabric service parameters causing performance issues


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    2 ++
 1 file changed, 2 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-09-26 21:11:41.195154018 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-09-26 21:11:59.119154426 -0400
@@ -809,6 +809,8 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vp
 	phba->fc_ratov = FF_DEF_RATOV;
 	rc = memcmp(&vport->fc_portname, &sp->portName,
 		    sizeof(vport->fc_portname));
+	memcpy(&phba->fc_fabparam, sp, sizeof(struct serv_parm));
+
 	if (rc >= 0) {
 		/* This side will initiate the PLOGI */
 		spin_lock_irq(shost->host_lock);



