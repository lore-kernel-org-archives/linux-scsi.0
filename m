From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Tue, 31 Jul 2007 23:12:26 +0300
Message-ID: <46AF97AA.5000908@panasas.com>
References: <46A60633.2020904@panasas.com>	<1185293406.3488.5.camel@localhost.localdomain>	<46A70944.6030005@panasas.com> <20070725174258T.fujita.tomonori@lab.ntt.co.jp> <46A7A2EC.6040400@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070009060600080208090804"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5425 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756016AbXGaUM6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 16:12:58 -0400
In-Reply-To: <46A7A2EC.6040400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bhalevy@panasas.com, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070009060600080208090804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Boaz Harrosh wrote:
> FUJITA Tomonori wrote:
>> From: Benny Halevy <bhalevy@panasas.com>
>> Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
>> Date: Wed, 25 Jul 2007 11:26:44 +0300
>>
>>>> However, I'm perfectly happy to go with whatever the empirical evidence
>>>> says is best .. and hopefully, now we don't have to pick this once and
>>>> for all time ... we can alter it if whatever is chosen proves to be
>>>> suboptimal.
>>> I agree.  This isn't a catholic marriage :)
>>> We'll run some performance experiments comparing the sgtable chaining
>>> implementation vs. a scsi_data_buff implementation pointing
>>> at a possibly chained sglist and let's see if we can measure
>>> any difference.  We'll send results as soon as we have them.
>> I did some tests with your sgtable patchset and the approach to use
>> separate buffer for sglists. As expected, there was no performance
>> difference with small I/Os. I've not tried very large I/Os, which
>> might give some difference.
>>
> 
> Next week I will try to mount lots of scsi_debug devices and
> use large parallel IO to try and find a difference. I will
> test Jens's sglist-arch tree against above sglist-arch+scsi_sgtable
> 


I was able to run some tests here are my results.

The results:
PPT - is Pages Per Transfer (sg_count)

The numbers are accumulated time of 20 transfers of 32GB each,
and the average of 4 such runs. (Lower time is better)
Transfers are sg_dd into scsi_debug

Kernel         | total time 128-PPT | total time 2048-PPT
---------------|--------------------|---------------------
sglist-arch    |      47.26         | Test Failed
scsi_data_buff |      41.68         | 35.05
scsi_sgtable   |      42.42         | 36.45


The test:
1. scsi_debug
  I mounted the scsi_debug module which was converted and fixed for 
  chaining with the following options:
  $ modprobe scsi_debug virtual_gb=32 delay=0 dev_size_mb=32 fake_rw=1
  
  32 GB of virtual drive on 32M of memory with 0 delay
  and read/write do nothing with the fake_rw=1.
  After that I just enabled chained IO on the device

  So what I'm actually testing is only sg + scsi-ml request
  queuing and sglist allocation/deallocation. Which is what I want
  to test.

2. sg_dd
  In the test script (see prof_test_scsi_debug attached)
  I use sg_dd in direct io mode to send a direct scsi-command
  to above device.
  I did 2 tests, in both I transfer 32GB of data.
  1st test with 128 (4K) pages IO size.
  2nd test with 2048 pages IO size.
  The second test will successfully run only if chaining is enabled
  and working. Otherwise it will fail.

The tested Kernels:

1. Jens's sglist-arch
  I was not able to pass all tests with this Kernel. For some reason when
  bigger than 256 pages commands are queued the Machine will run out
  of memory and will kill the test. After the test is killed the system
  is left with 10M of memory and can hardly reboot.
  I have done some prints at the queuecommand entry in scsi_debug.c
  and I can see that I receive the expected large sg_count and bufflen
  but unlike other tests I get a different pointer at scsi_sglist().
  In other tests since nothing is happening at this machine while in
  the test, the sglist pointer is always the same. commands comes in,
  allocates memory, do nothing in scsi_debug, freed, and returns. 
  I suspect sglist leak or allocation bug.

2. scsi_data_buff
  This tree is what I posted last. It is basically: 
  0. sglist-arch
  1. revert of scsi-ml support for chaining.
  2. sg-pools cleanup [PATCH AB1]
  3. scsi-ml sglist-arch [PATCH B1]
  4. scsi_data_buff patch. scsi_lib.c (Last patch sent)
  5. scsi_data_buff patch for sr.c sd.c & scsi_error.c
  6. Plus converted libata, ide-scsi, so Kernel can compile.
  7. convert of scsi_debug.c and fix for chaining.
  ( see http://www.bhalevy.com/open-osd/download/scsi_data_buff)

  All Tests run

3. scsi_sgtable 
  This tree is what I posted as patches that open this mailing thread.
  0. sglist-arch
  1. revert of scsi-ml support for chaining.
  2. sg-pools cleanup [PATCH AB1]
  3. sgtable [PATCH A2]
  3. chaining [PATCH A3]
  4. scsi_sgtable for sd sr and scsi_error
  6. Converted libata ide-scsi so Kernel can compile.
  7. convert of scsi_debug.c and fix for chaining.
  ( see http://www.bhalevy.com/open-osd/download/scsi_sgtable/linux-block/)

  All Tests run


--------------070009060600080208090804
Content-Type: text/plain;
 name="install_sdebug_chaining"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="install_sdebug_chaining"

#!/bin/sh
sdx=sdb
#load the device with these params
modprobe scsi_debug virtual_gb=32 delay=0 dev_size_mb=32 fake_rw=1

# go set some live params
# $ cd /sys/bus/pseudo/drivers/scsi_debug
# $ echo 1 > fake_rw

# mess with sglist chaining
cd /sys/block/$sdx/queue
echo 4096 > max_segments
cat max_hw_sectors_kb  > max_sectors_kb
echo "max_hw_sectors_kb="$(cat max_hw_sectors_kb) 
echo "max_hw_sectors_kb="$(cat max_sectors_kb) 
echo "max_hw_sectors_kb="$(cat max_segments)

--------------070009060600080208090804
Content-Type: text/plain;
 name="prof_test_scsi_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="prof_test_scsi_debug"

#!/bin/sh

#load the device with these params
#$ modprobe scsi_debug virtual_gb=32 delay=0 dev_size_mb=32 fake_rw=1

# go set some live params
# $ cd /sys/bus/pseudo/drivers/scsi_debug
# $ echo 1 > fake_rw

# mess with sglist chaining
# $ cd /sys/block/sdb/queue
# $ echo 4096 > max_segments
# $ cat max_hw_sectors_kb  > max_sectors_kb
# $ cat max_hw_sectors_kb 


if=/dev/zero
of=/dev/sdb

outputfile=$1.txt
echo "Testing $1"

# send 32G in $1 sectrors at once
do_dd()
{
# blocks of one sector
bs=512
#memory page in blocks
page=8
#number of scatterlist elements in a transfer
sgs=$1
#calculate the bpt param
bpt=$(($sgs*$page))
#total blocks to transfer 32 Giga bytes
count=64M


echo $3: "bpt=$bpt"

\time bash -c \
	"sg_dd blk_sgio=1 dio=1 if=$if of=$of bpt=$bpt bs=$bs count=$count 2>/dev/null" \
	2>> $2
}

echo "BEGIN RUN $1" >> $outputfile

# warm run
for i in {1..5}; do
do_dd 2048 /dev/null $i;
done

# one page trasfers
echo "one page transfers"
echo "one page transfers" >> $outputfile
for i in {1..20}; do
do_dd 128 $outputfile $i;
done

# chained
# 16K / 8 = 2K pages
# 2K / 128 = 16 chained sglists
echo "16 chained sglists"
echo "16 chained sglists" >> $outputfile
for i in {1..20}; do
do_dd 2048 $outputfile $i;
done

echo "END RUN" >> $outputfile

--------------070009060600080208090804--
