From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 14:17:20 -0700 (PDT)
Message-ID: <20070615.141720.112626963.davem@davemloft.net>
References: <20070615120848.352093000@pademelon.sonytel.be>
	<1181918159.25228.543.camel@pmac.infradead.org>
	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56313
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755725AbXFOVRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 17:17:17 -0400
In-Reply-To: <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com
Cc: dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Fri, 15 Jun 2007 16:43:05 +0200 (CEST)

> On Fri, 15 Jun 2007, David Woodhouse wrote:
> > On Fri, 2007-06-15 at 13:39 +0200, Geert Uytterhoeven wrote:
> > > Add a Disk Storage Driver for the PS3:
> > >   - Implemented as a block device driver with a dynamic major
> > >   - Disk names (and partitions) are of the format ps3d%c(%u)
> > >   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
> > >     doesn't support scatter-gather
> > 
> > Any particular reason why this is done as a separate block device driver
> > rather than as SCSI?
> 
> Because no new fake SCSI drivers are accepted anymore.

I'm strongly divided on this issue as I'm about to hit the same exact
thing for Sun Logical Domains on sparc64 Niagara systems.

In fact the interface I get to use allows SCSI commands to be sent
pass-through to the device, even though the basic virtual I/O API is
purely block I/O based.

It's senseless to make people build new major/minor numbers for
all these new quirky storage drivers.  People have to add support
for the new major number to installers and all kinds of other
tools.

If the SCSI guys were smart, there would be a totally generic helper
layer that allows anyone to hook into the SCSI layer as a virtual SCSI
disk provider in like 10 lines of code. :-)
