From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6] lpfc 8.3.21: Debugfs additions
Date: Wed, 16 Feb 2011 12:40:06 -0500
Message-ID: <1297878006.1492.28.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:7549 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753821Ab1BPRkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 12:40:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add the driver debugfs framework for supporting debugfs read and write
  operations, and iDiag command structure.
- Add read and write to SLI4 device PCI config space registers.
- Add the driver support of debugfs PCI config space register bits set/clear
  methods to the provided bitmask.
- Add iDiag driver support for SLI4 device queue diagnostic.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    6 
 lpfc_debugfs.c |  954 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 lpfc_debugfs.h |   60 +++
 lpfc_sli.c     |    5 
 lpfc_sli4.h    |    2 
 5 files changed, 972 insertions(+), 55 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2011-02-16 11:33:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-02-16 11:35:27.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2007-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -57,8 +57,8 @@
  * # mount -t debugfs none /sys/kernel/debug
  *
  * The lpfc debugfs directory hierarchy is:
- * lpfc/lpfcX/vportY
- * where X is the lpfc hba unique_id
+ * /sys/kernel/debug/lpfc/fnX/vportY
+ * where X is the lpfc hba function unique_id
  * where Y is the vport VPI on that hba
  *
  * Debugging services available per vport:
@@ -104,30 +104,12 @@ MODULE_PARM_DESC(lpfc_debugfs_mask_disc_
 
 #include <linux/debugfs.h>
 
-/* size of output line, for discovery_trace and slow_ring_trace */
-#define LPFC_DEBUG_TRC_ENTRY_SIZE 100
-
-/* nodelist output buffer size */
-#define LPFC_NODELIST_SIZE 8192
-#define LPFC_NODELIST_ENTRY_SIZE 120
-
-/* dumpHBASlim output buffer size */
-#define LPFC_DUMPHBASLIM_SIZE 4096
-
-/* dumpHostSlim output buffer size */
-#define LPFC_DUMPHOSTSLIM_SIZE 4096
-
-/* hbqinfo output buffer size */
-#define LPFC_HBQINFO_SIZE 8192
-
-struct lpfc_debug {
-	char *buffer;
-	int  len;
-};
-
 static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 static unsigned long lpfc_debugfs_start_time = 0L;
 
+/* iDiag */
+static struct lpfc_idiag idiag;
+
 /**
  * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer
  * @vport: The vport to gather the log info from.
@@ -996,8 +978,6 @@ lpfc_debugfs_dumpDataDif_write(struct fi
 	return nbytes;
 }
 
-
-
 /**
  * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file
  * @inode: The inode pointer that contains a vport pointer.
@@ -1099,6 +1079,7 @@ lpfc_debugfs_read(struct file *file, cha
 		  size_t nbytes, loff_t *ppos)
 {
 	struct lpfc_debug *debug = file->private_data;
+
 	return simple_read_from_buffer(buf, nbytes, ppos, debug->buffer,
 				       debug->len);
 }
@@ -1137,6 +1118,776 @@ lpfc_debugfs_dumpDataDif_release(struct 
 	return 0;
 }
 
+/*
+ * iDiag debugfs file access methods
+ */
+
+/*
+ * iDiag PCI config space register access methods:
+ *
+ * The PCI config space register accessees of read, write, read-modify-write
+ * for set bits, and read-modify-write for clear bits to SLI4 PCI functions
+ * are provided. In the proper SLI4 PCI function's debugfs iDiag directory,
+ *
+ *      /sys/kernel/debug/lpfc/fn<#>/iDiag
+ *
+ * the access is through the debugfs entry pciCfg:
+ *
+ * 1. For PCI config space register read access, there are two read methods:
+ *    A) read a single PCI config space register in the size of a byte
+ *    (8 bits), a word (16 bits), or a dword (32 bits); or B) browse through
+ *    the 4K extended PCI config space.
+ *
+ *    A) Read a single PCI config space register consists of two steps:
+ *
+ *    Step-1: Set up PCI config space register read command, the command
+ *    syntax is,
+ *
+ *        echo 1 <where> <count> > pciCfg
+ *
+ *    where, 1 is the iDiag command for PCI config space read, <where> is the
+ *    offset from the beginning of the device's PCI config space to read from,
+ *    and <count> is the size of PCI config space register data to read back,
+ *    it will be 1 for reading a byte (8 bits), 2 for reading a word (16 bits
+ *    or 2 bytes), or 4 for reading a dword (32 bits or 4 bytes).
+ *
+ *    Setp-2: Perform the debugfs read operation to execute the idiag command
+ *    set up in Step-1,
+ *
+ *        cat pciCfg
+ *
+ *    Examples:
+ *    To read PCI device's vendor-id and device-id from PCI config space,
+ *
+ *        echo 1 0 4 > pciCfg
+ *        cat pciCfg
+ *
+ *    To read PCI device's currnt command from config space,
+ *
+ *        echo 1 4 2 > pciCfg
+ *        cat pciCfg
+ *
+ *    B) Browse through the entire 4K extended PCI config space also consists
+ *    of two steps:
+ *
+ *    Step-1: Set up PCI config space register browsing command, the command
+ *    syntax is,
+ *
+ *        echo 1 0 4096 > pciCfg
+ *
+ *    where, 1 is the iDiag command for PCI config space read, 0 must be used
+ *    as the offset for PCI config space register browse, and 4096 must be
+ *    used as the count for PCI config space register browse.
+ *
+ *    Step-2: Repeately issue the debugfs read operation to browse through
+ *    the entire PCI config space registers:
+ *
+ *        cat pciCfg
+ *        cat pciCfg
+ *        cat pciCfg
+ *        ...
+ *
+ *    When browsing to the end of the 4K PCI config space, the browse method
+ *    shall wrap around to start reading from beginning again, and again...
+ *
+ * 2. For PCI config space register write access, it supports a single PCI
+ *    config space register write in the size of a byte (8 bits), a word
+ *    (16 bits), or a dword (32 bits). The command syntax is,
+ *
+ *        echo 2 <where> <count> <value> > pciCfg
+ *
+ *    where, 2 is the iDiag command for PCI config space write, <where> is
+ *    the offset from the beginning of the device's PCI config space to write
+ *    into, <count> is the size of data to write into the PCI config space,
+ *    it will be 1 for writing a byte (8 bits), 2 for writing a word (16 bits
+ *    or 2 bytes), or 4 for writing a dword (32 bits or 4 bytes), and <value>
+ *    is the data to be written into the PCI config space register at the
+ *    offset.
+ *
+ *    Examples:
+ *    To disable PCI device's interrupt assertion,
+ *
+ *    1) Read in device's PCI config space register command field <cmd>:
+ *
+ *           echo 1 4 2 > pciCfg
+ *           cat pciCfg
+ *
+ *    2) Set bit 10 (Interrupt Disable bit) in the <cmd>:
+ *
+ *           <cmd> = <cmd> | (1 < 10)
+ *
+ *    3) Write the modified command back:
+ *
+ *           echo 2 4 2 <cmd> > pciCfg
+ *
+ * 3. For PCI config space register set bits access, it supports a single PCI
+ *    config space register set bits in the size of a byte (8 bits), a word
+ *    (16 bits), or a dword (32 bits). The command syntax is,
+ *
+ *        echo 3 <where> <count> <bitmask> > pciCfg
+ *
+ *    where, 3 is the iDiag command for PCI config space set bits, <where> is
+ *    the offset from the beginning of the device's PCI config space to set
+ *    bits into, <count> is the size of the bitmask to set into the PCI config
+ *    space, it will be 1 for setting a byte (8 bits), 2 for setting a word
+ *    (16 bits or 2 bytes), or 4 for setting a dword (32 bits or 4 bytes), and
+ *    <bitmask> is the bitmask, indicating the bits to be set into the PCI
+ *    config space register at the offset. The logic performed to the content
+ *    of the PCI config space register, regval, is,
+ *
+ *        regval |= <bitmask>
+ *
+ * 4. For PCI config space register clear bits access, it supports a single
+ *    PCI config space register clear bits in the size of a byte (8 bits),
+ *    a word (16 bits), or a dword (32 bits). The command syntax is,
+ *
+ *        echo 4 <where> <count> <bitmask> > pciCfg
+ *
+ *    where, 4 is the iDiag command for PCI config space clear bits, <where>
+ *    is the offset from the beginning of the device's PCI config space to
+ *    clear bits from, <count> is the size of the bitmask to set into the PCI
+ *    config space, it will be 1 for setting a byte (8 bits), 2 for setting
+ *    a word(16 bits or 2 bytes), or 4 for setting a dword (32 bits or 4
+ *    bytes), and <bitmask> is the bitmask, indicating the bits to be cleared
+ *    from the PCI config space register at the offset. the logic performed
+ *    to the content of the PCI config space register, regval, is,
+ *
+ *        regval &= ~<bitmask>
+ *
+ * Note, for all single register read, write, set bits, or clear bits access,
+ * the offset (<where>) must be aligned with the size of the data:
+ *
+ * For data size of byte (8 bits), the offset must be aligned to the byte
+ * boundary; for data size of word (16 bits), the offset must be aligned
+ * to the word boundary; while for data size of dword (32 bits), the offset
+ * must be aligned to the dword boundary. Otherwise, the interface will
+ * return the error:
+ *
+ *     "-bash: echo: write error: Invalid argument".
+ *
+ * For example:
+ *
+ *     echo 1 2 4 > pciCfg
+ *     -bash: echo: write error: Invalid argument
+ *
+ * Note also, all of the numbers in the command fields for all read, write,
+ * set bits, and clear bits PCI config space register command fields can be
+ * either decimal or hex.
+ *
+ * For example,
+ *     echo 1 0 4096 > pciCfg
+ *
+ * will be the same as
+ *     echo 1 0 0x1000 > pciCfg
+ *
+ * And,
+ *     echo 2 155 1 10 > pciCfg
+ *
+ * will be
+ *     echo 2 0x9b 1 0xa > pciCfg
+ */
+
+/**
+ * lpfc_idiag_cmd_get - Get and parse idiag debugfs comands from user space
+ * @buf: The pointer to the user space buffer.
+ * @nbytes: The number of bytes in the user space buffer.
+ * @idiag_cmd: pointer to the idiag command struct.
+ *
+ * This routine reads data from debugfs user space buffer and parses the
+ * buffer for getting the idiag command and arguments. The while space in
+ * between the set of data is used as the parsing separator.
+ *
+ * This routine returns 0 when successful, it returns proper error code
+ * back to the user space in error conditions.
+ */
+static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
+			      struct lpfc_idiag_cmd *idiag_cmd)
+{
+	char mybuf[64];
+	char *pbuf, *step_str;
+	int bsize, i;
+
+	/* Protect copy from user */
+	if (!access_ok(VERIFY_READ, buf, nbytes))
+		return -EFAULT;
+
+	memset(mybuf, 0, sizeof(mybuf));
+	memset(idiag_cmd, 0, sizeof(*idiag_cmd));
+	bsize = min(nbytes, (sizeof(mybuf)-1));
+
+	if (copy_from_user(mybuf, buf, bsize))
+		return -EFAULT;
+	pbuf = &mybuf[0];
+	step_str = strsep(&pbuf, "\t ");
+
+	/* The opcode must present */
+	if (!step_str)
+		return -EINVAL;
+
+	idiag_cmd->opcode = simple_strtol(step_str, NULL, 0);
+	if (idiag_cmd->opcode == 0)
+		return -EINVAL;
+
+	for (i = 0; i < LPFC_IDIAG_CMD_DATA_SIZE; i++) {
+		step_str = strsep(&pbuf, "\t ");
+		if (!step_str)
+			return 0;
+		idiag_cmd->data[i] = simple_strtol(step_str, NULL, 0);
+	}
+	return 0;
+}
+
+/**
+ * lpfc_idiag_open - idiag open debugfs
+ * @inode: The inode pointer that contains a pointer to phba.
+ * @file: The file pointer to attach the file operation.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It
+ * gets the reference to phba from the i_private field in @inode, it then
+ * allocates buffer for the file operation, performs the necessary PCI config
+ * space read into the allocated buffer according to the idiag user command
+ * setup, and then returns a pointer to buffer in the private_data field in
+ * @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an
+ * negative error value.
+ **/
+static int
+lpfc_idiag_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		return -ENOMEM;
+
+	debug->i_private = inode->i_private;
+	debug->buffer = NULL;
+	file->private_data = debug;
+
+	return 0;
+}
+
+/**
+ * lpfc_idiag_release - Release idiag access file operation
+ * @inode: The inode pointer that contains a vport pointer. (unused)
+ * @file: The file pointer that contains the buffer to release.
+ *
+ * Description:
+ * This routine is the generic release routine for the idiag access file
+ * operation, it frees the buffer that was allocated when the debugfs file
+ * was opened.
+ *
+ * Returns:
+ * This function returns zero.
+ **/
+static int
+lpfc_idiag_release(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug = file->private_data;
+
+	/* Free the buffers to the file operation */
+	kfree(debug->buffer);
+	kfree(debug);
+
+	return 0;
+}
+
+/**
+ * lpfc_idiag_cmd_release - Release idiag cmd access file operation
+ * @inode: The inode pointer that contains a vport pointer. (unused)
+ * @file: The file pointer that contains the buffer to release.
+ *
+ * Description:
+ * This routine frees the buffer that was allocated when the debugfs file
+ * was opened. It also reset the fields in the idiag command struct in the
+ * case the command is not continuous browsing of the data structure.
+ *
+ * Returns:
+ * This function returns zero.
+ **/
+static int
+lpfc_idiag_cmd_release(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug = file->private_data;
+
+	/* Read PCI config register, if not read all, clear command fields */
+	if ((debug->op == LPFC_IDIAG_OP_RD) &&
+	    (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_RD))
+		if ((idiag.cmd.data[1] == sizeof(uint8_t)) ||
+		    (idiag.cmd.data[1] == sizeof(uint16_t)) ||
+		    (idiag.cmd.data[1] == sizeof(uint32_t)))
+			memset(&idiag, 0, sizeof(idiag));
+
+	/* Write PCI config register, clear command fields */
+	if ((debug->op == LPFC_IDIAG_OP_WR) &&
+	    (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR))
+		memset(&idiag, 0, sizeof(idiag));
+
+	/* Free the buffers to the file operation */
+	kfree(debug->buffer);
+	kfree(debug);
+
+	return 0;
+}
+
+/**
+ * lpfc_idiag_pcicfg_read - idiag debugfs read pcicfg
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the @phba pci config space according to the
+ * idiag command, and copies to user @buf. Depending on the PCI config space
+ * read command setup, it does either a single register read of a byte
+ * (8 bits), a word (16 bits), or a dword (32 bits) or browsing through all
+ * registers from the 4K extended PCI config space.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_pcicfg_read(struct file *file, char __user *buf, size_t nbytes,
+		       loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	int offset_label, offset, len = 0, index = LPFC_PCI_CFG_RD_SIZE;
+	int where, count;
+	char *pbuffer;
+	struct pci_dev *pdev;
+	uint32_t u32val;
+	uint16_t u16val;
+	uint8_t u8val;
+
+	pdev = phba->pcidev;
+	if (!pdev)
+		return 0;
+
+	/* This is a user read operation */
+	debug->op = LPFC_IDIAG_OP_RD;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_PCI_CFG_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+
+	if (*ppos)
+		return 0;
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_RD) {
+		where = idiag.cmd.data[0];
+		count = idiag.cmd.data[1];
+	} else
+		return 0;
+
+	/* Read single PCI config space register */
+	switch (count) {
+	case SIZE_U8: /* byte (8 bits) */
+		pci_read_config_byte(pdev, where, &u8val);
+		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+				"%03x: %02x\n", where, u8val);
+		break;
+	case SIZE_U16: /* word (16 bits) */
+		pci_read_config_word(pdev, where, &u16val);
+		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+				"%03x: %04x\n", where, u16val);
+		break;
+	case SIZE_U32: /* double word (32 bits) */
+		pci_read_config_dword(pdev, where, &u32val);
+		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+				"%03x: %08x\n", where, u32val);
+		break;
+	case LPFC_PCI_CFG_SIZE: /* browse all */
+		goto pcicfg_browse;
+		break;
+	default:
+		/* illegal count */
+		len = 0;
+		break;
+	}
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+
+pcicfg_browse:
+
+	/* Browse all PCI config space registers */
+	offset_label = idiag.offset.last_rd;
+	offset = offset_label;
+
+	/* Read PCI config space */
+	len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+			"%03x: ", offset_label);
+	while (index > 0) {
+		pci_read_config_dword(pdev, offset, &u32val);
+		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+				"%08x ", u32val);
+		offset += sizeof(uint32_t);
+		index -= sizeof(uint32_t);
+		if (!index)
+			len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+					"\n");
+		else if (!(index % (8 * sizeof(uint32_t)))) {
+			offset_label += (8 * sizeof(uint32_t));
+			len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+					"\n%03x: ", offset_label);
+		}
+	}
+
+	/* Set up the offset for next portion of pci cfg read */
+	idiag.offset.last_rd += LPFC_PCI_CFG_RD_SIZE;
+	if (idiag.offset.last_rd >= LPFC_PCI_CFG_SIZE)
+		idiag.offset.last_rd = 0;
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
+/**
+ * lpfc_idiag_pcicfg_write - Syntax check and set up idiag pcicfg commands
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the user data from.
+ * @nbytes: The number of bytes to get.
+ * @ppos: The position in the file to start reading from.
+ *
+ * This routine get the debugfs idiag command struct from user space and
+ * then perform the syntax check for PCI config space read or write command
+ * accordingly. In the case of PCI config space read command, it sets up
+ * the command in the idiag command struct for the debugfs read operation.
+ * In the case of PCI config space write operation, it executes the write
+ * operation into the PCI config space accordingly.
+ *
+ * It returns the @nbytges passing in from debugfs user space when successful.
+ * In case of error conditions, it returns proper error code back to the user
+ * space.
+ */
+static ssize_t
+lpfc_idiag_pcicfg_write(struct file *file, const char __user *buf,
+			size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	uint32_t where, value, count;
+	uint32_t u32val;
+	uint16_t u16val;
+	uint8_t u8val;
+	struct pci_dev *pdev;
+	int rc;
+
+	pdev = phba->pcidev;
+	if (!pdev)
+		return -EFAULT;
+
+	/* This is a user write operation */
+	debug->op = LPFC_IDIAG_OP_WR;
+
+	rc = lpfc_idiag_cmd_get(buf, nbytes, &idiag.cmd);
+	if (rc)
+		return rc;
+
+	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_RD) {
+		/* Read command from PCI config space, set up command fields */
+		where = idiag.cmd.data[0];
+		count = idiag.cmd.data[1];
+		if (count == LPFC_PCI_CFG_SIZE) {
+			if (where != 0)
+				goto error_out;
+		} else if ((count != sizeof(uint8_t)) &&
+			   (count != sizeof(uint16_t)) &&
+			   (count != sizeof(uint32_t)))
+			goto error_out;
+		if (count == sizeof(uint8_t)) {
+			if (where > LPFC_PCI_CFG_SIZE - sizeof(uint8_t))
+				goto error_out;
+			if (where % sizeof(uint8_t))
+				goto error_out;
+		}
+		if (count == sizeof(uint16_t)) {
+			if (where > LPFC_PCI_CFG_SIZE - sizeof(uint16_t))
+				goto error_out;
+			if (where % sizeof(uint16_t))
+				goto error_out;
+		}
+		if (count == sizeof(uint32_t)) {
+			if (where > LPFC_PCI_CFG_SIZE - sizeof(uint32_t))
+				goto error_out;
+			if (where % sizeof(uint32_t))
+				goto error_out;
+		}
+	} else if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR ||
+		   idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_ST ||
+		   idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_CL) {
+		/* Write command to PCI config space, read-modify-write */
+		where = idiag.cmd.data[0];
+		count = idiag.cmd.data[1];
+		value = idiag.cmd.data[2];
+		/* Sanity checks */
+		if ((count != sizeof(uint8_t)) &&
+		    (count != sizeof(uint16_t)) &&
+		    (count != sizeof(uint32_t)))
+			goto error_out;
+		if (count == sizeof(uint8_t)) {
+			if (where > LPFC_PCI_CFG_SIZE - sizeof(uint8_t))
+				goto error_out;
+			if (where % sizeof(uint8_t))
+				goto error_out;
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR)
+				pci_write_config_byte(pdev, where,
+						      (uint8_t)value);
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_ST) {
+				rc = pci_read_config_byte(pdev, where, &u8val);
+				if (!rc) {
+					u8val |= (uint8_t)value;
+					pci_write_config_byte(pdev, where,
+							      u8val);
+				}
+			}
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_CL) {
+				rc = pci_read_config_byte(pdev, where, &u8val);
+				if (!rc) {
+					u8val &= (uint8_t)(~value);
+					pci_write_config_byte(pdev, where,
+							      u8val);
+				}
+			}
+		}
+		if (count == sizeof(uint16_t)) {
+			if (where > LPFC_PCI_CFG_SIZE - sizeof(uint16_t))
+				goto error_out;
+			if (where % sizeof(uint16_t))
+				goto error_out;
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR)
+				pci_write_config_word(pdev, where,
+						      (uint16_t)value);
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_ST) {
+				rc = pci_read_config_word(pdev, where, &u16val);
+				if (!rc) {
+					u16val |= (uint16_t)value;
+					pci_write_config_word(pdev, where,
+							      u16val);
+				}
+			}
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_CL) {
+				rc = pci_read_config_word(pdev, where, &u16val);
+				if (!rc) {
+					u16val &= (uint16_t)(~value);
+					pci_write_config_word(pdev, where,
+							      u16val);
+				}
+			}
+		}
+		if (count == sizeof(uint32_t)) {
+			if (where > LPFC_PCI_CFG_SIZE - sizeof(uint32_t))
+				goto error_out;
+			if (where % sizeof(uint32_t))
+				goto error_out;
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_WR)
+				pci_write_config_dword(pdev, where, value);
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_ST) {
+				rc = pci_read_config_dword(pdev, where,
+							   &u32val);
+				if (!rc) {
+					u32val |= value;
+					pci_write_config_dword(pdev, where,
+							       u32val);
+				}
+			}
+			if (idiag.cmd.opcode == LPFC_IDIAG_CMD_PCICFG_CL) {
+				rc = pci_read_config_dword(pdev, where,
+							   &u32val);
+				if (!rc) {
+					u32val &= ~value;
+					pci_write_config_dword(pdev, where,
+							       u32val);
+				}
+			}
+		}
+	} else
+		/* All other opecodes are illegal for now */
+		goto error_out;
+
+	return nbytes;
+error_out:
+	memset(&idiag, 0, sizeof(idiag));
+	return -EINVAL;
+}
+
+/**
+ * lpfc_idiag_queinfo_read - idiag debugfs read queue information
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from the @phba SLI4 PCI function queue information,
+ * and copies to user @buf.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
+static ssize_t
+lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
+			loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	int len = 0, fcp_qidx;
+	char *pbuffer;
+
+	if (!debug->buffer)
+		debug->buffer = kmalloc(LPFC_QUE_INFO_GET_BUF_SIZE, GFP_KERNEL);
+	if (!debug->buffer)
+		return 0;
+	pbuffer = debug->buffer;
+
+	if (*ppos)
+		return 0;
+
+	/* Get slow-path event queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Slow-path EQ information:\n");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], EQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			phba->sli4_hba.sp_eq->queue_id,
+			phba->sli4_hba.sp_eq->entry_count,
+			phba->sli4_hba.sp_eq->host_index,
+			phba->sli4_hba.sp_eq->hba_index);
+
+	/* Get fast-path event queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Fast-path EQ information:\n");
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++) {
+		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\tID [%02d], EQE-COUNT [%04d], "
+				"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+				phba->sli4_hba.fp_eq[fcp_qidx]->queue_id,
+				phba->sli4_hba.fp_eq[fcp_qidx]->entry_count,
+				phba->sli4_hba.fp_eq[fcp_qidx]->host_index,
+				phba->sli4_hba.fp_eq[fcp_qidx]->hba_index);
+	}
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+
+	/* Get mailbox complete queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Mailbox CQ information:\n");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tAssociated EQ-ID [%02d]:\n",
+			phba->sli4_hba.mbx_cq->assoc_qid);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], CQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			phba->sli4_hba.mbx_cq->queue_id,
+			phba->sli4_hba.mbx_cq->entry_count,
+			phba->sli4_hba.mbx_cq->host_index,
+			phba->sli4_hba.mbx_cq->hba_index);
+
+	/* Get slow-path complete queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Slow-path CQ information:\n");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tAssociated EQ-ID [%02d]:\n",
+			phba->sli4_hba.els_cq->assoc_qid);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], CQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			phba->sli4_hba.els_cq->queue_id,
+			phba->sli4_hba.els_cq->entry_count,
+			phba->sli4_hba.els_cq->host_index,
+			phba->sli4_hba.els_cq->hba_index);
+
+	/* Get fast-path complete queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Fast-path CQ information:\n");
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++) {
+		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tAssociated EQ-ID [%02d]:\n",
+				phba->sli4_hba.fcp_cq[fcp_qidx]->assoc_qid);
+		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+		"\tID [%02d], EQE-COUNT [%04d], "
+		"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+		phba->sli4_hba.fcp_cq[fcp_qidx]->queue_id,
+		phba->sli4_hba.fcp_cq[fcp_qidx]->entry_count,
+		phba->sli4_hba.fcp_cq[fcp_qidx]->host_index,
+		phba->sli4_hba.fcp_cq[fcp_qidx]->hba_index);
+	}
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+
+	/* Get mailbox queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Mailbox MQ information:\n");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tAssociated CQ-ID [%02d]:\n",
+			phba->sli4_hba.mbx_wq->assoc_qid);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], MQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			phba->sli4_hba.mbx_wq->queue_id,
+			phba->sli4_hba.mbx_wq->entry_count,
+			phba->sli4_hba.mbx_wq->host_index,
+			phba->sli4_hba.mbx_wq->hba_index);
+
+	/* Get slow-path work queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Slow-path WQ information:\n");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tAssociated CQ-ID [%02d]:\n",
+			phba->sli4_hba.els_wq->assoc_qid);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], WQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n\n",
+			phba->sli4_hba.els_wq->queue_id,
+			phba->sli4_hba.els_wq->entry_count,
+			phba->sli4_hba.els_wq->host_index,
+			phba->sli4_hba.els_wq->hba_index);
+
+	/* Get fast-path work queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Fast-path WQ information:\n");
+	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_wq_count; fcp_qidx++) {
+		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tAssociated CQ-ID [%02d]:\n",
+				phba->sli4_hba.fcp_wq[fcp_qidx]->assoc_qid);
+		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\tID [%02d], WQE-COUNT [%04d], "
+				"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+				phba->sli4_hba.fcp_wq[fcp_qidx]->queue_id,
+				phba->sli4_hba.fcp_wq[fcp_qidx]->entry_count,
+				phba->sli4_hba.fcp_wq[fcp_qidx]->host_index,
+				phba->sli4_hba.fcp_wq[fcp_qidx]->hba_index);
+	}
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+
+	/* Get receive queue information */
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"Slow-path RQ information:\n");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tAssociated CQ-ID [%02d]:\n",
+			phba->sli4_hba.hdr_rq->assoc_qid);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], RHQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+			phba->sli4_hba.hdr_rq->queue_id,
+			phba->sli4_hba.hdr_rq->entry_count,
+			phba->sli4_hba.hdr_rq->host_index,
+			phba->sli4_hba.hdr_rq->hba_index);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tID [%02d], RDQE-COUNT [%04d], "
+			"HOST-INDEX [%04x], PORT-INDEX [%04x]\n",
+			phba->sli4_hba.dat_rq->queue_id,
+			phba->sli4_hba.dat_rq->entry_count,
+			phba->sli4_hba.dat_rq->host_index,
+			phba->sli4_hba.dat_rq->hba_index);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+}
+
 #undef lpfc_debugfs_op_disc_trc
 static const struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
@@ -1213,6 +1964,28 @@ static const struct file_operations lpfc
 
 static struct dentry *lpfc_debugfs_root = NULL;
 static atomic_t lpfc_debugfs_hba_count;
+
+/*
+ * File operations for the iDiag debugfs
+ */
+#undef lpfc_idiag_op_pciCfg
+static const struct file_operations lpfc_idiag_op_pciCfg = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_idiag_pcicfg_read,
+	.write =        lpfc_idiag_pcicfg_write,
+	.release =      lpfc_idiag_cmd_release,
+};
+
+#undef lpfc_idiag_op_queInfo
+static const struct file_operations lpfc_idiag_op_queInfo = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_idiag_open,
+	.read =         lpfc_idiag_queinfo_read,
+	.release =      lpfc_idiag_release,
+};
+
 #endif
 
 /**
@@ -1249,8 +2022,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	if (!lpfc_debugfs_start_time)
 		lpfc_debugfs_start_time = jiffies;
 
-	/* Setup lpfcX directory for specific HBA */
-	snprintf(name, sizeof(name), "lpfc%d", phba->brd_no);
+	/* Setup funcX directory for specific HBA PCI function */
+	snprintf(name, sizeof(name), "fn%d", phba->brd_no);
 	if (!phba->hba_debugfs_root) {
 		phba->hba_debugfs_root =
 			debugfs_create_dir(name, lpfc_debugfs_root);
@@ -1275,28 +2048,38 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		}
 
 		/* Setup dumpHBASlim */
-		snprintf(name, sizeof(name), "dumpHBASlim");
-		phba->debug_dumpHBASlim =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 phba->hba_debugfs_root,
-				 phba, &lpfc_debugfs_op_dumpHBASlim);
-		if (!phba->debug_dumpHBASlim) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				"0413 Cannot create debugfs dumpHBASlim\n");
-			goto debug_failed;
-		}
+		if (phba->sli_rev < LPFC_SLI_REV4) {
+			snprintf(name, sizeof(name), "dumpHBASlim");
+			phba->debug_dumpHBASlim =
+				debugfs_create_file(name,
+					S_IFREG|S_IRUGO|S_IWUSR,
+					phba->hba_debugfs_root,
+					phba, &lpfc_debugfs_op_dumpHBASlim);
+			if (!phba->debug_dumpHBASlim) {
+				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+						 "0413 Cannot create debugfs "
+						"dumpHBASlim\n");
+				goto debug_failed;
+			}
+		} else
+			phba->debug_dumpHBASlim = NULL;
 
 		/* Setup dumpHostSlim */
-		snprintf(name, sizeof(name), "dumpHostSlim");
-		phba->debug_dumpHostSlim =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 phba->hba_debugfs_root,
-				 phba, &lpfc_debugfs_op_dumpHostSlim);
-		if (!phba->debug_dumpHostSlim) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				"0414 Cannot create debugfs dumpHostSlim\n");
-			goto debug_failed;
-		}
+		if (phba->sli_rev < LPFC_SLI_REV4) {
+			snprintf(name, sizeof(name), "dumpHostSlim");
+			phba->debug_dumpHostSlim =
+				debugfs_create_file(name,
+					S_IFREG|S_IRUGO|S_IWUSR,
+					phba->hba_debugfs_root,
+					phba, &lpfc_debugfs_op_dumpHostSlim);
+			if (!phba->debug_dumpHostSlim) {
+				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+						 "0414 Cannot create debugfs "
+						 "dumpHostSlim\n");
+				goto debug_failed;
+			}
+		} else
+			phba->debug_dumpHBASlim = NULL;
 
 		/* Setup dumpData */
 		snprintf(name, sizeof(name), "dumpData");
@@ -1322,8 +2105,6 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 			goto debug_failed;
 		}
 
-
-
 		/* Setup slow ring trace */
 		if (lpfc_debugfs_max_slow_ring_trc) {
 			num = lpfc_debugfs_max_slow_ring_trc - 1;
@@ -1342,7 +2123,6 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 			}
 		}
 
-
 		snprintf(name, sizeof(name), "slow_ring_trace");
 		phba->debug_slow_ring_trc =
 			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
@@ -1434,6 +2214,53 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 "0409 Cant create debugfs nodelist\n");
 		goto debug_failed;
 	}
+
+	/*
+	 * iDiag debugfs root entry points for SLI4 device only
+	 */
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		goto debug_failed;
+
+	snprintf(name, sizeof(name), "iDiag");
+	if (!phba->idiag_root) {
+		phba->idiag_root =
+			debugfs_create_dir(name, phba->hba_debugfs_root);
+		if (!phba->idiag_root) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "2922 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+		/* Initialize iDiag data structure */
+		memset(&idiag, 0, sizeof(idiag));
+	}
+
+	/* iDiag read PCI config space */
+	snprintf(name, sizeof(name), "pciCfg");
+	if (!phba->idiag_pci_cfg) {
+		phba->idiag_pci_cfg =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				phba->idiag_root, phba, &lpfc_idiag_op_pciCfg);
+		if (!phba->idiag_pci_cfg) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "2923 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+		idiag.offset.last_rd = 0;
+	}
+
+	/* iDiag get PCI function queue information */
+	snprintf(name, sizeof(name), "queInfo");
+	if (!phba->idiag_que_info) {
+		phba->idiag_que_info =
+			debugfs_create_file(name, S_IFREG|S_IRUGO,
+			phba->idiag_root, phba, &lpfc_idiag_op_queInfo);
+		if (!phba->idiag_que_info) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "2924 Can't create idiag debugfs\n");
+			goto debug_failed;
+		}
+	}
+
 debug_failed:
 	return;
 #endif
@@ -1508,8 +2335,31 @@ lpfc_debugfs_terminate(struct lpfc_vport
 			phba->debug_slow_ring_trc = NULL;
 		}
 
+		/*
+		 * iDiag release
+		 */
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			if (phba->idiag_que_info) {
+				/* iDiag queInfo */
+				debugfs_remove(phba->idiag_que_info);
+				phba->idiag_que_info = NULL;
+			}
+			if (phba->idiag_pci_cfg) {
+				/* iDiag pciCfg */
+				debugfs_remove(phba->idiag_pci_cfg);
+				phba->idiag_pci_cfg = NULL;
+			}
+
+			/* Finally remove the iDiag debugfs root */
+			if (phba->idiag_root) {
+				/* iDiag root */
+				debugfs_remove(phba->idiag_root);
+				phba->idiag_root = NULL;
+			}
+		}
+
 		if (phba->hba_debugfs_root) {
-			debugfs_remove(phba->hba_debugfs_root); /* lpfcX */
+			debugfs_remove(phba->hba_debugfs_root); /* fnX */
 			phba->hba_debugfs_root = NULL;
 			atomic_dec(&lpfc_debugfs_hba_count);
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2011-02-16 11:35:27.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2007 Emulex.  All rights reserved.                *
+ * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -22,6 +22,44 @@
 #define _H_LPFC_DEBUG_FS
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+
+/* size of output line, for discovery_trace and slow_ring_trace */
+#define LPFC_DEBUG_TRC_ENTRY_SIZE 100
+
+/* nodelist output buffer size */
+#define LPFC_NODELIST_SIZE 8192
+#define LPFC_NODELIST_ENTRY_SIZE 120
+
+/* dumpHBASlim output buffer size */
+#define LPFC_DUMPHBASLIM_SIZE 4096
+
+/* dumpHostSlim output buffer size */
+#define LPFC_DUMPHOSTSLIM_SIZE 4096
+
+/* hbqinfo output buffer size */
+#define LPFC_HBQINFO_SIZE 8192
+
+/* rdPciConf output buffer size */
+#define LPFC_PCI_CFG_SIZE 4096
+#define LPFC_PCI_CFG_RD_BUF_SIZE (LPFC_PCI_CFG_SIZE/2)
+#define LPFC_PCI_CFG_RD_SIZE (LPFC_PCI_CFG_SIZE/4)
+
+/* queue info output buffer size */
+#define LPFC_QUE_INFO_GET_BUF_SIZE 2048
+
+#define SIZE_U8  sizeof(uint8_t)
+#define SIZE_U16 sizeof(uint16_t)
+#define SIZE_U32 sizeof(uint32_t)
+
+struct lpfc_debug {
+	char *i_private;
+	char op;
+#define LPFC_IDIAG_OP_RD 1
+#define LPFC_IDIAG_OP_WR 2
+	char *buffer;
+	int  len;
+};
+
 struct lpfc_debugfs_trc {
 	char *fmt;
 	uint32_t data1;
@@ -30,6 +68,26 @@ struct lpfc_debugfs_trc {
 	uint32_t seq_cnt;
 	unsigned long jif;
 };
+
+struct lpfc_idiag_offset {
+	uint32_t last_rd;
+};
+
+#define LPFC_IDIAG_CMD_DATA_SIZE 4
+struct lpfc_idiag_cmd {
+	uint32_t opcode;
+#define LPFC_IDIAG_CMD_PCICFG_RD 0x00000001
+#define LPFC_IDIAG_CMD_PCICFG_WR 0x00000002
+#define LPFC_IDIAG_CMD_PCICFG_ST 0x00000003
+#define LPFC_IDIAG_CMD_PCICFG_CL 0x00000004
+	uint32_t data[LPFC_IDIAG_CMD_DATA_SIZE];
+};
+
+struct lpfc_idiag {
+	uint32_t active;
+	struct lpfc_idiag_cmd cmd;
+	struct lpfc_idiag_offset offset;
+};
 #endif
 
 /* Mask for discovery_trace */
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:33:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:35:27.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -799,6 +799,10 @@ struct lpfc_hba {
 	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
 	atomic_t slow_ring_trc_cnt;
+	/* iDiag debugfs sub-directory */
+	struct dentry *idiag_root;
+	struct dentry *idiag_pci_cfg;
+	struct dentry *idiag_que_info;
 #endif
 
 	/* Used for deferred freeing of ELS data buffers */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-02-16 11:35:27.000000000 -0500
@@ -125,9 +125,9 @@ struct lpfc_queue {
 	uint32_t entry_count;	/* Number of entries to support on the queue */
 	uint32_t entry_size;	/* Size of each queue entry. */
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
+	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
 	struct list_head page_list;
 	uint32_t page_count;	/* Number of pages allocated for this queue */
-
 	uint32_t host_index;	/* The host's index for putting or getting */
 	uint32_t hba_index;	/* The last known hba index for get or put */
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-02-16 11:35:27.000000000 -0500
@@ -10471,6 +10471,7 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 	cq->type = type;
 	cq->subtype = subtype;
 	cq->queue_id = bf_get(lpfc_mbx_cq_create_q_id, &cq_create->u.response);
+	cq->assoc_qid = eq->queue_id;
 	cq->host_index = 0;
 	cq->hba_index = 0;
 
@@ -10665,6 +10666,7 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 		goto out;
 	}
 	mq->type = LPFC_MQ;
+	mq->assoc_qid = cq->queue_id;
 	mq->subtype = subtype;
 	mq->host_index = 0;
 	mq->hba_index = 0;
@@ -10752,6 +10754,7 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 		goto out;
 	}
 	wq->type = LPFC_WQ;
+	wq->assoc_qid = cq->queue_id;
 	wq->subtype = subtype;
 	wq->host_index = 0;
 	wq->hba_index = 0;
@@ -10869,6 +10872,7 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 		goto out;
 	}
 	hrq->type = LPFC_HRQ;
+	hrq->assoc_qid = cq->queue_id;
 	hrq->subtype = subtype;
 	hrq->host_index = 0;
 	hrq->hba_index = 0;
@@ -10929,6 +10933,7 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 		goto out;
 	}
 	drq->type = LPFC_DRQ;
+	drq->assoc_qid = cq->queue_id;
 	drq->subtype = subtype;
 	drq->host_index = 0;
 	drq->hba_index = 0;


