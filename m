From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Fri, 28 Mar 2003 10:09:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8465A2.7020501@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <3E80BDC3.7000503@splentec.com> <20030326111146.A3548@beaverton.ibm.com> <3E822415.2080306@splentec.com> <20030327144326.A14457@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030327144326.A14457@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Wed, Mar 26, 2003 at 05:05:09PM -0500, Luben Tuikov wrote:
> 
>>Patrick Mansfield wrote:
>>

[This is your premise:]
>>>But the last single_lun LU that ran should have priority over any other
>>>LU's on that same target (well it should really get some slice of IO time,
>>>rather than allowing IO til it is no longer busy), and separately, the
>>>first starved device should have priority over all other starved devices,
>>>I can't do that (simply) with one list. 
>>Given: consumer of starved_list takes from its front.

Here I'm quoting the sinlge lun part of your premise above:

>>``the last single_lun LU that run'' has priority over all others,
>>*IF* added at the front. (LIFO) (since any latter one of the same
>>sort (single lun) will be added at the front)
> 
> 
> Yes if using the list_splice code, and if it is added even for cases when
> it is able to send IO. This would differ from the current code - given 3
> single_lun devices on a target, one can be prevented from sending IO (in
> addition to all cases where one single_lun device can prevent IO to
> other single_lun devices).
> 

Here I'm quoting the second part of your premise above:
 
>>The *first* starved device DOES HAVE priority over all others,
>>*IF* added at the tail. (FIFO)  (since all others of the same
>>sort (non-single lun) all *also* be added at the tail)
> 
> 
> Then it has priority over other starved devices, but not over single_lun
> devices put on the head. So a single_lun device put on the head of the
> starved_list could potentially prevent other non-single_lun devices on the
> same scsi_host from sending IO.

You see, all I'm doing is trying to come up with a suitable ADT
and algorithm for the premise which _you_ gave.

The problem is that you have no fixed arbitration criterium between single
lun and fully capable targets.  If you did, it's a little thing to get
the sinlge list as priority queue working.

I.e. What I'm asking is this: _even_ if you had 2 lists, one
for sinlge lun and another for fully capable targets,
how would you arbitrate between the two in scsi_request_fn().

Because if you tell me how, a sinlge list travesal of a single
starved devices as priority queue as I described will work.

What I'm trying to say it that, there exists an ordering, i.e.
insertion mechanism, for the problem at hand.

I.e. you know that the last finished single target is at the front,
the last finished fully capable target is at the tail, and
you can arbitrate any which way you want just from a single
list traversal:
	- last finished lu on a single lu target (front)
	- last finished lu on a fully cap. target (tail)
	- first finished lu on a single lu target (last single lun F->T)
	- first finished lu on a single lu target (last f. cap. lun T->F)
	- any other starved lu (single lu or fully cap.; arb.)
 
> We could add another list_head for the single_lun, but I don't think it
> is worth the extra code, data, and effort.

Right.  It is *not* worth it, mainly because I think that the task
can be accomplished with a single list.
 
>>>Also the same lock has to be used to protect the scsi_host->starved_list
>>>and scsi_device->starved_entry. In the above code the first
>>>list_splice_init above touches the shost->starved_devs->next->prev,
>>>corresponding to a scsi_device->starved_entry->prev, while holding
>>>starved_devs_lock but the following list_del_init is done holding the
>>>queue_lock.
>>
>>We're working with the local list now!
>>
>>So that starved_entry is in the local starved list now,
>>and shost->starved_list is EMPTY!
>>
>>On the ``following list_del_init'' dev->starved_entry is in
>>the local ``starved'' list!
> 
> 
> dev->starved_entry is still visible and used in scsi_request_fn, removing
> it from the starved list does not prevent scsi_request_fn from being
> called and referencing it (if we have two locks and no lock hierarchy in
> scsi_request_fn).

Well, this is just unfortunate.  This ``design feature'' is not very
good.  It is *still* my conviction that a scsi_cmnd has to have
only *one* list entry and belong to only *one* list at a time.
That list representing its state. I think I'm repreating myself.

> I'm not against using the list_splice, it does not clean up the
> locking, but it probably fixes James issue (possible loop).

-- 
Luben



