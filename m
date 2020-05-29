Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F33C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 00:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E91B2078C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 00:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qcFPHjYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437630AbgE2AVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 20:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437625AbgE2AVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 20:21:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473F2C08C5C6
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 17:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KWl+6okp+I7EbsxVN5Q76DQ4ade6eqSfrwSj2xZty14=; b=qcFPHjYvIPcMt035AqJpKpHhX7
        SkX735gLq0zlrP9vMezqsQaV0O42zdR4gX8g961yRxBA1sqi9jWz1HkQ9VkguQQk8VN0s7Wmk04/+
        Eo2HK+/OoeKvjhrcyucfhqpbu5TTel3LPmI7Cnj8XnivRpJ/5rHfqwJD+KLXqXB0++0utcvhnrfJ1
        /KHYtK5Wxl+NCVyIH3oDFW5YTUtEYFrPNqykoarDVua6j8+H+5XQ+arYOBwimBskqNNpqO2UL0Rvm
        oTCKPYMGpFyaTyeVobWnSwkSXfcQ8g0V7QBmc4N86A8fuEGD1nM2/mpSaYO/DYD++e3flIEfTrepe
        bkQkb8Xw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeSlc-0002ap-BS; Fri, 29 May 2020 00:20:56 +0000
Date:   Thu, 28 May 2020 17:20:56 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
Message-ID: <20200529002056.GS17206@bombadil.infradead.org>
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
 <c33c3000-caac-4b51-42fd-d6e13a9fd641@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c33c3000-caac-4b51-42fd-d6e13a9fd641@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 28, 2020 at 10:58:31PM +0200, Hannes Reinecke wrote:
> On 5/28/20 8:54 PM, Matthew Wilcox wrote:
> > On Thu, May 28, 2020 at 01:50:02PM -0400, Douglas Gilbert wrote:
> > > On 2020-05-28 12:36 p.m., Hannes Reinecke wrote:
> > > > Use xarray for device lookup by target. LUNs below 256 are linear,
> > > > and can be used directly as the index into the xarray.
> > > > LUNs above 256 have a distinct LUN format, and are not necessarily
> > > > linear. They'll be stored in indices above 256 in the xarray, with
> > > > the next free index in the xarray.
> > 
> > I don't understand why you think this is an improvement over just
> > using an allocating XArray for all LUNs.  It seems like more code,
> > and doesn't actually save you any storage space ... ?
> > 
> The LUN range is 64 bit.
> I was under the impression that xarray can only handle up to unsigned long;
> which probably would work for 64bit systems, but there _are_ users running
> on 32 bit, and they get patently unhappy when we have to tell them 'sorry,
> not for you'.

I meant just use xa_alloc() for everything instead of using xa_insert for
0-255.

