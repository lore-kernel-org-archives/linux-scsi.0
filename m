From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/21] lpfc 8.3.30: Fix SLI4 driver module load and unload
Date: Thu, 1 Mar 2012 22:35:58 -0500
Message-ID: <1330659360.18500.35.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38854 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756988Ab2CBDgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:36:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed SLI4 driver module load and unload test in a loop
 crashes the system (CR: 126397)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:42.000000000 -0500
@@ -5821,10 +5821,9 @@ lpfc_sli4_post_status_check(struct lpfc_
 					readl(phba->sli4_hba.u.if_type2.
 					      ERR2regaddr);
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2888 Port Error Detected "
-					"during POST: "
-					"port status reg 0x%x, "
-					"port_smphr reg 0x%x, "
+					"2888 Unrecoverable port error "
+					"following POST: port status reg "
+					"0x%x, port_smphr reg 0x%x, "
 					"error 1=0x%x, error 2=0x%x\n",
 					reg_data.word0,
 					portsmphr_reg.word0,
@@ -7279,7 +7278,8 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			       LPFC_SLIPORT_INIT_PORT);
 			writel(reg_data.word0, phba->sli4_hba.u.if_type2.
 			       CTRLregaddr);
-
+			/* flush */
+			readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
 			/*
 			 * Poll the Port Status Register and wait for RDY for
 			 * up to 10 seconds.  If the port doesn't respond, treat
@@ -7317,11 +7317,10 @@ lpfc_pci_function_reset(struct lpfc_hba 
 				phba->work_status[1] = readl(
 					phba->sli4_hba.u.if_type2.ERR2regaddr);
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2890 Port Error Detected "
-					"during Port Reset: "
-					"port status reg 0x%x, "
+					"2890 Port error detected during port "
+					"reset(%d): port status reg 0x%x, "
 					"error 1=0x%x, error 2=0x%x\n",
-					reg_data.word0,
+					num_resets, reg_data.word0,
 					phba->work_status[0],
 					phba->work_status[1]);
 				rc = -ENODEV;



