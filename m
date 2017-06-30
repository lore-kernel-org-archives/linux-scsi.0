From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 07/15] megaraid_sas: Check valid aen class range to avoid kernel panic
Date: Fri, 30 Jun 2017 01:30:01 -0700
Message-ID: <1498811409-11157-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:36018 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751818AbdF3IbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:31:10 -0400
Received: by mail-pg0-f45.google.com with SMTP id u62so60420226pgb.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 01:31:10 -0700 (PDT)
In-Reply-To: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org

An application sending out of range AEN class code for 
registration, will result in kernel panic in MR driver.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3c50a7b..e490272 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5650,6 +5650,14 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 		prev_aen.word =
 			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
 
+		if ((curr_aen.members.class < MFI_EVT_CLASS_DEBUG) ||
+		    (curr_aen.members.class > MFI_EVT_CLASS_DEAD)) {
+			dev_info(&instance->pdev->dev,
+				 "%s %d out of range class %d send by application\n",
+				 __func__, __LINE__, curr_aen.members.class);
+			return 0;
+		}
+
 		/*
 		 * A class whose enum value is smaller is inclusive of all
 		 * higher values. If a PROGRESS (= -1) was previously
-- 
2.8.3
