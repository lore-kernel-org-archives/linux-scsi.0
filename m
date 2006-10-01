From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape block size
Date: Sun, 1 Oct 2006 13:42:17 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0610011305270.4358@kai.makisara.local>
References: <200609241605.32327.johna@onevista.com>
 <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
 <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
 <Pine.LNX.4.60.0609302243120.3656@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:28742 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751426AbWJAKmT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 06:42:19 -0400
In-Reply-To: <Pine.LNX.4.60.0609302243120.3656@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sat, 30 Sep 2006, Guennadi Liakhovetski wrote:

> On Thu, 28 Sep 2006, Kai Makisara wrote:
> 
> > Both 1 and 2 are needed for 1 MB block size. max_sectors_kb for tapes is 
> > not visible in /sys.
> 
> Kai, as st maintainer, you surely know - on my tape HP C1533A I cannot 
> seem to set up any block size other than 1 byte... Is it __really__ 1 byte 
> or is it just some fixed block size that the drive doesn't report and 
> cannot change? And it means I cannot test setting of different block 
> sizes? I have a (unconnected ATM) slightly newer C1555D, wonder if that 
> could use different block sizes?...
> 
This is interesting. I also have HP C1533A (firmware 9608) and I have not 
had any problems with setting the block size. Dmesg shows that the drive 
supports blocks up to 1<<24 - 1 bytes:
st0: Block limits 1 - 16777215 bytes.

I just tested with kernel 2.6.18 that setting block size works in my 
system.

> 1 byte I see in "mt status" and setting anything else with "mt setblk" 
> causes "st0: Incorrect block size."
> 
This message comes from reading in fixed block mode when the drive tries 
to read a block and the size of the block does not match the block size 
set to the drive. If you have written the tape with block size 1, you 
can't read it with any other block size in fixed block mode.

If you are testing the limits of the LLD, it may be easier to use variable 
block mode. What matters is the size of the SCSI i/o and in this case you 
know it exactly. In fixed block mode the i/o size may be several blocks 
unless you are careful.

-- 
Kai
