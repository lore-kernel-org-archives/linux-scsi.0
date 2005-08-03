From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 7/7] aacraid: sgraw command support
Date: Wed, 03 Aug 2005 15:39:49 -0700
Message-ID: <1123108789.24945.41.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53730 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261603AbVHCWjy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2005 18:39:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec:

This patch adds support for the new raw io command. This new command 
offers much larger io commands, is more friendly to the internal firmware 
structure requiring less translation efforts by the firmware and offers 
support for targets greater than 2TB (patch to support >2TB will 
be sent in the future).

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-1/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/aachba.c	2005-07-05 13:55:51.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/aachba.c	2005-07-05 15:12:05.000000000 -0700
@@ -133,6 +133,7 @@
  
 static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* sgmap);
 static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg);
+static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw* psg);
 static int aac_send_srb_fib(struct scsi_cmnd* scsicmd);
 #ifdef AAC_DETAILED_STATUS_INFO
 static char *aac_get_status_string(u32 status);
@@ -777,34 +778,36 @@
 	/* 
 	 * 57 scatter gather elements 
 	 */
-	dev->scsi_host_ptr->sg_tablesize = (dev->max_fib_size -
-		sizeof(struct aac_fibhdr) -
-		sizeof(struct aac_write) + sizeof(struct sgmap)) /
-			sizeof(struct sgmap);
-	if (dev->dac_support) {
-		/* 
-		 * 38 scatter gather elements 
-		 */
-		dev->scsi_host_ptr->sg_tablesize =
-			(dev->max_fib_size -
+	if (!(dev->raw_io_interface)) {
+		dev->scsi_host_ptr->sg_tablesize = (dev->max_fib_size -
 			sizeof(struct aac_fibhdr) -
-			sizeof(struct aac_write64) +
-			sizeof(struct sgmap64)) /
-				sizeof(struct sgmap64);
-	}
-	dev->scsi_host_ptr->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
-	if(!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
-		/*
-		 * Worst case size that could cause sg overflow when
-		 * we break up SG elements that are larger than 64KB.
-		 * Would be nice if we could tell the SCSI layer what
-		 * the maximum SG element size can be. Worst case is
-		 * (sg_tablesize-1) 4KB elements with one 64KB
-		 * element.
-		 *	32bit -> 468 or 238KB	64bit -> 424 or 212KB
-		 */
-		dev->scsi_host_ptr->max_sectors =
-		  (dev->scsi_host_ptr->sg_tablesize * 8) + 112;
+			sizeof(struct aac_write) + sizeof(struct sgmap)) /
+				sizeof(struct sgmap);
+		if (dev->dac_support) {
+			/* 
+			 * 38 scatter gather elements 
+			 */
+			dev->scsi_host_ptr->sg_tablesize =
+				(dev->max_fib_size -
+				sizeof(struct aac_fibhdr) -
+				sizeof(struct aac_write64) +
+				sizeof(struct sgmap64)) /
+					sizeof(struct sgmap64);
+		}
+		dev->scsi_host_ptr->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
+		if(!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
+			/*
+			 * Worst case size that could cause sg overflow when
+			 * we break up SG elements that are larger than 64KB.
+			 * Would be nice if we could tell the SCSI layer what
+			 * the maximum SG element size can be. Worst case is
+			 * (sg_tablesize-1) 4KB elements with one 64KB
+			 * element.
+			 *	32bit -> 468 or 238KB	64bit -> 424 or 212KB
+			 */
+			dev->scsi_host_ptr->max_sectors =
+			  (dev->scsi_host_ptr->sg_tablesize * 8) + 112;
+		}
 	}
 
 	fib_complete(fibptr);
@@ -905,7 +908,32 @@
 
 	fib_init(cmd_fibcontext);
 
-	if (dev->dac_support == 1) {
+	if (dev->raw_io_interface) {
+		struct aac_raw_io *readcmd;
+		readcmd = (struct aac_raw_io *) fib_data(cmd_fibcontext);
+		readcmd->block[0] = cpu_to_le32(lba);
+		readcmd->block[1] = 0;
+		readcmd->count = cpu_to_le32(count<<9);
+		readcmd->cid = cpu_to_le16(cid);
+		readcmd->flags = cpu_to_le16(1);
+		readcmd->bpTotal = 0;
+		readcmd->bpComplete = 0;
+		
+		aac_build_sgraw(scsicmd, &readcmd->sg);
+		fibsize = sizeof(struct aac_raw_io) + ((le32_to_cpu(readcmd->sg.count) - 1) * sizeof (struct sgentryraw));
+		if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))
+			BUG();
+		/*
+		 *	Now send the Fib to the adapter
+		 */
+		status = fib_send(ContainerRawIo,
+			  cmd_fibcontext, 
+			  fibsize, 
+			  FsaNormal, 
+			  0, 1, 
+			  (fib_callback) io_callback, 
+			  (void *) scsicmd);
+	} else if (dev->dac_support == 1) {
 		struct aac_read64 *readcmd;
 		readcmd = (struct aac_read64 *) fib_data(cmd_fibcontext);
 		readcmd->command = cpu_to_le32(VM_CtHostRead64);
@@ -1012,7 +1040,32 @@
 	}
 	fib_init(cmd_fibcontext);
 
-	if(dev->dac_support == 1) {
+	if (dev->raw_io_interface) {
+		struct aac_raw_io *writecmd;
+		writecmd = (struct aac_raw_io *) fib_data(cmd_fibcontext);
+		writecmd->block[0] = cpu_to_le32(lba);
+		writecmd->block[1] = 0;
+		writecmd->count = cpu_to_le32(count<<9);
+		writecmd->cid = cpu_to_le16(cid);
+		writecmd->flags = 0; 
+		writecmd->bpTotal = 0;
+		writecmd->bpComplete = 0;
+		
+		aac_build_sgraw(scsicmd, &writecmd->sg);
+		fibsize = sizeof(struct aac_raw_io) + ((le32_to_cpu(writecmd->sg.count) - 1) * sizeof (struct sgentryraw));
+		if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))
+			BUG();
+		/*
+		 *	Now send the Fib to the adapter
+		 */
+		status = fib_send(ContainerRawIo,
+			  cmd_fibcontext, 
+			  fibsize, 
+			  FsaNormal, 
+			  0, 1, 
+			  (fib_callback) io_callback, 
+			  (void *) scsicmd);
+	} else if (dev->dac_support == 1) {
 		struct aac_write64 *writecmd;
 		writecmd = (struct aac_write64 *) fib_data(cmd_fibcontext);
 		writecmd->command = cpu_to_le32(VM_CtHostWrite64);
@@ -2028,6 +2081,76 @@
 	return byte_count;
 }
 
+static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw* psg)
+{
+	struct Scsi_Host *host = scsicmd->device->host;
+	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
+	unsigned long byte_count = 0;
+
+	// Get rid of old data
+	psg->count = 0;
+	psg->sg[0].next = 0;
+	psg->sg[0].prev = 0;
+	psg->sg[0].addr[0] = 0;
+	psg->sg[0].addr[1] = 0;
+	psg->sg[0].count = 0;
+	psg->sg[0].flags = 0;
+	if (scsicmd->use_sg) {
+		struct scatterlist *sg;
+		int i;
+		int sg_count;
+		sg = (struct scatterlist *) scsicmd->request_buffer;
+
+		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
+			scsicmd->sc_data_direction);
+
+		for (i = 0; i < sg_count; i++) {
+			int count = sg_dma_len(sg);
+			u64 addr = sg_dma_address(sg);
+			psg->sg[i].next = 0;
+			psg->sg[i].prev = 0;
+			psg->sg[i].addr[1] = cpu_to_le32((u32)(addr>>32));
+			psg->sg[i].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
+			psg->sg[i].count = cpu_to_le32(count);
+			psg->sg[i].flags = 0;
+			byte_count += count;
+			sg++;
+		}
+		psg->count = cpu_to_le32(sg_count);
+		/* hba wants the size to be exact */
+		if(byte_count > scsicmd->request_bufflen){
+			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
+				(byte_count - scsicmd->request_bufflen);
+			psg->sg[i-1].count = cpu_to_le32(temp);
+			byte_count = scsicmd->request_bufflen;
+		}
+		/* Check for command underflow */
+		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
+			printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
+					byte_count, scsicmd->underflow);
+		}
+	}
+	else if(scsicmd->request_bufflen) {
+		int count;
+		u64 addr;
+		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
+				scsicmd->request_buffer,
+				scsicmd->request_bufflen,
+				scsicmd->sc_data_direction);
+		addr = scsicmd->SCp.dma_handle;
+		count = scsicmd->request_bufflen;
+		psg->count = cpu_to_le32(1);
+		psg->sg[0].next = 0;
+		psg->sg[0].prev = 0;
+		psg->sg[0].addr[1] = cpu_to_le32((u32)(addr>>32));
+		psg->sg[0].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
+		psg->sg[0].count = cpu_to_le32(count);
+		psg->sg[0].flags = 0;
+		byte_count = scsicmd->request_bufflen;
+	}
+	return byte_count;
+}
+
 #ifdef AAC_DETAILED_STATUS_INFO
 
 struct aac_srb_status_info {
Index: scsi-misc-aac-1/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/aacraid.h	2005-07-01 11:52:07.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/aacraid.h	2005-07-05 15:12:05.000000000 -0700
@@ -114,6 +114,22 @@
 	u32	count;	/* Length. */
 };
 
+struct sgentryraw {
+	__le32		next;	/* reserved for F/W use */
+	__le32		prev;	/* reserved for F/W use */
+	__le32		addr[2];
+	__le32		count;
+	__le32		flags;	/* reserved for F/W use */
+};
+
+struct user_sgentryraw {
+	u32		next;	/* reserved for F/W use */
+	u32		prev;	/* reserved for F/W use */
+	u32		addr[2];
+	u32		count;
+	u32		flags;	/* reserved for F/W use */
+};
+
 /*
  *	SGMAP
  *
@@ -141,6 +157,16 @@
 	struct user_sgentry64 sg[1];
 };
 
+struct sgmapraw {
+	__le32		  count;
+	struct sgentryraw sg[1];
+};
+
+struct user_sgmapraw {
+	u32		  count;
+	struct user_sgentryraw sg[1];
+};
+
 struct creation_info
 {
 	u8 		buildnum;		/* e.g., 588 */
@@ -355,6 +381,7 @@
  */
 #define		ContainerCommand		500
 #define		ContainerCommand64		501
+#define		ContainerRawIo			502
 /*
  *	Cluster Commands
  */
@@ -986,6 +1013,9 @@
 	u8			nondasd_support; 
 	u8			dac_support;
 	u8			raid_scsi_mode;
+	/* macro side-effects BEWARE */
+#	define			raw_io_interface \
+	  init->InitStructRevision==cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4)
 	u8			printf_enabled;
 };
 
@@ -1164,6 +1194,17 @@
 	__le32		committed;
 };
 
+struct aac_raw_io
+{
+	__le32		block[2];
+	__le32		count;
+	__le16		cid;
+	__le16		flags;		/* 00 W, 01 R */
+	__le16		bpTotal;	/* reserved for F/W use */
+	__le16		bpComplete;	/* reserved for F/W use */
+	struct sgmapraw	sg;
+};
+
 #define CT_FLUSH_CACHE 129
 struct aac_synchronize {
 	__le32		command;	/* VM_ContainerConfig */
@@ -1204,7 +1245,7 @@
 };
 
 /*
- * This and assocated data structs are used by the 
+ * This and associated data structs are used by the
  * ioctl caller and are in cpu order.
  */
 struct user_aac_srb

-- 
Mark Haverkamp <markh@osdl.org>

