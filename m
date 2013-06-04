From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Date: Tue, 4 Jun 2013 00:21:54 +0000
Message-ID: <d278530eda3a4bd18f78b9106ea5dd2f@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
 <1370301688-27286-1-git-send-email-kys@microsoft.com>
 <1370300581.2013.14.camel@dabdike.int.hansenpartnership.com>
 <154d86b83ab94931a097c32e1c8e4987@SN2PR03MB061.namprd03.prod.outlook.com>
 <1370303241.2013.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1370303241.2013.21.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Monday, June 03, 2013 7:47 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a module
> parameter
> 
> On Mon, 2013-06-03 at 23:25 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley [mailto:jbottomley@parallels.com]
> > > Sent: Monday, June 03, 2013 7:03 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
> module
> > > parameter
> > >
> > > On Mon, 2013-06-03 at 16:21 -0700, K. Y. Srinivasan wrote:
> > > > The standard scsi timeout is not appropriate in some of the environments
> > > where
> > > > Hyper-V is deployed. Set this timeout appropriately for all devices managed
> > > > by this driver. Further make this a module parameter.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/scsi/storvsc_drv.c |    9 +++++++++
> > > >  1 files changed, 9 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > > index 16a3a0c..8d29a95 100644
> > > > --- a/drivers/scsi/storvsc_drv.c
> > > > +++ b/drivers/scsi/storvsc_drv.c
> > > > @@ -221,6 +221,13 @@ static int storvsc_ringbuffer_size = (20 *
> PAGE_SIZE);
> > > >  module_param(storvsc_ringbuffer_size, int, S_IRUGO);
> > > >  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
> > > >
> > > > +/*
> > > > + * Timeout in seconds for all devices managed by this driver.
> > > > + */
> > > > +static int storvsc_timeout = 180;
> > > > +module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
> > > > +MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
> > > > +
> > > >  #define STORVSC_MAX_IO_REQUESTS				128
> > > >
> > > >  /*
> > > > @@ -1204,6 +1211,8 @@ static int storvsc_device_configure(struct
> scsi_device
> > > *sdevice)
> > > >
> > > >  	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
> > > >
> > > > +	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout *
> > > HZ));
> > >
> > > Why does this need to be a module parameter?  It's already a sysfs one
> > > in the scsi_device class?  Three minutes is also a bit large.  The
> > > default is 30s with huge cache arrays recommending upping this to
> > > 60s ... you're three times this.
> >
> > James,
> > This number was arrived at based on some testing that was done on the
> > cloud. On our cloud, we have a  120 second
> > timeouts that trigger broader VM level recovery  and in cases where
> > there is storage access issues
> > (which is when we would hit this timeout), it will be better to defer
> > to the fabric level recovery than attempt
> > Scsi level recovery/retry.  The default value chosen for devices
> > managed by storvsc should be just fine,
> 
> So are you sure you want to set the command timeout to 3 minutes? ...
> it's an incredibly high value.  The actual complete timeout is this
> value multiplied by the number of retries, which is 5 for disk devices,
> so you'll be waiting up to 15 minutes before we signal a failure in some
> circumstances.  It sounds like you want the actual path length of error
> recovery to be on average 3 minutes.
>
> The value of the timeout should be a compromise between the longest time
> you want the user to wait for a failure and the longest time a device
> should take to respond.

This should be fine. Note that all error recovery/retry is happening on the host side and beyond
a certain delay, we will do a VM level recovery at the fabric level.  On a slightly different note,
we have the same issue with the SCSI FLUSH timeout. Would you consider changing this.
> 
> > I made it a module parameter to have more flexibility.
> 
> It's *already* a sysfs parameter ... why do you want an additional
> module parameter?  Multiple parameters for the same quantity, especially
> ones which can't be altered at runtime like module parameters, end up
> confusing users.

Agreed. I can send you a patch that would remove this parameter. Or, if you prefer
I could resend this set with the change to this patch (removing the module parameter).

Regards,

K. Y
> 
> James
> 
> 
