From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH 4/5] scsi: pm: use runtime resume callback if available
Date: Tue, 24 Jul 2012 07:30:45 +0800
Message-ID: <20120723233043.GA1965@localhost.localdomain>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
 <1343026180-22236-5-git-send-email-aaron.lu@amd.com>
 <500D615C.1080605@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <500D615C.1080605@mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Mon, Jul 23, 2012 at 06:36:12PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/23/2012 10:49 AM, Aaron Lu wrote:
> 
> > When runtime resume a scsi device, if the device's driver has
> > implemented runtime resume callback, use that instead of the resume
> > callback.
> 
> > sr driver needs this to properly do different things for system resume
> > and runtime resume.
> 
> > Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> > ---
> >  drivers/scsi/scsi_pm.c | 14 +++++++++-----
> >  drivers/scsi/sr.c      | 21 +++++++++++++++++++++
> >  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> > diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> > index d4201de..19bba47 100644
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> > @@ -34,14 +34,18 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
> >  	return err;
> >  }
> >  
> > -static int scsi_dev_type_resume(struct device *dev)
> > +static int scsi_dev_type_resume(struct device *dev, bool runtime)
> >  {
> >  	struct device_driver *drv;
> >  	int err = 0;
> > +	int (*resume)(struct device *);
> >  
> >  	drv = dev->driver;
> > -	if (drv && drv->resume)
> > -		err = drv->resume(dev);
> > +	if (runtime && drv && drv->pm && drv->pm->runtime_resume)
> > +		resume = drv->pm->runtime_resume;
> > +	else
> > +		resume = drv ? drv->resume : NULL;
> 
>    Call thru NULL pointer below will cause kernel oops. Is it your intention?

Oops, I forgot the if check here, thanks for pointing this out.

-Aaron

> 
> > +	err = resume(dev);
> 
