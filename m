From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V2 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Wed, 6 Jan 2016 23:22:22 -0800
Message-ID: <1452151344-417-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:44852 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbcAFXMi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 18:12:38 -0500
In-Reply-To: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, David.Carroll@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

while driver removal is in progress or PCI shutdown is invoked, driver
kills AIF aacraid thread, but IOCTL requests from the management tools
re-start AIF thread leading to IOP_RESET.

Fixed by setting adapter_shutdown flag when PCI shutdown is invoked.

Changes in V2:
Set adapter_shutdown flag before shutdown command is sent to \
controller

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/comminit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 0e954e3..fe08854 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -212,8 +212,9 @@ int aac_send_shutdown(struct aac_dev * dev)
 		return -ENOMEM;
 	aac_fib_init(fibctx);
 
-	cmd = (struct aac_close *) fib_data(fibctx);
+	dev->adapter_shutdown = 1;
 
+	cmd = (struct aac_close *) fib_data(fibctx);
 	cmd->command = cpu_to_le32(VM_CloseAll);
 	cmd->cid = cpu_to_le32(0xfffffffe);
 
@@ -229,7 +230,6 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
-	dev->adapter_shutdown = 1;
 	if ((dev->pdev->device == PMC_DEVICE_S7 ||
 	     dev->pdev->device == PMC_DEVICE_S8 ||
 	     dev->pdev->device == PMC_DEVICE_S9) &&
-- 
1.9.1

