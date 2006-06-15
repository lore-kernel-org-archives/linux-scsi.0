From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc transport: bug fix: correct references
Date: Thu, 15 Jun 2006 12:47:45 -0400
Message-ID: <1150390065.29774.24.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53133 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030844AbWFOQsL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 12:48:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k5FGlrK1017319
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2006 09:48:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Updating the FC transport for the following:
- Take a self-reference on the rport. Prior, when the starget was removed,
  the ref count would hit zero and fc_rport_dev_release was called, which
  would free the rport. This left corrupt lists, etc...
  Symptoms of error is oops w/ either:
    "Badness in kref_get in lib/kref.c:32"
    "Unable to handle kernel paging request for data at address 0x00000010"
       from kref_get
- Fix fc_rport_create failure path - too many put's on parent
- Add commenting to easily track ref taking.

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>

diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-06-14 11:37:09.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-06-14 16:33:55.000000000 -0400
@@ -1077,7 +1077,7 @@ static int fc_target_match(struct attrib
 static void fc_rport_dev_release(struct device *dev)
 {
 	struct fc_rport *rport = dev_to_rport(dev);
-	put_device(dev->parent);
+	put_device(dev->parent);		/* for parent reference */
 	kfree(rport);
 }
 
@@ -1476,7 +1476,8 @@ fc_rport_final_delete(void *data)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
-	put_device(&shost->shost_gendev);
+	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	put_device(dev);			/* for self-reference */
 }
 
 
@@ -1537,13 +1538,13 @@ fc_rport_create(struct Scsi_Host *shost,
 	else
 		rport->scsi_target_id = -1;
 	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);
+	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	dev = &rport->dev;
 	device_initialize(dev);
-	dev->parent = get_device(&shost->shost_gendev);
+	dev->parent = get_device(&shost->shost_gendev); /* parent reference */
 	dev->release = fc_rport_dev_release;
 	sprintf(dev->bus_id, "rport-%d:%d-%d",
 		shost->host_no, channel, rport->number);
@@ -1554,6 +1555,9 @@ fc_rport_create(struct Scsi_Host *shost,
 		printk(KERN_ERR "FC Remote Port device_add failed\n");
 		goto delete_rport;
 	}
+	
+	get_device(dev);			/* for self-reference */
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
@@ -1567,12 +1571,11 @@ fc_rport_create(struct Scsi_Host *shost,
 
 delete_rport:
 	transport_destroy_device(dev);
-	put_device(dev->parent);
+	put_device(dev->parent);		/* for parent reference */
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_del(&rport->peers);
-	put_device(&shost->shost_gendev);
+	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev->parent);
 	kfree(rport);
 	return NULL;
 }


