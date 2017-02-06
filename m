From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 33/39] megaraid_sas: call flush_scheduled_work during controller shutdown/detach
Date: Mon,  6 Feb 2017 02:00:06 -0800
Message-ID: <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:34244 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdBFKDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:03:04 -0500
Received: by mail-pg0-f53.google.com with SMTP id 14so27441221pgg.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:59 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 04ef0a0..b29cfd3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6393,6 +6393,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
 		cancel_delayed_work_sync(&ev->hotplug_work);
+		flush_scheduled_work();
 		instance->ev = NULL;
 	}
 
@@ -6619,6 +6620,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
 		cancel_delayed_work_sync(&ev->hotplug_work);
+		flush_scheduled_work();
 		instance->ev = NULL;
 	}
 
-- 
2.8.3
