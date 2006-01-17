From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/1] sg: Remove aha1542 hack
Date: Wed, 18 Jan 2006 09:34:54 +1000
Message-ID: <43CD7F1E.8010908@torque.net>
References: <200601172304.k0HN46YN013092@d01av04.pok.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:29157 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932275AbWAQXeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 18:34:21 -0500
In-Reply-To: <200601172304.k0HN46YN013092@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

brking@us.ibm.com wrote:
> Remove a hack in the sg driver that alters the total buffer
> length for SG_IO commands to ensure buffers are not odd byte
> lengths. This breaks on the ipr driver since it requires the
> request_bufflen to equal the length specified in the cdb.
> The block layer SG_IO code does not appear to have this hack.

Brian,
Yes, that is ok with me. The aha1542 may not be
the only adapter sensitive to odd data transfer
lengths. In the spirit of a pass through we can
let the user round up to even if it is needed.

The _original_ block layer SG_IO code didn't have
a "hack" called error processing either :-)

The ipr driver looking inside the cdb to determine
data transfer length is a dangerous procedure. Does
the ipr driver support vendor specific commands?
Even the ubiquitous INQUIRY cdb is tricky since byte 3
became the upper 8 bits of the allocation length in
SPC-3 (it was reserved before that). So does the
driver interpret it as active depending on the age
of the lu?

Signed-off-by: Douglas Gilbert <dougg@torque.net>

> Signed-off-by: Brian King <brking@us.ibm.com>
> ---
> 
>  linux-2.6-bjking1/drivers/scsi/sg.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/sg.c~sg_remove_aha1542_hack drivers/scsi/sg.c
> --- linux-2.6/drivers/scsi/sg.c~sg_remove_aha1542_hack	2006-01-17 16:50:16.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/sg.c	2006-01-17 16:50:29.000000000 -0600
> @@ -2162,7 +2162,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request 
>  
>  	srp->res_used = 1;
>  	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
> -	rem = size = (size + 1) & (~1);	/* round to even for aha1542 */
> +	rem = size;
>  
>  	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
>  		num = sg->length;
> _
> 

