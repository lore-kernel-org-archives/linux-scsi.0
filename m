From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific functions:
 megaraid_sas_fusion.c
Date: Thu, 16 Dec 2010 14:57:36 +0100
Message-ID: <4D0A1AD0.1040703@redhat.com>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab0LPN5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 08:57:44 -0500
In-Reply-To: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 12/15/2010 04:04 AM, adam radford wrote:
> James/Linux-scsi,
>
> This patch adds the MegaRAID 9265/9285 specific functions contained in
> the file megaraid_sas_fusion.c.
>
> Signed-off-by: Adam Radford <aradford@gmail.com>
>
> Note: The patch has been included in-line below, and also as an
> attachment in case Gmail hoses the patch.
>   
> +/* Fusion OCR work queue */
> +void megasas_fusion_ocr_wq(struct work_struct *work)
> +{
> +	struct megasas_instance *instance =
> +		container_of(work, struct megasas_instance, work_init);
> +	struct scsi_cmnd scmd;
> +	struct scsi_device dev;
> +
> +	scmd.device = &dev;
> +	dev.host = instance->host;
> +	megasas_reset_fusion(&scmd);
> +}
>   
Hi Adam, Bo,

The function megasas_fusion_ocr_wq seems to be used already in patch 6/11 
and declared in 7/11 - this breaks bisectability.

Further my compiler complains about a large frame size.
Probably the 'struct scsi_device dev' is too large to be on stack.
make checkstack
...
0x000090f4 megasas_fusion_ocr_wq [megaraid_sas]:	1696

Tomas

> +
> +struct megasas_instance_template megasas_instance_template_fusion = {
> +	.fire_cmd = megasas_fire_cmd_fusion,
> +	.enable_intr = megasas_enable_intr_fusion,
> +	.disable_intr = megasas_disable_intr_fusion,
> +	.clear_intr = megasas_clear_intr_fusion,
> +	.read_fw_status_reg = megasas_read_fw_status_reg_fusion,
> +	.adp_reset = megasas_adp_reset_fusion,
> +	.check_reset = megasas_check_reset_fusion,
> +	.service_isr = megasas_isr_fusion,
> +	.tasklet = megasas_complete_cmd_dpc_fusion,
> +	.init_adapter = megasas_init_adapter_fusion,
> +	.build_and_issue_cmd = megasas_build_and_issue_cmd_fusion,
> +	.issue_dcmd = megasas_issue_dcmd_fusion,
> +};
>   

