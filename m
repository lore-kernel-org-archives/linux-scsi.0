From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 17/20 v1] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API instead of create_singlethread_workqueue() API
Date: Tue, 16 Jun 2015 11:07:07 +0530
Message-ID: <1434433027-40682-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de, joe.lawrence@stratus.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Created a thread using alloc_ordered_workqueue() API in order to process
the works from firmware Work-queue sequentially instead of
create_singlethread_workqueue() API.

Changes in v1:
    No need to check for backport compatibility in the upstream kernel.
so removing the else section where driver use 
create_singlethread_workqueue() API if alloc_ordered_workqueue() API is
not defined, This else section is not required since in the latest upstream
kernel this alloc_ordered_workqueue() API is always defined.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b848458..7e5926c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8085,8 +8085,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
 	    "fw_event%d", ioc->id);
-	ioc->firmware_event_thread = create_singlethread_workqueue(
-	    ioc->firmware_event_name);
+	ioc->firmware_event_thread = alloc_ordered_workqueue(
+	    ioc->firmware_event_name, WQ_MEM_RECLAIM);
 	if (!ioc->firmware_event_thread) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-- 
2.0.2
