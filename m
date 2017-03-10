From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 2/4] megaraid_sas: add correct return type check for ldio hint logic for raid1
Date: Fri, 10 Mar 2017 03:22:13 -0800
Message-ID: <1489144935-26567-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34335 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934083AbdCJLWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2017 06:22:53 -0500
Received: by mail-pf0-f178.google.com with SMTP id v190so40971022pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 03:22:52 -0800 (PST)
In-Reply-To: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Return value check of atomic_dec_if_positive is required as it returns old value minus one.
Without this fix, driver will send small ios to firmware path and that will be a performance issue.

Not a critical, but good to have r1_ldio_hint as default value in sdev private.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 3 +++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 016ffce..0016f12 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1963,6 +1963,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 	if (!mr_device_priv_data)
 		return -ENOMEM;
 	sdev->hostdata = mr_device_priv_data;
+
+	atomic_set(&mr_device_priv_data->r1_ldio_hint,
+		   instance->r1_ldio_hint_default);
 	return 0;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 29650ba..ebd746e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2338,7 +2338,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				fp_possible = false;
 				atomic_dec(&instance->fw_outstanding);
 			} else if ((scsi_buff_len > MR_LARGE_IO_MIN_SIZE) ||
-				   atomic_dec_if_positive(&mrdev_priv->r1_ldio_hint)) {
+				   (atomic_dec_if_positive(&mrdev_priv->r1_ldio_hint) > 0)) {
 				fp_possible = false;
 				atomic_dec(&instance->fw_outstanding);
 				if (scsi_buff_len > MR_LARGE_IO_MIN_SIZE)
-- 
2.8.3
