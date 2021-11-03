Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F46C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8968B60D07
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhKCQoH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbhKCQoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:44:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2FDC061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 09:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IciWiBsqdUZS431uPWBCn/xA6SR0+w0ubqzT9tGXDZ8=; b=jWx2ilo+CgYgGkBUtS302TpJD+
        oQbmsRIJf4CQTmqgAxAdZndnXIE54i2R9vKDqT9kNWKF3twKq8N1vMBWhpKu4Ik0A/UfzXrBTwGcD
        MQFgNCSn7ndwKXPjv56LIxCdRgEmTVT5QhnMD3RdJv5ZfNaeCE9Q5TZbpRFS/cN4WNJA7ifOmhtHw
        1tZp7kWtdaCKnDQBhJQ+vsFzAExgCDJqCZskEpfrkcdNibfomlHbcjkJLkeS8wl2HpJRq2fcYXigy
        tM1yezbXEVsKXaFLJsSwO0gZpqRj2t1aSY659dxwloc6BGiiPdStkLmVadJUVGAQn1Y7YOW2L92hR
        F/A5iAhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJKF-005oNf-Nh; Wed, 03 Nov 2021 16:41:23 +0000
Date:   Wed, 3 Nov 2021 09:41:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Message-ID: <YYK7s7zN3SxEEJGm@infradead.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <YYI9BLBhrFbgridf@infradead.org>
 <700f0463-23a9-8465-f712-1188cb884dea@acm.org>
 <YYK4i6ak6Dqe1JeG@infradead.org>
 <5711eeec-e607-48fd-7c51-4d6f33fbb1ec@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5711eeec-e607-48fd-7c51-4d6f33fbb1ec@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 09:39:32AM -0700, Bart Van Assche wrote:
> How about changing the blk_mq_alloc_request() / blk_put_request() calls in
> ufshcd_exec_dev_cmd() and __ufshcd_issue_tm_cmd() into
> scsi_{get,put}_internal_command() calls once Hannes' patch series that
> introduces these functions is upstream? See also "[PATCH 03/18] scsi: add
> scsi_{get,put}_internal_cmd() helper"
> (https://lore.kernel.org/linux-scsi/20210503150333.130310-4-hare@suse.de/).
> See also patch "[PATCH 10/18] scsi: implement reserved command handling"
> (https://lore.kernel.org/linux-scsi/20210503150333.130310-11-hare@suse.de/).

Well, if they don't even need the command at all an API that just
returns the tag might be even better.  But yes, we need some SCSI layer
abstraction and Hannes and John are currently looking into that.
