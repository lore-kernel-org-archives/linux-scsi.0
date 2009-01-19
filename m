From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Mon, 19 Jan 2009 15:57:00 +0900
Message-ID: <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
References: <49625A67.3000304@cybernetics.com>
	<20090111022525I.fujita.tomonori@lab.ntt.co.jp>
	<496E4B93.4000507@cybernetics.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47482 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZASG5c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 01:57:32 -0500
In-Reply-To: <496E4B93.4000507@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, greg@kroah.com

Sorry for the delay,

On Wed, 14 Jan 2009 15:31:15 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> [CC: Greg Kroah-Hartman <greg@kroah.com>]
> 
> Fujita, your patch results in simpler code than my version 2 patch,
> but it still leaves some subtle races and other problems.  The crux
> of the problem is that kref_put() needs do be done while holding a
> lock if there is still a way for some other CPU to find a reference
> to the object in between the time the refcount drops to 0 and the
> time the destructor is called.
> 
> For example, look at sg_get_dev() and sg_put_dev().  In my patch,
> I locked sg_index_lock in sg_put_dev() and called kref_put() while
> holding the lock.  In your patch, you moved the lock from sg_put_dev()
> to the destructor function.  This introduces a subtle race with
> sg_get_dev():
> 
> CPU 1:
> sg_put_dev()
>   kref_put(): refcount 1 -> 0
> 
> CPU 2:
> sg_get_dev()
>   lock sg_index_lock
>   idr_find()
>   kref_get(): refcount 0 -> 1: bug
>   unlock sg_index_lock
> 
> CPU 1:
> sg_device_release()
>   lock sg_index_lock
>   idr_remove
>   unlock sg_index_lock
>   kfree(sdp)
> 
> CPU 2:
> access sdp which has already been freed
> sg_put_dev(): double-free bug
> 
> Besides holding the lock during kref_put(), I also considered two
> other simple ways to avoid this race:
> 1) Do idr_remove() from sg_remove().
> 2) Return NULL in sg_get_dev() if sdp->detached.
> 
> However, both of these options would have changed the behavior of
> the /proc/scsi/sg/* functions that show information for devices that
> are in the process of being detached.  I wanted to fix bugs without
> changing other behavior, so I chose to call kref_put() under lock in
> my previous patches.

How about doing 2) and accessing to /proc/scsi/sg/* with
sg_index_lock (don't use sg_get_device for it).

What /proc/scsi/sg/* doing is abnormal from the perspective of the ref
counting (accessing to something that is going away).

>From the perspective of the ref counting, the best way is calling
idr_remove in from sg_remove but as you said, it's not nice to change
the behavior.

If we don't use sg_get_device for /proc/scsi/sg/*, then we use
sg_get_device for only sg_open So we can do 2) without changing the
behavior.


> A similar problem exists with sg_remove_sfp() in your patch.
> The refcount for the sg_fd can drop to 0 while a different CPU can
> still find a reference to it by scanning sg_device::headfp.  The good
> news is that most places that scan sg_fd's using sdp->headfp never
> drop sg_index_lock while still holding a reference, so for most cases
> it is safe for the destructor to work the way you have it.  The one
> exception is sg_get_nth_sfp(), which needs to kref_get() the sg_fd it
> returns (my version 2 patch doesn't fix this problem either since I
> just noticed it).  But then the kref_get() would have a race similar
> to the one I described above between sg_get_dev() and sg_put_dev().

If we go with the above way, we can solve this? sg_get_nth_sfp is used
for only /proc/scsi/sg/*.


> There are several solutions to this problem:
> 1) Call kref_put(&sfp->f_ref, sg_remove_sfp) while holding
> sg_index_lock, and have the destructor unlink sfp from sdp->headfp
> before dropping the lock.  This is ugly since the destructor may want
> to drop sg_index_lock (e.g. to call scsi_device_put()), but the saved
> irqflags variable is in a different function.
> 2) Unlink sfp from sdp->headfp in sg_release().  The downside to this
> is that the /proc/scsi/sg/* functions no longer show fds that have
> been closed but still have commands pending.
> 3) Set sfp->closed in sg_release() and have sg_get_nth_sfp() return
> NULL if sfp->closed.  Same downside as #2.
> 4) Add a variation of kref_get() that uses atomic_inc_not_zero().
> 
> When I was designing my previous patches, I anticipated running into
> these complications with kref, which is one reason I avoided it.
> Other people have experienced similar problems with the kref interface
> (search "kref_get_not_zero" or "cgroups: fix probable race with
> put_css_set[_taskexit] and find_css_set").  If you still want to use
> kref, I think that we are either going to have to change the behavior
> of /proc/scsi/sg/*, or else use atomic_inc_not_zero().  Since I still
> prefer not to change valid user-visible behavior in a patch that fixes
> so many possible oopses, I will go with atomic_inc_not_zero().  And,
> since I am going that route, I will use it for sg_get_dev() also,
> so that sg_put_dev() doesn't need to acquire sg_index_lock.
> 
> For the purposes of this patch, I added the local function
> sg_kref_get_not_zero() to sg.c.  It would be better to add
> kref_get_not_zero() to kref.c, but I see in the mailing list archives
> that there has been some resistance to that idea because it complicates
> the kref interface.  However, since it has come up more than once,
> perhaps it would be better to go ahead and make it an official part
> of the interface.  If anyone wants to support that idea, I will break
> it out into a separate patch.

I've not read the whole discussion, but using the common mechanism in
your original way is not good. It confuses other developers and other
developers don't like it.


> Your patch also has a problem with management of f_ref.  You do
> kref_get() in sg_add_request() and kref_put() in sg_rq_end_io()().
> However, an error can occur in between sg_add_request() and sending
> the command to the midlevel, so sg_rq_end_io() may never be called.
> It is better to do kref_get() just before sending the command to the
> midlevel; that way the refcount counts active commands waiting for
> the completion callback rather than prepared requests.

Oops, yeah, you are right.


> Your patch doesn't fix the problem of various functions calling
> SCSI_LOG_TIMEOUT with sdp->disk->disk_name after sg_remove() sets
> sdp->disk to NULL.  This is why I moved put_disk() from sg_remove()
> to sg_device_release().

As I wrote in the previous mail, I don't try to fix all the race in
this patch. But yeah, we need to clean up sdp->disk in
sg_device_release().


> Your patch doesn't fix the problem of forgetting to do
> wake_up_interruptible(&sdp->o_excl_wait) after removing sfp from
> sdp->headfp.  This is important if sg_release() is called with
> commands still active; the last command that finishes should wake up
> any O_EXCL waiters.

I think we can fix this even with my patch.


Thanks,
