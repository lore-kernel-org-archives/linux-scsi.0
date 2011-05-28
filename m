From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/8] [REPOST] lpfc 8.3.24: debugfs additions for new
 hardware.
Date: Fri, 27 May 2011 23:58:20 -0400
Message-ID: <1306555114.2640.0.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:20610 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757815Ab1E1D7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 23:59:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


debugfs additions for new hardware.
Correct stack overflow in lpfc_debugfs_dumpHBASlim_data()
Correct warning on uninitialized reg_val in lpfc_idiag_drbacc_write()


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    5 
 lpfc_bsg.c     |   28 +
 lpfc_crtn.h    |    8 
 lpfc_debugfs.c |  973 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_debugfs.h |   62 +++
 lpfc_init.c    |    1 
 lpfc_sli.c     |  163 +++++++++
 7 files changed, 1227 insertions(+), 13 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2011-05-27 23:32:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2011-05-27 23:33:01.000000000 -0400
@@ -42,6 +42,7 @@
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
+#include "lpfc_debugfs.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
 
@@ -3430,6 +3431,10 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpf
 				"ext_buf_cnt:%d\n", ext_buf_cnt);
 	}
 
+	/* before dma descriptor setup */
+	lpfc_idiag_mbxacc_dump_bsg_mbox(phba, nemb_tp, mbox_rd, dma_mbox,
+					sta_pre_addr, dmabuf, ext_buf_cnt);
+
 	/* reject non-embedded mailbox command with none external buffer */
 	if (ext_buf_cnt == 0) {
 		rc = -EPERM;
@@ -3477,6 +3482,10 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpf
 		}
 	}
 
+	/* after dma descriptor setup */
+	lpfc_idiag_mbxacc_dump_bsg_mbox(phba, nemb_tp, mbox_rd, dma_mbox,
+					sta_pos_addr, dmabuf, ext_buf_cnt);
+
 	/* construct base driver mbox command */
 	pmb = &pmboxq->u.mb;
 	pmbx = (uint8_t *)dmabuf->virt;
@@ -3591,12 +3600,20 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lp
 				"ext_buf_cnt:%d\n", ext_buf_cnt);
 	}
 
+	/* before dma buffer descriptor setup */
+	lpfc_idiag_mbxacc_dump_bsg_mbox(phba, nemb_tp, mbox_wr, dma_mbox,
+					sta_pre_addr, dmabuf, ext_buf_cnt);
+
 	if (ext_buf_cnt == 0)
 		return -EPERM;
 
 	/* for the first external buffer */
 	lpfc_bsg_sli_cfg_dma_desc_setup(phba, nemb_tp, 0, dmabuf, dmabuf);
 
+	/* after dma descriptor setup */
+	lpfc_idiag_mbxacc_dump_bsg_mbox(phba, nemb_tp, mbox_wr, dma_mbox,
+					sta_pos_addr, dmabuf, ext_buf_cnt);
+
 	/* log for looking forward */
 	for (i = 1; i < ext_buf_cnt; i++) {
 		if (nemb_tp == nemb_mse)
@@ -3840,6 +3857,12 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *
 	dmabuf = list_first_entry(&phba->mbox_ext_buf_ctx.ext_dmabuf_list,
 				  struct lpfc_dmabuf, list);
 	list_del_init(&dmabuf->list);
+
+	/* after dma buffer descriptor setup */
+	lpfc_idiag_mbxacc_dump_bsg_mbox(phba, phba->mbox_ext_buf_ctx.nembType,
+					mbox_rd, dma_ebuf, sta_pos_addr,
+					dmabuf, index);
+
 	pbuf = (uint8_t *)dmabuf->virt;
 	job->reply->reply_payload_rcv_len =
 		sg_copy_from_buffer(job->reply_payload.sg_list,
@@ -3916,6 +3939,11 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba 
 
 	}
 
+	/* pre write dma buffer */
+	lpfc_idiag_mbxacc_dump_bsg_mbox(phba, phba->mbox_ext_buf_ctx.nembType,
+					mbox_wr, dma_ebuf, sta_pos_addr,
+					dmabuf, index);
+
 	/* set up external buffer descriptor and add to external buffer list */
 	lpfc_bsg_sli_cfg_dma_desc_setup(phba, nemb_tp, index,
 					phba->mbox_ext_buf_ctx.mbx_dmabuf,
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-27 23:32:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-27 23:33:01.000000000 -0400
@@ -371,6 +371,10 @@ extern struct lpfc_hbq_init *lpfc_hbq_de
 /* SLI4 if_type 2 externs. */
 int lpfc_sli4_alloc_resource_identifiers(struct lpfc_hba *);
 int lpfc_sli4_dealloc_resource_identifiers(struct lpfc_hba *);
+int lpfc_sli4_get_allocated_extnts(struct lpfc_hba *, uint16_t,
+				   uint16_t *, uint16_t *);
+int lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *, uint16_t,
+					  uint16_t *, uint16_t *);
 
 /* externs BlockGuard */
 extern char *_dump_buf_data;
@@ -436,6 +440,10 @@ void lpfc_cleanup_wt_rrqs(struct lpfc_hb
 void lpfc_cleanup_vports_rrqs(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_node_rrq *lpfc_get_active_rrq(struct lpfc_vport *, uint16_t,
 	uint32_t);
+void lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *, enum nemb_type,
+	enum mbox_type, enum dma_type, enum sta_type,
+	struct lpfc_dmabuf *, uint32_t);
+void lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *, MAILBOX_t *);
 int lpfc_wr_object(struct lpfc_hba *, struct list_head *, uint32_t, uint32_t *);
 /* functions to support SR-IOV */
 int lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *, int);
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2011-05-27 23:32:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-05-27 23:33:51.000000000 -0400
@@ -48,6 +48,7 @@
 #include "lpfc_version.h"
 #include "lpfc_compat.h"
 #include "lpfc_debugfs.h"
+#include "lpfc_bsg.h"
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /*
@@ -378,16 +379,20 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 	int len = 0;
 	int i, off;
 	uint32_t *ptr;
-	char buffer[1024];
+	char *dbuf;
+
+	dbuf = kmalloc(1024, GFP_KERNEL);
+	if (!dbuf)
+		goto out;
 
 	off = 0;
 	spin_lock_irq(&phba->hbalock);
 
 	len +=  snprintf(buf+len, size-len, "HBA SLIM\n");
-	lpfc_memcpy_from_slim(buffer,
+	lpfc_memcpy_from_slim(dbuf,
 		phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
 
-	ptr = (uint32_t *)&buffer[0];
+	ptr = (uint32_t *)dbuf;
 	off = lpfc_debugfs_last_hba_slim_off;
 
 	/* Set it up for the next time */
@@ -407,6 +412,8 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 	}
 
 	spin_unlock_irq(&phba->hbalock);
+	kfree(dbuf);
+out:
 	return len;
 }
 
@@ -2256,7 +2263,7 @@ lpfc_idiag_drbacc_write(struct file *fil
 {
 	struct lpfc_debug *debug = file->private_data;
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
-	uint32_t drb_reg_id, value, reg_val;
+	uint32_t drb_reg_id, value, reg_val = 0;
 	void __iomem *drb_reg;
 	int rc;
 
@@ -2329,6 +2336,678 @@ error_out:
 	return -EINVAL;
 }
 
+/**
+ * lpfc_idiag_ctlacc_read_reg - idiag debugfs read a control registers
+ * @phba: The pointer to hba structure.
+ * @pbuffer: The pointer to the buffer to copy the data to.
+ * @len: The lenght of bytes to copied.
+ * @drbregid: The id to doorbell registers.
+ *
+ * Description:
+ * This routine reads a control register and copies its content to the
+ * user buffer pointed to by @pbuffer.
+ *
+ * Returns:
+ * This function returns the amount of data that was copied into @pbuffer.
+ **/
+static int
+lpfc_idiag_ctlacc_read_reg(struct lpfc_hba *phba, char *pbuffer,
+			   int len, uint32_t ctlregid)
+{
+
+	if (!pbuffer)
+		return 0;
+
+	switch (ctlregid) {
+	case LPFC_CTL_PORT_SEM:
+		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+				"Port SemReg:   0x%08x\n",
+				readl(phba->sli4_hba.conf_regs_memmap_p +
+				      LPFC_CTL_PORT_SEM_OFFSET));
+		break;
+	case LPFC_CTL_PORT_STA:
+		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+				"Port StaReg:   0x%08x\n",
+				readl(phba->sli4_hba.conf_regs_memmap_p +
+				      LPFC_CTL_PORT_STA_OFFSET));
+		break;
+	case LPFC_CTL_PORT_CTL:
+		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+				"Port CtlReg:   0x%08x\n",
+				readl(phba->sli4_hba.conf_regs_memmap_p +
+				      LPFC_CTL_PORT_CTL_OFFSET));
+		break;
+	case LPFC_CTL_PORT_ER1:
+		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+				"Port Er1Reg:   0x%08x\n",
+				readl(phba->sli4_hba.conf_regs_memmap_p +
+				      LPFC_CTL_PORT_ER1_OFFSET));
+		break;
+	case LPFC_CTL_PORT_ER2:
+		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+				"Port Er2Reg:   0x%08x\n",
+				readl(phba->sli4_hba.conf_regs_memmap_p +
+				      LPFC_CTL_PORT_ER2_OFFSET));
+		break;
+	case LPFC_CTL_PDEV_CTL:
+		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+				"PDev CtlReg:   0x%08x\n",
+				readl(phba->sli4_hba.conf_regs_memmap_p +
+				      LPFC_CTL_PDEV_CTL_OFFSET));
+		break;
+	default:
+		break;
+	}
+	return len;
+}
+
+/**
+ * lpfc_idiag_ctlacc_read - idiag debugfs read port and device control register
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the @phba port and device registers according
+ * to the idiag command, and copies to user @buf.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_ctlacc_read(struct file *file, char __user *buf, size_t nbytes,
+		       loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	uint32_t ctl_reg_id, i;
+	char *pbuffer;
+	int len = 0;
+
+	/* This is a user read operation */
+	debug->op = LPFC_IDIAG_OP_RD;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_CTL_ACC_BUF_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+
+	if (*ppos)
+		return 0;
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_RD)
+		ctl_reg_id = idiag.cmd.data[0];
+	else
+		return 0;
+
+	if (ctl_reg_id == LPFC_CTL_ACC_ALL)
+		for (i = 1; i <= LPFC_CTL_MAX; i++)
+			len = lpfc_idiag_ctlacc_read_reg(phba,
+							 pbuffer, len, i);
+	else
+		len = lpfc_idiag_ctlacc_read_reg(phba,
+						 pbuffer, len, ctl_reg_id);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
+/**
+ * lpfc_idiag_ctlacc_write - Syntax check and set up idiag ctlacc commands
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the user data from.
+ * @nbytes: The number of bytes to get.
+ * @ppos: The position in the file to start reading from.
+ *
+ * This routine get the debugfs idiag command struct from user space and then
+ * perform the syntax check for port and device control register read (dump)
+ * or write (set) command accordingly.
+ *
+ * It returns the @nbytges passing in from debugfs user space when successful.
+ * In case of error conditions, it returns proper error code back to the user
+ * space.
+ **/
+static ssize_t
+lpfc_idiag_ctlacc_write(struct file *file, const char __user *buf,
+			size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	uint32_t ctl_reg_id, value, reg_val = 0;
+	void __iomem *ctl_reg;
+	int rc;
+
+	/* This is a user write operation */
+	debug->op = LPFC_IDIAG_OP_WR;
+
+	rc = lpfc_idiag_cmd_get(buf, nbytes, &idiag.cmd);
+	if (rc < 0)
+		return rc;
+
+	/* Sanity check on command line arguments */
+	ctl_reg_id = idiag.cmd.data[0];
+	value = idiag.cmd.data[1];
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_WR ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_ST ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_CL) {
+		if (rc != LPFC_CTL_ACC_WR_CMD_ARG)
+			goto error_out;
+		if (ctl_reg_id > LPFC_CTL_MAX)
+			goto error_out;
+	} else if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_RD) {
+		if (rc != LPFC_CTL_ACC_RD_CMD_ARG)
+			goto error_out;
+		if ((ctl_reg_id > LPFC_CTL_MAX) &&
+		    (ctl_reg_id != LPFC_CTL_ACC_ALL))
+			goto error_out;
+	} else
+		goto error_out;
+
+	/* Perform the write access operation */
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_WR ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_ST ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_CL) {
+		switch (ctl_reg_id) {
+		case LPFC_CTL_PORT_SEM:
+			ctl_reg = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_CTL_PORT_SEM_OFFSET;
+			break;
+		case LPFC_CTL_PORT_STA:
+			ctl_reg = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_CTL_PORT_STA_OFFSET;
+			break;
+		case LPFC_CTL_PORT_CTL:
+			ctl_reg = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_CTL_PORT_CTL_OFFSET;
+			break;
+		case LPFC_CTL_PORT_ER1:
+			ctl_reg = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_CTL_PORT_ER1_OFFSET;
+			break;
+		case LPFC_CTL_PORT_ER2:
+			ctl_reg = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_CTL_PORT_ER2_OFFSET;
+			break;
+		case LPFC_CTL_PDEV_CTL:
+			ctl_reg = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_CTL_PDEV_CTL_OFFSET;
+			break;
+		default:
+			goto error_out;
+		}
+
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_WR)
+			reg_val = value;
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_ST) {
+			reg_val = readl(ctl_reg);
+			reg_val |= value;
+		}
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_CTLACC_CL) {
+			reg_val = readl(ctl_reg);
+			reg_val &= ~value;
+		}
+		writel(reg_val, ctl_reg);
+		readl(ctl_reg); /* flush */
+	}
+	return nbytes;
+
+error_out:
+	/* Clean out command structure on command error out */
+	memset(&idiag, 0, sizeof(idiag));
+	return -EINVAL;
+}
+
+/**
+ * lpfc_idiag_mbxacc_get_setup - idiag debugfs get mailbox access setup
+ * @phba: Pointer to HBA context object.
+ * @pbuffer: Pointer to data buffer.
+ *
+ * Description:
+ * This routine gets the driver mailbox access debugfs setup information.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static int
+lpfc_idiag_mbxacc_get_setup(struct lpfc_hba *phba, char *pbuffer)
+{
+	uint32_t mbx_dump_map, mbx_dump_cnt, mbx_word_cnt, mbx_mbox_cmd;
+	int len = 0;
+
+	mbx_dump_map = idiag.cmd.data[0];
+	mbx_dump_cnt = idiag.cmd.data[1];
+	mbx_word_cnt = idiag.cmd.data[2];
+	if (mbx_dump_map & LPFC_MBX_DMP_ISSUE_MBX_ALL)
+		mbx_mbox_cmd = idiag.cmd.data[3];
+	else
+		mbx_mbox_cmd = 0;
+
+	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+			"mbx_dump_map: 0x%08x\n", mbx_dump_map);
+	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+			"mbx_dump_cnt: %04d\n", mbx_dump_cnt);
+	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+			"mbx_word_cnt: %04d\n", mbx_word_cnt);
+	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+			"mbx_mbox_cmd: 0x%02x\n", mbx_mbox_cmd);
+
+	return len;
+}
+
+/**
+ * lpfc_idiag_mbxacc_read - idiag debugfs read on mailbox access
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the @phba driver mailbox access debugfs setup
+ * information.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_mbxacc_read(struct file *file, char __user *buf, size_t nbytes,
+		       loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	char *pbuffer;
+	int len = 0;
+
+	/* This is a user read operation */
+	debug->op = LPFC_IDIAG_OP_RD;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_MBX_ACC_BUF_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+
+	if (*ppos)
+		return 0;
+
+	if (idiag.cmd.opcode != LPFC_IDIAG_CMD_MBXACC_DP)
+		return 0;
+
+	len = lpfc_idiag_mbxacc_get_setup(phba, pbuffer);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
+/**
+ * lpfc_idiag_mbxacc_write - Syntax check and set up idiag mbxacc commands
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the user data from.
+ * @nbytes: The number of bytes to get.
+ * @ppos: The position in the file to start reading from.
+ *
+ * This routine get the debugfs idiag command struct from user space and then
+ * perform the syntax check for driver mailbox command (dump) and sets up the
+ * necessary states in the idiag command struct accordingly.
+ *
+ * It returns the @nbytges passing in from debugfs user space when successful.
+ * In case of error conditions, it returns proper error code back to the user
+ * space.
+ **/
+static ssize_t
+lpfc_idiag_mbxacc_write(struct file *file, const char __user *buf,
+			size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	uint32_t mbx_dump_map, mbx_dump_cnt, mbx_word_cnt, mbx_mbox_cmd;
+	int rc;
+
+	/* This is a user write operation */
+	debug->op = LPFC_IDIAG_OP_WR;
+
+	rc = lpfc_idiag_cmd_get(buf, nbytes, &idiag.cmd);
+	if (rc < 0)
+		return rc;
+
+	/* Sanity check on command line arguments */
+	mbx_dump_map = idiag.cmd.data[0];
+	mbx_dump_cnt = idiag.cmd.data[1];
+	mbx_word_cnt = idiag.cmd.data[2];
+	mbx_mbox_cmd = idiag.cmd.data[3];
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_MBXACC_DP) {
+		if (!(mbx_dump_map & LPFC_MBX_DMP_ALL))
+			goto error_out;
+		if (mbx_dump_map & ~LPFC_MBX_DMP_ALL)
+			goto error_out;
+		if (mbx_word_cnt == 0)
+			goto error_out;
+		if (mbx_dump_map & LPFC_BSG_MBX_DMP_ALL) {
+			if (mbx_dump_cnt > (BSG_MBOX_SIZE)/4)
+				goto error_out;
+			if ((rc != LPFC_BSG_MBX_DMP_CMD_ARG) &&
+			    (rc != LPFC_MBX_DMP_ISSUE_MBX_CMD_ARG))
+				goto error_out;
+		}
+		if (mbx_dump_map & LPFC_MBX_DMP_ISSUE_MBX_ALL) {
+			if (mbx_dump_cnt > sizeof(MAILBOX_t))
+				goto error_out;
+			if (rc != LPFC_MBX_DMP_ISSUE_MBX_CMD_ARG)
+				goto error_out;
+		}
+		if ((mbx_dump_map & LPFC_MBX_DMP_ISSUE_MBX_ALL) &&
+		    (mbx_mbox_cmd & ~0xff))
+			goto error_out;
+		/* as condition for stop mailbox dump */
+		if (mbx_dump_cnt == 0)
+			goto reset_out;
+	} else
+		goto error_out;
+
+	return nbytes;
+
+reset_out:
+	/* Clean out command structure on command error out */
+	memset(&idiag, 0, sizeof(idiag));
+	return nbytes;
+
+error_out:
+	/* Clean out command structure on command error out */
+	memset(&idiag, 0, sizeof(idiag));
+	return -EINVAL;
+}
+
+/**
+ * lpfc_idiag_extacc_avail_get - get the available extents information
+ * @phba: pointer to lpfc hba data structure.
+ * @pbuffer: pointer to internal buffer.
+ * @len: length into the internal buffer data has been copied.
+ *
+ * Description:
+ * This routine is to get the available extent information.
+ *
+ * Returns:
+ * overall lenth of the data read into the internal buffer.
+ **/
+static int
+lpfc_idiag_extacc_avail_get(struct lpfc_hba *phba, char *pbuffer, int len)
+{
+	uint16_t ext_cnt, ext_size;
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\nAvailable Extents Information:\n");
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tPort Available VPI extents: ");
+	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_VPI,
+				       &ext_cnt, &ext_size);
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"Count %3d, Size %3d\n", ext_cnt, ext_size);
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tPort Available VFI extents: ");
+	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_VFI,
+				       &ext_cnt, &ext_size);
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"Count %3d, Size %3d\n", ext_cnt, ext_size);
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tPort Available RPI extents: ");
+	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_RPI,
+				       &ext_cnt, &ext_size);
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"Count %3d, Size %3d\n", ext_cnt, ext_size);
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tPort Available XRI extents: ");
+	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_XRI,
+				       &ext_cnt, &ext_size);
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"Count %3d, Size %3d\n", ext_cnt, ext_size);
+
+	return len;
+}
+
+/**
+ * lpfc_idiag_extacc_alloc_get - get the allocated extents information
+ * @phba: pointer to lpfc hba data structure.
+ * @pbuffer: pointer to internal buffer.
+ * @len: length into the internal buffer data has been copied.
+ *
+ * Description:
+ * This routine is to get the allocated extent information.
+ *
+ * Returns:
+ * overall lenth of the data read into the internal buffer.
+ **/
+static int
+lpfc_idiag_extacc_alloc_get(struct lpfc_hba *phba, char *pbuffer, int len)
+{
+	uint16_t ext_cnt, ext_size;
+	int rc;
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\nAllocated Extents Information:\n");
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tHost Allocated VPI extents: ");
+	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_VPI,
+					    &ext_cnt, &ext_size);
+	if (!rc)
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"Port %d Extent %3d, Size %3d\n",
+				phba->brd_no, ext_cnt, ext_size);
+	else
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"N/A\n");
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tHost Allocated VFI extents: ");
+	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_VFI,
+					    &ext_cnt, &ext_size);
+	if (!rc)
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"Port %d Extent %3d, Size %3d\n",
+				phba->brd_no, ext_cnt, ext_size);
+	else
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"N/A\n");
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tHost Allocated RPI extents: ");
+	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_RPI,
+					    &ext_cnt, &ext_size);
+	if (!rc)
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"Port %d Extent %3d, Size %3d\n",
+				phba->brd_no, ext_cnt, ext_size);
+	else
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"N/A\n");
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tHost Allocated XRI extents: ");
+	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_XRI,
+					    &ext_cnt, &ext_size);
+	if (!rc)
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"Port %d Extent %3d, Size %3d\n",
+				phba->brd_no, ext_cnt, ext_size);
+	else
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"N/A\n");
+
+	return len;
+}
+
+/**
+ * lpfc_idiag_extacc_drivr_get - get driver extent information
+ * @phba: pointer to lpfc hba data structure.
+ * @pbuffer: pointer to internal buffer.
+ * @len: length into the internal buffer data has been copied.
+ *
+ * Description:
+ * This routine is to get the driver extent information.
+ *
+ * Returns:
+ * overall lenth of the data read into the internal buffer.
+ **/
+static int
+lpfc_idiag_extacc_drivr_get(struct lpfc_hba *phba, char *pbuffer, int len)
+{
+	struct lpfc_rsrc_blks *rsrc_blks;
+	int index;
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\nDriver Extents Information:\n");
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tVPI extents:\n");
+	index = 0;
+	list_for_each_entry(rsrc_blks, &phba->lpfc_vpi_blk_list, list) {
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"\t\tBlock %3d: Start %4d, Count %4d\n",
+				index, rsrc_blks->rsrc_start,
+				rsrc_blks->rsrc_size);
+		index++;
+	}
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tVFI extents:\n");
+	index = 0;
+	list_for_each_entry(rsrc_blks, &phba->sli4_hba.lpfc_vfi_blk_list,
+			    list) {
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"\t\tBlock %3d: Start %4d, Count %4d\n",
+				index, rsrc_blks->rsrc_start,
+				rsrc_blks->rsrc_size);
+		index++;
+	}
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tRPI extents:\n");
+	index = 0;
+	list_for_each_entry(rsrc_blks, &phba->sli4_hba.lpfc_rpi_blk_list,
+			    list) {
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"\t\tBlock %3d: Start %4d, Count %4d\n",
+				index, rsrc_blks->rsrc_start,
+				rsrc_blks->rsrc_size);
+		index++;
+	}
+
+	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+			"\tXRI extents:\n");
+	index = 0;
+	list_for_each_entry(rsrc_blks, &phba->sli4_hba.lpfc_xri_blk_list,
+			    list) {
+		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+				"\t\tBlock %3d: Start %4d, Count %4d\n",
+				index, rsrc_blks->rsrc_start,
+				rsrc_blks->rsrc_size);
+		index++;
+	}
+
+	return len;
+}
+
+/**
+ * lpfc_idiag_extacc_write - Syntax check and set up idiag extacc commands
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the user data from.
+ * @nbytes: The number of bytes to get.
+ * @ppos: The position in the file to start reading from.
+ *
+ * This routine get the debugfs idiag command struct from user space and then
+ * perform the syntax check for extent information access commands and sets
+ * up the necessary states in the idiag command struct accordingly.
+ *
+ * It returns the @nbytges passing in from debugfs user space when successful.
+ * In case of error conditions, it returns proper error code back to the user
+ * space.
+ **/
+static ssize_t
+lpfc_idiag_extacc_write(struct file *file, const char __user *buf,
+			size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	uint32_t ext_map;
+	int rc;
+
+	/* This is a user write operation */
+	debug->op = LPFC_IDIAG_OP_WR;
+
+	rc = lpfc_idiag_cmd_get(buf, nbytes, &idiag.cmd);
+	if (rc < 0)
+		return rc;
+
+	ext_map = idiag.cmd.data[0];
+
+	if (idiag.cmd.opcode != LPFC_IDIAG_CMD_EXTACC_RD)
+		goto error_out;
+	if (rc != LPFC_EXT_ACC_CMD_ARG)
+		goto error_out;
+	if (!(ext_map & LPFC_EXT_ACC_ALL))
+		goto error_out;
+
+	return nbytes;
+error_out:
+	/* Clean out command structure on command error out */
+	memset(&idiag, 0, sizeof(idiag));
+	return -EINVAL;
+}
+
+/**
+ * lpfc_idiag_extacc_read - idiag debugfs read access to extent information
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the proper extent information according to
+ * the idiag command, and copies to user @buf.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_extacc_read(struct file *file, char __user *buf, size_t nbytes,
+		       loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	char *pbuffer;
+	uint32_t ext_map;
+	int len = 0;
+
+	/* This is a user read operation */
+	debug->op = LPFC_IDIAG_OP_RD;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_EXT_ACC_BUF_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+	if (*ppos)
+		return 0;
+	if (idiag.cmd.opcode != LPFC_IDIAG_CMD_EXTACC_RD)
+		return 0;
+
+	ext_map = idiag.cmd.data[0];
+	if (ext_map & LPFC_EXT_ACC_AVAIL)
+		len = lpfc_idiag_extacc_avail_get(phba, pbuffer, len);
+	if (ext_map & LPFC_EXT_ACC_ALLOC)
+		len = lpfc_idiag_extacc_alloc_get(phba, pbuffer, len);
+	if (ext_map & LPFC_EXT_ACC_DRIVR)
+		len = lpfc_idiag_extacc_drivr_get(phba, pbuffer, len);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
 #undef lpfc_debugfs_op_disc_trc
 static const struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
@@ -2427,7 +3106,7 @@ static const struct file_operations lpfc
 	.release =      lpfc_idiag_release,
 };
 
-#undef lpfc_idiag_op_queacc
+#undef lpfc_idiag_op_queAcc
 static const struct file_operations lpfc_idiag_op_queAcc = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_idiag_open,
@@ -2437,7 +3116,7 @@ static const struct file_operations lpfc
 	.release =      lpfc_idiag_cmd_release,
 };
 
-#undef lpfc_idiag_op_drbacc
+#undef lpfc_idiag_op_drbAcc
 static const struct file_operations lpfc_idiag_op_drbAcc = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_idiag_open,
@@ -2447,8 +3126,228 @@ static const struct file_operations lpfc
 	.release =      lpfc_idiag_cmd_release,
 };
 
+#undef lpfc_idiag_op_ctlAcc
+static const struct file_operations lpfc_idiag_op_ctlAcc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_idiag_ctlacc_read,
+	.write =        lpfc_idiag_ctlacc_write,
+	.release =      lpfc_idiag_cmd_release,
+};
+
+#undef lpfc_idiag_op_mbxAcc
+static const struct file_operations lpfc_idiag_op_mbxAcc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_idiag_mbxacc_read,
+	.write =        lpfc_idiag_mbxacc_write,
+	.release =      lpfc_idiag_cmd_release,
+};
+
+#undef lpfc_idiag_op_extAcc
+static const struct file_operations lpfc_idiag_op_extAcc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_idiag_extacc_read,
+	.write =        lpfc_idiag_extacc_write,
+	.release =      lpfc_idiag_cmd_release,
+};
+
 #endif
 
+/* lpfc_idiag_mbxacc_dump_bsg_mbox - idiag debugfs dump bsg mailbox command
+ * @phba: Pointer to HBA context object.
+ * @dmabuf: Pointer to a DMA buffer descriptor.
+ *
+ * Description:
+ * This routine dump a bsg pass-through non-embedded mailbox command with
+ * external buffer.
+ **/
+void
+lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
+				enum mbox_type mbox_tp, enum dma_type dma_tp,
+				enum sta_type sta_tp,
+				struct lpfc_dmabuf *dmabuf, uint32_t ext_buf)
+{
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint32_t *mbx_dump_map, *mbx_dump_cnt, *mbx_word_cnt;
+	char line_buf[LPFC_MBX_ACC_LBUF_SZ];
+	int len = 0;
+	uint32_t do_dump = 0;
+	uint32_t *pword;
+	uint32_t i;
+
+	if (idiag.cmd.opcode != LPFC_IDIAG_CMD_MBXACC_DP)
+		return;
+
+	mbx_dump_map = &idiag.cmd.data[0];
+	mbx_dump_cnt = &idiag.cmd.data[1];
+	mbx_word_cnt = &idiag.cmd.data[2];
+
+	if (!(*mbx_dump_map & LPFC_MBX_DMP_ALL) || (*mbx_dump_cnt == 0) ||
+	    (*mbx_word_cnt == 0))
+		return;
+
+	if ((mbox_tp == mbox_rd) && (dma_tp == dma_mbox)) {
+		if (*mbx_dump_map & LPFC_BSG_MBX_DMP_RD_MBX) {
+			do_dump |= LPFC_BSG_MBX_DMP_RD_MBX;
+			printk(KERN_ERR "\nRead mbox command (x%x), "
+			       "nemb:0x%x, extbuf_cnt:%d:\n",
+			       sta_tp, nemb_tp, ext_buf);
+		}
+	}
+	if ((mbox_tp == mbox_rd) && (dma_tp == dma_ebuf)) {
+		if (*mbx_dump_map & LPFC_BSG_MBX_DMP_RD_BUF) {
+			do_dump |= LPFC_BSG_MBX_DMP_RD_BUF;
+			printk(KERN_ERR "\nRead mbox buffer (x%x), "
+			       "nemb:0x%x, extbuf_seq:%d:\n",
+			       sta_tp, nemb_tp, ext_buf);
+		}
+	}
+	if ((mbox_tp == mbox_wr) && (dma_tp == dma_mbox)) {
+		if (*mbx_dump_map & LPFC_BSG_MBX_DMP_WR_MBX) {
+			do_dump |= LPFC_BSG_MBX_DMP_WR_MBX;
+			printk(KERN_ERR "\nWrite mbox command (x%x), "
+			       "nemb:0x%x, extbuf_cnt:%d:\n",
+			       sta_tp, nemb_tp, ext_buf);
+		}
+	}
+	if ((mbox_tp == mbox_wr) && (dma_tp == dma_ebuf)) {
+		if (*mbx_dump_map & LPFC_BSG_MBX_DMP_WR_BUF) {
+			do_dump |= LPFC_BSG_MBX_DMP_WR_MBX;
+			printk(KERN_ERR "\nWrite mbox buffer (x%x), "
+			       "nemb:0x%x, extbuf_seq:%d:\n",
+			       sta_tp, nemb_tp, ext_buf);
+		}
+	}
+
+	/* dump buffer content */
+	if (do_dump) {
+		pword = (uint32_t *)dmabuf->virt;
+		for (i = 0; i < *mbx_word_cnt; i++) {
+			if (!(i % 8)) {
+				if (i != 0)
+					printk(KERN_ERR "%s\n", line_buf);
+				len = 0;
+				len += snprintf(line_buf+len,
+						LPFC_MBX_ACC_LBUF_SZ-len,
+						"%03d: ", i);
+			}
+			len += snprintf(line_buf+len, LPFC_MBX_ACC_LBUF_SZ-len,
+					"%08x ", (uint32_t)*pword);
+			pword++;
+		}
+		if ((i - 1) % 8)
+			printk(KERN_ERR "%s\n", line_buf);
+		(*mbx_dump_cnt)--;
+	}
+
+	/* Clean out command structure on reaching dump count */
+	if (*mbx_dump_cnt == 0)
+		memset(&idiag, 0, sizeof(idiag));
+	return;
+#endif
+}
+
+/* lpfc_idiag_mbxacc_dump_issue_mbox - idiag debugfs dump issue mailbox command
+ * @phba: Pointer to HBA context object.
+ * @dmabuf: Pointer to a DMA buffer descriptor.
+ *
+ * Description:
+ * This routine dump a pass-through non-embedded mailbox command from issue
+ * mailbox command.
+ **/
+void
+lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
+{
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint32_t *mbx_dump_map, *mbx_dump_cnt, *mbx_word_cnt, *mbx_mbox_cmd;
+	char line_buf[LPFC_MBX_ACC_LBUF_SZ];
+	int len = 0;
+	uint32_t *pword;
+	uint8_t *pbyte;
+	uint32_t i, j;
+
+	if (idiag.cmd.opcode != LPFC_IDIAG_CMD_MBXACC_DP)
+		return;
+
+	mbx_dump_map = &idiag.cmd.data[0];
+	mbx_dump_cnt = &idiag.cmd.data[1];
+	mbx_word_cnt = &idiag.cmd.data[2];
+	mbx_mbox_cmd = &idiag.cmd.data[3];
+
+	if (!(*mbx_dump_map & LPFC_MBX_DMP_ISSUE_MBX_ALL) ||
+	    (*mbx_dump_cnt == 0) ||
+	    (*mbx_word_cnt == 0))
+		return;
+
+	if ((*mbx_mbox_cmd != 0xff) && (*mbx_mbox_cmd != pmbox->mbxCommand))
+		return;
+
+	/* dump buffer content */
+	if (*mbx_dump_map & LPFC_MBX_DMP_ISSUE_MBX_WORD) {
+		printk(KERN_ERR "Mailbox command:0x%x dump by word:\n",
+		       pmbox->mbxCommand);
+		pword = (uint32_t *)pmbox;
+		for (i = 0; i < *mbx_word_cnt; i++) {
+			if (!(i % 8)) {
+				if (i != 0)
+					printk(KERN_ERR "%s\n", line_buf);
+				len = 0;
+				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
+				len += snprintf(line_buf+len,
+						LPFC_MBX_ACC_LBUF_SZ-len,
+						"%03d: ", i);
+			}
+			len += snprintf(line_buf+len, LPFC_MBX_ACC_LBUF_SZ-len,
+					"%08x ",
+					((uint32_t)*pword) & 0xffffffff);
+			pword++;
+		}
+		if ((i - 1) % 8)
+			printk(KERN_ERR "%s\n", line_buf);
+		printk(KERN_ERR "\n");
+	}
+	if (*mbx_dump_map & LPFC_MBX_DMP_ISSUE_MBX_BYTE) {
+		printk(KERN_ERR "Mailbox command:0x%x dump by byte:\n",
+		       pmbox->mbxCommand);
+		pbyte = (uint8_t *)pmbox;
+		for (i = 0; i < *mbx_word_cnt; i++) {
+			if (!(i % 8)) {
+				if (i != 0)
+					printk(KERN_ERR "%s\n", line_buf);
+				len = 0;
+				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
+				len += snprintf(line_buf+len,
+						LPFC_MBX_ACC_LBUF_SZ-len,
+						"%03d: ", i);
+			}
+			for (j = 0; j < 4; j++) {
+				len += snprintf(line_buf+len,
+						LPFC_MBX_ACC_LBUF_SZ-len,
+						"%02x",
+						((uint8_t)*pbyte) & 0xff);
+				pbyte++;
+			}
+			len += snprintf(line_buf+len,
+					LPFC_MBX_ACC_LBUF_SZ-len, " ");
+		}
+		if ((i - 1) % 8)
+			printk(KERN_ERR "%s\n", line_buf);
+		printk(KERN_ERR "\n");
+	}
+	(*mbx_dump_cnt)--;
+
+	/* Clean out command structure on reaching dump count */
+	if (*mbx_dump_cnt == 0)
+		memset(&idiag, 0, sizeof(idiag));
+	return;
+#endif
+}
+
 /**
  * lpfc_debugfs_initialize - Initialize debugfs for a vport
  * @vport: The vport pointer to initialize.
@@ -2672,7 +3571,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 vport, &lpfc_debugfs_op_nodelist);
 	if (!vport->debug_nodelist) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0409 Can't create debugfs nodelist\n");
+				 "2985 Can't create debugfs nodelist\n");
 		goto debug_failed;
 	}
 
@@ -2748,6 +3647,50 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		}
 	}
 
+	/* iDiag access PCI function control registers */
+	snprintf(name, sizeof(name), "ctlAcc");
+	if (!phba->idiag_ctl_acc) {
+		phba->idiag_ctl_acc =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				phba->idiag_root, phba, &lpfc_idiag_op_ctlAcc);
+		if (!phba->idiag_ctl_acc) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "2981 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+	}
+
+	/* iDiag access mbox commands */
+	snprintf(name, sizeof(name), "mbxAcc");
+	if (!phba->idiag_mbx_acc) {
+		phba->idiag_mbx_acc =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				phba->idiag_root, phba, &lpfc_idiag_op_mbxAcc);
+		if (!phba->idiag_mbx_acc) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					"2980 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+	}
+
+	/* iDiag extents access commands */
+	if (phba->sli4_hba.extents_in_use) {
+		snprintf(name, sizeof(name), "extAcc");
+		if (!phba->idiag_ext_acc) {
+			phba->idiag_ext_acc =
+				debugfs_create_file(name,
+						    S_IFREG|S_IRUGO|S_IWUSR,
+						    phba->idiag_root, phba,
+						    &lpfc_idiag_op_extAcc);
+			if (!phba->idiag_ext_acc) {
+				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+						"2986 Cant create "
+						"idiag debugfs\n");
+				goto debug_failed;
+			}
+		}
+	}
+
 debug_failed:
 	return;
 #endif
@@ -2782,7 +3725,6 @@ lpfc_debugfs_terminate(struct lpfc_vport
 		debugfs_remove(vport->debug_nodelist); /* nodelist */
 		vport->debug_nodelist = NULL;
 	}
-
 	if (vport->vport_debugfs_root) {
 		debugfs_remove(vport->vport_debugfs_root); /* vportX */
 		vport->vport_debugfs_root = NULL;
@@ -2826,6 +3768,21 @@ lpfc_debugfs_terminate(struct lpfc_vport
 		 * iDiag release
 		 */
 		if (phba->sli_rev == LPFC_SLI_REV4) {
+			if (phba->idiag_ext_acc) {
+				/* iDiag extAcc */
+				debugfs_remove(phba->idiag_ext_acc);
+				phba->idiag_ext_acc = NULL;
+			}
+			if (phba->idiag_mbx_acc) {
+				/* iDiag mbxAcc */
+				debugfs_remove(phba->idiag_mbx_acc);
+				phba->idiag_mbx_acc = NULL;
+			}
+			if (phba->idiag_ctl_acc) {
+				/* iDiag ctlAcc */
+				debugfs_remove(phba->idiag_ctl_acc);
+				phba->idiag_ctl_acc = NULL;
+			}
 			if (phba->idiag_drb_acc) {
 				/* iDiag drbAcc */
 				debugfs_remove(phba->idiag_drb_acc);
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2011-05-20 19:54:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2011-05-27 23:33:01.000000000 -0400
@@ -63,7 +63,7 @@
 #define LPFC_IDIAG_WQ 4
 #define LPFC_IDIAG_RQ 5
 
-/* doorbell acc */
+/* doorbell register acc */
 #define LPFC_DRB_ACC_ALL 0xffff
 #define LPFC_DRB_ACC_RD_CMD_ARG 1
 #define LPFC_DRB_ACC_WR_CMD_ARG 2
@@ -76,6 +76,56 @@
 
 #define LPFC_DRB_MAX  4
 
+/* control register acc */
+#define LPFC_CTL_ACC_ALL 0xffff
+#define LPFC_CTL_ACC_RD_CMD_ARG 1
+#define LPFC_CTL_ACC_WR_CMD_ARG 2
+#define LPFC_CTL_ACC_BUF_SIZE 256
+
+#define LPFC_CTL_PORT_SEM  1
+#define LPFC_CTL_PORT_STA  2
+#define LPFC_CTL_PORT_CTL  3
+#define LPFC_CTL_PORT_ER1  4
+#define LPFC_CTL_PORT_ER2  5
+#define LPFC_CTL_PDEV_CTL  6
+
+#define LPFC_CTL_MAX  6
+
+/* mailbox access */
+#define LPFC_BSG_MBX_DMP_CMD_ARG 	3
+#define LPFC_MBX_DMP_ISSUE_MBX_CMD_ARG	4
+
+#define LPFC_MBX_ACC_BUF_SIZE 512
+#define LPFC_MBX_ACC_LBUF_SZ 128
+
+#define LPFC_MBX_DMP_ISSUE_MBX_WORD 0x00000001
+#define LPFC_MBX_DMP_ISSUE_MBX_BYTE 0x00000002
+#define LPFC_MBX_DMP_ISSUE_MBX_ALL (LPFC_MBX_DMP_ISSUE_MBX_WORD | \
+				    LPFC_MBX_DMP_ISSUE_MBX_BYTE)
+
+#define LPFC_BSG_MBX_DMP_RD_MBX 0x00000004
+#define LPFC_BSG_MBX_DMP_RD_BUF 0x00000008
+#define LPFC_BSG_MBX_DMP_WR_MBX 0x00000010
+#define LPFC_BSG_MBX_DMP_WR_BUF 0x00000020
+#define LPFC_BSG_MBX_DMP_ALL (LPFC_BSG_MBX_DMP_RD_MBX | \
+			      LPFC_BSG_MBX_DMP_RD_BUF | \
+			      LPFC_BSG_MBX_DMP_WR_MBX | \
+			      LPFC_BSG_MBX_DMP_WR_BUF)
+
+#define LPFC_MBX_DMP_ALL (LPFC_BSG_MBX_DMP_ALL | \
+			  LPFC_MBX_DMP_ISSUE_MBX_ALL)
+
+/* extents access */
+#define LPFC_EXT_ACC_CMD_ARG 1
+#define LPFC_EXT_ACC_BUF_SIZE 4096
+
+#define LPFC_EXT_ACC_AVAIL 0x1
+#define LPFC_EXT_ACC_ALLOC 0x2
+#define LPFC_EXT_ACC_DRIVR 0x4
+#define LPFC_EXT_ACC_ALL   (LPFC_EXT_ACC_DRIVR | \
+			    LPFC_EXT_ACC_AVAIL | \
+			    LPFC_EXT_ACC_ALLOC)
+
 #define SIZE_U8  sizeof(uint8_t)
 #define SIZE_U16 sizeof(uint16_t)
 #define SIZE_U32 sizeof(uint32_t)
@@ -119,6 +169,16 @@ struct lpfc_idiag_cmd {
 #define LPFC_IDIAG_CMD_DRBACC_WR 0x00000022
 #define LPFC_IDIAG_CMD_DRBACC_ST 0x00000023
 #define LPFC_IDIAG_CMD_DRBACC_CL 0x00000024
+
+#define LPFC_IDIAG_CMD_CTLACC_RD 0x00000031
+#define LPFC_IDIAG_CMD_CTLACC_WR 0x00000032
+#define LPFC_IDIAG_CMD_CTLACC_ST 0x00000033
+#define LPFC_IDIAG_CMD_CTLACC_CL 0x00000034
+
+#define LPFC_IDIAG_CMD_MBXACC_DP 0x00000041
+
+#define LPFC_IDIAG_CMD_EXTACC_RD 0x00000051
+
 	uint32_t data[LPFC_IDIAG_CMD_DATA_SIZE];
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-05-27 23:32:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2011-05-27 23:33:01.000000000 -0400
@@ -54,6 +54,8 @@ struct lpfc_sli2_slim;
 
 #define  LPFC_MAX_BUCKET_COUNT 20	/* Maximum no. of buckets for stat data
 					   collection. */
+
+#define CONFIG_SCSI_LPFC_DEBUG_FS 1;
 /*
  * Following time intervals are used of adjusting SCSI device
  * queue depths when there are driver resource error or Firmware
@@ -848,6 +850,9 @@ struct lpfc_hba {
 	struct dentry *idiag_que_info;
 	struct dentry *idiag_que_acc;
 	struct dentry *idiag_drb_acc;
+	struct dentry *idiag_ctl_acc;
+	struct dentry *idiag_mbx_acc;
+	struct dentry *idiag_ext_acc;
 #endif
 
 	/* Used for deferred freeing of ELS data buffers */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-05-27 23:32:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-05-27 23:33:01.000000000 -0400
@@ -9112,7 +9112,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 
 	/* Check if there are static vports to be created. */
 	lpfc_create_static_vport(phba);
-
 	return 0;
 
 out_disable_intr:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-05-27 23:32:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-05-27 23:33:01.000000000 -0400
@@ -4712,10 +4712,15 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba 
  * lpfc_sli4_get_avail_extnt_rsrc - Get available resource extent count.
  * @phba: Pointer to HBA context object.
  * @type: The resource extent type.
+ * @extnt_count: buffer to hold port available extent count.
+ * @extnt_size: buffer to hold element count per extent.
  *
- * This function allocates all SLI4 resource identifiers.
+ * This function calls the port and retrievs the number of available
+ * extents and their size for a particular extent type.
+ *
+ * Returns: 0 if successful.  Nonzero otherwise.
  **/
-static int
+int
 lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *phba, uint16_t type,
 			       uint16_t *extnt_count, uint16_t *extnt_size)
 {
@@ -4892,7 +4897,7 @@ lpfc_sli4_cfg_post_extnts(struct lpfc_hb
 				     req_len, *emb);
 	if (alloc_len < req_len) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"9000 Allocated DMA memory size (x%x) is "
+			"2982 Allocated DMA memory size (x%x) is "
 			"less than the requested DMA memory "
 			"size (x%x)\n", alloc_len, req_len);
 		return -ENOMEM;
@@ -5506,6 +5511,155 @@ lpfc_sli4_dealloc_resource_identifiers(s
 }
 
 /**
+ * lpfc_sli4_get_allocated_extnts - Get the port's allocated extents.
+ * @phba: Pointer to HBA context object.
+ * @type: The resource extent type.
+ * @extnt_count: buffer to hold port extent count response
+ * @extnt_size: buffer to hold port extent size response.
+ *
+ * This function calls the port to read the host allocated extents
+ * for a particular type.
+ **/
+int
+lpfc_sli4_get_allocated_extnts(struct lpfc_hba *phba, uint16_t type,
+			       uint16_t *extnt_cnt, uint16_t *extnt_size)
+{
+	bool emb;
+	int rc = 0;
+	uint16_t curr_blks = 0;
+	uint32_t req_len, emb_len;
+	uint32_t alloc_len, mbox_tmo;
+	struct list_head *blk_list_head;
+	struct lpfc_rsrc_blks *rsrc_blk;
+	LPFC_MBOXQ_t *mbox;
+	void *virtaddr = NULL;
+	struct lpfc_mbx_nembed_rsrc_extent *n_rsrc;
+	struct lpfc_mbx_alloc_rsrc_extents *rsrc_ext;
+	union  lpfc_sli4_cfg_shdr *shdr;
+
+	switch (type) {
+	case LPFC_RSC_TYPE_FCOE_VPI:
+		blk_list_head = &phba->lpfc_vpi_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_XRI:
+		blk_list_head = &phba->sli4_hba.lpfc_xri_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_VFI:
+		blk_list_head = &phba->sli4_hba.lpfc_vfi_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_RPI:
+		blk_list_head = &phba->sli4_hba.lpfc_rpi_blk_list;
+		break;
+	default:
+		return -EIO;
+	}
+
+	/* Count the number of extents currently allocatd for this type. */
+	list_for_each_entry(rsrc_blk, blk_list_head, list) {
+		if (curr_blks == 0) {
+			/*
+			 * The GET_ALLOCATED mailbox does not return the size,
+			 * just the count.  The size should be just the size
+			 * stored in the current allocated block and all sizes
+			 * for an extent type are the same so set the return
+			 * value now.
+			 */
+			*extnt_size = rsrc_blk->rsrc_size;
+		}
+		curr_blks++;
+	}
+
+	/* Calculate the total requested length of the dma memory. */
+	req_len = curr_blks * sizeof(uint16_t);
+
+	/*
+	 * Calculate the size of an embedded mailbox.  The uint32_t
+	 * accounts for extents-specific word.
+	 */
+	emb_len = sizeof(MAILBOX_t) - sizeof(struct mbox_header) -
+		sizeof(uint32_t);
+
+	/*
+	 * Presume the allocation and response will fit into an embedded
+	 * mailbox.  If not true, reconfigure to a non-embedded mailbox.
+	 */
+	emb = LPFC_SLI4_MBX_EMBED;
+	req_len = emb_len;
+	if (req_len > emb_len) {
+		req_len = curr_blks * sizeof(uint16_t) +
+			sizeof(union lpfc_sli4_cfg_shdr) +
+			sizeof(uint32_t);
+		emb = LPFC_SLI4_MBX_NEMBED;
+	}
+
+	mbox = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	memset(mbox, 0, sizeof(LPFC_MBOXQ_t));
+
+	alloc_len = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+				     LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT,
+				     req_len, emb);
+	if (alloc_len < req_len) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2983 Allocated DMA memory size (x%x) is "
+			"less than the requested DMA memory "
+			"size (x%x)\n", alloc_len, req_len);
+		rc = -ENOMEM;
+		goto err_exit;
+	}
+	rc = lpfc_sli4_mbox_rsrc_extent(phba, mbox, curr_blks, type, emb);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto err_exit;
+	}
+
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto err_exit;
+	}
+
+	/*
+	 * Figure out where the response is located.  Then get local pointers
+	 * to the response data.  The port does not guarantee to respond to
+	 * all extents counts request so update the local variable with the
+	 * allocated count from the port.
+	 */
+	if (emb == LPFC_SLI4_MBX_EMBED) {
+		rsrc_ext = &mbox->u.mqe.un.alloc_rsrc_extents;
+		shdr = &rsrc_ext->header.cfg_shdr;
+		*extnt_cnt = bf_get(lpfc_mbx_rsrc_cnt, &rsrc_ext->u.rsp);
+	} else {
+		virtaddr = mbox->sge_array->addr[0];
+		n_rsrc = (struct lpfc_mbx_nembed_rsrc_extent *) virtaddr;
+		shdr = &n_rsrc->cfg_shdr;
+		*extnt_cnt = bf_get(lpfc_mbx_rsrc_cnt, n_rsrc);
+	}
+
+	*extnt_cnt = curr_blks;
+	if (bf_get(lpfc_mbox_hdr_status, &shdr->response)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+			"2984 Failed to read allocated resources "
+			"for type %d - Status 0x%x Add'l Status 0x%x.\n",
+			type,
+			bf_get(lpfc_mbox_hdr_status, &shdr->response),
+			bf_get(lpfc_mbox_hdr_add_status, &shdr->response));
+		rc = -EIO;
+		goto err_exit;
+	}
+ err_exit:
+	lpfc_sli4_mbox_cmd_free(phba, mbox);
+	return rc;
+}
+
+/**
  * lpfc_sli4_hba_setup - SLI4 device intialization PCI function
  * @phba: Pointer to HBA context object.
  *
@@ -6634,6 +6788,9 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 	unsigned long iflags;
 	int rc;
 
+	/* dump from issue mailbox command if setup */
+	lpfc_idiag_mbxacc_dump_issue_mbox(phba, &mboxq->u.mb);
+
 	rc = lpfc_mbox_dev_check(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,


