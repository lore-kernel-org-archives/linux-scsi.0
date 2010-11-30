From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Tue, 30 Nov 2010 14:31:26 +0100
Message-ID: <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:59560 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab0K3Nb2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 08:31:28 -0500
In-Reply-To: <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-29 at 19:09 +0200, Kai Makisara wrote:

Hi,

> > On our backup system (2 LTO4 drives/Tandberg library via LSISAS1068E,
> > Kernel 2.6.36 with the stock Fusion MPT SAS Host driver 3.04.17 on
> > debian/squeeze), we see reproducible tape read and write failures after
> > the system was under memory pressure:
> > 
> > [342567.297152] st0: Can't allocate 2097152 byte tape buffer.
> > [342569.316099] st0: Can't allocate 2097152 byte tape buffer.
> > [342570.805164] st0: Can't allocate 2097152 byte tape buffer.
> > [342571.958331] st0: Can't allocate 2097152 byte tape buffer.
> > [342572.704264] st0: Can't allocate 2097152 byte tape buffer.
> > [342873.737130] st: from_buffer offset overflow.
> > 
> > Bacula is spewing this message every time it tries to access the tape
> > drive:
> > 28-Nov 19:58 sd1.techfak JobId 2857: Error: block.c:1002 Read error on fd=10 at file:blk 0:0 on device "drv2" (/dev/nst0). ERR=Input/output error
> > 
> > By memory pressure, I mean that the KVM processes containing the
> > postgres-db (~20million files) and the bacula director have used all
> > available RAM, one of them used ~4GiB of its 12GiB swap for an hour or
> > so (by selecting a full restore, it seems that the whole directory tree
> > of the 15mio files backup gets read into memory). After this, I wasn't
> > able to read from the second tape drive anymore (/dev/st0); whereas the
> > first tape drive was restoring the data happily (it is currently about
> > halfway through a 3TiB restore from 5 tapes).
> > 
> > This same behaviour appears when we're doing a few incremental backups;
> > after a while, it just isn't possible to use the tape drives anymore -
> > every I/O operation gives an I/O Error, even a simple dd bs=64k
> > count=10. After a restart, the system behaves correctly until
> > -seemingly- another memory pressure situation occured.
> > 
> This is predictable. The maximum number of scatter/gather segments seems 
> to be 128. The st driver first tries to set up transfer directly from the 
> user buffer to the HBA. The user buffer is usually fragmented so that one 
> scatter/gather segment is used for each page. Assuming 4 kB page size, the 
> maximu size of the direct transfer is 128 x 4 = 512 kB.
> 
> When this fails, the driver tries to allocate a kernel buffer so that 
> there larger than 4 kB physically contiguous segments. Let's assume that 
> it can find 128 16 kB segments. In this case the maximum block size is 
> 2048 kB. Memory pressure results in memory fragmentation and the driver 
> can't find large enough segments and allocation fails. This is what you 
> are seeing.

Reasonable explanation, thanks. What makes me wonder is why it still
fails *after* memory pressure was gone - ie free shows more than 4GiB of
free memory. I had the output of /proc/meminfo at that time but can't
find it anymore :/

> So, one solution is to use 512 kB block size. Another one is to try to 
> find out if the 128 segment limit is a physical limitation or just a 
> choice. In the latter case the mptsas driver could be modified to support 
> larger block size even after memory fragmentation.

Even with 64kb blocksize (dd bs=64k), I was getting I/O errors trying to
access the tape drive. I am now trying to upper the max_sg_segs
parameter to the st module (modinfo says 256 is the default; I'm trying
1024 now) and see how well this works under memory pressure.

> Kai

-- 
Lukas


