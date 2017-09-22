From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 05/13] scsi: arcmsr: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:37 +0530
Message-ID: <1506073905-12985-6-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35108 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdIVJwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:18 -0400
Received: by mail-pf0-f195.google.com with SMTP id i23so268349pfi.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:18 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index af032c4..a54b6c1 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -837,10 +837,9 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
 	acb->fw_flag = FW_NORMAL;
-	init_timer(&acb->eternal_timer);
+	setup_timer(&acb->eternal_timer, &arcmsr_request_device_map,
+		    (unsigned long)acb);
 	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-	acb->eternal_timer.data = (unsigned long) acb;
-	acb->eternal_timer.function = &arcmsr_request_device_map;
 	add_timer(&acb->eternal_timer);
 	if(arcmsr_alloc_sysfs_attr(acb))
 		goto out_free_sysfs;
@@ -930,10 +929,9 @@ static int arcmsr_resume(struct pci_dev *pdev)
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
 	acb->fw_flag = FW_NORMAL;
-	init_timer(&acb->eternal_timer);
+	setup_timer(&acb->eternal_timer, &arcmsr_request_device_map,
+		    (unsigned long)acb);
 	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-	acb->eternal_timer.data = (unsigned long) acb;
-	acb->eternal_timer.function = &arcmsr_request_device_map;
 	add_timer(&acb->eternal_timer);
 	return 0;
 controller_stop:
-- 
2.7.4
