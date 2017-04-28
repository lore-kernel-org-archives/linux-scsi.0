From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Fri, 28 Apr 2017 11:45:57 -0700
Message-ID: <1493405157.15639.31.camel@HansenPartnership.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1493232838.2632.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34744 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1425242AbdD1SqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 14:46:00 -0400
In-Reply-To: <1493232838.2632.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Wed, 2017-04-26 at 18:53 +0000, Bart Van Assche wrote:
> On Tue, 2017-04-18 at 08:56 -0700, James Bottomley wrote:
> > The priority has got to be the removal we've been ordered to do
> > rather
> > than waiting around to see if the transport comes back so we can
> > send a
> > final flush.
> > 
> > How about this approach.  It goes straight to DEL if the device is
> > blocked (skipping CANCEL).  This means that all the commands issued
> > in 
> > ->shutdown will error in the mid-layer, thus making the removal
> > proceed
> > without being stopped.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index e5a2d590a104..31171204cfd1 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2611,7 +2611,6 @@ scsi_device_set_state(struct scsi_device
> > *sdev, enum scsi_device_state state)
> >  		case SDEV_QUIESCE:
> >  		case SDEV_OFFLINE:
> >  		case SDEV_TRANSPORT_OFFLINE:
> > -		case SDEV_BLOCK:
> >  			break;
> >  		default:
> >  			goto illegal;
> > @@ -2625,6 +2624,7 @@ scsi_device_set_state(struct scsi_device
> > *sdev, enum scsi_device_state state)
> >  		case SDEV_OFFLINE:
> >  		case SDEV_TRANSPORT_OFFLINE:
> >  		case SDEV_CANCEL:
> > +		case SDEV_BLOCK:
> >  		case SDEV_CREATED_BLOCK:
> >  			break;
> >  		default:
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 82dfe07b1d47..788309e307e9 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1282,8 +1282,14 @@ void __scsi_remove_device(struct scsi_device
> > *sdev)
> >  		return;
> >  
> >  	if (sdev->is_visible) {
> > +		/*
> > +		 * If blocked, we go straight to DEL so any
> > commands
> > +		 * issued during the driver shutdown (like sync
> > cache)
> > +		 * are errored
> > +		 */
> >  		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> > -			return;
> > +			if (scsi_device_set_state(sdev, SDEV_DEL)
> > != 0)
> > +				return;
> >  
> >  		bsg_unregister_queue(sdev->request_queue);
> >  		device_unregister(&sdev->sdev_dev);
> > 
> > 
> 
> Hello James,
> 
> How about modifying the above patch by adding a mutex to avoid that 
> the transition to SDEV_DEL and blocking the request queue happen in 
> the wrong order, e.g. as in the attached three patches?

If you've hammered it with your usual testing and it survived, I think
that's enough to prove its a concurrency problem we have to solve, so
the critical section introduction looks good.  The only refinement I
think I'd ask for is rather than creating an entirely new mutex, what
about using the host->scan_mutex?  It simplifies your code in
__scsi_remove_device because the scan mutex is already held on entry.

I'm also not very happy with a conditional mutex: that's usually
something we try to avoid.   I'd prefer an underscore version of
scsi_internal_device_block that doesn't take the mutex and which
mpt3sas uses (and make the non underscore version take the mutex and
call the underscore version).

Thanks,

James
