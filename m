From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 3] sd: Export preferred I/O sizes
Date: Thu, 05 Jun 2008 01:22:52 -0400
Message-ID: <dba6ce5d97b8aa7d0e1c.1212643372@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <patchbomb.1212643369@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

1 file changed, 67 insertions(+)
drivers/scsi/sd.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++


Make storage devices that support the Block Limits VPD export the
optimal transfer length granularity and the optimal transfer length to
the block layer.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r c7132bad88f3 -r dba6ce5d97b8 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Thu Jun 05 01:07:51 2008 -0400
+++ b/drivers/scsi/sd.c	Thu Jun 05 01:07:51 2008 -0400
@@ -1534,6 +1534,72 @@
 	sdkp->DPOFUA = 0;
 }
 
+static int sd_vpd_inquiry(struct scsi_disk *sdkp, unsigned char *buffer, u8 page, u8 len)
+{
+	int result;
+	unsigned char cmd[16];
+	struct scsi_sense_hdr sshdr;
+
+	memset(cmd, 0, 16);
+	cmd[0] = INQUIRY;
+	cmd[1] = 1;		/* EVPD */
+	cmd[2] = page;		/* VPD page */
+	cmd[3] = len;
+	
+	result = scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer,
+				  len, &sshdr, SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (media_not_present(sdkp, &sshdr))
+		return -EIO;
+
+	if (result) {
+		sd_printk(KERN_ERR, sdkp, "EVPD Inquiry failed\n");
+		return -EIO;
+	}
+
+	if (buffer[1] != page) {
+		sd_printk(KERN_ERR, sdkp, "Page code not %2x (%2x)\n", page,
+			  buffer[1]);
+		return -EIO;
+	}
+
+	return buffer[3];
+}
+
+/**
+ * sd_block_limits - Query disk device for preferred I/O sizes.
+ * @disk: disk to query
+ * @buffer: temporary buffer to store inquiry response in
+ */
+static void sd_block_limits(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	int result, i, bl_found;
+
+	bl_found = 0;
+	result = sd_vpd_inquiry(sdkp, buffer, 0x0, 32); /* Supported Pages list */
+
+	if (result < 0 || buffer[4] != 0)
+		return;
+
+	for (i = 0 ; i < buffer[3] ; i++)
+		if (buffer[4+i] == 0xb0)
+			bl_found = 1;
+
+	if (bl_found == 0)
+		return;
+
+	result = sd_vpd_inquiry(sdkp, buffer, 0xb0, 16); /* Block Limits VPD */
+
+	if (result < 0 || buffer[3] != 12)
+		return;
+
+	disk_set_io_hints(sdkp->disk, 0, ((buffer[6] << 8) | buffer[7])
+			  * sdkp->device->sector_size,
+			  ((buffer[12] << 24) | (buffer[13] << 16)
+			   | (buffer[14] << 8) | buffer[15])
+			  * sdkp->device->sector_size);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -1579,6 +1645,7 @@
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_block_limits(sdkp, buffer);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 	}


