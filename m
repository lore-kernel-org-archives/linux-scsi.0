From: James Smart <James.Smart@Emulex.Com>
Subject: [REPOST]	[PATCH] fc transport: bug fix: correct references
Date: Mon, 26 Jun 2006 14:19:59 -0400
Message-ID: <1151345999.5883.9.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51937 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932608AbWFZSUA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 14:20:00 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k5QIJwZ9011248
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2006 11:19:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Original post was incorrect as it didn't realize that we already had
a self-referenc due to device_initialize(), and we were really only 
missing the put on our own reference. This was hidden by the other bug
which had the midlayer reusing stargets after they were already free,
which was doing too many puts on our rport.

Updating FC transport for:
- Add put in fc_rport_final_delete(), to release the rport.
  Prior, we were leaving the rport with a reference, thus the shost
  with references, etc. If the driver was unloaded, shosts and rports
  remained, along with work threads, etc
- Fix fc_rport_create failure path - too many put's on parent
- Add commenting to easily track ref taking.

-- james s

Original Post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115039021604020&w=2


Signed-off-by: James Smart <james.smart@emulex.com>

diff -upNr a/drivers/scsi/scsi_transport_fc.c
b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-06-14 11:37:09.000000000
-0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-06-26 14:06:17.000000000
-0400
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
-	device_initialize(dev);
-	dev->parent = get_device(&shost->shost_gendev);
+	device_initialize(dev);			/* takes self reference */
+	dev->parent = get_device(&shost->shost_gendev); /* parent reference */
 	dev->release = fc_rport_dev_release;
 	sprintf(dev->bus_id, "rport-%d:%d-%d",
 		shost->host_no, channel, rport->number);
@@ -1567,10 +1568,9 @@ fc_rport_create(struct Scsi_Host *shost,
 
 delete_rport:
 	transport_destroy_device(dev);
-	put_device(dev->parent);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_del(&rport->peers);
-	put_device(&shost->shost_gendev);
+	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev->parent);
 	kfree(rport);


