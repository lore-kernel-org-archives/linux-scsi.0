From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 22 Nov 2004 13:30:14 +0000
Message-ID: <20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org> <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org> <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> <m3actaw0pv.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:59826 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262096AbUKVNaR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 08:30:17 -0500
Content-Disposition: inline
In-Reply-To: <m3actaw0pv.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Steffen Winterfeldt <snwint@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, matthew@wil.cx

On Mon, Nov 22, 2004 at 01:02:36PM +0100, Matthias Andree wrote:
> [Context: SuSE's hwscan --pci and lspci -xxx trigger SCSI parity errors
> on reading /sys/devices/pci*/*/config of sym53c8xx devices, possibly
> including phase fixup, a non-working abort loop of up to 2 minutes that
> ends in a SCSI bus reset that fixes it, details below]
> 
> I found a minimal way to reproduce the problem:

Aha, this is wonderful.

> (adjust bus and device no. as appropriate, try: /sbin/lspci | grep 53c8):
> 
> cd /sys/devices/pci0000:00/0000:00:0d.0
> dd if=config bs=1 count=1 of=/dev/null skip=216
> 
> hwscan or lspci -xxx reads all of the config file (256 bytes) which
> includes this byte, lspci without -xxx reads selectively the first 68
> bytes in several stages and avoids this (except lspci -xxx which also
> triggers the parity error as it reads the whole 256 bytes).

*nod*.  The manpage does warn about this:

       -xxx   Show  hexadecimal  dump of whole PCI configuration space. Avail-
              able only for root as several PCI devices crash when you try  to
              read  undefined  portions  of  the  config space (this behaviour
              probably doesn't violate the PCI standard,  but  it's  at  least
              very stupid).

I can reproduce this on my sym53c810:

sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
sym0: SCSI parity error detected: SCR1=3 DBC=50000000 SBCL=0
sym0:1:0:M_REJECT received (0:8).

> So it looks as though the byte at offset 216 in
> /sys/devices/pci0000:00/0000:00:0d.0/config was "poisonous" for reading
> somehow. I haven't dared to write there.

Aha.  Now I see this note in the 810a docs:

   The lower 128 bytes hold configuration data while the upper 128
   bytes hold the LSI53C810A operating registers, which are described
   in Chapter 5, "Operating Registers." The operating registers can be
   accessed by SCRIPTS or the host processor.

So you're actually reading the SBDL (SCSI Bus Data Lines) register.  
I guess it shouldn't surprise us too much that this causes parity errors
when we read that:

   The signal status is not latched and is a true representation of
   exactly what is on the data bus at the time the register is read. This
   register is used when receiving data using programmed I/O. This
   register can also be used for diagnostic testing or in low level mode.

> Questions:
> 
> 1. is it necessary that hwscan reads the whole configuration space?

No.  hwscan should use libpci rather than accessing the pci space itself.

> 2. is it a kernel bug if reading offset #216 (byte-wise) in the config
>    file in sysfs confuses the hardware?

No, but it does seem to me that we could do better.  Unfortunately,
the obvious thing to do (set the file size to less than 256 bytes) isn't
really possible in sysfs.  But we could use the 'undocumented feature'
in drivers/pci/pci-sysfs.c:pci_read_config() of setting the pci_dev's
cfg_size to 128 bytes.  This would prevent even root from reading more
than 128 bytes.  That'd be OK -- there's no *PCI* data in this range,
even on the latest 1010/1030 controllers.  The operating registers are
exposed in the 0x80-0xFF range only up to the 875; the 876 and later
return only 0 in that range.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
