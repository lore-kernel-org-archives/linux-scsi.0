From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Tue, 31 Oct 2006 14:24:01 -0500
Message-ID: <1162322643.13859.54.camel@mulgrave.il.steeleye.com>
References: <20061020180510.GN6537@austin.ibm.com>
	 <20061031185506.GE26964@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [71.30.118.248] ([71.30.118.248]:27837 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1423810AbWJaTZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 14:25:09 -0500
In-Reply-To: <20061031185506.GE26964@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linas Vepstas <linas@austin.ibm.com>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org

On Tue, 2006-10-31 at 11:55 -0700, Matthew Wilcox wrote:
> Is it safe / reasonable / a good idea to sleep for 35 seconds in the EH
> handler?  I'm not that familiar with how the EH code works.  It has its
> own thread, so I suppose that's OK.

Yes, each host has its own thread.  Ordinarily it would be impolite to
delay recovery this long, but I assume that since the card is wedged
there's nothing else it could be doing anyway.

Just for my own edification, what happens on the dual function (dual
channel) boards?  We have two threads there and two separate I/O
processors.  I assume a PCI error will kill both, do we need to do
something about this?

James



> I generally prefer not to be so perlish in conditionals, ie:
> 
>         if ((np->s.device->error_state != pci_channel_io_normal) &&
>             (np->s.device->error_state != 0) {
>                 int timed_out = wait_for_completion_timeout(
>                         &np->s.io_reset_wait, WAIT_FOR_PCI_RECOVERY*HZ);
>                 if (!timed_out)
>                         return SCSI_FAILED;
>         }
> 
> Why is the condition so complicated though?  What does 0 mean if it's
> not io_normal?  At least let's hide that behind a convenience macro:
> 

