From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 01/17] scsi_dh: return individual errors in scsi_dh_activate()
Date: Thu, 7 May 2015 13:34:33 +0200
Message-ID: <554B4DC9.7020601@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:27456
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751968AbbEGLei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:34:38 -0400
In-Reply-To: <1430743343-47174-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> When calling scsi_dh_activate() we should be returning
> individual errors and not lumping all into one.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/device_handler/scsi_dh.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 155abeab..a4afd30 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -315,9 +315,10 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>
>   	if (!sdev->handler)
>   		goto out_fn;
> +	err = SCSI_DH_NOTCONN;
>   	if (sdev->sdev_state == SDEV_CANCEL ||
>   	    sdev->sdev_state == SDEV_DEL)
> -	    	goto out_fn;
> +		goto out_fn;
>
>   	err = SCSI_DH_DEV_OFFLINED;
>   	if (sdev->sdev_state == SDEV_OFFLINE)
>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
