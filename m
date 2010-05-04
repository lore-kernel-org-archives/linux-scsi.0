From: giridhar.malavali@qlogic.com
Subject: [PATCH 10/16] qla2xxx: T10 DIF support added.
Date: Tue,  4 May 2010 15:01:30 -0700
Message-ID: <1273010496-43045-11-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47174 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760229Ab0EDWBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:42 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Duane Grigsby <duane.grigsby@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |   16 +
 drivers/scsi/qla2xxx/qla_dbg.c    |   58 ++++
 drivers/scsi/qla2xxx/qla_dbg.h    |   10 +
 drivers/scsi/qla2xxx/qla_def.h    |   84 +++++-
 drivers/scsi/qla2xxx/qla_fw.h     |   47 +++-
 drivers/scsi/qla2xxx/qla_gbl.h    |    4 +
 drivers/scsi/qla2xxx/qla_inline.h |   16 +
 drivers/scsi/qla2xxx/qla_iocb.c   |  678 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c    |   77 +++++
 drivers/scsi/qla2xxx/qla_os.c     |   75 ++++-
 10 files changed, 1053 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5c98b09..62a22cf 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1726,6 +1726,22 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
 	}
 
+	if (IS_QLA25XX(ha) && ql2xenabledif) {
+		if (ha->fw_attributes & BIT_4) {
+			vha->flags.difdix_supported = 1;
+			DEBUG18(qla_printk(KERN_INFO, ha,
+			    "Registering for DIF/DIX type 1 and 3"
+			    " protection.\n"));
+			scsi_host_set_prot(vha->host,
+			    SHOST_DIF_TYPE1_PROTECTION
+			    | SHOST_DIF_TYPE3_PROTECTION
+			    | SHOST_DIX_TYPE1_PROTECTION
+			    | SHOST_DIX_TYPE3_PROTECTION);
+			scsi_host_set_guard(vha->host, SHOST_DIX_GUARD_CRC);
+		} else
+			vha->flags.difdix_supported = 0;
+	}
+
 	if (scsi_add_host_with_dma(vha->host, &fc_vport->dev,
 				   &ha->pdev->dev)) {
 		DEBUG15(printk("scsi(%ld): scsi_add_host failure for VP[%d].\n",
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 89bfc11..2afc8a3 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1663,4 +1663,62 @@ qla2x00_dump_buffer(uint8_t * b, uint32_t size)
 		printk("\n");
 }
 
+void
+qla2x00_dump_buffer_zipped(uint8_t *b, uint32_t size)
+{
+	uint32_t cnt;
+	uint8_t c;
+	uint8_t  last16[16], cur16[16];
+	uint32_t lc = 0, num_same16 = 0, j;
+
+	printk(KERN_DEBUG " 0   1   2   3   4   5   6   7   8   9  "
+	    "Ah  Bh  Ch  Dh  Eh  Fh\n");
+	printk(KERN_DEBUG "----------------------------------------"
+	    "----------------------\n");
+
+	for (cnt = 0; cnt < size;) {
+		c = *b++;
 
+		cur16[lc++] = c;
+
+		cnt++;
+		if (cnt % 16)
+			continue;
+
+		/* We have 16 now */
+		lc = 0;
+		if (num_same16 == 0) {
+			memcpy(last16, cur16, 16);
+			num_same16++;
+			continue;
+		}
+		if (memcmp(cur16, last16, 16) == 0) {
+			num_same16++;
+			continue;
+		}
+		for (j = 0; j < 16; j++)
+			printk(KERN_DEBUG "%02x  ", (uint32_t)last16[j]);
+		printk(KERN_DEBUG "\n");
+
+		if (num_same16 > 1)
+			printk(KERN_DEBUG "> prev pattern repeats (%u)"
+			    "more times\n", num_same16-1);
+		memcpy(last16, cur16, 16);
+		num_same16 = 1;
+	}
+
+	if (num_same16) {
+		for (j = 0; j < 16; j++)
+			printk(KERN_DEBUG "%02x  ", (uint32_t)last16[j]);
+		printk(KERN_DEBUG "\n");
+
+		if (num_same16 > 1)
+			printk(KERN_DEBUG "> prev pattern repeats (%u)"
+			    "more times\n", num_same16-1);
+	}
+	if (lc) {
+		for (j = 0; j < lc; j++)
+			printk(KERN_DEBUG "%02x  ", (uint32_t)cur16[j]);
+		printk(KERN_DEBUG "\n");
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index d6d9c86..916c81f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -27,6 +27,9 @@
 /* #define QL_DEBUG_LEVEL_15 */ /* Output NPIV trace msgs */
 /* #define QL_DEBUG_LEVEL_16 */ /* Output ISP84XX trace msgs */
 /* #define QL_DEBUG_LEVEL_17 */ /* Output EEH trace messages */
+/* #define QL_DEBUG_LEVEL_18 */ /* Output T10 CRC trace messages */
+
+/* #define QL_PRINTK_BUF */ /* Captures printk to buffer */
 
 /*
 * Macros use for debugging the driver.
@@ -139,6 +142,13 @@
 #define DEBUG17(x)	do {} while (0)
 #endif
 
+#if defined(QL_DEBUG_LEVEL_18)
+#define DEBUG18(x)	do {if (ql2xextended_error_logging) x; } while (0)
+#else
+#define DEBUG18(x)	do {} while (0)
+#endif
+
+
 /*
  * Firmware Dump structure definition
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0d2cecb..4559f5c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -189,6 +189,16 @@
 struct req_que;
 
 /*
+ * (sd.h is not exported, hence local inclusion)
+ * Data Integrity Field tuple.
+ */
+struct sd_dif_tuple {
+	__be16 guard_tag;	/* Checksum */
+	__be16 app_tag;		/* Opaque storage */
+	__be32 ref_tag;		/* Target LBA or indirect LBA */
+};
+
+/*
  * SCSI Request Block
  */
 typedef struct srb {
@@ -208,8 +218,14 @@ typedef struct srb {
 /*
  * SRB flag definitions
  */
-#define SRB_DMA_VALID		BIT_0	/* Command sent to ISP */
-#define SRB_FCP_CMND_DMA_VALID	BIT_12  /* FCP command in IOCB */
+#define SRB_DMA_VALID			BIT_0	/* Command sent to ISP */
+#define SRB_FCP_CMND_DMA_VALID		BIT_12	/* DIF: DSD List valid */
+#define SRB_CRC_CTX_DMA_VALID		BIT_2	/* DIF: context DMA valid */
+#define SRB_CRC_PROT_DMA_VALID		BIT_4	/* DIF: prot DMA valid */
+#define SRB_CRC_CTX_DSD_VALID		BIT_5	/* DIF: dsd_list valid */
+
+/* To identify if a srb is of T10-CRC type. @sp => srb_t pointer */
+#define IS_PROT_IO(sp)	(sp->flags & SRB_CRC_CTX_DSD_VALID)
 
 /*
  * SRB extensions.
@@ -1330,6 +1346,66 @@ typedef struct {
 	uint32_t dseg_4_length;		/* Data segment 4 length. */
 } cont_a64_entry_t;
 
+#define PO_MODE_DIF_INSERT	0
+#define PO_MODE_DIF_REMOVE	BIT_0
+#define PO_MODE_DIF_PASS	BIT_1
+#define PO_MODE_DIF_REPLACE	(BIT_0 + BIT_1)
+#define PO_ENABLE_DIF_BUNDLING	BIT_8
+#define PO_ENABLE_INCR_GUARD_SEED	BIT_3
+#define PO_DISABLE_INCR_REF_TAG	BIT_5
+#define PO_DISABLE_GUARD_CHECK	BIT_4
+/*
+ * ISP queue - 64-Bit addressing, continuation crc entry structure definition.
+ */
+struct crc_context {
+	uint32_t handle;		/* System handle. */
+	uint32_t ref_tag;
+	uint16_t app_tag;
+	uint8_t ref_tag_mask[4];	/* Validation/Replacement Mask*/
+	uint8_t app_tag_mask[2];	/* Validation/Replacement Mask*/
+	uint16_t guard_seed;		/* Initial Guard Seed */
+	uint16_t prot_opts;		/* Requested Data Protection Mode */
+	uint16_t blk_size;		/* Data size in bytes */
+	uint16_t runt_blk_guard;	/* Guard value for runt block (tape
+					 * only) */
+	uint32_t byte_count;		/* Total byte count/ total data
+					 * transfer count */
+	union {
+		struct {
+			uint32_t	reserved_1;
+			uint16_t	reserved_2;
+			uint16_t	reserved_3;
+			uint32_t	reserved_4;
+			uint32_t	data_address[2];
+			uint32_t	data_length;
+			uint32_t	reserved_5[2];
+			uint32_t	reserved_6;
+		} nobundling;
+		struct {
+			uint32_t	dif_byte_count;	/* Total DIF byte
+							 * count */
+			uint16_t	reserved_1;
+			uint16_t	dseg_count;	/* Data segment count */
+			uint32_t	reserved_2;
+			uint32_t	data_address[2];
+			uint32_t	data_length;
+			uint32_t	dif_address[2];
+			uint32_t	dif_length;	/* Data segment 0
+							 * length */
+		} bundling;
+	} u;
+
+	struct fcp_cmnd	fcp_cmnd;
+	dma_addr_t	crc_ctx_dma;
+	/* List of DMA context transfers */
+	struct list_head dsd_list;
+
+	/* This structure should not exceed 512 bytes */
+};
+
+#define CRC_CONTEXT_LEN_FW	(offsetof(struct crc_context, fcp_cmnd.lun))
+#define CRC_CONTEXT_FCPCMND_OFF	(offsetof(struct crc_context, fcp_cmnd.lun))
+
 /*
  * ISP queue - status entry structure definition.
  */
@@ -1390,6 +1466,7 @@ typedef struct {
 #define CS_ABORTED		0x5	/* System aborted command. */
 #define CS_TIMEOUT		0x6	/* Timeout error. */
 #define CS_DATA_OVERRUN		0x7	/* Data overrun. */
+#define CS_DIF_ERROR		0xC	/* DIF error detected  */
 
 #define CS_DATA_UNDERRUN	0x15	/* Data Underrun. */
 #define CS_QUEUE_FULL		0x1C	/* Queue Full. */
@@ -2732,6 +2809,7 @@ typedef struct scsi_qla_host {
 
 		uint32_t	management_server_logged_in :1;
 		uint32_t	process_response_queue	:1;
+		uint32_t	difdix_supported:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2883,6 +2961,8 @@ typedef struct scsi_qla_host {
 #define OPTROM_BURST_SIZE	0x1000
 #define OPTROM_BURST_DWORDS	(OPTROM_BURST_SIZE / 4)
 
+#define	QLA_DSDS_PER_IOCB	37
+
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index a77a247..93f8339 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -400,6 +400,7 @@ struct cmd_type_6 {
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
 	uint16_t control_flags;		/* Control flags. */
+#define CF_DIF_SEG_DESCR_ENABLE		BIT_3
 #define CF_DATA_SEG_DESCR_ENABLE	BIT_2
 #define CF_READ_DATA			BIT_1
 #define CF_WRITE_DATA			BIT_0
@@ -466,6 +467,43 @@ struct cmd_type_7 {
 	uint32_t dseg_0_len;		/* Data segment 0 length. */
 };
 
+#define COMMAND_TYPE_CRC_2	0x6A	/* Command Type CRC_2 (Type 6)
+					 * (T10-DIF) */
+struct cmd_type_crc_2 {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+	uint16_t timeout;		/* Command timeout. */
+
+	uint16_t dseg_count;		/* Data segment count. */
+
+	uint16_t fcp_rsp_dseg_len;	/* FCP_RSP DSD length. */
+
+	struct scsi_lun lun;		/* FCP LUN (BE). */
+
+	uint16_t control_flags;		/* Control flags. */
+
+	uint16_t fcp_cmnd_dseg_len;		/* Data segment length. */
+	uint32_t fcp_cmnd_dseg_address[2];	/* Data segment address. */
+
+	uint32_t fcp_rsp_dseg_address[2];	/* Data segment address. */
+
+	uint32_t byte_count;		/* Total byte count. */
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+	uint8_t vp_index;
+
+	uint32_t crc_context_address[2];	/* Data segment address. */
+	uint16_t crc_context_len;		/* Data segment length. */
+	uint16_t reserved_1;			/* MUST be set to 0. */
+};
+
+
 /*
  * ISP queue - status entry structure definition.
  */
@@ -496,10 +534,17 @@ struct sts_entry_24xx {
 
 	uint32_t sense_len;		/* FCP SENSE length. */
 	uint32_t rsp_data_len;		/* FCP response data length. */
-
 	uint8_t data[28];		/* FCP response/sense information. */
+	/*
+	 * If DIF Error is set in comp_status, these additional fields are
+	 * defined:
+	 * &data[10] : uint8_t report_runt_bg[2];	- computed guard
+	 * &data[12] : uint8_t actual_dif[8];		- DIF Data recieved
+	 * &data[20] : uint8_t expected_dif[8];		- DIF Data computed
+	*/
 };
 
+
 /*
  * Status entry completion status
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3dbefe1..3e946da 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -94,6 +94,8 @@ extern int ql2xshiftctondsd;
 extern int ql2xdbwr;
 extern int ql2xdontresethba;
 extern int ql2xasynctmfenable;
+extern int ql2xenabledif;
+extern int ql2xenablehba_err_chk;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -179,6 +181,7 @@ extern int qla2x00_start_sp(srb_t *);
 extern void qla2x00_ctx_sp_free(srb_t *);
 extern uint16_t qla24xx_calc_iocbs(uint16_t);
 extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *, uint16_t);
+extern int qla24xx_dif_start_scsi(srb_t *);
 
 
 /*
@@ -423,6 +426,7 @@ extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla81xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
+extern void qla2x00_dump_buffer_zipped(uint8_t *, uint32_t);
 
 /*
  * Global Function Prototypes in qla_gs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index ad53c64..84c2fea 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -67,3 +67,19 @@ qla2x00_is_reserved_id(scsi_qla_host_t *vha, uint16_t loop_id)
 	return ((loop_id > ha->max_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
 	    loop_id == MANAGEMENT_SERVER || loop_id == BROADCAST);
 }
+
+static inline void
+qla2x00_clean_dsd_pool(struct qla_hw_data *ha, srb_t *sp)
+{
+	struct dsd_dma *dsd_ptr, *tdsd_ptr;
+
+	/* clean up allocated prev pool */
+	list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
+	    &((struct crc_context *)sp->ctx)->dsd_list, list) {
+		dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
+		    dsd_ptr->dsd_list_dma);
+		list_del(&dsd_ptr->list);
+		kfree(dsd_ptr);
+	}
+	INIT_LIST_HEAD(&((struct crc_context *)sp->ctx)->dsd_list);
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d7a9fff..8ef9453 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -145,7 +145,49 @@ qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha)
 	return (cont_pkt);
 }
 
-/**
+static inline int
+qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
+{
+	uint8_t	guard = scsi_host_get_guard(sp->cmd->device->host);
+
+	/* We only support T10 DIF right now */
+	if (guard != SHOST_DIX_GUARD_CRC) {
+		DEBUG2(printk(KERN_ERR "Unsupported guard: %d\n", guard));
+		return 0;
+	}
+
+	/* We always use DIFF Bundling for best performance */
+	*fw_prot_opts = 0;
+
+	/* Translate SCSI opcode to a protection opcode */
+	switch (scsi_get_prot_op(sp->cmd)) {
+	case SCSI_PROT_READ_STRIP:
+		*fw_prot_opts |= PO_MODE_DIF_REMOVE;
+		break;
+	case SCSI_PROT_WRITE_INSERT:
+		*fw_prot_opts |= PO_MODE_DIF_INSERT;
+		break;
+	case SCSI_PROT_READ_INSERT:
+		*fw_prot_opts |= PO_MODE_DIF_INSERT;
+		break;
+	case SCSI_PROT_WRITE_STRIP:
+		*fw_prot_opts |= PO_MODE_DIF_REMOVE;
+		break;
+	case SCSI_PROT_READ_PASS:
+		*fw_prot_opts |= PO_MODE_DIF_PASS;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+		*fw_prot_opts |= PO_MODE_DIF_PASS;
+		break;
+	default:	/* Normal Request */
+		*fw_prot_opts |= PO_MODE_DIF_PASS;
+		break;
+	}
+
+	return scsi_prot_sg_count(sp->cmd);
+}
+
+/*
  * qla2x00_build_scsi_iocbs_32() - Build IOCB command utilizing 32bit
  * capable IOCB types.
  *
@@ -636,6 +678,8 @@ qla24xx_calc_iocbs(uint16_t dsds)
 		if ((dsds - 1) % 5)
 			iocbs++;
 	}
+	DEBUG3(printk(KERN_DEBUG "%s(): Required PKT(s) = %d\n",
+	    __func__, iocbs));
 	return iocbs;
 }
 
@@ -716,6 +760,453 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 }
 
+struct fw_dif_context {
+	uint32_t ref_tag;
+	uint16_t app_tag;
+	uint8_t ref_tag_mask[4];	/* Validation/Replacement Mask*/
+	uint8_t app_tag_mask[2];	/* Validation/Replacement Mask*/
+};
+
+/*
+ * qla24xx_set_t10dif_tags_from_cmd - Extract Ref and App tags from SCSI command
+ *
+ */
+static inline void
+qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
+    unsigned int protcnt)
+{
+	struct sd_dif_tuple *spt;
+	unsigned char op = scsi_get_prot_op(cmd);
+
+	switch (scsi_get_prot_type(cmd)) {
+	/* For TYPE 0 protection: no checking */
+	case SCSI_PROT_DIF_TYPE0:
+		pkt->ref_tag_mask[0] = 0x00;
+		pkt->ref_tag_mask[1] = 0x00;
+		pkt->ref_tag_mask[2] = 0x00;
+		pkt->ref_tag_mask[3] = 0x00;
+		break;
+
+	/*
+	 * For TYPE 2 protection: 16 bit GUARD + 32 bit REF tag has to
+	 * match LBA in CDB + N
+	 */
+	case SCSI_PROT_DIF_TYPE2:
+		break;
+
+	/* For Type 3 protection: 16 bit GUARD only */
+	case SCSI_PROT_DIF_TYPE3:
+		pkt->ref_tag_mask[0] = pkt->ref_tag_mask[1] =
+			pkt->ref_tag_mask[2] = pkt->ref_tag_mask[3] =
+								0x00;
+		break;
+
+	/*
+	 * For TYpe 1 protection: 16 bit GUARD tag, 32 bit REF tag, and
+	 * 16 bit app tag.
+	 */
+	case SCSI_PROT_DIF_TYPE1:
+		if (!ql2xenablehba_err_chk)
+			break;
+
+		if (protcnt && (op == SCSI_PROT_WRITE_STRIP ||
+		    op == SCSI_PROT_WRITE_PASS)) {
+			spt = page_address(sg_page(scsi_prot_sglist(cmd))) +
+			    scsi_prot_sglist(cmd)[0].offset;
+			DEBUG18(printk(KERN_DEBUG
+			    "%s(): LBA from user %p, lba = 0x%x\n",
+			    __func__, spt, (int)spt->ref_tag));
+			pkt->ref_tag = swab32(spt->ref_tag);
+			pkt->app_tag_mask[0] = 0x0;
+			pkt->app_tag_mask[1] = 0x0;
+		} else {
+			pkt->ref_tag = cpu_to_le32((uint32_t)
+			    (0xffffffff & scsi_get_lba(cmd)));
+			pkt->app_tag = __constant_cpu_to_le16(0);
+			pkt->app_tag_mask[0] = 0x0;
+			pkt->app_tag_mask[1] = 0x0;
+		}
+		/* enable ALL bytes of the ref tag */
+		pkt->ref_tag_mask[0] = 0xff;
+		pkt->ref_tag_mask[1] = 0xff;
+		pkt->ref_tag_mask[2] = 0xff;
+		pkt->ref_tag_mask[3] = 0xff;
+		break;
+	}
+
+	DEBUG18(printk(KERN_DEBUG
+	    "%s(): Setting protection Tags: (BIG) ref tag = 0x%x,"
+	    " app tag = 0x%x, prot SG count %d , cmd lba 0x%x,"
+	    " prot_type=%u\n", __func__, pkt->ref_tag, pkt->app_tag, protcnt,
+	    (int)scsi_get_lba(cmd), scsi_get_prot_type(cmd)));
+}
+
+
+static int
+qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
+	uint16_t tot_dsds)
+{
+	void *next_dsd;
+	uint8_t avail_dsds = 0;
+	uint32_t dsd_list_len;
+	struct dsd_dma *dsd_ptr;
+	struct scatterlist *sg;
+	uint32_t *cur_dsd = dsd;
+	int	i;
+	uint16_t	used_dsds = tot_dsds;
+
+	uint8_t		*cp;
+
+	scsi_for_each_sg(sp->cmd, sg, tot_dsds, i) {
+		dma_addr_t	sle_dma;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			avail_dsds = (used_dsds > QLA_DSDS_PER_IOCB) ?
+					QLA_DSDS_PER_IOCB : used_dsds;
+			dsd_list_len = (avail_dsds + 1) * 12;
+			used_dsds -= avail_dsds;
+
+			/* allocate tracking DS */
+			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
+			if (!dsd_ptr)
+				return 1;
+
+			/* allocate new list */
+			dsd_ptr->dsd_addr = next_dsd =
+			    dma_pool_alloc(ha->dl_dma_pool, GFP_ATOMIC,
+				&dsd_ptr->dsd_list_dma);
+
+			if (!next_dsd) {
+				/*
+				 * Need to cleanup only this dsd_ptr, rest
+				 * will be done by sp_free_dma()
+				 */
+				kfree(dsd_ptr);
+				return 1;
+			}
+
+			list_add_tail(&dsd_ptr->list,
+			    &((struct crc_context *)sp->ctx)->dsd_list);
+
+			sp->flags |= SRB_CRC_CTX_DSD_VALID;
+
+			/* add new list to cmd iocb or last list */
+			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = dsd_list_len;
+			cur_dsd = (uint32_t *)next_dsd;
+		}
+		sle_dma = sg_dma_address(sg);
+		DEBUG18(printk("%s(): %p, sg entry %d - addr =0x%x 0x%x,"
+		    " len =%d\n", __func__ , cur_dsd, i, LSD(sle_dma),
+		    MSD(sle_dma), sg_dma_len(sg)));
+		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
+		avail_dsds--;
+
+		if (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_PASS) {
+			cp = page_address(sg_page(sg)) + sg->offset;
+			DEBUG18(printk("%s(): User Data buffer= %p:\n",
+			    __func__ , cp));
+		}
+	}
+	/* Null termination */
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	return 0;
+}
+
+static int
+qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
+							uint32_t *dsd,
+	uint16_t tot_dsds)
+{
+	void *next_dsd;
+	uint8_t avail_dsds = 0;
+	uint32_t dsd_list_len;
+	struct dsd_dma *dsd_ptr;
+	struct scatterlist *sg;
+	int	i;
+	struct scsi_cmnd *cmd;
+	uint32_t *cur_dsd = dsd;
+	uint16_t	used_dsds = tot_dsds;
+
+	uint8_t		*cp;
+
+
+	cmd = sp->cmd;
+	scsi_for_each_prot_sg(cmd, sg, tot_dsds, i) {
+		dma_addr_t	sle_dma;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			avail_dsds = (used_dsds > QLA_DSDS_PER_IOCB) ?
+						QLA_DSDS_PER_IOCB : used_dsds;
+			dsd_list_len = (avail_dsds + 1) * 12;
+			used_dsds -= avail_dsds;
+
+			/* allocate tracking DS */
+			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
+			if (!dsd_ptr)
+				return 1;
+
+			/* allocate new list */
+			dsd_ptr->dsd_addr = next_dsd =
+			    dma_pool_alloc(ha->dl_dma_pool, GFP_ATOMIC,
+				&dsd_ptr->dsd_list_dma);
+
+			if (!next_dsd) {
+				/*
+				 * Need to cleanup only this dsd_ptr, rest
+				 * will be done by sp_free_dma()
+				 */
+				kfree(dsd_ptr);
+				return 1;
+			}
+
+			list_add_tail(&dsd_ptr->list,
+			    &((struct crc_context *)sp->ctx)->dsd_list);
+
+			sp->flags |= SRB_CRC_CTX_DSD_VALID;
+
+			/* add new list to cmd iocb or last list */
+			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = dsd_list_len;
+			cur_dsd = (uint32_t *)next_dsd;
+		}
+		sle_dma = sg_dma_address(sg);
+		if (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_PASS) {
+			DEBUG18(printk(KERN_DEBUG
+			    "%s(): %p, sg entry %d - addr =0x%x"
+			    "0x%x, len =%d\n", __func__ , cur_dsd, i,
+			    LSD(sle_dma), MSD(sle_dma), sg_dma_len(sg)));
+		}
+		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
+
+		if (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_PASS) {
+			cp = page_address(sg_page(sg)) + sg->offset;
+			DEBUG18(printk("%s(): Protection Data buffer = %p:\n",
+			    __func__ , cp));
+		}
+		avail_dsds--;
+	}
+	/* Null termination */
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	return 0;
+}
+
+/**
+ * qla24xx_build_scsi_crc_2_iocbs() - Build IOCB command utilizing Command
+ *							Type 6 IOCB types.
+ *
+ * @sp: SRB command to process
+ * @cmd_pkt: Command type 3 IOCB
+ * @tot_dsds: Total number of segments to transfer
+ */
+static inline int
+qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
+    uint16_t tot_dsds, uint16_t tot_prot_dsds, uint16_t fw_prot_opts)
+{
+	uint32_t		*cur_dsd, *fcp_dl;
+	scsi_qla_host_t		*vha;
+	struct scsi_cmnd	*cmd;
+	struct scatterlist	*cur_seg;
+	int			sgc;
+	uint32_t		total_bytes;
+	uint32_t		data_bytes;
+	uint32_t		dif_bytes;
+	uint8_t			bundling = 1;
+	uint16_t		blk_size;
+	uint8_t			*clr_ptr;
+	struct crc_context	*crc_ctx_pkt = NULL;
+	struct qla_hw_data	*ha;
+	uint8_t			additional_fcpcdb_len;
+	uint16_t		fcp_cmnd_len;
+	struct fcp_cmnd		*fcp_cmnd;
+	dma_addr_t		crc_ctx_dma;
+
+	cmd = sp->cmd;
+
+	sgc = 0;
+	/* Update entry type to indicate Command Type CRC_2 IOCB */
+	*((uint32_t *)(&cmd_pkt->entry_type)) =
+	    __constant_cpu_to_le32(COMMAND_TYPE_CRC_2);
+
+	/* No data transfer */
+	data_bytes = scsi_bufflen(cmd);
+	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
+		DEBUG18(printk(KERN_INFO "%s: Zero data bytes or DMA-NONE %d\n",
+		    __func__, data_bytes));
+		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		return QLA_SUCCESS;
+	}
+
+	vha = sp->fcport->vha;
+	ha = vha->hw;
+
+	DEBUG18(printk(KERN_DEBUG
+	    "%s(%ld): Executing cmd sp %p, pid=%ld, prot_op=%u.\n", __func__,
+	    vha->host_no, sp, cmd->serial_number, scsi_get_prot_op(sp->cmd)));
+
+	cmd_pkt->vp_index = sp->fcport->vp_idx;
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		cmd_pkt->control_flags =
+		    __constant_cpu_to_le16(CF_WRITE_DATA);
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		cmd_pkt->control_flags =
+		    __constant_cpu_to_le16(CF_READ_DATA);
+	}
+
+	tot_prot_dsds = scsi_prot_sg_count(cmd);
+	if (!tot_prot_dsds)
+		bundling = 0;
+
+	/* Allocate CRC context from global pool */
+	crc_ctx_pkt = sp->ctx = dma_pool_alloc(ha->dl_dma_pool,
+	    GFP_ATOMIC, &crc_ctx_dma);
+
+	if (!crc_ctx_pkt)
+		goto crc_queuing_error;
+
+	/* Zero out CTX area. */
+	clr_ptr = (uint8_t *)crc_ctx_pkt;
+	memset(clr_ptr, 0, sizeof(*crc_ctx_pkt));
+
+	crc_ctx_pkt->crc_ctx_dma = crc_ctx_dma;
+
+	sp->flags |= SRB_CRC_CTX_DMA_VALID;
+
+	/* Set handle */
+	crc_ctx_pkt->handle = cmd_pkt->handle;
+
+	INIT_LIST_HEAD(&crc_ctx_pkt->dsd_list);
+
+	qla24xx_set_t10dif_tags(cmd, (struct fw_dif_context *)
+	    &crc_ctx_pkt->ref_tag, tot_prot_dsds);
+
+	cmd_pkt->crc_context_address[0] = cpu_to_le32(LSD(crc_ctx_dma));
+	cmd_pkt->crc_context_address[1] = cpu_to_le32(MSD(crc_ctx_dma));
+	cmd_pkt->crc_context_len = CRC_CONTEXT_LEN_FW;
+
+	/* Determine SCSI command length -- align to 4 byte boundary */
+	if (cmd->cmd_len > 16) {
+		DEBUG18(printk(KERN_INFO "%s(): **** SCSI CMD > 16\n",
+		    __func__));
+		additional_fcpcdb_len = cmd->cmd_len - 16;
+		if ((cmd->cmd_len % 4) != 0) {
+			/* SCSI cmd > 16 bytes must be multiple of 4 */
+			goto crc_queuing_error;
+		}
+		fcp_cmnd_len = 12 + cmd->cmd_len + 4;
+	} else {
+		additional_fcpcdb_len = 0;
+		fcp_cmnd_len = 12 + 16 + 4;
+	}
+
+	fcp_cmnd = &crc_ctx_pkt->fcp_cmnd;
+
+	fcp_cmnd->additional_cdb_len = additional_fcpcdb_len;
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		fcp_cmnd->additional_cdb_len |= 1;
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		fcp_cmnd->additional_cdb_len |= 2;
+
+	int_to_scsilun(sp->cmd->device->lun, &fcp_cmnd->lun);
+	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
+	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
+	cmd_pkt->fcp_cmnd_dseg_address[0] = cpu_to_le32(
+	    LSD(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF));
+	cmd_pkt->fcp_cmnd_dseg_address[1] = cpu_to_le32(
+	    MSD(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF));
+	fcp_cmnd->task_attribute = 0;
+	fcp_cmnd->task_managment = 0;
+
+	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
+
+	DEBUG18(printk(KERN_INFO "%s(%ld): Total SG(s) Entries %d, Data"
+	    "entries %d, data bytes %d, Protection entries %d\n",
+	    __func__, vha->host_no, tot_dsds, (tot_dsds-tot_prot_dsds),
+	    data_bytes, tot_prot_dsds));
+
+	/* Compute dif len and adjust data len to incude protection */
+	total_bytes = data_bytes;
+	dif_bytes = 0;
+	blk_size = cmd->device->sector_size;
+	if (scsi_get_prot_type(cmd) == SCSI_PROT_DIF_TYPE1) {
+		dif_bytes = (data_bytes / blk_size) * 8;
+		total_bytes += dif_bytes;
+	}
+
+	if (!ql2xenablehba_err_chk)
+		fw_prot_opts |= 0x10; /* Disable Guard tag checking */
+
+	if (!bundling) {
+		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.nobundling.data_address;
+	} else {
+		/*
+		 * Configure Bundling if we need to fetch interlaving
+		 * protection PCI accesses
+		 */
+		fw_prot_opts |= PO_ENABLE_DIF_BUNDLING;
+		crc_ctx_pkt->u.bundling.dif_byte_count = cpu_to_le32(dif_bytes);
+		crc_ctx_pkt->u.bundling.dseg_count = cpu_to_le16(tot_dsds -
+							tot_prot_dsds);
+		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.data_address;
+	}
+
+	/* Finish the common fields of CRC pkt */
+	crc_ctx_pkt->blk_size = cpu_to_le16(blk_size);
+	crc_ctx_pkt->prot_opts = cpu_to_le16(fw_prot_opts);
+	crc_ctx_pkt->byte_count = cpu_to_le32(data_bytes);
+	crc_ctx_pkt->guard_seed = __constant_cpu_to_le16(0);
+	/* Fibre channel byte count */
+	cmd_pkt->byte_count = cpu_to_le32(total_bytes);
+	fcp_dl = (uint32_t *)(crc_ctx_pkt->fcp_cmnd.cdb + 16 +
+	    additional_fcpcdb_len);
+	*fcp_dl = htonl(total_bytes);
+
+	DEBUG18(printk(KERN_INFO "%s(%ld): dif bytes = 0x%x (%d), total bytes"
+	    " = 0x%x (%d), dat block size =0x%x (%d)\n", __func__,
+	    vha->host_no, dif_bytes, dif_bytes, total_bytes, total_bytes,
+	    crc_ctx_pkt->blk_size, crc_ctx_pkt->blk_size));
+
+	/* Walks data segments */
+
+	cmd_pkt->control_flags |=
+	    __constant_cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
+	if (qla24xx_walk_and_build_sglist(ha, sp, cur_dsd,
+	    (tot_dsds - tot_prot_dsds)))
+		goto crc_queuing_error;
+
+	if (bundling && tot_prot_dsds) {
+		/* Walks dif segments */
+		cur_seg = scsi_prot_sglist(cmd);
+		cmd_pkt->control_flags |=
+			__constant_cpu_to_le16(CF_DIF_SEG_DESCR_ENABLE);
+		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
+		if (qla24xx_walk_and_build_prot_sglist(ha, sp, cur_dsd,
+		    tot_prot_dsds))
+			goto crc_queuing_error;
+	}
+	return QLA_SUCCESS;
+
+crc_queuing_error:
+	DEBUG18(qla_printk(KERN_INFO, ha,
+	    "CMD sent FAILED crc_q error:sp = %p\n", sp));
+	/* Cleanup will be performed by the caller */
+
+	return QLA_FUNCTION_FAILED;
+}
 
 /**
  * qla24xx_start_scsi() - Send a SCSI command to the ISP
@@ -869,6 +1360,191 @@ queuing_error:
 	return QLA_FUNCTION_FAILED;
 }
 
+
+/**
+ * qla24xx_dif_start_scsi() - Send a SCSI command to the ISP
+ * @sp: command to send to the ISP
+ *
+ * Returns non-zero if a failure occurred, else zero.
+ */
+int
+qla24xx_dif_start_scsi(srb_t *sp)
+{
+	int			nseg;
+	unsigned long		flags;
+	uint32_t		*clr_ptr;
+	uint32_t		index;
+	uint32_t		handle;
+	uint16_t		cnt;
+	uint16_t		req_cnt = 0;
+	uint16_t		tot_dsds;
+	uint16_t		tot_prot_dsds;
+	uint16_t		fw_prot_opts = 0;
+	struct req_que		*req = NULL;
+	struct rsp_que		*rsp = NULL;
+	struct scsi_cmnd	*cmd = sp->cmd;
+	struct scsi_qla_host	*vha = sp->fcport->vha;
+	struct qla_hw_data	*ha = vha->hw;
+	struct cmd_type_crc_2	*cmd_pkt;
+	uint32_t		status = 0;
+
+#define QDSS_GOT_Q_SPACE	BIT_0
+
+	/* Only process protection in this routine */
+	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL)
+		return qla24xx_start_scsi(sp);
+
+	/* Setup device pointers. */
+
+	qla25xx_set_que(sp, &rsp);
+	req = vha->req;
+
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	/* Send marker if required */
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+		vha->marker_needed = 0;
+	}
+
+	/* Acquire ring specific lock */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+
+	if (index == MAX_OUTSTANDING_COMMANDS)
+		goto queuing_error;
+
+	/* Compute number of required data segments */
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (scsi_sg_count(cmd)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+		else
+			sp->flags |= SRB_DMA_VALID;
+	} else
+		nseg = 0;
+
+	/* number of required data segments */
+	tot_dsds = nseg;
+
+	/* Compute number of required protection segments */
+	if (qla24xx_configure_prot_mode(sp, &fw_prot_opts)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_prot_sglist(cmd),
+		    scsi_prot_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+		else
+			sp->flags |= SRB_CRC_PROT_DMA_VALID;
+	} else {
+		nseg = 0;
+	}
+
+	req_cnt = 1;
+	/* Total Data and protection sg segment(s) */
+	tot_prot_dsds = nseg;
+	tot_dsds += nseg;
+	if (req->cnt < (req_cnt + 2)) {
+		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
+
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
+		else
+			req->cnt = req->length -
+				(req->ring_index - cnt);
+	}
+
+	if (req->cnt < (req_cnt + 2))
+		goto queuing_error;
+
+	status |= QDSS_GOT_Q_SPACE;
+
+	/* Build header part of command packet (excluding the OPCODE). */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	req->cnt -= req_cnt;
+
+	/* Fill-in common area */
+	cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
+	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+
+	clr_ptr = (uint32_t *)cmd_pkt + 2;
+	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+
+	/* Set NPORT-ID and LUN number*/
+	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+
+	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+
+	/* Total Data and protection segment(s) */
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+	/* Build IOCB segments and adjust for data protection segments */
+	if (qla24xx_build_scsi_crc_2_iocbs(sp, (struct cmd_type_crc_2 *)
+	    req->ring_ptr, tot_dsds, tot_prot_dsds, fw_prot_opts) !=
+		QLA_SUCCESS)
+		goto queuing_error;
+
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	/* Specify response queue number where completion should happen */
+	cmd_pkt->entry_status = (uint8_t) rsp->id;
+	cmd_pkt->timeout = __constant_cpu_to_le16(0);
+	wmb();
+
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else
+		req->ring_ptr++;
+
+	/* Set chip new ring index. */
+	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	RD_REG_DWORD_RELAXED(&ha->iobase->isp24.hccr);
+
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_SUCCESS;
+
+queuing_error:
+	if (status & QDSS_GOT_Q_SPACE) {
+		req->outstanding_cmds[handle] = NULL;
+		req->cnt += req_cnt;
+	}
+	/* Cleanup will be performed by the caller (queuecommand) */
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	DEBUG18(qla_printk(KERN_INFO, ha,
+	    "CMD sent FAILED SCSI prot_op:%02x\n", scsi_get_prot_op(cmd)));
+	return QLA_FUNCTION_FAILED;
+}
+
+
 static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 {
 	struct scsi_cmnd *cmd = sp->cmd;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index eed71ea..be3d8be 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_bsg_fc.h>
+#include <scsi/scsi_eh.h>
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_process_completed_request(struct scsi_qla_host *,
@@ -1364,6 +1365,78 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len,
 		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer, sense_len));
 }
 
+struct scsi_dif_tuple {
+	__be16 guard;       /* Checksum */
+	__be16 app_tag;         /* APPL identifer */
+	__be32 ref_tag;         /* Target LBA or indirect LBA */
+};
+
+/*
+ * Checks the guard or meta-data for the type of error
+ * detected by the HBA. In case of errors, we set the
+ * ASC/ASCQ fields in the sense buffer with ILLEGAL_REQUEST
+ * to indicate to the kernel that the HBA detected error.
+ */
+static inline void
+qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
+{
+	struct scsi_cmnd *cmd = sp->cmd;
+	struct scsi_dif_tuple	*ep =
+			(struct scsi_dif_tuple *)&sts24->data[20];
+	struct scsi_dif_tuple	*ap =
+			(struct scsi_dif_tuple *)&sts24->data[12];
+	uint32_t	e_ref_tag, a_ref_tag;
+	uint16_t	e_app_tag, a_app_tag;
+	uint16_t	e_guard, a_guard;
+
+	e_ref_tag = be32_to_cpu(ep->ref_tag);
+	a_ref_tag = be32_to_cpu(ap->ref_tag);
+	e_app_tag = be16_to_cpu(ep->app_tag);
+	a_app_tag = be16_to_cpu(ap->app_tag);
+	e_guard = be16_to_cpu(ep->guard);
+	a_guard = be16_to_cpu(ap->guard);
+
+	DEBUG18(printk(KERN_DEBUG
+	    "%s(): iocb(s) %p Returned STATUS\n", __func__, sts24));
+
+	DEBUG18(printk(KERN_ERR "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
+	    " tag=0x%x, exp ref_tag=0x%x, act app tag=0x%x, exp app"
+	    " tag=0x%x, act guard=0x%x, exp guard=0x%x\n",
+	    cmd->cmnd[0], (u64)scsi_get_lba(cmd), a_ref_tag, e_ref_tag,
+	    a_app_tag, e_app_tag, a_guard, e_guard));
+
+
+	/* check guard */
+	if (e_guard != a_guard) {
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x10, 0x1);
+		set_driver_byte(cmd, DRIVER_SENSE);
+		set_host_byte(cmd, DID_ABORT);
+		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		return;
+	}
+
+	/* check appl tag */
+	if (e_app_tag != a_app_tag) {
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x10, 0x2);
+		set_driver_byte(cmd, DRIVER_SENSE);
+		set_host_byte(cmd, DID_ABORT);
+		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		return;
+	}
+
+	/* check ref tag */
+	if (e_ref_tag != a_ref_tag) {
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x10, 0x3);
+		set_driver_byte(cmd, DRIVER_SENSE);
+		set_host_byte(cmd, DID_ABORT);
+		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		return;
+	}
+}
+
 /**
  * qla2x00_status_entry() - Process a Status IOCB entry.
  * @ha: SCSI driver HA context
@@ -1630,6 +1703,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	case CS_ABORTED:
 		cp->result = DID_RESET << 16;
 		break;
+
+	case CS_DIF_ERROR:
+		qla2x00_handle_dif_error(sp, sts24);
+		break;
 	default:
 		cp->result = DID_ERROR << 16;
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 523d414..5104aef 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -92,6 +92,19 @@ module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to report for target devices.");
 
+/* Do not change the value of this after module load */
+int ql2xenabledif = 1;
+module_param(ql2xenabledif, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xenabledif,
+		" Enable T10-CRC-DIF "
+		" Default is 0 - No DIF Support. 1 - Enable it");
+
+int ql2xenablehba_err_chk;
+module_param(ql2xenablehba_err_chk, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xenablehba_err_chk,
+		" Enable T10-CRC-DIF Error isolation by HBA"
+		" Default is 0 - Error isolation disabled, 1 - Enable it");
+
 int ql2xiidmaenable=1;
 module_param(ql2xiidmaenable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xiidmaenable,
@@ -537,6 +550,14 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	if (fcport->drport)
 		goto qc24_target_busy;
 
+	if (!vha->flags.difdix_supported &&
+		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
+			DEBUG2(qla_printk(KERN_ERR, ha,
+			    "DIF Cap Not Reg, fail DIF capable cmd's:%x\n",
+			    cmd->cmnd[0]));
+			cmd->result = DID_NO_CONNECT << 16;
+			goto qc24_fail_command;
+	}
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 		    atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
@@ -776,7 +797,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		if (sp == NULL)
 			continue;
-		if ((sp->ctx) && !(sp->flags & SRB_FCP_CMND_DMA_VALID))
+		if ((sp->ctx) && !(sp->flags & SRB_FCP_CMND_DMA_VALID) &&
+		    !IS_PROT_IO(sp))
 			continue;
 		if (sp->cmd != cmd)
 			continue;
@@ -842,7 +864,7 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 		sp = req->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
-		if (sp->ctx)
+		if ((sp->ctx) && !IS_PROT_IO(sp))
 			continue;
 		if (vha->vp_idx != sp->fcport->vha->vp_idx)
 			continue;
@@ -1189,7 +1211,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 			if (sp) {
 				req->outstanding_cmds[cnt] = NULL;
 				if (!sp->ctx ||
-				(sp->flags & SRB_FCP_CMND_DMA_VALID)) {
+					(sp->flags & SRB_FCP_CMND_DMA_VALID) ||
+					IS_PROT_IO(sp)) {
 					sp->cmd->result = res;
 					qla2x00_sp_compl(ha, sp);
 				} else {
@@ -1553,7 +1576,7 @@ static struct isp_operations qla25xx_isp_ops = {
 	.read_optrom		= qla25xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
-	.start_scsi		= qla24xx_start_scsi,
+	.start_scsi		= qla24xx_dif_start_scsi,
 	.abort_isp		= qla2x00_abort_isp,
 };
 
@@ -2185,6 +2208,22 @@ skip_dpc:
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    base_vha->host_no, ha));
 
+	if (IS_QLA25XX(ha) && ql2xenabledif) {
+		if (ha->fw_attributes & BIT_4) {
+			base_vha->flags.difdix_supported = 1;
+			DEBUG18(qla_printk(KERN_INFO, ha,
+			    "Registering for DIF/DIX type 1 and 3"
+			    " protection.\n"));
+			scsi_host_set_prot(host,
+			    SHOST_DIF_TYPE1_PROTECTION
+			    | SHOST_DIF_TYPE3_PROTECTION
+			    | SHOST_DIX_TYPE1_PROTECTION
+			    | SHOST_DIX_TYPE3_PROTECTION);
+			scsi_host_set_guard(host, SHOST_DIX_GUARD_CRC);
+		} else
+			base_vha->flags.difdix_supported = 0;
+	}
+
 	ha->isp_ops->enable_intrs(ha);
 
 	ret = scsi_add_host(host, &pdev->dev);
@@ -2546,7 +2585,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->s_dma_pool)
 		goto fail_free_nvram;
 
-	if (IS_QLA82XX(ha)) {
+	if (IS_QLA82XX(ha) || ql2xenabledif) {
 		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 			DSD_LIST_DMA_POOL_SIZE, 8, 0);
 		if (!ha->dl_dma_pool) {
@@ -2678,12 +2717,12 @@ fail_free_ms_iocb:
 	ha->ms_iocb = NULL;
 	ha->ms_iocb_dma = 0;
 fail_dma_pool:
-	if (IS_QLA82XX(ha)) {
+	if (IS_QLA82XX(ha) || ql2xenabledif) {
 		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
 		ha->fcp_cmnd_dma_pool = NULL;
 	}
 fail_dl_dma_pool:
-	if (IS_QLA82XX(ha)) {
+	if (IS_QLA82XX(ha) || ql2xenabledif) {
 		dma_pool_destroy(ha->dl_dma_pool);
 		ha->dl_dma_pool = NULL;
 	}
@@ -3346,11 +3385,31 @@ static void
 qla2x00_sp_free_dma(srb_t *sp)
 {
 	struct scsi_cmnd *cmd = sp->cmd;
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
 
 	if (sp->flags & SRB_DMA_VALID) {
 		scsi_dma_unmap(cmd);
 		sp->flags &= ~SRB_DMA_VALID;
 	}
+
+	if (sp->flags & SRB_CRC_PROT_DMA_VALID) {
+		dma_unmap_sg(&ha->pdev->dev, scsi_prot_sglist(cmd),
+		    scsi_prot_sg_count(cmd), cmd->sc_data_direction);
+		sp->flags &= ~SRB_CRC_PROT_DMA_VALID;
+	}
+
+	if (sp->flags & SRB_CRC_CTX_DSD_VALID) {
+		/* List assured to be having elements */
+		qla2x00_clean_dsd_pool(ha, sp);
+		sp->flags &= ~SRB_CRC_CTX_DSD_VALID;
+	}
+
+	if (sp->flags & SRB_CRC_CTX_DMA_VALID) {
+		dma_pool_free(ha->dl_dma_pool, sp->ctx,
+		    ((struct crc_context *)sp->ctx)->crc_ctx_dma);
+		sp->flags &= ~SRB_CRC_CTX_DMA_VALID;
+	}
+
 	CMD_SP(cmd) = NULL;
 }
 
@@ -3464,7 +3523,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 					sp = req->outstanding_cmds[index];
 					if (!sp)
 						continue;
-					if (sp->ctx)
+					if (sp->ctx && !IS_PROT_IO(sp))
 						continue;
 					sfcp = sp->fcport;
 					if (!(sfcp->flags & FCF_FCP2_DEVICE))
-- 
1.6.2.rc1.30.gd43c

