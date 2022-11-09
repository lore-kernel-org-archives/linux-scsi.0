Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209B0C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 12:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKIMbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 07:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKIMbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 07:31:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906CC1CB24;
        Wed,  9 Nov 2022 04:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eRzuEXN9362q/hm/FS3+aYwyK9q6wPOkykwNudQnk2w=; b=Jm3QTcZJ/2OzYib865/QJe6Jib
        Y8zYsQaCrGdvDo5tzhK3G15u0bHeC5kQuF71N2vAYRTqMG761I9uVM0cfHGO4jOmFHzqrIK3dOIWS
        I2mRv1F7RkQ3+0GpWH8B7IRff4kVuDkb1RSVv8sBO9acSuY37ve8hRgmYjB3WFubV2sjA9id04fe9
        MCEJ++8s+9MJFBDDaRNZ7r6db3JKIvdeJU6sR7tts3fGa83kRFPIpZFwT+RyUeL5vSUP4MRuYw9//
        wNBSLYMaYXq+F0gAHDo7NhJBu4eDv0uD8bDDMN6vSTCUJuZPu4tD65/njJivEd4VlsUn+y/cZZvZY
        tA3G8VKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oskEk-00DPR6-Ny; Wed, 09 Nov 2022 12:31:22 +0000
Date:   Wed, 9 Nov 2022 04:31:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Juhyung Park <qkrwngud825@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jiaming Li <lijiaming3@xiaomi.corp-partner.google.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijiaming3 <lijiaming3@xiaomi.com>
Subject: Re: [RESEND PATCH 0/4] Implement File-Based optimization
 functionality
Message-ID: <Y2udmtayRau/x5AO@infradead.org>
References: <20221102053058.21021-1-lijiaming3@xiaomi.corp-partner.google.com>
 <Y2IuhG8nBJj0F1fd@infradead.org>
 <c5948336-19fc-ddd3-bc34-aba2d1b02302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5948336-19fc-ddd3-bc34-aba2d1b02302@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 03, 2022 at 03:11:16PM +0900, Juhyung Park wrote:
> Is the idea really an utter madness?

Yes.

> Majority of regular files that may be
> of interest from the perspective of UFS aren't reflinked or snapshotted (let
> alone the lack of support from ext4 or f2fs).

Linux does not require you in any way to use obsolete file systems
desings only on any given block device.

> Device-side fragmentation is a real issue [1] and it makes more than enough
> sense to defrag LBAs of interests to improve performance. This was long
> overdue, unless the block interface itself changes somehow.

Or maybe random writes to flash aren't a good idea if you FTL sucks?
Full blown FTLs tend to not do any extent based mappings, so
fragmentation does not matter.  The price paid for that is much larger
FTL tables.  If you stop pretending flash is random writable through
saner interfaces like ZNS you automatically solve this fragmentation
problem as well.

> The question is how to implement it correctly without creating a mess with
> mismatched/outdated LBAs as you've mentioned, preferably through
> file-system's integration: If the LBAs in questions are indeed reflinked,
> how do we handle it?, If the LBAs are moved/invalidated from defrag or GC,
> how do we make sure that UFS is up-to-date?, etc.

The fix is to plug the leaking abtractions in UFS.  If it wants to look
like a random writable block device it better perform when doing that.
And if it doesn't want to pay the prize for that it'd better expose
an abstraction that actually fits the underlying media.  It's not like
some of us haven't worked on that for the last decade.
