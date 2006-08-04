From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 2/4] aacraid: Restart adapter on firmware assert
Date: Fri, 04 Aug 2006 08:41:44 -0700
Message-ID: <1154706104.16758.1.camel@markh3.pdx.osdl.net>
References: <1154617371.31319.21.camel@markh3.pdx.osdl.net>
	 <20060804152411.GB6224@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62407 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161249AbWHDPly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2006 11:41:54 -0400
In-Reply-To: <20060804152411.GB6224@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-08-04 at 16:24 +0100, Christoph Hellwig wrote:
> > +	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC) {
> > +		u32 var;
> > +		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
> > +		var = 0;
> > +		if ((aac_rkt_check_health(dev) <= 0)
> > +		 || rkt_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
> > +		  &var, NULL, NULL, NULL, NULL)
> > +		 || (var != 0x00000001)
> > +		 || (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC))
> > +			goto error_iounmap;
> > +	}
> 
> I know you guys hate me for all that nitpicking, but can we write the
> if condition in normal kernel style?  Even better untangle it a little
> and put it into a helper function:

I do check for these things when looking over the patches.  I guess I
missed some this time.  I'll fix it.


-- 
Mark Haverkamp <markh@osdl.org>

