From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 14:06:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921210614.GD146363@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD911@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:406 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S268048AbUIUVGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:06:43 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0012AD911@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 01:50:02PM -0700, Andrew Vasquez wrote:
> 
> Yes, please see my earlier reply to Matthew:
> 
> 	Hmm...adding more confusion to the mix.  I apologize -- my
> 	reply was not written correctly, yes, the config-read will
> 	flush any pending writes.  But, the same problem persists 
> 	- the RISC will still stop responding to requests (config
> 	or MMIO) during the soft-reset -- potentially resulting in
> 	a MAC (as seen by SGI).

Sorry, I should have read all 30 or so messages before replying to
any  :-)

> > . . . unless there is some sort of random delay within the chip
> > itself between a completion of the IO write on the PCI bus and the
> > chip resetting itself.  That's not a problem, is it, Andrew?
> >
> 
> The only requirement after reception of a soft-reset request (by PIO
> or MMIO) by the RISC is for the driver to wait 16 PCI clocks before
> issuing another request.  The problem of course is determining when to
> start timing within the driver.

So I think that we just wait for some reasonable worst case time for
the write to complete.  We can't really do anything else.

Are these resets done as part of error recovery?  I.e., do we have
to be concerned about long the write will take on a busy system?

jeremy
