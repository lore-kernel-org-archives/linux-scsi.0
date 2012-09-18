From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/4] scsi: introduce sync_before_stop flag
Date: Tue, 18 Sep 2012 08:56:55 +0100
Message-ID: <1347955015.2388.0.camel@dabdike.int.hansenpartnership.com>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
	 <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48698 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab2IRH5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 03:57:00 -0400
In-Reply-To: <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Oliver Neukum <oneukum@suse.de>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org

On Tue, 2012-09-18 at 15:00 +0800, Aaron Lu wrote:
> When scsi device received stop command, it will take care of its
> internal cache before enters stopped power condition. This command is
> translated to standby immediate in libata-scsi, but standby doesn't
> imply flush cache for ATA device, so to issue stop command to ATA
> device, an additional flush cache has to be issued.
> 
> Introduce this flag so that when we are to stop the ATA disk in scsi
> disk driver, also flush its internal cache.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  include/scsi/scsi_device.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 4712aa1..26c3621 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -160,6 +160,7 @@ struct scsi_device {
>  	unsigned ready_to_power_off:1;	/* Device is ready to be powered off */
>  	unsigned powered_off:1;	/* Device is powered off */
>  	unsigned may_power_off:1; /* Power off is allowed by user */
> +	unsigned sync_before_stop:1; /* Sync cache before stop */

Why do you need this?

Surely it's all conditioned on the WCE flag.  If WCE isn't set, the
cache is write through (or uncached) and there's no need for a sync
before power down.

James


