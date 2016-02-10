From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] be2iscsi: Fix memory leak in beiscsi_alloc_mem()
Date: Wed, 10 Feb 2016 11:13:39 +0100
Message-ID: <56BB0D53.9010103@redhat.com>
References: <1443689785-13712-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbcBJKNl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2016 05:13:41 -0500
In-Reply-To: <1443689785-13712-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, James.Bottomley@HansenPartnership.com

ping.

On 10/01/2015 10:56 AM, Maurizio Lombardi wrote:
> In case of error, the memory allocated for phwi_ctrlr was not freed.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 7a6dbfb..360aa88 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2706,8 +2706,10 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>  	phwi_ctrlr->wrb_context = kzalloc(sizeof(struct hwi_wrb_context) *
>  					  phba->params.cxns_per_ctrl,
>  					  GFP_KERNEL);
> -	if (!phwi_ctrlr->wrb_context)
> +	if (!phwi_ctrlr->wrb_context) {
> +		kfree(phba->phwi_ctrlr);
>  		return -ENOMEM;
> +	}
>  
>  	phba->init_mem = kcalloc(SE_MEM_MAX, sizeof(*mem_descr),
>  				 GFP_KERNEL);
> 
