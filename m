From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Mon, 06 Aug 2007 01:03:27 +0900
Message-ID: <200708051603.l75G3rpl025895@mbox.iij4u.or.jp>
References: <20070725174258T.fujita.tomonori@lab.ntt.co.jp>
	<46A7A2EC.6040400@panasas.com>
	<46AF97AA.5000908@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34252 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXHEQER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Aug 2007 12:04:17 -0400
In-Reply-To: <46AF97AA.5000908@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, bhalevy@panasas.com, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
Date: Tue, 31 Jul 2007 23:12:26 +0300

> Boaz Harrosh wrote:
> > FUJITA Tomonori wrote:
> >> From: Benny Halevy <bhalevy@panasas.com>
> >> Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
> >> Date: Wed, 25 Jul 2007 11:26:44 +0300
> >>
> >>>> However, I'm perfectly happy to go with whatever the empirical evidence
> >>>> says is best .. and hopefully, now we don't have to pick this once and
> >>>> for all time ... we can alter it if whatever is chosen proves to be
> >>>> suboptimal.
> >>> I agree.  This isn't a catholic marriage :)
> >>> We'll run some performance experiments comparing the sgtable chaining
> >>> implementation vs. a scsi_data_buff implementation pointing
> >>> at a possibly chained sglist and let's see if we can measure
> >>> any difference.  We'll send results as soon as we have them.
> >> I did some tests with your sgtable patchset and the approach to use
> >> separate buffer for sglists. As expected, there was no performance
> >> difference with small I/Os. I've not tried very large I/Os, which
> >> might give some difference.
> >>
> > 
> > Next week I will try to mount lots of scsi_debug devices and
> > use large parallel IO to try and find a difference. I will
> > test Jens's sglist-arch tree against above sglist-arch+scsi_sgtable
> > 
> 
> 
> I was able to run some tests here are my results.
> 
> The results:
> PPT - is Pages Per Transfer (sg_count)
> 
> The numbers are accumulated time of 20 transfers of 32GB each,
> and the average of 4 such runs. (Lower time is better)
> Transfers are sg_dd into scsi_debug
> 
> Kernel         | total time 128-PPT | total time 2048-PPT
> ---------------|--------------------|---------------------
> sglist-arch    |      47.26         | Test Failed
> scsi_data_buff |      41.68         | 35.05
> scsi_sgtable   |      42.42         | 36.45
> 
> 
> The test:
> 1. scsi_debug
>   I mounted the scsi_debug module which was converted and fixed for 
>   chaining with the following options:
>   $ modprobe scsi_debug virtual_gb=32 delay=0 dev_size_mb=32 fake_rw=1
>   
>   32 GB of virtual drive on 32M of memory with 0 delay
>   and read/write do nothing with the fake_rw=1.
>   After that I just enabled chained IO on the device
> 
>   So what I'm actually testing is only sg + scsi-ml request
>   queuing and sglist allocation/deallocation. Which is what I want
>   to test.
> 
> 2. sg_dd
>   In the test script (see prof_test_scsi_debug attached)
>   I use sg_dd in direct io mode to send a direct scsi-command
>   to above device.

Your script is doing:

sg_dd blk_sgio=1 dio=1 if=/dev/zero of=/dev/sdb ...

dio works for SG_IO? Only sg suuports it, I think.

And sd_read is more appropriate than sg_dd for performance tests.

I'm not sure about the results. How can sglist-arch be slower than
scsi_data_buff and scsi_sgtable.


>   I did 2 tests, in both I transfer 32GB of data.
>   1st test with 128 (4K) pages IO size.
>   2nd test with 2048 pages IO size.
>   The second test will successfully run only if chaining is enabled
>   and working. Otherwise it will fail.
> 
> The tested Kernels:
> 
> 1. Jens's sglist-arch
>   I was not able to pass all tests with this Kernel. For some reason when
>   bigger than 256 pages commands are queued the Machine will run out
>   of memory and will kill the test. After the test is killed the system
>   is left with 10M of memory and can hardly reboot.

sglist-arch works for me. I hit memory leak due to the sg (I used sg
instead of SG_IO) bug though the bug happens even with scsi_data_buff
and sgtable.


> 2. scsi_data_buff
>   This tree is what I posted last. It is basically: 
>   0. sglist-arch
>   1. revert of scsi-ml support for chaining.
>   2. sg-pools cleanup [PATCH AB1]

I don't think this is the proper way. As I said, we can implement
scsi_data_buffer stuff on the top of sglist cleanly. No need to revert
something in sglist.

I don't think that sg-pools cleanup is necessary. We can live without
the sg segment size hack due to sglist.

My scsi data buffer patch is at:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git sdbuffer

The differences are: I use 'scsi_data_buffer structure' instead of
scsi_data_buff; it's on the top of sglist cleanly.


I also put your scsi_data_buff and sgtable patchset:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git boaz-sdbuff
git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git boaz-sgtable
