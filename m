Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154ACC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 07:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D38222C6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 07:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MyIrNe5m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfKMHGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 02:06:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMHGP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 02:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1z4quAOHH2Akat4uFIdPYFiZ0oXjyTLqx8trezJXJOE=; b=MyIrNe5mUezegC2u6ULNi0+gJ
        ME+X2vwWbZIufGKaV754XdMvgg+zFcIkjyQvZeomdj76+mejRK8cHujSTlk9ugc9rvgry26a2mZ6I
        1CZQjBB5Abe66yE7rH3gMXWDsJaCjJaLSJpQ0y2RQL79+ejjfPgILbZuyuzzweG7uZuhbDJ+9nKcD
        DR2hdlMY0OSrr1U1zaXNZjljqMnM6LP+v3NyCVU3F52DWjOOB8fMjbh0cBDb1AdAVwjAQAO3BwlaO
        Vzsx6/qYx0xBM9QoF9Jft1YKisv6p07SEWVLJU8mE9NSFONvuenbp8prkcu5RcIUVTTutCl87M8OS
        5c6uiYuaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUmjC-0004ha-QZ; Wed, 13 Nov 2019 07:06:10 +0000
Date:   Tue, 12 Nov 2019 23:06:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v2 0/9] Zoned block device enhancements and zone report
 rework
Message-ID: <20191113070610.GA17875@infradead.org>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
 <a0c1c1bf-d6e5-8be1-ed99-6bfed3483d1d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c1c1bf-d6e5-8be1-ed99-6bfed3483d1d@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 12, 2019 at 07:16:39PM -0700, Jens Axboe wrote:
> We're taking branching to new levels... I created for-5.5/zoned for this,
> which is for-5.5/block + for-5.5/drivers + for-5.5/drivers-post combined.
> The latter is a branch with the SCSI dependencies from Martin pulled in.

So I guess the report of the partitioning series has to go on top of
that?  Let me try..
