From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/19] Avoid sign extension of scsi_device.type
Date: Thu, 24 Aug 2017 08:10:49 +0200
Message-ID: <693381a6-aaa6-817a-b205-9da68ac5d160@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751111AbdHXGKv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 02:10:51 -0400
In-Reply-To: <20170823214009.15015-3-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:39 PM, Bart Van Assche wrote:
> This patch avoids that smatch reports the following:
> 
> drivers/scsi/scsi_sysfs.c:506 scsi_bus_uevent() warn: argument 3 to %02x specifier has type 'char'
> drivers/scsi/scsi_sysfs.c:872 sdev_show_modalias() warn: argument 4 to %02x specifier has type 'char'
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  include/scsi/scsi_device.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 0979a5f3b69a..f054f3f43c75 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -111,7 +111,7 @@ struct scsi_device {
>  	unsigned sector_size;	/* size in bytes */
>  
>  	void *hostdata;		/* available to low-level driver */
> -	char type;
> +	unsigned char type;
>  	char scsi_level;
>  	char inq_periph_qual;	/* PQ from INQUIRY data */	
>  	struct mutex inquiry_mutex;
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
