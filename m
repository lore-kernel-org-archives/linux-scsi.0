From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Thu, 14 Dec 2017 17:10:36 -0500
Message-ID: <1513289436.10760.79.camel@localhost.localdomain>
References: <1513171297-58020-1-git-send-email-hare@suse.de>
         <1513203795.2413.14.camel@wdc.com> <5A3230D3.2060302@huawei.com>
         <f43e0560-7a46-6d72-41f9-0d90fa20948c@suse.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753930AbdLNWKi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 17:10:38 -0500
In-Reply-To: <f43e0560-7a46-6d72-41f9-0d90fa20948c@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Jason Yan <yanaijie@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2017-12-14 at 10:02 +0100, Hannes Reinecke wrote:
> On 12/14/2017 09:05 AM, Jason Yan wrote:
> > 
> > On 2017/12/14 6:23, Bart Van Assche wrote:
> >> On Wed, 2017-12-13 at 14:21 +0100, Hannes Reinecke wrote:
> >>> As it turned out device_get() doesn't use kref_get_unless_zero(),
> >>> so we will be always getting a device pointer.
> >>> So we need to check for the device state in __scsi_remove_target()
> >>> to avoid tripping over deleted objects.
> >>>
> >>> Fixes: fbce4d9 ("scsi: fixup kernel warning during rmmod()")
> >>
> >> How about adding Reported-by: Jason Yan? See also
> >> https://www.spinics.net/lists/linux-scsi/msg115295.html
> >>
> >> Anyway:
> >>
> >> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> >>
> > 
> > Seems the same as my patch.So how do we plan to fix this issue,
> > pick this approach up or the approach James Bottomley suggested?
> > I have sent a patch to change get_device() but Greg seems do not
> > like this way.
> > 
> This is actually a real regression, which can be trivially exercised by
> eg logging out from two connections to an iSCSI target.
> (Our QA tripped across that one).
> So I'd rather have to have it fixed reasonably soon.
> 
> While 'get_device' is IMO the 'correct' solution it surely warrants a
> broader discussion, plus one would need to audit all callers to check
> the return value. If we were going down that route we should probably
> add a __must_check to get_device(), too.
> But again, this will probably drag out for quite some time, and I'd
> prefer to have the fix in the meantime.
> 
> Cheers,
> 
> Hannes

We have 2 reproducible test cases, this patch fixes one of them,
which was a continually oscillating FC target port w/short dev_loss_tmo.
I'm still waiting for a report on the iSCSI test.  The code looks good.
We need to get some kind of fix for this sooner rather than later.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
