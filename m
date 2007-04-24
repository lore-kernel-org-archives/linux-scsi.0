From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/7] libata: check for AN support
Date: Tue, 24 Apr 2007 17:03:29 +0900
Message-ID: <462DB9D1.2070106@gmail.com>
References: <20070424074856.005152262@intel.com> <20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

Kristen Carlson Accardi wrote:
>  static unsigned int ata_print_id = 1;
> @@ -1744,6 +1745,23 @@ int ata_dev_configure(struct ata_device 
>  		}
>  		dev->cdb_len = (unsigned int) rc;
>  
> +		/*
> +		 * check to see if this ATAPI device supports
> +		 * Asynchronous Notification
> +		 */
> +		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id))
> +		{
> +			/* issue SET feature command to turn this on */
> +			rc = ata_dev_set_AN(dev);

Please don't store err_mask into int rc.  Please store it to a separate
err_mask variable and report it when printing error message.

> +			if (rc) {
> +				ata_dev_printk(dev, KERN_ERR,
> +						"unable to set AN\n");
> +				rc = -EINVAL;

Wouldn't -EIO be more appropriate?

> +				goto err_out_nosup;
> +			}
> +			dev->flags |= ATA_DFLAG_AN;
> +		}
> +

Not NACKing.  Just notes for future improvements.  We need to be more
careful here.  ATA/ATAPI world is filled with braindamaged devices and I
bet there are devices which advertises it can do AN but chokes when AN
is enabled.

This should be handled similarly to ACPI failure.  Currently ACPI does
the following.

1. try once, if fail, record that ACPI failed.  return error to trigger
retry.
2. try again, if fail again, ignore error if possible (!FROZEN) and turn
off ACPI.

This fallback mechanism for optional features can probably be
generalized and used for both ACPI and AN.

-- 
tejun
