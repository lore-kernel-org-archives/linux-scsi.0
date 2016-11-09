From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a deadlock
Date: Tue, 08 Nov 2016 18:57:20 -0600
Message-ID: <87bmxpqxlb.fsf@xmission.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
        <1478618887.2824.2.camel@linux.vnet.ibm.com>
        <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
        <1478628101.2824.27.camel@linux.vnet.ibm.com>
        <87oa1pvl8f.fsf@xmission.com>
        <1478648684.2368.17.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:43599 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbcKIA7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 19:59:50 -0500
In-Reply-To: <1478648684.2368.17.camel@linux.vnet.ibm.com> (James Bottomley's
        message of "Tue, 08 Nov 2016 15:44:44 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley <jejb@linux.vnet.ibm.com> writes:

> On Tue, 2016-11-08 at 13:13 -0600, Eric W. Biederman wrote:
>> James Bottomley <jejb@linux.vnet.ibm.com> writes:
>> 
>> > On Tue, 2016-11-08 at 08:52 -0800, Bart Van Assche wrote:
>> > > On 11/08/2016 07:28 AM, James Bottomley wrote:
>> > > > On Mon, 2016-11-07 at 16:32 -0800, Bart Van Assche wrote:
>> > > > > diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
>> > > > > index cf4c636..44ec536 100644
>> > > > > --- a/fs/kernfs/dir.c
>> > > > > +++ b/fs/kernfs/dir.c
>> > > > > @@ -1410,7 +1410,7 @@ int kernfs_remove_by_name_ns(struct
>> > > > > kernfs_node
>> > > > > *parent, const char *name,
>> > > > >  	mutex_lock(&kernfs_mutex);
>> > > > > 
>> > > > >  	kn = kernfs_find_ns(parent, name, ns);
>> > > > > -	if (kn)
>> > > > > +	if (kn && !(kn->flags & KERNFS_SUICIDED))
>> > > > 
>> > > > Actually, wrong flag, you need KERNFS_SUICIDAL.  The reason is
>> > > > that
>> > > > kernfs_mutex is actually dropped half way through
>> > > > __kernfs_remove, 
>> > > > so KERNFS_SUICIDED is not set atomically with this mutex.
>> > > 
>> > > Hello James,
>> > > 
>> > > Sorry but what you wrote is not correct.
>> > 
>> > I think you agree it is dropped.  I don't need to add the bit about 
>> > the reacquisition because the race is mediated by the first 
>> > acquisition not the second one, if you mediate on KERNFS_SUICIDAL, 
>> > you only need to worry about this because the mediation is in the 
>> > first acquisition.   If you mediate on KERNFS_SUICIDED, you need to 
>> > explain that the final thing that means the race can't happen is 
>> > the unbreak in the sysfs delete path re-acquiring s_active ... the 
>> > explanation of what's going on and why gets about 2x more complex.
>> 
>> Is it really the dropping of the lock that is causing this?
>> I don't see that when I read those traces.
>
> No, it's an ABBA lock inversion that causes this.  The traces are
> somewhat dense, but they say it here:
>
>  Possible unsafe locking scenario:
>        CPU0                    CPU1
>        ----                    ----
>   lock(s_active#336);
>                                lock(&shost->scan_mutex);
>                                lock(s_active#336);
>   lock(&shost->scan_mutex);
>
>  *** DEADLOCK ***
>
> The detailed explanation of this is here:
>
> http://marc.info/?l=linux-scsi&m=147855187425596
>
> The fix is ensuring that the CPU1 thread doesn't get into taking
> s_active if CPU0 already has it using the KERNFS_SUICIDED/AL flag as an
> indicator.

So.  The kernfs code does not look safe to have kernfs_remove_self
and kernfs_remove_by_name_ns racing against each other I agree.

The kernfs_remove_self path turns KERNFS_SUICIDAL into another blocking
lock by another name, and without lockdep annotations so I don't know
that it is safe.

The relevant bit from kernfs_remove_self is:

	if (!(kn->flags & KERNFS_SUICIDAL)) {
		kn->flags |= KERNFS_SUICIDAL;
		__kernfs_remove(kn);
		kn->flags |= KERNFS_SUICIDED;
		ret = true;
	} else {
		wait_queue_head_t *waitq = &kernfs_root(kn)->deactivate_waitq;
		DEFINE_WAIT(wait);

		while (true) {
			prepare_to_wait(waitq, &wait, TASK_UNINTERRUPTIBLE);

			if ((kn->flags & KERNFS_SUICIDED) &&
			    atomic_read(&kn->active) == KN_DEACTIVATED_BIAS)
				break;

			mutex_unlock(&kernfs_mutex);
			schedule();
			mutex_lock(&kernfs_mutex);
		}
		finish_wait(waitq, &wait);
		WARN_ON_ONCE(!RB_EMPTY_NODE(&kn->rb));
		ret = false;
	}

I am pretty certain that if you are going to make kernfs_remove_self and
kernfs_remove_by_name_ns to be safe to race against each other, not just
the KERNFS_SUICIDAL check, but the wait when KERNFS_SUICIDAL is set
needs to be added ot kernfs_remove_by_name_ns.

And I suspect if you add the appropriate lockdep annotations to that mess
you will find yourself in a similar but related ABBA deadlock.

Which is why I would like a simpler easier to understand mechanism if we can.

Eric

