From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: 28 Sep 2004 11:38:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096385921.2008.21.camel@mulgrave>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53168 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267890AbUI1Pio (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 11:38:44 -0400
In-Reply-To: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-28 at 09:58, Anton Blanchard wrote:
> Ive got a 2.6.9-rc2-bk tree from about September 16 which exploded in
> sym_prepare_nego. It turns out sdev is NULL, and scsi_device_dt(sdev)
> causes the trouble.
> 
> A few lines above there is a check for sdev != NULL, so assuming it is
> valid to be NULL add a check before scsi_device_dt() too.
> 
> Anton
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~fix-sym2 drivers/scsi/sym53c8xx_2/sym_hipd.c
> --- gr_work/drivers/scsi/sym53c8xx_2/sym_hipd.c~fix-sym2	2004-09-28 03:03:26.493627814 -0500
> +++ gr_work-anton/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-09-28 03:03:50.247458823 -0500
> @@ -1550,7 +1550,7 @@ static int sym_prepare_nego(hcb_p np, cc
>  	/*
>  	 *  negotiate using PPR ?
>  	 */
> -	if (scsi_device_dt(sdev)) {
> +	if (sdev && scsi_device_dt(sdev)) {
>  		nego = NS_PPR;
>  	} else {
>  		/*

Actually, this patch can't be correct.  We should never be negotiating
with a NULL sdev.  Previously we negotated after slave_alloc, but I've
tried to change the driver to defer negotiation until slave_configure.

What were the messages in the log prior to the NULL deref?  What I'm
trying to understand is how we got to this point.

James


