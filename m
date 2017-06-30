From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 11/15] megaraid_sas: Set device queue_depth same as HBA can_queue value in scsi-mq mode
Date: Fri, 30 Jun 2017 01:30:05 -0700
Message-ID: <1498811409-11157-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34091 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdF3IbY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:31:24 -0400
Received: by mail-pf0-f178.google.com with SMTP id s66so63607832pfs.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 01:31:24 -0700 (PDT)
In-Reply-To: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Currently driver sets default queue_depth for VDs at 256 and JBODs based on interface type,
ie., for SAS JBOD QD will be 64, for SATA JBOD QD will be 32.
During performance runs with scsi-mq enabled, we are seeing better results by
setting QD same as HBA queue_depth.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0230929..c200f1a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1891,7 +1891,8 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
 	if (instance->nvme_page_size && max_io_size_kb)
 		megasas_set_nvme_device_properties(sdev, (max_io_size_kb << 10));
 
-	scsi_change_queue_depth(sdev, device_qd);
+	if (!shost_use_blk_mq(sdev->host))
+		scsi_change_queue_depth(sdev, device_qd);
 
 }
 
@@ -5914,6 +5915,9 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->max_lun = MEGASAS_MAX_LUN;
 	host->max_cmd_len = 16;
 
+	if (shost_use_blk_mq(host))
+		host->cmd_per_lun = host->can_queue;
+
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
-- 
2.8.3
