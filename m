From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Fri, 29 Oct 2010 16:50:47 -0700
Message-ID: <1288396247.19406.26.camel@haakon2.linux-iscsi.org>
References: <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
	 <1288133450.8283.723.camel@mulgrave.site>
	 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
	 <1288134713.19649.11.camel@mulgrave.site>
	 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
	 <20101027075349.GA32585@gargoyle.fritz.box>
	 <1288189658.4692.13.camel@mulgrave.site>
	 <20101028091020.GA7906@gargoyle.fritz.box> <4CC95BE8.3000909@panasas.com>
	 <1288297634.5169.302.camel@haakon2.linux-iscsi.org>
	 <20101029075019.GC8287@gargoyle.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35040 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0J3AFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 20:05:05 -0400
In-Reply-To: <20101029075019.GC8287@gargoyle.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@suse.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, julia@diku.dk, Jeff

On Fri, 2010-10-29 at 09:50 +0200, Andi Kleen wrote:
> > I would have to agree that approach does make a bit more sense..  Now
> > can some brave soul (/me looks at ak) code another script to automate
> > this for the identified legacy LLDs cases that need push down..?
> 
> For the drivers I looked at it doesn't really make too much difference,
> I don't think there was any with a really large number of returns.
> You can see that in the diffstat for the full changes.
> 

Yep, this is a valid point.  During the push down this week, I only ran
into a handful (say ~15) overly-complex SHT->queuecommand() w more than
a few return statements.  This was also isoloated for the most part into
legacy/ancient LLDs.

> Writing another script is probably not too hard, but the problem
> is that I needed a significant amount of manual post processing
> (both the select the right files to patch and to get rid
> of misplaced newlines and some mismatches in cocci) 
> So it's not a fully automated procedure.
> 

<nod>

So I really do not have a strong preference here.  I think Boaz's
approach is a bit cleaner, but in the end I think it should not hold up
on a global push-down merge for lio-4.0.git/host_lock-less-for-37-v9.

Also, at this point I have not received any other feedback from LLD
maintainers to say "My LLD should be running in lock-less mode" or "My
LLD cannot run in lock-less mode, and needs the host_lock push down".

One additional point that was raised by jgarzik was that those LLDs
running in 'lock-less' mode may need to have their internal
->queuecommand() spinlocks converted to spin_lock_irqsave() +
spin_unlock_irqrestore().  This has already been fixed for libata
following Jeff's recommendation, but we also identified a few other
potential LLDs that may need more work.  From the last response locatd
here:

http://marc.info/?l=linux-scsi&m=128825558912565&w=2

"Ok, so originally libiscsi, fnic, and lpfc where using
spin_unlock(host->host_lock) -> spin_lock(host->host_lock)

And libsas, qla2xxx, qla4xxx where using
spin_unlock_irq(host->host_lock) -> spin_lock_irq(host->host_lock)

Just to verify, you are thinking that those *not* using spin_unlock_irq
+ spin_lock_irq() for the legacy optimization dispatch should have their
per LLD host lock converted to spin_lock_irqsave() +
spin_unlock_irqrestore(), right..?"

So I think that means an audit of locks obtained in libiscsi, fnic and lpfc
will be in to ensure they do not assume irqs have alreadby been externally
disabled for lock-less operation..

Any comments folks..?

--nab

