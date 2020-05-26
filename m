Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11B1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 18:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3622073B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 18:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lBItXttT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388499AbgEZSj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 14:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgEZSj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 14:39:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D43C03E96D
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2020 11:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i70/VeKkFNWOCOEr/ho6wQPtJ8yKUGRxXhfcAK1Pcp8=; b=lBItXttT/czFaIsBYNdI8km5Wo
        +QvxFPIEj3Bm7A6gUnx+cLnkHJoK3HTk+tWGtlsIACSSsznIEgXpRWE9R6YV7qDwf0NdGyL/OQBeQ
        IqcCB91spjDy1MIbEsEWy3Onc4mdcY4gaAEY/I/I/m8KTjd7eKPNipqRJEIg0z2WR6JoB3K09BYDZ
        B+yZI8TPu4jkdbCcCx1XXPypCcPd7gMowuQixuQsmZep9lXvchS5J+dFJGHjyTwdjaVvUenzgjdXR
        fVGhm2cLD2JyQijPwdDZXB+RFKNjcJd+oznHXjSBMh0E/oF+bdLl0VkzXEB4Wix/sHGlJb/xAwi9H
        e0QBG6hg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdeTw-0006uX-Gp; Tue, 26 May 2020 18:39:20 +0000
Date:   Tue, 26 May 2020 11:39:20 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
Message-ID: <20200526183920.GI17206@bombadil.infradead.org>
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
 <825bece5-e209-a4da-ddb1-809c48e4e9b3@suse.de>
 <20200526142727.GH17206@bombadil.infradead.org>
 <b14bdfa1-1cb9-6e3f-c025-fccdfa034024@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b14bdfa1-1cb9-6e3f-c025-fccdfa034024@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 26, 2020 at 07:53:35PM +0200, Hannes Reinecke wrote:
> On 5/26/20 4:27 PM, Matthew Wilcox wrote:
> > Ah, OK.  I think for these arrays you'd be better off accepting the cost
> > of an extra 4 bytes in the struct scsi_device rather than the cost of
> > storing the scsi_device at the LUN.
> > 
> > Let's just work an example where you have a 64-bit LUN with 4 ranges,
> > each of 64 entries (this is almost a best-case scenario for the XArray).
> > [0,63], 2^62+[0,63], 2^63+[0,63], 2^63+2^62+[0,63].
> > 
> > If we store them sequentially in an allocating XArray, we take up 256 *
> > 4 bytes = 1kB extra space in the scsi_device.  The XArray will allocate
> > four nodes plus one node to hold the four nodes, which is 5 * 576 bytes
> > (2780 bytes) for a total of 3804 bytes.
> > 
> > Storing them in at their LUN will allocate a top level node which covers
> > bits 60-66, then four nodes, each covering bits of 54-59, another four
> > nodes covering bits 48-53, four nodes for 42-47, ...  I make it 41 nodes,
> > coming to 23616 bytes.  And the pointer chase to get to each LUN is
> > ten deep.  It'll mostly be cached, but still ...
> > 
> Which is my worry, too.
> In the end we're having a massively large array space (128bit if we take the
> numbers as they stand today), of which only a _tiny_ fraction is actually
> allocated.

In your scheme, yes.  Do you ever need to look up scsi_device from
a scsi_host with only the C:T:L as a key (and it's a situation where
speed matters)?  Everything I've seen so far is about iterating every
sdev in an shost, but maybe this is a "when you have a hammer" situation.

> We can try to reduce the array space by eg. restricting channels and targets
> to be 16 bits, and the LUN to be 32 bits.
> But then we'll be having a hard time arguing; "Hey, we have a cool new
> feature, which has a really nice interface, but we can't support the same
> set of devices as we have now...".
> That surely will go down well.

But using the allocating XArray will outperform both the linked list and
the direct-store XArray that you're proposing.

> Maybe one should look at using an rbtree directly; _that_ could be made to
> work with an 128bit index, and lookup should be fast, too.
> Let's see.

The rbtree is even worse than the linked list if your primary API is
"iterate all objects".

