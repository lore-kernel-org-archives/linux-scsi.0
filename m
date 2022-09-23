Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A5DC6FA82
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 15:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiIWPQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 11:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiIWPQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 11:16:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AAD129688;
        Fri, 23 Sep 2022 08:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UorYsw2Q0RA5v1p3DScoB0Hc2dP1ZUZpZTV/kkTX85E=; b=Po0/39aTMPTJPyvX4jrPGSdGjH
        sTzwVlvKd5I+ytnGVySRSsHQOeovBHPTlR9BZty3cdTDEbxtfd6wuFo8QgTWtGumTouQXCmfTQqcM
        q6eSeB0N8tcT13BM1B+Z2c8hTCjOFKrXLh1IvCUUpBekzStbO1ASHNH7ooclfvLx/tDtCxk0mIRRv
        oIbpbmWtOxV8vJWExH4mAUzwn5mYUl87vCJRRMGV9wbPQAIPJGA06fo1QheNrRdGIDbf70j0JbhBv
        EfxHfS69zFXZzMGVoWOXgRI1yElQX23xC9vCGrvgI4d8gLqM0cRBb1oGel2F6NYD6OMaE/eOdy7Aa
        uyPPPZ8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obkPg-004lw7-Tj; Fri, 23 Sep 2022 15:16:24 +0000
Date:   Fri, 23 Sep 2022 08:16:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCHSET 0/5] Enable alloc caching and batched freeing for
 passthrough
Message-ID: <Yy3NyACongSfayY+@infradead.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922182805.96173-1-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 12:28:00PM -0600, Jens Axboe wrote:
> This is good for a 10% improvement for passthrough performance. For
> a non-drive limited test case, passthrough IO is now more efficient
> than the regular bdev O_DIRECT path.

How so?  If it ends up faster we are doing something wrong in the
normal path as there should be no fundamental difference in the work
that is being done.
