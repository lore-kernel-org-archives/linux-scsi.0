From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_transport_fc: return -EBUSY for deleted vport
Date: Mon, 24 Jul 2017 12:09:36 +0200
Message-ID: <1500890976-7992-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752262AbdGXKJn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 06:09:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When trying to delete a vport via 'vport_delete' sysfs attribute
we should be checking if the port is already in state VPORT_DELETING;
if so there's no need to do anything.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 6dd0922..ec9837e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1286,7 +1286,7 @@ static FC_DEVICE_ATTR(vport, symbolic_name, S_IRUGO | S_IWUSR,
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)) {
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING | FC_VPORT_DELETING)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return -EBUSY;
 	}
@@ -2430,8 +2430,10 @@ void fc_release_transport(struct scsi_transport_template *t)
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	/* Remove any vports */
-	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers)
+	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
+		vport->flags |= FC_VPORT_DELETING;
 		fc_queue_work(shost, &vport->vport_delete_work);
+	}
 
 	/* Remove any remote ports */
 	list_for_each_entry_safe(rport, next_rport,
-- 
1.8.5.6
