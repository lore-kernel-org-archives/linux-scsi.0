From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH 5/5] block: genhd: add an interface to set disk's poll
 interval
Date: Wed, 25 Jul 2012 10:47:38 +0800
Message-ID: <20120725024737.GA2395@aarontestpc.amd.com>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
 <1343026180-22236-6-git-send-email-aaron.lu@amd.com>
 <1343069014.25735.28.camel@ejdallLaptop>
 <20120723235211.GB1965@localhost.localdomain>
 <1343156106.25735.59.camel@ejdallLaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27257
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab2GYCrv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2012 22:47:51 -0400
Content-Disposition: inline
In-Reply-To: <1343156106.25735.59.camel@ejdallLaptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Betty Dall <betty.dall@hp.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

Hi Betty,

On Tue, Jul 24, 2012 at 12:55:06PM -0600, Betty Dall wrote:
> > > > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > > > index 2f159aa..78c4226 100644
> > > > --- a/drivers/scsi/sr.c
> > > > +++ b/drivers/scsi/sr.c
> > > > @@ -869,6 +869,7 @@ static int sr_probe(struct device *dev)
> > > >  	dev_set_drvdata(dev, cd);
> > > >  	disk->flags |= GENHD_FL_REMOVABLE;
> > > >  	add_disk(disk);
> > > > +	disk_events_set_poll_msecs(disk, 2000);
> > > 
> > > Could you check that disk event's poll_msecs is the default (-1) before
> > > setting it to 2s? I am thinking of a case when the probe happens after
> > > the call to disk_events_poll_msecs_store() and this code would overwrite
> > > the user specified value.
> > 
> > The block device sr0 is created by this driver in this probe function,
> > so the user should not be able to set the poll interval before probe,
> > right?
> 
> The add_disk() call happens immediately before the new
> disk_events_set_poll_msecs() call. add_disk() is what eventually creates
> the sysfs files

Right, and it's disk_add_events in add_disk that adds these sysfs files.

> and calls your new disk_events_set_poll_msecs().

No... there is no call to disk_events_set_poll_msecs in add_disk, when
the events for the disk is created by disk_alloc_events, the poll_msecs
of the event is initialized to the default value -1. And then
disk_add_events will create the sysfs files and add_disk will return,
and I'll change the default value of -1 to 2000 with the new function
I've made.

> It makes more sense to me to have the new call to
> disk_events_set_poll_msecs(disk, 2000) before the call to add_disk().

This is too early, since the events of the disk is not allocated yet.

I hope I've explained this clearly, if you see a problem, please let me
know, thanks.

-Aaron


