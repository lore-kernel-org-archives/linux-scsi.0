From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] - 2.4.25-pre5 - sym53c8xx.c
Date: Wed, 21 Jan 2004 13:46:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040121134633.A29605@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703A75BEB@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:41999 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265435AbUAUNqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 08:46:39 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703A75BEB@exa-atlanta.se.lsil.com>; from Emoore@lsil.com on Thu, Jan 15, 2004 at 05:53:51PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: groudier@free.fr, willy@debian.org, linux-scsi@vger.kernel.org, "Stephens, Larry" <larry.stephens@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>

On Thu, Jan 15, 2004 at 05:53:51PM -0500, Moore, Eric Dean wrote:
> Here's a patch for "ODD Byte tape fix" for IBM.
> This is provided by Larry Stephens<lstephen@lsil.com>.

Do you also have a 2.6 version of the fix?

> --- linux-2.4.25-pre5-reference/drivers/scsi/sym53c8xx.c	2004-01-15
> 15:08:26.000000000 -0700
> +++ linux-2.4.25-pre5/drivers/scsi/sym53c8xx.c	2004-01-15
> 15:38:22.000000000 -0700
> @@ -1981,7 +1981,8 @@
>  
>  	u_char		target;
>  	u_char		lun;
> -	u_short		queued;
> +	u_char		queued;
> +	u_char		odd_byte_adjustment;
>  	ccb_p		link_ccb;	/* Host adapter CCB chain	*/
>  	ccb_p		link_ccbh;	/* Host adapter CCB hash chain	*/
>  	XPT_QUEHEAD	link_ccbq;	/* Link to unit CCB queue	*/
> @@ -8184,7 +8185,9 @@
>  	**	Donnot announce negotiations due to auto-sense, 
>  	**	unless user really want us to be verbose. :)
>  	*/
> -	if ( bootverbose < 2 && (cp->host_flags & HF_AUTO_SENSE))
> +	if ( bootverbose < 2 )
> +		goto next;
> +	if ( cp->host_flags & HF_AUTO_SENSE )
>  		goto next;
>  	PRINT_TARGET(np, target);
>  	if (offset) {
> @@ -8356,7 +8359,9 @@
>  	**	Donnot announce negotiations due to auto-sense, 
>  	**	unless user really want us to be verbose. :)
>  	*/
> -	if ( bootverbose < 2 && (cp->host_flags & HF_AUTO_SENSE))
> +	if ( bootverbose < 2 )
> +		goto next;
> +	if ( cp->host_flags & HF_AUTO_SENSE )
>  		goto next;
>  	PRINT_TARGET(np, target);
>  	if (offset) {
> @@ -10690,6 +10695,8 @@
>  		resid += (tmp & 0xffffff);
>  	}
>  
> +	resid -= cp->odd_byte_adjustment;
> +
>  	/*
>  	**	Hopefully, the result is not too wrong.
>  	*/
> @@ -11655,7 +11662,7 @@
>  	/*
>  	**	Remember all informations needed to free this CCB.
>  	*/
> -	cp->to_abort = 0;
> +	cp->to_abort = cp->odd_byte_adjustment = 0;
>  	cp->tag	   = tag;
>  	cp->target = tn;
>  	cp->lun    = ln;
> @@ -12081,13 +12088,21 @@
>  {
>  	struct scr_tblmove *data = &cp->phys.data[MAX_SCATTER-1];
>  	int segment;
> +	unsigned int len = cmd->request_bufflen;
>  
> -	cp->data_len = cmd->request_bufflen;
> -
> -	if (cmd->request_bufflen) {
> +	if (len) {
>  		dma_addr_t baddr = map_scsi_single_data(np, cmd);
>  
> -		SCATTER_ONE(data, baddr, cmd->request_bufflen);
> +		if ( len & 0x01 )  /* odd # of bytes? */
> +		{
> +			tcb_p tp = &np->target[cp->target];
> +			if (tp->wval & EWS)  /* negotiated wide? */
> +			{
> +				len++;
> +				cp->odd_byte_adjustment++;
> +			}
> +		}
> +		SCATTER_ONE(data, baddr, len);
>  		if (CROSS_16MB(baddr, cmd->request_bufflen)) {
>  			cp->host_flags |= HF_PM_TO_C;
>  #ifdef DEBUG_896R1
> @@ -12100,6 +12115,8 @@
>  	else
>  		segment = 0;
>  
> +	cp->data_len = len;
> +
>  	return segment;
>  }
>  
> @@ -12138,6 +12155,15 @@
>  		for (segn = 0; segn < use_sg; segn++) {
>  			dma_addr_t baddr =
> scsi_sg_dma_address(&scatter[segn]);
>  			unsigned int len = scsi_sg_dma_len(&scatter[segn]);
> +			if ( len & 0x01 )  /* odd # of bytes? */
> +			{
> +				tcb_p tp = &np->target[cp->target];
> +				if (tp->wval & EWS)  /* negotiated wide? */
> +				{
> +					len++;
> +					cp->odd_byte_adjustment++;
> +				}
> +			}
>  
>  			SCATTER_ONE(&data[segn],
>  				    baddr,
> @@ -12177,6 +12203,16 @@
>  		for (segment = 0; segment < use_sg; segment++) {
>  			dma_addr_t baddr =
> scsi_sg_dma_address(&scatter[segment]);
>  			unsigned int len =
> scsi_sg_dma_len(&scatter[segment]);
> +			if ( len & 0x01 )  /* odd # of bytes? */
> +			{
> +				tcb_p tp = &np->target[cp->target];
> +				if (tp->wval & EWS)  /* negotiated wide? */
> +				{
> +					len++;
> +					cp->odd_byte_adjustment++;
> +				}
> +			}
> +
>  
>  			SCATTER_ONE(&data[segment],
>  				    baddr,
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

-- 
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
