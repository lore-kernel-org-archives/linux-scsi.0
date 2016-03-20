From: Colin King <colin.king@canonical.com>
Subject: [PATCH] megaraid_sas: fix missing { }, nullify kbuff_arr[i] only when necessary
Date: Sun, 20 Mar 2016 17:03:32 +0000
Message-ID: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcCTRDi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Mar 2016 13:03:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, James Bottomley <jbottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix missing { } on if statement, this change will nullify kbuff_arr[i]
only where necessary as the code intended.

detected using static analysis with smatch

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 69d375b..e6ebc7a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6656,12 +6656,13 @@ out:
 	}
 
 	for (i = 0; i < ioc->sge_count; i++) {
-		if (kbuff_arr[i])
+		if (kbuff_arr[i]) {
 			dma_free_coherent(&instance->pdev->dev,
 					  le32_to_cpu(kern_sge32[i].length),
 					  kbuff_arr[i],
 					  le32_to_cpu(kern_sge32[i].phys_addr));
 			kbuff_arr[i] = NULL;
+		}
 	}
 
 	megasas_return_cmd(instance, cmd);
-- 
2.7.3

