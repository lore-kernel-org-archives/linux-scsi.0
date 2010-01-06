From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/3] be2iscsi: Fixing Bug for multiple SGEs
Date: Thu, 7 Jan 2010 01:50:19 +0530
Message-ID: <20100106202008.GA19910@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:26844 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932498Ab0AFUTz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 15:19:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  The patch fixes a but where the sg_next is not assigned and hence
the first sge was being resused wrongly

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9fc4446..d611a13 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1711,7 +1711,8 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 				      io_task->bhs_pa.u.a32.address_hi);
 
 	l_sg = sg;
-	for (index = 0; (index < num_sg) && (index < 2); index++, sg_next(sg)) {
+	for (index = 0; (index < num_sg) && (index < 2); index++,
+							 sg = sg_next(sg)) {
 		if (index == 0) {
 			sg_len = sg_dma_len(sg);
 			addr = (u64) sg_dma_address(sg);
@@ -1755,7 +1756,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 	psgl++;
 	psgl++;
 	offset = 0;
-	for (index = 0; index < num_sg; index++, sg_next(sg), psgl++) {
+	for (index = 0; index < num_sg; index++, sg = sg_next(sg), psgl++) {
 		sg_len = sg_dma_len(sg);
 		addr = (u64) sg_dma_address(sg);
 		AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
-- 
1.6.4

