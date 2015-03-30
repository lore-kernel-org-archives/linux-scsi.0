From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 17/20] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API instead of create_singlethread_workqueue() API
Date: Mon, 30 Mar 2015 19:25:20 +0530
Message-ID: <1427723723-12676-18-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Created a thread using alloc_ordered_workqueue() API in order to process the works from firmware Work-queue sequentially instead of create_singlethread_workqueue() API.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 55f39f6..0070f78 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8070,8 +8070,13 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
 	    "fw_event%d", ioc->id);
-	ioc->firmware_event_thread = create_singlethread_workqueue(
+#if defined(alloc_ordered_workqueue)
+	ioc->firmware_event_thread = alloc_ordered_workqueue(
+		ioc->firmware_event_name, WQ_MEM_RECLAIM);
+#else
+		ioc->firmware_event_thread = create_singlethread_workqueue(
 	    ioc->firmware_event_name);
+#endif
 	if (!ioc->firmware_event_thread) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-- 
2.0.2
