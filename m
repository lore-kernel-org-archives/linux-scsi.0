From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
Date: Tue, 11 Oct 2011 13:56:52 +0530
Message-ID: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg__26284.2869772159$1318321640$gmane$org@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1JKI0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Oct 2011 04:26:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.ke

SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails

It has been observed that a number of USB HDD's do not respond correctly
to SCSI mode sense command(retrieve caching pages) which results in their
Write Cache being discarded by queue requests i.e., WCE if left set to
'0'(disabled). So, in order to identify the devices correctly - give it
a last try using SG_ATA_16 after failure from normal routine.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>

diff -Nurp linux-Orig/drivers/scsi/sd.c linux-Updated/drivers/scsi/sd.c
--- linux-Orig/drivers/scsi/sd.c	2011-10-11 11:02:48.000000000 +0530
+++ linux-Updated/drivers/scsi/sd.c	2011-10-11 11:10:09.000000000 +0530
@@ -56,6 +56,7 @@
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>

+#include <scsi/sg.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -134,6 +135,58 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };

+/* Relevant Structure and Function to be used to Retrieve
+ * Caching Information from USB HDD - this is picked from
+ * source code of 'hdparm'
+ *
+ *
+ * Definitions and structures for use with SG_IO + ATA_16:
+ * */
+#define SG_ATA_16               0x85
+#define SG_ATA_16_LEN           16
+
+#define ATA_OP_IDENTIFY		0xec
+
+/*
+ * Some useful ATA register bits
+ */
+enum {
+        ATA_USING_LBA           = (1 << 6),
+        ATA_STAT_DRQ            = (1 << 3),
+        ATA_STAT_ERR            = (1 << 0),
+};
+
+struct ata_lba_regs {
+        __u8    feat;
+        __u8    nsect;
+        __u8    lbal;
+        __u8    lbam;
+        __u8    lbah;
+};
+struct ata_tf {
+        __u8                    dev;
+        __u8                    command;
+        __u8                    error;
+        __u8                    status;
+        __u8                    is_lba48;
+        struct ata_lba_regs     lob;
+        struct ata_lba_regs     hob;
+};
+
+__u64 tf_to_lba (struct ata_tf *tf)
+{
+        __u32 lba24, lbah;
+        __u64 lba64;
+
+        lba24 = (tf->lob.lbah << 16) | (tf->lob.lbam << 8) | (tf->lob.lbal);
+        if (tf->is_lba48)
+                lbah = (tf->hob.lbah << 16) | (tf->hob.lbam << 8) |
(tf->hob.lbal);
+        else
+                lbah = (tf->dev & 0x0f);
+        lba64 = (((__u64)lbah) << 24) | (__u64)lba24;
+        return lba64;
+}
+
 static ssize_t
 sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
@@ -1839,6 +1892,18 @@ sd_read_cache_type(struct scsi_disk *sdk
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;

+	struct ata_tf tf;
+	struct sg_io_hdr io_hdr;
+	unsigned char cdb[SG_ATA_16_LEN] = {0};
+	unsigned char sb[32] = {0};
+	unsigned char buf[512] = {0};
+	unsigned short wce_word = 0;
+	void *data_cmd = buf;
+
+	memset(cdb, 0, SG_ATA_16_LEN);
+	memset(&tf, 0, sizeof(struct ata_tf));
+	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
+
        first_len = 4;
        if (sdp->skip_ms_page_8) {
                if (sdp->type == TYPE_RBC)
@@ -1961,7 +2026,6 @@ Page_found:
 				  sdkp->DPOFUA ? "supports DPO and FUA"
 				  : "doesn't support DPO or FUA");

-		return;
 	}

 bad_sense:
@@ -1974,8 +2038,64 @@ bad_sense:
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");

 defaults:
-	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
-	sdkp->WCE = 0;
+	if (sdkp->WCE)
+		return;
+	else {
+		sd_printk(KERN_ERR, sdkp, "Normal Routine Failed: Trying ATA_16\n");
+		
+		/* The below are necessary parameters which are to set - in order
+		to make use of ATA_OP_IDENTIFY command */
+		tf.lob.lbal = 0;
+	        tf.lob.lbam = 0;
+	        tf.lob.lbah = 0;
+	        tf.lob.nsect = 1; //Number of Sectors to Read
+	        tf.lob.feat = 0;
+
+		/* Command Descriptor Block For SCSI 	*/
+	        cdb[0] = SG_ATA_16;
+	        cdb[1] = 0x08;
+	        cdb[2] = 0x0e;
+	        cdb[6] = 0x01; //No. of Sectors To Read
+	        cdb[13] = ATA_USING_LBA;
+	        cdb[14] = ATA_OP_IDENTIFY;
+
+	        io_hdr.cmd_len = SG_ATA_16_LEN;
+	        io_hdr.interface_id = SG_INTERFACE_ID_ORIG;
+	        io_hdr.mx_sb_len= sizeof(sb);
+	        io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	        io_hdr.dxfer_len = sizeof(buf);
+	        io_hdr.dxferp = data_cmd;
+	        io_hdr.cmdp = cdb;
+	        io_hdr.sbp = sb;
+	        io_hdr.pack_id = tf_to_lba(&tf);
+        	io_hdr.timeout = 0;
+
+	        if (!scsi_cmd_ioctl(sdkp->disk->queue, sdkp->disk,
O_RDONLY|O_NONBLOCK, SG_IO, &io_hdr))
+        	{
+#if 0
+#define DUMP_BYTES_BUFFER(x...) printk( x )
+			int i;
+			for (i = 0; i < 32; i++)
+        	                DUMP_BYTES_BUFFER(" %02x", sb[i]);
+	                DUMP_BYTES_BUFFER("\n");
+	                for (i = 0; i < 512; i++)
+        	                DUMP_BYTES_BUFFER(" %02x", buf[i]);
+	                DUMP_BYTES_BUFFER("\n");
+        	        printk(KERN_ERR"82 - [0x%x], 85 -
[0x%x]\n",((unsigned short*)data_cmd)[82],((unsigned
short*)data_cmd)[85]);
+#endif
+			/* '6th' Bit in Word 85 Corresponds to Write Cache being Enabled/disabled*/
+                	wce_word = le16_to_cpu(((unsigned short*)data_cmd)[85]);
+	                if (wce_word & 0x20) {
+        	                sdkp->WCE = 1;
+                		sd_printk(KERN_NOTICE, sdkp, "Write Cache Enabled
after ATA_16 response\n");
+			} else
+				goto write_through;
+	        } else {
+write_through:
+	        	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+		        sdkp->WCE = 0;
+        	}
+	}
 	sdkp->RCD = 0;
 	sdkp->DPOFUA = 0;
 }
