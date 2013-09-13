From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 0/4] Hyper-V TRIM support
Date: Fri, 13 Sep 2013 16:40:53 +0100
Message-ID: <20130913154053.GS5382@dm>
References: <1379077109-29606-1-git-send-email-apw@canonical.com>
 <1379084278.2181.3.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52470 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3IMPk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 11:40:57 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm2so976137wib.10
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 08:40:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1379084278.2181.3.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Ben Howard <ben.howard@canonical.com>, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 07:57:58AM -0700, James Bottomley wrote:

> This is an awful lot of contortions (which don't seem to have any other
> users on the horizon) to support a device that's not standards
> compliant.  What about this, it's simple, it does the right thing and
> it's contained in the driver of the problem device.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 83ec1aa..bd86a4b 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1438,6 +1438,12 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  
>  	sdevice->no_write_same = 1;
>  
> +	/*
> +	 * hyper-v is stupid and lies about its capabilities
> +	 * If we pretend to be SPC-3, we send RC16 which activates trim
> +	 */
> +	sdevice->scsi_level = SCSI_SPC_3;
> +
>  	return 0;
>  }

I will get that tested and see if there are any other negative side effects.

-apw
