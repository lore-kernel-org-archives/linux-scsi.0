From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] ibmvstgt: set up scsi_host properly before __scsi_alloc_queue
Date: Sat,  1 Mar 2008 15:36:34 +0900
Message-ID: <1204353397-29855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204353397-29855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35759 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYCAGha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Mar 2008 01:37:30 -0500
In-Reply-To: <1204353397-29855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Before calling __scsi_alloc_queue, scsi_host->shost_gendev.parent must
be initialized properly.

This patch moves __scsi_alloc_queue after scsi_add_host (like
initiator drivers do).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index bd62131..429bf53 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -838,9 +838,6 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (!shost)
 		goto free_vport;
 	shost->transportt = ibmvstgt_transport_template;
-	err = scsi_tgt_alloc_queue(shost);
-	if (err)
-		goto put_host;
 
 	target = host_to_srp_target(shost);
 	target->shost = shost;
@@ -872,6 +869,10 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (err)
 		goto destroy_queue;
 
+	err = scsi_tgt_alloc_queue(shost);
+	if (err)
+		goto destroy_queue;
+
 	return 0;
 destroy_queue:
 	crq_queue_destroy(target);
-- 
1.5.3.7

