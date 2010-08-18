From: "jack wang" <jack_wang@usish.com>
Subject: RE: [patch] scsi/pm8001: handle allocation failures
Date: Wed, 18 Aug 2010 09:15:23 +0800
Message-ID: <BE124E04D5CE40BFBBCF6107FDF8B94D@usish.com.cn>
References: <20100817115334.GG645@bicker>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:35719 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0HRBRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2010 21:17:00 -0400
In-Reply-To: <20100817115334.GG645@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Carpenter' <error27@gmail.com>
Cc: lindar_liu@usish.com, "'James E.J. Bottomley'" <James.Bottomley@suse.de>, 'Jiri Kosina' <jkosina@suse.cz>, 'Julia Lawall' <julia@diku.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org


[Jack] Acked-by: Jack Wang <jack_wang@usish.com> 
	Thanks!
                                                                     

Return -ENOMEM if the allocations fail.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 9793aa6..d8db013 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4194,6 +4194,8 @@ static int pm8001_chip_get_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
 
 	nvmd_type = ioctl_payload->minor_function;
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex),
GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	fw_control_context->usrAddr = (u8
*)&ioctl_payload->func_specific[0];
 	fw_control_context->len = ioctl_payload->length;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -4272,6 +4274,8 @@ static int pm8001_chip_set_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
 
 	nvmd_type = ioctl_payload->minor_function;
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex),
GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		ioctl_payload->func_specific,
@@ -4381,6 +4385,8 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info
*pm8001_ha,
 	struct pm8001_ioctl_payload *ioctl_payload = payload;
 
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex),
GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	fw_control = (struct fw_control_info
*)&ioctl_payload->func_specific[0];
 	if (fw_control->len != 0) {
 		if (pm8001_mem_alloc(pm8001_ha->pdev,

