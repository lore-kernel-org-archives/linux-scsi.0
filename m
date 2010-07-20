From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] lpfc: Add LPFC TM API v4 WIP
Date: Tue, 20 Jul 2010 16:09:46 -0700
Message-ID: <1279667386-12750-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:20765 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933098Ab0GTXQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 19:16:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch contains the lpfc_target_api.c related functions that are required
to function existing TM API v2 HBQ I/O operation with LPFC_EXTRA_RING.  There are a
couple of significant differences with the new v4 API related to explict sliport and
tgtport configuration in order to be driven by the fabric independent configfs
infrastructure and TM child module code.

Note that backwards compat with v2 plugins is a WIP, as well as is the merge of
TM v3 support.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/Makefile               |    4 +-
 drivers/scsi/lpfc/lpfc_target_api.c      | 1375 ++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_target_api.h      |  180 ++++
 drivers/scsi/lpfc/lpfc_target_api_base.h |   45 +
 drivers/scsi/lpfc/lpfc_target_mod.h      |  159 ++++
 drivers/scsi/lpfc/lpfc_target_protos.h   |   34 +
 6 files changed, 1796 insertions(+), 1 deletions(-)
 create mode 100755 drivers/scsi/lpfc/lpfc_target_api.c
 create mode 100755 drivers/scsi/lpfc/lpfc_target_api.h
 create mode 100755 drivers/scsi/lpfc/lpfc_target_api_base.h
 create mode 100755 drivers/scsi/lpfc/lpfc_target_mod.h
 create mode 100755 drivers/scsi/lpfc/lpfc_target_protos.h

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index ad05d6e..752e232 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -24,8 +24,10 @@ ifneq ($(GCOV),)
   EXTRA_CFLAGS += -O0
 endif
 
+EXTRA_CFLAGS += -DLPFC_TARGET_MODE
+
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	\
 	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o lpfc_scsi.o lpfc_attr.o \
-	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
+	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o lpfc_target_api.o
diff --git a/drivers/scsi/lpfc/lpfc_target_api.c b/drivers/scsi/lpfc/lpfc_target_api.c
new file mode 100755
index 0000000..c3ed9b7
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_target_api.c
@@ -0,0 +1,1375 @@
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
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#include "lpfc_target_mod.h"
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
+#include "lpfc_scsi.h"
+#include "lpfc.h"
+#include "lpfc_logmsg.h"
+#include "lpfc_target_protos.h"
+#include "lpfc_crtn.h"
+
+int lpfctm_num_hba;
+static int init_called;
+atomic_t bind_call_outstanding = ATOMIC_INIT(0);
+
+/*
+ * Do NOT try to acquire tm_global_spinlock while holding any
+ * exchange locks.  OK to acquire exchange locks while holding
+ * global lock.
+ */
+spinlock_t tm_global_spinlock;
+struct target_sliport_s *tm_first_sliport;
+struct target_tgtport_s *tm_first_tgtport;
+
+atomic_t tm_exiting = ATOMIC_INIT(0);
+atomic_t tm_bind_inp = ATOMIC_INIT(0);
+atomic_t tm_sliinit_inp = ATOMIC_INIT(0);
+
+static uint32_t tm_num_tgt_ports;
+static uint32_t tm_num_sli_ports;
+
+#if 0
+static void lpfc_tm_run_queue(struct target_sliport_s *sliport)
+{
+	struct target_exchange_s *exchange;
+	void *base_handle;
+	uint32_t status;
+
+	while (!list_empty(&sliport->command_iocb_wait)) {
+		exchange = list_entry(sliport->command_iocb_wait.next,
+				struct target_exchange_s, list);
+
+//		exchange->flags |= TEFLAG_IO_INPROGRESS;
+		base_handle = exchange->owner->base_handle;
+		status = lpfc_tm_cmd_send(sliport->sliport_handle,
+				base_handle, &exchange->iocb, 8);
+
+		if (status == TM_RCD_FULL || status == TM_RCD_BUSY) {
+			printk(KERN_INFO "Cmd send wait iocb: error %d xri"
+				" x%x\n", status, exchange->xri);
+//			exchange->flags &= ~TEFLAG_IO_INPROGRESS;
+			return;
+		}
+		list_del(&exchange->list);
+	}
+}
+
+static void lpfc_tm_watchdog(unsigned long arg)
+{
+	struct target_sliport_s *sliport = (struct target_sliport_s *)arg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sliport->spin_lock, flags);
+	if (!list_empty(&sliport->command_iocb_wait))
+		lpfc_tm_run_queue(sliport);
+	spin_unlock_irqrestore(&sliport->spin_lock, flags);
+
+	sliport->watchdog_timer.expires = jiffies + HZ / 10;
+	add_timer(&sliport->watchdog_timer);
+}
+#endif
+
+static int lpfc_tm_sliport_init(
+	tm_sliport_handle_t lpfc_port_handle,
+	tm_sliport_info_t *portinfo,
+	tm_sliport_handle_t *tgt_slihandle)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)lpfc_port_handle;
+	struct target_sliport_s *sliport;
+	uint32_t max_rpis, max_xris;
+	int status;
+	/*
+	 * set a flag to indicate a bind in progress.
+	 * need to use this to resolve race between
+	 * this bind and unbind within the target exit routing
+	 */
+	atomic_inc(&tm_sliinit_inp);
+	if (atomic_read(&tm_exiting)) {
+		atomic_dec(&tm_sliinit_inp);
+		return TM_RCD_FAILURE;
+	}
+	/*
+	 * Running in target mode requires at least SLI3 firmware.
+	 */
+	if (!(portinfo->flags & LPFC_TM_SLI3_HBQ_ENABLED)) {
+		printk(KERN_ERR "Init Failure: sliport: Handle %p, "
+			"SLI-3 ERBM mode is required\n",
+			lpfc_port_handle);
+		printk(KERN_ERR "Minimum 4Gb HBA with SLI-3 firmware"
+			" required\n");
+		atomic_dec(&tm_sliinit_inp);
+		return TM_RCD_FAILURE;
+	}
+	if (!(portinfo->flags & LPFC_TM_HBQ_TAGS_SUPPORTED)) {
+		printk(KERN_ERR "Init Failure: sliport: Handle %p, "
+			"SLI-3 HBQ buffer tag support required\n",
+			lpfc_port_handle);
+		atomic_dec(&tm_sliinit_inp);
+		return TM_RCD_FAILURE;
+	}
+
+	status = lpfc_tm_get_max_rpi(lpfc_port_handle, &max_rpis);
+	if (status != TM_RCD_SUCCESS) {
+		printk(KERN_ERR "Init Failure: sliport: Handle %p, error "
+			"getting max RPIs\n", lpfc_port_handle);
+		atomic_dec(&tm_sliinit_inp);
+		return TM_RCD_FAILURE;
+	}
+	/*
+	 * Calc number of HBQ buffers supported from the HBA's max XRI.
+	 * Default to the HBA's maximum.  Always hold a number of unused
+	 * spare as the base driver pushes a new HBQ buffer before
+	 * sending up the SCSI command.
+	 */
+#warning FIXME: lpfc_tm_sliport_init() + max_xris is hardcoded
+#if 0
+	if (lpfc_tm_max_exchanges &&
+	    lpfc_tm_max_exchanges < portinfo->max_tgt_contexts)
+		portinfo->max_tgt_contexts = lpfc_tm_max_exchanges;
+
+	max_xris = portinfo->max_tgt_contexts + lpfc_tm_extra_exchanges;
+#else
+	max_xris = portinfo->max_tgt_contexts + 1024;
+#endif
+	/*
+	 * Call phba->tgt_data->tm_sliport_allocate() to setup
+	 * struct target_sliport_s *sliport based on TM child module
+	 * provided
+	 */
+	if (phba->tgt_data->tm_sliport_allocate) {
+		sliport = phba->tgt_data->tm_sliport_allocate(portinfo,
+					max_rpis, max_xris);
+		if (!sliport) {
+			printk(KERN_INFO "Init Failure: sliport: Handle %p\n",
+					lpfc_port_handle);
+			atomic_dec(&tm_sliinit_inp);
+			return TM_RCD_FAILURE;
+		}
+	}
+
+	sliport->sliport_handle = lpfc_port_handle;
+	*tgt_slihandle = (tm_sliport_handle_t)sliport;
+	sliport->state = SLIPORT_BOUND;
+
+	printk(KERN_INFO "Sliport Init Success\n");
+
+	/* start a watch dog timer to post any stranded IOCBs */
+#if 0
+	init_timer(&sliport->watchdog_timer);
+	sliport->watchdog_timer.function = lpfc_tm_watchdog;
+	sliport->watchdog_timer.data = (unsigned long)sliport;
+	sliport->watchdog_timer.expires = jiffies + HZ / 10;
+	add_timer(&sliport->watchdog_timer);
+#endif
+	if (!tm_first_sliport)
+		tm_first_sliport = sliport;
+
+	/* Initialize the QUEUE FULL detection mechanism */
+	atomic_set(&sliport->outstanding_cmd_cnt, 0);
+#if 0
+	spin_lock_irqsave(&tm_global_spinlock, flags);
+	list_add(&sliport->sliport_list, &tm_sliport_list_head);
+	spin_unlock_irqrestore(&tm_global_spinlock, flags);
+#endif
+	atomic_dec(&tm_sliinit_inp);
+	return TM_RCD_SUCCESS;
+}
+
+/*
+ * Legacy <= TM v3 API operations call this directly from lpfc_tgt_init() below.
+ *
+ * TM v4 API consumers are allowed to call this explictly during WWPN registration.
+ */
+int lpfc_target_sliport_init(
+	struct lpfc_hba *phba,
+	struct pci_dev *pci_dev,
+	tm_driver_data_t *fabric_tgt_data)
+{
+	uint32_t           result;
+	tm_sliport_info_t *sliport_info;
+	tm_sliport_t      *sliport = &phba->target_sliport;
+	struct lpfc_sli2_slim *p2slim =
+		(struct lpfc_sli2_slim *)phba->slim2p.virt;
+	struct lpfc_sli *psli;
+	struct lpfc_sli_ring *pring;
+
+	/* set up parameters in port info */
+	sliport_info = &phba->target_sliport.info;
+	sliport_info->sli_version = *(uint32_t *)&p2slim->pcb;
+	sliport_info->iotag16_mask = 0xc000;
+	sliport_info->pcidev = phba->pcidev;
+
+	/* allow negotiation on init call if hbq num is zero in driver data */
+	sliport_info->max_tgt_contexts = phba->cfg_hba_queue_depth;
+	if (fabric_tgt_data->tm_num_hbq_buf &&
+	   (fabric_tgt_data->tm_num_hbq_buf < sliport_info->max_tgt_contexts))
+		sliport_info->max_tgt_contexts = fabric_tgt_data->tm_num_hbq_buf;
+
+	printk("lpfc_target_sliport_init() fabric_tgt_data->tm_num_hbq_buf: %u\n",
+			fabric_tgt_data->tm_num_hbq_buf);
+	printk("lpfc_target_sliport_init() uising max_tgt_contexts: %u\n",
+			sliport_info->max_tgt_contexts);
+
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		sliport_info->flags |= LPFC_TM_SLI3_HBQ_ENABLED;
+		sliport_info->flags |= LPFC_TM_HBQ_TAGS_SUPPORTED;
+	} else {
+		sliport_info->flags &= ~LPFC_TM_SLI3_HBQ_ENABLED;
+		sliport_info->flags &= ~LPFC_TM_HBQ_TAGS_SUPPORTED;
+	}
+	/*
+	 * Assign passed tm_driver_data_t * pointer to struct lpfc_hba
+	 * for use with subsequent HBA context specific TM API child
+	 * fabric module calls.
+	 */
+	phba->tgt_data = fabric_tgt_data;
+
+	/* Initialize the >= SLI v3 TM API infrastructure */
+#warning FIXME: Accept max_exchanges and extra_exchanges from child module
+	result = lpfc_tm_sliport_init(phba, sliport_info,
+			&phba->target_sliport.target_slihandle);
+
+	if (result != TM_RCD_SUCCESS) {
+		phba->tgt_data = NULL;
+		return result;
+	}
+
+	psli = &phba->sli;
+	pring = &psli->ring[LPFC_EXTRA_RING];
+
+	/* protect against user brain damage */
+	if (sliport_info->max_tgt_contexts > phba->cfg_hba_queue_depth)
+		sliport_info->max_tgt_contexts =
+			phba->cfg_hba_queue_depth;
+
+	/* Setup PRING function pointer for unsolicited recvs */
+	pring->prt[0].lpfc_sli_rcv_unsol_event = lpfc_tm_recv_unsol;
+	/*
+	 * Setup the hbq_alloc_buffer() and hbq_free_buffer() function
+	 * for LPFC_EXTRA_HBQ, and call fill up the HBQs.
+	 */
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		phba->hbqs[LPFC_EXTRA_HBQ].hbq_alloc_buffer =
+				lpfc_tm_hbq_alloc;
+		phba->hbqs[LPFC_EXTRA_HBQ].hbq_free_buffer =
+				lpfc_tm_hbq_free;
+		if (lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_EXTRA_HBQ,
+				sliport_info->max_tgt_contexts) <= 0) {
+			result = TM_RCD_FAILURE;
+		}
+	}
+	sliport->interrupt_callback_allowed = 0;
+	atomic_set(&sliport->interrupt_in_progress, 0);
+
+#warning Convert to return errno to tcm_lpfc_configfs.c:tcm_lpfc_make_lport()
+	return result;
+}
+EXPORT_SYMBOL(lpfc_target_sliport_init);
+
+static int
+lpfc_tgt_init(tm_driver_data_t *tgt_data)
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
+		printk(KERN_ERR "lpfctm: 2690 "
+			"No lpfc HBAs supporting target mode found\n");
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
+			result = lpfc_target_sliport_init(phba, dev, tgt_data);
+			if (result) {
+				lpfc_printf_log(phba, KERN_ERR,
+					LOG_INIT | LOG_TARGET,
+					"2691 Unable to init target sliport\n");
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
+			if (!phba->cfg_tgt_brings_link_up)
+				lpfc_tm_init_link(phba);
+		}
+	}
+	return 0;
+}
+
+static int
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
+static inline void
+tm_rsp_recv(struct lpfc_vport *vport, IOCB_t *iocb)
+{
+	struct lpfc_hba *phba = vport->phba;
+	tm_tgtport_handle_t target_handle;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	target_handle = vport->target_tgtport.target_handle;
+	if (target_handle)
+		phba->tgt_data->tm_rsp_recv(target_handle, iocb);
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+}
+
+void
+lpfc_tm_recv_unsol(struct lpfc_hba *phba,
+	     struct lpfc_sli_ring *pring, struct lpfc_iocbq *iocb)
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
+				&phba->rb_pend_list, list) {
+			hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
+			hbqno = lpfc_hbqno_get(hbq_buf->tag);
+			if (hbqno == LPFC_EXTRA_HBQ) {
+				list_del(&hbq_buf->dbuf.list);
+				kfree(hbq_buf);
+			}
+		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+	}
+	return;
+}
+
+static void
+lpfc_tm_recv_sol(struct lpfc_hba *phba,
+	    struct lpfc_iocbq *cmdiocb, struct lpfc_iocbq *rspiocb)
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
+struct hbq_dmabuf *lpfc_tm_hbq_alloc(struct lpfc_hba *phba)
+{
+	struct hbq_dmabuf *hbqbp;
+	tm_sliport_handle_t *tm_sliport;
+	struct tm_hbq_dmabuf *tm_hbqbp;
+
+	hbqbp = kzalloc(sizeof(struct hbq_dmabuf), GFP_ATOMIC);
+	if (!hbqbp)
+		return NULL;
+
+	tm_hbqbp = (struct tm_hbq_dmabuf *)hbqbp;
+	atomic_inc(&phba->target_sliport.calls_outstanding);
+	tm_sliport = phba->target_sliport.target_slihandle;
+	/*
+	 * Check if the TM child module will be using it's own
+	 * internal tm_hbq_alloc() logic.
+	 */
+	if (tm_sliport && phba->tgt_data->tm_hbq_alloc)
+		phba->tgt_data->tm_hbq_alloc(tm_sliport, hbqbp);
+
+	atomic_dec(&phba->target_sliport.calls_outstanding);
+	if (hbqbp->dbuf.virt == NULL) {
+		kfree(hbqbp);
+		return NULL;
+	}
+	return hbqbp;
+}
+
+void
+lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
+{
+	tm_sliport_handle_t tm_sliport;
+	struct tm_hbq_dmabuf *tm_hbqbp;
+
+	tm_hbqbp = (struct tm_hbq_dmabuf *)hbqbp;
+	hbqbp->tag = lpfc_hbq_app_tag_get(hbqbp->tag);
+	atomic_inc(&phba->target_sliport.calls_outstanding);
+	tm_sliport = phba->target_sliport.target_slihandle;
+
+	if (tm_sliport && phba->tgt_data->tm_hbq_free)
+		phba->tgt_data->tm_hbq_free(tm_sliport, hbqbp);
+
+	atomic_dec(&phba->target_sliport.calls_outstanding);
+	kfree(hbqbp);
+	return;
+}
+
+/* encapsulate all calls to target module */
+uint32_t
+tm_tgtport_bind(struct lpfc_vport *vport, tm_tgtport_info_t *portinfo)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	uint32_t result;
+
+	atomic_inc(&bind_call_outstanding);
+	if (phba->tgt_data) {
+		if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
+			portinfo->flags |= LPFC_TM_SLI3_HBQ_ENABLED;
+		else
+			portinfo->flags &= ~LPFC_TM_SLI3_HBQ_ENABLED;
+
+		/* let remote initiators login to target */
+		vport->cfg_restrict_login = 0;
+
+		result =
+		    phba->tgt_data->tm_tgtport_bind_v2(
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
+lpfc_tm_tgtport_chk_login(struct lpfc_vport *vport, tm_login_info_t *logininfo)
+{
+	struct lpfc_hba *phba = vport->phba;
+	tm_tgtport_handle_t target_handle;
+	uint32_t result;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	target_handle = vport->target_tgtport.target_handle;
+	if (target_handle)
+		result =
+		    phba->tgt_data->tm_tgtport_chk_login(target_handle,
+							logininfo);
+	else
+		result = TM_RCD_FAILURE;
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+	return result;
+}
+
+tm_login_handle_t
+lpfc_tm_tgtport_login(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba *phba = vport->phba;
+	tm_tgtport_handle_t target_handle;
+	tm_login_handle_t result;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	target_handle = vport->target_tgtport.target_handle;
+	if (target_handle) {
+		tm_check_duplicate_wwpn(vport, ndlp);
+		result = phba->tgt_data->tm_tgtport_login(target_handle,
+				 ndlp->nlp_rpi, &ndlp->tm_login_info);
+	} else
+		result = 0;
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+	return result;
+}
+
+void
+lpfc_tm_tgtport_logout(struct lpfc_vport *vport, tm_login_handle_t tgt_login_handle)
+{
+	struct lpfc_hba *phba = vport->phba;
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
+	if (phba->tgt_data == NULL)	/* lpfc_tm_term() already called */
+		return;
+
+	atomic_inc(&vport->target_tgtport.calls_outstanding);
+	phba->tgt_data->tm_tgtport_logout(tgt_login_handle);
+	atomic_dec(&vport->target_tgtport.calls_outstanding);
+}
+
+uint32_t
+lpfc_tm_version(void)
+{
+	return TM_API_VERSION_2;
+}
+EXPORT_SYMBOL(lpfc_tm_version);
+
+uint32_t
+lpfc_tm_init(tm_driver_data_t *tgt_data)
+{
+	int status;
+
+	if (init_called) {
+		printk(KERN_ERR "lpfctm: "
+				"2692 multiple init of target module\n");
+		return TM_RCD_INVALID;
+	}
+	if (tgt_data->api_version != TM_API_VERSION_2)
+		return TM_RCD_INVALID;
+
+	status = lpfc_tgt_init(tgt_data);
+	if (status) {
+		init_called = 0;
+		return status;
+	}
+	init_called = 1;
+	return status;
+}
+EXPORT_SYMBOL(lpfc_tm_init);
+
+struct target_tgtport_s *lpfc_tm_init_tgtport(
+	tm_sliport_handle_t tgt_slihandle,
+	tm_tgtport_handle_t base_handle,
+	tm_tgtport_info_t *portinfo,
+	tm_tgtport_handle_t *tgt_handle)
+{
+	struct target_tgtport_s *tgtport;
+	struct target_sliport_s *sliport;
+	/*
+	 * set a flag to indicate a bind in progress.
+	 * need to use this to resolve race between
+	 * this bind and unbind within the target exit routing.
+	 */
+	atomic_inc(&tm_bind_inp);
+	if (atomic_read(&tm_exiting)) {
+		atomic_dec(&tm_bind_inp);
+		return NULL;
+	}
+	tgtport = kzalloc(sizeof(struct target_tgtport_s), GFP_ATOMIC);
+	if (!(tgtport)) {
+		printk(KERN_ERR "Bind Failure: tgtport: Handle %p\n",
+			base_handle);
+		atomic_dec(&tm_bind_inp);
+		return NULL;
+	}
+	tgtport->portinfo = portinfo;
+	tgtport->tgt_sliport = tgt_slihandle;
+	tgtport->base_handle = base_handle;
+	tgtport->port_no = tm_num_tgt_ports++;
+
+	*tgt_handle = (tm_tgtport_handle_t) tgtport;
+	tgtport->state = TGTPORT_BOUND;
+
+	sliport = tgtport->tgt_sliport;
+	atomic_inc(&sliport->sliport_num_tgt_ports);
+
+	printk(KERN_INFO "Bind Success WWPN: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+		portinfo->proto_u.fc_proto_info.fc_port_name[0],
+		portinfo->proto_u.fc_proto_info.fc_port_name[1],
+		portinfo->proto_u.fc_proto_info.fc_port_name[2],
+		portinfo->proto_u.fc_proto_info.fc_port_name[3],
+		portinfo->proto_u.fc_proto_info.fc_port_name[4],
+		portinfo->proto_u.fc_proto_info.fc_port_name[5],
+		portinfo->proto_u.fc_proto_info.fc_port_name[6],
+		portinfo->proto_u.fc_proto_info.fc_port_name[7]);
+
+	if (!tm_first_tgtport)
+		tm_first_tgtport = tgtport;
+
+	atomic_dec(&tm_bind_inp);
+	return tgtport;
+}
+
+struct target_tgtport_s *lpfc_target_new_tgtport(struct lpfc_vport *vport)
+{
+	tm_tgtport_t     *tgtport = &vport->target_tgtport;
+	struct target_tgtport_s *target_tgtport;
+	struct lpfc_hba  *phba = vport->phba;
+	uint32_t max_xri;
+	struct lpfc_sli2_slim *p2slim =
+		(struct lpfc_sli2_slim *)phba->slim2p.virt;
+#if 0
+	if (unlikely(phba->tgt_data != NULL)) {
+		/* unlikely to get here. Means a new
+		 * tgtport appeared after unloading the
+		 * target driver.  So just return 0.
+		 */
+		dump_stack();
+		return 0;
+	}
+#endif
+	printk("lpfc_target_new_tgtport(): Using phba->tgt_data: %p API Rev:"
+		" %d\n", phba->tgt_data, phba->tgt_data->api_version);
+	/* initialize tgtport struct */
+	memset(tgtport, 0, sizeof(tm_tgtport_t));
+	atomic_set(&tgtport->calls_outstanding, 0);
+
+	/* set up parameters in port info */
+	tgtport->info.sli_version = *(uint32_t *)&p2slim->pcb;
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
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT | LOG_TARGET,
+			"2693 lpfc_target_new_tgtport max_xri %d\n", max_xri);
+		return NULL;
+	}
+	/*
+	 * Now let the target driver know. Binds both phys & npiv ports
+	 * tm_sliport_init must have already been called for this hba.
+	 */
+	atomic_inc(&bind_call_outstanding);
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
+		tgtport->info.flags |= LPFC_TM_SLI3_HBQ_ENABLED;
+	else
+		tgtport->info.flags &= ~LPFC_TM_SLI3_HBQ_ENABLED;
+
+	/* let remote initiators login to target */
+	vport->cfg_restrict_login = 0;
+
+	target_tgtport = lpfc_tm_init_tgtport(phba->target_sliport.target_slihandle,
+			(tm_tgtport_handle_t)vport,
+			&tgtport->info,
+			(tm_tgtport_handle_t *)&vport->target_tgtport.
+			target_handle);
+	if (target_tgtport)
+		phba->num_targets_bound++;
+	tgtport->info.max_tgt_contexts = max_xri;
+
+	return target_tgtport;
+}
+EXPORT_SYMBOL(lpfc_target_new_tgtport);
+
+void __lpfc_tm_tgtport_unbind(tm_tgtport_handle_t base_handle);
+
+uint32_t
+lpfc_tm_tgtport_unbind(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	tm_tgtport_t     *tgtport = &vport->target_tgtport;
+
+	if (!(phba->tgt_data)) {
+		/* unlikely to get here. Means a new
+		 * tgtport appeared after unloading the
+		 * target driver.  So just return 0.
+		 */
+		return 0;
+	}
+	/* now let the target driver know */
+	__lpfc_tm_tgtport_unbind(tgtport);
+	return 1;
+}
+EXPORT_SYMBOL(lpfc_tm_tgtport_unbind);
+
+/* check for a node already logged in with the same port name.
+ * If found, then log it out of the target
+ */
+void
+tm_check_duplicate_wwpn(struct lpfc_vport *vport,
+				struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_nodelist *ndlp1;
+
+	list_for_each_entry(ndlp1, &vport->fc_nodes, nlp_listp) {
+		if (memcmp(&ndlp->nlp_portname,
+				&ndlp1->nlp_portname, 8) == 0 &&
+				ndlp != ndlp1 &&
+				ndlp1->login_handle_valid) {
+
+			/* found duplicate needs to be logged out */
+			lpfc_tm_tgtport_logout(vport, ndlp1->login_handle);
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
+	ndlp->tm_check_login_result = lpfc_tm_tgtport_chk_login(vport, p);
+	return ndlp->tm_check_login_result;
+}
+
+void
+__lpfc_tm_tgtport_unbind(tm_tgtport_handle_t base_handle)
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
+	return;
+}
+
+uint32_t
+lpfc_tm_cmd_send(tm_sliport_handle_t lpfc_sliport_handle,
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
+	if (lpfc_sli_issue_iocb(phba, pring->ringno, tmiocb, 0)) {
+		lpfc_sli_release_iocbq(phba, tmiocb);
+		return TM_RCD_FULL;  /* ring is full */
+	}
+	return 0;
+}
+EXPORT_SYMBOL(lpfc_tm_cmd_send);
+
+void
+lpfc_tm_rsp_poll(tm_sliport_handle_t lpfc_port_handle,
+				uint32_t max_responses)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)lpfc_port_handle;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring = &psli->ring[LPFC_EXTRA_RING];
+	uint32_t ha_copy;
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
+void
+lpfc_tm_poll_set(tm_sliport_handle_t lpfc_port_handle, uint32_t enable)
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
+void
+lpfc_tm_term(void)
+{
+	/* wait for any outstanding bind calls to complete
+	 * before returning.  Don't want the target driver
+	 * to unload while a call to it is still in progress.
+	 */
+	while (atomic_read(&bind_call_outstanding))
+		schedule_timeout(10);
+	lpfc_tgt_exit();
+	init_called = 0;
+	return;
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
+	return;
+}
+
+void lpfc_tm_init_link(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_port_handle;
+	LPFC_MBOXQ_t *pmb;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_LINK_EVENT | LOG_TARGET,
+			"2694 Unable to allocate mailbox mem\n");
+		return ;
+	}
+
+	printk("Calling lpfc_tm_linkdown for phba: %p\n", phba);
+	lpfc_tm_linkdown(phba);
+	printk("Calling lpfc_init_link() with cfg_topology: 0x%08x"
+		" cfg_link_speed: %u\n", phba->cfg_topology, phba->cfg_link_speed);
+	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
+	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_WARNING,
+			LOG_MBOX | LOG_LINK_EVENT | LOG_TARGET,
+			"2695 init_link mailbox command unsuccessful\n");
+		lpfc_init_link(phba, pmb, phba->cfg_topology,
+				phba->cfg_link_speed);
+		if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS)
+			lpfc_printf_log(phba, KERN_ERR,
+				LOG_MBOX | LOG_LINK_EVENT | LOG_TARGET,
+				"2696 init_link mbox command retry failed\n");
+	}
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
+EXPORT_SYMBOL(lpfc_tm_init_link);
+
+void lpfc_tm_down_link(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)lpfc_port_handle;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_LINK_EVENT | LOG_TARGET,
+			"2697 Unable to allocate mbox mem\n");
+		return ;
+	}
+	mb = &pmb->u.mb;
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+
+	mb->mbxCommand = MBX_DOWN_LINK;
+	mb->mbxOwner = OWN_HOST;
+	printk("Calling MBX_DOWN_LINK for phba: %p\n", phba);
+	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS)
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_LINK_EVENT | LOG_TARGET,
+			"2698 down_link mbox command unsuccessful\n");
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
+EXPORT_SYMBOL(lpfc_tm_down_link);
+
+int lpfc_sliport_term(struct lpfc_hba *phba)
+{
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
+	/*
+	 * Check if the TM child module is presenting it's own tm_sliport_term()
+	 * logic.
+	 */
+	if (phba->tgt_data && phba->tgt_data->tm_sliport_term) {
+		phba->tgt_data->tm_sliport_term(phba->target_sliport.target_slihandle);
+		phba->tgt_data = NULL;
+	}
+	tm_num_sli_ports--;
+
+	printk(KERN_INFO "Sliport Term Success\n");
+
+	return TM_RCD_SUCCESS;
+}
+EXPORT_SYMBOL(lpfc_sliport_term);
+
+static void
+lpfc_tm_terp_reg_login_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
+{
+	struct lpfc_nodelist *ndlp;
+
+	if (pmboxq->u.mb.mbxStatus != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_INIT | LOG_TARGET,
+			"2700 Unable to enable FC-4 tERP support "
+			"status=x%x\n", pmboxq->u.mb.mbxStatus);
+		ndlp = (struct lpfc_nodelist *)pmboxq->context1;
+		ndlp->tm_login_flags &= ~NLP_TM_FCP_4_ERP;
+	}
+	pmboxq->context1 = NULL;
+	pmboxq->mbox_cmpl = NULL;
+	mempool_free(pmboxq, phba->mbox_mem_pool);
+}
+
+void lpfc_tm_terp_reg_login(
+	struct lpfc_vport *vport,
+	struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba   *phba = vport->phba;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+	int rc;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_INIT | LOG_TARGET,
+			"2701 Unable to allocate mailbox mem\n");
+		ndlp->tm_login_flags &= ~NLP_TM_FCP_4_ERP;
+		return;
+	}
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+
+	mb = &pmb->u.mb;
+	mb->mbxOwner = OWN_HOST;
+	mb->mbxCommand = MBX_REG_LOGIN64;
+	mb->un.varRegLogin.rpi = ndlp->nlp_rpi;
+	mb->un.varRegLogin.did = ndlp->nlp_DID;
+	mb->un.varRegLogin.tUPD = 1;
+	if (ndlp->tm_login_flags & NLP_TM_FCP_CONF)
+		mb->un.varRegLogin.fcpConf = 1;
+	if (ndlp->tm_login_flags & NLP_TM_FCP_RETRY)
+		mb->un.varRegLogin.tERP = 1;
+	if (ndlp->tm_login_flags & NLP_TM_CISC_MODE)
+		mb->un.varRegLogin.cisc = 1;
+
+	pmb->mbox_cmpl = lpfc_tm_terp_reg_login_cmpl;
+	pmb->context1 = ndlp;
+	pmb->vport = vport;
+
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if ((rc != MBX_BUSY) && (rc != MBX_SUCCESS)) {
+		lpfc_printf_log(phba, KERN_INFO,
+			LOG_MBOX | LOG_INIT | LOG_TARGET,
+			"2702 Mailbox command unsuccessful rc=0x%x\n", rc);
+		ndlp->tm_login_flags &= ~NLP_TM_FCP_4_ERP;
+		mempool_free(pmb, phba->mbox_mem_pool);
+	}
+}
+
+static void
+lpfc_tm_get_hba_terp_cap_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
+{
+	if (pmboxq->u.mb.mbxStatus != MBX_SUCCESS) {
+		/* Fail silently on older firmware */
+		mempool_free(pmboxq, phba->mbox_mem_pool);
+		return;
+	}
+
+	if (pmboxq->u.mb.un.varPortCapabilities.un.qts.ConfmComplAllowed)
+		phba->tm_terp_capabilities |= TM_TERP_FCP_CONF;
+	if (pmboxq->u.mb.un.varPortCapabilities.un.qts.Retry)
+		phba->tm_terp_capabilities |= TM_TERP_FCP_RETRY;
+	if (pmboxq->u.mb.un.varPortCapabilities.un.qts.TaskRetryIdReq)
+		phba->tm_terp_capabilities |= TM_TERP_FCP_RETRY_ID;
+
+	mempool_free(pmboxq, phba->mbox_mem_pool);
+}
+
+void
+lpfc_tm_get_hba_terp_cap(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+	int rc;
+
+	/* SLI-3 extended IOCB required to respond to an SRR request */
+	phba->tm_terp_capabilities = 0;
+	if (!phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
+		return;
+	if (!phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+		return;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_INIT | LOG_TARGET,
+			"2703 Unable to allocate mailbox mem\n");
+		return;
+	}
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+
+	mb = &pmb->u.mb;
+	mb->mbxOwner = OWN_HOST;
+	mb->mbxCommand = MBX_PORT_CAPABILITIES;
+	mb->un.varPortCapabilities.cpn = PORT_CAPABILITY_TERP_CPN;
+	pmb->mbox_cmpl = lpfc_tm_get_hba_terp_cap_cmpl;
+	pmb->vport = vport;
+
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if ((rc != MBX_BUSY) && (rc != MBX_SUCCESS)) {
+		lpfc_printf_log(phba, KERN_ERR,
+			LOG_MBOX | LOG_INIT | LOG_TARGET,
+			"2704 Mailbox command unsuccessful rc=0x%x\n", rc);
+		mempool_free(pmb, phba->mbox_mem_pool);
+	}
+}
+
+int
+lpfc_tm_get_board_number(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba   *phba = (struct lpfc_hba *)lpfc_port_handle;
+
+	return phba->brd_no;
+}
+EXPORT_SYMBOL(lpfc_tm_get_board_number);
+
+int
+lpfc_tm_get_port_number(tm_tgtport_handle_t target_handle)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)target_handle;
+
+	return vport->vpi;
+}
+EXPORT_SYMBOL(lpfc_tm_get_port_number);
+
+uint32_t
+lpfc_tm_get_port_terp_capabilities(tm_sliport_handle_t lpfc_port_handle)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)lpfc_port_handle;
+
+	return phba->tm_terp_capabilities;
+}
+EXPORT_SYMBOL(lpfc_tm_get_port_terp_capabilities);
+
+uint32_t
+lpfc_tm_get_node_terp_capabilities(tm_tgtport_handle_t target_handle,
+		uint16_t rpi)
+{
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_vport *vport = (struct lpfc_vport *)target_handle;
+
+	ndlp = lpfc_findnode_rpi(vport, rpi);
+
+	if (!ndlp)
+		return 0;
+
+	/* return the tERP capabilities negotiated via PRLI */
+
+	return ndlp->tm_login_flags & NLP_TM_FCP_4_ERP;
+}
+EXPORT_SYMBOL(lpfc_tm_get_node_terp_capabilities);
+
+int
+lpfc_tm_set_node_terp_behavior(tm_tgtport_handle_t target_handle,
+		tm_login_info_t *logininfo, uint32_t terp_capabilities)
+{
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_vport *vport = (struct lpfc_vport *)target_handle;
+
+	ndlp = lpfc_findnode_wwpn(vport,
+		(struct lpfc_name *)logininfo->fc_login_info.fc_port_name);
+
+	if (!ndlp)
+		return TM_RCD_FAILURE;
+
+	ndlp->tm_node_capabilities &= ~NLP_TM_FCP_4_ERP;
+
+	if (terp_capabilities & TM_TERP_FCP_CONF)
+		ndlp->tm_node_capabilities |= NLP_TM_FCP_CONF;
+	if (terp_capabilities & TM_TERP_FCP_RETRY)
+		ndlp->tm_node_capabilities |= NLP_TM_FCP_RETRY;
+	if (terp_capabilities & TM_TERP_FCP_RETRY_ID)
+		ndlp->tm_node_capabilities |= NLP_TM_FCP_RETRY_ID;
+
+	return TM_RCD_SUCCESS;
+}
+EXPORT_SYMBOL(lpfc_tm_set_node_terp_behavior);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION(LPFC_MODULE_DESC);
+MODULE_AUTHOR("Emulex Corporation - tech.support@emulex.com");
+MODULE_VERSION("0:" LPFC_DRIVER_VERSION);
diff --git a/drivers/scsi/lpfc/lpfc_target_api.h b/drivers/scsi/lpfc/lpfc_target_api.h
new file mode 100755
index 0000000..2198135
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_target_api.h
@@ -0,0 +1,180 @@
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
+typedef void *tm_tgtport_handle_t;
+typedef void *tm_login_handle_t;
+typedef void *tm_sliport_handle_t;
+
+/* API version values */
+#define        TM_API_VERSION_1        1
+#define        TM_API_VERSION_2        2
+#define	       TM_API_VERSION_3        3
+#define	       TM_API_VERSION_4        4
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
+/* From lpfc.h */
+struct hbq_dmabuf;
+
+struct tm_hbq_dmabuf {
+	struct tm_lpfc_dmabuf dbuf;
+	uint32_t size;
+	uint32_t tag;
+	struct lpfc_cq_event cq_event;
+	unsigned long time_stamp;
+};
+
+typedef struct tm_driver_data_s {
+	uint32_t api_version;
+	uint32_t(*tm_tgtport_bind) (tm_tgtport_handle_t base_handle,
+					tm_tgtport_info_t *portinfo,
+					tm_tgtport_handle_t *tgt_handle);
+	void (*tm_tgtport_req_unbind) (tm_tgtport_handle_t tgt_handle);
+	void (*tm_tgtport_reset) (tm_tgtport_handle_t tgt_handle);
+	uint32_t(*tm_tgtport_chk_login) (tm_tgtport_handle_t tgt_handle,
+					tm_login_info_t *logininfo);
+	tm_login_handle_t(*tm_tgtport_login) (tm_tgtport_handle_t tgt_handle,
+					uint16_t rpi,
+					tm_login_info_t *logininfo);
+	void (*tm_tgtport_logout) (tm_login_handle_t tgt_login_handle);
+	void (*tm_rsp_recv) (tm_tgtport_handle_t tgt_handle, IOCB_t *iocb);
+	void (*tm_hbq_alloc) (tm_sliport_handle_t tgt_slihandle,
+					struct hbq_dmabuf *hbqbp);
+	uint32_t (*tm_sliport_init)(tm_sliport_handle_t lpfc_port_handle,
+			tm_sliport_info_t *sliport_info,
+			tm_sliport_handle_t *tgt_slihandle);
+	struct target_sliport_s *(*tm_sliport_allocate)(
+			tm_sliport_info_t *sliport_info, u32, u32);
+	void (*tm_sliport_term)(tm_sliport_handle_t tgt_slihandle);
+	uint32_t (*tm_tgtport_bind_v2)(tm_sliport_handle_t tgt_slihandle,
+			tm_tgtport_handle_t base_handle,
+			tm_tgtport_info_t *portinfo,
+			tm_tgtport_handle_t *tgt_handle);
+	void (*tm_sliport_reset)(tm_sliport_handle_t tgt_slihandle);
+	void (*tm_hbq_free) (tm_sliport_handle_t tgt_slihandle,
+					struct hbq_dmabuf *hbqbp);
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
+/* FCP-4 Target Error Recovery Protocol capability codes */
+#define        TM_TERP_FCP_CONF       0x1
+#define        TM_TERP_FCP_RETRY      0x2
+#define        TM_TERP_FCP_RETRY_ID   0x4
+#define        TM_FCP_TERP_FLAGS \
+	(TM_TERP_FCP_CONF | TM_TERP_FCP_RETRY | TM_TERP_FCP_RETRY_ID)
+
+#include "lpfc_target_mod.h"
+
+uint32_t lpfc_tm_version(void);
+uint32_t lpfc_tm_init(tm_driver_data_t *tgt_data);
+void lpfc_tm_term(void);
+uint32_t lpfc_tm_cmd_send(tm_sliport_handle_t lpfc_sliport_handle,
+			  tm_tgtport_handle_t base_handle,
+			  IOCB_t *iocb, uint32_t iocb_wd_len);
+void lpfc_tm_rsp_poll(tm_sliport_handle_t lpfc_port_handle,
+			  uint32_t max_responses);
+void lpfc_tm_poll_set(tm_sliport_handle_t lpfc_port_handle,
+			  uint32_t enable);
+void lpfc_tm_init_link(tm_tgtport_handle_t base_handle);
+void lpfc_tm_down_link(tm_sliport_handle_t lpfc_port_handle);
+int lpfc_sliport_term(struct lpfc_hba *);
+int lpfc_tm_get_board_number(tm_sliport_handle_t lpfc_port_handle);
+int lpfc_tm_get_port_number(tm_tgtport_handle_t target_handle);
+uint32_t lpfc_tm_get_port_terp_capabilities(tm_sliport_handle_t
+			lpfc_port_handle);
+uint32_t lpfc_tm_get_node_terp_capabilities(tm_tgtport_handle_t target_handle,
+			 uint16_t rpi);
+int lpfc_tm_set_node_terp_behavior(tm_tgtport_handle_t target_handle,
+		tm_login_info_t *logininfo, uint32_t terp_capabilities);
+void lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp) ;
+void lpfc_tm_down_link(tm_sliport_handle_t lpfc_port_handle);
+uint32_t lpfc_tm_tgtport_unbind(struct lpfc_vport *vport);
+int lpfc_tm_get_max_rpi(tm_sliport_handle_t lpfc_sliport_handle,
+		uint32_t *max_rpi);
+void lpfc_tm_free_exchange_cmnd(struct target_sliport_s *sliport,
+		struct target_exchange_s *exchange);
+void lpfc_tm_terp_reg_login(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp);
+void lpfc_tm_get_hba_terp_cap(struct lpfc_hba *phba);
+
+#endif				/* _H_LPFC_TGT_API */
diff --git a/drivers/scsi/lpfc/lpfc_target_api_base.h b/drivers/scsi/lpfc/lpfc_target_api_base.h
new file mode 100755
index 0000000..1e5a879
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_target_api_base.h
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
+extern tm_driver_data_t *lpfc_tgt_data;
+extern atomic_t bind_call_outstanding;
+
+typedef struct tm_tgtport_s {
+	tm_tgtport_handle_t target_handle;
+	tm_tgtport_info_t info;
+	struct list_head list;
+	atomic_t calls_outstanding;
+} tm_tgtport_t;
+
+
+typedef struct tm_sliport_s {
+	tm_sliport_handle_t target_slihandle;
+	uint32_t interrupt_callback_allowed;
+	atomic_t interrupt_in_progress;
+	tm_sliport_info_t info;
+	struct list_head list;
+	atomic_t calls_outstanding;
+} tm_sliport_t;
+
+#endif				/* _H_LPFC_TGT_API_BASE */
diff --git a/drivers/scsi/lpfc/lpfc_target_mod.h b/drivers/scsi/lpfc/lpfc_target_mod.h
new file mode 100755
index 0000000..4b7bd80
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_target_mod.h
@@ -0,0 +1,159 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
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
+
+#ifndef LPFC_TM_FABRIC_H
+#define LPFC_TM_FABRIC_H
+
+#include <linux/list.h>
+#include <linux/version.h>
+#include <linux/pci.h>
+
+
+#define MAX_LPFC_SNS 16
+
+struct fcp_rsp_s {
+	uint32_t rspRsvd1;	/* FC Word 0, byte 0:3 */
+	uint32_t rspRsvd2;	/* FC Word 1, byte 0:3 */
+
+	uint8_t rspStatus0;	/* FCP_STATUS byte 0 (reserved) */
+	uint8_t rspStatus1;	/* FCP_STATUS byte 1 (reserved) */
+	uint8_t rspStatus2;	/* FCP_STATUS byte 2 field validity */
+#define RSP_LEN_VALID  0x01	/* bit 0 */
+#define SNS_LEN_VALID  0x02	/* bit 1 */
+#define RESID_OVER     0x04	/* bit 2 */
+#define RESID_UNDER    0x08	/* bit 3 */
+#define FCP_CONF_REQ   0x10	/* bit 4 */
+	uint8_t rspStatus3;	/* FCP_STATUS byte 3 SCSI status byte */
+
+	uint32_t rspResId;	/* Residual xfer if residual count field set in
+				   fcpStatus2 */
+	/* Received in Big Endian format */
+	uint32_t rspSnsLen;	/* Length of sense data in fcpSnsInfo */
+	/* Received in Big Endian format */
+	uint32_t rspRspLen;	/* Length of FCP response data in fcpRspInfo */
+	/* Received in Big Endian format */
+
+	uint8_t rspInfo0;	/* FCP_RSP_INFO byte 0 (reserved) */
+	uint8_t rspInfo1;	/* FCP_RSP_INFO byte 1 (reserved) */
+	uint8_t rspInfo2;	/* FCP_RSP_INFO byte 2 (reserved) */
+	uint8_t rspInfo3;	/* FCP_RSP_INFO RSP_CODE byte 3 */
+
+#define RSP_NO_FAILURE       0x00
+#define RSP_DATA_BURST_ERR   0x01
+#define RSP_CMD_FIELD_ERR    0x02
+#define RSP_RO_MISMATCH_ERR  0x03
+#define RSP_TM_NOT_SUPPORTED 0x04	/* Task mgmt function not supported */
+#define RSP_TM_NOT_COMPLETED 0x05	/* Task mgmt function not performed */
+#define RSP_TM_BAD_LUN       0x09
+
+
+	uint32_t rspInfoRsvd;	/* FCP_RSP_INFO bytes 4-7 (reserved) */
+
+	uint8_t rspSnsInfo[MAX_LPFC_SNS];
+#define SNS_ILLEGAL_REQ 0x05	/* sense key is byte 3 ([2]) */
+#define SNSCOD_BADCMD 0x20	/* sense code is byte 13 ([12]) */
+#define SNSCODE_LBA_OOR 0x21	/* sense code - lba out of range */
+
+};
+
+struct fcp_cmnd_s {
+	uint8_t fcp_lun[8];
+	uint8_t command_reference_number;
+	uint8_t task_attribute;
+#define  SIMPLE_Q        0x00	/* From FCP-4 spec */
+#define  HEAD_OF_Q       0x01
+#define  ORDERED_Q       0x02
+#define  ACA_Q           0x04
+#define  UNTAGGED        0x05
+
+	uint8_t task_management_flags;
+	uint8_t adlen_rd_wr;
+#define  WRITE_DATA      0x01   /* Bit 0 */
+#define  READ_DATA       0x02   /* Bit 1 */
+
+	uint8_t fcp_cdb[16];
+	uint32_t fcp_dl;
+};
+
+struct target_tgtport_s;
+struct target_sliport_s;
+
+struct target_sliport_s {
+	tm_sliport_info_t *portinfo;
+	tm_sliport_handle_t sliport_handle;
+	struct list_head sliport_list;
+	struct list_head command_iocb_wait;
+	struct list_head command_iocb_posted;
+	uint32_t num_exchanges;
+	uint32_t next_exchange;
+	struct target_exchange_s **iotag_map;
+#define FIRST_VALID_XRI  1
+	spinlock_t spin_lock;	/* spinlock */
+	uint32_t state;
+	atomic_t sliport_num_tgt_ports;
+#define SLIPORT_INIT              0
+#define SLIPORT_BOUND             1
+#define SLIPORT_UNBIND_PENDING    2
+#define SLIPORT_UNBOUND           3
+	struct timer_list watchdog_timer;
+	uint32_t port_no;
+	atomic_t outstanding_cmd_cnt;
+	uint32_t max_rpis;
+	struct target_login_s *logins;
+};
+
+/* All references to this structure other than by the
+   base module, and by the tgtport_list_head list should
+   be included in the ref_count.  To delete an instance
+   of this struct, first call lpfc_tgtport_unbind, after
+   return from which the base module will never again
+   reference it. */
+
+struct target_tgtport_s {
+	/* This tgtport is a child of this sliport */
+	struct target_sliport_s *tgt_sliport;
+	tm_tgtport_info_t *portinfo;
+	tm_tgtport_handle_t base_handle;
+	struct list_head tgtport_list;
+	uint32_t state;
+	atomic_t outstanding_exchanges;
+#define TGTPORT_INIT              0
+#define TGTPORT_BOUND             1
+#define TGTPORT_UNBIND_PENDING    2
+#define TGTPORT_UNBOUND           3
+	uint32_t port_no;
+
+	void *tm_fabric_tgtport;
+};
+
+/* lpfc_tm logging */
+#define LPFC_TM_LOG_ALWAYS		0x0
+#define LPFC_TM_LOG_API			0x1
+#define LPFC_TM_LOG_IO_SCSICMD		0x2
+#define LPFC_TM_LOG_NONIO_SCSICMD	0x4
+#define LPFC_TM_LOG_ALL_SCSICMD		0x6
+#define LPFC_TM_LOG_POST_IOCB		0x8
+#define LPFC_TM_LOG_UNSOL_IOCB		0x10
+#define LPFC_TM_LOG_ALL_IOCB		0x18
+
+#define LPFC_TM_NO_TGTPORT ((struct target_tgtport_s *)(~0))
+#define LPFC_TM_NO_SLIPORT ((struct target_sliport_s *)(~0))
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_target_protos.h b/drivers/scsi/lpfc/lpfc_target_protos.h
new file mode 100755
index 0000000..a08fce2
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_target_protos.h
@@ -0,0 +1,34 @@
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
+int lpfc_target_sliport_init(struct lpfc_hba *phba, struct pci_dev *pci_dev,
+			tm_driver_data_t *fabric_tgt_data);
+struct target_tgtport_s *lpfc_target_new_tgtport(struct lpfc_vport *vport);
+uint32_t lpfc_tm_tgtport_unbind(struct lpfc_vport *vport);
+uint32_t lpfc_target_check_login(struct lpfc_vport *, struct lpfc_nodelist *);
+
+tm_login_handle_t lpfc_tm_tgtport_login(struct lpfc_vport *,
+			struct lpfc_nodelist *);
+void lpfc_tm_tgtport_logout(struct lpfc_vport *, tm_login_handle_t);
+uint32_t lpfc_tm_tgtport_chk_login(struct lpfc_vport *, tm_login_info_t *);
+#endif				/* _H_LPFC_TGT_PROTO */
-- 
1.5.6.5

