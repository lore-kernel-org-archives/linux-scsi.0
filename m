From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd workqueue
Date: Mon,  3 Jan 2011 14:49:40 +0100
Message-ID: <1294062595-30097-18-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab1ACNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2011 08:50:35 -0500
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

The target driver is not in the memory reclaim path and doesn't need a
dedicated workqueue.  Drop vtgtd and use system_wq instead.  The used
work item is sync flushed on removal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/scsi/ibmvscsi/ibmvstgt.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2256bab..47fc632 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -74,7 +74,6 @@ struct vio_port {
 	struct srp_rport *rport;
 };
 
-static struct workqueue_struct *vtgtd;
 static struct scsi_transport_template *ibmvstgt_transport_template;
 
 /*
@@ -546,7 +545,7 @@ static irqreturn_t ibmvstgt_interrupt(int dummy, void *data)
 	struct vio_port *vport = target_to_port(target);
 
 	vio_disable_interrupts(vport->dma_dev);
-	queue_work(vtgtd, &vport->crq_work);
+	schedule_work(&vport->crq_work);
 
 	return IRQ_HANDLED;
 }
@@ -900,6 +899,7 @@ static int ibmvstgt_remove(struct vio_dev *dev)
 	crq_queue_destroy(target);
 	srp_remove_host(shost);
 	scsi_remove_host(shost);
+	flush_work_sync(&vport->crq_work);
 	scsi_tgt_free_queue(shost);
 	srp_target_free(target);
 	kfree(vport);
@@ -967,21 +967,15 @@ static int __init ibmvstgt_init(void)
 	if (!ibmvstgt_transport_template)
 		return err;
 
-	vtgtd = create_workqueue("ibmvtgtd");
-	if (!vtgtd)
-		goto release_transport;
-
 	err = get_system_info();
 	if (err)
-		goto destroy_wq;
+		goto release_transport;
 
 	err = vio_register_driver(&ibmvstgt_driver);
 	if (err)
-		goto destroy_wq;
+		goto release_transport;
 
 	return 0;
-destroy_wq:
-	destroy_workqueue(vtgtd);
 release_transport:
 	srp_release_transport(ibmvstgt_transport_template);
 	return err;
@@ -991,7 +985,6 @@ static void __exit ibmvstgt_exit(void)
 {
 	printk("Unregister IBM virtual SCSI driver\n");
 
-	destroy_workqueue(vtgtd);
 	vio_unregister_driver(&ibmvstgt_driver);
 	srp_release_transport(ibmvstgt_transport_template);
 }
-- 
1.7.1

