From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] I/O space write barrier
Date: Fri, 15 Oct 2004 20:31:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041016033120.GA299925@sgi.com>
References: <200409271103.39913.jbarnes@engr.sgi.com> <200409291555.29138.jbarnes@engr.sgi.com> <20040930071541.GA201816@sgi.com> <Pine.LNX.4.60.0409302317590.3449@poirot.grange> <20041016003809.GA299051@sgi.com> <20041016032044.GB16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:42627 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268588AbUJPDbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 23:31:33 -0400
Content-Disposition: inline
In-Reply-To: <20041016032044.GB16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, akpm@osdl.org, Jesse Barnes <jbarnes@engr.sgi.com>, linux-kernel@vger.kernel.org, gnb@sgi.com, linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Sat, Oct 16, 2004 at 04:20:44AM +0100, Matthew Wilcox wrote:
> On Fri, Oct 15, 2004 at 05:38:09PM -0700, Jeremy Higdon wrote:
> > -	(void) RD_REG_WORD(&reg->mailbox4); /* PCI posted write flush */
> > +	/* Enforce mmio write ordering; see comment in qla1280_isp_cmd(). */
> > +	mmiowb();
> 
> I really don't think we want a comment by every mmiowb() explaining what
> it does.  We needed one by the write flush because it had two potential
> meanings, and we didn't want people overoptimising it away.  But mmiowb()
> is clear and unambiguous.

This seems to be a case of not being able to please everyone.
James Bottomley asked for documentation on the usage of mmiowb().
Guennadi asked for one copy of the documentation and the references
to that in other places.

I don't really care that much, but this is the third version of this
patch, where the only difference is comments.  If it's all right, let
this go in, and you can submit patches to change the comments later.

I believe James' idea was that qla1280 would be the "example" driver.

jeremy
