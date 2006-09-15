From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [PATCH] SCSI: Make megaraid_ioctl() check copy_to_user() return value
Date: Fri, 15 Sep 2006 12:26:43 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E37D@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56716 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932138AbWIOS1L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 14:27:11 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org
Cc: "Kolli, Neela" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@steeleye.com

Hi,

On Friday, September 15, 2006 8:43 AM, Jesper Juhl wrote:
> Check copy_to_user() return value in 
> drivers/scsi/megaraid.c::megadev_ioctl()
> This gets rid of this little warning:
>   drivers/scsi/megaraid.c:3661: warning: ignoring return 
> value of 'copy_to_user', declared with attribute warn_unused_result
ACK - Thank you for correction, Jesper. 

Seokmann

> -----Original Message-----
> From: Jesper Juhl [mailto:jesper.juhl@gmail.com] 
> Sent: Friday, September 15, 2006 8:43 AM
> To: linux-kernel@vger.kernel.org
> Cc: Ju, Seokmann; Kolli, Neela; linux-scsi@vger.kernel.org; 
> akpm@osdl.org; James.Bottomley@steeleye.com; jesper.juhl@gmail.com
> Subject: [PATCH] SCSI: Make megaraid_ioctl() check 
> copy_to_user() return value
> 
> 
> Check copy_to_user() return value in 
> drivers/scsi/megaraid.c::megadev_ioctl()
> This gets rid of this little warning:
>   drivers/scsi/megaraid.c:3661: warning: ignoring return 
> value of 'copy_to_user', declared with attribute warn_unused_result
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/scsi/megaraid.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.18-rc7-git1-orig/drivers/scsi/megaraid.c	
> 2006-09-15 13:51:15.121774000 +0200
> +++ linux-2.6.18-rc7-git1/drivers/scsi/megaraid.c	
> 2006-09-15 14:27:32.377407763 +0200
> @@ -3658,8 +3658,9 @@ megadev_ioctl(struct inode *inode, struc
>  			 * Send the request sense data also, 
> irrespective of
>  			 * whether the user has asked for it or not.
>  			 */
> -			copy_to_user(upthru->reqsensearea,
> -					pthru->reqsensearea, 14);
> +			if (copy_to_user(upthru->reqsensearea,
> +					pthru->reqsensearea, 14))
> +				rval = -EFAULT;
>  
>  freemem_and_return:
>  			if( pthru->dataxferlen ) {
> 
> 
> 
> 
