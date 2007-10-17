From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 24/32] wd7000.c - proper fix for boards without sg support
Date: Wed, 17 Oct 2007 20:15:40 +0200
Message-ID: <4716514C.3050405@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12915 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755500AbXJQSQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:16:33 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - code used to set sg_tablesize to zero for board revision
    less than 6. This is no longer supported, therefore I
    use sg_tablesize=1 and open code the sg handling for that case.
  - Get rid of use of SG_NONE which will be removed soon.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/wd7000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 255c611..3887640 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1108,13 +1108,10 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 	scb->host = host;
 
 	nseg = scsi_sg_count(SCpnt);
-	if (nseg) {
+	if (nseg > 1) {
 		struct scatterlist *sg;
 		unsigned i;
 
-		if (SCpnt->device->host->sg_tablesize == SG_NONE) {
-			panic("wd7000_queuecommand: scatter/gather not supported.\n");
-		}
 		dprintk("Using scatter/gather with %d elements.\n", nseg);
 
 		sgb = scb->sgb;
@@ -1128,7 +1125,10 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 		}
 	} else {
 		scb->op = 0;
-		any2scsi(scb->dataptr, isa_virt_to_bus(scsi_sglist(SCpnt)));
+		if (nseg) {
+			struct scatterlist *sg = scsi_sglist(SCpnt);
+			any2scsi(scb->dataptr, isa_page_to_bus(sg->page) + sg->offset);
+		}
 		any2scsi(scb->maxlen, scsi_bufflen(SCpnt));
 	}
 
@@ -1524,7 +1524,7 @@ static __init int wd7000_detect(struct scsi_host_template *tpnt)
 				 *  For boards before rev 6.0, scatter/gather isn't supported.
 				 */
 				if (host->rev1 < 6)
-					sh->sg_tablesize = SG_NONE;
+					sh->sg_tablesize = 1;
 
 				present++;	/* count it */
 
-- 
1.5.3.1


