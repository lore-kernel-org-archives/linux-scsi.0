Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612FFC2D0ED
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A1B4206E6
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="etdXQcPb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgC0RAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:00:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0RAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y4jqMXMuSCLjtxZfZUroyV7Ldlb0usNsMs0ZoH+IuWE=; b=etdXQcPbKq+hMTQy1uJbrj3Dwy
        S43mHrDmjodUSCeE2wcyLdiTBbZJji4+WjPE4HUq2bPN515bISs4fQbf8iy6g0GnC/kLmQW2umQoC
        MMfuXv8wpvN7PtMkMYIwpWJvRGQiwaX1yPIpaph27QJWiwOSxDnwSbMAQjDDsV452yNDgMra3H2br
        HJZU6dXL+GOF5RIelMf0M3qQXd0XOSSLEIN61bYpPNgi7M0qZjp8iQxaFKDqzCCUi5yYZQRjdIg7S
        R+6EFzJShR0M2/KGokbmRcDYGxefBu/VbHisjiZ965IiOWNK1hBiGOpezrfse89/d53XlYXi4+ZO5
        cdtm2WfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHsLf-00084s-Sa; Fri, 27 Mar 2020 17:00:47 +0000
Date:   Fri, 27 Mar 2020 10:00:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v9 01/11] block: Keyslot Manager for Inline Encryption
Message-ID: <20200327170047.GA24682@infradead.org>
References: <20200326030702.223233-1-satyat@google.com>
 <20200326030702.223233-2-satyat@google.com>
 <20200326062213.GF858@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326062213.GF858@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 25, 2020 at 11:22:13PM -0700, Eric Biggers wrote:
> > +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> > +	/* Inline crypto capabilities */
> > +	struct blk_keyslot_manager *ksm;
> > +#endif
> 
> I do still wonder whether the concept of inline crypto support should be more
> separated from keyslot management, to be better prepared for device-mapper
> passthrough support and for hardware that accepts keys directly.  (Such hardware
> exists, though I'm not sure support for it will be upstreamed.)  For example,
> the crypto capabilities could be stored in a 'struct blk_crypto_capabilities'
> rather than in 'struct blk_keyslot_manager', and the latter could be optional.
> 
> What you have now is fine for the functionality in the current patchset though,
> so I'm not really complaining.  Just something to think about.

I'd rather keep things simple (aka as-is) for now.  If needed we can
change it. I doubt we'll even have a handful drivers with inline
crypto in the next years..
