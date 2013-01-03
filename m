From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/11] lpfc 8.3.37: Fixed crash due to SLI Port invalid
 resource count
Date: Thu, 3 Jan 2013 15:44:09 -0500
Message-ID: <1357245849.2628.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:27044 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3ACUty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:49:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system crash due to SLI Port provisioning of invalid resource count


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:08.951087785 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:10.046087810 -0500
@@ -5639,6 +5639,13 @@ lpfc_sli4_alloc_resource_identifiers(str
 		}
 		/* RPIs. */
 		count = phba->sli4_hba.max_cfg_param.max_rpi;
+		if (count <= 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"3279 Invalid provisioning of "
+					"rpi:%d\n", count);
+			rc = -EINVAL;
+			goto err_exit;
+		}
 		base = phba->sli4_hba.max_cfg_param.rpi_base;
 		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
 		phba->sli4_hba.rpi_bmask = kzalloc(longs *
@@ -5661,6 +5668,13 @@ lpfc_sli4_alloc_resource_identifiers(str
 
 		/* VPIs. */
 		count = phba->sli4_hba.max_cfg_param.max_vpi;
+		if (count <= 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"3280 Invalid provisioning of "
+					"vpi:%d\n", count);
+			rc = -EINVAL;
+			goto free_rpi_ids;
+		}
 		base = phba->sli4_hba.max_cfg_param.vpi_base;
 		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
 		phba->vpi_bmask = kzalloc(longs *
@@ -5683,6 +5697,13 @@ lpfc_sli4_alloc_resource_identifiers(str
 
 		/* XRIs. */
 		count = phba->sli4_hba.max_cfg_param.max_xri;
+		if (count <= 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"3281 Invalid provisioning of "
+					"xri:%d\n", count);
+			rc = -EINVAL;
+			goto free_vpi_ids;
+		}
 		base = phba->sli4_hba.max_cfg_param.xri_base;
 		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
 		phba->sli4_hba.xri_bmask = kzalloc(longs *
@@ -5706,6 +5727,13 @@ lpfc_sli4_alloc_resource_identifiers(str
 
 		/* VFIs. */
 		count = phba->sli4_hba.max_cfg_param.max_vfi;
+		if (count <= 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"3282 Invalid provisioning of "
+					"vfi:%d\n", count);
+			rc = -EINVAL;
+			goto free_xri_ids;
+		}
 		base = phba->sli4_hba.max_cfg_param.vfi_base;
 		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
 		phba->sli4_hba.vfi_bmask = kzalloc(longs *



