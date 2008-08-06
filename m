From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Wed, 06 Aug 2008 12:10:21 +0300
Message-ID: <48996A7D.3080101@panasas.com>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
	<1217877676.3318.32.camel@localhost.localdomain>
	<48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
	<4898B0AF.6050800@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4898B0AF.6050800@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Boaz Harrosh wrote:
>> From my tests, the block layer will, very fast, send you chained commands.
>> if you set it to 255 you'll see two chained fragments. In iscsi we have
>> 4096 and it is very good for performance. However since you are pre-allocating
>> the memory per can_queue commands, this can get big, and the memory overhead
>> can be an impact on performance.
> 
> I did repeated read tests with dd now, with a 3.5" 750G SATA/ FireWire 
> 800 disk and with a 2.5" 250G IDE/ FireWire 400 disk, each with either 
> FireWire stack.  I used dd with and without iflag=direct, just because I 
> don't have a clue how to capture the influence of .sg_tablesize best.
> 
> Tests with .sg_tablesize = 128, 255, and 5000 all yield the same 
> transfer rates.  So I guess I simply leave it at the current SG_ALL for now.

You will need to enable sg chaining for your device. I'm not sure
where is the latest documentation. (CC: Jens)

Here is the script I used in my tests:

	#!/bin/bash
	sdx=sdb

	# mess with sglist chaining
	cd /sys/block/$sdx/queue
	echo 4096 > max_segments
	cat max_hw_sectors_kb  > max_sectors_kb
	echo "max_hw_sectors_kb="$(cat max_hw_sectors_kb) 
	echo "max_sectors_kb="$(cat max_sectors_kb) 
	echo "max_segments="$(cat max_segments)

Try to view the content of max_segments before and after
see if it changed.


and also with dd you need a large block size here is how
I calculated it. (Other people might have better tests)
I did a write test but a read test should be better:

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

	echo "run with 128-sgilist"
	echo "run with 128-sgilist" >> $outputfile
	for i in {1..20}; do
		do_dd 128 $outputfile $i;
	done

	echo "run with 2048-sgilist"
	echo "run with 2048-sgilist" >> $outputfile
	for i in {1..20}; do
		do_dd 2048 $outputfile $i;
	done

I think that in the second case with 2048 if your device does
not support it, dd will fail. (if I recall correctly)

Boaz

PS: OK I used sg_dd from sg-utils sg_read might be even better


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
