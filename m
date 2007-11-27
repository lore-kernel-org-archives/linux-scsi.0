From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1
Date: Mon, 26 Nov 2007 22:15:09 -0800
Message-ID: <20071126221509.8f437b61.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<47462F3C.3040700@googlemail.com>
	<20071122201250.f957e280.akpm@linux-foundation.org>
	<47466B5D.90607@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbXK0GPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2007 01:15:18 -0500
In-Reply-To: <47466B5D.90607@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Fri, 23 Nov 2007 06:55:41 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> > On Fri, 23 Nov 2007 02:39:08 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:
> > 
> >> I have some warnings on each SCSI disc:
> >>
> >>
> >> ...
> >>
> >> [   30.724410] scsi 0:0:0:0: Direct-Access     SEAGATE  ST318406LW       0109 PQ: 0 ANSI: 3
> >> [   30.724419] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
> >> [   30.724435]  target0:0:0: Beginning Domain Validation
> >> [   30.724446]  target0:0:0: Domain Validation Initial Inquiry Failed <--
> >> [   30.724572]  target0:0:0: Ending Domain Validation
> >> [   30.729747] scsi 0:0:1:0: Direct-Access     FUJITSU  MAH3182MP        0114 PQ: 0 ANSI: 4
> >> [   30.729754] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
> >> [   30.729771]  target0:0:1: Beginning Domain Validation
> >> [   30.729780]  target0:0:1: Domain Validation Initial Inquiry Failed <--
> >> [   30.729908]  target0:0:1: Ending Domain Validation
> >>
> > 
> > Don't know what would have caused that.  But yes, something is wrong in
> > scsi land.
> 
> Actually I'm lucky the author didn't fix that FIXME in scsi_transport_spi.c and I still can boot ;)
> 
> > 
> >> no idea whatever this is related but buffered disk reads are 2.XX MB/sec and the box is somewhat laggy.
> >>
> >> hdparm -t on sda and sdb reports :
> >>
> >> /dev/sda:
> >>  Timing buffered disk reads:    8 MB in  3.26 seconds =   2.46 MB/sec
> >>
> >> /dev/sdb:
> >>  Timing buffered disk reads:    8 MB in  3.56 seconds =   2.25 MB/sec
> >>
> >> My IDE discs are fine.
> >>
> >> Please let me know if you need my config or any other informations.
> >>
> > 
> > And you're the second to report very slow scsi throughput in 2.6.24-rc3-mm1.
> > 
> 
> I found the commit which cause these problems , it is in git-scsi-misc patch and reverting it fixes both problems for me.
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff_plain;h=8655a546c83fc43f0a73416bbd126d02de7ad6c0;hp=5bc717b6bdaaf52edf365eb7d9d8c89fec79df5d
> 

OK, thanks.  I'll assume that James and Hannes have this in hand (or will
have, by mid-week) and I won't do anything here.

