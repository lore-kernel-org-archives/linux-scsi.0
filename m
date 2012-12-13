From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Thu, 13 Dec 2012 18:18:59 +0100
Message-ID: <50CA0E03.5070901@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C6ED1A.7040404@acm.org> <20121211224626.GB20898@beardog.cce.hp.com> <50C9BEAB.6010702@acm.org> <20121213180352.GJ20898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:50325 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2LMRTC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 12:19:02 -0500
In-Reply-To: <20121213180352.GJ20898@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/13/12 19:03, scameron@beardog.cce.hp.com wrote:
> What are your system specs?

A quad core Intel i5-2400 @ 3.10 GHz.

> 	taskset -c "$cpu" dd if="$device" of=/dev/null bs=4k iflag=direct

Please use fio instead of dd for any serious performance measurements. 
dd doesn't even guarantee that it's buffers are page aligned.

> I don't have "disable-frequency-scaling" on rhel6, but I think if I send
> SIGUSR1 to all the cpuspeed processes, this does the same thing.

Depends on which scaling governor and minimum frequency has been 
configured. This is what I am using:

#!/bin/bash
for d in /sys/devices/system/cpu/cpu*/cpufreq
do
   if [ -e "$d/scaling_governor" ]; then
     echo "userspace" >"$d/scaling_governor"
     echo "$(<$d/cpuinfo_max_freq)" >"$d/scaling_min_freq"
   fi
done

And the test I ran is:

fio --bs=4096 --ioengine=libaio --rw=randread --buffered=0 --thread    \
     --numjobs=${cpucount} --iodepth=16 --iodepth_batch=8               \
     --iodepth_batch_complete=8                                         \
     --loops=$((2**31)) --runtime=60 --group_reporting --size=${size}   \
     --gtod_reduce=1 --name=${dev} --filename=${dev} --invalidate=1

Bart.

