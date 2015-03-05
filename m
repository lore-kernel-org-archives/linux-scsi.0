From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] scsi: proper state checking and module refcount handling
 in scsi_device_get
Date: Thu, 05 Mar 2015 14:36:20 +0100
Message-ID: <54F85BD4.200@redhat.com>
References: <1422882086-1863-1-git-send-email-hch@lst.de> <1422882086-1863-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34447 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbCENg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 08:36:27 -0500
Received: by lbiv13 with SMTP id v13so32667420lbi.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2015 05:36:26 -0800 (PST)
In-Reply-To: <1422882086-1863-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>



On 02/02/2015 14:01, Christoph Hellwig wrote:
> This effectively reverts commits 85b6c7 ("[SCSI] sd: fix cache flushing on
> module removal (and individual device removal)" and dc4515ea ("scsi: always
> increment reference count").
> 
> We now never call scsi_device_get from the shutdown path, and the fact
> that we started grabbing reference there in commit 85b6c7 turned out
> turned out to create more problems than it solves, and required
> workarounds for workarounds for workarounds. Move back to properly checking
> the device state and carefully handle module refcounting.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9b38299..9b7fd0b 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -979,18 +979,24 @@ EXPORT_SYMBOL(scsi_report_opcode);
>   * Description: Gets a reference to the scsi_device and increments the use count
>   * of the underlying LLDD module.  You must hold host_lock of the
>   * parent Scsi_Host or already have a reference when calling this.
> + *
> + * This will fail if a device is deleted or cancelled, or when the LLD module
> + * is in the process of being unloaded.
>   */
>  int scsi_device_get(struct scsi_device *sdev)
>  {
> -	if (sdev->sdev_state == SDEV_DEL)
> -		return -ENXIO;
> +	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
> +		goto fail;
>  	if (!get_device(&sdev->sdev_gendev))
> -		return -ENXIO;
> -	/* We can fail try_module_get if we're doing SCSI operations
> -	 * from module exit (like cache flush) */
> -	__module_get(sdev->host->hostt->module);
> -
> +		goto fail;
> +	if (!try_module_get(sdev->host->hostt->module))
> +		goto fail_put_device;
>  	return 0;
> +
> +fail_put_device:
> +	put_device(&sdev->sdev_gendev);
> +fail:
> +	return -ENXIO;
>  }
>  EXPORT_SYMBOL(scsi_device_get);
>  
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
