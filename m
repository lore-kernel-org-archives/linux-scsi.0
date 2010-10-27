From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 27 Oct 2010 11:03:34 -0700
Message-ID: <1288202614.5169.197.camel@haakon2.linux-iscsi.org>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
	 <20101021150840.GA24309@linux.vnet.ibm.com>
	 <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
	 <1288132071.8283.689.camel@mulgrave.site>
	 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
	 <1288133450.8283.723.camel@mulgrave.site>
	 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
	 <1288134713.19649.11.camel@mulgrave.site>
	 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
	 <20101027075349.GA32585@gargoyle.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8.bullet.mail.ac4.yahoo.com ([98.139.52.205]:44915 "HELO
	nm8.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754126Ab0J0SId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 14:08:33 -0400
In-Reply-To: <20101027075349.GA32585@gargoyle.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

On Wed, 2010-10-27 at 09:53 +0200, Andi Kleen wrote:
> > This sounds like a pretty reasonable compromise that I think is slightly
> > less risky for the LLDs with the ghosts and cob-webs hanging off of
> > them.
> 
> They won't get tested either next release cycle. Essentially
> near nobody uses them.
> 

This is exactly my point.  Using this series does not introduce
distruptive changes into LLDs that will be getting little or no testing
wrt the changes to enable lock-less operation with the modern LLDs that
we actually care about.  When running with the default of
SHT->unlocked_qcmd=0, the legacy LLDs will continue to function
*exactly* the same, minus those that are now using the explict
scsi_cmd_get_serial() call because they use cmd->serial_number for
something beyond simple informational purposes.

> > 
> > What do you think..?
> 
> Standard linux practice is to simply push the locks down. That's a pretty
> mechanical operation and shouldn't be too risky
> 

No disagreements here whatsoever, as I think that pushing the locks
approach does make alot sense as the final goal.  The question is if
starting with this series is less disruptive and less error prone than
adding a new host_lock -> lock() and unlock() in SHT->queuecommand() of
every single legacy LLD and every single failure path for that legacy
code.

The benfits on this series is having to add less LOC, not having to
touch lots legacy LLD code ->queuecommand() that will get little or no
testing, and the 'by default' setting of using SHT->unlocked_qcmd=0 (eg:
legacy mode).  I believe it makes sense that merging this approach first
and then transitioning to pushing the locks in per LLDs specific
SHT->queuecommand() would be the most logical two steps for a graceful
transition to optional host_lock less scsi_dispatch_cmd().

Best,

--nab

