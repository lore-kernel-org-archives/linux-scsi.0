From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Add the IEEE SGL support to
 the driver
Date: Wed, 18 Feb 2009 16:38:35 -0800
Message-ID: <20090218163835.bb10c640.akpm@linux-foundation.org>
References: <4B6A08C587958942AA3002690DD4F8C33A07FC48@cosmail02.lsi.com>
	<4B6A08C587958942AA3002690DD4F8C33A07FC5B@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbZBSAil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 19:38:41 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FC5B@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Winston.Austria@lsi.com

On Tue, 17 Feb 2009 10:31:10 -0700
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Add the IEEE SGL support to MegaRAID SAS driver
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> ---
> drivers/scsi/megaraid/megaraid_sas.c |  125 ++++++++++++++++++++++++++---------
>  drivers/scsi/megaraid/megaraid_sas.h |   13 +++
>  2 files changed, 107 insertions(+), 31 deletions(-)
> 
> diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 16:36:41.000000000 -0500
> +++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 17:24:26.000000000 -0500
> @@ -698,6 +698,35 @@ megasas_make_sgl64(struct megasas_instan
>         return sge_count;
>  }
> 
> +/**
> + * megasas_make_sgl64 -        Prepares 64-bit SGL
> + * @instance:          Adapter soft state
> + * @scp:               SCSI command from the mid-layer
> + * @mfi_sgl:           SGL to be filled in
> + *
> + * If successful, this function returns the number of SG elements. Otherwise,
> + * it returnes -1.
> + */
> +static int
> +megasas_make_sgl_skinny(struct megasas_instance *instance,
> +               struct scsi_cmnd *scp, union megasas_sgl *mfi_sgl)
> +{
> +       int i;
> +       int sge_count;
> +       struct scatterlist *os_sgl;
> +
> +       sge_count = scsi_dma_map(scp);
> +       BUG_ON(sge_count < 0);

Crashing the kernel if scsi_dma_map() fails seems inappropriate?

> +       if (sge_count) {
> +               scsi_for_each_sg(scp, os_sgl, sge_count, i) {
> +                 mfi_sgl->sge_skinny[i].length = sg_dma_len(os_sgl);
> +                 mfi_sgl->sge_skinny[i].phys_addr = sg_dma_address(os_sgl);
> +               }
> +       }
> +       return sge_count;
> +}
>
> ...
>
> +       if (instance->flag_ieee == 1) {
> +               flags = MFI_FRAME_IEEE;
> +       }

We typically omit the unneeded brakes in this situation.  But there are
a huge number of places in this driver which ignored that convention.

>         /*
>          * The RAID firmware may require extended timeouts.
> @@ -1405,7 +1476,7 @@ megasas_bios_param(struct scsi_device *s
>         return 0;
>  }
> 
> -static void megasas_aen_polling(void *arg);
> +static void megasas_aen_polling(struct work_struct *work);
> 
>  /**
>   * megasas_service_aen -       Processes an event notification
> @@ -1433,7 +1504,8 @@ megasas_service_aen(struct megasas_insta
>                 } else {
>                         ev->instance = instance;
>                         INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
> -                       schedule_delayed_work(&ev->hotplug_work, 0);
> +                       schedule_delayed_work(
> +                               (struct delayed_work *)&ev->hotplug_work, 0);

Why was this cast added?  It looks either unneeded or wrong.

> @@ -4043,12 +4108,12 @@ megasas_aen_polling(struct work_struct *
>         class_locale.members.locale = MR_EVT_LOCALE_ALL;
>         class_locale.members.class = MR_EVT_CLASS_DEBUG;
> 
> -       down(&instance->aen_mutex);
> +       mutex_lock(&instance->aen_mutex);
> 
>         error = megasas_register_aen(instance, seq_num,
>                                 class_locale.word);
> 
> -       up(&instance->aen_mutex);
> +       mutex_unlock(&instance->aen_mutex);

OK, so this fixes a bug which was added in an earlier patch.

Please just fix the original patch so that we don't introduce bisection
holes.

>         if (error)
>                 printk(KERN_ERR "%s[%d]: register aen failed error %x\n",
> diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
> --- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 16:36:42.000000000 -0500
> +++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 16:53:50.000000000 -0500
> @@ -96,6 +96,7 @@
>  #define MFI_FRAME_DIR_WRITE                    0x0008
>  #define MFI_FRAME_DIR_READ                     0x0010
>  #define MFI_FRAME_DIR_BOTH                     0x0018
> +#define MFI_FRAME_IEEE                         0x0020
> 
>  /*
>   * Definition for cmd_status
> @@ -752,10 +753,19 @@ struct megasas_sge64 {
> 
>  } __attribute__ ((packed));
> 
> +struct megasas_sge_skinny {
> +
> +       u64 phys_addr;
> +       u32 length;
> +       u32 flag;
> +
> +} __attribute__ ((packed));

Please use __packed throughout the driver.  (might be a problem if this
header is supposed to be shared with userspace?)


