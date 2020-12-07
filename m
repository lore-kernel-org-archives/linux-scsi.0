Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A220C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2B623407
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgLGNfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgLGNfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 08:35:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E85C0613D0;
        Mon,  7 Dec 2020 05:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vz8klrd5u3Eczk/bz00opfwI6AtR7j0+zJaT2Oj/rwE=; b=UrD1fB03ukaSZOIb7lhtu4sxE5
        J/Ya6Ub1V7vaI58Ltke71TIwp2jyHc0U1ok3gCpM2hnLj9kga+BJ06E9XpY34TDNi4PDbW4XEEjjM
        x5L7Qrr1TthTXu6e5xS/g3qD/aCn2YVeKsD/C25f106947sXx08NYJNScMMrpe59yss0mjDq0L2gW
        KD0MIk38gQfYuxmweGFOqO23uwyw3o7FMYZN6R2j3IghR73xT2yHme/ct7fS/rbzBv0GXMxc8TaqQ
        qo9uAfdg6fUTaMoRwnuCeA5EzBgT0zA25r0UqPMQjGbE53DsbhWYD0lZd6q5ktrgfiESlRsmn+4j3
        YKN+wqRA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmGeu-0007Wf-AD; Mon, 07 Dec 2020 13:34:32 +0000
Date:   Mon, 7 Dec 2020 13:34:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/3] block: make __blkdev_issue_zero_pages() less
 confusing
Message-ID: <20201207133432.GA28592@infradead.org>
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <20201206055332.3144-2-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206055332.3144-2-tom.ty89@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 06, 2020 at 01:53:31PM +0800, Tom Yan wrote:
> Instead of using the same check for the two layers of loops, count
> bio pages in the inner loop instead.

I don't really see any major benefit of one version over the other.
