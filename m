From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [RFC PATCH 1/2] lpfc: add target infrastructure
Date: Sun, 12 Apr 2015 16:14:31 +0200
Message-ID: <20150412161431.00007950@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Add target infrastructure.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
---

diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_api.c 4.0-rc7/drivers/scsi/lpfc/lpfc_target_api.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_api.c	1970-01-01 01:00:00.000000000 +0100
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_target_api.c	2015-04-12 11:29:57.314144739 +0200
@@ -0,0 +1,902 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2003-2008 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
+
+#include "lpfc_version.h"
+#include "lpfc_hw4.h"
+#include "lpfc_hw.h"
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#include "lpfc_nl.h"
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_disc.h"
+#include "lpfc_scsi.h"
+#include "lpfc.h"
+#include "lpfc_logmsg.h"
+#include "lpfc_target_protos.h"
+#include "lpfc_crtn.h"
+
+int lpfc_tgt_init(void);
+int lpfc_tgt_exit(void);
+
+int lpfctm_num_hba = 0;
+void lpfc_tm_down_link(tm_sliport_handle_t lpfc_port_handle);
+void lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp);
+void lpfc_tm_tgtport_unbind(tm_tgtport_handle_t base_handle);
+
+extern int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
+extern int lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *, uint32_t, uint32_t);
+extern struct lpfc_vport *lpfc_find_vport_by_vpid(struct lpfc_hba *, uint16_t);
+void lpfc_tm_recv_unsol(struct lpfc_hba *phba,
+		     struct lpfc_sli_ring *pring, struct lpfc_iocbq *iocb);
+struct hbq_dmabuf *lpfc_tm_hbq_alloc(struct lpfc_hba *phba);
+void lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp);
+int lpfc_get_hba_info(struct lpfc_hba *phba, uint32_t *mxri, uint32_t *axri,
+	  uint32_t *mrpi, uint32_t *arpi, uint32_t *mvpi, uint32_t *avpi);
+
+extern struct lpfc_hbq_init *lpfc_hbq_defs[];
+
+int lpfc_target_sliport_init(struct lpfc_hba *phba, struct pci_dev *pci_dev)
+{
+	uint32_t           result;
+	tm_sliport_info_t *sliport_info;
+	tm_driver_data_t  *driver_data = lpfc_tgt_data;
+	tm_sliport_t      *sliport = &phba->target_sliport;
+
+	/* set up parameters in port info */
+	sliport_info = &phba->target_sliport.info;
+	sliport_info->sli_version = *(uint32_t *)&phba->pcb;
+	sliport_info->iotag16_mask = 0xc000;
+	sliport_info->pcidev = phba->pcidev;
+
+	/* allow negotiation on init call if hbq num is zero in driver data */
+	sliport_info->max_tgt_contexts = phba->cfg_hba_queue_depth;
+	if (driver_data->tm_num_hbq_buf &&
+		driver_data->tm_num_hbq_buf < sliport_info->max_tgt_contexts)
+		sliport_info->max_tgt_contexts = driver_data->tm_num_hbq_buf;
+
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		sliport_info->flags |= LPFC_TM_SLI3_HBQ_ENABLED;
+		sliport_info->flags |= LPFC_TM_HBQ_TAGS_SUPPORTED;
+	} else {
+		sliport_info->flags &= ~LPFC_TM_SLI3_HBQ_ENABLED;
+		sliport_info->flags &= ~LPFC_TM_HBQ_TAGS_SUPPORTED;
+	}
+
+	result = lpfc_tgt_data->tm_sliport_init((tm_sliport_handle_t *)phba,
+			sliport_info, &phba->target_sliport.target_slihandle);
+
+	if (result == TM_RCD_SUCCESS) {
+		struct lpfc_sli *psli;
+		struct lpfc_sli_ring *pring;
+
+		psli = &phba->sli;
+		pring = &psli->ring[LPFC_EXTRA_RING];
+
+		/* protect against user brain damage */
+		if (sliport_info->max_tgt_contexts > phba->cfg_hba_queue_depth)
+			sliport_info->max_tgt_contexts =
+				phba->cfg_hba_queue_depth;
+
+		pring->prt[0].lpfc_sli_rcv_unsol_event = lpfc_tm_recv_unsol;
+
+		if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+			phba->hbqs[LPFC_EXTRA_HBQ].hbq_alloc_buffer =
+					lpfc_tm_hbq_alloc;
+			phba->hbqs[LPFC_EXTRA_HBQ].hbq_free_buffer =
+					lpfc_tm_hbq_free;
+			if (!lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_EXTRA_HBQ,
+					sliport_info->max_tgt_contexts)) {
+				result = TM_RCD_FAILURE;
+			}
+		}
+		sliport->interrupt_callback_allowed = 0;
+		atomic_set(&sliport->interrupt_in_progress, 0);
+	}
+	return result;
+}
+
+int lpfc_tgt_init(void)
+{
+	struct Scsi_Host  *host;
+	struct lpfc_vport *vport, *pport;
+	struct lpfc_hba   *phba;
+	struct pci_dev    *dev = NULL;
+	uint32_t           result;
+
+	while ((dev = pci_get_device(PCI_VENDOR_ID_EMULEX, PCI_ANY_ID,
+								dev)) != NULL) {
+		host = pci_get_drvdata(dev);
+		if (host != NULL) {
+			pport = (struct lpfc_vport *) host->hostdata;
+			phba = pport->phba;
+			if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+				lpfctm_num_hba++;
+		}
+	}
+
+	if (!lpfctm_num_hba) {
+		printk(KERN_ERR "lpfctm: No lpfc HBAs supporting target mode found\n");
+		return -ENODEV;
+	}
+
+	dev = NULL;
+	while ((dev = pci_get_device(PCI_VENDOR_ID_EMULEX, PCI_ANY_ID,
+								dev)) != NULL) {
+		host = pci_get_drvdata(dev);
+		if (host != NULL) {
+			pport = (struct lpfc_vport *) host->hostdata;
+			phba = pport->phba;
+			if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET))
+				continue;
+
+			result = lpfc_target_sliport_init(phba, dev);
+			if (result) {
+				printk(KERN_ERR "lpfc_tm: "
+					"Unable to init target sliport\n");
+				return -ENODEV;
+			}
+		}
+	}
+
+	dev = NULL;
+	while ((dev = pci_get_device(PCI_VENDOR_ID_EMULEX, PCI_ANY_ID,
+								dev)) != NULL) {
+		host = pci_get_drvdata(dev);
+		if (host != NULL) {
+			pport = (struct lpfc_vport *) host->hostdata;
+			phba = pport->phba;
+			if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET))
+				continue;
+			list_for_each_entry(vport, &phba->port_list,
+							listentry) {
+				lpfc_target_new_tgtport(vport);
+			}
+			lpfc_tm_init_link(phba);
+		}
+	}
+	return 0;
+}
+
+int
+lpfc_tgt_exit(void)
+{
+	struct lpfc_hba   *phba;
+	struct lpfc_vport *vport, *pport;
+	struct Scsi_Host  *host;
+	struct pci_dev    *dev = NULL;
+
+	dev = NULL;
+	while ((dev = pci_get_device(PCI_VENDOR_ID_EMULEX, PCI_ANY_ID,
+								dev)) != NULL) {
+		host = pci_get_drvdata(dev);
+		if (host != NULL) {
+			pport = (struct lpfc_vport *) host->hostdata;
+			phba = pport->phba;
+			if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET))
+				continue;
+			list_for_each_entry(vport, &phba->port_list,
+							listentry) {
+				/* Add code to cleanup tgtport */
+			}
+			lpfc_tm_down_link(phba);
+		}
+	}
+	return 0;
+}
+
+int
+lpfc_tm_get_max_rpi(tm_sliport_handle_t lpfc_sliport_handle, uint32_t *max_rpi)
+{
+	int status;
+	struct lpfc_hba *phba;
+	uint32_t mxri, axri, arpi, mvpi, avpi;
+
+	phba = (struct lpfc_hba *)lpfc_sliport_handle;
+
+	status = lpfc_get_hba_info(phba,
+			&mxri, &axri, max_rpi, &arpi, &mvpi, &avpi);
+	if (status == 0)
+		return TM_RCD_FAILURE;
+	return TM_RCD_SUCCESS;
+}
+EXPORT_SYMBOL(lpfc_tm_get_max_rpi);
+
+static inline void tm_rsp_recv(struct lpfc_vport *vport, IOCB_t *iocb)
+{
+	tm_tgtport_handle_t target_handle;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	target_handle = vport->target_tgtport.target_handle;
+	if (target_handle)
+		lpfc_tgt_data->tm_rsp_recv(target_handle, iocb);
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+}
+
+void
+lpfc_tm_recv_unsol(struct lpfc_hba *phba,
+		     struct lpfc_sli_ring *pring, struct lpfc_iocbq *iocb)
+{
+	struct lpfc_vport *vport = NULL;
+	IOCB_t *icmd = &iocb->iocb;
+	uint16_t vpi;
+	struct lpfc_dmabuf *dmabuf, *next_dmabuf;
+	struct hbq_dmabuf *hbq_buf;
+	unsigned long flags;
+	uint32_t hbqno;
+
+	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
+	     (icmd->ulpCommand == CMD_IOCB_RCV_SEQ64_CX)) {
+		vpi = icmd->unsli3.rcvsli3.vpi;
+		if (vpi != 0xffff)
+			vport = lpfc_find_vport_by_vpid(phba, vpi);
+	}
+	if (vport == NULL)
+		vport = phba->pport;
+
+	/* Initiator must be logged in for any incoming SCSI request */
+	switch (icmd->ulpCommand) {
+	case CMD_IOCB_RCV_SEQ64_CX:
+		/* transparently restore applications SLI-3 hbq io tag */
+		icmd->un.ulpWord[3] = lpfc_hbq_app_tag_get(icmd->un.ulpWord[3]);
+		/* FALLTHRU */
+
+	case CMD_RCV_SEQUENCE64_CX:
+		tm_rsp_recv(vport, icmd);
+		break;
+
+	default:
+		tm_rsp_recv(vport, icmd);
+	}
+
+	/* Now get rid of all HBQs that are in-flight */
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		spin_lock_irqsave(&phba->hbalock, flags);
+		list_for_each_entry_safe(dmabuf, next_dmabuf,
+			&phba->rb_pend_list, list) {
+			hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
+			hbqno = lpfc_hbqno_get(hbq_buf->tag);
+			if (hbqno == LPFC_EXTRA_HBQ) {
+				list_del(&hbq_buf->dbuf.list);
+				kfree(hbq_buf);
+			}
+		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+	}
+}
+
+static void
+lpfc_tm_recv_sol(struct lpfc_hba *phba,
+		    struct lpfc_iocbq *cmdiocb, struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = NULL;
+
+	vport = cmdiocb->vport;
+	if (vport == NULL)
+		vport = phba->pport;
+	tm_rsp_recv(vport, &rspiocb->iocb);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
+}
+
+struct hbq_dmabuf *
+lpfc_tm_hbq_alloc(struct lpfc_hba *phba)
+{
+	struct hbq_dmabuf *hbqbp;
+	tm_sliport_handle_t target_sliport;
+	struct tm_hbq_dmabuf *tm_hbqbp;
+
+	hbqbp = kmalloc(sizeof(struct hbq_dmabuf), GFP_ATOMIC);
+	if (!hbqbp)
+		return NULL;
+
+	tm_hbqbp = (struct tm_hbq_dmabuf *)hbqbp;
+	atomic_inc(&phba->target_sliport.calls_outstanding);
+	target_sliport = phba->target_sliport.target_slihandle;
+	if (target_sliport)
+		lpfc_tgt_data->tm_hbq_alloc(target_sliport, tm_hbqbp);
+	atomic_dec(&phba->target_sliport.calls_outstanding);
+	if (tm_hbqbp->dbuf.virt == NULL) {
+		kfree(hbqbp);
+		return NULL;
+	}
+
+	return hbqbp;
+}
+
+void
+lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
+{
+	tm_sliport_handle_t target_sliport;
+	struct tm_hbq_dmabuf *tm_hbqbp;
+
+	tm_hbqbp = (struct tm_hbq_dmabuf *)hbqbp;
+	hbqbp->tag = lpfc_hbq_app_tag_get(hbqbp->tag);
+	atomic_inc(&phba->target_sliport.calls_outstanding);
+	target_sliport = phba->target_sliport.target_slihandle;
+	if (target_sliport)
+		lpfc_tgt_data->tm_hbq_free(target_sliport, tm_hbqbp);
+	atomic_dec(&phba->target_sliport.calls_outstanding);
+	kfree(hbqbp);
+}
+
+/* encapsulate all calls to target module */
+uint32_t
+tm_tgtport_bind(struct lpfc_vport *vport, tm_tgtport_info_t *portinfo)
+{
+	tm_driver_data_t *driver_data;
+	struct lpfc_hba  *phba = vport->phba;
+	uint32_t result;
+
+	atomic_inc(&bind_call_outstanding);
+	driver_data = lpfc_tgt_data;
+	if (driver_data) {
+		if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
+			portinfo->flags |= LPFC_TM_SLI3_HBQ_ENABLED;
+		else
+			portinfo->flags &= ~LPFC_TM_SLI3_HBQ_ENABLED;
+
+		/* let remote initiators login to target */
+		vport->cfg_restrict_login = 0;
+
+		result =
+		    driver_data->tm_tgtport_bind_v2(
+					phba->target_sliport.target_slihandle,
+					(tm_tgtport_handle_t)vport,
+					 portinfo, (tm_tgtport_handle_t *)
+					 &vport->target_tgtport.
+					 target_handle);
+	} else
+		result = TM_RCD_FAILURE;
+	atomic_dec(&bind_call_outstanding);
+	return result;
+}
+
+uint32_t
+tm_tgtport_chk_login(struct lpfc_vport *vport,
+		     tm_login_info_t *logininfo)
+{
+	tm_tgtport_handle_t target_handle;
+	uint32_t result;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	target_handle = vport->target_tgtport.target_handle;
+	if (target_handle)
+		result =
+		    lpfc_tgt_data->tm_tgtport_chk_login(target_handle,
+							logininfo);
+	else
+		result = TM_RCD_FAILURE;
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+	return result;
+}
+
+tm_login_handle_t tm_tgtport_login(struct lpfc_vport *vport,
+					struct lpfc_nodelist *ndlp)
+{
+	tm_tgtport_handle_t target_handle;
+	tm_login_handle_t result;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	target_handle = vport->target_tgtport.target_handle;
+	if (target_handle) {
+		tm_check_duplicate_wwpn(vport, ndlp);
+		result = lpfc_tgt_data->tm_tgtport_login(target_handle,
+				 ndlp->nlp_rpi, &ndlp->tm_login_info);
+	} else
+		result = 0;
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+	return result;
+}
+
+void tm_tgtport_logout(struct lpfc_vport *vport,
+		      tm_login_handle_t tgt_login_handle)
+{
+	tm_tgtport_handle_t target_handle;
+
+	/*
+	 * Check for various stages of tearing down the target driver. It's
+	 * possible to receive link events during teardown depending on load.
+	 * If any of the folloging conditions are true, we would dereference
+	 * freed memory if we continued.
+	 */
+	target_handle = vport->target_tgtport.target_handle;
+	if (tgt_login_handle == NULL)	/* lpfc_unreg_rpi already called */
+		return;
+	if (target_handle == NULL)	/* lpfc_tm_tgtport_unbind called */
+		return;
+	if (lpfc_tgt_data == NULL)	/* lpfc_tm_term() already called */
+		return;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	lpfc_tgt_data->tm_tgtport_logout(tgt_login_handle);
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+}
+
+
+static int    init_called = 0;
+
+atomic_t bind_call_outstanding = ATOMIC_INIT(0);
+
+tm_driver_data_t *volatile lpfc_tgt_data;
+
+uint32_t lpfc_tm_version(void)
+{
+	return TM_API_VERSION_2;
+}
+EXPORT_SYMBOL(lpfc_tm_version);
+
+uint32_t lpfc_tm_init(tm_driver_data_t *tgt_data)
+{
+	int status;
+
+	if (init_called) {
+		printk("lpfc multiple init of target module\n");
+		return TM_RCD_INVALID;
+	}
+	if (tgt_data->api_version != TM_API_VERSION_2)
+		return TM_RCD_INVALID;
+	lpfc_tgt_data = tgt_data;
+
+	status = lpfc_tgt_init();
+	if (status) {
+		init_called = 0;
+		lpfc_tgt_data = NULL;
+		return status;
+	}
+	init_called = 1;
+	return status;
+}
+EXPORT_SYMBOL(lpfc_tm_init);
+
+uint32_t
+lpfc_target_new_tgtport(struct lpfc_vport *vport)
+{
+	tm_driver_data_t *temp_lpfc_tgt_data;
+	tm_tgtport_t     *tgtport = &vport->target_tgtport;
+	struct lpfc_hba  *phba = vport->phba;
+	uint32_t result;
+	uint32_t max_xri;
+
+	temp_lpfc_tgt_data = lpfc_tgt_data;
+
+	if (!temp_lpfc_tgt_data) {
+		/* unlikely to get here. Means a new
+		 * tgtport appeared after unloading the
+		 * target driver.  So just return 0.
+		 */
+		return 0;
+	}
+
+	/* initialize tgtport struct */
+	memset(tgtport, 0, sizeof(tm_tgtport_t));
+	atomic_set(&tgtport->calls_outstanding, 0);
+
+	/* set up parameters in port info */
+	tgtport->info.sli_version = *(uint32_t *)&phba->pcb;
+	tgtport->info.protocol_type = TM_PROTO_FC;
+	memcpy(tgtport->info.proto_u.fc_proto_info.fc_port_name,
+		(uint8_t *)&vport->fc_portname, 8);
+	memcpy(tgtport->info.proto_u.fc_proto_info.fc_node_name,
+		(uint8_t *)&vport->fc_nodename, 8);
+	tgtport->info.iotag16_mask = 0xc000;
+	tgtport->info.pcidev = phba->pcidev;
+
+	/*
+	 * max_tgt_contexts was negotiated in a preceding tm_sliport_init() call
+	 * Don't allow it to be modified here, use vport[0] cfg for all vports
+	 */
+	max_xri = phba->target_sliport.info.max_tgt_contexts;
+	tgtport->info.max_tgt_contexts = max_xri;
+	if (max_xri < 32) {
+		printk("lpfc_target_new_tgtport max_xri = %d\n", max_xri);
+		return TM_RCD_FAILURE;
+	}
+
+	/*
+	 * Now let the target driver know. Binds both phys & npiv ports
+	 * tm_sliport_init must have already been called for this hba.
+	 */
+	result = tm_tgtport_bind(vport, &tgtport->info);
+	if (result == TM_RCD_SUCCESS)
+		phba->num_targets_bound++;
+	tgtport->info.max_tgt_contexts = max_xri;
+
+	return result;
+}
+
+uint32_t
+lpfc_target_rm_tgtport(struct lpfc_vport *vport)
+{
+	tm_driver_data_t *temp_lpfc_tgt_data;
+	tm_tgtport_t     *tgtport = &vport->target_tgtport;
+
+	temp_lpfc_tgt_data = lpfc_tgt_data;
+
+	if (!temp_lpfc_tgt_data) {
+		/* unlikely to get here. Means a new
+		 * tgtport appeared after unloading the
+		 * target driver.  So just return 0.
+		 */
+		return 0;
+	}
+
+	/* now let the target driver know */
+	lpfc_tm_tgtport_unbind(tgtport);
+	return 1;
+}
+
+/* check for a node already logged in with the same port name.
+ * If found, then log it out of the target
+ */
+void tm_check_duplicate_wwpn(struct lpfc_vport *vport,
+				struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_nodelist *ndlp1;
+
+	list_for_each_entry(ndlp1, &vport->fc_nodes, nlp_listp) {
+		if (memcmp(&ndlp->nlp_portname, &ndlp1->nlp_portname,
+			8) == 0 && ndlp != ndlp1 &&
+			ndlp1->login_handle_valid) {
+
+			/* found duplicate needs to be logged out */
+			tm_tgtport_logout(vport, ndlp1->login_handle);
+			ndlp1->login_handle_valid = 0;
+			ndlp1->login_handle = 0;
+		}
+	}
+}
+
+/* this function called in the prli els functions prior to
+ * sending any PRLI or PRLI response.
+ */
+uint32_t
+lpfc_target_check_login(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	/* fill in the login info structure */
+	tm_login_info_t *p = &ndlp->tm_login_info;
+
+	/* if we have already checked, then just
+	 * return the result we got last time.
+	 */
+	if (ndlp->tm_check_login_called)
+		return ndlp->tm_check_login_result;
+
+	memcpy(p->fc_login_info.fc_port_name, &ndlp->nlp_portname, 8);
+	memcpy(p->fc_login_info.fc_node_name, &ndlp->nlp_nodename, 8);
+	p->fc_login_info.local_fc_id = vport->fc_myDID;
+	p->fc_login_info.fc_id = ndlp->nlp_DID;
+
+	/* find out if target driver likes it */
+	ndlp->tm_check_login_called = 1;
+	ndlp->tm_check_login_result = tm_tgtport_chk_login(vport, p);
+	return ndlp->tm_check_login_result;
+}
+
+void lpfc_tm_tgtport_unbind(tm_tgtport_handle_t base_handle)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)base_handle;
+	struct lpfc_hba *phba = vport->phba;
+
+
+	/* invalidate the handle */
+	vport->target_tgtport.target_handle = 0;
+
+	/* then wait for all outstanding calls to the target referencing
+	 * this tgtport to complete.
+	 */
+	while (atomic_read(&vport->target_tgtport.calls_outstanding))
+		schedule_timeout(10);
+
+	phba->num_targets_bound--;
+}
+EXPORT_SYMBOL(lpfc_tm_tgtport_unbind);
+
+
+
+uint32_t lpfc_tm_cmd_send(tm_sliport_handle_t lpfc_sliport_handle,
+				tm_tgtport_handle_t  base_handle,
+				IOCB_t    *iocb,
+				uint32_t   iocb_wd_len)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)base_handle;
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_sliport_handle;
+	struct lpfc_sli   *psli;
+	struct lpfc_sli_ring *pring;
+	struct lpfc_iocbq *tmiocb;
+	IOCB_t *icmd;
+
+	psli = &phba->sli;
+	pring = &psli->ring[LPFC_EXTRA_RING];
+
+	/* lpfc_sli_issue_iocb will do this for us, but way too much
+	 * overhead.  This routine is largely a cut and paste of required
+	 * code. This code may need to be updated if structure
+	 * definitions change.
+	 */
+
+	/* Allocate buffer for  command iocb */
+	tmiocb = lpfc_sli_get_iocbq(phba);
+	if (!tmiocb)
+		return TM_RCD_FULL;  /* ring is full */
+
+	icmd = &tmiocb->iocb;
+	iocb->ulpIoTag = icmd->ulpIoTag;
+	memcpy((uint8_t *)icmd, (uint8_t *)iocb, sizeof(IOCB_t));
+	if (icmd->ulpCommand == CMD_QUE_RING_BUF64_CN)
+		tmiocb->iocb_cmpl = NULL;
+	else {
+		tmiocb->vport = vport;
+		tmiocb->iocb_cmpl = lpfc_tm_recv_sol;
+	}
+
+	if (lpfc_sli_issue_iocb(phba, LPFC_EXTRA_RING, tmiocb, 0)) {
+		lpfc_sli_release_iocbq(phba, tmiocb);
+		return TM_RCD_FULL;  /* ring is full */
+	}
+	return 0;
+}
+EXPORT_SYMBOL(lpfc_tm_cmd_send);
+
+void lpfc_tm_rsp_poll(tm_sliport_handle_t lpfc_port_handle,
+				uint32_t max_responses)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)lpfc_port_handle;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring = &psli->ring[LPFC_EXTRA_RING];
+	extern int lpfc_sli_handle_fast_ring_event(struct lpfc_hba *,
+			   struct lpfc_sli_ring *, uint32_t);
+	uint32_t  ha_copy;
+
+	/* Reading the HA register is expensive, but if
+	 * we are host limited, the response ring will
+	 * be full so the cost is ammortized.  If we
+	 * are not host limited, we don't care.
+	 */
+	ha_copy = readl(phba->HAregaddr) >> 4*LPFC_EXTRA_RING;
+	phba->poll_rsp_cnt = max_responses;
+	if (ha_copy & HA_RXATT) {
+		lpfc_sli_handle_fast_ring_event(phba, pring,
+				   (ha_copy & HA_RXMASK));
+	}
+	phba->poll_rsp_cnt = 0;
+}
+EXPORT_SYMBOL(lpfc_tm_rsp_poll);
+
+void lpfc_tm_poll_set(tm_sliport_handle_t lpfc_port_handle, uint32_t enable)
+{
+	uint32_t  hc_value;
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_port_handle;
+	tm_sliport_t      *sliport = &phba->target_sliport;
+
+	spin_lock(&phba->hbalock);
+	/* set the interrupt enable bit in the HC register.
+	 * This should really be protected by a lock, but
+	 * can't do this until base driver is fixed.
+	 */
+	hc_value = readl(phba->HCregaddr);
+	if (enable)
+		hc_value |= (HC_R0INT_ENA << LPFC_EXTRA_RING);
+	else
+		hc_value &= ~(HC_R0INT_ENA << LPFC_EXTRA_RING);
+	writel(hc_value, phba->HCregaddr);
+
+	sliport->interrupt_callback_allowed = !enable;
+	spin_unlock(&phba->hbalock);
+
+	/* If disabling interrupt call backs (enabling polling)
+	 * then need to wait for any concurrent call back to
+	 * complete.  This guarantees that on return from
+	 * this function, no future callbacks will occur.
+	 */
+	while (atomic_read(&sliport->interrupt_in_progress))
+		schedule_timeout(10);
+}
+EXPORT_SYMBOL(lpfc_tm_poll_set);
+
+void lpfc_tm_term(void)
+{
+	/* wait for any outstanding bind calls to complete
+	 * before returning.  Don't want the target driver
+	 * to unload while a call to it is still in progress.
+	 */
+	while (atomic_read(&bind_call_outstanding))
+		schedule_timeout(10);
+	lpfc_tgt_exit();
+	lpfc_tgt_data = NULL;
+	init_called = 0;
+}
+EXPORT_SYMBOL(lpfc_tm_term);
+
+void
+lpfc_tm_linkdown(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport;
+	struct lpfc_nodelist  *ndlp, *next_ndlp;
+
+	/* This routine will do additional link down processing
+	 * required for target mode. Regular link down processing
+	 * is still done in lpfc_linkdown.
+	 */
+
+	list_for_each_entry(vport, &phba->port_list, listentry) {
+		list_for_each_entry_safe(ndlp, next_ndlp,
+					&phba->pport->fc_nodes, nlp_listp) {
+
+		if (ndlp->nlp_state != NLP_STE_UNUSED_NODE)
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+				     NLP_EVT_DEVICE_RECOVERY);
+
+			/* Because this is a target, we want to force
+			 * any remote initiator to use PLOGI / PRLI
+			 * to login to us instead of ADISC. Typically
+			 * this will only make a difference if this
+			 * local port is configuration as BOTH a target
+			 * and an initiator.
+			 */
+			lpfc_unreg_rpi(vport, ndlp);
+		}
+	}
+}
+
+void lpfc_tm_init_link(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_port_handle;
+	LPFC_MBOXQ_t *pmb;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (!pmb) {
+		printk("lpfc_tm_init_link unable to allocate mailbox mem\n");
+		return;
+	}
+
+	lpfc_tm_linkdown(phba);
+	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
+	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
+		printk("lpfc_tm_init_link mailbox command unsuccessful\n");
+		lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
+		if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS)
+			printk("lpfc_tm_init_link retry failed\n");
+	}
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
+EXPORT_SYMBOL(lpfc_tm_init_link);
+
+void lpfc_tm_down_link(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_port_handle;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (!pmb) {
+		printk("lpfc_tm_down_link unable to allocate mailbox mem\n");
+		return;
+	}
+	mb = &pmb->u.mb;
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+
+	mb->mbxCommand = MBX_DOWN_LINK;
+	mb->mbxOwner = OWN_HOST;
+	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS)
+		printk("lpfc_tm_down_link mailbox command unsuccessful\n");
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
+
+int lpfc_sliport_term(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_port_handle;
+	struct lpfc_dmabuf *dmabuf, *next_dmabuf;
+	struct hbq_dmabuf *hbq_buf;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb = NULL;
+	uint32_t hbq_index;
+
+	if (phba->num_targets_bound)
+		return TM_RCD_BUSY;
+
+
+	/* must pause the hbq before resetting the ring */
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+		if (pmb) {
+			memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+			mb = &pmb->u.mb;
+			mb->mbxCommand = MBX_PAUSE_HBQ;
+			mb->un.varPauseHbq.hbqId = LPFC_EXTRA_HBQ;
+			lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+			mempool_free(pmb, phba->mbox_mem_pool);
+		}
+	}
+
+	/* reset the target ring */
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (pmb) {
+		memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+		mb = &pmb->u.mb;
+		mb->mbxCommand = MBX_RESET_RING;
+		mb->un.varRstRing.ring_no = LPFC_EXTRA_RING;
+		lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+		mempool_free(pmb, phba->mbox_mem_pool);
+	}
+
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		list_for_each_entry_safe(dmabuf, next_dmabuf,
+			&phba->hbqs[LPFC_EXTRA_HBQ].hbq_buffer_list,
+								list) {
+			hbq_buf = container_of(dmabuf,
+				struct hbq_dmabuf, dbuf);
+			list_del(&hbq_buf->dbuf.list);
+			(phba->hbqs[LPFC_EXTRA_HBQ].hbq_free_buffer)
+				(phba, hbq_buf);
+		}
+		phba->hbqs[LPFC_EXTRA_HBQ].hbq_alloc_buffer = NULL;
+		phba->hbqs[LPFC_EXTRA_HBQ].hbq_free_buffer  = NULL;
+	}
+
+	/* resume the hbq and reset the get pointer after reset */
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+		if (pmb) {
+			/* set the hbq put pointer before issuing the resume */
+			hbq_index = 0;
+			writel(hbq_index, phba->hbq_put + LPFC_EXTRA_HBQ);
+			/* flush */
+			hbq_index = readl(phba->hbq_put + LPFC_EXTRA_HBQ);
+			phba->hbqs[LPFC_EXTRA_HBQ].hbqPutIdx = hbq_index;
+			phba->hbqs[LPFC_EXTRA_HBQ].next_hbqPutIdx = hbq_index;
+
+			memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+			mb = &pmb->u.mb;
+			mb->mbxCommand = MBX_RESUME_HBQ;
+			mb->un.varResumeHbq.hbqId = LPFC_EXTRA_HBQ;
+			mb->un.varResumeHbq.hbqGetPtr = hbq_index;
+			lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+
+			phba->hbqs[LPFC_EXTRA_HBQ].local_hbqGetIdx = hbq_index;
+			phba->hbqs[LPFC_EXTRA_HBQ].buffer_count = 0;
+
+			mempool_free(pmb, phba->mbox_mem_pool);
+		}
+	}
+
+	if (lpfc_tgt_data)
+		lpfc_tgt_data->tm_sliport_term(
+				phba->target_sliport.target_slihandle);
+
+	return TM_RCD_SUCCESS;
+}
+EXPORT_SYMBOL(lpfc_sliport_term);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION(LPFC_MODULE_DESC);
+MODULE_AUTHOR("Emulex Corporation - tech.support@emulex.com");
+MODULE_VERSION("0:" LPFC_DRIVER_VERSION);
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_api.h 4.0-rc7/drivers/scsi/lpfc/lpfc_target_api.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_api.h	1970-01-01 01:00:00.000000000 +0100
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_target_api.h	2015-04-12 11:36:20.966140847 +0200
@@ -0,0 +1,155 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2003-2008 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+#ifndef _H_LPFC_TGT_API
+#define _H_LPFC_TGT_API
+
+#include <linux/version.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+
+#define putPaddrLow(addr)    ((uint32_t) (0xffffffff & (u64)(addr)))
+#define putPaddrHigh(addr)   ((uint32_t) (0xffffffff & (((u64)(addr))>>32)))
+#define getPaddr(high, low)  ((dma_addr_t)( \
+				(( (u64)(high)<<16 ) << 16)|( (u64)(low))))
+
+typedef void *tm_tgtport_handle_t;
+typedef void *tm_login_handle_t;
+typedef void *tm_sliport_handle_t;
+
+/* API version values */
+#define        TM_API_VERSION_1        1
+#define        TM_API_VERSION_2        2
+
+/* Protocol type values */
+#define        TM_PROTO_FC             0
+
+/* SLI Port abstraction */
+
+typedef	struct tm_sliport_info_s {
+	uint32_t sli_version;		/* explicit PCB word 0 */
+	uint16_t max_tgt_contexts;	/* maximum # of tgt mode I/O contexts */
+	uint16_t iotag16_mask;
+	struct	pci_dev *pcidev;
+	int flags;
+} tm_sliport_info_t;
+
+/* Target port abstaction */
+typedef struct tm_tgtport_info_s {
+	uint32_t sli_version;
+	uint16_t max_tgt_contexts;
+	uint16_t iotag16_mask;
+	uint32_t protocol_type;
+	union {
+		struct fc_proto_info_s {
+			uint8_t fc_port_name[8];
+			uint8_t fc_node_name[8];
+		} fc_proto_info;
+	} proto_u;
+	struct pci_dev *pcidev;
+	int flags;
+} tm_tgtport_info_t;
+
+/* Flags for Target Port */
+#define LPFC_TM_SLI3_HBQ_ENABLED	1   /* Port used HBQs */
+#define LPFC_TM_HBQ_TAGS_SUPPORTED	2
+
+#define        fc_protoinfo        proto_u.fc_proto_info
+
+typedef union tm_login_info_u {
+	struct fc_login_info_s {
+		uint8_t fc_port_name[8];
+		uint8_t fc_node_name[8];
+		uint32_t fc_id;
+		uint32_t local_fc_id;
+	} fc_login_info;
+} tm_login_info_t;
+
+
+struct tm_lpfc_dmabuf {
+	struct list_head list;
+	void *virt;		/* virtual address ptr */
+	dma_addr_t phys;	/* mapped address */
+	uint32_t   buffer_tag;
+};
+
+struct tm_hbq_dmabuf {
+	struct tm_lpfc_dmabuf hbuf;
+	struct tm_lpfc_dmabuf dbuf;
+	uint32_t size;
+	uint32_t tag;
+/* FIXME */
+/*
+	struct lpfc_cq_event cq_event;
+	unsigned long time_stamp;
+*/
+};
+
+typedef struct tm_driver_data_s {
+	uint32_t api_version;
+	uint32_t (*tm_tgtport_bind)(tm_tgtport_handle_t base_handle,
+					tm_tgtport_info_t *portinfo,
+					tm_tgtport_handle_t *tgt_handle);
+	void (*tm_tgtport_req_unbind)(tm_tgtport_handle_t tgt_handle);
+	void (*tm_tgtport_reset)(tm_tgtport_handle_t tgt_handle);
+	uint32_t (*tm_tgtport_chk_login)(tm_tgtport_handle_t tgt_handle,
+					tm_login_info_t *logininfo);
+	tm_login_handle_t (*tm_tgtport_login)(tm_tgtport_handle_t tgt_handle,
+					uint16_t rpi,
+					tm_login_info_t *logininfo);
+	void (*tm_tgtport_logout)(tm_login_handle_t tgt_login_handle);
+	void (*tm_rsp_recv)(tm_tgtport_handle_t tgt_handle, IOCB_t *iocb);
+	void (*tm_hbq_alloc)(tm_sliport_handle_t tgt_slihandle,
+					struct tm_hbq_dmabuf *hbqbp);
+	uint32_t (*tm_sliport_init)(tm_sliport_handle_t lpfc_port_handle,
+			tm_sliport_info_t *sliport_info,
+			tm_sliport_handle_t *tgt_slihandle);
+	void (*tm_sliport_term)(tm_sliport_handle_t tgt_slihandle);
+	uint32_t (*tm_tgtport_bind_v2)(tm_sliport_handle_t tgt_slihandle,
+			tm_tgtport_handle_t base_handle,
+			tm_tgtport_info_t *portinfo,
+			tm_tgtport_handle_t *tgt_handle);
+	void (*tm_sliport_reset)(tm_sliport_handle_t tgt_slihandle);
+	void (*tm_hbq_free)(tm_sliport_handle_t tgt_slihandle,
+					struct tm_hbq_dmabuf *hbqbp);
+	uint32_t tm_num_hbq_buf;
+} tm_driver_data_t;
+
+/* function return codes */
+#define        TM_RCD_SUCCESS     0
+#define        TM_RCD_FAILURE     1
+#define        TM_RCD_FULL        2
+#define        TM_RCD_BUSY        3
+#define        TM_RCD_INVALID     4
+
+uint32_t lpfc_tm_version(void);
+uint32_t lpfc_tm_init(tm_driver_data_t *tgt_data);
+void lpfc_tm_term(void);
+void lpfc_tm_tgtport_unbind(tm_tgtport_handle_t base_handle);
+uint32_t lpfc_tm_cmd_send(tm_sliport_handle_t lpfc_sliport_handle,
+			  tm_tgtport_handle_t base_handle,
+			  IOCB_t *iocb, uint32_t iocb_wd_len);
+void lpfc_tm_rsp_poll(tm_sliport_handle_t lpfc_port_handle,
+			  uint32_t max_responses);
+void lpfc_tm_poll_set(tm_sliport_handle_t lpfc_port_handle,
+			  uint32_t enable);
+void lpfc_tm_init_link(tm_tgtport_handle_t base_handle);
+int lpfc_sliport_term(tm_sliport_handle_t lpfc_port_handle);
+#endif				/* _H_LPFC_TGT_API */
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_api_base.h 4.0-rc7/drivers/scsi/lpfc/lpfc_target_api_base.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_api_base.h	1970-01-01 01:00:00.000000000 +0100
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_target_api_base.h	2015-04-12 10:32:24.750179769 +0200
@@ -0,0 +1,45 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2003-2008 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+#ifndef _H_LPFC_TGT_API_BASE
+#define _H_LPFC_TGT_API_BASE
+#define TARGET_RING 3
+#define  RRTOV_TIME 30
+
+extern tm_driver_data_t *volatile lpfc_tgt_data;
+extern atomic_t bind_call_outstanding;
+
+typedef struct tm_tgtport_s {
+	volatile tm_tgtport_handle_t target_handle;
+	tm_tgtport_info_t info;
+	struct list_head list;
+	atomic_t calls_outstanding;
+} tm_tgtport_t;
+
+
+typedef struct tm_sliport_s {
+	tm_sliport_handle_t target_slihandle;
+	volatile uint32_t interrupt_callback_allowed;
+	atomic_t interrupt_in_progress;
+	tm_sliport_info_t info;
+	struct list_head list;
+	atomic_t calls_outstanding;
+} tm_sliport_t;
+
+#endif				/* _H_LPFC_TGT_API_BASE */
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_protos.h 4.0-rc7/drivers/scsi/lpfc/lpfc_target_protos.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_target_protos.h	1970-01-01 01:00:00.000000000 +0100
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_target_protos.h	2015-04-12 10:32:24.750179769 +0200
@@ -0,0 +1,31 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2003-2008 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+#ifndef _H_LPFC_TGT_PROTO
+#define _H_LPFC_TGT_PROTO
+void tm_check_duplicate_wwpn(struct lpfc_vport *, struct lpfc_nodelist *);
+
+uint32_t lpfc_target_new_tgtport(struct lpfc_vport *);
+uint32_t lpfc_target_rm_tgtport(struct lpfc_vport *);
+uint32_t lpfc_target_check_login(struct lpfc_vport *, struct lpfc_nodelist *);
+
+tm_login_handle_t tm_tgtport_login(struct lpfc_vport *, struct lpfc_nodelist *);
+void tm_tgtport_logout(struct lpfc_vport *, tm_login_handle_t);
+uint32_t tm_tgtport_chk_login(struct lpfc_vport *, tm_login_info_t *);
+#endif				/* _H_LPFC_TGT_PROTO */
