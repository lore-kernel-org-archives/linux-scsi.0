From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 18/18] megaraid_sas : swap whole register in megasas_register_aen
Date: Tue, 21 Apr 2015 14:33:12 +0200
Message-ID: <55364388.6040403@redhat.com>
References: <201504201237.t3KCbWt3016906@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbbDUMdP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:33:15 -0400
In-Reply-To: <201504201237.t3KCbWt3016906@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
> Swap the whole 32 bits we read from the hardware instead of swapping
> just the 16bits we care about in place later.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index e863701..fa6c3c9 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4923,8 +4923,9 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
>  
>  	if (instance->aen_cmd) {
>  
> -		prev_aen.word = instance->aen_cmd->frame->dcmd.mbox.w[1];
> -		prev_aen.members.locale = le16_to_cpu(prev_aen.members.locale);
> +		prev_aen.word =
> +			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
> +		prev_aen.members.locale = prev_aen.members.locale;

This^ looks odd, do we need the last assignment?

Tomas

>  
>  		/*
>  		 * A class whose enum value is smaller is inclusive of all

