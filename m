From: Phil Thompson <philt@4bridgeworks.com>
Subject: RE: Support for LSI 53C1010R
Date: Tue, 13 Apr 2004 17:03:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C18BA5DDB58DD511BD0700C0DF0DD45028B296@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.digitalinterfacesltd.com ([62.69.87.37]:21513 "EHLO
	ntserver4.diluk.co.uk") by vger.kernel.org with ESMTP
	id S263620AbUDMQDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 12:03:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <willy@debian.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Matthew Wilcox [mailto:willy@debian.org] 
> Sent: 13 April 2004 16:09
> To: Phil Thompson
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: Support for LSI 53C1010R
> 
> 
> On Tue, Apr 13, 2004 at 02:21:13PM +0100, Phil Thompson wrote:
> > I'm having problems with the Linux sym53c8xx_2 
> (sym-2.1.17a) driver on 
> > an embedded system with an LSI 53C1010R. Are there any 
> issues with the 
> > driver and that revision of the chip - specifically the R suffix?
> 
> I don't have a 1010R myself, only the data sheet.
> 
> > The driver tries to do some things with the chip which 
> (according to 
> > the
> > datasheet) aren't supported. For example, the first problem 
> is that it fails
> > to determine the PCI clock frequency - it times out in 
> sym_hipd.c:getfreq()
> > waiting for the GEN flag (almost as if there is no SCSI 
> clock). Just prior
> > to this (in sym_getpciclock()) it tries to set the SCLK bit 
> of STEST1 in
> > order to use the PCI clock as the SCSI clock - but that bit 
> is reserved
> > according to the datasheet.
> 
> Yes.  It's reserved for the 1010 too, and this problem 
> doesn't occur there.  Does the problem go away if you stop 
> setting that bit?  If so it would be straightforward to 
> conditionalise this setting on a feature bit. My guess is 
> that it's something else though.

It doesn't make any difference if I skip the calls and hardwire the PCI
frequency to 66000. The next problem is that sym_snooptest() fails - also
with a timeout.

I've gone through the datasheet and the driver to check for any other
reserved bits/registers that are being used - SCLK is the only one.

I agree that it's looking like something else.

> > The same hardware seems to work with a much simpler, internally 
> > written, driver.
> 
> I'd like to simplify the sym2 driver; it's far too 
> complicated.  It'll take a while though.

Either the simple driver isn't using as much of the hardware (and there is a
hardware bug), or the bootloader isn't setting something up that the Linux
driver is expecting.

Thanks,
Phil
