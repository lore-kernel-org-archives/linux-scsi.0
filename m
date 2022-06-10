Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF153C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 08:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbiFJIHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343985AbiFJIHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 04:07:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454596B00B;
        Fri, 10 Jun 2022 01:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4cfo9iam47eZXOMjXmG76u/SVRl8up5whCEXthHYRiw=; b=ALstZLmT/X6qeniUT8CeS621ej
        /PKukknv4lpJLVcg1/hr4QOZ3i9LdMMVQ50VOAtP8wUhqCtQcwu1kGRsJ8S/hhpb6J75e7sdg93/e
        cGxhX2bwuHCLqbPde5uKd+bD4bkQJimWk2KN+4pDLwNB09i4Exro9/AU0I8g3ami1djknPgob+Mxn
        KB3vdoYwA05rok7xj13tNo0xnzXu/PeOEu9Divo1yxxl3mciF9AIXTZWCdf8ArnybCHJtUDyZTBY2
        dpTq98E7r+6l+10rpHvfqFj515v9Lfvb1RL9GACiGsH0YZDtJqH9cBhmSoYfSTCyZ/OPOCjh/GHGL
        769pcykw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nzZfe-006ffq-6T; Fri, 10 Jun 2022 08:07:06 +0000
Date:   Fri, 10 Jun 2022 01:07:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v5.19-rc1
Message-ID: <YqL7qr6p1qDImkni@infradead.org>
References: <20220609235329.4jbz4wr3eg2nmzqa@shindev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609235329.4jbz4wr3eg2nmzqa@shindev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 09, 2022 at 11:53:30PM +0000, Shinichiro Kawasaki wrote:
> Failure descriptiion
> ====================
> #1: block/002: Failed 3 times with 3 trials.
>     Known issue. It is suggested to remove this test case [1].
>     [1] https://lore.kernel.org/linux-block/20220530134548.3108185-3-hch@lst.de/

It's a little more complicated than that.  The patch mentioned there
isn't actually in 5.19-rc yet.  But even the current code doesn't remove
synchronously, so it could happen (although I don't see it).

I'll send a patch to remove this particular check, the test case itself
can mostly remain.
