From: James Smart <james.smart@emulex.com>
Subject: [PATCH 20/22] lpfc 8.3.39: Reduced tmo value set to FLOGI WQE for
 quick recovery from FLOGI sequence timeout
Date: Wed, 17 Apr 2013 20:19:44 -0400
Message-ID: <1366244384.1513.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15696 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DRATt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:19:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reduced tmo value set to FLOGI WQE for quick recovery from FLOGI sequence timeout


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |    9 ++++++---
 lpfc_hbadisc.c |    7 +++++--
 lpfc_sli.c     |   11 ++++++-----
 3 files changed, 17 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-04-15 18:26:54.238041512 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-04-15 18:26:55.598041544 -0400
@@ -239,7 +239,10 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 
 		icmd->un.elsreq64.remoteID = did;		/* DID */
 		icmd->ulpCommand = CMD_ELS_REQUEST64_CR;
-		icmd->ulpTimeout = phba->fc_ratov * 2;
+		if (elscmd == ELS_CMD_FLOGI)
+			icmd->ulpTimeout = FF_DEF_RATOV * 2;
+		else
+			icmd->ulpTimeout = phba->fc_ratov * 2;
 	} else {
 		icmd->un.xseq64.bdl.addrHigh = putPaddrHigh(pbuflist->phys);
 		icmd->un.xseq64.bdl.addrLow = putPaddrLow(pbuflist->phys);
@@ -1086,8 +1089,8 @@ stop_rr_fcf_flogi:
 
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0101 FLOGI completes successfully "
-			 "Data: x%x x%x x%x x%x x%x x%x\n",
+			 "0101 FLOGI completes successfully, I/O tag:x%x, "
+			 "Data: x%x x%x x%x x%x x%x x%x\n", cmdiocb->iotag,
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution,
 			 vport->port_state, vport->fc_flag);
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:44.695041295 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:55.603041543 -0400
@@ -2272,8 +2272,11 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 				spin_unlock_irq(&phba->hbalock);
 				lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
 						"2836 New FCF matches in-use "
-						"FCF (x%x)\n",
-						phba->fcf.current_rec.fcf_indx);
+						"FCF (x%x), port_state:x%x, "
+						"fc_flag:x%x\n",
+						phba->fcf.current_rec.fcf_indx,
+						phba->pport->port_state,
+						phba->pport->fc_flag);
 				goto out;
 			} else
 				lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:52.730041478 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:55.615041544 -0400
@@ -13991,13 +13991,14 @@ lpfc_fc_frame_check(struct lpfc_hba *phb
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"2538 Received frame rctl:%s type:%s "
-			"Frame Data:%08x %08x %08x %08x %08x %08x\n",
-			rctl_names[fc_hdr->fh_r_ctl],
-			type_names[fc_hdr->fh_type],
+			"2538 Received frame rctl:%s (x%x), type:%s (x%x), "
+			"frame Data:%08x %08x %08x %08x %08x %08x %08x\n",
+			rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
+			type_names[fc_hdr->fh_type], fc_hdr->fh_type,
 			be32_to_cpu(header[0]), be32_to_cpu(header[1]),
 			be32_to_cpu(header[2]), be32_to_cpu(header[3]),
-			be32_to_cpu(header[4]), be32_to_cpu(header[5]));
+			be32_to_cpu(header[4]), be32_to_cpu(header[5]),
+			be32_to_cpu(header[6]));
 	return 0;
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,



