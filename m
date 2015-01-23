From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 17/17] IB/srp: Detect bidi commands properly
Date: Fri, 23 Jan 2015 13:17:46 +0100
Message-ID: <54C23BEA.9050501@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:12848
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751856AbbAWMRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:17:53 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL. This allows
to simplify srp_unmap_data(). Fix the bidi test in srp_map_data().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Roland Dreier <roland@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0747c05..22b7529 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1063,9 +1063,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 	struct ib_device *ibdev = dev->dev;
 	int i, res;
 
-	if (!scsi_sglist(scmnd) ||
-	    (scmnd->sc_data_direction != DMA_TO_DEVICE &&
-	     scmnd->sc_data_direction != DMA_FROM_DEVICE))
+	if (!scsi_sglist(scmnd))
 		return;
 
 	if (dev->use_fast_reg) {
@@ -1524,11 +1522,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	if (!scsi_sglist(scmnd) || scmnd->sc_data_direction == DMA_NONE)
 		return sizeof (struct srp_cmd);
 
-	if (scmnd->sc_data_direction != DMA_FROM_DEVICE &&
-	    scmnd->sc_data_direction != DMA_TO_DEVICE) {
+	if (scsi_bidi_cmnd(scmnd)) {
 		shost_printk(KERN_WARNING, target->scsi_host,
-			     PFX "Unhandled data direction %d\n",
-			     scmnd->sc_data_direction);
+			     PFX "Bidi commands are not yet supported\n");
 		return -EINVAL;
 	}
 
-- 
2.1.2

