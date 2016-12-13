From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v2 01/12] scsi: ufs: dump debug info during failures
Date: Tue, 13 Dec 2016 11:48:34 -0800
Message-ID: <1481658514-31768-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Dolev Raviv <draviv@codeaurora.org>

Inserts driver dumps for UFS Host Controller registers, Transfer Requests
and Task Management Requests.
The dumps will occur on driver initialization failure, ufshcd_abort() and
on error handling path.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
Changes v1 -> v2:
 - Added explicit new line character at the end of the printk messages.
 - Fixed couple of checkpatch warnings.
---
 drivers/scsi/ufs/ufshcd.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshci.h |   3 ++
 2 files changed, 132 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index af7e028..fe516b2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -94,6 +94,9 @@
 		_ret;                                                   \
 	})
 
+#define ufshcd_hex_dump(prefix_str, buf, len) \
+print_hex_dump(KERN_ERR, prefix_str, DUMP_PREFIX_OFFSET, 16, 4, buf, len, false)
+
 static u32 ufs_query_desc_max_size[] = {
 	QUERY_DESC_DEVICE_MAX_SIZE,
 	QUERY_DESC_CONFIGURAION_MAX_SIZE,
@@ -267,6 +270,77 @@ static inline void ufshcd_remove_non_printable(char *val)
 		*val = ' ';
 }
 
+static void ufshcd_print_host_regs(struct ufs_hba *hba)
+{
+	/*
+	 * hex_dump reads its data without the readl macro. This might
+	 * cause inconsistency issues on some platform, as the printed
+	 * values may be from cache and not the most recent value.
+	 * To know whether you are looking at an un-cached version verify
+	 * that IORESOURCE_MEM flag is on when xxx_get_resource() is invoked
+	 * during platform/pci probe function.
+	 */
+	ufshcd_hex_dump("host regs: ", hba->mmio_base, UFSHCI_REG_SPACE_SIZE);
+	dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities = 0x%x\n",
+		hba->ufs_version, hba->capabilities);
+	dev_err(hba->dev,
+		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x\n",
+		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
+}
+
+static
+void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
+{
+	struct ufshcd_lrb *lrbp;
+	int tag;
+
+	for_each_set_bit(tag, &bitmap, hba->nutrs) {
+		lrbp = &hba->lrb[tag];
+
+		dev_err(hba->dev, "UPIU[%d] - Transfer Request Descriptor\n",
+				tag);
+		ufshcd_hex_dump("UPIU TRD: ", lrbp->utr_descriptor_ptr,
+				sizeof(struct utp_transfer_req_desc));
+		dev_err(hba->dev, "UPIU[%d] - Request UPIU\n", tag);
+		ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
+				sizeof(struct utp_upiu_req));
+		dev_err(hba->dev, "UPIU[%d] - Response UPIU\n", tag);
+		ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
+				sizeof(struct utp_upiu_rsp));
+		if (pr_prdt) {
+			int prdt_length = le16_to_cpu(
+				lrbp->utr_descriptor_ptr->prd_table_length);
+
+			dev_err(hba->dev, "UPIU[%d] - PRDT - %d entries\n", tag,
+					prdt_length);
+			ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr,
+					sizeof(struct ufshcd_sg_entry) *
+					prdt_length);
+		}
+	}
+}
+
+static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
+{
+	struct utp_task_req_desc *tmrdp;
+	int tag;
+
+	for_each_set_bit(tag, &bitmap, hba->nutmrs) {
+		tmrdp = &hba->utmrdl_base_addr[tag];
+		dev_err(hba->dev, "TM[%d] - Task Management Header\n", tag);
+		ufshcd_hex_dump("TM TRD: ", &tmrdp->header,
+				sizeof(struct request_desc_header));
+		dev_err(hba->dev, "TM[%d] - Task Management Request UPIU\n",
+				tag);
+		ufshcd_hex_dump("TM REQ: ", tmrdp->task_req_upiu,
+				sizeof(struct utp_upiu_req));
+		dev_err(hba->dev, "TM[%d] - Task Management Response UPIU\n",
+				tag);
+		ufshcd_hex_dump("TM RSP: ", tmrdp->task_rsp_upiu,
+				sizeof(struct utp_task_req_desc));
+	}
+}
+
 /*
  * ufshcd_wait_for_register - wait for register value to change
  * @hba - per-adapter interface
@@ -2392,6 +2466,32 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_print_pwr_info - print power params as saved in hba
+ * power info
+ * @hba: per-adapter instance
+ */
+static void ufshcd_print_pwr_info(struct ufs_hba *hba)
+{
+	static const char * const names[] = {
+		"INVALID MODE",
+		"FAST MODE",
+		"SLOW_MODE",
+		"INVALID MODE",
+		"FASTAUTO_MODE",
+		"SLOWAUTO_MODE",
+		"INVALID MODE",
+	};
+
+	dev_info(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
+		 __func__,
+		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
+		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
+		 names[hba->pwr_info.pwr_rx],
+		 names[hba->pwr_info.pwr_tx],
+		 hba->pwr_info.hs_rate);
+}
+
+/**
  * ufshcd_host_memory_configure - configure local reference block with
  *				memory offsets
  * @hba: per adapter instance
@@ -2973,6 +3073,8 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			sizeof(struct ufs_pa_layer_attr));
 	}
 
+	ufshcd_print_pwr_info(hba);
+
 	return ret;
 }
 
@@ -3656,6 +3758,8 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
 		break;
 	} /* end of switch */
 
+	if (host_byte(result) != DID_OK)
+		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
 
@@ -4327,6 +4431,22 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 			scsi_block_requests(hba->host);
 
 			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
+
+			/* dump controller state before resetting */
+			if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
+				bool pr_prdt = !!(hba->saved_err &
+						SYSTEM_BUS_FATAL_ERROR);
+
+				dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
+					__func__, hba->saved_err,
+					hba->saved_uic_err);
+
+				ufshcd_print_host_regs(hba);
+				ufshcd_print_pwr_info(hba);
+				ufshcd_print_tmrs(hba, hba->outstanding_tasks);
+				ufshcd_print_trs(hba, hba->outstanding_reqs,
+							pr_prdt);
+			}
 			schedule_work(&hba->eh_work);
 		}
 	}
@@ -4617,6 +4737,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		__func__, tag);
 	}
 
+	/* Print Transfer Request of aborted task */
+	dev_err(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
+	scsi_print_command(hba->lrb[tag].cmd);
+	ufshcd_print_host_regs(hba);
+	ufshcd_print_pwr_info(hba);
+	ufshcd_print_trs(hba, 1 << tag, true);
+
 	lrbp = &hba->lrb[tag];
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
@@ -5256,6 +5383,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		goto out;
 
 	ufshcd_init_pwr_info(hba);
+	ufshcd_print_pwr_info(hba);
 
 	/* set the default level for urgent bkops */
 	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
@@ -6795,6 +6923,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = ufshcd_hba_enable(hba);
 	if (err) {
 		dev_err(hba->dev, "Host controller enable failed\n");
+		ufshcd_print_host_regs(hba);
 		goto out_remove_scsi_host;
 	}
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 8c5190e..d14e9b9 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -72,6 +72,9 @@ enum {
 	REG_UIC_COMMAND_ARG_1			= 0x94,
 	REG_UIC_COMMAND_ARG_2			= 0x98,
 	REG_UIC_COMMAND_ARG_3			= 0x9C,
+
+	UFSHCI_REG_SPACE_SIZE			= 0xA0,
+
 	REG_UFS_CCAP				= 0x100,
 	REG_UFS_CRYPTOCAP			= 0x104,
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
