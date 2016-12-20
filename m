From: Sasikumar PC <sasikumar.pc@broadcom.com>
Subject: RE: [PATCH V4 02/11] megaraid_sas: 128 MSIX Support
Date: Mon, 19 Dec 2016 20:50:30 -0500
Message-ID: <daa55fdc1193f237cc2d76c68e5e0488@mail.gmail.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-3-git-send-email-sasikumar.pc@broadcom.com>
 <ece66d1c-473a-5c20-1ee5-c01a3d25d375@redhat.com> d3be93246dde4d729a42f4aa7055c103@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:32866 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbcLTBud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 20:50:33 -0500
Received: by mail-lf0-f46.google.com with SMTP id c13so66382491lfg.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 17:50:32 -0800 (PST)
In-Reply-To: d3be93246dde4d729a42f4aa7055c103@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, Christopher Owens <christopher.owens@broadcom.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

Hi Tomas,

Please see my response inline

Thanks
sasi

-----Original Message-----
From: Sasikumar PC [mailto:sasikumar.pc@broadcom.com]
Sent: Wednesday, December 14, 2016 4:43 PM
To: 'Tomas Henzl'; 'jejb@kernel.org'; 'hch@infradead.org'
Cc: 'linux-scsi@vger.kernel.org'; Sathya Prakash Veerichetty;
'linux-kernel@vger.kernel.org'; Christopher Owens; Kiran Kumar Kasturi
Subject: RE: [PATCH V4 02/11] megaraid_sas: 128 MSIX Support

Hi Tomas,

Please see my response inline

Thanks
sasi

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com]
Sent: Thursday, December 08, 2016 10:35 AM
To: Sasikumar Chandrasekaran; jejb@kernel.org; hch@infradead.org
Cc: linux-scsi@vger.kernel.org; Sathya.Prakash@broadcom.com;
linux-kernel@vger.kernel.org; christopher.owens@broadcom.com;
kiran-kumar.kasturi@broadcom.com
Subject: Re: [PATCH V4 02/11] megaraid_sas: 128 MSIX Support

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> SAS3.5 Generic Megaraid based Controllers will have the support for
> 128 MSI-X vectors, resulting in the need to support 128 reply queues
>
> This patch is depending on patch 1
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  1 +
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 24
+++++++++++++++++-------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 ++--
>  3 files changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> b/drivers/scsi/megaraid/megaraid_sas.h
> index 72e16c2..9d4ca8d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2149,6 +2149,7 @@ struct megasas_instance {
>  	bool dev_handle;
>  	bool fw_sync_cache_support;
>  	bool is_ventura;
> +	bool msix_combined;
>  };
>  struct MR_LD_VF_MAP {
>  	u32 size;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index efccf98..c583e0b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5086,13 +5086,7 @@ static int megasas_init_fw(struct
megasas_instance *instance)
>  			goto fail_ready_state;
>  	}
>
> -	/*
> -	 * MSI-X host index 0 is common for all adapter.
> -	 * It is used for all MPT based Adapters.
> -	 */
> -	instance->reply_post_host_index_addr[0] =
> -		(u32 __iomem *)((u8 __iomem *)instance->reg_set +
> -		MPI2_REPLY_POST_HOST_INDEX_OFFSET);
> +
>
>  	/* Check if MSI-X is supported while in ready state */
>  	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
@@
> -5110,6 +5104,9 @@ static int megasas_init_fw(struct megasas_instance
*instance)
>  				instance->msix_vectors = ((scratch_pad_2
>  					& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
>  					>>
MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
> +				if (instance->msix_vectors > 16)
> +					instance->msix_combined = true;
> +
>  				if (rdpq_enable)
>  					instance->is_rdpq = (scratch_pad_2
& MR_RDPQ_MODE_OFFSET) ?
>  								1 : 0;
> @@ -5143,6 +5140,19 @@ static int megasas_init_fw(struct
megasas_instance *instance)
>  		else
>  			instance->msix_vectors = 0;
>  	}

Have you tested this patch with the pci=nomsi kernel option?
Sasi - Driver is tested with pci=nomsi option and looking good

is it safe when msix_combined is true and pci_enable_msix_range fails so
instance->msix_vectors is zero?

msix_combined mode is dependent on how many vectors adapter supports, not
the actual vectors used.
It is correct to be in combined mode even if actual number of msix_vectors
used are fewer than 16, if hardware is in combined mode

Sasi


tomash

> +	/*
> +	 * MSI-X host index 0 is common for all adapter.
> +	 * It is used for all MPT based Adapters.
> +	 */
> +	if (instance->msix_combined) {
> +		instance->reply_post_host_index_addr[0] =
> +				(u32 *)((u8 *)instance->reg_set +
> +				MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET);
> +	} else {
> +		instance->reply_post_host_index_addr[0] =
> +			(u32 *)((u8 *)instance->reg_set +
> +			MPI2_REPLY_POST_HOST_INDEX_OFFSET);
> +	}
>
>  	dev_info(&instance->pdev->dev,
>  		"firmware supports msix\t: (%d)", fw_msix_count); diff
--git
> a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 8d7a397..413e2030 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2391,7 +2391,7 @@ static void megasas_build_ld_nonrw_fusion(struct
megasas_instance *instance,
>  		 * pending to be completed
>  		 */
>  		if (threshold_reply_count >= THRESHOLD_REPLY_COUNT) {
> -			if (fusion->adapter_type == INVADER_SERIES)
> +			if (instance->msix_combined)
>  				writel(((MSIxIndex & 0x7) << 24) |
>  					fusion->last_reply_idx[MSIxIndex],
>
instance->reply_post_host_index_addr[MSIxIndex/8]);
> @@ -2407,7 +2407,7 @@ static void megasas_build_ld_nonrw_fusion(struct
megasas_instance *instance,
>  		return IRQ_NONE;
>
>  	wmb();
> -	if (fusion->adapter_type == INVADER_SERIES)
> +	if (instance->msix_combined)
>  		writel(((MSIxIndex & 0x7) << 24) |
>  			fusion->last_reply_idx[MSIxIndex],
>
instance->reply_post_host_index_addr[MSIxIndex/8]);
