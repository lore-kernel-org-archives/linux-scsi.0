From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 6/9] zfcp: block queue limits with data router
Date: Fri, 26 Apr 2013 17:33:45 +0200
Message-ID: <517A9E59.5060806@linux.vnet.ibm.com>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com> <1366985635-38270-7-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1366985635-38270-7-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 86a9668a8d29ea711613e1cb37efa68e7c4db564
"[SCSI] zfcp: support for hardware data router"
reduced the initial block queue limits in the scsi_host_template to the
absolute minimum and adjusted them later on. However, the adjustment was
too late for the BSG devices of Scsi_Host and fc_host.

Therefore, ioctl(..., SG_IO, ...) with request or response size > 4kB to a
BSG device of an fc_host or a Scsi_Host fails with EINVAL. As a result,
users of such ioctl such as HBA_SendCTPassThru() in libzfcphbaapi return
with error HBA_STATUS_ERROR.

Initialize the block queue limits in zfcp_scsi_host_template to the
greatest common denominator (GCD).

While we cannot exploit the slightly enlarged maximum request size with
data router, this should be neglectible. Doing so also avoids running into
trouble after live guest relocation (LGR) / migration from a data router
FCP device to an FCP device that does not support data router. In that
case, zfcp would figure out the new limits on adapter recovery, but the
fc_host and Scsi_Host (plus in fact all sdevs) still exist with the old and
now too large queue limits.

It should also OK, not to use half the size as in the DIX case, because
fc_host and Scsi_Host do not transport FCP requests including SCSI commands
using protection data.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #3.2+
---
 drivers/s390/scsi/zfcp_scsi.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */

 #define KMSG_COMPONENT "zfcp"
@@ -311,8 +311,12 @@ static struct scsi_host_template zfcp_sc
 	.proc_name		 = "zfcp",
 	.can_queue		 = 4096,
 	.this_id		 = -1,
-	.sg_tablesize		 = 1, /* adjusted later */
-	.max_sectors		 = 8, /* adjusted later */
+	.sg_tablesize		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2),
+				   /* GCD, adjusted later */
+	.max_sectors		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2) * 8,
+				   /* GCD, adjusted later */
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = 1,
