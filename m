From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: fix meory leak in alua_rtpg()
Date: Fri, 30 Sep 2016 08:30:26 +0200
Message-ID: <b203ec37-64d1-c771-09ac-3ff3c3ee784d@suse.de>
References: <1474193111-6396-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54263 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964848AbcI3Gad (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 02:30:33 -0400
In-Reply-To: <1474193111-6396-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

On 09/18/2016 12:05 PM, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> buff should be freed before returning with SCSI_DH_RETRY in alua_rtpg().
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 752b5c9..241829e 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -583,6 +583,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
>  				    ALUA_DH_NAME);
>  			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> +			kfree(buff);
>  			return err;
>  		}
>  		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
>
Correct.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
