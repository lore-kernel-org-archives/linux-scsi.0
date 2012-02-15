From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [RFC PATCH 6/6] libata: add ZPODD support
Date: Wed, 15 Feb 2012 15:18:19 +0800
Message-ID: <20120215071818.GA10754@ladygaga>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
 <1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
 <CAOzJMDQHbM9Hyx_W=0nhzK+FTk5i5Hvvn00TerYH54-yH1so2A@mail.gmail.com>
 <1329288365.3104.34.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1329288365.3104.34.camel@minggr>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 15, 2012 at 02:46:05PM +0800, Lin Ming wrote:
> On Wed, 2012-02-15 at 14:06 +0800, Aaron Lu wrote:
> > Hi,
> > 
> > Good work, I'm also working on ZPODD for AMD platforms, some comments below.
> 
> Great :)
> 
> > 
> > On Mon, Feb 13, 2012 at 5:11 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > > ZPODD(Zero Power Optical Disk Drive) is a new feature in
> > > SATA 3.1 specification. It provides a way to power off unused CDROM.
> > 
> > I don't see anywhere in the sata 3.1 spec mentioned how to power off the
> > cdrom, the only relevant content is the newly defined device attention pin,
> > which is used to notify the host that this powered off device needs attention.
> > Or do I miss something?
> 
> You're right.
> 
> > 
> > >
> > > CDROM is powered off by executing ACPI power resource's _OFF method.
> > >
> > 
> > AMD has a different implementation to power off the CDROM, I'll need to
> > prepare another patch based on yours.
> 
> Could you share AMD's implementation?
>

Sure.
We have defined a special device, named ODDZ, under the SATA scope in the
DSDT table. So basically, the existence of device ODDZ means the support
of ZPODD at the platform level. And there are the _PS0 and _PS3 control
methods under device ODDZ to power on/off the attached cdrom.
The code is not ready yet, I'm still working on it.

Thanks,
Aaron

> > 
> > > When CDROM is powered off(D3Cold state), inserting disk will trigger a
> > > wakeup event(GPE). GPE AML handler notifies the associated device. Then
> > > CDROM is resumed in the notify handler.
> > >
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > ---
> > >  drivers/ata/libata-acpi.c |   64 +++++++++++++++++++++++++++++++++++++-------
> > >  drivers/scsi/sr.c         |   39 +++++++++++++++++++++++++++
> > >  drivers/scsi/sr.h         |    3 ++
> > >  3 files changed, 95 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > > index 5fc97d2..bf4eace 100644
> > > --- a/drivers/scsi/sr.c
> > > +++ b/drivers/scsi/sr.c
> > > @@ -716,6 +752,9 @@ static int sr_probe(struct device *dev)
> > >        disk->flags |= GENHD_FL_REMOVABLE;
> > >        add_disk(disk);
> > >
> > > +       if (device_run_wake(dev))
> > > +               cd->zpodd = 1;
> > > +
> > 
> > For a cd to support zero power, it has to support device attention pin.
> > If it does not support that, once it is powered off, it can't be power up
> > back. So I don't think device_run_wake is enough to set the zpodd flag,
> > unless your firmware has done the check and created the acpi table
> > according to the result. Is it the case?
> 
> I should add device attention pin check.
> 
> Thanks for the comments.
> Lin Ming
> 
> > 
> > Thanks,
> > Aaron
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

