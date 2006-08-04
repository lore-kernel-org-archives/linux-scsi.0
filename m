From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] aacraid:  interruptible ioctl
Date: Fri, 4 Aug 2006 16:20:09 +0100
Message-ID: <20060804152009.GA6224@infradead.org>
References: <1154617344.31319.20.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11209 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932526AbWHDPUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Aug 2006 11:20:13 -0400
Content-Disposition: inline
In-Reply-To: <1154617344.31319.20.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

> -#include <linux/delay.h>
> +#include <linux/delay.h> /* ssleep prototype */

do we really need that comment?

>  #include <linux/kthread.h>
>  #include <asm/semaphore.h>
>  #include <asm/uaccess.h>
> @@ -140,7 +140,8 @@
>  		fibptr->hw_fib_pa = hw_fib_pa;
>  		fibptr->hw_fib = hw_fib;
>  	}
> -	aac_fib_free(fibptr);
> +	if (retval != -EINTR)
> +		aac_fib_free(fibptr);

even if we are interrupted we shouldn't leak the fib, should we?

