From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 3/8] cciss: simplify interface of sendcmd() and sendcmd_withirq()
Date: Mon, 8 Jun 2009 16:02:17 -0500
Message-ID: <20090608210217.GI23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:1257 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZFHVBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:01:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net



Simplify interfaces of sendcmd() and sendcmd_withirq() so that they
provide only one way to address commands instead of three ways.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

---


diff -puN drivers/block/cciss.c~more_sendcmd_cleanup drivers/block/cciss.c
--- linux-next/drivers/block/cciss.c~more_sendcmd_cleanup	2009-06-08 12:58:49.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss.c	2009-06-08 12:58:49.000000000 -0500
@@ -180,11 +180,10 @@ static void __devinit cciss_interrupt_mo
 					   __u32);
 static void start_io(ctlr_info_t *h);
 static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size,
-		   unsigned int use_unit_num, unsigned int log_unit,
 		   __u8 page_code, unsigned char *scsi3addr, int cmd_type);
 static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
-			   unsigned int use_unit_num, unsigned int log_unit,
-			   __u8 page_code, int cmd_type);
+			__u8 page_code, unsigned char scsi3addr[],
+			int cmd_type);
 
 static void fail_all_cmds(unsigned long ctlr);
 static int scan_thread(void *data);
@@ -1520,6 +1519,15 @@ static void cciss_softirq_done(struct re
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
+static void log_unit_to_scsi3addr(ctlr_info_t *h, unsigned char scsi3addr[],
+	uint32_t log_unit)
+{
+	log_unit = h->drv[log_unit].LunID & 0x03fff;
+	memset(&scsi3addr[4], 0, 4);
+	memcpy(&scsi3addr[0], &log_unit, 4);
+	scsi3addr[3] |= 0x40;
+}
+
 /* This function gets the SCSI vendor, model, and revision of a logical drive
  * via the inquiry page 0.  Model, vendor, and rev are set to empty strings if
  * they cannot be read.
@@ -1529,6 +1537,7 @@ static void cciss_get_device_descr(int c
 {
 	int rc;
 	InquiryData_struct *inq_buf;
+	unsigned char scsi3addr[8];
 
 	*vendor = '\0';
 	*model = '\0';
@@ -1538,14 +1547,15 @@ static void cciss_get_device_descr(int c
 	if (!inq_buf)
 		return;
 
+	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
 	if (withirq)
 		rc = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buf,
-				     sizeof(InquiryData_struct), 1, logvol,
-				     0, TYPE_CMD);
+			     sizeof(InquiryData_struct), 0,
+				scsi3addr, TYPE_CMD);
 	else
 		rc = sendcmd(CISS_INQUIRY, ctlr, inq_buf,
-			     sizeof(InquiryData_struct), 1, logvol, 0, NULL,
-			     TYPE_CMD);
+			     sizeof(InquiryData_struct), 0,
+				scsi3addr, TYPE_CMD);
 	if (rc == IO_OK) {
 		memcpy(vendor, &inq_buf->data_byte[8], VENDOR_LEN);
 		vendor[VENDOR_LEN] = '\0';
@@ -1570,6 +1580,7 @@ static void cciss_get_serial_no(int ctlr
 #define PAGE_83_INQ_BYTES 64
 	int rc;
 	unsigned char *buf;
+	unsigned char scsi3addr[8];
 
 	if (buflen > 16)
 		buflen = 16;
@@ -1578,12 +1589,13 @@ static void cciss_get_serial_no(int ctlr
 	if (!buf)
 		return;
 	memset(serial_no, 0, buflen);
+	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
 	if (withirq)
 		rc = sendcmd_withirq(CISS_INQUIRY, ctlr, buf,
-			PAGE_83_INQ_BYTES, 1, logvol, 0x83, TYPE_CMD);
+			PAGE_83_INQ_BYTES, 0x83, scsi3addr, TYPE_CMD);
 	else
 		rc = sendcmd(CISS_INQUIRY, ctlr, buf,
-			PAGE_83_INQ_BYTES, 1, logvol, 0x83, NULL, TYPE_CMD);
+			PAGE_83_INQ_BYTES, 0x83, scsi3addr, TYPE_CMD);
 	if (rc == IO_OK)
 		memcpy(serial_no, &buf[8], buflen);
 	kfree(buf);
@@ -1902,8 +1914,8 @@ static int rebuild_lun_table(ctlr_info_t
 		goto mem_msg;
 
 	return_code = sendcmd_withirq(CISS_REPORT_LOG, ctlr, ld_buff,
-				      sizeof(ReportLunData_struct), 0,
-				      0, 0, TYPE_CMD);
+				      sizeof(ReportLunData_struct),
+				      0, CTLR_LUNID, TYPE_CMD);
 
 	if (return_code == IO_OK)
 		listlength = be32_to_cpu(*(__be32 *) ld_buff->LUNListLength);
@@ -2112,11 +2124,9 @@ static int deregister_disk(ctlr_info_t *
 	return 0;
 }
 
-static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff, size_t size, unsigned int use_unit_num,	/* 0: address the controller,
-															   1: address logical volume log_unit,
-															   2: periph device address is scsi3addr */
-		    unsigned int log_unit, __u8 page_code,
-		    unsigned char *scsi3addr, int cmd_type)
+static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
+		size_t size, __u8 page_code, unsigned char *scsi3addr,
+		int cmd_type)
 {
 	ctlr_info_t *h = hba[ctlr];
 	u64bit buff_dma_handle;
@@ -2132,27 +2142,12 @@ static int fill_cmd(CommandList_struct *
 		c->Header.SGTotal = 0;
 	}
 	c->Header.Tag.lower = c->busaddr;
+	memcpy(c->Header.LUN.LunAddrBytes, scsi3addr, 8);
 
 	c->Request.Type.Type = cmd_type;
 	if (cmd_type == TYPE_CMD) {
 		switch (cmd) {
 		case CISS_INQUIRY:
-			/* If the logical unit number is 0 then, this is going
-			   to controller so It's a physical command
-			   mode = 0 target = 0.  So we have nothing to write.
-			   otherwise, if use_unit_num == 1,
-			   mode = 1(volume set addressing) target = LUNID
-			   otherwise, if use_unit_num == 2,
-			   mode = 0(periph dev addr) target = scsi3addr */
-			if (use_unit_num == 1) {
-				c->Header.LUN.LogDev.VolId =
-				    h->drv[log_unit].LunID;
-				c->Header.LUN.LogDev.Mode = 1;
-			} else if (use_unit_num == 2) {
-				memcpy(c->Header.LUN.LunAddrBytes, scsi3addr,
-				       8);
-				c->Header.LUN.LogDev.Mode = 0;
-			}
 			/* are we trying to read a vital product page */
 			if (page_code != 0) {
 				c->Request.CDB[1] = 0x01;
@@ -2182,8 +2177,6 @@ static int fill_cmd(CommandList_struct *
 			break;
 
 		case CCISS_READ_CAPACITY:
-			c->Header.LUN.LogDev.VolId = h->drv[log_unit].LunID;
-			c->Header.LUN.LogDev.Mode = 1;
 			c->Request.CDBLen = 10;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_READ;
@@ -2191,8 +2184,6 @@ static int fill_cmd(CommandList_struct *
 			c->Request.CDB[0] = cmd;
 			break;
 		case CCISS_READ_CAPACITY_16:
-			c->Header.LUN.LogDev.VolId = h->drv[log_unit].LunID;
-			c->Header.LUN.LogDev.Mode = 1;
 			c->Request.CDBLen = 16;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_READ;
@@ -2215,7 +2206,6 @@ static int fill_cmd(CommandList_struct *
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
 			break;
 		case TEST_UNIT_READY:
-			memcpy(c->Header. LUN.LunAddrBytes, scsi3addr, 8);
 			c->Request.CDBLen = 6;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_NONE;
@@ -2239,7 +2229,6 @@ static int fill_cmd(CommandList_struct *
 			memcpy(&c->Request.CDB[4], buff, 8);
 			break;
 		case 1:	/* RESET message */
-			memcpy(c->Header.LUN.LunAddrBytes, scsi3addr, 8);
 			c->Request.CDBLen = 16;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_NONE;
@@ -2307,6 +2296,9 @@ resend_cmd2:
 			printk(KERN_WARNING "cciss: cmd 0x%02x "
 			       "has SCSI Status = %x\n",
 			       c->Request.CDB[0], c->err_info->ScsiStatus);
+			if (c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION)
+				printk(KERN_WARNING "sense key = 0x%02x\n",
+					0xf & c->err_info->SenseInfo[2]);
 		}
 		break;
 	case CMD_DATA_UNDERRUN:
@@ -2377,12 +2369,9 @@ command_done:
 	return return_status;
 }
 
-static int sendcmd_withirq(__u8 cmd,
-			   int ctlr,
-			   void *buff,
-			   size_t size,
-			   unsigned int use_unit_num,
-			   unsigned int log_unit, __u8 page_code, int cmd_type)
+static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
+			   __u8 page_code, unsigned char scsi3addr[],
+			int cmd_type)
 {
 	ctlr_info_t *h = hba[ctlr];
 	CommandList_struct *c;
@@ -2391,8 +2380,8 @@ static int sendcmd_withirq(__u8 cmd,
 	c = cmd_alloc(h, 0);
 	if (!c)
 		return -ENOMEM;
-	return_status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
-				 log_unit, page_code, NULL, cmd_type);
+	return_status = fill_cmd(c, cmd, ctlr, buff, size, page_code,
+		scsi3addr, cmd_type);
 	if (return_status == IO_OK)
 		return_status = sendcmd_withirq_core(h, c);
 	cmd_free(h, c, 0);
@@ -2407,15 +2396,17 @@ static void cciss_geometry_inquiry(int c
 {
 	int return_code;
 	unsigned long t;
+	unsigned char scsi3addr[8];
 
 	memset(inq_buff, 0, sizeof(InquiryData_struct));
+	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
 	if (withirq)
 		return_code = sendcmd_withirq(CISS_INQUIRY, ctlr,
-					      inq_buff, sizeof(*inq_buff), 1,
-					      logvol, 0xC1, TYPE_CMD);
+					      inq_buff, sizeof(*inq_buff),
+					      0xC1, scsi3addr, TYPE_CMD);
 	else
 		return_code = sendcmd(CISS_INQUIRY, ctlr, inq_buff,
-				      sizeof(*inq_buff), 1, logvol, 0xC1, NULL,
+				      sizeof(*inq_buff), 0xC1, scsi3addr,
 				      TYPE_CMD);
 	if (return_code == IO_OK) {
 		if (inq_buff->data_byte[8] == 0xFF) {
@@ -2456,6 +2447,7 @@ cciss_read_capacity(int ctlr, int logvol
 {
 	ReadCapdata_struct *buf;
 	int return_code;
+	unsigned char scsi3addr[8];
 
 	buf = kzalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
 	if (!buf) {
@@ -2463,14 +2455,15 @@ cciss_read_capacity(int ctlr, int logvol
 		return;
 	}
 
+	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
 	if (withirq)
 		return_code = sendcmd_withirq(CCISS_READ_CAPACITY,
 				ctlr, buf, sizeof(ReadCapdata_struct),
-					1, logvol, 0, TYPE_CMD);
+					0, scsi3addr, TYPE_CMD);
 	else
 		return_code = sendcmd(CCISS_READ_CAPACITY,
 				ctlr, buf, sizeof(ReadCapdata_struct),
-					1, logvol, 0, NULL, TYPE_CMD);
+					0, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		*total_size = be32_to_cpu(*(__be32 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
@@ -2490,6 +2483,7 @@ cciss_read_capacity_16(int ctlr, int log
 {
 	ReadCapdata_struct_16 *buf;
 	int return_code;
+	unsigned char scsi3addr[8];
 
 	buf = kzalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
 	if (!buf) {
@@ -2497,15 +2491,16 @@ cciss_read_capacity_16(int ctlr, int log
 		return;
 	}
 
+	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
 	if (withirq) {
 		return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
 			ctlr, buf, sizeof(ReadCapdata_struct_16),
-				1, logvol, 0, TYPE_CMD);
+				0, scsi3addr, TYPE_CMD);
 	}
 	else {
 		return_code = sendcmd(CCISS_READ_CAPACITY_16,
 			ctlr, buf, sizeof(ReadCapdata_struct_16),
-				1, logvol, 0, NULL, TYPE_CMD);
+				0, scsi3addr, TYPE_CMD);
 	}
 	if (return_code == IO_OK) {
 		*total_size = be64_to_cpu(*(__be64 *) buf->total_size);
@@ -2760,10 +2755,6 @@ cleanup1:
  * Used at init time, and during SCSI error recovery.
  */
 static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size,
-	unsigned int use_unit_num,/* 0: address the controller,
-				     1: address logical volume log_unit,
-				     2: periph device address is scsi3addr */
-	unsigned int log_unit,
 	__u8 page_code, unsigned char *scsi3addr, int cmd_type)
 {
 	CommandList_struct *c;
@@ -2774,8 +2765,8 @@ static int sendcmd(__u8 cmd, int ctlr, v
 		printk(KERN_WARNING "cciss: unable to get memory");
 		return IO_ERROR;
 	}
-	status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
-			  log_unit, page_code, scsi3addr, cmd_type);
+	status = fill_cmd(c, cmd, ctlr, buff, size, page_code,
+		scsi3addr, cmd_type);
 	if (status == IO_OK)
 		status = sendcmd_core(hba[ctlr], c);
 	cmd_free(hba[ctlr], c, 1);
@@ -4076,7 +4067,7 @@ static int __devinit cciss_init_one(stru
 	}
 
 	return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
-		sizeof(InquiryData_struct), 0, 0 , 0, TYPE_CMD);
+		sizeof(InquiryData_struct), 0, CTLR_LUNID, TYPE_CMD);
 	if (return_code == IO_OK) {
 		hba[i]->firm_ver[0] = inq_buff->data_byte[32];
 		hba[i]->firm_ver[1] = inq_buff->data_byte[33];
@@ -4157,8 +4148,8 @@ static void cciss_shutdown(struct pci_de
 	/* sendcmd will turn off interrupt, and send the flush...
 	 * To write all data in the battery backed cache to disks */
 	memset(flush_buf, 0, 4);
-	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
-			      TYPE_CMD);
+	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0,
+		CTLR_LUNID, TYPE_CMD);
 	if (return_code == IO_OK) {
 		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
 	} else {
diff -puN drivers/block/cciss_cmd.h~more_sendcmd_cleanup drivers/block/cciss_cmd.h
--- linux-next/drivers/block/cciss_cmd.h~more_sendcmd_cleanup	2009-06-08 12:58:49.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss_cmd.h	2009-06-08 12:58:49.000000000 -0500
@@ -217,6 +217,8 @@ typedef union _LUNAddr_struct {
   LogDevAddr_struct  LogDev;
 } LUNAddr_struct;
 
+#define CTLR_LUNID "\0\0\0\0\0\0\0\0"
+
 typedef struct _CommandListHeader_struct {
   BYTE              ReplyQueue;
   BYTE              SGList;
diff -puN drivers/block/cciss_scsi.c~more_sendcmd_cleanup drivers/block/cciss_scsi.c
--- linux-next/drivers/block/cciss_scsi.c~more_sendcmd_cleanup	2009-06-08 12:58:49.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss_scsi.c	2009-06-08 12:58:49.000000000 -0500
@@ -44,26 +44,9 @@
 #define CCISS_ABORT_MSG 0x00
 #define CCISS_RESET_MSG 0x01
 
-/* some prototypes... */ 
-static int sendcmd(
-	__u8	cmd,
-	int	ctlr,
-	void	*buff,
-	size_t	size,
-	unsigned int use_unit_num, /* 0: address the controller,
-				      1: address logical volume log_unit, 
-				      2: address is in scsi3addr */
-	unsigned int log_unit,
-	__u8	page_code,
-	unsigned char *scsi3addr,
-	int cmd_type);
-
 static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
 	size_t size,
-	unsigned int use_unit_num, /* 0: address the controller,
-				      1: address logical volume log_unit,
-				      2: periph device address is scsi3addr */
-	unsigned int log_unit, __u8 page_code, unsigned char *scsi3addr,
+	__u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
 static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c);
@@ -1616,7 +1599,7 @@ static int wait_for_device_to_become_rea
 			waittime = waittime * 2;
 
 		/* Send the Test Unit Ready */
-		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0, 0, 0,
+		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0,
 			lunaddr, TYPE_CMD);
 		if (rc == 0) {
 			rc = sendcmd_core(h, c);
@@ -1680,7 +1663,7 @@ static int cciss_eh_device_reset_handler
 		return FAILED;
 	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0, lunaddr,
+	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
 		TYPE_MSG);
 	/* sendcmd turned off interrupts on the board, turn 'em back on. */
 	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
@@ -1708,8 +1691,7 @@ static int  cciss_eh_abort_handler(struc
 	cmd_to_abort = (CommandList_struct *) scsicmd->host_scribble;
 	if (cmd_to_abort == NULL) /* paranoia */
 		return FAILED;
-	rc = sendcmd(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag, 
-		0, 2, 0, 0, 
+	rc = sendcmd(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag, 0, 0,
 		(unsigned char *) &cmd_to_abort->Header.LUN.LunAddrBytes[0], 
 		TYPE_MSG);
 	/* sendcmd turned off interrupts on the board, turn 'em back on. */
_
