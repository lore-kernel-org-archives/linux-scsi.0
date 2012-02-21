From: Jan Schmidt <list.linux-scsi@jan-o-sch.net>
Subject: Re: mpt2sas: BUG: using smp_processor_id() in preemptible
Date: Tue, 21 Feb 2012 10:01:13 +0100
Message-ID: <4F435D59.1000302@jan-o-sch.net>
References: <4F425105.4090505@jan-o-sch.net> <4565AEA676113A449269C2F3A549520FB5AE22B0@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:33857 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab2BUJBO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 04:01:14 -0500
In-Reply-To: <4565AEA676113A449269C2F3A549520FB5AE22B0@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Eric,

On 21.02.2012 00:06, Moore, Eric wrote:
> Jan - the smp_processor_id() is part of NUMA support which I added over a year ago. I don't see any problem with the driver running on sles11sp2 which has btrfs support ( I'm not sure  if CONFIG_DEBUG_PREEMPT is turned on as I have not checked).   Any theory why its oopsing in smp_processor_id() ?

-- excerpt from include/linux/smp.h --
/*
 * smp_processor_id(): get the current CPU ID.
 *
 * if DEBUG_PREEMPT is enabled then we check whether it is
 * used in a preemption-safe way. (smp_processor_id() is safe
 * if it's used in a preemption-off critical section, or in
 * a thread that is bound to the current CPU.)
[...]
 */
#ifdef CONFIG_DEBUG_PREEMPT
  extern unsigned int debug_smp_processor_id(void);
# define smp_processor_id() debug_smp_processor_id()
#else
# define smp_processor_id() raw_smp_processor_id()
#endif
 
#define get_cpu()               ({ preempt_disable(); smp_processor_id(); })
#define put_cpu()               preempt_enable()
-- end --

... and ...

-- excerpt from drivers/scsi/mpt2sas/mpt2sas_base.c --
static inline u8 
_base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
{
        return ioc->cpu_msix_table[smp_processor_id()]; 
}
-- end --

Suggestion: Use get_cpu() and put_cpu().

-Jan
