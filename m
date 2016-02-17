From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 1/2] mpt3sas: Deallocate resources before trying reallocation of the same in _base_allocate_memory_pools()
Date: Wed, 17 Feb 2016 16:55:25 +0530
Message-ID: <1455708326-7584-2-git-send-email-chaitra.basappa@broadcom.com>
References: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Deallocates resources before reallocating of the same in retry_allocation
path of _base_allocate_memory_pools()

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f59495b..60c2e86 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3124,8 +3124,10 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
 		ioc->scsi_lookup = NULL;
 	}
-	kfree(ioc->hpr_lookup);
-	kfree(ioc->internal_lookup);
+	if (ioc->hpr_lookup)
+		kfree(ioc->hpr_lookup);
+	if (ioc->internal_lookup)
+		kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
 		for (i = 0; i < ioc->chain_depth; i++) {
 			if (ioc->chain_lookup[i].chain_buffer)
@@ -3360,6 +3362,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 			goto out;
 		retry_sz += 64;
 		ioc->hba_queue_depth = max_request_credit - retry_sz;
+		_base_release_memory_pools(ioc);
 		goto retry_allocation;
 	}
 
-- 
1.8.3.1
