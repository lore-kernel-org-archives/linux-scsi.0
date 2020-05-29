Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2561AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 11:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EECC4207BC
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 11:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GgxI+rPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgE2LVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 07:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE2LVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 07:21:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E01BC03E969
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2020 04:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y5/O20sLx3fjuyh6Z8r/1D7M4kqvydFDwRj9J3VS02s=; b=GgxI+rPAyk4QPNq3I8QFs8jnTd
        9BN4TIMy4/7/G99e10RW23xG6nbGY9m1qSqgtpuigiU0gi5lmOXeehcPQ+1D1KNaiOA7RNVSyfhEF
        NfEfo5Q2cJ1WB05eClqpeL4mpLZ/tQ63xORqmuvKbxDDcTge5+cdu0UCKCoGg5/CqBOLbN3O1i2LW
        gfYSN0sYlRhCc84QgbAC7fI4T+KtGWTzsBY1egHEv2HHtVN+fDcknmg3DjsgnzNAkK3GFtNboi+oI
        vkn+UOklITR4BGnhcU4OAQjoS5OAEGckCvDHxc7fhqCvvOw77lyG8f4ZI+r5LkDWkE4vtxrtz3Tcg
        zdMcr8AA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jed4W-00068z-4T; Fri, 29 May 2020 11:21:08 +0000
Date:   Fri, 29 May 2020 04:21:07 -0700
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
Message-ID: <20200529112107.GT17206@bombadil.infradead.org>
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
 <c33c3000-caac-4b51-42fd-d6e13a9fd641@suse.de>
 <20200529002056.GS17206@bombadil.infradead.org>
 <8c84ac5f-f64a-0372-5738-fb49f2d01c91@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c84ac5f-f64a-0372-5738-fb49f2d01c91@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 29, 2020 at 08:50:21AM +0200, Hannes Reinecke wrote:
> > I meant just use xa_alloc() for everything instead of using xa_insert for
> > 0-255.
> > 
> But then I'll have to use xa_find() to get to the actual element as the 1:1
> mapping between SCSI LUN and array index is lost.
> And seeing that most storage arrays will expose only up to 256 LUNs I
> thought this was a good improvement on lookup.
> Of course, this only makes sense if xa_load() is more efficient than
> xa_find(). If not then of course it's a bit futile.

xa_load() is absolutely more efficient than xa_find().  It's just a
question of whether it matters ;-)  Carry on ...
