From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scsi: Fix bad use of udelay in atp870u.c
Date: Thu, 16 Oct 2008 15:51:35 -0700
Message-ID: <20081016155135.8fc411ae.akpm@linux-foundation.org>
References: <20081016082146.GA18535@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072AbYJPWw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2008 18:52:29 -0400
In-Reply-To: <20081016082146.GA18535@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, linux-arm-kernel@lists.arm.linux.org.uk

On Thu, 16 Oct 2008 10:21:46 +0200
Martin Michlmayr <tbm@cyrius.com> wrote:

> The ACARD driver calls udelay() with a value > 2000, which leads to
> to the following compilation error on ARM:
>   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
>   make[1]: *** [__modpost] Error 1
> Fix this by using a combination of mdelay and udelay.
> 
> Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
> 
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -1171,7 +1171,8 @@ wait_io1:
>  	outw(val, tmport);
>  	outb(2, 0x80);
>  TCM_SYNC:
> -	udelay(0x800);
> +	mdelay(2);
> +	udelay(48);
>  	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
>  		outw(0, tmport--);
>  		outb(0, tmport);
> 

hum.  The code has been like that for many years - why was the
error only discovered now.  Is that check in arm new?

If so, was it present in 2.6.27?
  If so, does anyone actually use this driver on arm?
    If so, we'll need this patch in 2.6.27.x as well.

?
