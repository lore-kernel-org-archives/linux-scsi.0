From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: sd: Optimal I/O size should be a multiple of physical block size
Date: Tue, 12 Feb 2019 16:21:05 -0500
Message-ID: <20190212212105.17522-1-martin.petersen@oracle.com>
References: <20190212080409.GB10547@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190212080409.GB10547@infradead.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It was reported that some devices report an OPTIMAL TRANSFER LENGTH of
0xFFFF blocks. That looks bogus, especially for a device with a
4096-byte physical block size.

Ignore OPTIMAL TRANSFER LENGTH if it is not a multiple of the device's
reported physical block size.

To make the sanity checking conditionals more readable--and to
facilitate printing warnings--relocate the checking to a helper
function. No functional change aside from the printks.

Cc: <stable@vger.kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199759
Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

v2:
	- Added warnings as requested by hch
	- Moved the checks to a helper function

Before:

NAME ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED      RQ-SIZE  RA WSAME
sda          0   4096 33553920    4096     512    0 mq-deadline    256 128   32M

After:

NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE   RA WSAME
sda          0   4096      0    4096     512    0 mq-deadline     256 4096   32M
---
 drivers/scsi/sd.c | 59 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9aa409b38765..5dfe37b08d3b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3048,6 +3048,55 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->security = 1;
 }
 
+/*
+ * Determine the device's preferred I/O size for reads and writes
+ * unless the reported value is unreasonably small, large, not a
+ * multiple of the physical block size, or simply garbage.
+ */
+static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
+				      unsigned int dev_max)
+{
+	struct scsi_device *sdp = sdkp->device;
+	unsigned int opt_xfer_bytes =
+		logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
+
+	if (sdkp->opt_xfer_blocks > dev_max) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Optimal transfer size %u logical blocks " \
+				"> dev_max (%u logical blocks)\n",
+				sdkp->opt_xfer_blocks, dev_max);
+		return false;
+	}
+
+	if (sdkp->opt_xfer_blocks > SD_DEF_XFER_BLOCKS) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Optimal transfer size %u logical blocks " \
+				"> sd driver limit (%u logical blocks)\n",
+				sdkp->opt_xfer_blocks, SD_DEF_XFER_BLOCKS);
+		return false;
+	}
+
+	if (opt_xfer_bytes < PAGE_SIZE) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Optimal transfer size %u bytes < " \
+				"PAGE_SIZE (%u bytes)\n",
+				opt_xfer_bytes, (unsigned int)PAGE_SIZE);
+		return false;
+	}
+
+	if (opt_xfer_bytes & (sdkp->physical_block_size - 1)) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Optimal transfer size %u bytes not a " \
+				"multiple of physical block size (%u bytes)\n",
+				opt_xfer_bytes, sdkp->physical_block_size);
+		return false;
+	}
+
+	sd_first_printk(KERN_INFO, sdkp, "Optimal transfer size %u bytes\n",
+			opt_xfer_bytes);
+	return true;
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3117,15 +3166,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
 	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
-	/*
-	 * Determine the device's preferred I/O size for reads and writes
-	 * unless the reported value is unreasonably small, large, or
-	 * garbage.
-	 */
-	if (sdkp->opt_xfer_blocks &&
-	    sdkp->opt_xfer_blocks <= dev_max &&
-	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
-	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
+	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else
-- 
2.19.2
