From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 22 Nov 2004 13:02:36 +0100
Message-ID: <m3actaw0pv.fsf@merlin.emma.line.org>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
	<1100473795.23649.26.camel@mulgrave>
	<m3hdnsvvfd.fsf@merlin.emma.line.org>
	<1100477105.24921.3.camel@mulgrave>
	<m34qjrx6iy.fsf_-_@merlin.emma.line.org>
	<Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:9428 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261834AbUKVMCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 07:02:41 -0500
In-Reply-To: <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> (Steffen
	Winterfeldt's message of "Mon, 22 Nov 2004 11:35:26 +0100 (CET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Winterfeldt <snwint@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, matthew@wil.cx

Steffen Winterfeldt <snwint@suse.de> writes:

[Context: SuSE's hwscan --pci and lspci -xxx trigger SCSI parity errors
on reading /sys/devices/pci*/*/config of sym53c8xx devices, possibly
including phase fixup, a non-working abort loop of up to 2 minutes that
ends in a SCSI bus reset that fixes it, details below]
> hwinfo is just a normal program and doesn't do any special tricks on
> hardware. In particular, it issues an scsi inquiry command to get the serial
> number, but that's about all.
>
> If running just hwinfo breaks things for you, you might try running it
> through strace and look at the files it accesses. Maybe that gives some hint
> to narrow things down.

[dropping Andrew and Linus from the Cc:, adding Matthew Wilcox instead I
 think if it's a kernel issue, this can be propagated by the SCSI or
 SYM53C8XX maintainers]

I found a minimal way to reproduce the problem:

(adjust bus and device no. as appropriate, try: /sbin/lspci | grep 53c8):

cd /sys/devices/pci0000:00/0000:00:0d.0
dd if=config bs=1 count=1 of=/dev/null skip=216

hwscan or lspci -xxx reads all of the config file (256 bytes) which
includes this byte, lspci without -xxx reads selectively the first 68
bytes in several stages and avoids this (except lspci -xxx which also
triggers the parity error as it reads the whole 256 bytes).

So it looks as though the byte at offset 216 in
/sys/devices/pci0000:00/0000:00:0d.0/config was "poisonous" for reading
somehow. I haven't dared to write there.

I wonder if hwscan should (and needs to) read the whole config space or
can go along with less, as lspci does.

Questions:

1. is it necessary that hwscan reads the whole configuration space?

2. is it a kernel bug if reading offset #216 (byte-wise) in the config
   file in sysfs confuses the hardware?

3. both?

-- 
Matthias Andree
