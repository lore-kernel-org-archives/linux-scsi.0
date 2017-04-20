From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Thu, 20 Apr 2017 15:13:17 -0700
Message-ID: <1492726397.21601.16.camel@HansenPartnership.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
         <1492725550.2642.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50890 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S947912AbdDTWNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 18:13:20 -0400
In-Reply-To: <1492725550.2642.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, 2017-04-20 at 21:59 +0000, Bart Van Assche wrote:
> On Tue, 2017-04-18 at 16:56 -0700, James Bottomley wrote:
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
> > index 82dfe07b1d47..e477f95bf169 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1282,8 +1282,17 @@ void __scsi_remove_device(struct scsi_device
> > *sdev)
> >  		return;
> >  
> >  	if (sdev->is_visible) {
> > -		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> > -			return;
> > +		/*
> > +		 * If blocked, we go straight to DEL so any
> > commands
> > +		 * issued during the driver shutdown (like sync
> > cache)
> > +		 * are errored
> > +		 */
> > +		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> > {
> > +			if (scsi_device_set_state(sdev, SDEV_DEL)
> > != 0)
> > +				return;
> > +			else
> > +				scsi_start_queue(sdev);
> > +		}
> >  
> >  		bsg_unregister_queue(sdev->request_queue);
> >  		device_unregister(&sdev->sdev_dev);
> 
> Hello James,
> 
> This approach cannot work. A scsi_target_block() call by the 
> transport layer can happen concurrently with the 
> __scsi_remove_device() call and hence can occur at any time between 
> the scsi_start_queue() call by __scsi_remove_device() and the 
> sd_shutdown() call, resulting in a deadlock.

How is that possible?  Once the device goes into the CANCEL state, it
no longer can be found by starget_for_each_device() because
scsi_device_get() returns NULL ... unless you also have a patch
altering that?

James


> I have been able to trigger this with my tests by simulating a cable 
> pull shortly before running "rmmod ib_srp".
> 
> That deadlock did not occur with the patch series that makes 
> synchronize cache upon shutdown asynchronous. I'm going to resubmit 
> that patch series.
> 
> Bart.
