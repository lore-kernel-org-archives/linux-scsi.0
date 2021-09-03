Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DA1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 04:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF35E61057
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 04:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhICEog (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 00:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhICEof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 00:44:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1440C061575
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 21:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M2nciGyJJrn+f+HNNXEtwtF0W45pvHZ78fPTsWMlmzg=; b=Bm/eQYUDaNZhFpb/ANnk1+S3me
        25Nhm+3M7FLbXL91vl/etW4QxXO/yqyb2jZtS5sX1W5VCi86YWN5sH+7oY/0hygmAajNYfHW5YBq7
        9TwunhvzyzKHjtPlt/kD2VnGpLTLyrzNqJ4c3thLzCe8YCOCI9hafl8seCha7Ko/Sc2d/SNgsDAvO
        p3i/32NczSAgvM3lBMH0W26xDYvPc37ncs/9F0+DSsfnoZ0d4yln3d5bBEpQKaxi1Ll+HmQvEJ3T8
        QpqNAAdWu0uC7fVlIGQDuRkNXv57g1IxUKYLlL4v2Y6OyJ4UsF+DAo2fGicFuM+S0zq4jkE4Zk7TX
        ctMGtPZg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mM11M-0047ke-FM; Fri, 03 Sep 2021 04:42:10 +0000
Date:   Fri, 3 Sep 2021 05:41:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ewan Milne <emilne@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: do not call device_add() on scsi_disk with
 uninitialized gendisk ->queue
Message-ID: <YTGniIxMcUDI0E3F@infradead.org>
References: <20210902162425.17208-1-emilne@redhat.com>
 <YTEDFs8GdhTi6EUl@infradead.org>
 <CAGtn9rk0dqCiSQqRkN6BrDeBMjJWLqMmFsbH09Uqi2Yn4U4iQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGtn9rk0dqCiSQqRkN6BrDeBMjJWLqMmFsbH09Uqi2Yn4U4iQQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 02, 2021 at 03:35:23PM -0400, Ewan Milne wrote:
> It was against git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
> branch "fixes".
> 
> Looks like your changes resolve ->queue not being set prior to add_device(),
> please disregard my patch.  It's not that critical to fix in earlier versions.
> Sorry for the noise.

This might still be useful for -stable. It just needs to be clearly
tagged as such.
