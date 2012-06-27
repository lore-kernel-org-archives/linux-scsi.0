From: walter harms <wharms@bfs.de>
Subject: Re: [patch 1/2 -resend] SCSI: advansys: handle errors from scsi_dma_map()
Date: Wed, 27 Jun 2012 12:01:01 +0200
Message-ID: <4FEAD9DD.8080207@bfs.de>
References: <20120627090055.GD31212@elgon.mountain>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:59829 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab2F0KBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jun 2012 06:01:03 -0400
In-Reply-To: <20120627090055.GD31212@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 27.06.2012 11:00, schrieb Dan Carpenter:
> scsi_dma_map() returns -ENOMEM on error.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Originally sent on Tue, 20 Sep 2011.
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 374c4ed..b2c3a1a 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -8426,6 +8426,12 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>  
>  	/* Build ASC_SCSI_Q */
>  	use_sg = scsi_dma_map(scp);
> +	if (use_sg < 0) {
> +		scsi_dma_unmap(scp);
> +		scp->result = HOST_BYTE(DID_SOFT_ERROR);
> +		return ASC_ERROR;
> +	}
> +
>  	if (use_sg != 0) {
>  		int sgcnt;
>  		struct scatterlist *slp;

Q:if use_sg == 0 a special case ?

re,
 wh

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
