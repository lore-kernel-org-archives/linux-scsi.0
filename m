From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.3 oops at kobject_unregister, alsa & aic7xxx
Date: Mon, 23 Feb 2004 22:17:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223221740.5786b0b3.akpm@osdl.org>
References: <1077546633.362.28.camel@boxen>
	<20040223160716.799195d0.akpm@osdl.org>
	<1077602725.3172.19.camel@opiate>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:17888 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262181AbUBXGRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 01:17:39 -0500
In-Reply-To: <1077602725.3172.19.camel@opiate>
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>
Cc: alexn@telia.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Eric Kerin <eric@bootseg.com> wrote:
>
> On Mon, 2004-02-23 at 19:07, Andrew Morton wrote:
> > Alexander Nyberg <alexn@telia.com> wrote:
> > >
> > > This happens at shutdown when alsa is to close down. I'm running debian
> > > sid. NOTE: I recently removed my aic7xxx out of the motherboard, so the
> > > driver obviously can't find it. But if I remove aic7xxx from the modules
> > > list, this oops does _not_ happen.
> > 
> > That's useful infomation.  It indicates that the aic7xxx driver is screwing
> > up the kobject lists.
> > 
> > Just to confirm: are you saying that the aic7xxx driver is loaded at the
> > tie of the oops, but there is no aic7xxx hardware present in the machine?
> 
> 
> I stumbled up this in early January.  I posted a patch to linux-scsi,
> but it dosn't seem to be merged at this point.  This problem will also
> occur with the aic79xx driver.
> 
> Here's the location of the original thread:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107307695430108&w=2
> 
> I just tried the patch on 2.6.3, and it still applies cleanly.

hm, I was looking at that code but it seemed OK.  You said "left a stale
entry in the pci_device list".  Is that correct, or was the entry in the
PCI driver list?  The latter, surely?

If so, why is that a problem?  ahc_linux_pci_exit() takes it out again?

