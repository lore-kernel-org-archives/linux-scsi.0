From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/2] scsi_transport_fc: Introduce scsi_host_{get,put}()
Date: Fri, 20 Nov 2015 13:33:04 -0800
Message-ID: <564F9190.5090103@sandisk.com>
References: <564F910E.9070306@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0099.outbound.protection.outlook.com ([207.46.100.99]:60285
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbbKTVdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 16:33:08 -0500
In-Reply-To: <564F910E.9070306@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

Use scsi_host_{get,put}() instead of open-coding these functions.
Compile-tested only.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@emulex.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/scsi/scsi_transport_fc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 24eaaf6..8a88226 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2586,7 +2586,7 @@ fc_rport_final_delete(struct work_struct *work)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
-	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	scsi_host_put(shost);			/* for fc_host->rport list */
 	put_device(dev);			/* for self-reference */
 }
 
@@ -2650,7 +2650,7 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 	else
 		rport->scsi_target_id = -1;
 	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	scsi_host_get(shost);			/* for fc_host->rport list */
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -2685,7 +2685,7 @@ delete_rport:
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_del(&rport->peers);
-	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	scsi_host_put(shost);			/* for fc_host->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev->parent);
 	kfree(rport);
@@ -3383,7 +3383,7 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	fc_host->npiv_vports_inuse++;
 	vport->number = fc_host->next_vport_number++;
 	list_add_tail(&vport->peers, &fc_host->vports);
-	get_device(&shost->shost_gendev);	/* for fc_host->vport list */
+	scsi_host_get(shost);			/* for fc_host->vport list */
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -3441,7 +3441,7 @@ delete_vport:
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_del(&vport->peers);
-	put_device(&shost->shost_gendev);	/* for fc_host->vport list */
+	scsi_host_put(shost);			/* for fc_host->vport list */
 	fc_host->npiv_vports_inuse--;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev->parent);
@@ -3504,7 +3504,7 @@ fc_vport_terminate(struct fc_vport *vport)
 		vport->flags |= FC_VPORT_DELETED;
 		list_del(&vport->peers);
 		fc_host->npiv_vports_inuse--;
-		put_device(&shost->shost_gendev);  /* for fc_host->vport list */
+		scsi_host_put(shost);		/* for fc_host->vport list */
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-- 
2.1.4

