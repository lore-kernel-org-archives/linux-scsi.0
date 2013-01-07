From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 8/9] libata: no poll when ODD is powered off
Date: Mon, 7 Jan 2013 10:45:53 -0800
Message-ID: <20130107184553.GU3926@htj.dyndns.org>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
 <1357440509-28108-9-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357440509-28108-9-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 06, 2013 at 10:48:28AM +0800, Aaron Lu wrote:
> When the ODD is powered off, any action the user did to the ODD that
> would generate a media event will trigger an ACPI interrupt, so the
> poll for media event is no longer necessary. And the poll will also
> cause a runtime status change, which will stop the ODD from staying in
> powered off state, so the poll should better be stopped.
> 
> But since we don't have access to the gendisk structure in LLDs, here
> comes the event_driven flag for scsi device. This flag serves as a
> capability of the device, conveyed by the LLDs to upper layer. It is set
> when LLDs know that this device will no longer generate any media
> related events, so that the check_events can simply return 0 without
> bothering the device, effectively silence the poll.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> @@ -160,6 +160,7 @@ struct scsi_device {
>  	unsigned can_power_off:1; /* Device supports runtime power off */
>  	unsigned wce_default_on:1;	/* Cache is ON by default */
>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
> +	unsigned event_driven:1; /* No need to poll the device */

Again, synchronization.  Also, wouldn't something more explicit like
disable_disk_events better suited?

Thanks.

-- 
tejun
