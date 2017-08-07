From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: move command counter to correct place
Date: Mon, 7 Aug 2017 23:01:58 +0530
Message-ID: <6da476e6af4e0265bc3f2de5a26e4977@mail.gmail.com>
References: <20170728140359.15424-1-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34958 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdHGRcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:32:01 -0400
Received: by mail-oi0-f48.google.com with SMTP id e124so10606169oig.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2017 10:32:00 -0700 (PDT)
In-Reply-To: <20170728140359.15424-1-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@broadcom.com>

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Friday, July 28, 2017 7:34 PM
>To: linux-scsi@vger.kernel.org
>Cc: sumit.saxena@broadcom.com; kashyap.desai@broadcom.com
>Subject: [PATCH] megaraid_sas: move command counter to correct place
>
>the eh reset function returns success when fw_outstanding equals zero,
that
>means that the counter shouldn't be decremented when the driver still
owns
>the command
>
>
>Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index f990ab4d45..c615aadb2b 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -3046,7 +3046,6 @@ complete_cmd_fusion(struct megasas_instance
>*instance, u32 MSIxIndex)
> 			}
> 			//Fall thru and complete IO
> 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO
>Path */
>-			atomic_dec(&instance->fw_outstanding);
> 			if (cmd_fusion->r1_alt_dev_handle ==
>MR_DEVHANDLE_INVALID) {
> 				map_cmd_status(fusion, scmd_local, status,
> 					       extStatus,
>le32_to_cpu(data_length), @@ -3060,6 +3059,7 @@
>complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
> 				scmd_local->scsi_done(scmd_local);
> 			} else	/* Optimal VD - R1 FP command completion.
>*/
> 				megasas_complete_r1_command(instance,
>cmd_fusion);
>+			atomic_dec(&instance->fw_outstanding);
> 			break;
> 		case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST:
>/*MFI command */
> 			cmd_mfi = instance->cmd_list[cmd_fusion-
>>sync_cmd_idx];

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>--
>2.9.4
