Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3A4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D2C6613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244532AbhI2HLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244495AbhI2HLF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 03:11:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D2DC06161C;
        Wed, 29 Sep 2021 00:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Rfn/RSuMmk5y6ZJA1VwqaUbdI4VVIDYyQj92saxwa1U=; b=vB+VKm4IMGdjKTike8OfMVSW8q
        +Ux2VKLJBweoaELDrkaxJ2zefCvAWPOyEkZfLHCRYKgz4Zqn5+uaxBwzEVmmgOkD5bG3R34gh64Kh
        2FU14wa/9Jgi1fn+Pa6sU1bWJyNYWbsXzd32IOLUpJjreI1wD9p9VB1p2JpULaidKxwIzueaWlxjS
        2U0vfAaeFVYzhWbHi2ktszjPdnCWAx5xzCxBu4rlqcjCMuJuGeTLZ6w9jJo8Tnj1E+GWiPGBq4uQV
        5cv17DnMqbWzc5A35ZQ4+qjRPNhioxu1DFbT7jIa/4QaXev+K96MAf1l7lqfUUHzHBCefuGYqLk95
        G1PvkLdA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVTha-00Bahg-2B; Wed, 29 Sep 2021 07:08:43 +0000
Date:   Wed, 29 Sep 2021 08:08:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Po-Wen Kao <powen.kao@mediatek.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        alice.chao@mediatek.com, jonathan.hsu@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, wsd_upstream@mediatek.com,
        ed.tsai@mediatek.com
Subject: Re: [PATCH 1/2] blk-mq: new busy request iterator for driver
Message-ID: <YVQQ6mNhdMVQOhZN@infradead.org>
References: <20210929070047.4223-1-powen.kao@mediatek.com>
 <20210929070047.4223-2-powen.kao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929070047.4223-2-powen.kao@mediatek.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29, 2021 at 03:00:46PM +0800, Po-Wen Kao wrote:
> Driver occasionally execute allocated request directly without
> dispatching to block layer, thus request never appears in tags->rqs.
> To allow driver to iterate through requests in static_rqs, a new
> interface blk_mq_drv_tagset_busy_iter() is introduced.

Don't do that.  All requests must be dispatched to blk-mq.  Let's not
even get started on these hacks that will make our life painful forever.
