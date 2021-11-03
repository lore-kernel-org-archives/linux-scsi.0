Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3316C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C62A608FB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhKCQgj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKCQgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:36:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928D9C061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 09:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l4y/qDzonttdCVMmfb7yYZvhiOJVSk3NHutZFNCB0dM=; b=EsK6qeLCJFMUJLDx4LgccpXIYY
        x4Ssl3KtSOXM5hh5UAqmNwewwK5zDSf1KxPBNWMUYk2IpN7PVSEr+DSdjyQM2CZukGR7hU5JJgt0u
        qEAGFRg5bOB50HKpakACpFP2HyzYQRkXabpmIbIvLNX1y35NmwBKccu5ovXVTrqRuxpNBHgr9sW6f
        SX0Mn9StFZMjqX7Xk1OSj4Chp0e+PDHUQwgUVkFhZI+47WgQm6fbdGF+snynjzA3/tlEap4V+HzCR
        YRsd3lC7aVLWnOWJG3NuqwH49tRpwFxFqWigPZpRGmb+N5fxfm+6opJNT5Vc7kdpyyf12EW7nnPUw
        wg98p01A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJD2-005n1O-B1; Wed, 03 Nov 2021 16:33:56 +0000
Date:   Wed, 3 Nov 2021 09:33:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Message-ID: <YYK59D+M5w4FSoo0@infradead.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <YYI9BLBhrFbgridf@infradead.org>
 <19b8e555-d12f-9bf5-91c6-d3c5f849e72c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19b8e555-d12f-9bf5-91c6-d3c5f849e72c@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 10:37:30AM +0200, Adrian Hunter wrote:
> The UFS driver does not issue device commands to the block layer.
> blk_get_request() is used only to get a free slot.

That is indeed the case for the code touched here, but not in general:

ch@brick:~/work/linux$ git-grep blk_execute_rq drivers/scsi/ufs/
drivers/scsi/ufs/ufshcd.c:      blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
drivers/scsi/ufs/ufshpb.c:      blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
drivers/scsi/ufs/ufshpb.c:      blk_execute_rq_nowait(NULL, req, 1, ufshpb_map_req_compl_fn);
