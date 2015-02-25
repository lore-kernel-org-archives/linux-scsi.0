From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [patch] megaraid_sas: harmless memory corruption in megasas_mgmt_fw_ioctl()
Date: Wed, 25 Feb 2015 19:16:15 +0530
Message-ID: <c3d45ec00aea189cf1cb5449fe41ae3f@mail.gmail.com>
References: <20150225132236.GI19745@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150225132236.GI19745@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>Sent: Wednesday, February 25, 2015 6:53 PM
>To: Kashyap Desai
>Cc: Sumit Saxena; Uday Lingala; James E.J. Bottomley;
>megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org; kernel-
>janitors@vger.kernel.org
>Subject: [patch] megaraid_sas: harmless memory corruption in
>megasas_mgmt_fw_ioctl()
>
>The intent here was for the "kbuff_arr[i] = NULL;" to be inside the loop
but,
>because the curly braces were missing, it's after the loop.
>This means we corrupt a little memory one step beyond the array.
>Fortunately, we weren't going to use that memory anyway so it's harmless.
>Also we aren't going to use kbuff_arr[] again so we don't need to set it
to
>NULL.
>
>I have deleted that line of code.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 890637f..834bfc0 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -6208,7 +6208,6 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
>*instance,
>
le32_to_cpu(kern_sge32[i].length),
> 					  kbuff_arr[i],
>
>le32_to_cpu(kern_sge32[i].phys_addr));
>-			kbuff_arr[i] = NULL;
> 	}
>
> 	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)

Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

-Sumit
