From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 05/12] scsi/ncr5380: Increase register polling limit
Date: Mon, 10 Oct 2016 00:46:52 -0400 (EDT)
Message-ID: <aee781fefa4fa431cc9664675715ae9c7fcd72ef.1476051962.git.fthain@telegraphics.com.au>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476051961.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If NCR5380_poll_politely() is called under irq lock, the polling time
limit is clamped to avoid a spike in interrupt latency. When not under
irq lock, the same polling time limit acts as the worst case delay
between schedule() calls.

During PDMA (under irq lock) I've found that the 10 ms time limit is
sometimes too short, and leads to the error message,
sd 0:0:0:0: [sda] tag#1 macscsi_pread: !REQ and !ACK

This particular target identifies itself as a QUANTUM DAYTONA514S. It
seems to be slower to assert ACK than the other targets I've tested.
This patch solves the problem by increasing the polling timeout.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
When irqs are disabled, this change will make no difference unless the
driver or target happens to suffer from timeout errors. In the irqs
enabled case, this patch may delay the next call to schedule() by an
additional 5 ms (in all 5380 drivers). Normally that would only happen
for a target selection timeout during a SCSI bus scan, which should not
bother anyone too much.
---
 drivers/scsi/NCR5380.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index cbb29d6..f0eea44 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -253,7 +253,7 @@ struct NCR5380_cmd {
 #define NCR5380_PIO_CHUNK_SIZE		256
 
 /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
-#define NCR5380_REG_POLL_TIME		10
+#define NCR5380_REG_POLL_TIME		15
 
 static inline struct scsi_cmnd *NCR5380_to_scmd(struct NCR5380_cmd *ncmd_ptr)
 {
-- 
2.7.3
