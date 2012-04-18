From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id()	in
 preemptible
Date: Tue, 17 Apr 2012 21:35:49 -0600
Message-ID: <4565AEA676113A449269C2F3A549520FB5AE22E7@cosmail03.lsi.com>
References: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>,<20120418031441.GA10862@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:56403 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152Ab2DRDfv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2012 23:35:51 -0400
In-Reply-To: <20120418031441.GA10862@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "jejb@kernel.org" <jejb@kernel.org>

 Jan Schmidt suggested using raw_smp_processor_id()  back in February, see this: http://marc.info/?t=132974687100003&r=1&w=2

Alex Shi recently suggested using preempt_disable() and preempt_enable() to solve the same issue, see this: http://marc.info/?t=133274303900003&r=1&w=2

I believe the stack traces are there in both email discussion, they occur when CONFIG_DEBUG_PREEMPT is enabled.

I would rather go with the solution giving the best performance.   James Bottomley is there on the discussion with  Jan Schmidt, he suggested using get_cpu() and put_cpu().

Eric
________________________________________
From: Matthew Wilcox [matthew@wil.cx]
Sent: Tuesday, April 17, 2012 9:14 PM
To: Nandigama, Nagalakshmi
Cc: stable@vger.kernel.org; linux-scsi@vger.kernel.org; Prakash, Sathya; Moore, Eric; jejb@kernel.org
Subject: Re: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id()       in preemptible

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
> -     return ioc->cpu_msix_table[smp_processor_id()];
> +     return ioc->cpu_msix_table[raw_smp_processor_id()];
>  }
>
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Matthew Wilcox                          Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
