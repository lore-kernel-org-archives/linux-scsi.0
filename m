From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] sd: assign appropriate log level
Date: Mon, 17 Oct 2016 10:19:10 -0700
Message-ID: <1476724750.2734.20.camel@linux.vnet.ibm.com>
References: <20161017165108.29718-4-davsingl@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36386 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933255AbcJQRTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 13:19:20 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9HHFneP016294
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 13:19:19 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2651gvv2a0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 13:19:19 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Mon, 17 Oct 2016 11:19:18 -0600
In-Reply-To: <20161017165108.29718-4-davsingl@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Singleton <davsingl@cisco.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shikhar Dogra <shidogra@cisco.com>, xe-kernel@external.cisco.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2016-10-17 at 09:51 -0700, David Singleton wrote:
> From: Shikhar Dogra <shidogra@cisco.com>
> 
> Reduce chatter on console for usb hotplug.
> KERN_ERR is too high severity for these messages, moving them
> to KERN_WARNING

It's an error because we have several USB to IDE bridges that have
write back cache drives but report nothing to the caching mode page. 
 For them this is a serious error because their data integrity is at
risk.  I'm open to other ways to fix your problem, but downgrading the
message severity because *you* don't have an issue would mask the
problem for others, so it's not really viable.

> USB devices never have a Caching Mode page, it doesn't make
> sense to make it an error when you have tons of USB devices where
> the print is useless, and not an error.
> 
> For second message, the condition is not an error. The existing
> workaround of assuming a write through cache doesn't limit
> functionality in any way.

Yes, it does if the cache is actually write back ...

James


> Cc: xe-kernel@external.cisco.com
> Signed-off-by: Shikhar Dogra <shidogra@cisco.com>
> Signed-off-by: David Singleton <davsingl@cisco.com>
> ---
>  drivers/scsi/sd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 51e5629..ab7bfe3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2540,7 +2540,7 @@ sd_read_cache_type(struct scsi_disk *sdkp,
> unsigned char *buffer)
>  			}
>  		}
>  
> -		sd_first_printk(KERN_ERR, sdkp, "No Caching mode
> page found\n");
> +		sd_first_printk(KERN_WARNING, sdkp, "No Caching mode
> page found\n");
>  		goto defaults;
>  
>  	Page_found:
> @@ -2594,7 +2594,7 @@ sd_read_cache_type(struct scsi_disk *sdkp,
> unsigned char *buffer)
>  				"Assuming drive cache: write
> back\n");
>  		sdkp->WCE = 1;
>  	} else {
> -		sd_first_printk(KERN_ERR, sdkp,
> +		sd_first_printk(KERN_WARNING, sdkp,
>  				"Assuming drive cache: write
> through\n");
>  		sdkp->WCE = 0;
>  	}

