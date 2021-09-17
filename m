Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D06C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 12:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307BF61130
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 12:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244393AbhIQMix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 08:38:53 -0400
Received: from verein.lst.de ([213.95.11.211]:44897 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhIQMip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 08:38:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 67E4467357; Fri, 17 Sep 2021 14:37:19 +0200 (CEST)
Date:   Fri, 17 Sep 2021 14:37:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <20210917123719.GA17003@lst.de>
References: <20210915134008.GA13933@lst.de> <YUKfl9Qqsluh+5FX@T590> <20210916101451.GA26782@lst.de> <YUM6uFHqfjWMM5BH@T590> <20210916142009.GA12603@lst.de> <YUQOBKa67R9pEunr@T590.Home> <20210917065305.GA24012@lst.de> <YURGkXQndMxDEWxW@T590.Home> <20210917075650.GA28455@lst.de> <YURSj0G5gMiSAo5j@T590.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YURSj0G5gMiSAo5j@T590.Home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 04:32:15PM +0800, Ming Lei wrote:
> > Is it?  For the typical case the second free in blk_cleanp_queue will
> > be bsically free because there is no pending I/O.  The only case
> > where that matters if if there is pending passthrough I/O again,
> > which can only happen with SCSI, and even there is highly unusual.
> 
> RCU grace period is involved in blk_freeze_queue().

where?

> One way you can
> avoid it is to keep the percpu ref at atomic mode when running
> blk_mq_unfreeze_queue() in del_gendisk().
> 
> 
> 
> Thanks,
> Ming
---end quoted text---
