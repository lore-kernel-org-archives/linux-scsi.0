From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a deadlock
Date: Thu, 10 Nov 2016 22:13:29 -0600
Message-ID: <87k2calkly.fsf@xmission.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
        <1478618887.2824.2.camel@linux.vnet.ibm.com>
        <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
        <1478628101.2824.27.camel@linux.vnet.ibm.com>
        <87oa1pvl8f.fsf@xmission.com>
        <1478648684.2368.17.camel@linux.vnet.ibm.com>
        <87bmxpqxlb.fsf@xmission.com>
        <1478655815.2368.34.camel@linux.vnet.ibm.com>
        <87pom5o123.fsf@xmission.com>
        <1478828244.3267.49.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:55369 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965482AbcKKEP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 23:15:56 -0500
In-Reply-To: <1478828244.3267.49.camel@linux.vnet.ibm.com> (James Bottomley's
        message of "Thu, 10 Nov 2016 17:37:24 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>

James Bottomley <jejb@linux.vnet.ibm.com> writes:

> On Tue, 2016-11-08 at 20:10 -0600, Eric W. Biederman wrote:
>> James Bottomley <jejb@linux.vnet.ibm.com> writes:
>> 
>> > On Tue, 2016-11-08 at 18:57 -0600, Eric W. Biederman wrote:
> [...]
>> > > I am pretty certain that if you are going to make 
>> > > kernfs_remove_self and kernfs_remove_by_name_ns to be safe to 
>> > > race against each other, not just the KERNFS_SUICIDAL check, but 
>> > > the wait when KERNFS_SUICIDAL is set needs to be added ot
>> > > kernfs_remove_by_name_ns.
>> > 
>> > I don't think you can do that: waiting for SUICIDED would introduce
>> > another potential lock entanglement.  I'm reasonably happy that the
>> > deactivation offset coupled with kernfs_drain in the non self 
>> > remove path means that the necessary cleanup is done when the 
>> > directory itself is removed.  That seems to be a common pattern in 
>> > all non-self removes.
>> 
>> But if we don't I am pretty certain there will be asynchrounous 
>> behavior in some cases that could potentially confuse userspace.
>
> But the original behaviour kernfs_remove_self() eliminated was the
> asynchronous callback.  If we go back to that, we're definitely going
> to introduce far more asynchronous behaviour.

Not from a userspace perspective if we use task_work_add(current,...).

In that case we simply get to do an asynchrnous looking thing before we
return to userspace.  So an asynchronous form, but not actually
asynchronous actions.

>> Which is partly why I would like to kill kernfs_remove_self.
>
> I took a look at it.  It's definitely not cleanly revertible given
> what's gone on since.  Even just trying to excise it is going to be
> hard given all the tentacles it has.

Well changing the users and removing the code from kernfs and sysfs
doesn't look hard.  There are only 5-7 users of this insane and broken
remove self thing.

I think even if we do the naive thing and don't use any helpers in
kernfs, sysfs, or the device subsystem we could easily wind up with less
code in the kernel.  Certainly it will be code that is simpler and
easier to get right.

>> Using task_work_add(current, ...) as I posted earlier let's us retain
>> the synchronous property of the current API.
>> 
>> While we debate the details I am happy to look at scsi as a special 
>> case and solve for scsi.  Then when we have the details worked out we 
>> can go fix the other cases.  Given my preliminary patch in my last 
>> reply it looks very straight forward to fix this sanely.
>
> I don't think there's any urgency to fix SCSI.  You can only really
> trigger this by hammering the device and host remove paths, which isn't
> what users normally do ... as the fact it's been in the field for 2.5
> years with no apparent problems shows.

Sure little urgency.  But scsi makes a good concrete example for which
a reproducer is known.  So it is a good test ground.

> I'd like Greg and Tejun to weigh in on this before we start doing
> something, since they created the initial problem.

Fair.  Although I wouldn't be surprised if we don't hear anything short
of a concrete patch that changes everything.

Eric

