From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: [PATCH] pm80xx : Fix missing NULL pointer checks and memory leaks
Date: Fri,  9 May 2014 11:31:01 +0530
Message-ID: <1399615261-15932-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:55104 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbaEIGUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2014 02:20:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

Checking return value for the memory allocattion and freeing it
while exiting the function

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 28b4e81..5f68571 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -395,6 +395,8 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
 	payload.offset = 0;
 	payload.length = 4096;
 	payload.func_specific = kzalloc(4096, GFP_KERNEL);
+	if (!payload.func_specific)
+		return -ENOMEM;
 	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	wait_for_completion(&completion);
 	virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
@@ -402,6 +404,7 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
 		bios_index++)
 		str += sprintf(str, "%c",
 			*((u8 *)((u8 *)virt_addr+bios_index)));
+	kfree(payload.func_specific);
 	return str - buf;
 }
 static DEVICE_ATTR(bios_version, S_IRUGO, pm8001_ctl_bios_version_show, NULL);
-- 
1.7.1

