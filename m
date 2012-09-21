From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 3/6] scsi: sr: support zero power ODD(ZPODD)
Date: Fri, 21 Sep 2012 23:02:19 +0200
Message-ID: <201209212302.19896.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209210007.23494.rjw@sisk.pl> <20120921013917.GB2142@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120921013917.GB2142@mint-spring.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Friday, September 21, 2012, Aaron Lu wrote:
> On Fri, Sep 21, 2012 at 12:07:23AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, September 12, 2012, Aaron Lu wrote:
> > >  static struct scsi_driver sr_template = {
> > >  	.owner			= THIS_MODULE,
> > > @@ -87,6 +89,8 @@ static struct scsi_driver sr_template = {
> > >  		.name   	= "sr",
> > >  		.probe		= sr_probe,
> > >  		.remove		= sr_remove,
> > > +		.suspend        = sr_suspend,
> > > +		.resume         = sr_resume,
> > >  	},
> > >  	.done			= sr_done,
> > >  };
> > > @@ -172,6 +176,52 @@ static void scsi_cd_put(struct scsi_cd *cd)
> > >  	mutex_unlock(&sr_ref_mutex);
> > >  }
> > 
> > Besides, I need some help to understand how this is supposed to work.
> > 
> > Do I think correctly that sr_suspend(), for example, will be run by the
> > SCSI bus type layer in case of a CD device runtime suspend?  However,
> 
> Yes.
> 
> > won't this routine be used during system suspend as well and won't it cause
> > problems to happen if so?
> 
> On system suspend, nothing needs to be done.
> I'll add the following code in next version.
> 
> 	if (!PMSG_IS_AUTO(msg))
> 		return 0;

Please don't.  The pm_message_t thing is obsolete and shoulnd't really be
used by device drivers.  I know that ATA relies on it internally, but that's
just something that needs to be changed at one point.

Moreover, I'd like to migrate SCSI drivers to the PM handling based on struct
dev_pm_ops eventually and your change is kind of going in the opposite
direction.  I don't know how much effort the migration is going to take,
though, so perhaps we can just make this change first.

On a slightly related note, suppose that we have an "enabled" bit in flags
in struct acpi_device_power_state and suppose that we have a helper
function pm_platform_power_off_allowed(dev, bool), such that if the driver
(or subsystem) does pm_platform_power_off_allowed(dev, false) and the
platform is ACPI, the "enabled" bit for the D3cold state will be cleared.
Then, the ACPI device PM routines will never use D3cold as the device
power state.

In that case, it seems, you won't need the "ready_to_power_off" flag in struct
scsi_device any more.

Thanks,
Rafael
