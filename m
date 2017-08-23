From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 07/14] megaraid_sas: Check valid aen class range to avoid kernel panic
Date: Wed, 23 Aug 2017 04:47:01 -0700
Message-ID: <1503488828-2242-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:37526 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753919AbdHWLrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:47:51 -0400
Received: by mail-pg0-f53.google.com with SMTP id y129so6244325pgy.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:47:51 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b8b4654..df2332f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5651,6 +5651,14 @@ static void megasas_release_mfi(struct megasas_instance *instance)
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
