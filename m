From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] sd: disable write same for SAT as per the comment
Date: Fri, 26 Feb 2016 12:16:34 -0800
Message-ID: <1456517794.2369.43.camel@HansenPartnership.com>
References: <1456517250-2713-1-git-send-email-me>
	 <56d0b08c.e99c420a.dbca1.0415@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42440 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbcBZUQi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2016 15:16:38 -0500
In-Reply-To: <56d0b08c.e99c420a.dbca1.0415@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com, linux-scsi@vger.kernel.org

On Sat, 2016-02-27 at 04:07 +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1179ec1..9eeee51 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2786,7 +2786,7 @@ static void sd_read_write_same(struct scsi_disk
> *sdkp, unsigned char *buffer)
>  		 * CODES is unsupported and the device has an ATA
>  		 * Information VPD page (SAT).
>  		 */
> -		if (!scsi_get_vpd_page(sdev, 0x89, buffer,
> vpd_buf_len))
> +		if (scsi_get_vpd_page(sdev, 0x89, buffer,
> vpd_buf_len))
>  			sdev->no_write_same = 1;
>  	}


If you're inverting the condition, you'd need to invert the comment as
well.  scsi_get_vpd_page returns 0 on success so !scsi_get_vpd_page is
true if it got the page (which is what the comment says).

James

