From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: [RFC PATCH v2] blk-mq: Introduce per sw queue time-slice
Date: Wed, 10 Feb 2016 20:34:14 +0100
Message-ID: <20160210193414.GC14676@suselix.suse.de>
References: <20151119120235.GA7966@suselix.suse.de>
 <20160201224340.GA16639@suselix.suse.de>
 <20160209171239.GE12437@suselix.suse.de>
 <20160209174156.GA323@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:38498 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbcBJTeu (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Wed, 10 Feb 2016 14:34:50 -0500
Content-Disposition: inline
In-Reply-To: <20160209174156.GA323@x4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Tue, Feb 09, 2016 at 06:41:56PM +0100, Markus Trippelsdorf wrote:
> On 2016.02.09 at 18:12 +0100, Andreas Herrmann wrote:
> > [CC-ing linux-block and linux-scsi and adding some comments]
> > 
> > On Mon, Feb 01, 2016 at 11:43:40PM +0100, Andreas Herrmann wrote:
> > > This introduces a new blk_mq hw attribute time_slice_us which allows
> > > to specify a time slice in usecs.
> > > 
> > > Fio test results are sent in a separate mail to this.
> > 
> > See http://marc.info/?l=linux-kernel&m=145436682607949&w=2
> > 
> > In short it shows significant performance gains in some tests,
> > e.g. sequential read iops up by >40% with 8 jobs. But it's never on
> > par with CFQ when more than 1 job was used during the test.
> > 
> > > Results for fio improved to some extent with this patch. But in
> > > reality the picture is quite mixed. Performance is highly dependend on
> > > task scheduling. There is no guarantee that the requests originated
> > > from one CPU belong to the same process.
> > > 
> > > I think for rotary devices CFQ is by far the best choice. A simple
> > > illustration is:
> > > 
> > >   Copying two files (750MB in this case) in parallel on a rotary
> > >   device. The elapsed wall clock time (seconds) for this is
> > >                                mean    stdev
> > >    cfq, slice_idle=8           16.18   4.95
> > >    cfq, slice_idle=0           23.74   2.82
> > >    blk-mq, time_slice_usec=0   24.37   2.05
> > >    blk-mq, time_slice_usec=250 25.58   3.16
> > 
> > This illustrates that although their was performance gain with fio
> > tests, the patch can cause higher variance and lower performance in
> > comparison to unmodified blk-mq with other tests. And it underscores
> > superiority of CFQ for rotary disks.
> > 
> > Meanwhile my opinion is that it's not really worth to look further
> > into introduction of I/O scheduling support in blk-mq. I don't see the
> > need for scheduling support (deadline or something else) for fast
> > storage devices. And rotary devices should really avoid usage of blk-mq
> > and stick to CFQ.
> > 
> > Thus I think that introducing some coexistence of blk-mq and the
> > legacy block with CFQ is the best option.
> > 
> > Recently Johannes sent a patch to enable scsi-mq per driver, see
> > http://marc.info/?l=linux-scsi&m=145347009631192&w=2
> > 
> > Probably that is a good solution (at least in the short term) to allow
> > users to switch to blk-mq for some host adapters (with fast storage
> > attached) but to stick to legacy stuff on other host adapters with
> > rotary devices.
> 
> I don't think that Johannes' patch is a good solution.

Why? Because it's not per device?

> The best solution for the user would be if blk-mq could be toggled
> per drive (or even automatically enabled if queue/rotational == 0).

Yes, I aggree, but ...

> Is there a fundamental reason why this is not feasible?

... it's not possible (*) with the current implementation.

Tag handling/command allocation differs. Respective functions are set
per host.

(*) Or maybe it's possible but just hard to achieve and I didn't look
long enough into relevant code to get an idea how to do it.

> Your solution is better than nothing, but it requires that the user
> finds out the drive <=> host mapping by hand and then runs something
> like: 
> echo "250" > /sys/devices/pci0000:00/0000:00:11.0/ata2/host1/target1:0:0/1:0:0:0/block/sdb/mq/0/time_slice_us
> during boot for spinning rust drives...

Or it could automatically be set in case of rotational device.
(Once we know for sure that it doesn't cause performance degradation.)

> -- 
> Markus

Andreas
