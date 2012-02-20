From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/1] SCSI: Add rumtime pm in the sd_check_events()
Date: Mon, 20 Feb 2012 15:41:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202201538500.11040-100000@netrider.rowland.org>
References: <1329727760-6467-1-git-send-email-tianyu.lan@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42198 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753312Ab2BTUlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 15:41:53 -0500
In-Reply-To: <1329727760-6467-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Mon, 20 Feb 2012, Lan Tianyu wrote:

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
>  drivers/scsi/sd.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..7913bd1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1183,8 +1183,14 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  
>  	if (scsi_block_when_processing_errors(sdp)) {
>  		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
> +
> +		retval = scsi_autopm_get_device(sdp);
> +		if (retval)
> +			goto out;
> +
>  		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
>  					      sshdr);
> +		scsi_autopm_put_device(sdp);
>  	}
>  
>  	/* failed to execute TUR, assume media not present */

You might as well put the _get_device call before the kzalloc; no point 
in allocating memory if it's not going to be used.

Apart from that, this is fine.  Are there any other places where the
block layer sends I/O requests even when the device isn't open?

Alan Stern

