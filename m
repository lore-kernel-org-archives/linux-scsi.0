From: Ingo Molnar <mingo@elte.hu>
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Wed, 18 Feb 2009 20:20:07 +0100
Message-ID: <20090218192007.GE8889@elte.hu>
References: <20090215115823.GB19464@elte.hu> <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org> <20090218155817.GC23989@elte.hu> <20090218191643.GA16347@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:45518 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZBRTUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 14:20:25 -0500
Content-Disposition: inline
In-Reply-To: <20090218191643.GA16347@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org


* Mike Anderson <andmike@linux.vnet.ibm.com> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > * Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > I have no idea if this will make any difference for the 
> > > problem you're seeing, but it has been submitted and it's 
> > > worth trying out.  If the problem still occurs, I'll write a 
> > > diagnostic patch to add log messages giving the destiny of 
> > > each request in scsi_io_completion().
> > 
> > OK, i've undone the reverts and have applied your fix - it will 
> > take a few hours to see whether the hang still occurs.
> 
> I know already started your testing, but..

and that particular box already survived 20 test iterations in 
the past few hours - while it would hang after 5-10 iterations 
before. So i think Alan's fix is making a difference. I'll be 
able to tell for sure tomorrow morning.

> I find it informative to set my scsi logging to the value 
> below to display non-zero IO status on commands. The overhead 
> impact is low for good completions.
> 
> sysctl -w dev.scsi.logging_level=4100
> 
> Note: This does not provide the exact policy that 
> scsi_io_completion will take on the IO, but it provides the 
> input to scsi_io_completion which should help.

will do that next time around i have a bug like this. (or if 
this bug triggers again)

OTOH, the hang took quite a bit of IO to occur. Sometimes the 
box would be able to build a new kernel and reboot into it, 
without the hang.

	Ingo
