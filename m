From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/19] sd: Remove a useless comparison
Date: Fri, 25 Aug 2017 17:50:36 +0200
Message-ID: <ad09a3d0-d941-f71e-1c25-cad78cd34357@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-12-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42865 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933662AbdHYPui (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:50:38 -0400
In-Reply-To: <20170823214009.15015-12-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 08/23/2017 11:40 PM, Bart Van Assche wrote:
> This patch avoids that gcc reports the following warning when
> building with W=1:
> 
> drivers/scsi/sd.c:315:10: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
>   if (val >= 0 && val <= T10_PI_TYPE3_PROTECTION)
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8b3d7994e182..7c0f9eb5a5fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -312,7 +312,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
>  	if (err)
>  		return err;
>  
> -	if (val >= 0 && val <= T10_PI_TYPE3_PROTECTION)
> +	if (val <= T10_PI_TYPE3_PROTECTION)
>  		sdkp->protection_type = val;
>  
>  	return count;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
