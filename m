From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Date: Mon, 3 Jun 2013 23:47:22 +0000
Message-ID: <1370303241.2013.21.camel@dabdike.int.hansenpartnership.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
	 <1370301688-27286-1-git-send-email-kys@microsoft.com>
	 <1370300581.2013.14.camel@dabdike.int.hansenpartnership.com>
	 <154d86b83ab94931a097c32e1c8e4987@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:33650 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3FCXrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jun 2013 19:47:25 -0400
In-Reply-To: <154d86b83ab94931a097c32e1c8e4987@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Language: en-US
Content-ID: <77A61E00CA0C5246BB59D166600FC796@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2013-06-03 at 23:25 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:jbottomley@parallels.com]
> > Sent: Monday, June 03, 2013 7:03 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> > scsi@vger.kernel.org
> > Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a module
> > parameter
> > 
> > On Mon, 2013-06-03 at 16:21 -0700, K. Y. Srinivasan wrote:
> > > The standard scsi timeout is not appropriate in some of the environments
> > where
> > > Hyper-V is deployed. Set this timeout appropriately for all devices managed
> > > by this driver. Further make this a module parameter.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/scsi/storvsc_drv.c |    9 +++++++++
> > >  1 files changed, 9 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > index 16a3a0c..8d29a95 100644
> > > --- a/drivers/scsi/storvsc_drv.c
> > > +++ b/drivers/scsi/storvsc_drv.c
> > > @@ -221,6 +221,13 @@ static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
> > >  module_param(storvsc_ringbuffer_size, int, S_IRUGO);
> > >  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
> > >
> > > +/*
> > > + * Timeout in seconds for all devices managed by this driver.
> > > + */
> > > +static int storvsc_timeout = 180;
> > > +module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
> > > +MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
> > > +
> > >  #define STORVSC_MAX_IO_REQUESTS				128
> > >
> > >  /*
> > > @@ -1204,6 +1211,8 @@ static int storvsc_device_configure(struct scsi_device
> > *sdevice)
> > >
> > >  	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
> > >
> > > +	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout *
> > HZ));
> > 
> > Why does this need to be a module parameter?  It's already a sysfs one
> > in the scsi_device class?  Three minutes is also a bit large.  The
> > default is 30s with huge cache arrays recommending upping this to
> > 60s ... you're three times this.
> 
> James,
> This number was arrived at based on some testing that was done on the
> cloud. On our cloud, we have a  120 second
> timeouts that trigger broader VM level recovery  and in cases where
> there is storage access issues
> (which is when we would hit this timeout), it will be better to defer
> to the fabric level recovery than attempt
> Scsi level recovery/retry.  The default value chosen for devices
> managed by storvsc should be just fine, 

So are you sure you want to set the command timeout to 3 minutes? ...
it's an incredibly high value.  The actual complete timeout is this
value multiplied by the number of retries, which is 5 for disk devices,
so you'll be waiting up to 15 minutes before we signal a failure in some
circumstances.  It sounds like you want the actual path length of error
recovery to be on average 3 minutes.

The value of the timeout should be a compromise between the longest time
you want the user to wait for a failure and the longest time a device
should take to respond.

> I made it a module parameter to have more flexibility.

It's *already* a sysfs parameter ... why do you want an additional
module parameter?  Multiple parameters for the same quantity, especially
ones which can't be altered at runtime like module parameters, end up
confusing users.

James

