From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/5] lpfc 10.2.8001.0: Fix ExpressLane priority setup
Date: Mon, 12 May 2014 11:53:34 -0400
Message-ID: <1399910014.25346.11.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:59276 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaELPxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2014 11:53:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix ExpressLane priority setup


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    2 +-
 lpfc_sli.c  |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2014-05-12 09:45:34.438083588 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2014-05-12 09:49:39.269095920 -0400
@@ -4660,7 +4660,7 @@ LPFC_ATTR_R(EnableXLane, 0, 0, 1, "Enabl
 #       0x0 - 0x7f  = CS_CTL field in FC header (high 7 bits)
 # Value range is [0x0,0x7f]. Default value is 0
 */
-LPFC_ATTR_R(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
+LPFC_ATTR_RW(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
 
 /*
 # lpfc_enable_bg: Enable BlockGuard (Emulex's Implementation of T10-DIF)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-05-12 09:49:36.984095804 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-05-12 09:49:39.279095920 -0400
@@ -8185,6 +8185,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	abort_tag = (uint32_t) iocbq->iotag;
 	xritag = iocbq->sli4_xritag;
 	wqe->generic.wqe_com.word7 = 0; /* The ct field has moved so reset */
+	wqe->generic.wqe_com.word10 = 0;
 	/* words0-2 bpl convert bde */
 	if (iocbq->iocb.un.genreq64.bdl.bdeFlags == BUFF_TYPE_BLP_64) {
 		numBdes = iocbq->iocb.un.genreq64.bdl.bdeSize /



