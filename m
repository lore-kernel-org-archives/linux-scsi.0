From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Wed, 26 Mar 2003 17:05:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E822415.2080306@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <3E80BDC3.7000503@splentec.com> <20030326111146.A3548@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> But the last single_lun LU that ran should have priority over any other
> LU's on that same target (well it should really get some slice of IO time,
> rather than allowing IO til it is no longer busy), and separately, the
> first starved device should have priority over all other starved devices,
> I can't do that (simply) with one list. 
> 
> single_lun devices are likely slow (CDROM), and we really don't want to
> give them priority over other starved devices.

So, using the starved_list as a priority queue will not work?

Given: consumer of starved_list takes from its front.

``the last single_lun LU that run'' has priority over all others,
*IF* added at the front. (LIFO) (since any latter one of the same
sort (single lun) will be added at the front)

The *first* starved device DOES HAVE priority over all others,
*IF* added at the tail. (FIFO)  (since all others of the same
sort (non-single lun) all *also* be added at the tail)

So, so for single_lun, our priority queue (starved_list) behaves
as LIFO, and for non-single_lun, our priority queue (starved_list)
behaves as FIFO.

The bottom line is that you have one, universal logic for single
lun and non-single lun device simply by manipulating where
you insert in the starved list.

The insertion is, of course, done at scsi_request_fn.

(cont'd)

> 
>>static inline void scsi_run_starved_devs(struct Scsi_Host *shost)
>>{
>>	unsigned long flags;
>>	LIST_HEAD(starved);
>>	
>>	spin_lock_irqsave(&shost->starved_devs_lock, flags);
>>	list_splice_init(&shost->starved_devs, &starved);
>>	spin_unlock_irqrestore(&shost->starved_devs_lock, flags);
>>	
>>	while (!list_empty(&starved)) {
>>		struct scsi_device *dev;
>>
>>		if (shost->host_blocked || shost->host_self_blocked ||
>>		    (shost->can_queue > 0 &&
>>		     shost->host_busy >= shost->can_queue))
>>			break;
>>	
>>		dev=list_entry(starved.next,struct scsi_device,starved_entry);
>>		list_del_init(dev->starved_entry);
>>		spin_lock_irqsave(dev->request_queue->queue_lock, flags);
>>		__blk_run_queue(dev->request_queue);
>>		spin_unlock_irqrestore(dev->request_queue->queue_lock, flags);
>>	}
>>	
>>	if (!list_empty(&starved)) {
>>		spin_lock_irqsave(&shost->starved_devs_lock, flags);
>>		list_splice_init(&starved, &shost->starved_devs);
>>		spin_unlock_irqrestore(&shost->starved_devs_lock, flags);
>>	}
>>}
> 
> 
> I did not take the list_splice an approach mainly because I wanted to
> allow multiple CPU's to run the starved queues (host_blocked cases, not
> can_queue). I don't have any data to back this up, and it probably does
> not matter. 
> 
> For the can_queue limit being hit, with continuous IO across multiple LU's
> on a host, there we will (likely) send only one more IO (run one starved
> queue) and stop - the last few lines of the above code would always be
> executed.
> 
> Also the same lock has to be used to protect the scsi_host->starved_list
> and scsi_device->starved_entry. In the above code the first
> list_splice_init above touches the shost->starved_devs->next->prev,
> corresponding to a scsi_device->starved_entry->prev, while holding
> starved_devs_lock but the following list_del_init is done holding the
> queue_lock.

We're working with the local list now!

So that starved_entry is in the local starved list now,
and shost->starved_list is EMPTY!

On the ``following list_del_init'' dev->starved_entry is in
the local ``starved'' list!

-- 
Luben



