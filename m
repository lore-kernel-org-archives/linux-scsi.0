From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 32/64 ioctl support (update)
Date: Wed, 16 Jun 2004 18:19:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616171924.GA15925@infradead.org>
References: <1087401137.13488.61.camel@markh1.pdx.osdl.net> <20040616160107.GA14144@infradead.org> <20040616160232.GB14144@infradead.org> <1087405920.13488.82.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:55708 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264215AbUFPRT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:19:26 -0400
Content-Disposition: inline
In-Reply-To: <1087405920.13488.82.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Jun 16, 2004 at 10:12:00AM -0700, Mark Haverkamp wrote:
> On Wed, 2004-06-16 at 09:02, Christoph Hellwig wrote:
> > On Wed, Jun 16, 2004 at 05:01:07PM +0100, Christoph Hellwig wrote:
> > > > +		register_ioctl32_conversion(2131, NULL);
> > > > +#	endif
> > > 
> > > #ifdef please and no additional indentation inside the ifdef please.
> > 
> > btw, what's ioctl2131?  It doesn't seem to be implemented, so no need to translate it.
> 
> Christoph,
> 
> I think that I have addressed all of your comments in this patch.
> 
> removed != 0
> fixed indentation
> fixed include order
> fixed ifdefs
> used compat_alloc_user_space

Although the compat_alloc_user_space implementations I looked at don't fail I
think a check for NULL wouldn't hurt.

> I checked, and 2131 is implemented in aachba.c and looks like it gets
> container info.

Hmm, could we please get a symbolic name for that from adaptec?

> +#ifdef CONFIG_COMPAT
> +/* 
> + * Promote 32 bit apps that call get_next_adapter_fib_ioctl to 64 bit version 
> + */
> +int aac_get_next_adapter_fib_ioctl(unsigned int fd, unsigned int cmd, 
> +		unsigned long arg, struct file *file)

hmm, should probably be static.

> +{
> +	struct fib_ioctl *f;
> +	int retval;
> +
> +	f = compat_alloc_user_space(sizeof(*f));
> +	memset (f, 0, sizeof(*f));

superflous space before the opening brace here.

> +	if (copy_from_user((void *)f, (void *)arg, 
> +				sizeof(struct fib_ioctl) - sizeof(u32)))
> +		return -EFAULT;
> +	retval = sys_ioctl(fd, cmd, (unsigned long)f);
> +	return retval;

No need for retval here.

