Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90D3C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 15:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D402080C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 15:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHLPNp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:13:45 -0400
Received: from verein.lst.de ([213.95.11.211]:43660 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLPNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Aug 2020 11:13:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0E3086736F; Wed, 12 Aug 2020 17:13:41 +0200 (CEST)
Date:   Wed, 12 Aug 2020 17:13:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Chao Leng <lengchao@huawei.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] nvme-core: delete the dependency on
 REQ_FAILFAST_TRANSPORT
Message-ID: <20200812151340.GC29544@lst.de>
References: <20200812081855.22277-1-lengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812081855.22277-1-lengchao@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 12, 2020 at 04:18:55PM +0800, Chao Leng wrote:
> REQ_FAILFAST_TRANSPORT may be designed for scsi, because scsi protocol
> do not difine the local retry mechanism. SCSI implements a fuzzy local
> retry mechanism, so need the REQ_FAILFAST_TRANSPORT for multipath
> software, if work with multipath software, ultraPath determines
> whether to retry and how to retry.
> 
> Nvme is different with scsi about this. It define local retry mechanism
> and path error code, so nvme should retry local for non path error.
> If path related error, whether to retry and how to retry is still
> determined by ultraPath. REQ_FAILFAST_TRANSPORT just for non nvme
> multipath software(like dm-multipath), but we do not need return an
> error for REQ_FAILFAST_TRANSPORT first, because we need retry local
> for non path error first.

This doesn't look wrong, but these kinds of changes really need to
go along with block layer documentation of the intended uses of the
flags.  In fact the SCSI usage also looks really confused to me and at
very least needs better documentation if not changes.  So I think
you need to do a lot code archaeology, ping the authors and current
maintainers and sort this out as well.

More importantly if the above explanation makes sense we really need
to kill blk_noretry_request off entirely and replace it with a check
of the right set of flags in each caller as well.
