Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796F6C6FA82
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 15:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiIWPWO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 11:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiIWPVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 11:21:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D560D13F28D;
        Fri, 23 Sep 2022 08:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U2GBoTlUUzXWekHFJz6mXCmgTVG6B81NWa8OCvWXOw0=; b=2wbGPu0YTuslKhonzfHHxdRbtW
        UvfVO1WpNdHcA691HVkGW/40llw3vKRwbmeV/Z6ApI63tKwANGui9tO4YqyOAqq9DfKrwIp7LBFJq
        tchjlyXezutZya56bksO/Y1CUlmDMl0zLcQUVZjFOrps/NA0HTbY8faDBfL2JXUOWYFQCZAwjBWPt
        001VB8F2ryd5Ts+Y+SjJh3rDIadQrePu1E2tuFOz9C8Du2PSIZpyJGMtBqIlyEpfaXzAx9VlRtt9f
        kO0I0bId6kn9fYtn/SqdA3VYlBYZYoYTcNZCyrHBBdUXo/VUPjfIVshU+ru2dbb24BLL8PD3mXIBe
        Vuj3UgGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obkV0-004nLV-CI; Fri, 23 Sep 2022 15:21:54 +0000
Date:   Fri, 23 Sep 2022 08:21:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCHSET 0/5] Enable alloc caching and batched freeing for
 passthrough
Message-ID: <Yy3PEjD2pkSq84RW@infradead.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <Yy3NyACongSfayY+@infradead.org>
 <6f7600be-d4b9-aeac-7dd1-71992a4dd5e8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f7600be-d4b9-aeac-7dd1-71992a4dd5e8@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 23, 2022 at 09:19:15AM -0600, Jens Axboe wrote:
> On 9/23/22 9:16 AM, Christoph Hellwig wrote:
> > On Thu, Sep 22, 2022 at 12:28:00PM -0600, Jens Axboe wrote:
> >> This is good for a 10% improvement for passthrough performance. For
> >> a non-drive limited test case, passthrough IO is now more efficient
> >> than the regular bdev O_DIRECT path.
> > 
> > How so?  If it ends up faster we are doing something wrong in the
> > normal path as there should be no fundamental difference in the work
> > that is being done.
> 
> There's no fundamental difference, but the bdev path is more involved
> than the simple passthrough path.

Well, I guess that means there is some more fat we need to trim
then..
