From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [Resend 02/11] mpt3sas: use list_splice_init()
Date: Thu,  4 Jan 2018 04:57:02 -0800
Message-ID: <1515070631-14740-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1515070631-14740-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33442 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbeADM5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 07:57:38 -0500
Received: by mail-qk0-f194.google.com with SMTP id x7so1786080qkb.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jan 2018 04:57:38 -0800 (PST)
In-Reply-To: <1515070631-14740-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

Use 'list_splice_init()' instead of hand-crafted function.
No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e3857e5..464a11e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2885,20 +2885,13 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
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
+		list_splice_init(&ioc->scsi_lookup[i].chain_list,
+				 &ioc->free_chain_list);
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-- 
2.5.5
