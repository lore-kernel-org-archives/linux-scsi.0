From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 06/16] lpfc: NVME Initiator: Base modifications
Date: Sun, 12 Feb 2017 13:52:30 -0800
Message-ID: <58a0d91e.dhVNcGxwBsHs5tB5%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35743 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdBLVwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:36 -0500
Received: by mail-oi0-f68.google.com with SMTP id x84so5873602oix.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This patch adds base modifications for NVME initiator support.

The base modifications consist of:
- Formal split of SLI3 rings from SLI-4 WQs (sometimes referred to as
  rings as well) as implementation now widely varies between the two.
- Addition of configuration modes:
   SCSI initiator only; NVME initiator only; NVME target only; and
   SCSI and NVME initiator.
   The configuration mode drives overall adapter configuration,
   offloads enabled, and resource splits.
   NVME support is only available on SLI-4 devices and newer fw.
- Implements the following based on configuration mode:
  - Exchange resources are split by protocol; Obviously, if only
     1 mode, then no split occurs. Default is 50/50. module attribute
     allows tuning.
  - Pools and config parameters are separated per-protocol
  - Each protocol has it's own set of queues, but share interrupt
    vectors.
     SCSI:
       SLI3 devices have few queues and the original style of queue
         allocation remains.
       SLI4 devices piggy back on an "io-channel" concept that
         eventually needs to merge with scsi-mq/blk-mq support (it is
	 underway).  For now, the paradigm continues as it existed
	 prior. io channel allocates N msix and N WQs (N=4 default)
	 and either round robins or uses cpu # modulo N for scheduling.
	 A bunch of module parameters allow the configuration to be
	 tuned.
     NVME (initiator):
       Allocates an msix per cpu (or whatever pci_alloc_irq_vectors
         gets)
       Allocates a WQ per cpu, and maps the WQs to msix on a WQ #
         modulo msix vector count basis.
       Module parameters exist to cap/control the config if desired.
  - Each protocol has its own buffer and dma pools.

I apologize for the size of the patch.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

----
---
 drivers/scsi/lpfc/lpfc.h           |   80 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  374 ++++++-
 drivers/scsi/lpfc/lpfc_bsg.c       |   27 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   27 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  178 ++-
 drivers/scsi/lpfc/lpfc_debugfs.h   |   72 +-
 drivers/scsi/lpfc/lpfc_els.c       |   38 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  157 ++-
 drivers/scsi/lpfc/lpfc_hw.h        |    3 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |   63 +-
 drivers/scsi/lpfc/lpfc_init.c      | 2141 ++++++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_logmsg.h    |    4 +
 drivers/scsi/lpfc/lpfc_mbox.c      |   23 +-
 drivers/scsi/lpfc/lpfc_mem.c       |   62 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |    7 +-
 drivers/scsi/lpfc/lpfc_nvme.h      |   88 ++
 drivers/scsi/lpfc/lpfc_scsi.c      |  101 +-
 drivers/scsi/lpfc/lpfc_scsi.h      |    6 +
 drivers/scsi/lpfc/lpfc_sli.c       | 1429 +++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_sli.h       |   30 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   75 +-
 drivers/scsi/lpfc/lpfc_vport.c     |    2 +
 22 files changed, 3353 insertions(+), 1634 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8e0d6f4..77ad757 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -20,6 +20,7 @@
  *******************************************************************/
 
 #include <scsi/scsi_host.h>
+#include <linux/ktime.h>
 
 #if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_SCSI_LPFC_DEBUG_FS)
 #define CONFIG_SCSI_LPFC_DEBUG_FS
@@ -53,6 +54,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
 #define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
 #define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
+#define LPFC_MIN_NVME_SEG_CNT	254
 
 #define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
@@ -114,6 +116,13 @@ enum lpfc_polling_flags {
 	DISABLE_FCP_RING_INT    = 0x2
 };
 
+struct perf_prof {
+	uint16_t cmd_cpu[40];
+	uint16_t rsp_cpu[40];
+	uint16_t qh_cpu[40];
+	uint16_t wqidx[40];
+};
+
 /* Provide DMA memory definitions the driver uses per port instance. */
 struct lpfc_dmabuf {
 	struct list_head list;
@@ -131,10 +140,24 @@ struct lpfc_dma_pool {
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
+};
+
+struct rqb_dmabuf {
+	struct lpfc_dmabuf hbuf;
+	struct lpfc_dmabuf dbuf;
+	uint16_t total_size;
+	uint16_t bytes_recv;
+	void *context;
+	struct lpfc_iocbq *iocbq;
+	struct lpfc_sglq *sglq;
+	struct lpfc_queue *hrq;	  /* ptr to associated Header RQ */
+	struct lpfc_queue *drq;	  /* ptr to associated Data RQ */
 };
 
 /* Priority bit.  Set value to exceed low water mark in lpfc_mem. */
@@ -442,6 +465,11 @@ struct lpfc_vport {
 	uint16_t fdmi_num_disc;
 	uint32_t fdmi_hba_mask;
 	uint32_t fdmi_port_mask;
+
+	/* There is a single nvme instance per vport. */
+	struct nvme_fc_local_port *localport;
+	uint8_t  nvmei_support; /* driver supports NVME Initiator */
+	uint32_t last_fcp_wqidx;
 };
 
 struct hbq_s {
@@ -459,10 +487,9 @@ struct hbq_s {
 					       struct hbq_dmabuf *);
 };
 
-#define LPFC_MAX_HBQS  4
 /* this matches the position in the lpfc_hbq_defs array */
 #define LPFC_ELS_HBQ	0
-#define LPFC_EXTRA_HBQ	1
+#define LPFC_MAX_HBQS	1
 
 enum hba_temp_state {
 	HBA_NORMAL_TEMP,
@@ -652,6 +679,8 @@ struct lpfc_hba {
 					 * Firmware supports Forced Link Speed
 					 * capability
 					 */
+#define HBA_NVME_IOQ_FLUSH      0x80000 /* NVME IO queues flushed. */
+
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
@@ -700,6 +729,8 @@ struct lpfc_hba {
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
 	uint8_t  fcp_embed_io;
+	uint8_t  nvme_support;	/* Firmware supports NVME */
+	uint8_t  nvmet_support;	/* driver supports NVMET */
 	uint8_t  mds_diags_support;
 
 	/* HBA Config Parameters */
@@ -725,6 +756,9 @@ struct lpfc_hba {
 	uint32_t cfg_fcp_imax;
 	uint32_t cfg_fcp_cpu_map;
 	uint32_t cfg_fcp_io_channel;
+	uint32_t cfg_nvme_oas;
+	uint32_t cfg_nvme_io_channel;
+	uint32_t cfg_nvme_enable_fb;
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
@@ -770,6 +804,12 @@ struct lpfc_hba {
 #define LPFC_FDMI_SUPPORT	1	/* FDMI supported? */
 	uint32_t cfg_enable_SmartSAN;
 	uint32_t cfg_enable_mds_diags;
+	uint32_t cfg_enable_fc4_type;
+	uint32_t cfg_xri_split;
+#define LPFC_ENABLE_FCP  1
+#define LPFC_ENABLE_NVME 2
+#define LPFC_ENABLE_BOTH 3
+	uint32_t io_channel_irqs;	/* number of irqs for io channels */
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
@@ -784,11 +824,11 @@ struct lpfc_hba {
 	unsigned long data_flags;
 
 	uint32_t hbq_in_use;		/* HBQs in use flag */
-	struct list_head rb_pend_list;  /* Received buffers to be processed */
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
-	atomic_t fcp_qidx;		/* next work queue to post work to */
+	atomic_t fcp_qidx;         /* next FCP WQ (RR Policy) */
+	atomic_t nvme_qidx;        /* next NVME WQ (RR Policy) */
 
 	phys_addr_t pci_bar0_map;     /* Physical address for PCI BAR0 */
 	phys_addr_t pci_bar1_map;     /* Physical address for PCI BAR1 */
@@ -843,9 +883,17 @@ struct lpfc_hba {
 	/*
 	 * stat  counters
 	 */
-	uint64_t fc4InputRequests;
-	uint64_t fc4OutputRequests;
-	uint64_t fc4ControlRequests;
+	uint64_t fc4ScsiInputRequests;
+	uint64_t fc4ScsiOutputRequests;
+	uint64_t fc4ScsiControlRequests;
+	uint64_t fc4ScsiIoCmpls;
+	uint64_t fc4NvmeInputRequests;
+	uint64_t fc4NvmeOutputRequests;
+	uint64_t fc4NvmeControlRequests;
+	uint64_t fc4NvmeIoCmpls;
+	uint64_t fc4NvmeLsRequests;
+	uint64_t fc4NvmeLsCmpls;
+
 	uint64_t bg_guard_err_cnt;
 	uint64_t bg_apptag_err_cnt;
 	uint64_t bg_reftag_err_cnt;
@@ -856,17 +904,23 @@ struct lpfc_hba {
 	struct list_head lpfc_scsi_buf_list_get;
 	struct list_head lpfc_scsi_buf_list_put;
 	uint32_t total_scsi_bufs;
+	spinlock_t nvme_buf_list_get_lock;  /* NVME buf alloc list lock */
+	spinlock_t nvme_buf_list_put_lock;  /* NVME buf free list lock */
+	struct list_head lpfc_nvme_buf_list_get;
+	struct list_head lpfc_nvme_buf_list_put;
+	uint32_t total_nvme_bufs;
 	struct list_head lpfc_iocb_list;
 	uint32_t total_iocbq_bufs;
 	struct list_head active_rrq_list;
 	spinlock_t hbalock;
 
 	/* pci_mem_pools */
-	struct pci_pool *lpfc_scsi_dma_buf_pool;
+	struct pci_pool *lpfc_sg_dma_buf_pool;
 	struct pci_pool *lpfc_mbuf_pool;
 	struct pci_pool *lpfc_hrb_pool;	/* header receive buffer pool */
 	struct pci_pool *lpfc_drb_pool; /* data receive buffer pool */
 	struct pci_pool *lpfc_hbq_pool;	/* SLI3 hbq buffer pool */
+	struct pci_pool *txrdy_payload_pool;
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
 
 	mempool_t *mbox_mem_pool;
@@ -1092,3 +1146,11 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 
 	return 0;
 }
+
+static inline struct lpfc_sli_ring *
+lpfc_phba_elsring(struct lpfc_hba *phba)
+{
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return phba->sli4_hba.els_wq->pring;
+	return &phba->sli.sli3_ring[LPFC_ELS_RING];
+}
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ce41dea..b91b4bb 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -35,14 +35,17 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/fc/fc_fs.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_version.h"
 #include "lpfc_compat.h"
@@ -130,6 +133,124 @@ lpfc_enable_fip_show(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = shost_priv(shost);
+	struct lpfc_hba   *phba = vport->phba;
+	struct nvme_fc_local_port *localport;
+	struct lpfc_nvme_lport *lport;
+	struct lpfc_nvme_rport *rport;
+	struct nvme_fc_remote_port *nrport;
+	char *statep;
+	int len = 0;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
+		len += snprintf(buf, PAGE_SIZE, "NVME Disabled\n");
+		return len;
+	}
+
+	localport = vport->localport;
+	if (!localport) {
+		len = snprintf(buf, PAGE_SIZE,
+				"NVME Initiator x%llx is not allocated\n",
+				wwn_to_u64(vport->fc_portname.u.wwn));
+		return len;
+	}
+	len = snprintf(buf, PAGE_SIZE, "NVME Initiator Enabled\n");
+
+	spin_lock_irq(shost->host_lock);
+	lport = (struct lpfc_nvme_lport *)localport->private;
+
+	/* Port state is only one of two values for now. */
+	if (localport->port_id)
+		statep = "ONLINE";
+	else
+		statep = "UNKNOWN ";
+
+	len += snprintf(buf + len, PAGE_SIZE - len,
+			"%s%d WWPN x%llx WWNN x%llx DID x%06x %s\n",
+			"NVME LPORT lpfc",
+			phba->brd_no,
+			wwn_to_u64(vport->fc_portname.u.wwn),
+			wwn_to_u64(vport->fc_nodename.u.wwn),
+			localport->port_id, statep);
+
+	list_for_each_entry(rport, &lport->rport_list, list) {
+		/* local short-hand pointer. */
+		nrport = rport->remoteport;
+
+		/* Port state is only one of two values for now. */
+		switch (nrport->port_state) {
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
+
+		/* Tab in to show lport ownership. */
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"NVME RPORT       ");
+		if (phba->brd_no >= 10)
+			len += snprintf(buf + len, PAGE_SIZE - len, " ");
+
+		len += snprintf(buf + len, PAGE_SIZE - len, "WWPN x%llx ",
+				nrport->port_name);
+		len += snprintf(buf + len, PAGE_SIZE - len, "WWNN x%llx ",
+				nrport->node_name);
+		len += snprintf(buf + len, PAGE_SIZE - len, "DID x%06x ",
+				nrport->port_id);
+
+		switch (nrport->port_role) {
+		case FC_PORT_ROLE_NVME_INITIATOR:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "INITIATOR ");
+			break;
+		case FC_PORT_ROLE_NVME_TARGET:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "TARGET ");
+			break;
+		case FC_PORT_ROLE_NVME_DISCOVERY:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "DISCOVERY ");
+			break;
+		default:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "UNKNOWN_ROLE x%x",
+					 nrport->port_role);
+			break;
+		}
+		len +=  snprintf(buf + len, PAGE_SIZE - len, "%s  ", statep);
+		/* Terminate the string. */
+		len +=  snprintf(buf + len, PAGE_SIZE - len, "\n");
+	}
+	spin_unlock_irq(shost->host_lock);
+
+	len += snprintf(buf + len, PAGE_SIZE, "\nNVME Statistics\n");
+	len += snprintf(buf+len, PAGE_SIZE-len,
+			"LS: Xmt %016llx Cmpl %016llx\n",
+			phba->fc4NvmeLsRequests,
+			phba->fc4NvmeLsCmpls);
+
+	len += snprintf(buf+len, PAGE_SIZE-len,
+			"FCP: Rd %016llx Wr %016llx IO %016llx\n",
+			phba->fc4NvmeInputRequests,
+			phba->fc4NvmeOutputRequests,
+			phba->fc4NvmeControlRequests);
+
+	len += snprintf(buf+len, PAGE_SIZE-len,
+			"    Cmpl %016llx\n", phba->fc4NvmeIoCmpls);
+
+	return len;
+}
+
+static ssize_t
 lpfc_bg_info_show(struct device *dev, struct device_attribute *attr,
 		  char *buf)
 {
@@ -675,6 +796,28 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 	return 0;
 }
 
+int
+lpfc_emptyq_wait(struct lpfc_hba *phba, struct list_head *q, spinlock_t *lock)
+{
+	int cnt = 0;
+
+	spin_lock_irq(lock);
+	while (!list_empty(q)) {
+		spin_unlock_irq(lock);
+		msleep(20);
+		if (cnt++ > 250) {  /* 5 secs */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0466 %s %s\n",
+					"Outstanding IO when ",
+					"bringing Adapter offline\n");
+				return 0;
+		}
+		spin_lock_irq(lock);
+	}
+	spin_unlock_irq(lock);
+	return 1;
+}
+
 /**
  * lpfc_do_offline - Issues a mailbox command to bring the link down
  * @phba: lpfc_hba pointer.
@@ -694,10 +837,10 @@ static int
 lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 {
 	struct completion online_compl;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	int status = 0;
-	int cnt = 0;
 	int i;
 	int rc;
 
@@ -717,20 +860,24 @@ lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 	/* Wait a little for things to settle down, but not
 	 * long enough for dev loss timeout to expire.
 	 */
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		while (!list_empty(&pring->txcmplq)) {
-			msleep(10);
-			if (cnt++ > 500) {  /* 5 secs */
-				lpfc_printf_log(phba,
-					KERN_WARNING, LOG_INIT,
-					"0466 Outstanding IO when "
-					"bringing Adapter offline\n");
-				break;
-			}
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			if (!lpfc_emptyq_wait(phba, &pring->txcmplq,
+					      &phba->hbalock))
+				goto out;
+		}
+	} else {
+		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+			pring = qp->pring;
+			if (!pring)
+				continue;
+			if (!lpfc_emptyq_wait(phba, &pring->txcmplq,
+					      &pring->ring_lock))
+				goto out;
 		}
 	}
-
+out:
 	init_completion(&online_compl);
 	rc = lpfc_workq_post_event(phba, &status, &online_compl, type);
 	if (rc == 0)
@@ -1945,6 +2092,7 @@ lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
 }
 
 
+static DEVICE_ATTR(nvme_info, 0444, lpfc_nvme_info_show, NULL);
 static DEVICE_ATTR(bg_info, S_IRUGO, lpfc_bg_info_show, NULL);
 static DEVICE_ATTR(bg_guard_err, S_IRUGO, lpfc_bg_guard_err_show, NULL);
 static DEVICE_ATTR(bg_apptag_err, S_IRUGO, lpfc_bg_apptag_err_show, NULL);
@@ -2816,9 +2964,9 @@ lpfc_txq_hw_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+	struct lpfc_sli_ring *pring = lpfc_phba_elsring(phba);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-		phba->sli.ring[LPFC_ELS_RING].txq_max);
+	return snprintf(buf, PAGE_SIZE, "%d\n", pring->txq_max);
 }
 
 static DEVICE_ATTR(txq_hw, S_IRUGO,
@@ -2829,9 +2977,9 @@ lpfc_txcmplq_hw_show(struct device *dev, struct device_attribute *attr,
 {
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+	struct lpfc_sli_ring *pring = lpfc_phba_elsring(phba);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-		phba->sli.ring[LPFC_ELS_RING].txcmplq_max);
+	return snprintf(buf, PAGE_SIZE, "%d\n", pring->txcmplq_max);
 }
 
 static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
@@ -3030,6 +3178,31 @@ static DEVICE_ATTR(lpfc_devloss_tmo, S_IRUGO | S_IWUSR,
 		   lpfc_devloss_tmo_show, lpfc_devloss_tmo_store);
 
 /*
+ * lpfc_enable_fc4_type: Defines what FC4 types are supported.
+ * Supported Values:  1 - register just FCP
+ *                    3 - register both FCP and NVME
+ * Supported values are [1,3]. Default value is 3
+ */
+LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
+	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
+	    "Define fc4 type to register with fabric.");
+
+/*
+ * lpfc_xri_split: Defines the division of XRI resources between SCSI and NVME
+ * This parameter is only used if:
+ *     lpfc_enable_fc4_type is 3 - register both FCP and NVME
+ *
+ * ELS/CT always get 10% of XRIs, up to a maximum of 250
+ * The remaining XRIs get split up based on lpfc_xri_split per port:
+ *
+ * Supported Values are in percentages
+ * the xri_split value is the percentage the SCSI port will get. The remaining
+ * percentage will go to NVME.
+ */
+LPFC_ATTR_R(xri_split, 50, 10, 90,
+	     "Division of XRI resources between SCSI and NVME");
+
+/*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
 # deluged with LOTS of information.
 # You can set a bit mask to record specific types of verbose messages:
@@ -4143,13 +4316,14 @@ lpfc_fcp_imax_store(struct device *dev, struct device_attribute *attr,
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
+	for (i = 0; i < phba->io_channel_irqs; i++)
+		lpfc_modify_hba_eq_delay(phba, i);
 
 	return strlen(buf);
 }
@@ -4187,7 +4361,8 @@ lpfc_fcp_imax_init(struct lpfc_hba *phba, int val)
 		return 0;
 	}
 
-	if (val >= LPFC_MIN_IMAX && val <= LPFC_MAX_IMAX) {
+	if ((val >= LPFC_MIN_IMAX && val <= LPFC_MAX_IMAX) ||
+	    (val == 0)) {
 		phba->cfg_fcp_imax = val;
 		return 0;
 	}
@@ -4377,6 +4552,17 @@ LPFC_VPORT_ATTR_RW(first_burst_size, 0, 0, 65536,
 		   "First burst size for Targets that support first burst");
 
 /*
+* lpfc_nvme_enable_fb: Enable NVME first burst on I and T functions.
+* For the Initiator (I), enabling this parameter means that an NVME
+* PRLI response with FBA enabled and an FB_SIZE set to a nonzero value
+* will be processed by the initiator for subsequent NVME FCP IO.
+* Parameter supported on physical port only - no NPIV support.
+* Value range is [0,1]. Default value is 0 (disabled).
+*/
+LPFC_ATTR_RW(nvme_enable_fb, 0, 0, 1,
+	     "Enable First Burst feature on I and T functions.");
+
+/*
 # lpfc_max_scsicmpl_time: Use scsi command completion time to control I/O queue
 # depth. Default value is 0. When the value of this parameter is zero the
 # SCSI command completion time is not used for controlling I/O queue depth. When
@@ -4423,17 +4609,25 @@ static DEVICE_ATTR(lpfc_max_scsicmpl_time, S_IRUGO | S_IWUSR,
 LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 support");
 
 /*
-# lpfc_fcp_io_sched: Determine scheduling algrithmn for issuing FCP cmds
-# range is [0,1]. Default value is 0.
-# For [0], FCP commands are issued to Work Queues ina round robin fashion.
-# For [1], FCP commands are issued to a Work Queue associated with the
-#          current CPU.
-# It would be set to 1 by the driver if it's able to set up cpu affinity
-# for FCP I/Os through Work Queue associated with the current CPU. Otherwise,
-# roundrobin scheduling of FCP I/Os through WQs will be used.
-*/
-LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algorithm for "
-		"issuing commands [0] - Round Robin, [1] - Current CPU");
+ * lpfc_io_sched: Determine scheduling algrithmn for issuing FCP cmds
+ * range is [0,1]. Default value is 0.
+ * For [0], FCP commands are issued to Work Queues ina round robin fashion.
+ * For [1], FCP commands are issued to a Work Queue associated with the
+ *          current CPU.
+ *
+ * LPFC_FCP_SCHED_ROUND_ROBIN == 0
+ * LPFC_FCP_SCHED_BY_CPU == 1
+ *
+ * The driver dynamically sets this to 1 (BY_CPU) if it's able to set up cpu
+ * affinity for FCP/NVME I/Os through Work Queues associated with the current
+ * CPU. Otherwise, the default 0 (Round Robin) scheduling of FCP/NVME I/Os
+ * through WQs will be used.
+ */
+LPFC_ATTR_RW(fcp_io_sched, LPFC_FCP_SCHED_ROUND_ROBIN,
+	     LPFC_FCP_SCHED_ROUND_ROBIN,
+	     LPFC_FCP_SCHED_BY_CPU,
+	     "Determine scheduling algorithm for "
+	     "issuing commands [0] - Round Robin, [1] - Current CPU");
 
 /*
 # lpfc_fcp2_no_tgt_reset: Determine bus reset behavior
@@ -4560,15 +4754,54 @@ LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
-# lpfc_fcp_io_channel: Set the number of FCP EQ/CQ/WQ IO channels
-#
-# Value range is [1,7]. Default value is 4.
-*/
-LPFC_ATTR_R(fcp_io_channel, LPFC_FCP_IO_CHAN_DEF, LPFC_FCP_IO_CHAN_MIN,
-	    LPFC_FCP_IO_CHAN_MAX,
+ * lpfc_nvme_oas: Use the oas bit when sending NVME IOs
+ *
+ *      0  = NVME OAS disabled
+ *      1  = NVME OAS enabled
+ *
+ * Value range is [0,1]. Default value is 0.
+ */
+LPFC_ATTR_RW(nvme_oas, 0, 0, 1,
+	     "Use OAS bit on NVME IOs");
+
+/*
+ * lpfc_fcp_io_channel: Set the number of FCP IO channels the driver
+ * will advertise it supports to the SCSI layer. This also will map to
+ * the number of WQs the driver will create.
+ *
+ *      0    = Configure the number of io channels to the number of active CPUs.
+ *      1,32 = Manually specify how many io channels to use.
+ *
+ * Value range is [0,32]. Default value is 4.
+ */
+LPFC_ATTR_R(fcp_io_channel,
+	    LPFC_FCP_IO_CHAN_DEF,
+	    LPFC_HBA_IO_CHAN_MIN, LPFC_HBA_IO_CHAN_MAX,
 	    "Set the number of FCP I/O channels");
 
 /*
+ * lpfc_nvme_io_channel: Set the number of IO hardware queues the driver
+ * will advertise it supports to the NVME layer. This also will map to
+ * the number of WQs the driver will create.
+ *
+ * This module parameter is valid when lpfc_enable_fc4_type is set
+ * to support NVME.
+ *
+ * The NVME Layer will try to create this many, plus 1 administrative
+ * hardware queue. The administrative queue will always map to WQ 0
+ * A hardware IO queue maps (qidx) to a specific driver WQ.
+ *
+ *      0    = Configure the number of io channels to the number of active CPUs.
+ *      1,32 = Manually specify how many io channels to use.
+ *
+ * Value range is [0,32]. Default value is 0.
+ */
+LPFC_ATTR_R(nvme_io_channel,
+	    LPFC_NVME_IO_CHAN_DEF,
+	    LPFC_HBA_IO_CHAN_MIN, LPFC_HBA_IO_CHAN_MAX,
+	    "Set the number of NVME I/O channels");
+
+/*
 # lpfc_enable_hba_reset: Allow or prevent HBA resets to the hardware.
 #       0  = HBA resets disabled
 #       1  = HBA resets enabled (default)
@@ -4692,6 +4925,7 @@ LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
 LPFC_ATTR_R(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
 
 struct device_attribute *lpfc_hba_attrs[] = {
+	&dev_attr_nvme_info,
 	&dev_attr_bg_info,
 	&dev_attr_bg_guard_err,
 	&dev_attr_bg_apptag_err,
@@ -4718,6 +4952,8 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
+	&dev_attr_lpfc_enable_fc4_type,
+	&dev_attr_lpfc_xri_split,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
 	&dev_attr_lpfc_first_burst_size,
@@ -4752,9 +4988,12 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_poll_tmo,
 	&dev_attr_lpfc_task_mgmt_tmo,
 	&dev_attr_lpfc_use_msi,
+	&dev_attr_lpfc_nvme_oas,
 	&dev_attr_lpfc_fcp_imax,
 	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
+	&dev_attr_lpfc_nvme_io_channel,
+	&dev_attr_lpfc_nvme_enable_fb,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
@@ -5764,9 +6003,9 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
 	lpfc_enable_SmartSAN_init(phba, lpfc_enable_SmartSAN);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
+	lpfc_nvme_oas_init(phba, lpfc_nvme_oas);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
 	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
-	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
 
@@ -5789,8 +6028,43 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	else
 		phba->cfg_poll = lpfc_poll;
 
+	lpfc_enable_fc4_type_init(phba, lpfc_enable_fc4_type);
+
+	/* Initialize first burst. Target vs Initiator are different. */
+	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
+	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
+	lpfc_nvme_io_channel_init(phba, lpfc_nvme_io_channel);
+
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		/* NVME only supported on SLI4 */
+		phba->nvmet_support = 0;
+		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
+	} else {
+		/* We MUST have FCP support */
+		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+			phba->cfg_enable_fc4_type |= LPFC_ENABLE_FCP;
+	}
+
+	/* A value of 0 means use the number of CPUs found in the system */
+	if (phba->cfg_nvme_io_channel == 0)
+		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
+	if (phba->cfg_fcp_io_channel == 0)
+		phba->cfg_fcp_io_channel = phba->sli4_hba.num_present_cpu;
+
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)
+		phba->cfg_nvme_io_channel = 0;
+
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
+		phba->cfg_fcp_io_channel = 0;
+
+	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+	else
+		phba->io_channel_irqs = phba->cfg_nvme_io_channel;
+
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
+	lpfc_xri_split_init(phba, lpfc_xri_split);
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
@@ -5807,6 +6081,26 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_nvme_mod_param_dep - Adjust module parameter value based on
+ * dependencies between protocols and roles.
+ * @phba: lpfc_hba pointer.
+ **/
+void
+lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
+{
+	phba->nvmet_support = 0;
+	if (phba->cfg_nvme_io_channel > phba->sli4_hba.num_present_cpu)
+		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
+	if (phba->cfg_fcp_io_channel > phba->sli4_hba.num_present_cpu)
+		phba->cfg_fcp_io_channel = phba->sli4_hba.num_present_cpu;
+
+	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+	else
+		phba->io_channel_irqs = phba->cfg_nvme_io_channel;
+}
+
+/**
  * lpfc_get_vport_cfgparam - Used during port create, init the vport structure
  * @vport: lpfc_vport pointer.
  **/
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 1ee131f..55a2270 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1704,6 +1704,7 @@ lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba)
 	struct lpfc_vport **vports;
 	struct Scsi_Host *shost;
 	struct lpfc_sli *psli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	int i = 0;
 
@@ -1711,9 +1712,6 @@ lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba)
 	if (!psli)
 		return -ENODEV;
 
-	pring = &psli->ring[LPFC_FCP_RING];
-	if (!pring)
-		return -ENODEV;
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 	    (psli->sli_flag & LPFC_BLOCK_MGMT_IO) ||
@@ -1732,10 +1730,18 @@ lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba)
 		scsi_block_requests(shost);
 	}
 
-	while (!list_empty(&pring->txcmplq)) {
-		if (i++ > 500)  /* wait up to 5 seconds */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		pring = &psli->sli3_ring[LPFC_FCP_RING];
+		lpfc_emptyq_wait(phba, &pring->txcmplq, &phba->hbalock);
+		return 0;
+	}
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring || (pring->ringno != LPFC_FCP_RING))
+			continue;
+		if (!lpfc_emptyq_wait(phba, &pring->txcmplq,
+				      &pring->ring_lock))
 			break;
-		msleep(10);
 	}
 	return 0;
 }
@@ -2875,8 +2881,7 @@ diag_cmd_data_alloc(struct lpfc_hba *phba,
 static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 			     size_t len)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *cmdiocbq;
 	IOCB_t *cmd = NULL;
 	struct list_head head, *curr, *next;
@@ -2890,6 +2895,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	int iocb_stat;
 	int i = 0;
 
+	pring = lpfc_phba_elsring(phba);
+
 	cmdiocbq = lpfc_sli_get_iocbq(phba);
 	rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (rxbmp != NULL) {
@@ -5403,13 +5410,15 @@ lpfc_bsg_timeout(struct bsg_job *job)
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct bsg_job_data *dd_data;
 	unsigned long flags;
 	int rc = 0;
 	LIST_HEAD(completions);
 	struct lpfc_iocbq *check_iocb, *next_iocb;
 
+	pring = lpfc_phba_elsring(phba);
+
 	/* if job's driver data is NULL, the command completed or is in the
 	 * the process of completing.  In this case, return status to request
 	 * so the timeout is retried.  This avoids double completion issues
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 309643a..2e6345e 100644
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
+int lpfc_issue_gidft(struct lpfc_vport *vport);
+int lpfc_get_gidft_type(struct lpfc_vport *vport, struct lpfc_iocbq *iocbq);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int, uint32_t);
 void lpfc_fdmi_num_disc_check(struct lpfc_vport *);
@@ -186,6 +189,8 @@ void lpfc_unblock_mgmt_io(struct lpfc_hba *);
 void lpfc_offline_prep(struct lpfc_hba *, int);
 void lpfc_offline(struct lpfc_hba *);
 void lpfc_reset_hba(struct lpfc_hba *);
+int lpfc_emptyq_wait(struct lpfc_hba *phba, struct list_head *hd,
+			spinlock_t *slock);
 
 int lpfc_fof_queue_create(struct lpfc_hba *);
 int lpfc_fof_queue_setup(struct lpfc_hba *);
@@ -193,7 +198,11 @@ int lpfc_fof_queue_destroy(struct lpfc_hba *);
 irqreturn_t lpfc_sli4_fof_intr_handler(int, void *);
 
 int lpfc_sli_setup(struct lpfc_hba *);
-int lpfc_sli_queue_setup(struct lpfc_hba *);
+int lpfc_sli4_setup(struct lpfc_hba *phba);
+void lpfc_sli_queue_init(struct lpfc_hba *phba);
+void lpfc_sli4_queue_init(struct lpfc_hba *phba);
+struct lpfc_sli_ring *lpfc_sli4_calc_ring(struct lpfc_hba *phba,
+					  struct lpfc_iocbq *iocbq);
 
 void lpfc_handle_eratt(struct lpfc_hba *);
 void lpfc_handle_latt(struct lpfc_hba *);
@@ -233,6 +242,11 @@ struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
+int lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
+		     struct lpfc_rqe *hrqe, struct lpfc_rqe *drqe);
+int lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hq,
+			struct lpfc_queue *dq, int count);
+int lpfc_free_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hq);
 void lpfc_unregister_fcf(struct lpfc_hba *);
 void lpfc_unregister_fcf_rescan(struct lpfc_hba *);
 void lpfc_unregister_unused_fcf(struct lpfc_hba *);
@@ -287,6 +301,9 @@ void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
+int lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t rnum,
+			struct lpfc_iocbq *iocbq);
+struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
@@ -356,6 +373,7 @@ extern struct device_attribute *lpfc_hba_attrs[];
 extern struct device_attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_template_s3;
+extern struct scsi_host_template lpfc_template_nvme;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
@@ -471,7 +489,9 @@ int lpfc_issue_unreg_vfi(struct lpfc_vport *);
 int lpfc_selective_reset(struct lpfc_hba *);
 int lpfc_sli4_read_config(struct lpfc_hba *);
 void lpfc_sli4_node_prep(struct lpfc_hba *);
-int lpfc_sli4_xri_sgl_update(struct lpfc_hba *);
+int lpfc_sli4_els_sgl_update(struct lpfc_hba *phba);
+int lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba);
+int lpfc_sli4_nvme_sgl_update(struct lpfc_hba *phba);
 void lpfc_free_sgl_list(struct lpfc_hba *, struct list_head *);
 uint32_t lpfc_sli_port_speed_get(struct lpfc_hba *);
 int lpfc_sli4_request_firmware_update(struct lpfc_hba *, uint8_t);
@@ -496,3 +516,6 @@ bool lpfc_find_next_oas_lun(struct lpfc_hba *, struct lpfc_name *,
 			    uint32_t *, uint32_t *);
 int lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox);
 void lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
+
+/* NVME interfaces. */
+void lpfc_nvme_mod_param_dep(struct lpfc_hba *phba);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index f8f47af..a0d817d 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -484,20 +484,23 @@ lpfc_debugfs_dumpHostSlim_data(struct lpfc_hba *phba, char *buf, int size)
 		off += (8 * sizeof(uint32_t));
 	}
 
-	for (i = 0; i < 4; i++) {
-		pgpp = &phba->port_gp[i];
-		pring = &psli->ring[i];
-		len +=  snprintf(buf+len, size-len,
-				 "Ring %d: CMD GetInx:%d (Max:%d Next:%d "
-				 "Local:%d flg:x%x)  RSP PutInx:%d Max:%d\n",
-				 i, pgpp->cmdGetInx, pring->sli.sli3.numCiocb,
-				 pring->sli.sli3.next_cmdidx,
-				 pring->sli.sli3.local_getidx,
-				 pring->flag, pgpp->rspPutInx,
-				 pring->sli.sli3.numRiocb);
-	}
-
 	if (phba->sli_rev <= LPFC_SLI_REV3) {
+		for (i = 0; i < 4; i++) {
+			pgpp = &phba->port_gp[i];
+			pring = &psli->sli3_ring[i];
+			len +=  snprintf(buf+len, size-len,
+					 "Ring %d: CMD GetInx:%d "
+					 "(Max:%d Next:%d "
+					 "Local:%d flg:x%x)  "
+					 "RSP PutInx:%d Max:%d\n",
+					 i, pgpp->cmdGetInx,
+					 pring->sli.sli3.numCiocb,
+					 pring->sli.sli3.next_cmdidx,
+					 pring->sli.sli3.local_getidx,
+					 pring->flag, pgpp->rspPutInx,
+					 pring->sli.sli3.numRiocb);
+		}
+
 		word0 = readl(phba->HAregaddr);
 		word1 = readl(phba->CAregaddr);
 		word2 = readl(phba->HSregaddr);
@@ -535,6 +538,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
 
+	len += snprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (!cnt) {
@@ -2011,6 +2015,14 @@ lpfc_idiag_wqs_for_cq(struct lpfc_hba *phba, char *wqtype, char *pbuffer,
 		if (*len >= max_cnt)
 			return 1;
 	}
+	for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++) {
+		qp = phba->sli4_hba.nvme_wq[qidx];
+		if (qp->assoc_qid != cq_id)
+			continue;
+		*len = __lpfc_idiag_print_wq(qp, wqtype, pbuffer, *len);
+		if (*len >= max_cnt)
+			return 1;
+	}
 	return 0;
 }
 
@@ -2096,6 +2108,25 @@ lpfc_idiag_cqs_for_eq(struct lpfc_hba *phba, char *pbuffer,
 			return 1;
 	}
 
+	for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++) {
+		qp = phba->sli4_hba.nvme_cq[qidx];
+		if (qp->assoc_qid != eq_id)
+			continue;
+
+		*len = __lpfc_idiag_print_cq(qp, "NVME", pbuffer, *len);
+
+		/* Reset max counter */
+		qp->CQ_max_cqe = 0;
+
+		if (*len >= max_cnt)
+			return 1;
+
+		rc = lpfc_idiag_wqs_for_cq(phba, "NVME", pbuffer, len,
+				max_cnt, qp->queue_id);
+		if (rc)
+			return 1;
+	}
+
 	return 0;
 }
 
@@ -2162,21 +2193,21 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 	spin_lock_irq(&phba->hbalock);
 
 	/* Fast-path event queue */
-	if (phba->sli4_hba.hba_eq && phba->cfg_fcp_io_channel) {
+	if (phba->sli4_hba.hba_eq && phba->io_channel_irqs) {
 
 		x = phba->lpfc_idiag_last_eq;
-		if (phba->cfg_fof && (x >= phba->cfg_fcp_io_channel)) {
+		if (phba->cfg_fof && (x >= phba->io_channel_irqs)) {
 			phba->lpfc_idiag_last_eq = 0;
 			goto fof;
 		}
 		phba->lpfc_idiag_last_eq++;
-		if (phba->lpfc_idiag_last_eq >= phba->cfg_fcp_io_channel)
+		if (phba->lpfc_idiag_last_eq >= phba->io_channel_irqs)
 			if (phba->cfg_fof == 0)
 				phba->lpfc_idiag_last_eq = 0;
 
 		len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 					"EQ %d out of %d HBA EQs\n",
-					x, phba->cfg_fcp_io_channel);
+					x, phba->io_channel_irqs);
 
 		/* Fast-path EQ */
 		qp = phba->sli4_hba.hba_eq[x];
@@ -2191,6 +2222,7 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 		if (len >= max_cnt)
 			goto too_big;
 
+		/* will dump both fcp and nvme cqs/wqs for the eq */
 		rc = lpfc_idiag_cqs_for_eq(phba, pbuffer, &len,
 			max_cnt, qp->queue_id);
 		if (rc)
@@ -2227,6 +2259,23 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 		if (len >= max_cnt)
 			goto too_big;
 
+		/* Slow-path NVME LS response CQ */
+		qp = phba->sli4_hba.nvmels_cq;
+		len = __lpfc_idiag_print_cq(qp, "NVME LS",
+						pbuffer, len);
+		/* Reset max counter */
+		if (qp)
+			qp->CQ_max_cqe = 0;
+		if (len >= max_cnt)
+			goto too_big;
+
+		/* Slow-path NVME LS WQ */
+		qp = phba->sli4_hba.nvmels_wq;
+		len = __lpfc_idiag_print_wq(qp, "NVME LS",
+						pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
+
 		qp = phba->sli4_hba.hdr_rq;
 		len = __lpfc_idiag_print_rqpair(qp, phba->sli4_hba.dat_rq,
 				"RQpair", pbuffer, len);
@@ -2447,7 +2496,7 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
 	uint32_t qidx, quetp, queid, index, count, offset, value;
 	uint32_t *pentry;
-	struct lpfc_queue *pque;
+	struct lpfc_queue *pque, *qp;
 	int rc;
 
 	/* This is a user write operation */
@@ -2483,19 +2532,15 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 	case LPFC_IDIAG_EQ:
 		/* HBA event queue */
 		if (phba->sli4_hba.hba_eq) {
-			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
-				qidx++) {
-				if (phba->sli4_hba.hba_eq[qidx] &&
-				    phba->sli4_hba.hba_eq[qidx]->queue_id ==
-				    queid) {
+			for (qidx = 0; qidx < phba->io_channel_irqs; qidx++) {
+				qp = phba->sli4_hba.hba_eq[qidx];
+				if (qp && qp->queue_id == queid) {
 					/* Sanity check */
-					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.hba_eq[qidx],
+					rc = lpfc_idiag_que_param_check(qp,
 						index, count);
 					if (rc)
 						goto error_out;
-					idiag.ptr_private =
-						phba->sli4_hba.hba_eq[qidx];
+					idiag.ptr_private = qp;
 					goto pass_check;
 				}
 			}
@@ -2525,24 +2570,32 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
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
-			qidx = 0;
-			do {
-				if (phba->sli4_hba.fcp_cq[qidx] &&
-				    phba->sli4_hba.fcp_cq[qidx]->queue_id ==
-				    queid) {
+			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
+								qidx++) {
+				qp = phba->sli4_hba.fcp_cq[qidx];
+				if (qp && qp->queue_id == queid) {
 					/* Sanity check */
 					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.fcp_cq[qidx],
-						index, count);
+						qp, index, count);
 					if (rc)
 						goto error_out;
-					idiag.ptr_private =
-						phba->sli4_hba.fcp_cq[qidx];
+					idiag.ptr_private = qp;
 					goto pass_check;
 				}
-			} while (++qidx < phba->cfg_fcp_io_channel);
+			}
 		}
 		goto error_out;
 		break;
@@ -2572,22 +2625,45 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
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
 		if (phba->sli4_hba.fcp_wq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
-				qidx++) {
-				if (!phba->sli4_hba.fcp_wq[qidx])
-					continue;
-				if (phba->sli4_hba.fcp_wq[qidx]->queue_id ==
-				    queid) {
+								qidx++) {
+				qp = phba->sli4_hba.fcp_wq[qidx];
+				if (qp && qp->queue_id == queid) {
 					/* Sanity check */
 					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.fcp_wq[qidx],
-						index, count);
+						qp, index, count);
+					if (rc)
+						goto error_out;
+					idiag.ptr_private = qp;
+					goto pass_check;
+				}
+			}
+		}
+		/* NVME work queue */
+		if (phba->sli4_hba.nvme_wq) {
+			for (qidx = 0; qidx < phba->cfg_nvme_io_channel;
+								qidx++) {
+				qp = phba->sli4_hba.nvme_wq[qidx];
+				if (qp && qp->queue_id == queid) {
+					/* Sanity check */
+					rc = lpfc_idiag_que_param_check(
+						qp, index, count);
 					if (rc)
 						goto error_out;
-					idiag.ptr_private =
-						phba->sli4_hba.fcp_wq[qidx];
+					idiag.ptr_private = qp;
 					goto pass_check;
 				}
 			}
@@ -4562,10 +4638,14 @@ lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 	 */
 	lpfc_debug_dump_wq(phba, DUMP_MBX, 0);
 	lpfc_debug_dump_wq(phba, DUMP_ELS, 0);
+	lpfc_debug_dump_wq(phba, DUMP_NVMELS, 0);
 
 	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
 		lpfc_debug_dump_wq(phba, DUMP_FCP, idx);
 
+	for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++)
+		lpfc_debug_dump_wq(phba, DUMP_NVME, idx);
+
 	lpfc_debug_dump_hdr_rq(phba);
 	lpfc_debug_dump_dat_rq(phba);
 	/*
@@ -4573,13 +4653,17 @@ lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 	 */
 	lpfc_debug_dump_cq(phba, DUMP_MBX, 0);
 	lpfc_debug_dump_cq(phba, DUMP_ELS, 0);
+	lpfc_debug_dump_cq(phba, DUMP_NVMELS, 0);
 
 	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
 		lpfc_debug_dump_cq(phba, DUMP_FCP, idx);
 
+	for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++)
+		lpfc_debug_dump_cq(phba, DUMP_NVME, idx);
+
 	/*
 	 * Dump Event Queues (EQs)
 	 */
-	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+	for (idx = 0; idx < phba->io_channel_irqs; idx++)
 		lpfc_debug_dump_hba_eq(phba, idx);
 }
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 9ae2c4b..98814d6 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -44,8 +44,10 @@
 
 enum {
 	DUMP_FCP,
+	DUMP_NVME,
 	DUMP_MBX,
 	DUMP_ELS,
+	DUMP_NVMELS,
 };
 
 /*
@@ -364,11 +366,11 @@ lpfc_debug_dump_q(struct lpfc_queue *q)
 }
 
 /**
- * lpfc_debug_dump_wq - dump all entries from the fcp work queue
+ * lpfc_debug_dump_wq - dump all entries from the fcp or nvme work queue
  * @phba: Pointer to HBA context object.
- * @wqidx: Index to a FCP work queue.
+ * @wqidx: Index to a FCP or NVME work queue.
  *
- * This function dumps all entries from a FCP work queue specified
+ * This function dumps all entries from a FCP or NVME work queue specified
  * by the wqidx.
  **/
 static inline void
@@ -380,16 +382,22 @@ lpfc_debug_dump_wq(struct lpfc_hba *phba, int qtype, int wqidx)
 	if (qtype == DUMP_FCP) {
 		wq = phba->sli4_hba.fcp_wq[wqidx];
 		qtypestr = "FCP";
+	} else if (qtype == DUMP_NVME) {
+		wq = phba->sli4_hba.nvme_wq[wqidx];
+		qtypestr = "NVME";
 	} else if (qtype == DUMP_MBX) {
 		wq = phba->sli4_hba.mbx_wq;
 		qtypestr = "MBX";
 	} else if (qtype == DUMP_ELS) {
 		wq = phba->sli4_hba.els_wq;
 		qtypestr = "ELS";
+	} else if (qtype == DUMP_NVMELS) {
+		wq = phba->sli4_hba.nvmels_wq;
+		qtypestr = "NVMELS";
 	} else
 		return;
 
-	if (qtype == DUMP_FCP)
+	if (qtype == DUMP_FCP || qtype == DUMP_NVME)
 		pr_err("%s WQ: WQ[Idx:%d|Qid:%d]\n",
 			qtypestr, wqidx, wq->queue_id);
 	else
@@ -400,12 +408,12 @@ lpfc_debug_dump_wq(struct lpfc_hba *phba, int qtype, int wqidx)
 }
 
 /**
- * lpfc_debug_dump_cq - dump all entries from a fcp work queue's
+ * lpfc_debug_dump_cq - dump all entries from a fcp or nvme work queue's
  * cmpl queue
  * @phba: Pointer to HBA context object.
  * @wqidx: Index to a FCP work queue.
  *
- * This function dumps all entries from a FCP completion queue
+ * This function dumps all entries from a FCP or NVME completion queue
  * which is associated to the work queue specified by the @wqidx.
  **/
 static inline void
@@ -415,12 +423,16 @@ lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 	char *qtypestr;
 	int eqidx;
 
-	/* fcp wq and cq are 1:1, thus same indexes */
+	/* fcp/nvme wq and cq are 1:1, thus same indexes */
 
 	if (qtype == DUMP_FCP) {
 		wq = phba->sli4_hba.fcp_wq[wqidx];
 		cq = phba->sli4_hba.fcp_cq[wqidx];
 		qtypestr = "FCP";
+	} else if (qtype == DUMP_NVME) {
+		wq = phba->sli4_hba.nvme_wq[wqidx];
+		cq = phba->sli4_hba.nvme_cq[wqidx];
+		qtypestr = "NVME";
 	} else if (qtype == DUMP_MBX) {
 		wq = phba->sli4_hba.mbx_wq;
 		cq = phba->sli4_hba.mbx_cq;
@@ -429,21 +441,25 @@ lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 		wq = phba->sli4_hba.els_wq;
 		cq = phba->sli4_hba.els_cq;
 		qtypestr = "ELS";
+	} else if (qtype == DUMP_NVMELS) {
+		wq = phba->sli4_hba.nvmels_wq;
+		cq = phba->sli4_hba.nvmels_cq;
+		qtypestr = "NVMELS";
 	} else
 		return;
 
-	for (eqidx = 0; eqidx < phba->cfg_fcp_io_channel; eqidx++) {
+	for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++) {
 		eq = phba->sli4_hba.hba_eq[eqidx];
 		if (cq->assoc_qid == eq->queue_id)
 			break;
 	}
-	if (eqidx == phba->cfg_fcp_io_channel) {
+	if (eqidx == phba->io_channel_irqs) {
 		pr_err("Couldn't find EQ for CQ. Using EQ[0]\n");
 		eqidx = 0;
 		eq = phba->sli4_hba.hba_eq[0];
 	}
 
-	if (qtype == DUMP_FCP)
+	if (qtype == DUMP_FCP || qtype == DUMP_NVME)
 		pr_err("%s CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]"
 			"->EQ[Idx:%d|Qid:%d]:\n",
 			qtypestr, wqidx, wq->queue_id, wqidx, cq->queue_id,
@@ -527,11 +543,25 @@ lpfc_debug_dump_wq_by_id(struct lpfc_hba *phba, int qid)
 		return;
 	}
 
+	for (wq_idx = 0; wq_idx < phba->cfg_nvme_io_channel; wq_idx++)
+		if (phba->sli4_hba.nvme_wq[wq_idx]->queue_id == qid)
+			break;
+	if (wq_idx < phba->cfg_nvme_io_channel) {
+		pr_err("NVME WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvme_wq[wq_idx]);
+		return;
+	}
+
 	if (phba->sli4_hba.els_wq->queue_id == qid) {
 		pr_err("ELS WQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_wq);
 		return;
 	}
+
+	if (phba->sli4_hba.nvmels_wq->queue_id == qid) {
+		pr_err("NVME LS WQ[Qid:%d]\n", qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvmels_wq);
+	}
 }
 
 /**
@@ -596,12 +626,28 @@ lpfc_debug_dump_cq_by_id(struct lpfc_hba *phba, int qid)
 		return;
 	}
 
+	for (cq_idx = 0; cq_idx < phba->cfg_nvme_io_channel; cq_idx++)
+		if (phba->sli4_hba.nvme_cq[cq_idx]->queue_id == qid)
+			break;
+
+	if (cq_idx < phba->cfg_nvme_io_channel) {
+		pr_err("NVME CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvme_cq[cq_idx]);
+		return;
+	}
+
 	if (phba->sli4_hba.els_cq->queue_id == qid) {
 		pr_err("ELS CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_cq);
 		return;
 	}
 
+	if (phba->sli4_hba.nvmels_cq->queue_id == qid) {
+		pr_err("NVME LS CQ[Qid:%d]\n", qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvmels_cq);
+		return;
+	}
+
 	if (phba->sli4_hba.mbx_cq->queue_id == qid) {
 		pr_err("MBX CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
@@ -621,17 +667,15 @@ lpfc_debug_dump_eq_by_id(struct lpfc_hba *phba, int qid)
 {
 	int eq_idx;
 
-	for (eq_idx = 0; eq_idx < phba->cfg_fcp_io_channel; eq_idx++) {
+	for (eq_idx = 0; eq_idx < phba->io_channel_irqs; eq_idx++)
 		if (phba->sli4_hba.hba_eq[eq_idx]->queue_id == qid)
 			break;
-	}
 
-	if (eq_idx < phba->cfg_fcp_io_channel) {
+	if (eq_idx < phba->io_channel_irqs) {
 		printk(KERN_ERR "FCP EQ[Idx:%d|Qid:%d]\n", eq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.hba_eq[eq_idx]);
 		return;
 	}
-
 }
 
 void lpfc_debug_dump_all_queues(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ede14f1..9e4611a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1323,7 +1323,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			"0201 Abort outstanding I/O on NPort x%x\n",
 			Fabric_DID);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
 
 	/*
 	 * Check the txcmplq for an iocb that matches the nport the driver is
@@ -7153,7 +7153,8 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 
 	timeout = (uint32_t)(phba->fc_ratov << 1);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
+
 	if ((phba->pport->load_flag & FC_UNLOADING))
 		return;
 	spin_lock_irq(&phba->hbalock);
@@ -7222,7 +7223,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 		spin_unlock_irq(&phba->hbalock);
 	}
 
-	if (!list_empty(&phba->sli.ring[LPFC_ELS_RING].txcmplq))
+	if (!list_empty(&pring->txcmplq))
 		if (!(phba->pport->load_flag & FC_UNLOADING))
 			mod_timer(&vport->els_tmofunc,
 				  jiffies + msecs_to_jiffies(1000 * timeout));
@@ -7253,7 +7254,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 {
 	LIST_HEAD(abort_list);
 	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
 
@@ -7265,6 +7266,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	 * a working list and release the locks before calling the abort.
 	 */
 	spin_lock_irq(&phba->hbalock);
+	pring = lpfc_phba_elsring(phba);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
@@ -9011,7 +9013,9 @@ void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 	LIST_HEAD(completions);
 	struct lpfc_hba  *phba = ndlp->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
+
+	pring = lpfc_phba_elsring(phba);
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
@@ -9067,13 +9071,13 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 	unsigned long iflag = 0;
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport)
 			sglq_entry->ndlp = NULL;
 	}
-	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
@@ -9097,22 +9101,22 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
+
+	pring = lpfc_phba_elsring(phba);
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->sli4_xritag == xri) {
 			list_del(&sglq_entry->list);
 			ndlp = sglq_entry->ndlp;
 			sglq_entry->ndlp = NULL;
-			spin_lock(&pring->ring_lock);
 			list_add_tail(&sglq_entry->list,
-				&phba->sli4_hba.lpfc_sgl_list);
+				&phba->sli4_hba.lpfc_els_sgl_list);
 			sglq_entry->state = SGL_FREED;
-			spin_unlock(&pring->ring_lock);
-			spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+			spin_unlock(&phba->sli4_hba.sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			lpfc_set_rrq_active(phba, ndlp,
 				sglq_entry->sli4_lxritag,
@@ -9124,21 +9128,21 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			return;
 		}
 	}
-	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	lxri = lpfc_sli4_xri_inrange(phba, xri);
 	if (lxri == NO_XRI) {
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return;
 	}
-	spin_lock(&pring->ring_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	sglq_entry = __lpfc_get_active_sglq(phba, lxri);
 	if (!sglq_entry || (sglq_entry->sli4_xritag != xri)) {
-		spin_unlock(&pring->ring_lock);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return;
 	}
 	sglq_entry->state = SGL_XRI_ABORTED;
-	spin_unlock(&pring->ring_lock);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index cdbe252..6c42715 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -93,7 +93,7 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		lpfc_sli_abort_iocb(ndlp->vport,
-			&phba->sli.ring[phba->sli.fcp_ring],
+			&phba->sli.sli3_ring[LPFC_FCP_RING],
 			ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 }
@@ -247,8 +247,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		if (ndlp->nlp_sid != NLP_NO_SID) {
 			/* flush the target */
 			lpfc_sli_abort_iocb(vport,
-					&phba->sli.ring[phba->sli.fcp_ring],
-					ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+					    &phba->sli.sli3_ring[LPFC_FCP_RING],
+					    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 		}
 		put_node = rdata->pnode != NULL;
 		rdata->pnode = NULL;
@@ -283,7 +283,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
-		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+		lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
 				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 
@@ -495,11 +495,12 @@ lpfc_send_fastpath_evt(struct lpfc_hba *phba,
 		return;
 	}
 
-	fc_host_post_vendor_event(shost,
-		fc_get_event_number(),
-		evt_data_size,
-		evt_data,
-		LPFC_NL_VENDOR_ID);
+	if (phba->cfg_enable_fc4_type != LPFC_ENABLE_NVME)
+		fc_host_post_vendor_event(shost,
+			fc_get_event_number(),
+			evt_data_size,
+			evt_data,
+			LPFC_NL_VENDOR_ID);
 
 	lpfc_free_fast_evt(phba, fast_evt_data);
 	return;
@@ -682,7 +683,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
 	status >>= (4*LPFC_ELS_RING);
 	if ((status & HA_RXMASK) ||
@@ -894,11 +895,16 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		spin_unlock_irq(shost->host_lock);
 	}
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			/* Issue a LINK DOWN event to all nodes */
 			lpfc_linkdown_port(vports[i]);
+
+			vports[i]->fc_myDID = 0;
+
+			/* todo: init: revise localport nvme attributes */
 		}
+	}
 	lpfc_destroy_vport_work_array(phba, vports);
 	/* Clean up any firmware default rpi's */
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -914,7 +920,6 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->pport->fc_flag & FC_PT2PT) {
-		phba->pport->fc_myDID = 0;
 		mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mb) {
 			lpfc_config_link(phba, mb);
@@ -929,7 +934,6 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		phba->pport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI);
 		spin_unlock_irq(shost->host_lock);
 	}
-
 	return 0;
 }
 
@@ -1016,7 +1020,7 @@ lpfc_linkup(struct lpfc_hba *phba)
  * This routine handles processing a CLEAR_LA mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
  * as the completion routine when the command is
- * handed off to the SLI layer.
+ * handed off to the SLI layer. SLI3 only.
  */
 static void
 lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
@@ -1028,9 +1032,8 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	uint32_t control;
 
 	/* Since we don't do discovery right now, turn these off here */
-	psli->ring[psli->extra_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
-	psli->ring[psli->fcp_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
-	psli->ring[psli->next_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
+	psli->sli3_ring[LPFC_EXTRA_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
+	psli->sli3_ring[LPFC_FCP_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
 
 	/* Check for error */
 	if ((mb->mbxStatus) && (mb->mbxStatus != 0x1601)) {
@@ -3277,7 +3280,7 @@ lpfc_mbx_issue_link_down(struct lpfc_hba *phba)
  * This routine handles processing a READ_TOPOLOGY mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
  * as the completion routine when the command is
- * handed off to the SLI layer.
+ * handed off to the SLI layer. SLI4 only.
  */
 void
 lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
@@ -3285,11 +3288,14 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_mbx_read_top *la;
+	struct lpfc_sli_ring *pring;
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 
 	/* Unblock ELS traffic */
-	phba->sli.ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
+	pring = lpfc_phba_elsring(phba);
+	pring->flag &= ~LPFC_STOP_IOCB_EVENT;
+
 	/* Check for error */
 	if (mb->mbxStatus) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -3458,6 +3464,14 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
@@ -3903,6 +3917,9 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct fc_rport_identifiers rport_ids;
 	struct lpfc_hba  *phba = vport->phba;
 
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
+		return;
+
 	/* Remote port has reappeared. Re-register w/ FC transport */
 	rport_ids.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
 	rport_ids.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
@@ -4395,7 +4412,6 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		    struct lpfc_iocbq *iocb,
 		    struct lpfc_nodelist *ndlp)
 {
-	struct lpfc_sli *psli = &phba->sli;
 	IOCB_t *icmd = &iocb->iocb;
 	struct lpfc_vport    *vport = ndlp->vport;
 
@@ -4414,9 +4430,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 			if (iocb->context1 == (uint8_t *) ndlp)
 				return 1;
 		}
-	} else if (pring->ringno == psli->extra_ring) {
-
-	} else if (pring->ringno == psli->fcp_ring) {
+	} else if (pring->ringno == LPFC_FCP_RING) {
 		/* Skip match check if waiting to relogin to FCP target */
 		if ((ndlp->nlp_type & NLP_FCP_TARGET) &&
 		    (ndlp->nlp_flag & NLP_DELAY_TMO)) {
@@ -4429,6 +4443,54 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 	return 0;
 }
 
+static void
+__lpfc_dequeue_nport_iocbs(struct lpfc_hba *phba,
+		struct lpfc_nodelist *ndlp, struct lpfc_sli_ring *pring,
+		struct list_head *dequeue_list)
+{
+	struct lpfc_iocbq *iocb, *next_iocb;
+
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
+		/* Check to see if iocb matches the nport */
+		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
+			/* match, dequeue */
+			list_move_tail(&iocb->list, dequeue_list);
+	}
+}
+
+static void
+lpfc_sli3_dequeue_nport_iocbs(struct lpfc_hba *phba,
+		struct lpfc_nodelist *ndlp, struct list_head *dequeue_list)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	uint32_t i;
+
+	spin_lock_irq(&phba->hbalock);
+	for (i = 0; i < psli->num_rings; i++)
+		__lpfc_dequeue_nport_iocbs(phba, ndlp, &psli->sli3_ring[i],
+						dequeue_list);
+	spin_unlock_irq(&phba->hbalock);
+}
+
+static void
+lpfc_sli4_dequeue_nport_iocbs(struct lpfc_hba *phba,
+		struct lpfc_nodelist *ndlp, struct list_head *dequeue_list)
+{
+	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *qp = NULL;
+
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring)
+			continue;
+		spin_lock_irq(&pring->ring_lock);
+		__lpfc_dequeue_nport_iocbs(phba, ndlp, pring, dequeue_list);
+		spin_unlock_irq(&pring->ring_lock);
+	}
+	spin_unlock_irq(&phba->hbalock);
+}
+
 /*
  * Free resources / clean up outstanding I/Os
  * associated with nlp_rpi in the LPFC_NODELIST entry.
@@ -4437,10 +4499,6 @@ static int
 lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
-	struct lpfc_sli *psli;
-	struct lpfc_sli_ring *pring;
-	struct lpfc_iocbq *iocb, *next_iocb;
-	uint32_t i;
 
 	lpfc_fabric_abort_nport(ndlp);
 
@@ -4448,29 +4506,11 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	 * Everything that matches on txcmplq will be returned
 	 * by firmware with a no rpi error.
 	 */
-	psli = &phba->sli;
 	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
-		/* Now process each ring */
-		for (i = 0; i < psli->num_rings; i++) {
-			pring = &psli->ring[i];
-
-			spin_lock_irq(&phba->hbalock);
-			list_for_each_entry_safe(iocb, next_iocb, &pring->txq,
-						 list) {
-				/*
-				 * Check to see if iocb matches the nport we are
-				 * looking for
-				 */
-				if ((lpfc_check_sli_ndlp(phba, pring, iocb,
-							 ndlp))) {
-					/* It matches, so deque and call compl
-					   with an error */
-					list_move_tail(&iocb->list,
-						       &completions);
-				}
-			}
-			spin_unlock_irq(&phba->hbalock);
-		}
+		if (phba->sli_rev != LPFC_SLI_REV4)
+			lpfc_sli3_dequeue_nport_iocbs(phba, ndlp, &completions);
+		else
+			lpfc_sli4_dequeue_nport_iocbs(phba, ndlp, &completions);
 	}
 
 	/* Cancel all the IOCBs from the completions list */
@@ -5039,14 +5079,14 @@ lpfc_disc_list_loopmap(struct lpfc_vport *vport)
 	return;
 }
 
+/* SLI3 only */
 void
 lpfc_issue_clear_la(struct lpfc_hba *phba, struct lpfc_vport *vport)
 {
 	LPFC_MBOXQ_t *mbox;
 	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *extra_ring = &psli->ring[psli->extra_ring];
-	struct lpfc_sli_ring *fcp_ring   = &psli->ring[psli->fcp_ring];
-	struct lpfc_sli_ring *next_ring  = &psli->ring[psli->next_ring];
+	struct lpfc_sli_ring *extra_ring = &psli->sli3_ring[LPFC_EXTRA_RING];
+	struct lpfc_sli_ring *fcp_ring   = &psli->sli3_ring[LPFC_FCP_RING];
 	int  rc;
 
 	/*
@@ -5070,7 +5110,6 @@ lpfc_issue_clear_la(struct lpfc_hba *phba, struct lpfc_vport *vport)
 			lpfc_disc_flush_list(vport);
 			extra_ring->flag &= ~LPFC_STOP_IOCB_EVENT;
 			fcp_ring->flag &= ~LPFC_STOP_IOCB_EVENT;
-			next_ring->flag &= ~LPFC_STOP_IOCB_EVENT;
 			phba->link_state = LPFC_HBA_ERROR;
 		}
 	}
@@ -5206,7 +5245,7 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_sli_ring *pring;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
 
 	/* Error matching iocb on txq or txcmplq
 	 * First check the txq.
@@ -5522,12 +5561,14 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 
 	if (clrlaerr) {
 		lpfc_disc_flush_list(vport);
-		psli->ring[(psli->extra_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
-		psli->ring[(psli->fcp_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
-		psli->ring[(psli->next_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		if (phba->sli_rev != LPFC_SLI_REV4) {
+			psli->sli3_ring[(LPFC_EXTRA_RING)].flag &=
+				~LPFC_STOP_IOCB_EVENT;
+			psli->sli3_ring[LPFC_FCP_RING].flag &=
+				~LPFC_STOP_IOCB_EVENT;
+		}
 		vport->port_state = LPFC_VPORT_READY;
 	}
-
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 3b970d37..28247c9 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -44,8 +44,6 @@
 #define LPFC_FCP_RING            0	/* ring 0 for FCP initiator commands */
 #define LPFC_EXTRA_RING          1	/* ring 1 for other protocols */
 #define LPFC_ELS_RING            2	/* ring 2 for ELS commands */
-#define LPFC_FCP_NEXT_RING       3
-#define LPFC_FCP_OAS_RING        3
 
 #define SLI2_IOCB_CMD_R0_ENTRIES    172	/* SLI-2 FCP command ring entries */
 #define SLI2_IOCB_RSP_R0_ENTRIES    134	/* SLI-2 FCP response ring entries */
@@ -1791,6 +1789,7 @@ typedef struct {		/* FireFly BIU registers */
 #define MBX_INIT_VFI        0xA3
 #define MBX_INIT_VPI        0xA4
 #define MBX_ACCESS_VDATA    0xA5
+#define MBX_REG_FCFI_MRQ    0xAF
 
 #define MBX_AUTH_PORT       0xF8
 #define MBX_SECURITY_MGMT   0xF9
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 964a1fd..c3277c5 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -108,6 +108,7 @@ struct lpfc_sli_intf {
 #define LPFC_MAX_MQ_PAGE		8
 #define LPFC_MAX_WQ_PAGE_V0		4
 #define LPFC_MAX_WQ_PAGE		8
+#define LPFC_MAX_RQ_PAGE		8
 #define LPFC_MAX_CQ_PAGE		4
 #define LPFC_MAX_EQ_PAGE		8
 
@@ -198,7 +199,7 @@ struct lpfc_sli_intf {
 /* Configuration of Interrupts / sec for entire HBA port */
 #define LPFC_MIN_IMAX          5000
 #define LPFC_MAX_IMAX          5000000
-#define LPFC_DEF_IMAX          50000
+#define LPFC_DEF_IMAX          150000
 
 #define LPFC_MIN_CPU_MAP       0
 #define LPFC_MAX_CPU_MAP       2
@@ -348,6 +349,7 @@ struct lpfc_cqe {
 #define CQE_CODE_RECEIVE		0x4
 #define CQE_CODE_XRI_ABORTED		0x5
 #define CQE_CODE_RECEIVE_V1		0x9
+#define CQE_CODE_NVME_ERSP		0xd
 
 /*
  * Define mask value for xri_aborted and wcqe completed CQE extended status.
@@ -367,6 +369,9 @@ struct lpfc_wcqe_complete {
 #define lpfc_wcqe_c_hw_status_SHIFT	0
 #define lpfc_wcqe_c_hw_status_MASK	0x000000FF
 #define lpfc_wcqe_c_hw_status_WORD	word0
+#define lpfc_wcqe_c_ersp0_SHIFT		0
+#define lpfc_wcqe_c_ersp0_MASK		0x0000FFFF
+#define lpfc_wcqe_c_ersp0_WORD		word0
 	uint32_t total_data_placed;
 	uint32_t parameter;
 #define lpfc_wcqe_c_bg_edir_SHIFT	5
@@ -400,6 +405,9 @@ struct lpfc_wcqe_complete {
 #define lpfc_wcqe_c_code_SHIFT		lpfc_cqe_code_SHIFT
 #define lpfc_wcqe_c_code_MASK		lpfc_cqe_code_MASK
 #define lpfc_wcqe_c_code_WORD		lpfc_cqe_code_WORD
+#define lpfc_wcqe_c_sqhead_SHIFT	0
+#define lpfc_wcqe_c_sqhead_MASK		0x0000FFFF
+#define lpfc_wcqe_c_sqhead_WORD		word3
 };
 
 /* completion queue entry for wqe release */
@@ -2841,12 +2849,18 @@ struct lpfc_sli4_parameters {
 #define cfg_mqv_WORD				word6
 	uint32_t word7;
 	uint32_t word8;
+#define cfg_wqpcnt_SHIFT			0
+#define cfg_wqpcnt_MASK				0x0000000f
+#define cfg_wqpcnt_WORD				word8
 #define cfg_wqsize_SHIFT			8
 #define cfg_wqsize_MASK				0x0000000f
 #define cfg_wqsize_WORD				word8
 #define cfg_wqv_SHIFT				14
 #define cfg_wqv_MASK				0x00000003
 #define cfg_wqv_WORD				word8
+#define cfg_wqpsize_SHIFT			16
+#define cfg_wqpsize_MASK			0x000000ff
+#define cfg_wqpsize_WORD			word8
 	uint32_t word9;
 	uint32_t word10;
 #define cfg_rqv_SHIFT				14
@@ -2897,6 +2911,12 @@ struct lpfc_sli4_parameters {
 #define cfg_mds_diags_SHIFT			1
 #define cfg_mds_diags_MASK			0x00000001
 #define cfg_mds_diags_WORD			word19
+#define cfg_nvme_SHIFT				3
+#define cfg_nvme_MASK				0x00000001
+#define cfg_nvme_WORD				word19
+#define cfg_xib_SHIFT				4
+#define cfg_xib_MASK				0x00000001
+#define cfg_xib_WORD				word19
 };
 
 #define LPFC_SET_UE_RECOVERY		0x10
@@ -3659,6 +3679,9 @@ struct wqe_common {
 #define wqe_ebde_cnt_SHIFT    0
 #define wqe_ebde_cnt_MASK     0x0000000f
 #define wqe_ebde_cnt_WORD     word10
+#define wqe_nvme_SHIFT        4
+#define wqe_nvme_MASK         0x00000001
+#define wqe_nvme_WORD         word10
 #define wqe_oas_SHIFT         6
 #define wqe_oas_MASK          0x00000001
 #define wqe_oas_WORD          word10
@@ -4017,11 +4040,39 @@ struct lpfc_grp_hdr {
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
+#define LPFC_NVME_EMBED_CMD	0x0
+#define LPFC_NVME_EMBED_WRITE	0x1
+#define LPFC_NVME_EMBED_READ	0x2
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
index 7ad6897..8b9b940 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -34,6 +34,7 @@
 #include <linux/firmware.h>
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
+#include <linux/msi.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -46,8 +47,9 @@
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
@@ -499,12 +501,10 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	phba->link_state = LPFC_LINK_DOWN;
 
 	/* Only process IOCBs on ELS ring till hba_state is READY */
-	if (psli->ring[psli->extra_ring].sli.sli3.cmdringaddr)
-		psli->ring[psli->extra_ring].flag |= LPFC_STOP_IOCB_EVENT;
-	if (psli->ring[psli->fcp_ring].sli.sli3.cmdringaddr)
-		psli->ring[psli->fcp_ring].flag |= LPFC_STOP_IOCB_EVENT;
-	if (psli->ring[psli->next_ring].sli.sli3.cmdringaddr)
-		psli->ring[psli->next_ring].flag |= LPFC_STOP_IOCB_EVENT;
+	if (psli->sli3_ring[LPFC_EXTRA_RING].sli.sli3.cmdringaddr)
+		psli->sli3_ring[LPFC_EXTRA_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	if (psli->sli3_ring[LPFC_FCP_RING].sli.sli3.cmdringaddr)
+		psli->sli3_ring[LPFC_FCP_RING].flag |= LPFC_STOP_IOCB_EVENT;
 
 	/* Post receive buffers for desired rings */
 	if (phba->sli_rev != 3)
@@ -892,7 +892,7 @@ lpfc_hba_free_post_buf(struct lpfc_hba *phba)
 		lpfc_sli_hbqbuf_free_all(phba);
 	else {
 		/* Cleanup preposted buffers on the ELS ring */
-		pring = &psli->ring[LPFC_ELS_RING];
+		pring = &psli->sli3_ring[LPFC_ELS_RING];
 		spin_lock_irq(&phba->hbalock);
 		list_splice_init(&pring->postbufq, &buflist);
 		spin_unlock_irq(&phba->hbalock);
@@ -925,32 +925,43 @@ static void
 lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	LIST_HEAD(completions);
 	int i;
 
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		if (phba->sli_rev >= LPFC_SLI_REV4)
-			spin_lock_irq(&pring->ring_lock);
-		else
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
 			spin_lock_irq(&phba->hbalock);
-		/* At this point in time the HBA is either reset or DOA. Either
-		 * way, nothing should be on txcmplq as it will NEVER complete.
-		 */
-		list_splice_init(&pring->txcmplq, &completions);
-		pring->txcmplq_cnt = 0;
-
-		if (phba->sli_rev >= LPFC_SLI_REV4)
-			spin_unlock_irq(&pring->ring_lock);
-		else
+			/* At this point in time the HBA is either reset or DOA
+			 * Nothing should be on txcmplq as it will
+			 * NEVER complete.
+			 */
+			list_splice_init(&pring->txcmplq, &completions);
+			pring->txcmplq_cnt = 0;
 			spin_unlock_irq(&phba->hbalock);
 
+			lpfc_sli_abort_iocb_ring(phba, pring);
+		}
 		/* Cancel all the IOCBs from the completions list */
-		lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
-				      IOERR_SLI_ABORTED);
+		lpfc_sli_cancel_iocbs(phba, &completions,
+				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
+		return;
+	}
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring)
+			continue;
+		spin_lock_irq(&pring->ring_lock);
+		list_splice_init(&pring->txcmplq, &completions);
+		pring->txcmplq_cnt = 0;
+		spin_unlock_irq(&pring->ring_lock);
 		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions,
+			      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
 }
 
 /**
@@ -989,43 +1000,51 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 {
 	struct lpfc_scsi_buf *psb, *psb_next;
 	LIST_HEAD(aborts);
+	LIST_HEAD(nvme_aborts);
 	unsigned long iflag = 0;
 	struct lpfc_sglq *sglq_entry = NULL;
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring;
 
-	lpfc_hba_free_post_buf(phba);
+
+	lpfc_sli_hbqbuf_free_all(phba);
 	lpfc_hba_clean_txcmplq(phba);
-	pring = &psli->ring[LPFC_ELS_RING];
 
 	/* At this point in time the HBA is either reset or DOA. Either
 	 * way, nothing should be on lpfc_abts_els_sgl_list, it needs to be
-	 * on the lpfc_sgl_list so that it can either be freed if the
+	 * on the lpfc_els_sgl_list so that it can either be freed if the
 	 * driver is unloading or reposted if the driver is restarting
 	 * the port.
 	 */
-	spin_lock_irq(&phba->hbalock);  /* required for lpfc_sgl_list and */
+	spin_lock_irq(&phba->hbalock);  /* required for lpfc_els_sgl_list and */
 					/* scsl_buf_list */
-	/* abts_sgl_list_lock required because worker thread uses this
+	/* sgl_list_lock required because worker thread uses this
 	 * list.
 	 */
-	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry(sglq_entry,
 		&phba->sli4_hba.lpfc_abts_els_sgl_list, list)
 		sglq_entry->state = SGL_FREED;
 
-	spin_lock(&pring->ring_lock);
 	list_splice_init(&phba->sli4_hba.lpfc_abts_els_sgl_list,
-			&phba->sli4_hba.lpfc_sgl_list);
-	spin_unlock(&pring->ring_lock);
-	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+			&phba->sli4_hba.lpfc_els_sgl_list);
+
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	/* abts_scsi_buf_list_lock required because worker thread uses this
 	 * list.
 	 */
-	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
-	list_splice_init(&phba->sli4_hba.lpfc_abts_scsi_buf_list,
-			&aborts);
-	spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_abts_scsi_buf_list,
+				 &aborts);
+		spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	}
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_abts_nvme_buf_list,
+				 &nvme_aborts);
+		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	}
+
 	spin_unlock_irq(&phba->hbalock);
 
 	list_for_each_entry_safe(psb, psb_next, &aborts, list) {
@@ -1036,6 +1055,14 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	list_splice(&aborts, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 
+	list_for_each_entry_safe(psb, psb_next, &nvme_aborts, list) {
+		psb->pCmd = NULL;
+		psb->status = IOSTAT_SUCCESS;
+	}
+	spin_lock_irqsave(&phba->nvme_buf_list_put_lock, iflag);
+	list_splice(&nvme_aborts, &phba->lpfc_nvme_buf_list_put);
+	spin_unlock_irqrestore(&phba->nvme_buf_list_put_lock, iflag);
+
 	lpfc_sli4_free_sp_events(phba);
 	return 0;
 }
@@ -1829,7 +1856,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked from the worker thread to handle a HBA host
- * attention link event.
+ * attention link event. SLI3 only.
  **/
 void
 lpfc_handle_latt(struct lpfc_hba *phba)
@@ -1867,7 +1894,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = vport;
 	/* Block ELS IOCBs until we have processed this mbox command */
-	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	phba->sli.sli3_ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
 	rc = lpfc_sli_issue_mbox (phba, pmb, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 4;
@@ -1883,7 +1910,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	return;
 
 lpfc_handle_latt_free_mbuf:
-	phba->sli.ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
+	phba->sli.sli3_ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 lpfc_handle_latt_free_mp:
 	kfree(mp);
@@ -2441,7 +2468,7 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
  *
  * This routine posts initial receive IOCB buffers to the ELS ring. The
  * current number of initial IOCB buffers specified by LPFC_BUF_RING0 is
- * set to 64 IOCBs.
+ * set to 64 IOCBs. SLI3 only.
  *
  * Return codes
  *   0 - success (currently always success)
@@ -2452,7 +2479,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 
 	/* Ring 0, ELS / CT buffers */
-	lpfc_post_buffer(phba, &psli->ring[LPFC_ELS_RING], LPFC_BUF_RING0);
+	lpfc_post_buffer(phba, &psli->sli3_ring[LPFC_ELS_RING], LPFC_BUF_RING0);
 	/* Ring 2 - FCP no buffers needed */
 
 	return 0;
@@ -2895,11 +2922,6 @@ lpfc_online(struct lpfc_hba *phba)
 
 	lpfc_block_mgmt_io(phba, LPFC_MBX_WAIT);
 
-	if (!lpfc_sli_queue_setup(phba)) {
-		lpfc_unblock_mgmt_io(phba);
-		return 1;
-	}
-
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (lpfc_sli4_hba_setup(phba)) { /* Initialize SLI4 HBA */
 			lpfc_unblock_mgmt_io(phba);
@@ -2910,6 +2932,7 @@ lpfc_online(struct lpfc_hba *phba)
 			vpis_cleared = true;
 		spin_unlock_irq(&phba->hbalock);
 	} else {
+		lpfc_sli_queue_init(phba);
 		if (lpfc_sli_hba_setup(phba)) {	/* Initialize SLI2/SLI3 HBA */
 			lpfc_unblock_mgmt_io(phba);
 			return 1;
@@ -3101,6 +3124,9 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	struct lpfc_scsi_buf *sb, *sb_next;
 	struct lpfc_iocbq *io, *io_next;
 
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return;
+
 	spin_lock_irq(&phba->hbalock);
 
 	/* Release all the lpfc_scsi_bufs maintained by this host. */
@@ -3109,7 +3135,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list_put,
 				 list) {
 		list_del(&sb->list);
-		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, sb->data,
 			      sb->dma_handle);
 		kfree(sb);
 		phba->total_scsi_bufs--;
@@ -3120,7 +3146,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list_get,
 				 list) {
 		list_del(&sb->list);
-		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, sb->data,
 			      sb->dma_handle);
 		kfree(sb);
 		phba->total_scsi_bufs--;
@@ -3136,9 +3162,59 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 
 	spin_unlock_irq(&phba->hbalock);
 }
+/**
+ * lpfc_nvme_free - Free all the NVME buffers and IOCBs from driver lists
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to free all the NVME buffers and IOCBs from the driver
+ * list back to kernel. It is called from lpfc_pci_remove_one to free
+ * the internal resources before the device is removed from the system.
+ **/
+static void
+lpfc_nvme_free(struct lpfc_hba *phba)
+{
+	struct lpfc_nvme_buf *lpfc_ncmd, *lpfc_ncmd_next;
+	struct lpfc_iocbq *io, *io_next;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return;
+
+	spin_lock_irq(&phba->hbalock);
+
+	/* Release all the lpfc_nvme_bufs maintained by this host. */
+	spin_lock(&phba->nvme_buf_list_put_lock);
+	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+				 &phba->lpfc_nvme_buf_list_put, list) {
+		list_del(&lpfc_ncmd->list);
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, lpfc_ncmd->data,
+			      lpfc_ncmd->dma_handle);
+		kfree(lpfc_ncmd);
+		phba->total_nvme_bufs--;
+	}
+	spin_unlock(&phba->nvme_buf_list_put_lock);
+
+	spin_lock(&phba->nvme_buf_list_get_lock);
+	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+				 &phba->lpfc_nvme_buf_list_get, list) {
+		list_del(&lpfc_ncmd->list);
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, lpfc_ncmd->data,
+			      lpfc_ncmd->dma_handle);
+		kfree(lpfc_ncmd);
+		phba->total_nvme_bufs--;
+	}
+	spin_unlock(&phba->nvme_buf_list_get_lock);
 
+	/* Release all the lpfc_iocbq entries maintained by this host. */
+	list_for_each_entry_safe(io, io_next, &phba->lpfc_iocb_list, list) {
+		list_del(&io->list);
+		kfree(io);
+		phba->total_iocbq_bufs--;
+	}
+
+	spin_unlock_irq(&phba->hbalock);
+}
 /**
- * lpfc_sli4_xri_sgl_update - update xri-sgl sizing and mapping
+ * lpfc_sli4_els_sgl_update - update ELS xri-sgl sizing and mapping
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine first calculates the sizes of the current els and allocated
@@ -3150,20 +3226,18 @@ lpfc_scsi_free(struct lpfc_hba *phba)
  *   0 - successful (for now, it always returns 0)
  **/
 int
-lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
+lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 {
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_entry_next = NULL;
-	struct lpfc_scsi_buf *psb = NULL, *psb_next = NULL;
-	uint16_t i, lxri, xri_cnt, els_xri_cnt, scsi_xri_cnt;
+	uint16_t i, lxri, xri_cnt, els_xri_cnt;
 	LIST_HEAD(els_sgl_list);
-	LIST_HEAD(scsi_sgl_list);
 	int rc;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	/*
 	 * update on pci function's els xri-sgl list
 	 */
 	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+
 	if (els_xri_cnt > phba->sli4_hba.els_xri_cnt) {
 		/* els xri-sgl expanded */
 		xri_cnt = els_xri_cnt - phba->sli4_hba.els_xri_cnt;
@@ -3199,9 +3273,10 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 			list_add_tail(&sglq_entry->list, &els_sgl_list);
 		}
 		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&els_sgl_list, &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&pring->ring_lock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&els_sgl_list,
+				 &phba->sli4_hba.lpfc_els_sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irq(&phba->hbalock);
 	} else if (els_xri_cnt < phba->sli4_hba.els_xri_cnt) {
 		/* els xri-sgl shrinked */
@@ -3211,24 +3286,22 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 				"%d to %d\n", phba->sli4_hba.els_xri_cnt,
 				els_xri_cnt);
 		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &els_sgl_list);
-		spin_unlock(&pring->ring_lock);
-		spin_unlock_irq(&phba->hbalock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_els_sgl_list,
+				 &els_sgl_list);
 		/* release extra els sgls from list */
 		for (i = 0; i < xri_cnt; i++) {
 			list_remove_head(&els_sgl_list,
 					 sglq_entry, struct lpfc_sglq, list);
 			if (sglq_entry) {
-				lpfc_mbuf_free(phba, sglq_entry->virt,
-					       sglq_entry->phys);
+				__lpfc_mbuf_free(phba, sglq_entry->virt,
+						 sglq_entry->phys);
 				kfree(sglq_entry);
 			}
 		}
-		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&els_sgl_list, &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&pring->ring_lock);
+		list_splice_init(&els_sgl_list,
+				 &phba->sli4_hba.lpfc_els_sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irq(&phba->hbalock);
 	} else
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -3240,7 +3313,7 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 	sglq_entry = NULL;
 	sglq_entry_next = NULL;
 	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
-				 &phba->sli4_hba.lpfc_sgl_list, list) {
+				 &phba->sli4_hba.lpfc_els_sgl_list, list) {
 		lxri = lpfc_sli4_next_xritag(phba);
 		if (lxri == NO_XRI) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -3252,21 +3325,53 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 		sglq_entry->sli4_lxritag = lxri;
 		sglq_entry->sli4_xritag = phba->sli4_hba.xri_ids[lxri];
 	}
+	return 0;
+
+out_free_mem:
+	lpfc_free_els_sgl_list(phba);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_scsi_sgl_update - update xri-sgl sizing and mapping
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine first calculates the sizes of the current els and allocated
+ * scsi sgl lists, and then goes through all sgls to updates the physical
+ * XRIs assigned due to port function reset. During port initialization, the
+ * current els and allocated scsi sgl lists are 0s.
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
+int
+lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba)
+{
+	struct lpfc_scsi_buf *psb, *psb_next;
+	uint16_t i, lxri, els_xri_cnt, scsi_xri_cnt;
+	LIST_HEAD(scsi_sgl_list);
+	int rc;
 
 	/*
-	 * update on pci function's allocated scsi xri-sgl list
+	 * update on pci function's els xri-sgl list
 	 */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
 	phba->total_scsi_bufs = 0;
 
+	/*
+	 * update on pci function's allocated scsi xri-sgl list
+	 */
 	/* maximum number of xris available for scsi buffers */
 	phba->sli4_hba.scsi_xri_max = phba->sli4_hba.max_cfg_param.max_xri -
 				      els_xri_cnt;
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"2401 Current allocated SCSI xri-sgl count:%d, "
-			"maximum  SCSI xri count:%d\n",
-			phba->sli4_hba.scsi_xri_cnt,
-			phba->sli4_hba.scsi_xri_max);
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return 0;
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		phba->sli4_hba.scsi_xri_max =  /* Split them up */
+			(phba->sli4_hba.scsi_xri_max *
+			 phba->cfg_xri_split) / 100;
 
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
 	spin_lock(&phba->scsi_buf_list_put_lock);
@@ -3284,7 +3389,7 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 			list_remove_head(&scsi_sgl_list, psb,
 					 struct lpfc_scsi_buf, list);
 			if (psb) {
-				pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+				pci_pool_free(phba->lpfc_sg_dma_buf_pool,
 					      psb->data, psb->dma_handle);
 				kfree(psb);
 			}
@@ -3315,16 +3420,113 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
 	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
-
 	return 0;
 
 out_free_mem:
-	lpfc_free_els_sgl_list(phba);
 	lpfc_scsi_free(phba);
 	return rc;
 }
 
 /**
+ * lpfc_sli4_nvme_sgl_update - update xri-sgl sizing and mapping
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine first calculates the sizes of the current els and allocated
+ * scsi sgl lists, and then goes through all sgls to updates the physical
+ * XRIs assigned due to port function reset. During port initialization, the
+ * current els and allocated scsi sgl lists are 0s.
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
+int
+lpfc_sli4_nvme_sgl_update(struct lpfc_hba *phba)
+{
+	struct lpfc_nvme_buf *lpfc_ncmd = NULL, *lpfc_ncmd_next = NULL;
+	uint16_t i, lxri, els_xri_cnt;
+	uint16_t nvme_xri_cnt, nvme_xri_max;
+	LIST_HEAD(nvme_sgl_list);
+	int rc;
+
+	phba->total_nvme_bufs = 0;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return 0;
+	/*
+	 * update on pci function's allocated nvme xri-sgl list
+	 */
+
+	/* maximum number of xris available for nvme buffers */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+	nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
+	phba->sli4_hba.nvme_xri_max = nvme_xri_max;
+	phba->sli4_hba.nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"6074 Current allocated NVME xri-sgl count:%d, "
+			"maximum  NVME xri count:%d\n",
+			phba->sli4_hba.nvme_xri_cnt,
+			phba->sli4_hba.nvme_xri_max);
+
+	spin_lock_irq(&phba->nvme_buf_list_get_lock);
+	spin_lock(&phba->nvme_buf_list_put_lock);
+	list_splice_init(&phba->lpfc_nvme_buf_list_get, &nvme_sgl_list);
+	list_splice(&phba->lpfc_nvme_buf_list_put, &nvme_sgl_list);
+	spin_unlock(&phba->nvme_buf_list_put_lock);
+	spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+
+	if (phba->sli4_hba.nvme_xri_cnt > phba->sli4_hba.nvme_xri_max) {
+		/* max nvme xri shrunk below the allocated nvme buffers */
+		spin_lock_irq(&phba->nvme_buf_list_get_lock);
+		nvme_xri_cnt = phba->sli4_hba.nvme_xri_cnt -
+					phba->sli4_hba.nvme_xri_max;
+		spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+		/* release the extra allocated nvme buffers */
+		for (i = 0; i < nvme_xri_cnt; i++) {
+			list_remove_head(&nvme_sgl_list, lpfc_ncmd,
+					 struct lpfc_nvme_buf, list);
+			if (lpfc_ncmd) {
+				pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+					      lpfc_ncmd->data,
+					      lpfc_ncmd->dma_handle);
+				kfree(lpfc_ncmd);
+			}
+		}
+		spin_lock_irq(&phba->nvme_buf_list_get_lock);
+		phba->sli4_hba.nvme_xri_cnt -= nvme_xri_cnt;
+		spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+	}
+
+	/* update xris associated to remaining allocated nvme buffers */
+	lpfc_ncmd = NULL;
+	lpfc_ncmd_next = NULL;
+	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+				 &nvme_sgl_list, list) {
+		lxri = lpfc_sli4_next_xritag(phba);
+		if (lxri == NO_XRI) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"6075 Failed to allocate xri for "
+					"nvme buffer\n");
+			rc = -ENOMEM;
+			goto out_free_mem;
+		}
+		lpfc_ncmd->cur_iocbq.sli4_lxritag = lxri;
+		lpfc_ncmd->cur_iocbq.sli4_xritag = phba->sli4_hba.xri_ids[lxri];
+	}
+	spin_lock_irq(&phba->nvme_buf_list_get_lock);
+	spin_lock(&phba->nvme_buf_list_put_lock);
+	list_splice_init(&nvme_sgl_list, &phba->lpfc_nvme_buf_list_get);
+	INIT_LIST_HEAD(&phba->lpfc_nvme_buf_list_put);
+	spin_unlock(&phba->nvme_buf_list_put_lock);
+	spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+	return 0;
+
+out_free_mem:
+	lpfc_nvme_free(phba);
+	return rc;
+}
+
+/**
  * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
  * @instance: a unique integer ID to this FC port.
@@ -3344,18 +3546,23 @@ struct lpfc_vport *
 lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 {
 	struct lpfc_vport *vport;
-	struct Scsi_Host  *shost;
+	struct Scsi_Host  *shost = NULL;
 	int error = 0;
 
-	if (dev != &phba->pcidev->dev) {
-		shost = scsi_host_alloc(&lpfc_vport_template,
-					sizeof(struct lpfc_vport));
-	} else {
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			shost = scsi_host_alloc(&lpfc_template,
-					sizeof(struct lpfc_vport));
-		else
-			shost = scsi_host_alloc(&lpfc_template_s3,
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		if (dev != &phba->pcidev->dev) {
+			shost = scsi_host_alloc(&lpfc_vport_template,
+						sizeof(struct lpfc_vport));
+		} else {
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				shost = scsi_host_alloc(&lpfc_template,
+						sizeof(struct lpfc_vport));
+			else
+				shost = scsi_host_alloc(&lpfc_template_s3,
+						sizeof(struct lpfc_vport));
+		}
+	} else if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		shost = scsi_host_alloc(&lpfc_template_nvme,
 					sizeof(struct lpfc_vport));
 	}
 	if (!shost)
@@ -3366,8 +3573,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	vport->fc_rscn_flush = 0;
-
 	lpfc_get_vport_cfgparam(vport);
+
 	shost->unique_id = instance;
 	shost->max_id = LPFC_MAX_TARGET;
 	shost->max_lun = vport->cfg_max_luns;
@@ -3945,7 +4152,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	lpfc_els_flush_all_cmd(phba);
 
 	/* Block ELS IOCBs until we have done process link event */
-	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	phba->sli4_hba.els_wq->pring->flag |= LPFC_STOP_IOCB_EVENT;
 
 	/* Update link event statistics */
 	phba->sli.slistat.link_event++;
@@ -4104,7 +4311,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	lpfc_els_flush_all_cmd(phba);
 
 	/* Block ELS IOCBs until we have done process link event */
-	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	phba->sli4_hba.els_wq->pring->flag |= LPFC_STOP_IOCB_EVENT;
 
 	/* Update link event statistics */
 	phba->sli.slistat.link_event++;
@@ -5001,40 +5208,78 @@ lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *phba, int nr_vfn)
 }
 
 /**
- * lpfc_sli_driver_resource_setup - Setup driver internal resources for SLI3 dev.
+ * lpfc_setup_driver_resource_phase1 - Phase1 etup driver internal resources.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to set up the driver internal resources specific to
- * support the SLI-3 HBA device it attached to.
+ * This routine is invoked to set up the driver internal resources before the
+ * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- * 	0 - successful
- * 	other values - error
+ *	0 - successful
+ *	other values - error
  **/
 static int
-lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
+lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli;
-	int rc;
+	struct lpfc_sli *psli = &phba->sli;
 
 	/*
-	 * Initialize timers used by driver
+	 * Driver resources common to all SLI revisions
 	 */
+	atomic_set(&phba->fast_event_count, 0);
+	spin_lock_init(&phba->hbalock);
 
-	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
+	/* Initialize ndlp management spinlock */
+	spin_lock_init(&phba->ndlp_lock);
+
+	INIT_LIST_HEAD(&phba->port_list);
+	INIT_LIST_HEAD(&phba->work_list);
+	init_waitqueue_head(&phba->wait_4_mlo_m_q);
+
+	/* Initialize the wait queue head for the kernel thread */
+	init_waitqueue_head(&phba->work_waitq);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"1403 Protocols supported %s %s\n",
+			((phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) ?
+				"SCSI" : " "),
+			((phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) ?
+				"NVME" : " "));
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		/* Initialize the scsi buffer list used by driver for scsi IO */
+		spin_lock_init(&phba->scsi_buf_list_get_lock);
+		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
+		spin_lock_init(&phba->scsi_buf_list_put_lock);
+		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+	}
+
+	if ((phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) &&
+		(phba->nvmet_support == 0)) {
+		/* Initialize the NVME buffer list used by driver for NVME IO */
+		spin_lock_init(&phba->nvme_buf_list_get_lock);
+		INIT_LIST_HEAD(&phba->lpfc_nvme_buf_list_get);
+		spin_lock_init(&phba->nvme_buf_list_put_lock);
+		INIT_LIST_HEAD(&phba->lpfc_nvme_buf_list_put);
+	}
+
+	/* Initialize the fabric iocb list */
+	INIT_LIST_HEAD(&phba->fabric_iocb_list);
+
+	/* Initialize list to save ELS buffers */
+	INIT_LIST_HEAD(&phba->elsbuf);
+
+	/* Initialize FCF connection rec list */
+	INIT_LIST_HEAD(&phba->fcf_conn_rec_list);
+
+	/* Initialize OAS configuration list */
+	spin_lock_init(&phba->devicelock);
+	INIT_LIST_HEAD(&phba->luns);
 
-	psli = &phba->sli;
 	/* MBOX heartbeat timer */
 	init_timer(&psli->mbox_tmo);
 	psli->mbox_tmo.function = lpfc_mbox_timeout;
 	psli->mbox_tmo.data = (unsigned long) phba;
-	/* FCP polling mode timer */
-	init_timer(&phba->fcp_poll_timer);
-	phba->fcp_poll_timer.function = lpfc_poll_timeout;
-	phba->fcp_poll_timer.data = (unsigned long) phba;
 	/* Fabric block timer */
 	init_timer(&phba->fabric_block_timer);
 	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
@@ -5043,6 +5288,38 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	init_timer(&phba->eratt_poll);
 	phba->eratt_poll.function = lpfc_poll_eratt;
 	phba->eratt_poll.data = (unsigned long) phba;
+	/* Heartbeat timer */
+	init_timer(&phba->hb_tmofunc);
+	phba->hb_tmofunc.function = lpfc_hb_timeout;
+	phba->hb_tmofunc.data = (unsigned long)phba;
+
+	return 0;
+}
+
+/**
+ * lpfc_sli_driver_resource_setup - Setup driver internal resources for SLI3 dev
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the driver internal resources specific to
+ * support the SLI-3 HBA device it attached to.
+ *
+ * Return codes
+ * 0 - successful
+ * other values - error
+ **/
+static int
+lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
+{
+	int rc;
+
+	/*
+	 * Initialize timers used by driver
+	 */
+
+	/* FCP polling mode timer */
+	init_timer(&phba->fcp_poll_timer);
+	phba->fcp_poll_timer.function = lpfc_poll_timeout;
+	phba->fcp_poll_timer.data = (unsigned long) phba;
 
 	/* Host attention work mask setup */
 	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
@@ -5050,6 +5327,12 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* Get all the module params for configuring this host */
 	lpfc_get_cfgparam(phba);
+	/* Set up phase-1 common device driver resources */
+
+	rc = lpfc_setup_driver_resource_phase1(phba);
+	if (rc)
+		return -ENODEV;
+
 	if (phba->pcidev->device == PCI_DEVICE_ID_HORNET) {
 		phba->menlo_flag |= HBA_MENLO_SUPPORT;
 		/* check for menlo minimum sg count */
@@ -5057,10 +5340,10 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
 	}
 
-	if (!phba->sli.ring)
-		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
+	if (!phba->sli.sli3_ring)
+		phba->sli.sli3_ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
-	if (!phba->sli.ring)
+	if (!phba->sli.sli3_ring)
 		return -ENOMEM;
 
 	/*
@@ -5119,7 +5402,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize the SLI Layer to run with lpfc HBAs.
 	 */
 	lpfc_sli_setup(phba);
-	lpfc_sli_queue_setup(phba);
+	lpfc_sli_queue_init(phba);
 
 	/* Allocate device driver memory */
 	if (lpfc_mem_alloc(phba, BPL_ALIGN_SZ))
@@ -5175,18 +5458,25 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
 static int
 lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_vector_map_info *cpup;
-	struct lpfc_sli *psli;
 	LPFC_MBOXQ_t *mboxq;
-	int rc, i, hbq_count, max_buf_size;
+	int rc, i, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
 	int longs;
 	int fof_vectors = 0;
 
+	phba->sli4_hba.num_online_cpu = num_online_cpus();
+	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
+	phba->sli4_hba.curr_disp_cpu = 0;
+
 	/* Get all the module params for configuring this host */
 	lpfc_get_cfgparam(phba);
 
+	/* Set up phase-1 common device driver resources */
+	rc = lpfc_setup_driver_resource_phase1(phba);
+	if (rc)
+		return -ENODEV;
+
 	/* Before proceed, wait for POST done and device ready */
 	rc = lpfc_sli4_post_status_check(phba);
 	if (rc)
@@ -5196,27 +5486,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize timers used by driver
 	 */
 
-	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
 	init_timer(&phba->rrq_tmr);
 	phba->rrq_tmr.function = lpfc_rrq_timeout;
 	phba->rrq_tmr.data = (unsigned long)phba;
 
-	psli = &phba->sli;
-	/* MBOX heartbeat timer */
-	init_timer(&psli->mbox_tmo);
-	psli->mbox_tmo.function = lpfc_mbox_timeout;
-	psli->mbox_tmo.data = (unsigned long) phba;
-	/* Fabric block timer */
-	init_timer(&phba->fabric_block_timer);
-	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
-	phba->fabric_block_timer.data = (unsigned long) phba;
-	/* EA polling mode timer */
-	init_timer(&phba->eratt_poll);
-	phba->eratt_poll.function = lpfc_poll_eratt;
-	phba->eratt_poll.data = (unsigned long) phba;
 	/* FCF rediscover timer */
 	init_timer(&phba->fcf.redisc_wait);
 	phba->fcf.redisc_wait.function = lpfc_sli4_fcf_redisc_wait_tmo;
@@ -5243,14 +5516,9 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	/*
 	 * For SLI4, instead of using ring 0 (LPFC_FCP_RING) for FCP commands
-	 * we will associate a new ring, for each FCP fastpath EQ/CQ/WQ tuple.
+	 * we will associate a new ring, for each EQ/CQ/WQ tuple.
+	 * The WQ create will allocate the ring.
 	 */
-	if (!phba->sli.ring)
-		phba->sli.ring = kzalloc(
-			(LPFC_SLI3_MAX_RING + phba->cfg_fcp_io_channel) *
-			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
-	if (!phba->sli.ring)
-		return -ENOMEM;
 
 	/*
 	 * It doesn't matter what family our adapter is in, we are
@@ -5262,43 +5530,45 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		phba->cfg_sg_seg_cnt = LPFC_MAX_SGL_SEG_CNT - 2;
 
 	/*
-	 * Since lpfc_sg_seg_cnt is module parameter, the sg_dma_buf_size
-	 * used to create the sg_dma_buf_pool must be dynamically calculated.
+	 * Since lpfc_sg_seg_cnt is module param, the sg_dma_buf_size
+	 * used to create the sg_dma_buf_pool must be calculated.
 	 */
-
 	if (phba->cfg_enable_bg) {
 		/*
-		 * The scsi_buf for a T10-DIF I/O will hold the FCP cmnd,
-		 * the FCP rsp, and a SGE for each. Sice we have no control
-		 * over how many protection data segments the SCSI Layer
+		 * The scsi_buf for a T10-DIF I/O holds the FCP cmnd,
+		 * the FCP rsp, and a SGE. Sice we have no control
+		 * over how many protection segments the SCSI Layer
 		 * will hand us (ie: there could be one for every block
-		 * in the IO), we just allocate enough SGEs to accomidate
-		 * our max amount and we need to limit lpfc_sg_seg_cnt to
-		 * minimize the risk of running out.
+		 * in the IO), just allocate enough SGEs to accomidate
+		 * our max amount and we need to limit lpfc_sg_seg_cnt
+		 * to minimize the risk of running out.
 		 */
 		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
-			sizeof(struct fcp_rsp) + max_buf_size;
+				sizeof(struct fcp_rsp) + max_buf_size;
 
 		/* Total SGEs for scsi_sg_list and scsi_sg_prot_list */
 		phba->cfg_total_seg_cnt = LPFC_MAX_SGL_SEG_CNT;
 
 		if (phba->cfg_sg_seg_cnt > LPFC_MAX_SG_SLI4_SEG_CNT_DIF)
-			phba->cfg_sg_seg_cnt = LPFC_MAX_SG_SLI4_SEG_CNT_DIF;
+			phba->cfg_sg_seg_cnt =
+				LPFC_MAX_SG_SLI4_SEG_CNT_DIF;
 	} else {
 		/*
-		 * The scsi_buf for a regular I/O will hold the FCP cmnd,
+		 * The scsi_buf for a regular I/O holds the FCP cmnd,
 		 * the FCP rsp, a SGE for each, and a SGE for up to
 		 * cfg_sg_seg_cnt data segments.
 		 */
 		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
-			sizeof(struct fcp_rsp) +
-			((phba->cfg_sg_seg_cnt + 2) * sizeof(struct sli4_sge));
+				sizeof(struct fcp_rsp) +
+				((phba->cfg_sg_seg_cnt + 2) *
+				sizeof(struct sli4_sge));
 
 		/* Total SGEs for scsi_sg_list */
 		phba->cfg_total_seg_cnt = phba->cfg_sg_seg_cnt + 2;
+
 		/*
-		 * NOTE: if (phba->cfg_sg_seg_cnt + 2) <= 256 we only need
-		 * to post 1 page for the SGL.
+		 * NOTE: if (phba->cfg_sg_seg_cnt + 2) <= 256 we only
+		 * need to post 1 page for the SGL.
 		 */
 	}
 
@@ -5318,21 +5588,27 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_total_seg_cnt);
 
 	/* Initialize buffer queue management fields */
-	hbq_count = lpfc_sli_hbq_count();
-	for (i = 0; i < hbq_count; ++i)
-		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
-	INIT_LIST_HEAD(&phba->rb_pend_list);
+	INIT_LIST_HEAD(&phba->hbqs[LPFC_ELS_HBQ].hbq_buffer_list);
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_sli4_rb_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_sli4_rb_free;
 
 	/*
 	 * Initialize the SLI Layer to run with lpfc SLI4 HBAs.
 	 */
-	/* Initialize the Abort scsi buffer list used by driver */
-	spin_lock_init(&phba->sli4_hba.abts_scsi_buf_list_lock);
-	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		/* Initialize the Abort scsi buffer list used by driver */
+		spin_lock_init(&phba->sli4_hba.abts_scsi_buf_list_lock);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	}
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Initialize the Abort nvme buffer list used by driver */
+		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+	}
+
 	/* This abort list used by worker thread */
-	spin_lock_init(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
 
 	/*
 	 * Initialize driver internal slow-path work queues
@@ -5360,10 +5636,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* initialize optic_state to 0xFF */
 	phba->sli4_hba.lnk_info.optic_state = 0xff;
 
-	/* Initialize the driver internal SLI layer lists. */
-	lpfc_sli_setup(phba);
-	lpfc_sli_queue_setup(phba);
-
 	/* Allocate device driver memory */
 	rc = lpfc_mem_alloc(phba, SGL_ALIGN_SZ);
 	if (rc)
@@ -5373,8 +5645,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		rc = lpfc_pci_function_reset(phba);
-		if (unlikely(rc))
-			return -ENODEV;
+		if (unlikely(rc)) {
+			rc = -ENODEV;
+			goto out_free_mem;
+		}
 		phba->temp_sensor_support = 1;
 	}
 
@@ -5411,6 +5685,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_bsmbx;
 	}
 
+	phba->nvmet_support = 0;
+
+	lpfc_nvme_mod_param_dep(phba);
+
 	/* Get the Supported Pages if PORT_CAPABILITIES is supported by port. */
 	lpfc_supported_pages(mboxq);
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
@@ -5449,9 +5727,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2999 Unsupported SLI4 Parameters "
 				"Extents and RPI headers enabled.\n");
-			goto out_free_bsmbx;
 		}
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		goto out_free_bsmbx;
 	}
+
 	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/* Verify OAS is supported */
@@ -5498,11 +5778,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_remove_rpi_hdrs;
 	}
 
-	phba->sli4_hba.fcp_eq_hdl =
-			kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
-			    (fof_vectors + phba->cfg_fcp_io_channel)),
-			    GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_eq_hdl) {
+	phba->sli4_hba.hba_eq_hdl = kcalloc(fof_vectors + phba->io_channel_irqs,
+						sizeof(struct lpfc_hba_eq_hdl),
+						GFP_KERNEL);
+	if (!phba->sli4_hba.hba_eq_hdl) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2572 Failed allocate memory for "
 				"fast-path per-EQ handle array\n");
@@ -5510,41 +5789,31 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_fcf_rr_bmask;
 	}
 
-	phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
-					 phba->sli4_hba.num_present_cpu),
-					 GFP_KERNEL);
+	phba->sli4_hba.cpu_map = kcalloc(phba->sli4_hba.num_present_cpu,
+					sizeof(struct lpfc_vector_map_info),
+					GFP_KERNEL);
 	if (!phba->sli4_hba.cpu_map) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3327 Failed allocate memory for msi-x "
 				"interrupt vector mapping\n");
 		rc = -ENOMEM;
-		goto out_free_fcp_eq_hdl;
+		goto out_free_hba_eq_hdl;
 	}
 	if (lpfc_used_cpu == NULL) {
-		lpfc_used_cpu = kzalloc((sizeof(uint16_t) * lpfc_present_cpu),
-					 GFP_KERNEL);
+		lpfc_used_cpu = kcalloc(lpfc_present_cpu, sizeof(uint16_t),
+						GFP_KERNEL);
 		if (!lpfc_used_cpu) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3335 Failed allocate memory for msi-x "
 					"interrupt vector mapping\n");
 			kfree(phba->sli4_hba.cpu_map);
 			rc = -ENOMEM;
-			goto out_free_fcp_eq_hdl;
+			goto out_free_hba_eq_hdl;
 		}
 		for (i = 0; i < lpfc_present_cpu; i++)
 			lpfc_used_cpu[i] = LPFC_VECTOR_MAP_EMPTY;
 	}
 
-	/* Initialize io channels for round robin */
-	cpup = phba->sli4_hba.cpu_map;
-	rc = 0;
-	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-		cpup->channel_id = rc;
-		rc++;
-		if (rc >= phba->cfg_fcp_io_channel)
-			rc = 0;
-	}
-
 	/*
 	 * Enable sr-iov virtual functions if supported and configured
 	 * through the module parameter.
@@ -5564,8 +5833,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	return 0;
 
-out_free_fcp_eq_hdl:
-	kfree(phba->sli4_hba.fcp_eq_hdl);
+out_free_hba_eq_hdl:
+	kfree(phba->sli4_hba.hba_eq_hdl);
 out_free_fcf_rr_bmask:
 	kfree(phba->fcf.fcf_rr_bmask);
 out_remove_rpi_hdrs:
@@ -5600,7 +5869,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 	phba->sli4_hba.curr_disp_cpu = 0;
 
 	/* Free memory allocated for fast-path work queue handles */
-	kfree(phba->sli4_hba.fcp_eq_hdl);
+	kfree(phba->sli4_hba.hba_eq_hdl);
 
 	/* Free the allocated rpi headers. */
 	lpfc_sli4_remove_rpi_hdrs(phba);
@@ -5674,58 +5943,6 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 }
 
 /**
- * lpfc_setup_driver_resource_phase1 - Phase1 etup driver internal resources.
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to set up the driver internal resources before the
- * device specific resource setup to support the HBA device it attached to.
- *
- * Return codes
- *	0 - successful
- *	other values - error
- **/
-static int
-lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
-{
-	/*
-	 * Driver resources common to all SLI revisions
-	 */
-	atomic_set(&phba->fast_event_count, 0);
-	spin_lock_init(&phba->hbalock);
-
-	/* Initialize ndlp management spinlock */
-	spin_lock_init(&phba->ndlp_lock);
-
-	INIT_LIST_HEAD(&phba->port_list);
-	INIT_LIST_HEAD(&phba->work_list);
-	init_waitqueue_head(&phba->wait_4_mlo_m_q);
-
-	/* Initialize the wait queue head for the kernel thread */
-	init_waitqueue_head(&phba->work_waitq);
-
-	/* Initialize the scsi buffer list used by driver for scsi IO */
-	spin_lock_init(&phba->scsi_buf_list_get_lock);
-	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
-	spin_lock_init(&phba->scsi_buf_list_put_lock);
-	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
-
-	/* Initialize the fabric iocb list */
-	INIT_LIST_HEAD(&phba->fabric_iocb_list);
-
-	/* Initialize list to save ELS buffers */
-	INIT_LIST_HEAD(&phba->elsbuf);
-
-	/* Initialize FCF connection rec list */
-	INIT_LIST_HEAD(&phba->fcf_conn_rec_list);
-
-	/* Initialize OAS configuration list */
-	spin_lock_init(&phba->devicelock);
-	INIT_LIST_HEAD(&phba->luns);
-
-	return 0;
-}
-
-/**
  * lpfc_setup_driver_resource_phase2 - Phase2 setup driver internal resources.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -5872,13 +6089,12 @@ static void
 lpfc_free_els_sgl_list(struct lpfc_hba *phba)
 {
 	LIST_HEAD(sglq_list);
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	/* Retrieve all els sgls from driver list */
 	spin_lock_irq(&phba->hbalock);
-	spin_lock(&pring->ring_lock);
-	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &sglq_list);
-	spin_unlock(&pring->ring_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_splice_init(&phba->sli4_hba.lpfc_els_sgl_list, &sglq_list);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Now free the sgl list */
@@ -5932,7 +6148,7 @@ static void
 lpfc_init_sgl_list(struct lpfc_hba *phba)
 {
 	/* Initialize and populate the sglq list per host/VF. */
-	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_sgl_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_els_sgl_list);
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 
 	/* els xri-sgl book keeping */
@@ -5940,6 +6156,9 @@ lpfc_init_sgl_list(struct lpfc_hba *phba)
 
 	/* scsi xri-buffer book keeping */
 	phba->sli4_hba.scsi_xri_cnt = 0;
+
+	/* nvme xri-buffer book keeping */
+	phba->sli4_hba.nvme_xri_cnt = 0;
 }
 
 /**
@@ -6170,9 +6389,9 @@ lpfc_hba_free(struct lpfc_hba *phba)
 	/* Release the driver assigned board number */
 	idr_remove(&lpfc_hba_index, phba->brd_no);
 
-	/* Free memory allocated with sli rings */
-	kfree(phba->sli.ring);
-	phba->sli.ring = NULL;
+	/* Free memory allocated with sli3 rings */
+	kfree(phba->sli.sli3_ring);
+	phba->sli.sli3_ring = NULL;
 
 	kfree(phba);
 	return;
@@ -6490,8 +6709,6 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 
 	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
 
-	INIT_LIST_HEAD(&phba->rb_pend_list);
-
 	phba->MBslimaddr = phba->slim_memmap_p;
 	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
 	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
@@ -7201,11 +7418,11 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_queue_verify - Verify and update EQ and CQ counts
+ * lpfc_sli4_queue_verify - Verify and update EQ counts
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to check the user settable queue counts for EQs and
- * CQs. after this routine is called the counts will be set to valid values that
+ * This routine is invoked to check the user settable queue counts for EQs.
+ * After this routine is called the counts will be set to valid values that
  * adhere to the constraints of the system's interrupt vectors and the port's
  * queue resources.
  *
@@ -7216,9 +7433,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
 static int
 lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 {
-	int cfg_fcp_io_channel;
-	uint32_t cpu;
-	uint32_t i = 0;
+	int io_channel;
 	int fof_vectors = phba->cfg_fof ? 1 : 0;
 
 	/*
@@ -7227,49 +7442,38 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	 */
 
 	/* Sanity check on HBA EQ parameters */
-	cfg_fcp_io_channel = phba->cfg_fcp_io_channel;
+	io_channel = phba->io_channel_irqs;
 
-	/* It doesn't make sense to have more io channels then online CPUs */
-	for_each_present_cpu(cpu) {
-		if (cpu_online(cpu))
-			i++;
-	}
-	phba->sli4_hba.num_online_cpu = i;
-	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
-	phba->sli4_hba.curr_disp_cpu = 0;
-
-	if (i < cfg_fcp_io_channel) {
+	if (phba->sli4_hba.num_online_cpu < io_channel) {
 		lpfc_printf_log(phba,
 				KERN_ERR, LOG_INIT,
 				"3188 Reducing IO channels to match number of "
 				"online CPUs: from %d to %d\n",
-				cfg_fcp_io_channel, i);
-		cfg_fcp_io_channel = i;
+				io_channel, phba->sli4_hba.num_online_cpu);
+		io_channel = phba->sli4_hba.num_online_cpu;
 	}
 
-	if (cfg_fcp_io_channel + fof_vectors >
-	    phba->sli4_hba.max_cfg_param.max_eq) {
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
+	if (io_channel + fof_vectors > phba->sli4_hba.max_cfg_param.max_eq) {
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
+	if (io_channel != phba->io_channel_irqs)
+		phba->io_channel_irqs = io_channel;
+	if (phba->cfg_fcp_io_channel > io_channel)
+		phba->cfg_fcp_io_channel = io_channel;
+	if (phba->cfg_nvme_io_channel > io_channel)
+		phba->cfg_nvme_io_channel = io_channel;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2574 IRQs: %d, IO Channels: fcp %d nvme %d\n",
+			phba->io_channel_irqs, phba->cfg_fcp_io_channel,
+			phba->cfg_nvme_io_channel);
 
 	/* Get EQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
@@ -7278,10 +7482,67 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	/* Get CQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
 	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
+	return 0;
+}
+
+static int
+lpfc_alloc_nvme_wq_cq(struct lpfc_hba *phba, int wqidx)
+{
+	struct lpfc_queue *qdesc;
+	int cnt;
 
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					    phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0508 Failed allocate fast-path NVME CQ (%d)\n",
+				wqidx);
+		return 1;
+	}
+	phba->sli4_hba.nvme_cq[wqidx] = qdesc;
+
+	cnt = LPFC_NVME_WQSIZE;
+	qdesc = lpfc_sli4_queue_alloc(phba, LPFC_WQE128_SIZE, cnt);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0509 Failed allocate fast-path NVME WQ (%d)\n",
+				wqidx);
+		return 1;
+	}
+	phba->sli4_hba.nvme_wq[wqidx] = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+	return 0;
+}
+
+static int
+lpfc_alloc_fcp_wq_cq(struct lpfc_hba *phba, int wqidx)
+{
+	struct lpfc_queue *qdesc;
+	uint32_t wqesize;
+
+	/* Create Fast Path FCP CQs */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0499 Failed allocate fast-path FCP CQ (%d)\n", wqidx);
+		return 1;
+	}
+	phba->sli4_hba.fcp_cq[wqidx] = qdesc;
+
+	/* Create Fast Path FCP WQs */
+	wqesize = (phba->fcp_embed_io) ?
+				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
+	qdesc = lpfc_sli4_queue_alloc(phba, wqesize, phba->sli4_hba.wq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0503 Failed allocate fast-path FCP WQ (%d)\n",
+				wqidx);
+		return 1;
+	}
+	phba->sli4_hba.fcp_wq[wqidx] = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
 	return 0;
-out_error:
-	return -ENOMEM;
 }
 
 /**
@@ -7302,13 +7563,14 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
-	uint32_t wqesize;
-	int idx;
+	int idx, io_channel;
 
 	/*
 	 * Create HBA Record arrays.
+	 * Both NVME and FCP will share that same vectors / EQs
 	 */
-	if (!phba->cfg_fcp_io_channel)
+	io_channel = phba->io_channel_irqs;
+	if (!io_channel)
 		return -ERANGE;
 
 	phba->sli4_hba.mq_esize = LPFC_MQE_SIZE;
@@ -7317,9 +7579,14 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	phba->sli4_hba.wq_ecount = LPFC_WQE_DEF_COUNT;
 	phba->sli4_hba.rq_esize = LPFC_RQE_SIZE;
 	phba->sli4_hba.rq_ecount = LPFC_RQE_DEF_COUNT;
+	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
+	phba->sli4_hba.eq_ecount = LPFC_EQE_DEF_COUNT;
+	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
+	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
 
-	phba->sli4_hba.hba_eq =  kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
+	phba->sli4_hba.hba_eq =  kcalloc(io_channel,
+					sizeof(struct lpfc_queue *),
+					GFP_KERNEL);
 	if (!phba->sli4_hba.hba_eq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2576 Failed allocate memory for "
@@ -7327,44 +7594,83 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 
-	phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2577 Failed allocate memory for fast-path "
-				"CQ record array\n");
-		goto out_error;
+	if (phba->cfg_fcp_io_channel) {
+		phba->sli4_hba.fcp_cq = kcalloc(phba->cfg_fcp_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2577 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
+		phba->sli4_hba.fcp_wq = kcalloc(phba->cfg_fcp_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2578 Failed allocate memory for "
+					"fast-path FCP WQ record array\n");
+			goto out_error;
+		}
+		/*
+		 * Since the first EQ can have multiple CQs associated with it,
+		 * this array is used to quickly see if we have a FCP fast-path
+		 * CQ match.
+		 */
+		phba->sli4_hba.fcp_cq_map = kcalloc(phba->cfg_fcp_io_channel,
+							sizeof(uint16_t),
+							GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2545 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
 	}
 
-	phba->sli4_hba.fcp_wq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2578 Failed allocate memory for fast-path "
-				"WQ record array\n");
-		goto out_error;
-	}
+	if (phba->cfg_nvme_io_channel) {
+		phba->sli4_hba.nvme_cq = kcalloc(phba->cfg_nvme_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6077 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
 
-	/*
-	 * Since the first EQ can have multiple CQs associated with it,
-	 * this array is used to quickly see if we have a FCP fast-path
-	 * CQ match.
-	 */
-	phba->sli4_hba.fcp_cq_map = kzalloc((sizeof(uint16_t) *
-					 phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_cq_map) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2545 Failed allocate memory for fast-path "
-				"CQ map\n");
-		goto out_error;
+
+		phba->sli4_hba.nvme_wq = kcalloc(phba->cfg_nvme_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2581 Failed allocate memory for "
+					"fast-path NVME WQ record array\n");
+			goto out_error;
+		}
+
+		/*
+		 * Since the first EQ can have multiple CQs associated with it,
+		 * this array is used to quickly see if we have a NVME fast-path
+		 * CQ match.
+		 */
+		phba->sli4_hba.nvme_cq_map = kcalloc(phba->cfg_nvme_io_channel,
+							sizeof(uint16_t),
+							GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6078 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
 	}
 
-	/*
-	 * Create HBA Event Queues (EQs).  The cfg_fcp_io_channel specifies
-	 * how many EQs to create.
-	 */
-	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
 
+	/* Create HBA Event Queues (EQs) */
+	for (idx = 0; idx < io_channel; idx++) {
 		/* Create EQs */
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
 					      phba->sli4_hba.eq_ecount);
@@ -7374,32 +7680,17 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			goto out_error;
 		}
 		phba->sli4_hba.hba_eq[idx] = qdesc;
+	}
 
-		/* Create Fast Path FCP CQs */
-		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
-					      phba->sli4_hba.cq_ecount);
-		if (!qdesc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0499 Failed allocate fast-path FCP "
-					"CQ (%d)\n", idx);
-			goto out_error;
-		}
-		phba->sli4_hba.fcp_cq[idx] = qdesc;
+	/* FCP and NVME io channels are not required to be balanced */
 
-		/* Create Fast Path FCP WQs */
-		wqesize = (phba->fcp_embed_io) ?
-				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
-		qdesc = lpfc_sli4_queue_alloc(phba, wqesize,
-						phba->sli4_hba.wq_ecount);
-		if (!qdesc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0503 Failed allocate fast-path FCP "
-					"WQ (%d)\n", idx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		if (lpfc_alloc_fcp_wq_cq(phba, idx))
 			goto out_error;
-		}
-		phba->sli4_hba.fcp_wq[idx] = qdesc;
-	}
 
+	for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++)
+		if (lpfc_alloc_nvme_wq_cq(phba, idx))
+			goto out_error;
 
 	/*
 	 * Create Slow Path Completion Queues (CQs)
@@ -7454,6 +7745,30 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 	phba->sli4_hba.els_wq = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Create NVME LS Complete Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					      phba->sli4_hba.cq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6079 Failed allocate NVME LS CQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmels_cq = qdesc;
+
+		/* Create NVME LS Work Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
+					      phba->sli4_hba.wq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6080 Failed allocate NVME LS WQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmels_wq = qdesc;
+		list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+	}
 
 	/*
 	 * Create Receive Queue (RQ)
@@ -7489,6 +7804,39 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	return -ENOMEM;
 }
 
+static inline void
+__lpfc_sli4_release_queue(struct lpfc_queue **qp)
+{
+	if (*qp != NULL) {
+		lpfc_sli4_queue_free(*qp);
+		*qp = NULL;
+	}
+}
+
+static inline void
+lpfc_sli4_release_queues(struct lpfc_queue ***qs, int max)
+{
+	int idx;
+
+	if (*qs == NULL)
+		return;
+
+	for (idx = 0; idx < max; idx++)
+		__lpfc_sli4_release_queue(&(*qs)[idx]);
+
+	kfree(*qs);
+	*qs = NULL;
+}
+
+static inline void
+lpfc_sli4_release_queue_map(uint16_t **qmap)
+{
+	if (*qmap != NULL) {
+		kfree(*qmap);
+		*qmap = NULL;
+	}
+}
+
 /**
  * lpfc_sli4_queue_destroy - Destroy all the SLI4 queues
  * @phba: pointer to lpfc hba data structure.
@@ -7504,91 +7852,188 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 void
 lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 {
-	int idx;
-
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
 
-	if (phba->sli4_hba.hba_eq != NULL) {
-		/* Release HBA event queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.hba_eq[idx] != NULL) {
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.hba_eq[idx]);
-				phba->sli4_hba.hba_eq[idx] = NULL;
-			}
+	/* Release HBA eqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.hba_eq, phba->io_channel_irqs);
+
+	/* Release FCP cqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.fcp_cq,
+					phba->cfg_fcp_io_channel);
+
+	/* Release FCP wqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.fcp_wq,
+					phba->cfg_fcp_io_channel);
+
+	/* Release FCP CQ mapping array */
+	lpfc_sli4_release_queue_map(&phba->sli4_hba.fcp_cq_map);
+
+	/* Release NVME cqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvme_cq,
+					phba->cfg_nvme_io_channel);
+
+	/* Release NVME wqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvme_wq,
+					phba->cfg_nvme_io_channel);
+
+	/* Release NVME CQ mapping array */
+	lpfc_sli4_release_queue_map(&phba->sli4_hba.nvme_cq_map);
+
+	/* Release mailbox command work queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.mbx_wq);
+
+	/* Release ELS work queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.els_wq);
+
+	/* Release ELS work queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.nvmels_wq);
+
+	/* Release unsolicited receive queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.hdr_rq);
+	__lpfc_sli4_release_queue(&phba->sli4_hba.dat_rq);
+
+	/* Release ELS complete queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.els_cq);
+
+	/* Release NVME LS complete queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.nvmels_cq);
+
+	/* Release mailbox command complete queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.mbx_cq);
+
+	/* Everything on this list has been freed */
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
+}
+
+int
+lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
+		    struct lpfc_queue *drq, int count)
+{
+	int rc, i;
+	struct lpfc_rqe hrqe;
+	struct lpfc_rqe drqe;
+	struct lpfc_rqb *rqbp;
+	struct rqb_dmabuf *rqb_buffer;
+	LIST_HEAD(rqb_buf_list);
+
+	rqbp = hrq->rqbp;
+	for (i = 0; i < count; i++) {
+		rqb_buffer = (rqbp->rqb_alloc_buffer)(phba);
+		if (!rqb_buffer)
+			break;
+		rqb_buffer->hrq = hrq;
+		rqb_buffer->drq = drq;
+		list_add_tail(&rqb_buffer->hbuf.list, &rqb_buf_list);
+	}
+	while (!list_empty(&rqb_buf_list)) {
+		list_remove_head(&rqb_buf_list, rqb_buffer, struct rqb_dmabuf,
+				 hbuf.list);
+
+		hrqe.address_lo = putPaddrLow(rqb_buffer->hbuf.phys);
+		hrqe.address_hi = putPaddrHigh(rqb_buffer->hbuf.phys);
+		drqe.address_lo = putPaddrLow(rqb_buffer->dbuf.phys);
+		drqe.address_hi = putPaddrHigh(rqb_buffer->dbuf.phys);
+		rc = lpfc_sli4_rq_put(hrq, drq, &hrqe, &drqe);
+		if (rc < 0) {
+			(rqbp->rqb_free_buffer)(phba, rqb_buffer);
+		} else {
+			list_add_tail(&rqb_buffer->hbuf.list,
+				      &rqbp->rqb_buffer_list);
+			rqbp->buffer_count++;
 		}
-		kfree(phba->sli4_hba.hba_eq);
-		phba->sli4_hba.hba_eq = NULL;
 	}
+	return 1;
+}
 
-	if (phba->sli4_hba.fcp_cq != NULL) {
-		/* Release FCP completion queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.fcp_cq[idx] != NULL) {
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.fcp_cq[idx]);
-				phba->sli4_hba.fcp_cq[idx] = NULL;
-			}
-		}
-		kfree(phba->sli4_hba.fcp_cq);
-		phba->sli4_hba.fcp_cq = NULL;
+int
+lpfc_free_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *rq)
+{
+	struct lpfc_rqb *rqbp;
+	struct lpfc_dmabuf *h_buf;
+	struct rqb_dmabuf *rqb_buffer;
+
+	rqbp = rq->rqbp;
+	while (!list_empty(&rqbp->rqb_buffer_list)) {
+		list_remove_head(&rqbp->rqb_buffer_list, h_buf,
+				 struct lpfc_dmabuf, list);
+
+		rqb_buffer = container_of(h_buf, struct rqb_dmabuf, hbuf);
+		(rqbp->rqb_free_buffer)(phba, rqb_buffer);
+		rqbp->buffer_count--;
 	}
+	return 1;
+}
 
-	if (phba->sli4_hba.fcp_wq != NULL) {
-		/* Release FCP work queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.fcp_wq[idx] != NULL) {
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.fcp_wq[idx]);
-				phba->sli4_hba.fcp_wq[idx] = NULL;
-			}
-		}
-		kfree(phba->sli4_hba.fcp_wq);
-		phba->sli4_hba.fcp_wq = NULL;
+static int
+lpfc_create_wq_cq(struct lpfc_hba *phba, struct lpfc_queue *eq,
+	struct lpfc_queue *cq, struct lpfc_queue *wq, uint16_t *cq_map,
+	int qidx, uint32_t qtype)
+{
+	struct lpfc_sli_ring *pring;
+	int rc;
+
+	if (!eq || !cq || !wq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"6085 Fast-path %s (%d) not allocated\n",
+			((eq) ? ((cq) ? "WQ" : "CQ") : "EQ"), qidx);
+		return -ENOMEM;
+	}
+
+	/* create the Cq first */
+	rc = lpfc_cq_create(phba, cq, eq,
+			(qtype == LPFC_MBOX) ? LPFC_MCQ : LPFC_WCQ, qtype);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"6086 Failed setup of CQ (%d), rc = 0x%x\n",
+			qidx, (uint32_t)rc);
+		return rc;
 	}
 
-	/* Release FCP CQ mapping array */
-	if (phba->sli4_hba.fcp_cq_map != NULL) {
-		kfree(phba->sli4_hba.fcp_cq_map);
-		phba->sli4_hba.fcp_cq_map = NULL;
-	}
+	if (qtype != LPFC_MBOX) {
+		/* Setup nvme_cq_map for fast lookup */
+		if (cq_map)
+			*cq_map = cq->queue_id;
 
-	/* Release mailbox command work queue */
-	if (phba->sli4_hba.mbx_wq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.mbx_wq);
-		phba->sli4_hba.mbx_wq = NULL;
-	}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"6087 CQ setup: cq[%d]-id=%d, parent eq[%d]-id=%d\n",
+			qidx, cq->queue_id, qidx, eq->queue_id);
 
-	/* Release ELS work queue */
-	if (phba->sli4_hba.els_wq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.els_wq);
-		phba->sli4_hba.els_wq = NULL;
-	}
+		/* create the wq */
+		rc = lpfc_wq_create(phba, wq, cq, qtype);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6123 Fail setup fastpath WQ (%d), rc = 0x%x\n",
+				qidx, (uint32_t)rc);
+			/* no need to tear down cq - caller will do so */
+			return rc;
+		}
 
-	/* Release unsolicited receive queue */
-	if (phba->sli4_hba.hdr_rq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
-		phba->sli4_hba.hdr_rq = NULL;
-	}
-	if (phba->sli4_hba.dat_rq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.dat_rq);
-		phba->sli4_hba.dat_rq = NULL;
-	}
+		/* Bind this CQ/WQ to the NVME ring */
+		pring = wq->pring;
+		pring->sli.sli4.wqp = (void *)wq;
+		cq->pring = pring;
 
-	/* Release ELS complete queue */
-	if (phba->sli4_hba.els_cq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.els_cq);
-		phba->sli4_hba.els_cq = NULL;
-	}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2593 WQ setup: wq[%d]-id=%d assoc=%d, cq[%d]-id=%d\n",
+			qidx, wq->queue_id, wq->assoc_qid, qidx, cq->queue_id);
+	} else {
+		rc = lpfc_mq_create(phba, wq, cq, LPFC_MBOX);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0539 Failed setup of slow-path MQ: "
+				"rc = 0x%x\n", rc);
+			/* no need to tear down cq - caller will do so */
+			return rc;
+		}
 
-	/* Release mailbox command complete queue */
-	if (phba->sli4_hba.mbx_cq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.mbx_cq);
-		phba->sli4_hba.mbx_cq = NULL;
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
+			phba->sli4_hba.mbx_wq->queue_id,
+			phba->sli4_hba.mbx_cq->queue_id);
 	}
 
-	return;
+	return 0;
 }
 
 /**
@@ -7606,15 +8051,12 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 int
 lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring;
-	int rc = -ENOMEM;
-	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
-	int fcp_cq_index = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	LPFC_MBOXQ_t *mboxq;
-	uint32_t length;
+	int qidx;
+	uint32_t length, io_channel;
+	int rc = -ENOMEM;
 
 	/* Check for dual-ULP support */
 	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -7664,220 +8106,173 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	/*
 	 * Set up HBA Event Queues (EQs)
 	 */
+	io_channel = phba->io_channel_irqs;
 
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
+	for (qidx = 0; qidx < io_channel; qidx++) {
+		if (!phba->sli4_hba.hba_eq[qidx]) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0522 Fast-path EQ (%d) not "
-					"allocated\n", fcp_eqidx);
+					"allocated\n", qidx);
 			rc = -ENOMEM;
-			goto out_destroy_hba_eq;
+			goto out_destroy;
 		}
-		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[fcp_eqidx],
-			 (phba->cfg_fcp_imax / phba->cfg_fcp_io_channel));
+		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[qidx],
+						phba->cfg_fcp_imax);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0523 Failed setup of fast-path EQ "
-					"(%d), rc = 0x%x\n", fcp_eqidx,
+					"(%d), rc = 0x%x\n", qidx,
 					(uint32_t)rc);
-			goto out_destroy_hba_eq;
+			goto out_destroy;
 		}
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2584 HBA EQ setup: "
-				"queue[%d]-id=%d\n", fcp_eqidx,
-				phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id);
-	}
-
-	/* Set up fast-path FCP Response Complete Queue */
-	if (!phba->sli4_hba.fcp_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3148 Fast-path FCP CQ array not "
-				"allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_hba_eq;
+				"2584 HBA EQ setup: queue[%d]-id=%d\n",
+				qidx, phba->sli4_hba.hba_eq[qidx]->queue_id);
 	}
 
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++) {
-		if (!phba->sli4_hba.fcp_cq[fcp_cqidx]) {
+	if (phba->cfg_nvme_io_channel) {
+		if (!phba->sli4_hba.nvme_cq || !phba->sli4_hba.nvme_wq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0526 Fast-path FCP CQ (%d) not "
-					"allocated\n", fcp_cqidx);
+				"6084 Fast-path NVME %s array not allocated\n",
+				(phba->sli4_hba.nvme_cq) ? "CQ" : "WQ");
 			rc = -ENOMEM;
-			goto out_destroy_fcp_cq;
-		}
-		rc = lpfc_cq_create(phba, phba->sli4_hba.fcp_cq[fcp_cqidx],
-			phba->sli4_hba.hba_eq[fcp_cqidx], LPFC_WCQ, LPFC_FCP);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0527 Failed setup of fast-path FCP "
-					"CQ (%d), rc = 0x%x\n", fcp_cqidx,
-					(uint32_t)rc);
-			goto out_destroy_fcp_cq;
+			goto out_destroy;
 		}
 
-		/* Setup fcp_cq_map for fast lookup */
-		phba->sli4_hba.fcp_cq_map[fcp_cqidx] =
-				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id;
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2588 FCP CQ setup: cq[%d]-id=%d, "
-				"parent seq[%d]-id=%d\n",
-				fcp_cqidx,
-				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id,
-				fcp_cqidx,
-				phba->sli4_hba.hba_eq[fcp_cqidx]->queue_id);
-	}
-
-	/* Set up fast-path FCP Work Queue */
-	if (!phba->sli4_hba.fcp_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3149 Fast-path FCP WQ array not "
-				"allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_fcp_cq;
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++) {
+			rc = lpfc_create_wq_cq(phba,
+					phba->sli4_hba.hba_eq[
+						qidx % io_channel],
+					phba->sli4_hba.nvme_cq[qidx],
+					phba->sli4_hba.nvme_wq[qidx],
+					&phba->sli4_hba.nvme_cq_map[qidx],
+					qidx, LPFC_NVME);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6123 Failed to setup fastpath "
+					"NVME WQ/CQ (%d), rc = 0x%x\n",
+					qidx, (uint32_t)rc);
+				goto out_destroy;
+			}
+		}
 	}
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++) {
-		if (!phba->sli4_hba.fcp_wq[fcp_wqidx]) {
+	if (phba->cfg_fcp_io_channel) {
+		/* Set up fast-path FCP Response Complete Queue */
+		if (!phba->sli4_hba.fcp_cq || !phba->sli4_hba.fcp_wq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0534 Fast-path FCP WQ (%d) not "
-					"allocated\n", fcp_wqidx);
+				"3148 Fast-path FCP %s array not allocated\n",
+				phba->sli4_hba.fcp_cq ? "WQ" : "CQ");
 			rc = -ENOMEM;
-			goto out_destroy_fcp_wq;
-		}
-		rc = lpfc_wq_create(phba, phba->sli4_hba.fcp_wq[fcp_wqidx],
-				    phba->sli4_hba.fcp_cq[fcp_wqidx],
-				    LPFC_FCP);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0535 Failed setup of fast-path FCP "
-					"WQ (%d), rc = 0x%x\n", fcp_wqidx,
-					(uint32_t)rc);
-			goto out_destroy_fcp_wq;
+			goto out_destroy;
 		}
 
-		/* Bind this WQ to the next FCP ring */
-		pring = &psli->ring[MAX_SLI3_CONFIGURED_RINGS + fcp_wqidx];
-		pring->sli.sli4.wqp = (void *)phba->sli4_hba.fcp_wq[fcp_wqidx];
-		phba->sli4_hba.fcp_cq[fcp_wqidx]->pring = pring;
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2591 FCP WQ setup: wq[%d]-id=%d, "
-				"parent cq[%d]-id=%d\n",
-				fcp_wqidx,
-				phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-				fcp_cq_index,
-				phba->sli4_hba.fcp_cq[fcp_wqidx]->queue_id);
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++) {
+			rc = lpfc_create_wq_cq(phba,
+					phba->sli4_hba.hba_eq[
+						qidx % io_channel],
+					phba->sli4_hba.fcp_cq[qidx],
+					phba->sli4_hba.fcp_wq[qidx],
+					&phba->sli4_hba.fcp_cq_map[qidx],
+					qidx, LPFC_FCP);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0535 Failed to setup fastpath "
+					"FCP WQ/CQ (%d), rc = 0x%x\n",
+					qidx, (uint32_t)rc);
+				goto out_destroy;
+			}
+		}
 	}
+
 	/*
-	 * Set up Complete Queues (CQs)
+	 * Set up Slow Path Complete Queues (CQs)
 	 */
 
-	/* Set up slow-path MBOX Complete Queue as the first CQ */
-	if (!phba->sli4_hba.mbx_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0528 Mailbox CQ not allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_fcp_wq;
-	}
-	rc = lpfc_cq_create(phba, phba->sli4_hba.mbx_cq,
-			phba->sli4_hba.hba_eq[0], LPFC_MCQ, LPFC_MBOX);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0529 Failed setup of slow-path mailbox CQ: "
-				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
-	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2585 MBX CQ setup: cq-id=%d, parent eq-id=%d\n",
-			phba->sli4_hba.mbx_cq->queue_id,
-			phba->sli4_hba.hba_eq[0]->queue_id);
+	/* Set up slow-path MBOX CQ/MQ */
 
-	/* Set up slow-path ELS Complete Queue */
-	if (!phba->sli4_hba.els_cq) {
+	if (!phba->sli4_hba.mbx_cq || !phba->sli4_hba.mbx_wq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0530 ELS CQ not allocated\n");
+				"0528 %s not allocated\n",
+				phba->sli4_hba.mbx_cq ?
+						"Mailbox WQ" : "Mailbox CQ");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_cq;
+		goto out_destroy;
 	}
-	rc = lpfc_cq_create(phba, phba->sli4_hba.els_cq,
-			phba->sli4_hba.hba_eq[0], LPFC_WCQ, LPFC_ELS);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0531 Failed setup of slow-path ELS CQ: "
-				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_cq;
-	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2586 ELS CQ setup: cq-id=%d, parent eq-id=%d\n",
-			phba->sli4_hba.els_cq->queue_id,
-			phba->sli4_hba.hba_eq[0]->queue_id);
-
-	/*
-	 * Set up all the Work Queues (WQs)
-	 */
 
-	/* Set up Mailbox Command Queue */
-	if (!phba->sli4_hba.mbx_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0538 Slow-path MQ not allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_els_cq;
-	}
-	rc = lpfc_mq_create(phba, phba->sli4_hba.mbx_wq,
-			    phba->sli4_hba.mbx_cq, LPFC_MBOX);
+	rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
+					phba->sli4_hba.mbx_cq,
+					phba->sli4_hba.mbx_wq,
+					NULL, 0, LPFC_MBOX);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0539 Failed setup of slow-path MQ: "
-				"rc = 0x%x\n", rc);
-		goto out_destroy_els_cq;
+			"0529 Failed setup of mailbox WQ/CQ: rc = 0x%x\n",
+			(uint32_t)rc);
+		goto out_destroy;
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
-			phba->sli4_hba.mbx_wq->queue_id,
-			phba->sli4_hba.mbx_cq->queue_id);
 
-	/* Set up slow-path ELS Work Queue */
-	if (!phba->sli4_hba.els_wq) {
+	/* Set up slow-path ELS WQ/CQ */
+	if (!phba->sli4_hba.els_cq || !phba->sli4_hba.els_wq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0536 Slow-path ELS WQ not allocated\n");
+				"0530 ELS %s not allocated\n",
+				phba->sli4_hba.els_cq ? "WQ" : "CQ");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_wq;
+		goto out_destroy;
 	}
-	rc = lpfc_wq_create(phba, phba->sli4_hba.els_wq,
-			    phba->sli4_hba.els_cq, LPFC_ELS);
+	rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
+					phba->sli4_hba.els_cq,
+					phba->sli4_hba.els_wq,
+					NULL, 0, LPFC_ELS);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0537 Failed setup of slow-path ELS WQ: "
-				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_wq;
+			"0529 Failed setup of ELS WQ/CQ: rc = 0x%x\n",
+			(uint32_t)rc);
+		goto out_destroy;
 	}
-
-	/* Bind this WQ to the ELS ring */
-	pring = &psli->ring[LPFC_ELS_RING];
-	pring->sli.sli4.wqp = (void *)phba->sli4_hba.els_wq;
-	phba->sli4_hba.els_cq->pring = pring;
-
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2590 ELS WQ setup: wq-id=%d, parent cq-id=%d\n",
 			phba->sli4_hba.els_wq->queue_id,
 			phba->sli4_hba.els_cq->queue_id);
 
-	/*
-	 * Create Receive Queue (RQ)
-	 */
+	if (phba->cfg_nvme_io_channel) {
+		/* Set up NVME LS Complete Queue */
+		if (!phba->sli4_hba.nvmels_cq || !phba->sli4_hba.nvmels_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6091 LS %s not allocated\n",
+					phba->sli4_hba.nvmels_cq ? "WQ" : "CQ");
+			rc = -ENOMEM;
+			goto out_destroy;
+		}
+		rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
+					phba->sli4_hba.nvmels_cq,
+					phba->sli4_hba.nvmels_wq,
+					NULL, 0, LPFC_NVME_LS);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0529 Failed setup of NVVME LS WQ/CQ: "
+				"rc = 0x%x\n", (uint32_t)rc);
+			goto out_destroy;
+		}
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"6096 ELS WQ setup: wq-id=%d, "
+				"parent cq-id=%d\n",
+				phba->sli4_hba.nvmels_wq->queue_id,
+				phba->sli4_hba.nvmels_cq->queue_id);
+	}
+
 	if (!phba->sli4_hba.hdr_rq || !phba->sli4_hba.dat_rq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0540 Receive Queue not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_els_wq;
+		goto out_destroy;
 	}
 
 	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
@@ -7889,7 +8284,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
+		goto out_destroy;
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -7905,7 +8300,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0549 Failed setup of FOF Queues: "
 					"rc = 0x%x\n", rc);
-			goto out_destroy_els_rq;
+			goto out_destroy;
 		}
 	}
 
@@ -7913,30 +8308,12 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	 * Configure EQ delay multipier for interrupt coalescing using
 	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-			fcp_eqidx += LPFC_MAX_EQ_DELAY)
-		lpfc_modify_fcp_eq_delay(phba, fcp_eqidx);
+	for (qidx = 0; qidx < io_channel; qidx += LPFC_MAX_EQ_DELAY)
+		lpfc_modify_hba_eq_delay(phba, qidx);
 	return 0;
 
-out_destroy_els_rq:
-	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
-out_destroy_els_wq:
-	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
-out_destroy_mbx_wq:
-	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
-out_destroy_els_cq:
-	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
-out_destroy_mbx_cq:
-	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
-out_destroy_fcp_wq:
-	for (--fcp_wqidx; fcp_wqidx >= 0; fcp_wqidx--)
-		lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_wqidx]);
-out_destroy_fcp_cq:
-	for (--fcp_cqidx; fcp_cqidx >= 0; fcp_cqidx--)
-		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_cqidx]);
-out_destroy_hba_eq:
-	for (--fcp_eqidx; fcp_eqidx >= 0; fcp_eqidx--)
-		lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_eqidx]);
+out_destroy:
+	lpfc_sli4_queue_unset(phba);
 out_error:
 	return rc;
 }
@@ -7956,39 +8333,66 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 void
 lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 {
-	int fcp_qidx;
+	int qidx;
 
 	/* Unset the queues created for Flash Optimized Fabric operations */
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
+
 	/* Unset mailbox command work queue */
-	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+	if (phba->sli4_hba.mbx_wq)
+		lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+
+	/* Unset NVME LS work queue */
+	if (phba->sli4_hba.nvmels_wq)
+		lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
+
 	/* Unset ELS work queue */
-	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
+	if (phba->sli4_hba.els_cq)
+		lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
+
 	/* Unset unsolicited receive queue */
-	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
+	if (phba->sli4_hba.hdr_rq)
+		lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq,
+				phba->sli4_hba.dat_rq);
+
 	/* Unset FCP work queue */
-	if (phba->sli4_hba.fcp_wq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_qidx]);
+	if (phba->sli4_hba.fcp_wq)
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[qidx]);
+
+	/* Unset NVME work queue */
+	if (phba->sli4_hba.nvme_wq) {
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			lpfc_wq_destroy(phba, phba->sli4_hba.nvme_wq[qidx]);
 	}
+
 	/* Unset mailbox command complete queue */
-	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
+	if (phba->sli4_hba.mbx_cq)
+		lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
+
 	/* Unset ELS complete queue */
-	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+	if (phba->sli4_hba.els_cq)
+		lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+
+	/* Unset NVME LS complete queue */
+	if (phba->sli4_hba.nvmels_cq)
+		lpfc_cq_destroy(phba, phba->sli4_hba.nvmels_cq);
+
+	/* Unset NVME response complete queue */
+	if (phba->sli4_hba.nvme_cq)
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			lpfc_cq_destroy(phba, phba->sli4_hba.nvme_cq[qidx]);
+
 	/* Unset FCP response complete queue */
-	if (phba->sli4_hba.fcp_cq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_qidx]);
-	}
+	if (phba->sli4_hba.fcp_cq)
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[qidx]);
+
 	/* Unset fast-path event queue */
-	if (phba->sli4_hba.hba_eq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_qidx]);
-	}
+	if (phba->sli4_hba.hba_eq)
+		for (qidx = 0; qidx < phba->io_channel_irqs; qidx++)
+			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[qidx]);
 }
 
 /**
@@ -8698,91 +9102,33 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_find_next_cpu - Find next available CPU that matches the phys_id
+ * lpfc_cpu_affinity_check - Check vector CPU affinity mappings
  * @phba: pointer to lpfc hba data structure.
- *
- * Find next available CPU to use for IRQ to CPU affinity.
+ * @vectors: number of msix vectors allocated.
+ *
+ * The routine will figure out the CPU affinity assignment for every
+ * MSI-X vector allocated for the HBA.  The hba_eq_hdl will be updated
+ * with a pointer to the CPU mask that defines ALL the CPUs this vector
+ * can be associated with. If the vector can be unquely associated with
+ * a single CPU, that CPU will be recorded in hba_eq_hdl[index].cpu.
+ * In addition, the CPU to IO channel mapping will be calculated
+ * and the phba->sli4_hba.cpu_map array will reflect this.
  */
-static int
-lpfc_find_next_cpu(struct lpfc_hba *phba, uint32_t phys_id)
+static void
+lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 {
 	struct lpfc_vector_map_info *cpup;
+	int index = 0;
+	int vec = 0;
 	int cpu;
-
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		/* CPU must be online */
-		if (cpu_online(cpu)) {
-			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
-			    (lpfc_used_cpu[cpu] == LPFC_VECTOR_MAP_EMPTY) &&
-			    (cpup->phys_id == phys_id)) {
-				return cpu;
-			}
-		}
-		cpup++;
-	}
-
-	/*
-	 * If we get here, we have used ALL CPUs for the specific
-	 * phys_id. Now we need to clear out lpfc_used_cpu and start
-	 * reusing CPUs.
-	 */
-
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		if (lpfc_used_cpu[cpu] == phys_id)
-			lpfc_used_cpu[cpu] = LPFC_VECTOR_MAP_EMPTY;
-	}
-
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		/* CPU must be online */
-		if (cpu_online(cpu)) {
-			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
-			    (cpup->phys_id == phys_id)) {
-				return cpu;
-			}
-		}
-		cpup++;
-	}
-	return LPFC_VECTOR_MAP_EMPTY;
-}
-
-/**
- * lpfc_sli4_set_affinity - Set affinity for HBA IRQ vectors
- * @phba:	pointer to lpfc hba data structure.
- * @vectors:	number of HBA vectors
- *
- * Affinitize MSIX IRQ vectors to CPUs. Try to equally spread vector
- * affinization across multple physical CPUs (numa nodes).
- * In addition, this routine will assign an IO channel for each CPU
- * to use when issuing I/Os.
- */
-static int
-lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
-{
-	int i, idx, saved_chann, used_chann, cpu, phys_id;
-	int max_phys_id, min_phys_id;
-	int num_io_channel, first_cpu, chan;
-	struct lpfc_vector_map_info *cpup;
 #ifdef CONFIG_X86
 	struct cpuinfo_x86 *cpuinfo;
 #endif
-	uint8_t chann[LPFC_FCP_IO_CHAN_MAX+1];
-
-	/* If there is no mapping, just return */
-	if (!phba->cfg_fcp_cpu_map)
-		return 1;
 
 	/* Init cpu_map array */
 	memset(phba->sli4_hba.cpu_map, 0xff,
 	       (sizeof(struct lpfc_vector_map_info) *
-		phba->sli4_hba.num_present_cpu));
-
-	max_phys_id = 0;
-	min_phys_id = 0xff;
-	phys_id = 0;
-	num_io_channel = 0;
-	first_cpu = LPFC_VECTOR_MAP_EMPTY;
+	       phba->sli4_hba.num_present_cpu));
 
 	/* Update CPU map with physical id and core id of each CPU */
 	cpup = phba->sli4_hba.cpu_map;
@@ -8796,184 +9142,16 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 		cpup->phys_id = 0;
 		cpup->core_id = 0;
 #endif
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3328 CPU physid %d coreid %d\n",
-				cpup->phys_id, cpup->core_id);
-
-		if (cpup->phys_id > max_phys_id)
-			max_phys_id = cpup->phys_id;
-		if (cpup->phys_id < min_phys_id)
-			min_phys_id = cpup->phys_id;
+		cpup->channel_id = index;  /* For now round robin */
+		cpup->irq = pci_irq_vector(phba->pcidev, vec);
+		vec++;
+		if (vec >= vectors)
+			vec = 0;
+		index++;
+		if (index >= phba->cfg_fcp_io_channel)
+			index = 0;
 		cpup++;
 	}
-
-	phys_id = min_phys_id;
-	/* Now associate the HBA vectors with specific CPUs */
-	for (idx = 0; idx < vectors; idx++) {
-		cpup = phba->sli4_hba.cpu_map;
-		cpu = lpfc_find_next_cpu(phba, phys_id);
-		if (cpu == LPFC_VECTOR_MAP_EMPTY) {
-
-			/* Try for all phys_id's */
-			for (i = 1; i < max_phys_id; i++) {
-				phys_id++;
-				if (phys_id > max_phys_id)
-					phys_id = min_phys_id;
-				cpu = lpfc_find_next_cpu(phba, phys_id);
-				if (cpu == LPFC_VECTOR_MAP_EMPTY)
-					continue;
-				goto found;
-			}
-
-			/* Use round robin for scheduling */
-			phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_ROUND_ROBIN;
-			chan = 0;
-			cpup = phba->sli4_hba.cpu_map;
-			for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-				cpup->channel_id = chan;
-				cpup++;
-				chan++;
-				if (chan >= phba->cfg_fcp_io_channel)
-					chan = 0;
-			}
-
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3329 Cannot set affinity:"
-					"Error mapping vector %d (%d)\n",
-					idx, vectors);
-			return 0;
-		}
-found:
-		cpup += cpu;
-		if (phba->cfg_fcp_cpu_map == LPFC_DRIVER_CPU_MAP)
-			lpfc_used_cpu[cpu] = phys_id;
-
-		/* Associate vector with selected CPU */
-		cpup->irq = pci_irq_vector(phba->pcidev, idx);
-
-		/* Associate IO channel with selected CPU */
-		cpup->channel_id = idx;
-		num_io_channel++;
-
-		if (first_cpu == LPFC_VECTOR_MAP_EMPTY)
-			first_cpu = cpu;
-
-		/* Now affinitize to the selected CPU */
-		i = irq_set_affinity_hint(pci_irq_vector(phba->pcidev, idx),
-					  get_cpu_mask(cpu));
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3330 Set Affinity: CPU %d channel %d "
-				"irq %d (%x)\n",
-				cpu, cpup->channel_id,
-				pci_irq_vector(phba->pcidev, idx), i);
-
-		/* Spread vector mapping across multple physical CPU nodes */
-		phys_id++;
-		if (phys_id > max_phys_id)
-			phys_id = min_phys_id;
-	}
-
-	/*
-	 * Finally fill in the IO channel for any remaining CPUs.
-	 * At this point, all IO channels have been assigned to a specific
-	 * MSIx vector, mapped to a specific CPU.
-	 * Base the remaining IO channel assigned, to IO channels already
-	 * assigned to other CPUs on the same phys_id.
-	 */
-	for (i = min_phys_id; i <= max_phys_id; i++) {
-		/*
-		 * If there are no io channels already mapped to
-		 * this phys_id, just round robin thru the io_channels.
-		 * Setup chann[] for round robin.
-		 */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
-			chann[idx] = idx;
-
-		saved_chann = 0;
-		used_chann = 0;
-
-		/*
-		 * First build a list of IO channels already assigned
-		 * to this phys_id before reassigning the same IO
-		 * channels to the remaining CPUs.
-		 */
-		cpup = phba->sli4_hba.cpu_map;
-		cpu = first_cpu;
-		cpup += cpu;
-		for (idx = 0; idx < phba->sli4_hba.num_present_cpu;
-		     idx++) {
-			if (cpup->phys_id == i) {
-				/*
-				 * Save any IO channels that are
-				 * already mapped to this phys_id.
-				 */
-				if (cpup->irq != LPFC_VECTOR_MAP_EMPTY) {
-					if (saved_chann <=
-					    LPFC_FCP_IO_CHAN_MAX) {
-						chann[saved_chann] =
-							cpup->channel_id;
-						saved_chann++;
-					}
-					goto out;
-				}
-
-				/* See if we are using round-robin */
-				if (saved_chann == 0)
-					saved_chann =
-						phba->cfg_fcp_io_channel;
-
-				/* Associate next IO channel with CPU */
-				cpup->channel_id = chann[used_chann];
-				num_io_channel++;
-				used_chann++;
-				if (used_chann == saved_chann)
-					used_chann = 0;
-
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"3331 Set IO_CHANN "
-						"CPU %d channel %d\n",
-						idx, cpup->channel_id);
-			}
-out:
-			cpu++;
-			if (cpu >= phba->sli4_hba.num_present_cpu) {
-				cpup = phba->sli4_hba.cpu_map;
-				cpu = 0;
-			} else {
-				cpup++;
-			}
-		}
-	}
-
-	if (phba->sli4_hba.num_online_cpu != phba->sli4_hba.num_present_cpu) {
-		cpup = phba->sli4_hba.cpu_map;
-		for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
-			if (cpup->channel_id == LPFC_VECTOR_MAP_EMPTY) {
-				cpup->channel_id = 0;
-				num_io_channel++;
-
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"3332 Assign IO_CHANN "
-						"CPU %d channel %d\n",
-						idx, cpup->channel_id);
-			}
-			cpup++;
-		}
-	}
-
-	/* Sanity check */
-	if (num_io_channel != phba->sli4_hba.num_present_cpu)
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3333 Set affinity mismatch:"
-				"%d chann != %d cpus: %d vectors\n",
-				num_io_channel, phba->sli4_hba.num_present_cpu,
-				vectors);
-
-	/* Enable using cpu affinity for scheduling */
-	phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
-	return 1;
 }
 
 
@@ -8994,11 +9172,12 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	int vectors, rc, index;
 
 	/* Set up MSI-X multi-message vectors */
-	vectors = phba->cfg_fcp_io_channel;
+	vectors = phba->io_channel_irqs;
 	if (phba->cfg_fof)
 		vectors++;
 
-	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors, PCI_IRQ_MSIX);
+	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors,
+				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
@@ -9013,19 +9192,19 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			 LPFC_SLI4_HANDLER_NAME_SZ,
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-		atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].fcp_eq_in_use, 1);
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+		atomic_set(&phba->sli4_hba.hba_eq_hdl[index].hba_eq_in_use, 1);
 		if (phba->cfg_fof && (index == (vectors - 1)))
 			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_fof_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		else
 			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_hba_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
@@ -9037,26 +9216,29 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	if (phba->cfg_fof)
 		vectors--;
 
-	if (vectors != phba->cfg_fcp_io_channel) {
+	if (vectors != phba->io_channel_irqs) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3238 Reducing IO channels to match number of "
 				"MSI-X vectors, requested %d got %d\n",
-				phba->cfg_fcp_io_channel, vectors);
-		phba->cfg_fcp_io_channel = vectors;
+				phba->io_channel_irqs, vectors);
+		if (phba->cfg_fcp_io_channel > vectors)
+			phba->cfg_fcp_io_channel = vectors;
+		if (phba->cfg_nvme_io_channel > vectors)
+			phba->cfg_nvme_io_channel = vectors;
+		if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+			phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+		else
+			phba->io_channel_irqs = phba->cfg_nvme_io_channel;
 	}
+	lpfc_cpu_affinity_check(phba, vectors);
 
-	if (!shost_use_blk_mq(lpfc_shost_from_vport(phba->pport)))
-		lpfc_sli4_set_affinity(phba, vectors);
 	return rc;
 
 cfg_fail_out:
 	/* free the irq already requested */
-	for (--index; index >= 0; index--) {
-		int irq = pci_irq_vector(phba->pcidev, index);
-
-		irq_set_affinity_hint(irq, NULL);
-		free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
-	}
+	for (--index; index >= 0; index--)
+		free_irq(pci_irq_vector(phba->pcidev, index),
+				&phba->sli4_hba.hba_eq_hdl[index]);
 
 	/* Unconfigure MSI-X capability structure */
 	pci_free_irq_vectors(phba->pcidev);
@@ -9103,14 +9285,14 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 		return rc;
 	}
 
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+	for (index = 0; index < phba->io_channel_irqs; index++) {
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
@@ -9135,7 +9317,7 @@ static uint32_t
 lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 {
 	uint32_t intr_mode = LPFC_INTR_ERROR;
-	int retval, index;
+	int retval, idx;
 
 	if (cfg_mode == 2) {
 		/* Preparation before conf_msi mbox cmd */
@@ -9166,21 +9348,23 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 		retval = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
 				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
 		if (!retval) {
+			struct lpfc_hba_eq_hdl *eqhdl;
+
 			/* Indicate initialization to INTx mode */
 			phba->intr_type = INTx;
 			intr_mode = 0;
-			for (index = 0; index < phba->cfg_fcp_io_channel;
-			     index++) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+
+			for (idx = 0; idx < phba->io_channel_irqs; idx++) {
+				eqhdl = &phba->sli4_hba.hba_eq_hdl[idx];
+				eqhdl->idx = idx;
+				eqhdl->phba = phba;
+				atomic_set(&eqhdl->hba_eq_in_use, 1);
 			}
 			if (phba->cfg_fof) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+				eqhdl = &phba->sli4_hba.hba_eq_hdl[idx];
+				eqhdl->idx = idx;
+				eqhdl->phba = phba;
+				atomic_set(&eqhdl->hba_eq_in_use, 1);
 			}
 		}
 	}
@@ -9204,15 +9388,13 @@ lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 		int index;
 
 		/* Free up MSI-X multi-message vectors */
-		for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-			int irq = pci_irq_vector(phba->pcidev, index);
-
-			irq_set_affinity_hint(irq, NULL);
-			free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
-		}
+		for (index = 0; index < phba->io_channel_irqs; index++)
+			free_irq(pci_irq_vector(phba->pcidev, index),
+					&phba->sli4_hba.hba_eq_hdl[index]);
 
 		if (phba->cfg_fof)
-			free_irq(pci_irq_vector(phba->pcidev, index), phba);
+			free_irq(pci_irq_vector(phba->pcidev, index),
+					&phba->sli4_hba.hba_eq_hdl[index]);
 	} else {
 		free_irq(phba->pcidev->irq, phba);
 	}
@@ -9274,11 +9456,24 @@ static void
 lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 {
 	int wait_time = 0;
-	int fcp_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	int nvme_xri_cmpl = 1;
+	int fcp_xri_cmpl = 1;
 	int els_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 
-	while (!fcp_xri_cmpl || !els_xri_cmpl) {
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
+		fcp_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		nvme_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+
+	while (!fcp_xri_cmpl || !els_xri_cmpl || !nvme_xri_cmpl) {
 		if (wait_time > LPFC_XRI_EXCH_BUSY_WAIT_TMO) {
+			if (!nvme_xri_cmpl)
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6100 NVME XRI exchange busy "
+						"wait time: %d seconds.\n",
+						wait_time/1000);
 			if (!fcp_xri_cmpl)
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"2877 FCP XRI exchange busy "
@@ -9295,8 +9490,14 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 			msleep(LPFC_XRI_EXCH_BUSY_WAIT_T1);
 			wait_time += LPFC_XRI_EXCH_BUSY_WAIT_T1;
 		}
-		fcp_xri_cmpl =
-			list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+			nvme_xri_cmpl = list_empty(
+				&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
+			fcp_xri_cmpl = list_empty(
+				&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+
 		els_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 	}
@@ -9510,10 +9711,31 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	sli4_params->wqsize = bf_get(cfg_wqsize, mbx_sli4_parameters);
 	sli4_params->sgl_pages_max = bf_get(cfg_sgl_page_cnt,
 					    mbx_sli4_parameters);
+	sli4_params->wqpcnt = bf_get(cfg_wqpcnt, mbx_sli4_parameters);
 	sli4_params->sgl_pp_align = bf_get(cfg_sgl_pp_align,
 					   mbx_sli4_parameters);
 	phba->sli4_hba.extents_in_use = bf_get(cfg_ext, mbx_sli4_parameters);
 	phba->sli4_hba.rpi_hdrs_in_use = bf_get(cfg_hdrr, mbx_sli4_parameters);
+	phba->nvme_support = (bf_get(cfg_nvme, mbx_sli4_parameters) &&
+			      bf_get(cfg_xib, mbx_sli4_parameters));
+
+	if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP) ||
+	    !phba->nvme_support) {
+		phba->nvme_support = 0;
+		phba->nvmet_support = 0;
+		phba->cfg_nvme_io_channel = 0;
+		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_NVME,
+				"6101 Disabling NVME support: "
+				"Not supported by firmware: %d %d\n",
+				bf_get(cfg_nvme, mbx_sli4_parameters),
+				bf_get(cfg_xib, mbx_sli4_parameters));
+
+		/* If firmware doesn't support NVME, just use SCSI support */
+		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+			return -ENODEV;
+		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
+	}
 
 	/* Make sure that sge_supp_len can be handled by the driver */
 	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
@@ -9588,14 +9810,6 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_disable_pci_dev;
 	}
 
-	/* Set up phase-1 common device driver resources */
-	error = lpfc_setup_driver_resource_phase1(phba);
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1403 Failed to set up driver resource.\n");
-		goto out_unset_pci_mem_s3;
-	}
-
 	/* Set up SLI-3 specific device driver resources */
 	error = lpfc_sli_driver_resource_setup(phba);
 	if (error) {
@@ -10171,6 +10385,21 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli4_get_iocb_cnt - Calculate the # of total IOCBs to reserve
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * returns the number of ELS/CT
+ **/
+int
+lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba)
+{
+	int max_xri = lpfc_sli4_get_els_iocb_cnt(phba);
+
+	return max_xri;
+}
+
+
+/**
  * lpfc_write_firmware - attempt to write a firmware image to the port
  * @fw: pointer to firmware image returned from request_firmware.
  * @phba: pointer to lpfc hba data structure.
@@ -10334,7 +10563,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct Scsi_Host  *shost = NULL;
 	int error;
 	uint32_t cfg_mode, intr_mode;
-	int adjusted_fcp_io_channel;
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);
@@ -10359,14 +10587,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_disable_pci_dev;
 	}
 
-	/* Set up phase-1 common device driver resources */
-	error = lpfc_setup_driver_resource_phase1(phba);
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1411 Failed to set up driver resource.\n");
-		goto out_unset_pci_mem_s4;
-	}
-
 	/* Set up SLI-4 Specific device driver resources */
 	error = lpfc_sli4_driver_resource_setup(phba);
 	if (error) {
@@ -10425,6 +10645,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 
 	/* Put device to a known state before enabling interrupt */
 	lpfc_stop_port(phba);
+
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, cfg_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
@@ -10434,11 +10655,15 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_free_sysfs_attr;
 	}
 	/* Default to single EQ for non-MSI-X */
-	if (phba->intr_type != MSIX)
-		adjusted_fcp_io_channel = 1;
-	else
-		adjusted_fcp_io_channel = phba->cfg_fcp_io_channel;
-	phba->cfg_fcp_io_channel = adjusted_fcp_io_channel;
+	if (phba->intr_type != MSIX) {
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
+			phba->cfg_fcp_io_channel = 1;
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+			phba->cfg_nvme_io_channel = 1;
+		phba->io_channel_irqs = 1;
+	}
+
+
 	/* Set up SLI-4 HBA */
 	if (lpfc_sli4_hba_setup(phba)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -10454,6 +10679,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
+	/* todo: init: register port with nvme */
+
 	/* check for firmware upgrade or downgrade */
 	if (phba->cfg_request_firmware_upgrade)
 		lpfc_sli4_request_firmware_update(phba, INT_FW_UPGRADE);
@@ -10525,8 +10752,11 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 
-	/* Perform cleanup on the physical port */
+	/* Perform ndlp cleanup on the physical port.  The nvme localport
+	 * is destroyed after to ensure all rports are io-disabled.
+	 */
 	lpfc_cleanup(vport);
+	/* todo: init: unregister port with nvme */
 
 	/*
 	 * Bring down the SLI Layer. This step disables all interrupts,
@@ -10544,6 +10774,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	 * buffers are released to their corresponding pools here.
 	 */
 	lpfc_scsi_free(phba);
+	lpfc_nvme_free(phba);
 
 	lpfc_sli4_driver_resource_unset(phba);
 
@@ -11189,7 +11420,7 @@ lpfc_sli4_oas_verify(struct lpfc_hba *phba)
 int
 lpfc_fof_queue_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
 	int rc;
 
 	rc = lpfc_eq_create(phba, phba->sli4_hba.fof_eq, LPFC_MAX_IMAX);
@@ -11208,8 +11439,11 @@ lpfc_fof_queue_setup(struct lpfc_hba *phba)
 		if (rc)
 			goto out_oas_wq;
 
-		phba->sli4_hba.oas_cq->pring = &psli->ring[LPFC_FCP_OAS_RING];
-		phba->sli4_hba.oas_ring = &psli->ring[LPFC_FCP_OAS_RING];
+		/* Bind this CQ/WQ to the NVME ring */
+		pring = phba->sli4_hba.oas_wq->pring;
+		pring->sli.sli4.wqp =
+			(void *)phba->sli4_hba.oas_wq;
+		phba->sli4_hba.oas_cq->pring = pring;
 	}
 
 	return 0;
@@ -11266,6 +11500,7 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 			goto out_error;
 
 		phba->sli4_hba.oas_wq = qdesc;
+		list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
 
 	}
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 2a4e5d2..3faf7a0 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -38,6 +38,10 @@
 #define LOG_FIP		0x00020000	/* FIP events */
 #define LOG_FCP_UNDER	0x00040000	/* FCP underruns errors */
 #define LOG_SCSI_CMD	0x00080000	/* ALL SCSI commands */
+#define LOG_NVME	0x00100000	/* NVME general events. */
+#define LOG_NVME_DISC   0x00200000      /* NVME Discovery/Connect events. */
+#define LOG_NVME_ABTS   0x00400000      /* NVME ABTS events. */
+#define LOG_NVME_IOERR  0x00800000      /* NVME IO Error events. */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index b234c50..c20dc25 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -954,7 +954,7 @@ lpfc_config_pcb_setup(struct lpfc_hba * phba)
 	pcbp->maxRing = (psli->num_rings - 1);
 
 	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+		pring = &psli->sli3_ring[i];
 
 		pring->sli.sli3.sizeCiocb =
 			phba->sli_rev == 3 ? SLI3_IOCB_CMD_SIZE :
@@ -1217,7 +1217,7 @@ lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 	mb->un.varCfgRing.recvNotify = 1;
 
 	psli = &phba->sli;
-	pring = &psli->ring[ring];
+	pring = &psli->sli3_ring[ring];
 	mb->un.varCfgRing.numMask = pring->num_mask;
 	mb->mbxCommand = MBX_CONFIG_RING;
 	mb->mbxOwner = OWN_HOST;
@@ -2434,14 +2434,25 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 	memset(mbox, 0, sizeof(*mbox));
 	reg_fcfi = &mbox->u.mqe.un.reg_fcfi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_FCFI);
-	bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi, phba->sli4_hba.hdr_rq->queue_id);
-	bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+	if (phba->nvmet_support == 0) {
+		bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi,
+		       phba->sli4_hba.hdr_rq->queue_id);
+		/* Match everything - rq_id0 */
+		bf_set(lpfc_reg_fcfi_type_match0, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_type_mask0, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_rctl_match0, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_rctl_mask0, reg_fcfi, 0);
+
+		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+
+		/* addr mode is bit wise inverted value of fcf addr_mode */
+		bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
+		       (~phba->fcf.addr_mode) & 0x3);
+	}
 	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_info_index, reg_fcfi,
 	       phba->fcf.current_rec.fcf_indx);
-	/* reg_fcf addr mode is bit wise inverted value of fcf addr_mode */
-	bf_set(lpfc_reg_fcfi_mam, reg_fcfi, (~phba->fcf.addr_mode) & 0x3);
 	if (phba->fcf.current_rec.vlan_id != LPFC_FCOE_NULL_VID) {
 		bf_set(lpfc_reg_fcfi_vv, reg_fcfi, 1);
 		bf_set(lpfc_reg_fcfi_vlan_tag, reg_fcfi,
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 3fa6533..c65a1ec 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -24,10 +24,12 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
 
-#include <scsi/scsi.h>
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -35,8 +37,9 @@
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
 
@@ -66,7 +69,7 @@ lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
  * lpfc_mem_alloc - create and allocate all PCI and memory pools
  * @phba: HBA to allocate pools for
  *
- * Description: Creates and allocates PCI pools lpfc_scsi_dma_buf_pool,
+ * Description: Creates and allocates PCI pools lpfc_sg_dma_buf_pool,
  * lpfc_mbuf_pool, lpfc_hrb_pool.  Creates and allocates kmalloc-backed mempools
  * for LPFC_MBOXQ_t and lpfc_nodelist.  Also allocates the VPI bitmask.
  *
@@ -90,21 +93,23 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 		else
 			i = SLI4_PAGE_SIZE;
 
-		phba->lpfc_scsi_dma_buf_pool =
-			pci_pool_create("lpfc_scsi_dma_buf_pool",
-				phba->pcidev,
-				phba->cfg_sg_dma_buf_size,
-				i,
-				0);
+		phba->lpfc_sg_dma_buf_pool =
+			pci_pool_create("lpfc_sg_dma_buf_pool",
+					phba->pcidev,
+					phba->cfg_sg_dma_buf_size,
+					i, 0);
+		if (!phba->lpfc_sg_dma_buf_pool)
+			goto fail;
+
 	} else {
-		phba->lpfc_scsi_dma_buf_pool =
-			pci_pool_create("lpfc_scsi_dma_buf_pool",
-				phba->pcidev, phba->cfg_sg_dma_buf_size,
-				align, 0);
-	}
+		phba->lpfc_sg_dma_buf_pool =
+			pci_pool_create("lpfc_sg_dma_buf_pool",
+					phba->pcidev, phba->cfg_sg_dma_buf_size,
+					align, 0);
 
-	if (!phba->lpfc_scsi_dma_buf_pool)
-		goto fail;
+		if (!phba->lpfc_sg_dma_buf_pool)
+			goto fail;
+	}
 
 	phba->lpfc_mbuf_pool = pci_pool_create("lpfc_mbuf_pool", phba->pcidev,
 							LPFC_BPL_SIZE,
@@ -170,12 +175,15 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
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
@@ -197,8 +205,8 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 	pci_pool_destroy(phba->lpfc_mbuf_pool);
 	phba->lpfc_mbuf_pool = NULL;
  fail_free_dma_buf_pool:
-	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
-	phba->lpfc_scsi_dma_buf_pool = NULL;
+	pci_pool_destroy(phba->lpfc_sg_dma_buf_pool);
+	phba->lpfc_sg_dma_buf_pool = NULL;
  fail:
 	return -ENOMEM;
 }
@@ -227,6 +235,9 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	if (phba->lpfc_hrb_pool)
 		pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
+	if (phba->txrdy_payload_pool)
+		pci_pool_destroy(phba->txrdy_payload_pool);
+	phba->txrdy_payload_pool = NULL;
 
 	if (phba->lpfc_hbq_pool)
 		pci_pool_destroy(phba->lpfc_hbq_pool);
@@ -258,8 +269,8 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	phba->lpfc_mbuf_pool = NULL;
 
 	/* Free DMA buffer memory pool */
-	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
-	phba->lpfc_scsi_dma_buf_pool = NULL;
+	pci_pool_destroy(phba->lpfc_sg_dma_buf_pool);
+	phba->lpfc_sg_dma_buf_pool = NULL;
 
 	/* Free Device Data memory pool */
 	if (phba->device_data_mem_pool) {
@@ -282,7 +293,7 @@ lpfc_mem_free(struct lpfc_hba *phba)
  * @phba: HBA to free memory for
  *
  * Description: Free memory from PCI and driver memory pools and also those
- * used : lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool, lpfc_hrb_pool. Frees
+ * used : lpfc_sg_dma_buf_pool, lpfc_mbuf_pool, lpfc_hrb_pool. Frees
  * kmalloc-backed mempools for LPFC_MBOXQ_t and lpfc_nodelist. Also frees
  * the VPI bitmask.
  *
@@ -458,7 +469,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 		kfree(hbqbp);
 		return NULL;
 	}
-	hbqbp->size = LPFC_BPL_SIZE;
+	hbqbp->total_size = LPFC_BPL_SIZE;
 	return hbqbp;
 }
 
@@ -518,7 +529,7 @@ lpfc_sli4_rb_alloc(struct lpfc_hba *phba)
 		kfree(dma_buf);
 		return NULL;
 	}
-	dma_buf->size = LPFC_BPL_SIZE;
+	dma_buf->total_size = LPFC_DATA_BUF_SIZE;
 	return dma_buf;
 }
 
@@ -540,7 +551,6 @@ lpfc_sli4_rb_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
 	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
 	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
 	kfree(dmab);
-	return;
 }
 
 /**
@@ -565,13 +575,13 @@ lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
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
index 56a3df4..835ea9f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -204,10 +204,11 @@ int
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(abort_list);
-	struct lpfc_sli  *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
 
+	pring = lpfc_phba_elsring(phba);
+
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
 			 "2819 Abort outstanding I/O on NPort x%x "
@@ -2104,7 +2105,7 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* flush the target */
-	lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+	lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
 			    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 
 	/* Treat like rcv logo */
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
new file mode 100644
index 0000000..2b16793
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -0,0 +1,88 @@
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
+#define LPFC_NVME_MIN_SEGS		16
+#define LPFC_NVME_DEFAULT_SEGS		66	/* 256K IOs - 64 + 2 */
+#define LPFC_NVME_MAX_SEGS		510
+#define LPFC_NVMET_MIN_POSTBUF		16
+#define LPFC_NVMET_DEFAULT_POSTBUF	1024
+#define LPFC_NVMET_MAX_POSTBUF		4096
+#define LPFC_NVME_WQSIZE		256
+
+#define LPFC_NVME_ERSP_LEN		0x20
+
+/* Declare nvme-based local and remote port definitions. */
+struct lpfc_nvme_lport {
+	struct lpfc_vport *vport;
+	struct list_head rport_list;
+	struct completion lport_unreg_done;
+	/* Add sttats counters here */
+};
+
+struct lpfc_nvme_rport {
+	struct list_head list;
+	struct lpfc_nvme_lport *lport;
+	struct nvme_fc_remote_port *remoteport;
+	struct lpfc_nodelist *ndlp;
+	struct completion rport_unreg_done;
+};
+
+struct lpfc_nvme_buf {
+	struct list_head list;
+	struct nvmefc_fcp_req *nvmeCmd;
+	struct lpfc_nvme_rport *nrport;
+
+	uint32_t timeout;
+
+	uint16_t flags;  /* TBD convert exch_busy to flags */
+#define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
+	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
+	uint16_t status;	/* From IOCB Word 7- ulpStatus */
+	uint16_t cpu;
+	uint16_t qidx;
+	uint16_t sqid;
+	uint32_t result;	/* From IOCB Word 4. */
+
+	uint32_t   seg_cnt;	/* Number of scatter-gather segments returned by
+				 * dma_map_sg.  The driver needs this for calls
+				 * to dma_unmap_sg.
+				 */
+	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
+
+	/*
+	 * data and dma_handle are the kernel virtual and bus address of the
+	 * dma-able buffer containing the fcp_cmd, fcp_rsp and a scatter
+	 * gather bde list that supports the sg_tablesize value.
+	 */
+	void *data;
+	dma_addr_t dma_handle;
+
+	struct sli4_sge *nvme_sgl;
+	dma_addr_t dma_phys_sgl;
+
+	/* cur_iocbq has phys of the dma-able buffer.
+	 * Iotag is in here
+	 */
+	struct lpfc_iocbq cur_iocbq;
+
+	wait_queue_head_t *waitq;
+	unsigned long start_time;
+};
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 54d7718..7b9ff8e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -413,7 +413,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		 * struct fcp_cmnd, struct fcp_rsp and the number of bde's
 		 * necessary to support the sg_tablesize.
 		 */
-		psb->data = pci_pool_zalloc(phba->lpfc_scsi_dma_buf_pool,
+		psb->data = pci_pool_zalloc(phba->lpfc_sg_dma_buf_pool,
 					GFP_KERNEL, &psb->dma_handle);
 		if (!psb->data) {
 			kfree(psb);
@@ -424,8 +424,8 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		/* Allocate iotag for psb->cur_iocbq. */
 		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
 		if (iotag == 0) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-					psb->data, psb->dma_handle);
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+				      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
@@ -522,6 +522,8 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 	struct lpfc_scsi_buf *psb, *next_psb;
 	unsigned long iflag = 0;
 
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return;
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
 	list_for_each_entry_safe(psb, next_psb,
@@ -554,8 +556,10 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 	int i;
 	struct lpfc_nodelist *ndlp;
 	int rrq_empty = 0;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring = phba->sli4_hba.els_wq->pring;
 
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return;
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
 	list_for_each_entry_safe(psb, next_psb,
@@ -819,7 +823,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		 * for the struct fcp_cmnd, struct fcp_rsp and the number
 		 * of bde's necessary to support the sg_tablesize.
 		 */
-		psb->data = pci_pool_zalloc(phba->lpfc_scsi_dma_buf_pool,
+		psb->data = pci_pool_zalloc(phba->lpfc_sg_dma_buf_pool,
 						GFP_KERNEL, &psb->dma_handle);
 		if (!psb->data) {
 			kfree(psb);
@@ -832,7 +836,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		 */
 		if (phba->cfg_enable_bg  && (((unsigned long)(psb->data) &
 		    (unsigned long)(SLI4_PAGE_SIZE - 1)) != 0)) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
 				      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
@@ -841,8 +845,8 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 
 		lxri = lpfc_sli4_next_xritag(phba);
 		if (lxri == NO_XRI) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-			      psb->data, psb->dma_handle);
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+				      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
@@ -850,8 +854,8 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		/* Allocate iotag for psb->cur_iocbq. */
 		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
 		if (iotag == 0) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-				psb->data, psb->dma_handle);
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+				      psb->data, psb->dma_handle);
 			kfree(psb);
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 					"3368 Failed to allocate IOTAG for"
@@ -920,7 +924,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		phba->sli4_hba.scsi_xri_cnt++;
 		spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_BG,
+	lpfc_printf_log(phba, KERN_INFO, LOG_BG | LOG_FCP,
 			"3021 Allocate %d out of %d requested new SCSI "
 			"buffers\n", bcnt, num_to_alloc);
 
@@ -3925,6 +3929,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct Scsi_Host *shost;
 	uint32_t logit = LOG_FCP;
 
+	phba->fc4ScsiIoCmpls++;
+
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
 	if (!cmd)
@@ -4242,19 +4248,19 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 						vport->cfg_first_burst_size;
 			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
-			phba->fc4OutputRequests++;
+			phba->fc4ScsiOutputRequests++;
 		} else {
 			iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			fcp_cmnd->fcpCntl3 = READ_DATA;
-			phba->fc4InputRequests++;
+			phba->fc4ScsiInputRequests++;
 		}
 	} else {
 		iocb_cmd->ulpCommand = CMD_FCP_ICMND64_CR;
 		iocb_cmd->un.fcpi.fcpi_parm = 0;
 		iocb_cmd->ulpPU = 0;
 		fcp_cmnd->fcpCntl3 = 0;
-		phba->fc4ControlRequests++;
+		phba->fc4ScsiControlRequests++;
 	}
 	if (phba->sli_rev == 3 &&
 	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
@@ -4468,7 +4474,7 @@ static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
 	unsigned long  poll_tmo_expires =
 		(jiffies + msecs_to_jiffies(phba->cfg_poll_tmo));
 
-	if (!list_empty(&phba->sli.ring[LPFC_FCP_RING].txcmplq))
+	if (!list_empty(&phba->sli.sli3_ring[LPFC_FCP_RING].txcmplq))
 		mod_timer(&phba->fcp_poll_timer,
 			  poll_tmo_expires);
 }
@@ -4498,7 +4504,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
@@ -4562,7 +4568,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
 
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_MISC,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_ERROR,
 				 "0707 driver's buffer pool is empty, "
 				 "IO busied\n");
 		goto out_host_busy;
@@ -4637,7 +4643,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
@@ -4682,7 +4688,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS, status = 0;
 	struct lpfc_sli_ring *pring_s4;
-	int ring_number, ret_val;
+	int ret_val;
 	unsigned long flags, iflags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
@@ -4770,7 +4776,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	icmd->ulpClass = cmd->ulpClass;
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocb->fcp_wqidx = iocb->fcp_wqidx;
+	abtsiocb->hba_wqidx = iocb->hba_wqidx;
 	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
 	if (iocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocb->iocb_flag |= LPFC_IO_FOF;
@@ -4783,8 +4789,11 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number = MAX_SLI3_CONFIGURED_RINGS + iocb->fcp_wqidx;
-		pring_s4 = &phba->sli.ring[ring_number];
+		pring_s4 = lpfc_sli4_calc_ring(phba, iocb);
+		if (pring_s4 == NULL) {
+			ret = FAILED;
+			goto out_unlock;
+		}
 		/* Note: both hbalock and ring_lock must be set here */
 		spin_lock_irqsave(&pring_s4->ring_lock, iflags);
 		ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -4806,7 +4815,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 wait_for_cmpl:
 	lpfc_cmd->waitq = &waitq;
@@ -5106,7 +5115,7 @@ lpfc_reset_flush_io_context(struct lpfc_vport *vport, uint16_t tgt_id,
 	cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
 	if (cnt)
 		lpfc_sli_abort_taskmgmt(vport,
-					&phba->sli.ring[phba->sli.fcp_ring],
+					&phba->sli.sli3_ring[LPFC_FCP_RING],
 					tgt_id, lun_id, context);
 	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
 	while (time_after(later, jiffies) && cnt) {
@@ -5535,7 +5544,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
@@ -5899,6 +5908,48 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 	return false;
 }
 
+static int
+lpfc_no_command(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
+{
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
+
+static int
+lpfc_no_handler(struct scsi_cmnd *cmnd)
+{
+	return FAILED;
+}
+
+static int
+lpfc_no_slave(struct scsi_device *sdev)
+{
+	return -ENODEV;
+}
+
+struct scsi_host_template lpfc_template_nvme = {
+	.module			= THIS_MODULE,
+	.name			= LPFC_DRIVER_NAME,
+	.proc_name		= LPFC_DRIVER_NAME,
+	.info			= lpfc_info,
+	.queuecommand		= lpfc_no_command,
+	.eh_abort_handler	= lpfc_no_handler,
+	.eh_device_reset_handler = lpfc_no_handler,
+	.eh_target_reset_handler = lpfc_no_handler,
+	.eh_bus_reset_handler	= lpfc_no_handler,
+	.eh_host_reset_handler  = lpfc_no_handler,
+	.slave_alloc		= lpfc_no_slave,
+	.slave_configure	= lpfc_no_slave,
+	.scan_finished		= lpfc_scan_finished,
+	.this_id		= -1,
+	.sg_tablesize		= 1,
+	.cmd_per_lun		= 1,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= lpfc_hba_attrs,
+	.max_sectors		= 0xFFFF,
+	.vendor_id		= LPFC_NL_VENDOR_ID,
+	.track_queue_depth	= 0,
+};
+
 struct scsi_host_template lpfc_template_s3 = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 4d70622..def0c0a5 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -135,6 +135,8 @@ struct lpfc_scsi_buf {
 
 	uint32_t timeout;
 
+	uint16_t flags;  /* TBD convert exch_busy to flags */
+#define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
 	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
@@ -164,6 +166,8 @@ struct lpfc_scsi_buf {
 	 * Iotag is in here
 	 */
 	struct lpfc_iocbq cur_iocbq;
+	uint16_t cpu;
+
 	wait_queue_head_t *waitq;
 	unsigned long start_time;
 
@@ -186,5 +190,7 @@ struct lpfc_scsi_buf {
 #define NO_MORE_OAS_LUN		-1
 #define NOT_OAS_ENABLED_LUN	NO_MORE_OAS_LUN
 
+#define TXRDY_PAYLOAD_LEN	12
+
 int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 				  struct lpfc_scsi_buf *lpfc_cmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6a00b3a..557f757 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -34,14 +34,17 @@
 #include <scsi/fc/fc_fs.h>
 #include <linux/aer.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_compat.h"
@@ -67,14 +70,17 @@ static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
 							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
-static int lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *, struct lpfc_queue *,
+static int lpfc_sli4_fp_handle_cqe(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_cqe *);
-static int lpfc_sli4_post_els_sgl_list(struct lpfc_hba *, struct list_head *,
+static int lpfc_sli4_post_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
 static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *, struct lpfc_eqe *,
 			uint32_t);
 static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
 static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
+static int lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba,
+				   struct lpfc_sli_ring *pring,
+				   struct lpfc_iocbq *cmdiocb);
 
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
@@ -456,7 +462,7 @@ lpfc_sli4_cq_release(struct lpfc_queue *q, bool arm)
  * on @q then this function will return -ENOMEM.
  * The caller is expected to hold the hbalock when calling this routine.
  **/
-static int
+int
 lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 		 struct lpfc_rqe *hrqe, struct lpfc_rqe *drqe)
 {
@@ -602,7 +608,7 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  *
  * Returns sglq ponter = success, NULL = Failure.
  **/
-static struct lpfc_sglq *
+struct lpfc_sglq *
 __lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
 {
 	struct lpfc_sglq *sglq;
@@ -902,7 +908,7 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * __lpfc_sli_get_sglq - Allocates an iocb object from sgl pool
+ * __lpfc_sli_get_els_sglq - Allocates an iocb object from sgl pool
  * @phba: Pointer to HBA context object.
  * @piocb: Pointer to the iocbq.
  *
@@ -912,9 +918,9 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
  * allocated sglq object else it returns NULL.
  **/
 static struct lpfc_sglq *
-__lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
+__lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 {
-	struct list_head *lpfc_sgl_list = &phba->sli4_hba.lpfc_sgl_list;
+	struct list_head *lpfc_els_sgl_list = &phba->sli4_hba.lpfc_els_sgl_list;
 	struct lpfc_sglq *sglq = NULL;
 	struct lpfc_sglq *start_sglq = NULL;
 	struct lpfc_scsi_buf *lpfc_cmd;
@@ -938,18 +944,21 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 		ndlp = piocbq->context1;
 	}
 
-	list_remove_head(lpfc_sgl_list, sglq, struct lpfc_sglq, list);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_remove_head(lpfc_els_sgl_list, sglq, struct lpfc_sglq, list);
 	start_sglq = sglq;
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
-			list_add_tail(&sglq->list, lpfc_sgl_list);
+			list_add_tail(&sglq->list, lpfc_els_sgl_list);
 			sglq = NULL;
-			list_remove_head(lpfc_sgl_list, sglq,
+			list_remove_head(lpfc_els_sgl_list, sglq,
 						struct lpfc_sglq, list);
 			if (sglq == start_sglq) {
 				sglq = NULL;
@@ -962,6 +971,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 		phba->sli4_hba.lpfc_sglq_active_list[sglq->sli4_lxritag] = sglq;
 		sglq->state = SGL_ALLOCATED;
 	}
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	return sglq;
 }
 
@@ -1002,7 +1012,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  * this IO was aborted then the sglq entry it put on the
  * lpfc_abts_els_sgl_list until the CQ_ABORTED_XRI is received. If the
  * IO has good status or fails for any other reason then the sglq
- * entry is added to the free list (lpfc_sgl_list).
+ * entry is added to the free list (lpfc_els_sgl_list).
  **/
 static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
@@ -1010,7 +1020,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	struct lpfc_sglq *sglq;
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 
 	lockdep_assert_held(&phba->hbalock);
 
@@ -1021,21 +1031,24 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 
 
 	if (sglq)  {
+		pring = phba->sli4_hba.els_wq->pring;
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 			(sglq->state != SGL_XRI_ABORTED)) {
-			spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock,
-					iflag);
+			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
+					  iflag);
 			list_add(&sglq->list,
-				&phba->sli4_hba.lpfc_abts_els_sgl_list);
+				 &phba->sli4_hba.lpfc_abts_els_sgl_list);
 			spin_unlock_irqrestore(
-				&phba->sli4_hba.abts_sgl_list_lock, iflag);
+				&phba->sli4_hba.sgl_list_lock, iflag);
 		} else {
-			spin_lock_irqsave(&pring->ring_lock, iflag);
+			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
+					  iflag);
 			sglq->state = SGL_FREED;
 			sglq->ndlp = NULL;
 			list_add_tail(&sglq->list,
-				&phba->sli4_hba.lpfc_sgl_list);
-			spin_unlock_irqrestore(&pring->ring_lock, iflag);
+				      &phba->sli4_hba.lpfc_els_sgl_list);
+			spin_unlock_irqrestore(
+				&phba->sli4_hba.sgl_list_lock, iflag);
 
 			/* Check if TXQ queue needs to be serviced */
 			if (!list_empty(&pring->txq))
@@ -1043,13 +1056,13 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 		}
 	}
 
-
 	/*
 	 * Clean all volatile data fields, preserve iotag and node struct.
 	 */
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
 	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
+	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVME_LS);
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
@@ -1639,7 +1652,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 
 	if (lpfc_is_link_up(phba) &&
 	    (!list_empty(&pring->txq)) &&
-	    (pring->ringno != phba->sli.fcp_ring ||
+	    (pring->ringno != LPFC_FCP_RING ||
 	     phba->sli.sli_flag & LPFC_PROCESS_LA)) {
 
 		while ((iocb = lpfc_sli_next_iocb_slot(phba, pring)) &&
@@ -1718,7 +1731,6 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 	struct hbq_dmabuf *hbq_buf;
 	unsigned long flags;
 	int i, hbq_count;
-	uint32_t hbqno;
 
 	hbq_count = lpfc_sli_hbq_count();
 	/* Return all memory used by all HBQs */
@@ -1732,24 +1744,6 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
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
@@ -1802,7 +1796,7 @@ lpfc_sli_hbq_to_firmware_s3(struct lpfc_hba *phba, uint32_t hbqno,
 
 		hbqe->bde.addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
 		hbqe->bde.addrLow  = le32_to_cpu(putPaddrLow(physaddr));
-		hbqe->bde.tus.f.bdeSize = hbq_buf->size;
+		hbqe->bde.tus.f.bdeSize = hbq_buf->total_size;
 		hbqe->bde.tus.f.bdeFlags = 0;
 		hbqe->bde.tus.w = le32_to_cpu(hbqe->bde.tus.w);
 		hbqe->buffer_tag = le32_to_cpu(hbq_buf->tag);
@@ -1834,17 +1828,23 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 	int rc;
 	struct lpfc_rqe hrqe;
 	struct lpfc_rqe drqe;
+	struct lpfc_queue *hrq;
+	struct lpfc_queue *drq;
+
+	if (hbqno != LPFC_ELS_HBQ)
+		return 1;
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
@@ -1861,22 +1861,9 @@ static struct lpfc_hbq_init lpfc_els_hbq = {
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
@@ -2713,7 +2700,7 @@ static struct lpfc_iocbq *
 lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			     struct lpfc_sli_ring *pring, uint16_t iotag)
 {
-	struct lpfc_iocbq *cmd_iocb;
+	struct lpfc_iocbq *cmd_iocb = NULL;
 
 	lockdep_assert_held(&phba->hbalock);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
@@ -2727,8 +2714,10 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"0372 iotag x%x is out of range: max iotag (x%x)\n",
-			iotag, phba->sli.last_iotag);
+			"0372 iotag x%x lookup error: max iotag (x%x) "
+			"iocb_flag x%x\n",
+			iotag, phba->sli.last_iotag,
+			cmd_iocb ? cmd_iocb->iocb_flag : 0xffff);
 	return NULL;
 }
 
@@ -3598,6 +3587,33 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
+ * lpfc_sli_abort_wqe_ring - Abort all iocbs in the ring
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function aborts all iocbs in the given ring and frees all the iocb
+ * objects in txq. This function issues an abort iocb for all the iocb commands
+ * in txcmplq. The iocbs in the txcmplq is not guaranteed to complete before
+ * the return of this function. The caller is not required to hold any locks.
+ **/
+void
+lpfc_sli_abort_wqe_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
+{
+	LIST_HEAD(completions);
+	struct lpfc_iocbq *iocb, *next_iocb;
+
+	if (pring->ringno == LPFC_ELS_RING)
+		lpfc_fabric_abort_hba(phba);
+
+	spin_lock_irq(&phba->hbalock);
+	/* Next issue ABTS for everything on the txcmplq */
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+		lpfc_sli4_abort_nvme_io(phba, pring, iocb);
+	spin_unlock_irq(&phba->hbalock);
+}
+
+
+/**
  * lpfc_sli_abort_fcp_rings - Abort all iocbs in all FCP rings
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -3617,15 +3633,40 @@ lpfc_sli_abort_fcp_rings(struct lpfc_hba *phba)
 	/* Look on all the FCP Rings for the iotag */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
-			pring = &psli->ring[i + MAX_SLI3_CONFIGURED_RINGS];
+			pring = phba->sli4_hba.fcp_wq[i]->pring;
 			lpfc_sli_abort_iocb_ring(phba, pring);
 		}
 	} else {
-		pring = &psli->ring[psli->fcp_ring];
+		pring = &psli->sli3_ring[LPFC_FCP_RING];
 		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
 }
 
+/**
+ * lpfc_sli_abort_nvme_rings - Abort all wqes in all NVME rings
+ * @phba: Pointer to HBA context object.
+ *
+ * This function aborts all wqes in NVME rings. This function issues an
+ * abort wqe for all the outstanding IO commands in txcmplq. The iocbs in
+ * the txcmplq is not guaranteed to complete before the return of this
+ * function. The caller is not required to hold any locks.
+ **/
+void
+lpfc_sli_abort_nvme_rings(struct lpfc_hba *phba)
+{
+	struct lpfc_sli_ring  *pring;
+	uint32_t i;
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return;
+
+	/* Abort all IO on each NVME ring. */
+	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		pring = phba->sli4_hba.nvme_wq[i]->pring;
+		lpfc_sli_abort_wqe_ring(phba, pring);
+	}
+}
+
 
 /**
  * lpfc_sli_flush_fcp_rings - flush all iocbs in the fcp ring
@@ -3654,7 +3695,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 	/* Look on all the FCP Rings for the iotag */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
-			pring = &psli->ring[i + MAX_SLI3_CONFIGURED_RINGS];
+			pring = phba->sli4_hba.fcp_wq[i]->pring;
 
 			spin_lock_irq(&pring->ring_lock);
 			/* Retrieve everything on txq */
@@ -3675,7 +3716,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 					      IOERR_SLI_DOWN);
 		}
 	} else {
-		pring = &psli->ring[psli->fcp_ring];
+		pring = &psli->sli3_ring[LPFC_FCP_RING];
 
 		spin_lock_irq(&phba->hbalock);
 		/* Retrieve everything on txq */
@@ -3696,6 +3737,51 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli_flush_nvme_rings - flush all wqes in the nvme rings
+ * @phba: Pointer to HBA context object.
+ *
+ * This function flushes all wqes in the nvme rings and frees all resources
+ * in the txcmplq. This function does not issue abort wqes for the IO
+ * commands in txcmplq, they will just be returned with
+ * IOERR_SLI_DOWN. This function is invoked with EEH when device's PCI
+ * slot has been permanently disabled.
+ **/
+void
+lpfc_sli_flush_nvme_rings(struct lpfc_hba *phba)
+{
+	LIST_HEAD(txcmplq);
+	struct lpfc_sli_ring  *pring;
+	uint32_t i;
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return;
+
+	/* Hint to other driver operations that a flush is in progress. */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag |= HBA_NVME_IOQ_FLUSH;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Cycle through all NVME rings and complete each IO with
+	 * a local driver reason code.  This is a flush so no
+	 * abort exchange to FW.
+	 */
+	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		pring = phba->sli4_hba.nvme_wq[i]->pring;
+
+		/* Retrieve everything on the txcmplq */
+		spin_lock_irq(&pring->ring_lock);
+		list_splice_init(&pring->txcmplq, &txcmplq);
+		pring->txcmplq_cnt = 0;
+		spin_unlock_irq(&pring->ring_lock);
+
+		/* Flush the txcmpq &&&PAE */
+		lpfc_sli_cancel_iocbs(phba, &txcmplq,
+				      IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_DOWN);
+	}
+}
+
+/**
  * lpfc_sli_brdready_s3 - Check for sli3 host ready status
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.
@@ -4069,7 +4155,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 
 	/* Initialize relevant SLI info */
 	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+		pring = &psli->sli3_ring[i];
 		pring->flag = 0;
 		pring->sli.sli3.rspidx = 0;
 		pring->sli.sli3.next_cmdidx  = 0;
@@ -4498,10 +4584,11 @@ static int
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
 
@@ -5107,27 +5194,31 @@ lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
 static void
 lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 {
-	int fcp_eqidx;
+	int qidx;
 
 	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
 	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	fcp_eqidx = 0;
-	if (phba->sli4_hba.fcp_cq) {
-		do {
-			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[fcp_eqidx],
-					     LPFC_QUEUE_REARM);
-		} while (++fcp_eqidx < phba->cfg_fcp_io_channel);
-	}
+	if (phba->sli4_hba.nvmels_cq)
+		lpfc_sli4_cq_release(phba->sli4_hba.nvmels_cq,
+						LPFC_QUEUE_REARM);
+
+	if (phba->sli4_hba.fcp_cq)
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[qidx],
+						LPFC_QUEUE_REARM);
+
+	if (phba->sli4_hba.nvme_cq)
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			lpfc_sli4_cq_release(phba->sli4_hba.nvme_cq[qidx],
+						LPFC_QUEUE_REARM);
 
 	if (phba->cfg_fof)
 		lpfc_sli4_cq_release(phba->sli4_hba.oas_cq, LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.hba_eq) {
-		for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-		     fcp_eqidx++)
-			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[fcp_eqidx],
-					     LPFC_QUEUE_REARM);
-	}
+	if (phba->sli4_hba.hba_eq)
+		for (qidx = 0; qidx < phba->io_channel_irqs; qidx++)
+			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[qidx],
+						LPFC_QUEUE_REARM);
 
 	if (phba->cfg_fof)
 		lpfc_sli4_eq_release(phba->sli4_hba.fof_eq, LPFC_QUEUE_REARM);
@@ -5560,9 +5651,13 @@ lpfc_sli4_alloc_extent(struct lpfc_hba *phba, uint16_t type)
 		rsrc_blks->rsrc_size = rsrc_size;
 		list_add_tail(&rsrc_blks->list, ext_blk_list);
 		rsrc_start = rsrc_id;
-		if ((type == LPFC_RSC_TYPE_FCOE_XRI) && (j == 0))
+		if ((type == LPFC_RSC_TYPE_FCOE_XRI) && (j == 0)) {
 			phba->sli4_hba.scsi_xri_start = rsrc_start +
-				lpfc_sli4_get_els_iocb_cnt(phba);
+				lpfc_sli4_get_iocb_cnt(phba);
+			phba->sli4_hba.nvme_xri_start =
+				phba->sli4_hba.scsi_xri_start +
+				phba->sli4_hba.scsi_xri_max;
+		}
 
 		while (rsrc_id < (rsrc_start + rsrc_size)) {
 			ids[j] = rsrc_id;
@@ -5578,6 +5673,8 @@ lpfc_sli4_alloc_extent(struct lpfc_hba *phba, uint16_t type)
 	return rc;
 }
 
+
+
 /**
  * lpfc_sli4_dealloc_extent - Deallocate an SLI4 resource extent.
  * @phba: Pointer to HBA context object.
@@ -6149,42 +6246,45 @@ lpfc_sli4_get_allocated_extnts(struct lpfc_hba *phba, uint16_t type,
 }
 
 /**
- * lpfc_sli4_repost_els_sgl_list - Repsot the els buffers sgl pages as block
+ * lpfc_sli4_repost_sgl_list - Repsot the buffers sgl pages as block
  * @phba: pointer to lpfc hba data structure.
+ * @pring: Pointer to driver SLI ring object.
+ * @sgl_list: linked link of sgl buffers to post
+ * @cnt: number of linked list buffers
  *
- * This routine walks the list of els buffers that have been allocated and
+ * This routine walks the list of buffers that have been allocated and
  * repost them to the port by using SGL block post. This is needed after a
  * pci_function_reset/warm_start or start. It attempts to construct blocks
- * of els buffer sgls which contains contiguous xris and uses the non-embedded
- * SGL block post mailbox commands to post them to the port. For single els
+ * of buffer sgls which contains contiguous xris and uses the non-embedded
+ * SGL block post mailbox commands to post them to the port. For single
  * buffer sgl with non-contiguous xri, if any, it shall use embedded SGL post
  * mailbox command for posting.
  *
  * Returns: 0 = success, non-zero failure.
  **/
 static int
-lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
+lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
+			  struct list_head *sgl_list, int cnt)
 {
 	struct lpfc_sglq *sglq_entry = NULL;
 	struct lpfc_sglq *sglq_entry_next = NULL;
 	struct lpfc_sglq *sglq_entry_first = NULL;
-	int status, total_cnt, post_cnt = 0, num_posted = 0, block_cnt = 0;
+	int status, total_cnt;
+	int post_cnt = 0, num_posted = 0, block_cnt = 0;
 	int last_xritag = NO_XRI;
-	struct lpfc_sli_ring *pring;
 	LIST_HEAD(prep_sgl_list);
 	LIST_HEAD(blck_sgl_list);
 	LIST_HEAD(allc_sgl_list);
 	LIST_HEAD(post_sgl_list);
 	LIST_HEAD(free_sgl_list);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
 	spin_lock_irq(&phba->hbalock);
-	spin_lock(&pring->ring_lock);
-	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &allc_sgl_list);
-	spin_unlock(&pring->ring_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_splice_init(sgl_list, &allc_sgl_list);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irq(&phba->hbalock);
 
-	total_cnt = phba->sli4_hba.els_xri_cnt;
+	total_cnt = cnt;
 	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
 				 &allc_sgl_list, list) {
 		list_del_init(&sglq_entry->list);
@@ -6213,8 +6313,8 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 		/* keep track of last sgl's xritag */
 		last_xritag = sglq_entry->sli4_xritag;
 
-		/* end of repost sgl list condition for els buffers */
-		if (num_posted == phba->sli4_hba.els_xri_cnt) {
+		/* end of repost sgl list condition for buffers */
+		if (num_posted == total_cnt) {
 			if (post_cnt == 0) {
 				list_splice_init(&prep_sgl_list,
 						 &blck_sgl_list);
@@ -6231,7 +6331,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 					/* Failure, put sgl to free list */
 					lpfc_printf_log(phba, KERN_WARNING,
 						LOG_SLI,
-						"3159 Failed to post els "
+						"3159 Failed to post "
 						"sgl, xritag:x%x\n",
 						sglq_entry->sli4_xritag);
 					list_add_tail(&sglq_entry->list,
@@ -6245,9 +6345,9 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 		if (post_cnt == 0)
 			continue;
 
-		/* post the els buffer list sgls as a block */
-		status = lpfc_sli4_post_els_sgl_list(phba, &blck_sgl_list,
-						     post_cnt);
+		/* post the buffer list sgls as a block */
+		status = lpfc_sli4_post_sgl_list(phba, &blck_sgl_list,
+						 post_cnt);
 
 		if (!status) {
 			/* success, put sgl list to posted sgl list */
@@ -6258,7 +6358,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 							    struct lpfc_sglq,
 							    list);
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"3160 Failed to post els sgl-list, "
+					"3160 Failed to post sgl-list, "
 					"xritag:x%x-x%x\n",
 					sglq_entry_first->sli4_xritag,
 					(sglq_entry_first->sli4_xritag +
@@ -6271,29 +6371,28 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 		if (block_cnt == 0)
 			last_xritag = NO_XRI;
 
-		/* reset els sgl post count for next round of posting */
+		/* reset sgl post count for next round of posting */
 		post_cnt = 0;
 	}
-	/* update the number of XRIs posted for ELS */
-	phba->sli4_hba.els_xri_cnt = total_cnt;
 
-	/* free the els sgls failed to post */
+	/* free the sgls failed to post */
 	lpfc_free_sgl_list(phba, &free_sgl_list);
 
-	/* push els sgls posted to the availble list */
+	/* push sgls posted to the available list */
 	if (!list_empty(&post_sgl_list)) {
 		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&post_sgl_list,
-				 &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&pring->ring_lock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&post_sgl_list, sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irq(&phba->hbalock);
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"3161 Failure to post els sgl to port.\n");
+				"3161 Failure to post sgl to port.\n");
 		return -EIO;
 	}
-	return 0;
+
+	/* return the number of XRIs actually posted */
+	return total_cnt;
 }
 
 void
@@ -6615,35 +6714,78 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
 	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
 
-	/* update host els and scsi xri-sgl sizes and mappings */
-	rc = lpfc_sli4_xri_sgl_update(phba);
+	/* Create all the SLI4 queues */
+	rc = lpfc_sli4_queue_create(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3089 Failed to allocate queues\n");
+		rc = -ENODEV;
+		goto out_free_mbox;
+	}
+	/* Set up all the queues to the device */
+	rc = lpfc_sli4_queue_setup(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0381 Error %d during queue setup.\n ", rc);
+		goto out_stop_timers;
+	}
+	/* Initialize the driver internal SLI layer lists. */
+	lpfc_sli4_setup(phba);
+	lpfc_sli4_queue_init(phba);
+
+	/* update host els xri-sgl sizes and mappings */
+	rc = lpfc_sli4_els_sgl_update(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"1400 Failed to update xri-sgl size and "
 				"mapping: %d\n", rc);
-		goto out_free_mbox;
+		goto out_destroy_queue;
 	}
 
 	/* register the els sgl pool to the port */
-	rc = lpfc_sli4_repost_els_sgl_list(phba);
-	if (unlikely(rc)) {
+	rc = lpfc_sli4_repost_sgl_list(phba, &phba->sli4_hba.lpfc_els_sgl_list,
+				       phba->sli4_hba.els_xri_cnt);
+	if (unlikely(rc < 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"0582 Error %d during els sgl post "
 				"operation\n", rc);
 		rc = -ENODEV;
-		goto out_free_mbox;
+		goto out_destroy_queue;
 	}
+	phba->sli4_hba.els_xri_cnt = rc;
 
-	/* register the allocated scsi sgl pool to the port */
-	rc = lpfc_sli4_repost_scsi_sgl_list(phba);
-	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"0383 Error %d during scsi sgl post "
-				"operation\n", rc);
-		/* Some Scsi buffers were moved to the abort scsi list */
-		/* A pci function reset will repost them */
-		rc = -ENODEV;
-		goto out_free_mbox;
+	if (phba->nvmet_support == 0) {
+		/* update host scsi xri-sgl sizes and mappings */
+		rc = lpfc_sli4_scsi_sgl_update(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"6309 Failed to update scsi-sgl size "
+					"and mapping: %d\n", rc);
+			goto out_destroy_queue;
+		}
+
+		/* update host nvme xri-sgl sizes and mappings */
+		rc = lpfc_sli4_nvme_sgl_update(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"6082 Failed to update nvme-sgl size "
+					"and mapping: %d\n", rc);
+			goto out_destroy_queue;
+		}
+	}
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		/* register the allocated scsi sgl pool to the port */
+		rc = lpfc_sli4_repost_scsi_sgl_list(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"0383 Error %d during scsi sgl post "
+					"operation\n", rc);
+			/* Some Scsi buffers were moved to abort scsi list */
+			/* A pci function reset will repost them */
+			rc = -ENODEV;
+			goto out_destroy_queue;
+		}
 	}
 
 	/* Post the rpi header region to the device. */
@@ -6653,24 +6795,26 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_free_mbox;
+		goto out_destroy_queue;
 	}
 	lpfc_sli4_node_prep(phba);
 
-	/* Create all the SLI4 queues */
-	rc = lpfc_sli4_queue_create(phba);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3089 Failed to allocate queues\n");
-		rc = -ENODEV;
-		goto out_stop_timers;
-	}
-	/* Set up all the queues to the device */
-	rc = lpfc_sli4_queue_setup(phba);
-	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"0381 Error %d during queue setup.\n ", rc);
-		goto out_destroy_queue;
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		if (phba->nvmet_support == 0) {
+			/*
+			 * The FC Port needs to register FCFI (index 0)
+			 */
+			lpfc_reg_fcfi(phba, mboxq);
+			mboxq->vport = phba->pport;
+			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+			if (rc != MBX_SUCCESS)
+				goto out_unset_queue;
+			rc = 0;
+			phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi,
+						&mboxq->u.mqe.un.reg_fcfi);
+		}
+		/* Check if the port is configured to be disabled */
+		lpfc_sli_read_link_ste(phba);
 	}
 
 	/* Arm the CQs and then EQs on device */
@@ -6724,23 +6868,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		rc = 0;
 	}
 
-	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		/*
-		 * The FC Port needs to register FCFI (index 0)
-		 */
-		lpfc_reg_fcfi(phba, mboxq);
-		mboxq->vport = phba->pport;
-		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-		if (rc != MBX_SUCCESS)
-			goto out_unset_queue;
-		rc = 0;
-		phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi,
-					&mboxq->u.mqe.un.reg_fcfi);
-
-		/* Check if the port is configured to be disabled */
-		lpfc_sli_read_link_ste(phba);
-	}
-
 	/*
 	 * The port is ready, set the host's link state to LINK_DOWN
 	 * in preparation for link interrupts.
@@ -6877,7 +7004,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 	/* Find the eq associated with the mcq */
 
 	if (phba->sli4_hba.hba_eq)
-		for (eqidx = 0; eqidx < phba->cfg_fcp_io_channel; eqidx++)
+		for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++)
 			if (phba->sli4_hba.hba_eq[eqidx]->queue_id ==
 			    phba->sli4_hba.mbx_cq->assoc_qid) {
 				fpeq = phba->sli4_hba.hba_eq[eqidx];
@@ -7236,16 +7363,15 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 				= MAILBOX_HBA_EXT_OFFSET;
 
 		/* Copy the mailbox extension data */
-		if (pmbox->in_ext_byte_len && pmbox->context2) {
+		if (pmbox->in_ext_byte_len && pmbox->context2)
 			lpfc_memcpy_to_slim(phba->MBslimaddr +
 				MAILBOX_HBA_EXT_OFFSET,
 				pmbox->context2, pmbox->in_ext_byte_len);
 
-		}
-		if (mbx->mbxCommand == MBX_CONFIG_PORT) {
+		if (mbx->mbxCommand == MBX_CONFIG_PORT)
 			/* copy command data into host mbox for cmpl */
-			lpfc_sli_pcimem_bcopy(mbx, phba->mbox, MAILBOX_CMD_SIZE);
-		}
+			lpfc_sli_pcimem_bcopy(mbx, phba->mbox,
+					      MAILBOX_CMD_SIZE);
 
 		/* First copy mbox command data to HBA SLIM, skip past first
 		   word */
@@ -7259,10 +7385,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		writel(ldata, to_slim);
 		readl(to_slim); /* flush */
 
-		if (mbx->mbxCommand == MBX_CONFIG_PORT) {
+		if (mbx->mbxCommand == MBX_CONFIG_PORT)
 			/* switch over to host mailbox */
 			psli->sli_flag |= LPFC_SLI_ACTIVE;
-		}
 	}
 
 	wmb();
@@ -8053,7 +8178,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 {
 	struct lpfc_iocbq *nextiocb;
 	IOCB_t *iocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
+	struct lpfc_sli_ring *pring = &phba->sli.sli3_ring[ring_number];
 
 	lockdep_assert_held(&phba->hbalock);
 
@@ -8127,7 +8252,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 	 * For FCP commands, we must be in a state where we can process link
 	 * attention events.
 	 */
-	} else if (unlikely(pring->ringno == phba->sli.fcp_ring &&
+	} else if (unlikely(pring->ringno == LPFC_FCP_RING &&
 			    !(phba->sli.sli_flag & LPFC_PROCESS_LA))) {
 		goto iocb_busy;
 	}
@@ -8864,9 +8989,21 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	union lpfc_wqe *wqe;
 	union lpfc_wqe128 wqe128;
 	struct lpfc_queue *wq;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
+	struct lpfc_sli_ring *pring;
 
-	lockdep_assert_held(&phba->hbalock);
+	/* Get the WQ */
+	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
+	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
+		if (!phba->cfg_fof || (!(piocb->iocb_flag & LPFC_IO_OAS)))
+			wq = phba->sli4_hba.fcp_wq[piocb->hba_wqidx];
+		else
+			wq = phba->sli4_hba.oas_wq;
+	} else {
+		wq = phba->sli4_hba.els_wq;
+	}
+
+	/* Get corresponding ring */
+	pring = wq->pring;
 
 	/*
 	 * The WQE can be either 64 or 128 bytes,
@@ -8874,6 +9011,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	 */
 	wqe = (union lpfc_wqe *)&wqe128;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
@@ -8888,7 +9027,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 					return IOCB_BUSY;
 				}
 			} else {
-				sglq = __lpfc_sli_get_sglq(phba, piocb);
+				sglq = __lpfc_sli_get_els_sglq(phba, piocb);
 				if (!sglq) {
 					if (!(flag & SLI_IOCB_RET_IOCB)) {
 						__lpfc_sli_ringtx_put(phba,
@@ -8923,21 +9062,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	if (lpfc_sli4_iocb2wqe(phba, piocb, wqe))
 		return IOCB_ERROR;
 
-	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
-	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
-		if (!phba->cfg_fof || (!(piocb->iocb_flag & LPFC_IO_OAS))) {
-			wq = phba->sli4_hba.fcp_wq[piocb->fcp_wqidx];
-		} else {
-			wq = phba->sli4_hba.oas_wq;
-		}
-		if (lpfc_sli4_wq_put(wq, wqe))
-			return IOCB_ERROR;
-	} else {
-		if (unlikely(!phba->sli4_hba.els_wq))
-			return IOCB_ERROR;
-		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, wqe))
-			return IOCB_ERROR;
-	}
+	if (lpfc_sli4_wq_put(wq, wqe))
+		return IOCB_ERROR;
 	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
 
 	return 0;
@@ -8995,46 +9121,44 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 }
 
 /**
- * lpfc_sli_calc_ring - Calculates which ring to use
+ * lpfc_sli4_calc_ring - Calculates which ring to use
  * @phba: Pointer to HBA context object.
- * @ring_number: Initial ring
  * @piocb: Pointer to command iocb.
  *
- * For SLI4, FCP IO can deferred to one fo many WQs, based on
- * fcp_wqidx, thus we need to calculate the corresponding ring.
+ * For SLI4 only, FCP IO can deferred to one fo many WQs, based on
+ * hba_wqidx, thus we need to calculate the corresponding ring.
  * Since ABORTS must go on the same WQ of the command they are
- * aborting, we use command's fcp_wqidx.
+ * aborting, we use command's hba_wqidx.
  */
-static int
-lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
-		    struct lpfc_iocbq *piocb)
+struct lpfc_sli_ring *
+lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 {
-	if (phba->sli_rev < LPFC_SLI_REV4)
-		return ring_number;
-
-	if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
+	if (piocb->iocb_flag & (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
 		if (!(phba->cfg_fof) ||
-				(!(piocb->iocb_flag & LPFC_IO_FOF))) {
+		    (!(piocb->iocb_flag & LPFC_IO_FOF))) {
 			if (unlikely(!phba->sli4_hba.fcp_wq))
-				return LPFC_HBA_ERROR;
+				return NULL;
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
-			ring_number = MAX_SLI3_CONFIGURED_RINGS +
-				piocb->fcp_wqidx;
+			return phba->sli4_hba.fcp_wq[piocb->hba_wqidx]->pring;
 		} else {
 			if (unlikely(!phba->sli4_hba.oas_wq))
-				return LPFC_HBA_ERROR;
-			piocb->fcp_wqidx = 0;
-			ring_number =  LPFC_FCP_OAS_RING;
+				return NULL;
+			piocb->hba_wqidx = 0;
+			return phba->sli4_hba.oas_wq->pring;
 		}
+	} else {
+		if (unlikely(!phba->sli4_hba.els_wq))
+			return NULL;
+		piocb->hba_wqidx = 0;
+		return phba->sli4_hba.els_wq->pring;
 	}
-	return ring_number;
 }
 
 /**
@@ -9054,7 +9178,7 @@ int
 lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_queue *fpeq;
 	struct lpfc_eqe *eqe;
@@ -9062,21 +9186,19 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 	int rc, idx;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number = lpfc_sli_calc_ring(phba, ring_number, piocb);
-		if (unlikely(ring_number == LPFC_HBA_ERROR))
+		pring = lpfc_sli4_calc_ring(phba, piocb);
+		if (unlikely(pring == NULL))
 			return IOCB_ERROR;
-		idx = piocb->fcp_wqidx;
 
-		pring = &phba->sli.ring[ring_number];
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
 		if (lpfc_fcp_look_ahead && (piocb->iocb_flag &  LPFC_IO_FCP)) {
-			fcp_eq_hdl = &phba->sli4_hba.fcp_eq_hdl[idx];
+			idx = piocb->hba_wqidx;
+			hba_eq_hdl = &phba->sli4_hba.hba_eq_hdl[idx];
 
-			if (atomic_dec_and_test(&fcp_eq_hdl->
-				fcp_eq_in_use)) {
+			if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use)) {
 
 				/* Get associated EQ with this index */
 				fpeq = phba->sli4_hba.hba_eq[idx];
@@ -9097,7 +9219,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				lpfc_sli4_eq_release(fpeq,
 					LPFC_QUEUE_REARM);
 			}
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 		}
 	} else {
 		/* For now, SLI2/3 will still use hbalock */
@@ -9117,7 +9239,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
  * only when driver needs to support target mode functionality
  * or IP over FC functionalities.
  *
- * This function is called with no lock held.
+ * This function is called with no lock held. SLI3 only.
  **/
 static int
 lpfc_extra_ring_setup( struct lpfc_hba *phba)
@@ -9130,14 +9252,14 @@ lpfc_extra_ring_setup( struct lpfc_hba *phba)
 	/* Adjust cmd/rsp ring iocb entries more evenly */
 
 	/* Take some away from the FCP ring */
-	pring = &psli->ring[psli->fcp_ring];
+	pring = &psli->sli3_ring[LPFC_FCP_RING];
 	pring->sli.sli3.numCiocb -= SLI2_IOCB_CMD_R1XTRA_ENTRIES;
 	pring->sli.sli3.numRiocb -= SLI2_IOCB_RSP_R1XTRA_ENTRIES;
 	pring->sli.sli3.numCiocb -= SLI2_IOCB_CMD_R3XTRA_ENTRIES;
 	pring->sli.sli3.numRiocb -= SLI2_IOCB_RSP_R3XTRA_ENTRIES;
 
 	/* and give them to the extra ring */
-	pring = &psli->ring[psli->extra_ring];
+	pring = &psli->sli3_ring[LPFC_EXTRA_RING];
 
 	pring->sli.sli3.numCiocb += SLI2_IOCB_CMD_R1XTRA_ENTRIES;
 	pring->sli.sli3.numRiocb += SLI2_IOCB_RSP_R1XTRA_ENTRIES;
@@ -9322,7 +9444,7 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 
 
 /**
- * lpfc_sli_setup - SLI ring setup function
+ * lpfc_sli4_setup - SLI ring setup function
  * @phba: Pointer to HBA context object.
  *
  * lpfc_sli_setup sets up rings of the SLI interface with
@@ -9333,6 +9455,51 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
  * This function always returns 0.
  **/
 int
+lpfc_sli4_setup(struct lpfc_hba *phba)
+{
+	struct lpfc_sli_ring *pring;
+
+	pring = phba->sli4_hba.els_wq->pring;
+	pring->num_mask = LPFC_MAX_RING_MASK;
+	pring->prt[0].profile = 0;	/* Mask 0 */
+	pring->prt[0].rctl = FC_RCTL_ELS_REQ;
+	pring->prt[0].type = FC_TYPE_ELS;
+	pring->prt[0].lpfc_sli_rcv_unsol_event =
+	    lpfc_els_unsol_event;
+	pring->prt[1].profile = 0;	/* Mask 1 */
+	pring->prt[1].rctl = FC_RCTL_ELS_REP;
+	pring->prt[1].type = FC_TYPE_ELS;
+	pring->prt[1].lpfc_sli_rcv_unsol_event =
+	    lpfc_els_unsol_event;
+	pring->prt[2].profile = 0;	/* Mask 2 */
+	/* NameServer Inquiry */
+	pring->prt[2].rctl = FC_RCTL_DD_UNSOL_CTL;
+	/* NameServer */
+	pring->prt[2].type = FC_TYPE_CT;
+	pring->prt[2].lpfc_sli_rcv_unsol_event =
+	    lpfc_ct_unsol_event;
+	pring->prt[3].profile = 0;	/* Mask 3 */
+	/* NameServer response */
+	pring->prt[3].rctl = FC_RCTL_DD_SOL_CTL;
+	/* NameServer */
+	pring->prt[3].type = FC_TYPE_CT;
+	pring->prt[3].lpfc_sli_rcv_unsol_event =
+	    lpfc_ct_unsol_event;
+	return 0;
+}
+
+/**
+ * lpfc_sli_setup - SLI ring setup function
+ * @phba: Pointer to HBA context object.
+ *
+ * lpfc_sli_setup sets up rings of the SLI interface with
+ * number of iocbs per ring and iotags. This function is
+ * called while driver attach to the HBA and before the
+ * interrupts are enabled. So there is no need for locking.
+ *
+ * This function always returns 0. SLI3 only.
+ **/
+int
 lpfc_sli_setup(struct lpfc_hba *phba)
 {
 	int i, totiocbsize = 0;
@@ -9340,19 +9507,14 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 
 	psli->num_rings = MAX_SLI3_CONFIGURED_RINGS;
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		psli->num_rings += phba->cfg_fcp_io_channel;
 	psli->sli_flag = 0;
-	psli->fcp_ring = LPFC_FCP_RING;
-	psli->next_ring = LPFC_FCP_NEXT_RING;
-	psli->extra_ring = LPFC_EXTRA_RING;
 
 	psli->iocbq_lookup = NULL;
 	psli->iocbq_lookup_len = 0;
 	psli->last_iotag = 0;
 
 	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+		pring = &psli->sli3_ring[i];
 		switch (i) {
 		case LPFC_FCP_RING:	/* ring 0 - FCP */
 			/* numCiocb and numRiocb are used in config_port */
@@ -9451,18 +9613,18 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_queue_setup - Queue initialization function
+ * lpfc_sli4_queue_init - Queue initialization function
  * @phba: Pointer to HBA context object.
  *
- * lpfc_sli_queue_setup sets up mailbox queues and iocb queues for each
+ * lpfc_sli4_queue_init sets up mailbox queues and iocb queues for each
  * ring. This function also initializes ring indices of each ring.
  * This function is called during the initialization of the SLI
  * interface of an HBA.
  * This function is called with no lock held and always returns
  * 1.
  **/
-int
-lpfc_sli_queue_setup(struct lpfc_hba *phba)
+void
+lpfc_sli4_queue_init(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
@@ -9473,31 +9635,102 @@ lpfc_sli_queue_setup(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&psli->mboxq);
 	INIT_LIST_HEAD(&psli->mboxq_cmpl);
 	/* Initialize list headers for txq and txcmplq as double linked lists */
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		pring->ringno = i;
-		pring->sli.sli3.next_cmdidx  = 0;
-		pring->sli.sli3.local_getidx = 0;
-		pring->sli.sli3.cmdidx = 0;
+	for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
+		pring = phba->sli4_hba.fcp_wq[i]->pring;
 		pring->flag = 0;
+		pring->ringno = LPFC_FCP_RING;
 		INIT_LIST_HEAD(&pring->txq);
 		INIT_LIST_HEAD(&pring->txcmplq);
 		INIT_LIST_HEAD(&pring->iocb_continueq);
-		INIT_LIST_HEAD(&pring->iocb_continue_saveq);
-		INIT_LIST_HEAD(&pring->postbufq);
 		spin_lock_init(&pring->ring_lock);
 	}
-	spin_unlock_irq(&phba->hbalock);
-	return 1;
-}
+	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		pring = phba->sli4_hba.nvme_wq[i]->pring;
+		pring->flag = 0;
+		pring->ringno = LPFC_FCP_RING;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+	pring = phba->sli4_hba.els_wq->pring;
+	pring->flag = 0;
+	pring->ringno = LPFC_ELS_RING;
+	INIT_LIST_HEAD(&pring->txq);
+	INIT_LIST_HEAD(&pring->txcmplq);
+	INIT_LIST_HEAD(&pring->iocb_continueq);
+	spin_lock_init(&pring->ring_lock);
 
-/**
- * lpfc_sli_mbox_sys_flush - Flush mailbox command sub-system
- * @phba: Pointer to HBA context object.
- *
- * This routine flushes the mailbox command subsystem. It will unconditionally
- * flush all the mailbox commands in the three possible stages in the mailbox
- * command sub-system: pending mailbox command queue; the outstanding mailbox
+	if (phba->cfg_nvme_io_channel) {
+		pring = phba->sli4_hba.nvmels_wq->pring;
+		pring->flag = 0;
+		pring->ringno = LPFC_ELS_RING;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+
+	if (phba->cfg_fof) {
+		pring = phba->sli4_hba.oas_wq->pring;
+		pring->flag = 0;
+		pring->ringno = LPFC_FCP_RING;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
+ * lpfc_sli_queue_init - Queue initialization function
+ * @phba: Pointer to HBA context object.
+ *
+ * lpfc_sli_queue_init sets up mailbox queues and iocb queues for each
+ * ring. This function also initializes ring indices of each ring.
+ * This function is called during the initialization of the SLI
+ * interface of an HBA.
+ * This function is called with no lock held and always returns
+ * 1.
+ **/
+void
+lpfc_sli_queue_init(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli;
+	struct lpfc_sli_ring *pring;
+	int i;
+
+	psli = &phba->sli;
+	spin_lock_irq(&phba->hbalock);
+	INIT_LIST_HEAD(&psli->mboxq);
+	INIT_LIST_HEAD(&psli->mboxq_cmpl);
+	/* Initialize list headers for txq and txcmplq as double linked lists */
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->sli3_ring[i];
+		pring->ringno = i;
+		pring->sli.sli3.next_cmdidx  = 0;
+		pring->sli.sli3.local_getidx = 0;
+		pring->sli.sli3.cmdidx = 0;
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		INIT_LIST_HEAD(&pring->iocb_continue_saveq);
+		INIT_LIST_HEAD(&pring->postbufq);
+		pring->flag = 0;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		spin_lock_init(&pring->ring_lock);
+	}
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
+ * lpfc_sli_mbox_sys_flush - Flush mailbox command sub-system
+ * @phba: Pointer to HBA context object.
+ *
+ * This routine flushes the mailbox command subsystem. It will unconditionally
+ * flush all the mailbox commands in the three possible stages in the mailbox
+ * command sub-system: pending mailbox command queue; the outstanding mailbox
  * command; and completed mailbox command queue. It is caller's responsibility
  * to make sure that the driver is in the proper state to flush the mailbox
  * command sub-system. Namely, the posting of mailbox commands into the
@@ -9560,6 +9793,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 	LIST_HEAD(completions);
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int i;
@@ -9569,36 +9803,64 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 	lpfc_cleanup_discovery_resources(vport);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		prev_pring_flag = pring->flag;
-		/* Only slow rings */
-		if (pring->ringno == LPFC_ELS_RING) {
-			pring->flag |= LPFC_DEFERRED_RING_EVENT;
-			/* Set the lpfc data pending flag */
-			set_bit(LPFC_DATA_READY, &phba->data_flags);
-		}
-		/*
-		 * Error everything on the txq since these iocbs have not been
-		 * given to the FW yet.
-		 */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-			if (iocb->vport != vport)
-				continue;
-			list_move_tail(&iocb->list, &completions);
-		}
 
-		/* Next issue ABTS for everything on the txcmplq */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq,
-									list) {
-			if (iocb->vport != vport)
+	/*
+	 * Error everything on the txq since these iocbs
+	 * have not been given to the FW yet.
+	 * Also issue ABTS for everything on the txcmplq
+	 */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			prev_pring_flag = pring->flag;
+			/* Only slow rings */
+			if (pring->ringno == LPFC_ELS_RING) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txq, list) {
+				if (iocb->vport != vport)
+					continue;
+				list_move_tail(&iocb->list, &completions);
+			}
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list) {
+				if (iocb->vport != vport)
+					continue;
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			}
+			pring->flag = prev_pring_flag;
+		}
+	} else {
+		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+			pring = qp->pring;
+			if (!pring)
 				continue;
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			if (pring == phba->sli4_hba.els_wq->pring) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+			prev_pring_flag = pring->flag;
+			spin_lock_irq(&pring->ring_lock);
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txq, list) {
+				if (iocb->vport != vport)
+					continue;
+				list_move_tail(&iocb->list, &completions);
+			}
+			spin_unlock_irq(&pring->ring_lock);
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list) {
+				if (iocb->vport != vport)
+					continue;
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			}
+			pring->flag = prev_pring_flag;
 		}
-
-		pring->flag = prev_pring_flag;
 	}
-
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	/* Cancel all the IOCBs from the completions list */
@@ -9627,6 +9889,7 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
 	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *buf_ptr;
 	unsigned long flags = 0;
@@ -9640,20 +9903,36 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	lpfc_fabric_abort_hba(phba);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		/* Only slow rings */
-		if (pring->ringno == LPFC_ELS_RING) {
-			pring->flag |= LPFC_DEFERRED_RING_EVENT;
-			/* Set the lpfc data pending flag */
-			set_bit(LPFC_DATA_READY, &phba->data_flags);
-		}
 
-		/*
-		 * Error everything on the txq since these iocbs have not been
-		 * given to the FW yet.
-		 */
-		list_splice_init(&pring->txq, &completions);
+	/*
+	 * Error everything on the txq since these iocbs
+	 * have not been given to the FW yet.
+	 */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			/* Only slow rings */
+			if (pring->ringno == LPFC_ELS_RING) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+			list_splice_init(&pring->txq, &completions);
+		}
+	} else {
+		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+			pring = qp->pring;
+			if (!pring)
+				continue;
+			spin_lock_irq(&pring->ring_lock);
+			list_splice_init(&pring->txq, &completions);
+			spin_unlock_irq(&pring->ring_lock);
+			if (pring == phba->sli4_hba.els_wq->pring) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+		}
 	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
@@ -9980,7 +10259,6 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_iocbq *abtsiocbp;
 	IOCB_t *icmd = NULL;
 	IOCB_t *iabt = NULL;
-	int ring_number;
 	int retval;
 	unsigned long iflags;
 
@@ -10020,7 +10298,7 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	iabt->ulpClass = icmd->ulpClass;
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocbp->fcp_wqidx = cmdiocb->fcp_wqidx;
+	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
 	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
 		abtsiocbp->iocb_flag |= LPFC_USE_FCPWQIDX;
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
@@ -10042,11 +10320,9 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 abtsiocbp->iotag);
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number =
-			lpfc_sli_calc_ring(phba, pring->ringno, abtsiocbp);
-		if (unlikely(ring_number == LPFC_HBA_ERROR))
+		pring = lpfc_sli4_calc_ring(phba, abtsiocbp);
+		if (unlikely(pring == NULL))
 			return 0;
-		pring = &phba->sli.ring[ring_number];
 		/* Note: both hbalock and ring_lock need to be set here */
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		retval = __lpfc_sli_issue_iocb(phba, pring->ringno,
@@ -10128,6 +10404,111 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
+ * lpfc_sli4_abort_nvme_io - Issue abort for a command iocb
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ *
+ * This function issues an abort iocb for the provided command iocb down to
+ * the port. Other than the case the outstanding command iocb is an abort
+ * request, this function issues abort out unconditionally. This function is
+ * called with hbalock held. The function returns 0 when it fails due to
+ * memory allocation failure or when the command iocb is an abort request.
+ **/
+static int
+lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			struct lpfc_iocbq *cmdiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_iocbq *abtsiocbp;
+	union lpfc_wqe *abts_wqe;
+	int retval;
+
+	/*
+	 * There are certain command types we don't want to abort.  And we
+	 * don't want to abort commands that are already in the process of
+	 * being aborted.
+	 */
+	if (cmdiocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
+	    cmdiocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN ||
+	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
+		return 0;
+
+	/* issue ABTS for this io based on iotag */
+	abtsiocbp = __lpfc_sli_get_iocbq(phba);
+	if (abtsiocbp == NULL)
+		return 0;
+
+	/* This signals the response to set the correct status
+	 * before calling the completion handler
+	 */
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
+
+	/* Complete prepping the abort wqe and issue to the FW. */
+	abts_wqe = &abtsiocbp->wqe;
+	bf_set(abort_cmd_ia, &abts_wqe->abort_cmd, 0);
+	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
+
+	/* Explicitly set reserved fields to zero.*/
+	abts_wqe->abort_cmd.rsrvd4 = 0;
+	abts_wqe->abort_cmd.rsrvd5 = 0;
+
+	/* WQE Common - word 6.  Context is XRI tag.  Set 0. */
+	bf_set(wqe_xri_tag, &abts_wqe->abort_cmd.wqe_com, 0);
+	bf_set(wqe_ctxt_tag, &abts_wqe->abort_cmd.wqe_com, 0);
+
+	/* word 7 */
+	bf_set(wqe_ct, &abts_wqe->abort_cmd.wqe_com, 0);
+	bf_set(wqe_cmnd, &abts_wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
+	bf_set(wqe_class, &abts_wqe->abort_cmd.wqe_com,
+	       cmdiocb->iocb.ulpClass);
+
+	/* word 8 - tell the FW to abort the IO associated with this
+	 * outstanding exchange ID.
+	 */
+	abts_wqe->abort_cmd.wqe_com.abort_tag = cmdiocb->sli4_xritag;
+
+	/* word 9 - this is the iotag for the abts_wqe completion. */
+	bf_set(wqe_reqtag, &abts_wqe->abort_cmd.wqe_com,
+	       abtsiocbp->iotag);
+
+	/* word 10 */
+	bf_set(wqe_wqid, &abts_wqe->abort_cmd.wqe_com, cmdiocb->hba_wqidx);
+	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
+
+	/* word 11 */
+	bf_set(wqe_cmd_type, &abts_wqe->abort_cmd.wqe_com, OTHER_COMMAND);
+	bf_set(wqe_wqec, &abts_wqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_cqid, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+
+	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
+	abtsiocbp->iocb_flag |= LPFC_IO_NVME;
+	abtsiocbp->vport = vport;
+	/* todo: assign wqe_cmpl to lpfc_nvme_abort_fcreq_cmpl
+	 * subsequent patch will add routine. For now, just skip assignment
+	 * as won't ever be called.
+	 */
+	retval = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abtsiocbp);
+	if (retval == IOCB_ERROR) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+				 "6147 Failed abts issue_wqe with status x%x "
+				 "for oxid x%x\n",
+				 retval, cmdiocb->sli4_xritag);
+		lpfc_sli_release_iocbq(phba, abtsiocbp);
+		return retval;
+	}
+
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+			 "6148 Drv Abort NVME Request Issued for "
+			 "ox_id x%x on reqtag x%x\n",
+			 cmdiocb->sli4_xritag,
+			 abtsiocbp->iotag);
+
+	return retval;
+}
+
+/**
  * lpfc_sli_hba_iocb_abort - Abort all iocbs to an hba.
  * @phba: pointer to lpfc HBA data structure.
  *
@@ -10138,10 +10519,20 @@ lpfc_sli_hba_iocb_abort(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *qp = NULL;
 	int i;
 
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			lpfc_sli_abort_iocb_ring(phba, pring);
+		}
+		return;
+	}
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring)
+			continue;
 		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
 }
@@ -10345,7 +10736,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		abtsiocb->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocb->fcp_wqidx = iocbq->fcp_wqidx;
+		abtsiocb->hba_wqidx = iocbq->hba_wqidx;
 		if (iocbq->iocb_flag & LPFC_IO_FCP)
 			abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
@@ -10405,7 +10796,6 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 	int sum, i, ret_val;
 	unsigned long iflags;
 	struct lpfc_sli_ring *pring_s4;
-	uint32_t ring_number;
 
 	spin_lock_irq(&phba->hbalock);
 
@@ -10448,7 +10838,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		abtsiocbq->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocbq->fcp_wqidx = iocbq->fcp_wqidx;
+		abtsiocbq->hba_wqidx = iocbq->hba_wqidx;
 		if (iocbq->iocb_flag & LPFC_IO_FCP)
 			abtsiocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
@@ -10473,9 +10863,9 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		iocbq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
-			ring_number = MAX_SLI3_CONFIGURED_RINGS +
-					 iocbq->fcp_wqidx;
-			pring_s4 = &phba->sli.ring[ring_number];
+			pring_s4 = lpfc_sli4_calc_ring(phba, iocbq);
+			if (pring_s4 == NULL)
+				continue;
 			/* Note: both hbalock and ring_lock must be set here */
 			spin_lock_irqsave(&pring_s4->ring_lock, iflags);
 			ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -10637,10 +11027,14 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	struct lpfc_iocbq *iocb;
 	int txq_cnt = 0;
 	int txcmplq_cnt = 0;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	unsigned long iflags;
 	bool iocb_completed = true;
 
+	if (phba->sli_rev >= LPFC_SLI_REV4)
+		pring = lpfc_sli4_calc_ring(phba, piocb);
+	else
+		pring = &phba->sli.sli3_ring[ring_number];
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
 	 * is NULL or its an error.
@@ -11435,6 +11829,7 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 	uint32_t ha_copy;
 	unsigned long status;
 	unsigned long iflag;
+	struct lpfc_sli_ring *pring;
 
 	/* Get the driver's phba structure from the dev_id and
 	 * assume the HBA is not interrupting.
@@ -11479,10 +11874,9 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 
 	status = (ha_copy & (HA_RXMASK << (4*LPFC_FCP_RING)));
 	status >>= (4*LPFC_FCP_RING);
+	pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
 	if (status & HA_RXMASK)
-		lpfc_sli_handle_fast_ring_event(phba,
-						&phba->sli.ring[LPFC_FCP_RING],
-						status);
+		lpfc_sli_handle_fast_ring_event(phba, pring, status);
 
 	if (phba->cfg_multi_ring_support == 2) {
 		/*
@@ -11493,7 +11887,7 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 		status >>= (4*LPFC_EXTRA_RING);
 		if (status & HA_RXMASK) {
 			lpfc_sli_handle_fast_ring_event(phba,
-					&phba->sli.ring[LPFC_EXTRA_RING],
+					&phba->sli.sli3_ring[LPFC_EXTRA_RING],
 					status);
 		}
 	}
@@ -11806,11 +12200,13 @@ static struct lpfc_iocbq *
 lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 			       struct lpfc_iocbq *irspiocbq)
 {
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *cmdiocbq;
 	struct lpfc_wcqe_complete *wcqe;
 	unsigned long iflags;
 
+	pring = lpfc_phba_elsring(phba);
+
 	wcqe = &irspiocbq->cq_event.cqe.wcqe_cmpl;
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
@@ -12046,8 +12442,6 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			txq_cnt++;
 		if (!list_empty(&pring->txcmplq))
 			txcmplq_cnt++;
-		if (!list_empty(&phba->sli.ring[LPFC_FCP_RING].txcmplq))
-			fcp_txcmplq_cnt++;
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0387 NO IOCBQ data: txq_cnt=%d iocb_cnt=%d "
 			"fcp_txcmplq_cnt=%d, els_txcmplq_cnt=%d\n",
@@ -12166,6 +12560,7 @@ static bool
 lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 {
 	bool workposted = false;
+	struct fc_frame_header *fc_hdr;
 	struct lpfc_queue *hrq = phba->sli4_hba.hdr_rq;
 	struct lpfc_queue *drq = phba->sli4_hba.dat_rq;
 	struct hbq_dmabuf *dma_buf;
@@ -12200,6 +12595,10 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
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
@@ -12318,6 +12717,9 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		return;
 	}
 
+	/* Save EQ associated with this CQ */
+	cq->assoc_qp = speq;
+
 	/* Process all the entries to the CQ */
 	switch (cq->type) {
 	case LPFC_MCQ:
@@ -12330,8 +12732,9 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
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
@@ -12418,7 +12821,23 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 		return;
 	}
-	if (unlikely(!cmdiocbq->iocb_cmpl)) {
+
+	if (cq->assoc_qp)
+		cmdiocbq->isr_timestamp =
+			cq->assoc_qp->isr_timestamp;
+
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
@@ -12454,12 +12873,12 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
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
@@ -12470,11 +12889,11 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	if (wqid_matched != true)
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"2580 Fast-path wqe consume event carries "
-				"miss-matched qid: wcqe-qid=x%x\n", fcp_wqid);
+				"miss-matched qid: wcqe-qid=x%x\n", hba_wqid);
 }
 
 /**
- * lpfc_sli4_fp_handle_wcqe - Process fast-path work queue completion entry
+ * lpfc_sli4_fp_handle_cqe - Process fast-path work queue completion entry
  * @cq: Pointer to the completion queue.
  * @eqe: Pointer to fast-path completion queue entry.
  *
@@ -12482,7 +12901,7 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * event queue for FCP command response completion.
  **/
 static int
-lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			 struct lpfc_cqe *cqe)
 {
 	struct lpfc_wcqe_release wcqe;
@@ -12494,10 +12913,15 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
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
@@ -12513,9 +12937,13 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
 				(struct sli4_wcqe_xri_aborted *)&wcqe);
 		break;
+	case CQE_CODE_RECEIVE_V1:
+	case CQE_CODE_RECEIVE:
+		phba->last_completion_time = jiffies;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0144 Not a valid WCQE code: x%x\n",
+				"0144 Not a valid CQE code: x%x\n",
 				bf_get(lpfc_wcqe_c_code, &wcqe));
 		break;
 	}
@@ -12538,7 +12966,7 @@ static void
 lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			uint32_t qidx)
 {
-	struct lpfc_queue *cq;
+	struct lpfc_queue *cq = NULL;
 	struct lpfc_cqe *cqe;
 	bool workposted = false;
 	uint16_t cqid;
@@ -12556,28 +12984,33 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* Get the reference to the corresponding CQ */
 	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 
-	/* Check if this is a Slow path event */
-	if (unlikely(cqid != phba->sli4_hba.fcp_cq_map[qidx])) {
-		lpfc_sli4_sp_handle_eqe(phba, eqe,
-			phba->sli4_hba.hba_eq[qidx]);
-		return;
+	if (phba->sli4_hba.nvme_cq_map &&
+	    (cqid == phba->sli4_hba.nvme_cq_map[qidx])) {
+		/* Process NVME command completion */
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
+		/* Process NVME unsol rcv */
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
@@ -12586,9 +13019,12 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		return;
 	}
 
+	/* Save EQ associated with this CQ */
+	cq->assoc_qp = phba->sli4_hba.hba_eq[qidx];
+
 	/* Process all the entries to the CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
@@ -12679,7 +13115,7 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 
 	/* Process all the entries to the OAS CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
@@ -12727,15 +13163,15 @@ irqreturn_t
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
@@ -12821,17 +13257,17 @@ irqreturn_t
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
@@ -12839,15 +13275,15 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
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
@@ -12862,7 +13298,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 			lpfc_sli4_eq_flush(phba, fpeq);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (lpfc_fcp_look_ahead)
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 		return IRQ_NONE;
 	}
 
@@ -12873,7 +13309,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		if (eqe == NULL)
 			break;
 
-		lpfc_sli4_hba_handle_eqe(phba, eqe, fcp_eqidx);
+		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
 		if (!(++ecount % fpeq->entry_repost))
 			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
 		fpeq->EQ_processed++;
@@ -12890,7 +13326,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		fpeq->EQ_no_entry++;
 
 		if (lpfc_fcp_look_ahead) {
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
 		}
 
@@ -12904,7 +13340,8 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	}
 
 	if (lpfc_fcp_look_ahead)
-		atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+		atomic_inc(&hba_eq_hdl->hba_eq_in_use);
+
 	return IRQ_HANDLED;
 } /* lpfc_sli4_fp_intr_handler */
 
@@ -12931,7 +13368,7 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba  *phba;
 	irqreturn_t hba_irq_rc;
 	bool hba_handled = false;
-	int fcp_eqidx;
+	int qidx;
 
 	/* Get the driver's phba structure from the dev_id */
 	phba = (struct lpfc_hba *)dev_id;
@@ -12942,16 +13379,16 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 	/*
 	 * Invoke fast-path host attention interrupt handling as appropriate.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel; fcp_eqidx++) {
+	for (qidx = 0; qidx < phba->io_channel_irqs; qidx++) {
 		hba_irq_rc = lpfc_sli4_hba_intr_handler(irq,
-					&phba->sli4_hba.fcp_eq_hdl[fcp_eqidx]);
+					&phba->sli4_hba.hba_eq_hdl[qidx]);
 		if (hba_irq_rc == IRQ_HANDLED)
 			hba_handled |= true;
 	}
 
 	if (phba->cfg_fof) {
 		hba_irq_rc = lpfc_sli4_fof_intr_handler(irq,
-					&phba->sli4_hba.fcp_eq_hdl[0]);
+					&phba->sli4_hba.hba_eq_hdl[qidx]);
 		if (hba_irq_rc == IRQ_HANDLED)
 			hba_handled |= true;
 	}
@@ -12982,6 +13419,11 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 				  dmabuf->virt, dmabuf->phys);
 		kfree(dmabuf);
 	}
+	if (queue->rqbp) {
+		lpfc_free_rq_buffer(queue->phba, queue);
+		kfree(queue->rqbp);
+	}
+	kfree(queue->pring);
 	kfree(queue);
 	return;
 }
@@ -13015,7 +13457,13 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 		return NULL;
 	queue->page_count = (ALIGN(entry_size * entry_count,
 			hw_page_size))/hw_page_size;
+
+	/* If needed, Adjust page count to match the max the adapter supports */
+	if (queue->page_count > phba->sli4_hba.pc_sli4_params.wqpcnt)
+		queue->page_count = phba->sli4_hba.pc_sli4_params.wqpcnt;
+
 	INIT_LIST_HEAD(&queue->list);
+	INIT_LIST_HEAD(&queue->wq_list);
 	INIT_LIST_HEAD(&queue->page_list);
 	INIT_LIST_HEAD(&queue->child_list);
 	for (x = 0, total_qe_count = 0; x < queue->page_count; x++) {
@@ -13087,7 +13535,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 }
 
 /**
- * lpfc_modify_fcp_eq_delay - Modify Delay Multiplier on FCP EQs
+ * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on FCP EQs
  * @phba: HBA structure that indicates port to create a queue on.
  * @startq: The starting FCP EQ to modify
  *
@@ -13103,7 +13551,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * fails this function will return -ENXIO.
  **/
 int
-lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
+lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 {
 	struct lpfc_mbx_modify_eq_delay *eq_delay;
 	LPFC_MBOXQ_t *mbox;
@@ -13111,11 +13559,11 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 	int cnt, rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	uint32_t result;
-	int fcp_eqidx;
+	int qidx;
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint16_t dmult;
 
-	if (startq >= phba->cfg_fcp_io_channel)
+	if (startq >= phba->io_channel_irqs)
 		return 0;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -13129,16 +13577,15 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 	eq_delay = &mbox->u.mqe.un.eq_delay;
 
 	/* Calculate delay multiper from maximum interrupt per second */
-	result = phba->cfg_fcp_imax / phba->cfg_fcp_io_channel;
-	if (result > LPFC_DMULT_CONST)
+	result = phba->cfg_fcp_imax / phba->io_channel_irqs;
+	if (result > LPFC_DMULT_CONST || result == 0)
 		dmult = 0;
 	else
 		dmult = LPFC_DMULT_CONST/result - 1;
 
 	cnt = 0;
-	for (fcp_eqidx = startq; fcp_eqidx < phba->cfg_fcp_io_channel;
-	    fcp_eqidx++) {
-		eq = phba->sli4_hba.hba_eq[fcp_eqidx];
+	for (qidx = startq; qidx < phba->io_channel_irqs; qidx++) {
+		eq = phba->sli4_hba.hba_eq[qidx];
 		if (!eq)
 			continue;
 		eq_delay->u.request.eq[cnt].eq_id = eq->queue_id;
@@ -13822,6 +14269,11 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 		wq->db_format = LPFC_DB_LIST_FORMAT;
 		wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
 	}
+	wq->pring = kzalloc(sizeof(struct lpfc_sli_ring), GFP_KERNEL);
+	if (wq->pring == NULL) {
+		status = -ENOMEM;
+		goto out;
+	}
 	wq->type = LPFC_WQ;
 	wq->assoc_qid = cq->queue_id;
 	wq->subtype = subtype;
@@ -14606,7 +15058,7 @@ lpfc_sli4_next_xritag(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_post_els_sgl_list - post a block of ELS sgls to the port.
+ * lpfc_sli4_post_sgl_list - post a block of ELS sgls to the port.
  * @phba: pointer to lpfc hba data structure.
  * @post_sgl_list: pointer to els sgl entry list.
  * @count: number of els sgl entries on the list.
@@ -14617,7 +15069,7 @@ lpfc_sli4_next_xritag(struct lpfc_hba *phba)
  * stopped.
  **/
 static int
-lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba,
+lpfc_sli4_post_sgl_list(struct lpfc_hba *phba,
 			    struct list_head *post_sgl_list,
 			    int post_cnt)
 {
@@ -14633,14 +15085,15 @@ lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba,
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 
-	reqlen = phba->sli4_hba.els_xri_cnt * sizeof(struct sgl_page_pairs) +
+	reqlen = post_cnt * sizeof(struct sgl_page_pairs) +
 		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
 	if (reqlen > SLI4_PAGE_SIZE) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2559 Block sgl registration required DMA "
 				"size (%d) great than a page\n", reqlen);
 		return -ENOMEM;
 	}
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -14684,8 +15137,9 @@ lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba,
 
 	/* Complete initialization and perform endian conversion. */
 	bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
-	bf_set(lpfc_post_sgl_pages_xricnt, sgl, phba->sli4_hba.els_xri_cnt);
+	bf_set(lpfc_post_sgl_pages_xricnt, sgl, post_cnt);
 	sgl->word0 = cpu_to_le32(sgl->word0);
+
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
@@ -14881,6 +15335,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_TYPE_ELS:
 	case FC_TYPE_FCP:
 	case FC_TYPE_CT:
+	case FC_TYPE_NVME:
 		break;
 	case FC_TYPE_IP:
 	case FC_TYPE_ILS:
@@ -14938,14 +15393,11 @@ lpfc_fc_hdr_get_vfi(struct fc_frame_header *fc_hdr)
  **/
 static struct lpfc_vport *
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
@@ -14954,7 +15406,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
 		return phba->pport;
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			if (phba->fcf.fcfi == fcfi &&
 			    vports[i]->vfi == lpfc_fc_hdr_get_vfi(fc_hdr) &&
@@ -14963,6 +15415,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
 				break;
 			}
 		}
+	}
 	lpfc_destroy_vport_work_array(phba, vports);
 	return vport;
 }
@@ -15392,7 +15845,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	 * a BA_RJT.
 	 */
 	if ((fctl & FC_FC_EX_CTX) &&
-	    (lxri > lpfc_sli4_get_els_iocb_cnt(phba))) {
+	    (lxri > lpfc_sli4_get_iocb_cnt(phba))) {
 		icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_RJT;
 		bf_set(lpfc_vndr_code, &icmd->un.bls_rsp, 0);
 		bf_set(lpfc_rsn_expln, &icmd->un.bls_rsp, FC_BA_RJT_INV_XID);
@@ -15569,6 +16022,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		/* Initialize the first IOCB. */
 		first_iocbq->iocb.unsli3.rcvsli3.acc_len = 0;
 		first_iocbq->iocb.ulpStatus = IOSTAT_SUCCESS;
+		first_iocbq->vport = vport;
 
 		/* Check FC Header to see what TYPE of frame we are rcv'ing */
 		if (sli4_type_from_fc_hdr(fc_hdr) == FC_TYPE_ELS) {
@@ -15681,7 +16135,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 		return;
 	}
 	if (!lpfc_complete_unsol_iocb(phba,
-				      &phba->sli.ring[LPFC_ELS_RING],
+				      phba->sli4_hba.els_wq->pring,
 				      iocbq, fc_hdr->fh_r_ctl,
 				      fc_hdr->fh_type))
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -15706,8 +16160,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
  * This function is called with no lock held. This function processes all
  * the received buffers and gives it to upper layers when a received buffer
  * indicates that it is the final frame in the sequence. The interrupt
- * service routine processes received buffers at interrupt contexts and adds
- * received dma buffers to the rb_pend_list queue and signals the worker thread.
+ * service routine processes received buffers at interrupt contexts.
  * Worker thread calls lpfc_sli4_handle_received_buffer, which will call the
  * appropriate receive function when the final frame in a sequence is received.
  **/
@@ -15738,16 +16191,16 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
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
@@ -17225,7 +17678,7 @@ uint32_t
 lpfc_drain_txq(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *piocbq = NULL;
 	unsigned long iflags = 0;
 	char *fail_msg = NULL;
@@ -17234,6 +17687,8 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	union lpfc_wqe *wqe = (union lpfc_wqe *) &wqe128;
 	uint32_t txq_cnt = 0;
 
+	pring = lpfc_phba_elsring(phba);
+
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	list_for_each_entry(piocbq, &pring->txq, list) {
 		txq_cnt++;
@@ -17255,7 +17710,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 				txq_cnt);
 			break;
 		}
-		sglq = __lpfc_sli_get_sglq(phba, piocbq);
+		sglq = __lpfc_sli_get_els_sglq(phba, piocbq);
 		if (!sglq) {
 			__lpfc_sli_ringtx_put(phba, pring, piocbq);
 			spin_unlock_irqrestore(&pring->ring_lock, iflags);
@@ -17295,3 +17750,191 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 
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
+ */
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
+
+/**
+ * lpfc_sli4_issue_wqe - Issue an SLI4 Work Queue Entry (WQE)
+ * @phba: Pointer to HBA context object.
+ * @ring_number: Base sli ring number
+ * @pwqe: Pointer to command WQE.
+ **/
+int
+lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
+		    struct lpfc_iocbq *pwqe)
+{
+	union lpfc_wqe *wqe = &pwqe->wqe;
+	struct lpfc_queue *wq;
+	struct lpfc_sglq *sglq;
+	struct lpfc_sli_ring *pring;
+	unsigned long iflags;
+
+	/* NVME_LS and NVME_LS ABTS requests. */
+	if (pwqe->iocb_flag & LPFC_IO_NVME_LS) {
+		pring =  phba->sli4_hba.nvmels_wq->pring;
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		sglq = __lpfc_sli_get_els_sglq(phba, pwqe);
+		if (!sglq) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_BUSY;
+		}
+		pwqe->sli4_lxritag = sglq->sli4_lxritag;
+		pwqe->sli4_xritag = sglq->sli4_xritag;
+		if (lpfc_wqe_bpl2sgl(phba, pwqe, sglq) == NO_XRI) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		bf_set(wqe_xri_tag, &pwqe->wqe.xmit_bls_rsp.wqe_com,
+		       pwqe->sli4_xritag);
+		if (lpfc_sli4_wq_put(phba->sli4_hba.nvmels_wq, wqe)) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		return 0;
+	}
+
+	/* NVME_FCREQ and NVME_ABTS requests */
+	if (pwqe->iocb_flag & LPFC_IO_NVME) {
+		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
+		pring = phba->sli4_hba.nvme_wq[pwqe->hba_wqidx]->pring;
+
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		wq = phba->sli4_hba.nvme_wq[pwqe->hba_wqidx];
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
+
+	return WQE_ERROR;
+}
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 3fad565..7252012 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -54,9 +54,16 @@ struct lpfc_iocbq {
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_lxritag;  /* logical pre-assigned XRI. */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
+	uint16_t hba_wqidx;     /* index to HBA work queue */
 	struct lpfc_cq_event cq_event;
+	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
+	uint64_t isr_timestamp;
 
-	IOCB_t iocb;		/* IOCB cmd */
+	/* Be careful here */
+	union lpfc_wqe wqe;	/* WQE cmd */
+	IOCB_t iocb;		/* For IOCB cmd or if we want 128 byte WQE */
+
+	uint8_t rsvd2;
 	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint32_t iocb_flag;
@@ -82,9 +89,12 @@ struct lpfc_iocbq {
 #define LPFC_IO_OAS		0x10000 /* OAS FCP IO */
 #define LPFC_IO_FOF		0x20000 /* FOF FCP IO */
 #define LPFC_IO_LOOPBACK	0x40000 /* Loopback IO */
+#define LPFC_PRLI_NVME_REQ	0x80000 /* This is an NVME PRLI. */
+#define LPFC_PRLI_FCP_REQ	0x100000 /* This is an NVME PRLI. */
+#define LPFC_IO_NVME	        0x200000 /* NVME FCP command */
+#define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
-	uint32_t fcp_wqidx;	/* index to FCP work queue */
 	struct lpfc_vport *vport;/* virtual port pointer */
 	void *context1;		/* caller context information */
 	void *context2;		/* caller context information */
@@ -103,6 +113,8 @@ struct lpfc_iocbq {
 			   struct lpfc_iocbq *);
 	void (*iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
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
 
@@ -298,11 +318,7 @@ struct lpfc_sli {
 #define LPFC_MENLO_MAINT          0x1000 /* need for menl fw download */
 #define LPFC_SLI_ASYNC_MBX_BLK    0x2000 /* Async mailbox is blocked */
 
-	struct lpfc_sli_ring *ring;
-	int fcp_ring;		/* ring used for FCP initiator commands */
-	int next_ring;
-
-	int extra_ring;		/* extra ring used for other protocols */
+	struct lpfc_sli_ring *sli3_ring;
 
 	struct lpfc_sli_stat slistat;	/* SLI statistical info */
 	struct list_head mboxq;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index dfbb25e..b5b4f6b 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -35,9 +35,10 @@
 #define LPFC_NEMBED_MBOX_SGL_CNT		254
 
 /* Multi-queue arrangement for FCP EQ/CQ/WQ tuples */
-#define LPFC_FCP_IO_CHAN_DEF       4
-#define LPFC_FCP_IO_CHAN_MIN       1
-#define LPFC_FCP_IO_CHAN_MAX       16
+#define LPFC_HBA_IO_CHAN_MIN	0
+#define LPFC_HBA_IO_CHAN_MAX	32
+#define LPFC_FCP_IO_CHAN_DEF	4
+#define LPFC_NVME_IO_CHAN_DEF	0
 
 /* Number of channels used for Flash Optimized Fabric (FOF) operations */
 
@@ -107,6 +108,8 @@ enum lpfc_sli4_queue_subtype {
 	LPFC_MBOX,
 	LPFC_FCP,
 	LPFC_ELS,
+	LPFC_NVME,
+	LPFC_NVME_LS,
 	LPFC_USOL
 };
 
@@ -125,25 +128,41 @@ union sli4_qe {
 	struct lpfc_rqe *rqe;
 };
 
+/* RQ buffer list */
+struct lpfc_rqb {
+	uint16_t entry_count;	  /* Current number of RQ slots */
+	uint16_t buffer_count;	  /* Current number of buffers posted */
+	struct list_head rqb_buffer_list;  /* buffers assigned to this HBQ */
+				  /* Callback for HBQ buffer allocation */
+	struct rqb_dmabuf *(*rqb_alloc_buffer)(struct lpfc_hba *);
+				  /* Callback for HBQ buffer free */
+	void               (*rqb_free_buffer)(struct lpfc_hba *,
+					       struct rqb_dmabuf *);
+};
+
 struct lpfc_queue {
 	struct list_head list;
+	struct list_head wq_list;
 	enum lpfc_sli4_queue_type type;
 	enum lpfc_sli4_queue_subtype subtype;
 	struct lpfc_hba *phba;
 	struct list_head child_list;
+	struct list_head page_list;
+	struct list_head sgl_list;
 	uint32_t entry_count;	/* Number of entries to support on the queue */
 	uint32_t entry_size;	/* Size of each queue entry. */
 	uint32_t entry_repost;	/* Count of entries before doorbell is rung */
 #define LPFC_QUEUE_MIN_REPOST	8
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
-	struct list_head page_list;
 	uint32_t page_count;	/* Number of pages allocated for this queue */
 	uint32_t host_index;	/* The host's index for putting or getting */
 	uint32_t hba_index;	/* The last known hba index for get or put */
 
 	struct lpfc_sli_ring *pring; /* ptr to io ring associated with q */
+	struct lpfc_rqb *rqbp;	/* ptr to RQ buffers */
 
+	uint16_t sgl_list_cnt;
 	uint16_t db_format;
 #define LPFC_DB_RING_FORMAT	0x01
 #define LPFC_DB_LIST_FORMAT	0x02
@@ -176,6 +195,8 @@ struct lpfc_queue {
 #define	RQ_buf_trunc		q_cnt_3
 #define	RQ_rcv_buf		q_cnt_4
 
+	uint64_t isr_timestamp;
+	struct lpfc_queue *assoc_qp;
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
 };
 
@@ -338,6 +359,7 @@ struct lpfc_bmbx {
 #define LPFC_CQE_DEF_COUNT      1024
 #define LPFC_WQE_DEF_COUNT      256
 #define LPFC_WQE128_DEF_COUNT   128
+#define LPFC_WQE128_MAX_COUNT   256
 #define LPFC_MQE_DEF_COUNT      16
 #define LPFC_RQE_DEF_COUNT	512
 
@@ -379,10 +401,14 @@ struct lpfc_max_cfg_param {
 
 struct lpfc_hba;
 /* SLI4 HBA multi-fcp queue handler struct */
-struct lpfc_fcp_eq_hdl {
+struct lpfc_hba_eq_hdl {
 	uint32_t idx;
 	struct lpfc_hba *phba;
-	atomic_t fcp_eq_in_use;
+	atomic_t hba_eq_in_use;
+	struct cpumask *cpumask;
+	/* CPU affinitsed to or 0xffffffff if multiple */
+	uint32_t cpu;
+#define LPFC_MULTI_CPU_AFFINITY 0xffffffff
 };
 
 /* Port Capabilities for SLI4 Parameters */
@@ -427,6 +453,7 @@ struct lpfc_pc_sli4_params {
 	uint8_t wqsize;
 #define LPFC_WQ_SZ64_SUPPORT	1
 #define LPFC_WQ_SZ128_SUPPORT	2
+	uint8_t wqpcnt;
 };
 
 struct lpfc_iov {
@@ -445,7 +472,7 @@ struct lpfc_sli4_lnk_info {
 	uint8_t optic_state;
 };
 
-#define LPFC_SLI4_HANDLER_CNT		(LPFC_FCP_IO_CHAN_MAX+ \
+#define LPFC_SLI4_HANDLER_CNT		(LPFC_HBA_IO_CHAN_MAX+ \
 					 LPFC_FOF_IO_CHAN_NUM)
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 
@@ -516,21 +543,30 @@ struct lpfc_sli4_hba {
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	uint8_t handler_name[LPFC_SLI4_HANDLER_CNT][LPFC_SLI4_HANDLER_NAME_SZ];
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
+	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
 	/* Pointers to the constructed SLI4 queues */
-	struct lpfc_queue **hba_eq;/* Event queues for HBA */
-	struct lpfc_queue **fcp_cq;/* Fast-path FCP compl queue */
-	struct lpfc_queue **fcp_wq;/* Fast-path FCP work queue */
+	struct lpfc_queue **hba_eq;  /* Event queues for HBA */
+	struct lpfc_queue **fcp_cq;  /* Fast-path FCP compl queue */
+	struct lpfc_queue **nvme_cq; /* Fast-path NVME compl queue */
+	struct lpfc_queue **fcp_wq;  /* Fast-path FCP work queue */
+	struct lpfc_queue **nvme_wq; /* Fast-path NVME work queue */
 	uint16_t *fcp_cq_map;
+	uint16_t *nvme_cq_map;
+	struct list_head lpfc_wq_list;
 
 	struct lpfc_queue *mbx_cq; /* Slow-path mailbox complete queue */
 	struct lpfc_queue *els_cq; /* Slow-path ELS response complete queue */
+	struct lpfc_queue *nvmels_cq; /* NVME LS complete queue */
 	struct lpfc_queue *mbx_wq; /* Slow-path MBOX work queue */
 	struct lpfc_queue *els_wq; /* Slow-path ELS work queue */
+	struct lpfc_queue *nvmels_wq; /* NVME LS work queue */
 	struct lpfc_queue *hdr_rq; /* Slow-path Header Receive queue */
 	struct lpfc_queue *dat_rq; /* Slow-path Data Receive queue */
 
+	struct lpfc_name wwnn;
+	struct lpfc_name wwpn;
+
 	uint32_t fw_func_mode;	/* FW function protocol mode */
 	uint32_t ulp0_mode;	/* ULP0 protocol mode */
 	uint32_t ulp1_mode;	/* ULP1 protocol mode */
@@ -567,14 +603,17 @@ struct lpfc_sli4_hba {
 	uint16_t rpi_hdrs_in_use; /* must post rpi hdrs if set. */
 	uint16_t next_xri; /* last_xri - max_cfg_param.xri_base = used */
 	uint16_t next_rpi;
+	uint16_t nvme_xri_max;
+	uint16_t nvme_xri_cnt;
+	uint16_t nvme_xri_start;
 	uint16_t scsi_xri_max;
 	uint16_t scsi_xri_cnt;
-	uint16_t els_xri_cnt;
 	uint16_t scsi_xri_start;
-	struct list_head lpfc_free_sgl_list;
-	struct list_head lpfc_sgl_list;
+	uint16_t els_xri_cnt;
+	struct list_head lpfc_els_sgl_list;
 	struct list_head lpfc_abts_els_sgl_list;
 	struct list_head lpfc_abts_scsi_buf_list;
+	struct list_head lpfc_abts_nvme_buf_list;
 	struct lpfc_sglq **lpfc_sglq_active_list;
 	struct list_head lpfc_rpi_hdr_list;
 	unsigned long *rpi_bmask;
@@ -601,8 +640,9 @@ struct lpfc_sli4_hba {
 #define LPFC_SLI4_PPNAME_NON	0
 #define LPFC_SLI4_PPNAME_GET	1
 	struct lpfc_iov iov;
+	spinlock_t abts_nvme_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
-	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
+	spinlock_t sgl_list_lock; /* list of aborted els IOs */
 	uint32_t physical_port;
 
 	/* CPU to vector mapping information */
@@ -614,7 +654,7 @@ struct lpfc_sli4_hba {
 
 enum lpfc_sge_type {
 	GEN_BUFF_TYPE,
-	SCSI_BUFF_TYPE
+	SCSI_BUFF_TYPE,
 };
 
 enum lpfc_sgl_state {
@@ -693,7 +733,7 @@ struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
 			uint32_t);
 void lpfc_sli4_queue_free(struct lpfc_queue *);
 int lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
-int lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint32_t);
+int lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq);
 int lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
 int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
@@ -745,6 +785,7 @@ int lpfc_sli4_brdreset(struct lpfc_hba *);
 int lpfc_sli4_add_fcf_record(struct lpfc_hba *, struct fcf_record *);
 void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
 int lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *);
+int lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba);
 int lpfc_sli4_init_vpi(struct lpfc_vport *);
 uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
 uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 5bbe6af..07c7c5f 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -403,6 +403,8 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		vport->fdmi_port_mask = phba->pport->fdmi_port_mask;
 	}
 
+	/* todo: init: register port with nvme */
+
 	/*
 	 * In SLI4, the vpi must be activated before it can be used
 	 * by the port.
-- 
2.5.0
