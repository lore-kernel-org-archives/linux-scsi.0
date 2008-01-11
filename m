From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/10] lpfc 8.2.4 : Miscellaneous Fixes
Date: Fri, 11 Jan 2008 01:52:54 -0500
Message-ID: <1200034374.27954.21.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51523 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYAKGxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:53:07 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6r5iv021656
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:53:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Fixes:
- Fix a couple of sparse complaints
- Reset the FCP recovery flag when the node is not a FCP2 device.
- Speed up offline prep delays
- Fixed a memory leak in lpfc_mem_alloc failure path
- Fixed external loopback test.
- Fixed error code returned from the driver when HBA is over heated.
- Correct Max NPIV vport to limits read from adapter
- Add missing locks around fc_flag and FC_NEEDS_REG_VPI
- Add missing hba ids for device identification
- Added support for SET_VARIABLE and MBX_WRITE_WWN mailbox commands
- Changed all temperature event messages from warning to error
- Fix reporting of link speed when link is down
- Added support for MBX_WRITE_WWN mailbox command 
- Change del_timer_sync() in ISR to del_timer() in interrupt handler
- Correct instances of beXX_to_cpu() that should be cpu_to_beXX()
- Perform target flush before releasing node references on module unload
- Avoid bogus devloss_tmo messages when driver unloads
- Fix panic when HBA generates ERATT interupt
- Fix mbox race condition and a workaround on back-to-back mailbox commands
- Force NPIV off for pt2pt mode between 2 NPorts
- Stop worker thread before removing fc_host.
- Fix up discovery timeout error case due to missing clear_la
- Tighten mailbox polling code to speed up detection of fast completions
- Only allow DUMP_MEMORY if adapter offline due to overtemp errors
- Added extended error information to the log messages in chip init.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-01-11 00:53:19.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-01-11 01:04:21.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -311,12 +311,14 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 
 	psli = &phba->sli;
 
+	/* Wait a little for things to settle down, but not
+	 * long enough for dev loss timeout to expire.
+	 */
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
-		/* The linkdown event takes 30 seconds to timeout. */
 		while (pring->txcmplq_cnt) {
 			msleep(10);
-			if (cnt++ > 3000) {
+			if (cnt++ > 500) {  /* 5 secs */
 				lpfc_printf_log(phba,
 					KERN_WARNING, LOG_INIT,
 					"0466 Outstanding IO when "
@@ -989,7 +991,7 @@ lpfc_soft_wwpn_store(struct class_device
 	spin_lock_irq(&phba->hbalock);
 	if (phba->over_temp_state == HBA_OVER_TEMP) {
 		spin_unlock_irq(&phba->hbalock);
-		return -EPERM;
+		return -EACCES;
 	}
 	spin_unlock_irq(&phba->hbalock);
 	/* count may include a LF at end of string */
@@ -1782,7 +1784,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 	if (phba->over_temp_state == HBA_OVER_TEMP) {
 		sysfs_mbox_idle(phba);
 		spin_unlock_irq(&phba->hbalock);
-		return  -EPERM;
+		return  -EACCES;
 	}
 
 	if (off == 0 &&
@@ -1801,9 +1803,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 		case MBX_DUMP_CONTEXT:
 		case MBX_RUN_DIAGS:
 		case MBX_RESTART:
-		case MBX_FLASH_WR_ULA:
 		case MBX_SET_MASK:
-		case MBX_SET_SLIM:
 		case MBX_SET_DEBUG:
 			if (!(vport->fc_flag & FC_OFFLINE_MODE)) {
 				printk(KERN_WARNING "mbox_read:Command 0x%x "
@@ -1831,6 +1831,8 @@ sysfs_mbox_read(struct kobject *kobj, st
 		case MBX_LOAD_EXP_ROM:
 		case MBX_BEACON:
 		case MBX_DEL_LD_ENTRY:
+		case MBX_SET_VARIABLE:
+		case MBX_WRITE_WWN:
 			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:
@@ -1852,6 +1854,17 @@ sysfs_mbox_read(struct kobject *kobj, st
 			return -EPERM;
 		}
 
+		/* If HBA encountered an error attention, allow only DUMP
+		 * mailbox command until the HBA is restarted.
+		 */
+		if ((phba->pport->stopped) &&
+			(phba->sysfs_mbox.mbox->mb.mbxCommand
+				!= MBX_DUMP_MEMORY)) {
+			sysfs_mbox_idle(phba);
+			spin_unlock_irq(&phba->hbalock);
+			return -EPERM;
+		}
+
 		phba->sysfs_mbox.mbox->vport = vport;
 
 		if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
@@ -2052,7 +2065,8 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 				fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
 		}
-	}
+	} else
+		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 
 	spin_unlock_irq(shost->host_lock);
 }
@@ -2072,7 +2086,7 @@ lpfc_get_host_fabric_name (struct Scsi_H
 		node_name = wwn_to_u64(phba->fc_fabparam.nodeName.u.wwn);
 	else
 		/* fabric is local port if there is no F/FL_Port */
-		node_name = wwn_to_u64(vport->fc_nodename.u.wwn);
+		node_name = 0;
 
 	spin_unlock_irq(shost->host_lock);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 01:04:08.000000000 -0500
@@ -19,7 +19,7 @@
  *******************************************************************/
 
 /*
- * Fibre Channel SCSI LAN Device Driver CT support
+ * Fibre Channel SCSI LAN Device Driver CT support: FC Generic Services FC-GS
  */
 
 #include <linux/blkdev.h>
@@ -203,7 +203,7 @@ lpfc_alloc_ct_rsp(struct lpfc_hba *phba,
 	struct lpfc_dmabuf *mp;
 	int cnt, i = 0;
 
-	/* We get chucks of FCELSSIZE */
+	/* We get chunks of FCELSSIZE */
 	cnt = size > FCELSSIZE ? FCELSSIZE: size;
 
 	while (size) {
@@ -1175,7 +1175,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 	case SLI_CTNS_GFF_ID:
 		CtReq->CommandResponse.bits.CmdRsp =
 			be16_to_cpu(SLI_CTNS_GFF_ID);
-		CtReq->un.gff.PortId = be32_to_cpu(context);
+		CtReq->un.gff.PortId = cpu_to_be32(context);
 		cmpl = lpfc_cmpl_ct_cmd_gff_id;
 		break;
 
@@ -1183,7 +1183,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		vport->ct_flags &= ~FC_CT_RFT_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFT_ID);
-		CtReq->un.rft.PortId = be32_to_cpu(vport->fc_myDID);
+		CtReq->un.rft.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rft.fcpReg = 1;
 		cmpl = lpfc_cmpl_ct_cmd_rft_id;
 		break;
@@ -1192,7 +1192,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		vport->ct_flags &= ~FC_CT_RNN_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RNN_ID);
-		CtReq->un.rnn.PortId = be32_to_cpu(vport->fc_myDID);
+		CtReq->un.rnn.PortId = cpu_to_be32(vport->fc_myDID);
 		memcpy(CtReq->un.rnn.wwnn,  &vport->fc_nodename,
 		       sizeof (struct lpfc_name));
 		cmpl = lpfc_cmpl_ct_cmd_rnn_id;
@@ -1202,7 +1202,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		vport->ct_flags &= ~FC_CT_RSPN_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RSPN_ID);
-		CtReq->un.rspn.PortId = be32_to_cpu(vport->fc_myDID);
+		CtReq->un.rspn.PortId = cpu_to_be32(vport->fc_myDID);
 		size = sizeof(CtReq->un.rspn.symbname);
 		CtReq->un.rspn.len =
 			lpfc_vport_symbolic_port_name(vport,
@@ -1225,14 +1225,14 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		/* Implement DA_ID Nameserver request */
 		CtReq->CommandResponse.bits.CmdRsp =
 			be16_to_cpu(SLI_CTNS_DA_ID);
-		CtReq->un.da_id.port_id = be32_to_cpu(vport->fc_myDID);
+		CtReq->un.da_id.port_id = cpu_to_be32(vport->fc_myDID);
 		cmpl = lpfc_cmpl_ct_cmd_da_id;
 		break;
 	case SLI_CTNS_RFF_ID:
 		vport->ct_flags &= ~FC_CT_RFF_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
-		CtReq->un.rff.PortId = be32_to_cpu(vport->fc_myDID);;
+		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);;
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
 		CtReq->un.rff.type_code = FC_FCP_DATA;
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-01-11 01:04:12.000000000 -0500
@@ -18,7 +18,7 @@
  * more details, a copy of which can be found in the file COPYING  *
  * included with this package.                                     *
  *******************************************************************/
-
+/* See Fibre Channel protocol T11 FC-LS for details */
 #include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
@@ -392,11 +392,12 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		}
 		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 			lpfc_mbx_unreg_vpi(vport);
+			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			spin_unlock_irq(shost->host_lock);
 		}
 	}
 
-	ndlp->nlp_sid = irsp->un.ulpWord[4] & Mask_DID;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 
 	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED &&
@@ -484,6 +485,9 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vp
 		lpfc_nlp_put(ndlp);
 	}
 
+	/* If we are pt2pt with another NPort, force NPIV off! */
+	phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
+
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_PT2PT;
 	spin_unlock_irq(shost->host_lock);
@@ -2068,7 +2072,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	return 0;
 }
 
-int
+static int
 lpfc_els_free_data(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr1)
 {
 	struct lpfc_dmabuf *buf_ptr;
@@ -2086,7 +2090,7 @@ lpfc_els_free_data(struct lpfc_hba *phba
 	return 0;
 }
 
-int
+static int
 lpfc_els_free_bpl(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr)
 {
 	lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
@@ -2976,10 +2980,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 			"RCV RSCN defer:  did:x%x/ste:x%x flg:x%x",
 			ndlp->nlp_DID, vport->port_state, ndlp->nlp_flag);
 
+		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_RSCN_DEFERRED;
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
-			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_RSCN_MODE;
 			spin_unlock_irq(shost->host_lock);
 			if (rscn_cnt) {
@@ -3008,7 +3012,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 					 vport->fc_rscn_id_cnt, vport->fc_flag,
 					 vport->port_state);
 		} else {
-			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_RSCN_DISCOVERY;
 			spin_unlock_irq(shost->host_lock);
 			/* ReDiscovery RSCN */
@@ -3023,7 +3026,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 
 		/* send RECOVERY event for ALL nodes that match RSCN payload */
 		lpfc_rscn_recovery_check(vport);
+		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~FC_RSCN_DEFERRED;
+		spin_unlock_irq(shost->host_lock);
 		return 0;
 	}
 
@@ -3307,13 +3312,13 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 		status |= 0x4;
 
 	rps_rsp->rsvd1 = 0;
-	rps_rsp->portStatus = be16_to_cpu(status);
-	rps_rsp->linkFailureCnt = be32_to_cpu(mb->un.varRdLnk.linkFailureCnt);
-	rps_rsp->lossSyncCnt = be32_to_cpu(mb->un.varRdLnk.lossSyncCnt);
-	rps_rsp->lossSignalCnt = be32_to_cpu(mb->un.varRdLnk.lossSignalCnt);
-	rps_rsp->primSeqErrCnt = be32_to_cpu(mb->un.varRdLnk.primSeqErrCnt);
-	rps_rsp->invalidXmitWord = be32_to_cpu(mb->un.varRdLnk.invalidXmitWord);
-	rps_rsp->crcCnt = be32_to_cpu(mb->un.varRdLnk.crcCnt);
+	rps_rsp->portStatus = cpu_to_be16(status);
+	rps_rsp->linkFailureCnt = cpu_to_be32(mb->un.varRdLnk.linkFailureCnt);
+	rps_rsp->lossSyncCnt = cpu_to_be32(mb->un.varRdLnk.lossSyncCnt);
+	rps_rsp->lossSignalCnt = cpu_to_be32(mb->un.varRdLnk.lossSignalCnt);
+	rps_rsp->primSeqErrCnt = cpu_to_be32(mb->un.varRdLnk.primSeqErrCnt);
+	rps_rsp->invalidXmitWord = cpu_to_be32(mb->un.varRdLnk.invalidXmitWord);
+	rps_rsp->crcCnt = cpu_to_be32(mb->un.varRdLnk.crcCnt);
 	/* Xmit ELS RPS ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_ELS,
 			 "0118 Xmit ELS RPS ACC response tag x%x xri x%x, "
@@ -4276,7 +4281,9 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 	MAILBOX_t *mb = &pmb->mb;
 
+	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(shost->host_lock);
 	lpfc_nlp_put(ndlp);
 
 	if (mb->mbxStatus) {
@@ -4297,7 +4304,9 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 		default:
 			/* Try to recover from this error */
 			lpfc_mbx_unreg_vpi(vport);
+			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			spin_unlock_irq(shost->host_lock);
 			lpfc_initial_fdisc(vport);
 			break;
 		}
@@ -4316,6 +4325,7 @@ static void
 lpfc_register_new_vport(struct lpfc_hba *phba, struct lpfc_vport *vport,
 			struct lpfc_nodelist *ndlp)
 {
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	LPFC_MBOXQ_t *mbox;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -4327,7 +4337,9 @@ lpfc_register_new_vport(struct lpfc_hba 
 		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 		    == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
+			spin_lock_irq(shost->host_lock);
 			vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+			spin_unlock_irq(shost->host_lock);
 
 			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
@@ -4339,7 +4351,9 @@ lpfc_register_new_vport(struct lpfc_hba 
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 				 "0254 Register VPI: no memory\n");
 
+		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+		spin_unlock_irq(shost->host_lock);
 		lpfc_nlp_put(ndlp);
 	}
 }
@@ -4412,7 +4426,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 				lpfc_unreg_rpi(vport, np);
 			}
 			lpfc_mbx_unreg_vpi(vport);
+			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			spin_unlock_irq(shost->host_lock);
 		}
 
 		if (vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-01-11 00:53:19.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-01-11 01:03:53.000000000 -0500
@@ -559,8 +559,7 @@ struct lpfc_hba {
 	struct list_head port_list;
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
 	uint16_t max_vpi;		/* Maximum virtual nports */
-#define LPFC_MAX_VPI 100		/* Max number of VPI supported */
-#define LPFC_MAX_VPORTS (LPFC_MAX_VPI+1)/* Max number of VPorts supported */
+#define LPFC_MAX_VPI 0xFFFF		/* Max number of VPI supported */
 	unsigned long *vpi_bmask;	/* vpi allocation table */
 
 	/* Data structure used by fabric iocb scheduler */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-01-11 01:04:18.000000000 -0500
@@ -114,15 +114,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
-
-	if (!ndlp) {
-		if (rport->scsi_target_id != -1) {
-			printk(KERN_ERR "Cannot find remote node"
-				" for rport in dev_loss_tmo_callbk x%x\n",
-				rport->port_id);
-		}
+	if (!ndlp)
 		return;
-	}
 
 	vport = ndlp->vport;
 	phba  = vport->phba;
@@ -202,6 +195,12 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	 * appropriately we just need to cleanup the ndlp rport info here.
 	 */
 	if (vport->load_flag & FC_UNLOADING) {
+		if (ndlp->nlp_sid != NLP_NO_SID) {
+			/* flush the target */
+			lpfc_sli_abort_iocb(vport,
+					&phba->sli.ring[phba->sli.fcp_ring],
+					ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+		}
 		put_node = rdata->pnode != NULL;
 		put_rport = ndlp->rport != NULL;
 		rdata->pnode = NULL;
@@ -381,7 +380,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 		lpfc_handle_latt(phba);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS; i++) {
+		for(i = 0; i <= phba->max_vpi; i++) {
 			/*
 			 * We could have no vports in array if unloading, so if
 			 * this happens then just use the pport
@@ -413,7 +412,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 			vport->work_port_events &= ~work_port_events;
 			spin_unlock_irq(&vport->work_port_lock);
 		}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
@@ -552,6 +551,7 @@ lpfc_workq_post_event(struct lpfc_hba *p
 void
 lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove)
 {
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 	int  rc;
@@ -575,7 +575,9 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 	}
 	if (phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) {
 		lpfc_mbx_unreg_vpi(vport);
+		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+		spin_unlock_irq(shost->host_lock);
 	}
 }
 
@@ -629,11 +631,11 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			/* Issue a LINK DOWN event to all nodes */
 			lpfc_linkdown_port(vports[i]);
 		}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 	/* Clean up any firmware default rpi's */
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mb) {
@@ -738,9 +740,9 @@ lpfc_linkup(struct lpfc_hba *phba)
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
 			lpfc_linkup_port(vports[i]);
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
 		lpfc_issue_clear_la(phba, phba->pport);
 
@@ -1319,7 +1321,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		vports = lpfc_create_vport_work_array(phba);
 		if (vports != NULL)
 			for(i = 0;
-			    i < LPFC_MAX_VPORTS && vports[i] != NULL;
+			    i <= phba->max_vpi && vports[i] != NULL;
 			    i++) {
 				if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
 					continue;
@@ -1335,7 +1337,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 							"Fabric support\n");
 				}
 			}
-		lpfc_destroy_vport_work_array(vports);
+		lpfc_destroy_vport_work_array(phba, vports);
 		lpfc_do_scr_ns_plogi(phba, vport);
 	}
 
@@ -1902,7 +1904,8 @@ lpfc_unreg_all_rpis(struct lpfc_vport *v
 		lpfc_unreg_login(phba, vport->vpi, 0xffff, mbox);
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		mbox->context1 = NULL;
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
 		if (rc == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
@@ -1921,7 +1924,8 @@ lpfc_unreg_default_rpis(struct lpfc_vpor
 		lpfc_unreg_did(phba, vport->vpi, 0xffffffff, mbox);
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		mbox->context1 = NULL;
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
 		if (rc == MBX_NOT_FINISHED) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
 					 "1815 Could not issue "
@@ -2026,7 +2030,7 @@ lpfc_nlp_remove(struct lpfc_vport *vport
 				mbox->mbox_flag |= LPFC_MBX_IMED_UNREG;
 				mbox->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;
 				mbox->vport = vport;
-				mbox->context2 = 0;
+				mbox->context2 = NULL;
 				rc =lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 				if (rc == MBX_NOT_FINISHED) {
 					mempool_free(mbox, phba->mbox_mem_pool);
@@ -2702,12 +2706,14 @@ restart_disc:
 		clrlaerr = 1;
 		break;
 
+	case LPFC_LINK_UP:
+		lpfc_issue_clear_la(phba, vport);
+		/* Drop thru */
 	case LPFC_LINK_UNKNOWN:
 	case LPFC_WARM_START:
 	case LPFC_INIT_START:
 	case LPFC_INIT_MBX_CMDS:
 	case LPFC_LINK_DOWN:
-	case LPFC_LINK_UP:
 	case LPFC_HBA_ERROR:
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				 "0230 Unexpected timeout, hba link "
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-01-11 01:04:05.000000000 -0500
@@ -1279,7 +1279,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_DEL_LD_ENTRY    0x1D
 #define MBX_RUN_PROGRAM     0x1E
 #define MBX_SET_MASK        0x20
-#define MBX_SET_SLIM        0x21
+#define MBX_SET_VARIABLE    0x21
 #define MBX_UNREG_D_ID      0x23
 #define MBX_KILL_BOARD      0x24
 #define MBX_CONFIG_FARP     0x25
@@ -1301,7 +1301,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_REG_VNPID	    0x96
 #define MBX_UNREG_VNPID	    0x97
 
-#define MBX_FLASH_WR_ULA    0x98
+#define MBX_WRITE_WWN       0x98
 #define MBX_SET_DEBUG       0x99
 #define MBX_LOAD_EXP_ROM    0x9C
 
@@ -3227,6 +3227,8 @@ lpfc_is_LC_HBA(unsigned short device)
 	    (device == PCI_DEVICE_ID_BSMB) ||
 	    (device == PCI_DEVICE_ID_ZMID) ||
 	    (device == PCI_DEVICE_ID_ZSMB) ||
+	    (device == PCI_DEVICE_ID_SAT_MID) ||
+	    (device == PCI_DEVICE_ID_SAT_SMB) ||
 	    (device == PCI_DEVICE_ID_RFLY))
 		return 1;
 	else
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-01-11 00:53:19.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-01-11 01:04:13.000000000 -0500
@@ -484,6 +484,9 @@ lpfc_hba_down_post(struct lpfc_hba *phba
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *mp, *next_mp;
+	struct lpfc_iocbq *iocb;
+	IOCB_t *cmd = NULL;
+	LIST_HEAD(completions);
 	int i;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
@@ -499,10 +502,36 @@ lpfc_hba_down_post(struct lpfc_hba *phba
 		}
 	}
 
+	spin_lock_irq(&phba->hbalock);
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
+
+		/* At this point in time the HBA is either reset or DOA. Either
+		 * way, nothing should be on txcmplq as it will NEVER complete.
+		 */
+		list_splice_init(&pring->txcmplq, &completions);
+		pring->txcmplq_cnt = 0;
+		spin_unlock_irq(&phba->hbalock);
+
+		while (!list_empty(&completions)) {
+			iocb = list_get_first(&completions, struct lpfc_iocbq,
+				list);
+			cmd = &iocb->iocb;
+			list_del_init(&iocb->list);
+
+			if (!iocb->iocb_cmpl)
+				lpfc_sli_release_iocbq(phba, iocb);
+			else {
+				cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+				cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+				(iocb->iocb_cmpl) (phba, iocb, iocb);
+			}
+		}
+
 		lpfc_sli_abort_iocb_ring(phba, pring);
+		spin_lock_irq(&phba->hbalock);
 	}
+	spin_unlock_irq(&phba->hbalock);
 
 	return 0;
 }
@@ -641,6 +670,26 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 	}
 }
 
+static void
+lpfc_offline_eratt(struct lpfc_hba *phba)
+{
+	struct lpfc_sli   *psli = &phba->sli;
+
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+	lpfc_offline_prep(phba);
+
+	lpfc_offline(phba);
+	lpfc_reset_barrier(phba);
+	lpfc_sli_brdreset(phba);
+	lpfc_hba_down_post(phba);
+	lpfc_sli_brdready(phba, HS_MBRDY);
+	lpfc_unblock_mgmt_io(phba);
+	phba->link_state = LPFC_HBA_ERROR;
+	return;
+}
+
 /************************************************************************/
 /*                                                                      */
 /*    lpfc_handle_eratt                                                 */
@@ -681,14 +730,14 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 		vports = lpfc_create_vport_work_array(phba);
 		if (vports != NULL)
 			for(i = 0;
-			    i < LPFC_MAX_VPORTS && vports[i] != NULL;
+			    i <= phba->max_vpi && vports[i] != NULL;
 			    i++){
 				shost = lpfc_shost_from_vport(vports[i]);
 				spin_lock_irq(shost->host_lock);
 				vports[i]->fc_flag |= FC_ESTABLISH_LINK;
 				spin_unlock_irq(shost->host_lock);
 			}
-		lpfc_destroy_vport_work_array(vports);
+		lpfc_destroy_vport_work_array(phba, vports);
 		spin_lock_irq(&phba->hbalock);
 		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		spin_unlock_irq(&phba->hbalock);
@@ -737,14 +786,9 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 					  | PCI_VENDOR_ID_EMULEX);
 
 		spin_lock_irq(&phba->hbalock);
-		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		phba->over_temp_state = HBA_OVER_TEMP;
 		spin_unlock_irq(&phba->hbalock);
-		lpfc_offline_prep(phba);
-		lpfc_offline(phba);
-		lpfc_unblock_mgmt_io(phba);
-		phba->link_state = LPFC_HBA_ERROR;
-		lpfc_hba_down_post(phba);
+		lpfc_offline_eratt(phba);
 
 	} else {
 		/* The if clause above forces this code path when the status
@@ -763,14 +807,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 				sizeof(event_data), (char *) &event_data,
 				SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
 
-		spin_lock_irq(&phba->hbalock);
-		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
-		spin_unlock_irq(&phba->hbalock);
-		lpfc_offline_prep(phba);
-		lpfc_offline(phba);
-		lpfc_unblock_mgmt_io(phba);
-		phba->link_state = LPFC_HBA_ERROR;
-		lpfc_hba_down_post(phba);
+		lpfc_offline_eratt(phba);
 	}
 }
 
@@ -790,21 +827,25 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *pmb;
 	volatile uint32_t control;
 	struct lpfc_dmabuf *mp;
-	int rc = -ENOMEM;
+	int rc = 0;
 
 	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!pmb)
+	if (!pmb) {
+		rc = 1;
 		goto lpfc_handle_latt_err_exit;
+	}
 
 	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
-	if (!mp)
+	if (!mp) {
+		rc = 2;
 		goto lpfc_handle_latt_free_pmb;
+	}
 
 	mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
-	if (!mp->virt)
+	if (!mp->virt) {
+		rc = 3;
 		goto lpfc_handle_latt_free_mp;
-
-	rc = -EIO;
+	}
 
 	/* Cleanup any outstanding ELS commands */
 	lpfc_els_flush_all_cmd(phba);
@@ -814,8 +855,10 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_la;
 	pmb->vport = vport;
 	rc = lpfc_sli_issue_mbox (phba, pmb, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		rc = 4;
 		goto lpfc_handle_latt_free_mbuf;
+	}
 
 	/* Clear Link Attention in HA REG */
 	spin_lock_irq(&phba->hbalock);
@@ -847,10 +890,8 @@ lpfc_handle_latt_err_exit:
 	lpfc_linkdown(phba);
 	phba->link_state = LPFC_HBA_ERROR;
 
-	/* The other case is an error from issue_mbox */
-	if (rc == -ENOMEM)
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
-			        "0300 READ_LA: no buffers\n");
+	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+		     "0300 LATT: Cannot issue READ_LA: Data:%d\n", rc);
 
 	return;
 }
@@ -1421,14 +1462,14 @@ lpfc_establish_link_tmo(unsigned long pt
 			phba->pport->fc_flag, phba->pport->port_state);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irqsave(shost->host_lock, iflag);
 			vports[i]->fc_flag &= ~FC_ESTABLISH_LINK;
 			spin_unlock_irqrestore(shost->host_lock, iflag);
 		}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 }
 
 void
@@ -1493,7 +1534,7 @@ lpfc_online(struct lpfc_hba *phba)
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
@@ -1502,7 +1543,7 @@ lpfc_online(struct lpfc_hba *phba)
 				vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			spin_unlock_irq(shost->host_lock);
 		}
-		lpfc_destroy_vport_work_array(vports);
+		lpfc_destroy_vport_work_array(phba, vports);
 
 	lpfc_unblock_mgmt_io(phba);
 	return 0;
@@ -1536,7 +1577,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	/* Issue an unreg_login to all nodes on all vports */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 
 			if (vports[i]->load_flag & FC_UNLOADING)
@@ -1560,7 +1601,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 			}
 		}
 	}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 
 	lpfc_sli_flush_mbox_queue(phba);
 }
@@ -1579,9 +1620,9 @@ lpfc_offline(struct lpfc_hba *phba)
 	lpfc_stop_phba_timers(phba);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
 			lpfc_stop_vport_timers(vports[i]);
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 			"0460 Bring Adapter offline\n");
 	/* Bring down the SLI Layer and cleanup.  The HBA is offline
@@ -1592,14 +1633,14 @@ lpfc_offline(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
 			vports[i]->work_port_events = 0;
 			vports[i]->fc_flag |= FC_OFFLINE_MODE;
 			spin_unlock_irq(shost->host_lock);
 		}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 }
 
 /******************************************************************************
@@ -2149,6 +2190,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	kfree(vport->vname);
 	lpfc_free_sysfs_attr(vport);
 
+	kthread_stop(phba->worker_thread);
+
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 	lpfc_cleanup(vport);
@@ -2168,8 +2211,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	lpfc_debugfs_terminate(vport);
 
-	kthread_stop(phba->worker_thread);
-
 	/* Release the irq reservation */
 	free_irq(phba->pcidev->irq, phba);
 	if (phba->using_msi)
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2008-01-11 01:04:05.000000000 -0500
@@ -896,7 +896,7 @@ lpfc_mbox_tmo_val(struct lpfc_hba *phba,
 	case MBX_DOWN_LOAD:	/* 0x1C */
 	case MBX_DEL_LD_ENTRY:	/* 0x1D */
 	case MBX_LOAD_AREA:	/* 0x81 */
-	case MBX_FLASH_WR_ULA:  /* 0x98 */
+	case MBX_WRITE_WWN:     /* 0x98 */
 	case MBX_LOAD_EXP_ROM:	/* 0x9C */
 		return LPFC_MBOX_TMO_FLASH_CMD;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2008-01-11 01:03:51.000000000 -0500
@@ -98,6 +98,7 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 
  fail_free_hbq_pool:
 	lpfc_sli_hbqbuf_free_all(phba);
+	pci_pool_destroy(phba->lpfc_hbq_pool);
  fail_free_nlp_mem_pool:
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-01-11 00:52:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-01-11 01:04:08.000000000 -0500
@@ -130,7 +130,7 @@ lpfc_ramp_down_queue_handler(struct lpfc
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
 				new_queue_depth =
@@ -151,7 +151,7 @@ lpfc_ramp_down_queue_handler(struct lpfc
 							new_queue_depth);
 			}
 		}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 	atomic_set(&phba->num_rsrc_err, 0);
 	atomic_set(&phba->num_cmd_success, 0);
 }
@@ -166,7 +166,7 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
 				if (sdev->ordered_tags)
@@ -179,7 +179,7 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 							sdev->queue_depth+1);
 			}
 		}
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 	atomic_set(&phba->num_rsrc_err, 0);
 	atomic_set(&phba->num_cmd_success, 0);
 }
@@ -380,7 +380,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 		(num_bde * sizeof (struct ulp_bde64));
 	iocb_cmd->ulpBdeCount = 1;
 	iocb_cmd->ulpLe = 1;
-	fcp_cmnd->fcpDl = be32_to_cpu(scsi_bufflen(scsi_cmnd));
+	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
 	return 0;
 }
 
@@ -763,6 +763,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	piocbq->iocb.ulpContext = pnode->nlp_rpi;
 	if (pnode->nlp_fcp_info & NLP_FCP_2_DEVICE)
 		piocbq->iocb.ulpFCP2Rcvy = 1;
+	else
+		piocbq->iocb.ulpFCP2Rcvy = 0;
 
 	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
 	piocbq->context1  = lpfc_cmd;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 00:53:19.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 01:04:23.000000000 -0500
@@ -716,7 +716,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_DEL_LD_ENTRY:
 	case MBX_RUN_PROGRAM:
 	case MBX_SET_MASK:
-	case MBX_SET_SLIM:
+	case MBX_SET_VARIABLE:
 	case MBX_UNREG_D_ID:
 	case MBX_KILL_BOARD:
 	case MBX_CONFIG_FARP:
@@ -728,7 +728,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_READ_RPI64:
 	case MBX_REG_LOGIN64:
 	case MBX_READ_LA64:
-	case MBX_FLASH_WR_ULA:
+	case MBX_WRITE_WWN:
 	case MBX_SET_DEBUG:
 	case MBX_LOAD_EXP_ROM:
 	case MBX_ASYNCEVT_ENABLE:
@@ -2182,7 +2182,10 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 			   <status> */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0436 Adapter failed to init, "
-					"timeout, status reg x%x\n", status);
+					"timeout, status reg x%x, "
+					"FW Data: A8 x%x AC x%x\n", status,
+					readl(phba->MBslimaddr + 0xa8),
+					readl(phba->MBslimaddr + 0xac));
 			phba->link_state = LPFC_HBA_ERROR;
 			return -ETIMEDOUT;
 		}
@@ -2194,7 +2197,10 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 			   <status> */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0437 Adapter failed to init, "
-					"chipset, status reg x%x\n", status);
+					"chipset, status reg x%x, "
+					"FW Data: A8 x%x AC x%x\n", status,
+					readl(phba->MBslimaddr + 0xa8),
+					readl(phba->MBslimaddr + 0xac));
 			phba->link_state = LPFC_HBA_ERROR;
 			return -EIO;
 		}
@@ -2222,7 +2228,10 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 		/* Adapter failed to init, chipset, status reg <status> */
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0438 Adapter failed to init, chipset, "
-				"status reg x%x\n", status);
+				"status reg x%x, "
+				"FW Data: A8 x%x AC x%x\n", status,
+				readl(phba->MBslimaddr + 0xa8),
+				readl(phba->MBslimaddr + 0xac));
 		phba->link_state = LPFC_HBA_ERROR;
 		return -EIO;
 	}
@@ -2581,6 +2590,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 	uint32_t status, evtctr;
 	uint32_t ha_copy;
 	int i;
+	unsigned long timeout;
 	unsigned long drvr_flag = 0;
 	volatile uint32_t word0, ldata;
 	void __iomem *to_slim;
@@ -2756,18 +2766,24 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 	}
 
 	wmb();
-	/* interrupt board to doit right away */
-	writel(CA_MBATT, phba->CAregaddr);
-	readl(phba->CAregaddr); /* flush */
 
 	switch (flag) {
 	case MBX_NOWAIT:
-		/* Don't wait for it to finish, just return */
+		/* Set up reference to mailbox command */
 		psli->mbox_active = pmbox;
+		/* Interrupt board to do it */
+		writel(CA_MBATT, phba->CAregaddr);
+		readl(phba->CAregaddr); /* flush */
+		/* Don't wait for it to finish, just return */
 		break;
 
 	case MBX_POLL:
+		/* Set up null reference to mailbox command */
 		psli->mbox_active = NULL;
+		/* Interrupt board to do it */
+		writel(CA_MBATT, phba->CAregaddr);
+		readl(phba->CAregaddr); /* flush */
+
 		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 			/* First read mbox status word */
 			word0 = *((volatile uint32_t *)&phba->slim2p->mbx);
@@ -2779,15 +2795,15 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 		/* Read the HBA Host Attention Register */
 		ha_copy = readl(phba->HAregaddr);
-
-		i = lpfc_mbox_tmo_val(phba, mb->mbxCommand);
-		i *= 1000; /* Convert to ms */
-
+		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
+							     mb->mbxCommand) *
+					   1000) + jiffies;
+		i = 0;
 		/* Wait for command to complete */
 		while (((word0 & OWN_CHIP) == OWN_CHIP) ||
 		       (!(ha_copy & HA_MBATT) &&
 			(phba->link_state > LPFC_WARM_START))) {
-			if (i-- <= 0) {
+			if (time_after(jiffies, timeout)) {
 				psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 				spin_unlock_irqrestore(&phba->hbalock,
 						       drvr_flag);
@@ -2800,12 +2816,12 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			    && (evtctr != psli->slistat.mbox_event))
 				break;
 
-			spin_unlock_irqrestore(&phba->hbalock,
-					       drvr_flag);
-
-			msleep(1);
-
-			spin_lock_irqsave(&phba->hbalock, drvr_flag);
+			if (i++ > 10) {
+				spin_unlock_irqrestore(&phba->hbalock,
+						       drvr_flag);
+				msleep(1);
+				spin_lock_irqsave(&phba->hbalock, drvr_flag);
+			}
 
 			if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 				/* First copy command data */
@@ -3065,7 +3081,7 @@ lpfc_sli_async_event_handler(struct lpfc
 	if (evt_code == ASYNC_TEMP_WARN) {
 		temp_event_data.event_code = LPFC_THRESHOLD_TEMP;
 		lpfc_printf_log(phba,
-				KERN_WARNING,
+				KERN_ERR,
 				LOG_TEMP,
 				"0347 Adapter is very hot, please take "
 				"corrective action. temperature : %d Celsius\n",
@@ -3074,7 +3090,7 @@ lpfc_sli_async_event_handler(struct lpfc
 	if (evt_code == ASYNC_TEMP_SAFE) {
 		temp_event_data.event_code = LPFC_NORMAL_TEMP;
 		lpfc_printf_log(phba,
-				KERN_INFO,
+				KERN_ERR,
 				LOG_TEMP,
 				"0340 Adapter temperature is OK now. "
 				"temperature : %d Celsius\n",
@@ -4047,7 +4063,6 @@ lpfc_intr_handler(int irq, void *dev_id)
 		}
 
 		if (work_ha_copy & HA_ERATT) {
-			phba->link_state = LPFC_HBA_ERROR;
 			/*
 			 * There was a link/board error.  Read the
 			 * status register to retrieve the error event
@@ -4079,7 +4094,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 				 * Stray Mailbox Interrupt, mbxCommand <cmd>
 				 * mbxStatus <status>
 				 */
-				lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX |
+				lpfc_printf_log(phba, KERN_ERR, LOG_MBOX |
 						LOG_SLI,
 						"(%d):0304 Stray Mailbox "
 						"Interrupt mbxCommand x%x "
@@ -4087,51 +4102,60 @@ lpfc_intr_handler(int irq, void *dev_id)
 						(vport ? vport->vpi : 0),
 						pmbox->mbxCommand,
 						pmbox->mbxStatus);
-			}
-			phba->last_completion_time = jiffies;
-			del_timer_sync(&phba->sli.mbox_tmo);
+				/* clear mailbox attention bit */
+				work_ha_copy &= ~HA_MBATT;
+			} else {
+				phba->last_completion_time = jiffies;
+				del_timer(&phba->sli.mbox_tmo);
 
-			phba->sli.mbox_active = NULL;
-			if (pmb->mbox_cmpl) {
-				lpfc_sli_pcimem_bcopy(mbox, pmbox,
-						      MAILBOX_CMD_SIZE);
-			}
-			if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
-				pmb->mbox_flag &= ~LPFC_MBX_IMED_UNREG;
+				phba->sli.mbox_active = NULL;
+				if (pmb->mbox_cmpl) {
+					lpfc_sli_pcimem_bcopy(mbox, pmbox,
+							MAILBOX_CMD_SIZE);
+				}
+				if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
+					pmb->mbox_flag &= ~LPFC_MBX_IMED_UNREG;
 
-				lpfc_debugfs_disc_trc(vport,
-					LPFC_DISC_TRC_MBOX_VPORT,
-					"MBOX dflt rpi: : status:x%x rpi:x%x",
-					(uint32_t)pmbox->mbxStatus,
-					pmbox->un.varWords[0], 0);
-
-				if ( !pmbox->mbxStatus) {
-					mp = (struct lpfc_dmabuf *)
-						(pmb->context1);
-					ndlp = (struct lpfc_nodelist *)
-						pmb->context2;
-
-					/* Reg_LOGIN of dflt RPI was successful.
-					 * new lets get rid of the RPI using the
-					 * same mbox buffer.
-					 */
-					lpfc_unreg_login(phba, vport->vpi,
-						pmbox->un.varWords[0], pmb);
-					pmb->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;
-					pmb->context1 = mp;
-					pmb->context2 = ndlp;
-					pmb->vport = vport;
-					spin_lock(&phba->hbalock);
-					phba->sli.sli_flag &=
-						~LPFC_SLI_MBOX_ACTIVE;
-					spin_unlock(&phba->hbalock);
-					goto send_current_mbox;
+					lpfc_debugfs_disc_trc(vport,
+						LPFC_DISC_TRC_MBOX_VPORT,
+						"MBOX dflt rpi: : "
+						"status:x%x rpi:x%x",
+						(uint32_t)pmbox->mbxStatus,
+						pmbox->un.varWords[0], 0);
+
+					if (!pmbox->mbxStatus) {
+						mp = (struct lpfc_dmabuf *)
+							(pmb->context1);
+						ndlp = (struct lpfc_nodelist *)
+							pmb->context2;
+
+						/* Reg_LOGIN of dflt RPI was
+						 * successful. new lets get
+						 * rid of the RPI using the
+						 * same mbox buffer.
+						 */
+						lpfc_unreg_login(phba,
+							vport->vpi,
+							pmbox->un.varWords[0],
+							pmb);
+						pmb->mbox_cmpl =
+							lpfc_mbx_cmpl_dflt_rpi;
+						pmb->context1 = mp;
+						pmb->context2 = ndlp;
+						pmb->vport = vport;
+						spin_lock(&phba->hbalock);
+						phba->sli.sli_flag &=
+							~LPFC_SLI_MBOX_ACTIVE;
+						spin_unlock(&phba->hbalock);
+						goto send_current_mbox;
+					}
 				}
+				spin_lock(&phba->pport->work_port_lock);
+				phba->pport->work_port_events &=
+					~WORKER_MBOX_TMO;
+				spin_unlock(&phba->pport->work_port_lock);
+				lpfc_mbox_cmpl_put(phba, pmb);
 			}
-			spin_lock(&phba->pport->work_port_lock);
-			phba->pport->work_port_events &= ~WORKER_MBOX_TMO;
-			spin_unlock(&phba->pport->work_port_lock);
-			lpfc_mbox_cmpl_put(phba, pmb);
 		}
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active == NULL)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-12-17 13:51:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-01-11 01:03:53.000000000 -0500
@@ -562,7 +562,7 @@ lpfc_create_vport_work_array(struct lpfc
 	struct lpfc_vport *port_iterator;
 	struct lpfc_vport **vports;
 	int index = 0;
-	vports = kzalloc(LPFC_MAX_VPORTS * sizeof(struct lpfc_vport *),
+	vports = kzalloc((phba->max_vpi + 1) * sizeof(struct lpfc_vport *),
 			 GFP_KERNEL);
 	if (vports == NULL)
 		return NULL;
@@ -581,12 +581,12 @@ lpfc_create_vport_work_array(struct lpfc
 }
 
 void
-lpfc_destroy_vport_work_array(struct lpfc_vport **vports)
+lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
 {
 	int i;
 	if (vports == NULL)
 		return;
-	for (i=0; vports[i] != NULL && i < LPFC_MAX_VPORTS; i++)
+	for (i=0; vports[i] != NULL && i <= phba->max_vpi; i++)
 		scsi_host_put(lpfc_shost_from_vport(vports[i]));
 	kfree(vports);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
--- a/drivers/scsi/lpfc/lpfc_vport.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.h	2008-01-11 01:03:53.000000000 -0500
@@ -89,7 +89,7 @@ int lpfc_vport_delete(struct fc_vport *)
 int lpfc_vport_getinfo(struct Scsi_Host *, struct vport_info *);
 int lpfc_vport_tgt_remove(struct Scsi_Host *, uint, uint);
 struct lpfc_vport **lpfc_create_vport_work_array(struct lpfc_hba *);
-void lpfc_destroy_vport_work_array(struct lpfc_vport **);
+void lpfc_destroy_vport_work_array(struct lpfc_hba *, struct lpfc_vport **);
 
 /*
  *  queuecommand  VPORT-specific return codes. Specified in  the host byte code.


