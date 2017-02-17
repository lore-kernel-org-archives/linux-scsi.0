From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 08/11] mpt3sas: always use smid 1 for ioctl passthrough
Date: Fri, 17 Feb 2017 09:23:07 +0100
Message-ID: <1487319790-97340-9-git-send-email-hare@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754542AbdBQIXX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:23:23 -0500
In-Reply-To: <1487319790-97340-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

ioctl passthrough commands require a SCSIIO smid, but cannot
easily integrate with the block layer. But as we're only ever
allowing one ioctl command at a time we can reserve smid 1
for ioctl commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9b7273b..dec86c4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2355,13 +2355,20 @@ struct scsiio_tracker *
 		return 0;
 	}
 
-	request = list_entry(ioc->free_list.next,
-	    struct scsiio_tracker, tracker_list);
-	request->scmd = scmd;
+	if (!scmd) {
+		/* ioctl command, always use the first slot */
+		request = ioc->lookup[0];
+		request->scmd = NULL;
+	} else {
+		request = list_entry(ioc->free_list.next,
+				     struct scsiio_tracker, tracker_list);
+		request->scmd = scmd;
+	}
 	request->cb_idx = cb_idx;
 	smid = request->smid;
 	request->msix_io = _base_get_msix_index(ioc);
-	list_del(&request->tracker_list);
+	if (scmd)
+		list_del(&request->tracker_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return smid;
 }
@@ -2429,7 +2436,9 @@ struct scsiio_tracker *
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
+		if (i > 0)
+			list_add(&ioc->scsi_lookup[i].tracker_list,
+				 &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 		_base_recovery_check(ioc);
@@ -5165,14 +5174,17 @@ struct scsiio_tracker *
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	INIT_LIST_HEAD(&ioc->free_list);
 	smid = 1;
-	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
+	for (i = 1; i < ioc->scsiio_depth; i++, smid++) {
 		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].smid = smid;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-		    &ioc->free_list);
+		if (i == 1)
+			INIT_LIST_HEAD(&ioc->lookup[i].tracker_list);
+		else
+			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+				      &ioc->free_list);
 	}
 
 	/* hi-priority queue */
-- 
1.8.5.6
