From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/3] Better log messages for PQ3 devs
Date: Wed, 29 Mar 2006 13:30:09 -0700
Message-ID: <20060329203009.GC13590@parisc-linux.org>
References: <20060329201020.GG7919@tpkurt.suse.de> <20060329201247.GI7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:30905 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750815AbWC2UaK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 15:30:10 -0500
Content-Disposition: inline
In-Reply-To: <20060329201247.GI7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On Wed, Mar 29, 2006 at 10:12:47PM +0200, Kurt Garloff wrote:
>  		 */
> -		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
> -					"scsi scan: peripheral qualifier of 3,"
> -					" no device added\n"));
> +		SCSI_LOG_SCAN_BUS(2, printk(KERN_INFO "scsi scan: periph.qual. of 3,"
> +				" device %s not added\n",
> +				sdev->sdev_gendev.bus_id));

You seem to be suffering from long-line-itis, probably as a result of
too much exposure to ia64 code.  How about:

		SCSI_LOG_SCAN_BUS(2, printk(KERN_INFO "scsi scan: peripheral "
				"qualifier of 3, device %s not added\n",
				sdev->sdev_gendev.bus_id));

> +		if (lun == 0) {
> +			unsigned char vend[9], mod[17];
> +			SCSI_LOG_SCAN_BUS(1, printk(KERN_INFO "scsi scan: consider passing "
> +					"scsi_mod.dev_flags=%s:%s:0x240 or 0x800240\n",


Likewise:

			SCSI_LOG_SCAN_BUS(1, printk(KERN_INFO "scsi scan: "
					"consider passing scsi_mod.dev_flags="
					"%s:%s:0x240 or 0x800240\n",

> +					scsi_inq_str(vend, result, 8, 16),
> +					scsi_inq_str(mod, result, 16, 32)));
> +		}
> +		
>  		res = SCSI_SCAN_TARGET_PRESENT;
>  		goto out_free_result;
>  	}
>  
> -- 
> Kurt Garloff, Head Architect Linux R&D, Novell Inc.


