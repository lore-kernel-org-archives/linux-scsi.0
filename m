From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Don't blatt first element of prv in sg_chain()
Date: Fri, 11 Jan 2008 10:15:03 +0100
Message-ID: <20080111091503.GN6258@kernel.dk>
References: <200801071538.43371.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23950 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbYAKJPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 04:15:08 -0500
Content-Disposition: inline
In-Reply-To: <200801071538.43371.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jan 07 2008, Rusty Russell wrote:
> I realize that sg chaining is a ploy to make the rest of the kernel
> devs feel the pain of the SCSI subsystem.  But this was a little
> unsubtle.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r b3aec596b841 include/linux/scatterlist.h
> --- a/include/linux/scatterlist.h	Mon Jan 07 12:43:56 2008 +1100
> +++ b/include/linux/scatterlist.h	Mon Jan 07 15:01:51 2008 +1100
> @@ -188,8 +188,8 @@ static inline void sg_chain(struct scatt
>  	/*
>  	 * offset and length are unused for chain entry.  Clear them.
>  	 */
> -	prv->offset = 0;
> -	prv->length = 0;
> +	prv[prv_nents - 1].offset = 0;
> +	prv[prv_nents - 1].length = 0;
>  
>  	/*
>  	 * Set lowest bit to indicate a link pointer, and make sure to clear

Dang, I should have caught that. Thanks Rusty...

-- 
Jens Axboe

