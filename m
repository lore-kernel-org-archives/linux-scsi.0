From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 19/39] megaraid_sas: Big endian RDPQ mode fix
Date: Mon,  6 Feb 2017 01:59:52 -0800
Message-ID: <1486375212-17329-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33717 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdBFKCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:18 -0500
Received: by mail-pf0-f178.google.com with SMTP id y143so23100681pfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:17 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix if RDPQ mode enabled MR FW is deployed on big endian host machine,
driver does not setup reply address correctly.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 3d4d4b8..b68babc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -580,7 +580,7 @@ megasas_alloc_rdpq_fusion(struct megasas_instance *instance)
 		}
 
 		fusion->rdpq_virt[i].RDPQBaseAddress =
-			fusion->reply_frames_desc_phys[i];
+			cpu_to_le64(fusion->reply_frames_desc_phys[i]);
 
 		reply_desc = fusion->reply_frames_desc[i];
 		for (j = 0; j < fusion->reply_q_depth; j++, reply_desc++)
-- 
2.8.3
