From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup
Date: Mon, 28 Mar 2005 14:04:31 -0800
Message-ID: <1112047471.5560.26.camel@markh1.pdx.osdl.net>
References: <1111430484.9918.9.camel@markh1.pdx.osdl.net>
	 <1112047128.5531.78.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:56784 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262094AbVC1WEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 17:04:36 -0500
In-Reply-To: <1112047128.5531.78.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-03-28 at 15:58 -0600, James Bottomley wrote:
> On Mon, 2005-03-21 at 10:41 -0800, Mark Haverkamp wrote:
> > +	Adaptec 2130S

That was in the TODO file I think.   There isn't a new card supported in
this patch set.

> 
> Why are we getting updated card support in an endian cleanup patch?
> 
> > +/*
> > + * Some configurations of BE Linux have writel and readl automatically perform
> > + * byte swapping, and some configurations (embedded) do not. Typically
> > + * AAC_IO_USES_CPU_ORDER needs to be defined since most BE ports are working
> > + * with drivers that have not been coded to support BE.
> > + */
> > +#define AAC_IO_USES_CPU_ORDER 1
> > +#ifdef AAC_IO_USES_CPU_ORDER
> > +# define aac_io_le32_to_cpu
> > +# define aac_io_cpu_to_le16
> > +# define aac_io_cpu_to_le32
> > +#else
> > +# define aac_io_le32_to_cpu le32_to_cpu
> > +# define aac_io_cpu_to_le16 cpu_to_le16
> > +# define aac_io_cpu_to_le32 cpu_to_le32
> > +#endif
> 
> What exactly is this for?  I know of no platforms that implement readl
> and friends incorrectly, so all of this should be unnecessary.

I wondered about this.  Mark S. thought that there were some.  If there
aren't, I can remove all that code.

Mark.


> 
> James
> 
-- 
Mark Haverkamp <markh@osdl.org>

