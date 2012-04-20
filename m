From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() in
 preemptible
Date: Fri, 20 Apr 2012 15:07:57 +0400
Message-ID: <1334920077.5879.28.camel@dabdike>
References: <20120418031441.GA10862@parisc-linux.org>
	 <4565AEA676113A449269C2F3A549520FB5AE22E7@cosmail03.lsi.com>
	 <20120418041359.GB10862@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45347 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab2DTLIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 07:08:02 -0400
In-Reply-To: <20120418041359.GB10862@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "jejb@kernel.org" <jejb@kernel.org>

On Tue, 2012-04-17 at 22:13 -0600, Matthew Wilcox wrote:
> On Tue, Apr 17, 2012 at 09:35:49PM -0600, Moore, Eric wrote:
> >  Jan Schmidt suggested using raw_smp_processor_id()  back in February, see this: http://marc.info/?t=132974687100003&r=1&w=2
> > 
> > Alex Shi recently suggested using preempt_disable() and preempt_enable() to solve the same issue, see this: http://marc.info/?t=133274303900003&r=1&w=2
> > 
> > I believe the stack traces are there in both email discussion, they occur when CONFIG_DEBUG_PREEMPT is enabled.
> > 
> > I would rather go with the solution giving the best performance.   James Bottomley is there on the discussion with  Jan Schmidt, he suggested using get_cpu() and put_cpu().
> 
> I use get_cpu() / put_cpu() in the NVMe driver in similar circumstances.
> It's not noticable in the profiles :-)
> 
> Where my usage differs from the patch for mpt2sas is that I hold a
> reference to the CPU over the submission.  This works out well for
> me because I have per-CPU state.  Might be worth considering for your
> driver ...

Right, so in this case mpt2sas doesn't care.  It literally only needs a
notion of the current CPU for cache hotness of MSI queue return.  It
doesn't need pinning or anything else.  I think the use of
raw_smp_processor_id() in this instance is ideal, because it actually is
a "need to think about how to do this better" flag, which may mean
actually doing it in a more per-CPU state type way.

Mind you, something like

cpu = get_cpu(); put_cpu();

Is also an instant smack in the eyeballs too because it looks so daft,
so I'm not incredibly bothered.  I lean towards raw_smp_processor_id()
because it's what's actually wanted, but not strongly.

James


