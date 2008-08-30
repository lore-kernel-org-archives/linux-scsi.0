From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Date: Sat, 30 Aug 2008 11:45:16 -0600
Message-ID: <20080830174516.GD1239@parisc-linux.org>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43514 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYH3Rpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2008 13:45:33 -0400
Content-Disposition: inline
In-Reply-To: <1220117091.3615.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Aug 30, 2008 at 12:24:50PM -0500, James Bottomley wrote:
> linux-scsi is the correct list for this, cc's added
> 
> On Sat, 2008-08-30 at 15:08 +0100, Simon Arlott wrote:
> > The capacity printk'd in bytes is divided by 1000000,
> > whereas 1048576 would be more consistent with the rest
> > of the OS and disk-related utilities ('df' etc.).

> > -		/* avoid 64-bit division on 32-bit platforms */
> > -		sector_div(sz, 625);
> > -		mb -= sz - 974;
> > -		sector_div(mb, 1950);
> > +		/* Convert to megabytes (/2048) */
> > +		mb = sz >> 11;
> >  
> >  		sd_printk(KERN_NOTICE, sdkp,
> >  			  "%llu %d-byte hardware sectors (%llu MB)\n",
> 
> No, this is wrong.  By mandated standards the manufacturers are allowed
> to calculate MB by dividing by 10^6.  This is a fiddle to allow them to
> make their drives look slightly bigger.  However, we want the printed
> information to match that written on the drive, so in this printk, we
> use the manufacturer standard for calculation (and then do everything
> else in bytes so we don't have to bother with it ever again).

I was looking at this code recently because it looks really bizarre when
you create a half-petabyte filesystem:

$ sudo insmod drivers/ata/ata_ram.ko capacity=1099511627776 preallocate=0

[12095.028093] ata7.00: 1099511627776 sectors, multi 0: LBA48 NCQ (depth 31/32)
[12095.028093] ata7.00: configured for UDMA/133
[12095.041915] scsi 7:0:0:0: Direct-Access     ATA      Linux RAM Drive 0.01 PQ: 0 ANSI: 5
[12095.041915] sd 7:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
[12095.041915] sd 7:0:0:0: [sdc] 1099511627776 512-byte hardware sectors (562949953 MB)
[12095.041915] sd 7:0:0:0: [sdc] Write Protect is off
[12095.041915] sd 7:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

1. Avoiding 64-bit divisions is _so_ last decade.  We have
linux/math64.h, we should use it.

2. We should report in GB or TB when appropriate.  The exact definition
of 'appropriate' is going to vary from person to person.  Might I
suggest that we should report between two and four significant digits.
eg 9543 MB is ok, 10543 MB should be 10 GB.

3. I hate myself for saying this ... but maybe we should be using the
horrific MiB/GiB/TiB instead of MB/GB/TB.

4. I've been far too busy to write said patch.  Simon, would you mind
doing the honours?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
