From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 10/10] megaraid_sas: fix endianess for the crash dump
 state support
Date: Wed, 14 Jan 2015 17:31:29 +0530
Message-ID: <5d58234d141eb9298e1561e53f70f1e0@mail.gmail.com>
References: <1420909883-19479-1-git-send-email-hch@lst.de> <1420909883-19479-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:60230 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbANMBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 07:01:31 -0500
Received: by mail-qa0-f53.google.com with SMTP id n4so6191056qaq.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 04:01:31 -0800 (PST)
In-Reply-To: <1420909883-19479-11-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@lst.de]
>Sent: Saturday, January 10, 2015 10:41 PM
>To: Sumit.Saxena@avagotech.com; kashyap.desai@avagotech.com
>Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org
>Subject: [PATCH 10/10] megaraid_sas: fix endianess for the crash dump
state
>support
>
>Note that this one is a bit fishy: it seems like it should always be read
and
>written using either words or bytes, but never using a mixture.
>
>Please verify against the hardware documentation.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
> drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
> drivers/scsi/megaraid/megaraid_sas_base.c | 7 ++++---
> 2 files changed, 5 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>b/drivers/scsi/megaraid/megaraid_sas.h
>index 81484f1..465dd45 100644
>--- a/drivers/scsi/megaraid/megaraid_sas.h
>+++ b/drivers/scsi/megaraid/megaraid_sas.h
>@@ -1676,7 +1676,7 @@ struct megasas_instance {
> 	u32 drv_buf_alloc;
> 	u32 crash_dump_fw_support;
> 	u32 crash_dump_drv_support;
>-	u32 crash_dump_app_support;
>+	__le32 crash_dump_app_support;
> 	u32 secure_jbod_support;
> 	spinlock_t crashdump_lock;
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 3d4a080..29a1b20 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -6010,7 +6010,7 @@ static int megasas_set_crash_dump_params_ioctl(
> {
> 	struct megasas_instance *local_instance;
> 	int i, error = 0;
>-	int crash_support;
>+	__le32 crash_support;
>
> 	crash_support = cmd->frame->dcmd.mbox.w[0];
>
>@@ -6020,7 +6020,7 @@ static int megasas_set_crash_dump_params_ioctl(
> 			if ((local_instance->adprecovery ==
> 				MEGASAS_HBA_OPERATIONAL) &&
>
>	!megasas_set_crash_dump_params(local_instance,
>-					crash_support)) {
>+					le32_to_cpu(crash_support))) {
> 				local_instance->crash_dump_app_support =
> 					crash_support;
> 				dev_info(&local_instance->pdev->dev,
>@@ -6084,7 +6084,8 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
>*instance,
> 					       MFI_FRAME_SGL64 |
> 					       MFI_FRAME_SENSE64));
>
>-	if (cmd->frame->dcmd.opcode ==
>MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
>+	if (cmd->frame->dcmd.opcode ==
>+
>	cpu_to_le32(MR_DRIVER_SET_APP_CRASHDUMP_MODE)) {

Application will not do any byte swapping for this DCMD
frame(MR_DRIVER_SET_APP_CRASHDUMP_MODE) to convert it in LE format, since
this DCMD will not be sent to firmware, driver will only process this DCMD
and fire another DCMD- MR_DCMD_CTRL_SET_CRASH_DUMP_PARAMS to firmware.
DCMD frame will always be in CPU format only.
So this "if" condition does not need
cpu_to_le32(MR_DRIVER_SET_APP_CRASHDUMP_MODE).


> 		error = megasas_set_crash_dump_params_ioctl(cmd);
> 		megasas_return_cmd(instance, cmd);
> 		return error;
>--
>1.9.1
