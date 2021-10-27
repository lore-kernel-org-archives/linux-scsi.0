Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD63C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 05:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F015C60EB4
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 05:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhJ0F3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 01:29:54 -0400
Received: from verein.lst.de ([213.95.11.211]:36238 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236690AbhJ0F3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 01:29:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D55B267373; Wed, 27 Oct 2021 07:27:24 +0200 (CEST)
Date:   Wed, 27 Oct 2021 07:27:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <20211027052724.GA8946@lst.de>
References: <20211026071204.1709318-1-hch@lst.de> <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org> <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com> <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk> <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org> <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk> <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com> <yq1ee873av4.fsf@ca-mkp.ca.oracle.com> <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
> If blk_insert_cloned_request() is moved into the device mapper then I
> think that blk_mq_request_issue_directly() will need to be exported.

Which is even worse.

> How
> about the (totally untested) patch below for removing the
> blk_insert_cloned_request() call from the UFS-HPB code?

Which again doesn't fix anything.  The problem is that it fans out one
request into two on the same queue, not the specific interface used.

Martin:  please just take the HPB removal.  This seems to be the only
thing that makes sense given that no one from the UFS camp seems to
have the time and resources to come up with an alternative.
