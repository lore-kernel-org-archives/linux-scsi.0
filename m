From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id()
	in preemptible
Date: Tue, 17 Apr 2012 21:14:41 -0600
Message-ID: <20120418031441.GA10862@parisc-linux.org>
References: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46039 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2DRDUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 23:20:53 -0400
Content-Disposition: inline
In-Reply-To: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, jejb@kernel.org

On Tue, Apr 17, 2012 at 11:25:04AM +0530, nagalakshmi.nandigama@lsi.com wrote:
> When CONFIG_DEBUG_PREEMPT is enabled, bug is observed in the smp_processor_id().
> This is because smp_processor_id() is not called in preempt safe condition.
> 
> To fix this issue, use raw_smp_processor_id instead of smp_processor_id.

Just so we're clear, "fix this issue" really means "paper over the warning".

 * NOTE: raw_smp_processor_id() is for internal use only
 * (smp_processor_id() is the preferred variant), but in rare
 * instances it might also be used to turn off false positives
 * (i.e. smp_processor_id() use that the debugging code reports but
 * which use for some reason is legal). Don't use this to hack around
 * the warning message, as your code might not work under PREEMPT.

As far as I can tell, it's called under a lock already so should be
non-preemptable ... can you share the backtrace you get?

> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
> CC: stable@vger.kernel.org
> ---
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 272fab7..b010be0 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1792,7 +1792,7 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
>  static inline u8
>  _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
>  {
> -	return ioc->cpu_msix_table[smp_processor_id()];
> +	return ioc->cpu_msix_table[raw_smp_processor_id()];
>  }
>  
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
