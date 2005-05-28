From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...) (fwd)
Date: Sun, 29 May 2005 00:37:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505282312390.11729@poirot.grange>
References: <Pine.LNX.4.60.0505281030510.3721@poirot.grange>
 <1117307520.5192.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:59783 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261192AbVE1XKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2005 19:10:13 -0400
In-Reply-To: <1117307520.5192.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 28 May 2005, James Bottomley wrote:

> On Sat, 2005-05-28 at 10:32 +0200, Guennadi Liakhovetski wrote:
> > So, just pass ioctl()'s directly and convert the rest (filesystem)
> > block 
> > requests separately - wouldn't it be easier and avoid any
> > modifications to 
> > other drivers?
> 
> Before you go any further, I suggest you think about what an ioctl is
> and why we're going through a process of trying to get rid of them in
> the kernel:  They're structured streams of information, where the
> structure is architecture and 64/32 bit dependent (look at all the
> issues over compat ioctls).  Inherently these things will be incredibly
> nasty to convert to an architecture neutral network protocol, and you'll
> have to provide a translator to and from every possible ioctl...they're
> inherently unsuitable things for building a protocol on top of.  On the
> other hand, the current nbd protocol is block request based, which is
> why I suggested looking at that instead.

Yeah... Well, whatever way it goes further, I think, 1 thing we do have to 
do before implementing that functionality - moving open / close in 
nbd-server from start / stop to be triggered by the client - right? And 
the flags and the return code should be passed accordingly. That's exactly 
what I've done so far.

As for the ioctls vs. REQ_BLOCK_PC... Well, I am open. I just thought: 
either we convert ioctls to ioctls, or block commands to ioctls, in any 
case ioctls are what we have to issue on the server side. But I'll rather 
trust you than myself on this:-) So, if no other opinions pop up in this 
discussion, I might try to play in that direction a bit. Will see.

Thanks
Guennadi
---
Guennadi Liakhovetski

