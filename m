From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Quiesce warning if device does not report optimal I/O size
Date: Wed, 27 Mar 2019 12:11:52 -0400
Message-ID: <20190327161152.23401-1-martin.petersen@oracle.com>
References: <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hussam Al-Tayeb <ht990332@gmx.com>, Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit a83da8a4509d ("scsi: sd: Optimal I/O size should be a multiple
of physical block size") split one conditional into several separate
statements in an effort to provide more accurate warning messages when
a device reports a nonsensical value. However, this reorganization
accidentally dropped the precondition of the reported value being
larger than zero. This lead to a warning getting emitted on devices
that do not report an optimal I/O size at all.

Remain silent if a device does not report an optimal I/O size.

Fixes: a83da8a4509d ("scsi: sd: Optimal I/O size should be a multiple of physical block size")
Reported-by: Hussam Al-Tayeb <ht990332@gmx.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9d8e15d03d2b..87d542de2db7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3074,6 +3074,9 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	unsigned int opt_xfer_bytes =
 		logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 
+	if (sdkp->opt_xfer_blocks == 0)
+		return false;
+
 	if (sdkp->opt_xfer_blocks > dev_max) {
 		sd_first_printk(KERN_WARNING, sdkp,
 				"Optimal transfer size %u logical blocks " \
-- 
2.21.0
