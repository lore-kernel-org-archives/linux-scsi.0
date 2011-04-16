From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/5] lpfc 8.3.23: Debugfs enhancements
Date: Sat, 16 Apr 2011 11:03:04 -0400
Message-ID: <1302966198.6245.26.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15975 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751811Ab1DPPDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2011 11:03:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Debugfs enhancements

- Added iDiag support for new adapters.
- Added queue entry access methods.
- Fix host/port index in decimal
- Added Doorbell register access methods.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 
 lpfc_debugfs.c |  931 +++++++++++++++++++++++++++++++++++++++++++--------------
 lpfc_debugfs.h |   48 ++
 3 files changed, 759 insertions(+), 222 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2011-04-16 08:29:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-04-16 09:34:09.000000000 -0400
@@ -1119,172 +1119,14 @@ lpfc_debugfs_dumpDataDif_release(struct 
 }
 
 /*
+ * ---------------------------------
  * iDiag debugfs file access methods
- */
-
-/*
- * iDiag PCI config space register access methods:
- *
- * The PCI config space register accessees of read, write, read-modify-write
- * for set bits, and read-modify-write for clear bits to SLI4 PCI functions
- * are provided. In the proper SLI4 PCI function's debugfs iDiag directory,
- *
- *      /sys/kernel/debug/lpfc/fn<#>/iDiag
- *
- * the access is through the debugfs entry pciCfg:
- *
- * 1. For PCI config space register read access, there are two read methods:
- *    A) read a single PCI config space register in the size of a byte
- *    (8 bits), a word (16 bits), or a dword (32 bits); or B) browse through
- *    the 4K extended PCI config space.
- *
- *    A) Read a single PCI config space register consists of two steps:
- *
- *    Step-1: Set up PCI config space register read command, the command
- *    syntax is,
- *
- *        echo 1 <where> <count> > pciCfg
- *
- *    where, 1 is the iDiag command for PCI config space read, <where> is the
- *    offset from the beginning of the device's PCI config space to read from,
- *    and <count> is the size of PCI config space register data to read back,
- *    it will be 1 for reading a byte (8 bits), 2 for reading a word (16 bits
- *    or 2 bytes), or 4 for reading a dword (32 bits or 4 bytes).
- *
- *    Setp-2: Perform the debugfs read operation to execute the idiag command
- *    set up in Step-1,
- *
- *        cat pciCfg
- *
- *    Examples:
- *    To read PCI device's vendor-id and device-id from PCI config space,
- *
- *        echo 1 0 4 > pciCfg
- *        cat pciCfg
- *
- *    To read PCI device's currnt command from config space,
- *
- *        echo 1 4 2 > pciCfg
- *        cat pciCfg
- *
- *    B) Browse through the entire 4K extended PCI config space also consists
- *    of two steps:
- *
- *    Step-1: Set up PCI config space register browsing command, the command
- *    syntax is,
- *
- *        echo 1 0 4096 > pciCfg
- *
- *    where, 1 is the iDiag command for PCI config space read, 0 must be used
- *    as the offset for PCI config space register browse, and 4096 must be
- *    used as the count for PCI config space register browse.
- *
- *    Step-2: Repeately issue the debugfs read operation to browse through
- *    the entire PCI config space registers:
- *
- *        cat pciCfg
- *        cat pciCfg
- *        cat pciCfg
- *        ...
- *
- *    When browsing to the end of the 4K PCI config space, the browse method
- *    shall wrap around to start reading from beginning again, and again...
- *
- * 2. For PCI config space register write access, it supports a single PCI
- *    config space register write in the size of a byte (8 bits), a word
- *    (16 bits), or a dword (32 bits). The command syntax is,
- *
- *        echo 2 <where> <count> <value> > pciCfg
- *
- *    where, 2 is the iDiag command for PCI config space write, <where> is
- *    the offset from the beginning of the device's PCI config space to write
- *    into, <count> is the size of data to write into the PCI config space,
- *    it will be 1 for writing a byte (8 bits), 2 for writing a word (16 bits
- *    or 2 bytes), or 4 for writing a dword (32 bits or 4 bytes), and <value>
- *    is the data to be written into the PCI config space register at the
- *    offset.
- *
- *    Examples:
- *    To disable PCI device's interrupt assertion,
- *
- *    1) Read in device's PCI config space register command field <cmd>:
- *
- *           echo 1 4 2 > pciCfg
- *           cat pciCfg
- *
- *    2) Set bit 10 (Interrupt Disable bit) in the <cmd>:
- *
- *           <cmd> = <cmd> | (1 < 10)
- *
- *    3) Write the modified command back:
- *
- *           echo 2 4 2 <cmd> > pciCfg
- *
- * 3. For PCI config space register set bits access, it supports a single PCI
- *    config space register set bits in the size of a byte (8 bits), a word
- *    (16 bits), or a dword (32 bits). The command syntax is,
- *
- *        echo 3 <where> <count> <bitmask> > pciCfg
- *
- *    where, 3 is the iDiag command for PCI config space set bits, <where> is
- *    the offset from the beginning of the device's PCI config space to set
- *    bits into, <count> is the size of the bitmask to set into the PCI config
- *    space, it will be 1 for setting a byte (8 bits), 2 for setting a word
- *    (16 bits or 2 bytes), or 4 for setting a dword (32 bits or 4 bytes), and
- *    <bitmask> is the bitmask, indicating the bits to be set into the PCI
- *    config space register at the offset. The logic performed to the content
- *    of the PCI config space register, regval, is,
- *
- *        regval |= <bitmask>
- *
- * 4. For PCI config space register clear bits access, it supports a single
- *    PCI config space register clear bits in the size of a byte (8 bits),
- *    a word (16 bits), or a dword (32 bits). The command syntax is,
- *
- *        echo 4 <where> <count> <bitmask> > pciCfg
- *
- *    where, 4 is the iDiag command for PCI config space clear bits, <where>
- *    is the offset from the beginning of the device's PCI config space to
- *    clear bits from, <count> is the size of the bitmask to set into the PCI
- *    config space, it will be 1 for setting a byte (8 bits), 2 for setting
- *    a word(16 bits or 2 bytes), or 4 for setting a dword (32 bits or 4
- *    bytes), and <bitmask> is the bitmask, indicating the bits to be cleared
- *    from the PCI config space register at the offset. the logic performed
- *    to the content of the PCI config space register, regval, is,
- *
- *        regval &= ~<bitmask>
+ * ---------------------------------
  *
- * Note, for all single register read, write, set bits, or clear bits access,
- * the offset (<where>) must be aligned with the size of the data:
+ * All access methods are through the proper SLI4 PCI function's debugfs
+ * iDiag directory:
  *
- * For data size of byte (8 bits), the offset must be aligned to the byte
- * boundary; for data size of word (16 bits), the offset must be aligned
- * to the word boundary; while for data size of dword (32 bits), the offset
- * must be aligned to the dword boundary. Otherwise, the interface will
- * return the error:
- *
- *     "-bash: echo: write error: Invalid argument".
- *
- * For example:
- *
- *     echo 1 2 4 > pciCfg
- *     -bash: echo: write error: Invalid argument
- *
- * Note also, all of the numbers in the command fields for all read, write,
- * set bits, and clear bits PCI config space register command fields can be
- * either decimal or hex.
- *
- * For example,
- *     echo 1 0 4096 > pciCfg
- *
- * will be the same as
- *     echo 1 0 0x1000 > pciCfg
- *
- * And,
- *     echo 2 155 1 10 > pciCfg
- *
- * will be
- *     echo 2 0x9b 1 0xa > pciCfg
+ *     /sys/kernel/debug/lpfc/fn<#>/iDiag
  */
 
 /**
@@ -1331,10 +1173,10 @@ static int lpfc_idiag_cmd_get(const char
 	for (i = 0; i < LPFC_IDIAG_CMD_DATA_SIZE; i++) {
 		step_str = strsep(&pbuf, "\t ");
 		if (!step_str)
-			return 0;
+			return i;
 		idiag_cmd->data[i] = simple_strtol(step_str, NULL, 0);
 	}
-	return 0;
+	return i;
 }
 
 /**
@@ -1403,7 +1245,7 @@ lpfc_idiag_release(struct inode *inode, 
  * Description:
  * This routine frees the buffer that was allocated when the debugfs file
  * was opened. It also reset the fields in the idiag command struct in the
- * case the command is not continuous browsing of the data structure.
+ * case of command for write operation.
  *
  * Returns:
  * This function returns zero.
@@ -1413,18 +1255,20 @@ lpfc_idiag_cmd_release(struct inode *ino
 {
 	struct lpfc_debug *debug = file->private_data;
 
-	/* Read PCI config register, if not read all, clear command fields */
-	if ((debug->op == LPFC_IDIAG_OP_RD) &&
-	    (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_RD))
-		if ((idiag.cmd.data[1] == sizeof(uint8_t)) ||
-		    (idiag.cmd.data[1] == sizeof(uint16_t)) ||
-		    (idiag.cmd.data[1] == sizeof(uint32_t)))
+	if (debug->op == LPFC_IDIAG_OP_WR) {
+		switch (idiag.cmd.opcode) {
+		case LPFC_IDIAG_CMD_PCICFG_WR:
+		case LPFC_IDIAG_CMD_PCICFG_ST:
+		case LPFC_IDIAG_CMD_PCICFG_CL:
+		case LPFC_IDIAG_CMD_QUEACC_WR:
+		case LPFC_IDIAG_CMD_QUEACC_ST:
+		case LPFC_IDIAG_CMD_QUEACC_CL:
 			memset(&idiag, 0, sizeof(idiag));
-
-	/* Write PCI config register, clear command fields */
-	if ((debug->op == LPFC_IDIAG_OP_WR) &&
-	    (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR))
-		memset(&idiag, 0, sizeof(idiag));
+			break;
+		default:
+			break;
+		}
+	}
 
 	/* Free the buffers to the file operation */
 	kfree(debug->buffer);
@@ -1504,7 +1348,7 @@ lpfc_idiag_pcicfg_read(struct file *file
 		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 				"%03x: %08x\n", where, u32val);
 		break;
-	case LPFC_PCI_CFG_SIZE: /* browse all */
+	case LPFC_PCI_CFG_BROWSE: /* browse all */
 		goto pcicfg_browse;
 		break;
 	default:
@@ -1586,16 +1430,21 @@ lpfc_idiag_pcicfg_write(struct file *fil
 	debug->op = LPFC_IDIAG_OP_WR;
 
 	rc = lpfc_idiag_cmd_get(buf, nbytes, &idiag.cmd);
-	if (rc)
+	if (rc < 0)
 		return rc;
 
 	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_RD) {
+		/* Sanity check on PCI config read command line arguments */
+		if (rc != LPFC_PCI_CFG_RD_CMD_ARG)
+			goto error_out;
 		/* Read command from PCI config space, set up command fields */
 		where = idiag.cmd.data[0];
 		count = idiag.cmd.data[1];
-		if (count == LPFC_PCI_CFG_SIZE) {
-			if (where != 0)
+		if (count == LPFC_PCI_CFG_BROWSE) {
+			if (where % sizeof(uint32_t))
 				goto error_out;
+			/* Starting offset to browse */
+			idiag.offset.last_rd = where;
 		} else if ((count != sizeof(uint8_t)) &&
 			   (count != sizeof(uint16_t)) &&
 			   (count != sizeof(uint32_t)))
@@ -1621,6 +1470,9 @@ lpfc_idiag_pcicfg_write(struct file *fil
 	} else if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR ||
 		   idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_ST ||
 		   idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_CL) {
+		/* Sanity check on PCI config write command line arguments */
+		if (rc != LPFC_PCI_CFG_WR_CMD_ARG)
+			goto error_out;
 		/* Write command to PCI config space, read-modify-write */
 		where = idiag.cmd.data[0];
 		count = idiag.cmd.data[1];
@@ -1753,10 +1605,12 @@ lpfc_idiag_queinfo_read(struct file *fil
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
 			"Slow-path EQ information:\n");
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], EQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			"\tEQID[%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
 			phba->sli4_hba.sp_eq->queue_id,
 			phba->sli4_hba.sp_eq->entry_count,
+			phba->sli4_hba.sp_eq->entry_size,
 			phba->sli4_hba.sp_eq->host_index,
 			phba->sli4_hba.sp_eq->hba_index);
 
@@ -1765,10 +1619,12 @@ lpfc_idiag_queinfo_read(struct file *fil
 			"Fast-path EQ information:\n");
 	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++) {
 		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tID [%02d], EQE-COUNT [%04d], "
-				"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+				"\tEQID[%02d], "
+				"QE-COUNT[%04d], QE-SIZE[%04d], "
+				"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
 				phba->sli4_hba.fp_eq[fcp_qidx]->queue_id,
 				phba->sli4_hba.fp_eq[fcp_qidx]->entry_count,
+				phba->sli4_hba.fp_eq[fcp_qidx]->entry_size,
 				phba->sli4_hba.fp_eq[fcp_qidx]->host_index,
 				phba->sli4_hba.fp_eq[fcp_qidx]->hba_index);
 	}
@@ -1776,89 +1632,101 @@ lpfc_idiag_queinfo_read(struct file *fil
 
 	/* Get mailbox complete queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Mailbox CQ information:\n");
+			"Slow-path MBX CQ information:\n");
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\t\tAssociated EQ-ID [%02d]:\n",
+			"Associated EQID[%02d]:\n",
 			phba->sli4_hba.mbx_cq->assoc_qid);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], CQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			"\tCQID[%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
 			phba->sli4_hba.mbx_cq->queue_id,
 			phba->sli4_hba.mbx_cq->entry_count,
+			phba->sli4_hba.mbx_cq->entry_size,
 			phba->sli4_hba.mbx_cq->host_index,
 			phba->sli4_hba.mbx_cq->hba_index);
 
 	/* Get slow-path complete queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path CQ information:\n");
+			"Slow-path ELS CQ information:\n");
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\t\tAssociated EQ-ID [%02d]:\n",
+			"Associated EQID[%02d]:\n",
 			phba->sli4_hba.els_cq->assoc_qid);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], CQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			"\tCQID [%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
 			phba->sli4_hba.els_cq->queue_id,
 			phba->sli4_hba.els_cq->entry_count,
+			phba->sli4_hba.els_cq->entry_size,
 			phba->sli4_hba.els_cq->host_index,
 			phba->sli4_hba.els_cq->hba_index);
 
 	/* Get fast-path complete queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Fast-path CQ information:\n");
+			"Fast-path FCP CQ information:\n");
 	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++) {
 		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tAssociated EQ-ID [%02d]:\n",
+				"Associated EQID[%02d]:\n",
 				phba->sli4_hba.fcp_cq[fcp_qidx]->assoc_qid);
 		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-		"\tID [%02d], EQE-COUNT [%04d], "
-		"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
-		phba->sli4_hba.fcp_cq[fcp_qidx]->queue_id,
-		phba->sli4_hba.fcp_cq[fcp_qidx]->entry_count,
-		phba->sli4_hba.fcp_cq[fcp_qidx]->host_index,
-		phba->sli4_hba.fcp_cq[fcp_qidx]->hba_index);
+				"\tCQID[%02d], "
+				"QE-COUNT[%04d], QE-SIZE[%04d], "
+				"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
+				phba->sli4_hba.fcp_cq[fcp_qidx]->queue_id,
+				phba->sli4_hba.fcp_cq[fcp_qidx]->entry_count,
+				phba->sli4_hba.fcp_cq[fcp_qidx]->entry_size,
+				phba->sli4_hba.fcp_cq[fcp_qidx]->host_index,
+				phba->sli4_hba.fcp_cq[fcp_qidx]->hba_index);
 	}
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 
 	/* Get mailbox queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Mailbox MQ information:\n");
+			"Slow-path MBX MQ information:\n");
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\t\tAssociated CQ-ID [%02d]:\n",
+			"Associated CQID[%02d]:\n",
 			phba->sli4_hba.mbx_wq->assoc_qid);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], MQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			"\tWQID[%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
 			phba->sli4_hba.mbx_wq->queue_id,
 			phba->sli4_hba.mbx_wq->entry_count,
+			phba->sli4_hba.mbx_wq->entry_size,
 			phba->sli4_hba.mbx_wq->host_index,
 			phba->sli4_hba.mbx_wq->hba_index);
 
 	/* Get slow-path work queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path WQ information:\n");
+			"Slow-path ELS WQ information:\n");
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\t\tAssociated CQ-ID [%02d]:\n",
+			"Associated CQID[%02d]:\n",
 			phba->sli4_hba.els_wq->assoc_qid);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], WQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			"\tWQID[%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
 			phba->sli4_hba.els_wq->queue_id,
 			phba->sli4_hba.els_wq->entry_count,
+			phba->sli4_hba.els_wq->entry_size,
 			phba->sli4_hba.els_wq->host_index,
 			phba->sli4_hba.els_wq->hba_index);
 
 	/* Get fast-path work queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Fast-path WQ information:\n");
+			"Fast-path FCP WQ information:\n");
 	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_wq_count; fcp_qidx++) {
 		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tAssociated CQ-ID [%02d]:\n",
+				"Associated CQID[%02d]:\n",
 				phba->sli4_hba.fcp_wq[fcp_qidx]->assoc_qid);
 		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tID [%02d], WQE-COUNT [%04d], "
-				"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+				"\tWQID[%02d], "
+				"QE-COUNT[%04d], WQE-SIZE[%04d], "
+				"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
 				phba->sli4_hba.fcp_wq[fcp_qidx]->queue_id,
 				phba->sli4_hba.fcp_wq[fcp_qidx]->entry_count,
+				phba->sli4_hba.fcp_wq[fcp_qidx]->entry_size,
 				phba->sli4_hba.fcp_wq[fcp_qidx]->host_index,
 				phba->sli4_hba.fcp_wq[fcp_qidx]->hba_index);
 	}
@@ -1868,26 +1736,597 @@ lpfc_idiag_queinfo_read(struct file *fil
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
 			"Slow-path RQ information:\n");
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\t\tAssociated CQ-ID [%02d]:\n",
+			"Associated CQID[%02d]:\n",
 			phba->sli4_hba.hdr_rq->assoc_qid);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], RHQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+			"\tHQID[%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
 			phba->sli4_hba.hdr_rq->queue_id,
 			phba->sli4_hba.hdr_rq->entry_count,
+			phba->sli4_hba.hdr_rq->entry_size,
 			phba->sli4_hba.hdr_rq->host_index,
 			phba->sli4_hba.hdr_rq->hba_index);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tID [%02d], RDQE-COUNT [%04d], "
-			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+			"\tDQID[%02d], "
+			"QE-COUNT[%04d], QE-SIZE[%04d], "
+			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
 			phba->sli4_hba.dat_rq->queue_id,
 			phba->sli4_hba.dat_rq->entry_count,
+			phba->sli4_hba.dat_rq->entry_size,
 			phba->sli4_hba.dat_rq->host_index,
 			phba->sli4_hba.dat_rq->hba_index);
 
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 }
 
+/**
+ * lpfc_idiag_que_param_check - queue access command parameter sanity check
+ * @q: The pointer to queue structure.
+ * @index: The index into a queue entry.
+ * @count: The number of queue entries to access.
+ *
+ * Description:
+ * The routine performs sanity check on device queue access method commands.
+ *
+ * Returns:
+ * This function returns -EINVAL when fails the sanity check, otherwise, it
+ * returns 0.
+ **/
+static int
+lpfc_idiag_que_param_check(struct lpfc_queue *q, int index, int count)
+{
+	/* Only support single entry read or browsing */
+	if ((count != 1) && (count != LPFC_QUE_ACC_BROWSE))
+		return -EINVAL;
+	if (index > q->entry_count - 1)
+		return -EINVAL;
+	return 0;
+}
+
+/**
+ * lpfc_idiag_queacc_read_qe - read a single entry from the given queue index
+ * @pbuffer: The pointer to buffer to copy the read data into.
+ * @pque: The pointer to the queue to be read.
+ * @index: The index into the queue entry.
+ *
+ * Description:
+ * This routine reads out a single entry from the given queue's index location
+ * and copies it into the buffer provided.
+ *
+ * Returns:
+ * This function returns 0 when it fails, otherwise, it returns the length of
+ * the data read into the buffer provided.
+ **/
+static int
+lpfc_idiag_queacc_read_qe(char *pbuffer, int len, struct lpfc_queue *pque,
+			  uint32_t index)
+{
+	int offset, esize;
+	uint32_t *pentry;
+
+	if (!pbuffer || !pque)
+		return 0;
+
+	esize = pque->entry_size;
+	len += snprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len,
+			"QE-INDEX[%04d]:\n", index);
+
+	offset = 0;
+	pentry = pque->qe[index].address;
+	while (esize > 0) {
+		len += snprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len,
+				"%08x ", *pentry);
+		pentry++;
+		offset += sizeof(uint32_t);
+		esize -= sizeof(uint32_t);
+		if (esize > 0 && !(offset % (4 * sizeof(uint32_t))))
+			len += snprintf(pbuffer+len,
+					LPFC_QUE_ACC_BUF_SIZE-len, "\n");
+	}
+	len += snprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len, "\n");
+
+	return len;
+}
+
+/**
+ * lpfc_idiag_queacc_read - idiag debugfs read port queue
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the @phba device queue memory according to the
+ * idiag command, and copies to user @buf. Depending on the queue dump read
+ * command setup, it does either a single queue entry read or browing through
+ * all entries of the queue.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_queacc_read(struct file *file, char __user *buf, size_t nbytes,
+		       loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	uint32_t last_index, index, count;
+	struct lpfc_queue *pque = NULL;
+	char *pbuffer;
+	int len = 0;
+
+	/* This is a user read operation */
+	debug->op = LPFC_IDIAG_OP_RD;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_QUE_ACC_BUF_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+
+	if (*ppos)
+		return 0;
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_RD) {
+		index = idiag.cmd.data[2];
+		count = idiag.cmd.data[3];
+		pque = (struct lpfc_queue *)idiag.ptr_private;
+	} else
+		return 0;
+
+	/* Browse the queue starting from index */
+	if (count == LPFC_QUE_ACC_BROWSE)
+		goto que_browse;
+
+	/* Read a single entry from the queue */
+	len = lpfc_idiag_queacc_read_qe(pbuffer, len, pque, index);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+
+que_browse:
+
+	/* Browse all entries from the queue */
+	last_index = idiag.offset.last_rd;
+	index = last_index;
+
+	while (len < LPFC_QUE_ACC_SIZE - pque->entry_size) {
+		len = lpfc_idiag_queacc_read_qe(pbuffer, len, pque, index);
+		index++;
+		if (index > pque->entry_count - 1)
+			break;
+	}
+
+	/* Set up the offset for next portion of pci cfg read */
+	if (index > pque->entry_count - 1)
+		index = 0;
+	idiag.offset.last_rd = index;
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
+/**
+ * lpfc_idiag_queacc_write - Syntax check and set up idiag queacc commands
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the user data from.
+ * @nbytes: The number of bytes to get.
+ * @ppos: The position in the file to start reading from.
+ *
+ * This routine get the debugfs idiag command struct from user space and then
+ * perform the syntax check for port queue read (dump) or write (set) command
+ * accordingly. In the case of port queue read command, it sets up the command
+ * in the idiag command struct for the following debugfs read operation. In
+ * the case of port queue write operation, it executes the write operation
+ * into the port queue entry accordingly.
+ *
+ * It returns the @nbytges passing in from debugfs user space when successful.
+ * In case of error conditions, it returns proper error code back to the user
+ * space.
+ **/
+static ssize_t
+lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
+			size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	uint32_t qidx, quetp, queid, index, count, offset, value;
+	uint32_t *pentry;
+	struct lpfc_queue *pque;
+	int rc;
+
+	/* This is a user write operation */
+	debug->op = LPFC_IDIAG_OP_WR;
+
+	rc = lpfc_idiag_cmd_get(buf, nbytes, &idiag.cmd);
+	if (rc < 0)
+		return rc;
+
+	/* Get and sanity check on command feilds */
+	quetp  = idiag.cmd.data[0];
+	queid  = idiag.cmd.data[1];
+	index  = idiag.cmd.data[2];
+	count  = idiag.cmd.data[3];
+	offset = idiag.cmd.data[4];
+	value  = idiag.cmd.data[5];
+
+	/* Sanity check on command line arguments */
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_WR ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_ST ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_CL) {
+		if (rc != LPFC_QUE_ACC_WR_CMD_ARG)
+			goto error_out;
+		if (count != 1)
+			goto error_out;
+	} else if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_RD) {
+		if (rc != LPFC_QUE_ACC_RD_CMD_ARG)
+			goto error_out;
+	} else
+		goto error_out;
+
+	switch (quetp) {
+	case LPFC_IDIAG_EQ:
+		/* Slow-path event queue */
+		if (phba->sli4_hba.sp_eq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.sp_eq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.sp_eq;
+			goto pass_check;
+		}
+		/* Fast-path event queue */
+		for (qidx = 0; qidx < phba->cfg_fcp_eq_count; qidx++) {
+			if (phba->sli4_hba.fp_eq[qidx]->queue_id == queid) {
+				/* Sanity check */
+				rc = lpfc_idiag_que_param_check(
+						phba->sli4_hba.fp_eq[qidx],
+						index, count);
+				if (rc)
+					goto error_out;
+				idiag.ptr_private = phba->sli4_hba.fp_eq[qidx];
+				goto pass_check;
+			}
+		}
+		goto error_out;
+		break;
+	case LPFC_IDIAG_CQ:
+		/* MBX complete queue */
+		if (phba->sli4_hba.mbx_cq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.mbx_cq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.mbx_cq;
+			goto pass_check;
+		}
+		/* ELS complete queue */
+		if (phba->sli4_hba.els_cq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.els_cq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.els_cq;
+			goto pass_check;
+		}
+		/* FCP complete queue */
+		for (qidx = 0; qidx < phba->cfg_fcp_eq_count; qidx++) {
+			if (phba->sli4_hba.fcp_cq[qidx]->queue_id == queid) {
+				/* Sanity check */
+				rc = lpfc_idiag_que_param_check(
+						phba->sli4_hba.fcp_cq[qidx],
+						index, count);
+				if (rc)
+					goto error_out;
+				idiag.ptr_private =
+						phba->sli4_hba.fcp_cq[qidx];
+				goto pass_check;
+			}
+		}
+		goto error_out;
+		break;
+	case LPFC_IDIAG_MQ:
+		/* MBX work queue */
+		if (phba->sli4_hba.mbx_wq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.mbx_wq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.mbx_wq;
+			goto pass_check;
+		}
+		break;
+	case LPFC_IDIAG_WQ:
+		/* ELS work queue */
+		if (phba->sli4_hba.els_wq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.els_wq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.els_wq;
+			goto pass_check;
+		}
+		/* FCP work queue */
+		for (qidx = 0; qidx < phba->cfg_fcp_wq_count; qidx++) {
+			if (phba->sli4_hba.fcp_wq[qidx]->queue_id == queid) {
+				/* Sanity check */
+				rc = lpfc_idiag_que_param_check(
+						phba->sli4_hba.fcp_wq[qidx],
+						index, count);
+				if (rc)
+					goto error_out;
+				idiag.ptr_private =
+					phba->sli4_hba.fcp_wq[qidx];
+				goto pass_check;
+			}
+		}
+		goto error_out;
+		break;
+	case LPFC_IDIAG_RQ:
+		/* HDR queue */
+		if (phba->sli4_hba.hdr_rq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.hdr_rq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.hdr_rq;
+			goto pass_check;
+		}
+		/* DAT queue */
+		if (phba->sli4_hba.dat_rq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.dat_rq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.dat_rq;
+			goto pass_check;
+		}
+		goto error_out;
+		break;
+	default:
+		goto error_out;
+		break;
+	}
+
+pass_check:
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_RD) {
+		if (count == LPFC_QUE_ACC_BROWSE)
+			idiag.offset.last_rd = index;
+	}
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_WR ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_ST ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_CL) {
+		/* Additional sanity checks on write operation */
+		pque = (struct lpfc_queue *)idiag.ptr_private;
+		if (offset > pque->entry_size/sizeof(uint32_t) - 1)
+			goto error_out;
+		pentry = pque->qe[index].address;
+		pentry += offset;
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_WR)
+			*pentry = value;
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_ST)
+			*pentry |= value;
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_CL)
+			*pentry &= ~value;
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
+ * lpfc_idiag_drbacc_read_reg - idiag debugfs read a doorbell register
+ * @phba: The pointer to hba structure.
+ * @pbuffer: The pointer to the buffer to copy the data to.
+ * @len: The lenght of bytes to copied.
+ * @drbregid: The id to doorbell registers.
+ *
+ * Description:
+ * This routine reads a doorbell register and copies its content to the
+ * user buffer pointed to by @pbuffer.
+ *
+ * Returns:
+ * This function returns the amount of data that was copied into @pbuffer.
+ **/
+static int
+lpfc_idiag_drbacc_read_reg(struct lpfc_hba *phba, char *pbuffer,
+			   int len, uint32_t drbregid)
+{
+
+	if (!pbuffer)
+		return 0;
+
+	switch (drbregid) {
+	case LPFC_DRB_EQCQ:
+		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+				"EQCQ-DRB-REG: 0x%08x\n",
+				readl(phba->sli4_hba.EQCQDBregaddr));
+		break;
+	case LPFC_DRB_MQ:
+		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+				"MQ-DRB-REG:   0x%08x\n",
+				readl(phba->sli4_hba.MQDBregaddr));
+		break;
+	case LPFC_DRB_WQ:
+		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+				"WQ-DRB-REG:   0x%08x\n",
+				readl(phba->sli4_hba.WQDBregaddr));
+		break;
+	case LPFC_DRB_RQ:
+		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+				"RQ-DRB-REG:   0x%08x\n",
+				readl(phba->sli4_hba.RQDBregaddr));
+		break;
+	default:
+		break;
+	}
+
+	return len;
+}
+
+/**
+ * lpfc_idiag_drbacc_read - idiag debugfs read port doorbell
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the @phba device doorbell register according
+ * to the idiag command, and copies to user @buf. Depending on the doorbell
+ * register read command setup, it does either a single doorbell register
+ * read or dump all doorbell registers.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_drbacc_read(struct file *file, char __user *buf, size_t nbytes,
+		       loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	uint32_t drb_reg_id, i;
+	char *pbuffer;
+	int len = 0;
+
+	/* This is a user read operation */
+	debug->op = LPFC_IDIAG_OP_RD;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_DRB_ACC_BUF_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+
+	if (*ppos)
+		return 0;
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_RD)
+		drb_reg_id = idiag.cmd.data[0];
+	else
+		return 0;
+
+	if (drb_reg_id == LPFC_DRB_ACC_ALL)
+		for (i = 1; i <= LPFC_DRB_MAX; i++)
+			len = lpfc_idiag_drbacc_read_reg(phba,
+							 pbuffer, len, i);
+	else
+		len = lpfc_idiag_drbacc_read_reg(phba,
+						 pbuffer, len, drb_reg_id);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
+/**
+ * lpfc_idiag_drbacc_write - Syntax check and set up idiag drbacc commands
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the user data from.
+ * @nbytes: The number of bytes to get.
+ * @ppos: The position in the file to start reading from.
+ *
+ * This routine get the debugfs idiag command struct from user space and then
+ * perform the syntax check for port doorbell register read (dump) or write
+ * (set) command accordingly. In the case of port queue read command, it sets
+ * up the command in the idiag command struct for the following debugfs read
+ * operation. In the case of port doorbell register write operation, it
+ * executes the write operation into the port doorbell register accordingly.
+ *
+ * It returns the @nbytges passing in from debugfs user space when successful.
+ * In case of error conditions, it returns proper error code back to the user
+ * space.
+ **/
+static ssize_t
+lpfc_idiag_drbacc_write(struct file *file, const char __user *buf,
+			size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	uint32_t drb_reg_id, value, reg_val;
+	void __iomem *drb_reg;
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
+	drb_reg_id = idiag.cmd.data[0];
+	value = idiag.cmd.data[1];
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_WR ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_ST ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_CL) {
+		if (rc != LPFC_DRB_ACC_WR_CMD_ARG)
+			goto error_out;
+		if (drb_reg_id > LPFC_DRB_MAX)
+			goto error_out;
+	} else if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_RD) {
+		if (rc != LPFC_DRB_ACC_RD_CMD_ARG)
+			goto error_out;
+		if ((drb_reg_id > LPFC_DRB_MAX) &&
+		    (drb_reg_id != LPFC_DRB_ACC_ALL))
+			goto error_out;
+	} else
+		goto error_out;
+
+	/* Perform the write access operation */
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_WR ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_ST ||
+	    idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_CL) {
+		switch (drb_reg_id) {
+		case LPFC_DRB_EQCQ:
+			drb_reg = phba->sli4_hba.EQCQDBregaddr;
+			break;
+		case LPFC_DRB_MQ:
+			drb_reg = phba->sli4_hba.MQDBregaddr;
+			break;
+		case LPFC_DRB_WQ:
+			drb_reg = phba->sli4_hba.WQDBregaddr;
+			break;
+		case LPFC_DRB_RQ:
+			drb_reg = phba->sli4_hba.RQDBregaddr;
+			break;
+		default:
+			goto error_out;
+		}
+
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_WR)
+			reg_val = value;
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_ST) {
+			reg_val = readl(drb_reg);
+			reg_val |= value;
+		}
+		if (idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_CL) {
+			reg_val = readl(drb_reg);
+			reg_val &= ~value;
+		}
+		writel(reg_val, drb_reg);
+		readl(drb_reg); /* flush */
+	}
+	return nbytes;
+
+error_out:
+	/* Clean out command structure on command error out */
+	memset(&idiag, 0, sizeof(idiag));
+	return -EINVAL;
+}
+
 #undef lpfc_debugfs_op_disc_trc
 static const struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
@@ -1986,6 +2425,26 @@ static const struct file_operations lpfc
 	.release =      lpfc_idiag_release,
 };
 
+#undef lpfc_idiag_op_queacc
+static const struct file_operations lpfc_idiag_op_queAcc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_idiag_queacc_read,
+	.write =        lpfc_idiag_queacc_write,
+	.release =      lpfc_idiag_cmd_release,
+};
+
+#undef lpfc_idiag_op_drbacc
+static const struct file_operations lpfc_idiag_op_drbAcc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_idiag_drbacc_read,
+	.write =        lpfc_idiag_drbacc_write,
+	.release =      lpfc_idiag_cmd_release,
+};
+
 #endif
 
 /**
@@ -2261,6 +2720,32 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		}
 	}
 
+	/* iDiag access PCI function queue */
+	snprintf(name, sizeof(name), "queAcc");
+	if (!phba->idiag_que_acc) {
+		phba->idiag_que_acc =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				phba->idiag_root, phba, &lpfc_idiag_op_queAcc);
+		if (!phba->idiag_que_acc) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "2926 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+	}
+
+	/* iDiag access PCI function doorbell registers */
+	snprintf(name, sizeof(name), "drbAcc");
+	if (!phba->idiag_drb_acc) {
+		phba->idiag_drb_acc =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				phba->idiag_root, phba, &lpfc_idiag_op_drbAcc);
+		if (!phba->idiag_drb_acc) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "2927 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+	}
+
 debug_failed:
 	return;
 #endif
@@ -2339,6 +2824,16 @@ lpfc_debugfs_terminate(struct lpfc_vport
 		 * iDiag release
 		 */
 		if (phba->sli_rev == LPFC_SLI_REV4) {
+			if (phba->idiag_drb_acc) {
+				/* iDiag drbAcc */
+				debugfs_remove(phba->idiag_drb_acc);
+				phba->idiag_drb_acc = NULL;
+			}
+			if (phba->idiag_que_acc) {
+				/* iDiag queAcc */
+				debugfs_remove(phba->idiag_que_acc);
+				phba->idiag_que_acc = NULL;
+			}
 			if (phba->idiag_que_info) {
 				/* iDiag queInfo */
 				debugfs_remove(phba->idiag_que_info);
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2011-04-16 09:34:09.000000000 -0400
@@ -39,13 +39,42 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
-/* rdPciConf output buffer size */
+/* pciConf */
+#define LPFC_PCI_CFG_BROWSE 0xffff
+#define LPFC_PCI_CFG_RD_CMD_ARG 2
+#define LPFC_PCI_CFG_WR_CMD_ARG 3
 #define LPFC_PCI_CFG_SIZE 4096
 #define LPFC_PCI_CFG_RD_BUF_SIZE (LPFC_PCI_CFG_SIZE/2)
 #define LPFC_PCI_CFG_RD_SIZE (LPFC_PCI_CFG_SIZE/4)
 
-/* queue info output buffer size */
-#define LPFC_QUE_INFO_GET_BUF_SIZE 2048
+/* queue info */
+#define LPFC_QUE_INFO_GET_BUF_SIZE 4096
+
+/* queue acc */
+#define LPFC_QUE_ACC_BROWSE 0xffff
+#define LPFC_QUE_ACC_RD_CMD_ARG 4
+#define LPFC_QUE_ACC_WR_CMD_ARG 6
+#define LPFC_QUE_ACC_BUF_SIZE 4096
+#define LPFC_QUE_ACC_SIZE (LPFC_QUE_ACC_BUF_SIZE/2)
+
+#define LPFC_IDIAG_EQ 1
+#define LPFC_IDIAG_CQ 2
+#define LPFC_IDIAG_MQ 3
+#define LPFC_IDIAG_WQ 4
+#define LPFC_IDIAG_RQ 5
+
+/* doorbell acc */
+#define LPFC_DRB_ACC_ALL 0xffff
+#define LPFC_DRB_ACC_RD_CMD_ARG 1
+#define LPFC_DRB_ACC_WR_CMD_ARG 2
+#define LPFC_DRB_ACC_BUF_SIZE 256
+
+#define LPFC_DRB_EQCQ 1
+#define LPFC_DRB_MQ   2
+#define LPFC_DRB_WQ   3
+#define LPFC_DRB_RQ   4
+
+#define LPFC_DRB_MAX  4
 
 #define SIZE_U8  sizeof(uint8_t)
 #define SIZE_U16 sizeof(uint16_t)
@@ -73,13 +102,23 @@ struct lpfc_idiag_offset {
 	uint32_t last_rd;
 };
 
-#define LPFC_IDIAG_CMD_DATA_SIZE 4
+#define LPFC_IDIAG_CMD_DATA_SIZE 8
 struct lpfc_idiag_cmd {
 	uint32_t opcode;
 #define LPFC_IDIAG_CMD_PCICFG_RD 0x00000001
 #define LPFC_IDIAG_CMD_PCICFG_WR 0x00000002
 #define LPFC_IDIAG_CMD_PCICFG_ST 0x00000003
 #define LPFC_IDIAG_CMD_PCICFG_CL 0x00000004
+
+#define LPFC_IDIAG_CMD_QUEACC_RD 0x00000011
+#define LPFC_IDIAG_CMD_QUEACC_WR 0x00000012
+#define LPFC_IDIAG_CMD_QUEACC_ST 0x00000013
+#define LPFC_IDIAG_CMD_QUEACC_CL 0x00000014
+
+#define LPFC_IDIAG_CMD_DRBACC_RD 0x00000021
+#define LPFC_IDIAG_CMD_DRBACC_WR 0x00000022
+#define LPFC_IDIAG_CMD_DRBACC_ST 0x00000023
+#define LPFC_IDIAG_CMD_DRBACC_CL 0x00000024
 	uint32_t data[LPFC_IDIAG_CMD_DATA_SIZE];
 };
 
@@ -87,6 +126,7 @@ struct lpfc_idiag {
 	uint32_t active;
 	struct lpfc_idiag_cmd cmd;
 	struct lpfc_idiag_offset offset;
+	void *ptr_private;
 };
 #endif
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-03-27 11:03:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2011-04-16 09:34:09.000000000 -0400
@@ -805,6 +805,8 @@ struct lpfc_hba {
 	struct dentry *idiag_root;
 	struct dentry *idiag_pci_cfg;
 	struct dentry *idiag_que_info;
+	struct dentry *idiag_que_acc;
+	struct dentry *idiag_drb_acc;
 #endif
 
 	/* Used for deferred freeing of ELS data buffers */


