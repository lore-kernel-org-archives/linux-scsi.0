From: Steffen Winterfeldt <snwint@suse.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 22 Nov 2004 14:05:05 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411221350400.22230@ligeti.suse.de>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
 <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org>
 <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org>
 <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> <m3actaw0pv.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from news.suse.de ([195.135.220.2]:14308 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262097AbUKVNFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 08:05:09 -0500
In-Reply-To: <m3actaw0pv.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, matthew@wil.cx

On Mon, 22 Nov 2004, Matthias Andree wrote:

> Steffen Winterfeldt <snwint@suse.de> writes:

[...]

> I found a minimal way to reproduce the problem:
> 
> (adjust bus and device no. as appropriate, try: /sbin/lspci | grep 53c8):
> 
> cd /sys/devices/pci0000:00/0000:00:0d.0
> dd if=config bs=1 count=1 of=/dev/null skip=216
> 
> hwscan or lspci -xxx reads all of the config file (256 bytes) which
> includes this byte, lspci without -xxx reads selectively the first 68
> bytes in several stages and avoids this (except lspci -xxx which also
> triggers the parity error as it reads the whole 256 bytes).
> 
> So it looks as though the byte at offset 216 in
> /sys/devices/pci0000:00/0000:00:0d.0/config was "poisonous" for reading
> somehow. I haven't dared to write there.
> 
> I wonder if hwscan should (and needs to) read the whole config space or
> can go along with less, as lspci does.
> 
> Questions:
> 
> 1. is it necessary that hwscan reads the whole configuration space?

No, it isn't.

Just checked and it looks like though hwinfo itself is careful to read just
the first 64 bytes + capability list, some libsysfs call reads the config
completely.

I'll look at it closer.

> 2. is it a kernel bug if reading offset #216 (byte-wise) in the config
>    file in sysfs confuses the hardware?

It's IMO a hardware problem. We've seen this in past (with symbios cards,
IIRC).


Steffen
