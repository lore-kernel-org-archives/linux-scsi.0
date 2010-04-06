From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/7] lpfc 8.3.12: Miscellaneous Changes
Date: Tue, 6 Apr 2010 14:49:03 -0400
Message-ID: <1270579783.19178.22.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15622 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757527Ab0DFSuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 14:50:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Prevent log message 1801 during vport delete.
- Enable NPIV by default.
- Display correct value for max Vports on SLI4 HBAs.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c  |   18 ++++++++++++------
 lpfc_vport.c |    4 +++-
 2 files changed, 15 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-04-06 14:38:22.000000000 -0400
@@ -868,6 +868,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
 	int rc = 0;
+	uint32_t max_vpi;
 
 	/*
 	 * prevent udev from issuing mailbox commands until the port is
@@ -915,11 +916,17 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		if (axri)
 			*axri = bf_get(lpfc_mbx_rd_conf_xri_count, rd_config) -
 					phba->sli4_hba.max_cfg_param.xri_used;
+
+		/* Account for differences with SLI-3.  Get vpi count from
+		 * mailbox data and subtract one for max vpi value.
+		 */
+		max_vpi = (bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) > 0) ?
+			(bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) - 1) : 0;
+
 		if (mvpi)
-			*mvpi = bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config);
+			*mvpi = max_vpi;
 		if (avpi)
-			*avpi = bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) -
-					phba->sli4_hba.max_cfg_param.vpi_used;
+			*avpi = max_vpi - phba->sli4_hba.max_cfg_param.vpi_used;
 	} else {
 		if (mrpi)
 			*mrpi = pmb->un.varRdConfig.max_rpi;
@@ -1924,13 +1931,12 @@ MODULE_PARM_DESC(lpfc_sli_mode, "SLI mod
 		 " 2 - select SLI-2 even on SLI-3 capable HBAs,"
 		 " 3 - select SLI-3");
 
-int lpfc_enable_npiv = 0;
+int lpfc_enable_npiv = 1;
 module_param(lpfc_enable_npiv, int, 0);
 MODULE_PARM_DESC(lpfc_enable_npiv, "Enable NPIV functionality");
 lpfc_param_show(enable_npiv);
 lpfc_param_init(enable_npiv, 1, 0, 1);
-static DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO,
-			 lpfc_enable_npiv_show, NULL);
+static DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO, lpfc_enable_npiv_show, NULL);
 
 /*
 # lpfc_suppress_link_up:  Bring link up at initialization
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-04-06 14:39:29.000000000 -0400
@@ -762,7 +762,9 @@ lpfc_create_vport_work_array(struct lpfc
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
 		if (!scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
-			lpfc_printf_vlog(port_iterator, KERN_WARNING, LOG_VPORT,
+			if (!(port_iterator->load_flag & FC_UNLOADING))
+				lpfc_printf_vlog(port_iterator, KERN_ERR,
+					 LOG_VPORT,
 					 "1801 Create vport work array FAILED: "
 					 "cannot do scsi_host_get\n");
 			continue;


