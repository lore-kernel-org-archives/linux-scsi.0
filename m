From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 22 Nov 2004 15:05:29 +0100
Message-ID: <m3mzxaq8ra.fsf@merlin.emma.line.org>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
	<1100473795.23649.26.camel@mulgrave>
	<m3hdnsvvfd.fsf@merlin.emma.line.org>
	<1100477105.24921.3.camel@mulgrave>
	<m34qjrx6iy.fsf_-_@merlin.emma.line.org>
	<Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
	<m3actaw0pv.fsf@merlin.emma.line.org>
	<20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:60374 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S262131AbUKVOFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 09:05:34 -0500
In-Reply-To: <20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
	(Matthew Wilcox's message of "Mon, 22 Nov 2004 13:30:14 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, Steffen Winterfeldt <snwint@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>

Matthew Wilcox <matthew@wil.cx> writes:

>> I found a minimal way to reproduce the problem:
>
> Aha, this is wonderful.

Indeed, this has annoyed me for around half a year.
How did I know you'd like to see the triggering element? :-)

I'm relieved we know the cause now and can go fixing, and SuSE will be
relieved to know that the vanilla kernel is part of the problem.

> *nod*.  The [lspci] manpage does warn about this:
>
>    -xxx   Show  hexadecimal  dump of whole PCI configuration space. Avail-
>           able only for root as several PCI devices crash when you try  to
>           read  undefined  portions  of  the  config space (this behaviour
>           probably doesn't violate the PCI standard,  but  it's  at  least
>           very stupid).

Right. I was checking for other way to trigger the parity error.

In 2.6.9, I'm getting a short read (only 64 bytes) if I try to read the
.../config file as the user, but the full file as root.

> So you're actually reading the SBDL (SCSI Bus Data Lines) register.  
> I guess it shouldn't surprise us too much that this causes parity errors
> when we read that:
>
>    The signal status is not latched and is a true representation of
>    exactly what is on the data bus at the time the register is read. This
>    register is used when receiving data using programmed I/O. This
>    register can also be used for diagnostic testing or in low level
>    mode.

Makes sense if we're stealing a data byte.

BTW, is it correct that the driver/hardware can go into an ABORT/ABORT
timed-out loop like this (I stripped hostname and date)? This is still
Linux-2.6.9, where only the bus reset gets this straight again?

12:35:30 sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
12:36:03 sym0:1:0: ABORT operation started.
12:36:08 sym0:1:0: ABORT operation timed-out.
12:36:08 sym0:1:0: ABORT operation started.
12:36:13 sym0:1:0: ABORT operation timed-out.
12:36:13 sym0:1:0: ABORT operation started.
12:36:18 sym0:1:0: ABORT operation timed-out.
12:36:18 sym0:1:0: ABORT operation started.
12:36:23 sym0:1:0: ABORT operation timed-out.
12:36:23 sym0:1:0: DEVICE RESET operation started.
12:36:28 sym0:1:0: DEVICE RESET operation timed-out.
12:36:28 sym0:1:0: BUS RESET operation started.
12:36:28 sym0: SCSI BUS reset detected.
12:36:28 sym0: SCSI BUS has been reset.
12:36:28 sym0:1:0: BUS RESET operation complete.

>> 2. is it a kernel bug if reading offset #216 (byte-wise) in the config
>>    file in sysfs confuses the hardware?
>
> No, but it does seem to me that we could do better.  Unfortunately,
> the obvious thing to do (set the file size to less than 256 bytes) isn't
> really possible in sysfs.

> But we could use the 'undocumented feature'
> in drivers/pci/pci-sysfs.c:pci_read_config() of setting the pci_dev's
> cfg_size to 128 bytes.  This would prevent even root from reading more
> than 128 bytes.

Let me know if you have a patch. I'm not usually enthusiastic about
getting the latest and greatest fixes now, but I'm really eager to try
this.

> That'd be OK -- there's no *PCI* data in this range,
> even on the latest 1010/1030 controllers.  The operating registers are
> exposed in the 0x80-0xFF range only up to the 875; the 876 and later
> return only 0 in that range.

Right, SYM53C875 and SYM53C860 here.

-- 
Matthias Andree
