From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 3/3] scsi: consolidate checking for VPD pages
Date: Mon, 20 Jun 2016 09:26:10 -0400
Message-ID: <1466429170.4039.16.camel@localhost.localdomain>
References: <1466405868-87720-1-git-send-email-hare@suse.de>
	 <1466405868-87720-4-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbcFTN0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 09:26:11 -0400
In-Reply-To: <1466405868-87720-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, 2016-06-20 at 08:57 +0200, Hannes Reinecke wrote:
> scsi_get_vpd_page() has a check for 'skip_vpd_pages'. However,
> this is not sufficient to test if the device really supports
> VPD pages. At the same time, most sites were already calling
> scsi_device_supports_vpd() prior to calling this function.
> So this patchs updates all callers to use scsi_device_supports_vpd()
> prior to calling scsi_get_vpd_page() and remove the check
> to skip_vpd_pages.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi.c               | 5 ++---
>  drivers/scsi/scsi_transport_sas.c | 3 ++-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1ff4a0b..f054878 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -727,15 +727,14 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>   * to a buffer containing the data from that page.  The caller is
>   * responsible for calling kfree() on this pointer when it is no longer
>   * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
> + * The caller is responsible for checking if the device supports VPD
> + * pages prior to calling this function.
>   */
>  int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
>  		      int buf_len)
>  {
>  	int i, result;
>  
> -	if (sdev->skip_vpd_pages)
> -		goto fail;
> -
>  	/* Ask for all the pages supported by this device */
>  	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
>  	if (result < 4)
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 3f0ff07..b2616eb 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -412,7 +412,8 @@ sas_tlr_supported(struct scsi_device *sdev)
>  	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
>  	int ret = 0;
>  
> -	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
> +	if (!scsi_device_supports_vpd(sdev) ||
> +	    scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
>  		goto out;
>  
>  	/*

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


