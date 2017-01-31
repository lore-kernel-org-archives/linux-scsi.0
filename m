From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] mpt3sas: set default value for cb_idx
Date: Tue, 31 Jan 2017 10:25:52 +0100
Message-ID: <1485854760-122683-3-git-send-email-hare@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbdAaJ0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:26:15 -0500
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0185a8d..09d0008 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -873,7 +873,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	int i;
-	u8 cb_idx;
+	u8 cb_idx = 0xFF;
 
 	if (smid < ioc->hi_priority_smid) {
 		i = smid - 1;
@@ -884,8 +884,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	} else if (smid <= ioc->hba_queue_depth) {
 		i = smid - ioc->internal_smid;
 		cb_idx = ioc->internal_lookup[i].cb_idx;
-	} else
-		cb_idx = 0xFF;
+	}
 	return cb_idx;
 }
 
-- 
1.8.5.6

