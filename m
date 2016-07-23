From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 1/3] nvme_fabrics: Rework lpfc base driver to support the
 NVME protocol
Date: Fri, 22 Jul 2016 17:24:01 -0700
Message-ID: <5792b921.L3V+MaGwYqBxmw1C%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35238 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbcGWAYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 20:24:06 -0400
Received: by mail-pf0-f180.google.com with SMTP id x72so45807613pfd.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 17:24:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


This patch revises the core of the lfpc driver so that it has the notion of
SCSI and NVME support. It currently is an unoptimized NVME implementation.

The patch:
-Adds attributes to manage SCSI-only, NVME-only, or both protocols
 supported simultaneously
-Reworks initialization to create initial nvme wq, cq, etc sufficient
 for at least initiatur support. Will eventually have same per-cpu queuing
 support as on the scsi side. For now, it's suboptimal while keeping it
 simple for functional testing.
-Augments debugfs support, logging, etc for NVME
-adds any necessary NVME protocol definitions for FC discovery
-The discovery code is updated to
 - register support for NVME
 - Discovery NVME-subsystem supporting targets
 - Perform PLOGI and nvme PRLI with the endpoints
 - Linkage of endpoint discovery with the NVMEoF transport stubbed out. Will
   be populated in subsequent patches
 - Adds infrastructure to post FC-4 LS's as well as FCP cmds in prep for
   NVME transport use.


Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/Makefile         |   6 +-
 drivers/scsi/lpfc/lpfc.h           |  39 ++-
 drivers/scsi/lpfc/lpfc_attr.c      |  69 +++-
 drivers/scsi/lpfc/lpfc_crtn.h      |  21 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 373 ++++++++++++++--------
 drivers/scsi/lpfc/lpfc_debugfs.c   | 374 ++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_debugfs.h   | 119 +++++--
 drivers/scsi/lpfc/lpfc_disc.h      |  17 +-
 drivers/scsi/lpfc/lpfc_els.c       | 202 +++++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 319 +++++++++++++++++--
 drivers/scsi/lpfc/lpfc_hw.h        |  49 ++-
 drivers/scsi/lpfc/lpfc_hw4.h       | 128 +++++++-
 drivers/scsi/lpfc/lpfc_init.c      | 586 ++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_logmsg.h    |   1 +
 drivers/scsi/lpfc/lpfc_mbox.c      |   9 +-
 drivers/scsi/lpfc/lpfc_mem.c       |  12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 148 ++++++++-
 drivers/scsi/lpfc/lpfc_nvme.h      |  62 ++++
 drivers/scsi/lpfc/lpfc_scsi.c      |  12 +-
 drivers/scsi/lpfc/lpfc_scsi.h      |  19 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 632 ++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h       |  30 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |  25 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   1 +
 24 files changed, 2564 insertions(+), 689 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index e2516ba..9606a13 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -28,6 +28,6 @@ endif
 
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
-lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	\
-	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o lpfc_scsi.o lpfc_attr.o \
-	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
+lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o \
+	lpfc_hbadisc.o	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o   \
+	lpfc_scsi.o lpfc_attr.o lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index b484859..22dcb39 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -114,6 +114,17 @@ enum lpfc_polling_flags {
 	DISABLE_FCP_RING_INT    = 0x2
 };
 
+/*
+ * Provide for FC4 TYPE x28 - NVME.  The
+ * bit mask for FCP and NVME is 0x8 identically
+ * because they are 32 bit positions distance.
+ */
+#define LPFC_FC4_TYPE_NVME	0x28
+#define LPFC_FC4_TYPE_FCP	0x8
+#define LPFC_FC4_TYPE_BLS	0x0
+#define LPFC_FC4_TYPE_BITMASK	0x00000100
+#define LPFC_RCTL_ABTS		0x81
+
 /* Provide DMA memory definitions the driver uses per port instance. */
 struct lpfc_dmabuf {
 	struct list_head list;
@@ -131,10 +142,14 @@ struct lpfc_dma_pool {
 struct hbq_dmabuf {
 	struct lpfc_dmabuf hbuf;
 	struct lpfc_dmabuf dbuf;
-	uint32_t size;
+	uint16_t total_size;
+	uint16_t bytes_recv;
 	uint32_t tag;
 	struct lpfc_cq_event cq_event;
 	unsigned long time_stamp;
+	void *context;
+	struct lpfc_iocbq *iocbq;
+	struct lpfc_sglq *sglq;
 };
 
 /* Priority bit.  Set value to exceed low water mark in lpfc_mem. */
@@ -367,7 +382,8 @@ struct lpfc_vport {
 	int32_t stopped;   /* HBA has not been restarted since last ERATT */
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
 
-	uint32_t num_disc_nodes;	/*in addition to hba_state */
+	uint32_t num_disc_nodes;	/* in addition to hba_state */
+	uint32_t gidft_inp;		/* cnt of outstanding GID_FTs */
 
 	uint32_t fc_nlp_cnt;	/* outstanding NODELIST requests */
 	uint32_t fc_rscn_id_cnt;	/* count of RSCNs payloads in list */
@@ -442,6 +458,10 @@ struct lpfc_vport {
 	uint16_t fdmi_num_disc;
 	uint32_t fdmi_hba_mask;
 	uint32_t fdmi_port_mask;
+
+	/* There is a single nvme instance per vport. */
+	struct lpfc_nvme *pnvme;
+	uint32_t last_fcp_wqidx;
 };
 
 struct hbq_s {
@@ -459,10 +479,9 @@ struct hbq_s {
 					       struct hbq_dmabuf *);
 };
 
-#define LPFC_MAX_HBQS  4
 /* this matches the position in the lpfc_hbq_defs array */
 #define LPFC_ELS_HBQ	0
-#define LPFC_EXTRA_HBQ	1
+#define LPFC_MAX_HBQS	1
 
 enum hba_temp_state {
 	HBA_NORMAL_TEMP,
@@ -696,6 +715,7 @@ struct lpfc_hba {
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
 	uint8_t  fcp_embed_io;
+	uint8_t  nvme_support;	/* Firmware supports NVME */
 	uint8_t  mds_diags_support;
 
 	/* HBA Config Parameters */
@@ -721,6 +741,11 @@ struct lpfc_hba {
 	uint32_t cfg_fcp_imax;
 	uint32_t cfg_fcp_cpu_map;
 	uint32_t cfg_fcp_io_channel;
+	uint32_t cfg_nvme_io_channel;
+	uint32_t cfg_enable_nvmet;
+#define NVME_TARGET_OFF		0xffff
+#define NVME_TARGET_MIN		0
+#define NVME_TARGET_MAX		255
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_prot_sg_seg_cnt;
@@ -765,6 +790,11 @@ struct lpfc_hba {
 #define LPFC_FDMI_SUPPORT	1	/* FDMI supported? */
 	uint32_t cfg_enable_SmartSAN;
 	uint32_t cfg_enable_mds_diags;
+	uint32_t cfg_enable_fc4_type;
+#define LPFC_ENABLE_FCP  1
+#define LPFC_ENABLE_NVME 2
+#define LPFC_ENABLE_BOTH 3
+	uint32_t io_channel;	/* max of fcp or nvme io channels */
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
@@ -779,7 +809,6 @@ struct lpfc_hba {
 	unsigned long data_flags;
 
 	uint32_t hbq_in_use;		/* HBQs in use flag */
-	struct list_head rb_pend_list;  /* Received buffers to be processed */
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 6793df8..e0961ec 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3021,6 +3021,17 @@ static DEVICE_ATTR(lpfc_devloss_tmo, S_IRUGO | S_IWUSR,
 		   lpfc_devloss_tmo_show, lpfc_devloss_tmo_store);
 
 /*
+ * lpfc_enable_fc4_type: Defines what FC4 types are supported.
+ * Supported Values:  1 - register just FCP
+ *                    2 - register just NVME
+ *                    3 - register both FCP and NVME
+ * is [1,3]. Default value is 1
+ */
+LPFC_ATTR_RW(enable_fc4_type, LPFC_ENABLE_FCP,
+	     LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
+	     "Define fc4 type to register with fabric.");
+
+/*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
 # deluged with LOTS of information.
 # You can set a bit mask to record specific types of verbose messages:
@@ -4196,13 +4207,14 @@ lpfc_fcp_imax_store(struct device *dev, struct device_attribute *attr,
 	/*
 	 * Value range for the HBA is [5000,5000000]
 	 * The value for each EQ depends on how many EQs are configured.
+	 * Allow value == 0
 	 */
-	if (val < LPFC_MIN_IMAX || val > LPFC_MAX_IMAX)
+	if (val && (val < LPFC_MIN_IMAX || val > LPFC_MAX_IMAX))
 		return -EINVAL;
 
 	phba->cfg_fcp_imax = (uint32_t)val;
-	for (i = 0; i < phba->cfg_fcp_io_channel; i += LPFC_MAX_EQ_DELAY)
-		lpfc_modify_fcp_eq_delay(phba, i);
+	for (i = 0; i < phba->io_channel; i += LPFC_MAX_EQ_DELAY)
+		lpfc_modify_hba_eq_delay(phba, i);
 
 	return strlen(buf);
 }
@@ -4240,7 +4252,8 @@ lpfc_fcp_imax_init(struct lpfc_hba *phba, int val)
 		return 0;
 	}
 
-	if (val >= LPFC_MIN_IMAX && val <= LPFC_MAX_IMAX) {
+	if ((val >= LPFC_MIN_IMAX && val <= LPFC_MAX_IMAX) ||
+	    (val == 0)) {
 		phba->cfg_fcp_imax = val;
 		return 0;
 	}
@@ -4614,15 +4627,32 @@ LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
-# lpfc_fcp_io_channel: Set the number of FCP EQ/CQ/WQ IO channels
-#
-# Value range is [1,7]. Default value is 4.
-*/
-LPFC_ATTR_R(fcp_io_channel, LPFC_FCP_IO_CHAN_DEF, LPFC_FCP_IO_CHAN_MIN,
-	    LPFC_FCP_IO_CHAN_MAX,
+ * lpfc_fcp_io_channel: Set the number of FCP EQ/CQ/WQ IO channels
+ *
+ * Value range is [1,32]. Default value is 4.
+ */
+LPFC_ATTR_R(fcp_io_channel, LPFC_HBA_IO_CHAN_DEF,
+	    LPFC_HBA_IO_CHAN_MIN, LPFC_HBA_IO_CHAN_MAX,
 	    "Set the number of FCP I/O channels");
 
 /*
+ * lpfc_nvme_io_channel: Set the number of NVME EQ/CQ/WQ IO channels
+ *
+ * Value range is [1,32]. Default value is 4.
+ */
+LPFC_ATTR_R(nvme_io_channel, LPFC_HBA_IO_CHAN_DEF,
+	    LPFC_HBA_IO_CHAN_MIN, LPFC_HBA_IO_CHAN_MAX,
+	    "Set the number of NVME I/O channels");
+
+/*
+ * lpfc_enable_nvmet: Specify the lpfc instance number of NVME Target
+ *
+ */
+LPFC_ATTR_R(enable_nvmet, NVME_TARGET_OFF, NVME_TARGET_MIN,
+	    NVME_TARGET_OFF,
+	    "Specify lpfc instance number of NVME Target");
+
+/*
 # lpfc_enable_hba_reset: Allow or prevent HBA resets to the hardware.
 #       0  = HBA resets disabled
 #       1  = HBA resets enabled (default)
@@ -4777,6 +4807,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
+	&dev_attr_lpfc_enable_fc4_type,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
 	&dev_attr_lpfc_first_burst_size,
@@ -4814,6 +4845,8 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_fcp_imax,
 	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
+	&dev_attr_lpfc_nvme_io_channel,
+	&dev_attr_lpfc_enable_nvmet,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
@@ -4861,6 +4894,7 @@ struct device_attribute *lpfc_vport_attrs[] = {
 	&dev_attr_lpfc_tgt_queue_depth,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
+	&dev_attr_lpfc_enable_fc4_type,
 	&dev_attr_lpfc_hba_queue_depth,
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_restrict_login,
@@ -5810,6 +5844,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
 	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
+	lpfc_nvme_io_channel_init(phba, lpfc_nvme_io_channel);
+	lpfc_enable_nvmet_init(phba, lpfc_enable_nvmet);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
 	lpfc_EnableXLane_init(phba, lpfc_EnableXLane);
@@ -5828,6 +5864,19 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	else
 		phba->cfg_poll = lpfc_poll;
 
+	/*
+	 * If the FC4 type is exclusively FCP, set the
+	 * nvme_io_channels to 0 to shutdown the runtime
+	 * nvme code paths.
+	 */
+	lpfc_enable_fc4_type_init(phba, lpfc_enable_fc4_type);
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)
+		phba->cfg_nvme_io_channel = 0;
+
+	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+		phba->io_channel = phba->cfg_fcp_io_channel;
+	else
+		phba->io_channel = phba->cfg_nvme_io_channel;
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index bd7576d..bfac2c6 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -21,6 +21,7 @@
 typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
+struct fc_frame_header;
 void lpfc_down_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli_read_link_ste(struct lpfc_hba *);
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t, uint16_t);
@@ -167,6 +168,8 @@ void lpfc_hb_timeout_handler(struct lpfc_hba *);
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			 struct lpfc_iocbq *);
 int lpfc_ct_handle_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
+int lpfc_issue_gidft(struct lpfc_vport *);
+int lpfc_get_gidft_type(struct lpfc_vport *, struct lpfc_iocbq *);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int, uint32_t);
 void lpfc_fdmi_num_disc_check(struct lpfc_vport *);
@@ -287,6 +290,10 @@ void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
+int lpfc_sli_issue_wqe(struct lpfc_hba *, uint32_t,
+			struct lpfc_iocbq *);
+struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *, uint16_t);
+struct lpfc_sglq *__lpfc_sli_get_sglq(struct lpfc_hba *, struct lpfc_iocbq *);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
@@ -303,10 +310,10 @@ uint32_t lpfc_sli_get_buffer_tag(struct lpfc_hba *);
 struct lpfc_dmabuf * lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *,
 			struct lpfc_sli_ring *, uint32_t );
 
-int lpfc_sli_hbq_count(void);
+int lpfc_sli_hbq_count(struct lpfc_hba *);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
-int lpfc_sli_hbq_size(void);
+int lpfc_sli_hbq_size(struct lpfc_hba *);
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
 			       struct lpfc_iocbq *);
 int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
@@ -359,6 +366,7 @@ extern struct scsi_host_template lpfc_template_s3;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
+extern int lpfc_new_scsi_buf(struct lpfc_vport *, int);
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
@@ -497,3 +505,12 @@ bool lpfc_find_next_oas_lun(struct lpfc_hba *, struct lpfc_name *,
 			    struct lpfc_name *, uint64_t *, uint32_t *);
 int lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox);
 void lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
+struct lpfc_vport *lpfc_fc_frame_to_vport(struct lpfc_hba *,
+					  struct fc_frame_header *,
+					  uint16_t, uint32_t);
+
+/* SCSI Interfaces. */
+void lpfc_release_scsi_buf(struct lpfc_hba *, struct lpfc_scsi_buf *);
+struct lpfc_scsi_buf *lpfc_get_scsi_buf(struct lpfc_hba *,
+					struct lpfc_nodelist *);
+
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 63e48d4..3a43cdf 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -453,8 +453,88 @@ lpfc_find_vport_by_did(struct lpfc_hba *phba, uint32_t did) {
 	return NULL;
 }
 
+static void
+lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
+{
+	struct lpfc_nodelist *ndlp;
+
+	if ((vport->port_type != LPFC_NPIV_PORT) ||
+	    !(vport->ct_flags & FC_CT_RFF_ID) || !vport->cfg_restrict_login) {
+
+		ndlp = lpfc_setup_disc_node(vport, Did);
+
+		if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Parse GID_FTrsp: did:x%x flg:x%x x%x",
+				Did, ndlp->nlp_flag, vport->fc_flag);
+
+			/* By default, the driver expects to support FCP FC4 */
+			if (fc4_type == LPFC_FC4_TYPE_FCP)
+				ndlp->nlp_fc4_type |= NLP_FC4_FCP;
+
+			if (fc4_type == LPFC_FC4_TYPE_NVME)
+				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
+
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				"0238 Process x%06x NameServer Rsp "
+				"Data: x%x x%x x%x x%x\n",
+				Did, ndlp->nlp_flag, ndlp->nlp_fc4_type,
+				vport->fc_flag, vport->fc_rscn_id_cnt);
+		} else {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Skip1 GID_FTrsp: did:x%x flg:x%x cnt:%d",
+				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
+
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				"0239 Skip x%06x NameServer Rsp "
+				"Data: x%x x%x\n", Did, vport->fc_flag,
+				vport->fc_rscn_id_cnt);
+		}
+
+	} else {
+		if (!(vport->fc_flag & FC_RSCN_MODE) ||
+		    lpfc_rscn_payload_check(vport, Did)) {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Query GID_FTrsp: did:x%x flg:x%x cnt:%d",
+				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
+
+			/*
+			 * This NPortID was previously a FCP target,
+			 * Don't even bother to send GFF_ID.
+			 */
+			ndlp = lpfc_findnode_did(vport, Did);
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp))
+				ndlp->nlp_fc4_type = fc4_type;
+
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+				ndlp->nlp_fc4_type = fc4_type;
+
+				if (ndlp->nlp_type & NLP_FCP_TARGET)
+					lpfc_setup_disc_node(vport, Did);
+
+				else if (lpfc_ns_cmd(vport, SLI_CTNS_GFF_ID,
+							0, Did) == 0)
+					vport->num_disc_nodes++;
+
+				else
+					lpfc_setup_disc_node(vport, Did);
+			}
+		} else {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Skip2 GID_FTrsp: did:x%x flg:x%x cnt:%d",
+				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
+
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				"0245 Skip x%06x NameServer Rsp "
+				"Data: x%x x%x\n", Did, vport->fc_flag,
+				vport->fc_rscn_id_cnt);
+		}
+	}
+}
+
 static int
-lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint32_t Size)
+lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
+	    uint32_t Size)
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_sli_ct_request *Response =
@@ -499,97 +579,12 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint32_t Size)
 			 */
 			if ((Did != vport->fc_myDID) &&
 			    ((lpfc_find_vport_by_did(phba, Did) == NULL) ||
-			     vport->cfg_peer_port_login)) {
-				if ((vport->port_type != LPFC_NPIV_PORT) ||
-				    (!(vport->ct_flags & FC_CT_RFF_ID)) ||
-				    (!vport->cfg_restrict_login)) {
-					ndlp = lpfc_setup_disc_node(vport, Did);
-					if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
-						lpfc_debugfs_disc_trc(vport,
-						LPFC_DISC_TRC_CT,
-						"Parse GID_FTrsp: "
-						"did:x%x flg:x%x x%x",
-						Did, ndlp->nlp_flag,
-						vport->fc_flag);
-
-						lpfc_printf_vlog(vport,
-							KERN_INFO,
-							LOG_DISCOVERY,
-							"0238 Process "
-							"x%x NameServer Rsp"
-							"Data: x%x x%x x%x\n",
-							Did, ndlp->nlp_flag,
-							vport->fc_flag,
-							vport->fc_rscn_id_cnt);
-					} else {
-						lpfc_debugfs_disc_trc(vport,
-						LPFC_DISC_TRC_CT,
-						"Skip1 GID_FTrsp: "
-						"did:x%x flg:x%x cnt:%d",
-						Did, vport->fc_flag,
-						vport->fc_rscn_id_cnt);
-
-						lpfc_printf_vlog(vport,
-							KERN_INFO,
-							LOG_DISCOVERY,
-							"0239 Skip x%x "
-							"NameServer Rsp Data: "
-							"x%x x%x\n",
-							Did, vport->fc_flag,
-							vport->fc_rscn_id_cnt);
-					}
-
-				} else {
-					if (!(vport->fc_flag & FC_RSCN_MODE) ||
-					(lpfc_rscn_payload_check(vport, Did))) {
-						lpfc_debugfs_disc_trc(vport,
-						LPFC_DISC_TRC_CT,
-						"Query GID_FTrsp: "
-						"did:x%x flg:x%x cnt:%d",
-						Did, vport->fc_flag,
-						vport->fc_rscn_id_cnt);
-
-						/* This NPortID was previously
-						 * a FCP target, * Don't even
-						 * bother to send GFF_ID.
-						 */
-						ndlp = lpfc_findnode_did(vport,
-							Did);
-						if (ndlp &&
-						    NLP_CHK_NODE_ACT(ndlp)
-						    && (ndlp->nlp_type &
-						     NLP_FCP_TARGET))
-							lpfc_setup_disc_node
-								(vport, Did);
-						else if (lpfc_ns_cmd(vport,
-							SLI_CTNS_GFF_ID,
-							0, Did) == 0)
-							vport->num_disc_nodes++;
-						else
-							lpfc_setup_disc_node
-								(vport, Did);
-					}
-					else {
-						lpfc_debugfs_disc_trc(vport,
-						LPFC_DISC_TRC_CT,
-						"Skip2 GID_FTrsp: "
-						"did:x%x flg:x%x cnt:%d",
-						Did, vport->fc_flag,
-						vport->fc_rscn_id_cnt);
-
-						lpfc_printf_vlog(vport,
-							KERN_INFO,
-							LOG_DISCOVERY,
-							"0245 Skip x%x "
-							"NameServer Rsp Data: "
-							"x%x x%x\n",
-							Did, vport->fc_flag,
-							vport->fc_rscn_id_cnt);
-					}
-				}
-			}
+			     vport->cfg_peer_port_login))
+				lpfc_prep_node_fc4type(vport, Did, fc4_type);
+
 			if (CTentry & (cpu_to_be32(SLI_CT_LAST_ENTRY)))
 				goto nsout1;
+
 			Cnt -= sizeof(uint32_t);
 		}
 		ctptr = NULL;
@@ -609,16 +604,18 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfc_dmabuf *outp;
+	struct lpfc_dmabuf *inp;
 	struct lpfc_sli_ct_request *CTrsp;
+	struct lpfc_sli_ct_request *CTreq;
 	struct lpfc_nodelist *ndlp;
-	int rc;
+	int rc, type;
 
 	/* First save ndlp, before we overwrite it */
 	ndlp = cmdiocb->context_un.ndlp;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
-
+	inp = (struct lpfc_dmabuf *) cmdiocb->context1;
 	outp = (struct lpfc_dmabuf *) cmdiocb->context2;
 	irsp = &rspiocb->iocb;
 
@@ -656,9 +653,14 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			    IOERR_NO_RESOURCES)
 				vport->fc_ns_retry++;
 
+			type = lpfc_get_gidft_type(vport, cmdiocb);
+			if (type == 0)
+				goto out;
+
 			/* CT command is being retried */
+			vport->gidft_inp--;
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
-					 vport->fc_ns_retry, 0);
+					 vport->fc_ns_retry, type);
 			if (rc == 0)
 				goto out;
 		}
@@ -670,13 +672,18 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->ulpStatus, vport->fc_ns_retry);
 	} else {
 		/* Good status, continue checking */
+		CTreq = (struct lpfc_sli_ct_request *) inp->virt;
 		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    cpu_to_be16(SLI_CT_RESPONSE_FS_ACC)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-					 "0208 NameServer Rsp Data: x%x\n",
-					 vport->fc_flag);
-			lpfc_ns_rsp(vport, outp,
+					 "0208 NameServer Rsp Data: x%x x%x\n",
+					 vport->fc_flag,
+					 CTreq->un.gid.Fc4Type);
+
+			lpfc_ns_rsp(vport,
+				    outp,
+				    CTreq->un.gid.Fc4Type,
 				    (uint32_t) (irsp->un.genreq64.bdl.bdeSize));
 		} else if (CTrsp->CommandResponse.bits.CmdRsp ==
 			   be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
@@ -731,9 +738,11 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				(uint32_t) CTrsp->ReasonCode,
 				(uint32_t) CTrsp->Explanation);
 		}
+		vport->gidft_inp--;
 	}
 	/* Link up / RSCN discovery */
-	if (vport->num_disc_nodes == 0) {
+	if ((vport->num_disc_nodes == 0) &&
+	    (vport->gidft_inp == 0)) {
 		/*
 		 * The driver has cycled through all Nports in the RSCN payload.
 		 * Complete the handling by cleaning up and marking the
@@ -881,6 +890,61 @@ out:
 	return;
 }
 
+static void
+lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+				struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	IOCB_t *irsp = &rspiocb->iocb;
+	struct lpfc_dmabuf *inp = (struct lpfc_dmabuf *)cmdiocb->context1;
+	struct lpfc_dmabuf *outp = (struct lpfc_dmabuf *)cmdiocb->context2;
+	struct lpfc_sli_ct_request *CTrsp;
+	int did;
+	struct lpfc_nodelist *ndlp;
+	uint32_t fc4_data_0, fc4_data_1;
+
+	did = ((struct lpfc_sli_ct_request *)inp->virt)->un.gft.PortId;
+	did = be32_to_cpu(did);
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+			      "GFT_ID cmpl: status:x%x/x%x did:x%x",
+			      irsp->ulpStatus, irsp->un.ulpWord[4], did);
+
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		/* Good status, continue checking */
+		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
+		fc4_data_0 = be32_to_cpu(CTrsp->un.gft_acc.fc4_types[0]);
+		fc4_data_1 = be32_to_cpu(CTrsp->un.gft_acc.fc4_types[1]);
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+				 "3062 DID x%06x GFT Word 0 x%08x "
+				 "Word 1 x%08x\n", did, fc4_data_0,
+				 fc4_data_1);
+
+		ndlp = lpfc_findnode_did(vport, did);
+		if (ndlp) {
+			/* The bitmask value for FCP and NVME FCP types is
+			 * the same because they are 32 bits distant from
+			 * each other in word0 and word0.
+			 */
+			if (fc4_data_0 & LPFC_FC4_TYPE_BITMASK)
+				ndlp->nlp_fc4_type |= NLP_FC4_FCP;
+			if (fc4_data_1 &  LPFC_FC4_TYPE_BITMASK)
+				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+					 "3064 Setting ndlp %p, DID x%06x with "
+					 "FC4 x%08x, Data: x%08x x%08x\n",
+					 ndlp, did, ndlp->nlp_fc4_type,
+					 FC_TYPE_FCP, LPFC_FC4_TYPE_NVME);
+		}
+		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
+		lpfc_issue_els_prli(vport, ndlp, 0);
+	} else
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+				"3065 GFT_ID failed x%08x\n", irsp->ulpStatus);
+
+	lpfc_ct_free_iocb(phba, cmdiocb);
+}
 
 static void
 lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -1071,31 +1135,27 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	return;
 }
 
+/*
+ * Although the symbolic port name is thought to be an integer
+ * as of January 18, 2016, leave it as a string until more of
+ * the record state becomes defined.
+ */
 int
 lpfc_vport_symbolic_port_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
 	int n;
-	uint8_t *wwn = vport->phba->wwpn;
-
-	n = snprintf(symbol, size,
-		     "Emulex PPN-%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
-		     wwn[0], wwn[1], wwn[2], wwn[3],
-		     wwn[4], wwn[5], wwn[6], wwn[7]);
-
-	if (vport->port_type == LPFC_PHYSICAL_PORT)
-		return n;
-
-	if (n < size)
-		n += snprintf(symbol + n, size - n, " VPort-%d", vport->vpi);
 
-	if (n < size &&
-	    strlen(vport->fc_vport->symbolic_name))
-		n += snprintf(symbol + n, size - n, " VName-%s",
-			      vport->fc_vport->symbolic_name);
+	/*
+	 * Use the lpfc board number as the Symbolic Port
+	 * Name object.  NPIV is not in play so this integer
+	 * value is sufficient and unique per FC-ID.
+	 */
+	n = snprintf(symbol, size, "%d", vport->phba->brd_no);
 	return n;
 }
 
+
 int
 lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
@@ -1106,24 +1166,26 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
 
 	n = snprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
-
 	if (size < n)
 		return n;
-	n += snprintf(symbol + n, size - n, " FV%s", fwrev);
 
+	n += snprintf(symbol + n, size - n, " FV%s", fwrev);
 	if (size < n)
 		return n;
-	n += snprintf(symbol + n, size - n, " DV%s", lpfc_release_version);
 
+	n += snprintf(symbol + n, size - n, " DV%s.",
+		      lpfc_release_version);
 	if (size < n)
 		return n;
-	n += snprintf(symbol + n, size - n, " HN:%s", init_utsname()->nodename);
 
-	/* Note :- OS name is "Linux" */
+	n += snprintf(symbol + n, size - n, " HN:%s.",
+		      init_utsname()->nodename);
 	if (size < n)
 		return n;
-	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
 
+	/* Note :- OS name is "Linux" */
+	n += snprintf(symbol + n, size - n, " OS:%s\n",
+		      init_utsname()->sysname);
 	return n;
 }
 
@@ -1148,6 +1210,27 @@ lpfc_find_map_node(struct lpfc_vport *vport)
 }
 
 /*
+ * This routine will return the FC4 Type associated with the CT
+ * GID_FT command.
+ */
+int
+lpfc_get_gidft_type(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb)
+{
+	struct lpfc_sli_ct_request *CtReq;
+	struct lpfc_dmabuf *mp;
+	uint32_t type;
+
+	mp = cmdiocb->context1;
+	if (mp == NULL)
+		return 0;
+	CtReq = (struct lpfc_sli_ct_request *)mp->virt;
+	type = (uint32_t)CtReq->un.gid.Fc4Type;
+	if ((type != SLI_CTPT_FCP) && (type != SLI_CTPT_NVME))
+		return 0;
+	return type;
+}
+
+/*
  * lpfc_ns_cmd
  * Description:
  *    Issue Cmd to NameServer
@@ -1207,8 +1290,9 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 
 	/* NameServer Req */
 	lpfc_printf_vlog(vport, KERN_INFO ,LOG_DISCOVERY,
-			 "0236 NameServer Req Data: x%x x%x x%x\n",
-			 cmdcode, vport->fc_flag, vport->fc_rscn_id_cnt);
+			 "0236 NameServer Req Data: x%x x%x x%x x%x\n",
+			 cmdcode, vport->fc_flag, vport->fc_rscn_id_cnt,
+			 context);
 
 	bpl = (struct ulp_bde64 *) bmp->virt;
 	memset(bpl, 0, sizeof(struct ulp_bde64));
@@ -1219,6 +1303,8 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		bpl->tus.f.bdeSize = GID_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_GFF_ID)
 		bpl->tus.f.bdeSize = GFF_REQUEST_SZ;
+	else if (cmdcode == SLI_CTNS_GFT_ID)
+		bpl->tus.f.bdeSize = GFT_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RFT_ID)
 		bpl->tus.f.bdeSize = RFT_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RNN_ID)
@@ -1246,7 +1332,8 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	case SLI_CTNS_GID_FT:
 		CtReq->CommandResponse.bits.CmdRsp =
 		    cpu_to_be16(SLI_CTNS_GID_FT);
-		CtReq->un.gid.Fc4Type = SLI_CTPT_FCP;
+		CtReq->un.gid.Fc4Type = context;
+
 		if (vport->port_state < LPFC_NS_QRY)
 			vport->port_state = LPFC_NS_QRY;
 		lpfc_set_disctmo(vport);
@@ -1261,12 +1348,32 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		cmpl = lpfc_cmpl_ct_cmd_gff_id;
 		break;
 
+	case SLI_CTNS_GFT_ID:
+		CtReq->CommandResponse.bits.CmdRsp =
+			cpu_to_be16(SLI_CTNS_GFT_ID);
+		CtReq->un.gft.PortId = cpu_to_be32(context);
+		cmpl = lpfc_cmpl_ct_cmd_gft_id;
+		break;
+
 	case SLI_CTNS_RFT_ID:
 		vport->ct_flags &= ~FC_CT_RFT_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    cpu_to_be16(SLI_CTNS_RFT_ID);
 		CtReq->un.rft.PortId = cpu_to_be32(vport->fc_myDID);
-		CtReq->un.rft.fcpReg = 1;
+
+		/* Register FC4 FCP type if enabled.  */
+		if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP))
+			CtReq->un.rft.fcpReg = 1;
+
+		/* Register NVME type if enabled.  Defined LE and swapped.
+		 * rsvd[0] is used as word1 because of the hard-coded
+		 * word0 usage in the ct_request data structure.
+		 */
+		if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME))
+			CtReq->un.rft.rsvd[0] = cpu_to_be32(0x00000100);
+
 		cmpl = lpfc_cmpl_ct_cmd_rft_id;
 		break;
 
@@ -1316,7 +1423,24 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		    cpu_to_be16(SLI_CTNS_RFF_ID);
 		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
-		CtReq->un.rff.type_code = FC_TYPE_FCP;
+
+		/* The driver always supports FC_TYPE_FCP.  However, the
+		 * caller can specify NVME (type x28) as well.  But only
+		 * these that FC4 type is supported.
+		 */
+		if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) &&
+		    (context == LPFC_FC4_TYPE_NVME))
+			CtReq->un.rff.type_code = context;
+
+		else if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+			    (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)) &&
+			   (context == FC_TYPE_FCP))
+			CtReq->un.rff.type_code = context;
+
+		else
+			goto ns_cmd_free_bmpvirt;
+
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
 		break;
 	}
@@ -1337,6 +1461,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	 */
 	lpfc_nlp_put(ndlp);
 
+ns_cmd_free_bmpvirt:
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 ns_cmd_free_bmp:
 	kfree(bmp);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a63542b..cd226cb 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -35,6 +35,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -42,6 +44,7 @@
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
@@ -283,7 +286,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
 	spin_lock_irq(&phba->hbalock);
 
 	/* toggle between multiple hbqs, if any */
-	i = lpfc_sli_hbq_count();
+	i = lpfc_sli_hbq_count(phba);
 	if (i > 1) {
 		 lpfc_debugfs_last_hbq++;
 		 if (lpfc_debugfs_last_hbq >= i)
@@ -531,10 +534,15 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	int cnt;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
-	unsigned char *statep, *name;
+	unsigned char *statep;
+	struct lpfc_nvme_lport *lport;
+	struct lpfc_nvme_rport *rport;
+	struct nvme_fc_remote_port *nrport;
+	struct lpfc_nvme *pnvme;
 
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
 
+	len += snprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (!cnt) {
@@ -574,36 +582,32 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		default:
 			statep = "UNKNOWN";
 		}
-		len +=  snprintf(buf+len, size-len, "%s DID:x%06x ",
-			statep, ndlp->nlp_DID);
-		name = (unsigned char *)&ndlp->nlp_portname;
-		len +=  snprintf(buf+len, size-len,
-			"WWPN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x ",
-			*name, *(name+1), *(name+2), *(name+3),
-			*(name+4), *(name+5), *(name+6), *(name+7));
-		name = (unsigned char *)&ndlp->nlp_nodename;
-		len +=  snprintf(buf+len, size-len,
-			"WWNN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x ",
-			*name, *(name+1), *(name+2), *(name+3),
-			*(name+4), *(name+5), *(name+6), *(name+7));
+		len += snprintf(buf+len, size-len, "%s DID:x%06x ",
+				statep, ndlp->nlp_DID);
+		len += snprintf(buf+len, size-len,
+				"WWPN x%llx ",
+				wwn_to_u64(ndlp->nlp_portname.u.wwn));
+		len += snprintf(buf+len, size-len,
+				"WWNN x%llx ",
+				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len +=  snprintf(buf+len, size-len, "RPI:%03d ",
-				ndlp->nlp_rpi);
+			len += snprintf(buf+len, size-len, "RPI:%03d ",
+					ndlp->nlp_rpi);
 		else
-			len +=  snprintf(buf+len, size-len, "RPI:none ");
+			len += snprintf(buf+len, size-len, "RPI:none ");
 		len +=  snprintf(buf+len, size-len, "flag:x%08x ",
 			ndlp->nlp_flag);
 		if (!ndlp->nlp_type)
-			len +=  snprintf(buf+len, size-len, "UNKNOWN_TYPE ");
+			len += snprintf(buf+len, size-len, "UNKNOWN_TYPE ");
 		if (ndlp->nlp_type & NLP_FC_NODE)
-			len +=  snprintf(buf+len, size-len, "FC_NODE ");
+			len += snprintf(buf+len, size-len, "FC_NODE ");
 		if (ndlp->nlp_type & NLP_FABRIC)
-			len +=  snprintf(buf+len, size-len, "FABRIC ");
+			len += snprintf(buf+len, size-len, "FABRIC ");
 		if (ndlp->nlp_type & NLP_FCP_TARGET)
-			len +=  snprintf(buf+len, size-len, "FCP_TGT sid:%d ",
+			len += snprintf(buf+len, size-len, "FCP_TGT sid:%d ",
 				ndlp->nlp_sid);
 		if (ndlp->nlp_type & NLP_FCP_INITIATOR)
-			len +=  snprintf(buf+len, size-len, "FCP_INITIATOR ");
+			len += snprintf(buf+len, size-len, "FCP_INITIATOR ");
 		len += snprintf(buf+len, size-len, "usgmap:%x ",
 			ndlp->nlp_usg_map);
 		len += snprintf(buf+len, size-len, "refcnt:%x",
@@ -611,8 +615,100 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		len +=  snprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
+
+	/* Now step through the NVME ports. Reset cnt to prevent infinite
+	 * loops.
+	 */
+	if (vport->pnvme == NULL)
+		goto out_exit;
+
+	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
+	len += snprintf(buf+len, size-len, "\nNVME Lport/Rport Entries ...\n");
+	pnvme = vport->pnvme;
+
+	spin_lock_irq(shost->host_lock);
+	list_for_each_entry(lport, &pnvme->lport_list, list) {
+		if (!cnt) {
+			len +=  snprintf(buf+len, size-len,
+				"Missing Lport/Rport Entries\n");
+			break;
+		}
+		cnt--;
+		/* Port state is only one of two values for now. */
+		switch (lport->localport->port_state) {
+		case FC_OBJSTATE_ONLINE:
+			statep = "ONLINE";
+			break;
+		case FC_OBJSTATE_UNKNOWN:
+			statep = "UNKNOWN ";
+			break;
+		default:
+			statep = "UNSUPPORTED";
+			break;
+		}
+		len += snprintf(buf+len, size-len,
+				"Lport DID x%06x, FabricName x%llx, "
+				"PortState %s\n",
+				lport->localport->port_id,
+				lport->localport->fabric_name,
+				statep);
+
+		len += snprintf(buf+len, size-len, "\tRport List:\n");
+		list_for_each_entry(rport, &lport->rport_list, list) {
+			/* local short-hand pointer. */
+			nrport = rport->remoteport;
+
+			/* Port state is only one of two values for now. */
+			switch (nrport->port_state) {
+			case FC_OBJSTATE_ONLINE:
+				statep = "ONLINE";
+				break;
+			case FC_OBJSTATE_UNKNOWN:
+				statep = "UNKNOWN ";
+				break;
+			default:
+				statep = "UNSUPPORTED";
+				break;
+			}
+
+			/* Tab in to show lport ownership. */
+			len += snprintf(buf+len, size-len,
+					"\t%s Port ID:x%06x ",
+					statep, nrport->port_id);
+			len += snprintf(buf+len, size-len, "WWPN x%llx ",
+					nrport->port_name);
+			len += snprintf(buf+len, size-len, "WWNN x%llx ",
+					nrport->node_name);
+			switch (nrport->port_role) {
+			case FC_PORT_ROLE_NVME_INITIATOR:
+				len +=  snprintf(buf+len, size-len,
+						 "NVME INITIATOR ");
+				break;
+			case FC_PORT_ROLE_NVME_TARGET:
+				len +=  snprintf(buf+len, size-len,
+						 "NVME TARGET ");
+				break;
+			case FC_PORT_ROLE_NVME_DISCOVERY:
+				len +=  snprintf(buf+len, size-len,
+						 "NVME DISCOVERY ");
+				break;
+			default:
+				len +=  snprintf(buf+len, size-len,
+						 "UNKNOWN ROLE x%x",
+						 nrport->port_role);
+				break;
+			}
+
+			/* Terminate the string. */
+			len +=  snprintf(buf+len, size-len, "\n");
+		}
+	}
+
+	spin_unlock_irq(shost->host_lock);
+ out_exit:
 	return len;
 }
+
 #endif
 
 /**
@@ -1229,6 +1325,7 @@ lpfc_debugfs_dumpDataDif_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+
 /*
  * ---------------------------------
  * iDiag debugfs file access methods
@@ -1998,7 +2095,7 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 	int len = 0;
 	char *pbuffer;
 	int x, cnt;
-	int max_cnt;
+	int max_cnt, io_channel;
 	struct lpfc_queue *qp = NULL;
 
 
@@ -2012,11 +2109,12 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 	if (*ppos)
 		return 0;
 
+	io_channel = phba->io_channel;
 	spin_lock_irq(&phba->hbalock);
 
 	/* Fast-path event queue */
-	if (phba->sli4_hba.hba_eq && phba->cfg_fcp_io_channel) {
-		cnt = phba->cfg_fcp_io_channel;
+	if (phba->sli4_hba.hba_eq && io_channel) {
+		cnt = io_channel;
 
 		for (x = 0; x < cnt; x++) {
 
@@ -2053,43 +2151,80 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 			if (len >= max_cnt)
 				goto too_big;
 proc_cq:
-			/* Fast-path FCP CQ */
-			qp = phba->sli4_hba.fcp_cq[x];
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tFCP CQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocEQID[%02d]: "
-				"CQ STAT[max:x%x relw:x%x "
-				"xabt:x%x wq:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tCQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id, qp->entry_count,
-				qp->entry_size, qp->host_index,
-				qp->hba_index);
+			if (x < phba->cfg_fcp_io_channel) {
+				/* Fast-path FCP CQ */
+				qp = phba->sli4_hba.fcp_cq[x];
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tFCP CQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocEQID[%02d]: "
+					"CQ STAT[max:x%x relw:x%x "
+					"xabt:x%x wq:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tCQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
 
 
-			/* Reset max counter */
-			qp->CQ_max_cqe = 0;
+				/* Reset max counter */
+				qp->CQ_max_cqe = 0;
 
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
+
+			if (x < phba->cfg_nvme_io_channel) {
+				/* Fast-path FCP CQ */
+				qp = phba->sli4_hba.nvme_cq[x];
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tNVME CQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocEQID[%02d]: "
+					"CQ STAT[max:x%x relw:x%x "
+					"xabt:x%x wq:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tCQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
 
-			/* Fast-path FCP WQ */
-			qp = phba->sli4_hba.fcp_wq[x];
+
+				/* Reset max counter */
+				qp->CQ_max_cqe = 0;
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
+
+			/* Fast-path HBA WQ */
+			qp = phba->sli4_hba.hba_wq[x];
 
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tFCP WQ info: ");
+				"\t\tHBA WQ info: ");
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
 				"AssocCQID[%02d]: "
@@ -2172,6 +2307,66 @@ proc_cq:
 					goto too_big;
 			}
 
+			/* NVME LS response CQ */
+			qp = phba->sli4_hba.nvmels_cq;
+			if (qp) {
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tNVME LS CQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocEQID[%02d]: "
+					"CQ-STAT[max:x%x relw:x%x "
+					"xabt:x%x wq:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tCQID [%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				/* Reset max counter */
+				qp->CQ_max_cqe = 0;
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
+
+			/* NVME LS WQ */
+			qp = phba->sli4_hba.nvmels_wq;
+			if (qp) {
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tNVME LS WQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocCQID[%02d]: "
+					"WQ-STAT[oflow:x%x posted:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1,
+					(unsigned long long)qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tWQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
 			/* Slow-path ELS response CQ */
 			qp = phba->sli4_hba.els_cq;
 			if (qp) {
@@ -2267,7 +2462,7 @@ proc_cq:
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
 					"\t\tDQID[%02d], "
 					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
 					qp->queue_id,
 					qp->entry_count,
 					qp->entry_size,
@@ -2595,7 +2790,7 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 	case LPFC_IDIAG_EQ:
 		/* HBA event queue */
 		if (phba->sli4_hba.hba_eq) {
-			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
+			for (qidx = 0; qidx < phba->io_channel;
 				qidx++) {
 				if (phba->sli4_hba.hba_eq[qidx] &&
 				    phba->sli4_hba.hba_eq[qidx]->queue_id ==
@@ -2637,6 +2832,17 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.els_cq;
 			goto pass_check;
 		}
+		/* NVME LS complete queue */
+		if (phba->sli4_hba.nvmels_cq &&
+		    phba->sli4_hba.nvmels_cq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.nvmels_cq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
+			goto pass_check;
+		}
 		/* FCP complete queue */
 		if (phba->sli4_hba.fcp_cq) {
 			qidx = 0;
@@ -2656,6 +2862,25 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 				}
 			} while (++qidx < phba->cfg_fcp_io_channel);
 		}
+		/* NVME complete queue */
+		if (phba->sli4_hba.nvme_cq) {
+			qidx = 0;
+			do {
+				if (phba->sli4_hba.nvme_cq[qidx] &&
+				    phba->sli4_hba.nvme_cq[qidx]->queue_id ==
+				    queid) {
+					/* Sanity check */
+					rc = lpfc_idiag_que_param_check(
+						phba->sli4_hba.nvme_cq[qidx],
+						index, count);
+					if (rc)
+						goto error_out;
+					idiag.ptr_private =
+						phba->sli4_hba.nvme_cq[qidx];
+					goto pass_check;
+				}
+			} while (++qidx < phba->cfg_nvme_io_channel);
+		}
 		goto error_out;
 		break;
 	case LPFC_IDIAG_MQ:
@@ -2684,22 +2909,33 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.els_wq;
 			goto pass_check;
 		}
+		/* NVME LS work queue */
+		if (phba->sli4_hba.nvmels_wq &&
+		    phba->sli4_hba.nvmels_wq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.nvmels_wq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
+			goto pass_check;
+		}
 		/* FCP work queue */
-		if (phba->sli4_hba.fcp_wq) {
-			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
+		if (phba->sli4_hba.hba_wq) {
+			for (qidx = 0; qidx < phba->io_channel;
 				qidx++) {
-				if (!phba->sli4_hba.fcp_wq[qidx])
+				if (!phba->sli4_hba.hba_wq[qidx])
 					continue;
-				if (phba->sli4_hba.fcp_wq[qidx]->queue_id ==
+				if (phba->sli4_hba.hba_wq[qidx]->queue_id ==
 				    queid) {
 					/* Sanity check */
 					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.fcp_wq[qidx],
+						phba->sli4_hba.hba_wq[qidx],
 						index, count);
 					if (rc)
 						goto error_out;
 					idiag.ptr_private =
-						phba->sli4_hba.fcp_wq[qidx];
+						phba->sli4_hba.hba_wq[qidx];
 					goto pass_check;
 				}
 			}
@@ -4273,6 +4509,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc));
 		}
+
 	}
 
 	snprintf(name, sizeof(name), "vport%d", vport->vpi);
@@ -4675,9 +4912,10 @@ lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 	 */
 	lpfc_debug_dump_mbx_wq(phba);
 	lpfc_debug_dump_els_wq(phba);
+	lpfc_debug_dump_nvmels_wq(phba);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_wq(phba, fcp_wqidx);
+	for (fcp_wqidx = 0; fcp_wqidx < phba->io_channel; fcp_wqidx++)
+		lpfc_debug_dump_hba_wq(phba, fcp_wqidx);
 
 	lpfc_debug_dump_hdr_rq(phba);
 	lpfc_debug_dump_dat_rq(phba);
@@ -4686,13 +4924,17 @@ lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 	 */
 	lpfc_debug_dump_mbx_cq(phba);
 	lpfc_debug_dump_els_cq(phba);
+	lpfc_debug_dump_nvmels_cq(phba);
 
 	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
 		lpfc_debug_dump_fcp_cq(phba, fcp_wqidx);
 
+	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_nvme_io_channel; fcp_wqidx++)
+		lpfc_debug_dump_nvme_cq(phba, fcp_wqidx);
+
 	/*
 	 * Dump Event Queues (EQs)
 	 */
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
+	for (fcp_wqidx = 0; fcp_wqidx < phba->io_channel; fcp_wqidx++)
 		lpfc_debug_dump_hba_eq(phba, fcp_wqidx);
 }
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 8b2b6a3..312e560 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -42,6 +42,9 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
+/* nvmestat output buffer size */
+#define LPFC_NVMESTAT_SIZE 8192
+
 /*
  * For SLI4 iDiag debugfs diagnostics tool
  */
@@ -358,23 +361,59 @@ lpfc_debug_dump_q(struct lpfc_queue *q)
 }
 
 /**
- * lpfc_debug_dump_fcp_wq - dump all entries from a fcp work queue
+ * lpfc_debug_dump_hba_wq - dump all entries from a fcp work queue
  * @phba: Pointer to HBA context object.
- * @fcp_wqidx: Index to a FCP work queue.
+ * @hba_wqidx: Index to a FCP work queue.
  *
  * This function dumps all entries from a FCP work queue specified by the
- * @fcp_wqidx.
+ * @hba_wqidx.
  **/
 static inline void
-lpfc_debug_dump_fcp_wq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_hba_wq(struct lpfc_hba *phba, int hba_wqidx)
 {
 	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	if (hba_wqidx >= phba->io_channel)
 		return;
 
 	printk(KERN_ERR "FCP WQ: WQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[fcp_wqidx]);
+		hba_wqidx, phba->sli4_hba.hba_wq[hba_wqidx]->queue_id);
+	lpfc_debug_dump_q(phba->sli4_hba.hba_wq[hba_wqidx]);
+}
+
+/**
+ * lpfc_debug_dump_nvme_cq - dump all entries from nvme work queue's cmpl queue
+ * @phba: Pointer to HBA context object.
+ * @nvme_wqidx: Index to a FCP work queue.
+ *
+ * This function dumps all entries from a FCP complete queue which is
+ * associated to the FCP work queue specified by the @nvme_wqidx.
+ **/
+static inline void
+lpfc_debug_dump_nvme_cq(struct lpfc_hba *phba, int nvme_wqidx)
+{
+	int nvme_cqidx, nvme_cqid;
+
+	/* sanity check */
+	if (nvme_wqidx >= phba->cfg_nvme_io_channel)
+		return;
+
+	nvme_cqid = phba->sli4_hba.hba_wq[nvme_wqidx]->assoc_qid;
+	for (nvme_cqidx = 0; nvme_cqidx < phba->cfg_nvme_io_channel;
+	     nvme_cqidx++)
+		if (phba->sli4_hba.nvme_cq[nvme_cqidx]->queue_id == nvme_cqid)
+			break;
+	if (phba->intr_type == MSIX) {
+		if (nvme_cqidx >= phba->cfg_nvme_io_channel)
+			return;
+	} else {
+		if (nvme_cqidx > 0)
+			return;
+	}
+
+	pr_err("NVME CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]:\n",
+		nvme_wqidx, phba->sli4_hba.hba_wq[nvme_wqidx]->queue_id,
+		nvme_cqidx, nvme_cqid);
+	lpfc_debug_dump_q(phba->sli4_hba.nvme_cq[nvme_cqidx]);
 }
 
 /**
@@ -394,7 +433,7 @@ lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
 	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
 		return;
 
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
+	fcp_cqid = phba->sli4_hba.hba_wq[fcp_wqidx]->assoc_qid;
 	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
 		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
 			break;
@@ -407,7 +446,7 @@ lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
 	}
 
 	printk(KERN_ERR "FCP CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]:\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
+		fcp_wqidx, phba->sli4_hba.hba_wq[fcp_wqidx]->queue_id,
 		fcp_cqidx, fcp_cqid);
 	lpfc_debug_dump_q(phba->sli4_hba.fcp_cq[fcp_cqidx]);
 }
@@ -428,14 +467,14 @@ lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int fcp_wqidx)
 	int fcp_cqidx, fcp_cqid;
 
 	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	if (fcp_wqidx >= phba->io_channel)
 		return;
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
+	fcp_cqid = phba->sli4_hba.hba_wq[fcp_wqidx]->assoc_qid;
+	for (fcp_cqidx = 0; fcp_cqidx < phba->io_channel; fcp_cqidx++)
 		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
 			break;
 	if (phba->intr_type == MSIX) {
-		if (fcp_cqidx >= phba->cfg_fcp_io_channel)
+		if (fcp_cqidx >= phba->io_channel)
 			return;
 	} else {
 		if (fcp_cqidx > 0)
@@ -448,7 +487,7 @@ lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int fcp_wqidx)
 
 	printk(KERN_ERR "FCP EQ: WQ[Idx:%d|Qid:%d]->CQ[Idx:%d|Qid:%d]->"
 		"EQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
+		fcp_wqidx, phba->sli4_hba.hba_wq[fcp_wqidx]->queue_id,
 		fcp_cqidx, fcp_cqid, fcp_eqidx, fcp_eqid);
 	lpfc_debug_dump_q(qdesc);
 }
@@ -468,6 +507,20 @@ lpfc_debug_dump_els_wq(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_debug_dump_nvmels_wq - dump all entries from the nvme ls work queue
+ * @phba: Pointer to HBA context object.
+ *
+ * This function dumps all entries from the NVME LS work queue.
+ **/
+static inline void
+lpfc_debug_dump_nvmels_wq(struct lpfc_hba *phba)
+{
+	pr_err("NVME LS WQ: WQ[Qid:%d]:\n",
+		phba->sli4_hba.nvmels_wq->queue_id);
+	lpfc_debug_dump_q(phba->sli4_hba.nvmels_wq);
+}
+
+/**
  * lpfc_debug_dump_mbx_wq - dump all entries from the mbox work queue
  * @phba: Pointer to HBA context object.
  *
@@ -525,6 +578,21 @@ lpfc_debug_dump_els_cq(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_debug_dump_nvmels_cq - dump all entries from the nvme ls complete queue
+ * @phba: Pointer to HBA context object.
+ *
+ * This function dumps all entries from the nvme ls complete queue.
+ **/
+static inline void
+lpfc_debug_dump_nvmels_cq(struct lpfc_hba *phba)
+{
+	pr_err("NVME LS CQ: WQ[Qid:%d]->CQ[Qid:%d]\n",
+		phba->sli4_hba.nvmels_wq->queue_id,
+		phba->sli4_hba.nvmels_cq->queue_id);
+	lpfc_debug_dump_q(phba->sli4_hba.nvmels_cq);
+}
+
+/**
  * lpfc_debug_dump_mbx_cq - dump all entries from the mbox complete queue
  * @phba: Pointer to HBA context object.
  *
@@ -552,12 +620,12 @@ lpfc_debug_dump_wq_by_id(struct lpfc_hba *phba, int qid)
 {
 	int wq_idx;
 
-	for (wq_idx = 0; wq_idx < phba->cfg_fcp_io_channel; wq_idx++)
-		if (phba->sli4_hba.fcp_wq[wq_idx]->queue_id == qid)
+	for (wq_idx = 0; wq_idx < phba->io_channel; wq_idx++)
+		if (phba->sli4_hba.hba_wq[wq_idx]->queue_id == qid)
 			break;
-	if (wq_idx < phba->cfg_fcp_io_channel) {
+	if (wq_idx < phba->io_channel) {
 		printk(KERN_ERR "FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
-		lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[wq_idx]);
+		lpfc_debug_dump_q(phba->sli4_hba.hba_wq[wq_idx]);
 		return;
 	}
 
@@ -565,6 +633,11 @@ lpfc_debug_dump_wq_by_id(struct lpfc_hba *phba, int qid)
 		printk(KERN_ERR "ELS WQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_wq);
 	}
+
+	if (phba->sli4_hba.nvmels_wq->queue_id == qid) {
+		pr_err("NVME LS WQ[Qid:%d]\n", qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvmels_wq);
+	}
 }
 
 /**
@@ -636,6 +709,12 @@ lpfc_debug_dump_cq_by_id(struct lpfc_hba *phba, int qid)
 		return;
 	}
 
+	if (phba->sli4_hba.nvmels_cq->queue_id == qid) {
+		pr_err("NVME LS CQ[Qid:%d]\n", qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvmels_cq);
+		return;
+	}
+
 	if (phba->sli4_hba.mbx_cq->queue_id == qid) {
 		printk(KERN_ERR "MBX CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
@@ -655,12 +734,12 @@ lpfc_debug_dump_eq_by_id(struct lpfc_hba *phba, int qid)
 {
 	int eq_idx;
 
-	for (eq_idx = 0; eq_idx < phba->cfg_fcp_io_channel; eq_idx++) {
+	for (eq_idx = 0; eq_idx < phba->io_channel; eq_idx++) {
 		if (phba->sli4_hba.hba_eq[eq_idx]->queue_id == qid)
 			break;
 	}
 
-	if (eq_idx < phba->cfg_fcp_io_channel) {
+	if (eq_idx < phba->io_channel) {
 		printk(KERN_ERR "FCP EQ[Idx:%d|Qid:%d]\n", eq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.hba_eq[eq_idx]);
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 361f5b3..773e715 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -86,6 +86,17 @@ struct lpfc_nodelist {
 #define NLP_FABRIC         0x4			/* entry rep a Fabric entity */
 #define NLP_FCP_TARGET     0x8			/* entry is an FCP target */
 #define NLP_FCP_INITIATOR  0x10			/* entry is an FCP Initiator */
+#define NLP_NVME_TARGET    0x20			/* entry is a NVME Target */
+#define NLP_NVME_INITIATOR 0x40			/* entry is a NVME Initiator */
+
+	uint16_t	nlp_fc4_type;		/* FC types node supports. */
+						/* Assigned from GID_FF, only
+						 * FCP (0x8) and NVME (0x28)
+						 * supported.
+						 */
+#define NLP_FC4_NONE	0x0
+#define NLP_FC4_FCP	0x1			/* FC4 Type FCP (value x8)) */
+#define NLP_FC4_NVME	0x2			/* FC4 TYPE NVME (value x28) */
 
 	uint16_t        nlp_rpi;
 	uint16_t        nlp_state;		/* state transition indicator */
@@ -107,8 +118,8 @@ struct lpfc_nodelist {
 
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
 	struct lpfc_hba *phba;
-	struct fc_rport *rport;			/* Corresponding FC transport
-						   port structure */
+	struct fc_rport *rport;		/* scsi_transport_fc port structure */
+	struct lpfc_nvme_rport *nrport;	/* nvme transport rport struct. */
 	struct lpfc_vport *vport;
 	struct lpfc_work_evt els_retry_evt;
 	struct lpfc_work_evt dev_loss_evt;
@@ -118,6 +129,8 @@ struct lpfc_nodelist {
 	unsigned long last_change_time;
 	unsigned long *active_rrqs_xri_bitmap;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
+	uint32_t fc4_prli_sent;
+	uint32_t upcall_flags;
 };
 struct lpfc_node_rrq {
 	struct list_head list;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c0af32f..4d9ee2b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -29,7 +29,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
-
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -1868,10 +1867,12 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* PLOGI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0102 PLOGI completes to NPort x%x "
+			 "0102 PLOGI completes to NPort x%06x "
 			 "Data: x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, disc, vport->num_disc_nodes);
+			 ndlp->nlp_DID, ndlp->nlp_fc4_type,
+			 irsp->ulpStatus, irsp->un.ulpWord[4],
+			 disc, vport->num_disc_nodes);
+
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		spin_lock_irq(shost->host_lock);
@@ -2049,14 +2050,17 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		"PRLI cmpl:       status:x%x/x%x did:x%x",
 		irsp->ulpStatus, irsp->un.ulpWord[4],
 		ndlp->nlp_DID);
+
+	/* Ddriver supports multiple FC4 types.  Counters matter. */
+	vport->fc_prli_sent--;
+
 	/* PRLI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0103 PRLI completes to NPort x%x "
+			 "0103 PRLI completes to NPort x%06x "
 			 "Data: x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, vport->num_disc_nodes);
+			 vport->num_disc_nodes, ndlp->fc4_prli_sent);
 
-	vport->fc_prli_sent--;
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport))
 		goto out;
@@ -2065,6 +2069,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
+			ndlp->fc4_prli_sent--;
 			goto out;
 		}
 		/* PRLI failed */
@@ -2079,9 +2084,14 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 	} else
-		/* Good status, call state machine */
+		/* Good status, call state machine.  However, if another
+		 * PRLI is outstanding, don't call the state machine
+		 * because final disposition to Mapped or Unmapped is
+		 * completed there.
+		 */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PRLI);
+
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
@@ -2115,11 +2125,25 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba *phba = vport->phba;
 	PRLI *npr;
+	struct lpfc_nvme_prli *npr_nvme;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
+	uint32_t local_nlp_type;
+
+	local_nlp_type = ndlp->nlp_fc4_type;
 
-	cmdsize = (sizeof(uint32_t) + sizeof(PRLI));
+ send_next_prli:
+	if (local_nlp_type & NLP_FC4_FCP)
+		cmdsize = (sizeof(uint32_t) + sizeof(PRLI));
+	else if (local_nlp_type & NLP_FC4_NVME)
+		cmdsize = (sizeof(uint32_t) + sizeof(struct lpfc_nvme_prli));
+	else {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "3083 Unknown FC_TYPE x%x ndlp x%06x\n",
+				 ndlp->nlp_fc4_type, ndlp->nlp_DID);
+		return 1;
+	}
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_PRLI);
 	if (!elsiocb)
@@ -2128,29 +2152,55 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	/* For PRLI request, remainder of payload is service parameters */
-	memset(pcmd, 0, (sizeof(PRLI) + sizeof(uint32_t)));
+	memset(pcmd, 0, cmdsize);
 	*((uint32_t *) (pcmd)) = ELS_CMD_PRLI;
 	pcmd += sizeof(uint32_t);
 
-	/* For PRLI, remainder of payload is PRLI parameter page */
-	npr = (PRLI *) pcmd;
-	/*
-	 * If our firmware version is 3.20 or later,
-	 * set the following bits for FC-TAPE support.
-	 */
-	if (phba->vpd.rev.feaLevelHigh >= 0x02) {
-		npr->ConfmComplAllowed = 1;
-		npr->Retry = 1;
-		npr->TaskRetryIdReq = 1;
-	}
-	npr->estabImagePair = 1;
-	npr->readXferRdyDis = 1;
-	 if (vport->cfg_first_burst_size)
-		npr->writeXferRdyDis = 1;
+	if (local_nlp_type & NLP_FC4_FCP) {
+		/* Remainder of payload is FCP PRLI parameter page.
+		 * Note: this data structure is defined as
+		 * BE/LE in the structure definition so no
+		 * byte swap call is made.
+		 */
+		npr = (PRLI *)pcmd;
+
+		/*
+		 * If our firmware version is 3.20 or later,
+		 * set the following bits for FC-TAPE support.
+		 */
+		if (phba->vpd.rev.feaLevelHigh >= 0x02) {
+			npr->ConfmComplAllowed = 1;
+			npr->Retry = 1;
+			npr->TaskRetryIdReq = 1;
+		}
+		npr->estabImagePair = 1;
+		npr->readXferRdyDis = 1;
+		if (vport->cfg_first_burst_size)
+			npr->writeXferRdyDis = 1;
+
+		/* For FCP support */
+		npr->prliType = PRLI_FCP_TYPE;
+		npr->initiatorFunc = 1;
+		elsiocb->iocb_flag |= LPFC_PRLI_FCP_REQ;
+
+		/* Remove FCP type - processed. */
+		local_nlp_type &= ~NLP_FC4_FCP;
+	} else if (local_nlp_type & NLP_FC4_NVME) {
+		/* Remainder of payload is NVME PRLI parameter page.
+		 * This data structure is the newer definition that
+		 * uses bf macros so a byte swap is required.
+		 */
+		npr_nvme = (struct lpfc_nvme_prli *)pcmd;
+		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
+		bf_set(prli_estabImagePair, npr_nvme, 0);  /* Should be 0 */
+		bf_set(prli_init, npr_nvme, 1);
+		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
+		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
+		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
 
-	/* For FCP support */
-	npr->prliType = PRLI_FCP_TYPE;
-	npr->initiatorFunc = 1;
+		/* Remove NVME type - processed. */
+		local_nlp_type &= ~NLP_FC4_NVME;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PRLI:      did:x%x",
@@ -2169,7 +2219,20 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
+
+	/* The vport counters are used for lpfc_scan_finished, but
+	 * the ndlp is used to track outstanding PRLIs for different
+	 * FC4 types.
+	 */
 	vport->fc_prli_sent++;
+	ndlp->fc4_prli_sent++;
+
+	/* The driver supports 2 FC4 types.  Make sure
+	 * a PRLI is issued for all types before exiting.
+	 */
+	if (local_nlp_type & (NLP_FC4_FCP | NLP_FC4_NVME))
+		goto send_next_prli;
+
 	return 0;
 }
 
@@ -4223,15 +4286,37 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 {
 	struct lpfc_hba  *phba = vport->phba;
 	PRLI *npr;
+	struct lpfc_nvme_prli *npr_nvme;
 	lpfc_vpd_t *vpd;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
+	uint32_t prli_fc4_req, *req_payload;
+	struct lpfc_dmabuf *req_buf;
 	int rc;
 
-	cmdsize = sizeof(uint32_t) + sizeof(PRLI);
+	/* Need the incoming PRLI payload to determine if the ACC is for an
+	 * FC4 or NVME PRLI type.  The PRLI type is at word 1.
+	 */
+	req_buf = (struct lpfc_dmabuf *)oldiocb->context2;
+	req_payload = (((uint32_t *)req_buf->virt) + 1);
+
+	/* PRLI type payload is at byte 3 for FCP or NVME. */
+	prli_fc4_req = be32_to_cpu(*req_payload);
+	prli_fc4_req = (prli_fc4_req >> 24) & 0xff;
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "3092 PRLI_ACC:  Req Type x%x, Word1 x%08x\n",
+			 prli_fc4_req, *((uint32_t *)req_payload));
+
+	if (prli_fc4_req == PRLI_FCP_TYPE)
+		cmdsize = sizeof(uint32_t) + sizeof(PRLI);
+	else if (prli_fc4_req & PRLI_NVME_TYPE)
+		cmdsize = sizeof(uint32_t) + sizeof(struct lpfc_nvme_prli);
+	else
+		return 1;
+
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 		ndlp->nlp_DID, (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK)));
 	if (!elsiocb)
@@ -4250,33 +4335,46 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	memset(pcmd, 0, cmdsize);
 
 	*((uint32_t *) (pcmd)) = (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK));
 	pcmd += sizeof(uint32_t);
 
 	/* For PRLI, remainder of payload is PRLI parameter page */
-	memset(pcmd, 0, sizeof(PRLI));
-
-	npr = (PRLI *) pcmd;
 	vpd = &phba->vpd;
-	/*
-	 * If the remote port is a target and our firmware version is 3.20 or
-	 * later, set the following bits for FC-TAPE support.
-	 */
-	if ((ndlp->nlp_type & NLP_FCP_TARGET) &&
-	    (vpd->rev.feaLevelHigh >= 0x02)) {
-		npr->ConfmComplAllowed = 1;
-		npr->Retry = 1;
-		npr->TaskRetryIdReq = 1;
-	}
-
-	npr->acceptRspCode = PRLI_REQ_EXECUTED;
-	npr->estabImagePair = 1;
-	npr->readXferRdyDis = 1;
-	npr->ConfmComplAllowed = 1;
 
-	npr->prliType = PRLI_FCP_TYPE;
-	npr->initiatorFunc = 1;
+	if (prli_fc4_req == PRLI_FCP_TYPE) {
+		/*
+		 * If the remote port is a target and our firmware version
+		 * is 3.20 or later, set the following bits for FC-TAPE
+		 * support.
+		 */
+		npr = (PRLI *) pcmd;
+		if ((ndlp->nlp_type & NLP_FCP_TARGET) &&
+		    (vpd->rev.feaLevelHigh >= 0x02)) {
+			npr->ConfmComplAllowed = 1;
+			npr->Retry = 1;
+			npr->TaskRetryIdReq = 1;
+		}
+		npr->acceptRspCode = PRLI_REQ_EXECUTED;
+		npr->estabImagePair = 1;
+		npr->readXferRdyDis = 1;
+		npr->ConfmComplAllowed = 1;
+		npr->prliType = PRLI_FCP_TYPE;
+		npr->initiatorFunc = 1;
+	} else if (prli_fc4_req & PRLI_NVME_TYPE) {
+		/* Respond with an NVME PRLI Type */
+		npr_nvme = (struct lpfc_nvme_prli *) pcmd;
+		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
+		bf_set(prli_estabImagePair, npr_nvme, 0);  /* Should be 0 */
+		bf_set(prli_init, npr_nvme, 1);
+		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
+		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
+	} else
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "3095 Unknown FC_TYPE x%x x%x ndlp x%06x\n",
+				 prli_fc4_req, ndlp->nlp_fc4_type,
+				 ndlp->nlp_DID);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue ACC PRLI:  did:x%x flg:x%x",
@@ -5968,9 +6066,11 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
 	    && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		/* Good ndlp, issue CT Request to NameServer */
-		if (lpfc_ns_cmd(vport, SLI_CTNS_GID_FT, 0, 0) == 0)
+		vport->gidft_inp = 0;
+		if (lpfc_issue_gidft(vport) == 0)
 			/* Wait for NameServer query cmpl before we can
-			   continue */
+			 * continue
+			 */
 			return 1;
 	} else {
 		/* If login to NameServer does not exist, issue one */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ed22393..2061636 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -31,6 +31,9 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
+
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -39,6 +42,7 @@
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
@@ -3458,6 +3462,14 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
 		spin_unlock_irq(shost->host_lock);
+
+		/*
+		 * We cannot leave the RPI registered because
+		 * if we go thru discovery again for this ndlp
+		 * a subsequent REG_RPI will fail.
+		 */
+		ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+		lpfc_unreg_rpi(vport, ndlp);
 	}
 
 	/* Call state machine */
@@ -3805,6 +3817,50 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	return;
 }
 
+ /*
+  * This routine will issue a GID_FT for each FC4 Type supported
+  * by the driver. ALL GID_FTs must complete before discovery is started.
+  */
+int
+lpfc_issue_gidft(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+
+	/* Good status, issue CT Request to NameServer */
+	if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+	    (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)) {
+		if (lpfc_ns_cmd(vport, SLI_CTNS_GID_FT, 0, SLI_CTPT_FCP)) {
+			/* Cannot issue NameServer FCP Query, so finish up
+			 * discovery
+			 */
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
+					 "0604 Failed to issue GID_FT to "
+					 "FC TYPE %x. Finishing discovery.\n",
+					 FC_TYPE_FCP);
+			return 0;
+		}
+		vport->gidft_inp++;
+	}
+
+	if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+	    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+		if (lpfc_ns_cmd(vport, SLI_CTNS_GID_FT, 0, SLI_CTPT_NVME)) {
+			/* Cannot issue NameServer NVME Query, so finish up
+			 * discovery
+			 */
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
+					 "0605 Failed to issue GID_FT to "
+					 "FC_TYPE %x Finishing discovery: "
+					 "gidftinp %d\n",
+					 LPFC_FC4_TYPE_NVME, vport->gidft_inp);
+			if (vport->gidft_inp == 0)
+				return 0;
+		} else
+			vport->gidft_inp++;
+	}
+	return vport->gidft_inp;
+}
+
 /*
  * This routine handles processing a NameServer REG_LOGIN mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
@@ -3821,12 +3877,14 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
+	vport->gidft_inp = 0;
 
 	if (mb->mbxStatus) {
-out:
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0260 Register NameServer error: 0x%x\n",
 				 mb->mbxStatus);
+
+out:
 		/* decrement the node reference count held for this
 		 * callback function.
 		 */
@@ -3870,20 +3928,29 @@ out:
 		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
-		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0);
+
+		if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP))
+			lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, FC_TYPE_FCP);
+
+		if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME))
+			lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0,
+				    LPFC_FC4_TYPE_NVME);
 
 		/* Issue SCR just before NameServer GID_FT Query */
 		lpfc_issue_els_scr(vport, SCR_DID, 0);
 	}
 
 	vport->fc_ns_retry = 0;
-	/* Good status, issue CT Request to NameServer */
-	if (lpfc_ns_cmd(vport, SLI_CTNS_GID_FT, 0, 0)) {
-		/* Cannot issue NameServer Query, so finish up discovery */
+	if (lpfc_issue_gidft(vport) == 0)
 		goto out;
-	}
 
-	/* decrement the node reference count held for this
+	/*
+	 * At this point in time we may need to wait for multiple
+	 * SLI_CTNS_GID_FT CT commands to complete before we start discovery.
+	 *
+	 * decrement the node reference count held for this
 	 * callback function.
 	 */
 	lpfc_nlp_put(ndlp);
@@ -3986,6 +4053,178 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 	return;
 }
 
+static int
+lpfc_register_nvme_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	int found = 0, ret = 0;
+	struct lpfc_nvme *pnvme = vport->pnvme;
+	struct lpfc_nvme_lport *lport;
+	struct lpfc_nvme_rport *rport;
+	struct nvme_fc_port_info rpinfo;
+	struct lpfc_nodelist *fndlp;
+
+	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NVME,
+			 "6006 Register NVME LPORT. nvme %p, DID x%06x nlptype x%x\n",
+			 pnvme, ndlp->nlp_DID, ndlp->nlp_type);
+
+	/* Ensure the driver has a valid nvme interface. */
+	if (pnvme == NULL) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_NVME,
+				 "6016 No NVME instance available. Error\n");
+		return -EINVAL;
+	}
+
+	if ((ndlp->nlp_type & NLP_FABRIC) && (ndlp->nlp_DID == Fabric_DID))  {
+		/* Update the Fabric name and local driver DID in
+		 * the nvme fc port data structure. For now, only
+		 * a single lport for FC.
+		 */
+		list_for_each_entry(lport, &pnvme->lport_list, list) {
+			lport->localport->fabric_name =
+				wwn_to_u64(ndlp->nlp_nodename.u.wwn);
+			lport->localport->port_role =
+				FC_PORT_ROLE_NVME_INITIATOR;
+			lport->localport->port_id = vport->fc_myDID;
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+					 "6030 bound lport %p to "
+					 "FabricName x%llx, DID x%06x\n",
+					 lport,
+					 lport->localport->fabric_name,
+					 lport->localport->port_id);
+		}
+	} else if (ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_INITIATOR)) {
+		if (vport->fc_flag & FC_PT2PT) {
+			lport = list_get_first(&vport->pnvme->lport_list,
+					       struct lpfc_nvme_lport, list);
+			goto regit;
+		}
+		/* Find the rport's owning lport. */
+		fndlp = lpfc_findnode_did(vport, Fabric_DID);
+		if (!fndlp || !NLP_CHK_NODE_ACT(fndlp)) {
+			lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
+					 "6011 No Fabric DID.  Exiting.\n");
+			return -EINVAL;
+		}
+
+		list_for_each_entry(lport, &pnvme->lport_list, list) {
+			if (lport->localport->fabric_name !=
+			    wwn_to_u64(fndlp->nlp_nodename.u.wwn))
+				continue;
+			found = 1;
+			break;
+		}
+		if (!found) {
+			lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NVME,
+					 "6034 No lport available.\n");
+			return -EINVAL;
+		}
+regit:
+		/* The driver isn't expecting the rport wwn to change
+		 * but it might get a different DID on a different
+		 * fabric.
+		 */
+		list_for_each_entry(rport, &lport->rport_list, list) {
+			if (rport->remoteport->port_name !=
+			    wwn_to_u64(ndlp->nlp_portname.u.wwn))
+				continue;
+			lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NVME,
+					 "6035 Found lport %p, rport%p, "
+					 "nlp type x%x DID x%06x\n",
+					 lport, rport, ndlp->nlp_type,
+					 ndlp->nlp_DID);
+			return 0;
+		}
+
+		/* NVME rports are not preserved across devloss.
+		 * Just register this instance.
+		 */
+		rpinfo.port_id = ndlp->nlp_DID;
+		rpinfo.port_role = 0;
+		if (ndlp->nlp_type & NLP_NVME_TARGET)
+			rpinfo.port_role |= FC_PORT_ROLE_NVME_TARGET;
+		if (ndlp->nlp_type & NLP_NVME_INITIATOR)
+			rpinfo.port_role |= FC_PORT_ROLE_NVME_INITIATOR;
+		rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
+		rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
+		if (vport->fc_flag & FC_PT2PT)
+			rpinfo.fabric_name =
+				wwn_to_u64(vport->fc_portname.u.wwn);
+		else
+			rpinfo.fabric_name = lport->localport->fabric_name;
+
+		/* TODO: bind with nvme layer - register remote nvme port */
+	} else {
+		ret = -EINVAL;
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+				 "6027 Unknown nlp_type x%x on DID x%06x "
+				 "ndlp %p.  Not Registering nvme rport\n",
+				 ndlp->nlp_type, ndlp->nlp_DID, ndlp);
+	}
+	return ret;
+}
+
+static void
+lpfc_unregister_nvme_port(struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_nvme *pnvme = ndlp->vport->pnvme;
+	struct lpfc_vport *vport = ndlp->vport;
+	struct lpfc_nvme_lport *lport;
+	struct lpfc_nvme_rport *rport;
+
+	if (pnvme == NULL)
+		return;
+
+	if ((ndlp->nlp_type & NLP_FABRIC) && (ndlp->nlp_DID == Fabric_DID)) {
+		/* Update the local port id and role to reflect the
+		 * new state.  The fabric name is needed to match. For
+		 * now, only a single lport for FC so this works.
+		 * To handle link recovery, fabric name changes will become
+		 * necessary.
+		 */
+		list_for_each_entry(lport, &pnvme->lport_list, list) {
+			if (lport->localport->fabric_name !=
+			    wwn_to_u64(ndlp->nlp_nodename.u.wwn))
+				continue;
+
+			lport->localport->port_id = 0;
+			lport->localport->port_role =
+					FC_PORT_ROLE_NVME_DISCOVERY;
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+					 "6032 lport %p Fabric Name "
+					 "and DID cleared.\n",
+					 lport);
+		}
+	} else if (ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_INITIATOR)) {
+		/* Find the rport matching the ndlp wwn and update the
+		 * port and wwn's to reflect no connection.
+		 */
+		list_for_each_entry(lport, &pnvme->lport_list, list) {
+			if (lport->localport->fabric_name !=
+			    wwn_to_u64(ndlp->nlp_nodename.u.wwn))
+				continue;
+
+			/* The rports are not expected to change WWNs but
+			 * but the port_id and fabric name could be different
+			 * during recovery.  For NPIV-based rports that do
+			 * recover with new WWNs, a new rport should get
+			 * registered and added to the nvme_transport.
+			 */
+			list_for_each_entry(rport, &lport->rport_list, list) {
+				if (rport->remoteport->port_name !=
+				    wwn_to_u64(ndlp->nlp_portname.u.wwn))
+					continue;
+
+				rport->remoteport->port_id = 0;
+				rport->remoteport->port_role =
+					FC_PORT_ROLE_NVME_DISCOVERY;
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+						 "6033 rport %p DID x%06x unreg.\n",
+						 rport, ndlp->nlp_DID);
+			}
+		}
+	}
+}
+
 static void
 lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
 {
@@ -4029,6 +4268,7 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       int old_state, int new_state)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_hba *phba = vport->phba;
 
 	if (new_state == NLP_STE_UNMAPPED_NODE) {
 		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
@@ -4039,23 +4279,50 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (new_state == NLP_STE_NPR_NODE)
 		ndlp->nlp_flag &= ~NLP_RCV_PLOGI;
 
-	/* Transport interface */
-	if (ndlp->rport && (old_state == NLP_STE_MAPPED_NODE ||
-			    old_state == NLP_STE_UNMAPPED_NODE)) {
-		vport->phba->nport_event_cnt++;
-		lpfc_unregister_remote_port(ndlp);
+	/* FCP and NVME Transport interface */
+	if ((old_state == NLP_STE_MAPPED_NODE ||
+	     old_state == NLP_STE_UNMAPPED_NODE)) {
+		if (ndlp->rport) {
+			vport->phba->nport_event_cnt++;
+			lpfc_unregister_remote_port(ndlp);
+		}
+
+		/* Notify the NVME transport of this rport's loss */
+		if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) &&
+		    (vport->phba->cfg_enable_nvmet == NVME_TARGET_OFF) &&
+		    ((ndlp->nlp_fc4_type & NLP_FC4_NVME) ||
+		    (ndlp->nlp_DID == Fabric_DID))) {
+			vport->phba->nport_event_cnt++;
+			lpfc_unregister_nvme_port(ndlp);
+		}
 	}
 
+	/* FCP and NVME Transport interfaces */
+
 	if (new_state ==  NLP_STE_MAPPED_NODE ||
 	    new_state == NLP_STE_UNMAPPED_NODE) {
-		vport->phba->nport_event_cnt++;
-		/*
-		 * Tell the fc transport about the port, if we haven't
-		 * already. If we have, and it's a scsi entity, be
-		 * sure to unblock any attached scsi devices
-		 */
-		lpfc_register_remote_port(vport, ndlp);
+		if ((ndlp->nlp_fc4_type & NLP_FC4_FCP) ||
+		    (ndlp->nlp_DID == Fabric_DID)) {
+			vport->phba->nport_event_cnt++;
+			/*
+			 * Tell the fc transport about the port, if we haven't
+			 * already. If we have, and it's a scsi entity, be
+			 */
+			lpfc_register_remote_port(vport, ndlp);
+		}
+		/* Notify the NVME transport of this new rport. */
+		if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) &&
+		    (vport->phba->cfg_enable_nvmet == NVME_TARGET_OFF)) {
+			if ((ndlp->nlp_fc4_type & NLP_FC4_NVME) ||
+			    (ndlp->nlp_DID == Fabric_DID)) {
+				vport->phba->nport_event_cnt++;
+				lpfc_register_nvme_port(vport, ndlp);
+			}
+		}
 	}
+
 	if ((new_state ==  NLP_STE_MAPPED_NODE) &&
 		(vport->stat_data_enabled)) {
 		/*
@@ -4212,6 +4479,7 @@ lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->vport = vport;
 	ndlp->phba = vport->phba;
 	ndlp->nlp_sid = NLP_NO_SID;
+	ndlp->nlp_fc4_type = NLP_FC4_NONE;
 	kref_init(&ndlp->kref);
 	NLP_INT_NODE_ACT(ndlp);
 	atomic_set(&ndlp->cmd_pending, 0);
@@ -5331,12 +5599,13 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 	switch (vport->port_state) {
 
 	case LPFC_LOCAL_CFG_LINK:
-	/* port_state is identically  LPFC_LOCAL_CFG_LINK while waiting for
-	 * FAN
-	 */
-				/* FAN timeout */
+		/*
+		 * port_state is identically  LPFC_LOCAL_CFG_LINK while
+		 * waiting for FAN timeout
+		 */
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
 				 "0221 FAN timeout\n");
+
 		/* Start discovery by sending FLOGI, clean up old rpis */
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
@@ -5407,8 +5676,8 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 			/* Try it one more time */
 			vport->fc_ns_retry++;
-			rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
-					 vport->fc_ns_retry, 0);
+			vport->gidft_inp = 0;
+			rc = lpfc_issue_gidft(vport);
 			if (rc == 0)
 				break;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 8226543..632697d 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -92,8 +92,10 @@ union CtCommandResponse {
 	uint32_t word;
 };
 
-#define FC4_FEATURE_INIT 0x2
-#define FC4_FEATURE_TARGET 0x1
+/* FC4 Feature bits for RFF_ID */
+#define FC4_FEATURE_TARGET	0x1
+#define FC4_FEATURE_INIT	0x2
+#define FC4_FEATURE_NVME_DISC	0x4
 
 struct lpfc_sli_ct_request {
 	/* Structure is in Big Endian format */
@@ -117,6 +119,16 @@ struct lpfc_sli_ct_request {
 			uint8_t AreaScope;
 			uint8_t Fc4Type;	/* for GID_FT requests */
 		} gid;
+		struct gid_ff {
+			uint8_t Flags;
+			uint8_t DomainScope;
+			uint8_t AreaScope;
+			uint8_t rsvd1;
+			uint8_t rsvd2;
+			uint8_t rsvd3;
+			uint8_t Fc4FBits;
+			uint8_t Fc4Type;
+		} gid_ff;
 		struct rft {
 			uint32_t PortId;	/* For RFT_ID requests */
 
@@ -161,6 +173,12 @@ struct lpfc_sli_ct_request {
 		struct gff_acc {
 			uint8_t fbits[128];
 		} gff_acc;
+		struct gft {
+			uint32_t PortId;
+		} gft;
+		struct gft_acc {
+			uint32_t fc4_types[8];
+		} gft_acc;
 #define FCP_TYPE_FEATURE_OFFSET 7
 		struct rff {
 			uint32_t PortId;
@@ -176,8 +194,12 @@ struct lpfc_sli_ct_request {
 #define  SLI_CT_REVISION        1
 #define  GID_REQUEST_SZ   (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct gid))
+#define  GIDFF_REQUEST_SZ (offsetof(struct lpfc_sli_ct_request, un) + \
+			   sizeof(struct gid_ff))
 #define  GFF_REQUEST_SZ   (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct gff))
+#define  GFT_REQUEST_SZ   (offsetof(struct lpfc_sli_ct_request, un) + \
+			   sizeof(struct gft))
 #define  RFT_REQUEST_SZ   (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct rft))
 #define  RFF_REQUEST_SZ   (offsetof(struct lpfc_sli_ct_request, un) + \
@@ -273,6 +295,7 @@ struct lpfc_sli_ct_request {
 #define  SLI_CTNS_GNN_IP      0x0153
 #define  SLI_CTNS_GIPA_IP     0x0156
 #define  SLI_CTNS_GID_FT      0x0171
+#define  SLI_CTNS_GID_FF      0x01F1
 #define  SLI_CTNS_GID_PT      0x01A1
 #define  SLI_CTNS_RPN_ID      0x0212
 #define  SLI_CTNS_RNN_ID      0x0213
@@ -290,15 +313,16 @@ struct lpfc_sli_ct_request {
  * Port Types
  */
 
-#define  SLI_CTPT_N_PORT      0x01
-#define  SLI_CTPT_NL_PORT     0x02
-#define  SLI_CTPT_FNL_PORT    0x03
-#define  SLI_CTPT_IP          0x04
-#define  SLI_CTPT_FCP         0x08
-#define  SLI_CTPT_NX_PORT     0x7F
-#define  SLI_CTPT_F_PORT      0x81
-#define  SLI_CTPT_FL_PORT     0x82
-#define  SLI_CTPT_E_PORT      0x84
+#define SLI_CTPT_N_PORT		0x01
+#define SLI_CTPT_NL_PORT	0x02
+#define SLI_CTPT_FNL_PORT	0x03
+#define SLI_CTPT_IP		0x04
+#define SLI_CTPT_FCP		0x08
+#define SLI_CTPT_NVME		0x28
+#define SLI_CTPT_NX_PORT	0x7F
+#define SLI_CTPT_F_PORT		0x81
+#define SLI_CTPT_FL_PORT	0x82
+#define SLI_CTPT_E_PORT		0x84
 
 #define SLI_CT_LAST_ENTRY     0x80000000
 
@@ -680,6 +704,7 @@ typedef struct _PRLI {		/* Structure is in Big Endian format */
 	uint8_t prliType;	/* FC Parm Word 0, bit 24:31 */
 
 #define PRLI_FCP_TYPE 0x08
+#define PRLI_NVME_TYPE 0x28
 	uint8_t word0Reserved1;	/* FC Parm Word 0, bit 16:23 */
 
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -4157,7 +4182,7 @@ typedef struct _IOCB {	/* IOCB structure */
 
 /* HBQ entries are 4 words each = 4k */
 #define LPFC_TOTAL_HBQ_SIZE (sizeof(struct lpfc_hbq_entry) *  \
-			     lpfc_sli_hbq_count())
+			     lpfc_sli_hbq_count(phba))
 
 struct lpfc_sli2_slim {
 	MAILBOX_t mbx;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index ee80227..2c5d1fd 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -348,6 +348,7 @@ struct lpfc_cqe {
 #define CQE_CODE_RECEIVE		0x4
 #define CQE_CODE_XRI_ABORTED		0x5
 #define CQE_CODE_RECEIVE_V1		0x9
+#define CQE_CODE_NVME_ERSP		0xd
 
 /*
  * Define mask value for xri_aborted and wcqe completed CQE extended status.
@@ -2891,6 +2892,9 @@ struct lpfc_sli4_parameters {
 #define cfg_mds_diags_SHIFT			1
 #define cfg_mds_diags_MASK			0x00000001
 #define cfg_mds_diags_WORD			word19
+#define cfg_nvme_SHIFT				3
+#define cfg_nvme_MASK				0x00000001
+#define cfg_nvme_WORD				word19
 };
 
 #define LPFC_SET_UE_RECOVERY		0x10
@@ -3642,6 +3646,9 @@ struct wqe_common {
 #define wqe_ebde_cnt_SHIFT    0
 #define wqe_ebde_cnt_MASK     0x0000000f
 #define wqe_ebde_cnt_WORD     word10
+#define wqe_nvme_SHIFT        4
+#define wqe_nvme_MASK         0x00000001
+#define wqe_nvme_WORD         word10
 #define wqe_oas_SHIFT         6
 #define wqe_oas_MASK          0x00000001
 #define wqe_oas_WORD          word10
@@ -3702,6 +3709,9 @@ struct wqe_common {
 #define LPFC_ELS_ID_FDISC	2
 #define LPFC_ELS_ID_LOGO	1
 #define LPFC_ELS_ID_DEFAULT	0
+#define wqe_irsp_SHIFT        4
+#define wqe_irsp_MASK         0x00000001
+#define wqe_irsp_WORD         word11
 #define wqe_wqec_SHIFT        7
 #define wqe_wqec_MASK         0x00000001
 #define wqe_wqec_WORD         word11
@@ -3882,6 +3892,50 @@ struct gen_req64_wqe {
 	uint32_t max_response_payload_len;
 };
 
+/* Define NVME PRLI request to fabric. NVME is a
+ * fabric-only protocol.
+ */
+struct lpfc_nvme_prli {
+	uint32_t word1;
+#define prli_estabImagePair_SHIFT       13
+#define prli_estabImagePair_MASK        0x00000001
+#define prli_estabImagePair_WORD        word1
+#define prli_type_code_ext_SHIFT        16
+#define prli_type_code_ext_MASK         0x000000ff
+#define prli_type_code_ext_WORD         word1
+#define prli_type_code_SHIFT            24
+#define prli_type_code_MASK             0x000000ff
+#define prli_type_code_WORD             word1
+	uint32_t word_rsvd2;
+	uint32_t word_rsvd3;
+	uint32_t word4;
+#define prli_disc_SHIFT                 3
+#define prli_disc_MASK                  0x00000001
+#define prli_disc_WORD                  word4
+#define prli_tgt_SHIFT                  4
+#define prli_tgt_MASK                   0x00000001
+#define prli_tgt_WORD                   word4
+#define prli_init_SHIFT                 5
+#define prli_init_MASK                  0x00000001
+#define prli_init_WORD                  word4
+#define prli_dovly_SHIFT                6
+#define prli_dovly_MASK                 0x00000001
+#define prli_dovly_WORD                 word4
+#define prli_conf_SHIFT                 7
+#define prli_conf_MASK                  0x00000001
+#define prli_conf_WORD                  word4
+#define prli_retry_SHIFT                8
+#define prli_retry_MASK                 0x00000001
+#define prli_retry_WORD                 word4
+#define prli_rec_SHIFT                  10
+#define prli_rec_MASK                   0x00000001
+#define prli_rec_WORD                   word4
+#define prli_fba_SHIFT                  16
+#define prli_fba_MASK                   0x00000001
+#define prli_fba_WORD                   word4
+	uint32_t first_burst_sz;
+};
+
 struct create_xri_wqe {
 	uint32_t rsrvd[5];           /* words 0-4 */
 	struct wqe_did	wqe_dest;  /* word 5 */
@@ -3954,6 +4008,39 @@ struct fcp_icmnd64_wqe {
 	uint32_t rsvd_12_15[4];        /* word 12-15 */
 };
 
+struct fcp_trsp64_wqe {
+	struct ulp_bde64 bde;
+	uint32_t response_len;
+	uint32_t rsvd_4_5[2];
+	struct wqe_common wqe_com;      /* words 6-11 */
+	uint32_t rsvd_12_15[4];         /* word 12-15 */
+};
+
+struct fcp_tsend64_wqe {
+	struct ulp_bde64 bde;
+	uint32_t payload_offset_len;
+	uint32_t relative_offset;
+	uint32_t reserved;
+	struct wqe_common wqe_com;     /* words 6-11 */
+	uint32_t fcp_data_len;         /* word 12 */
+	uint32_t word13;
+#define wqe_irsplen_SHIFT     24
+#define wqe_irsplen_MASK      0x000000ff
+#define wqe_irsplen_WORD      word13
+	uint32_t rsvd_14_15[2];        /* word 14-15 */
+};
+
+struct fcp_treceive64_wqe {
+	struct ulp_bde64 bde;
+	uint32_t payload_offset_len;
+	uint32_t relative_offset;
+	uint32_t reserved;
+	struct wqe_common wqe_com;     /* words 6-11 */
+	uint32_t fcp_data_len;         /* word 12 */
+	uint32_t rsvd_13_15[3];        /* word 13-15 */
+};
+#define TXRDY_PAYLOAD_LEN      12
+
 
 union lpfc_wqe {
 	uint32_t words[16];
@@ -3969,6 +4056,10 @@ union lpfc_wqe {
 	struct xmit_els_rsp64_wqe xmit_els_rsp;
 	struct els_request64_wqe els_req;
 	struct gen_req64_wqe gen_req;
+	struct fcp_trsp64_wqe fcp_trsp;
+	struct fcp_tsend64_wqe fcp_tsend;
+	struct fcp_treceive64_wqe fcp_treceive;
+
 };
 
 union lpfc_wqe128 {
@@ -3977,6 +4068,9 @@ union lpfc_wqe128 {
 	struct fcp_icmnd64_wqe fcp_icmd;
 	struct fcp_iread64_wqe fcp_iread;
 	struct fcp_iwrite64_wqe fcp_iwrite;
+	struct fcp_trsp64_wqe fcp_trsp;
+	struct fcp_tsend64_wqe fcp_tsend;
+	struct fcp_treceive64_wqe fcp_treceive;
 	struct xmit_seq64_wqe xmit_sequence;
 	struct gen_req64_wqe gen_req;
 };
@@ -3999,11 +4093,35 @@ struct lpfc_grp_hdr {
 	uint8_t revision[32];
 };
 
-#define FCP_COMMAND 0x0
-#define FCP_COMMAND_DATA_OUT 0x1
-#define ELS_COMMAND_NON_FIP 0xC
-#define ELS_COMMAND_FIP 0xD
-#define OTHER_COMMAND 0x8
+/* Defines for WQE command type */
+#define FCP_COMMAND		0x0
+#define NVME_READ_CMD		0x0
+#define FCP_COMMAND_DATA_OUT	0x1
+#define NVME_WRITE_CMD		0x1
+#define FCP_COMMAND_TRECEIVE	0x2
+#define FCP_COMMAND_TRSP	0x3
+#define FCP_COMMAND_TSEND	0x7
+#define OTHER_COMMAND		0x8
+#define ELS_COMMAND_NON_FIP	0xC
+#define ELS_COMMAND_FIP		0xD
+
+/* WQE Commands */
+#define CMD_ABORT_XRI_WQE       0x0F
+#define CMD_XMIT_SEQUENCE64_WQE 0x82
+#define CMD_XMIT_BCAST64_WQE    0x84
+#define CMD_ELS_REQUEST64_WQE   0x8A
+#define CMD_XMIT_ELS_RSP64_WQE  0x95
+#define CMD_XMIT_BLS_RSP64_WQE  0x97
+#define CMD_FCP_IWRITE64_WQE    0x98
+#define CMD_FCP_IREAD64_WQE     0x9A
+#define CMD_FCP_ICMND64_WQE     0x9C
+#define CMD_FCP_TSEND64_WQE     0x9F
+#define CMD_FCP_TRECEIVE64_WQE  0xA1
+#define CMD_FCP_TRSP64_WQE      0xA3
+#define CMD_GEN_REQUEST64_WQE   0xC2
+
+#define CMD_WQE_MASK            0xff
+
 
 #define LPFC_FW_DUMP	1
 #define LPFC_FW_RESET	2
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index adf61b43..53d3e75 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3366,8 +3366,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	vport->fc_rscn_flush = 0;
-
 	lpfc_get_vport_cfgparam(vport);
+
 	shost->unique_id = instance;
 	shost->max_id = LPFC_MAX_TARGET;
 	shost->max_lun = vport->cfg_max_luns;
@@ -5184,10 +5184,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	struct lpfc_vector_map_info *cpup;
 	struct lpfc_sli *psli;
 	LPFC_MBOXQ_t *mboxq;
-	int rc, i, hbq_count, max_buf_size;
+	int rc, i, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
-	int longs;
+	int longs, io_channel;
 	int fof_vectors = 0;
 
 	/* Get all the module params for configuring this host */
@@ -5240,6 +5240,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* This will be set to correct value after the read_config mbox */
 	phba->max_vports = 0;
+	io_channel = phba->io_channel;
 
 	/* Program the default value of vlan_id and fc_map */
 	phba->valid_vlan = 0;
@@ -5253,7 +5254,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 */
 	if (!phba->sli.ring)
 		phba->sli.ring = kzalloc(
-			(LPFC_SLI3_MAX_RING + phba->cfg_fcp_io_channel) *
+			(LPFC_SLI3_MAX_RING + io_channel) *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
@@ -5324,10 +5325,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_total_seg_cnt);
 
 	/* Initialize buffer queue management fields */
-	hbq_count = lpfc_sli_hbq_count();
-	for (i = 0; i < hbq_count; ++i)
-		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
-	INIT_LIST_HEAD(&phba->rb_pend_list);
+	INIT_LIST_HEAD(&phba->hbqs[LPFC_ELS_HBQ].hbq_buffer_list);
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_sli4_rb_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_sli4_rb_free;
 
@@ -5380,7 +5378,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		rc = lpfc_pci_function_reset(phba);
 		if (unlikely(rc))
-			return -ENODEV;
+			goto out_free_mem;
 		phba->temp_sensor_support = 1;
 	}
 
@@ -5455,9 +5453,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2999 Unsupported SLI4 Parameters "
 				"Extents and RPI headers enabled.\n");
+			mempool_free(mboxq, phba->mbox_mem_pool);
 			goto out_free_bsmbx;
 		}
 	}
+
 	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/* Verify OAS is supported */
@@ -5504,11 +5504,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_remove_rpi_hdrs;
 	}
 
-	phba->sli4_hba.fcp_eq_hdl =
-			kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
-			    (fof_vectors + phba->cfg_fcp_io_channel)),
-			    GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_eq_hdl) {
+	phba->sli4_hba.hba_eq_hdl =
+			kzalloc((sizeof(struct lpfc_hba_eq_hdl) *
+			    (fof_vectors + io_channel)), GFP_KERNEL);
+	if (!phba->sli4_hba.hba_eq_hdl) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2572 Failed allocate memory for "
 				"fast-path per-EQ handle array\n");
@@ -5517,14 +5516,13 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
-				  (fof_vectors +
-				   phba->cfg_fcp_io_channel)), GFP_KERNEL);
+				  (fof_vectors + io_channel)), GFP_KERNEL);
 	if (!phba->sli4_hba.msix_entries) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2573 Failed allocate memory for msi-x "
 				"interrupt vector entries\n");
 		rc = -ENOMEM;
-		goto out_free_fcp_eq_hdl;
+		goto out_free_hba_eq_hdl;
 	}
 
 	phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
@@ -5558,7 +5556,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
 		cpup->channel_id = rc;
 		rc++;
-		if (rc >= phba->cfg_fcp_io_channel)
+		if (rc >= io_channel)
 			rc = 0;
 	}
 
@@ -5583,8 +5581,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 out_free_msix:
 	kfree(phba->sli4_hba.msix_entries);
-out_free_fcp_eq_hdl:
-	kfree(phba->sli4_hba.fcp_eq_hdl);
+out_free_hba_eq_hdl:
+	kfree(phba->sli4_hba.hba_eq_hdl);
 out_free_fcf_rr_bmask:
 	kfree(phba->fcf.fcf_rr_bmask);
 out_remove_rpi_hdrs:
@@ -5622,7 +5620,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 	kfree(phba->sli4_hba.msix_entries);
 
 	/* Free memory allocated for fast-path work queue handles */
-	kfree(phba->sli4_hba.fcp_eq_hdl);
+	kfree(phba->sli4_hba.hba_eq_hdl);
 
 	/* Free the allocated rpi headers. */
 	lpfc_sli4_remove_rpi_hdrs(phba);
@@ -6230,6 +6228,9 @@ lpfc_create_shost(struct lpfc_hba *phba)
 
 	shost = lpfc_shost_from_vport(vport);
 	phba->pport = vport;
+
+	phba->cfg_enable_nvmet = NVME_TARGET_OFF;
+
 	lpfc_debugfs_initialize(vport);
 	/* Put reference to SCSI host to driver's device private data */
 	pci_set_drvdata(phba->pcidev, shost);
@@ -6490,13 +6491,13 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 		       offsetof(struct lpfc_sli2_slim, IOCBs));
 
 	phba->hbqslimp.virt = dma_alloc_coherent(&pdev->dev,
-						 lpfc_sli_hbq_size(),
+						 lpfc_sli_hbq_size(phba),
 						 &phba->hbqslimp.phys,
 						 GFP_KERNEL);
 	if (!phba->hbqslimp.virt)
 		goto out_free_slim;
 
-	hbq_count = lpfc_sli_hbq_count();
+	hbq_count = lpfc_sli_hbq_count(phba);
 	ptr = phba->hbqslimp.virt;
 	for (i = 0; i < hbq_count; ++i) {
 		phba->hbqs[i].hbq_virt = ptr;
@@ -6507,9 +6508,7 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_els_hbq_free;
 
-	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
-
-	INIT_LIST_HEAD(&phba->rb_pend_list);
+	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size(phba));
 
 	phba->MBslimaddr = phba->slim_memmap_p;
 	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
@@ -6549,7 +6548,7 @@ lpfc_sli_pci_mem_unset(struct lpfc_hba *phba)
 		pdev = phba->pcidev;
 
 	/* Free coherent DMA memory allocated */
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(phba),
 			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
 			  phba->slim2p.virt, phba->slim2p.phys);
@@ -7176,7 +7175,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
 static int
 lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 {
-	int cfg_fcp_io_channel;
+	int io_channel;
 	uint32_t cpu;
 	uint32_t i = 0;
 	int fof_vectors = phba->cfg_fof ? 1 : 0;
@@ -7187,7 +7186,7 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	 */
 
 	/* Sanity check on HBA EQ parameters */
-	cfg_fcp_io_channel = phba->cfg_fcp_io_channel;
+	io_channel = phba->io_channel;
 
 	/* It doesn't make sense to have more io channels then online CPUs */
 	for_each_present_cpu(cpu) {
@@ -7198,38 +7197,30 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
 	phba->sli4_hba.curr_disp_cpu = 0;
 
-	if (i < cfg_fcp_io_channel) {
+	if (i < io_channel) {
 		lpfc_printf_log(phba,
 				KERN_ERR, LOG_INIT,
 				"3188 Reducing IO channels to match number of "
 				"online CPUs: from %d to %d\n",
-				cfg_fcp_io_channel, i);
-		cfg_fcp_io_channel = i;
+				io_channel, i);
+		io_channel = i;
 	}
 
-	if (cfg_fcp_io_channel + fof_vectors >
+	if (io_channel + fof_vectors >
 	    phba->sli4_hba.max_cfg_param.max_eq) {
-		if (phba->sli4_hba.max_cfg_param.max_eq <
-		    LPFC_FCP_IO_CHAN_MIN) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2574 Not enough EQs (%d) from the "
-					"pci function for supporting FCP "
-					"EQs (%d)\n",
-					phba->sli4_hba.max_cfg_param.max_eq,
-					phba->cfg_fcp_io_channel);
-			goto out_error;
-		}
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2575 Reducing IO channels to match number of "
 				"available EQs: from %d to %d\n",
-				cfg_fcp_io_channel,
+				io_channel,
 				phba->sli4_hba.max_cfg_param.max_eq);
-		cfg_fcp_io_channel = phba->sli4_hba.max_cfg_param.max_eq -
-			fof_vectors;
+		io_channel = phba->sli4_hba.max_cfg_param.max_eq - fof_vectors;
 	}
 
-	/* The actual number of FCP event queues adopted */
-	phba->cfg_fcp_io_channel = cfg_fcp_io_channel;
+	/* The actual number of FCP / NVME event queues adopted */
+	if (phba->cfg_fcp_io_channel > io_channel)
+		phba->cfg_fcp_io_channel = io_channel;
+	if (phba->cfg_nvme_io_channel > io_channel)
+		phba->cfg_nvme_io_channel = io_channel;
 
 	/* Get EQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
@@ -7240,8 +7231,6 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
 
 	return 0;
-out_error:
-	return -ENOMEM;
 }
 
 /**
@@ -7262,12 +7251,14 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
-	int idx;
+	int idx, io_channel;
 
 	/*
 	 * Create HBA Record arrays.
+	 * Both NVME and FCP will share that same vectors / EQs
 	 */
-	if (!phba->cfg_fcp_io_channel)
+	io_channel = phba->io_channel;
+	if (!io_channel)
 		return -ERANGE;
 
 	phba->sli4_hba.mq_esize = LPFC_MQE_SIZE;
@@ -7278,7 +7269,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	phba->sli4_hba.rq_ecount = LPFC_RQE_DEF_COUNT;
 
 	phba->sli4_hba.hba_eq =  kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
+				io_channel), GFP_KERNEL);
 	if (!phba->sli4_hba.hba_eq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2576 Failed allocate memory for "
@@ -7295,9 +7286,20 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 
-	phba->sli4_hba.fcp_wq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_wq) {
+	if (phba->cfg_nvme_io_channel) {
+		phba->sli4_hba.nvme_cq = kzalloc((sizeof(struct lpfc_queue *) *
+					phba->cfg_nvme_io_channel), GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
+	}
+
+	phba->sli4_hba.hba_wq = kzalloc((sizeof(struct lpfc_queue *) *
+				io_channel), GFP_KERNEL);
+	if (!phba->sli4_hba.hba_wq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2578 Failed allocate memory for fast-path "
 				"WQ record array\n");
@@ -7319,10 +7321,27 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	}
 
 	/*
-	 * Create HBA Event Queues (EQs).  The cfg_fcp_io_channel specifies
+	 * Since the first EQ can have multiple CQs associated with it,
+	 * this array is used to quickly see if we have a NVME fast-path
+	 * CQ match.
+	 */
+	if (phba->cfg_nvme_io_channel) {
+		phba->sli4_hba.nvme_cq_map = kzalloc(
+			(sizeof(uint16_t) * phba->cfg_nvme_io_channel),
+			GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
+	}
+
+	/*
+	 * Create HBA Event Queues (EQs).  The io_channel specifies
 	 * how many EQs to create.
 	 */
-	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+	for (idx = 0; idx < io_channel; idx++) {
 
 		/* Create EQs */
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
@@ -7345,8 +7364,24 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		}
 		phba->sli4_hba.fcp_cq[idx] = qdesc;
 
+		if (phba->cfg_nvme_io_channel) {
+			/* Create Fast Path NVME CQs */
+			qdesc = lpfc_sli4_queue_alloc(
+					phba,
+					phba->sli4_hba.cq_esize,
+					phba->sli4_hba.cq_ecount);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"9999 Failed allocate "
+						"fast-path NVME CQ (%d)\n",
+						idx);
+				goto out_error;
+			}
+			phba->sli4_hba.nvme_cq[idx] = qdesc;
+		}
+
 		/* Create Fast Path FCP WQs */
-		if (phba->fcp_embed_io) {
+		if (phba->fcp_embed_io || phba->nvme_support) {
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      LPFC_WQE128_SIZE,
 						      LPFC_WQE128_DEF_COUNT);
@@ -7361,7 +7396,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 					"WQ (%d)\n", idx);
 			goto out_error;
 		}
-		phba->sli4_hba.fcp_wq[idx] = qdesc;
+		phba->sli4_hba.hba_wq[idx] = qdesc;
 	}
 
 
@@ -7389,6 +7424,16 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	}
 	phba->sli4_hba.els_cq = qdesc;
 
+	/* Create NVME LS Complete Queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+				      phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"9999 Failed allocate NVME LS CQ\n");
+		goto out_error;
+	}
+	phba->sli4_hba.nvmels_cq = qdesc;
+
 
 	/*
 	 * Create Slow Path Work Queues (WQs)
@@ -7419,6 +7464,16 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	}
 	phba->sli4_hba.els_wq = qdesc;
 
+	/* Create slow-path ELS Work Queue */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
+				      phba->sli4_hba.wq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"9999 Failed allocate NVME LS WQ\n");
+		goto out_error;
+	}
+	phba->sli4_hba.nvmels_wq = qdesc;
+
 	/*
 	 * Create Receive Queue (RQ)
 	 */
@@ -7475,7 +7530,7 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 
 	if (phba->sli4_hba.hba_eq != NULL) {
 		/* Release HBA event queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+		for (idx = 0; idx < phba->io_channel; idx++) {
 			if (phba->sli4_hba.hba_eq[idx] != NULL) {
 				lpfc_sli4_queue_free(
 					phba->sli4_hba.hba_eq[idx]);
@@ -7499,17 +7554,30 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_cq = NULL;
 	}
 
-	if (phba->sli4_hba.fcp_wq != NULL) {
+	if (phba->sli4_hba.nvme_cq != NULL) {
+		/* Release NVME completion queue */
+		for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++) {
+			if (phba->sli4_hba.nvme_cq[idx] != NULL) {
+				lpfc_sli4_queue_free(
+					phba->sli4_hba.nvme_cq[idx]);
+				phba->sli4_hba.nvme_cq[idx] = NULL;
+			}
+		}
+		kfree(phba->sli4_hba.nvme_cq);
+		phba->sli4_hba.nvme_cq = NULL;
+	}
+
+	if (phba->sli4_hba.hba_wq != NULL) {
 		/* Release FCP work queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.fcp_wq[idx] != NULL) {
+		for (idx = 0; idx < phba->io_channel; idx++) {
+			if (phba->sli4_hba.hba_wq[idx] != NULL) {
 				lpfc_sli4_queue_free(
-					phba->sli4_hba.fcp_wq[idx]);
-				phba->sli4_hba.fcp_wq[idx] = NULL;
+					phba->sli4_hba.hba_wq[idx]);
+				phba->sli4_hba.hba_wq[idx] = NULL;
 			}
 		}
-		kfree(phba->sli4_hba.fcp_wq);
-		phba->sli4_hba.fcp_wq = NULL;
+		kfree(phba->sli4_hba.hba_wq);
+		phba->sli4_hba.hba_wq = NULL;
 	}
 
 	/* Release FCP CQ mapping array */
@@ -7518,6 +7586,12 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_cq_map = NULL;
 	}
 
+	/* Release NVME CQ mapping array */
+	if (phba->sli4_hba.nvme_cq_map != NULL) {
+		kfree(phba->sli4_hba.nvme_cq_map);
+		phba->sli4_hba.nvme_cq_map = NULL;
+	}
+
 	/* Release mailbox command work queue */
 	if (phba->sli4_hba.mbx_wq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.mbx_wq);
@@ -7530,6 +7604,12 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.els_wq = NULL;
 	}
 
+	/* Release ELS work queue */
+	if (phba->sli4_hba.nvmels_wq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmels_wq);
+		phba->sli4_hba.nvmels_wq = NULL;
+	}
+
 	/* Release unsolicited receive queue */
 	if (phba->sli4_hba.hdr_rq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
@@ -7546,6 +7626,12 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.els_cq = NULL;
 	}
 
+	/* Release NVME LS complete queue */
+	if (phba->sli4_hba.nvmels_cq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmels_cq);
+		phba->sli4_hba.nvmels_cq = NULL;
+	}
+
 	/* Release mailbox command complete queue */
 	if (phba->sli4_hba.mbx_cq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.mbx_cq);
@@ -7572,13 +7658,14 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *wcq;
 	int rc = -ENOMEM;
-	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
+	int hba_eqidx, fcp_cqidx, nvme_cqidx, hba_wqidx;
 	int fcp_cq_index = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	LPFC_MBOXQ_t *mboxq;
-	uint32_t length;
+	uint32_t length, io_channel;
 
 	/* Check for dual-ULP support */
 	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -7628,35 +7715,84 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	/*
 	 * Set up HBA Event Queues (EQs)
 	 */
+	io_channel = phba->io_channel;
 
 	/* Set up HBA event queue */
-	if (phba->cfg_fcp_io_channel && !phba->sli4_hba.hba_eq) {
+	if (io_channel && !phba->sli4_hba.hba_eq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3147 Fast-path EQs not allocated\n");
 		rc = -ENOMEM;
 		goto out_error;
 	}
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel; fcp_eqidx++) {
-		if (!phba->sli4_hba.hba_eq[fcp_eqidx]) {
+	for (hba_eqidx = 0; hba_eqidx < io_channel; hba_eqidx++) {
+		if (!phba->sli4_hba.hba_eq[hba_eqidx]) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0522 Fast-path EQ (%d) not "
-					"allocated\n", fcp_eqidx);
+					"allocated\n", hba_eqidx);
 			rc = -ENOMEM;
 			goto out_destroy_hba_eq;
 		}
-		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[fcp_eqidx],
-			 (phba->cfg_fcp_imax / phba->cfg_fcp_io_channel));
+		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[hba_eqidx],
+			 (phba->cfg_fcp_imax / io_channel));
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0523 Failed setup of fast-path EQ "
-					"(%d), rc = 0x%x\n", fcp_eqidx,
+					"(%d), rc = 0x%x\n", hba_eqidx,
 					(uint32_t)rc);
 			goto out_destroy_hba_eq;
 		}
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2584 HBA EQ setup: "
-				"queue[%d]-id=%d\n", fcp_eqidx,
-				phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id);
+				"2584 HBA EQ setup: queue[%d]-id=%d\n",
+				hba_eqidx,
+				phba->sli4_hba.hba_eq[hba_eqidx]->queue_id);
+	}
+
+	nvme_cqidx = 0;
+	if (phba->cfg_nvme_io_channel) {
+		/* Set up fast-path NVME Response Complete Queue */
+		if (!phba->sli4_hba.nvme_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Fast-path NVME CQ array not "
+					"allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy_hba_eq;
+		}
+
+		for (nvme_cqidx = 0; nvme_cqidx < phba->cfg_nvme_io_channel;
+		     nvme_cqidx++) {
+			if (!phba->sli4_hba.nvme_cq[nvme_cqidx]) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"9999 Fast-path NVME CQ (%d) "
+						"not allocated\n", nvme_cqidx);
+				rc = -ENOMEM;
+				goto out_destroy_nvme_cq;
+			}
+			rc = lpfc_cq_create(
+				phba, phba->sli4_hba.nvme_cq[nvme_cqidx],
+				phba->sli4_hba.hba_eq[nvme_cqidx],
+				LPFC_WCQ, LPFC_NVME);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"9999 Failed setup of NVME CQ "
+						"(%d), rc = 0x%x\n", nvme_cqidx,
+						(uint32_t)rc);
+				goto out_destroy_nvme_cq;
+			}
+
+			/* Setup nvme_cq_map for fast lookup */
+			phba->sli4_hba.nvme_cq_map[nvme_cqidx] =
+				phba->sli4_hba.nvme_cq[nvme_cqidx]->queue_id;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"9999 NVME CQ setup: cq[%d]-id=%d, "
+					"parent seq[%d]-id=%d\n",
+					nvme_cqidx,
+					phba->sli4_hba.nvme_cq[
+							nvme_cqidx]->queue_id,
+					nvme_cqidx,
+					phba->sli4_hba.hba_eq[
+							nvme_cqidx]->queue_id);
+		}
 	}
 
 	/* Set up fast-path FCP Response Complete Queue */
@@ -7665,7 +7801,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 				"3148 Fast-path FCP CQ array not "
 				"allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_hba_eq;
+		goto out_destroy_nvme_cq;
 	}
 
 	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++) {
@@ -7700,7 +7836,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	}
 
 	/* Set up fast-path FCP Work Queue */
-	if (!phba->sli4_hba.fcp_wq) {
+	if (!phba->sli4_hba.hba_wq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3149 Fast-path FCP WQ array not "
 				"allocated\n");
@@ -7708,37 +7844,47 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		goto out_destroy_fcp_cq;
 	}
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++) {
-		if (!phba->sli4_hba.fcp_wq[fcp_wqidx]) {
+	for (hba_wqidx = 0; hba_wqidx < io_channel; hba_wqidx++) {
+		if (!phba->sli4_hba.hba_wq[hba_wqidx]) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0534 Fast-path FCP WQ (%d) not "
-					"allocated\n", fcp_wqidx);
+					"allocated\n", hba_wqidx);
 			rc = -ENOMEM;
-			goto out_destroy_fcp_wq;
+			goto out_destroy_hba_wq;
 		}
-		rc = lpfc_wq_create(phba, phba->sli4_hba.fcp_wq[fcp_wqidx],
-				    phba->sli4_hba.fcp_cq[fcp_wqidx],
-				    LPFC_FCP);
+		if (hba_wqidx < phba->cfg_fcp_io_channel)
+			wcq = phba->sli4_hba.fcp_cq[hba_wqidx];
+		else if (hba_wqidx < phba->cfg_nvme_io_channel)
+			wcq = phba->sli4_hba.nvme_cq[hba_wqidx];
+		else {
+			rc = -ERANGE;
+			goto out_destroy_hba_wq;
+		}
+		rc = lpfc_wq_create(phba, phba->sli4_hba.hba_wq[hba_wqidx],
+				    wcq, LPFC_FCP);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0535 Failed setup of fast-path FCP "
-					"WQ (%d), rc = 0x%x\n", fcp_wqidx,
+					"WQ (%d), rc = 0x%x\n", hba_wqidx,
 					(uint32_t)rc);
-			goto out_destroy_fcp_wq;
+			goto out_destroy_hba_wq;
 		}
 
 		/* Bind this WQ to the next FCP ring */
-		pring = &psli->ring[MAX_SLI3_CONFIGURED_RINGS + fcp_wqidx];
-		pring->sli.sli4.wqp = (void *)phba->sli4_hba.fcp_wq[fcp_wqidx];
-		phba->sli4_hba.fcp_cq[fcp_wqidx]->pring = pring;
+		pring = &psli->ring[MAX_SLI3_CONFIGURED_RINGS + hba_wqidx];
+		pring->sli.sli4.wqp = (void *)phba->sli4_hba.hba_wq[hba_wqidx];
+		if (hba_wqidx < phba->cfg_fcp_io_channel)
+			phba->sli4_hba.fcp_cq[hba_wqidx]->pring = pring;
+		if (hba_wqidx < phba->cfg_nvme_io_channel)
+			phba->sli4_hba.nvme_cq[hba_wqidx]->pring = pring;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"2591 FCP WQ setup: wq[%d]-id=%d, "
 				"parent cq[%d]-id=%d\n",
-				fcp_wqidx,
-				phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
+				hba_wqidx,
+				phba->sli4_hba.hba_wq[hba_wqidx]->queue_id,
 				fcp_cq_index,
-				phba->sli4_hba.fcp_cq[fcp_wqidx]->queue_id);
+				wcq->queue_id);
 	}
 	/*
 	 * Set up Complete Queues (CQs)
@@ -7749,7 +7895,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0528 Mailbox CQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_fcp_wq;
+		goto out_destroy_hba_wq;
 	}
 	rc = lpfc_cq_create(phba, phba->sli4_hba.mbx_cq,
 			phba->sli4_hba.hba_eq[0], LPFC_MCQ, LPFC_MBOX);
@@ -7757,7 +7903,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0529 Failed setup of slow-path mailbox CQ: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
+		goto out_destroy_hba_wq;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2585 MBX CQ setup: cq-id=%d, parent eq-id=%d\n",
@@ -7784,6 +7930,26 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			phba->sli4_hba.els_cq->queue_id,
 			phba->sli4_hba.hba_eq[0]->queue_id);
 
+	/* Set up NVME LS Complete Queue */
+	if (!phba->sli4_hba.nvmels_cq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"9999 ELS CQ not allocated\n");
+		rc = -ENOMEM;
+		goto out_destroy_els_cq;
+	}
+	rc = lpfc_cq_create(phba, phba->sli4_hba.nvmels_cq,
+			phba->sli4_hba.hba_eq[0], LPFC_WCQ, LPFC_NVME_LS);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"9999 Failed setup of NVME LS CQ: rc = 0x%x\n",
+				(uint32_t)rc);
+		goto out_destroy_els_cq;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"9999 NVME LS CQ setup: cq-id=%d, parent eq-id=%d\n",
+			phba->sli4_hba.nvmels_cq->queue_id,
+			phba->sli4_hba.hba_eq[0]->queue_id);
+
 	/*
 	 * Set up all the Work Queues (WQs)
 	 */
@@ -7793,7 +7959,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0538 Slow-path MQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_els_cq;
+		goto out_destroy_nvmels_cq;
 	}
 	rc = lpfc_mq_create(phba, phba->sli4_hba.mbx_wq,
 			    phba->sli4_hba.mbx_cq, LPFC_MBOX);
@@ -7801,7 +7967,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0539 Failed setup of slow-path MQ: "
 				"rc = 0x%x\n", rc);
-		goto out_destroy_els_cq;
+		goto out_destroy_nvmels_cq;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
@@ -7834,14 +8000,37 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			phba->sli4_hba.els_wq->queue_id,
 			phba->sli4_hba.els_cq->queue_id);
 
-	/*
-	 * Create Receive Queue (RQ)
-	 */
+	/* Set up NVME LS Work Queue */
+	if (!phba->sli4_hba.nvmels_wq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"9999 NVME LS WQ not allocated\n");
+		rc = -ENOMEM;
+		goto out_destroy_els_wq;
+	}
+	rc = lpfc_wq_create(phba, phba->sli4_hba.nvmels_wq,
+			    phba->sli4_hba.nvmels_cq, LPFC_NVME_LS);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"9999 Failed setup of NVME LS WQ: rc = 0x%x\n",
+				(uint32_t)rc);
+		goto out_destroy_els_wq;
+	}
+
+	/* Bind this WQ to the ELS ring */
+	pring = &psli->ring[LPFC_ELS_RING];
+	pring->sli.sli4.wqp = (void *)phba->sli4_hba.nvmels_wq;
+	phba->sli4_hba.nvmels_cq->pring = pring;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"9999 ELS WQ setup: wq-id=%d, parent cq-id=%d\n",
+			phba->sli4_hba.nvmels_wq->queue_id,
+			phba->sli4_hba.nvmels_cq->queue_id);
+
 	if (!phba->sli4_hba.hdr_rq || !phba->sli4_hba.dat_rq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0540 Receive Queue not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_els_wq;
+		goto out_destroy_nvmels_wq;
 	}
 
 	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
@@ -7853,7 +8042,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
+		goto out_destroy_nvmels_wq;
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -7877,30 +8066,37 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	 * Configure EQ delay multipier for interrupt coalescing using
 	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-			fcp_eqidx += LPFC_MAX_EQ_DELAY)
-		lpfc_modify_fcp_eq_delay(phba, fcp_eqidx);
+	for (hba_eqidx = 0; hba_eqidx < io_channel;
+			hba_eqidx += LPFC_MAX_EQ_DELAY)
+		lpfc_modify_hba_eq_delay(phba, hba_eqidx);
 	return 0;
 
 out_destroy_els_rq:
 	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
+out_destroy_nvmels_wq:
+	lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
 out_destroy_els_wq:
 	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
 out_destroy_mbx_wq:
 	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+out_destroy_nvmels_cq:
+	lpfc_cq_destroy(phba, phba->sli4_hba.nvmels_cq);
 out_destroy_els_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
 out_destroy_mbx_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
-out_destroy_fcp_wq:
-	for (--fcp_wqidx; fcp_wqidx >= 0; fcp_wqidx--)
-		lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_wqidx]);
+out_destroy_hba_wq:
+	for (--hba_wqidx; hba_wqidx >= 0; hba_wqidx--)
+		lpfc_wq_destroy(phba, phba->sli4_hba.hba_wq[hba_wqidx]);
 out_destroy_fcp_cq:
 	for (--fcp_cqidx; fcp_cqidx >= 0; fcp_cqidx--)
 		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_cqidx]);
+out_destroy_nvme_cq:
+	for (--nvme_cqidx; nvme_cqidx >= 0; nvme_cqidx--)
+		lpfc_cq_destroy(phba, phba->sli4_hba.nvme_cq[nvme_cqidx]);
 out_destroy_hba_eq:
-	for (--fcp_eqidx; fcp_eqidx >= 0; fcp_eqidx--)
-		lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_eqidx]);
+	for (--hba_eqidx; hba_eqidx >= 0; hba_eqidx--)
+		lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[hba_eqidx]);
 out_error:
 	return rc;
 }
@@ -7920,27 +8116,39 @@ out_error:
 void
 lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 {
-	int fcp_qidx;
+	int fcp_qidx, io_channel;
+
+	io_channel = phba->io_channel;
 
 	/* Unset the queues created for Flash Optimized Fabric operations */
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
 	/* Unset mailbox command work queue */
 	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+	/* Unset NVME LS work queue */
+	lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
 	/* Unset ELS work queue */
 	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
 	/* Unset unsolicited receive queue */
 	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
 	/* Unset FCP work queue */
-	if (phba->sli4_hba.fcp_wq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
+	if (phba->sli4_hba.hba_wq) {
+		for (fcp_qidx = 0; fcp_qidx < io_channel;
 		     fcp_qidx++)
-			lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_qidx]);
+			lpfc_wq_destroy(phba, phba->sli4_hba.hba_wq[fcp_qidx]);
 	}
 	/* Unset mailbox command complete queue */
 	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
 	/* Unset ELS complete queue */
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+	/* Unset NVME LS complete queue */
+	lpfc_cq_destroy(phba, phba->sli4_hba.nvmels_cq);
+	/* Unset NVME response complete queue */
+	if (phba->sli4_hba.nvme_cq) {
+		for (fcp_qidx = 0; fcp_qidx < phba->cfg_nvme_io_channel;
+		     fcp_qidx++)
+			lpfc_cq_destroy(phba, phba->sli4_hba.nvme_cq[fcp_qidx]);
+	}
 	/* Unset FCP response complete queue */
 	if (phba->sli4_hba.fcp_cq) {
 		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
@@ -7949,7 +8157,7 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 	}
 	/* Unset fast-path event queue */
 	if (phba->sli4_hba.hba_eq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
+		for (fcp_qidx = 0; fcp_qidx < io_channel;
 		     fcp_qidx++)
 			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_qidx]);
 	}
@@ -8783,11 +8991,12 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 	int i, idx, saved_chann, used_chann, cpu, phys_id;
 	int max_phys_id, min_phys_id;
 	int num_io_channel, first_cpu, chan;
+	int max_io_channel;
 	struct lpfc_vector_map_info *cpup;
 #ifdef CONFIG_X86
 	struct cpuinfo_x86 *cpuinfo;
 #endif
-	uint8_t chann[LPFC_FCP_IO_CHAN_MAX+1];
+	uint8_t chann[LPFC_HBA_IO_CHAN_MAX+1];
 
 	/* If there is no mapping, just return */
 	if (!phba->cfg_fcp_cpu_map)
@@ -8804,6 +9013,8 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 	num_io_channel = 0;
 	first_cpu = LPFC_VECTOR_MAP_EMPTY;
 
+	max_io_channel = phba->io_channel;
+
 	/* Update CPU map with physical id and core id of each CPU */
 	cpup = phba->sli4_hba.cpu_map;
 	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
@@ -8854,7 +9065,7 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 				cpup->channel_id = chan;
 				cpup++;
 				chan++;
-				if (chan >= phba->cfg_fcp_io_channel)
+				if (chan >= max_io_channel)
 					chan = 0;
 			}
 
@@ -8908,7 +9119,7 @@ found:
 		 * this phys_id, just round robin thru the io_channels.
 		 * Setup chann[] for round robin.
 		 */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		for (idx = 0; idx < max_io_channel; idx++)
 			chann[idx] = idx;
 
 		saved_chann = 0;
@@ -8931,7 +9142,7 @@ found:
 				 */
 				if (cpup->irq != LPFC_VECTOR_MAP_EMPTY) {
 					if (saved_chann <=
-					    LPFC_FCP_IO_CHAN_MAX) {
+					    LPFC_HBA_IO_CHAN_MAX) {
 						chann[saved_chann] =
 							cpup->channel_id;
 						saved_chann++;
@@ -8941,8 +9152,7 @@ found:
 
 				/* See if we are using round-robin */
 				if (saved_chann == 0)
-					saved_chann =
-						phba->cfg_fcp_io_channel;
+					saved_chann = max_io_channel;
 
 				/* Associate next IO channel with CPU */
 				cpup->channel_id = chann[used_chann];
@@ -9019,13 +9229,16 @@ static int
 lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
 	int vectors, rc, index;
+	int io_channel;
+
+	io_channel = phba->io_channel;
 
 	/* Set up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
+	for (index = 0; index < io_channel; index++)
 		phba->sli4_hba.msix_entries[index].entry = index;
 
 	/* Configure MSI-X capability structure */
-	vectors = phba->cfg_fcp_io_channel;
+	vectors = io_channel;
 	if (phba->cfg_fof) {
 		phba->sli4_hba.msix_entries[index].entry = index;
 		vectors++;
@@ -9054,21 +9267,21 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			 LPFC_SLI4_HANDLER_NAME_SZ,
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-		atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].fcp_eq_in_use, 1);
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+		atomic_set(&phba->sli4_hba.hba_eq_hdl[index].hba_eq_in_use, 1);
 		if (phba->cfg_fof && (index == (vectors - 1)))
 			rc = request_irq(
 				phba->sli4_hba.msix_entries[index].vector,
 				 &lpfc_sli4_fof_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		else
 			rc = request_irq(
 				phba->sli4_hba.msix_entries[index].vector,
 				 &lpfc_sli4_hba_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
@@ -9080,12 +9293,19 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	if (phba->cfg_fof)
 		vectors--;
 
-	if (vectors != phba->cfg_fcp_io_channel) {
+	if (vectors != io_channel) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3238 Reducing IO channels to match number of "
 				"MSI-X vectors, requested %d got %d\n",
 				phba->cfg_fcp_io_channel, vectors);
-		phba->cfg_fcp_io_channel = vectors;
+		if (phba->cfg_fcp_io_channel > vectors)
+			phba->cfg_fcp_io_channel = vectors;
+		if (phba->cfg_nvme_io_channel > vectors)
+			phba->cfg_nvme_io_channel = vectors;
+		if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+			phba->io_channel = phba->cfg_fcp_io_channel;
+		else
+			phba->io_channel = phba->cfg_nvme_io_channel;
 	}
 
 	if (!shost_use_blk_mq(lpfc_shost_from_vport(phba->pport)))
@@ -9098,7 +9318,7 @@ cfg_fail_out:
 		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
 					  vector, NULL);
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+			 &phba->sli4_hba.hba_eq_hdl[index]);
 	}
 
 	/* Unconfigure MSI-X capability structure */
@@ -9121,15 +9341,15 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
 	int index;
 
 	/* Free up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
+	for (index = 0; index < phba->io_channel; index++) {
 		irq_set_affinity_hint(phba->sli4_hba.msix_entries[index].
 					  vector, NULL);
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+			 &phba->sli4_hba.hba_eq_hdl[index]);
 	}
 	if (phba->cfg_fof) {
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+			 &phba->sli4_hba.hba_eq_hdl[index]);
 	}
 	/* Disable MSI-X */
 	pci_disable_msix(phba->pcidev);
@@ -9175,14 +9395,14 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 		return rc;
 	}
 
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+	for (index = 0; index < phba->io_channel; index++) {
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
 	}
 
 	if (phba->cfg_fof) {
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
 	}
 	return 0;
 }
@@ -9259,18 +9479,17 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			/* Indicate initialization to INTx mode */
 			phba->intr_type = INTx;
 			intr_mode = 0;
-			for (index = 0; index < phba->cfg_fcp_io_channel;
-			     index++) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+			for (index = 0; index < phba->io_channel; index++) {
+				phba->sli4_hba.hba_eq_hdl[index].idx = index;
+				phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+				atomic_set(&phba->sli4_hba.hba_eq_hdl[index].
+					hba_eq_in_use, 1);
 			}
 			if (phba->cfg_fof) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+				phba->sli4_hba.hba_eq_hdl[index].idx = index;
+				phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+				atomic_set(&phba->sli4_hba.hba_eq_hdl[index].
+					hba_eq_in_use, 1);
 			}
 		}
 	}
@@ -9594,6 +9813,23 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 					   mbx_sli4_parameters);
 	phba->sli4_hba.extents_in_use = bf_get(cfg_ext, mbx_sli4_parameters);
 	phba->sli4_hba.rpi_hdrs_in_use = bf_get(cfg_hdrr, mbx_sli4_parameters);
+	phba->nvme_support = bf_get(cfg_nvme, mbx_sli4_parameters);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_NVME,
+			"9999 NVME embedded IO support: %d\n",
+			phba->nvme_support);
+
+	if ((phba->cfg_enable_fc4_type != LPFC_ENABLE_FCP) &&
+	    !phba->nvme_support) {
+		/* If firmware doesn't support NVME, just use SCSI support */
+		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
+		phba->cfg_nvme_io_channel = 0;
+		phba->io_channel = phba->cfg_fcp_io_channel;
+
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_NVME,
+				"9999 Disabling NVME support: "
+				"Not supported by firmware\n");
+	}
 
 	/* Make sure that sge_supp_len can be handled by the driver */
 	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
@@ -9609,6 +9845,10 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->fcp_embed_io = 0;
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_FCP,
+			"9999 FCP embedded IO support: %d\n",
+			phba->fcp_embed_io);
+
 	/*
 	 * Check if the SLI port supports MDS Diagnostics
 	 */
@@ -9873,7 +10113,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	lpfc_scsi_free(phba);
 	lpfc_mem_free_all(phba);
 
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(phba),
 			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 
 	/* Free resources associated with SLI2 interface */
@@ -10231,22 +10471,26 @@ int
 lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
 {
 	int max_xri = phba->sli4_hba.max_cfg_param.max_xri;
+	int i;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (max_xri <= 100)
-			return 10;
+			i = 10;
 		else if (max_xri <= 256)
-			return 25;
+			i = 25;
 		else if (max_xri <= 512)
-			return 50;
+			i = 50;
 		else if (max_xri <= 1024)
-			return 100;
+			i = 100;
 		else if (max_xri <= 1536)
-			return 150;
+			i = 150;
 		else if (max_xri <= 2048)
-			return 200;
+			i = 200;
 		else
-			return 250;
+			i = 250;
+
+		return i;
+
 	} else
 		return 0;
 }
@@ -10533,6 +10777,19 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
+	/* Don't rely on nvme_io_channels.  They are always set
+	 * nonzero from a module parameter view but are not activated
+	 * unless the fc4 type is enabled.
+	 */
+	if (phba->cfg_enable_nvmet == NVME_TARGET_OFF &&
+	    ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+	     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME))) {
+		/* Create NVME binding with nvme_fc_transport. This
+		 * ensures the vport is initialized.
+		 */
+		/* TODO: bind with nvme layer */
+	}
+
 	/* check for firmware upgrade or downgrade */
 	if (phba->cfg_request_firmware_upgrade)
 		lpfc_sli4_request_firmware_update(phba, INT_FW_UPGRADE);
@@ -10600,9 +10857,16 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
+	if (phba->cfg_nvme_io_channel) {
+		/* TODO: unbind with nvme layer */
+		/* The nvme pointer is invalid post call. */
+		vport->pnvme = NULL;
+	}
+
 	/* Remove FC host and then SCSI host with the physical port */
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
+	/* TODO: unbind with nvmet layer */
 
 	/* Perform cleanup on the physical port */
 	lpfc_cleanup(vport);
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 2a4e5d2..531ba4d 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -38,6 +38,7 @@
 #define LOG_FIP		0x00020000	/* FIP events */
 #define LOG_FCP_UNDER	0x00040000	/* FCP underruns errors */
 #define LOG_SCSI_CMD	0x00080000	/* ALL SCSI commands */
+#define LOG_NVME	0x00100000	/* All NVME events. */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 12dbe99..8c7676b 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1291,7 +1291,7 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			mb->un.varCfgPort.cdss = 1; /* Configure Security */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
-		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
+		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count(phba);
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
 			mb->un.varCfgPort.max_vpi = LPFC_MAX_VPI;
@@ -2434,8 +2434,11 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 	memset(mbox, 0, sizeof(*mbox));
 	reg_fcfi = &mbox->u.mqe.un.reg_fcfi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_FCFI);
-	bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi, phba->sli4_hba.hdr_rq->queue_id);
-	bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+	if (phba->cfg_enable_nvmet == NVME_TARGET_OFF) {
+		bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi,
+		       phba->sli4_hba.hdr_rq->queue_id);
+		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+	}
 	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_info_index, reg_fcfi,
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 3fa6533..7397ab6 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -26,7 +26,6 @@
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
-
 #include <scsi/scsi.h>
 
 #include "lpfc_hw4.h"
@@ -170,12 +169,15 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 					LPFC_DEVICE_DATA_POOL_SIZE,
 					sizeof(struct lpfc_device_data));
 		if (!phba->device_data_mem_pool)
-			goto fail_free_hrb_pool;
+			goto fail_free_drb_pool;
 	} else {
 		phba->device_data_mem_pool = NULL;
 	}
 
 	return 0;
+fail_free_drb_pool:
+	pci_pool_destroy(phba->lpfc_drb_pool);
+	phba->lpfc_drb_pool = NULL;
  fail_free_hrb_pool:
 	pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
@@ -458,7 +460,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 		kfree(hbqbp);
 		return NULL;
 	}
-	hbqbp->size = LPFC_BPL_SIZE;
+	hbqbp->total_size = LPFC_BPL_SIZE;
 	return hbqbp;
 }
 
@@ -518,7 +520,7 @@ lpfc_sli4_rb_alloc(struct lpfc_hba *phba)
 		kfree(dma_buf);
 		return NULL;
 	}
-	dma_buf->size = LPFC_BPL_SIZE;
+	dma_buf->total_size = LPFC_DATA_BUF_SIZE;
 	return dma_buf;
 }
 
@@ -565,13 +567,13 @@ lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 		return;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		/* Check whether HBQ is still in use */
 		spin_lock_irqsave(&phba->hbalock, flags);
 		if (!phba->hbq_in_use) {
 			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return;
 		}
-		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		list_del(&hbq_entry->dbuf.list);
 		if (hbq_entry->tag == -1) {
 			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 56a3df4..df6de54 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -29,6 +29,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -36,6 +38,7 @@
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
@@ -720,11 +723,19 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
-	if (npr->prliType == PRLI_FCP_TYPE) {
-		if (npr->initiatorFunc)
-			ndlp->nlp_type |= NLP_FCP_INITIATOR;
+	if ((npr->prliType == PRLI_FCP_TYPE) ||
+	    (npr->prliType == PRLI_NVME_TYPE)) {
+		if (npr->initiatorFunc) {
+			if (npr->prliType == PRLI_FCP_TYPE)
+				ndlp->nlp_type |= NLP_FCP_INITIATOR;
+			if (npr->prliType == PRLI_NVME_TYPE)
+				ndlp->nlp_type |= NLP_NVME_INITIATOR;
+		}
 		if (npr->targetFunc) {
-			ndlp->nlp_type |= NLP_FCP_TARGET;
+			if (npr->prliType == PRLI_FCP_TYPE)
+				ndlp->nlp_type |= NLP_FCP_TARGET;
+			if (npr->prliType == PRLI_NVME_TYPE)
+				ndlp->nlp_type |= NLP_NVME_TARGET;
 			if (npr->writeXferRdyDis)
 				ndlp->nlp_flag |= NLP_FIRSTBURST;
 		}
@@ -1573,9 +1584,12 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 				  uint32_t evt)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_nvme_lport *lport;
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
 	MAILBOX_t *mb = &pmb->u.mb;
 	uint32_t did  = mb->un.varWords[1];
+	int rc = 0;
 
 	if (mb->mbxStatus) {
 		/* RegLogin failed */
@@ -1610,17 +1624,54 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 	}
 
 	/* SLI4 ports have preallocated logical rpis. */
-	if (vport->phba->sli_rev < LPFC_SLI_REV4)
+	if (phba->sli_rev < LPFC_SLI_REV4)
 		ndlp->nlp_rpi = mb->un.varWords[0];
 
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 
 	/* Only if we are not a fabric nport do we issue PRLI */
-	if (!(ndlp->nlp_type & NLP_FABRIC)) {
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "3066 RegLogin Complete on x%x x%x x%x\n",
+			 did, ndlp->nlp_type, ndlp->nlp_fc4_type);
+	if (!(ndlp->nlp_type & NLP_FABRIC) &&
+	    (phba->cfg_enable_nvmet == NVME_TARGET_OFF)) {
+		/* The driver supports FCP and NVME concurrently.  If the
+		 * ndlp's nlp_fc4_type is still zero, the driver doesn't
+		 * know what PRLI to send yet.  Figure that out now and
+		 * call PRLI depending on the outcome.
+		 */
+		if (vport->fc_flag & FC_PT2PT) {
+			/* If we are pt2pt, there is no Fabric to determine
+			 * the FC4 type of the remote nport. So if NVME
+			 * is configured try it.
+			 */
+			ndlp->nlp_fc4_type |= NLP_FC4_FCP;
+			if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+			     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
+				lport = list_get_first(
+					&vport->pnvme->lport_list,
+					struct lpfc_nvme_lport, list);
+				/* We need to update the localport also */
+				lport->localport->fabric_name =
+					wwn_to_u64(vport->fc_portname.u.wwn);
+				lport->localport->port_role =
+					FC_PORT_ROLE_NVME_INITIATOR;
+				lport->localport->port_id = vport->fc_myDID;
+
+			}
+
+		} else if (ndlp->nlp_fc4_type == 0) {
+			rc = lpfc_ns_cmd(vport, SLI_CTNS_GFT_ID,
+					 0, ndlp->nlp_DID);
+			return ndlp->nlp_state;
+		}
+
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else {
+		/* TODO: if pt2pt and NVME, bind with nvmet layer */
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
@@ -1739,10 +1790,23 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_hba   *phba = vport->phba;
 	IOCB_t *irsp;
 	PRLI *npr;
+	struct lpfc_nvme_prli *nvpr;
+	void *temp_ptr;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
-	npr = (PRLI *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
+
+	/* A solicited PRLI is either FCP or NVME.  The PRLI cmd/rsp
+	 * format is different so NULL the two PRLI types so that the
+	 * driver correctly gets the correct context.
+	 */
+	npr = NULL;
+	nvpr = NULL;
+	temp_ptr = lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
+	if (cmdiocb->iocb_flag & LPFC_PRLI_FCP_REQ)
+		npr = (PRLI *) temp_ptr;
+	else if (cmdiocb->iocb_flag & LPFC_PRLI_NVME_REQ)
+		nvpr = (struct lpfc_nvme_prli *) temp_ptr;
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
@@ -1750,7 +1814,21 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    vport->cfg_restrict_login) {
 			goto out;
 		}
+
+		/* The LS Req had some error.  Don't let this be a
+		 * target.
+		 */
+		if ((ndlp->fc4_prli_sent == 1) &&
+		    (ndlp->nlp_state == NLP_STE_PRLI_ISSUE) &&
+		    (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_FCP_INITIATOR)))
+			/* The FCP PRLI completed successfully but
+			 * the NVME PRLI failed.  Since they are sent in
+			 * succession, allow the FCP to complete.
+			 */
+			goto out_err;
+
 		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
+		ndlp->nlp_type |= NLP_FCP_INITIATOR;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 		return ndlp->nlp_state;
 	}
@@ -1759,8 +1837,12 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
-	if ((npr->acceptRspCode == PRLI_REQ_EXECUTED) &&
+	if (npr && (npr->acceptRspCode == PRLI_REQ_EXECUTED) &&
 	    (npr->prliType == PRLI_FCP_TYPE)) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+				 "6028 FCP NPR PRLI Cmpl Init %d Target %d\n",
+				 npr->initiatorFunc,
+				 npr->targetFunc);
 		if (npr->initiatorFunc)
 			ndlp->nlp_type |= NLP_FCP_INITIATOR;
 		if (npr->targetFunc) {
@@ -1770,6 +1852,33 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		if (npr->Retry)
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
+
+		/* PRLI completed.  Decrement count. */
+		ndlp->fc4_prli_sent--;
+	} else if (nvpr &&
+		   (bf_get_be32(prli_type_code, nvpr)) == PRLI_NVME_TYPE) {
+		/* NVME is the word-based structure define.  Flip byte mode. */
+		/* NVME PRLI has no PRLI_EXECUTED status.  Just proceed. */
+
+		if (bf_get_be32(prli_init, nvpr))
+			ndlp->nlp_type |= NLP_NVME_INITIATOR;
+
+		if (bf_get_be32(prli_tgt, nvpr)) {
+			ndlp->nlp_type |= NLP_NVME_TARGET;
+			if (bf_get(prli_fba, nvpr))
+				ndlp->nlp_flag |= NLP_FIRSTBURST;
+		}
+
+		if (bf_get_be32(prli_retry, nvpr))
+			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+				 "6029 NVME PRLI Cmpl word 0 x%08x "
+				 "word 4 x%08x flag x%x, fcp_info %d\n",
+				 nvpr->word1, nvpr->word4,
+				 ndlp->nlp_flag, ndlp->nlp_fcp_info);
+		/* PRLI completed.  Decrement count. */
+		ndlp->fc4_prli_sent--;
 	}
 	if (!(ndlp->nlp_type & NLP_FCP_TARGET) &&
 	    (vport->port_type == LPFC_NPIV_PORT) &&
@@ -1785,11 +1894,24 @@ out:
 		return ndlp->nlp_state;
 	}
 
-	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
-	if (ndlp->nlp_type & NLP_FCP_TARGET)
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
-	else
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+out_err:
+	/* The ndlp state cannot move to MAPPED or UNMAPPED before all PRLIs
+	 * are complete.
+	 */
+	if (ndlp->fc4_prli_sent == 0) {
+		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
+		if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET))
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
+		else
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+	} else
+		lpfc_printf_vlog(vport,
+				 KERN_INFO, LOG_ELS,
+				 "3067 PRLI's still outstanding "
+				 "on x%06x - count %d, Pend Node Mode "
+				 "transition...\n",
+				 ndlp->nlp_DID, ndlp->fc4_prli_sent);
+
 	return ndlp->nlp_state;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
new file mode 100644
index 0000000..2755dd9
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -0,0 +1,62 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
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
+ ********************************************************************/
+
+enum nvme_conn_state {
+	LPFC_NVME_CONN_ERR     =  0,    /* Connections have error */
+	LPFC_NVME_CONN_NONE    =  1,    /* No connections available */
+	LPFC_NVME_IN_PROGRESS  =  6,    /* Connections in progress */
+	LPFC_NVME_CONN_RDY     =  7     /* Connections ready for IO */
+};
+
+enum nvme_state {
+	LPFC_NVME_INIT    =   0,   /* NVME Struct alloc and initialize */
+	LPFC_NVME_REG     =   1,   /* NVME driver inst reg'd with OS */
+	LPFC_NVME_READY   =   2,   /* NVME instance ready for connections */
+	LPFC_NVME_ERROR   =   3    /* NVME instance in error */
+};
+
+struct lpfc_nvme_qhandle {
+	uint32_t cpu_id;
+	uint32_t wq_id;
+};
+
+struct lpfc_nvme {
+	struct lpfc_vport *vport;
+	enum nvme_conn_state lpfc_nvme_conn_state;
+	enum nvme_state lpfc_nvme_state;
+	struct list_head lport_list;
+};
+
+/* Declare nvme-based local and remote port definitions. */
+struct lpfc_nvme_lport {
+	struct list_head list;
+	struct lpfc_nvme *pnvme;
+	struct nvme_fc_local_port *localport;
+	struct list_head rport_list;
+};
+
+struct lpfc_nvme_rport {
+	struct list_head list;
+	struct lpfc_nvme_lport *lport;
+	struct nvme_fc_remote_port *remoteport;
+	struct lpfc_nodelist *ndlp;
+};
+
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a5655d5..8823475 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -923,7 +923,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		phba->sli4_hba.scsi_xri_cnt++;
 		spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_BG,
+	lpfc_printf_log(phba, KERN_INFO, LOG_BG | LOG_FCP,
 			"3021 Allocate %d out of %d requested new SCSI "
 			"buffers\n", bcnt, num_to_alloc);
 
@@ -949,7 +949,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
  *   int - number of scsi buffers that were allocated.
  *   0 = failure, less than num_to_alloc is a partial failure.
  **/
-static inline int
+int
 lpfc_new_scsi_buf(struct lpfc_vport *vport, int num_to_alloc)
 {
 	return vport->phba->lpfc_new_scsi_buf(vport, num_to_alloc);
@@ -1048,7 +1048,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
  *   NULL - Error
  *   Pointer to lpfc_scsi_buf - Success
  **/
-static struct lpfc_scsi_buf*
+struct lpfc_scsi_buf*
 lpfc_get_scsi_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	return  phba->lpfc_get_scsi_buf(phba, ndlp);
@@ -1122,7 +1122,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
  * This routine releases @psb scsi buffer by adding it to tail of @phba
  * lpfc_scsi_buf_list list.
  **/
-static void
+void
 lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 {
 
@@ -4769,7 +4769,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	icmd->ulpClass = cmd->ulpClass;
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocb->fcp_wqidx = iocb->fcp_wqidx;
+	abtsiocb->hba_wqidx = iocb->hba_wqidx;
 	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
 	if (iocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocb->iocb_flag |= LPFC_IO_FOF;
@@ -4782,7 +4782,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number = MAX_SLI3_CONFIGURED_RINGS + iocb->fcp_wqidx;
+		ring_number = MAX_SLI3_CONFIGURED_RINGS + iocb->hba_wqidx;
 		pring_s4 = &phba->sli.ring[ring_number];
 		/* Note: both hbalock and ring_lock must be set here */
 		spin_lock_irqsave(&pring_s4->ring_lock, iflags);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 8cb80da..2d5c1ee 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -132,9 +132,13 @@ struct lpfc_scsi_buf {
 	struct list_head list;
 	struct scsi_cmnd *pCmd;
 	struct lpfc_rport_data *rdata;
+	struct nvmefc_fcp_req *nvmeCmd;
+	struct lpfc_nvme_rport *nrport;
 
 	uint32_t timeout;
 
+	uint16_t flags;  /* TBD convert exch_busy to flags */
+#define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
 	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
@@ -164,6 +168,7 @@ struct lpfc_scsi_buf {
 	 * Iotag is in here
 	 */
 	struct lpfc_iocbq cur_iocbq;
+
 	wait_queue_head_t *waitq;
 	unsigned long start_time;
 
@@ -178,13 +183,15 @@ struct lpfc_scsi_buf {
 #endif
 };
 
-#define LPFC_SCSI_DMA_EXT_SIZE 264
-#define LPFC_BPL_SIZE          1024
-#define MDAC_DIRECT_CMD                  0x22
+#define LPFC_SCSI_DMA_EXT_SIZE	264
+#define LPFC_BPL_SIZE		1024
+#define MDAC_DIRECT_CMD		0x22
+
+#define FIND_FIRST_OAS_LUN	0
+#define NO_MORE_OAS_LUN		-1
+#define NOT_OAS_ENABLED_LUN	NO_MORE_OAS_LUN
 
-#define FIND_FIRST_OAS_LUN		 0
-#define NO_MORE_OAS_LUN			-1
-#define NOT_OAS_ENABLED_LUN		NO_MORE_OAS_LUN
+#define TXRDY_PAYLOAD_LEN	12
 
 int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 				  struct lpfc_scsi_buf *lpfc_cmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c8fd0a3..fb0e604 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -66,7 +66,7 @@ static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
 							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
-static int lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *, struct lpfc_queue *,
+static int lpfc_sli4_fp_handle_cqe(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_cqe *);
 static int lpfc_sli4_post_els_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
@@ -599,7 +599,7 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  *
  * Returns sglq ponter = success, NULL = Failure.
  **/
-static struct lpfc_sglq *
+struct lpfc_sglq *
 __lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
 {
 	struct lpfc_sglq *sglq;
@@ -908,7 +908,7 @@ out:
  * list is not empty then it is successful, it returns pointer to the newly
  * allocated sglq object else it returns NULL.
  **/
-static struct lpfc_sglq *
+struct lpfc_sglq *
 __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 {
 	struct list_head *lpfc_sgl_list = &phba->sli4_hba.lpfc_sgl_list;
@@ -940,7 +940,9 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	while (!found) {
 		if (!sglq)
 			return NULL;
-		if (lpfc_test_rrq_active(phba, ndlp, sglq->sli4_lxritag)) {
+		if (ndlp && ndlp->active_rrqs_xri_bitmap &&
+		    test_bit(sglq->sli4_lxritag,
+		    ndlp->active_rrqs_xri_bitmap)) {
 			/* This xri has an rrq outstanding for this DID.
 			 * put it back in the list and get another xri.
 			 */
@@ -1047,6 +1049,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
 	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
+	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVMET | LPFC_IO_NVME_LS);
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
@@ -1716,9 +1719,8 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 	struct hbq_dmabuf *hbq_buf;
 	unsigned long flags;
 	int i, hbq_count;
-	uint32_t hbqno;
 
-	hbq_count = lpfc_sli_hbq_count();
+	hbq_count = lpfc_sli_hbq_count(phba);
 	/* Return all memory used by all HBQs */
 	spin_lock_irqsave(&phba->hbalock, flags);
 	for (i = 0; i < hbq_count; ++i) {
@@ -1730,24 +1732,6 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 		}
 		phba->hbqs[i].buffer_count = 0;
 	}
-	/* Return all HBQ buffer that are in-fly */
-	list_for_each_entry_safe(dmabuf, next_dmabuf, &phba->rb_pend_list,
-				 list) {
-		hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
-		list_del(&hbq_buf->dbuf.list);
-		if (hbq_buf->tag == -1) {
-			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
-				(phba, hbq_buf);
-		} else {
-			hbqno = hbq_buf->tag >> 16;
-			if (hbqno >= LPFC_MAX_HBQS)
-				(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
-					(phba, hbq_buf);
-			else
-				(phba->hbqs[hbqno].hbq_free_buffer)(phba,
-					hbq_buf);
-		}
-	}
 
 	/* Mark the HBQs not in use */
 	phba->hbq_in_use = 0;
@@ -1800,7 +1784,7 @@ lpfc_sli_hbq_to_firmware_s3(struct lpfc_hba *phba, uint32_t hbqno,
 
 		hbqe->bde.addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
 		hbqe->bde.addrLow  = le32_to_cpu(putPaddrLow(physaddr));
-		hbqe->bde.tus.f.bdeSize = hbq_buf->size;
+		hbqe->bde.tus.f.bdeSize = hbq_buf->total_size;
 		hbqe->bde.tus.f.bdeFlags = 0;
 		hbqe->bde.tus.w = le32_to_cpu(hbqe->bde.tus.w);
 		hbqe->buffer_tag = le32_to_cpu(hbq_buf->tag);
@@ -1832,17 +1816,21 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 	int rc;
 	struct lpfc_rqe hrqe;
 	struct lpfc_rqe drqe;
+	struct lpfc_queue *hrq;
+	struct lpfc_queue *drq;
+
+	hrq = phba->sli4_hba.hdr_rq;
+	drq = phba->sli4_hba.dat_rq;
 
 	lockdep_assert_held(&phba->hbalock);
 	hrqe.address_lo = putPaddrLow(hbq_buf->hbuf.phys);
 	hrqe.address_hi = putPaddrHigh(hbq_buf->hbuf.phys);
 	drqe.address_lo = putPaddrLow(hbq_buf->dbuf.phys);
 	drqe.address_hi = putPaddrHigh(hbq_buf->dbuf.phys);
-	rc = lpfc_sli4_rq_put(phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
-			      &hrqe, &drqe);
+	rc = lpfc_sli4_rq_put(hrq, drq, &hrqe, &drqe);
 	if (rc < 0)
 		return rc;
-	hbq_buf->tag = rc;
+	hbq_buf->tag = (rc | (hbqno << 16));
 	list_add_tail(&hbq_buf->dbuf.list, &phba->hbqs[hbqno].hbq_buffer_list);
 	return 0;
 }
@@ -1859,22 +1847,9 @@ static struct lpfc_hbq_init lpfc_els_hbq = {
 	.add_count = 40,
 };
 
-/* HBQ for the extra ring if needed */
-static struct lpfc_hbq_init lpfc_extra_hbq = {
-	.rn = 1,
-	.entry_count = 200,
-	.mask_count = 0,
-	.profile = 0,
-	.ring_mask = (1 << LPFC_EXTRA_RING),
-	.buffer_count = 0,
-	.init_count = 0,
-	.add_count = 5,
-};
-
 /* Array of HBQs */
 struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 	&lpfc_els_hbq,
-	&lpfc_extra_hbq,
 };
 
 /**
@@ -2461,6 +2436,14 @@ lpfc_complete_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 {
 	int i;
 
+	switch (fch_type) {
+	case LPFC_FC4_TYPE_NVME:
+		/* TODO: handle FC-4 LS requests */
+		/* fall-thru for failure */
+	default:
+		break;
+	}
+
 	/* unSolicited Responses */
 	if (pring->prt[0].profile) {
 		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
@@ -4376,9 +4359,12 @@ lpfc_sli_chipset_init(struct lpfc_hba *phba)
  * configured.
  **/
 int
-lpfc_sli_hbq_count(void)
+lpfc_sli_hbq_count(struct lpfc_hba *phba)
 {
-	return ARRAY_SIZE(lpfc_hbq_defs);
+	int i;
+
+	i = ARRAY_SIZE(lpfc_hbq_defs);
+	return i;
 }
 
 /**
@@ -4389,9 +4375,9 @@ lpfc_sli_hbq_count(void)
  * the total count.
  **/
 static int
-lpfc_sli_hbq_entry_count(void)
+lpfc_sli_hbq_entry_count(struct lpfc_hba *phba)
 {
-	int  hbq_count = lpfc_sli_hbq_count();
+	int  hbq_count = lpfc_sli_hbq_count(phba);
 	int  count = 0;
 	int  i;
 
@@ -4407,9 +4393,9 @@ lpfc_sli_hbq_entry_count(void)
  * to be configured and returns the total memory required.
  **/
 int
-lpfc_sli_hbq_size(void)
+lpfc_sli_hbq_size(struct lpfc_hba *phba)
 {
-	return lpfc_sli_hbq_entry_count() * sizeof(struct lpfc_hbq_entry);
+	return lpfc_sli_hbq_entry_count(phba) * sizeof(struct lpfc_hbq_entry);
 }
 
 /**
@@ -4424,7 +4410,7 @@ lpfc_sli_hbq_size(void)
 static int
 lpfc_sli_hbq_setup(struct lpfc_hba *phba)
 {
-	int  hbq_count = lpfc_sli_hbq_count();
+	int  hbq_count = lpfc_sli_hbq_count(phba);
 	LPFC_MBOXQ_t *pmb;
 	MAILBOX_t *pmbox;
 	uint32_t hbqno;
@@ -4494,10 +4480,11 @@ static int
 lpfc_sli4_rb_setup(struct lpfc_hba *phba)
 {
 	phba->hbq_in_use = 1;
-	phba->hbqs[0].entry_count = lpfc_hbq_defs[0]->entry_count;
+	phba->hbqs[LPFC_ELS_HBQ].entry_count =
+		lpfc_hbq_defs[LPFC_ELS_HBQ]->entry_count;
 	phba->hbq_count = 1;
+	lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_ELS_HBQ);
 	/* Initially populate or replenish the HBQs */
-	lpfc_sli_hbqbuf_init_hbqs(phba, 0);
 	return 0;
 }
 
@@ -5103,25 +5090,37 @@ out_free_mboxq:
 static void
 lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 {
-	int fcp_eqidx;
+	int hba_eqidx;
 
 	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
 	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	fcp_eqidx = 0;
+	if (phba->sli4_hba.nvmels_cq)
+		lpfc_sli4_cq_release(phba->sli4_hba.nvmels_cq,
+		LPFC_QUEUE_REARM);
+
+	hba_eqidx = 0;
 	if (phba->sli4_hba.fcp_cq) {
 		do {
-			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[fcp_eqidx],
+			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[hba_eqidx],
 					     LPFC_QUEUE_REARM);
-		} while (++fcp_eqidx < phba->cfg_fcp_io_channel);
+		} while (++hba_eqidx < phba->cfg_fcp_io_channel);
+	}
+
+	hba_eqidx = 0;
+	if (phba->sli4_hba.nvme_cq) {
+		do {
+			lpfc_sli4_cq_release(phba->sli4_hba.nvme_cq[hba_eqidx],
+					     LPFC_QUEUE_REARM);
+		} while (++hba_eqidx < phba->cfg_nvme_io_channel);
 	}
 
 	if (phba->cfg_fof)
 		lpfc_sli4_cq_release(phba->sli4_hba.oas_cq, LPFC_QUEUE_REARM);
 
 	if (phba->sli4_hba.hba_eq) {
-		for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-		     fcp_eqidx++)
-			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[fcp_eqidx],
+		for (hba_eqidx = 0; hba_eqidx < phba->io_channel;
+		     hba_eqidx++)
+			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[hba_eqidx],
 					     LPFC_QUEUE_REARM);
 	}
 
@@ -6844,7 +6843,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 	/* Find the eq associated with the mcq */
 
 	if (phba->sli4_hba.hba_eq)
-		for (eqidx = 0; eqidx < phba->cfg_fcp_io_channel; eqidx++)
+		for (eqidx = 0; eqidx < phba->io_channel; eqidx++)
 			if (phba->sli4_hba.hba_eq[eqidx]->queue_id ==
 			    phba->sli4_hba.mbx_cq->assoc_qid) {
 				fpeq = phba->sli4_hba.hba_eq[eqidx];
@@ -8892,7 +8891,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
 	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
 		if (!phba->cfg_fof || (!(piocb->iocb_flag & LPFC_IO_OAS))) {
-			wq = phba->sli4_hba.fcp_wq[piocb->fcp_wqidx];
+			wq = phba->sli4_hba.hba_wq[piocb->hba_wqidx];
 		} else {
 			wq = phba->sli4_hba.oas_wq;
 		}
@@ -8967,9 +8966,9 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  * @piocb: Pointer to command iocb.
  *
  * For SLI4, FCP IO can deferred to one fo many WQs, based on
- * fcp_wqidx, thus we need to calculate the corresponding ring.
+ * hba_wqidx, thus we need to calculate the corresponding ring.
  * Since ABORTS must go on the same WQ of the command they are
- * aborting, we use command's fcp_wqidx.
+ * aborting, we use command's hba_wqidx.
  */
 int
 lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
@@ -8981,25 +8980,34 @@ lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
 	if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
 		if (!(phba->cfg_fof) ||
 				(!(piocb->iocb_flag & LPFC_IO_FOF))) {
-			if (unlikely(!phba->sli4_hba.fcp_wq))
+			if (unlikely(!phba->sli4_hba.hba_wq))
 				return LPFC_HBA_ERROR;
 			/*
-			 * for abort iocb fcp_wqidx should already
+			 * for abort iocb hba_wqidx should already
 			 * be setup based on what work queue we used.
 			 */
 			if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
-				piocb->fcp_wqidx =
+				piocb->hba_wqidx =
 					lpfc_sli4_scmd_to_wqidx_distr(phba,
 							      piocb->context1);
 			ring_number = MAX_SLI3_CONFIGURED_RINGS +
-				piocb->fcp_wqidx;
+				piocb->hba_wqidx;
 		} else {
 			if (unlikely(!phba->sli4_hba.oas_wq))
 				return LPFC_HBA_ERROR;
-			piocb->fcp_wqidx = 0;
+			piocb->hba_wqidx = 0;
 			ring_number =  LPFC_FCP_OAS_RING;
 		}
-	}
+	} else if (piocb->iocb_flag & LPFC_IO_NVME) {
+		if (piocb->sli4_xritag == NO_XRI) {
+			piocb->hba_wqidx =
+				lpfc_sli4_scmd_to_wqidx_distr(phba,
+							      piocb->context1);
+		}
+		ring_number = MAX_SLI3_CONFIGURED_RINGS +
+				piocb->hba_wqidx;
+	} else
+		piocb->hba_wqidx = 0;
 	return ring_number;
 }
 
@@ -9020,7 +9028,7 @@ int
 lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_queue *fpeq;
 	struct lpfc_eqe *eqe;
@@ -9031,7 +9039,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		ring_number = lpfc_sli_calc_ring(phba, ring_number, piocb);
 		if (unlikely(ring_number == LPFC_HBA_ERROR))
 			return IOCB_ERROR;
-		idx = piocb->fcp_wqidx;
+		idx = piocb->hba_wqidx;
 
 		pring = &phba->sli.ring[ring_number];
 		spin_lock_irqsave(&pring->ring_lock, iflags);
@@ -9039,10 +9047,10 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
 		if (lpfc_fcp_look_ahead && (piocb->iocb_flag &  LPFC_IO_FCP)) {
-			fcp_eq_hdl = &phba->sli4_hba.fcp_eq_hdl[idx];
+			hba_eq_hdl = &phba->sli4_hba.hba_eq_hdl[idx];
 
-			if (atomic_dec_and_test(&fcp_eq_hdl->
-				fcp_eq_in_use)) {
+			if (atomic_dec_and_test(&hba_eq_hdl->
+				hba_eq_in_use)) {
 
 				/* Get associated EQ with this index */
 				fpeq = phba->sli4_hba.hba_eq[idx];
@@ -9063,7 +9071,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				lpfc_sli4_eq_release(fpeq,
 					LPFC_QUEUE_REARM);
 			}
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 		}
 	} else {
 		/* For now, SLI2/3 will still use hbalock */
@@ -9307,7 +9315,7 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 
 	psli->num_rings = MAX_SLI3_CONFIGURED_RINGS;
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		psli->num_rings += phba->cfg_fcp_io_channel;
+		psli->num_rings += phba->io_channel;
 	psli->sli_flag = 0;
 	psli->fcp_ring = LPFC_FCP_RING;
 	psli->next_ring = LPFC_FCP_NEXT_RING;
@@ -9986,7 +9994,7 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	iabt->ulpClass = icmd->ulpClass;
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocbp->fcp_wqidx = cmdiocb->fcp_wqidx;
+	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
 	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
 		abtsiocbp->iocb_flag |= LPFC_USE_FCPWQIDX;
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
@@ -10308,7 +10316,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		abtsiocb->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocb->fcp_wqidx = iocbq->fcp_wqidx;
+		abtsiocb->hba_wqidx = iocbq->hba_wqidx;
 		if (iocbq->iocb_flag & LPFC_IO_FCP)
 			abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
@@ -10411,7 +10419,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		abtsiocbq->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocbq->fcp_wqidx = iocbq->fcp_wqidx;
+		abtsiocbq->hba_wqidx = iocbq->hba_wqidx;
 		if (iocbq->iocb_flag & LPFC_IO_FCP)
 			abtsiocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
@@ -10437,7 +10445,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			ring_number = MAX_SLI3_CONFIGURED_RINGS +
-					 iocbq->fcp_wqidx;
+					 iocbq->hba_wqidx;
 			pring_s4 = &phba->sli.ring[ring_number];
 			/* Note: both hbalock and ring_lock must be set here */
 			spin_lock_irqsave(&pring_s4->ring_lock, iflags);
@@ -12127,6 +12135,7 @@ static bool
 lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 {
 	bool workposted = false;
+	struct fc_frame_header *fc_hdr;
 	struct lpfc_queue *hrq = phba->sli4_hba.hdr_rq;
 	struct lpfc_queue *drq = phba->sli4_hba.dat_rq;
 	struct hbq_dmabuf *dma_buf;
@@ -12161,6 +12170,10 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 		}
 		hrq->RQ_rcv_buf++;
 		memcpy(&dma_buf->cq_event.cqe.rcqe_cmpl, rcqe, sizeof(*rcqe));
+
+		/* If a NVME LS event (type 0x28), treat it as Fast path */
+		fc_hdr = (struct fc_frame_header *)dma_buf->hbuf.virt;
+
 		/* save off the frame for the word thread to process */
 		list_add_tail(&dma_buf->cq_event.list,
 			      &phba->sli4_hba.sp_queue_event);
@@ -12291,8 +12304,9 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		break;
 	case LPFC_WCQ:
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
-			if (cq->subtype == LPFC_FCP)
-				workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq,
+			if ((cq->subtype == LPFC_FCP) ||
+			    (cq->subtype == LPFC_NVME))
+				workposted |= lpfc_sli4_fp_handle_cqe(phba, cq,
 								       cqe);
 			else
 				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
@@ -12379,7 +12393,18 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 		return;
 	}
-	if (unlikely(!cmdiocbq->iocb_cmpl)) {
+	if (cmdiocbq->iocb_cmpl == NULL) {
+		if (cmdiocbq->wqe_cmpl) {
+			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+				spin_lock_irqsave(&phba->hbalock, iflags);
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+			}
+
+			/* Pass the cmd_iocb and the wcqe to the upper layer */
+			(cmdiocbq->wqe_cmpl)(phba, cmdiocbq, wcqe);
+			return;
+		}
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
 				"iotag: (%d)\n",
@@ -12415,12 +12440,12 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 {
 	struct lpfc_queue *childwq;
 	bool wqid_matched = false;
-	uint16_t fcp_wqid;
+	uint16_t hba_wqid;
 
 	/* Check for fast-path FCP work queue release */
-	fcp_wqid = bf_get(lpfc_wcqe_r_wq_id, wcqe);
+	hba_wqid = bf_get(lpfc_wcqe_r_wq_id, wcqe);
 	list_for_each_entry(childwq, &cq->child_list, list) {
-		if (childwq->queue_id == fcp_wqid) {
+		if (childwq->queue_id == hba_wqid) {
 			lpfc_sli4_wq_release(childwq,
 					bf_get(lpfc_wcqe_r_wqe_index, wcqe));
 			wqid_matched = true;
@@ -12431,11 +12456,12 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	if (wqid_matched != true)
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"2580 Fast-path wqe consume event carries "
-				"miss-matched qid: wcqe-qid=x%x\n", fcp_wqid);
+				"miss-matched qid: wcqe-qid=x%x\n", hba_wqid);
 }
 
+
 /**
- * lpfc_sli4_fp_handle_wcqe - Process fast-path work queue completion entry
+ * lpfc_sli4_fp_handle_cqe - Process fast-path work queue completion entry
  * @cq: Pointer to the completion queue.
  * @eqe: Pointer to fast-path completion queue entry.
  *
@@ -12443,7 +12469,7 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * event queue for FCP command response completion.
  **/
 static int
-lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			 struct lpfc_cqe *cqe)
 {
 	struct lpfc_wcqe_release wcqe;
@@ -12455,10 +12481,15 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	/* Check and process for different type of WCQE and dispatch */
 	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
 	case CQE_CODE_COMPL_WQE:
+	case CQE_CODE_NVME_ERSP:
 		cq->CQ_wq++;
 		/* Process the WQ complete event */
 		phba->last_completion_time = jiffies;
-		lpfc_sli4_fp_handle_fcp_wcqe(phba, cq,
+		if ((cq->subtype == LPFC_FCP) || (cq->subtype == LPFC_NVME))
+			lpfc_sli4_fp_handle_fcp_wcqe(phba, cq,
+				(struct lpfc_wcqe_complete *)&wcqe);
+		if (cq->subtype == LPFC_NVME_LS)
+			lpfc_sli4_fp_handle_fcp_wcqe(phba, cq,
 				(struct lpfc_wcqe_complete *)&wcqe);
 		break;
 	case CQE_CODE_RELEASE_WQE:
@@ -12474,9 +12505,17 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
 				(struct sli4_wcqe_xri_aborted *)&wcqe);
 		break;
+	case CQE_CODE_RECEIVE_V1:
+	case CQE_CODE_RECEIVE:
+		phba->last_completion_time = jiffies;
+		if (cq->subtype == LPFC_NVMET) {
+			/* TODO: handle nvme tgt receive frames */
+			workposted = false;
+		}
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0144 Not a valid WCQE code: x%x\n",
+				"0144 Not a valid CQE code: x%x\n",
 				bf_get(lpfc_wcqe_c_code, &wcqe));
 		break;
 	}
@@ -12499,7 +12538,7 @@ static void
 lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			uint32_t qidx)
 {
-	struct lpfc_queue *cq;
+	struct lpfc_queue *cq = NULL;
 	struct lpfc_cqe *cqe;
 	bool workposted = false;
 	uint16_t cqid;
@@ -12517,28 +12556,33 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* Get the reference to the corresponding CQ */
 	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 
-	/* Check if this is a Slow path event */
-	if (unlikely(cqid != phba->sli4_hba.fcp_cq_map[qidx])) {
-		lpfc_sli4_sp_handle_eqe(phba, eqe,
-			phba->sli4_hba.hba_eq[qidx]);
-		return;
+	if (phba->sli4_hba.nvme_cq_map &&
+	    (cqid == phba->sli4_hba.nvme_cq_map[qidx])) {
+		/* Process NVME / NVMET command completion */
+		cq = phba->sli4_hba.nvme_cq[qidx];
+		goto  process_cq;
 	}
 
-	if (unlikely(!phba->sli4_hba.fcp_cq)) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"3146 Fast-path completion queues "
-				"does not exist\n");
-		return;
+	if (phba->sli4_hba.fcp_cq_map &&
+	    (cqid == phba->sli4_hba.fcp_cq_map[qidx])) {
+		/* Process FCP command completion */
+		cq = phba->sli4_hba.fcp_cq[qidx];
+		goto  process_cq;
 	}
-	cq = phba->sli4_hba.fcp_cq[qidx];
-	if (unlikely(!cq)) {
-		if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
-			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"0367 Fast-path completion queue "
-					"(%d) does not exist\n", qidx);
+
+	if (phba->sli4_hba.nvmels_cq &&
+	    (cqid == phba->sli4_hba.nvmels_cq->queue_id)) {
+		/* Process NVMET unsol rcv */
+		cq = phba->sli4_hba.nvmels_cq;
+	}
+
+	/* Otherwise this is a Slow path event */
+	if (cq == NULL) {
+		lpfc_sli4_sp_handle_eqe(phba, eqe, phba->sli4_hba.hba_eq[qidx]);
 		return;
 	}
 
+process_cq:
 	if (unlikely(cqid != cq->queue_id)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0368 Miss-matched fast-path completion "
@@ -12549,7 +12593,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 
 	/* Process all the entries to the CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
@@ -12640,7 +12684,7 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 
 	/* Process all the entries to the OAS CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
@@ -12688,15 +12732,15 @@ irqreturn_t
 lpfc_sli4_fof_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba *phba;
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_queue *eq;
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
 
 	/* Get the driver's phba structure from the dev_id */
-	fcp_eq_hdl = (struct lpfc_fcp_eq_hdl *)dev_id;
-	phba = fcp_eq_hdl->phba;
+	hba_eq_hdl = (struct lpfc_hba_eq_hdl *)dev_id;
+	phba = hba_eq_hdl->phba;
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
@@ -12782,17 +12826,17 @@ irqreturn_t
 lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba *phba;
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_queue *fpeq;
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
-	int fcp_eqidx;
+	int hba_eqidx;
 
 	/* Get the driver's phba structure from the dev_id */
-	fcp_eq_hdl = (struct lpfc_fcp_eq_hdl *)dev_id;
-	phba = fcp_eq_hdl->phba;
-	fcp_eqidx = fcp_eq_hdl->idx;
+	hba_eq_hdl = (struct lpfc_hba_eq_hdl *)dev_id;
+	phba = hba_eq_hdl->phba;
+	hba_eqidx = hba_eq_hdl->idx;
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
@@ -12800,15 +12844,15 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	/* Get to the EQ struct associated with this vector */
-	fpeq = phba->sli4_hba.hba_eq[fcp_eqidx];
+	fpeq = phba->sli4_hba.hba_eq[hba_eqidx];
 	if (unlikely(!fpeq))
 		return IRQ_NONE;
 
 	if (lpfc_fcp_look_ahead) {
-		if (atomic_dec_and_test(&fcp_eq_hdl->fcp_eq_in_use))
+		if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use))
 			lpfc_sli4_eq_clr_intr(fpeq);
 		else {
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
 		}
 	}
@@ -12823,7 +12867,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 			lpfc_sli4_eq_flush(phba, fpeq);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (lpfc_fcp_look_ahead)
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 		return IRQ_NONE;
 	}
 
@@ -12834,7 +12878,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		if (eqe == NULL)
 			break;
 
-		lpfc_sli4_hba_handle_eqe(phba, eqe, fcp_eqidx);
+		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
 		if (!(++ecount % fpeq->entry_repost))
 			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
 		fpeq->EQ_processed++;
@@ -12851,7 +12895,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		fpeq->EQ_no_entry++;
 
 		if (lpfc_fcp_look_ahead) {
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
 		}
 
@@ -12865,7 +12909,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	}
 
 	if (lpfc_fcp_look_ahead)
-		atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+		atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 	return IRQ_HANDLED;
 } /* lpfc_sli4_fp_intr_handler */
 
@@ -12892,7 +12936,7 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba  *phba;
 	irqreturn_t hba_irq_rc;
 	bool hba_handled = false;
-	int fcp_eqidx;
+	int hba_eqidx, io_channel;
 
 	/* Get the driver's phba structure from the dev_id */
 	phba = (struct lpfc_hba *)dev_id;
@@ -12900,19 +12944,23 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 	if (unlikely(!phba))
 		return IRQ_NONE;
 
+	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+		io_channel = phba->cfg_fcp_io_channel;
+	else
+		io_channel = phba->cfg_nvme_io_channel;
 	/*
 	 * Invoke fast-path host attention interrupt handling as appropriate.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel; fcp_eqidx++) {
+	for (hba_eqidx = 0; hba_eqidx < phba->io_channel; hba_eqidx++) {
 		hba_irq_rc = lpfc_sli4_hba_intr_handler(irq,
-					&phba->sli4_hba.fcp_eq_hdl[fcp_eqidx]);
+					&phba->sli4_hba.hba_eq_hdl[hba_eqidx]);
 		if (hba_irq_rc == IRQ_HANDLED)
 			hba_handled |= true;
 	}
 
 	if (phba->cfg_fof) {
 		hba_irq_rc = lpfc_sli4_fof_intr_handler(irq,
-					&phba->sli4_hba.fcp_eq_hdl[0]);
+					&phba->sli4_hba.hba_eq_hdl[hba_eqidx]);
 		if (hba_irq_rc == IRQ_HANDLED)
 			hba_handled |= true;
 	}
@@ -13048,7 +13096,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 }
 
 /**
- * lpfc_modify_fcp_eq_delay - Modify Delay Multiplier on FCP EQs
+ * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on FCP EQs
  * @phba: HBA structure that indicates port to create a queue on.
  * @startq: The starting FCP EQ to modify
  *
@@ -13064,7 +13112,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * fails this function will return -ENXIO.
  **/
 int
-lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
+lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 {
 	struct lpfc_mbx_modify_eq_delay *eq_delay;
 	LPFC_MBOXQ_t *mbox;
@@ -13072,11 +13120,11 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 	int cnt, rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	uint32_t result;
-	int fcp_eqidx;
+	int hba_eqidx;
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint16_t dmult;
 
-	if (startq >= phba->cfg_fcp_io_channel)
+	if (startq >= phba->io_channel)
 		return 0;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -13090,16 +13138,20 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 	eq_delay = &mbox->u.mqe.un.eq_delay;
 
 	/* Calculate delay multiper from maximum interrupt per second */
-	result = phba->cfg_fcp_imax / phba->cfg_fcp_io_channel;
-	if (result > LPFC_DMULT_CONST)
+	result = phba->cfg_fcp_imax / phba->io_channel;
+	if ((result > LPFC_DMULT_CONST) || (result == 0))
 		dmult = 0;
 	else
 		dmult = LPFC_DMULT_CONST/result - 1;
 
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"9999 Interrupt (EQ) Delay multiplier is x%x "
+			"across %d IO channels\n",
+			dmult, phba->io_channel);
 	cnt = 0;
-	for (fcp_eqidx = startq; fcp_eqidx < phba->cfg_fcp_io_channel;
-	    fcp_eqidx++) {
-		eq = phba->sli4_hba.hba_eq[fcp_eqidx];
+	for (hba_eqidx = startq; hba_eqidx < phba->io_channel;
+	    hba_eqidx++) {
+		eq = phba->sli4_hba.hba_eq[hba_eqidx];
 		if (!eq)
 			continue;
 		eq_delay->u.request.eq[cnt].eq_id = eq->queue_id;
@@ -14778,6 +14830,9 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba,
 	return rc;
 }
 
+char *lpfc_rctl_names[] = FC_RCTL_NAMES_INIT;
+char *lpfc_type_names[] = FC_TYPE_NAMES_INIT;
+
 /**
  * lpfc_fc_frame_check - Check that this frame is a valid frame to handle
  * @phba: pointer to lpfc_hba struct that the frame was received on
@@ -14788,12 +14843,10 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba,
  * return a zero if the frame is a valid frame or a non zero value when the
  * frame does not pass the check.
  **/
-static int
+int
 lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 {
 	/*  make rctl_names static to save stack space */
-	static char *rctl_names[] = FC_RCTL_NAMES_INIT;
-	char *type_names[] = FC_TYPE_NAMES_INIT;
 	struct fc_vft_header *fc_vft_hdr;
 	uint32_t *header = (uint32_t *) fc_hdr;
 
@@ -14838,18 +14891,18 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_TYPE_ELS:
 	case FC_TYPE_FCP:
 	case FC_TYPE_CT:
+	case LPFC_FC4_TYPE_NVME:
 		break;
 	case FC_TYPE_IP:
 	case FC_TYPE_ILS:
 	default:
 		goto drop;
 	}
-
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"2538 Received frame rctl:%s (x%x), type:%s (x%x), "
 			"frame Data:%08x %08x %08x %08x %08x %08x %08x\n",
-			rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
-			type_names[fc_hdr->fh_type], fc_hdr->fh_type,
+			lpfc_rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
+			lpfc_type_names[fc_hdr->fh_type], fc_hdr->fh_type,
 			be32_to_cpu(header[0]), be32_to_cpu(header[1]),
 			be32_to_cpu(header[2]), be32_to_cpu(header[3]),
 			be32_to_cpu(header[4]), be32_to_cpu(header[5]),
@@ -14858,8 +14911,8 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
 			"2539 Dropped frame rctl:%s type:%s\n",
-			rctl_names[fc_hdr->fh_r_ctl],
-			type_names[fc_hdr->fh_type]);
+			lpfc_rctl_names[fc_hdr->fh_r_ctl],
+			lpfc_type_names[fc_hdr->fh_type]);
 	return 1;
 }
 
@@ -14893,16 +14946,13 @@ lpfc_fc_hdr_get_vfi(struct fc_frame_header *fc_hdr)
  * returns the matching vport pointer or NULL if unable to match frame to a
  * vport.
  **/
-static struct lpfc_vport *
+struct lpfc_vport *
 lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
-		       uint16_t fcfi)
+		       uint16_t fcfi, uint32_t did)
 {
 	struct lpfc_vport **vports;
 	struct lpfc_vport *vport = NULL;
 	int i;
-	uint32_t did = (fc_hdr->fh_d_id[0] << 16 |
-			fc_hdr->fh_d_id[1] << 8 |
-			fc_hdr->fh_d_id[2]);
 
 	if (did == Fabric_DID)
 		return phba->pport;
@@ -14911,7 +14961,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
 		return phba->pport;
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			if (phba->fcf.fcfi == fcfi &&
 			    vports[i]->vfi == lpfc_fc_hdr_get_vfi(fc_hdr) &&
@@ -14920,6 +14970,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
 				break;
 			}
 		}
+	}
 	lpfc_destroy_vport_work_array(phba, vports);
 	return vport;
 }
@@ -15526,6 +15577,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		/* Initialize the first IOCB. */
 		first_iocbq->iocb.unsli3.rcvsli3.acc_len = 0;
 		first_iocbq->iocb.ulpStatus = IOSTAT_SUCCESS;
+		first_iocbq->vport = vport;
 
 		/* Check FC Header to see what TYPE of frame we are rcv'ing */
 		if (sli4_type_from_fc_hdr(fc_hdr) == FC_TYPE_ELS) {
@@ -15663,8 +15715,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
  * This function is called with no lock held. This function processes all
  * the received buffers and gives it to upper layers when a received buffer
  * indicates that it is the final frame in the sequence. The interrupt
- * service routine processes received buffers at interrupt contexts and adds
- * received dma buffers to the rb_pend_list queue and signals the worker thread.
+ * service routine processes received buffers at interrupt contexts.
  * Worker thread calls lpfc_sli4_handle_received_buffer, which will call the
  * appropriate receive function when the final frame in a sequence is received.
  **/
@@ -15680,11 +15731,13 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 
 	/* Process each received buffer */
 	fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+
 	/* check to see if this a valid type of frame */
 	if (lpfc_fc_frame_check(phba, fc_hdr)) {
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
 	}
+
 	if ((bf_get(lpfc_cqe_code,
 		    &dmabuf->cq_event.cqe.rcqe_cmpl) == CQE_CODE_RECEIVE_V1))
 		fcfi = bf_get(lpfc_rcqe_fcf_id_v1,
@@ -15693,16 +15746,16 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		fcfi = bf_get(lpfc_rcqe_fcf_id,
 			      &dmabuf->cq_event.cqe.rcqe_cmpl);
 
-	vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi);
+	/* d_id this frame is directed to */
+	did = sli4_did_from_fc_hdr(fc_hdr);
+
+	vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi, did);
 	if (!vport) {
 		/* throw out the frame */
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
 	}
 
-	/* d_id this frame is directed to */
-	did = sli4_did_from_fc_hdr(fc_hdr);
-
 	/* vport is registered unless we rcv a FLOGI directed to Fabric_DID */
 	if (!(vport->vpi_state & LPFC_VPI_REGISTERED) &&
 		(did != Fabric_DID)) {
@@ -17249,3 +17302,270 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 
 	return txq_cnt;
 }
+
+/**
+ * lpfc_wqe_bpl2sgl - Convert the bpl/bde to a sgl.
+ * @phba: Pointer to HBA context object.
+ * @pwqe: Pointer to command WQE.
+ * @sglq: Pointer to the scatter gather queue object.
+ *
+ * This routine converts the bpl or bde that is in the WQE
+ * to a sgl list for the sli4 hardware. The physical address
+ * of the bpl/bde is converted back to a virtual address.
+ * If the WQE contains a BPL then the list of BDE's is
+ * converted to sli4_sge's. If the WQE contains a single
+ * BDE then it is converted to a single sli_sge.
+ * The WQE is still in cpu endianness so the contents of
+ * the bpl can be used without byte swapping.
+ *
+ * Returns valid XRI = Success, NO_XRI = Failure.
+**/
+static uint16_t
+lpfc_wqe_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeq,
+		 struct lpfc_sglq *sglq)
+{
+	uint16_t xritag = NO_XRI;
+	struct ulp_bde64 *bpl = NULL;
+	struct ulp_bde64 bde;
+	struct sli4_sge *sgl  = NULL;
+	struct lpfc_dmabuf *dmabuf;
+	union lpfc_wqe *wqe;
+	int numBdes = 0;
+	int i = 0;
+	uint32_t offset = 0; /* accumulated offset in the sg request list */
+	int inbound = 0; /* number of sg reply entries inbound from firmware */
+	uint32_t cmd;
+
+	if (!pwqeq || !sglq)
+		return xritag;
+
+	sgl  = (struct sli4_sge *)sglq->sgl;
+	wqe = &pwqeq->wqe;
+	pwqeq->iocb.ulpIoTag = pwqeq->iotag;
+
+	cmd = bf_get(wqe_cmnd, &wqe->generic.wqe_com);
+	if (cmd == CMD_XMIT_BLS_RSP64_WQE)
+		return sglq->sli4_xritag;
+	numBdes = pwqeq->rsvd2;
+	if (numBdes) {
+		/* The addrHigh and addrLow fields within the WQE
+		 * have not been byteswapped yet so there is no
+		 * need to swap them back.
+		 */
+		if (pwqeq->context3)
+			dmabuf = (struct lpfc_dmabuf *)pwqeq->context3;
+		else
+			return xritag;
+
+		bpl  = (struct ulp_bde64 *)dmabuf->virt;
+		if (!bpl)
+			return xritag;
+
+		for (i = 0; i < numBdes; i++) {
+			/* Should already be byte swapped. */
+			sgl->addr_hi = bpl->addrHigh;
+			sgl->addr_lo = bpl->addrLow;
+
+			sgl->word2 = le32_to_cpu(sgl->word2);
+			if ((i+1) == numBdes)
+				bf_set(lpfc_sli4_sge_last, sgl, 1);
+			else
+				bf_set(lpfc_sli4_sge_last, sgl, 0);
+			/* swap the size field back to the cpu so we
+			 * can assign it to the sgl.
+			 */
+			bde.tus.w = le32_to_cpu(bpl->tus.w);
+			sgl->sge_len = cpu_to_le32(bde.tus.f.bdeSize);
+			/* The offsets in the sgl need to be accumulated
+			 * separately for the request and reply lists.
+			 * The request is always first, the reply follows.
+			 */
+			switch (cmd) {
+			case CMD_GEN_REQUEST64_WQE:
+				/* add up the reply sg entries */
+				if (bpl->tus.f.bdeFlags == BUFF_TYPE_BDE_64I)
+					inbound++;
+				/* first inbound? reset the offset */
+				if (inbound == 1)
+					offset = 0;
+				bf_set(lpfc_sli4_sge_offset, sgl, offset);
+				bf_set(lpfc_sli4_sge_type, sgl,
+					LPFC_SGE_TYPE_DATA);
+				offset += bde.tus.f.bdeSize;
+				break;
+			case CMD_FCP_TRSP64_WQE:
+				bf_set(lpfc_sli4_sge_offset, sgl, 0);
+				bf_set(lpfc_sli4_sge_type, sgl,
+					LPFC_SGE_TYPE_DATA);
+				break;
+			case CMD_FCP_TSEND64_WQE:
+			case CMD_FCP_TRECEIVE64_WQE:
+				bf_set(lpfc_sli4_sge_type, sgl,
+					bpl->tus.f.bdeFlags);
+				if (i < 3)
+					offset = 0;
+				else
+					offset += bde.tus.f.bdeSize;
+				bf_set(lpfc_sli4_sge_offset, sgl, offset);
+				break;
+			}
+			sgl->word2 = cpu_to_le32(sgl->word2);
+			bpl++;
+			sgl++;
+		}
+	} else if (wqe->gen_req.bde.tus.f.bdeFlags == BUFF_TYPE_BDE_64) {
+		/* The addrHigh and addrLow fields of the BDE have not
+		 * been byteswapped yet so they need to be swapped
+		 * before putting them in the sgl.
+		 */
+		sgl->addr_hi = cpu_to_le32(wqe->gen_req.bde.addrHigh);
+		sgl->addr_lo = cpu_to_le32(wqe->gen_req.bde.addrLow);
+		sgl->word2 = le32_to_cpu(sgl->word2);
+		bf_set(lpfc_sli4_sge_last, sgl, 1);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = cpu_to_le32(wqe->gen_req.bde.tus.f.bdeSize);
+	}
+	return sglq->sli4_xritag;
+}
+/**
+ * __lpfc_sli_issue_wqe - SLI4 device lockless ver of lpfc_sli_issue_wqe
+ * @phba: Pointer to HBA context object.
+ * @ring_number: SLI ring number to issue WQE on.
+ * @pwqe: Pointer to command WQE.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * __lpfc_sli_issue_wqe is used by other functions in the driver to issue
+ * an WQE command to an HBA with SLI-4 interface spec.
+ *
+ * This function is called with hbalock held. The function will return success
+ * after it successfully submit the WQE to firmware or after adding to the
+ * txq.
+ **/
+int
+__lpfc_sli_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
+		      struct lpfc_iocbq *pwqe)
+{
+	struct lpfc_sglq *sglq;
+	union lpfc_wqe *wqe = &pwqe->wqe;
+	struct lpfc_queue *wq;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
+	uint32_t cmd;
+
+	cmd = bf_get(wqe_cmnd, &wqe->generic.wqe_com);
+	if (pwqe->sli4_xritag == NO_XRI) {
+		if (cmd == CMD_ABORT_XRI_WQE)
+			sglq = NULL;
+		else {
+			sglq = __lpfc_sli_get_sglq(phba, pwqe);
+			if (!sglq)
+				return WQE_BUSY;
+		}
+	} else if (pwqe->iocb_flag &  LPFC_IO_FCP)
+		/* These IO's already have an XRI and a mapped sgl. */
+		sglq = NULL;
+	else {
+		/*
+		 * This is a continuation of a commandi,(CX) so this
+		 * sglq is on the active list
+		 */
+		sglq = __lpfc_get_active_sglq(phba, pwqe->sli4_lxritag);
+		if (!sglq)
+			return WQE_ERROR;
+	}
+
+	if (sglq) {
+		pwqe->sli4_lxritag = sglq->sli4_lxritag;
+		pwqe->sli4_xritag = sglq->sli4_xritag;
+		if (lpfc_wqe_bpl2sgl(phba, pwqe, sglq) == NO_XRI)
+			return WQE_ERROR;
+		bf_set(wqe_xri_tag, &pwqe->wqe.xmit_bls_rsp.wqe_com,
+		       pwqe->sli4_xritag);
+		if (cmd == CMD_XMIT_BLS_RSP64_WQE)
+			bf_set(xmit_bls_rsp64_rxid, &pwqe->wqe.xmit_bls_rsp,
+			       pwqe->sli4_xritag);
+	}
+
+	if ((pwqe->iocb_flag & LPFC_IO_FCP) ||
+	    (pwqe->iocb_flag & LPFC_IO_NVME) ||
+	    (pwqe->iocb_flag & LPFC_USE_FCPWQIDX)) {
+		if (!phba->cfg_fof || (!(pwqe->iocb_flag & LPFC_IO_OAS))) {
+			wq = phba->sli4_hba.hba_wq[pwqe->hba_wqidx];
+			bf_set(wqe_cqid, &wqe->generic.wqe_com,
+				phba->sli4_hba.nvme_cq[
+					pwqe->hba_wqidx]->queue_id);
+		} else {
+			wq = phba->sli4_hba.oas_wq;
+		}
+		if (lpfc_sli4_wq_put(wq, wqe))
+			return WQE_ERROR;
+	} else {
+		if (unlikely(!phba->sli4_hba.nvmels_wq))
+			return WQE_ERROR;
+		if (lpfc_sli4_wq_put(phba->sli4_hba.nvmels_wq, wqe))
+			return WQE_ERROR;
+	}
+	lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+
+	return 0;
+}
+
+/**
+ * lpfc_sli_issue_wqe - Wrapper function for __lpfc_sli_issue_wqe
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @pwqe: Pointer to command WQE.
+ * @flag: Flag indicating if this command can be put into txq.
+ **/
+int
+lpfc_sli_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
+		    struct lpfc_iocbq *pwqe)
+{
+	union lpfc_wqe *wqe = &pwqe->wqe;
+	struct lpfc_queue *wq;
+	struct lpfc_sglq *sglq;
+	struct lpfc_sli_ring *pring;
+	unsigned long iflags;
+
+	if (pwqe->iocb_flag & LPFC_IO_NVME_LS) {
+		pring = &phba->sli.ring[ring_number];
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		sglq = __lpfc_sli_get_sglq(phba, pwqe);
+		if (!sglq) {
+			spin_lock_irqsave(&pring->ring_lock, iflags);
+			return WQE_BUSY;
+		}
+		pwqe->sli4_lxritag = sglq->sli4_lxritag;
+		pwqe->sli4_xritag = sglq->sli4_xritag;
+		if (lpfc_wqe_bpl2sgl(phba, pwqe, sglq) == NO_XRI) {
+			spin_lock_irqsave(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		bf_set(wqe_xri_tag, &pwqe->wqe.xmit_bls_rsp.wqe_com,
+		       pwqe->sli4_xritag);
+		if (lpfc_sli4_wq_put(phba->sli4_hba.nvmels_wq, wqe)) {
+			spin_lock_irqsave(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		return 0;
+	}
+	if (pwqe->iocb_flag & LPFC_IO_NVME) {
+		/* hard code io_channel 0 for now */
+		pwqe->hba_wqidx = 0;
+		ring_number = MAX_SLI3_CONFIGURED_RINGS + pwqe->hba_wqidx;
+		pring = &phba->sli.ring[ring_number];
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		wq = phba->sli4_hba.hba_wq[pwqe->hba_wqidx];
+		bf_set(wqe_cqid, &wqe->generic.wqe_com,
+		      phba->sli4_hba.nvme_cq[pwqe->hba_wqidx]->queue_id);
+		if (lpfc_sli4_wq_put(wq, wqe)) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		return 0;
+	}
+	return WQE_ERROR;
+}
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 74227a2..09e49f9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -54,9 +54,15 @@ struct lpfc_iocbq {
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_lxritag;  /* logical pre-assigned XRI. */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
+	uint16_t hba_wqidx;     /* index to HBA work queue */
 	struct lpfc_cq_event cq_event;
+	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
 
-	IOCB_t iocb;		/* IOCB cmd */
+	/* Be careful here */
+	union lpfc_wqe wqe;	/* WQE cmd */
+	IOCB_t iocb;		/* For IOCB cmd or if we want 128 byte WQE */
+
+	uint8_t rsvd2;
 	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint32_t iocb_flag;
@@ -82,9 +88,13 @@ struct lpfc_iocbq {
 #define LPFC_IO_OAS		0x10000 /* OAS FCP IO */
 #define LPFC_IO_FOF		0x20000 /* FOF FCP IO */
 #define LPFC_IO_LOOPBACK	0x40000 /* Loopback IO */
+#define LPFC_PRLI_NVME_REQ	0x80000 /* This is an NVME PRLI. */
+#define LPFC_PRLI_FCP_REQ	0x100000 /* This is an NVME PRLI. */
+#define LPFC_IO_NVME		0x200000 /* NVME command */
+#define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
+#define LPFC_IO_NVMET		0x800000 /* NVMET command */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
-	uint32_t fcp_wqidx;	/* index to FCP work queue */
 	struct lpfc_vport *vport;/* virtual port pointer */
 	void *context1;		/* caller context information */
 	void *context2;		/* caller context information */
@@ -97,12 +107,14 @@ struct lpfc_iocbq {
 		struct lpfc_node_rrq *rrq;
 	} context_un;
 
-	void (*fabric_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+	void (*fabric_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-	void (*wait_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+	void (*wait_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-	void (*iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+	void (*iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
+	void (*wqe_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			  struct lpfc_wcqe_complete *);
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */
@@ -112,6 +124,14 @@ struct lpfc_iocbq {
 #define IOCB_ERROR          2
 #define IOCB_TIMEDOUT       3
 
+#define SLI_WQE_RET_WQE    1    /* Return WQE if cmd ring full */
+
+#define WQE_SUCCESS        0
+#define WQE_BUSY           1
+#define WQE_ERROR          2
+#define WQE_TIMEDOUT       3
+#define WQE_ABORTED        4
+
 #define LPFC_MBX_WAKE		1
 #define LPFC_MBX_IMED_UNREG	2
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 0b88b570..86da988 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -35,9 +35,9 @@
 #define LPFC_NEMBED_MBOX_SGL_CNT		254
 
 /* Multi-queue arrangement for FCP EQ/CQ/WQ tuples */
-#define LPFC_FCP_IO_CHAN_DEF       4
-#define LPFC_FCP_IO_CHAN_MIN       1
-#define LPFC_FCP_IO_CHAN_MAX       16
+#define LPFC_HBA_IO_CHAN_MIN       1
+#define LPFC_HBA_IO_CHAN_DEF       4
+#define LPFC_HBA_IO_CHAN_MAX       32
 
 /* Number of channels used for Flash Optimized Fabric (FOF) operations */
 
@@ -107,6 +107,9 @@ enum lpfc_sli4_queue_subtype {
 	LPFC_MBOX,
 	LPFC_FCP,
 	LPFC_ELS,
+	LPFC_NVME,
+	LPFC_NVMET,
+	LPFC_NVME_LS,
 	LPFC_USOL
 };
 
@@ -379,10 +382,10 @@ struct lpfc_max_cfg_param {
 
 struct lpfc_hba;
 /* SLI4 HBA multi-fcp queue handler struct */
-struct lpfc_fcp_eq_hdl {
+struct lpfc_hba_eq_hdl {
 	uint32_t idx;
 	struct lpfc_hba *phba;
-	atomic_t fcp_eq_in_use;
+	atomic_t hba_eq_in_use;
 };
 
 /* Port Capabilities for SLI4 Parameters */
@@ -445,7 +448,7 @@ struct lpfc_sli4_lnk_info {
 	uint8_t optic_state;
 };
 
-#define LPFC_SLI4_HANDLER_CNT		(LPFC_FCP_IO_CHAN_MAX+ \
+#define LPFC_SLI4_HANDLER_CNT		(LPFC_HBA_IO_CHAN_MAX+ \
 					 LPFC_FOF_IO_CHAN_NUM)
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 
@@ -517,18 +520,22 @@ struct lpfc_sli4_hba {
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct msix_entry *msix_entries;
 	uint8_t handler_name[LPFC_SLI4_HANDLER_CNT][LPFC_SLI4_HANDLER_NAME_SZ];
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
+	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
 	/* Pointers to the constructed SLI4 queues */
 	struct lpfc_queue **hba_eq;/* Event queues for HBA */
 	struct lpfc_queue **fcp_cq;/* Fast-path FCP compl queue */
-	struct lpfc_queue **fcp_wq;/* Fast-path FCP work queue */
+	struct lpfc_queue **nvme_cq;/* Fast-path FCP compl queue */
+	struct lpfc_queue **hba_wq;/* Fast-path FCP work queue */
 	uint16_t *fcp_cq_map;
+	uint16_t *nvme_cq_map;
 
 	struct lpfc_queue *mbx_cq; /* Slow-path mailbox complete queue */
 	struct lpfc_queue *els_cq; /* Slow-path ELS response complete queue */
+	struct lpfc_queue *nvmels_cq; /* NVMET LS complete queue */
 	struct lpfc_queue *mbx_wq; /* Slow-path MBOX work queue */
 	struct lpfc_queue *els_wq; /* Slow-path ELS work queue */
+	struct lpfc_queue *nvmels_wq; /* NVME LS work queue */
 	struct lpfc_queue *hdr_rq; /* Slow-path Header Receive queue */
 	struct lpfc_queue *dat_rq; /* Slow-path Data Receive queue */
 
@@ -694,7 +701,7 @@ struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
 			uint32_t);
 void lpfc_sli4_queue_free(struct lpfc_queue *);
 int lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
-int lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint32_t);
+int lpfc_modify_hba_eq_delay(struct lpfc_hba *, uint32_t);
 int lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
 int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index c27f4b7..d9c4bbc 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
-- 
2.5.0

