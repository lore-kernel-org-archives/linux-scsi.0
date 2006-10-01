From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: SCSI tape block size
Date: Sun, 1 Oct 2006 19:05:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610011832140.4088@poirot.grange>
References: <200609241605.32327.johna@onevista.com>
 <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
 <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
 <Pine.LNX.4.60.0609302243120.3656@poirot.grange>
 <Pine.LNX.4.64.0610011305270.4358@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:48094 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751295AbWJARFm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Oct 2006 13:05:42 -0400
In-Reply-To: <Pine.LNX.4.64.0610011305270.4358@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Sun, 1 Oct 2006, Kai Makisara wrote:

> On Sat, 30 Sep 2006, Guennadi Liakhovetski wrote:
> 
> > Kai, as st maintainer, you surely know - on my tape HP C1533A I cannot 
> > seem to set up any block size other than 1 byte... Is it __really__ 1 byte 
> > or is it just some fixed block size that the drive doesn't report and 
> > cannot change? And it means I cannot test setting of different block 
> > sizes? I have a (unconnected ATM) slightly newer C1555D, wonder if that 
> > could use different block sizes?...
> > 
> This is interesting. I also have HP C1533A (firmware 9608) and I have not 
> had any problems with setting the block size. Dmesg shows that the drive 
> supports blocks up to 1<<24 - 1 bytes:
> st0: Block limits 1 - 16777215 bytes.
> 
> I just tested with kernel 2.6.18 that setting block size works in my 
> system.

I must have done something wrong yesterday. Sorry. It does work indeed, 
tested with

mt -f /dev/st0 setblk `expr $bs \* 1024`
time tar cf /dev/st0 -b `expr $bs \* 2` *jp*
mt -f /dev/st0 status

I can set block size as high as 512k (.max_sectors defaulting to 1024) 
independent of .use_clustering. Only setting .max_sectors higher lets one 
use larger blocks.

Thanks
Guennadi
---
Guennadi Liakhovetski
