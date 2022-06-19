Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D45CCA47A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 06:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiFSGZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 02:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiFSGZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 02:25:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CE3BE27;
        Sat, 18 Jun 2022 23:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4IvFDZ7krZ/2N6UTpbm98sukUrugjG4sfDdwHkszISU=; b=HcQagNtDXtgm88vFNbQ9tYkzg0
        CZ5PSGx6UeurFKgnPHU+ssYtiqXJ8gvhAwAJF2UKFuh3H+wR+N5GpcGkY8/tnXUS/DqTFGBuBO1Bv
        TSbaeEsN82a/LHx2Uxb1OUVvT573ONNHMwP/wJiB4ls69zt6ehwaLyMyGbZSa4bvvq9peXLl7de4L
        E9bfWeuDNYhuicmT7PlyVj4xRhX1eWuzqAm4cyedU15KQF69xrE23DVkon1s+2Ub/Th4FjsbIoNdI
        N5/v2w3of2+QgIHMzYZFbva0CT09xFPLiHrsQJ/9MrDUuTfYeLhixjc/bcRs0gZr7RQrapO4kWXAM
        pJHHA11w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2oN9-00DLgN-IQ; Sun, 19 Jun 2022 06:25:23 +0000
Date:   Sat, 18 Jun 2022 23:25:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] scsi: target: Fix WRITE_SAME NDOB handling in file
Message-ID: <Yq7BU8EpZZh+C1QB@infradead.org>
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-3-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617030440.116427-3-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2022 at 10:04:37PM -0500, Mike Christie wrote:
> If NDOB is set we don't have a buffer. We will then crash when trying to
> access the t_data_sg. This has us allocate a page to use for the data
> buffer that gets passed to vfs_iter_write.

But only due to the last patch, so this should be reordered before
that.

I also think this should just use ZERO_PAGE() or even better switch to
FALLOC_FL_ZERO_RANGE as a first pass.

