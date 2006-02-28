From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 12/13] ATA ACPI: use scsi_bus_shutdown for SATA/PATA
Date: Tue, 28 Feb 2006 12:58:58 +0100
Message-ID: <20060228115858.GF4081@elf.ucw.cz>
References: <20060222133241.595a8509.randy_d_dunlap@linux.intel.com> <20060222140608.2de3fa24.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41644 "EHLO amd.ucw.cz")
	by vger.kernel.org with ESMTP id S932264AbWB1MDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 07:03:50 -0500
Content-Disposition: inline
In-Reply-To: <20060222140608.2de3fa24.randy_d_dunlap@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, akpm@osdl.org, jgarzik@pobox.com, james.bottomley@steeleye.com

Hi!

> From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
> 
> Add ability for SCSI drivers to invoke a shutdown method.
> This allows drivers to make drives safe for shutdown/poweroff,
> for example.  Some drives need this to prevent possible problems.
> 
> Signed-off-by: Randy Dunlap <randy_d_dunlap@linux.intel.com>

> --- linux-2616-rc4-ata.orig/drivers/scsi/scsi_sysfs.c
> +++ linux-2616-rc4-ata/drivers/scsi/scsi_sysfs.c
> @@ -302,11 +302,27 @@ static int scsi_bus_resume(struct device
>  	return err;
>  }
>  
> +static void scsi_bus_shutdown(struct device * dev)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct scsi_host_template *sht = sdev->host->hostt;
> +	int err;
> +
> +	err = scsi_device_quiesce(sdev);

int err = scsi_device_quiesce()?

> +	if (err)
> +		printk(KERN_DEBUG "%s: error (0x%x) during shutdown\n",
> +			__FUNCTION__, err);

If you get an error, and then ignore it... that should not be DEBUG
message, right?

> +	if (sht->shutdown)
> +		sht->shutdown(sdev);
> +}
> +
>  struct bus_type scsi_bus_type = {
>          .name		= "scsi",
>          .match		= scsi_bus_match,
>  	.suspend	= scsi_bus_suspend,
>  	.resume		= scsi_bus_resume,
> +	.shutdown	= scsi_bus_shutdown,
>  };

Whitespace?
								Pavel
-- 
Web maintainer for suspend.sf.net (www.sf.net/projects/suspend) wanted...
