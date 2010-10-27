From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 27 Oct 2010 12:20:25 -0700
Message-ID: <20101027192025.GA1349@linux.vnet.ibm.com>
References: <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
 <1288132071.8283.689.camel@mulgrave.site>
 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
 <1288133450.8283.723.camel@mulgrave.site>
 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
 <1288134713.19649.11.camel@mulgrave.site>
 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
 <20101027075349.GA32585@gargoyle.fritz.box>
 <1288189658.4692.13.camel@mulgrave.site>
 <1288202802.5169.202.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36195 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab0J0TUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 15:20:47 -0400
Content-Disposition: inline
In-Reply-To: <1288202802.5169.202.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <ak@linux.intel.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> On Wed, 2010-10-27 at 09:27 -0500, James Bottomley wrote:
> > On Wed, 2010-10-27 at 09:53 +0200, Andi Kleen wrote:
> > > > This sounds like a pretty reasonable compromise that I think is slightly
> > > > less risky for the LLDs with the ghosts and cob-webs hanging off of
> > > > them.
> > > 
> > > They won't get tested either next release cycle. Essentially
> > > near nobody uses them.
> > > 
> > > > 
> > > > What do you think..?
> > > 
> > > Standard linux practice is to simply push the locks down. That's a pretty
> > > mechanical operation and shouldn't be too risky
> > > 
> > > With some luck you could even do it with coccinelle.
> > 
> > Precisely ... if we can do the push down now as a mechanical
> > transformation we can put it in the current merge window as a low risk
> > API change.
> 
> I disagree that touching every single legacy LLD's SHT->queuecommand()
> and failure paths in that code is a low rist change.
> 
> >   This gives us optimal exposure to the rc sequence to sort
> > out any problems that arise (or drivers that got missed) with the lowest
> > risk of such problems actually arising.
> 
> Yes, 
> 
> > Given the corner cases and the
> > late arrival of fixes, the serial number changes are just too risky for
> > the current merge window.
> 
> I think with andmike's testing and ACKs for the necessary scsi_error.c
> changes this would be an acceptable risk.
> 

Adding SCSI_EH_SOFTIRQ_DONE in scsi_softirq_done is not going to provide
value in scsi_try_to_abort_cmd. scsi_softirq_done calls scsi_eh_scmd_add
without the SCSI_EH_CANCEL_CMD flag set which will stop
scsi_try_to_abort_cmd from being called.

Removing the serial_number check in scsi_try_to_abort_cmd and not
replacing it may be the correct action as we should be relying on the
block complete checking. That said what James has indicated about
splitting the serial number change out seems like the lower risk approach
at this time.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
