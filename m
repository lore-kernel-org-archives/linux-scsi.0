From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Mon, 29 Nov 2010 19:09:46 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([195.197.172.102]:59751 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0K2RQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 12:16:04 -0500
In-Reply-To: <1290971729.2814.13.camel@larosa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 28 Nov 2010, Lukas Kolbe wrote:

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

