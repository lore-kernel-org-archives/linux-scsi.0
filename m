From: scameron@beardog.cce.hp.com
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Thu, 13 Dec 2012 12:03:52 -0600
Message-ID: <20121213180352.GJ20898@beardog.cce.hp.com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C6ED1A.7040404@acm.org> <20121211224626.GB20898@beardog.cce.hp.com> <50C9BEAB.6010702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:34099 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2LMRD5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 12:03:57 -0500
Content-Disposition: inline
In-Reply-To: <50C9BEAB.6010702@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com, scameron@beardog.cce.hp.com

On Thu, Dec 13, 2012 at 12:40:27PM +0100, Bart Van Assche wrote:
> On 12/11/12 23:46, scameron@beardog.cce.hp.com wrote:
> >I would be curious to see what kind of results you would get with 
> >scsi_debug
> >with fake_rw=1.  I am sort of suspecting that trying to put an "upper 
> >limit"
> >on scsi LLD IOPS performance by seeing what scsi_debug will do with 
> >fake_rw=1
> >is not really valid (or, maybe I'm doing it wrong) as I know of one case in
> >which a real HW scsi driver beats scsi_debug fake_rw=1 at IOPS on the very
> >same system, which seems like it shouldn't be possible.  Kind of 
> >mysterious.
> 
> The test
> 
> # disable-frequency-scaling
> # modprobe scsi_debug delay=0 fake_rw=1
> # echo 2 > /sys/block/sdc/queue/rq_affinity
> # echo noop > /sys/block/sdc/queue/scheduler
> # echo 0 > /sys/block/sdc/queue/add_random
> 
> results in about 800K IOPS for random reads on the same setup (with a 
> request size of 4 KB; CPU: quad core i5-2400).
> 
> Repeating the same test with fake_rw=0 results in about 651K IOPS.

What are your system specs?


Here's what I'm seeing.

I have one 6-core processor.

[root@localhost scameron]# grep 'model name' /proc/cpuinfo
model name	: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz
model name	: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz
model name	: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz
model name	: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz
model name	: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz
model name	: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz

hyperthreading is disabled.

Here is the script I'm running.

[root@localhost scameron]# cat do-dds
#!/bin/sh

do_dd()
{
	device="$1"
	cpu="$2"

	taskset -c "$cpu" dd if="$device" of=/dev/null bs=4k iflag=direct
}

do_six()
{
	for x in `seq 0 5`
	do
		do_dd "$1" $x &
	done
}

do_120()
{
	for z in `seq 1 20` 
	do
		do_six "$1"
	done
	wait
}

time do_120 "$1"
		
I don't have "disable-frequency-scaling" on rhel6, but I think if I send
SIGUSR1 to all the cpuspeed processes, this does the same thing.

 ps aux | grep cpuspeed | grep -v grep | awk '{ printf("kill -USR1 %s\n", $2);}' | sh

[root@localhost scameron]# find /sys -name 'scaling_cur_freq' -print | xargs cat
2000000
2000000
2000000
2000000
2000000
2000000
[root@localhost scameron]#

Now, using scsi-debug (300mb size) with delay=0 and fake_rw=1, with
rq_affinity set to 2, and add_random set to 0 and noop i/o scheduler
I get ~216k iops.

With my scsi lld (actually doing the i/o) , I now get ~190k iops.
rq_affinity set to 2, add_random 0, noop i/o scheduler, irqs
manually spread across cpus (irqbalance turned off).

With my block lld (actually doing the i/o), I get ~380k iops.
rq_affinity set to 2, add_random 0, i/o scheduler "none"
(there is no i/o scheduler with the make_request interface),
irqs manually spread across cpus (irqbalance turned off).

So the block driver seems to beat the snot out of the scsi lld
by a factor of 2x now, rather than 3x, so I guess that's some
improvement, but still.

-- steve

