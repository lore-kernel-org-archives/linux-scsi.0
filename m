From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Fri, 27 Jan 2006 19:56:31 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601271937540.6234@kai.makisara.local>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <20060124202306.GA8422@us.ibm.com> <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
 <Pine.LNX.4.63.0601252306270.5794@kai.makisara.local>
 <Pine.LNX.4.64.0601261033010.23310@localhost.localdomain>
 <Pine.LNX.4.63.0601261839440.6109@kai.makisara.local>
 <Pine.LNX.4.64.0601270958470.24983@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:59471 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751129AbWA0Ryb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 12:54:31 -0500
In-Reply-To: <Pine.LNX.4.64.0601270958470.24983@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chip Coldwell <coldwell@redhat.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Fri, 27 Jan 2006, Chip Coldwell wrote:

...
> > Compression seems to be enabled because you get speeds that exceed the 3.5
> > MB/s native speed of the drive. You are measuring here more the speed of
> > the drive's processor than the tape reading performance. However, this
> > does not invalidate the results of these tests.
> 
> Good point; a file entirely comprised of zeros should compress very
> well.  So I repeated the experiments with compression off.  First,
> with direct I/O
> 
> RHEL4# time dd if=/dev/nst0 of=/dev/null bs=1k
> 1000000+0 records in
> 1000000+0 records out
> 
> real    10m34.332s
> user    0m1.136s
> sys     0m16.209s
> 
> then again without it
> 
> RHEL4# time dd if=/dev/nst0 of=/dev/null bs=1k
> 1000000+0 records in
> 1000000+0 records out
> 
> real    4m47.364s
> user    0m0.655s
> sys     0m5.780s
> 
The raw speed of the drive is 3.5 MB/s. Reading 1 GB should take 4m45.6. 
Your result with read-ahead matches this. Doing 1 kB SCSI transfers slows 
down things (and causes "shoeshining" that further decreases speed).

> > I repeated these tests with a HP DAT40 connected to a LSI Logic 53c1010
> > HBA. The kernel was 2.6.16-rc1-git4.
> >
> > The tests in fixed block mode showed similar behaviour with slightly
> > different times (6m10 vs 1m6). (In variable block mode the time was 6m10
> > with both try_direct_io=1 and try_direct_io=0).
> 
> So are you saying that the best time in the experiments you did (1m6)
> is without direct I/O using fixed blocks?  This is nearly six times
> faster than fixed blocks with direct I/O, or variable blocks in either
> case.
> 
Yes, in a meaningless test.

> > Your analysis here is correct. This is also the case I mentioned in
> > another message where I said that disabling direct i/o increases speed in
> > fixed block mode: the read() and write() byte counts are very small.
> >
> > The problem is that this case is testing something that you should never
> > do with a tape. No even half-decent tape application does this. The
> > nearest I know is tar with the default 10 kB block size.
> 
> Well, the default mode of the tape drive when it comes up is a 512
> byte fixed block size.  tar, cpio and dump all use fixed block sizes
> by default.  So it seems that the default behavior is "something that
> you should never do with a tape".  I would argue that this is a
> problem.
> 
The programs don't use fixed or variable block size. They just read and 
write using a fixed byte count. If the tape drive is in fixed block mode, 
the application read/write byte count must be divisible by the block size. 
In variable block mode there are no limitations.

The tar default is 10 kB transfers. This causes slowdown without 
read-ahead in some systems (probably not with your test system). The users 
should use at least 'tar b 64'. cpio default is 5120 and it is really too 
low for tapes.

Most current tape drives come up in variable block mode. Fixed block mode 
is an exception. In an ideal world the user chooses the mode and block 
size that fits the application :-)

...
> > This is a more realistic test. The 32 kB i/o size is large enough for many
> > drives. In another message you prove this for the DAT72 because you did
> > not get better speed with 64 kB i/o size. (The drive manufacturers usually
> > provide a suggestion for the optimal i/o size.)
> 
> Granted, but in the best possible case, using direct I/O gives the
> same performance as not using it; and in all other cases it is much
> worse.  Can you describe a configuration I can test where direct I/O
> makes the performance better?
> 
Direct i/o saves bus cycles by eliminating copy from user space to kernel 
space. It is useful when there are not spare cycles to waste. The typical 
combination, relatively speaking, where this matters is a fast drive (or 
more than one drive) and a not so fast system. The first example that 
comes into my mind is an LTO-3 drive connected to a Celeron system with 
32-bit PCI bus. With this combination yous should see well noticeable 
difference is system time. If you add an application into this system, the 
throughput may not match the tape streaming speed and that is very bad.

I think that direct i/o is the correct default, but I admit that other 
opinions can exist if different weights are given to the different 
situations.

-- 
Kai
