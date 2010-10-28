From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Thu, 28 Oct 2010 11:10:20 +0200
Message-ID: <20101028091020.GA7906@gargoyle.fritz.box>
References: <20101021150840.GA24309@linux.vnet.ibm.com>
 <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
 <1288132071.8283.689.camel@mulgrave.site>
 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
 <1288133450.8283.723.camel@mulgrave.site>
 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
 <1288134713.19649.11.camel@mulgrave.site>
 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
 <20101027075349.GA32585@gargoyle.fritz.box>
 <1288189658.4692.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24920 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0J1JIH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 05:08:07 -0400
Content-Disposition: inline
In-Reply-To: <1288189658.4692.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, julia@diku.dk

On Wed, Oct 27, 2010 at 09:27:38AM -0500, James Bottomley wrote:
> On Wed, 2010-10-27 at 09:53 +0200, Andi Kleen wrote:
> > > This sounds like a pretty reasonable compromise that I think is slightly
> > > less risky for the LLDs with the ghosts and cob-webs hanging off of
> > > them.
> > 
> > They won't get tested either next release cycle. Essentially
> > near nobody uses them.
> > 
> > > 
> > > What do you think..?
> > 
> > Standard linux practice is to simply push the locks down. That's a pretty
> > mechanical operation and shouldn't be too risky
> > 
> > With some luck you could even do it with coccinelle.
> 
> Precisely ... if we can do the push down now as a mechanical
> transformation we can put it in the current merge window as a low risk
> API change.  This gives us optimal exposure to the rc sequence to sort
> out any problems that arise (or drivers that got missed) with the lowest
> risk of such problems actually arising.  Given the corner cases and the
> late arrival of fixes, the serial number changes are just too risky for
> the current merge window.  Having an API that changes depending on a
> flag is also a high risk process because it's prone to further sources
> of error.

Here's a coccinelle script I came up with that does the push down.
It still adds a bogus empty line in front of the irqflags declaration
which I haven't managed to avoid yet. Other than the it seems
to DTRT on the SCSI drivers I tried.

-Andi


@ rule1 @
struct scsi_host_template t;
identifier qc;
@@
t.queuecommand = qc;

@ rule2 @
identifier rule1.qc;
identifier cmnd;
expression E;
statement S, S2;
@@
int qc(struct scsi_cmnd *cmnd, ...) 
{
	... when != S
+	unsigned long irqflags;

+	spin_lock_irqsave(&cmnd->device->host->hostlock, irqflags);
	S2
	...
+	spin_unlock_irqrestore(&cmnd->device->host->hostlock, irqflags);
	return E;
}



