From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v2] Hard disk S3 resume time optimization
Date: Fri, 09 Aug 2013 09:25:47 +0200
Message-ID: <1376033147.1902.6.camel@linux-fkkt.site>
References: <11E08D716F0541429B7042699DD5C1A170680F5C@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030658Ab3HIIkj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Aug 2013 04:40:39 -0400
In-Reply-To: <11E08D716F0541429B7042699DD5C1A170680F5C@FMSMSX103.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Brandt, Todd E" <todd.e.brandt@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 2013-08-09 at 01:09 +0000, Brandt, Todd E wrote:

>  static struct ata_force_ent *ata_force_tbl;
>  static int ata_force_tbl_size;
> +int ata_resume_status;

A single global variable for multiple ports?
 
>  static char ata_force_param_buf[PAGE_SIZE] __initdata;
>  /* param_buf is thrown away after initialization, disallow read */
> @@ -5415,6 +5416,22 @@ static int ata_port_resume(struct device *dev)
>  	return rc;
>  }
>  
> +static int ata_port_resume_async(struct device *dev)
> +{
> +	struct ata_port *ap = to_ata_port(dev);
> +
> +	ata_resume_status = 0;
> +	ata_port_request_pm(ap, PMSG_RESUME, ATA_EH_RESET,
> +		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, &ata_resume_status);

If this ever runs in paralell it is extremely racy.

> +	if (!ata_resume_status) {
> +		pm_runtime_disable(dev);
> +		pm_runtime_set_active(dev);
> +		pm_runtime_enable(dev);
> +	}
> +
> +	return ata_resume_status;
> +}
> +


> +	req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);

What happens if commands go to the device before this has finished?
Especially should it fail.

	Regards
		Oliver


