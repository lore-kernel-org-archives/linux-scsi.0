From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/12] lpfc 8.3.34: Add XRI to abort handler timeout log
 message
Date: Tue, 14 Aug 2012 14:26:13 -0400
Message-ID: <1344968773.4432.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24944 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab2HNS0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add XRI to abort handler timeout log message


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.312924252 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.431924247 -0400
@@ -4502,9 +4502,10 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		ret = FAILED;
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0748 abort handler timed out waiting "
-				 "for abort to complete: ret %#x, ID %d, "
-				 "LUN %d\n",
-				 ret, cmnd->device->id, cmnd->device->lun);
+				 "for abortng I/O (xri:x%x) to complete: "
+				 "ret %#x, ID %d, LUN %d\n",
+				 iocb->sli4_xritag, ret,
+				 cmnd->device->id, cmnd->device->lun);
 	}
 	goto out;
 



