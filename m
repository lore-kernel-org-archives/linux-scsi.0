From: James Bottomley <James.Bottomley@steeleye.com>
Subject: qla1280 endiannes and 64/32bit fixes
Date: 17 Jan 2004 18:40:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074382860.1756.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:64746 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266211AbUAQXlF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 18:41:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Well, I finally got this to work for me on the parisc.

There were three specific problems

1. The Fimware reading routine is still wrong.  If you reverse all the
words, then the byte quantities will be correct but the word quantities
still need reversing again.

2. The new qla1280_return_status() routine wasn't endian neutral

3. You can't simply override the nvram 64/32 bit mode without actually
telling the card you're doing it.

To fix 3, I just removed the override, but since I was actually running
on a 64 bit platform (parisc64) there should be a command to tell the
card this...I'll see if I can find it.

With the attached patch, the card works nicely on parisc.

James

===== drivers/scsi/qla1280.c 1.53 vs edited =====
--- 1.53/drivers/scsi/qla1280.c	Thu Jan  8 15:42:46 2004
+++ edited/drivers/scsi/qla1280.c	Sat Jan 17 17:26:33 2004
@@ -765,7 +765,7 @@
 {
 	uint16_t *wptr;
 	uint8_t chksum;
-	int cnt;
+	int cnt, i;
 	struct nvram *nv;
 
 	ENTER("qla1280_read_nvram");
@@ -812,6 +812,28 @@
 	} else
 		ha->nvram_valid = 1;
 
+	/* The firmware interface is, um, interesting, in that the
+	 * actual firmware image on the chip is little endian, thus,
+	 * the process of taking that image to the CPU would end up
+	 * little endian.  However, the firmare interface requires it
+	 * to be read a word (two bytes) at a time.
+	 *
+	 * The net result of this would be that the word (and
+	 * doubleword) quantites in the firmware would be correct, but
+	 * the bytes would be pairwise reversed.  Since most of the
+	 * firmware quantites are, in fact, bytes, we do an extra
+	 * le16_to_cpu() in the firmware read routine.
+	 *
+	 * The upshot of all this is that the bytes in the firmware
+	 * are in the correct places, but the 16 and 32 bit quantites
+	 * are still in little endian format.  We fix that up below by
+	 * doing extra reverses on them */
+	nv->isp_parameter = cpu_to_le16(nv->isp_parameter);
+	nv->firmware_feature.w = cpu_to_le16(nv->firmware_feature.w);
+	for(i = 0; i < MAX_BUSES; i++) {
+		nv->bus[i].selection_timeout = cpu_to_le16(nv->bus[i].selection_timeout);
+		nv->bus[i].max_queue_depth = cpu_to_le16(nv->bus[i].max_queue_depth);
+	}
 	dprintk(1, "qla1280_read_nvram: Completed Reading NVRAM\n");
 	LEAVE("qla1280_read_nvram");
 
@@ -1558,6 +1580,10 @@
 qla1280_return_status(struct response * sts, struct scsi_cmnd *cp)
 {
 	int host_status = DID_ERROR;
+	uint16_t comp_status = le16_to_cpu(sts->comp_status);
+	uint16_t state_flags = le16_to_cpu(sts->state_flags);
+	uint16_t residual_length = le16_to_cpu(sts->residual_length);
+	uint16_t scsi_status = le16_to_cpu(sts->scsi_status);
 #if DEBUG_QLA1280_INTR
 	static char *reason[] = {
 		"DID_OK",
@@ -1578,26 +1604,27 @@
 #if DEBUG_QLA1280_INTR
 	/*
 	  dprintk(1, "qla1280_return_status: compl status = 0x%04x\n",
-	  sts->comp_status);
+	  comp_status);
 	*/
 #endif
-	switch (sts->comp_status) {
+
+	switch (comp_status) {
 	case CS_COMPLETE:
 		host_status = DID_OK;
 		break;
 
 	case CS_INCOMPLETE:
-		if (!(sts->state_flags & SF_GOT_BUS))
+		if (!(state_flags & SF_GOT_BUS))
 			host_status = DID_NO_CONNECT;
-		else if (!(sts->state_flags & SF_GOT_TARGET))
+		else if (!(state_flags & SF_GOT_TARGET))
 			host_status = DID_BAD_TARGET;
-		else if (!(sts->state_flags & SF_SENT_CDB))
+		else if (!(state_flags & SF_SENT_CDB))
 			host_status = DID_ERROR;
-		else if (!(sts->state_flags & SF_TRANSFERRED_DATA))
+		else if (!(state_flags & SF_TRANSFERRED_DATA))
 			host_status = DID_ERROR;
-		else if (!(sts->state_flags & SF_GOT_STATUS))
+		else if (!(state_flags & SF_GOT_STATUS))
 			host_status = DID_ERROR;
-		else if (!(sts->state_flags & SF_GOT_SENSE))
+		else if (!(state_flags & SF_GOT_SENSE))
 			host_status = DID_ERROR;
 		break;
 
@@ -1614,14 +1641,14 @@
 		break;
 
 	case CS_DATA_OVERRUN:
-		dprintk(2, "Data overrun 0x%x\n", sts->residual_length);
+		dprintk(2, "Data overrun 0x%x\n", residual_length);
 		dprintk(2, "qla1280_isr: response packet data\n");
 		qla1280_dump_buffer(2, (char *)sts, RESPONSE_ENTRY_SIZE);
 		host_status = DID_ERROR;
 		break;
 
 	case CS_DATA_UNDERRUN:
-		if ((cp->request_bufflen - sts->residual_length) <
+		if ((cp->request_bufflen - residual_length) <
 		    cp->underflow) {
 			printk(KERN_WARNING
 			       "scsi: Underflow detected - retrying "
@@ -1638,12 +1665,12 @@
 
 #if DEBUG_QLA1280_INTR
 	dprintk(1, "qla1280 ISP status: host status (%s) scsi status %x\n",
-		reason[host_status], sts->scsi_status);
+		reason[host_status], scsi_status);
 #endif
 
 	LEAVE("qla1280_return_status");
 
-	return (sts->scsi_status & 0xff) | (host_status << 16);
+	return (scsi_status & 0xff) | (host_status << 16);
 }
 
 /****************************************************************************/
@@ -2393,16 +2420,6 @@
 	/* Disable RISC load of firmware. */
 	ha->flags.disable_risc_code_load =
 		nv->cntr_flags_1.disable_loading_risc_code;
-
-#ifdef QLA_64BIT_PTR
-	/* Enable 64bit addressing for OS/System combination supporting it   */
-	/* actual NVRAM bit is: nv->cntr_flags_1.enable_64bit_addressing     */
-	/* but we will ignore it and use BITS_PER_LONG macro to setup for    */
-	/* 64 or 32 bit access of host memory in all x86/ia-64/Alpha systems */
-	ha->flags.enable_64bit_addressing = 1;
-#else
-	ha->flags.enable_64bit_addressing = 0;
-#endif
 
 	if (ha->flags.enable_64bit_addressing) {
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
===== drivers/scsi/qla1280.h 1.23 vs edited =====
--- 1.23/drivers/scsi/qla1280.h	Sun Jan  4 23:07:47 2004
+++ edited/drivers/scsi/qla1280.h	Sat Jan 17 13:04:48 2004
@@ -309,16 +309,19 @@
 	} cntr_flags_1;		/* 5 */
 
 	struct {
-		uint16_t boot_lun_number:5;
-		uint16_t scsi_bus_number:1;
-		uint16_t unused_6:1;
-		uint16_t unused_7:1;
-		uint16_t boot_target_number:4;
-		uint16_t unused_12:1;
-		uint16_t unused_13:1;
-		uint16_t unused_14:1;
-		uint16_t unused_15:1;
-	} cntr_flags_2;		/* 6, 7 */
+		uint8_t boot_lun_number:5;
+		uint8_t scsi_bus_number:1;
+		uint8_t unused_6:1;
+		uint8_t unused_7:1;
+	} cntr_flags_2l;	/* 7 */
+
+	struct {
+		uint8_t boot_target_number:4;
+		uint8_t unused_12:1;
+		uint8_t unused_13:1;
+		uint8_t unused_14:1;
+		uint8_t unused_15:1;
+	} cntr_flags_2h;	/* 8 */
 
 	uint16_t unused_8;	/* 8, 9 */
 	uint16_t unused_10;	/* 10, 11 */

