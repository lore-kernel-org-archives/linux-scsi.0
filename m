From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: SCSI enclosure black list
Date: 14 Nov 2002 10:24:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037298273.16635.132.camel@dell_ss3.pdx.osdl.net>
References: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net>
	<1037227816.11996.203.camel@irongate.swansea.linux.org.uk>
	<1037289000.30355.6.camel@markh1.pdx.osdl.net>
	<1037291446.16000.37.camel@irongate.swansea.linux.org.uk>
	<1037290824.30367.11.camel@markh1.pdx.osdl.net>
	<1037298585.16000.45.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1037298585.16000.45.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Domsch <Matt_Domsch@Dell.com>
Cc: Mark Haverkamp <markh@osdl.org>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org, linux-megaraid-devel@Dell.com

On Thu, 2002-11-14 at 10:29, Alan Cox wrote:
> On Thu, 2002-11-14 at 16:20, Mark Haverkamp wrote:
> > Wouldn't it still be reasonable to have the enclosure in the blacklist
> > since it doesn't seem to handle the report luns command?
> 
> I wasnt aware it was required to

The 2.5 SCSI probe code first finds all the targets, then does a report
LUN's.  The problem appears to be that these high end enclosure's don't
support report LUN's.  Maybe the SCSI code should not try the report
LUN's for all "Processor" targets?  or go back to the old way of probing
the LUN's for this type.

There are two separate issues: 
1. Error handling in megaraid is borken. Have seen cases where the
command completes after the timeout and DMA's to random memory. Haven't
seen a working driver yet.  The patched v1 driver fails, and the v2
driver panics in a different way on boot up.

OSDL will happily provide access to machines if the megaraid developers
need it.

2. Not causing the error in the first place seems like a good idea.

Right now, OSDL just needs drivers that work with the hardware on 2.5,
so take any patches as just suggestions. Fix it however is most
appropriate.



