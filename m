From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvstgt: move crq_queue_create at the end of
 initialization
Date: Fri, 5 Dec 2008 22:26:04 +0900
Message-ID: <20081205222558G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42664 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbYLEN0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 08:26:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: olh@suse.de, linux-scsi@vger.kernel.org

James,

Can you apply this to scsi-rc-fixes (this also need to go stable
trees)?

This fixes the following oops:

http://marc.info/?l=linux-scsi&m=122831634910153&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvstgt: move crq_queue_create at the end of initialization

Calling crq_queue_create creates rports. We need to set up everything
before creating a rport. This moves crq_queue_create at the end of
initialization to avoid a race.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Olaf Hering <olh@suse.de>
Tested-by: Olaf Hering <olh@suse.de>
Cc: stable@kernel.org
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2a5b29d..8dcb59e 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -864,21 +864,19 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = crq_queue_create(&vport->crq_queue, target);
+	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto free_srp_target;
 
-	err = scsi_add_host(shost, target->dev);
+	err = scsi_tgt_alloc_queue(shost);
 	if (err)
-		goto destroy_queue;
+		goto free_srp_target;
 
-	err = scsi_tgt_alloc_queue(shost);
+	err = crq_queue_create(&vport->crq_queue, target);
 	if (err)
-		goto destroy_queue;
+		goto free_srp_target;
 
 	return 0;
-destroy_queue:
-	crq_queue_destroy(target);
 free_srp_target:
 	srp_target_free(target);
 put_host:
-- 
1.5.6.5

