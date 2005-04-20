From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [PATCH]megaraid_sas: Reduce stack usage in megasas_probe_one(
	)
Date: Wed, 20 Apr 2005 10:05:44 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CCE24@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39107 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261360AbVDTOF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 10:05:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Yum Rayan' <yum.rayan@gmail.com>
Cc: linux-scsi@vger.kernel.org

>
>This patch reduces stack usage in megasas_probe_one() from to 2200 to
>156. A patched version of gcc 3.4.3 with -fno-unit-at-a-time disabled
>was used on i386 platform.
>
>Signed-off-by: Yum Rayan <yum.rayan@gmail.com>

Rayan,

Thanks. I will be submitting shortly a consolidated patch that includes
changes suggested by Matt, Adrian and others. I will merge your patch
into mine.

Thanks,
Sreenivas Bagalkote
LSI Logic Corporation

>
>--- 
>linux-2.6.12-rc2-mm3.a/drivers/scsi/megaraid/megaraid_sas.c	
>2005-04-14
>22:15:44.000000000 -0700
>+++ 
>linux-2.6.12-rc2-mm3.b/drivers/scsi/megaraid/megaraid_sas.c	
>2005-04-20
>00:26:01.000000000 -0700
>@@ -731,7 +731,7 @@
> 	struct megasas_register_set*	reg_set;
> 
> 	struct megasas_cmd*		cmd;
>-	struct megasas_ctrl_info	ctrl_info;
>+	struct megasas_ctrl_info	*ctrl_info;
> 
> 	struct megasas_init_frame*	init_frame;
> 	struct megasas_init_queue_info*	initq_info;
>@@ -846,15 +846,19 @@
> 
> 	megasas_return_cmd( instance, cmd );
> 
>+	ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), 
>GFP_KERNEL);
>+
> 	/*
> 	 * Gather misc FW related information
> 	 */
>-	if (!megasas_get_ctrl_info( instance, &ctrl_info ))
>-		instance->max_sectors_per_req = 
>ctrl_info.max_request_size;
>+	if (ctrl_info && !megasas_get_ctrl_info( instance, ctrl_info ))
>+		instance->max_sectors_per_req = 
>ctrl_info->max_request_size;
> 	else
> 		instance->max_sectors_per_req = instance->max_num_sge *
> 						PAGE_SIZE / 512;
> 
>+	kfree(ctrl_info);
>+
> 	return 0;
> 
> fail_fw_init:
>
