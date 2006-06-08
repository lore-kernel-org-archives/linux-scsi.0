From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] aacraid: Fix return code interpretation
Date: Thu, 8 Jun 2006 21:11:29 +0100
Message-ID: <20060608201129.GA21996@infradead.org>
References: <1149785454.22364.16.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5838 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964970AbWFHULd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 16:11:33 -0400
Content-Disposition: inline
In-Reply-To: <1149785454.22364.16.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> @@ -564,7 +564,7 @@
>  		
>  		f = compat_alloc_user_space(sizeof(*f));
>  		ret = 0;
> -		if (clear_user(f, sizeof(*f)) != sizeof(*f))
> +		if (clear_user(f, sizeof(*f)))
>  			ret = -EFAULT;
>  		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
>  			ret = -EFAULT;
> 

just remove the clear_user call completely, it's not needed.

