From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Thu, 10 Nov 2016 17:37:24 -0800
Message-ID: <1478828244.3267.49.camel@linux.vnet.ibm.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
         <1478618887.2824.2.camel@linux.vnet.ibm.com>
         <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
         <1478628101.2824.27.camel@linux.vnet.ibm.com> <87oa1pvl8f.fsf@xmission.com>
         <1478648684.2368.17.camel@linux.vnet.ibm.com> <87bmxpqxlb.fsf@xmission.com>
         <1478655815.2368.34.camel@linux.vnet.ibm.com> <87pom5o123.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965276AbcKKBhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 20:37:33 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAB1YEBF088582
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 20:37:32 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26n08tw232-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 20:37:32 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 10 Nov 2016 18:37:30 -0700
In-Reply-To: <87pom5o123.fsf@xmission.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>

On Tue, 2016-11-08 at 20:10 -0600, Eric W. Biederman wrote:
> James Bottomley <jejb@linux.vnet.ibm.com> writes:
> 
> > On Tue, 2016-11-08 at 18:57 -0600, Eric W. Biederman wrote:
[...]
> > > I am pretty certain that if you are going to make 
> > > kernfs_remove_self and kernfs_remove_by_name_ns to be safe to 
> > > race against each other, not just the KERNFS_SUICIDAL check, but 
> > > the wait when KERNFS_SUICIDAL is set needs to be added ot
> > > kernfs_remove_by_name_ns.
> > 
> > I don't think you can do that: waiting for SUICIDED would introduce
> > another potential lock entanglement.  I'm reasonably happy that the
> > deactivation offset coupled with kernfs_drain in the non self 
> > remove path means that the necessary cleanup is done when the 
> > directory itself is removed.  That seems to be a common pattern in 
> > all non-self removes.
> 
> But if we don't I am pretty certain there will be asynchrounous 
> behavior in some cases that could potentially confuse userspace.

But the original behaviour kernfs_remove_self() eliminated was the
asynchronous callback.  If we go back to that, we're definitely going
to introduce far more asynchronous behaviour.

> Which is partly why I would like to kill kernfs_remove_self.

I took a look at it.  It's definitely not cleanly revertible given
what's gone on since.  Even just trying to excise it is going to be
hard given all the tentacles it has.

> > > And I suspect if you add the appropriate lockdep annotations to 
> > > that mess you will find yourself in a similar but related ABBA
> > > deadlock.
> > 
> > I can't prove the negative, but as long as there's no waiting on 
> > the SUICIDED/AL flags in the non-self remove path, I believe we're 
> > safe with the current patch.
> > 
> > > Which is why I would like a simpler easier to understand 
> > > mechanism if we can.
> > 
> > I don't disagree: If you want to clean out the Augean Stables, I 
> > can lend you the thigh length rubber boots and the gas mask. 
> >  However, I think that what we're currently proposing: a simple 
> > patch to make device_remove_file_self() actually work for everyone, 
> > along with stringent testing is the better approach.
> > 
> > After all, if you look at
> > 
> > commit ac0ece9174aca9aa895ce0accc54f1f8ff12d117
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Mon Feb 3 14:03:03 2014 -0500
> > 
> >     scsi: use device_remove_file_self() instead of
> > device_schedule_callback()
> > 
> > You'll see Tejun added all this stuff just to remove the async 
> > callback we originally had.  Simply restoring the async callback 
> > back makes us quite considerably worse off because the 
> > device_remove_file_self() mechanism is in use elsewhere.  We need 
> > either to fix it and move on or junk it and go back to the
> > original.
> 
> I vote we junk it and go back to something that resembles the 
> original.  there are only about 5 other callers so this isn't that
> bad to do.
> 
> Tejun's work clearly added this deadlock 2 and a half years ago, and
> it was nasty enough no one noticed until recently.
> 
> Using task_work_add(current, ...) as I posted earlier let's us retain
> the synchronous property of the current API.
> 
> While we debate the details I am happy to look at scsi as a special 
> case and solve for scsi.  Then when we have the details worked out we 
> can go fix the other cases.  Given my preliminary patch in my last 
> reply it looks very straight forward to fix this sanely.

I don't think there's any urgency to fix SCSI.  You can only really
trigger this by hammering the device and host remove paths, which isn't
what users normally do ... as the fact it's been in the field for 2.5
years with no apparent problems shows.

I'd like Greg and Tejun to weigh in on this before we start doing
something, since they created the initial problem.

James

