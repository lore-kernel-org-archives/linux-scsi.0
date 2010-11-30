From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Tue, 30 Nov 2010 18:20:59 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1011301813460.9731@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local> <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs10.mail.saunalahti.fi ([195.197.172.105]:55129 "EHLO
	vs10.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab0K3QVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 11:21:07 -0500
In-Reply-To: <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 30 Nov 2010, Lukas Kolbe wrote:

> On Mon, 2010-11-29 at 19:09 +0200, Kai Makisara wrote:
> 
> Hi,
> 
> > > On our backup system (2 LTO4 drives/Tandberg library via LSISAS1068E,
> > > Kernel 2.6.36 with the stock Fusion MPT SAS Host driver 3.04.17 on
> > > debian/squeeze), we see reproducible tape read and write failures after
> > > the system was under memory pressure:
> > > 
> > > [342567.297152] st0: Can't allocate 2097152 byte tape buffer.
> > > [342569.316099] st0: Can't allocate 2097152 byte tape buffer.
> > > [342570.805164] st0: Can't allocate 2097152 byte tape buffer.
> > > [342571.958331] st0: Can't allocate 2097152 byte tape buffer.
> > > [342572.704264] st0: Can't allocate 2097152 byte tape buffer.
> > > [342873.737130] st: from_buffer offset overflow.
> > > 
...
> > When this fails, the driver tries to allocate a kernel buffer so that 
> > there larger than 4 kB physically contiguous segments. Let's assume that 
> > it can find 128 16 kB segments. In this case the maximum block size is 
> > 2048 kB. Memory pressure results in memory fragmentation and the driver 
> > can't find large enough segments and allocation fails. This is what you 
> > are seeing.
> 
> Reasonable explanation, thanks. What makes me wonder is why it still
> fails *after* memory pressure was gone - ie free shows more than 4GiB of
> free memory. I had the output of /proc/meminfo at that time but can't
> find it anymore :/
> 
This is because (AFAIK) the kernel does not defragment the memory. There 
may be contiguous free pages but the memory management data structures 
don't show these.

> > So, one solution is to use 512 kB block size. Another one is to try to 
> > find out if the 128 segment limit is a physical limitation or just a 
> > choice. In the latter case the mptsas driver could be modified to support 
> > larger block size even after memory fragmentation.
> 
> Even with 64kb blocksize (dd bs=64k), I was getting I/O errors trying to
> access the tape drive. I am now trying to upper the max_sg_segs
> parameter to the st module (modinfo says 256 is the default; I'm trying
> 1024 now) and see how well this works under memory pressure.
> 
This will not help. The final limit is the minimum of the limit of st and 
the limit of mtpsas. The mptsas limit is 128. This is the limit that 
should be increased but I don't know if it is possible.

If you see error with 64 kB block size, I would like to see any messages 
associated with these errors.

Kai
