From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 5/9] libata: check zero power ready status for ZPODD
Date: Mon, 7 Jan 2013 10:36:10 -0800
Message-ID: <20130107183610.GR3926@htj.dyndns.org>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
 <1357440509-28108-6-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357440509-28108-6-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Aaron.

On Sun, Jan 06, 2013 at 10:48:25AM +0800, Aaron Lu wrote:
> +/* Check zero power ready status */
> +void zpodd_on_suspend(struct ata_device *dev)
> +{
> +	struct zpodd *zpodd = dev->zpodd;
> +	unsigned long expires;
> +
> +	if (!zpready(dev)) {
> +		zpodd->zp_ready = false;
> +		zpodd->last_ready = 0;
> +		return;
> +	}
> +
> +	if (!zpodd->last_ready) {
> +		zpodd->last_ready = jiffies;
> +		return;
> +	}
> +
> +	expires = zpodd->last_ready +
> +		  msecs_to_jiffies(zpodd_poweroff_delay * 1000);
> +	if (time_before(jiffies, expires))
> +		return;
> +
> +	zpodd->zp_ready = true;
> +}

Using 0 jiffies as special value is generally considered a bad form.
It should be mostly ok here but it's not like avoiding that is
difficult, so let's please not use 0 jiffies as special value.  If you
have to, add another variable zp_sample_cnt or whatever.

Thanks.

-- 
tejun
