Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E46C48BC2
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 05:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EDB6141C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 05:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhFYFkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 01:40:15 -0400
Received: from verein.lst.de ([213.95.11.211]:56678 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233104AbhFYFkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Jun 2021 01:40:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EBAEB67373; Fri, 25 Jun 2021 07:37:51 +0200 (CEST)
Date:   Fri, 25 Jun 2021 07:37:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: remove REQ_OP_SCSI_{IN,OUT}
Message-ID: <20210625053751.GA22164@lst.de>
References: <20210624123935.479229-1-hch@lst.de> <BYAPR04MB4965F273BBD2CBD0958B44FE86079@BYAPR04MB4965.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB4965F273BBD2CBD0958B44FE86079@BYAPR04MB4965.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 24, 2021 at 10:57:44PM +0000, Chaitanya Kulkarni wrote:
> On 6/24/21 05:40, Christoph Hellwig wrote:
> > With the legacy IDE driver gone drivers now use either REQ_OP_DRV_*
> > or REQ_OP_SCSI_*, so unify the two concepts of passthrough requests
> > into a single one.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Nice cleanup, we got two bits free for new req_op.

We could in fact easily reduce REQ_OP_BITS to 5 now with space to spare.
But we haven't run out of flags bits quite yet.
