From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: support for multi- queue adapter
Date: Tue, 9 Dec 2008 16:45:39 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0812091525020.9629@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:58599 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYLJApk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 19:45:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Following changes have been made.
1. qla_hw_data structure holds an array for request queue pointers,
and an array for response queue pointers.
2. The base request and response queues are created by default.
3. Additional request and response queues are created at the time of vport
creation. If queue resources are exhausted during vport creation, newly
created vports use the default queue.
4. Requests are sent to the request queue that the vport was assigned
in the beginning.
5. Responses are completed on the response queue with which the request queue
is associated with.

The patch is generated against the scsi-misc-2.6 tree.
Please apply.

Thanks,
Anirban
 
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_attr.c    |   30 +++-
 drivers/scsi/qla2xxx/qla_dbg.c     |   67 +++++--
 drivers/scsi/qla2xxx/qla_dbg.h     |   15 ++-
 drivers/scsi/qla2xxx/qla_def.h     |   64 +++++-
 drivers/scsi/qla2xxx/qla_fw.h      |   14 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   41 +++-
 drivers/scsi/qla2xxx/qla_gs.c      |    6 -
 drivers/scsi/qla2xxx/qla_init.c    |  192 ++++++++++++-----
 drivers/scsi/qla2xxx/qla_inline.h  |   26 ---
 drivers/scsi/qla2xxx/qla_iocb.c    |  158 +++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c     |  335 ++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_mbx.c     |  147 +++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |  349 +++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c      |  423 +++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_sup.c     |   33 ++-
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 16 files changed, 1443 insertions(+), 461 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b223842..cd53627 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1143,8 +1143,11 @@ static int
 qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 {
 	int	ret = 0;
+	int	cnt = 0;
+	uint8_t	qos = QLA_DEFAULT_QUE_QOS;
 	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
 	scsi_qla_host_t *vha = NULL;
+	struct qla_hw_data *ha = base_vha->hw;
 
 	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
 	if (ret) {
@@ -1200,6 +1203,22 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	qla24xx_vport_disable(fc_vport, disable);
 
+	/* Create a queue pair for the vport */
+	if (ha->mqenable) {
+		if (ha->npiv_info) {
+			for (; cnt < ha->nvram_npiv_size; cnt++) {
+				if (ha->npiv_info[cnt].port_name ==
+					vha->port_name &&
+					ha->npiv_info[cnt].node_name ==
+					vha->node_name) {
+					qos = ha->npiv_info[cnt].q_qos;
+					break;
+				}
+			}
+		}
+		qla25xx_create_queues(vha, qos);
+	}
+
 	return 0;
 vport_create_failed_2:
 	qla24xx_disable_vp(vha);
@@ -1213,11 +1232,20 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
 	fc_port_t *fcport, *tfcport;
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t id = vha->vp_idx;
 
 	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags) ||
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
+	if (ha->mqenable) {
+		if (qla25xx_delete_queues(vha, 0) != QLA_SUCCESS)
+			qla_printk(KERN_WARNING, ha,
+				"Queue delete failed.\n");
+		vha->req_ques[0] = ha->req_q_map[0]->id;
+	}
+
 	qla24xx_disable_vp(vha);
 
 	fc_remove_host(vha->host);
@@ -1240,7 +1268,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
         }
 
 	scsi_host_put(vha->host);
-
+	qla_printk(KERN_INFO, ha, "vport %d deleted\n", id);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f15f903..1cf7777 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -23,11 +23,10 @@ qla2xxx_prep_dump(struct qla_hw_data *ha, struct qla2xxx_fw_dump *fw_dump)
 }
 
 static inline void *
-qla2xxx_copy_queues(scsi_qla_host_t *vha, void *ptr)
+qla2xxx_copy_queues(struct qla_hw_data *ha, void *ptr)
 {
-	struct req_que *req = vha->hw->req;
-	struct rsp_que *rsp = vha->hw->rsp;
-
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 	/* Request queue. */
 	memcpy(ptr, req->ring, req->length *
 	    sizeof(request_t));
@@ -327,6 +326,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
 	void		*nxt;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	flags = 0;
 
@@ -461,7 +461,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		    ha->fw_memory_size - 0x11000 + 1, &nxt);
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(vha, nxt);
+		qla2xxx_copy_queues(ha, nxt);
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
@@ -471,7 +471,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    vha->host_no, ha->fw_dump);
+		    base_vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -497,6 +497,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2100_fw_dump	*fw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	risc_address = 0;
 	mb0 = mb2 = 0;
@@ -667,7 +668,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(vha, &fw->risc_ram[cnt]);
+		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
@@ -677,7 +678,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    vha->host_no, ha->fw_dump);
+		    base_vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -701,6 +702,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	struct qla24xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
 	void		*nxt;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
@@ -910,7 +912,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval != QLA_SUCCESS)
 		goto qla24xx_fw_dump_failed_0;
 
-	nxt = qla2xxx_copy_queues(vha, nxt);
+	nxt = qla2xxx_copy_queues(ha, nxt);
 	if (ha->eft)
 		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 
@@ -923,7 +925,7 @@ qla24xx_fw_dump_failed_0:
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    vha->host_no, ha->fw_dump);
+		    base_vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -940,6 +942,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	struct device_reg_25xxmq __iomem *reg25;
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
 	uint16_t __iomem *mbx_reg;
@@ -948,6 +951,11 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t	ext_mem_cnt;
 	void		*nxt;
 	struct qla2xxx_fce_chain *fcec;
+	struct qla2xxx_mq_chain *mq = NULL;
+	uint32_t	qreg_size;
+	uint8_t		req_cnt, rsp_cnt, que_cnt;
+	uint32_t	que_idx;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
@@ -992,6 +1000,29 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	fw->pcie_regs[1] = htonl(RD_REG_DWORD(dmp_reg++));
 	fw->pcie_regs[2] = htonl(RD_REG_DWORD(dmp_reg));
 	fw->pcie_regs[3] = htonl(RD_REG_DWORD(&reg->iobase_window));
+
+	/* Multi queue registers */
+	if (ha->mqenable) {
+		qreg_size = sizeof(struct qla2xxx_mq_chain);
+		mq = kzalloc(qreg_size, GFP_KERNEL);
+		if (!mq)
+			goto qla25xx_fw_dump_failed_0;
+		req_cnt = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
+		rsp_cnt = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
+		que_cnt = req_cnt > rsp_cnt ? req_cnt : rsp_cnt;
+		mq->count = htonl(que_cnt);
+		mq->chain_size = htonl(qreg_size);
+		mq->type = __constant_htonl(DUMP_CHAIN_MQ);
+		for (cnt = 0; cnt < que_cnt; cnt++) {
+			reg25 = (struct device_reg_25xxmq *) ((void *)
+				ha->mqiobase + cnt * QLA_QUE_PAGE);
+			que_idx = cnt * 4;
+			mq->qregs[que_idx] = htonl(reg25->req_q_in);
+			mq->qregs[que_idx+1] = htonl(reg25->req_q_out);
+			mq->qregs[que_idx+2] = htonl(reg25->rsp_q_in);
+			mq->qregs[que_idx+3] = htonl(reg25->rsp_q_out);
+		}
+	}
 	WRT_REG_DWORD(&reg->iobase_window, 0x00);
 	RD_REG_DWORD(&reg->iobase_window);
 
@@ -1219,7 +1250,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		goto qla25xx_fw_dump_failed_0;
 
 	/* Fibre Channel Trace Buffer. */
-	nxt = qla2xxx_copy_queues(vha, nxt);
+	nxt = qla2xxx_copy_queues(ha, nxt);
 	if (ha->eft)
 		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 
@@ -1229,7 +1260,14 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
 
-	fcec = nxt + ntohl(ha->fw_dump->eft_size);
+	if (ha->mqenable) {
+		nxt = nxt + ntohl(ha->fw_dump->eft_size);
+		memcpy(nxt, mq, qreg_size);
+		kfree(mq);
+		fcec = nxt + qreg_size;
+	} else {
+		fcec = nxt + ntohl(ha->fw_dump->eft_size);
+	}
 	fcec->type = __constant_htonl(DUMP_CHAIN_FCE | DUMP_CHAIN_LAST);
 	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
 	    fce_calc_size(ha->fce_bufs));
@@ -1252,7 +1290,7 @@ qla25xx_fw_dump_failed_0:
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    vha->host_no, ha->fw_dump);
+		    base_vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -1260,7 +1298,6 @@ qla25xx_fw_dump_failed:
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
-
 /****************************************************************************/
 /*                         Driver Debug Functions.                          */
 /****************************************************************************/
@@ -1307,3 +1344,5 @@ qla2x00_dump_buffer(uint8_t * b, uint32_t size)
 	if (cnt % 16)
 		printk("\n");
 }
+
+
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 2e9c0c0..c1794a7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -4,6 +4,9 @@
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
+
+#include "qla_def.h"
+
 /*
  * Driver debug definitions.
  */
@@ -23,6 +26,7 @@
 /* #define QL_DEBUG_LEVEL_14 */ /* Output RSCN trace msgs */
 /* #define QL_DEBUG_LEVEL_15 */ /* Output NPIV trace msgs */
 /* #define QL_DEBUG_LEVEL_16 */ /* Output ISP84XX trace msgs */
+/* #define QL_DEBUG_LEVEL_17 */ /* Output MULTI-Q trace messages */
 
 /*
 * Macros use for debugging the driver.
@@ -43,6 +47,7 @@
 #define DEBUG2_11(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
 #define DEBUG2_13(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
 #define DEBUG2_16(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
+#define DEBUG2_17(x) 	do { if (ql2xextended_error_logging) { x; } } while (0)
 
 #if defined(QL_DEBUG_LEVEL_3)
 #define DEBUG3(x)	do {x;} while (0)
@@ -127,7 +132,6 @@
 #else
 #define DEBUG16(x)	do {} while (0)
 #endif
-
 /*
  * Firmware Dump structure definition
  */
@@ -266,8 +270,17 @@ struct qla2xxx_fce_chain {
 	uint32_t eregs[8];
 };
 
+struct qla2xxx_mq_chain {
+	uint32_t type;
+	uint32_t chain_size;
+
+	uint32_t count;
+	uint32_t qregs[4 * QLA_MQ_SIZE];
+};
+
 #define DUMP_CHAIN_VARIANT	0x80000000
 #define DUMP_CHAIN_FCE		0x7FFFFAF0
+#define DUMP_CHAIN_MQ		0x7FFFFAF1
 #define DUMP_CHAIN_LAST		0x80000000
 
 struct qla2xxx_fw_dump {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index edead28..5ecf292 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -369,9 +369,17 @@ struct device_reg_2xxx {
 	} u_end;
 };
 
+struct device_reg_25xxmq {
+	volatile uint32_t req_q_in;
+	volatile uint32_t req_q_out;
+	volatile uint32_t rsp_q_in;
+	volatile uint32_t rsp_q_out;
+};
+
 typedef union {
 		struct device_reg_2xxx isp;
 		struct device_reg_24xx isp24;
+		struct device_reg_25xxmq isp25mq;
 } device_reg_t;
 
 #define ISP_REQ_Q_IN(ha, reg) \
@@ -2037,6 +2045,7 @@ typedef struct vport_params {
 #define VP_RET_CODE_NOT_FOUND		6
 
 struct qla_hw_data;
+struct req_que;
 
 /*
  * ISP operations
@@ -2059,7 +2068,8 @@ struct isp_operations {
 	void (*enable_intrs) (struct qla_hw_data *);
 	void (*disable_intrs) (struct qla_hw_data *);
 
-	int (*abort_command) (struct scsi_qla_host *, srb_t *);
+	int (*abort_command) (struct scsi_qla_host *, srb_t *,
+		struct req_que *);
 	int (*target_reset) (struct fc_port *, unsigned int);
 	int (*lun_reset) (struct fc_port *, unsigned int);
 	int (*fabric_login) (struct scsi_qla_host *, uint16_t, uint8_t,
@@ -2102,16 +2112,18 @@ struct isp_operations {
 #define QLA_MSIX_DEFAULT	0x00
 #define QLA_MSIX_RSP_Q		0x01
 
-#define QLA_MSIX_ENTRIES	2
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
+#define QLA_PCI_MSIX_CONTROL	0xa2
 
 struct scsi_qla_host;
+struct rsp_que;
 
 struct qla_msix_entry {
 	int have_irq;
-	uint32_t msix_vector;
-	uint16_t msix_entry;
+	uint32_t vector;
+	uint16_t entry;
+	struct rsp_que *rsp;
 };
 
 #define	WATCH_INTERVAL		1       /* number of seconds */
@@ -2162,6 +2174,23 @@ struct qla_statistics {
 	uint64_t output_bytes;
 };
 
+/* Multi queue support */
+#define MBC_INITIALIZE_MULTIQ 0x1f
+#define QLA_QUE_PAGE 0X1000
+#define QLA_MQ_SIZE 32
+#define QLA_MAX_HOST_QUES 16
+#define QLA_MAX_QUEUES 256
+#define ISP_QUE_REG(ha, id) \
+	((ha->mqenable) ? \
+	((void *)(ha->mqiobase) +\
+	(QLA_QUE_PAGE * id)) :\
+	((void *)(ha->iobase)))
+#define QLA_REQ_QUE_ID(tag) \
+	((tag < QLA_MAX_QUEUES && tag > 0) ? tag : 0)
+#define QLA_DEFAULT_QUE_QOS 5
+#define QLA_PRECONFIG_VPORTS 32
+#define QLA_MAX_VPORTS_QLA24XX	128
+#define QLA_MAX_VPORTS_QLA25XX	256
 /* Response queue data structure */
 struct rsp_que {
 	dma_addr_t  dma;
@@ -2171,9 +2200,12 @@ struct rsp_que {
 	uint16_t  out_ptr;
 	uint16_t  length;
 	uint16_t  options;
-	uint16_t  msix_vector;
 	uint16_t  rid;
+	uint16_t  id;
+	uint16_t  vp_idx;
 	struct qla_hw_data *hw;
+	struct qla_msix_entry *msix;
+	struct req_que *req;
 };
 
 /* Request queue data structure */
@@ -2187,10 +2219,10 @@ struct req_que {
 	uint16_t  length;
 	uint16_t  options;
 	uint16_t  rid;
+	uint16_t  id;
 	uint16_t  qos;
 	uint16_t  vp_idx;
-	struct rsp_que *asso_que;
-	/* Outstandings ISP commands. */
+	struct rsp_que *rsp;
 	srb_t *outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
 	uint32_t current_outstanding_cmd;
 	int max_q_depth;
@@ -2240,8 +2272,17 @@ struct qla_hw_data {
 	resource_size_t pio_address;
 
 #define MIN_IOBASE_LEN          0x100
-	struct req_que *req;
-	struct rsp_que *rsp;
+/* Multi queue data structs */
+	device_reg_t    *mqiobase;
+	uint16_t        msix_count;
+	uint8_t         mqenable;
+	struct req_que **req_q_map;
+	struct rsp_que **rsp_q_map;
+	unsigned long req_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
+	unsigned long rsp_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
+	uint16_t 	max_queues;
+	struct qla_npiv_entry *npiv_info;
+	uint16_t	nvram_npiv_size;
 
 	uint16_t        switch_cap;
 #define FLOGI_SEQ_DEL           BIT_8
@@ -2502,7 +2543,7 @@ struct qla_hw_data {
 	uint16_t        zio_timer;
 	struct fc_host_statistics fc_host_stat;
 
-	struct qla_msix_entry msix_entries[QLA_MSIX_ENTRIES];
+	struct qla_msix_entry *msix_entries;
 
 	struct list_head        vp_list;        /* list of VP */
 	unsigned long   vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) /
@@ -2524,7 +2565,6 @@ typedef struct scsi_qla_host {
 	struct list_head list;
 	struct list_head vp_fcports;	/* list of fcports */
 	struct list_head work_list;
-
 	/* Commonly used flags and state information. */
 	struct Scsi_Host *host;
 	unsigned long	host_no;
@@ -2640,9 +2680,9 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
 	struct qla_hw_data *hw;
+	int	req_ques[QLA_MAX_HOST_QUES];
 } scsi_qla_host_t;
 
-
 /*
  * Macros to help code, maintain, etc.
  */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index d1d1420..ee1f1e7 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -299,7 +299,8 @@ struct init_cb_24xx {
 	uint32_t response_q_address[2];
 	uint32_t prio_request_q_address[2];
 
-	uint8_t reserved_2[8];
+	uint16_t msix;
+	uint8_t reserved_2[6];
 
 	uint16_t atio_q_inpointer;
 	uint16_t atio_q_length;
@@ -372,8 +373,9 @@ struct init_cb_24xx {
 	 * BIT 17-31 = Reserved
 	 */
 	uint32_t firmware_options_3;
-
-	uint8_t  reserved_3[24];
+	uint16_t qos;
+	uint16_t rid;
+	uint8_t  reserved_3[20];
 };
 
 /*
@@ -754,7 +756,8 @@ struct abort_entry_24xx {
 
 	uint32_t handle_to_abort;	/* System handle to abort. */
 
-	uint8_t reserved_1[32];
+	uint16_t req_que_no;
+	uint8_t reserved_1[30];
 
 	uint8_t port_id[3];		/* PortID of destination port. */
 	uint8_t vp_index;
@@ -1258,7 +1261,8 @@ struct qla_npiv_header {
 struct qla_npiv_entry {
 	uint16_t flags;
 	uint16_t vf_id;
-	uint16_t qos;
+	uint8_t q_qos;
+	uint8_t f_qos;
 	uint16_t unused1;
 	uint8_t port_name[WWN_SIZE];
 	uint8_t node_name[WWN_SIZE];
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c0cc686..d9712b5 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -63,6 +63,7 @@ extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
 extern int ql2xiidmaenable;
+extern int ql2xmaxqueues;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -97,7 +98,7 @@ extern void qla2x00_do_dpc_all_vps(scsi_qla_host_t *);
 extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t * qla24xx_create_vhost(struct fc_vport *);
 
-extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
+extern void qla2x00_sp_compl(struct qla_hw_data *, srb_t *);
 
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
@@ -109,8 +110,9 @@ extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
 
 extern void qla2xxx_wake_dpc(struct scsi_qla_host *);
-extern void qla2x00_alert_all_vps(struct qla_hw_data *, uint16_t *);
-extern void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
+extern void qla2x00_alert_all_vps(struct rsp_que *, uint16_t *);
+extern void qla2x00_async_event(scsi_qla_host_t *, struct rsp_que *,
+	uint16_t *);
 extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
 
 /*
@@ -122,8 +124,10 @@ extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
 extern void qla2x00_build_scsi_iocbs_64(srb_t *, cmd_entry_t *, uint16_t);
 extern int qla2x00_start_scsi(srb_t *sp);
 extern int qla24xx_start_scsi(srb_t *sp);
-int qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
-int __qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
+int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
+						uint16_t, uint16_t, uint8_t);
+int __qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
+						uint16_t, uint16_t, uint8_t);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -157,7 +161,7 @@ extern int
 qla2x00_issue_iocb(scsi_qla_host_t *, void *, dma_addr_t, size_t);
 
 extern int
-qla2x00_abort_command(scsi_qla_host_t *, srb_t *);
+qla2x00_abort_command(scsi_qla_host_t *, srb_t *, struct req_que *);
 
 extern int
 qla2x00_abort_target(struct fc_port *, unsigned int);
@@ -228,7 +232,7 @@ extern int
 qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
     dma_addr_t);
 
-extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *);
+extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *, struct req_que *);
 extern int qla24xx_abort_target(struct fc_port *, unsigned int);
 extern int qla24xx_lun_reset(struct fc_port *, unsigned int);
 
@@ -267,10 +271,10 @@ extern int qla84xx_verify_chip(struct scsi_qla_host *, uint16_t *);
 extern irqreturn_t qla2100_intr_handler(int, void *);
 extern irqreturn_t qla2300_intr_handler(int, void *);
 extern irqreturn_t qla24xx_intr_handler(int, void *);
-extern void qla2x00_process_response_queue(struct scsi_qla_host *);
-extern void qla24xx_process_response_queue(struct scsi_qla_host *);
+extern void qla2x00_process_response_queue(struct rsp_que *);
+extern void qla24xx_process_response_queue(struct rsp_que *);
 
-extern int qla2x00_request_irqs(struct qla_hw_data *);
+extern int qla2x00_request_irqs(struct qla_hw_data *, struct rsp_que *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
 
 /*
@@ -370,4 +374,21 @@ extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
  */
 extern int qla2x00_dfs_setup(scsi_qla_host_t *);
 extern int qla2x00_dfs_remove(scsi_qla_host_t *);
+
+/* Globa function prototypes for multi-q */
+extern int qla25xx_request_irq(struct rsp_que *);
+extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *,
+	uint8_t);
+extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *,
+	uint8_t);
+extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
+	uint16_t, uint8_t, uint8_t);
+extern int qla25xx_create_rsp_que(struct qla_hw_data *, uint16_t, uint8_t,
+	uint16_t);
+extern int qla25xx_update_req_que(struct scsi_qla_host *, uint8_t, uint8_t);
+extern void qla2x00_init_response_q_entries(struct rsp_que *);
+extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
+extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
+extern int qla25xx_create_queues(struct scsi_qla_host *, uint8_t);
+extern int qla25xx_delete_queues(struct scsi_qla_host *, uint8_t);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index db8de06..0a6f729 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1668,12 +1668,6 @@ qla2x00_fdmi_register(scsi_qla_host_t *vha)
 {
 	int rval;
 
-	if (IS_QLA2100(vha->hw) || IS_QLA2200(vha->hw)) {
-		DEBUG2(printk("scsi(%ld): FDMI unsupported on "
-		    "ISP2100/ISP2200.\n", vha->host_no));
-		return QLA_SUCCESS;
-	}
-
 	rval = qla2x00_mgmt_svr_login(vha);
 	if (rval)
 		return rval;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7bee87f..b1495ec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_gbl.h"
 
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
@@ -21,7 +22,6 @@
 static int qla2x00_isp_firmware(scsi_qla_host_t *);
 static void qla2x00_resize_request_q(scsi_qla_host_t *);
 static int qla2x00_setup_chip(scsi_qla_host_t *);
-static void qla2x00_init_response_q_entries(scsi_qla_host_t *);
 static int qla2x00_init_rings(scsi_qla_host_t *);
 static int qla2x00_fw_ready(scsi_qla_host_t *);
 static int qla2x00_configure_hba(scsi_qla_host_t *);
@@ -39,6 +39,7 @@ static int qla2x00_find_new_loop_id(scsi_qla_host_t *, fc_port_t *);
 
 static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
+static int qla25xx_init_queues(struct qla_hw_data *);
 
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
@@ -59,6 +60,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 {
 	int	rval;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
 	/* Clear adapter flags. */
 	vha->flags.online = 0;
 	vha->flags.reset_active = 0;
@@ -73,6 +75,9 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	ha->beacon_blink_led = 0;
 	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 
+	set_bit(0, ha->req_qid_map);
+	set_bit(0, ha->rsp_qid_map);
+
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 	rval = ha->isp_ops->pci_config(vha);
 	if (rval) {
@@ -90,7 +95,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		return (rval);
 	}
 
-	ha->isp_ops->get_flash_version(vha, ha->req->ring);
+	ha->isp_ops->get_flash_version(vha, req->ring);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 
@@ -603,6 +608,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	uint16_t	data;
 	uint32_t	cnt;
 	uint16_t	mb[5];
+	struct req_que *req = ha->req_q_map[0];
 
 	/* Assume a failed state */
 	rval = QLA_FUNCTION_FAILED;
@@ -671,11 +677,11 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	ha->product_id[3] = mb[4];
 
 	/* Adjust fw RISC transfer size */
-	if (ha->req->length > 1024)
+	if (req->length > 1024)
 		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
 	else
 		ha->fw_transfer_size = REQUEST_ENTRY_SIZE *
-		    ha->req->length;
+		    req->length;
 
 	if (IS_QLA2200(ha) &&
 	    RD_MAILBOX_REG(ha, reg, 7) == QLA2200A_RISC_ROM_VER) {
@@ -725,11 +731,12 @@ qla24xx_chip_diag(scsi_qla_host_t *vha)
 {
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
 
 	/* Perform RISC reset. */
 	qla24xx_reset_risc(vha);
 
-	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * ha->req->length;
+	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * req->length;
 
 	rval = qla2x00_mbx_reg_test(vha);
 	if (rval) {
@@ -750,10 +757,12 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint32_t dump_size, fixed_size, mem_size, req_q_size, rsp_q_size,
-	    eft_size, fce_size;
+	    eft_size, fce_size, mq_size;
 	dma_addr_t tc_dma;
 	void *tc;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	if (ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha,
@@ -762,7 +771,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	}
 
 	ha->fw_dumped = 0;
-	fixed_size = mem_size = eft_size = fce_size = 0;
+	fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		fixed_size = sizeof(struct qla2100_fw_dump);
 	} else if (IS_QLA23XX(ha)) {
@@ -771,10 +780,12 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
 		fixed_size = IS_QLA25XX(ha) ?
-		    offsetof(struct qla25xx_fw_dump, ext_mem):
-		    offsetof(struct qla24xx_fw_dump, ext_mem);
+			offsetof(struct qla25xx_fw_dump, ext_mem) :
+			offsetof(struct qla24xx_fw_dump, ext_mem);
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
+		if (ha->mqenable)
+			mq_size = sizeof(struct qla2xxx_mq_chain);
 
 		/* Allocate memory for Fibre Channel Event Buffer. */
 		if (!IS_QLA25XX(ha))
@@ -785,7 +796,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		if (!tc) {
 			qla_printk(KERN_WARNING, ha, "Unable to allocate "
 			    "(%d KB) for FCE.\n", FCE_SIZE / 1024);
-			goto try_eft;
+			goto cont_alloc;
 		}
 
 		memset(tc, 0, FCE_SIZE);
@@ -797,7 +808,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc,
 			    tc_dma);
 			ha->flags.fce_enabled = 0;
-			goto try_eft;
+			goto cont_alloc;
 		}
 
 		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
@@ -835,12 +846,12 @@ try_eft:
 		ha->eft = tc;
 	}
 cont_alloc:
-	req_q_size = ha->req->length * sizeof(request_t);
-	rsp_q_size = ha->rsp->length * sizeof(response_t);
+	req_q_size = req->length * sizeof(request_t);
+	rsp_q_size = rsp->length * sizeof(response_t);
 
 	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
-	    eft_size + fce_size;
+	    mq_size + eft_size + fce_size;
 
 	ha->fw_dump = vmalloc(dump_size);
 	if (!ha->fw_dump) {
@@ -855,7 +866,6 @@ cont_alloc:
 		}
 		return;
 	}
-
 	qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware dump...\n",
 	    dump_size / 1024);
 
@@ -894,7 +904,7 @@ qla2x00_resize_request_q(scsi_qla_host_t *vha)
 	dma_addr_t request_dma;
 	request_t *request_ring;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req = ha->req_q_map[0];
 
 	/* Valid only on recent ISPs. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
@@ -1030,12 +1040,11 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
  *
  * Returns 0 on success.
  */
-static void
-qla2x00_init_response_q_entries(scsi_qla_host_t *vha)
+void
+qla2x00_init_response_q_entries(struct rsp_que *rsp)
 {
 	uint16_t cnt;
 	response_t *pkt;
-	struct rsp_que *rsp = vha->hw->rsp;
 
 	pkt = rsp->ring_ptr;
 	for (cnt = 0; cnt < rsp->length; cnt++) {
@@ -1151,8 +1160,8 @@ qla2x00_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	struct req_que *req = ha->req;
-	struct rsp_que *rsp = ha->rsp;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	/* Setup ring parameters in initialization control block. */
 	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
@@ -1175,12 +1184,15 @@ void
 qla24xx_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	device_reg_t __iomem *reg = ISP_QUE_REG(ha, 0);
+	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
+	struct qla_msix_entry *msix;
 	struct init_cb_24xx *icb;
-	struct req_que *req = ha->req;
-	struct rsp_que *rsp = ha->rsp;
+	uint16_t rid = 0;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
-	/* Setup ring parameters in initialization control block. */
+/* Setup ring parameters in initialization control block. */
 	icb = (struct init_cb_24xx *)ha->init_cb;
 	icb->request_q_outpointer = __constant_cpu_to_le16(0);
 	icb->response_q_inpointer = __constant_cpu_to_le16(0);
@@ -1191,11 +1203,40 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
 	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
-	WRT_REG_DWORD(&reg->req_q_in, 0);
-	WRT_REG_DWORD(&reg->req_q_out, 0);
-	WRT_REG_DWORD(&reg->rsp_q_in, 0);
-	WRT_REG_DWORD(&reg->rsp_q_out, 0);
-	RD_REG_DWORD(&reg->rsp_q_out);
+	if (ha->mqenable) {
+		icb->qos = __constant_cpu_to_le16(QLA_DEFAULT_QUE_QOS);
+		icb->rid = __constant_cpu_to_le16(rid);
+		if (ha->flags.msix_enabled) {
+			msix = &ha->msix_entries[1];
+			DEBUG2_17(printk(KERN_INFO
+			"Reistering vector 0x%x for base que\n", msix->entry));
+			icb->msix = cpu_to_le16(msix->entry);
+		}
+		/* Use alternate PCI bus number */
+		if (MSB(rid))
+			icb->firmware_options_2 |=
+				__constant_cpu_to_le32(BIT_19);
+		/* Use alternate PCI devfn */
+		if (LSB(rid))
+			icb->firmware_options_2 |=
+				__constant_cpu_to_le32(BIT_18);
+
+		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_22);
+		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_23);
+		ha->rsp_q_map[0]->options = icb->firmware_options_2;
+
+		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
+		WRT_REG_DWORD(&reg->isp25mq.req_q_out, 0);
+		WRT_REG_DWORD(&reg->isp25mq.rsp_q_in, 0);
+		WRT_REG_DWORD(&reg->isp25mq.rsp_q_out, 0);
+	} else {
+		WRT_REG_DWORD(&reg->isp24.req_q_in, 0);
+		WRT_REG_DWORD(&reg->isp24.req_q_out, 0);
+		WRT_REG_DWORD(&reg->isp24.rsp_q_in, 0);
+		WRT_REG_DWORD(&reg->isp24.rsp_q_out, 0);
+	}
+	/* PCI posting */
+	RD_REG_DWORD(&ioreg->hccr);
 }
 
 /**
@@ -1214,8 +1255,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	unsigned long flags = 0;
 	int cnt;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
-	struct rsp_que *rsp = ha->rsp;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct mid_init_cb_24xx *mid_init_cb =
 	    (struct mid_init_cb_24xx *) ha->init_cb;
 
@@ -1239,7 +1280,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	rsp->ring_index    = 0;
 
 	/* Initialize response queue entries */
-	qla2x00_init_response_q_entries(vha);
+	qla2x00_init_response_q_entries(rsp);
 
 	ha->isp_ops->config_rings(vha);
 
@@ -2039,10 +2080,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 		if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-		if (test_bit(RSCN_UPDATE, &save_flags)) {
+		if (test_bit(RSCN_UPDATE, &save_flags))
 			set_bit(RSCN_UPDATE, &vha->dpc_flags);
-			vha->flags.rscn_queue_overflow = 1;
-		}
 	}
 
 	return (rval);
@@ -3169,10 +3208,11 @@ qla2x00_local_device_login(scsi_qla_host_t *vha, fc_port_t *fcport)
 int
 qla2x00_loop_resync(scsi_qla_host_t *vha)
 {
-	int   rval;
+	int rval = QLA_SUCCESS;
 	uint32_t wait_time;
-
-	rval = QLA_SUCCESS;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
@@ -3184,7 +3224,8 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 				atomic_set(&vha->loop_state, LOOP_UPDATE);
 
 				/* Issue a marker after FW becomes ready. */
-				qla2x00_marker(vha, 0, 0, MK_SYNC_ALL);
+				qla2x00_marker(vha, req, rsp, 0, 0,
+					MK_SYNC_ALL);
 				vha->marker_needed = 0;
 
 				/* Remap devices on Loop. */
@@ -3237,6 +3278,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
+	struct req_que *req = ha->req_q_map[0];
 
 	if (vha->flags.online) {
 		vha->flags.online = 0;
@@ -3262,7 +3304,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 
-		ha->isp_ops->get_flash_version(vha, ha->req->ring);
+		ha->isp_ops->get_flash_version(vha, req->ring);
 
 		ha->isp_ops->nvram_config(vha);
 
@@ -3376,6 +3418,8 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 	uint8_t		status = 0;
 	uint32_t wait_time;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(vha)) {
@@ -3387,13 +3431,16 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 
 	if (!status && !(status = qla2x00_init_rings(vha))) {
 		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+		/* Initialize the queues in use */
+		qla25xx_init_queues(ha);
+
 		status = qla2x00_fw_ready(vha);
 		if (!status) {
 			DEBUG(printk("%s(): Start configure loop, "
 			    "status = %d\n", __func__, status));
 
 			/* Issue a marker after FW becomes ready. */
-			qla2x00_marker(vha, 0, 0, MK_SYNC_ALL);
+			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
 
 			vha->flags.online = 1;
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
@@ -3419,6 +3466,46 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 	return (status);
 }
 
+static int
+qla25xx_init_queues(struct qla_hw_data *ha)
+{
+	struct rsp_que *rsp = NULL;
+	struct req_que *req = NULL;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	int ret = -1;
+	int i;
+
+	for (i = 1; i < ha->max_queues; i++) {
+		rsp = ha->rsp_q_map[i];
+		if (rsp) {
+			rsp->options &= ~BIT_0;
+			ret = qla25xx_init_rsp_que(base_vha, rsp, rsp->options);
+			if (ret != QLA_SUCCESS)
+				DEBUG2_17(printk(KERN_WARNING
+					"%s Rsp que:%d init failed\n", __func__,
+						rsp->id));
+			else
+				DEBUG2_17(printk(KERN_INFO
+					"%s Rsp que:%d inited\n", __func__,
+						rsp->id));
+		}
+		req = ha->req_q_map[i];
+		if (req) {
+			req->options &= ~BIT_0;
+			ret = qla25xx_init_req_que(base_vha, req, req->options);
+			if (ret != QLA_SUCCESS)
+				DEBUG2_17(printk(KERN_WARNING
+					"%s Req que:%d init failed\n", __func__,
+						req->id));
+			else
+				DEBUG2_17(printk(KERN_WARNING
+					"%s Rsp que:%d inited\n", __func__,
+						req->id));
+		}
+	}
+	return ret;
+}
+
 /*
 * qla2x00_reset_adapter
 *      Reset adapter.
@@ -3736,7 +3823,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 static int
 qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
-	int	rval;
+	int	rval = QLA_SUCCESS;
 	int	segments, fragment;
 	uint32_t faddr;
 	uint32_t *dcode, dlen;
@@ -3744,11 +3831,12 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	uint32_t risc_size;
 	uint32_t i;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
 	faddr = ha->flt_region_fw;
-	dcode = (uint32_t *)ha->req->ring;
+	dcode = (uint32_t *)req->ring;
 	*srisc_addr = 0;
 
 	/* Validate firmware image by checking version. */
@@ -3790,7 +3878,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(dcode[i]);
 
-			rval = qla2x00_load_ram(vha, ha->req->dma, risc_addr,
+			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
 			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
@@ -3826,6 +3914,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	uint32_t risc_addr, risc_size, fwclen, wlen, *seg;
 	struct fw_blob *blob;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
 
 	/* Load firmware blob. */
 	blob = qla2x00_request_firmware(vha);
@@ -3838,7 +3927,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 
 	rval = QLA_SUCCESS;
 
-	wcode = (uint16_t *)ha->req->ring;
+	wcode = (uint16_t *)req->ring;
 	*srisc_addr = 0;
 	fwcode = (uint16_t *)blob->fw->data;
 	fwclen = 0;
@@ -3891,7 +3980,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			for (i = 0; i < wlen; i++)
 				wcode[i] = swab16(fwcode[i]);
 
-			rval = qla2x00_load_ram(vha, ha->req->dma, risc_addr,
+			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
 			    wlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
@@ -3930,6 +4019,7 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	struct fw_blob *blob;
 	uint32_t *fwcode, fwclen;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
 
 	/* Load firmware blob. */
 	blob = qla2x00_request_firmware(vha);
@@ -3947,7 +4037,7 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
-	dcode = (uint32_t *)ha->req->ring;
+	dcode = (uint32_t *)req->ring;
 	*srisc_addr = 0;
 	fwcode = (uint32_t *)blob->fw->data;
 	fwclen = 0;
@@ -4001,7 +4091,7 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(fwcode[i]);
 
-			rval = qla2x00_load_ram(vha, ha->req->dma, risc_addr,
+			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
 			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
@@ -4060,6 +4150,8 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	if (!vha->vp_idx)
 		return -EINVAL;
@@ -4067,7 +4159,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	rval = qla2x00_fw_ready(base_vha);
 	if (rval == QLA_SUCCESS) {
 		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
-		qla2x00_marker(vha, 0, 0, MK_SYNC_ALL);
+		qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
 	}
 
 	vha->flags.management_server_logged_in = 0;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 8ce3547..507a6e9 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -41,32 +41,6 @@ qla2x00_poll(struct rsp_que *rsp)
 	local_irq_restore(flags);
 }
 
-/**
- * qla2x00_issue_marker() - Issue a Marker IOCB if necessary.
- * @ha: HA context
- * @ha_locked: is function called with the hardware lock
- *
- * Returns non-zero if a failure occurred, else zero.
- */
-static inline int
-qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
-{
-	/* Send marker if required */
-	if (vha->marker_needed != 0) {
-		if (ha_locked) {
-			if (__qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) !=
-			    QLA_SUCCESS)
-				return (QLA_FUNCTION_FAILED);
-		} else {
-			if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) !=
-			    QLA_SUCCESS)
-				return (QLA_FUNCTION_FAILED);
-		}
-		vha->marker_needed = 0;
-	}
-	return (QLA_SUCCESS);
-}
-
 static inline uint8_t *
 host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0c145c9..6d2bd97 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,8 +11,9 @@
 
 #include <scsi/scsi_tcq.h>
 
-static request_t *qla2x00_req_pkt(scsi_qla_host_t *);
-static void qla2x00_isp_cmd(scsi_qla_host_t *);
+static request_t *qla2x00_req_pkt(struct scsi_qla_host *, struct req_que *,
+							struct rsp_que *rsp);
+static void qla2x00_isp_cmd(struct scsi_qla_host *, struct req_que *);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -91,10 +92,9 @@ qla2x00_calc_iocbs_64(uint16_t dsds)
  * Returns a pointer to the Continuation Type 0 IOCB packet.
  */
 static inline cont_entry_t *
-qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *vha)
+qla2x00_prep_cont_type0_iocb(struct req_que *req, struct scsi_qla_host *vha)
 {
 	cont_entry_t *cont_pkt;
-	struct req_que *req = vha->hw->req;
 	/* Adjust ring index. */
 	req->ring_index++;
 	if (req->ring_index == req->length) {
@@ -120,10 +120,9 @@ qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *vha)
  * Returns a pointer to the continuation type 1 IOCB packet.
  */
 static inline cont_a64_entry_t *
-qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha)
+qla2x00_prep_cont_type1_iocb(struct req_que *req, scsi_qla_host_t *vha)
 {
 	cont_a64_entry_t *cont_pkt;
-	struct req_que *req = vha->hw->req;
 
 	/* Adjust ring index. */
 	req->ring_index++;
@@ -160,6 +159,8 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
+	struct req_que *req;
+	uint16_t que_id;
 
 	cmd = sp->cmd;
 
@@ -174,6 +175,8 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->vha;
+	que_id = vha->req_ques[0];
+	req = vha->hw->req_q_map[que_id];
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -191,7 +194,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Seven DSDs are available in the Continuation
 			 * Type 0 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type0_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type0_iocb(req, vha);
 			cur_dsd = (uint32_t *)&cont_pkt->dseg_0_address;
 			avail_dsds = 7;
 		}
@@ -219,6 +222,8 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
+	struct req_que *req;
+	uint16_t que_id;
 
 	cmd = sp->cmd;
 
@@ -233,6 +238,8 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->vha;
+	que_id = vha->req_ques[0];
+	req = vha->hw->req_q_map[que_id];
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -251,7 +258,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(req, vha);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -287,6 +294,7 @@ qla2x00_start_scsi(srb_t *sp)
 	struct device_reg_2xxx __iomem *reg;
 	struct qla_hw_data *ha;
 	struct req_que *req;
+	struct rsp_que *rsp;
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -294,13 +302,15 @@ qla2x00_start_scsi(srb_t *sp)
 	ha = vha->hw;
 	reg = &ha->iobase->isp;
 	cmd = sp->cmd;
-	req = ha->req;
+	req = ha->req_q_map[0];
+	rsp = ha->rsp_q_map[0];
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS)
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL)
+							!= QLA_SUCCESS)
 			return (QLA_FUNCTION_FAILED);
 		vha->marker_needed = 0;
 	}
@@ -392,8 +402,8 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
-	    ha->rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla2x00_process_response_queue(vha);
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla2x00_process_response_queue(rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -419,8 +429,9 @@ queuing_error:
  * Returns non-zero if a failure occurred, else zero.
  */
 int
-__qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
-    uint8_t type)
+__qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
+			struct rsp_que *rsp, uint16_t loop_id,
+			uint16_t lun, uint8_t type)
 {
 	mrk_entry_t *mrk;
 	struct mrk_entry_24xx *mrk24;
@@ -428,7 +439,7 @@ __qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	mrk24 = NULL;
-	mrk = (mrk_entry_t *)qla2x00_req_pkt(base_vha);
+	mrk = (mrk_entry_t *)qla2x00_req_pkt(vha, req, rsp);
 	if (mrk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Marker IOCB.\n",
 		    __func__, base_vha->host_no));
@@ -453,22 +464,22 @@ __qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
 	}
 	wmb();
 
-	qla2x00_isp_cmd(base_vha);
+	qla2x00_isp_cmd(vha, req);
 
 	return (QLA_SUCCESS);
 }
 
 int
-qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
-    uint8_t type)
+qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
+		struct rsp_que *rsp, uint16_t loop_id, uint16_t lun,
+		uint8_t type)
 {
 	int ret;
 	unsigned long flags = 0;
-	struct qla_hw_data *ha = vha->hw;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ret = __qla2x00_marker(vha, loop_id, lun, type);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	ret = __qla2x00_marker(vha, req, rsp, loop_id, lun, type);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
 	return (ret);
 }
@@ -482,27 +493,32 @@ qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
  * Returns NULL if function failed, else, a pointer to the request packet.
  */
 static request_t *
-qla2x00_req_pkt(scsi_qla_host_t *vha)
+qla2x00_req_pkt(struct scsi_qla_host *vha, struct req_que *req,
+		struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ha->iobase;
+	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
 	request_t	*pkt = NULL;
 	uint16_t	cnt;
 	uint32_t	*dword_ptr;
 	uint32_t	timer;
 	uint16_t	req_cnt = 1;
-	struct req_que *req = ha->req;
 
 	/* Wait 1 second for slot. */
 	for (timer = HZ; timer; timer--) {
 		if ((req_cnt + 2) >= req->cnt) {
 			/* Calculate number of free request entries. */
-			if (IS_FWI2_CAPABLE(ha))
-				cnt = (uint16_t)RD_REG_DWORD(
-				    &reg->isp24.req_q_out);
-			else
-				cnt = qla2x00_debounce_register(
-				    ISP_REQ_Q_OUT(ha, &reg->isp));
+			if (ha->mqenable)
+				cnt = (uint16_t)
+					RD_REG_DWORD(&reg->isp25mq.req_q_out);
+			else {
+				if (IS_FWI2_CAPABLE(ha))
+					cnt = (uint16_t)RD_REG_DWORD(
+						&reg->isp24.req_q_out);
+				else
+					cnt = qla2x00_debounce_register(
+						ISP_REQ_Q_OUT(ha, &reg->isp));
+			}
 			if  (req->ring_index < cnt)
 				req->cnt = cnt - req->ring_index;
 			else
@@ -536,7 +552,7 @@ qla2x00_req_pkt(scsi_qla_host_t *vha)
 		/* Check for pending interrupts. */
 		/* During init we issue marker directly */
 		if (!vha->marker_needed && !vha->flags.init_done)
-			qla2x00_poll(ha->rsp);
+			qla2x00_poll(rsp);
 		spin_lock_irq(&ha->hardware_lock);
 	}
 	if (!pkt) {
@@ -553,11 +569,10 @@ qla2x00_req_pkt(scsi_qla_host_t *vha)
  * Note: The caller must hold the hardware lock before calling this routine.
  */
 static void
-qla2x00_isp_cmd(scsi_qla_host_t *vha)
+qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ha->iobase;
-	struct req_que *req = ha->req;
+	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
 
 	DEBUG5(printk("%s(): IOCB data:\n", __func__));
 	DEBUG5(qla2x00_dump_buffer(
@@ -572,12 +587,17 @@ qla2x00_isp_cmd(scsi_qla_host_t *vha)
 		req->ring_ptr++;
 
 	/* Set chip new ring index. */
-	if (IS_FWI2_CAPABLE(ha)) {
-		WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
-		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
-	} else {
-		WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp), req->ring_index);
-		RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+	if (ha->mqenable)
+		RD_REG_DWORD(&reg->isp25mq.req_q_out);
+	else {
+		if (IS_FWI2_CAPABLE(ha)) {
+			WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
+			RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+		} else {
+			WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp),
+				req->ring_index);
+			RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+		}
 	}
 
 }
@@ -622,6 +642,8 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
+	uint16_t que_id;
+	struct req_que *req;
 
 	cmd = sp->cmd;
 
@@ -636,6 +658,8 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 
 	vha = sp->vha;
+	que_id = vha->req_ques[0];
+	req = vha->hw->req_q_map[que_id];
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -666,7 +690,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(req, vha);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -691,8 +715,6 @@ qla24xx_start_scsi(srb_t *sp)
 {
 	int		ret, nseg;
 	unsigned long   flags;
-	scsi_qla_host_t	*vha;
-	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
 	uint32_t	handle;
@@ -700,23 +722,32 @@ qla24xx_start_scsi(srb_t *sp)
 	uint16_t	cnt;
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
-	struct device_reg_24xx __iomem *reg;
-	struct qla_hw_data *ha;
-	struct req_que *req;
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
+	struct scsi_cmnd *cmd = sp->cmd;
+	struct scsi_qla_host *vha = sp->vha;
+	struct qla_hw_data *ha = vha->hw;
+	device_reg_t __iomem *reg;
+	uint16_t que_id;
 
 	/* Setup device pointers. */
 	ret = 0;
-	vha = sp->vha;
-	ha = vha->hw;
-	reg = &ha->iobase->isp24;
-	cmd = sp->cmd;
-	req = ha->req;
+	que_id = vha->req_ques[0];
+
+	req = ha->req_q_map[que_id];
+	reg = ISP_QUE_REG(ha, req->id);
+
+	if (req->rsp)
+		rsp = req->rsp;
+	else
+		rsp = ha->rsp_q_map[que_id];
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS)
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL)
+							!= QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
 		vha->marker_needed = 0;
 	}
@@ -749,7 +780,13 @@ qla24xx_start_scsi(srb_t *sp)
 
 	req_cnt = qla24xx_calc_iocbs(tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = (uint16_t)RD_REG_DWORD_RELAXED(&reg->req_q_out);
+		if (ha->mqenable)
+			cnt = (uint16_t)
+				RD_REG_DWORD_RELAXED(&reg->isp25mq.req_q_out);
+		else
+			cnt = (uint16_t)
+				RD_REG_DWORD_RELAXED(&reg->isp24.req_q_out);
+
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -809,13 +846,17 @@ qla24xx_start_scsi(srb_t *sp)
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(&reg->req_q_in, req->ring_index);
-	RD_REG_DWORD_RELAXED(&reg->req_q_in);		/* PCI Posting. */
+	if (ha->mqenable)
+		WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
+	else {
+		WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
+		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+	}
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
-	    ha->rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla24xx_process_response_queue(vha);
+		rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
@@ -828,3 +869,4 @@ queuing_error:
 
 	return QLA_FUNCTION_FAILED;
 }
+
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 89d3271..eb4b43d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -10,10 +10,12 @@
 #include <scsi/scsi_tcq.h>
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
-static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
-static void qla2x00_status_entry(scsi_qla_host_t *, void *);
+static void qla2x00_process_completed_request(struct scsi_qla_host *,
+	struct req_que *, uint32_t);
+static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
 static void qla2x00_status_cont_entry(scsi_qla_host_t *, sts_cont_entry_t *);
-static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
+static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
+	sts_entry_t *);
 static struct scsi_qla_host *qla2x00_get_rsp_host(struct rsp_que *);
 
 /**
@@ -83,7 +85,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 				mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 				mb[2] = RD_MAILBOX_REG(ha, reg, 2);
 				mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-				qla2x00_async_event(vha, mb);
+				qla2x00_async_event(vha, rsp, mb);
 			} else {
 				/*EMPTY*/
 				DEBUG2(printk("scsi(%ld): Unrecognized "
@@ -94,7 +96,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->semaphore, 0);
 			RD_REG_WORD(&reg->semaphore);
 		} else {
-			qla2x00_process_response_queue(vha);
+			qla2x00_process_response_queue(rsp);
 
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 			RD_REG_WORD(&reg->hccr);
@@ -190,21 +192,21 @@ qla2300_intr_handler(int irq, void *dev_id)
 			mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
 			mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-			qla2x00_async_event(vha, mb);
+			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x13:
-			qla2x00_process_response_queue(vha);
+			qla2x00_process_response_queue(rsp);
 			break;
 		case 0x15:
 			mb[0] = MBA_CMPLT_1_16BIT;
 			mb[1] = MSW(stat);
-			qla2x00_async_event(vha, mb);
+			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x16:
 			mb[0] = MBA_SCSI_COMPLETION;
 			mb[1] = MSW(stat);
 			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-			qla2x00_async_event(vha, mb);
+			qla2x00_async_event(vha, rsp, mb);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -270,7 +272,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
  * @mb: Mailbox registers (0 - 3)
  */
 void
-qla2x00_async_event(scsi_qla_host_t *vha, uint16_t *mb)
+qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 {
 #define LS_UNKNOWN	2
 	static char	*link_speeds[5] = { "1", "2", "?", "4", "8" };
@@ -344,7 +346,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, uint16_t *mb)
 			break;
 
 		for (cnt = 0; cnt < handle_cnt; cnt++)
-			qla2x00_process_completed_request(vha, handles[cnt]);
+			qla2x00_process_completed_request(vha, rsp->req,
+				handles[cnt]);
 		break;
 
 	case MBA_RESET:			/* Reset */
@@ -554,6 +557,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, uint16_t *mb)
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
+		/* Only handle SCNs for our Vport index. */
+		if (vha->vp_idx && vha->vp_idx != (mb[3] & 0xff))
+			break;
+
 		/*
 		 * If PORT UPDATE is global (received LIP_OCCURRED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
@@ -641,9 +648,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, uint16_t *mb)
 		    vha->host_no));
 
 		if (IS_FWI2_CAPABLE(ha))
-			qla24xx_process_response_queue(vha);
+			qla24xx_process_response_queue(rsp);
 		else
-			qla2x00_process_response_queue(vha);
+			qla2x00_process_response_queue(rsp);
 		break;
 
 	case MBA_DISCARD_RND_FRAME:
@@ -694,15 +701,21 @@ qla2x00_async_event(scsi_qla_host_t *vha, uint16_t *mb)
 	}
 
 	if (!vha->vp_idx && ha->num_vhosts)
-		qla2x00_alert_all_vps(ha, mb);
+		qla2x00_alert_all_vps(rsp, mb);
 }
 
 static void
 qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 {
 	fc_port_t *fcport = data;
-	struct qla_hw_data *ha = fcport->vha->hw;
-	if (ha->req->max_q_depth <= sdev->queue_depth)
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = NULL;
+
+	req = ha->req_q_map[vha->req_ques[0]];
+	if (!req)
+		return;
+	if (req->max_q_depth <= sdev->queue_depth)
 		return;
 
 	if (sdev->ordered_tags)
@@ -735,14 +748,14 @@ qla2x00_adjust_sdev_qdepth_down(struct scsi_device *sdev, void *data)
 }
 
 static inline void
-qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, srb_t *sp)
+qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, struct req_que *req,
+								srb_t *sp)
 {
 	fc_port_t *fcport;
 	struct scsi_device *sdev;
-	struct qla_hw_data *ha = vha->hw;
 
 	sdev = sp->cmd->device;
-	if (sdev->queue_depth >= ha->req->max_q_depth)
+	if (sdev->queue_depth >= req->max_q_depth)
 		return;
 
 	fcport = sp->fcport;
@@ -763,11 +776,11 @@ qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, srb_t *sp)
  * @index: SRB index
  */
 static void
-qla2x00_process_completed_request(struct scsi_qla_host *vha, uint32_t index)
+qla2x00_process_completed_request(struct scsi_qla_host *vha,
+				struct req_que *req, uint32_t index)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
 
 	/* Validate handle. */
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
@@ -791,8 +804,8 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha, uint32_t index)
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
 
-		qla2x00_ramp_up_queue_depth(vha, sp);
-		qla2x00_sp_compl(vha, sp);
+		qla2x00_ramp_up_queue_depth(vha, req, sp);
+		qla2x00_sp_compl(ha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld): Invalid ISP SCSI completion handle\n",
 		    vha->host_no));
@@ -808,14 +821,16 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha, uint32_t index)
  * @ha: SCSI driver HA context
  */
 void
-qla2x00_process_response_queue(struct scsi_qla_host *vha)
+qla2x00_process_response_queue(struct rsp_que *rsp)
 {
-	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha = rsp->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	sts_entry_t	*pkt;
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
-	struct rsp_que *rsp = ha->rsp;
+
+	vha = qla2x00_get_rsp_host(rsp);
 
 	if (!vha->flags.online)
 		return;
@@ -835,7 +850,7 @@ qla2x00_process_response_queue(struct scsi_qla_host *vha)
 			DEBUG3(printk(KERN_INFO
 			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
-			qla2x00_error_entry(vha, pkt);
+			qla2x00_error_entry(vha, rsp, pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
@@ -843,19 +858,19 @@ qla2x00_process_response_queue(struct scsi_qla_host *vha)
 
 		switch (pkt->entry_type) {
 		case STATUS_TYPE:
-			qla2x00_status_entry(vha, pkt);
+			qla2x00_status_entry(vha, rsp, pkt);
 			break;
 		case STATUS_TYPE_21:
 			handle_cnt = ((sts21_entry_t *)pkt)->handle_count;
 			for (cnt = 0; cnt < handle_cnt; cnt++) {
-				qla2x00_process_completed_request(vha,
+				qla2x00_process_completed_request(vha, rsp->req,
 				    ((sts21_entry_t *)pkt)->handle[cnt]);
 			}
 			break;
 		case STATUS_TYPE_22:
 			handle_cnt = ((sts22_entry_t *)pkt)->handle_count;
 			for (cnt = 0; cnt < handle_cnt; cnt++) {
-				qla2x00_process_completed_request(vha,
+				qla2x00_process_completed_request(vha, rsp->req,
 				    ((sts22_entry_t *)pkt)->handle[cnt]);
 			}
 			break;
@@ -914,7 +929,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
  * @pkt: Entry pointer
  */
 static void
-qla2x00_status_entry(scsi_qla_host_t *vha, void *pkt)
+qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 {
 	srb_t		*sp;
 	fc_port_t	*fcport;
@@ -928,7 +943,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, void *pkt)
 	uint32_t	sense_len, rsp_info_len, resid_len, fw_resid_len;
 	uint8_t		*rsp_info, *sense_data;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req = rsp->req;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -942,7 +957,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, void *pkt)
 
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
-		qla2x00_process_completed_request(vha, sts->handle);
+		qla2x00_process_completed_request(vha, req, sts->handle);
 
 		return;
 	}
@@ -1012,7 +1027,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, void *pkt)
 			    rsp_info[5], rsp_info[6], rsp_info[7]));
 
 			cp->result = DID_BUS_BUSY << 16;
-			qla2x00_sp_compl(vha, sp);
+			qla2x00_sp_compl(ha, sp);
 			return;
 		}
 	}
@@ -1276,7 +1291,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, void *pkt)
 
 	/* Place command on done queue. */
 	if (vha->status_srb == NULL)
-		qla2x00_sp_compl(vha, sp);
+		qla2x00_sp_compl(ha, sp);
 }
 
 /**
@@ -1325,7 +1340,7 @@ qla2x00_status_cont_entry(scsi_qla_host_t *vha, sts_cont_entry_t *pkt)
 		/* Place command on done queue. */
 		if (sp->request_sense_length == 0) {
 			vha->status_srb = NULL;
-			qla2x00_sp_compl(vha, sp);
+			qla2x00_sp_compl(ha, sp);
 		}
 	}
 }
@@ -1336,11 +1351,11 @@ qla2x00_status_cont_entry(scsi_qla_host_t *vha, sts_cont_entry_t *pkt)
  * @pkt: Entry pointer
  */
 static void
-qla2x00_error_entry(scsi_qla_host_t *vha, sts_entry_t *pkt)
+qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req = rsp->req;
 #if defined(QL_DEBUG_LEVEL_2)
 	if (pkt->entry_status & RF_INV_E_ORDER)
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Order\n", __func__);
@@ -1377,7 +1392,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, sts_entry_t *pkt)
 		} else {
 			sp->cmd->result = DID_ERROR << 16;
 		}
-		qla2x00_sp_compl(vha, sp);
+		qla2x00_sp_compl(ha, sp);
 
 	} else if (pkt->entry_type == COMMAND_A64_TYPE || pkt->entry_type ==
 	    COMMAND_TYPE || pkt->entry_type == COMMAND_TYPE_7) {
@@ -1428,12 +1443,14 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
  * @ha: SCSI driver HA context
  */
 void
-qla24xx_process_response_queue(struct scsi_qla_host *vha)
+qla24xx_process_response_queue(struct rsp_que *rsp)
 {
-	struct qla_hw_data *ha = vha->hw;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	struct qla_hw_data *ha = rsp->hw;
+	device_reg_t __iomem *reg = ISP_QUE_REG(ha, rsp->id);
 	struct sts_entry_24xx *pkt;
-	struct rsp_que *rsp = ha->rsp;
+	struct scsi_qla_host *vha;
+
+	vha = qla2x00_get_rsp_host(rsp);
 
 	if (!vha->flags.online)
 		return;
@@ -1453,7 +1470,7 @@ qla24xx_process_response_queue(struct scsi_qla_host *vha)
 			DEBUG3(printk(KERN_INFO
 			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
-			qla2x00_error_entry(vha, (sts_entry_t *) pkt);
+			qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
@@ -1461,7 +1478,7 @@ qla24xx_process_response_queue(struct scsi_qla_host *vha)
 
 		switch (pkt->entry_type) {
 		case STATUS_TYPE:
-			qla2x00_status_entry(vha, pkt);
+			qla2x00_status_entry(vha, rsp, pkt);
 			break;
 		case STATUS_CONT_TYPE:
 			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
@@ -1483,7 +1500,10 @@ qla24xx_process_response_queue(struct scsi_qla_host *vha)
 	}
 
 	/* Adjust ring index */
-	WRT_REG_DWORD(&reg->rsp_q_out, rsp->ring_index);
+	if (ha->mqenable)
+		WRT_REG_DWORD(&reg->isp25mq.rsp_q_out, rsp->ring_index);
+	else
+		WRT_REG_DWORD(&reg->isp24.rsp_q_out, rsp->ring_index);
 }
 
 static void
@@ -1607,10 +1627,11 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			mb[1] = RD_REG_WORD(&reg->mailbox1);
 			mb[2] = RD_REG_WORD(&reg->mailbox2);
 			mb[3] = RD_REG_WORD(&reg->mailbox3);
-			qla2x00_async_event(vha, mb);
+			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x13:
-			qla24xx_process_response_queue(vha);
+		case 0x14:
+			qla24xx_process_response_queue(rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -1635,7 +1656,6 @@ qla24xx_intr_handler(int irq, void *dev_id)
 static irqreturn_t
 qla24xx_msix_rsp_q(int irq, void *dev_id)
 {
-	scsi_qla_host_t	*vha;
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
@@ -1651,8 +1671,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	vha = qla2x00_get_rsp_host(rsp);
-	qla24xx_process_response_queue(vha);
+	qla24xx_process_response_queue(rsp);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
 	spin_unlock_irq(&ha->hardware_lock);
@@ -1661,6 +1680,41 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 }
 
 static irqreturn_t
+qla25xx_msix_rsp_q(int irq, void *dev_id)
+{
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
+	struct device_reg_24xx __iomem *reg;
+	uint16_t msix_disabled_hccr = 0;
+
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = rsp->hw;
+	reg = &ha->iobase->isp24;
+
+	spin_lock_irq(&ha->hardware_lock);
+
+	msix_disabled_hccr = rsp->options;
+	if (!rsp->id)
+		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_22);
+	else
+		msix_disabled_hccr &= BIT_6;
+
+	qla24xx_process_response_queue(rsp);
+
+	if (!msix_disabled_hccr)
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+
+	spin_unlock_irq(&ha->hardware_lock);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t
 qla24xx_msix_default(int irq, void *dev_id)
 {
 	scsi_qla_host_t	*vha;
@@ -1723,10 +1777,11 @@ qla24xx_msix_default(int irq, void *dev_id)
 			mb[1] = RD_REG_WORD(&reg->mailbox1);
 			mb[2] = RD_REG_WORD(&reg->mailbox2);
 			mb[3] = RD_REG_WORD(&reg->mailbox3);
-			qla2x00_async_event(vha, mb);
+			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x13:
-			qla24xx_process_response_queue(vha);
+		case 0x14:
+			qla24xx_process_response_queue(rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -1756,12 +1811,25 @@ struct qla_init_msix_entry {
 	irq_handler_t handler;
 };
 
-static struct qla_init_msix_entry imsix_entries[QLA_MSIX_ENTRIES] = {
-	{ QLA_MSIX_DEFAULT, QLA_MIDX_DEFAULT,
-		"qla2xxx (default)", qla24xx_msix_default },
+static struct qla_init_msix_entry base_queue = {
+	.entry = 0,
+	.index = 0,
+	.name = "qla2xxx (default)",
+	.handler = qla24xx_msix_default,
+};
+
+static struct qla_init_msix_entry base_rsp_queue = {
+	.entry = 1,
+	.index = 1,
+	.name = "qla2xxx (rsp_q)",
+	.handler = qla24xx_msix_rsp_q,
+};
 
-	{ QLA_MSIX_RSP_Q, QLA_MIDX_RSP_Q,
-		"qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
+static struct qla_init_msix_entry multi_rsp_queue = {
+	.entry = 1,
+	.index = 1,
+	.name = "qla2xxx (multi_q)",
+	.handler = qla25xx_msix_rsp_q,
 };
 
 static void
@@ -1769,63 +1837,115 @@ qla24xx_disable_msix(struct qla_hw_data *ha)
 {
 	int i;
 	struct qla_msix_entry *qentry;
-	struct rsp_que *rsp = ha->rsp;
 
-	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
-		qentry = &ha->msix_entries[imsix_entries[i].index];
+	for (i = 0; i < ha->msix_count; i++) {
+		qentry = &ha->msix_entries[i];
 		if (qentry->have_irq)
-			free_irq(qentry->msix_vector, rsp);
+			free_irq(qentry->vector, qentry->rsp);
 	}
 	pci_disable_msix(ha->pdev);
+	kfree(ha->msix_entries);
+	ha->msix_entries = NULL;
+	ha->flags.msix_enabled = 0;
 }
 
 static int
-qla24xx_enable_msix(struct qla_hw_data *ha)
+qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 	int i, ret;
-	struct rsp_que *rsp = ha->rsp;
-	struct msix_entry entries[QLA_MSIX_ENTRIES];
+	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
+	struct qla_init_msix_entry *msix_queue;
+
+	entries = kzalloc(sizeof(struct msix_entry) * ha->msix_count,
+					GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
 
-	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
-		entries[i].entry = imsix_entries[i].entry;
+	for (i = 0; i < ha->msix_count; i++)
+		entries[i].entry = i;
 
-	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
+	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
-		    "MSI-X: Failed to enable support -- %d/%d\n",
-		    QLA_MSIX_ENTRIES, ret);
+			"MSI-X: Failed to enable support -- %d/%d\n"
+			" Retry with %d vectors\n", ha->msix_count, ret, ret);
+		ha->msix_count = ret;
+		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
+		if (ret) {
+			qla_printk(KERN_WARNING, ha, "MSI-X: Failed to enable"
+				" support, giving up -- %d/%d\n",
+				ha->msix_count, ret);
+			goto msix_out;
+		}
+		ha->max_queues = ha->msix_count - 1;
+	}
+	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
+				ha->msix_count, GFP_KERNEL);
+	if (!ha->msix_entries) {
+		ret = -ENOMEM;
 		goto msix_out;
 	}
 	ha->flags.msix_enabled = 1;
 
-	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
-		qentry = &ha->msix_entries[imsix_entries[i].index];
-		qentry->msix_vector = entries[i].vector;
-		qentry->msix_entry = entries[i].entry;
+	for (i = 0; i < ha->msix_count; i++) {
+		qentry = &ha->msix_entries[i];
+		qentry->vector = entries[i].vector;
+		qentry->entry = entries[i].entry;
 		qentry->have_irq = 0;
-		ret = request_irq(qentry->msix_vector,
-		    imsix_entries[i].handler, 0, imsix_entries[i].name, rsp);
-		if (ret) {
-			qla_printk(KERN_WARNING, ha,
-			    "MSI-X: Unable to register handler -- %x/%d.\n",
-			    imsix_entries[i].index, ret);
-			qla24xx_disable_msix(ha);
-			goto msix_out;
-		}
-		qentry->have_irq = 1;
+		qentry->rsp = NULL;
 	}
 
+	/* Enable MSI-X for AENs for queue 0 */
+	qentry = &ha->msix_entries[0];
+	ret = request_irq(qentry->vector, base_queue.handler, 0,
+					base_queue.name, rsp);
+	if (ret) {
+		qla_printk(KERN_WARNING, ha,
+			"MSI-X: Unable to register handler -- %x/%d.\n",
+			qentry->vector, ret);
+		qla24xx_disable_msix(ha);
+		goto msix_out;
+	}
+	qentry->have_irq = 1;
+	qentry->rsp = rsp;
+
+	/* Enable MSI-X vector for response queue update for queue 0 */
+	if (ha->max_queues > 1 && ha->mqiobase) {
+		ha->mqenable = 1;
+		msix_queue = &multi_rsp_queue;
+		qla_printk(KERN_INFO, ha,
+				"MQ enabled, Number of Queue Resources: %d \n",
+				ha->max_queues);
+	} else {
+		ha->mqenable = 0;
+		msix_queue = &base_rsp_queue;
+	}
+
+	qentry = &ha->msix_entries[1];
+	ret = request_irq(qentry->vector, msix_queue->handler, 0,
+						msix_queue->name, rsp);
+	if (ret) {
+		qla_printk(KERN_WARNING, ha,
+			"MSI-X: Unable to register handler -- %x/%d.\n",
+			qentry->vector, ret);
+		qla24xx_disable_msix(ha);
+		ha->mqenable = 0;
+		goto msix_out;
+	}
+	qentry->have_irq = 1;
+	qentry->rsp = rsp;
+
 msix_out:
+	kfree(entries);
 	return ret;
 }
 
 int
-qla2x00_request_irqs(struct qla_hw_data *ha)
+qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 	int ret;
 	device_reg_t __iomem *reg = ha->iobase;
-	struct rsp_que *rsp = ha->rsp;
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha))
@@ -1852,7 +1972,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha)
 		goto skip_msi;
 	}
 
-	ret = qla24xx_enable_msix(ha);
+	ret = qla24xx_enable_msix(ha, rsp);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "MSI-X: Enabled (0x%X, 0x%X).\n", ha->chip_revision,
@@ -1903,7 +2023,7 @@ void
 qla2x00_free_irqs(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct rsp_que *rsp = ha->rsp;
+	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
@@ -1919,16 +2039,41 @@ qla2x00_get_rsp_host(struct rsp_que *rsp)
 	srb_t *sp;
 	struct qla_hw_data *ha = rsp->hw;
 	struct scsi_qla_host *vha = NULL;
-	struct sts_entry_24xx *pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
-
-	if (pkt && pkt->handle < MAX_OUTSTANDING_COMMANDS) {
-		sp = ha->req->outstanding_cmds[pkt->handle];
-		if (sp)
-			vha = sp->vha;
+	struct sts_entry_24xx *pkt;
+	struct req_que *req;
+
+	if (rsp->id) {
+		pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
+		req = rsp->req;
+		if (pkt && pkt->handle < MAX_OUTSTANDING_COMMANDS) {
+			sp = req->outstanding_cmds[pkt->handle];
+			if (sp)
+				vha = sp->vha;
+		}
 	}
 	if (!vha)
-	/* Invalid entry, handle it in base queue */
+	/* handle it in base queue */
 		vha = pci_get_drvdata(ha->pdev);
 
 	return vha;
 }
+
+int qla25xx_request_irq(struct rsp_que *rsp)
+{
+	struct qla_hw_data *ha = rsp->hw;
+	struct qla_init_msix_entry *intr = &multi_rsp_queue;
+	struct qla_msix_entry *msix = rsp->msix;
+	int ret;
+
+	ret = request_irq(msix->vector, intr->handler, 0, intr->name, rsp);
+	if (ret) {
+		qla_printk(KERN_WARNING, ha,
+			"MSI-X: Unable to register handler -- %x/%d.\n",
+			msix->vector, ret);
+		return ret;
+	}
+	msix->have_irq = 1;
+	msix->rsp = rsp;
+	return ret;
+}
+
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bbe7181..c54bc97 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -153,7 +153,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				break;
 
 			/* Check for pending interrupts. */
-			qla2x00_poll(ha->rsp);
+			qla2x00_poll(ha->rsp_q_map[0]);
 
 			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
 			    !ha->flags.mbox_int)
@@ -223,7 +223,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		    "interrupt.\n", __func__, base_vha->host_no));
 
 		/* polling mode for non isp_abort commands. */
-		qla2x00_poll(ha->rsp);
+		qla2x00_poll(ha->rsp_q_map[0]);
 	}
 
 	if (rval == QLA_FUNCTION_TIMEOUT &&
@@ -713,8 +713,6 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
 		    vha->host_no, rval));
-		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    vha->host_no, rval));
 	} else {
 		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
 
@@ -749,16 +747,15 @@ qla2x00_issue_iocb(scsi_qla_host_t *vha, void *buffer, dma_addr_t phys_addr,
  *	Kernel context.
  */
 int
-qla2x00_abort_command(scsi_qla_host_t *vha, srb_t *sp)
+qla2x00_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
 {
 	unsigned long   flags = 0;
 	fc_port_t	*fcport;
 	int		rval;
-	uint32_t	handle;
+	uint32_t	handle = 0;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
 
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", vha->host_no));
 
@@ -808,11 +805,15 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
 	scsi_qla_host_t *vha;
+	struct req_que *req;
+	struct rsp_que *rsp;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	l = l;
 	vha = fcport->vha;
+	req = vha->hw->req_q_map[0];
+	rsp = vha->hw->rsp_q_map[0];
 	mcp->mb[0] = MBC_ABORT_TARGET;
 	mcp->out_mb = MBX_9|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(vha->hw)) {
@@ -835,7 +836,8 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(vha, fcport->loop_id, 0, MK_SYNC_ID);
+	rval2 = qla2x00_marker(vha, req, rsp, fcport->loop_id, 0,
+							MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
 		    "(%x).\n", __func__, vha->host_no, rval2));
@@ -853,10 +855,14 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
 	scsi_qla_host_t *vha;
+	struct req_que *req;
+	struct rsp_que *rsp;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	vha = fcport->vha;
+	req = vha->hw->req_q_map[0];
+	rsp = vha->hw->rsp_q_map[0];
 	mcp->mb[0] = MBC_LUN_RESET;
 	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(vha->hw))
@@ -877,7 +883,8 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(vha, fcport->loop_id, l, MK_SYNC_ID_LUN);
+	rval2 = qla2x00_marker(vha, req, rsp, fcport->loop_id, l,
+								MK_SYNC_ID_LUN);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
 		    "(%x).\n", __func__, vha->host_no, rval2));
@@ -1743,6 +1750,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
 	lg->vp_index = vha->vp_idx;
+
 	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
@@ -1753,9 +1761,9 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		DEBUG2_3_11(printk("%s(%ld %d): failed to complete IOCB "
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    vha->host_no, le16_to_cpu(lg->comp_status),
+		    vha->host_no, vha->vp_idx, le16_to_cpu(lg->comp_status),
 		    le32_to_cpu(lg->io_parameter[0]),
 		    le32_to_cpu(lg->io_parameter[1])));
 	} else {
@@ -2173,7 +2181,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 }
 
 int
-qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp)
+qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
 {
 	int		rval;
 	fc_port_t	*fcport;
@@ -2183,7 +2191,6 @@ qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp)
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
@@ -2216,6 +2223,9 @@ qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp)
 	abt->port_id[1] = fcport->d_id.b.area;
 	abt->port_id[2] = fcport->d_id.b.domain;
 	abt->vp_index = fcport->vp_idx;
+
+	abt->req_que_no = cpu_to_le16(req->id);
+
 	rval = qla2x00_issue_iocb(vha, abt, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB (%x).\n",
@@ -2255,11 +2265,15 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	dma_addr_t	tsk_dma;
 	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha;
+	struct req_que *req;
+	struct rsp_que *rsp;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	vha = fcport->vha;
 	ha = vha->hw;
+	req = ha->req_q_map[0];
+	rsp = ha->rsp_q_map[0];
 	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
@@ -2301,7 +2315,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(vha, fcport->loop_id, l,
+	rval2 = qla2x00_marker(vha, req, rsp, fcport->loop_id, l,
 	    type == TCF_LUN_RESET ? MK_SYNC_ID_LUN: MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
@@ -3069,3 +3083,108 @@ verify_done:
 
 	return rval;
 }
+
+int
+qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
+	uint8_t options)
+{
+	int rval;
+	unsigned long flags;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct device_reg_25xxmq __iomem *reg;
+	struct qla_hw_data *ha = vha->hw;
+
+	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
+	mcp->mb[1] = options;
+	mcp->mb[2] = MSW(LSD(req->dma));
+	mcp->mb[3] = LSW(LSD(req->dma));
+	mcp->mb[6] = MSW(MSD(req->dma));
+	mcp->mb[7] = LSW(MSD(req->dma));
+	mcp->mb[5] = req->length;
+	if (req->rsp)
+		mcp->mb[10] = req->rsp->id;
+	mcp->mb[12] = req->qos;
+	mcp->mb[11] = req->vp_idx;
+	mcp->mb[13] = req->rid;
+
+	reg = (struct device_reg_25xxmq *)((void *)(ha->mqiobase) +
+		QLA_QUE_PAGE * req->id);
+
+	mcp->mb[4] = req->id;
+	/* que in ptr index */
+	mcp->mb[8] = 0;
+	/* que out ptr index */
+	mcp->mb[9] = 0;
+	mcp->out_mb = MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8|MBX_7|
+			MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->flags = MBX_DMA_OUT;
+	mcp->tov = 60;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (!(options & BIT_0)) {
+		WRT_REG_DWORD(&reg->req_q_in, 0);
+		WRT_REG_DWORD(&reg->req_q_out, 0);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	rval = (int)qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS)
+		DEBUG2_3_11(printk(KERN_WARNING "%s(%ld): failed=%x mb0=%x.\n",
+			__func__, vha->host_no, rval, mcp->mb[0]));
+	return rval;
+}
+
+int
+qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
+	uint8_t options)
+{
+	int rval;
+	unsigned long flags;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct device_reg_25xxmq __iomem *reg;
+	struct qla_hw_data *ha = vha->hw;
+
+	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
+	mcp->mb[1] = options;
+	mcp->mb[2] = MSW(LSD(rsp->dma));
+	mcp->mb[3] = LSW(LSD(rsp->dma));
+	mcp->mb[6] = MSW(MSD(rsp->dma));
+	mcp->mb[7] = LSW(MSD(rsp->dma));
+	mcp->mb[5] = rsp->length;
+	mcp->mb[11] = rsp->vp_idx;
+	mcp->mb[14] = rsp->msix->vector;
+	mcp->mb[13] = rsp->rid;
+
+	reg = (struct device_reg_25xxmq *)((void *)(ha->mqiobase) +
+		QLA_QUE_PAGE * rsp->id);
+
+	mcp->mb[4] = rsp->id;
+	/* que in ptr index */
+	mcp->mb[8] = 0;
+	/* que out ptr index */
+	mcp->mb[9] = 0;
+	mcp->out_mb = MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8|MBX_7
+			|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->flags = MBX_DMA_OUT;
+	mcp->tov = 60;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (!(options & BIT_0)) {
+		WRT_REG_DWORD(&reg->rsp_q_out, 0);
+		WRT_REG_DWORD(&reg->rsp_q_in, 0);
+	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	rval = (int)qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS)
+		DEBUG2_3_11(printk(KERN_WARNING "%s(%ld): failed=%x "
+			"mb0=%x.\n", __func__,
+			vha->host_no, rval, mcp->mb[0]));
+	return rval;
+}
+
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index da3db3a..55730f4 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -101,6 +101,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    "loop_id=0x%04x :%x\n",
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
 
+		atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
 		atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	}
@@ -191,9 +192,10 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_alert_all_vps(struct qla_hw_data *ha, uint16_t *mb)
+qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 {
 	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha = rsp->hw;
 	int i = 0;
 
 	list_for_each_entry(vha, &ha->vp_list, list) {
@@ -210,7 +212,7 @@ qla2x00_alert_all_vps(struct qla_hw_data *ha, uint16_t *mb)
 				DEBUG15(printk("scsi(%ld)%s: Async_event for"
 				" VP[%d], mb = 0x%x, vha=%p\n",
 				vha->host_no, __func__, i, *mb, vha));
-				qla2x00_async_event(vha, mb);
+				qla2x00_async_event(vha, rsp, mb);
 				break;
 			}
 		}
@@ -282,8 +284,7 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 		clear_bit(RESET_ACTIVE, &vha->dpc_flags);
 	}
 
-	if (atomic_read(&vha->vp_state) == VP_ACTIVE &&
-	    test_and_clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
+	if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 		if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))) {
 			qla2x00_loop_resync(vha);
 			clear_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags);
@@ -367,7 +368,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	host = vha->host;
 	fc_vport->dd_data = vha;
-
 	/* New host info */
 	u64_to_wwn(fc_vport->node_name, vha->node_name);
 	u64_to_wwn(fc_vport->port_name, vha->port_name);
@@ -396,7 +396,9 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	host->can_queue = ha->req->length + 128;
+	memset(vha->req_ques, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES, 0);
+	vha->req_ques[0] = ha->req_q_map[0]->id;
+	host->can_queue = ha->req_q_map[0]->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->max_cmd_len = MAX_CMDSZ;
@@ -416,3 +418,338 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 create_vhost_failed:
 	return NULL;
 }
+
+static void
+qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t que_id = req->id;
+
+	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
+		sizeof(request_t), req->ring, req->dma);
+	req->ring = NULL;
+	req->dma = 0;
+	if (que_id) {
+		ha->req_q_map[que_id] = NULL;
+		mutex_lock(&ha->vport_lock);
+		clear_bit(que_id, ha->req_qid_map);
+		mutex_unlock(&ha->vport_lock);
+	}
+	kfree(req);
+	req = NULL;
+}
+
+static void
+qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t que_id = rsp->id;
+
+	if (rsp->msix && rsp->msix->have_irq) {
+		free_irq(rsp->msix->vector, rsp);
+		rsp->msix->have_irq = 0;
+		rsp->msix->rsp = NULL;
+	}
+	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
+		sizeof(response_t), rsp->ring, rsp->dma);
+	rsp->ring = NULL;
+	rsp->dma = 0;
+	if (que_id) {
+		ha->rsp_q_map[que_id] = NULL;
+		mutex_lock(&ha->vport_lock);
+		clear_bit(que_id, ha->rsp_qid_map);
+		mutex_unlock(&ha->vport_lock);
+	}
+	kfree(rsp);
+	rsp = NULL;
+}
+
+int
+qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
+{
+	int ret = -1;
+
+	if (req) {
+		req->options |= BIT_0;
+		ret = qla25xx_init_req_que(vha, req, req->options);
+	}
+	if (ret == QLA_SUCCESS)
+		qla25xx_free_req_que(vha, req);
+
+	return ret;
+}
+
+int
+qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
+{
+	int ret = -1;
+
+	if (rsp) {
+		rsp->options |= BIT_0;
+		ret = qla25xx_init_rsp_que(vha, rsp, rsp->options);
+	}
+	if (ret == QLA_SUCCESS)
+		qla25xx_free_rsp_que(vha, rsp);
+
+	return ret;
+}
+
+int qla25xx_update_req_que(struct scsi_qla_host *vha, uint8_t que, uint8_t qos)
+{
+	int ret = 0;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[que];
+
+	req->options |= BIT_3;
+	req->qos = qos;
+	ret = qla25xx_init_req_que(vha, req, req->options);
+	if (ret != QLA_SUCCESS)
+		DEBUG2_17(printk(KERN_WARNING "%s failed\n", __func__));
+	/* restore options bit */
+	req->options &= ~BIT_3;
+	return ret;
+}
+
+
+/* Delete all queues for a given vhost */
+int
+qla25xx_delete_queues(struct scsi_qla_host *vha, uint8_t que_no)
+{
+	int cnt, ret = 0;
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (que_no) {
+	/* Delete request queue */
+		req = ha->req_q_map[que_no];
+		if (req) {
+			rsp = req->rsp;
+			ret = qla25xx_delete_req_que(vha, req);
+			if (ret != QLA_SUCCESS) {
+				qla_printk(KERN_WARNING, ha,
+				"Couldn't delete req que %d\n", req->id);
+				return ret;
+			}
+			/* Delete associated response queue */
+			if (rsp) {
+				ret = qla25xx_delete_rsp_que(vha, rsp);
+				if (ret != QLA_SUCCESS) {
+					qla_printk(KERN_WARNING, ha,
+						"Couldn't delete rsp que %d\n",
+						rsp->id);
+					return ret;
+				}
+			}
+		}
+	} else {  /* delete all queues of this host */
+		for (cnt = 0; cnt < QLA_MAX_HOST_QUES; cnt++) {
+			/* Delete request queues */
+			req = ha->req_q_map[vha->req_ques[cnt]];
+			if (req && req->id) {
+				rsp = req->rsp;
+				ret = qla25xx_delete_req_que(vha, req);
+				if (ret != QLA_SUCCESS) {
+					qla_printk(KERN_WARNING, ha,
+						"Couldn't delete req que %d\n",
+						vha->req_ques[cnt]);
+					return ret;
+				}
+				vha->req_ques[cnt] = ha->req_q_map[0]->id;
+			/* Delete associated response queue */
+				if (rsp && rsp->id) {
+					ret = qla25xx_delete_rsp_que(vha, rsp);
+					if (ret != QLA_SUCCESS) {
+						qla_printk(KERN_WARNING, ha,
+						"Couldn't delete rsp que %d\n",
+						rsp->id);
+						return ret;
+					}
+				}
+			}
+		}
+	}
+	qla_printk(KERN_INFO, ha, "Queues deleted for vport:%d\n",
+		vha->vp_idx);
+	return ret;
+}
+
+int
+qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
+	uint8_t vp_idx, uint16_t rid, uint8_t rsp_que, uint8_t qos)
+{
+	int ret = 0;
+	struct req_que *req = NULL;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	uint16_t que_id = 0;
+
+	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
+	if (req == NULL) {
+		qla_printk(KERN_WARNING, ha, "could not allocate memory"
+			"for request que\n");
+		goto que_failed;
+	}
+
+	req->length = REQUEST_ENTRY_CNT_24XX;
+	req->ring = dma_alloc_coherent(&ha->pdev->dev,
+			(req->length + 1) * sizeof(request_t),
+			&req->dma, GFP_KERNEL);
+	if (req->ring == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		"Memory Allocation failed - request_ring\n");
+		goto que_failed;
+	}
+
+	mutex_lock(&ha->vport_lock);
+	que_id = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
+	if (que_id >= ha->max_queues) {
+		mutex_unlock(&ha->vport_lock);
+		qla_printk(KERN_INFO, ha, "No resources to create "
+			 "additional request queue\n");
+		goto que_failed;
+	}
+	set_bit(que_id, ha->req_qid_map);
+	ha->req_q_map[que_id] = req;
+	req->rid = rid;
+	req->vp_idx = vp_idx;
+	req->qos = qos;
+
+	if (ha->rsp_q_map[rsp_que])
+		req->rsp = ha->rsp_q_map[rsp_que];
+	/* Use alternate PCI bus number */
+	if (MSB(req->rid))
+		options |= BIT_4;
+	/* Use alternate PCI devfn */
+	if (LSB(req->rid))
+		options |= BIT_5;
+	req->options = options;
+	req->ring_ptr = req->ring;
+	req->ring_index = 0;
+	req->cnt = req->length;
+	req->id = que_id;
+	mutex_unlock(&ha->vport_lock);
+
+	ret = qla25xx_init_req_que(base_vha, req, options);
+	if (ret != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
+		mutex_lock(&ha->vport_lock);
+		clear_bit(que_id, ha->req_qid_map);
+		mutex_unlock(&ha->vport_lock);
+		goto que_failed;
+	}
+
+	return req->id;
+
+que_failed:
+	qla25xx_free_req_que(base_vha, req);
+	return 0;
+}
+
+/* create response queue */
+int
+qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
+	uint8_t vp_idx, uint16_t rid)
+{
+	int ret = 0;
+	struct rsp_que *rsp = NULL;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	uint16_t que_id = 0;;
+
+	rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
+	if (rsp == NULL) {
+		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
+				" response que\n");
+		goto que_failed;
+	}
+
+	rsp->length = RESPONSE_ENTRY_CNT_2300;
+	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
+			(rsp->length + 1) * sizeof(response_t),
+			&rsp->dma, GFP_KERNEL);
+	if (rsp->ring == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		"Memory Allocation failed - response_ring\n");
+		goto que_failed;
+	}
+
+	mutex_lock(&ha->vport_lock);
+	que_id = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
+	if (que_id >= ha->max_queues) {
+		mutex_unlock(&ha->vport_lock);
+		qla_printk(KERN_INFO, ha, "No resources to create "
+			 "additional response queue\n");
+		goto que_failed;
+	}
+	set_bit(que_id, ha->rsp_qid_map);
+
+	if (ha->flags.msix_enabled)
+		rsp->msix = &ha->msix_entries[que_id + 1];
+	else
+		qla_printk(KERN_WARNING, ha, "msix not enabled\n");
+
+	ha->rsp_q_map[que_id] = rsp;
+	rsp->rid = rid;
+	rsp->vp_idx = vp_idx;
+	rsp->hw = ha;
+	/* Use alternate PCI bus number */
+	if (MSB(rsp->rid))
+		options |= BIT_4;
+	/* Use alternate PCI devfn */
+	if (LSB(rsp->rid))
+		options |= BIT_5;
+	rsp->options = options;
+	rsp->ring_ptr = rsp->ring;
+	rsp->ring_index = 0;
+	rsp->id = que_id;
+	mutex_unlock(&ha->vport_lock);
+
+	ret = qla25xx_request_irq(rsp);
+	if (ret)
+		goto que_failed;
+
+	ret = qla25xx_init_rsp_que(base_vha, rsp, options);
+	if (ret != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
+		mutex_lock(&ha->vport_lock);
+		clear_bit(que_id, ha->rsp_qid_map);
+		mutex_unlock(&ha->vport_lock);
+		goto que_failed;
+	}
+
+	qla2x00_init_response_q_entries(rsp);
+
+	return rsp->id;
+
+que_failed:
+	qla25xx_free_rsp_que(base_vha, rsp);
+	return 0;
+}
+
+int
+qla25xx_create_queues(struct scsi_qla_host *vha, uint8_t qos)
+{
+	uint16_t options = 0;
+	uint8_t ret = 0;
+	struct qla_hw_data *ha = vha->hw;
+
+	options |= BIT_1;
+	ret = qla25xx_create_rsp_que(ha, options, vha->vp_idx, 0);
+	if (!ret) {
+		qla_printk(KERN_WARNING, ha, "Response Que create failed\n");
+		return ret;
+	} else
+		qla_printk(KERN_INFO, ha, "Response Que:%d created.\n", ret);
+
+	options = 0;
+	if (qos & BIT_7)
+		options |= BIT_8;
+	ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, ret,
+					qos & ~BIT_7);
+	if (ret) {
+		vha->req_ques[0] = ret;
+		qla_printk(KERN_INFO, ha, "Request Que:%d created.\n", ret);
+	} else
+		qla_printk(KERN_WARNING, ha, "Request Que create failed\n");
+
+	return ret;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f636588..9142025 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -92,7 +92,12 @@ MODULE_PARM_DESC(ql2xiidmaenable,
 		"Enables iIDMA settings "
 		"Default is 1 - perform iIDMA. 0 - no iIDMA.");
 
-
+int ql2xmaxqueues = 1;
+module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xmaxqueues,
+		"Enables MQ settings "
+		"Default is 1 for single queue. Set it to number \
+			of queues in MQ mode.");
 /*
  * SCSI host template entry points
  */
@@ -210,11 +215,77 @@ static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-static int qla2x00_mem_alloc(struct qla_hw_data *, uint16_t, uint16_t);
+static int qla2x00_mem_alloc(struct qla_hw_data *, uint16_t, uint16_t,
+	struct req_que **, struct rsp_que **);
 static void qla2x00_mem_free(struct qla_hw_data *);
 static void qla2x00_sp_free_dma(srb_t *);
 
 /* -------------------------------------------------------------------------- */
+static int qla2x00_alloc_queues(struct qla_hw_data *ha)
+{
+	ha->req_q_map = kzalloc(sizeof(struct req_que *) * ha->max_queues,
+				GFP_KERNEL);
+	if (!ha->req_q_map) {
+		qla_printk(KERN_WARNING, ha,
+			"Unable to allocate memory for request queue ptrs\n");
+		goto fail_req_map;
+	}
+
+	ha->rsp_q_map = kzalloc(sizeof(struct rsp_que *) * ha->max_queues,
+				GFP_KERNEL);
+	if (!ha->rsp_q_map) {
+		qla_printk(KERN_WARNING, ha,
+			"Unable to allocate memory for response queue ptrs\n");
+		goto fail_rsp_map;
+	}
+	set_bit(0, ha->rsp_qid_map);
+	set_bit(0, ha->req_qid_map);
+	return 1;
+
+fail_rsp_map:
+	kfree(ha->req_q_map);
+	ha->req_q_map = NULL;
+fail_req_map:
+	return -ENOMEM;
+}
+
+static void qla2x00_free_que(struct qla_hw_data *ha, struct req_que *req,
+	struct rsp_que *rsp)
+{
+	if (rsp && rsp->ring)
+		dma_free_coherent(&ha->pdev->dev,
+		(rsp->length + 1) * sizeof(response_t),
+		rsp->ring, rsp->dma);
+
+	kfree(rsp);
+	rsp = NULL;
+	if (req && req->ring)
+		dma_free_coherent(&ha->pdev->dev,
+		(req->length + 1) * sizeof(request_t),
+		req->ring, req->dma);
+
+	kfree(req);
+	req = NULL;
+}
+
+static void qla2x00_free_queues(struct qla_hw_data *ha)
+{
+	struct req_que *req;
+	struct rsp_que *rsp;
+	int cnt;
+
+	for (cnt = 0; cnt < ha->max_queues; cnt++) {
+		rsp = ha->rsp_q_map[cnt];
+		req = ha->req_q_map[cnt];
+		qla2x00_free_que(ha, req, rsp);
+	}
+	kfree(ha->rsp_q_map);
+	ha->rsp_q_map = NULL;
+
+	kfree(ha->req_q_map);
+	ha->req_q_map = NULL;
+}
+
 static char *
 qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
@@ -629,34 +700,40 @@ qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 void
 qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 {
-	int cnt;
+	int cnt, que, id;
 	unsigned long flags;
 	srb_t *sp;
 	scsi_qla_host_t *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (!sp)
-			continue;
-		if (sp->fcport != fcport)
+	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
+		id = vha->req_ques[que];
+		req = ha->req_q_map[id];
+		if (!req)
 			continue;
+		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+			sp = req->outstanding_cmds[cnt];
+			if (!sp)
+				continue;
+			if (sp->fcport != fcport)
+				continue;
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(vha, sp)) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "Abort failed --  %lx\n", sp->cmd->serial_number));
-		} else {
-			if (qla2x00_eh_wait_on_command(sp->cmd) !=
-			    QLA_SUCCESS)
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			if (ha->isp_ops->abort_command(vha, sp, req)) {
 				DEBUG2(qla_printk(KERN_WARNING, ha,
-				    "Abort failed while waiting --  %lx\n",
-				    sp->cmd->serial_number));
-
+				"Abort failed --  %lx\n",
+				sp->cmd->serial_number));
+			} else {
+				if (qla2x00_eh_wait_on_command(sp->cmd) !=
+					QLA_SUCCESS)
+					DEBUG2(qla_printk(KERN_WARNING, ha,
+					"Abort failed while waiting --  %lx\n",
+					sp->cmd->serial_number));
+			}
+			spin_lock_irqsave(&ha->hardware_lock, flags);
 		}
-		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -698,13 +775,13 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret, i;
+	int ret, i, que;
 	unsigned int id, lun;
 	unsigned long serial;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req;
 
 	qla2x00_block_error_handler(cmd);
 
@@ -719,31 +796,34 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	/* Check active list for command command. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		sp = req->outstanding_cmds[i];
-
-		if (sp == NULL)
+	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
+		req = ha->req_q_map[vha->req_ques[que]];
+		if (!req)
 			continue;
+		for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
+			sp = req->outstanding_cmds[i];
 
-		if (sp->cmd != cmd)
-			continue;
+			if (sp == NULL)
+				continue;
 
-		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld.\n",
-		    __func__, vha->host_no, sp, serial));
+			if (sp->cmd != cmd)
+				continue;
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(vha, sp)) {
-			DEBUG2(printk("%s(%ld): abort_command "
-			    "mbx failed.\n", __func__, vha->host_no));
-			ret = FAILED;
-		} else {
-			DEBUG3(printk("%s(%ld): abort_command "
-			    "mbx success.\n", __func__, vha->host_no));
-			wait = 1;
-		}
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+			DEBUG2(printk("%s(%ld): aborting sp %p from RISC."
+			" pid=%ld.\n", __func__, vha->host_no, sp, serial));
 
-		break;
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			if (ha->isp_ops->abort_command(vha, sp, req)) {
+				DEBUG2(printk("%s(%ld): abort_command "
+				"mbx failed.\n", __func__, vha->host_no));
+			} else {
+				DEBUG3(printk("%s(%ld): abort_command "
+				"mbx success.\n", __func__, vha->host_no));
+				wait = 1;
+			}
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			break;
+		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -774,41 +854,46 @@ static int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
     unsigned int l, enum nexus_wait_type type)
 {
-	int cnt, match, status;
+	int cnt, match, status, que;
 	srb_t *sp;
 	unsigned long flags;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req;
 
 	status = QLA_SUCCESS;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (cnt = 1; status == QLA_SUCCESS && cnt < MAX_OUTSTANDING_COMMANDS;
-	    cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (!sp)
+	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
+		req = ha->req_q_map[vha->req_ques[que]];
+		if (!req)
 			continue;
+		for (cnt = 1; status == QLA_SUCCESS &&
+			cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+			sp = req->outstanding_cmds[cnt];
+			if (!sp)
+				continue;
 
-		if (vha->vp_idx != sp->fcport->vha->vp_idx)
-			continue;
-		match = 0;
-		switch (type) {
-		case WAIT_HOST:
-			match = 1;
-			break;
-		case WAIT_TARGET:
-			match = sp->cmd->device->id == t;
-			break;
-		case WAIT_LUN:
-			match = (sp->cmd->device->id == t &&
-			    sp->cmd->device->lun == l);
-			break;
-		}
-		if (!match)
-			continue;
+			if (vha->vp_idx != sp->fcport->vha->vp_idx)
+				continue;
+			match = 0;
+			switch (type) {
+			case WAIT_HOST:
+				match = 1;
+				break;
+			case WAIT_TARGET:
+				match = sp->cmd->device->id == t;
+				break;
+			case WAIT_LUN:
+				match = (sp->cmd->device->id == t &&
+					sp->cmd->device->lun == l);
+				break;
+			}
+			if (!match)
+				continue;
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		status = qla2x00_eh_wait_on_command(sp->cmd);
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			status = qla2x00_eh_wait_on_command(sp->cmd);
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1074,7 +1159,6 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 			}
 		}
 	}
-
 	/* Issue marker command only when we are going to start the I/O */
 	vha->marker_needed = 1;
 
@@ -1084,19 +1168,24 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
-	int cnt;
+	int que, cnt;
 	unsigned long flags;
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (sp) {
-			req->outstanding_cmds[cnt] = NULL;
-			sp->cmd->result = res;
-			qla2x00_sp_compl(vha, sp);
+	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
+		req = ha->req_q_map[vha->req_ques[que]];
+		if (!req)
+			continue;
+		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+			sp = req->outstanding_cmds[cnt];
+			if (sp && sp->vha == vha) {
+				req->outstanding_cmds[cnt] = NULL;
+				sp->cmd->result = res;
+				qla2x00_sp_compl(ha, sp);
+			}
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1121,11 +1210,12 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
+	struct req_que *req = ha->req_q_map[0];
 
 	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, ha->req->max_q_depth);
+		scsi_activate_tcq(sdev, req->max_q_depth);
 	else
-		scsi_deactivate_tcq(sdev, ha->req->max_q_depth);
+		scsi_deactivate_tcq(sdev, req->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count;
 
@@ -1471,6 +1561,7 @@ static int
 qla2x00_iospace_config(struct qla_hw_data *ha)
 {
 	resource_size_t pio;
+	uint16_t msix;
 
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
@@ -1523,6 +1614,29 @@ skip_pio:
 		goto iospace_error_exit;
 	}
 
+	/* Determine queue resources */
+	ha->max_queues = 1;
+	if (ql2xmaxqueues > 1) {
+		ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
+				pci_resource_len(ha->pdev, 3));
+		if (ha->mqiobase) {
+			/* Read MSIX vector size of the board */
+			pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL,
+						&msix);
+			ha->msix_count = msix;
+			/* Max queues are bounded by available msix vectors */
+			/* queue 0 uses two msix vectors */
+			if (ha->msix_count - 1 < ql2xmaxqueues)
+				ha->max_queues = ha->msix_count - 1;
+			else if (ql2xmaxqueues > QLA_MQ_SIZE)
+				ha->max_queues = QLA_MQ_SIZE;
+			else
+				ha->max_queues = ql2xmaxqueues;
+			qla_printk(KERN_INFO, ha,
+				"MSI-X vector count: %d\n", msix);
+		}
+	}
+	ha->msix_count = ha->max_queues + 1;
 	return (0);
 
 iospace_error_exit:
@@ -1568,6 +1682,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct scsi_host_template *sht;
 	int bars, max_id, mem_only = 0;
 	uint16_t req_length = 0, rsp_length = 0;
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2x00_driver_template;
@@ -1655,6 +1771,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_24XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA24XX;
 		ha->isp_ops = &qla24xx_isp_ops;
 	} else if (IS_QLA25XX(ha)) {
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1664,6 +1781,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_25XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla25xx_isp_ops;
 	}
 
@@ -1674,7 +1792,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
-	ret = qla2x00_mem_alloc(ha, req_length, rsp_length);
+	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
 	if (!ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "[ERROR] Failed to allocate memory for adapter\n");
@@ -1682,9 +1800,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_hw_failed;
 	}
 
-	ha->req->max_q_depth = MAX_Q_DEPTH;
+	req->max_q_depth = MAX_Q_DEPTH;
 	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
-		ha->req->max_q_depth = ql2xmaxqdepth;
+		req->max_q_depth = ql2xmaxqdepth;
+
 
 	base_vha = qla2x00_create_host(sht, ha);
 	if (!base_vha) {
@@ -1700,13 +1819,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	qla2x00_config_dma_addressing(base_vha);
 
 	host = base_vha->host;
-	host->can_queue = ha->req->length + 128;
-	if (IS_QLA2XXX_MIDTYPE(ha)) {
+	base_vha->req_ques[0] = req->id;
+	host->can_queue = req->length + 128;
+	if (IS_QLA2XXX_MIDTYPE(ha))
 		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
-	} else {
+	else
 		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
 						base_vha->vp_idx;
-	}
 	if (IS_QLA2100(ha))
 		host->sg_tablesize = 32;
 	host->max_id = max_id;
@@ -1718,6 +1837,21 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 
+	/* Set up the irqs */
+	ret = qla2x00_request_irqs(ha, rsp);
+	if (ret)
+		goto probe_failed;
+
+	/* Alloc arrays of request and response ring ptrs */
+	if (!qla2x00_alloc_queues(ha)) {
+		qla_printk(KERN_WARNING, ha,
+		"[ERROR] Failed to allocate memory for queue"
+		" pointers\n");
+		goto probe_failed;
+	}
+	ha->rsp_q_map[0] = rsp;
+	ha->req_q_map[0] = req;
+
 	if (qla2x00_initialize_adapter(base_vha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
@@ -1730,11 +1864,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	/* Set up the irqs */
-	ret = qla2x00_request_irqs(ha);
-	if (ret)
-		goto probe_failed;
-
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1786,6 +1915,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 probe_failed:
+	qla2x00_free_que(ha, req, rsp);
 	qla2x00_free_device(base_vha);
 
 	scsi_host_put(base_vha->host);
@@ -1836,6 +1966,9 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	if (ha->iobase)
 		iounmap(ha->iobase);
 
+	if (ha->mqiobase)
+		iounmap(ha->mqiobase);
+
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
 	ha = NULL;
@@ -1884,6 +2017,8 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	qla2x00_free_irqs(vha);
 
 	qla2x00_mem_free(ha);
+
+	qla2x00_free_queues(ha);
 }
 
 static inline void
@@ -1998,11 +2133,10 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 *      !0  = failure.
 */
 static int
-qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len)
+qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
+	struct req_que **req, struct rsp_que **rsp)
 {
 	char	name[16];
-	struct req_que *req = NULL;
-	struct rsp_que *rsp = NULL;
 
 	ha->init_cb_size = sizeof(init_cb_t);
 	if (IS_QLA2XXX_MIDTYPE(ha))
@@ -2055,52 +2189,67 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len)
 	}
 
 	/* Allocate memory for request ring */
-	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
-	if (!req) {
+	*req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
+	if (!*req) {
 		DEBUG(printk("Unable to allocate memory for req\n"));
 		goto fail_req;
 	}
-	ha->req = req;
-	req->length = req_len;
-	req->ring = dma_alloc_coherent(&ha->pdev->dev,
-		(req->length + 1) * sizeof(request_t),
-		&req->dma, GFP_KERNEL);
-	if (!req->ring) {
+	(*req)->length = req_len;
+	(*req)->ring = dma_alloc_coherent(&ha->pdev->dev,
+		((*req)->length + 1) * sizeof(request_t),
+		&(*req)->dma, GFP_KERNEL);
+	if (!(*req)->ring) {
 		DEBUG(printk("Unable to allocate memory for req_ring\n"));
 		goto fail_req_ring;
 	}
 	/* Allocate memory for response ring */
-	rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
-	if (!rsp) {
-		DEBUG(printk("Unable to allocate memory for rsp\n"));
+	*rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
+	if (!*rsp) {
+		qla_printk(KERN_WARNING, ha,
+			"Unable to allocate memory for rsp\n");
 		goto fail_rsp;
 	}
-	ha->rsp = rsp;
-	rsp->hw = ha;
-	rsp->length = rsp_len;
-
-	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
-		(rsp->length + 1) * sizeof(response_t),
-		&rsp->dma, GFP_KERNEL);
-	if (!rsp->ring) {
-		DEBUG(printk("Unable to allocate memory for rsp_ring\n"));
+	(*rsp)->hw = ha;
+	(*rsp)->length = rsp_len;
+	(*rsp)->ring = dma_alloc_coherent(&ha->pdev->dev,
+		((*rsp)->length + 1) * sizeof(response_t),
+		&(*rsp)->dma, GFP_KERNEL);
+	if (!(*rsp)->ring) {
+		qla_printk(KERN_WARNING, ha,
+			"Unable to allocate memory for rsp_ring\n");
 		goto fail_rsp_ring;
 	}
+	(*req)->rsp = *rsp;
+	(*rsp)->req = *req;
+	/* Allocate memory for NVRAM data for vports */
+	if (ha->nvram_npiv_size) {
+		ha->npiv_info = kzalloc(sizeof(struct qla_npiv_entry) *
+					ha->nvram_npiv_size, GFP_KERNEL);
+		if (!ha->npiv_info) {
+			qla_printk(KERN_WARNING, ha,
+				"Unable to allocate memory for npiv info\n");
+			goto fail_npiv_info;
+		}
+	} else
+		ha->npiv_info = NULL;
 
 	INIT_LIST_HEAD(&ha->vp_list);
 	return 1;
 
+fail_npiv_info:
+	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
+		sizeof(response_t), (*rsp)->ring, (*rsp)->dma);
+	(*rsp)->ring = NULL;
+	(*rsp)->dma = 0;
 fail_rsp_ring:
-	kfree(rsp);
-	ha->rsp = NULL;
+	kfree(*rsp);
 fail_rsp:
-	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
-		sizeof(request_t), req->ring, req->dma);
-	req->ring = NULL;
-	req->dma = 0;
+	dma_free_coherent(&ha->pdev->dev, ((*req)->length + 1) *
+		sizeof(request_t), (*req)->ring, (*req)->dma);
+	(*req)->ring = NULL;
+	(*req)->dma = 0;
 fail_req_ring:
-	kfree(req);
-	ha->req = NULL;
+	kfree(*req);
 fail_req:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
 		ha->ct_sns, ha->ct_sns_dma);
@@ -2144,9 +2293,6 @@ fail:
 static void
 qla2x00_mem_free(struct qla_hw_data *ha)
 {
-	struct req_que *req = ha->req;
-	struct rsp_que *rsp = ha->rsp;
-
 	if (ha->srb_mempool)
 		mempool_destroy(ha->srb_mempool);
 
@@ -2189,6 +2335,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		ha->init_cb, ha->init_cb_dma);
 	vfree(ha->optrom_buffer);
 	kfree(ha->nvram);
+	kfree(ha->npiv_info);
 
 	ha->srb_mempool = NULL;
 	ha->eft = NULL;
@@ -2210,26 +2357,6 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->fw_dump = NULL;
 	ha->fw_dumped = 0;
 	ha->fw_dump_reading = 0;
-
-	if (rsp) {
-		if (rsp->ring)
-			dma_free_coherent(&ha->pdev->dev,
-			(rsp->length + 1) * sizeof(response_t),
-			rsp->ring, rsp->dma);
-
-		kfree(rsp);
-		rsp = NULL;
-	}
-
-	if (req) {
-		if (req->ring)
-			dma_free_coherent(&ha->pdev->dev,
-			(req->length + 1) * sizeof(request_t),
-			req->ring, req->dma);
-
-		kfree(req);
-		req = NULL;
-	}
 }
 
 struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
@@ -2613,9 +2740,8 @@ qla2x00_sp_free_dma(srb_t *sp)
 }
 
 void
-qla2x00_sp_compl(scsi_qla_host_t *vha, srb_t *sp)
+qla2x00_sp_compl(struct qla_hw_data *ha, srb_t *sp)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct scsi_cmnd *cmd = sp->cmd;
 
 	qla2x00_sp_free_dma(sp);
@@ -2643,7 +2769,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	srb_t		*sp;
 	int		t;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req;
 	/*
 	 * Ports - Port down timer.
 	 *
@@ -2693,6 +2819,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 			if (!vha->vp_idx) {
 				spin_lock_irqsave(&ha->hardware_lock,
 				    cpu_flags);
+				req = ha->req_q_map[0];
 				for (index = 1;
 				    index < MAX_OUTSTANDING_COMMANDS;
 				    index++) {
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 6d6c021..c538ee1 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -547,7 +547,7 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	uint16_t cnt, chksum, *wptr;
 	struct qla_flt_location *fltl;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req = ha->req_q_map[0];
 
 	/*
 	 * FLT-location structure resides after the last PCI region.
@@ -624,7 +624,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	struct qla_flt_header *flt;
 	struct qla_flt_region *region;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req = ha->req_q_map[0];
 
 	ha->flt_region_flt = flt_addr;
 	wptr = (uint16_t *)req->ring;
@@ -730,7 +730,7 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	uint8_t	man_id, flash_id;
 	uint16_t mid, fid;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req;
+	struct req_que *req = ha->req_q_map[0];
 
 	wptr = (uint16_t *)req->ring;
 	fdt = (struct qla_fdt_layout *)req->ring;
@@ -833,6 +833,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	void *data;
 	uint16_t *wptr;
 	uint16_t cnt, chksum;
+	int i;
 	struct qla_npiv_header hdr;
 	struct qla_npiv_entry *entry;
 	struct qla_hw_data *ha = vha->hw;
@@ -876,7 +877,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 
 	entry = data + sizeof(struct qla_npiv_header);
 	cnt = le16_to_cpu(hdr.entries);
-	for ( ; cnt; cnt--, entry++) {
+	for (i = 0; cnt; cnt--, entry++, i++) {
 		uint16_t flags;
 		struct fc_vport_identifiers vid;
 		struct fc_vport *vport;
@@ -894,19 +895,25 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 		vid.port_name = wwn_to_u64(entry->port_name);
 		vid.node_name = wwn_to_u64(entry->node_name);
 
+		memcpy(&ha->npiv_info[i], entry, sizeof(struct qla_npiv_entry));
+
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
-		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt, vid.port_name,
-		    vid.node_name, le16_to_cpu(entry->vf_id),
-		    le16_to_cpu(entry->qos)));
-
-		vport = fc_vport_create(vha->host, 0, &vid);
-		if (!vport)
-			qla_printk(KERN_INFO, ha, "NPIV-Config: Failed to "
-			    "create vport [%02x]: wwpn=%llx wwnn=%llx.\n", cnt,
-			    vid.port_name, vid.node_name);
+			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
+			vid.port_name, vid.node_name, le16_to_cpu(entry->vf_id),
+			entry->q_qos, entry->f_qos));
+
+		if (i < QLA_PRECONFIG_VPORTS) {
+			vport = fc_vport_create(vha->host, 0, &vid);
+			if (!vport)
+				qla_printk(KERN_INFO, ha,
+				"NPIV-Config: Failed to create vport [%02x]: "
+				"wwpn=%llx wwnn=%llx.\n", cnt,
+				vid.port_name, vid.node_name);
+		}
 	}
 done:
 	kfree(data);
+	ha->npiv_info = NULL;
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 54b1100..be22f3a 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.02-k1"
+#define QLA2XXX_VERSION      "8.02.03-k1"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	2
+#define QLA_DRIVER_PATCH_VER	3
 #define QLA_DRIVER_BETA_VER	0
-- 
1.5.5

