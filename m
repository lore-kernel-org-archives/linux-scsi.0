From: Steve McIntyre <steve@einval.com>
Subject: Re: Is it possible to support a sector size 8192
Date: Sat, 23 Jul 2005 19:56:14 +0100
Message-ID: <E1DwPAU-00072R-DF@sledge.mossbank.org.uk>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:50696 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S261306AbVGWS4P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2005 14:56:15 -0400
In-Reply-To: <200507231528.20356.jhml@gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jhml@gmx.net
Cc: linux-scsi@vger.kernel.org, smcintyre@software.plasmon.com

Johann writes:
>Wow, an answer directly from Plasmon, that's nice. :-)

On my own time at the weekend, but I like to help... :-)

>I've already got the FUSE driver (udofs-1.1-92.i386.rpm, based on
>FUSE 1.4, is this current?!).

That's the latest release, yes. We're working on a new release at the
moment.

>It is nice for a standalone drive, but we use a SCSI robotic changer
>in conjunction with an HSM system (Legato DiskXtender 2.9) which
>needs some kind of direct access to the drive. It probes for
>/dev/nst*, but I guess /dev/sd* would also work.

Ah, OK.

>I know this exact configuration is not officially supported, but I'm a bit 
>dissapointed that the limiting factor seems to be the Linux kernel. If I 
>don't find a solution, it will probably become a Solaris/SPARC solution next 
>week. :-(

:-( The problem (for us) is the hardware page size on i386. On an
architecture with a larger native page size (e.g. Alpha, sparc64), I'd
expect you'd be able to simply patch the sd driver to allow 8KB
support. A naive early attempt to do exactly that on i386 showed up
page size issues in the VM/block layer underneath, and we left it
alone at that point.

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
  Getting a SCSI chain working is perfectly simple if you remember that there
  must be exactly three terminations: one on one end of the cable, one on the
  far end, and the goat, terminated over the SCSI chain with a silver-handled
  knife whilst burning *black* candles. --- Anthony DeBoer
