From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi_dh_alua: fix meory leak in alua_rtpg()
Date: Thu, 29 Sep 2016 13:20:02 -0700
Message-ID: <34d91218-a0a4-85aa-2771-025504fb267b@sandisk.com>
References: <1474193111-6396-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0085.outbound.protection.outlook.com ([104.47.40.85]:39231
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755742AbcI2UUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 16:20:16 -0400
In-Reply-To: <1474193111-6396-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tang.junhui@zte.com.cn, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

On 09/18/2016 03:05 AM, tang.junhui@zte.com.cn wrote:
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

That's a good catch, but please cc stable for this patch. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
