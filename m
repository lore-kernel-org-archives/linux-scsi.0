From: Betty Dall <betty.dall@hp.com>
Subject: Re: [PATCH 5/5] block: genhd: add an interface to set disk's poll
 interval
Date: Tue, 24 Jul 2012 12:55:06 -0600
Message-ID: <1343156106.25735.59.camel@ejdallLaptop>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
	 <1343026180-22236-6-git-send-email-aaron.lu@amd.com>
	 <1343069014.25735.28.camel@ejdallLaptop>
	 <20120723235211.GB1965@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47776 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2GXSzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2012 14:55:10 -0400
In-Reply-To: <20120723235211.GB1965@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

Hi Aaron,

On Tue, 2012-07-24 at 07:52 +0800, Aaron Lu wrote:
> On Mon, Jul 23, 2012 at 12:43:34PM -0600, Betty Dall wrote:
> > Hi Aaron,
> 
> Hi,
> 
> > 
> > On Mon, 2012-07-23 at 14:49 +0800, Aaron Lu wrote:
> > > Set the ODD's in kernel poll interval to 2s for the user in case the
> > > user is using an old distro on which udev will not set the system wide
> > > block parameter events_dfl_poll_msecs.
> > Why did you pick 2 seconds? 
> 
> Just a random pick, no special meaning here.
> On newer distros, udev will also pick 2s for the events_dfl_poll_msecs
> parameter, so I just followed that :-)
> Do you see any problem with this setting?

No problem, and I was curious as to why 2s, and the fact that is it used
in udev for events_dfl_poll_msecs is a good reason.

> > 
> > > 
> > > Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> > > ---
> > >  block/genhd.c         | 23 +++++++++++++++++------
> > >  drivers/scsi/sr.c     |  1 +
> > >  include/linux/genhd.h |  1 +
> > >  3 files changed, 19 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/block/genhd.c b/block/genhd.c
> > > index bdb3682..de9b9d9 100644
> > > --- a/block/genhd.c
> > > +++ b/block/genhd.c
> > > @@ -1619,6 +1619,19 @@ static void disk_events_workfn(struct work_struct *work)
> > >  		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
> > >  }
> > >  
> > > +int disk_events_set_poll_msecs(struct gendisk *disk, long intv)
> > > +{
> > > +	if (intv < 0 && intv != -1)
> > > +		return -EINVAL;
> > > +
> > > +	disk_block_events(disk);
> > > +	disk->ev->poll_msecs = intv;
> > > +	__disk_unblock_events(disk, true);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL(disk_events_set_poll_msecs);
> > > +
> > >  /*
> > >   * A disk events enabled device has the following sysfs nodes under
> > >   * its /sys/block/X/ directory.
> > > @@ -1675,16 +1688,14 @@ static ssize_t disk_events_poll_msecs_store(struct device *dev,
> > >  {
> > >  	struct gendisk *disk = dev_to_disk(dev);
> > >  	long intv;
> > > +	int ret;
> > >  
> > >  	if (!count || !sscanf(buf, "%ld", &intv))
> > >  		return -EINVAL;
> > >  
> > > -	if (intv < 0 && intv != -1)
> > > -		return -EINVAL;
> > > -
> > > -	disk_block_events(disk);
> > > -	disk->ev->poll_msecs = intv;
> > > -	__disk_unblock_events(disk, true);
> > > +	ret = disk_events_set_poll_msecs(disk, intv);
> > > +	if (ret)
> > > +		return ret;
> > >  
> > >  	return count;
> > >  }
> > > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > > index 2f159aa..78c4226 100644
> > > --- a/drivers/scsi/sr.c
> > > +++ b/drivers/scsi/sr.c
> > > @@ -869,6 +869,7 @@ static int sr_probe(struct device *dev)
> > >  	dev_set_drvdata(dev, cd);
> > >  	disk->flags |= GENHD_FL_REMOVABLE;
> > >  	add_disk(disk);
> > > +	disk_events_set_poll_msecs(disk, 2000);
> > 
> > Could you check that disk event's poll_msecs is the default (-1) before
> > setting it to 2s? I am thinking of a case when the probe happens after
> > the call to disk_events_poll_msecs_store() and this code would overwrite
> > the user specified value.
> 
> The block device sr0 is created by this driver in this probe function,
> so the user should not be able to set the poll interval before probe,
> right?

The add_disk() call happens immediately before the new
disk_events_set_poll_msecs() call. add_disk() is what eventually creates
the sysfs files and calls your new disk_events_set_poll_msecs(). It
makes more sense to me to have the new call to
disk_events_set_poll_msecs(disk, 2000) before the call to add_disk().
That way add_disk()could override the 2 second default based on user
input. If a distro doesn't support udev setting events_dfl_poll_msecs,
the add_disk() won't ever make a call to disk_events_set_poll_msecs()
and the 2 second default will stand.

-Betty


