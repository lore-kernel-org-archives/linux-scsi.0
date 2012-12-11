From: scameron@beardog.cce.hp.com
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Tue, 11 Dec 2012 16:46:26 -0600
Message-ID: <20121211224626.GB20898@beardog.cce.hp.com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C6ED1A.7040404@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:40840 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2LKVqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2012 16:46:38 -0500
Content-Disposition: inline
In-Reply-To: <50C6ED1A.7040404@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com, scameron@beardog.cce.hp.com

On Tue, Dec 11, 2012 at 09:21:46AM +0100, Bart Van Assche wrote:
> On 12/11/12 01:00, scameron@beardog.cce.hp.com wrote:
> >I tried using scsi_debug with fake_rw and also the scsi_ram driver
> >that was recently posted to get some idea of what the maximum IOPS
> >that could be pushed through the SCSI midlayer might be, and the
> >numbers were a little disappointing (was getting around 150k iops
> >with scsi_debug with reads and writes faked, and around 3x that
> >with the block driver actually doing the i/o).
> 
> With which request size was that ? 

4k (I'm thinking the request size should not matter too much since
fake_rw=1 causes the i/o not to actually be done -- there's no data 
transferred.  Similarly with scsi_ram there's a flag to discard 
reads and writes that I was using.)

> I see about 330K IOPS @ 4 KB and 
> about 540K IOPS @ 512 bytes with the SRP protocol, a RAM disk at the 
> target side, a single SCSI LUN and a single IB cable. These results have 
> been obtained on a setup with low-end CPU's. Had you set rq_affinity to 
> 2 in your tests ?

No, hadn't done anything with rq_affinity.  I had spread interrupts
around by turning off irqbalance and echoing things into /proc/irq/*, and
running a bunch of dd processes (one per cpu) like this: 

	taskset -c $cpu dd if=/dev/blah of=/dev/null bs=4k iflag=direct &

And the hardware in this case should route the interrupts back to the processor
which submitted the i/o (the submitted command contains info that lets the hw
know which msix vector we want the io to come back on.)

I would be curious to see what kind of results you would get with scsi_debug
with fake_rw=1.  I am sort of suspecting that trying to put an "upper limit"
on scsi LLD IOPS performance by seeing what scsi_debug will do with fake_rw=1
is not really valid (or, maybe I'm doing it wrong) as I know of one case in
which a real HW scsi driver beats scsi_debug fake_rw=1 at IOPS on the very
same system, which seems like it shouldn't be possible.  Kind of mysterious.

Another mystery I haven't been able to clear up -- I'm using code like
this to set affinity hints 

        int i, cpu;

        cpu = cpumask_first(cpu_online_mask);
        for (i = 0; i < h->noqs; i++) {
                int idx = i ? i + 1 : i;
                int rc;
                rc = irq_set_affinity_hint(h->qinfo[idx].msix_vector,
                                        get_cpu_mask(cpu));

                if (rc)
                        dev_warn(&h->pdev->dev, "Failed to hint affinity of vector %d to cpu %d\n",
                                        h->qinfo[idx].msix_vector, cpu);
                cpu = cpumask_next(cpu, cpu_online_mask);
        }

and those hints are set (querying /proc/irq/*/affinity_hint shows that my hints
are in there) but the hints are not "taken", that is /proc/irq/smp_affinity
does not match the hints.

doing this:

for x in `seq $first_irq $last_irq`
do
	cat /proc/irq/$x/affinity_hint > /proc/irq/$x/smp_affinity
done

(where first_irq and last_irq specify the range of irqs assigned
to my driver) makes the hints be "taken".

I noticed nvme doesn't seem to suffer from this, somehow the hints are
taken automatically (er, I don't recall if /proc/irq/*/smp_affinity matches
affinity_hints for nvme, but interrupts seem spread around without doing
anything special).   I haven't seen anything in the nvme code related to affinity
that I'm not already doing as well in my driver, so it is a mystery to me why
that difference in behavior occurs.

-- steve

