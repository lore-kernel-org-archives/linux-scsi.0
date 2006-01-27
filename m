From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Fri, 27 Jan 2006 10:40:49 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601270958470.24983@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <20060124202306.GA8422@us.ibm.com> <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
 <Pine.LNX.4.63.0601252306270.5794@kai.makisara.local>
 <Pine.LNX.4.64.0601261033010.23310@localhost.localdomain>
 <Pine.LNX.4.63.0601261839440.6109@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:62947 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751496AbWA0PlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 10:41:11 -0500
In-Reply-To: <Pine.LNX.4.63.0601261839440.6109@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Chip Coldwell <coldwell@redhat.com>, Patrick Mansfield <patmans@us.ibm.com>, Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Thu, 26 Jan 2006, Kai Makisara wrote:
>
> You did not say whether the drive was in fixed block mode ('mt status'
> tell nonzero block size) of variable block mode. The Seagate (now Quantum)
> drives usually wake up in fixed block mode with 1024 byte block size. I am
> assuming this is the case here.

Close, but with 512 byte fixed blocks by default:

RHEL4# mt -f /dev/nst0 status
SCSI 2 tape drive:
File number=1, block number=0, partition=0.
Tape block size 512 bytes. Density code 0x47 (TR-5).
Soft error count since last status=0
General status bits on (81010000):
  EOF ONLINE IM_REP_EN

> Compression seems to be enabled because you get speeds that exceed the 3.5
> MB/s native speed of the drive. You are measuring here more the speed of
> the drive's processor than the tape reading performance. However, this
> does not invalidate the results of these tests.

Good point; a file entirely comprised of zeros should compress very
well.  So I repeated the experiments with compression off.  First,
with direct I/O

RHEL4# time dd if=/dev/nst0 of=/dev/null bs=1k
1000000+0 records in
1000000+0 records out

real    10m34.332s
user    0m1.136s
sys     0m16.209s

then again without it

RHEL4# time dd if=/dev/nst0 of=/dev/null bs=1k
1000000+0 records in
1000000+0 records out

real    4m47.364s
user    0m0.655s
sys     0m5.780s

> I repeated these tests with a HP DAT40 connected to a LSI Logic 53c1010
> HBA. The kernel was 2.6.16-rc1-git4.
>
> The tests in fixed block mode showed similar behaviour with slightly
> different times (6m10 vs 1m6). (In variable block mode the time was 6m10
> with both try_direct_io=1 and try_direct_io=0).

So are you saying that the best time in the experiments you did (1m6)
is without direct I/O using fixed blocks?  This is nearly six times
faster than fixed blocks with direct I/O, or variable blocks in either
case.

> Your analysis here is correct. This is also the case I mentioned in
> another message where I said that disabling direct i/o increases speed in
> fixed block mode: the read() and write() byte counts are very small.
>
> The problem is that this case is testing something that you should never
> do with a tape. No even half-decent tape application does this. The
> nearest I know is tar with the default 10 kB block size.

Well, the default mode of the tape drive when it comes up is a 512
byte fixed block size.  tar, cpio and dump all use fixed block sizes
by default.  So it seems that the default behavior is "something that
you should never do with a tape".  I would argue that this is a
problem.

>> I did the test again with larger blocks (the buffer in the tape drive
>> is 32K), first without direct I/O
>>
>> RHEL4# cat /sys/bus/scsi/drivers/st/try_direct_io 0
>> RHEL4# time dd if=/dev/nst0 of=/dev/null bs=32k
>> 31250+0 records in
>> 31250+0 records out
>>
>> real    2m30.688s
>> user    0m0.028s
>> sys     0m2.871s
>>
>> then again with direct I/O
>>
>> RHEL4# time dd if=/dev/nst0 of=/dev/null bs=32k
>> 31250+0 records in
>> 31250+0 records out
>>
>> real    2m30.687s
>> user    0m0.063s
>> sys     0m0.677s
>>
>> So in this case, performance is no worse or better with direct I/O
>> than without.
>>
> This is a more realistic test. The 32 kB i/o size is large enough for many
> drives. In another message you prove this for the DAT72 because you did
> not get better speed with 64 kB i/o size. (The drive manufacturers usually
> provide a suggestion for the optimal i/o size.)

Granted, but in the best possible case, using direct I/O gives the
same performance as not using it; and in all other cases it is much
worse.  Can you describe a configuration I can test where direct I/O
makes the performance better?

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

