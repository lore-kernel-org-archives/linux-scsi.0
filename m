From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Tue, 13 Feb 2018 08:40:38 +0800
Message-ID: <20180213004031.GA8109@ming.t460p>
References: <20180207122257.GA16633@ming.t460p>
 <95b8ea33c79b84188e4a54b4e5fcd7b6@mail.gmail.com>
 <35778fd9-ede6-ed3d-4b13-27fb35ede9bd@suse.de>
 <20180208165313.GA31725@ming.t460p>
 <14c596572dcf99c4343c7eba65a7c427@mail.gmail.com>
 <20180209053107.GA30909@ming.t460p>
 <50c2ea693cd9923b53e2eb0ffd2b143e@mail.gmail.com>
 <20180210010057.GA2543@ming.t460p>
 <20180211053102.GA15507@ming.t460p>
 <4d9ec8ce1766819fa537c81a4a1db276@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932792AbeBMAlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Feb 2018 19:41:04 -0500
Content-Disposition: inline
In-Reply-To: <4d9ec8ce1766819fa537c81a4a1db276@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

Hi Kashyap,

On Tue, Feb 13, 2018 at 12:05:14AM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Ming Lei [mailto:ming.lei@redhat.com]
> > Sent: Sunday, February 11, 2018 11:01 AM
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
> > On Sat, Feb 10, 2018 at 09:00:57AM +0800, Ming Lei wrote:
> > > Hi Kashyap,
> > >
> > > On Fri, Feb 09, 2018 at 02:12:16PM +0530, Kashyap Desai wrote:
> > > > > -----Original Message-----
> > > > > From: Ming Lei [mailto:ming.lei@redhat.com]
> > > > > Sent: Friday, February 9, 2018 11:01 AM
> > > > > To: Kashyap Desai
> > > > > Cc: Hannes Reinecke; Jens Axboe; linux-block@vger.kernel.org;
> > > > > Christoph Hellwig; Mike Snitzer; linux-scsi@vger.kernel.org; Arun
> > > > > Easi; Omar
> > > > Sandoval;
> > > > > Martin K . Petersen; James Bottomley; Christoph Hellwig; Don
> > > > > Brace;
> > > > Peter
> > > > > Rivera; Paolo Bonzini; Laurence Oberman
> > > > > Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags &
> > > > > introduce force_blk_mq
> > > > >
> > > > > On Fri, Feb 09, 2018 at 10:28:23AM +0530, Kashyap Desai wrote:
> > > > > > > -----Original Message-----
> > > > > > > From: Ming Lei [mailto:ming.lei@redhat.com]
> > > > > > > Sent: Thursday, February 8, 2018 10:23 PM
> > > > > > > To: Hannes Reinecke
> > > > > > > Cc: Kashyap Desai; Jens Axboe; linux-block@vger.kernel.org;
> > > > > > > Christoph Hellwig; Mike Snitzer; linux-scsi@vger.kernel.org;
> > > > > > > Arun Easi; Omar
> > > > > > Sandoval;
> > > > > > > Martin K . Petersen; James Bottomley; Christoph Hellwig; Don
> > > > > > > Brace;
> > > > > > Peter
> > > > > > > Rivera; Paolo Bonzini; Laurence Oberman
> > > > > > > Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags &
> > > > > > > introduce force_blk_mq
> > > > > > >
> > > > > > > On Thu, Feb 08, 2018 at 08:00:29AM +0100, Hannes Reinecke
> wrote:
> > > > > > > > On 02/07/2018 03:14 PM, Kashyap Desai wrote:
> > > > > > > > >> -----Original Message-----
> > > > > > > > >> From: Ming Lei [mailto:ming.lei@redhat.com]
> > > > > > > > >> Sent: Wednesday, February 7, 2018 5:53 PM
> > > > > > > > >> To: Hannes Reinecke
> > > > > > > > >> Cc: Kashyap Desai; Jens Axboe;
> > > > > > > > >> linux-block@vger.kernel.org; Christoph Hellwig; Mike
> > > > > > > > >> Snitzer; linux-scsi@vger.kernel.org; Arun Easi; Omar
> > > > > > > > > Sandoval;
> > > > > > > > >> Martin K . Petersen; James Bottomley; Christoph Hellwig;
> > > > > > > > >> Don Brace;
> > > > > > > > > Peter
> > > > > > > > >> Rivera; Paolo Bonzini; Laurence Oberman
> > > > > > > > >> Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global
> > > > > > > > >> tags & introduce force_blk_mq
> > > > > > > > >>
> > > > > > > > >> On Wed, Feb 07, 2018 at 07:50:21AM +0100, Hannes Reinecke
> > > > wrote:
> > > > > > > > >>> Hi all,
> > > > > > > > >>>
> > > > > > > > >>> [ .. ]
> > > > > > > > >>>>>
> > > > > > > > >>>>> Could you share us your patch for enabling
> > > > > > > > >>>>> global_tags/MQ on
> > > > > > > > >>>> megaraid_sas
> > > > > > > > >>>>> so that I can reproduce your test?
> > > > > > > > >>>>>
> > > > > > > > >>>>>> See below perf top data. "bt_iter" is consuming 4
> > > > > > > > >>>>>> times more
> > > > > > CPU.
> > > > > > > > >>>>>
> > > > > > > > >>>>> Could you share us what the IOPS/CPU utilization
> > > > > > > > >>>>> effect is after
> > > > > > > > >>>> applying the
> > > > > > > > >>>>> patch V2? And your test script?
> > > > > > > > >>>> Regarding CPU utilization, I need to test one more
> time.
> > > > > > > > >>>> Currently system is in used.
> > > > > > > > >>>>
> > > > > > > > >>>> I run below fio test on total 24 SSDs expander
> attached.
> > > > > > > > >>>>
> > > > > > > > >>>> numactl -N 1 fio jbod.fio --rw=randread --iodepth=64
> > > > > > > > >>>> --bs=4k --ioengine=libaio --rw=randread
> > > > > > > > >>>>
> > > > > > > > >>>> Performance dropped from 1.6 M IOPs to 770K IOPs.
> > > > > > > > >>>>
> > > > > > > > >>> This is basically what we've seen with earlier
> iterations.
> > > > > > > > >>
> > > > > > > > >> Hi Hannes,
> > > > > > > > >>
> > > > > > > > >> As I mentioned in another mail[1], Kashyap's patch has a
> > > > > > > > >> big issue,
> > > > > > > > > which
> > > > > > > > >> causes only reply queue 0 used.
> > > > > > > > >>
> > > > > > > > >> [1] https://marc.info/?l=linux-scsi&m=151793204014631&w=2
> > > > > > > > >>
> > > > > > > > >> So could you guys run your performance test again after
> > > > > > > > >> fixing the
> > > > > > > > > patch?
> > > > > > > > >
> > > > > > > > > Ming -
> > > > > > > > >
> > > > > > > > > I tried after change you requested.  Performance drop is
> > > > > > > > > still
> > > > > > unresolved.
> > > > > > > > > From 1.6 M IOPS to 770K IOPS.
> > > > > > > > >
> > > > > > > > > See below data. All 24 reply queue is in used correctly.
> > > > > > > > >
> > > > > > > > > IRQs / 1 second(s)
> > > > > > > > > IRQ#  TOTAL  NODE0   NODE1  NAME
> > > > > > > > >  360  16422      0   16422  IR-PCI-MSI 70254653-edge
> megasas
> > > > > > > > >  364  15980      0   15980  IR-PCI-MSI 70254657-edge
> megasas
> > > > > > > > >  362  15979      0   15979  IR-PCI-MSI 70254655-edge
> megasas
> > > > > > > > >  345  15696      0   15696  IR-PCI-MSI 70254638-edge
> megasas
> > > > > > > > >  341  15659      0   15659  IR-PCI-MSI 70254634-edge
> megasas
> > > > > > > > >  369  15656      0   15656  IR-PCI-MSI 70254662-edge
> megasas
> > > > > > > > >  359  15650      0   15650  IR-PCI-MSI 70254652-edge
> megasas
> > > > > > > > >  358  15596      0   15596  IR-PCI-MSI 70254651-edge
> megasas
> > > > > > > > >  350  15574      0   15574  IR-PCI-MSI 70254643-edge
> megasas
> > > > > > > > >  342  15532      0   15532  IR-PCI-MSI 70254635-edge
> megasas
> > > > > > > > >  344  15527      0   15527  IR-PCI-MSI 70254637-edge
> megasas
> > > > > > > > >  346  15485      0   15485  IR-PCI-MSI 70254639-edge
> megasas
> > > > > > > > >  361  15482      0   15482  IR-PCI-MSI 70254654-edge
> megasas
> > > > > > > > >  348  15467      0   15467  IR-PCI-MSI 70254641-edge
> megasas
> > > > > > > > >  368  15463      0   15463  IR-PCI-MSI 70254661-edge
> megasas
> > > > > > > > >  354  15420      0   15420  IR-PCI-MSI 70254647-edge
> megasas
> > > > > > > > >  351  15378      0   15378  IR-PCI-MSI 70254644-edge
> megasas
> > > > > > > > >  352  15377      0   15377  IR-PCI-MSI 70254645-edge
> megasas
> > > > > > > > >  356  15348      0   15348  IR-PCI-MSI 70254649-edge
> megasas
> > > > > > > > >  337  15344      0   15344  IR-PCI-MSI 70254630-edge
> megasas
> > > > > > > > >  343  15320      0   15320  IR-PCI-MSI 70254636-edge
> megasas
> > > > > > > > >  355  15266      0   15266  IR-PCI-MSI 70254648-edge
> megasas
> > > > > > > > >  335  15247      0   15247  IR-PCI-MSI 70254628-edge
> megasas
> > > > > > > > >  363  15233      0   15233  IR-PCI-MSI 70254656-edge
> megasas
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > Average:        CPU      %usr     %nice      %sys
> %iowait
> > > > > > %steal
> > > > > > > > > %irq     %soft    %guest    %gnice     %idle
> > > > > > > > > Average:         18      3.80      0.00     14.78
> 10.08
> > > > > > 0.00
> > > > > > > > > 0.00      4.01      0.00      0.00     67.33
> > > > > > > > > Average:         19      3.26      0.00     15.35
> 10.62
> > > > > > 0.00
> > > > > > > > > 0.00      4.03      0.00      0.00     66.74
> > > > > > > > > Average:         20      3.42      0.00     14.57
> 10.67
> > > > > > 0.00
> > > > > > > > > 0.00      3.84      0.00      0.00     67.50
> > > > > > > > > Average:         21      3.19      0.00     15.60
> 10.75
> > > > > > 0.00
> > > > > > > > > 0.00      4.16      0.00      0.00     66.30
> > > > > > > > > Average:         22      3.58      0.00     15.15
> 10.66
> > > > > > 0.00
> > > > > > > > > 0.00      3.51      0.00      0.00     67.11
> > > > > > > > > Average:         23      3.34      0.00     15.36
> 10.63
> > > > > > 0.00
> > > > > > > > > 0.00      4.17      0.00      0.00     66.50
> > > > > > > > > Average:         24      3.50      0.00     14.58
> 10.93
> > > > > > 0.00
> > > > > > > > > 0.00      3.85      0.00      0.00     67.13
> > > > > > > > > Average:         25      3.20      0.00     14.68
> 10.86
> > > > > > 0.00
> > > > > > > > > 0.00      4.31      0.00      0.00     66.95
> > > > > > > > > Average:         26      3.27      0.00     14.80
> 10.70
> > > > > > 0.00
> > > > > > > > > 0.00      3.68      0.00      0.00     67.55
> > > > > > > > > Average:         27      3.58      0.00     15.36
> 10.80
> > > > > > 0.00
> > > > > > > > > 0.00      3.79      0.00      0.00     66.48
> > > > > > > > > Average:         28      3.46      0.00     15.17
> 10.46
> > > > > > 0.00
> > > > > > > > > 0.00      3.32      0.00      0.00     67.59
> > > > > > > > > Average:         29      3.34      0.00     14.42
> 10.72
> > > > > > 0.00
> > > > > > > > > 0.00      3.34      0.00      0.00     68.18
> > > > > > > > > Average:         30      3.34      0.00     15.08
> 10.70
> > > > > > 0.00
> > > > > > > > > 0.00      3.89      0.00      0.00     66.99
> > > > > > > > > Average:         31      3.26      0.00     15.33
> 10.47
> > > > > > 0.00
> > > > > > > > > 0.00      3.33      0.00      0.00     67.61
> > > > > > > > > Average:         32      3.21      0.00     14.80
> 10.61
> > > > > > 0.00
> > > > > > > > > 0.00      3.70      0.00      0.00     67.67
> > > > > > > > > Average:         33      3.40      0.00     13.88
> 10.55
> > > > > > 0.00
> > > > > > > > > 0.00      4.02      0.00      0.00     68.15
> > > > > > > > > Average:         34      3.74      0.00     17.41
> 10.61
> > > > > > 0.00
> > > > > > > > > 0.00      4.51      0.00      0.00     63.73
> > > > > > > > > Average:         35      3.35      0.00     14.37
> 10.74
> > > > > > 0.00
> > > > > > > > > 0.00      3.84      0.00      0.00     67.71
> > > > > > > > > Average:         36      0.54      0.00      1.77
> 0.00
> > > > > > 0.00
> > > > > > > > > 0.00      0.00      0.00      0.00     97.69
> > > > > > > > > ..
> > > > > > > > > Average:         54      3.60      0.00     15.17
> 10.39
> > > > > > 0.00
> > > > > > > > > 0.00      4.22      0.00      0.00     66.62
> > > > > > > > > Average:         55      3.33      0.00     14.85
> 10.55
> > > > > > 0.00
> > > > > > > > > 0.00      3.96      0.00      0.00     67.31
> > > > > > > > > Average:         56      3.40      0.00     15.19
> 10.54
> > > > > > 0.00
> > > > > > > > > 0.00      3.74      0.00      0.00     67.13
> > > > > > > > > Average:         57      3.41      0.00     13.98
> 10.78
> > > > > > 0.00
> > > > > > > > > 0.00      4.10      0.00      0.00     67.73
> > > > > > > > > Average:         58      3.32      0.00     15.16
> 10.52
> > > > > > 0.00
> > > > > > > > > 0.00      4.01      0.00      0.00     66.99
> > > > > > > > > Average:         59      3.17      0.00     15.80
> 10.35
> > > > > > 0.00
> > > > > > > > > 0.00      3.86      0.00      0.00     66.80
> > > > > > > > > Average:         60      3.00      0.00     14.63
> 10.59
> > > > > > 0.00
> > > > > > > > > 0.00      3.97      0.00      0.00     67.80
> > > > > > > > > Average:         61      3.34      0.00     14.70
> 10.66
> > > > > > 0.00
> > > > > > > > > 0.00      4.32      0.00      0.00     66.97
> > > > > > > > > Average:         62      3.34      0.00     15.29
> 10.56
> > > > > > 0.00
> > > > > > > > > 0.00      3.89      0.00      0.00     66.92
> > > > > > > > > Average:         63      3.29      0.00     14.51
> 10.72
> > > > > > 0.00
> > > > > > > > > 0.00      3.85      0.00      0.00     67.62
> > > > > > > > > Average:         64      3.48      0.00     15.31
> 10.65
> > > > > > 0.00
> > > > > > > > > 0.00      3.97      0.00      0.00     66.60
> > > > > > > > > Average:         65      3.34      0.00     14.36
> 10.80
> > > > > > 0.00
> > > > > > > > > 0.00      4.11      0.00      0.00     67.39
> > > > > > > > > Average:         66      3.13      0.00     14.94
> 10.70
> > > > > > 0.00
> > > > > > > > > 0.00      4.10      0.00      0.00     67.13
> > > > > > > > > Average:         67      3.06      0.00     15.56
> 10.69
> > > > > > 0.00
> > > > > > > > > 0.00      3.82      0.00      0.00     66.88
> > > > > > > > > Average:         68      3.33      0.00     14.98
> 10.61
> > > > > > 0.00
> > > > > > > > > 0.00      3.81      0.00      0.00     67.27
> > > > > > > > > Average:         69      3.20      0.00     15.43
> 10.70
> > > > > > 0.00
> > > > > > > > > 0.00      3.82      0.00      0.00     66.85
> > > > > > > > > Average:         70      3.34      0.00     17.14
> 10.59
> > > > > > 0.00
> > > > > > > > > 0.00      3.00      0.00      0.00     65.92
> > > > > > > > > Average:         71      3.41      0.00     14.94
> 10.56
> > > > > > 0.00
> > > > > > > > > 0.00      3.41      0.00      0.00     67.69
> > > > > > > > >
> > > > > > > > > Perf top -
> > > > > > > > >
> > > > > > > > >   64.33%  [kernel]            [k] bt_iter
> > > > > > > > >    4.86%  [kernel]            [k]
> blk_mq_queue_tag_busy_iter
> > > > > > > > >    4.23%  [kernel]            [k] _find_next_bit
> > > > > > > > >    2.40%  [kernel]            [k]
> > > > native_queued_spin_lock_slowpath
> > > > > > > > >    1.09%  [kernel]            [k] sbitmap_any_bit_set
> > > > > > > > >    0.71%  [kernel]            [k] sbitmap_queue_clear
> > > > > > > > >    0.63%  [kernel]            [k] find_next_bit
> > > > > > > > >    0.54%  [kernel]            [k] _raw_spin_lock_irqsave
> > > > > > > > >
> > > > > > > > Ah. So we're spending quite some time in trying to find a
> > > > > > > > free
> > > > tag.
> > > > > > > > I guess this is due to every queue starting at the same
> > > > > > > > position trying to find a free tag, which inevitably leads
> to a
> > contention.
> > > > > > >
> > > > > > > IMO, the above trace means that blk_mq_in_flight() may be the
> > > > > > bottleneck,
> > > > > > > and looks not related with tag allocation.
> > > > > > >
> > > > > > > Kashyap, could you run your performance test again after
> > > > > > > disabling
> > > > > > iostat by
> > > > > > > the following command on all test devices and killing all
> > > > > > > utilities
> > > > > > which may
> > > > > > > read iostat(/proc/diskstats, ...)?
> > > > > > >
> > > > > > > 	echo 0 > /sys/block/sdN/queue/iostat
> > > > > >
> > > > > > Ming - After changing iostat = 0 , I see performance issue is
> > > > resolved.
> > > > > >
> > > > > > Below is perf top output after iostats = 0
> > > > > >
> > > > > >
> > > > > >   23.45%  [kernel]             [k] bt_iter
> > > > > >    2.27%  [kernel]             [k] blk_mq_queue_tag_busy_iter
> > > > > >    2.18%  [kernel]             [k] _find_next_bit
> > > > > >    2.06%  [megaraid_sas]       [k] complete_cmd_fusion
> > > > > >    1.87%  [kernel]             [k] clflush_cache_range
> > > > > >    1.70%  [kernel]             [k] dma_pte_clear_level
> > > > > >    1.56%  [kernel]             [k] __domain_mapping
> > > > > >    1.55%  [kernel]             [k] sbitmap_queue_clear
> > > > > >    1.30%  [kernel]             [k] gup_pgd_range
> > > > >
> > > > > Hi Kashyap,
> > > > >
> > > > > Thanks for your test and update.
> > > > >
> > > > > Looks blk_mq_queue_tag_busy_iter() is still sampled by perf even
> > > > > though iostats is disabled, and I guess there may be utilities
> > > > > which are
> > > > reading iostats
> > > > > a bit frequently.
> > > >
> > > > I  will be doing some more testing and post you my findings.
> > >
> > > I will find sometime this weekend to see if I can cook a patch to
> > > address this issue of io accounting.
> >
> > Hi Kashyap,
> >
> > Please test the top 5 patches in the following tree to see if
> megaraid_sas's
> > performance is OK:
> >
> > 	https://github.com/ming1/linux/commits/v4.15-for-next-global-tags-
> > v2
> >
> > This tree is made by adding these 5 patches against patchset V2.
> >
> 
> Ming -
> I applied 5 patches on top of V2 and behavior is still unchanged. Below is
> perf top data. (1000K IOPS)
> 
>   34.58%  [kernel]                 [k] bt_iter
>    2.96%  [kernel]                 [k] sbitmap_any_bit_set
>    2.77%  [kernel]                 [k] bt_iter_global_tags
>    1.75%  [megaraid_sas]           [k] complete_cmd_fusion
>    1.62%  [kernel]                 [k] sbitmap_queue_clear
>    1.62%  [kernel]                 [k] _raw_spin_lock
>    1.51%  [kernel]                 [k] blk_mq_run_hw_queue
>    1.45%  [kernel]                 [k] gup_pgd_range
>    1.31%  [kernel]                 [k] irq_entries_start
>    1.29%  fio                      [.] __fio_gettime
>    1.13%  [kernel]                 [k] _raw_spin_lock_irqsave
>    0.95%  [kernel]                 [k] native_queued_spin_lock_slowpath
>    0.92%  [kernel]                 [k] scsi_queue_rq
>    0.91%  [kernel]                 [k] blk_mq_run_hw_queues
>    0.85%  [kernel]                 [k] blk_mq_get_request
>    0.81%  [kernel]                 [k] switch_mm_irqs_off
>    0.78%  [megaraid_sas]           [k] megasas_build_io_fusion
>    0.77%  [kernel]                 [k] __schedule
>    0.73%  [kernel]                 [k] update_load_avg
>    0.69%  [kernel]                 [k] fput
>    0.65%  [kernel]                 [k] scsi_dispatch_cmd
>    0.64%  fio                      [.] fio_libaio_event
>    0.53%  [kernel]                 [k] do_io_submit
>    0.52%  [kernel]                 [k] read_tsc
>    0.51%  [megaraid_sas]           [k] megasas_build_and_issue_cmd_fusion
>    0.51%  [kernel]                 [k] scsi_softirq_done
>    0.50%  [kernel]                 [k] kobject_put
>    0.50%  [kernel]                 [k] cpuidle_enter_state
>    0.49%  [kernel]                 [k] native_write_msr
>    0.48%  fio                      [.] io_completed
> 
> Below is perf top data with iostat=0  (1400K IOPS)
> 
>    4.87%  [kernel]                      [k] sbitmap_any_bit_set
>    2.93%  [kernel]                      [k] _raw_spin_lock
>    2.84%  [megaraid_sas]                [k] complete_cmd_fusion
>    2.38%  [kernel]                      [k] irq_entries_start
>    2.36%  [kernel]                      [k] gup_pgd_range
>    2.35%  [kernel]                      [k] blk_mq_run_hw_queue
>    2.30%  [kernel]                      [k] sbitmap_queue_clear
>    2.01%  fio                           [.] __fio_gettime
>    1.78%  [kernel]                      [k] _raw_spin_lock_irqsave
>    1.51%  [kernel]                      [k] scsi_queue_rq
>    1.43%  [kernel]                      [k] blk_mq_run_hw_queues
>    1.36%  [kernel]                      [k] fput
>    1.32%  [kernel]                      [k] __schedule
>    1.31%  [kernel]                      [k] switch_mm_irqs_off
>    1.29%  [kernel]                      [k] update_load_avg
>    1.25%  [megaraid_sas]                [k] megasas_build_io_fusion
>    1.22%  [kernel]                      [k]
> native_queued_spin_lock_slowpath
>    1.03%  [kernel]                      [k] scsi_dispatch_cmd
>    1.03%  [kernel]                      [k] blk_mq_get_request
>    0.91%  fio                           [.] fio_libaio_event
>    0.89%  [kernel]                      [k] scsi_softirq_done
>    0.87%  [kernel]                      [k] kobject_put
>    0.86%  [kernel]                      [k] cpuidle_enter_state
>    0.84%  fio                           [.] io_completed
>    0.83%  [kernel]                      [k] do_io_submit
>    0.83%  [megaraid_sas]                [k]
> megasas_build_and_issue_cmd_fusion
>    0.83%  [kernel]                      [k] __switch_to
>    0.82%  [kernel]                      [k] read_tsc
>    0.80%  [kernel]                      [k] native_write_msr
>    0.76%  [kernel]                      [k] aio_comp
> 
> 
> Perf data without V2 patch applied.  (1600K IOPS)
> 
>    5.97%  [megaraid_sas]           [k] complete_cmd_fusion
>    5.24%  [kernel]                 [k] bt_iter
>    3.28%  [kernel]                 [k] _raw_spin_lock
>    2.98%  [kernel]                 [k] irq_entries_start
>    2.29%  fio                      [.] __fio_gettime
>    2.04%  [kernel]                 [k] scsi_queue_rq
>    1.92%  [megaraid_sas]           [k] megasas_build_io_fusion
>    1.61%  [kernel]                 [k] switch_mm_irqs_off
>    1.59%  [megaraid_sas]           [k] megasas_build_and_issue_cmd_fusion
>    1.41%  [kernel]                 [k] scsi_dispatch_cmd
>    1.33%  [kernel]                 [k] scsi_softirq_done
>    1.18%  [kernel]                 [k] gup_pgd_range
>    1.18%  [kernel]                 [k] blk_mq_complete_request
>    1.13%  [kernel]                 [k] blk_mq_free_request
>    1.05%  [kernel]                 [k] do_io_submit
>    1.04%  [kernel]                 [k] _find_next_bit
>    1.02%  [kernel]                 [k] blk_mq_get_request
>    0.95%  [megaraid_sas]           [k] megasas_build_ldio_fusion
>    0.95%  [kernel]                 [k] scsi_dec_host_busy
>    0.89%  fio                      [.] get_io_u
>    0.88%  [kernel]                 [k] entry_SYSCALL_64
>    0.84%  [megaraid_sas]           [k] megasas_queue_command
>    0.79%  [kernel]                 [k] native_write_msr
>    0.77%  [kernel]                 [k] read_tsc
>    0.73%  [kernel]                 [k] _raw_spin_lock_irqsave
>    0.73%  fio                      [.] fio_libaio_commit
>    0.72%  [kernel]                 [k] kmem_cache_alloc
>    0.72%  [kernel]                 [k] blkdev_direct_IO
>    0.69%  [megaraid_sas]           [k] MR_GetPhyParams
>    0.68%  [kernel]                 [k] blk_mq_dequeue_f

The above data is very helpful to understand the issue, great thanks!

With this patchset V2 and the 5 patches, if iostats is set as 0, IOPS
is 1400K, but 1600K IOPS can be reached without all these patches with
iostats as 1.

BTW, could you share us what the machine is? ARM64? I saw ARM64's cache
coherence performance is bad before. In the dual socket system(each socket
has 8 X86 CPU cores) I tested, only ~0.5% IOPS drop can be observed after
the 5 patches are applied on V2 in null_blk test, which is described in commit
log.

Looks it means single sbitmap can't perform well under MQ's case in which
there will be much more concurrent submissions and completions. In case
of single hw queue(current linus tree), one hctx->run_work only allows
one __blk_mq_run_hw_queue() running at 'async' mode, and reply queues are
used in round-robin way, which may cause contention on the single sbitmap
too, especially io accounting may consume a bit much more CPU, I guess that may
contribute some on the CPU lockup.

Could you run your test without V2 patches by setting 'iostats' as 0?
and could you share us what the .can_queue is in this HBA?

> 
> 
> > If possible, please provide us the performance data without these
> patches and
> > with these patches, together with perf trace.
> >
> > The top 5 patches are for addressing the io accounting issue, and which
> > should be the main reason for your performance drop, even lockup in
> > megaraid_sas's ISR, IMO.
> 
> I think performance drop is different issue. May be a side effect of the
> patch set. Even though we fix this perf issue, cpu lock up is completely
> different issue.

The performance drop is caused by the global data structure of sbitmap
which is accessed from all CPUs concurrently.

> Regarding cpu lock up, there was similar discussion and folks are finding
> irq poll is good method to resolve lockup.  Not sure why NVME driver did
> not opted irq_poll, but there was extensive discussion and I am also

NVMe's hw queues won't use host wide tags, so no such issue.

> seeing cpu lock up mainly due to multiple completion queue/reply queue is
> tied to single CPU. We have weighing method in irq poll to quit ISR and
> that is the way we can avoid lock-up.
> http://lists.infradead.org/pipermail/linux-nvme/2017-January/007724.html

This patch can make sure that one request is always completed in the submission
CPU, but contention on the global sbitmap is too big and causes performance drop.

Now looks this is really an interesting topic for discussion.


Thanks,
Ming
