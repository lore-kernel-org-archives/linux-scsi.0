From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] fnic: remove redundant BUG_ONs and fix checks on unsigned
Date: Tue, 23 Jun 2009 01:06:40 +0200
Message-ID: <4A400E80.9020107@gmail.com>
References: <4A3FC55E.80108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:33842 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbZFVVGE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 17:06:04 -0400
Received: by ey-out-2122.google.com with SMTP id d26so506472eyd.37
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2009 14:06:05 -0700 (PDT)
In-Reply-To: <4A3FC55E.80108@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: abjoglek@cisco.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Andrew Morton <akpm@linux-foundation.org>

The shost sg tablesize is set to FNIC_MAX_SG_DESC_CNT and fnic uses
scsi_dma_map, so both BUG_ONs can be removed.

scsi_dma_map may return -ENOMEM, sg_count should be int to catch that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index eabf365..bfc9969 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -245,7 +245,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					  struct vnic_wq_copy *wq,
 					  struct fnic_io_req *io_req,
 					  struct scsi_cmnd *sc,
-					  u32 sg_count)
+					  int sg_count)
 {
 	struct scatterlist *sg;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
@@ -260,9 +260,6 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	char msg[2];
 
 	if (sg_count) {
-		BUG_ON(sg_count < 0);
-		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
-
 		/* For each SGE, create a device desc entry */
 		desc = io_req->sgl_list;
 		for_each_sg(scsi_sglist(sc), sg, sg_count, i) {
@@ -344,7 +341,7 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	struct fnic *fnic;
 	struct vnic_wq_copy *wq;
 	int ret;
-	u32 sg_count;
+	int sg_count;
 	unsigned long flags;
 	unsigned long ptr;
 
