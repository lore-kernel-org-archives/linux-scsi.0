From: Mark Haverkamp <markh@osdl.org>
Subject: Re: PATCH: fix crashes with aacraid
Date: Mon, 03 Jan 2005 09:05:21 -0800
Message-ID: <1104771922.21673.4.camel@markh1.pdx.osdl.net>
References: <1104158617.20952.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:35512 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261500AbVACRF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2005 12:05:26 -0500
In-Reply-To: <1104158617.20952.51.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2004-12-27 at 14:43 +0000, Alan Cox wrote:
> Is this change still needed for 2.6.10  Mark ?

I thought that the consensus was to remove aac_handle_aif altogether
like the patch sent in by Tom Coughlan on Dec. 8th.

Mark


> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.10/drivers/scsi/aacraid/commsup.c linux-2.6.10/drivers/scsi/aacraid/commsup.c
> --- linux.vanilla-2.6.10/drivers/scsi/aacraid/commsup.c	2004-12-25 21:14:35.000000000 +0000
> +++ linux-2.6.10/drivers/scsi/aacraid/commsup.c	2004-12-26 18:53:37.261691936 +0000
> @@ -781,6 +781,7 @@
>  static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
>  {
>  	struct hw_fib * hw_fib = fibptr->hw_fib;
> +#if 0	
>  	/*
>  	 * Set the status of this FIB to be Invalid parameter.
>  	 *
> @@ -788,6 +789,8 @@
>  	 */
>  	*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
>  	fib_adapter_complete(fibptr, sizeof(u32));
> +	/* This will be done on our return */
> +#endif
>  }
>  
>  /**
-- 
Mark Haverkamp <markh@osdl.org>

