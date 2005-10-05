From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata ATAPI command completion fixes and FIXMEs
Date: Wed, 05 Oct 2005 15:03:50 -0400
Message-ID: <43442396.1090308@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090604070406050600070606"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090604070406050600070606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Just checked this in:

Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Wed Oct 5 15:02:14 2005 -0400

   libata: ATAPI command completion tweaks and notes

   1) note urgent bug, that completes command twice

   2) only fix up INQUIRY data if the SCSI version is zero (typically
   indicates ATAPI MMC-ish device)

   3) if there is a problem on the ATA bus, don't bother with REQUEST
   SENSE, just directly handle the error based on Status/Error registers.

[patch attached]


--------------090604070406050600070606
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -1483,9 +1483,18 @@ static int atapi_qc_complete(struct ata_
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 
-	if (unlikely(drv_stat & (ATA_ERR | ATA_BUSY | ATA_DRQ))) {
+	if (unlikely(drv_stat & (ATA_BUSY | ATA_DRQ)))
+		ata_to_sense_error(qc, drv_stat);
+	else if (unlikely(drv_stat & ATA_ERR)) {
 		DPRINTK("request check condition\n");
 
+		/* FIXME: command completion with check condition
+		 * but no sense causes the error handler to run,
+		 * which then issues REQUEST SENSE, fills in the sense 
+		 * buffer, and completes the command (for the second
+		 * time).  We need to issue REQUEST SENSE some other
+		 * way, to avoid completing the command twice.
+		 */
 		cmd->result = SAM_STAT_CHECK_CONDITION;
 
 		qc->scsidone(cmd);
@@ -1499,10 +1508,26 @@ static int atapi_qc_complete(struct ata_
 			unsigned int buflen;
 
 			buflen = ata_scsi_rbuf_get(cmd, &buf);
-			buf[2] = 0x5;
-			buf[3] = (buf[3] & 0xf0) | 2;
+
+	/* ATAPI devices typically report zero for their SCSI version,
+	 * and sometimes deviate from the spec WRT response data
+	 * format.  If SCSI version is reported as zero like normal,
+	 * then we make the following fixups:  1) Fake MMC-5 version,
+	 * to indicate to the Linux scsi midlayer this is a modern
+	 * device.  2) Ensure response data format / ATAPI information
+	 * are always correct.
+	 */
+	/* FIXME: do we ever override EVPD pages and the like, with
+	 * this code?
+	 */
+			if (buf[2] == 0) {
+				buf[2] = 0x5;
+				buf[3] = 0x32;
+			}
+
 			ata_scsi_rbuf_put(cmd, buf);
 		}
+
 		cmd->result = SAM_STAT_GOOD;
 	}
 

--------------090604070406050600070606--
