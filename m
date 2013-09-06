From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/18] lpfc 8.3.42: Fixed not able to log informational
 messages at early stage of driver init time
Date: Fri, 6 Sep 2013 12:18:28 -0400
Message-ID: <1378484308.14051.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22766 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IFQTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:19:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed not able to log informational messages at early stage of driver init time


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:03:59.775058208 -0400
@@ -4859,6 +4859,9 @@ lpfc_sli4_driver_resource_setup(struct l
 	struct lpfc_mqe *mqe;
 	int longs;
 
+	/* Get all the module params for configuring this host */
+	lpfc_get_cfgparam(phba);
+
 	/* Before proceed, wait for POST done and device ready */
 	rc = lpfc_sli4_post_status_check(phba);
 	if (rc)
@@ -4902,15 +4905,6 @@ lpfc_sli4_driver_resource_setup(struct l
 		sizeof(struct lpfc_mbox_ext_buf_ctx));
 	INIT_LIST_HEAD(&phba->mbox_ext_buf_ctx.ext_dmabuf_list);
 
-	/*
-	 * We need to do a READ_CONFIG mailbox command here before
-	 * calling lpfc_get_cfgparam. For VFs this will report the
-	 * MAX_XRI, MAX_VPI, MAX_RPI, MAX_IOCB, and MAX_VFI settings.
-	 * All of the resources allocated
-	 * for this Port are tied to these values.
-	 */
-	/* Get all the module params for configuring this host */
-	lpfc_get_cfgparam(phba);
 	phba->max_vpi = LPFC_MAX_VPI;
 
 	/* This will be set to correct value after the read_config mbox */



