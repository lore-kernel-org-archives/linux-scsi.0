From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/10] mpt3sas: implement _dechain_st()
Date: Tue, 31 Jan 2017 10:25:53 +0100
Message-ID: <1485854760-122683-4-git-send-email-hare@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46417 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750906AbdAaJ0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:26:16 -0500
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Split off _dechain_st() as separate function.
No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 09d0008..120b317 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2365,6 +2365,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	return smid;
 }
 
+static void
+_dechain_st(struct MPT3SAS_ADAPTER *ioc, struct scsiio_tracker *st)
+{
+	struct chain_tracker *chain_req;
+
+	while (!list_empty(&st->chain_list)) {
+		chain_req = list_first_entry(&st->chain_list,
+					     struct chain_tracker,
+					     tracker_list);
+		list_move(&chain_req->tracker_list, &ioc->free_chain_list);
+	}
+}
+
 /**
  * mpt3sas_base_free_smid - put smid back on free_list
  * @ioc: per adapter object
@@ -2377,20 +2390,12 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 {
 	unsigned long flags;
 	int i;
-	struct chain_tracker *chain_req, *next;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (smid < ioc->hi_priority_smid) {
 		/* scsiio queue */
 		i = smid - 1;
-		if (!list_empty(&ioc->scsi_lookup[i].chain_list)) {
-			list_for_each_entry_safe(chain_req, next,
-			    &ioc->scsi_lookup[i].chain_list, tracker_list) {
-				list_del_init(&chain_req->tracker_list);
-				list_add(&chain_req->tracker_list,
-				    &ioc->free_chain_list);
-			}
-		}
+		_dechain_st(ioc, &ioc->scsi_lookup[i]);
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-- 
1.8.5.6

