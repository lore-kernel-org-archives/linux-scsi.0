From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/17] lpfc 8.3.40: Fixed system panic during handling
 unsolicited receive buffer error condition
Date: Fri, 31 May 2013 17:03:48 -0400
Message-ID: <1370034228.17258.26.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5782 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3EaVKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:10:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system panic during handling unsolicited receive buffer error condition


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:14.126057545 -0400
@@ -3279,7 +3279,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_h
 		if (free_saveq) {
 			list_for_each_entry_safe(rspiocbp, next_iocb,
 						 &saveq->list, list) {
-				list_del(&rspiocbp->list);
+				list_del_init(&rspiocbp->list);
 				__lpfc_sli_release_iocbq(phba, rspiocbp);
 			}
 			__lpfc_sli_release_iocbq(phba, saveq);



