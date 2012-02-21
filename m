From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mpt2sas: BUG: using smp_processor_id() in preemptible
Date: Tue, 21 Feb 2012 08:18:56 -0600
Message-ID: <1329833936.2922.10.camel@dabdike.int.hansenpartnership.com>
References: <4F425105.4090505@jan-o-sch.net>
	 <4565AEA676113A449269C2F3A549520FB5AE22B0@cosmail03.lsi.com>
	 <4F435D59.1000302@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56449 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab2BUOTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 09:19:01 -0500
In-Reply-To: <4F435D59.1000302@jan-o-sch.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Schmidt <list.linux-scsi@jan-o-sch.net>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2012-02-21 at 10:01 +0100, Jan Schmidt wrote:
> Hi Eric,
> 
> On 21.02.2012 00:06, Moore, Eric wrote:
> > Jan - the smp_processor_id() is part of NUMA support which I added over a year ago. I don't see any problem with the driver running on sles11sp2 which has btrfs support ( I'm not sure  if CONFIG_DEBUG_PREEMPT is turned on as I have not checked).   Any theory why its oopsing in smp_processor_id() ?
> 
> -- excerpt from include/linux/smp.h --
> /*
>  * smp_processor_id(): get the current CPU ID.
>  *
>  * if DEBUG_PREEMPT is enabled then we check whether it is
>  * used in a preemption-safe way. (smp_processor_id() is safe
>  * if it's used in a preemption-off critical section, or in
>  * a thread that is bound to the current CPU.)
> [...]
>  */
> #ifdef CONFIG_DEBUG_PREEMPT
>   extern unsigned int debug_smp_processor_id(void);
> # define smp_processor_id() debug_smp_processor_id()
> #else
> # define smp_processor_id() raw_smp_processor_id()
> #endif
>  
> #define get_cpu()               ({ preempt_disable(); smp_processor_id(); })
> #define put_cpu()               preempt_enable()
> -- end --
> 
> ... and ...
> 
> -- excerpt from drivers/scsi/mpt2sas/mpt2sas_base.c --
> static inline u8 
> _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
> {
>         return ioc->cpu_msix_table[smp_processor_id()]; 
> }
> -- end --
> 
> Suggestion: Use get_cpu() and put_cpu().

you mean

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0b2c955..5235068 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1785,7 +1785,9 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	int cpu = get_cpu();
+	put_cpu();
+	return ioc->cpu_msix_table[cpu];
 }
 
 /**


This is the I/O hot path we're talking about.  The point about this use
of smp_processor_id() is that if the block layer doesn't specify a CPU
affinity for the request and we're using MSI interrupt steering, we have
to (because the MSIs steer to different CPUs), so we just fill in the
approximation of the current CPU ... we don't care that it be exactly
accurate at the time.  We need the lightest weight way of getting
current CPU (and we don't care if it changes because of pre-empt at the
next instruction).

I suppose doing the above is only a couple of extra instruction cycles,
but it is pretty pointless and all to silence a spurious warning.

James


