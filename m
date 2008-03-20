From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Buffered I/O to block device very slow and other SCSI issues...
Date: Thu, 20 Mar 2008 07:59:12 -0400
Message-ID: <170fa0d20803200459o461fa65bv5c643b53c61953e3@mail.gmail.com>
References: <20080319231654.GA103321673@sgi.com>
	 <20080320010807.GA27620@sgi.com>
	 <20080320032010.e640c52a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:13075 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYCTL7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2008 07:59:13 -0400
Received: by wf-out-1314.google.com with SMTP id 28so936599wff.4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 04:59:12 -0700 (PDT)
In-Reply-To: <20080320032010.e640c52a.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>

On Thu, Mar 20, 2008 at 6:20 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 19 Mar 2008 18:08:07 -0700 Jeremy Higdon <jeremy@sgi.com> wrote:
>  >
>
>  (cc's added.  It matters)
>
>
>  > On Thu, Mar 20, 2008 at 10:16:54AM +1100, David Chinner wrote:
>  > > 4p ia64, 24GB RAM, 2.6.25-rc3, qla1280, 15krpm scsi disk.
>  > >
>  > > Direct I/O:
>  > >
>  > > dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=1024 oflag=direct
>  > > 1024+0 records in
>  > > 1024+0 records out
>  > > 1073741824 bytes (1.1 GB) copied, 27.8974 s, 38.5 MB/s
>  > >
>  > > Doing approximately 80 512k I/os per second (disk bandwidth).
>  > >
>  > > Buffered I/O:
>  > >
>  > > dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=4096
>  > > 4096+0 records in
>  > > 4096+0 records out
>  > > 4294967296 bytes (4.3 GB) copied, 427.872 s, 10.0 MB/s
>  >
>  > How big is sdb6?  How many '2's do you see in
>  >
>  >       factor `cat /sys/block/sdb/sdb6/size`
>
>  There have always been problems with thsi and I'm not sure that anyone
>  cared enough about buffered writes to blockdevs to get to the bottom of
>  them.
>
>  I assume you aren't running i386 highmem...

I've experienced the same kind of degradation with buffered IO vs
direct specifically when using Linux partitions.  Using the full block
device doesn't create such fragmented IOs.

The problem was reported to the blktrace list some weeks ago by my
coworker (cc'ing Ming):
http://marc.info/?l=linux-btrace&m=120296070516776&w=2
(fyi, Ming forgot to use oflag=sync, this explains the weird results
when doing buffered writes while blktrace'ing)

To summarize a little more (without messing round with partition
alignment), the test system is x86_64 with 4GB, storage is directly
connected via aacraid, 7200 rpm SATA disk.

Using:
dd if=/dev/zero of=/dev/sdhX bs=1M oflag=sync count=4 seek=2
and
dd if=/dev/zero of=/dev/sdhX bs=1M oflag=direct count=4 seek=2

full disk case (sdh):
buffered writes are +8 and being merged to 3 512k requests, 1 8k and 1
504k (27MB/s)
odirect writes are all +512 (35MB/s)

partitioned case: a 3GB sdh1 and ~720GB sdh2.
buffered writes to partition1 are +1 and are merged to 65k requests  (10.3MB/s)
buffered writes to partition2 are +2 and are merged to 130k requests (15.2MB/s)
odirect writes to either partition are all +512 (27MB/s)

So it appears partition size matters (at least in this case)?

As you can see performing buffered writes to a partition resulted in
very small requests, much like David reported in his original post (+1
or +2 via blktrace).

This happens with every kernel tried; 2.6.22, 2.6.24, RHEL5U1, etc.
cfq vs deadline doesn't change anything.  For partitions, changing
partition alignment to a power of 2 actually hurt!?

Mike
