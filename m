From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [mpt3sas driver V1 6/10] mpt3sas: Added smp_affinity_enable
 module parameter.
Date: Tue, 9 Feb 2016 16:58:51 +0100
Message-ID: <56BA0CBB.3040603@redhat.com>
References: <1454949819-10985-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbcBIP65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Feb 2016 10:58:57 -0500
In-Reply-To: <1454949819-10985-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@avagotech.com, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com

On 8.2.2016 17:43, Suganath prabu Subramani wrote:
> Module parameter to enable/disable configuring
> affinity hint for msix vector.
> SMP affinity feature can be enabled/disabled by setting
> module parameter "smp_affinity_enable" to 1/0.
> By default this feature is enabled. (smp_affinity_enable = 1 enabled).
>
> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 31838d9a..582ba4b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -83,6 +83,10 @@ static int msix_disable = -1;
>  module_param(msix_disable, int, 0);
>  MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
>  
> +static int smp_affinity_enable = 1;
> +module_param(smp_affinity_enable, int, S_IRUGO);
> +MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
> +
>  static int max_msix_vectors = -1;
>  module_param(max_msix_vectors, int, 0);
>  MODULE_PARM_DESC(max_msix_vectors,
> @@ -1812,8 +1816,10 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
>  
>  	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
>  		list_del(&reply_q->list);
> -		irq_set_affinity_hint(reply_q->vector, NULL);
> -		free_cpumask_var(reply_q->affinity_hint);
> +		if (smp_affinity_enable) {
> +			irq_set_affinity_hint(reply_q->vector, NULL);
> +			free_cpumask_var(reply_q->affinity_hint);
> +		}
>  		synchronize_irq(reply_q->vector);
>  		free_irq(reply_q->vector, reply_q);
>  		kfree(reply_q);
> @@ -1844,9 +1850,13 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
>  	reply_q->msix_index = index;
>  	reply_q->vector = vector;
>  
> -	if (!alloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
> -		return -ENOMEM;
> -	cpumask_clear(reply_q->affinity_hint);
> +	if (smp_affinity_enable) {
> +		if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL)) {
> +			kfree(reply_q);
> +			return -ENOMEM;
> +		}
> +		cpumask_clear(reply_q->affinity_hint);

I think, that with zalloc_cpumask_var we no more need the cpumask_clear here
Please remove it in next patchset.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas





