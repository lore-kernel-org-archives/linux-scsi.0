From: Colin King <colin.king@canonical.com>
Subject: [PATCH] megaraid_sas: fix missing { } braces
Date: Mon,  3 Aug 2015 16:00:29 +0100
Message-ID: <1438614029-4257-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbbHCPA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 11:00:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Static analysis by smatch indicated that there was a curly
braces issue:

drivers/scsi/megaraid/megaraid_sas_base.c:6139
  megasas_mgmt_fw_ioctl() warn: curly braces intended?

Add braces in the appropriate place so that kbuf_arr[i] gets
set to NULL only when we need to.  Also, remove whitespace
between kbuff_arr and [].

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 71b884d..8face78 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6131,12 +6131,13 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
2.5.0

