Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4CCC83028
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 17:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E499461041
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 17:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346397AbhIBRCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 13:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346393AbhIBRCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 13:02:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D3EC061575
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 10:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ESL82o5MOfMBkrQU8FIHdzP+pxFaZLxkeaNDbEpn1d0=; b=oAh76KthG48Imz/H94CDswzxEi
        Fy/HdHUC2dXlMF9QzjF8p4phDTbK/lUeQocGt/EEt2G29nGLeQq53t7QoJ1EcixQ275Tja/hJYK91
        VaU88MPsmWUFAOExUb6YT3uCA7hccCNUzPAU2yrfW9TBpGlu/HNJJexWj56newf4OY0yw5+toIpGc
        vaW42T2uXwkcvRz7ITErhEJUkijAv2f8fR/jyQnzqQAYDyLVMmwsh67iH4C7CzXHiwYANCbV2oSVQ
        6qcfJNrxe6Rz9udanzqRXHPOPQLrDcxyGt4XEKg8+5PfoDbEfDnQmXMH1Yj7dvmX1XHJiV3z7cWUM
        szE5LeNg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLq4M-003ej9-25; Thu, 02 Sep 2021 17:00:19 +0000
Date:   Thu, 2 Sep 2021 18:00:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: do not call device_add() on scsi_disk with
 uninitialized gendisk ->queue
Message-ID: <YTEDFs8GdhTi6EUl@infradead.org>
References: <20210902162425.17208-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902162425.17208-1-emilne@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 02, 2021 at 12:24:25PM -0400, Ewan D. Milne wrote:
> Calling device_add() makes the scsi_disk visible in sysfs, the accessor
> routines reference sdkp->disk->queue which was not yet set properly.
> Fix this by initializing gendisk fields earlier in the function.

What kernel is this against?  This won't apply against linux-next
as disk->queue is now always set up by __blk_alloc_disk.
