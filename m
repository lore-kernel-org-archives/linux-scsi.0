From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] MegaRAID SAS: Raidcard hotswap wouldn't work if the
 device's fd is held in userspace
Date: Fri, 28 Apr 2017 15:34:01 +0200
Message-ID: <0b77c7e5-3d44-7090-3379-75bf258f6b61@suse.de>
References: <1493372584-1204-1-git-send-email-johnzzpcrystal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48921 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1165489AbdD1NeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 09:34:08 -0400
In-Reply-To: <1493372584-1204-1-git-send-email-johnzzpcrystal@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhou Zhengping <johnzzpcrystal@gmail.com>, linux-scsi@vger.kernel.org

On 04/28/2017 11:43 AM, Zhou Zhengping wrote:
>     When a scsi_device is unpluged from scsi controller, if the
> scsi_device is still be used by application layer,it won't be
> released until users release it. In this case, scsi_device_remove just set
> the scsi_device's state to be SDEV_DEL. But if you plug the disk
> just before the old scsi_device is released, then there will be two
> scsi_device structures in scsi_host->__devices. when the next unpluging
> event happens,some low-level drivers will check whether the scsi_device
> has been added to host (for example, the megaraid sas series controller)
> by calling scsi_device_lookup(call __scsi_device_lookup) in function
> megasas_aen_polling.__scsi_device_lookup will return the first scsi_device.
> Because its state is SDEV_DEL, the scsi_device_lookup will return NULL finally,
> making the low-level driver assume that the scsi_device has been
> removed,and won't call scsi_device_remove,which will lead the
> failure of hot swap.
> 
> Signed-off-by: Zhou Zhengping <johnzzpcrystal@gmail.com>
> Tested-and-reported-by: Zeng Rujia <ZengRujia@sangfor.com.cn>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=195607
> ---
>  drivers/scsi/scsi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 61c82a3..b455619 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1262,6 +1262,8 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
>  	struct scsi_device *sdev;
>  
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +		if (sdev->sdev_state == SDEV_DEL)
> +			continue;
>  		if (sdev->channel == channel && sdev->id == id &&
>  				sdev->lun ==lun)
>  			return sdev;
> 
Actually this is a similar to 2aeef605aa0 ("[SCSI] Skip deleted devices
in __scsi_device_lookup_by_target()")
Well spotted.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
