From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 18:36:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211836.36367.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD911@AVEXCH02.qlogic.org> <20040921210614.GD146363@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:21227 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267189AbUIUWgw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 18:36:52 -0400
In-Reply-To: <20040921210614.GD146363@sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 5:06 pm, Jeremy Higdon wrote:
> > The only requirement after reception of a soft-reset request (by PIO
> > or MMIO) by the RISC is for the driver to wait 16 PCI clocks before
> > issuing another request.  The problem of course is determining when to
> > start timing within the driver.
>
> So I think that we just wait for some reasonable worst case time for
> the write to complete.  We can't really do anything else.

Shouldn't we do a config space read and *then* start the delay, which will 
only delay for as long as it takes to reset the card on a 33 MHz bus?

> Are these resets done as part of error recovery?  I.e., do we have
> to be concerned about long the write will take on a busy system?

If reading from config space isn't sufficient, then we'd be in trouble in that 
case.

Jesse
