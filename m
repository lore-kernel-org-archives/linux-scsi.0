From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ses: Use new scsi VPD helper
Date: Wed, 31 Dec 2008 12:59:38 -0600
Message-ID: <1230749978.3408.128.camel@localhost.localdomain>
References: <1230747167-31677-1-git-send-email-matthew@wil.cx>
	 <1230747167-31677-2-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45678 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281AbYLaS7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2008 13:59:41 -0500
In-Reply-To: <1230747167-31677-2-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Wed, 2008-12-31 at 13:12 -0500, Matthew Wilcox wrote:
> SES had its own code to retrieve VPD from devices; convert it to use the
> new scsi_get_vpd_page helper.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/ses.c |   29 +++--------------------------
>  1 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 7f0df29..95e48ad 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -345,44 +345,21 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
>  	return 0;
>  }
>  
> -#define VPD_INQUIRY_SIZE 36
> -
>  static void ses_match_to_enclosure(struct enclosure_device *edev,
>  				   struct scsi_device *sdev)
>  {
> -	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
> +	unsigned char *buf;
>  	unsigned char *desc;
>  	u16 vpd_len;
>  	struct efd efd = {
>  		.addr = 0,
>  	};
> -	unsigned char cmd[] = {
> -		INQUIRY,
> -		1,
> -		0x83,
> -		VPD_INQUIRY_SIZE >> 8,
> -		VPD_INQUIRY_SIZE & 0xff,
> -		0
> -	};
>  
> +	buf = scsi_get_vpd_page(sdev, 0x83);
>  	if (!buf)
>  		return;
>  
> -	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
> -			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES,
> -			     NULL))
> -		goto free;
> -
> -	vpd_len = (buf[2] << 8) + buf[3];
> -	kfree(buf);
> -	buf = kmalloc(vpd_len, GFP_KERNEL);
> -	if (!buf)
> -		return;
> -	cmd[3] = vpd_len >> 8;
> -	cmd[4] = vpd_len & 0xff;
> -	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
> -			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES, NULL))
> -		goto free;
> +	vpd_len = (buf[2] << 8) | buf[3];

This was actually wrong in the original code.  It should be

pd_len = (buf[2] << 8) | buf[3] + 4;

to account for the header offset in the returned data length.

James


