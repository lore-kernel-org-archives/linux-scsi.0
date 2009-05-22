From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/17] lpfc 8.3.2 : Addition of SLI4 Interface - Base
	Support - Part 3 of 6
Date: Fri, 22 May 2009 14:51:59 -0400
Message-ID: <1243018319.7729.49.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42020 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZEVSwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:01 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIq34x029741
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Base Support - Part 3 of 6

Adds new hardware and interface definitions.

Adds new interface routines - utilizing the reorganized layout of the
driver. Adds SLI-4 specific functions for attachment, initialization,
teardown, etc.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.h  |    2 
 lpfc_sli.c   | 1263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 lpfc_sli.h   |   27 +
 lpfc_sli4.h  |  467 +++++++++++++++++++++
 lpfc_vport.c |   23 +
 5 files changed, 1748 insertions(+), 34 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
--- a/drivers/scsi/lpfc/lpfc_scsi.h	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.h	2009-05-22 13:16:40.000000000 -0400
@@ -140,6 +140,8 @@ struct lpfc_scsi_buf {
 	struct fcp_rsp *fcp_rsp;
 	struct ulp_bde64 *fcp_bpl;
 
+	dma_addr_t dma_phys_bpl;
+
 	/* cur_iocbq has phys of the dma-able buffer.
 	 * Iotag is in here
 	 */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2009-05-22 13:16:40.000000000 -0400
@@ -0,0 +1,467 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2009 Emulex.  All rights reserved.                *
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
+#define LPFC_ACTIVE_MBOX_WAIT_CNT               100
+#define LPFC_RELEASE_NOTIFICATION_INTERVAL	32
+#define LPFC_GET_QE_REL_INT			32
+#define LPFC_RPI_LOW_WATER_MARK			10
+/* Number of SGL entries can be posted in a 4KB nonembedded mbox command */
+#define LPFC_NEMBED_MBOX_SGL_CNT		254
+
+/* Multi-queue arrangement for fast-path FCP work queues */
+#define LPFC_FN_EQN_MAX       8
+#define LPFC_SP_EQN_DEF       1
+#define LPFC_FP_EQN_DEF       1
+#define LPFC_FP_EQN_MIN       1
+#define LPFC_FP_EQN_MAX       (LPFC_FN_EQN_MAX - LPFC_SP_EQN_DEF)
+
+#define LPFC_FN_WQN_MAX       32
+#define LPFC_SP_WQN_DEF       1
+#define LPFC_FP_WQN_DEF       4
+#define LPFC_FP_WQN_MIN       1
+#define LPFC_FP_WQN_MAX       (LPFC_FN_WQN_MAX - LPFC_SP_WQN_DEF)
+
+/*
+ * Provide the default FCF Record attributes used by the driver
+ * when nonFIP mode is configured and there is no other default
+ * FCF Record attributes.
+ */
+#define LPFC_FCOE_FCF_DEF_INDEX	0
+#define LPFC_FCOE_FCF_GET_FIRST	0xFFFF
+#define LPFC_FCOE_FCF_NEXT_NONE	0xFFFF
+
+/* First 3 bytes of default FCF MAC is specified by FC_MAP */
+#define LPFC_FCOE_FCF_MAC3	0xFF
+#define LPFC_FCOE_FCF_MAC4	0xFF
+#define LPFC_FCOE_FCF_MAC5	0xFE
+#define LPFC_FCOE_FCF_MAP0	0x0E
+#define LPFC_FCOE_FCF_MAP1	0xFC
+#define LPFC_FCOE_FCF_MAP2	0x00
+#define LPFC_FCOE_MAX_RCV_SIZE	0x5AC
+#define LPFC_FCOE_FKA_ADV_PER	0
+#define LPFC_FCOE_FIP_PRIORITY	0x80
+
+enum lpfc_sli4_queue_type {
+	LPFC_EQ,
+	LPFC_GCQ,
+	LPFC_MCQ,
+	LPFC_WCQ,
+	LPFC_RCQ,
+	LPFC_MQ,
+	LPFC_WQ,
+	LPFC_HRQ,
+	LPFC_DRQ
+};
+
+/* The queue sub-type defines the functional purpose of the queue */
+enum lpfc_sli4_queue_subtype {
+	LPFC_NONE,
+	LPFC_MBOX,
+	LPFC_FCP,
+	LPFC_ELS,
+	LPFC_USOL
+};
+
+union sli4_qe {
+	void *address;
+	struct lpfc_eqe *eqe;
+	struct lpfc_cqe *cqe;
+	struct lpfc_mcqe *mcqe;
+	struct lpfc_wcqe_complete *wcqe_complete;
+	struct lpfc_wcqe_release *wcqe_release;
+	struct sli4_wcqe_xri_aborted *wcqe_xri_aborted;
+	struct lpfc_rcqe_complete *rcqe_complete;
+	struct lpfc_mqe *mqe;
+	union  lpfc_wqe *wqe;
+	struct lpfc_rqe *rqe;
+};
+
+struct lpfc_queue {
+	struct list_head list;
+	enum lpfc_sli4_queue_type type;
+	enum lpfc_sli4_queue_subtype subtype;
+	struct lpfc_hba *phba;
+	struct list_head child_list;
+	uint32_t entry_count;	/* Number of entries to support on the queue */
+	uint32_t entry_size;	/* Size of each queue entry. */
+	uint32_t queue_id;	/* Queue ID assigned by the hardware */
+	struct list_head page_list;
+	uint32_t page_count;	/* Number of pages allocated for this queue */
+
+	uint32_t host_index;	/* The host's index for putting or getting */
+	uint32_t hba_index;	/* The last known hba index for get or put */
+	union sli4_qe qe[1];	/* array to index entries (must be last) */
+};
+
+struct lpfc_cq_event {
+	struct list_head list;
+	union {
+		struct lpfc_mcqe		mcqe_cmpl;
+		struct lpfc_acqe_link		acqe_link;
+		struct lpfc_acqe_fcoe		acqe_fcoe;
+		struct lpfc_acqe_dcbx		acqe_dcbx;
+		struct lpfc_rcqe		rcqe_cmpl;
+		struct sli4_wcqe_xri_aborted	wcqe_axri;
+	} cqe;
+};
+
+struct lpfc_sli4_link {
+	uint8_t speed;
+	uint8_t duplex;
+	uint8_t status;
+	uint8_t physical;
+	uint8_t fault;
+};
+
+struct lpfc_fcf {
+	uint8_t	 fabric_name[8];
+	uint8_t  mac_addr[6];
+	uint16_t fcf_indx;
+	uint16_t fcfi;
+	uint32_t fcf_flag;
+#define FCF_AVAILABLE	0x01 /* FCF available for discovery */
+#define FCF_REGISTERED	0x02 /* FCF registered with FW */
+#define FCF_DISCOVERED	0x04 /* FCF discovery started  */
+#define FCF_BOOT_ENABLE 0x08 /* Boot bios use this FCF */
+#define FCF_IN_USE	0x10 /* Atleast one discovery completed */
+#define FCF_VALID_VLAN	0x20 /* Use the vlan id specified */
+	uint32_t priority;
+	uint32_t addr_mode;
+	uint16_t vlan_id;
+};
+
+#define LPFC_REGION23_SIGNATURE "RG23"
+#define LPFC_REGION23_VERSION	1
+#define LPFC_REGION23_LAST_REC  0xff
+struct lpfc_fip_param_hdr {
+	uint8_t type;
+#define FCOE_PARAM_TYPE		0xA0
+	uint8_t length;
+#define FCOE_PARAM_LENGTH	2
+	uint8_t parm_version;
+#define FIPP_VERSION		0x01
+	uint8_t parm_flags;
+#define	lpfc_fip_param_hdr_fipp_mode_SHIFT	6
+#define	lpfc_fip_param_hdr_fipp_mode_MASK	0x3
+#define lpfc_fip_param_hdr_fipp_mode_WORD	parm_flags
+#define	FIPP_MODE_ON				0x2
+#define	FIPP_MODE_OFF				0x0
+#define FIPP_VLAN_VALID				0x1
+};
+
+struct lpfc_fcoe_params {
+	uint8_t fc_map[3];
+	uint8_t reserved1;
+	uint16_t vlan_tag;
+	uint8_t reserved[2];
+};
+
+struct lpfc_fcf_conn_hdr {
+	uint8_t type;
+#define FCOE_CONN_TBL_TYPE		0xA1
+	uint8_t length;   /* words */
+	uint8_t reserved[2];
+};
+
+struct lpfc_fcf_conn_rec {
+	uint16_t flags;
+#define	FCFCNCT_VALID		0x0001
+#define	FCFCNCT_BOOT		0x0002
+#define	FCFCNCT_PRIMARY		0x0004   /* if not set, Secondary */
+#define	FCFCNCT_FBNM_VALID	0x0008
+#define	FCFCNCT_SWNM_VALID	0x0010
+#define	FCFCNCT_VLAN_VALID	0x0020
+#define	FCFCNCT_AM_VALID	0x0040
+#define	FCFCNCT_AM_PREFERRED	0x0080   /* if not set, AM Required */
+#define	FCFCNCT_AM_SPMA		0x0100	 /* if not set, FPMA */
+
+	uint16_t vlan_tag;
+	uint8_t fabric_name[8];
+	uint8_t switch_name[8];
+};
+
+struct lpfc_fcf_conn_entry {
+	struct list_head list;
+	struct lpfc_fcf_conn_rec conn_rec;
+};
+
+/*
+ * Define the host's bootstrap mailbox.  This structure contains
+ * the member attributes needed to create, use, and destroy the
+ * bootstrap mailbox region.
+ *
+ * The macro definitions for the bmbx data structure are defined
+ * in lpfc_hw4.h with the register definition.
+ */
+struct lpfc_bmbx {
+	struct lpfc_dmabuf *dmabuf;
+	struct dma_address dma_address;
+	void *avirt;
+	dma_addr_t aphys;
+	uint32_t bmbx_size;
+};
+
+#define LPFC_EQE_SIZE LPFC_EQE_SIZE_4
+
+#define LPFC_EQE_SIZE_4B 	4
+#define LPFC_EQE_SIZE_16B	16
+#define LPFC_CQE_SIZE		16
+#define LPFC_WQE_SIZE		64
+#define LPFC_MQE_SIZE		256
+#define LPFC_RQE_SIZE		8
+
+#define LPFC_EQE_DEF_COUNT	1024
+#define LPFC_CQE_DEF_COUNT      256
+#define LPFC_WQE_DEF_COUNT      64
+#define LPFC_MQE_DEF_COUNT      16
+#define LPFC_RQE_DEF_COUNT	512
+
+#define LPFC_QUEUE_NOARM	false
+#define LPFC_QUEUE_REARM	true
+
+
+/*
+ * SLI4 CT field defines
+ */
+#define SLI4_CT_RPI 0
+#define SLI4_CT_VPI 1
+#define SLI4_CT_VFI 2
+#define SLI4_CT_FCFI 3
+
+#define LPFC_SLI4_MAX_SEGMENT_SIZE 0x10000
+
+/*
+ * SLI4 specific data structures
+ */
+struct lpfc_max_cfg_param {
+	uint16_t max_xri;
+	uint16_t xri_base;
+	uint16_t xri_used;
+	uint16_t max_rpi;
+	uint16_t rpi_base;
+	uint16_t rpi_used;
+	uint16_t max_vpi;
+	uint16_t vpi_base;
+	uint16_t vpi_used;
+	uint16_t max_vfi;
+	uint16_t vfi_base;
+	uint16_t vfi_used;
+	uint16_t max_fcfi;
+	uint16_t fcfi_base;
+	uint16_t fcfi_used;
+	uint16_t max_eq;
+	uint16_t max_rq;
+	uint16_t max_cq;
+	uint16_t max_wq;
+};
+
+struct lpfc_hba;
+/* SLI4 HBA multi-fcp queue handler struct */
+struct lpfc_fcp_eq_hdl {
+	uint32_t idx;
+	struct lpfc_hba *phba;
+};
+
+/* SLI4 HBA data structure entries */
+struct lpfc_sli4_hba {
+	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
+					     PCI BAR0, config space registers */
+	void __iomem *ctrl_regs_memmap_p; /* Kernel memory mapped address for
+					     PCI BAR1, control registers */
+	void __iomem *drbl_regs_memmap_p; /* Kernel memory mapped address for
+					     PCI BAR2, doorbell registers */
+	/* BAR0 PCI config space register memory map */
+	void __iomem *UERRLOregaddr; /* Address to UERR_STATUS_LO register */
+	void __iomem *UERRHIregaddr; /* Address to UERR_STATUS_HI register */
+	void __iomem *ONLINE0regaddr; /* Address to components of internal UE */
+	void __iomem *ONLINE1regaddr; /* Address to components of internal UE */
+#define LPFC_ONLINE_NERR	0xFFFFFFFF
+	void __iomem *SCRATCHPADregaddr; /* Address to scratchpad register */
+	/* BAR1 FCoE function CSR register memory map */
+	void __iomem *STAregaddr;    /* Address to HST_STATE register */
+	void __iomem *ISRregaddr;    /* Address to HST_ISR register */
+	void __iomem *IMRregaddr;    /* Address to HST_IMR register */
+	void __iomem *ISCRregaddr;   /* Address to HST_ISCR register */
+	/* BAR2 VF-0 doorbell register memory map */
+	void __iomem *RQDBregaddr;   /* Address to RQ_DOORBELL register */
+	void __iomem *WQDBregaddr;   /* Address to WQ_DOORBELL register */
+	void __iomem *EQCQDBregaddr; /* Address to EQCQ_DOORBELL register */
+	void __iomem *MQDBregaddr;   /* Address to MQ_DOORBELL register */
+	void __iomem *BMBXregaddr;   /* Address to BootStrap MBX register */
+
+	struct msix_entry *msix_entries;
+	uint32_t cfg_eqn;
+	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
+	/* Pointers to the constructed SLI4 queues */
+	struct lpfc_queue **fp_eq; /* Fast-path event queue */
+	struct lpfc_queue *sp_eq;  /* Slow-path event queue */
+	struct lpfc_queue **fcp_wq;/* Fast-path FCP work queue */
+	struct lpfc_queue *mbx_wq; /* Slow-path MBOX work queue */
+	struct lpfc_queue *els_wq; /* Slow-path ELS work queue */
+	struct lpfc_queue *hdr_rq; /* Slow-path Header Receive queue */
+	struct lpfc_queue *dat_rq; /* Slow-path Data Receive queue */
+	struct lpfc_queue **fcp_cq;/* Fast-path FCP compl queue */
+	struct lpfc_queue *mbx_cq; /* Slow-path mailbox complete queue */
+	struct lpfc_queue *els_cq; /* Slow-path ELS response complete queue */
+	struct lpfc_queue *rxq_cq; /* Slow-path unsolicited complete queue */
+
+	/* Setup information for various queue parameters */
+	int eq_esize;
+	int eq_ecount;
+	int cq_esize;
+	int cq_ecount;
+	int wq_esize;
+	int wq_ecount;
+	int mq_esize;
+	int mq_ecount;
+	int rq_esize;
+	int rq_ecount;
+#define LPFC_SP_EQ_MAX_INTR_SEC         10000
+#define LPFC_FP_EQ_MAX_INTR_SEC         10000
+
+	uint32_t intr_enable;
+	struct lpfc_bmbx bmbx;
+	struct lpfc_max_cfg_param max_cfg_param;
+	uint16_t next_xri; /* last_xri - max_cfg_param.xri_base = used */
+	uint16_t next_rpi;
+	uint16_t scsi_xri_max;
+	uint16_t scsi_xri_cnt;
+	struct list_head lpfc_free_sgl_list;
+	struct list_head lpfc_sgl_list;
+	struct lpfc_sglq **lpfc_els_sgl_array;
+	struct list_head lpfc_abts_els_sgl_list;
+	struct lpfc_scsi_buf **lpfc_scsi_psb_array;
+	struct list_head lpfc_abts_scsi_buf_list;
+	uint32_t total_sglq_bufs;
+	struct lpfc_sglq **lpfc_sglq_active_list;
+	struct list_head lpfc_rpi_hdr_list;
+	unsigned long *rpi_bmask;
+	uint16_t rpi_count;
+	struct lpfc_sli4_flags sli4_flags;
+	struct list_head sp_rspiocb_work_queue;
+	struct list_head sp_cqe_event_pool;
+	struct list_head sp_asynce_work_queue;
+	struct list_head sp_fcp_xri_aborted_work_queue;
+	struct list_head sp_els_xri_aborted_work_queue;
+	struct list_head sp_unsol_work_queue;
+	struct lpfc_sli4_link link_state;
+	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
+	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
+};
+
+enum lpfc_sge_type {
+	GEN_BUFF_TYPE,
+	SCSI_BUFF_TYPE
+};
+
+struct lpfc_sglq {
+	/* lpfc_sglqs are used in double linked lists */
+	struct list_head list;
+	struct list_head clist;
+	enum lpfc_sge_type buff_type; /* is this a scsi sgl */
+	uint16_t iotag;         /* pre-assigned IO tag */
+	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
+	struct sli4_sge *sgl;	/* pre-assigned SGL */
+	void *virt;		/* virtual address. */
+	dma_addr_t phys;	/* physical address */
+};
+
+struct lpfc_rpi_hdr {
+	struct list_head list;
+	uint32_t len;
+	struct lpfc_dmabuf *dmabuf;
+	uint32_t page_count;
+	uint32_t start_rpi;
+};
+
+/*
+ * SLI4 specific function prototypes
+ */
+int lpfc_pci_function_reset(struct lpfc_hba *);
+int lpfc_sli4_hba_setup(struct lpfc_hba *);
+int lpfc_sli4_hba_down(struct lpfc_hba *);
+int lpfc_sli4_config(struct lpfc_hba *, struct lpfcMboxq *, uint8_t,
+		     uint8_t, uint32_t, bool);
+void lpfc_sli4_mbox_cmd_free(struct lpfc_hba *, struct lpfcMboxq *);
+void lpfc_sli4_mbx_sge_set(struct lpfcMboxq *, uint32_t, dma_addr_t, uint32_t);
+void lpfc_sli4_mbx_sge_get(struct lpfcMboxq *, uint32_t,
+			   struct lpfc_mbx_sge *);
+
+void lpfc_sli4_hba_reset(struct lpfc_hba *);
+struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
+			uint32_t);
+void lpfc_sli4_queue_free(struct lpfc_queue *);
+uint32_t lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint16_t);
+uint32_t lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
+			struct lpfc_queue *, uint32_t, uint32_t);
+uint32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
+			struct lpfc_queue *, uint32_t);
+uint32_t lpfc_wq_create(struct lpfc_hba *, struct lpfc_queue *,
+			struct lpfc_queue *, uint32_t);
+uint32_t lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
+			struct lpfc_queue *, struct lpfc_queue *, uint32_t);
+uint32_t lpfc_eq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+uint32_t lpfc_cq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+uint32_t lpfc_mq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+uint32_t lpfc_wq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+uint32_t lpfc_rq_destroy(struct lpfc_hba *, struct lpfc_queue *,
+			 struct lpfc_queue *);
+int lpfc_sli4_queue_setup(struct lpfc_hba *);
+void lpfc_sli4_queue_unset(struct lpfc_hba *);
+int lpfc_sli4_post_sgl(struct lpfc_hba *, dma_addr_t, dma_addr_t, uint16_t);
+int lpfc_sli4_repost_scsi_sgl_list(struct lpfc_hba *);
+int lpfc_sli4_remove_all_sgl_pages(struct lpfc_hba *);
+uint16_t lpfc_sli4_next_xritag(struct lpfc_hba *);
+int lpfc_sli4_post_async_mbox(struct lpfc_hba *);
+int lpfc_sli4_post_sgl_list(struct lpfc_hba *phba);
+int lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *, struct list_head *, int);
+struct lpfc_cq_event *__lpfc_sli4_cq_event_alloc(struct lpfc_hba *);
+struct lpfc_cq_event *lpfc_sli4_cq_event_alloc(struct lpfc_hba *);
+void __lpfc_sli4_cq_event_release(struct lpfc_hba *, struct lpfc_cq_event *);
+void lpfc_sli4_cq_event_release(struct lpfc_hba *, struct lpfc_cq_event *);
+int lpfc_sli4_init_rpi_hdrs(struct lpfc_hba *);
+int lpfc_sli4_post_rpi_hdr(struct lpfc_hba *, struct lpfc_rpi_hdr *);
+int lpfc_sli4_post_all_rpi_hdrs(struct lpfc_hba *);
+struct lpfc_rpi_hdr *lpfc_sli4_create_rpi_hdr(struct lpfc_hba *);
+void lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *);
+int lpfc_sli4_alloc_rpi(struct lpfc_hba *);
+void lpfc_sli4_free_rpi(struct lpfc_hba *, int);
+void lpfc_sli4_remove_rpis(struct lpfc_hba *);
+void lpfc_sli4_async_event_proc(struct lpfc_hba *);
+int lpfc_sli4_resume_rpi(struct lpfc_nodelist *);
+void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
+void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
+void lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *,
+			       struct sli4_wcqe_xri_aborted *);
+void lpfc_sli4_els_xri_aborted(struct lpfc_hba *,
+			       struct sli4_wcqe_xri_aborted *);
+int lpfc_sli4_brdreset(struct lpfc_hba *);
+int lpfc_sli4_add_fcf_record(struct lpfc_hba *, struct fcf_record *);
+void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
+int lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *);
+int lpfc_sli4_init_vpi(struct lpfc_hba *, uint16_t);
+uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
+uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
+void lpfc_sli4_fcfi_unreg(struct lpfc_hba *, uint16_t);
+int lpfc_sli4_read_fcf_record(struct lpfc_hba *, uint16_t);
+void lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_sli4_post_status_check(struct lpfc_hba *);
+uint8_t lpfc_sli4_mbox_opcode_get(struct lpfc_hba *, struct lpfcMboxq *);
+
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:14:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:16:40.000000000 -0400
@@ -29,9 +29,12 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -121,6 +124,76 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *ph
 }
 
 /**
+ * __lpfc_clear_active_sglq - Remove the active sglq for this XRI.
+ * @phba: Pointer to HBA context object.
+ * @xritag: XRI value.
+ *
+ * This function clears the sglq pointer from the array of acive
+ * sglq's. The xritag that is passed in is used to index into the
+ * array. Before the xritag can be used it needs to be adjusted
+ * by subtracting the xribase.
+ *
+ * Returns sglq ponter = success, NULL = Failure.
+ **/
+static struct lpfc_sglq *
+__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
+{
+	uint16_t adj_xri;
+	struct lpfc_sglq *sglq;
+	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
+	if (adj_xri > phba->sli4_hba.max_cfg_param.max_xri)
+		return NULL;
+	sglq = phba->sli4_hba.lpfc_sglq_active_list[adj_xri];
+	phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = NULL;
+	return sglq;
+}
+
+/**
+ * __lpfc_get_active_sglq - Get the active sglq for this XRI.
+ * @phba: Pointer to HBA context object.
+ * @xritag: XRI value.
+ *
+ * This function returns the sglq pointer from the array of acive
+ * sglq's. The xritag that is passed in is used to index into the
+ * array. Before the xritag can be used it needs to be adjusted
+ * by subtracting the xribase.
+ *
+ * Returns sglq ponter = success, NULL = Failure.
+ **/
+static struct lpfc_sglq *
+__lpfc_get_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
+{
+	uint16_t adj_xri;
+	struct lpfc_sglq *sglq;
+	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
+	if (adj_xri > phba->sli4_hba.max_cfg_param.max_xri)
+		return NULL;
+	sglq =  phba->sli4_hba.lpfc_sglq_active_list[adj_xri];
+	return sglq;
+}
+
+/**
+ * __lpfc_sli_get_sglq - Allocates an iocb object from sgl pool
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with hbalock held. This function
+ * Gets a new driver sglq object from the sglq list. If the
+ * list is not empty then it is successful, it returns pointer to the newly
+ * allocated sglq object else it returns NULL.
+ **/
+static struct lpfc_sglq *
+__lpfc_sli_get_sglq(struct lpfc_hba *phba)
+{
+	struct list_head *lpfc_sgl_list = &phba->sli4_hba.lpfc_sgl_list;
+	struct lpfc_sglq *sglq = NULL;
+	uint16_t adj_xri;
+	list_remove_head(lpfc_sgl_list, sglq, struct lpfc_sglq, list);
+	adj_xri = sglq->sli4_xritag - phba->sli4_hba.max_cfg_param.xri_base;
+	phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = sglq;
+	return sglq;
+}
+
+/**
  * lpfc_sli_get_iocbq - Allocates an iocb object from iocb pool
  * @phba: Pointer to HBA context object.
  *
@@ -298,6 +371,14 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_GEN_REQUEST64_CR:
 	case CMD_GEN_REQUEST64_CX:
 	case CMD_XMIT_ELS_RSP64_CX:
+	case DSSCMD_IWRITE64_CR:
+	case DSSCMD_IWRITE64_CX:
+	case DSSCMD_IREAD64_CR:
+	case DSSCMD_IREAD64_CX:
+	case DSSCMD_INVALIDATE_DEK:
+	case DSSCMD_SET_KEK:
+	case DSSCMD_GET_KEK_ID:
+	case DSSCMD_GEN_XFER:
 		type = LPFC_SOL_IOCB;
 		break;
 	case CMD_ABORT_XRI_CN:
@@ -2629,6 +2710,56 @@ lpfc_sli_brdready_s3(struct lpfc_hba *ph
 	return retval;
 }
 
+/**
+ * lpfc_sli_brdready_s4 - Check for sli4 host ready status
+ * @phba: Pointer to HBA context object.
+ * @mask: Bit mask to be checked.
+ *
+ * This function checks the host status register to check if HBA is
+ * ready. This function will wait in a loop for the HBA to be ready
+ * If the HBA is not ready , the function will will reset the HBA PCI
+ * function again. The function returns 1 when HBA fail to be ready
+ * otherwise returns zero.
+ **/
+static int
+lpfc_sli_brdready_s4(struct lpfc_hba *phba, uint32_t mask)
+{
+	uint32_t status;
+	int retval = 0;
+
+	/* Read the HBA Host Status Register */
+	status = lpfc_sli4_post_status_check(phba);
+
+	if (status) {
+		phba->pport->port_state = LPFC_VPORT_UNKNOWN;
+		lpfc_sli_brdrestart(phba);
+		status = lpfc_sli4_post_status_check(phba);
+	}
+
+	/* Check to see if any errors occurred during init */
+	if (status) {
+		phba->link_state = LPFC_HBA_ERROR;
+		retval = 1;
+	} else
+		phba->sli4_hba.intr_enable = 0;
+
+	return retval;
+}
+
+/**
+ * lpfc_sli_brdready - Wrapper func for checking the hba readyness
+ * @phba: Pointer to HBA context object.
+ * @mask: Bit mask to be checked.
+ *
+ * This routine wraps the actual SLI3 or SLI4 hba readyness check routine
+ * from the API jump table function pointer from the lpfc_hba struct.
+ **/
+int
+lpfc_sli_brdready(struct lpfc_hba *phba, uint32_t mask)
+{
+	return phba->lpfc_sli_brdready(phba, mask);
+}
+
 #define BARRIER_TEST_PATTERN (0xdeadbeef)
 
 /**
@@ -2863,7 +2994,66 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_brdrestart - Restart the HBA
+ * lpfc_sli4_brdreset - Reset a sli-4 HBA
+ * @phba: Pointer to HBA context object.
+ *
+ * This function resets a SLI4 HBA. This function disables PCI layer parity
+ * checking during resets the device. The caller is not required to hold
+ * any locks.
+ *
+ * This function returns 0 always.
+ **/
+int
+lpfc_sli4_brdreset(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	uint16_t cfg_value;
+	uint8_t qindx;
+
+	/* Reset HBA */
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"0295 Reset HBA Data: x%x x%x\n",
+			phba->pport->port_state, psli->sli_flag);
+
+	/* perform board reset */
+	phba->fc_eventTag = 0;
+	phba->pport->fc_myDID = 0;
+	phba->pport->fc_prevDID = 0;
+
+	/* Turn off parity checking and serr during the physical reset */
+	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
+	pci_write_config_word(phba->pcidev, PCI_COMMAND,
+			      (cfg_value &
+			      ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
+
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~(LPFC_PROCESS_LA);
+	phba->fcf.fcf_flag = 0;
+	/* Clean up the child queue list for the CQs */
+	list_del_init(&phba->sli4_hba.mbx_wq->list);
+	list_del_init(&phba->sli4_hba.els_wq->list);
+	list_del_init(&phba->sli4_hba.hdr_rq->list);
+	list_del_init(&phba->sli4_hba.dat_rq->list);
+	list_del_init(&phba->sli4_hba.mbx_cq->list);
+	list_del_init(&phba->sli4_hba.els_cq->list);
+	list_del_init(&phba->sli4_hba.rxq_cq->list);
+	for (qindx = 0; qindx < phba->cfg_fcp_wq_count; qindx++)
+		list_del_init(&phba->sli4_hba.fcp_wq[qindx]->list);
+	for (qindx = 0; qindx < phba->cfg_fcp_eq_count; qindx++)
+		list_del_init(&phba->sli4_hba.fcp_cq[qindx]->list);
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Now physically reset the device */
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0389 Performing PCI function reset!\n");
+	/* Perform FCoE PCI function reset */
+	lpfc_pci_function_reset(phba);
+
+	return 0;
+}
+
+/**
+ * lpfc_sli_brdrestart_s3 - Restart a sli-3 hba
  * @phba: Pointer to HBA context object.
  *
  * This function is called in the SLI initialization code path to
@@ -2875,8 +3065,8 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
  * The function does not guarantee completion of MBX_RESTART mailbox
  * command before the return of this function.
  **/
-int
-lpfc_sli_brdrestart(struct lpfc_hba *phba)
+static int
+lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
 {
 	MAILBOX_t *mb;
 	struct lpfc_sli *psli;
@@ -2915,7 +3105,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phb
 	lpfc_sli_brdreset(phba);
 	phba->pport->stopped = 0;
 	phba->link_state = LPFC_INIT_START;
-
+	phba->hba_flag = 0;
 	spin_unlock_irq(&phba->hbalock);
 
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
@@ -2930,6 +3120,55 @@ lpfc_sli_brdrestart(struct lpfc_hba *phb
 }
 
 /**
+ * lpfc_sli_brdrestart_s4 - Restart the sli-4 hba
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called in the SLI initialization code path to restart
+ * a SLI4 HBA. The caller is not required to hold any lock.
+ * At the end of the function, it calls lpfc_hba_down_post function to
+ * free any pending commands.
+ **/
+static int
+lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+
+
+	/* Restart HBA */
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"0296 Restart HBA Data: x%x x%x\n",
+			phba->pport->port_state, psli->sli_flag);
+
+	lpfc_sli4_brdreset(phba);
+
+	spin_lock_irq(&phba->hbalock);
+	phba->pport->stopped = 0;
+	phba->link_state = LPFC_INIT_START;
+	phba->hba_flag = 0;
+	spin_unlock_irq(&phba->hbalock);
+
+	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
+	psli->stats_start = get_seconds();
+
+	lpfc_hba_down_post(phba);
+
+	return 0;
+}
+
+/**
+ * lpfc_sli_brdrestart - Wrapper func for restarting hba
+ * @phba: Pointer to HBA context object.
+ *
+ * This routine wraps the actual SLI3 or SLI4 hba restart routine from the
+ * API jump table function pointer from the lpfc_hba struct.
+**/
+int
+lpfc_sli_brdrestart(struct lpfc_hba *phba)
+{
+	return phba->lpfc_sli_brdrestart(phba);
+}
+
+/**
  * lpfc_sli_chipset_init - Wait for the restart of the HBA after a restart
  * @phba: Pointer to HBA context object.
  *
@@ -3353,6 +3592,488 @@ lpfc_sli_hba_setup_error:
 	return rc;
 }
 
+/**
+ * lpfc_sli4_read_fcoe_params - Read fcoe params from conf region
+ * @phba: Pointer to HBA context object.
+ * @mboxq: mailbox pointer.
+ * This function issue a dump mailbox command to read config region
+ * 23 and parse the records in the region and populate driver
+ * data structure.
+ **/
+static int
+lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
+		LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_dmabuf *mp;
+	struct lpfc_mqe *mqe;
+	uint32_t data_length;
+	int rc;
+
+	/* Program the default value of vlan_id and fc_map */
+	phba->valid_vlan = 0;
+	phba->fc_map[0] = LPFC_FCOE_FCF_MAP0;
+	phba->fc_map[1] = LPFC_FCOE_FCF_MAP1;
+	phba->fc_map[2] = LPFC_FCOE_FCF_MAP2;
+
+	mqe = &mboxq->u.mqe;
+	if (lpfc_dump_fcoe_param(phba, mboxq))
+		return -ENOMEM;
+
+	mp = (struct lpfc_dmabuf *) mboxq->context1;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"(%d):2571 Mailbox cmd x%x Status x%x "
+			"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x "
+			"x%x x%x x%x x%x x%x x%x x%x x%x x%x "
+			"CQ: x%x x%x x%x x%x\n",
+			mboxq->vport ? mboxq->vport->vpi : 0,
+			bf_get(lpfc_mqe_command, mqe),
+			bf_get(lpfc_mqe_status, mqe),
+			mqe->un.mb_words[0], mqe->un.mb_words[1],
+			mqe->un.mb_words[2], mqe->un.mb_words[3],
+			mqe->un.mb_words[4], mqe->un.mb_words[5],
+			mqe->un.mb_words[6], mqe->un.mb_words[7],
+			mqe->un.mb_words[8], mqe->un.mb_words[9],
+			mqe->un.mb_words[10], mqe->un.mb_words[11],
+			mqe->un.mb_words[12], mqe->un.mb_words[13],
+			mqe->un.mb_words[14], mqe->un.mb_words[15],
+			mqe->un.mb_words[16], mqe->un.mb_words[50],
+			mboxq->mcqe.word0,
+			mboxq->mcqe.mcqe_tag0, 	mboxq->mcqe.mcqe_tag1,
+			mboxq->mcqe.trailer);
+
+	if (rc) {
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
+		kfree(mp);
+		return -EIO;
+	}
+	data_length = mqe->un.mb_words[5];
+	if (data_length > DMP_FCOEPARAM_RGN_SIZE)
+		return -EIO;
+
+	lpfc_parse_fcoe_conf(phba, mp->virt, data_length);
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+	kfree(mp);
+	return 0;
+}
+
+/**
+ * lpfc_sli4_read_rev - Issue READ_REV and collect vpd data
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to the LPFC_MBOXQ_t structure.
+ * @vpd: pointer to the memory to hold resulting port vpd data.
+ * @vpd_size: On input, the number of bytes allocated to @vpd.
+ *	      On output, the number of data bytes in @vpd.
+ *
+ * This routine executes a READ_REV SLI4 mailbox command.  In
+ * addition, this routine gets the port vpd data.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	ENOMEM - could not allocated memory.
+ **/
+static int
+lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
+		    uint8_t *vpd, uint32_t *vpd_size)
+{
+	int rc = 0;
+	uint32_t dma_size;
+	struct lpfc_dmabuf *dmabuf;
+	struct lpfc_mqe *mqe;
+
+	dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!dmabuf)
+		return -ENOMEM;
+
+	/*
+	 * Get a DMA buffer for the vpd data resulting from the READ_REV
+	 * mailbox command.
+	 */
+	dma_size = *vpd_size;
+	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
+					  dma_size,
+					  &dmabuf->phys,
+					  GFP_KERNEL);
+	if (!dmabuf->virt) {
+		kfree(dmabuf);
+		return -ENOMEM;
+	}
+	memset(dmabuf->virt, 0, dma_size);
+
+	/*
+	 * The SLI4 implementation of READ_REV conflicts at word1,
+	 * bits 31:16 and SLI4 adds vpd functionality not present
+	 * in SLI3.  This code corrects the conflicts.
+	 */
+	lpfc_read_rev(phba, mboxq);
+	mqe = &mboxq->u.mqe;
+	mqe->un.read_rev.vpd_paddr_high = putPaddrHigh(dmabuf->phys);
+	mqe->un.read_rev.vpd_paddr_low = putPaddrLow(dmabuf->phys);
+	mqe->un.read_rev.word1 &= 0x0000FFFF;
+	bf_set(lpfc_mbx_rd_rev_vpd, &mqe->un.read_rev, 1);
+	bf_set(lpfc_mbx_rd_rev_avail_len, &mqe->un.read_rev, dma_size);
+
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (rc) {
+		dma_free_coherent(&phba->pcidev->dev, dma_size,
+				  dmabuf->virt, dmabuf->phys);
+		return -EIO;
+	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"(%d):0380 Mailbox cmd x%x Status x%x "
+			"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x "
+			"x%x x%x x%x x%x x%x x%x x%x x%x x%x "
+			"CQ: x%x x%x x%x x%x\n",
+			mboxq->vport ? mboxq->vport->vpi : 0,
+			bf_get(lpfc_mqe_command, mqe),
+			bf_get(lpfc_mqe_status, mqe),
+			mqe->un.mb_words[0], mqe->un.mb_words[1],
+			mqe->un.mb_words[2], mqe->un.mb_words[3],
+			mqe->un.mb_words[4], mqe->un.mb_words[5],
+			mqe->un.mb_words[6], mqe->un.mb_words[7],
+			mqe->un.mb_words[8], mqe->un.mb_words[9],
+			mqe->un.mb_words[10], mqe->un.mb_words[11],
+			mqe->un.mb_words[12], mqe->un.mb_words[13],
+			mqe->un.mb_words[14], mqe->un.mb_words[15],
+			mqe->un.mb_words[16], mqe->un.mb_words[50],
+			mboxq->mcqe.word0,
+			mboxq->mcqe.mcqe_tag0, 	mboxq->mcqe.mcqe_tag1,
+			mboxq->mcqe.trailer);
+
+	/*
+	 * The available vpd length cannot be bigger than the
+	 * DMA buffer passed to the port.  Catch the less than
+	 * case and update the caller's size.
+	 */
+	if (mqe->un.read_rev.avail_vpd_len < *vpd_size)
+		*vpd_size = mqe->un.read_rev.avail_vpd_len;
+
+	lpfc_sli_pcimem_bcopy(dmabuf->virt, vpd, *vpd_size);
+	dma_free_coherent(&phba->pcidev->dev, dma_size,
+			  dmabuf->virt, dmabuf->phys);
+	kfree(dmabuf);
+	return 0;
+}
+
+/**
+ * lpfc_sli4_arm_cqeq_intr - Arm sli-4 device completion and event queues
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to explicitly arm the SLI4 device's completion and
+ * event queues
+ **/
+static void
+lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
+{
+	uint8_t fcp_eqidx;
+
+	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
+	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
+	lpfc_sli4_cq_release(phba->sli4_hba.rxq_cq, LPFC_QUEUE_REARM);
+	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++)
+		lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[fcp_eqidx],
+				     LPFC_QUEUE_REARM);
+	lpfc_sli4_eq_release(phba->sli4_hba.sp_eq, LPFC_QUEUE_REARM);
+	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++)
+		lpfc_sli4_eq_release(phba->sli4_hba.fp_eq[fcp_eqidx],
+				     LPFC_QUEUE_REARM);
+}
+
+/**
+ * lpfc_sli4_hba_setup - SLI4 device intialization PCI function
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is the main SLI4 device intialization PCI function. This
+ * function is called by the HBA intialization code, HBA reset code and
+ * HBA error attention handler code. Caller is not required to hold any
+ * locks.
+ **/
+int
+lpfc_sli4_hba_setup(struct lpfc_hba *phba)
+{
+	int rc;
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mqe *mqe;
+	uint8_t *vpd;
+	uint32_t vpd_size;
+	uint32_t ftr_rsp = 0;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(phba->pport);
+	struct lpfc_vport *vport = phba->pport;
+	struct lpfc_dmabuf *mp;
+
+	/* Perform a PCI function reset to start from clean */
+	rc = lpfc_pci_function_reset(phba);
+	if (unlikely(rc))
+		return -ENODEV;
+
+	/* Check the HBA Host Status Register for readyness */
+	rc = lpfc_sli4_post_status_check(phba);
+	if (unlikely(rc))
+		return -ENODEV;
+	else {
+		spin_lock_irq(&phba->hbalock);
+		phba->sli.sli_flag |= LPFC_SLI_ACTIVE;
+		spin_unlock_irq(&phba->hbalock);
+	}
+
+	/*
+	 * Allocate a single mailbox container for initializing the
+	 * port.
+	 */
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+
+	/*
+	 * Continue initialization with default values even if driver failed
+	 * to read FCoE param config regions
+	 */
+	if (lpfc_sli4_read_fcoe_params(phba, mboxq))
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+			"2570 Failed to read FCoE parameters \n");
+
+	/* Issue READ_REV to collect vpd and FW information. */
+	vpd_size = PAGE_SIZE;
+	vpd = kzalloc(vpd_size, GFP_KERNEL);
+	if (!vpd) {
+		rc = -ENOMEM;
+		goto out_free_mbox;
+	}
+
+	rc = lpfc_sli4_read_rev(phba, mboxq, vpd, &vpd_size);
+	if (unlikely(rc))
+		goto out_free_vpd;
+
+	mqe = &mboxq->u.mqe;
+	if ((bf_get(lpfc_mbx_rd_rev_sli_lvl,
+		    &mqe->un.read_rev) != LPFC_SLI_REV4) ||
+	    (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev) == 0)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+			"0376 READ_REV Error. SLI Level %d "
+			"FCoE enabled %d\n",
+			bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev),
+			bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev));
+		rc = -EIO;
+		goto out_free_vpd;
+	}
+	/* Single threaded at this point, no need for lock */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag |= HBA_FCOE_SUPPORT;
+	spin_unlock_irq(&phba->hbalock);
+	/*
+	 * Evaluate the read rev and vpd data. Populate the driver
+	 * state with the results. If this routine fails, the failure
+	 * is not fatal as the driver will use generic values.
+	 */
+	rc = lpfc_parse_vpd(phba, vpd, vpd_size);
+	if (unlikely(!rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0377 Error %d parsing vpd. "
+				"Using defaults.\n", rc);
+		rc = 0;
+	}
+
+	/* By now, we should determine the SLI revision, hard code for now */
+	phba->sli_rev = LPFC_SLI_REV4;
+
+	/*
+	 * Discover the port's supported feature set and match it against the
+	 * hosts requests.
+	 */
+	lpfc_request_features(phba, mboxq);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto out_free_vpd;
+	}
+
+	/*
+	 * The port must support FCP initiator mode as this is the
+	 * only mode running in the host.
+	 */
+	if (!(bf_get(lpfc_mbx_rq_ftr_rsp_fcpi, &mqe->un.req_ftrs))) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				"0378 No support for fcpi mode.\n");
+		ftr_rsp++;
+	}
+
+	/*
+	 * If the port cannot support the host's requested features
+	 * then turn off the global config parameters to disable the
+	 * feature in the driver.  This is not a fatal error.
+	 */
+	if ((phba->cfg_enable_bg) &&
+	    !(bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs)))
+		ftr_rsp++;
+
+	if (phba->max_vpi && phba->cfg_enable_npiv &&
+	    !(bf_get(lpfc_mbx_rq_ftr_rsp_npiv, &mqe->un.req_ftrs)))
+		ftr_rsp++;
+
+	if (ftr_rsp) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				"0379 Feature Mismatch Data: x%08x %08x "
+				"x%x x%x x%x\n", mqe->un.req_ftrs.word2,
+				mqe->un.req_ftrs.word3, phba->cfg_enable_bg,
+				phba->cfg_enable_npiv, phba->max_vpi);
+		if (!(bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs)))
+			phba->cfg_enable_bg = 0;
+		if (!(bf_get(lpfc_mbx_rq_ftr_rsp_npiv, &mqe->un.req_ftrs)))
+			phba->cfg_enable_npiv = 0;
+	}
+
+	/* These SLI3 features are assumed in SLI4 */
+	spin_lock_irq(&phba->hbalock);
+	phba->sli3_options |= (LPFC_SLI3_NPIV_ENABLED | LPFC_SLI3_HBQ_ENABLED);
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Read the port's service parameters. */
+	lpfc_read_sparam(phba, mboxq, vport->vpi);
+	mboxq->vport = vport;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	mp = (struct lpfc_dmabuf *) mboxq->context1;
+	if (rc == MBX_SUCCESS) {
+		memcpy(&vport->fc_sparam, mp->virt, sizeof(struct serv_parm));
+		rc = 0;
+	}
+
+	/*
+	 * This memory was allocated by the lpfc_read_sparam routine. Release
+	 * it to the mbuf pool.
+	 */
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+	kfree(mp);
+	mboxq->context1 = NULL;
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0382 READ_SPARAM command failed "
+				"status %d, mbxStatus x%x\n",
+				rc, bf_get(lpfc_mqe_status, mqe));
+		phba->link_state = LPFC_HBA_ERROR;
+		rc = -EIO;
+		goto out_free_vpd;
+	}
+
+	if (phba->cfg_soft_wwnn)
+		u64_to_wwn(phba->cfg_soft_wwnn,
+			   vport->fc_sparam.nodeName.u.wwn);
+	if (phba->cfg_soft_wwpn)
+		u64_to_wwn(phba->cfg_soft_wwpn,
+			   vport->fc_sparam.portName.u.wwn);
+	memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
+	       sizeof(struct lpfc_name));
+	memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
+	       sizeof(struct lpfc_name));
+
+	/* Update the fc_host data structures with new wwn. */
+	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
+	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
+
+	/* Register SGL pool to the device using non-embedded mailbox command */
+	rc = lpfc_sli4_post_sgl_list(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0582 Error %d during sgl post operation", rc);
+		rc = -ENODEV;
+		goto out_free_vpd;
+	}
+
+	/* Register SCSI SGL pool to the device */
+	rc = lpfc_sli4_repost_scsi_sgl_list(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				"0383 Error %d during scsi sgl post opeation",
+				rc);
+		/* Some Scsi buffers were moved to the abort scsi list */
+		/* A pci function reset will repost them */
+		rc = -ENODEV;
+		goto out_free_vpd;
+	}
+
+	/* Post the rpi header region to the device. */
+	rc = lpfc_sli4_post_all_rpi_hdrs(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0393 Error %d during rpi post operation\n",
+				rc);
+		rc = -ENODEV;
+		goto out_free_vpd;
+	}
+	/* Temporary initialization of lpfc_fip_flag to non-fip */
+	bf_set(lpfc_fip_flag, &phba->sli4_hba.sli4_flags, 0);
+
+	/* Set up all the queues to the device */
+	rc = lpfc_sli4_queue_setup(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0381 Error %d during queue setup.\n ", rc);
+		goto out_stop_timers;
+	}
+
+	/* Arm the CQs and then EQs on device */
+	lpfc_sli4_arm_cqeq_intr(phba);
+
+	/* Indicate device interrupt mode */
+	phba->sli4_hba.intr_enable = 1;
+
+	/* Allow asynchronous mailbox command to go through */
+	spin_lock_irq(&phba->hbalock);
+	phba->sli.sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Post receive buffers to the device */
+	lpfc_sli4_rb_setup(phba);
+
+	/* Start the ELS watchdog timer */
+	/*
+	 * The driver for SLI4 is not yet ready to process timeouts
+	 * or interrupts.  Once it is, the comment bars can be removed.
+	 */
+	/* mod_timer(&vport->els_tmofunc,
+	 *           jiffies + HZ * (phba->fc_ratov*2)); */
+
+	/* Start heart beat timer */
+	mod_timer(&phba->hb_tmofunc,
+		  jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+	phba->hb_outstanding = 0;
+	phba->last_completion_time = jiffies;
+
+	/* Start error attention (ERATT) polling timer */
+	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
+
+	/*
+	 * The port is ready, set the host's link state to LINK_DOWN
+	 * in preparation for link interrupts.
+	 */
+	lpfc_init_link(phba, mboxq, phba->cfg_topology, phba->cfg_link_speed);
+	mboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	lpfc_set_loopback_flag(phba);
+	/* Change driver state to LPFC_LINK_DOWN right before init link */
+	spin_lock_irq(&phba->hbalock);
+	phba->link_state = LPFC_LINK_DOWN;
+	spin_unlock_irq(&phba->hbalock);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (unlikely(rc != MBX_NOT_FINISHED)) {
+		kfree(vpd);
+		return 0;
+	} else
+		rc = -EIO;
+
+	/* Unset all the queues set up in this routine when error out */
+	if (rc)
+		lpfc_sli4_queue_unset(phba);
+
+out_stop_timers:
+	if (rc)
+		lpfc_stop_hba_timers(phba);
+out_free_vpd:
+	kfree(vpd);
+out_free_mbox:
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return rc;
+}
 
 /**
  * lpfc_mbox_timeout - Timeout call back function for mbox timer
@@ -3812,13 +4533,420 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 
 out_not_finished:
 	if (processing_queue) {
-		pmbox->mb.mbxStatus = MBX_NOT_FINISHED;
+		pmbox->u.mb.mbxStatus = MBX_NOT_FINISHED;
 		lpfc_mbox_cmpl_put(phba, pmbox);
 	}
 	return MBX_NOT_FINISHED;
 }
 
 /**
+ * lpfc_sli4_post_sync_mbox - Post an SLI4 mailbox to the bootstrap mailbox
+ * @phba: Pointer to HBA context object.
+ * @mboxq: Pointer to mailbox object.
+ *
+ * The function posts a mailbox to the port.  The mailbox is expected
+ * to be comletely filled in and ready for the port to operate on it.
+ * This routine executes a synchronous completion operation on the
+ * mailbox by polling for its completion.
+ *
+ * The caller must not be holding any locks when calling this routine.
+ *
+ * Returns:
+ *	MBX_SUCCESS - mailbox posted successfully
+ *	Any of the MBX error values.
+ **/
+static int
+lpfc_sli4_post_sync_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	int rc = MBX_SUCCESS;
+	unsigned long iflag;
+	uint32_t db_ready;
+	uint32_t mcqe_status;
+	uint32_t mbx_cmnd;
+	unsigned long timeout;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_mqe *mb = &mboxq->u.mqe;
+	struct lpfc_bmbx_create *mbox_rgn;
+	struct dma_address *dma_address;
+	struct lpfc_register bmbx_reg;
+
+	/*
+	 * Only one mailbox can be active to the bootstrap mailbox region
+	 * at a time and there is no queueing provided.
+	 */
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2532 Mailbox command x%x (x%x) "
+				"cannot issue Data: x%x x%x\n",
+				mboxq->vport ? mboxq->vport->vpi : 0,
+				mboxq->u.mb.mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				psli->sli_flag, MBX_POLL);
+		return MBXERR_ERROR;
+	}
+	/* The server grabs the token and owns it until release */
+	psli->sli_flag |= LPFC_SLI_MBOX_ACTIVE;
+	phba->sli.mbox_active = mboxq;
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+
+	/*
+	 * Initialize the bootstrap memory region to avoid stale data areas
+	 * in the mailbox post.  Then copy the caller's mailbox contents to
+	 * the bmbx mailbox region.
+	 */
+	mbx_cmnd = bf_get(lpfc_mqe_command, mb);
+	memset(phba->sli4_hba.bmbx.avirt, 0, sizeof(struct lpfc_bmbx_create));
+	lpfc_sli_pcimem_bcopy(mb, phba->sli4_hba.bmbx.avirt,
+			      sizeof(struct lpfc_mqe));
+
+	/* Post the high mailbox dma address to the port and wait for ready. */
+	dma_address = &phba->sli4_hba.bmbx.dma_address;
+	writel(dma_address->addr_hi, phba->sli4_hba.BMBXregaddr);
+
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mbx_cmnd)
+				   * 1000) + jiffies;
+	do {
+		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
+		db_ready = bf_get(lpfc_bmbx_rdy, &bmbx_reg);
+		if (!db_ready)
+			msleep(2);
+
+		if (time_after(jiffies, timeout)) {
+			rc = MBXERR_ERROR;
+			goto exit;
+		}
+	} while (!db_ready);
+
+	/* Post the low mailbox dma address to the port. */
+	writel(dma_address->addr_lo, phba->sli4_hba.BMBXregaddr);
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mbx_cmnd)
+				   * 1000) + jiffies;
+	do {
+		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
+		db_ready = bf_get(lpfc_bmbx_rdy, &bmbx_reg);
+		if (!db_ready)
+			msleep(2);
+
+		if (time_after(jiffies, timeout)) {
+			rc = MBXERR_ERROR;
+			goto exit;
+		}
+	} while (!db_ready);
+
+	/*
+	 * Read the CQ to ensure the mailbox has completed.
+	 * If so, update the mailbox status so that the upper layers
+	 * can complete the request normally.
+	 */
+	lpfc_sli_pcimem_bcopy(phba->sli4_hba.bmbx.avirt, mb,
+			      sizeof(struct lpfc_mqe));
+	mbox_rgn = (struct lpfc_bmbx_create *) phba->sli4_hba.bmbx.avirt;
+	lpfc_sli_pcimem_bcopy(&mbox_rgn->mcqe, &mboxq->mcqe,
+			      sizeof(struct lpfc_mcqe));
+	mcqe_status = bf_get(lpfc_mcqe_status, &mbox_rgn->mcqe);
+
+	/* Prefix the mailbox status with range x4000 to note SLI4 status. */
+	if (mcqe_status != MB_CQE_STATUS_SUCCESS) {
+		bf_set(lpfc_mqe_status, mb, LPFC_MBX_ERROR_RANGE | mcqe_status);
+		rc = MBXERR_ERROR;
+	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"(%d):0356 Mailbox cmd x%x (x%x) Status x%x "
+			"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x x%x x%x"
+			" x%x x%x CQ: x%x x%x x%x x%x\n",
+			mboxq->vport ? mboxq->vport->vpi : 0,
+			mbx_cmnd, lpfc_sli4_mbox_opcode_get(phba, mboxq),
+			bf_get(lpfc_mqe_status, mb),
+			mb->un.mb_words[0], mb->un.mb_words[1],
+			mb->un.mb_words[2], mb->un.mb_words[3],
+			mb->un.mb_words[4], mb->un.mb_words[5],
+			mb->un.mb_words[6], mb->un.mb_words[7],
+			mb->un.mb_words[8], mb->un.mb_words[9],
+			mb->un.mb_words[10], mb->un.mb_words[11],
+			mb->un.mb_words[12], mboxq->mcqe.word0,
+			mboxq->mcqe.mcqe_tag0, 	mboxq->mcqe.mcqe_tag1,
+			mboxq->mcqe.trailer);
+exit:
+	/* We are holding the token, no needed for lock when release */
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	phba->sli.mbox_active = NULL;
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	return rc;
+}
+
+/**
+ * lpfc_sli_issue_mbox_s4 - Issue an SLI4 mailbox command to firmware
+ * @phba: Pointer to HBA context object.
+ * @pmbox: Pointer to mailbox object.
+ * @flag: Flag indicating how the mailbox need to be processed.
+ *
+ * This function is called by discovery code and HBA management code to submit
+ * a mailbox command to firmware with SLI-4 interface spec.
+ *
+ * Return codes the caller owns the mailbox command after the return of the
+ * function.
+ **/
+static int
+lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
+		       uint32_t flag)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	unsigned long iflags;
+	int rc;
+
+	/* Detect polling mode and jump to a handler */
+	if (!phba->sli4_hba.intr_enable) {
+		if (flag == MBX_POLL)
+			rc = lpfc_sli4_post_sync_mbox(phba, mboxq);
+		else
+			rc = -EIO;
+		if (rc != MBX_SUCCESS)
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"(%d):2541 Mailbox command x%x "
+					"(x%x) cannot issue Data: x%x x%x\n",
+					mboxq->vport ? mboxq->vport->vpi : 0,
+					mboxq->u.mb.mbxCommand,
+					lpfc_sli4_mbox_opcode_get(phba, mboxq),
+					psli->sli_flag, flag);
+		return rc;
+	} else if (flag == MBX_POLL) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2542 Mailbox command x%x (x%x) "
+				"cannot issue Data: x%x x%x\n",
+				mboxq->vport ? mboxq->vport->vpi : 0,
+				mboxq->u.mb.mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				psli->sli_flag, flag);
+		return -EIO;
+	}
+
+	/* Now, interrupt mode asynchrous mailbox command */
+	rc = lpfc_mbox_cmd_check(phba, mboxq);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2543 Mailbox command x%x (x%x) "
+				"cannot issue Data: x%x x%x\n",
+				mboxq->vport ? mboxq->vport->vpi : 0,
+				mboxq->u.mb.mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				psli->sli_flag, flag);
+		goto out_not_finished;
+	}
+	rc = lpfc_mbox_dev_check(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2544 Mailbox command x%x (x%x) "
+				"cannot issue Data: x%x x%x\n",
+				mboxq->vport ? mboxq->vport->vpi : 0,
+				mboxq->u.mb.mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				psli->sli_flag, flag);
+		goto out_not_finished;
+	}
+
+	/* Put the mailbox command to the driver internal FIFO */
+	psli->slistat.mbox_busy++;
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	lpfc_mbox_put(phba, mboxq);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"(%d):0354 Mbox cmd issue - Enqueue Data: "
+			"x%x (x%x) x%x x%x x%x\n",
+			mboxq->vport ? mboxq->vport->vpi : 0xffffff,
+			bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+			lpfc_sli4_mbox_opcode_get(phba, mboxq),
+			phba->pport->port_state,
+			psli->sli_flag, MBX_NOWAIT);
+	/* Wake up worker thread to transport mailbox command from head */
+	lpfc_worker_wake_up(phba);
+
+	return MBX_BUSY;
+
+out_not_finished:
+	return MBX_NOT_FINISHED;
+}
+
+/**
+ * lpfc_sli4_post_async_mbox - Post an SLI4 mailbox command to device
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called by worker thread to send a mailbox command to
+ * SLI4 HBA firmware.
+ *
+ **/
+int
+lpfc_sli4_post_async_mbox(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	LPFC_MBOXQ_t *mboxq;
+	int rc = MBX_SUCCESS;
+	unsigned long iflags;
+	struct lpfc_mqe *mqe;
+	uint32_t mbx_cmnd;
+
+	/* Check interrupt mode before post async mailbox command */
+	if (unlikely(!phba->sli4_hba.intr_enable))
+		return MBX_NOT_FINISHED;
+
+	/* Check for mailbox command service token */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	if (unlikely(psli->sli_flag & LPFC_SLI_ASYNC_MBX_BLK)) {
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		return MBX_NOT_FINISHED;
+	}
+	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		return MBX_NOT_FINISHED;
+	}
+	if (unlikely(phba->sli.mbox_active)) {
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0384 There is pending active mailbox cmd\n");
+		return MBX_NOT_FINISHED;
+	}
+	/* Take the mailbox command service token */
+	psli->sli_flag |= LPFC_SLI_MBOX_ACTIVE;
+
+	/* Get the next mailbox command from head of queue */
+	mboxq = lpfc_mbox_get(phba);
+
+	/* If no more mailbox command waiting for post, we're done */
+	if (!mboxq) {
+		psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		return MBX_SUCCESS;
+	}
+	phba->sli.mbox_active = mboxq;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	/* Check device readiness for posting mailbox command */
+	rc = lpfc_mbox_dev_check(phba);
+	if (unlikely(rc))
+		/* Driver clean routine will clean up pending mailbox */
+		goto out_not_finished;
+
+	/* Prepare the mbox command to be posted */
+	mqe = &mboxq->u.mqe;
+	mbx_cmnd = bf_get(lpfc_mqe_command, mqe);
+
+	/* Start timer for the mbox_tmo and log some mailbox post messages */
+	mod_timer(&psli->mbox_tmo, (jiffies +
+		  (HZ * lpfc_mbox_tmo_val(phba, mbx_cmnd))));
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"(%d):0355 Mailbox cmd x%x (x%x) issue Data: "
+			"x%x x%x\n",
+			mboxq->vport ? mboxq->vport->vpi : 0, mbx_cmnd,
+			lpfc_sli4_mbox_opcode_get(phba, mboxq),
+			phba->pport->port_state, psli->sli_flag);
+
+	if (mbx_cmnd != MBX_HEARTBEAT) {
+		if (mboxq->vport) {
+			lpfc_debugfs_disc_trc(mboxq->vport,
+				LPFC_DISC_TRC_MBOX_VPORT,
+				"MBOX Send vport: cmd:x%x mb:x%x x%x",
+				mbx_cmnd, mqe->un.mb_words[0],
+				mqe->un.mb_words[1]);
+		} else {
+			lpfc_debugfs_disc_trc(phba->pport,
+				LPFC_DISC_TRC_MBOX,
+				"MBOX Send: cmd:x%x mb:x%x x%x",
+				mbx_cmnd, mqe->un.mb_words[0],
+				mqe->un.mb_words[1]);
+		}
+	}
+	psli->slistat.mbox_cmd++;
+
+	/* Post the mailbox command to the port */
+	rc = lpfc_sli4_mq_put(phba->sli4_hba.mbx_wq, mqe);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2533 Mailbox command x%x (x%x) "
+				"cannot issue Data: x%x x%x\n",
+				mboxq->vport ? mboxq->vport->vpi : 0,
+				mboxq->u.mb.mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				psli->sli_flag, MBX_NOWAIT);
+		goto out_not_finished;
+	}
+
+	return rc;
+
+out_not_finished:
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	mboxq->u.mb.mbxStatus = MBX_NOT_FINISHED;
+	__lpfc_mbox_cmpl_put(phba, mboxq);
+	/* Release the token */
+	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	phba->sli.mbox_active = NULL;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	return MBX_NOT_FINISHED;
+}
+
+/**
+ * lpfc_sli_issue_mbox - Wrapper func for issuing mailbox command
+ * @phba: Pointer to HBA context object.
+ * @pmbox: Pointer to mailbox object.
+ * @flag: Flag indicating how the mailbox need to be processed.
+ *
+ * This routine wraps the actual SLI3 or SLI4 mailbox issuing routine from
+ * the API jump table function pointer from the lpfc_hba struct.
+ *
+ * Return codes the caller owns the mailbox command after the return of the
+ * function.
+ **/
+int
+lpfc_sli_issue_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox, uint32_t flag)
+{
+	return phba->lpfc_sli_issue_mbox(phba, pmbox, flag);
+}
+
+/**
+ * lpfc_mbox_api_table_setup - Set up mbox api fucntion jump table
+ * @phba: The hba struct for which this call is being executed.
+ * @dev_grp: The HBA PCI-Device group number.
+ *
+ * This routine sets up the mbox interface API function jump table in @phba
+ * struct.
+ * Returns: 0 - success, -ENODEV - failure.
+ **/
+int
+lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
+{
+
+	switch (dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		phba->lpfc_sli_issue_mbox = lpfc_sli_issue_mbox_s3;
+		phba->lpfc_sli_handle_slow_ring_event =
+				lpfc_sli_handle_slow_ring_event_s3;
+		phba->lpfc_sli_hbq_to_firmware = lpfc_sli_hbq_to_firmware_s3;
+		phba->lpfc_sli_brdrestart = lpfc_sli_brdrestart_s3;
+		phba->lpfc_sli_brdready = lpfc_sli_brdready_s3;
+		break;
+	case LPFC_PCI_DEV_OC:
+		phba->lpfc_sli_issue_mbox = lpfc_sli_issue_mbox_s4;
+		phba->lpfc_sli_handle_slow_ring_event =
+				lpfc_sli_handle_slow_ring_event_s4;
+		phba->lpfc_sli_hbq_to_firmware = lpfc_sli_hbq_to_firmware_s4;
+		phba->lpfc_sli_brdrestart = lpfc_sli_brdrestart_s4;
+		phba->lpfc_sli_brdready = lpfc_sli_brdready_s4;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1420 Invalid HBA PCI-device group: 0x%x\n",
+				dev_grp);
+		return -ENODEV;
+		break;
+	}
+	return 0;
+}
+
+/**
  * __lpfc_sli_ringtx_put - Add an iocb to the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -4501,28 +5629,42 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 
 	/* Return any active mbox cmds */
 	del_timer_sync(&psli->mbox_tmo);
-	spin_lock_irqsave(&phba->hbalock, flags);
 
-	spin_lock(&phba->pport->work_port_lock);
+	spin_lock_irqsave(&phba->pport->work_port_lock, flags);
 	phba->pport->work_port_events &= ~WORKER_MBOX_TMO;
-	spin_unlock(&phba->pport->work_port_lock);
+	spin_unlock_irqrestore(&phba->pport->work_port_lock, flags);
 
-	/* Return any pending or completed mbox cmds */
-	list_splice_init(&phba->sli.mboxq, &completions);
-	if (psli->mbox_active) {
-		list_add_tail(&psli->mbox_active->list, &completions);
-		psli->mbox_active = NULL;
-		psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-	}
-	list_splice_init(&phba->sli.mboxq_cmpl, &completions);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	return 1;
+}
+
+/**
+ * lpfc_sli4_hba_down - PCI function resource cleanup for the SLI4 HBA
+ * @phba: Pointer to HBA context object.
+ *
+ * This function cleans up all queues, iocb, buffers, mailbox commands while
+ * shutting down the SLI4 HBA FCoE function. This function is called with no
+ * lock held and always returns 1.
+ *
+ * This function does the following to cleanup driver FCoE function resources:
+ * - Free discovery resources for each virtual port
+ * - Cleanup any pending fabric iocbs
+ * - Iterate through the iocb txq and free each entry in the list.
+ * - Free up any buffer posted to the HBA.
+ * - Clean up all the queue entries: WQ, RQ, MQ, EQ, CQ, etc.
+ * - Free mailbox commands in the mailbox queue.
+ **/
+int
+lpfc_sli4_hba_down(struct lpfc_hba *phba)
+{
+	/* Stop the SLI4 device port */
+	lpfc_stop_port(phba);
+
+	/* Tear down the queues in the HBA */
+	lpfc_sli4_queue_unset(phba);
+
+	/* unregister default FCFI from the HBA */
+	lpfc_sli4_fcfi_unreg(phba, phba->fcf.fcfi);
 
-	while (!list_empty(&completions)) {
-		list_remove_head(&completions, pmb, LPFC_MBOXQ_t, list);
-		pmb->mb.mbxStatus = MBX_NOT_FINISHED;
-		if (pmb->mbox_cmpl)
-			pmb->mbox_cmpl(phba,pmb);
-	}
 	return 1;
 }
 
@@ -4853,7 +5995,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 	iabt = &abtsiocbp->iocb;
 	iabt->un.acxri.abortType = ABORT_TYPE_ABTS;
 	iabt->un.acxri.abortContextTag = icmd->ulpContext;
-	iabt->un.acxri.abortIoTag = icmd->ulpIoTag;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		iabt->un.acxri.abortIoTag = cmdiocb->sli4_xritag;
+	else
+		iabt->un.acxri.abortIoTag = icmd->ulpIoTag;
 	iabt->ulpLe = 1;
 	iabt->ulpClass = icmd->ulpClass;
 
@@ -4869,7 +6014,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 			 "abort cmd iotag x%x\n",
 			 iabt->un.acxri.abortContextTag,
 			 iabt->un.acxri.abortIoTag, abtsiocbp->iotag);
-	retval = __lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0);
+	retval = __lpfc_sli_issue_iocb(phba, pring->ringno, abtsiocbp, 0);
 
 	if (retval)
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
@@ -5052,7 +6197,10 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 		cmd = &iocbq->iocb;
 		abtsiocb->iocb.un.acxri.abortType = ABORT_TYPE_ABTS;
 		abtsiocb->iocb.un.acxri.abortContextTag = cmd->ulpContext;
-		abtsiocb->iocb.un.acxri.abortIoTag = cmd->ulpIoTag;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			abtsiocb->iocb.un.acxri.abortIoTag = iocbq->sli4_xritag;
+		else
+			abtsiocb->iocb.un.acxri.abortIoTag = cmd->ulpIoTag;
 		abtsiocb->iocb.ulpLe = 1;
 		abtsiocb->iocb.ulpClass = cmd->ulpClass;
 		abtsiocb->vport = phba->pport;
@@ -5064,7 +6212,8 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 
 		/* Setup callback routine and issue the command. */
 		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
-		ret_val = lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0);
+		ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
+					      abtsiocb, 0);
 		if (ret_val == IOCB_ERROR) {
 			lpfc_sli_release_iocbq(phba, abtsiocb);
 			errcnt++;
@@ -5145,7 +6294,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba 
  **/
 int
 lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
-			 struct lpfc_sli_ring *pring,
+			 uint32_t ring_number,
 			 struct lpfc_iocbq *piocb,
 			 struct lpfc_iocbq *prspiocbq,
 			 uint32_t timeout)
@@ -5176,7 +6325,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	retval = lpfc_sli_issue_iocb(phba, pring, piocb, 0);
+	retval = lpfc_sli_issue_iocb(phba, ring_number, piocb, 0);
 	if (retval == IOCB_SUCCESS) {
 		timeout_req = timeout * HZ;
 		timeleft = wait_event_timeout(done_q,
@@ -5385,6 +6534,58 @@ lpfc_sli_eratt_read(struct lpfc_hba *phb
 }
 
 /**
+ * lpfc_sli4_eratt_read - read sli-4 error attention events
+ * @phba: Pointer to HBA context.
+ *
+ * This function is called to read the SLI4 device error attention registers
+ * for possible error attention events. The caller must hold the hostlock
+ * with spin_lock_irq().
+ *
+ * This fucntion returns 1 when there is Error Attention in the Host Attention
+ * Register and returns 0 otherwise.
+ **/
+static int
+lpfc_sli4_eratt_read(struct lpfc_hba *phba)
+{
+	uint32_t uerr_sta_hi, uerr_sta_lo;
+	uint32_t onlnreg0, onlnreg1;
+
+	/* For now, use the SLI4 device internal unrecoverable error
+	 * registers for error attention. This can be changed later.
+	 */
+	onlnreg0 = readl(phba->sli4_hba.ONLINE0regaddr);
+	onlnreg1 = readl(phba->sli4_hba.ONLINE1regaddr);
+	if ((onlnreg0 != LPFC_ONLINE_NERR) || (onlnreg1 != LPFC_ONLINE_NERR)) {
+		uerr_sta_lo = readl(phba->sli4_hba.UERRLOregaddr);
+		uerr_sta_hi = readl(phba->sli4_hba.UERRHIregaddr);
+		if (uerr_sta_lo || uerr_sta_hi) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1423 HBA Unrecoverable error: "
+					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
+					"online0_reg=0x%x, online1_reg=0x%x\n",
+					uerr_sta_lo, uerr_sta_hi,
+					onlnreg0, onlnreg1);
+			/* TEMP: as the driver error recover logic is not
+			 * fully developed, we just log the error message
+			 * and the device error attention action is now
+			 * temporarily disabled.
+			 */
+			return 0;
+			phba->work_status[0] = uerr_sta_lo;
+			phba->work_status[1] = uerr_sta_hi;
+			spin_lock_irq(&phba->hbalock);
+			/* Set the driver HA work bitmap */
+			phba->work_ha |= HA_ERATT;
+			/* Indicate polling handles this ERATT */
+			phba->hba_flag |= HBA_ERATT_HANDLED;
+			spin_unlock_irq(&phba->hbalock);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/**
  * lpfc_sli_check_eratt - check error attention events
  * @phba: Pointer to HBA context.
  *
@@ -5434,6 +6635,10 @@ lpfc_sli_check_eratt(struct lpfc_hba *ph
 		/* Read chip Host Attention (HA) register */
 		ha_copy = lpfc_sli_eratt_read(phba);
 		break;
+	case LPFC_SLI_REV4:
+		/* Read devcie Uncoverable Error (UERR) registers */
+		ha_copy = lpfc_sli4_eratt_read(phba);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0299 Invalid SLI revision (%d)\n",
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2008-10-18 10:32:52.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2009-05-22 13:16:40.000000000 -0400
@@ -29,13 +29,23 @@ typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
+/* This structure is used to carry the needed response IOCB states */
+struct lpfc_sli4_rspiocb_info {
+	uint8_t hw_status;
+	uint8_t bfield;
+#define LPFC_XB	0x1
+#define LPFC_PV	0x2
+	uint8_t priority;
+	uint8_t reserved;
+};
+
 /* This structure is used to handle IOCB requests / responses */
 struct lpfc_iocbq {
 	/* lpfc_iocbqs are used in double linked lists */
 	struct list_head list;
 	struct list_head clist;
 	uint16_t iotag;         /* pre-assigned IO tag */
-	uint16_t rsvd1;
+	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 
 	IOCB_t iocb;		/* IOCB cmd */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
@@ -65,7 +75,7 @@ struct lpfc_iocbq {
 			   struct lpfc_iocbq *);
 	void (*iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-
+	struct lpfc_sli4_rspiocb_info sli4_info;
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */
@@ -81,14 +91,18 @@ struct lpfc_iocbq {
 typedef struct lpfcMboxq {
 	/* MBOXQs are used in single linked lists */
 	struct list_head list;	/* ptr to next mailbox command */
-	MAILBOX_t mb;		/* Mailbox cmd */
-	struct lpfc_vport *vport;/* virutal port pointer */
+	union {
+		MAILBOX_t mb;		/* Mailbox cmd */
+		struct lpfc_mqe mqe;
+	} u;
+	struct lpfc_vport *vport;/* virtual port pointer */
 	void *context1;		/* caller context information */
 	void *context2;		/* caller context information */
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
 	uint8_t mbox_flag;
-
+	struct lpfc_mcqe mcqe;
+	struct lpfc_mbx_nembed_sge_virt *sge_array;
 } LPFC_MBOXQ_t;
 
 #define MBX_POLL        1	/* poll mailbox till command done, then
@@ -234,6 +248,7 @@ struct lpfc_sli {
 #define LPFC_PROCESS_LA           0x400	/* Able to process link attention */
 #define LPFC_BLOCK_MGMT_IO        0x800	/* Don't allow mgmt mbx or iocb cmds */
 #define LPFC_MENLO_MAINT          0x1000 /* need for menl fw download */
+#define LPFC_SLI_ASYNC_MBX_BLK    0x2000 /* Async mailbox is blocked */
 
 	struct lpfc_sli_ring ring[LPFC_MAX_RING];
 	int fcp_ring;		/* ring used for FCP initiator commands */
@@ -261,6 +276,8 @@ struct lpfc_sli {
 
 #define LPFC_MBOX_TMO           30	/* Sec tmo for outstanding mbox
 					   command */
+#define LPFC_MBOX_SLI4_CONFIG_TMO 60	/* Sec tmo for outstanding mbox
+					   command */
 #define LPFC_MBOX_TMO_FLASH_CMD 300     /* Sec tmo for outstanding FLASH write
 					 * or erase cmds. This is especially
 					 * long because of the potential of
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2009-05-19 09:39:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2009-05-22 13:16:40.000000000 -0400
@@ -32,8 +32,10 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -89,6 +91,8 @@ lpfc_alloc_vpi(struct lpfc_hba *phba)
 		vpi = 0;
 	else
 		set_bit(vpi, phba->vpi_bmask);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		phba->sli4_hba.max_cfg_param.vpi_used++;
 	spin_unlock_irq(&phba->hbalock);
 	return vpi;
 }
@@ -96,8 +100,12 @@ lpfc_alloc_vpi(struct lpfc_hba *phba)
 static void
 lpfc_free_vpi(struct lpfc_hba *phba, int vpi)
 {
+	if (vpi == 0)
+		return;
 	spin_lock_irq(&phba->hbalock);
 	clear_bit(vpi, phba->vpi_bmask);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		phba->sli4_hba.max_cfg_param.vpi_used--;
 	spin_unlock_irq(&phba->hbalock);
 }
 
@@ -308,6 +316,21 @@ lpfc_vport_create(struct fc_vport *fc_vp
 		goto error_out;
 	}
 
+	/*
+	 * In SLI4, the vpi must be activated before it can be used
+	 * by the port.
+	 */
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		rc = lpfc_sli4_init_vpi(phba, vpi);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
+					"1838 Failed to INIT_VPI on vpi %d "
+					"status %d\n", vpi, rc);
+			rc = VPORT_NORESOURCES;
+			lpfc_free_vpi(phba, vpi);
+			goto error_out;
+		}
+	}
 
 	/* Assign an unused board number */
 	if ((instance = lpfc_get_instance()) < 0) {


