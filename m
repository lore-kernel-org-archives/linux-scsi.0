From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: tie driver to the major number of the sequencer
	firmware
Date: Thu, 15 Feb 2007 15:25:35 -0600
Message-ID: <1171574735.3412.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59578 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161361AbXBOVZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 16:25:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, "Tan, Dennis" <Dennis_Tan@adaptec.com>

The sequencer firmware file has both a string (currently showing
V17/10c6) and a number (currently set to 1.1).  It has become apparent
that Adaptec may issue sequencer firmware in the future which could be
incompatible with the current driver.  Therefore, the driver will be
tied to the particular major number of the firmware (i.e. the current
driver will load any 1.x firmware).  Additionally, the driver will print
out both the ascii string and the major number, so with this pach the
current firmware will print out

aic94xx: Found sequencer firmware version 1.1 (V17/10c6)

James

diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 2768fe4..6c63b66 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -44,7 +44,6 @@
 #define PAUSE_TRIES 1000
 
 static const struct firmware *sequencer_fw;
-static const char *sequencer_version;
 static u16 cseq_vecs[CSEQ_NUM_VECS], lseq_vecs[LSEQ_NUM_VECS], mode2_task,
 	cseq_idle_loop, lseq_idle_loop;
 static u8 *cseq_code, *lseq_code;
@@ -1274,7 +1273,6 @@ static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 	header.csum = le32_to_cpu(hdr_ptr->csum);
 	header.major = le32_to_cpu(hdr_ptr->major);
 	header.minor = le32_to_cpu(hdr_ptr->minor);
-	sequencer_version = hdr_ptr->version;
 	header.cseq_table_offset = le32_to_cpu(hdr_ptr->cseq_table_offset);
 	header.cseq_table_size = le32_to_cpu(hdr_ptr->cseq_table_size);
 	header.lseq_table_offset = le32_to_cpu(hdr_ptr->lseq_table_offset);
@@ -1301,6 +1299,16 @@ static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 		return -EINVAL;
 	}
 
+	asd_printk("Found sequencer Firmware version %d.%d (%s)\n",
+		   header.major, header.minor, hdr_ptr->version);
+
+	if (header.major != SAS_RAZOR_SEQUENCER_FW_MAJOR) {
+		asd_printk("Firmware Major Version Mismatch;"
+			   "driver requires version %d.X",
+			   SAS_RAZOR_SEQUENCER_FW_MAJOR);
+		return -EINVAL;
+	}
+
 	ptr_cseq_vecs = (u16 *)&sequencer_fw->data[header.cseq_table_offset];
 	ptr_lseq_vecs = (u16 *)&sequencer_fw->data[header.lseq_table_offset];
 	mode2_task = header.mode2_task;
@@ -1333,7 +1341,6 @@ int asd_init_seqs(struct asd_ha_struct *asd_ha)
 		return err;
 	}
 
-	asd_printk("using sequencer %s\n", sequencer_version);
 	err = asd_seq_download_seqs(asd_ha);
 	if (err) {
 		asd_printk("couldn't download sequencers for %s\n",
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.h b/drivers/scsi/aic94xx/aic94xx_seq.h
index 9437ff0..2ea6a0d 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.h
+++ b/drivers/scsi/aic94xx/aic94xx_seq.h
@@ -31,6 +31,7 @@
 #define LSEQ_NUM_VECS	11
 
 #define SAS_RAZOR_SEQUENCER_FW_FILE "aic94xx-seq.fw"
+#define SAS_RAZOR_SEQUENCER_FW_MAJOR	1
 
 /* Note:  All quantites in the sequencer file are little endian */
 struct sequencer_file_header {



