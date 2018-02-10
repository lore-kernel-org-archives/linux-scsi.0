From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Sat, 10 Feb 2018 09:01:04 +0800
Message-ID: <20180210010057.GA2543@ming.t460p>
References: <20180206123148.GA29378@ming.t460p>
 <8cf1036167ec5fb58c1d2f70bbb0b678@mail.gmail.com>
 <4c934478-a9c1-2f66-83f2-982b85c4e6cc@suse.de>
 <20180207122257.GA16633@ming.t460p>
 <95b8ea33c79b84188e4a54b4e5fcd7b6@mail.gmail.com>
 <35778fd9-ede6-ed3d-4b13-27fb35ede9bd@suse.de>
 <20180208165313.GA31725@ming.t460p>
 <14c596572dcf99c4343c7eba65a7c427@mail.gmail.com>
 <20180209053107.GA30909@ming.t460p>
 <50c2ea693cd9923b53e2eb0ffd2b143e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50c2ea693cd9923b53e2eb0ffd2b143e@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Kashyap,

On Fri, Feb 09, 2018 at 02:12:16PM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Ming Lei [mailto:ming.lei@redhat.com]
> > Sent: Friday, February 9, 2018 11:01 AM
> > To: Kashyap Desai
> > Cc: Hannes Reinecke; Jens Axboe; linux-block@vger.kernel.org; Christoph
> > Hellwig; Mike Snitzer; linux-scsi@vger.kernel.org; Arun Easi; Omar
> Sandoval;
> > Martin K . Petersen; James Bottomley; Christoph Hellwig; Don Brace;
> Peter
> > Rivera; Paolo Bonzini; Laurence Oberman
> > Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
> > force_blk_mq
> >
> > On Fri, Feb 09, 2018 at 10:28:23AM +0530, Kashyap Desai wrote:
> > > > -----Original Message-----
> > > > From: Ming Lei [mailto:ming.lei@redhat.com]
> > > > Sent: Thursday, February 8, 2018 10:23 PM
> > > > To: Hannes Reinecke
> > > > Cc: Kashyap Desai; Jens Axboe; linux-block@vger.kernel.org;
> > > > Christoph Hellwig; Mike Snitzer; linux-scsi@vger.kernel.org; Arun
> > > > Easi; Omar
> > > Sandoval;
> > > > Martin K . Petersen; James Bottomley; Christoph Hellwig; Don Brace;
> > > Peter
> > > > Rivera; Paolo Bonzini; Laurence Oberman
> > > > Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags &
> > > > introduce force_blk_mq
> > > >
> > > > On Thu, Feb 08, 2018 at 08:00:29AM +0100, Hannes Reinecke wrote:
> > > > > On 02/07/2018 03:14 PM, Kashyap Desai wrote:
> > > > > >> -----Original Message-----
> > > > > >> From: Ming Lei [mailto:ming.lei@redhat.com]
> > > > > >> Sent: Wednesday, February 7, 2018 5:53 PM
> > > > > >> To: Hannes Reinecke
> > > > > >> Cc: Kashyap Desai; Jens Axboe; linux-block@vger.kernel.org;
> > > > > >> Christoph Hellwig; Mike Snitzer; linux-scsi@vger.kernel.org;
> > > > > >> Arun Easi; Omar
> > > > > > Sandoval;
> > > > > >> Martin K . Petersen; James Bottomley; Christoph Hellwig; Don
> > > > > >> Brace;
> > > > > > Peter
> > > > > >> Rivera; Paolo Bonzini; Laurence Oberman
> > > > > >> Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags &
> > > > > >> introduce force_blk_mq
> > > > > >>
> > > > > >> On Wed, Feb 07, 2018 at 07:50:21AM +0100, Hannes Reinecke
> wrote:
> > > > > >>> Hi all,
> > > > > >>>
> > > > > >>> [ .. ]
> > > > > >>>>>
> > > > > >>>>> Could you share us your patch for enabling global_tags/MQ on
> > > > > >>>> megaraid_sas
> > > > > >>>>> so that I can reproduce your test?
> > > > > >>>>>
> > > > > >>>>>> See below perf top data. "bt_iter" is consuming 4 times
> > > > > >>>>>> more
> > > CPU.
> > > > > >>>>>
> > > > > >>>>> Could you share us what the IOPS/CPU utilization effect is
> > > > > >>>>> after
> > > > > >>>> applying the
> > > > > >>>>> patch V2? And your test script?
> > > > > >>>> Regarding CPU utilization, I need to test one more time.
> > > > > >>>> Currently system is in used.
> > > > > >>>>
> > > > > >>>> I run below fio test on total 24 SSDs expander attached.
> > > > > >>>>
> > > > > >>>> numactl -N 1 fio jbod.fio --rw=randread --iodepth=64 --bs=4k
> > > > > >>>> --ioengine=libaio --rw=randread
> > > > > >>>>
> > > > > >>>> Performance dropped from 1.6 M IOPs to 770K IOPs.
> > > > > >>>>
> > > > > >>> This is basically what we've seen with earlier iterations.
> > > > > >>
> > > > > >> Hi Hannes,
> > > > > >>
> > > > > >> As I mentioned in another mail[1], Kashyap's patch has a big
> > > > > >> issue,
> > > > > > which
> > > > > >> causes only reply queue 0 used.
> > > > > >>
> > > > > >> [1] https://marc.info/?l=linux-scsi&m=151793204014631&w=2
> > > > > >>
> > > > > >> So could you guys run your performance test again after fixing
> > > > > >> the
> > > > > > patch?
> > > > > >
> > > > > > Ming -
> > > > > >
> > > > > > I tried after change you requested.  Performance drop is still
> > > unresolved.
> > > > > > From 1.6 M IOPS to 770K IOPS.
> > > > > >
> > > > > > See below data. All 24 reply queue is in used correctly.
> > > > > >
> > > > > > IRQs / 1 second(s)
> > > > > > IRQ#  TOTAL  NODE0   NODE1  NAME
> > > > > >  360  16422      0   16422  IR-PCI-MSI 70254653-edge megasas
> > > > > >  364  15980      0   15980  IR-PCI-MSI 70254657-edge megasas
> > > > > >  362  15979      0   15979  IR-PCI-MSI 70254655-edge megasas
> > > > > >  345  15696      0   15696  IR-PCI-MSI 70254638-edge megasas
> > > > > >  341  15659      0   15659  IR-PCI-MSI 70254634-edge megasas
> > > > > >  369  15656      0   15656  IR-PCI-MSI 70254662-edge megasas
> > > > > >  359  15650      0   15650  IR-PCI-MSI 70254652-edge megasas
> > > > > >  358  15596      0   15596  IR-PCI-MSI 70254651-edge megasas
> > > > > >  350  15574      0   15574  IR-PCI-MSI 70254643-edge megasas
> > > > > >  342  15532      0   15532  IR-PCI-MSI 70254635-edge megasas
> > > > > >  344  15527      0   15527  IR-PCI-MSI 70254637-edge megasas
> > > > > >  346  15485      0   15485  IR-PCI-MSI 70254639-edge megasas
> > > > > >  361  15482      0   15482  IR-PCI-MSI 70254654-edge megasas
> > > > > >  348  15467      0   15467  IR-PCI-MSI 70254641-edge megasas
> > > > > >  368  15463      0   15463  IR-PCI-MSI 70254661-edge megasas
> > > > > >  354  15420      0   15420  IR-PCI-MSI 70254647-edge megasas
> > > > > >  351  15378      0   15378  IR-PCI-MSI 70254644-edge megasas
> > > > > >  352  15377      0   15377  IR-PCI-MSI 70254645-edge megasas
> > > > > >  356  15348      0   15348  IR-PCI-MSI 70254649-edge megasas
> > > > > >  337  15344      0   15344  IR-PCI-MSI 70254630-edge megasas
> > > > > >  343  15320      0   15320  IR-PCI-MSI 70254636-edge megasas
> > > > > >  355  15266      0   15266  IR-PCI-MSI 70254648-edge megasas
> > > > > >  335  15247      0   15247  IR-PCI-MSI 70254628-edge megasas
> > > > > >  363  15233      0   15233  IR-PCI-MSI 70254656-edge megasas
> > > > > >
> > > > > >
> > > > > > Average:        CPU      %usr     %nice      %sys   %iowait
> > > %steal
> > > > > > %irq     %soft    %guest    %gnice     %idle
> > > > > > Average:         18      3.80      0.00     14.78     10.08
> > > 0.00
> > > > > > 0.00      4.01      0.00      0.00     67.33
> > > > > > Average:         19      3.26      0.00     15.35     10.62
> > > 0.00
> > > > > > 0.00      4.03      0.00      0.00     66.74
> > > > > > Average:         20      3.42      0.00     14.57     10.67
> > > 0.00
> > > > > > 0.00      3.84      0.00      0.00     67.50
> > > > > > Average:         21      3.19      0.00     15.60     10.75
> > > 0.00
> > > > > > 0.00      4.16      0.00      0.00     66.30
> > > > > > Average:         22      3.58      0.00     15.15     10.66
> > > 0.00
> > > > > > 0.00      3.51      0.00      0.00     67.11
> > > > > > Average:         23      3.34      0.00     15.36     10.63
> > > 0.00
> > > > > > 0.00      4.17      0.00      0.00     66.50
> > > > > > Average:         24      3.50      0.00     14.58     10.93
> > > 0.00
> > > > > > 0.00      3.85      0.00      0.00     67.13
> > > > > > Average:         25      3.20      0.00     14.68     10.86
> > > 0.00
> > > > > > 0.00      4.31      0.00      0.00     66.95
> > > > > > Average:         26      3.27      0.00     14.80     10.70
> > > 0.00
> > > > > > 0.00      3.68      0.00      0.00     67.55
> > > > > > Average:         27      3.58      0.00     15.36     10.80
> > > 0.00
> > > > > > 0.00      3.79      0.00      0.00     66.48
> > > > > > Average:         28      3.46      0.00     15.17     10.46
> > > 0.00
> > > > > > 0.00      3.32      0.00      0.00     67.59
> > > > > > Average:         29      3.34      0.00     14.42     10.72
> > > 0.00
> > > > > > 0.00      3.34      0.00      0.00     68.18
> > > > > > Average:         30      3.34      0.00     15.08     10.70
> > > 0.00
> > > > > > 0.00      3.89      0.00      0.00     66.99
> > > > > > Average:         31      3.26      0.00     15.33     10.47
> > > 0.00
> > > > > > 0.00      3.33      0.00      0.00     67.61
> > > > > > Average:         32      3.21      0.00     14.80     10.61
> > > 0.00
> > > > > > 0.00      3.70      0.00      0.00     67.67
> > > > > > Average:         33      3.40      0.00     13.88     10.55
> > > 0.00
> > > > > > 0.00      4.02      0.00      0.00     68.15
> > > > > > Average:         34      3.74      0.00     17.41     10.61
> > > 0.00
> > > > > > 0.00      4.51      0.00      0.00     63.73
> > > > > > Average:         35      3.35      0.00     14.37     10.74
> > > 0.00
> > > > > > 0.00      3.84      0.00      0.00     67.71
> > > > > > Average:         36      0.54      0.00      1.77      0.00
> > > 0.00
> > > > > > 0.00      0.00      0.00      0.00     97.69
> > > > > > ..
> > > > > > Average:         54      3.60      0.00     15.17     10.39
> > > 0.00
> > > > > > 0.00      4.22      0.00      0.00     66.62
> > > > > > Average:         55      3.33      0.00     14.85     10.55
> > > 0.00
> > > > > > 0.00      3.96      0.00      0.00     67.31
> > > > > > Average:         56      3.40      0.00     15.19     10.54
> > > 0.00
> > > > > > 0.00      3.74      0.00      0.00     67.13
> > > > > > Average:         57      3.41      0.00     13.98     10.78
> > > 0.00
> > > > > > 0.00      4.10      0.00      0.00     67.73
> > > > > > Average:         58      3.32      0.00     15.16     10.52
> > > 0.00
> > > > > > 0.00      4.01      0.00      0.00     66.99
> > > > > > Average:         59      3.17      0.00     15.80     10.35
> > > 0.00
> > > > > > 0.00      3.86      0.00      0.00     66.80
> > > > > > Average:         60      3.00      0.00     14.63     10.59
> > > 0.00
> > > > > > 0.00      3.97      0.00      0.00     67.80
> > > > > > Average:         61      3.34      0.00     14.70     10.66
> > > 0.00
> > > > > > 0.00      4.32      0.00      0.00     66.97
> > > > > > Average:         62      3.34      0.00     15.29     10.56
> > > 0.00
> > > > > > 0.00      3.89      0.00      0.00     66.92
> > > > > > Average:         63      3.29      0.00     14.51     10.72
> > > 0.00
> > > > > > 0.00      3.85      0.00      0.00     67.62
> > > > > > Average:         64      3.48      0.00     15.31     10.65
> > > 0.00
> > > > > > 0.00      3.97      0.00      0.00     66.60
> > > > > > Average:         65      3.34      0.00     14.36     10.80
> > > 0.00
> > > > > > 0.00      4.11      0.00      0.00     67.39
> > > > > > Average:         66      3.13      0.00     14.94     10.70
> > > 0.00
> > > > > > 0.00      4.10      0.00      0.00     67.13
> > > > > > Average:         67      3.06      0.00     15.56     10.69
> > > 0.00
> > > > > > 0.00      3.82      0.00      0.00     66.88
> > > > > > Average:         68      3.33      0.00     14.98     10.61
> > > 0.00
> > > > > > 0.00      3.81      0.00      0.00     67.27
> > > > > > Average:         69      3.20      0.00     15.43     10.70
> > > 0.00
> > > > > > 0.00      3.82      0.00      0.00     66.85
> > > > > > Average:         70      3.34      0.00     17.14     10.59
> > > 0.00
> > > > > > 0.00      3.00      0.00      0.00     65.92
> > > > > > Average:         71      3.41      0.00     14.94     10.56
> > > 0.00
> > > > > > 0.00      3.41      0.00      0.00     67.69
> > > > > >
> > > > > > Perf top -
> > > > > >
> > > > > >   64.33%  [kernel]            [k] bt_iter
> > > > > >    4.86%  [kernel]            [k] blk_mq_queue_tag_busy_iter
> > > > > >    4.23%  [kernel]            [k] _find_next_bit
> > > > > >    2.40%  [kernel]            [k]
> native_queued_spin_lock_slowpath
> > > > > >    1.09%  [kernel]            [k] sbitmap_any_bit_set
> > > > > >    0.71%  [kernel]            [k] sbitmap_queue_clear
> > > > > >    0.63%  [kernel]            [k] find_next_bit
> > > > > >    0.54%  [kernel]            [k] _raw_spin_lock_irqsave
> > > > > >
> > > > > Ah. So we're spending quite some time in trying to find a free
> tag.
> > > > > I guess this is due to every queue starting at the same position
> > > > > trying to find a free tag, which inevitably leads to a contention.
> > > >
> > > > IMO, the above trace means that blk_mq_in_flight() may be the
> > > bottleneck,
> > > > and looks not related with tag allocation.
> > > >
> > > > Kashyap, could you run your performance test again after disabling
> > > iostat by
> > > > the following command on all test devices and killing all utilities
> > > which may
> > > > read iostat(/proc/diskstats, ...)?
> > > >
> > > > 	echo 0 > /sys/block/sdN/queue/iostat
> > >
> > > Ming - After changing iostat = 0 , I see performance issue is
> resolved.
> > >
> > > Below is perf top output after iostats = 0
> > >
> > >
> > >   23.45%  [kernel]             [k] bt_iter
> > >    2.27%  [kernel]             [k] blk_mq_queue_tag_busy_iter
> > >    2.18%  [kernel]             [k] _find_next_bit
> > >    2.06%  [megaraid_sas]       [k] complete_cmd_fusion
> > >    1.87%  [kernel]             [k] clflush_cache_range
> > >    1.70%  [kernel]             [k] dma_pte_clear_level
> > >    1.56%  [kernel]             [k] __domain_mapping
> > >    1.55%  [kernel]             [k] sbitmap_queue_clear
> > >    1.30%  [kernel]             [k] gup_pgd_range
> >
> > Hi Kashyap,
> >
> > Thanks for your test and update.
> >
> > Looks blk_mq_queue_tag_busy_iter() is still sampled by perf even though
> > iostats is disabled, and I guess there may be utilities which are
> reading iostats
> > a bit frequently.
> 
> I  will be doing some more testing and post you my findings.

I will find sometime this weekend to see if I can cook a patch to
address this issue of io accounting.

> 
> >
> > Either there is issue introduced in part_round_stats() recently since I
> > remember that this counter should have been read at most one time during
> > one jiffies in IO path, or the implementation of blk_mq_in_flight() can
> become
> > a bit heavy in your environment. Jens may have idea about this issue.
> >
> > And I guess the lockup issue may be avoided by this approach now?
> 
> NO.  For CPU Lock up we need irq poll interface to quit from ISR loop of
> the driver.

Actually after this patchset starts working, the request's completion is
done basically on the submission CPU. Seems all CPU shouldn't have been
overloaded, given your system has so many msix irq vectors and enough
CPU cores.

I am interested in this problem too, but I think we have to fix the io
accounting issue first. Once the accounting issue(which may cause too
much CPU consumed up in interrupt handler) is fixed, let's see if there
is still the lockup issue. If there is, 'perf' may tell us something. But
from your previous perf trace, looks only the accounting symbols are listed
in hot path.

Thanks,
Ming
