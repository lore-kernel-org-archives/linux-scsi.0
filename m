Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF56DC47420
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 18:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F2220C09
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601402652;
	bh=dYKDtlZVBFAEYzyNeAIl/aBmEqFMgauOZ+HJZn/3x3g=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=aIMArlhyLptQ0uYBxRRlnlTtg2jvcJEQHNAVb4lCpt0mFaLhqh3nGWfJYJCVdeMXA
	 Vab9/ewhMG3XK8J60j80LcGtj8CD/WmTks84Q4zgoy9HzuGVvKcVTi5FmSF+hWkIV2
	 DLDQhoVr97WNC2GHh4Ihl4nO2kuN1nPcrFN6Xlt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgI2SEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 14:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgI2SEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 14:04:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C884220702;
        Tue, 29 Sep 2020 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601402650;
        bh=dYKDtlZVBFAEYzyNeAIl/aBmEqFMgauOZ+HJZn/3x3g=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ljhJvPhYpdoVcbCfZkbjz4dh4TSme2H8BpQaNCRgs5/QHJ+xyaxi+jtk7btKGAcPg
         QIbs7oipm4I+5kLQbNXoNf9SYu84+BwwUtoT2r6czJkx8qAWAH1r3pXnBjcsSCELFi
         iW/pZKljkhsR6NlKy0jad0lGYA45jy8jAgKnhg7A=
Date:   Tue, 29 Sep 2020 20:04:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>,
        Tony Asleson <tasleson@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
Message-ID: <20200929180415.GA1400445@kroah.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929175102.GA1613@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 29, 2020 at 06:51:02PM +0100, Christoph Hellwig wrote:
> Independ of my opinion on the whole scheme that I shared last time,
> we really should not bloat struct device with function pointers.
> 
> On Fri, Sep 25, 2020 at 11:19:18AM -0500, Tony Asleson wrote:
> > Function callback and function to be used to write a persistent
> > durable name to the supplied character buffer.  This will be used to add
> > structured key-value data to log messages for hardware related errors
> > which allows end users to correlate message and specific hardware.
> > 
> > Signed-off-by: Tony Asleson <tasleson@redhat.com>
> > ---
> >  drivers/base/core.c    | 24 ++++++++++++++++++++++++
> >  include/linux/device.h |  4 ++++
> >  2 files changed, 28 insertions(+)

I can't find this patch anywhere in my archives, why was I not cc:ed on
it?  It's a v5 and no one thought to ask the driver core
developers/maintainers about it???

{sigh}

And for log messages, what about the dynamic debug developers, why not
include them as well?  Since when is this a storage-only thing?

> > 
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 05d414e9e8a4..88696ade8bfc 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -2489,6 +2489,30 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
> >  }
> >  EXPORT_SYMBOL_GPL(dev_set_name);
> >  
> > +/**
> > + * dev_durable_name - Write "DURABLE_NAME"=<durable name> in buffer
> > + * @dev: device
> > + * @buffer: character buffer to write results
> > + * @len: length of buffer
> > + * @return: Number of bytes written to buffer
> > + */
> > +int dev_durable_name(const struct device *dev, char *buffer, size_t len)
> > +{
> > +	int tmp, dlen;
> > +
> > +	if (dev && dev->durable_name) {
> > +		tmp = snprintf(buffer, len, "DURABLE_NAME=");
> > +		if (tmp < len) {
> > +			dlen = dev->durable_name(dev, buffer + tmp,
> > +							len - tmp);
> > +			if (dlen > 0 && ((dlen + tmp) < len))
> > +				return dlen + tmp;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dev_durable_name);
> > +
> >  /**
> >   * device_to_dev_kobj - select a /sys/dev/ directory for the device
> >   * @dev: device
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 5efed864b387..074125999dd8 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -614,6 +614,8 @@ struct device {
> >  	struct iommu_group	*iommu_group;
> >  	struct dev_iommu	*iommu;
> >  
> > +	int (*durable_name)(const struct device *dev, char *buff, size_t len);

No, that's not ok at all, why is this even a thing?

Who is setting this?  Why can't the bus do this without anything
"special" needed from the driver core?

We have a mapping of 'struct device' to a unique hardware device at a
specific point in time, why are you trying to create another one?

What is wrong with what we have today?

So this is a HARD NAK on this patch for now.

thanks,

greg k-h
