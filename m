From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] use struct scsilun, and use u_char vs u8
Date: Wed, 12 Feb 2003 11:17:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212111734.A5248@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Hi -

This patch removes ScsiLun in favor of struct scsilun, and changes scsilun
to use a u_char instead of a u8 in include/scsi/scsi.h.

--- 1.28/drivers/scsi/scsi_debug.c	Tue Jan 28 08:15:52 2003
+++ edited/drivers/scsi/scsi_debug.c	Wed Feb 12 08:55:38 2003
@@ -771,7 +771,7 @@
 {
 	unsigned int alloc_len, lun_cnt, i;
 	int select_report = (int)cmd[2];
-	ScsiLun *one_lun;
+	struct scsilun *one_lun;
 
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
 	if ((alloc_len < 16) || (select_report > 2)) {
@@ -779,11 +779,11 @@
 		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if (bufflen > 3) {
-		lun_cnt = min((int)(bufflen / sizeof(ScsiLun)),
+		lun_cnt = min((int)(bufflen / sizeof(struct scsilun)),
 			      (int)scsi_debug_max_luns);
 		memset(buff, 0, bufflen);
 		buff[3] = 8 * lun_cnt;
-		one_lun = (ScsiLun*) &buff[0];
+		one_lun = (struct scsilun*) &buff[0];
 		for (i = 0; i < lun_cnt; i++)
 			one_lun[i].scsi_lun[1] = i;
 	}
===== drivers/scsi/scsi_scan.c 1.59 vs edited =====
--- 1.59/drivers/scsi/scsi_scan.c	Tue Feb 11 01:56:25 2003
+++ edited/drivers/scsi/scsi_scan.c	Wed Feb 12 08:56:42 2003
@@ -1458,25 +1458,25 @@
 
 #ifdef CONFIG_SCSI_REPORT_LUNS
 /**
- * scsilun_to_int: convert a ScsiLun to an int
- * @scsilun:	ScsiLun to be converted.
+ * scsilun_to_int: convert a scsilun to an int
+ * @scsilun:	scsilun to be converted.
  *
  * Description:
- *     Convert @scsilun from a ScsiLun to a four byte host byte-ordered
+ *     Convert @scsilun from a scsilun to a four byte host byte-ordered
  *     integer, and return the result. The caller must check for
  *     truncation before using this function.
  *
  * Notes:
- *     The ScsiLun is assumed to be four levels, with each level
+ *     The scsilun is assumed to be four levels, with each level
  *     effectively containing a SCSI byte-ordered (big endian) short; the
  *     addressing bits of each level are ignored (the highest two bits).
  *     For a description of the LUN format, post SCSI-3 see the SCSI
  *     Architecture Model, for SCSI-3 see the SCSI Controller Commands.
  *
- *     Given a ScsiLun of: 0a 04 0b 03 00 00 00 00, this function returns
+ *     Given a scsilun of: 0a 04 0b 03 00 00 00 00, this function returns
  *     the integer: 0x0b030a04
  **/
-static int scsilun_to_int(ScsiLun *scsilun)
+static int scsilun_to_int(struct scsilun *scsilun)
 {
 	int i;
 	unsigned int lun;
@@ -1515,7 +1515,7 @@
 	unsigned int lun;
 	unsigned int num_luns;
 	unsigned int retries;
-	ScsiLun *fcp_cur_lun, *lun_data;
+	struct scsilun *fcp_cur_lun, *lun_data;
 	Scsi_Request *sreq;
 	char *data;
 
@@ -1536,7 +1536,8 @@
 	sprintf(devname, "host %d channel %d id %d", sdev->host->host_no,
 		sdev->channel, sdev->id);
 	/*
-	 * Allocate enough to hold the header (the same size as one ScsiLun)
+	 * Allocate enough to hold the header (the same size as one
+	 * scsilun)
 	 * plus the max number of luns we are requesting.
 	 *
 	 * Reallocating and trying again (with the exact amount we need)
@@ -1545,8 +1546,8 @@
 	 * kmalloc - we don't want a kmalloc() failure of a huge value to
 	 * prevent us from finding any LUNs on this target.
 	 */
-	length = (max_scsi_report_luns + 1) * sizeof(ScsiLun);
-	lun_data = (ScsiLun *) kmalloc(length, GFP_ATOMIC |
+	length = (max_scsi_report_luns + 1) * sizeof(struct scsilun);
+	lun_data = (struct scsilun *) kmalloc(length, GFP_ATOMIC |
 					   (sdev->host->unchecked_isa_dma ?
 					    GFP_DMA : 0));
 	if (lun_data == NULL) {
@@ -1618,14 +1619,14 @@
 	data = (char *) lun_data->scsi_lun;
 	length = ((data[0] << 24) | (data[1] << 16) |
 		  (data[2] << 8) | (data[3] << 0));
-	if ((length / sizeof(ScsiLun)) > max_scsi_report_luns) {
+	if ((length / sizeof(struct scsilun)) > max_scsi_report_luns) {
 		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
 		       " of %d luns reported, try increasing"
 		       " max_scsi_report_luns.\n", devname,
-		       max_scsi_report_luns, length / sizeof(ScsiLun));
+		       max_scsi_report_luns, length / sizeof(struct scsilun));
 		num_luns = max_scsi_report_luns;
 	} else
-		num_luns = (length / sizeof(ScsiLun));
+		num_luns = (length / sizeof(struct scsilun));
 
 	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUN scan of"
 			" host %d channel %d id %d\n", sdev->host->host_no,
@@ -1652,7 +1653,7 @@
 			 */
 			printk(KERN_WARNING "scsi: %s lun 0x", devname);
 			data = (char *) fcp_cur_lun->scsi_lun;
-			for (i = 0; i < sizeof(ScsiLun); i++)
+			for (i = 0; i < sizeof(struct scsilun); i++)
 				printk("%02x", data[i]);
 			printk(" has a LUN larger than currently supported.\n");
 		} else if (lun == 0) {
===== include/scsi/scsi.h 1.9 vs edited =====
--- 1.9/include/scsi/scsi.h	Thu Jan 23 07:50:27 2003
+++ edited/include/scsi/scsi.h	Wed Feb 12 08:57:58 2003
@@ -198,11 +198,11 @@
 };
 
 /*
- * ScsiLun: 8 byte LUN.
+ * scsilun: 8 byte LUN.
  */
-typedef struct scsi_lun {
-	u8 scsi_lun[8];
-} ScsiLun;
+struct scsilun {
+	u_char scsi_lun[8];
+};
 
 /*
  *  MESSAGE CODES

-- Patrick Mansfield
