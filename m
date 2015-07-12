From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH 6/6] Fix unsafe fw_event_list usage
Date: Sat, 11 Jul 2015 21:20:01 -0700
Message-ID: <20150712042001.GA315519@mail.thefacebook.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-7-git-send-email-calvinowens@fb.com>
 <20150703160251.GB11815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150703160251.GB11815@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On Friday 07/03 at 09:02 -0700, Christoph Hellwig wrote:
> On Mon, Jun 08, 2015 at 08:50:56PM -0700, Calvin Owens wrote:
> > Since the fw_event deletes itself from the list, cleanup_queue() can
> > walk onto garbage pointers or walk off into freed memory.
> > 
> > This refactors the code in _scsih_fw_event_cleanup_queue() to not
> > iterate over the fw_event_list without a lock. 
> 
> I think this really should be folded into the previous one, with the
> fixes in this one the other refcounting change don't make a whole lot
> sense.
> 
> > +static struct fw_event_work *dequeue_next_fw_event(struct MPT2SAS_ADAPTER *ioc)
> > +{
> > +	unsigned long flags;
> > +	struct fw_event_work *fw_event = NULL;
> > +
> > +	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> > +	if (!list_empty(&ioc->fw_event_list)) {
> > +		fw_event = list_first_entry(&ioc->fw_event_list,
> > +				struct fw_event_work, list);
> > +		list_del_init(&fw_event->list);
> > +		fw_event_work_get(fw_event);
> > +	}
> > +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> > +
> > +	return fw_event;
> 
> Shouldn't we have a reference for each item on the list that gets
> transfer to whomever removes it from the list?

Yes, this was a bit weird the way I did it. I redid this in v2, hopefully
it's clearer.

> Additionally _firmware_event_work should call dequeue_next_fw_event
> first in the function so that item is off the list before we process
> it, and can then just drop the reference once it's done.

That works: cleanup_queue() won't wait on some already-running events, but
destroy_workqueue() drains the wq, so we won't run ahead and free things
from under the fw_event when unwinding.
