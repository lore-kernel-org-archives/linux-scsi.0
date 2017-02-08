From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 33/39] megaraid_sas: Bail out the driver load if ld_list_query fails
Date: Wed,  8 Feb 2017 01:29:27 -0800
Message-ID: <1486546173-20713-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:33161 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754081AbdBHJba (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:31:30 -0500
Received: by mail-pg0-f50.google.com with SMTP id 204so47597802pge.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:31:30 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Error handling: Bail out the driver load if
key FW cmds (LD_LIST) are not return successful.
Clean up error handling in megasas_init_fw.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 30e390c..0e7121d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5352,7 +5352,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
 		dev_err(&instance->pdev->dev, "failed to get PD list\n");
-		goto fail_get_pd_list;
+		goto fail_get_ld_pd_list;
 	}
 
 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
@@ -5388,7 +5388,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	if (megasas_ld_list_query(instance,
 				  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
-		megasas_get_ld_list(instance);
+		goto fail_get_ld_pd_list;
 
 	/*
 	 * Compute the max allowed sectors per IO: The controller info has two
@@ -5507,8 +5507,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 fail_get_ld_pd_list:
 	instance->instancet->disable_intr(instance);
-fail_get_pd_list:
-	instance->instancet->disable_intr(instance);
 fail_init_adapter:
 	megasas_destroy_irqs(instance);
 fail_setup_irqs:
@@ -5520,9 +5518,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
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
