From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] SCSI: Fix potential out-of-bounds access in drivers/scsi/sd.c
Date: Fri, 06 Sep 2013 18:24:11 +0200
Message-ID: <522A01AB.4010508@redhat.com>
References: <Pine.LNX.4.44L0.1309061054390.1165-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab3IFQY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Sep 2013 12:24:27 -0400
In-Reply-To: <Pine.LNX.4.44L0.1309061054390.1165-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Dmitry Vyukov <dvyukov@google.com>, richard@r-senior.demon.co.uk, ltuikov@yahoo.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

Il 06/09/2013 17:49, Alan Stern ha scritto:
> This patch fixes an out-of-bounds error in sd_read_cache_type(), found
> by Google's AddressSanitizer tool.  When the loop ends, we know that
> "offset" lies beyond the end of the data in the buffer, so no Caching
> mode page was found.  In theory it may be present, but the buffer size
> is limited to 512 bytes.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> CC: <stable@vger.kernel.org>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> 
> ---
> 
> 
> [as1709]
> 
> 
>  drivers/scsi/sd.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> Index: usb-3.11/drivers/scsi/sd.c
> ===================================================================
> --- usb-3.11.orig/drivers/scsi/sd.c
> +++ usb-3.11/drivers/scsi/sd.c
> @@ -2419,14 +2419,9 @@ sd_read_cache_type(struct scsi_disk *sdk
>  			}
>  		}
>  
> -		if (modepage == 0x3F) {
> -			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
> -				  "present\n");
> -			goto defaults;
> -		} else if ((buffer[offset] & 0x3f) != modepage) {
> -			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
> -			goto defaults;
> -		}
> +		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
> +		goto defaults;
> +
>  	Page_found:
>  		if (modepage == 8) {
>  			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
> 

