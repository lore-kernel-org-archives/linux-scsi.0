From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Thu, 27 Mar 2003 14:43:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030327144326.A14457@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <3E80BDC3.7000503@splentec.com> <20030326111146.A3548@beaverton.ibm.com> <3E822415.2080306@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E822415.2080306@splentec.com>; from luben@splentec.com on Wed, Mar 26, 2003 at 05:05:09PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 26, 2003 at 05:05:09PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > 
> > But the last single_lun LU that ran should have priority over any other
> > LU's on that same target (well it should really get some slice of IO time,
> > rather than allowing IO til it is no longer busy), and separately, the
> > first starved device should have priority over all other starved devices,
> > I can't do that (simply) with one list. 
> > 
> > single_lun devices are likely slow (CDROM), and we really don't want to
> > give them priority over other starved devices.

> So, using the starved_list as a priority queue will not work?

> Given: consumer of starved_list takes from its front.
> 
> ``the last single_lun LU that run'' has priority over all others,
> *IF* added at the front. (LIFO) (since any latter one of the same
> sort (single lun) will be added at the front)

Yes if using the list_splice code, and if it is added even for cases when
it is able to send IO. This would differ from the current code - given 3
single_lun devices on a target, one can be prevented from sending IO (in
addition to all cases where one single_lun device can prevent IO to
other single_lun devices).

> The *first* starved device DOES HAVE priority over all others,
> *IF* added at the tail. (FIFO)  (since all others of the same
> sort (non-single lun) all *also* be added at the tail)

Then it has priority over other starved devices, but not over single_lun
devices put on the head. So a single_lun device put on the head of the
starved_list could potentially prevent other non-single_lun devices on the
same scsi_host from sending IO.

We could add another list_head for the single_lun, but I don't think it
is worth the extra code, data, and effort.

> > Also the same lock has to be used to protect the scsi_host->starved_list
> > and scsi_device->starved_entry. In the above code the first
> > list_splice_init above touches the shost->starved_devs->next->prev,
> > corresponding to a scsi_device->starved_entry->prev, while holding
> > starved_devs_lock but the following list_del_init is done holding the
> > queue_lock.
> 
> We're working with the local list now!
> 
> So that starved_entry is in the local starved list now,
> and shost->starved_list is EMPTY!
> 
> On the ``following list_del_init'' dev->starved_entry is in
> the local ``starved'' list!

dev->starved_entry is still visible and used in scsi_request_fn, removing
it from the starved list does not prevent scsi_request_fn from being
called and referencing it (if we have two locks and no lock hierarchy in
scsi_request_fn).

I'm not against using the list_splice, it does not clean up the
locking, but it probably fixes James issue (possible loop).

-- Patrick Mansfield
