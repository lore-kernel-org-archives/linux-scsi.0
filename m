From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V2] SCSI: Add runtime pm in the sd_check_events()
Date: Mon, 20 Feb 2012 21:06:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202202106210.17444-100000@netrider.rowland.org>
References: <1329788086-17820-1-git-send-email-tianyu.lan@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:37260 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754997Ab2BUCG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 21:06:59 -0500
In-Reply-To: <1329788086-17820-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Tue, 21 Feb 2012, Lan Tianyu wrote:

> The sd_check_event() will be called periodly even when the device is in
> the suspended status to check media event. The scsi_test_unit_ready() in
> the sd_check_event() will issue scsi cmd request. Issuing scsi request when
> the device is in the suspeneded status will cause problem. For example, when
> a usb flash disk in the suspended status, scsi_test_unit_ready() issues a
> scsi request. The request will be returned as failed because the usb device
> is not active. The patch adds scsi_autopm_get_device() and scsi_autopm_put_device()
> around scsi_test_unit_ready() in the sd_check_event() to resolve such problem.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/scsi/sd.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..2d18aa9 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1182,9 +1182,14 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  	retval = -ENODEV;
>  
>  	if (scsi_block_when_processing_errors(sdp)) {
> +		retval = scsi_autopm_get_device(sdp);
> +		if (retval)
> +			goto out;
> +
>  		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
>  		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
>  					      sshdr);
> +		scsi_autopm_put_device(sdp);
>  	}
>  
>  	/* failed to execute TUR, assume media not present */

Acked-by: Alan Stern <stern@rowland.harvard.edu>

