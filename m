From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 03/16] lpfc: minor code cleanups
Date: Sun, 12 Feb 2017 13:52:27 -0800
Message-ID: <58a0d91b.VLyGPk7S2XWliQJD%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35735 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdBLVwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:31 -0500
Received: by mail-oi0-f67.google.com with SMTP id x84so5873545oix.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


This contains code cleanups that were in the prior patch set.
This allows better review of real changes later.

minor code cleanups:
 fix indentation, punctuation, line length
 addition/reduction of whitespace
 remove unneeded parens, braces
 lpfc_debugfs_nodelist_data: print as u64 rather than byte by byte
 covert printk(KERN_ERR to pr_err
 small print string deltas
 use num_present_cpus() rather than count them
 comment updates
 rctl/type names moved to module variable, not on stack

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    |  8 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     |  2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 81 +++++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  7 ++--
 drivers/scsi/lpfc/lpfc_init.c    | 19 ++++++----
 drivers/scsi/lpfc/lpfc_scsi.c    |  3 +-
 drivers/scsi/lpfc/lpfc_scsi.h    | 12 +++---
 drivers/scsi/lpfc/lpfc_sli.c     | 48 +++++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.h     |  6 +--
 drivers/scsi/lpfc/lpfc_vport.c   |  1 +
 10 files changed, 98 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 50cf402..ce41dea 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -50,9 +50,9 @@
 #include "lpfc_vport.h"
 #include "lpfc_attr.h"
 
-#define LPFC_DEF_DEVLOSS_TMO 30
-#define LPFC_MIN_DEVLOSS_TMO 1
-#define LPFC_MAX_DEVLOSS_TMO 255
+#define LPFC_DEF_DEVLOSS_TMO	30
+#define LPFC_MIN_DEVLOSS_TMO	1
+#define LPFC_MAX_DEVLOSS_TMO	255
 
 /*
  * Write key size should be multiple of 4. If write key is changed
@@ -5769,10 +5769,12 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
+
 	lpfc_EnableXLane_init(phba, lpfc_EnableXLane);
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		phba->cfg_EnableXLane = 0;
 	lpfc_XLanePriority_init(phba, lpfc_XLanePriority);
+
 	memset(phba->cfg_oas_tgt_wwpn, 0, (8 * sizeof(uint8_t)));
 	memset(phba->cfg_oas_vpt_wwpn, 0, (8 * sizeof(uint8_t)));
 	phba->cfg_oas_lun_state = 0;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7dca4d6..1ee131f 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2703,7 +2703,7 @@ static int lpfcdiag_loop_get_xri(struct lpfc_hba *phba, uint16_t rpi,
  * lpfc_bsg_dma_page_alloc - allocate a bsg mbox page sized dma buffers
  * @phba: Pointer to HBA context object
  *
- * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and.
+ * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and
  * returns the pointer to the buffer.
  **/
 static struct lpfc_dmabuf *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a63542b..0b99bdf 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -531,7 +531,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	int cnt;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
-	unsigned char *statep, *name;
+	unsigned char *statep;
 
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
 
@@ -574,36 +574,32 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
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
@@ -611,8 +607,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		len +=  snprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
+
 	return len;
 }
+
 #endif
 
 /**
@@ -938,7 +936,7 @@ lpfc_debugfs_dumpData_open(struct inode *inode, struct file *file)
 		goto out;
 
 	/* Round to page boundary */
-	printk(KERN_ERR "9059 BLKGRD:  %s: _dump_buf_data=0x%p\n",
+	pr_err("9059 BLKGRD:  %s: _dump_buf_data=0x%p\n",
 			__func__, _dump_buf_data);
 	debug->buffer = _dump_buf_data;
 	if (!debug->buffer) {
@@ -968,8 +966,8 @@ lpfc_debugfs_dumpDif_open(struct inode *inode, struct file *file)
 		goto out;
 
 	/* Round to page boundary */
-	printk(KERN_ERR	"9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%pD\n",
-		__func__, _dump_buf_dif, file);
+	pr_err("9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%pD\n",
+			__func__, _dump_buf_dif, file);
 	debug->buffer = _dump_buf_dif;
 	if (!debug->buffer) {
 		kfree(debug);
@@ -3853,7 +3851,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_rd) && (dma_tp == dma_mbox)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_RD_MBX) {
 			do_dump |= LPFC_BSG_DMP_MBX_RD_MBX;
-			printk(KERN_ERR "\nRead mbox command (x%x), "
+			pr_err("\nRead mbox command (x%x), "
 			       "nemb:0x%x, extbuf_cnt:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3861,7 +3859,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_rd) && (dma_tp == dma_ebuf)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_RD_BUF) {
 			do_dump |= LPFC_BSG_DMP_MBX_RD_BUF;
-			printk(KERN_ERR "\nRead mbox buffer (x%x), "
+			pr_err("\nRead mbox buffer (x%x), "
 			       "nemb:0x%x, extbuf_seq:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3869,7 +3867,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_wr) && (dma_tp == dma_mbox)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_WR_MBX) {
 			do_dump |= LPFC_BSG_DMP_MBX_WR_MBX;
-			printk(KERN_ERR "\nWrite mbox command (x%x), "
+			pr_err("\nWrite mbox command (x%x), "
 			       "nemb:0x%x, extbuf_cnt:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3877,7 +3875,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_wr) && (dma_tp == dma_ebuf)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_WR_BUF) {
 			do_dump |= LPFC_BSG_DMP_MBX_WR_BUF;
-			printk(KERN_ERR "\nWrite mbox buffer (x%x), "
+			pr_err("\nWrite mbox buffer (x%x), "
 			       "nemb:0x%x, extbuf_seq:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3889,7 +3887,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 		for (i = 0; i < *mbx_word_cnt; i++) {
 			if (!(i % 8)) {
 				if (i != 0)
-					printk(KERN_ERR "%s\n", line_buf);
+					pr_err("%s\n", line_buf);
 				len = 0;
 				len += snprintf(line_buf+len,
 						LPFC_MBX_ACC_LBUF_SZ-len,
@@ -3900,7 +3898,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 			pword++;
 		}
 		if ((i - 1) % 8)
-			printk(KERN_ERR "%s\n", line_buf);
+			pr_err("%s\n", line_buf);
 		(*mbx_dump_cnt)--;
 	}
 
@@ -3949,13 +3947,13 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 
 	/* dump buffer content */
 	if (*mbx_dump_map & LPFC_MBX_DMP_MBX_WORD) {
-		printk(KERN_ERR "Mailbox command:0x%x dump by word:\n",
+		pr_err("Mailbox command:0x%x dump by word:\n",
 		       pmbox->mbxCommand);
 		pword = (uint32_t *)pmbox;
 		for (i = 0; i < *mbx_word_cnt; i++) {
 			if (!(i % 8)) {
 				if (i != 0)
-					printk(KERN_ERR "%s\n", line_buf);
+					pr_err("%s\n", line_buf);
 				len = 0;
 				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
 				len += snprintf(line_buf+len,
@@ -3968,17 +3966,17 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 			pword++;
 		}
 		if ((i - 1) % 8)
-			printk(KERN_ERR "%s\n", line_buf);
-		printk(KERN_ERR "\n");
+			pr_err("%s\n", line_buf);
+		pr_err("\n");
 	}
 	if (*mbx_dump_map & LPFC_MBX_DMP_MBX_BYTE) {
-		printk(KERN_ERR "Mailbox command:0x%x dump by byte:\n",
+		pr_err("Mailbox command:0x%x dump by byte:\n",
 		       pmbox->mbxCommand);
 		pbyte = (uint8_t *)pmbox;
 		for (i = 0; i < *mbx_word_cnt; i++) {
 			if (!(i % 8)) {
 				if (i != 0)
-					printk(KERN_ERR "%s\n", line_buf);
+					pr_err("%s\n", line_buf);
 				len = 0;
 				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
 				len += snprintf(line_buf+len,
@@ -3996,8 +3994,8 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 					LPFC_MBX_ACC_LBUF_SZ-len, " ");
 		}
 		if ((i - 1) % 8)
-			printk(KERN_ERR "%s\n", line_buf);
-		printk(KERN_ERR "\n");
+			pr_err("%s\n", line_buf);
+		pr_err("\n");
 	}
 	(*mbx_dump_cnt)--;
 
@@ -4240,8 +4238,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 					i++;
 				}
 				lpfc_debugfs_max_slow_ring_trc = (1 << i);
-				printk(KERN_ERR
-				       "lpfc_debugfs_max_disc_trc changed to "
+				pr_err("lpfc_debugfs_max_disc_trc changed to "
 				       "%d\n", lpfc_debugfs_max_disc_trc);
 			}
 		}
@@ -4273,6 +4270,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc));
 		}
+
 	}
 
 	snprintf(name, sizeof(name), "vport%d", vport->vpi);
@@ -4298,8 +4296,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				i++;
 			}
 			lpfc_debugfs_max_disc_trc = (1 << i);
-			printk(KERN_ERR
-			       "lpfc_debugfs_max_disc_trc changed to %d\n",
+			pr_err("lpfc_debugfs_max_disc_trc changed to %d\n",
 			       lpfc_debugfs_max_disc_trc);
 		}
 	}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ed22393..cdbe252 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3972,12 +3972,13 @@ static void
 lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport = ndlp->rport;
+	struct lpfc_vport *vport = ndlp->vport;
 
-	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_RPORT,
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 		"rport delete:    did:x%x flg:x%x type x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
-	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 			 "3184 rport unregister x%06x, rport %p\n",
 			 ndlp->nlp_DID, rport);
 
@@ -4424,8 +4425,6 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		if (icmd->ulpContext == (volatile ushort)ndlp->nlp_rpi) {
 			return 1;
 		}
-	} else if (pring->ringno == psli->next_ring) {
-
 	}
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c4e8fad..7ad6897 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4273,13 +4273,13 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 			sprintf(message, "Unqualified optics - Replace with "
 				"Avago optics for Warranty and Technical "
 				"Support - Link is%s operational",
-				(operational) ? "" : " not");
+				(operational) ? " not" : "");
 			break;
 		case LPFC_SLI_EVENT_STATUS_UNCERTIFIED:
 			sprintf(message, "Uncertified optics - Replace with "
 				"Avago-certified optics to enable link "
 				"operation - Link is%s operational",
-				(operational) ? "" : " not");
+				(operational) ? " not" : "");
 			break;
 		default:
 			/* firmware is reporting a status we don't know about */
@@ -6208,6 +6208,7 @@ lpfc_create_shost(struct lpfc_hba *phba)
 
 	shost = lpfc_shost_from_vport(vport);
 	phba->pport = vport;
+
 	lpfc_debugfs_initialize(vport);
 	/* Put reference to SCSI host to driver's device private data */
 	pci_set_drvdata(phba->pcidev, shost);
@@ -6994,7 +6995,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				"VPI(B:%d M:%d) "
 				"VFI(B:%d M:%d) "
 				"RPI(B:%d M:%d) "
-				"FCFI(Count:%d)\n",
+				"FCFI:%d EQ:%d CQ:%d WQ:%d RQ:%d\n",
 				phba->sli4_hba.extents_in_use,
 				phba->sli4_hba.max_cfg_param.xri_base,
 				phba->sli4_hba.max_cfg_param.max_xri,
@@ -7004,7 +7005,12 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				phba->sli4_hba.max_cfg_param.max_vfi,
 				phba->sli4_hba.max_cfg_param.rpi_base,
 				phba->sli4_hba.max_cfg_param.max_rpi,
-				phba->sli4_hba.max_cfg_param.max_fcfi);
+				phba->sli4_hba.max_cfg_param.max_fcfi,
+				phba->sli4_hba.max_cfg_param.max_eq,
+				phba->sli4_hba.max_cfg_param.max_cq,
+				phba->sli4_hba.max_cfg_param.max_wq,
+				phba->sli4_hba.max_cfg_param.max_rq);
+
 	}
 
 	if (rc)
@@ -11345,7 +11351,6 @@ static struct miscdevice lpfc_mgmt_dev = {
 static int __init
 lpfc_init(void)
 {
-	int cpu;
 	int error = 0;
 
 	printk(LPFC_MODULE_DESC "\n");
@@ -11371,9 +11376,7 @@ lpfc_init(void)
 
 	/* Initialize in case vector mapping is needed */
 	lpfc_used_cpu = NULL;
-	lpfc_present_cpu = 0;
-	for_each_present_cpu(cpu)
-		lpfc_present_cpu++;
+	lpfc_present_cpu = num_present_cpus();
 
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 19d349f..54d7718 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3894,7 +3894,7 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 		}
 	}
 	chann = atomic_add_return(1, &phba->fcp_qidx);
-	chann = (chann % phba->cfg_fcp_io_channel);
+	chann = chann % phba->cfg_fcp_io_channel;
 	return chann;
 }
 
@@ -3967,6 +3967,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		lpfc_cmd->prot_data_segment = NULL;
 	}
 #endif
+
 	if (pnode && NLP_CHK_NODE_ACT(pnode))
 		atomic_dec(&pnode->cmd_pending);
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 8cb80da..4d70622 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -178,13 +178,13 @@ struct lpfc_scsi_buf {
 #endif
 };
 
-#define LPFC_SCSI_DMA_EXT_SIZE 264
-#define LPFC_BPL_SIZE          1024
-#define MDAC_DIRECT_CMD                  0x22
+#define LPFC_SCSI_DMA_EXT_SIZE	264
+#define LPFC_BPL_SIZE		1024
+#define MDAC_DIRECT_CMD		0x22
 
-#define FIND_FIRST_OAS_LUN		 0
-#define NO_MORE_OAS_LUN			-1
-#define NOT_OAS_ENABLED_LUN		NO_MORE_OAS_LUN
+#define FIND_FIRST_OAS_LUN	0
+#define NO_MORE_OAS_LUN		-1
+#define NOT_OAS_ENABLED_LUN	NO_MORE_OAS_LUN
 
 int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 				  struct lpfc_scsi_buf *lpfc_cmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dbe9cb1..6a00b3a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -271,10 +271,11 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 	/*
 	 * insert barrier for instruction interlock : data from the hardware
 	 * must have the valid bit checked before it can be copied and acted
-	 * upon. Given what was seen in lpfc_sli4_cq_get() of speculative
-	 * instructions allowing action on content before valid bit checked,
-	 * add barrier here as well. May not be needed as "content" is a
-	 * single 32-bit entity here (vs multi word structure for cq's).
+	 * upon. Speculative instructions were allowing a bcopy at the start
+	 * of lpfc_sli4_fp_handle_wcqe(), which is called immediately
+	 * after our return, to copy data before the valid bit check above
+	 * was done. As such, some of the copied data was stale. The barrier
+	 * ensures the check is before any data is copied.
 	 */
 	mb();
 	return eqe;
@@ -386,11 +387,10 @@ lpfc_sli4_cq_get(struct lpfc_queue *q)
 	/*
 	 * insert barrier for instruction interlock : data from the hardware
 	 * must have the valid bit checked before it can be copied and acted
-	 * upon. Speculative instructions were allowing a bcopy at the start
-	 * of lpfc_sli4_fp_handle_wcqe(), which is called immediately
-	 * after our return, to copy data before the valid bit check above
-	 * was done. As such, some of the copied data was stale. The barrier
-	 * ensures the check is before any data is copied.
+	 * upon. Given what was seen in lpfc_sli4_cq_get() of speculative
+	 * instructions allowing action on content before valid bit checked,
+	 * add barrier here as well. May not be needed as "content" is a
+	 * single 32-bit entity here (vs multi word structure for cq's).
 	 */
 	mb();
 	return cqe;
@@ -7361,7 +7361,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 
 		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 			/* copy results back to user */
-			lpfc_sli_pcimem_bcopy(phba->mbox, mbx, MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(phba->mbox, mbx,
+						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
 			if (pmbox->out_ext_byte_len && pmbox->context2) {
 				lpfc_sli_pcimem_bcopy(phba->mbox_ext,
@@ -7371,7 +7372,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		} else {
 			/* First copy command data */
 			lpfc_memcpy_from_slim(mbx, phba->MBslimaddr,
-							MAILBOX_CMD_SIZE);
+						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
 			if (pmbox->out_ext_byte_len && pmbox->context2) {
 				lpfc_memcpy_from_slim(pmbox->context2,
@@ -8899,10 +8900,10 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 			}
 		}
-	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
+	} else if (piocb->iocb_flag &  LPFC_IO_FCP)
 		/* These IO's already have an XRI and a mapped sgl. */
 		sglq = NULL;
-	} else {
+	else {
 		/*
 		 * This is a continuation of a commandi,(CX) so this
 		 * sglq is on the active list
@@ -13352,8 +13353,10 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	switch (cq->entry_count) {
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0361 Unsupported CQ count. (%d)\n",
-				cq->entry_count);
+				"0361 Unsupported CQ count: "
+				"entry cnt %d sz %d pg cnt %d repost %d\n",
+				cq->entry_count, cq->entry_size,
+				cq->page_count, cq->entry_repost);
 		if (cq->entry_count < 256) {
 			status = -EINVAL;
 			goto out;
@@ -14817,6 +14820,9 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba,
 	return rc;
 }
 
+static char *lpfc_rctl_names[] = FC_RCTL_NAMES_INIT;
+static char *lpfc_type_names[] = FC_TYPE_NAMES_INIT;
+
 /**
  * lpfc_fc_frame_check - Check that this frame is a valid frame to handle
  * @phba: pointer to lpfc_hba struct that the frame was received on
@@ -14831,8 +14837,6 @@ static int
 lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 {
 	/*  make rctl_names static to save stack space */
-	static char *rctl_names[] = FC_RCTL_NAMES_INIT;
-	char *type_names[] = FC_TYPE_NAMES_INIT;
 	struct fc_vft_header *fc_vft_hdr;
 	uint32_t *header = (uint32_t *) fc_hdr;
 
@@ -14887,8 +14891,8 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
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
@@ -14897,8 +14901,8 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
 			"2539 Dropped frame rctl:%s type:%s\n",
-			rctl_names[fc_hdr->fh_r_ctl],
-			type_names[fc_hdr->fh_type]);
+			lpfc_rctl_names[fc_hdr->fh_r_ctl],
+			lpfc_type_names[fc_hdr->fh_type]);
 	return 1;
 }
 
@@ -15719,11 +15723,13 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 74227a2..3fad565 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -97,11 +97,11 @@ struct lpfc_iocbq {
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
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index e18bbc6..5bbe6af 100644
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
