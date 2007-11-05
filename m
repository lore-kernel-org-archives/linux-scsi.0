From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] wd7000.c - proper fix for boards without sg support
Date: Mon, 05 Nov 2007 11:21:40 +0200
Message-ID: <472EE0A4.8080007@panasas.com>
References: <47276EB9.7070603@panasas.com> <1194118892.4230.1.camel@localhost.localdomain> <472EDDC9.6020109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8907 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751419AbXKEJVo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 04:21:44 -0500
In-Reply-To: <472EDDC9.6020109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  - code used to set sg_tablesize to zero for board revision
    less than 6. This is no longer supported, therefore I
    use sg_tablesize=1 and open code the sg handling for that case.
  - Get rid of use of SG_NONE which will be removed soon.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/wd7000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 03cd44f..b4304ae 100644
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
+			any2scsi(scb->dataptr, isa_page_to_bus(sg_page(sg)) + sg->offset);
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

