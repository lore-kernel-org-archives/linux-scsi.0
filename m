From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Tue, 08 Nov 2016 17:43:35 -0800
Message-ID: <1478655815.2368.34.camel@linux.vnet.ibm.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
         <1478618887.2824.2.camel@linux.vnet.ibm.com>
         <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
         <1478628101.2824.27.camel@linux.vnet.ibm.com> <87oa1pvl8f.fsf@xmission.com>
         <1478648684.2368.17.camel@linux.vnet.ibm.com> <87bmxpqxlb.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57639 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751032AbcKIBnn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 20:43:43 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA91cig9022206
        for <linux-scsi@vger.kernel.org>; Tue, 8 Nov 2016 20:43:42 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26kr456s8a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 20:43:42 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 8 Nov 2016 18:43:41 -0700
In-Reply-To: <87bmxpqxlb.fsf@xmission.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2016-11-08 at 18:57 -0600, Eric W. Biederman wrote:
> James Bottomley <jejb@linux.vnet.ibm.com> writes:
> 
> > On Tue, 2016-11-08 at 13:13 -0600, Eric W. Biederman wrote:
[...]
> > > Is it really the dropping of the lock that is causing this?
> > > I don't see that when I read those traces.
> > 
> > No, it's an ABBA lock inversion that causes this.  The traces are
> > somewhat dense, but they say it here:
> > 
> >  Possible unsafe locking scenario:
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(s_active#336);
> >                                lock(&shost->scan_mutex);
> >                                lock(s_active#336);
> >   lock(&shost->scan_mutex);
> > 
> >  *** DEADLOCK ***
> > 
> > The detailed explanation of this is here:
> > 
> > http://marc.info/?l=linux-scsi&m=147855187425596
> > 
> > The fix is ensuring that the CPU1 thread doesn't get into taking
> > s_active if CPU0 already has it using the KERNFS_SUICIDED/AL flag 
> > as an indicator.
> 
> So.  The kernfs code does not look safe to have kernfs_remove_self
> and kernfs_remove_by_name_ns racing against each other I agree.
> 
> The kernfs_remove_self path turns KERNFS_SUICIDAL into another 
> blocking lock by another name, and without lockdep annotations so I 
> don't know that it is safe.

Yes ... the number of hand rolled locks in that code make it super hard
to follow.

> The relevant bit from kernfs_remove_self is:
> 
> 	if (!(kn->flags & KERNFS_SUICIDAL)) {
> 		kn->flags |= KERNFS_SUICIDAL;
> 		__kernfs_remove(kn);
> 		kn->flags |= KERNFS_SUICIDED;
> 		ret = true;
> 	} else {
> 		wait_queue_head_t *waitq = &kernfs_root(kn)
> ->deactivate_waitq;
> 		DEFINE_WAIT(wait);
> 
> 		while (true) {
> 			prepare_to_wait(waitq, &wait,
> TASK_UNINTERRUPTIBLE);
> 
> 			if ((kn->flags & KERNFS_SUICIDED) &&
> 			    atomic_read(&kn->active) ==
> KN_DEACTIVATED_BIAS)
> 				break;
> 
> 			mutex_unlock(&kernfs_mutex);
> 			schedule();
> 			mutex_lock(&kernfs_mutex);
> 		}
> 		finish_wait(waitq, &wait);
> 		WARN_ON_ONCE(!RB_EMPTY_NODE(&kn->rb));
> 		ret = false;
> 	}
> 
> I am pretty certain that if you are going to make kernfs_remove_self 
> and kernfs_remove_by_name_ns to be safe to race against each other, 
> not just the KERNFS_SUICIDAL check, but the wait when KERNFS_SUICIDAL 
> is set needs to be added ot kernfs_remove_by_name_ns.

I don't think you can do that: waiting for SUICIDED would introduce
another potential lock entanglement.  I'm reasonably happy that the
deactivation offset coupled with kernfs_drain in the non self remove
path means that the necessary cleanup is done when the directory itself
is removed.  That seems to be a common pattern in all non-self removes.

> And I suspect if you add the appropriate lockdep annotations to that 
> mess you will find yourself in a similar but related ABBA deadlock.

I can't prove the negative, but as long as there's no waiting on the
SUICIDED/AL flags in the non-self remove path, I believe we're safe
with the current patch.

> Which is why I would like a simpler easier to understand mechanism if
> we can.

I don't disagree: If you want to clean out the Augean Stables, I can
lend you the thigh length rubber boots and the gas mask.  However, I
think that what we're currently proposing: a simple patch to make
device_remove_file_self() actually work for everyone, along with
stringent testing is the better approach.

After all, if you look at

commit ac0ece9174aca9aa895ce0accc54f1f8ff12d117
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Feb 3 14:03:03 2014 -0500

    scsi: use device_remove_file_self() instead of device_schedule_callback()

You'll see Tejun added all this stuff just to remove the async callback
we originally had.  Simply restoring the async callback back makes us
quite considerably worse off because the device_remove_file_self()
mechanism is in use elsewhere.  We need either to fix it and move on or
junk it and go back to the original.

James

