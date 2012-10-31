From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/7] lpfc 8.3.36: Correct mask error
Date: Wed, 31 Oct 2012 14:45:21 -0400
Message-ID: <1351709121.957.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47852 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2JaSqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:46:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct mask error

Reported via: https://bugzilla.kernel.org/show_bug.cgi?id=48891


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2012-10-31 12:48:37.064123712 -0400
@@ -634,7 +634,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 			if (irsp->ulpStatus != IOSTAT_LOCAL_REJECT ||
-			    (irsp->un.ulpWord[4] && IOERR_PARAM_MASK) !=
+			    (irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
 			    IOERR_NO_RESOURCES)
 				vport->fc_ns_retry++;
 



