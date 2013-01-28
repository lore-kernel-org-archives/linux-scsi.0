From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 4/4] sd: change to auto suspend mode
Date: Mon, 28 Jan 2013 16:56:51 +0800
Message-ID: <20130128085651.GA2568@aaronlu.sh.intel.com>
References: <1358326941-3725-5-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1301181613060.1190-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301181613060.1190-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 18, 2013 at 04:25:10PM -0500, Alan Stern wrote:
> On Wed, 16 Jan 2013, Aaron Lu wrote:
> 
> > From: Lin Ming <ming.m.lin@intel.com>
> > 
> > Uses block layer runtime pm helper functions in
> > scsi_runtime_suspend/resume.
> > Remove scsi_autopm_* from sd open/release path and check_events path.
> > And remove the quiesce call in runtime suspend path, as we know there is
> > no request to quiesce for the device.
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -893,6 +893,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> >  	 */
> >  	scsi_autopm_get_device(sdev);
> >  
> > +	blk_pm_runtime_init(rq, &sdev->sdev_gendev);
> > +
> >  	error = device_add(&sdev->sdev_gendev);
> >  	if (error) {
> >  		sdev_printk(KERN_INFO, sdev,
> 
> Someone just asked about the default autosuspend delay, and I realized
> your patch series doesn't set one.  Since we don't know the properties
> of the disk drive at this point (or even whether the device is a disk
> drive), the only safe course is to call
> 
> 	pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev, -1);
> 
> before calling blk_pm_runtime_init().  Then autosuspends will be 
> prevented until userspace writes a non-negative value into the device's 
> control/autosuspend_delay_ms file.

Shall we do it inside blk_pm_runtime_init? This way, we do not need to
do it for every driver. And for drivers that do know a proper value for
autosuspend delay, they can call pm_runtime_set_autosuspend_delay
somewhere after blk_pm_runtime_init.

Thanks,
Aaron

