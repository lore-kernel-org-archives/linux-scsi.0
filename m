From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Tue, 14 Sep 2004 14:37:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095197861.25727.13.camel@markh1.pdx.osdl.net>
References: <1095192761.25727.7.camel@markh1.pdx.osdl.net>
	 <20040914221427.A12989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:32727 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S269199AbUINVh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 17:37:57 -0400
In-Reply-To: <20040914221427.A12989@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, 2004-09-14 at 14:14, Christoph Hellwig wrote:
> On Tue, Sep 14, 2004 at 01:12:42PM -0700, Mark Haverkamp wrote:
> > +	for (; (unique_id < aac_count) && aac_devices[unique_id]; ++unique_id)
> > +		continue;
> > +	if (unique_id >= MAXIMUM_NUM_ADAPTERS)
> > +		goto out;
> 
> Do we need an upper limit at all?

It could be changed to have aac_devices be a **pointer and
allocate/extend it as devices are added for more than 8 adapters.  Would
it be worth doing?

> 
> > +	scsi_set_device(shost, &pdev->dev);
> 
> This one is bogus.  scsi_add_host already sets the device.

I'll remove it.

> 
> > @@ -682,6 +693,8 @@
> >  	error = pci_module_init(&aac_pci_driver);
> >  	if (error)
> >  		return error;
> > +	if (!aac_count)
> > +		return -ENODEV;
> 
> This hunk is definitly wrong, 
> 
>  a) want the module stay loaded for hot plugging if explicitly loaded
>     as module
>  b) you're missing an pci driver unregistration here
> 
> So just remove this hunk

OK.


-- 
Mark Haverkamp <markh@osdl.org>

