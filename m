From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/8] scsi: don't use scsi_next_command in scsi_reset_provider
Date: Wed, 01 Oct 2014 14:03:45 +0200
Message-ID: <542BEDA1.3070003@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:37897 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJAMDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:03:48 -0400
In-Reply-To: <1410107469-896-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> scsi_reset_provider already manually runs all queues for the given host,
> so it doesn't need the scsi_run_queues call from it, and it doesn't need
> a reference on the device because it's synchronous.
>
> So let's just call scsi_put_command directly and avoid the device reference
> dance to simplify the code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_error.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 6b20ef3..14cece9 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2317,15 +2317,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>   	if (scsi_autopm_get_host(shost) < 0)
>   		return FAILED;
>
> -	if (!get_device(&dev->sdev_gendev)) {
> -		rtn = FAILED;
> -		goto out_put_autopm_host;
> -	}
> -
>   	scmd = scsi_get_command(dev, GFP_KERNEL);
>   	if (!scmd) {
>   		rtn = FAILED;
> -		put_device(&dev->sdev_gendev);
>   		goto out_put_autopm_host;
>   	}
>
> @@ -2381,10 +2375,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>   			     "waking up host to restart after TMF\n"));
>
>   	wake_up(&shost->host_wait);
> -
>   	scsi_run_host_queues(shost);
>
> -	scsi_next_command(scmd);
> +	scsi_put_command(scmd);
>   out_put_autopm_host:
>   	scsi_autopm_put_host(shost);
>   	return rtn;

This patch looks fine to me.

A minor nit: if this patch has to be resent, please insert a blank line 
above the out_put_autopm_host label.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
