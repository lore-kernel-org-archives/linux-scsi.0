From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() in
	preemptible
Date: Tue, 17 Apr 2012 22:13:59 -0600
Message-ID: <20120418041359.GB10862@parisc-linux.org>
References: <20120418031441.GA10862@parisc-linux.org> <4565AEA676113A449269C2F3A549520FB5AE22E7@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52242 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2DREOB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 00:14:01 -0400
Content-Disposition: inline
In-Reply-To: <4565AEA676113A449269C2F3A549520FB5AE22E7@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "jejb@kernel.org" <jejb@kernel.org>

On Tue, Apr 17, 2012 at 09:35:49PM -0600, Moore, Eric wrote:
>  Jan Schmidt suggested using raw_smp_processor_id()  back in February, see this: http://marc.info/?t=132974687100003&r=1&w=2
> 
> Alex Shi recently suggested using preempt_disable() and preempt_enable() to solve the same issue, see this: http://marc.info/?t=133274303900003&r=1&w=2
> 
> I believe the stack traces are there in both email discussion, they occur when CONFIG_DEBUG_PREEMPT is enabled.
> 
> I would rather go with the solution giving the best performance.   James Bottomley is there on the discussion with  Jan Schmidt, he suggested using get_cpu() and put_cpu().

I use get_cpu() / put_cpu() in the NVMe driver in similar circumstances.
It's not noticable in the profiles :-)

Where my usage differs from the patch for mpt2sas is that I hold a
reference to the CPU over the submission.  This works out well for
me because I have per-CPU state.  Might be worth considering for your
driver ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
