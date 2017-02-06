From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 32/39] megaraid_sas: Bail out the driver load if ld_list_query fails
Date: Mon,  6 Feb 2017 02:00:05 -0800
Message-ID: <1486375212-17329-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33009 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdBFKCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:55 -0500
Received: by mail-pg0-f46.google.com with SMTP id 204so27456465pge.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:55 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Error handling: Bail out the driver load if
key FW cmds (LD_LIST) are not return successful.
Clean up error handling in megasas_init_fw.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2d72460..04ef0a0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5349,7 +5349,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
 		dev_err(&instance->pdev->dev, "failed to get PD list\n");
-		goto fail_get_pd_list;
+		goto fail_get_ld_pd_list;
 	}
 
 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
@@ -5385,7 +5385,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	if (megasas_ld_list_query(instance,
 				  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
-		megasas_get_ld_list(instance);
+		goto fail_get_ld_pd_list;
 
 	/*
 	 * Compute the max allowed sectors per IO: The controller info has two
@@ -5504,8 +5504,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 fail_get_ld_pd_list:
 	instance->instancet->disable_intr(instance);
-fail_get_pd_list:
-	instance->instancet->disable_intr(instance);
 fail_init_adapter:
 	megasas_destroy_irqs(instance);
 fail_setup_irqs:
@@ -5517,9 +5515,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->ctrl_info = NULL;
 	iounmap(instance->reg_set);
 
-      fail_ioremap:
+fail_ioremap:
 	pci_release_selected_regions(instance->pdev, 1<<instance->bar);
 
+	dev_err(&instance->pdev->dev, "Failed from %s %d\n",
+		__func__, __LINE__);
 	return -EINVAL;
 }
 
-- 
2.8.3
