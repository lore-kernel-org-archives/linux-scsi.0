From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 17/20] [SCSI] mpt3sas: Use  alloc_ordered_workqueue() API instead of create_singlethread_workqueue() API
Date: Tue, 30 Jun 2015 12:25:03 +0530
Message-ID: <1435647306-36956-18-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36288 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbbF3G4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:56:38 -0400
Received: by paceq1 with SMTP id eq1so631015pac.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:56:37 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Created a thread using alloc_ordered_workqueue() API in order to process
the works from firmware Work-queue sequentially instead of
create_singlethread_workqueue() API.

Changes in v1:
    No need to check for backport compatibility in the upstream kernel.
so removing the else section where driver use
create_singlethread_workqueue() API if alloc_ordered_workqueue() API is
not defined, This else section is not required since in the latest upstream
kernel this alloc_ordered_workqueue() API is always defined.

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 49c412b..a136ec8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8024,8 +8024,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

