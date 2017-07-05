From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 07/15] megaraid_sas: Check valid aen class range to avoid kernel panic
Date: Wed,  5 Jul 2017 05:00:21 -0700
Message-ID: <1499256029-16319-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35167 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752516AbdGEMBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:01:48 -0400
Received: by mail-pf0-f170.google.com with SMTP id c73so128733739pfk.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:01:33 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3c50a7b..e490272 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5650,6 +5650,14 @@ static void megasas_release_mfi(struct megasas_instance *instance)
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
1.8.3.1
