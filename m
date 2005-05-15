From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: 53C8XX /sys/devices/pci*/*/config revisited
Date: Sun, 15 May 2005 15:48:59 +0100
Message-ID: <20050515144859.GB11071@parcelfarce.linux.theplanet.co.uk>
References: <m3br7c4ur6.fsf@merlin.emma.line.org> <1116155603.6270.16.camel@laptopd505.fenrus.org> <1116156415.6270.19.camel@laptopd505.fenrus.org> <20050515125658.GA17625@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:26076 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262832AbVEOOsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 10:48:41 -0400
Content-Disposition: inline
In-Reply-To: <20050515125658.GA17625@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, gregkh@kroah.com

On Sun, May 15, 2005 at 02:56:59PM +0200, Matthias Andree wrote:
> On Sun, 15 May 2005, Arjan van de Ven wrote:
> > > if hal reads more than 64 bytes of config space (heck if it reads config
> > > space at all) then it's terminally broken.
> > 
> > this brings up a bug in the kernel though....
> > the config file is user readable! That's just plain dangerous and imo it
> > should be a root-only file as a result.

The same is true of /proc/bus/pci.  Otherwise lspci doesn't work for non-root.

> The user can access only the first 64 bytes, but hald is apparently
> meant to run as root so it can hack /etc/fstab for subfs file systems
> and such. SUSE Linux 9.3 runs hald as root.
> 
> BTW, - note I have little clue of how PCI works - if the PCI
> configuration space is only 64 bytes tall, then why the f* is the sysfs
> .../config file listed as 256 bytes in the first place, even for root?

PCI has 256 bytes of config space.  However, not all vendors do sane
things with it (even though they're required to).  It's a bug in hald
that it reads more than it needs to ...

> Relevant pointers to free copies of the PCI standard (the old 32 bit 33
> MHz variant is sufficient) welcome, if such are available.

While they are not freely available, knowing that the name of the file is
"pci22.pdf" might help one locate non-legitimate copies.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
