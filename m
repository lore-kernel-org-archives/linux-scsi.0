From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/7 V2] lpfc 8.3.44: Fixed incorrect allocation of iDiags
 directories/files in debugfs
Date: Tue, 17 Dec 2013 20:29:59 -0500
Message-ID: <1387330199.1011.13.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:22611 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3LRBaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 20:30:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed incorrect allocation of iDiags directories/files in debugfs


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2013-12-02 11:52:17.571242177 -0500
@@ -3927,6 +3927,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	struct lpfc_hba   *phba = vport->phba;
 	char name[64];
 	uint32_t num, i;
+	bool pport_setup = false;
 
 	if (!lpfc_debugfs_enable)
 		return;
@@ -3947,6 +3948,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	/* Setup funcX directory for specific HBA PCI function */
 	snprintf(name, sizeof(name), "fn%d", phba->brd_no);
 	if (!phba->hba_debugfs_root) {
+		pport_setup = true;
 		phba->hba_debugfs_root =
 			debugfs_create_dir(name, lpfc_debugfs_root);
 		if (!phba->hba_debugfs_root) {
@@ -4239,6 +4241,14 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	}
 
 	/*
+	 * The following section is for additional directories/files for the
+	 * physical port.
+	 */
+
+	if (!pport_setup)
+		goto debug_failed;
+
+	/*
 	 * iDiag debugfs root entry points for SLI4 device only
 	 */
 	if (phba->sli_rev < LPFC_SLI_REV4)


