From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 7/7] scsi: mac_scsi: Treat Last Byte Sent time-out as failure
Date: Sun, 02 Jun 2019 11:24:12 +1000
Message-ID: <6249ead35826f734592db83d7073c6247d6af793.1559438652.git.fthain@telegraphics.com.au>
References: <cover.1559438652.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1559438652.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A system bus error during a PDMA send operation can result in bytes being
lost. Theoretically that could cause the target to remain in DATA OUT
phase and the initiator (expecting a phase change) would time-out waiting
for the Last Byte Sent flag. Should that happen, fail the transfer so the
core driver will stop using PDMA with this target.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2e503f06ac99..68d4665112b5 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -188,9 +188,12 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 		if (hostdata->pdma_residual == 0) {
 			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 			                          TCR_LAST_BYTE_SENT,
-			                          TCR_LAST_BYTE_SENT, HZ / 64) < 0)
+			                          TCR_LAST_BYTE_SENT,
+			                          HZ / 64) < 0) {
 				scmd_printk(KERN_ERR, hostdata->connected,
 				            "%s: Last Byte Sent timeout\n", __func__);
+				result = -1;
+			}
 			goto out;
 		}
 
-- 
2.21.0
