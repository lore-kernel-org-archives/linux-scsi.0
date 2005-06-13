From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...) (fwd)
Date: Mon, 13 Jun 2005 21:57:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0506132143280.14571@poirot.grange>
References: <Pine.LNX.4.60.0505281030510.3721@poirot.grange>
 <1117307520.5192.3.camel@mulgrave> <Pine.LNX.4.60.0505282312390.11729@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:35237 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261392AbVFMVDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 17:03:24 -0400
In-Reply-To: <Pine.LNX.4.60.0505282312390.11729@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all

On Sun, 29 May 2005, Guennadi Liakhovetski wrote:

> On Sat, 28 May 2005, James Bottomley wrote:
> 
> > Before you go any further, I suggest you think about what an ioctl is
> > and why we're going through a process of trying to get rid of them in
> > the kernel:  They're structured streams of information, where the
> > structure is architecture and 64/32 bit dependent (look at all the
> > issues over compat ioctls).  Inherently these things will be incredibly

I haven't given up, I just have little time:-)

Let me just see, if my current understanding is nearer to what was 
suggested by James B.:

Get ide-cd (ATAPI command generator) and cdrom (ioctl translator) drivers 
work with nbd by emulating an ATAPI CD-ROM. You would have to explain 
users why they need the ide cdrom driver even when they are connecting to 
a quite different target...

I would add - make this a configuration option, since not all (embedded) 
systems might want to compile and load ide-cd and cdrom drivers just to be 
able to use nbd, if they only need a network-exported hd.

Still a question - when to do open / close on the server: on start / stop 
(disconnect) - not nice, from open / close on client, on lockdoor() 
GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL commands? My guess would still be from 
client open / close, because then you can pass flags / return code. Not 
sure how easy it is to do this 64bit clean?

Thanks
Guennadi
---
Guennadi Liakhovetski

