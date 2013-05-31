From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/17] lpfc 8.3.40: Fix starting reference tag when
 calculating BG error
Date: Fri, 31 May 2013 17:04:10 -0400
Message-ID: <1370034250.17258.28.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5790 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3EaVKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:10:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix starting reference tag when calculating BG error


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-05-31 10:58:12.310057503 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-05-31 10:58:17.946057631 -0400
@@ -3088,9 +3088,9 @@ lpfc_calc_bg_err(struct lpfc_hba *phba,
 			chk_guard = 1;
 		guard_type = scsi_host_get_guard(cmd->device->host);
 
+		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		start_ref_tag = (uint32_t)scsi_get_lba(cmd); /* Truncate LBA */
 		start_app_tag = src->app_tag;
-		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		len = sgpe->length;
 		while (src && protsegcnt) {
 			while (len) {



