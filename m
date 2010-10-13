From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 20072] tapeinfo reports MaxBlock: 16777215  but writes with
 blocksize >2M fail
Date: Wed, 13 Oct 2010 20:57:41 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1010132027110.5344@kai.makisara.local>
References: <bug-20072-11613@https.bugzilla.kernel.org/> <201010130950.o9D9oSY0018761@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs12.mail.saunalahti.fi ([195.197.172.107]:43411 "EHLO
	vs12.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0JMR7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2010 13:59:00 -0400
In-Reply-To: <201010130950.o9D9oSY0018761@demeter1.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2010, bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=20072
> 
> 
> 
> 
> 
> --- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2010-10-11 11:25:15 ---
> This is what dmesg has to say about the earlier tries to write to the device
> with higher than 2MiB blocksizes:
> 
> [92315.076956] st0: Block limits 1 - 16777215 bytes.
> [92445.438048] st0: Can't allocate 15728640 byte tape buffer.
> [92457.973733] st0: Can't allocate 16777215 byte tape buffer.
> [92460.990589] st0: Can't allocate 16777214 byte tape buffer.
> 
> --- Comment #3 from lkolbe@techfak.uni-bielefeld.de  2010-10-13 09:50:22 ---
> When instructing bacula to use the advertised tape blocksize of 16M, we get the
> following errors everytime it tries to access the tape:
> 
> 13-Oct 11:48 sd1.techfak JobId 2692: Error: block.c:1002 Read error on fd=5 at
> file:blk 0:0 on device "drv2" (/dev/nst0). ERR=Cannot allocate memory.
> 
> Is there some limit/sysctl we might have to adapt to the native tape drive
> blocksize of 16M?
> 
There is a limit that comes from physical constraints and memory 
fragmentation. Because of fragmentation, it is often not possible to find 
larger chunks of free memory than one page (e.g., 4 kB). The SCSI HBA 
supports often only a certain number of scatter/gather segments. Let's 
assume that this limit is 256. This means that the largest possible SCSI 
data buffer is 256 x 4 kB = 1 MB. This limits the possible block size. 
Depending on the state of fragmentation, the actual limit may be larger 
but this is the limit of the block size you can always use.

The st driver (with defaults) first tries to map the user buffer to the 
number of available scatter/gather segments. If this fails, the driver 
tries to allocate a local buffer using as large chunks of memory as it can 
get. If this succeeds, the request may still fail because of SCSI midlevel 
limits (I don't know what the limits currently are, but, if there are 
limits, they are tunable).

I have been able to read and write 16MB-1 blocks with my system. What you 
can actually reach depends on the things above.

Kai
