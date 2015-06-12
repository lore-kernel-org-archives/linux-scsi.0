From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 17/20] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API instead of create_singlethread_workqueue() API
Date: Fri, 12 Jun 2015 15:12:29 +0530
Message-ID: <1434102153-38581-18-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:32824 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbbFLJoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 05:44:15 -0400
Received: by qcnj1 with SMTP id j1so8930953qcn.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 02:44:14 -0700 (PDT)
In-Reply-To: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Created a thread using alloc_ordered_workqueue() API in order to process
the works from firmware Work-queue sequentially instead of
create_singlethread_workqueue() API.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 837c22a..42bb731 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8024,8 +8024,13 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

