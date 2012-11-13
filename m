From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 13 Nov 2012 21:20:28 +0800
Message-ID: <20121113132027.GB11672@aaronlu.sh.intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-7-git-send-email-aaron.lu@intel.com>
 <20121112191303.GE5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121112191303.GE5560@mtj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2012 at 11:13:03AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 09, 2012 at 02:51:58PM +0800, Aaron Lu wrote:
> > +/*
> > + * Check ODD's zero power ready status.
> > + *
> > + * This function is called during ATA port's suspend path,
> > + * when the port is not frozen yet, so that we can still make
> > + * some IO to the ODD to decide if it is zero power ready.
> > + *
> > + * The ODD is regarded as zero power ready when it is in zero
> > + * power ready state for some time(defined by POWEROFF_DELAY).
> > + */
> > +void zpodd_check_zpready(struct ata_device *dev)
> > +{
> > +	bool zp_ready;
> > +	unsigned long expires;
> > +	struct zpodd *zpodd = dev->private_data;
> > +
> > +	if (!zpodd->status_ready) {
> > +		zpodd->last_ready = 0;
> > +		return;
> > +	}
> > +
> > +	if (!zpodd->last_ready) {
> > +		zp_ready = zpready(dev);
> > +		if (zp_ready)
> > +			zpodd->last_ready = jiffies;
> > +		return;
> > +	}
> > +
> > +	expires = zpodd->last_ready + msecs_to_jiffies(POWEROFF_DELAY);
> > +	if (time_before(jiffies, expires))
> > +		return;
> > +
> > +	zpodd->zp_ready = zpready(dev);
> > +	if (!zpodd->zp_ready)
> > +		zpodd->last_ready = 0;
> > +}
> 
> Hmmm... so, the "full" check only happens when autopm kicks in, right?

Yes, and unless the ODD is powered off, autopm can kick in every 2
seconds(together with the events poll).

> Is it really worth avoiding an extra TUR on autopm events?  That's not
> really a hot path.  It seems a bit over-engineered to me.

I'm not sure...But if issuing TUR every 2 seconds under some condition
is acceptable, I'll be happily removing the snoop thing and use TUR only.

Thanks,
Aaron

