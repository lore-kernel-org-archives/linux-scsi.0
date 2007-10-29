From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc : Correct queue tag handling
Date: Mon, 29 Oct 2007 11:00:39 -0400
Message-ID: <1193670039.12766.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65257 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbXJ2PAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 11:00:45 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9TF0SOI007904
	for <linux-scsi@vger.kernel.org>; Mon, 29 Oct 2007 08:00:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch corrects the lpfc tag handling issue identified by Hannes Reinecke
http://marc.info/?l=linux-scsi@m=119270235628850&w=2

The basis for this patch originated from Hajime Kai. Thank You Hajime.

-- james s

Signed-off-by: hajime-kai@soft.fujitsu.com
Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-10-19 09:09:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-10-29 10:17:49.000000000 -0400
@@ -682,6 +682,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	struct lpfc_iocbq *piocbq = &(lpfc_cmd->cur_iocbq);
 	int datadir = scsi_cmnd->sc_data_direction;
+	char tag[2];
 
 	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
 	/* clear task management bits */
@@ -692,8 +693,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 
 	memcpy(&fcp_cmnd->fcpCdb[0], scsi_cmnd->cmnd, 16);
 
-	if (scsi_cmnd->device->tagged_supported) {
-		switch (scsi_cmnd->tag) {
+	if (scsi_populate_tag_msg(scsi_cmnd, tag)) {
+		switch (tag[0]) {
 		case HEAD_OF_QUEUE_TAG:
 			fcp_cmnd->fcpCntl1 = HEAD_OF_Q;
 			break;


