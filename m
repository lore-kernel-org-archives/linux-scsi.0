From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/1] scsi: Synchronize request queue PM status only
 on successful resume
Date: Thu, 3 Jan 2019 14:38:47 +0800
Message-ID: <1546497527.20657.12.camel@mtkswgap22>
References: <1546410308-13486-1-git-send-email-stanley.chu@mediatek.com>
 <1546410308-13486-3-git-send-email-stanley.chu@mediatek.com>
 <1546445745.163063.4.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1546445745.163063.4.camel-HInyCGIudOg@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wsdupstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

On Wed, 2019-01-02 at 08:15 -0800, Bart Van Assche wrote:
> On Wed, 2019-01-02 at 14:25 +0800, stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org wrote:
> > From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > 
> > The commit 356fd2663cff ("scsi: Set request queue runtime PM status
> > back to active on resume") fixed up the inconsistent RPM status between
> > request queue and device. However changing request queue RPM status
> > shall be done only on successful resume, otherwise status may be still
> > inconsistent as below,
> > 
> > Request queue: RPM_ACTIVE
> > Device: RPM_SUSPENDED
> > 
> > This ends up soft lockup because requests can be submitted to
> > underlying devices but those devices and their required resource
> > are not resumed.
> > 
> > Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> 
> Please add "Fixes:" and "Cc: stable" tags and also Cc the author of commit
> 356fd2663cff.

Sure. Thanks for remind.

> 
> 
> > ---
> >  drivers/scsi/scsi_pm.c | 24 ++++++++++++++----------
> >  1 file changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> > index a2b4179..eff3e59 100644
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> > @@ -82,6 +82,20 @@ static int scsi_dev_type_resume(struct device *dev,
> >  		pm_runtime_disable(dev);
> >  		pm_runtime_set_active(dev);
> >  		pm_runtime_enable(dev);
> > +
> > +		/*
> > +		 * Forcibly set runtime PM status of request queue to "active"
> > +		 * to make sure we can again get requests from the queue
> > +		 * (see also blk_pm_peek_request()).
> > +		 *
> > +		 * The resume hook will correct runtime PM status of the disk.
> > +		 */
> > +		if (!err && scsi_is_sdev_device(dev)) {
> > +			struct scsi_device *sdev = to_scsi_device(dev);
> > +
> > +			if (sdev->request_queue->dev)
> > +				blk_set_runtime_active(sdev->request_queue);
> > +		}
> 
> What makes you think that the sdev->request_queue->dev test is necessary? The
> scsi_dev_type_resume() function is only called after blk_pm_runtime_init() has
> finished so I don't think that test is necessary.

We found NULL sdev->request_queue->dev may be dereferenced during below
system resume flow,

scsi_bus_resume_common()
 => async_schedule_domain(async_sdev_resume)

And then async_sdev_resume() is invoked asynchronously,
 
async_sdev_resume()
 => scsi_dev_type_resume(dev, do_scsi_resume)
  => blk_set_runtime_active(sdev->request_queue)

If a SCSI device does not have upper layer driver (like SCSI disk), it
may not be applied blk_pm_runtime_init() invoked by sd_probe() while
this SCSI device is added.

For example, some SCSI devices (like UFS Boot W-LUN) are added
explicitly in __scsi_add_device() by ufshcd_scsi_add_wlus() first and
thus sd_probe() for them is skipped because they are already visible.

For those SCSI devices, null sdev->request_queue->dev will be
dereferenced in blk_set_runtime_active() during above system resume
flow, therefore we add a null pointer checking for this case.

The same issue also happens on those SCSI devices before this patch as
below system resume flow while devices are already runtime-suspended.

scsi_bus_resume_common()
 => blk_set_runtime_active(to_scsi_device(dev)->request_queue)

> 
> Additionally, since the above code occurs inside a block controlled by an
> "if (err == 0)" statement, I think the !err test is redundant and should be
> left out.

Sorry this is my code merge defect.
"err" here shall be returned value from pm_runtime_set_active().

I will fix it in v2.

> 
> Thanks,
> 
> Bart.
> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
