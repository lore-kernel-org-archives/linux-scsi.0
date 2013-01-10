From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 4/9] libata: check zero power ready status for ZPODD
Date: Thu, 10 Jan 2013 11:52:31 -0800
Message-ID: <20130110195231.GI20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357809870-18816-5-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Aaron.

On Thu, Jan 10, 2013 at 05:24:25PM +0800, Aaron Lu wrote:
> +/*
> + * Update the zpodd->zp_ready field. This field will only be set
> + * if the ODD has stayed in ZP ready state for zpodd_poweroff_delay
> + * time, and will be used to decide if power off is allowed. If it
> + * is set, it will be cleared during resume from powered off state.
> + */
> +void zpodd_on_suspend(struct ata_device *dev)
> +{
> +	struct zpodd *zpodd = dev->zpodd;
> +	unsigned long expires;
> +
> +	if (!zpready(dev)) {
> +		zpodd->zp_sampled = false;
> +		return;
> +	}
> +
> +	if (!zpodd->zp_sampled) {
> +		zpodd->zp_sampled = true;
> +		zpodd->last_ready = jiffies;
> +		return;

Is the above return necessary?  Can't we just fall through and always
check the actual condition?

> +	}
> +
> +	expires = zpodd->last_ready +
> +		  msecs_to_jiffies(zpodd_poweroff_delay * 1000);
> +	if (time_before(jiffies, expires))
> +		return;
> +
> +	zpodd->zp_ready = true;
> +}

Thanks.

-- 
tejun
