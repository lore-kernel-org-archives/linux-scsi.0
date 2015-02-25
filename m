From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] megaraid_sas: harmless memory corruption in
 megasas_mgmt_fw_ioctl()
Date: Wed, 25 Feb 2015 16:22:36 +0300
Message-ID: <20150225132236.GI19745@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The intent here was for the "kbuff_arr[i] = NULL;" to be inside the
loop but, because the curly braces were missing, it's after the loop.
This means we corrupt a little memory one step beyond the array.
Fortunately, we weren't going to use that memory anyway so it's
harmless.  Also we aren't going to use kbuff_arr[] again so we don't
need to set it to NULL.

I have deleted that line of code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..834bfc0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6208,7 +6208,6 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 					  le32_to_cpu(kern_sge32[i].length),
 					  kbuff_arr[i],
 					  le32_to_cpu(kern_sge32[i].phys_addr));
-			kbuff_arr[i] = NULL;
 	}
 
 	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
