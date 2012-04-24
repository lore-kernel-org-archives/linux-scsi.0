From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC v2] [SCSI] atp870u: Fix bad use of udelay
Date: Tue, 24 Apr 2012 14:18:50 -0700
Message-ID: <20120424141850.e5cdf6c2.akpm@linux-foundation.org>
References: <200901092028.n09KSAeI024551@imap1.linux-foundation.org>
	<20090109205835.GB5069@deprecation.cyrius.com>
	<20090109130308.bfde281e.akpm@linux-foundation.org>
	<1231536107.3235.50.camel@localhost.localdomain>
	<20120424074916.GA25261@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab2DXVSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2012 17:18:53 -0400
In-Reply-To: <20120424074916.GA25261@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Martin Michlmayr <tbm@cyrius.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Tue, 24 Apr 2012 02:49:16 -0500
Jonathan Nieder <jrnieder@gmail.com> wrote:

> From: Martin Michlmayr <tbm@cyrius.com>
> 
> The ACARD driver calls udelay() with a value > 2000, which leads to
> to the following compilation error on ARM:
>   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>
> ...
>
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -1173,7 +1173,16 @@ wait_io1:
>  	outw(val, tmport);
>  	outb(2, 0x80);
>  TCM_SYNC:
> -	udelay(0x800);
> +	/*
> +	 * The funny division into multiple delays is to accomodate
> +	 * arches like ARM where udelay() multiplies its argument by
> +	 * a large number to initialize a loop counter.  To avoid
> +	 * overflow, the maximum supported udelay is 2000 microseconds.
> +	 *
> +	 * XXX it would be more polite to find a way to use msleep()
> +	 */
> +	mdelay(2);
> +	udelay(48);
>  	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
>  		outw(0, tmport--);
>  		outb(0, tmport);

Fair enough, I say.  Looking at this driver, I do think it's best to
minimally fix the build and then tiptoe away very delicately lest
something explode.

That being said, I'm glad the kernel has a function called "fun_scam".
