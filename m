From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Wed, 01 Dec 2010 10:40:00 +0100
Message-ID: <1291196400.2814.34.camel@larosa>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
	 <4CF521DE.7020800@panasas.com>
	 <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
	 <4CF52A03.2000704@panasas.com>
	 <alpine.LNX.2.00.1011301853300.9731@kai.makisara.local>
	 <4CF53349.10509@panasas.com>
	 <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:53312 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab0LAJkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2010 04:40:06 -0500
In-Reply-To: <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>

Am Dienstag, den 30.11.2010, 21:53 +0200 schrieb Kai Makisara:
> On Tue, 30 Nov 2010, Boaz Harrosh wrote:

I'm Cc'ing Desay Kashyap from LSI, maybe he can comment on the hardware
limitations of the SAS1068E?

> ...
> > I looked at enlarge_buffer() and it looks fragile and broken. If you really
> > need a pointer eg:
> > 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
> > 
> If you think it is broken, please fix it.
> 
> > Than way not use vmalloc() for buffers larger then PAGE_SIZE? But better yet
> > avoid it by keeping a pages_array or sg-list and operate on an aio type
> > operations.
> > 
> vmalloc() is not a solution here. Think about this from the HBA side. Each 
> s/g segment must be contiguous in the address space the HBA uses. In many 
> cases this is the physical memory address space. Any solution must make 
> sure that the HBA can perform the requested data transfer.
> 
> > > Kai
> > 
> > But I understand this is a lot of work on an old driver. Perhaps pre-allocate
> > something big at startup. specified by user?
> > 
> This used to be possible at some time and it could be made possible again. 
> But I don't like this option because it means that the users must 
> explicitly set the boot parameters.
> 
> And it is difficult for me to believe the modern SAS HBAs only support 128 
> s/g segments.
> 
> Kai


For reference, here's my original message with Kais reply:

> Hi, 
> 
> On our backup system (2 LTO4 drives/Tandberg library via LSISAS1068E,
> Kernel 2.6.36 with the stock Fusion MPT SAS Host driver 3.04.17 on
> debian/squeeze), we see reproducible tape read and write failures after
> the system was under memory pressure:
> 
> [342567.297152] st0: Can't allocate 2097152 byte tape buffer.
> [342569.316099] st0: Can't allocate 2097152 byte tape buffer.
> [342570.805164] st0: Can't allocate 2097152 byte tape buffer.
> [342571.958331] st0: Can't allocate 2097152 byte tape buffer.
> [342572.704264] st0: Can't allocate 2097152 byte tape buffer.
> [342873.737130] st: from_buffer offset overflow.
> 
> Bacula is spewing this message every time it tries to access the tape
> drive:
> 28-Nov 19:58 sd1.techfak JobId 2857: Error: block.c:1002 Read error on fd=10 at file:blk 0:0 on device "drv2" (/dev/nst0). ERR=Input/output error
> 
> By memory pressure, I mean that the KVM processes containing the
> postgres-db (~20million files) and the bacula director have used all
> available RAM, one of them used ~4GiB of its 12GiB swap for an hour or
> so (by selecting a full restore, it seems that the whole directory tree
> of the 15mio files backup gets read into memory). After this, I wasn't
> able to read from the second tape drive anymore (/dev/st0); whereas the
> first tape drive was restoring the data happily (it is currently about
> halfway through a 3TiB restore from 5 tapes).
> 
> This same behaviour appears when we're doing a few incremental backups;
> after a while, it just isn't possible to use the tape drives anymore -
> every I/O operation gives an I/O Error, even a simple dd bs=64k
> count=10. After a restart, the system behaves correctly until
> -seemingly- another memory pressure situation occured.
> 
This is predictable. The maximum number of scatter/gather segments seems 
to be 128. The st driver first tries to set up transfer directly from the 
user buffer to the HBA. The user buffer is usually fragmented so that one 
scatter/gather segment is used for each page. Assuming 4 kB page size, the 
maximu size of the direct transfer is 128 x 4 = 512 kB.

When this fails, the driver tries to allocate a kernel buffer so that 
there larger than 4 kB physically contiguous segments. Let's assume that 
it can find 128 16 kB segments. In this case the maximum block size is 
2048 kB. Memory pressure results in memory fragmentation and the driver 
can't find large enough segments and allocation fails. This is what you 
are seeing.

So, one solution is to use 512 kB block size. Another one is to try to 
find out if the 128 segment limit is a physical limitation or just a 
choice. In the latter case the mptsas driver could be modified to support 
larger block size even after memory fragmentation.

Kai





