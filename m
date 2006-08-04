From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] aacraid: Check for unlikely errors
Date: Fri, 4 Aug 2006 16:24:52 +0100
Message-ID: <20060804152452.GC6224@infradead.org>
References: <1154617387.31319.22.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40897 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161205AbWHDPYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Aug 2006 11:24:55 -0400
Content-Disposition: inline
In-Reply-To: <1154617387.31319.22.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Aug 03, 2006 at 08:03:07AM -0700, Mark Haverkamp wrote:
> Received from Mark Salyzyn
> 
> The enclosed patch cleans up some code fragments, adds some paranoia
> (unproven causes of potential driver failures). 
> 
> Signed-off-by: Mark Haverkamp <markh@osdl.org>
> ---
> 
> --- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-07-31 14:33:27.000000000 -0700
> +++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-07-31 14:33:51.000000000 -0700
> @@ -489,6 +489,8 @@
>  	unsigned instance;
>  
>  	fsa_dev_ptr = dev->fsa_dev;
> +	if (!fsa_dev_ptr)
> +		return -ENOMEM;

How could this (and the fsa_dev_ptr in all other places) ever be null?

