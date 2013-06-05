From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Check if the device support WRITE_SAME_10
Date: Wed, 05 Jun 2013 15:14:40 -0400
Message-ID: <yq1r4ggpdy7.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
	<51AD2485.9000601@zytor.com>
	<alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
	<51AF0CCF.8000909@itwm.fraunhofer.de>
	<51AF232C.8060209@itwm.fraunhofer.de>
	<51AF34E0.3030609@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AF34E0.3030609@itwm.fraunhofer.de> (Bernd Schubert's message
	of "Wed, 05 Jun 2013 14:53:52 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:

Bernd> The md layer currently cannot handle failed WRITE_SAME commands
Bernd> and the initial easiest fix is to check if the device supports
Bernd> WRITE_SAME at all. It already tested for WRITE_SAME_16 and this
Bernd> commit adds a test for WRITE_SAME_10.

No go. That'll disable WRITE SAME for drives which don't support
RSOC. Which means almost all of them.

I propose the following...

-- 
Martin K. Petersen	Oracle Linux Engineering


[PATCH] sd: Update WRITE SAME heuristics

SATA drives located behind a SAS controller would incorrectly receive
WRITE SAME commands. Tweak the heuristics so that:

 - If REPORT SUPPORTED OPERATION CODES is provided we will use that to
   choose between WRITE SAME(16), WRITE SAME(10) and disabled. This also
   fixes an issue with the old code which would issue WRITE SAME(10)
   despite the command not being whitelisted in REPORT SUPPORTED
   OPERATION CODES.

 - If REPORT SUPPORTED OPERATION CODES is not provided we will fall back
   to WRITE SAME(10) unless the device has an ATA Information VPD page.
   The assumption is that a SATL which is smart enough to implement
   WRITE SAME would also provide REPORT SUPPORTED OPERATION CODES.

To facilitate the new heuristics scsi_report_opcode() has been modified
to so we can distinguish between "operation not supported" and "RSOC not
supported".

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2c0d0ec..3b1ea34 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1070,8 +1070,8 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
  * @opcode:	opcode for command to look up
  *
  * Uses the REPORT SUPPORTED OPERATION CODES to look up the given
- * opcode. Returns 0 if RSOC fails or if the command opcode is
- * unsupported. Returns 1 if the device claims to support the command.
+ * opcode. Returns -EINVAL if RSOC fails, 0 if the command opcode is
+ * unsupported and 1 if the device claims to support the command.
  */
 int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 		       unsigned int len, unsigned char opcode)
@@ -1081,7 +1081,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	int result;
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
-		return 0;
+		return -EINVAL;
 
 	memset(cmd, 0, 16);
 	cmd[0] = MAINTENANCE_IN;
@@ -1097,7 +1097,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	if (result && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
-		return 0;
+		return -EINVAL;
 
 	if ((buffer[1] & 3) == 3) /* Command supported */
 		return 1;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a37eda9..366b661 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -442,8 +442,15 @@ sd_store_write_same_blocks(struct device *dev, struct device_attribute *attr,
 
 	if (max == 0)
 		sdp->no_write_same = 1;
-	else if (max <= SD_MAX_WS16_BLOCKS)
-		sdkp->max_ws_blocks = max;
+	else
+		sdp->no_write_same = 0;
+
+	if (sdkp->ws16)
+		sdkp->max_ws_blocks =
+			max_t(unsigned long, max, SD_MAX_WS16_BLOCKS);
+	else
+		sdkp->max_ws_blocks =
+			max_t(unsigned long, max, SD_MAX_WS10_BLOCKS);
 
 	sd_config_write_same(sdkp);
 
@@ -762,16 +769,16 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	 * blocks per I/O unless the device explicitly advertises a
 	 * bigger limit.
 	 */
-	if (sdkp->max_ws_blocks == 0)
-		sdkp->max_ws_blocks = SD_MAX_WS10_BLOCKS;
-
-	if (sdkp->ws16 || sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
+	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
 		blocks = min_not_zero(sdkp->max_ws_blocks,
 				      (u32)SD_MAX_WS16_BLOCKS);
 	else
 		blocks = min_not_zero(sdkp->max_ws_blocks,
 				      (u32)SD_MAX_WS10_BLOCKS);
 
+	if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
+		sdkp->max_ws_blocks = blocks;
+
 out:
 	blk_queue_max_write_same_sectors(q, blocks * (logical_block_size >> 9));
 }
@@ -2645,9 +2652,24 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 
 static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
-	if (scsi_report_opcode(sdkp->device, buffer, SD_BUF_SIZE,
-			       WRITE_SAME_16))
+	struct scsi_device *sdev = sdkp->device;
+
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+		sdev->no_report_opcodes = 1;
+
+		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
+		 * CODES is unsupported and the device has an ATA
+		 * Information VPD page (SAT).
+		 */
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
+			sdev->no_write_same = 1;
+	}
+
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
 		sdkp->ws16 = 1;
+
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
+		sdkp->ws10 = 1;
 }
 
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2386aeb..7a049de 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -84,6 +84,7 @@ struct scsi_disk {
 	unsigned	lbpws : 1;
 	unsigned	lbpws10 : 1;
 	unsigned	lbpvpd : 1;
+	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
