Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F25C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 07:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D9B61175
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 07:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhKCHni (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 03:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhKCHni (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 03:43:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD81C061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 00:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ozhssCchCTTjAh0J7CLpISaUl9zdqSOIDJCoZ19s7d0=; b=q9hl8C/Pfe9evSMM0J+NIPc37X
        Tva2U+6I1G/kgwQJEKPo8IVChrDjYfAABzXrc+VkZ6slBlnQsQQu3tmdL7SGe02eFHSrA/Gfo6smu
        6RT1GTrfL8TGDj6Sx+dajaMDEhtBvTlPGkqPTXPDDzSx+GE0e1GbrHQRv/FrOLezgMoeAk3y4JQb6
        lCfGMlv2XAsMD2m8x6qjWwY+PdCe55aMMqjQ0AUx9lHnV6oill2BJbTuTR99a/d1y2TCgjev8nFi/
        cZOe//mGnoYLsWO/zzrm4V/u6GBWok+eFY1YK9m8Qe1Pab1PIPs9fMs7bw6aUMOqxoetmwudYo9Hq
        TLfBQKlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miAtA-004QdB-W4; Wed, 03 Nov 2021 07:40:52 +0000
Date:   Wed, 3 Nov 2021 00:40:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Message-ID: <YYI9BLBhrFbgridf@infradead.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103000529.1549411-3-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 02, 2021 at 05:05:29PM -0700, Bart Van Assche wrote:
> -	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);

blk_get_request will be gone in 5.16-rc, so this won't apply.

But more importantly: SCSI LLDDs have absolutel no business calling
blk_get_request or blk_mq_alloc_request directly, but as usual UFS is
completely fucked up here.

Please add a SCSI midlayer helper to allocate the reserved tags, and
switch _all_ of this UFS we're sending our own commands crap to it
so it doesn't mix with the actual SCSI requests.  We might or might not
want a separate request_queue for them as well as non-SCSI requests
really should not show up in ->queuecommand.  Hannes and John have been
looking into this for a while and we need to sort this out properly.

