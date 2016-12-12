From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Mon, 12 Dec 2016 08:43:04 -0800
Message-ID: <1481560984.2376.50.camel@linux.vnet.ibm.com>
References: <1481509217-23567-1-git-send-email-fangwei1@huawei.com>
         <1481559825.4643.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752447AbcLLQnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Dec 2016 11:43:13 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBCGccBm084975
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2016 11:43:12 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 279uynhe3y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2016 11:43:12 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Mon, 12 Dec 2016 09:43:11 -0700
In-Reply-To: <1481559825.4643.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Wei Fang <fangwei1@huawei.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, chenzengxi@huawei.com

On Mon, 2016-12-12 at 11:23 -0500, Ewan D. Milne wrote:
> On Mon, 2016-12-12 at 10:20 +0800, Wei Fang wrote:
> > A race between scanning and fc_remote_port_delete() may result in a
> > permanent stop if the device gets blocked before
> > scsi_sysfs_add_sdev()
> > and unblocked after.  The reason is that blocking a device sets
> > both
> > the SDEV_BLOCKED state and the QUEUE_FLAG_STOPPED.  However,
> > scsi_sysfs_add_sdev() unconditionally sets SDEV_RUNNING which
> > causes
> > the device to be ignored by scsi_target_unblock() and thus never
> > have
> > its QUEUE_FLAG_STOPPED cleared leading to a device which is
> > apparently
> > running but has a stopped queue.
> > 
> > We actually have two places where SDEV_RUNNING is set: once in
> > scsi_add_lun() which respects the blocked flag and once in
> > scsi_sysfs_add_sdev() which doesn't.  Since the second set is
> > entirely
> > spurious, simply remove it to fix the problem.
> > 
> > Reported-by: Zengxi Chen <chenzengxi@huawei.com>
> > Signed-off-by: Wei Fang <fangwei1@huawei.com>
> > ---
> > Changes v1->v2:
> > - don't modify scsi_internal_device_unblock(), just remove changing
> >   state to SDEV_RUNNING in scsi_sysfs_add_sdev(), suggested by
> >   James Bottomley and Ewan D. Milne.
> > Changes v2->v3
> > - Use a clearer description of this problem
> > 
> >  drivers/scsi/scsi_sysfs.c  | 4 ----
> >  include/scsi/scsi_device.h | 2 +-
> >  2 files changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 0734927..82dfe07 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1204,10 +1204,6 @@ int scsi_sysfs_add_sdev(struct scsi_device
> > *sdev)
> >  	struct request_queue *rq = sdev->request_queue;
> >  	struct scsi_target *starget = sdev->sdev_target;
> >  
> > -	error = scsi_device_set_state(sdev, SDEV_RUNNING);
> > -	if (error)
> > -		return error;
> > -
> >  	error = scsi_target_add(starget);
> >  	if (error)
> >  		return error;
> > diff --git a/include/scsi/scsi_device.h
> > b/include/scsi/scsi_device.h
> > index 8990e58..8bfb37f 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -31,7 +31,7 @@ struct scsi_mode_data {
> >  enum scsi_device_state {
> >  	SDEV_CREATED = 1,	/* device created but not added
> > to sysfs
> >  				 * Only internal commands allowed
> > (for inq) */
> > -	SDEV_RUNNING,		/* device properly configured
> > +	SDEV_RUNNING,		/* device properly configured
> > and not blocked
> >  				 * All commands allowed */
> >  	SDEV_CANCEL,		/* beginning to delete device
> >  				 * Only error handler commands
> > allowed */
> 
> Well, James said not to bother with the comment, but OK.

The comment change still adds no value: the states are exclusive so
every state that's not SDEV_BLOCKED or SDEV_CREATED_BLOCKED means that
state and not blocked; that makes the proposed addition a tautology.

The reason I don't want the change to the comment is because there's
nothing to fix in the comments, so that hunk shouldn't be part of a
backport to stable.  The way we work in linux is to backport whole
upstream commits, because it makes the stable process so much easier. 
 If you really want to change the comment, it should be a separate
patch ... but it better add value otherwise it won't get applied.

> I take it this has passed your testing.

Yes, I'd like this confirmation, too, please.

James


>   I have not heard back yet from the site that reported this problem 
> to me on their reproducer. The change looks good to me.
> 
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

