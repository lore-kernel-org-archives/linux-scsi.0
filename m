From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: [PATCH] scsi: sd: Fix cache_type_store()
Date: Sun, 23 Dec 2018 12:41:58 +0500
Message-ID: <20181223074158.22796-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Ivan Mironov <mironov.ivan@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Changing of caching mode via /sys/devices/.../scsi_disk/.../cache_type
may fail if device responses to MODE SENSE command with DPOFUA flag set,
and then checks this flag to be not set on MODE SELECT command.

When trying to change cache_type, write always fails:
	# echo "none" >cache_type
	bash: echo: write error: Invalid argument

And following appears in dmesg:
	[13007.865745] sd 1:0:1:0: [sda] Sense Key : Illegal Request [current]
	[13007.865753] sd 1:0:1:0: [sda] Add. Sense: Invalid field in parameter list

Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
---
 drivers/scsi/sd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd0a5c694a97..698fe651fb1a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -206,6 +206,21 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
 	buffer_data[0] &= ~0x80;
 
+	/* From SBC-4 r15, 6.5.1 "Mode pages overview", description of
+	 * DEVICE-SPECIFIC PARAMETER field in the mode parameter header:
+	 *     ...
+	 *     The write protect (WP) bit for mode data sent with a MODE SELECT
+	 *     command shall be ignored by the device server.
+	 *     ...
+	 *     The DPOFUA bit is reserved for mode data sent with a MODE SELECT
+	 *     command.
+	 *     ...
+	 * All other bits are also reserved, and all reserved bits shall be set
+	 * to zero according to the same document. So, we can simply set this
+	 * field to zero for compatibility.
+	 */
+	data.device_specific = 0;
+
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
 			     SD_MAX_RETRIES, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
-- 
2.20.1
