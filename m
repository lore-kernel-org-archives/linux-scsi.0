From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Tue, 14 Sep 2004 22:55:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914225521.A13440@infradead.org>
References: <1095192761.25727.7.camel@markh1.pdx.osdl.net> <20040914221427.A12989@infradead.org> <1095197861.25727.13.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:29707 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269226AbUINVzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 17:55:25 -0400
Content-Disposition: inline
In-Reply-To: <1095197861.25727.13.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Tue, Sep 14, 2004 at 02:37:41PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, Sep 14, 2004 at 02:37:41PM -0700, Mark Haverkamp wrote:
> On Tue, 2004-09-14 at 14:14, Christoph Hellwig wrote:
> > On Tue, Sep 14, 2004 at 01:12:42PM -0700, Mark Haverkamp wrote:
> > > +	for (; (unique_id < aac_count) && aac_devices[unique_id]; ++unique_id)
> > > +		continue;
> > > +	if (unique_id >= MAXIMUM_NUM_ADAPTERS)
> > > +		goto out;
> > 
> > Do we need an upper limit at all?
> 
> It could be changed to have aac_devices be a **pointer and
> allocate/extend it as devices are added for more than 8 adapters.  Would
> it be worth doing?

What about just using a linked list?  aac_cfg_open isn't exactly a critical
fastpath.

