From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sd: sd should not modify read capacity, cache type or
	write protect flag on rescan when there is a transport error
Date: Sun, 27 Feb 2011 07:51:12 -0700
Message-ID: <20110227145112.GG13726@parisc-linux.org>
References: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35601 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1B0OvO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2011 09:51:14 -0500
Content-Disposition: inline
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Menny_Hamburger@Dell.com
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 27, 2011 at 02:21:58PM +0000, Menny_Hamburger@Dell.com wrote:
> @@ -1502,10 +1502,16 @@
>           set_media_not_present(sdkp);
> 
> -    /*
> -    * We used to set media_present to 0 here to indicate no media
> -    * in the drive, but some drives fail read capacity even with
> -    * media present, so we can't do that.
> -    */
> -    sdkp->capacity = 0; /* unknown mapped to zero - as usual */
> +    if (host_byte(the_result) && !sdkp->first_scan)
> +          sd_printk(KERN_NOTICE, sdkp, "host error while reading capacity\n");

This patch is corrupted ... looks like Exchange has converted tabs
to spaces.

> +    else {
> +          /*
> +          * We used to set media_present to 0 here to indicate no media
> +          * in the drive, but some drives fail read capacity even with
> +          * media present, so we can't do that.
> +          */
> +          sdkp->capacity = 0; /* unknown mapped to zero - as usual */
> +    }
> +
> +    sd_printk(KERN_NOTICE, sdkp, "assuming capacity %llu.\n", sdkp->capacity);
> }
> 
> @@ -1878,6 +1884,11 @@
> 
>      if (!scsi_status_is_good(res)) {
> -          sd_printk(KERN_WARNING, sdkp,
> -                 "Test WP failed, assume Write Enabled\n");
> +          if (host_byte(res) && !sdkp->first_scan) {
> +               sd_printk(KERN_NOTICE, sdkp, "host error while reading write protect flag\n");
> +               set_disk_ro(sdkp->disk, sdkp->write_prot);
> +          }
> +
> +          sd_printk(KERN_WARNING, sdkp, 
> +                 "Test WP failed, assume Write %s\n", (sdkp->write_prot) ? "Disabled" : "Enabled");
>     } else {
>           sdkp->write_prot = ((data.device_specific & 0x80) != 0);
> @@ -2034,8 +2045,14 @@
> 
>  defaults:
> -    sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
> -    sdkp->WCE = 0;
> -    sdkp->RCD = 0;
> -    sdkp->DPOFUA = 0;
> +    if (host_byte(res) && !sdkp->first_scan) 
> +          sd_printk(KERN_NOTICE, sdkp, "host error while reading cache type\n");
> +    else {
> +          sdkp->WCE = 0;
> +          sdkp->RCD = 0;
> +          sdkp->DPOFUA = 0;
> +    }
> +
> +    sd_printk(KERN_ERR, sdkp, "Assuming drive cache: %s\n", 
> +            sd_cache_types[sdkp->RCD + 2*sdkp->WCE]);
> }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
