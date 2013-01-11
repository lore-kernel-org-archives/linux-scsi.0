From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v12 4/9] libata: check zero power ready status for ZPODD
Date: Fri, 11 Jan 2013 10:00:59 +0800
Message-ID: <20130111020059.GA26270@aaronlu.sh.intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-5-git-send-email-aaron.lu@intel.com>
 <20130110195231.GI20454@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130110195231.GI20454@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

On Thu, Jan 10, 2013 at 11:52:31AM -0800, Tejun Heo wrote:
> Hello, Aaron.
> 
> On Thu, Jan 10, 2013 at 05:24:25PM +0800, Aaron Lu wrote:
> > +/*
> > + * Update the zpodd->zp_ready field. This field will only be set
> > + * if the ODD has stayed in ZP ready state for zpodd_poweroff_delay
> > + * time, and will be used to decide if power off is allowed. If it
> > + * is set, it will be cleared during resume from powered off state.
> > + */
> > +void zpodd_on_suspend(struct ata_device *dev)
> > +{
> > +	struct zpodd *zpodd = dev->zpodd;
> > +	unsigned long expires;
> > +
> > +	if (!zpready(dev)) {
> > +		zpodd->zp_sampled = false;
> > +		return;
> > +	}
> > +
> > +	if (!zpodd->zp_sampled) {
> > +		zpodd->zp_sampled = true;
> > +		zpodd->last_ready = jiffies;
> > +		return;
> 
> Is the above return necessary?  Can't we just fall through and always
> check the actual condition?

The zpready(dev) function will check the actual condition by issuing a
TUR and check the returned sense code. And the zp_sampled serves as an
indication if this is the first time we sensed the ODD in ZP ready
status.

The zpodd_on_suspend works like this:

check ZP ready status by calling zpready(dev)
  if not, clear zp_sampled and zp_ready
  return

ODD is ZP ready

check if this is the first time we sensed it is ZP ready
  if not, set the zp_sampled flag and record timestamp
  return

This is not the first time we sensed ZP ready for the ODD

check if the ODD has been in this state long enough
  if not, return

The ODD has been in ZP ready state long enough
  set the zp_ready flag, the zpodd_zpready will use that flag

Done.

Does this work flow look OK?

BTW, I just realized I mistakenly removed the clear of zp_ready in v12
when zpready(dev) returns false, I thought it is not necessary since
each time we set that flag, the ODD will be powered off and the flag
will always be cleared during resume time in post_poweron. But when
qos_no_poweroff is set, this is not the case and can cause problem when
ODD is not in ZP ready state and user cleared the qos_no_poweroff flag.
I'll add a comment for this in next version to avoid making this mistake
again in the future...

Thanks,
Aaron

> 
> > +	}
> > +
> > +	expires = zpodd->last_ready +
> > +		  msecs_to_jiffies(zpodd_poweroff_delay * 1000);
> > +	if (time_before(jiffies, expires))
> > +		return;
> > +
> > +	zpodd->zp_ready = true;
> > +}
> 
> Thanks.
> 
> -- 
> tejun
