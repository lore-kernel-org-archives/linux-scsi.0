From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Thu, 27 Aug 2009 23:45:31 +0000
Message-ID: <1251416731.27356.8.camel@mulgrave.site>
References: <4A92BE18.50208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37111 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZH0Xpg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 19:45:36 -0400
In-Reply-To: <4A92BE18.50208@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Mon, 2009-08-24 at 18:21 +0200, Roel Kluin wrote:
> kmalloc() may fail, so test whether it succeeded.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2de5f3a..34fdde0 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1056,6 +1056,9 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
>  
>  	kfree(buf);
>  	buf = kmalloc(len + 4, GFP_KERNEL);
> +	if (!buf)
> +		return NULL;
> +

Firstly, this won't actually apply ... you should be developing against
either the SCSI trees or linux-next to get the latest versions in git.

Secondly it's not really right for the most common use cases, which
don't usually want the whole vpd buffer anyway.  I don't really see a
simple way of fixing it without altering the interface, though.

James

---



