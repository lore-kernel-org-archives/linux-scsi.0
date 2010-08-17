From: Dan Carpenter <error27@gmail.com>
Subject: [patch] scsi/pm8001: handle allocation failures
Date: Tue, 17 Aug 2010 13:54:57 +0200
Message-ID: <20100817115334.GG645@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60427 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab0HQL5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2010 07:57:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com
Cc: lindar_liu@usish.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jiri Kosina <jkosina@suse.cz>, Julia Lawall <julia@diku.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

Return -ENOMEM if the allocations fail.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 9793aa6..d8db013 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4194,6 +4194,8 @@ static int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 
 	nvmd_type = ioctl_payload->minor_function;
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	fw_control_context->usrAddr = (u8 *)&ioctl_payload->func_specific[0];
 	fw_control_context->len = ioctl_payload->length;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -4272,6 +4274,8 @@ static int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 
 	nvmd_type = ioctl_payload->minor_function;
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		ioctl_payload->func_specific,
@@ -4381,6 +4385,8 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_ioctl_payload *ioctl_payload = payload;
 
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	fw_control = (struct fw_control_info *)&ioctl_payload->func_specific[0];
 	if (fw_control->len != 0) {
 		if (pm8001_mem_alloc(pm8001_ha->pdev,
