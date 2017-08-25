From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/19] Convert a strncmp() call into a strcmp() call
Date: Fri, 25 Aug 2017 17:43:06 +0200
Message-ID: <65196798-05ca-93c9-4519-58d0b58e8305@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42193 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933598AbdHYPnI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:43:08 -0400
In-Reply-To: <20170823214009.15015-5-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:39 PM, Bart Van Assche wrote:
> This patch avoids that smatch reports the following warning:
> 
> drivers/scsi/scsi_sysfs.c:117: check_set() error: strncmp() '"-"' too small (2 vs 20)
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 41891db20108..5ed473a87589 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -114,7 +114,7 @@ static int check_set(unsigned long long *val, char *src)
>  {
>  	char *last;
>  
> -	if (strncmp(src, "-", 20) == 0) {
> +	if (strcmp(src, "-") == 0) {
>  		*val = SCAN_WILD_CARD;
>  	} else {
>  		/*
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
