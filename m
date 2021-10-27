Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8329AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 14:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE6E60F21
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 14:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhJ0OqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 10:46:17 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51484 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229447AbhJ0OqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 10:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635345828;
        bh=X71bsrfaWYQbpv46eCA0YAZPQTZHG11O6RiibLLYoWE=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Co/gD4uolDvFOjznbeaw4oTqImLnIZxsI/rfo+x4y20dImrkPG6ojhADyb8jr5q2d
         qr4tzENVR3qN5tHup3+fd9h9BA81RL1zUncjK7zW7puv9gMvWQv5poaweXx11qaOnm
         f2FaWN+P9kzInhdESFeK60E3kVPCeacCmyLMhh4k=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D75F8128068C;
        Wed, 27 Oct 2021 10:43:48 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0HGN5eKoMMg9; Wed, 27 Oct 2021 10:43:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635345828;
        bh=X71bsrfaWYQbpv46eCA0YAZPQTZHG11O6RiibLLYoWE=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Co/gD4uolDvFOjznbeaw4oTqImLnIZxsI/rfo+x4y20dImrkPG6ojhADyb8jr5q2d
         qr4tzENVR3qN5tHup3+fd9h9BA81RL1zUncjK7zW7puv9gMvWQv5poaweXx11qaOnm
         f2FaWN+P9kzInhdESFeK60E3kVPCeacCmyLMhh4k=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id EBF5A128049B;
        Wed, 27 Oct 2021 10:43:47 -0400 (EDT)
Message-ID: <dc2b19c67a0595a5ac9c7f75e7f022f5ce8b4af4.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Date:   Wed, 27 Oct 2021 10:43:46 -0400
In-Reply-To: <804aabca-35cd-e22b-1108-b82be38f6885@kernel.dk>
References: <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
         <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
         <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
         <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
         <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
         <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
         <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
         <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
         <20211027052724.GA8946@lst.de>
         <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
         <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
         <804aabca-35cd-e22b-1108-b82be38f6885@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-10-27 at 08:38 -0600, Jens Axboe wrote:
> On 10/27/21 8:12 AM, Keith Busch wrote:
> > On Wed, Oct 27, 2021 at 06:16:19AM -0700, Bart Van Assche wrote:
> > > On 10/26/21 10:27 PM, Christoph Hellwig wrote:
> > > > On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche
> > > > wrote:
> > > > > If blk_insert_cloned_request() is moved into the device
> > > > > mapper then I think that blk_mq_request_issue_directly() will
> > > > > need to be exported.
> > > > 
> > > > Which is even worse.
> > > > 
> > > > > How
> > > > > about the (totally untested) patch below for removing the
> > > > > blk_insert_cloned_request() call from the UFS-HPB code?
> > > > 
> > > > Which again doesn't fix anything.  The problem is that it fans
> > > > out one request into two on the same queue, not the specific
> > > > interface used.
> > > 
> > > That patch fixes the reported issue, namely removing the
> > > additional accounting caused by calling
> > > blk_insert_cloned_request(). Please explain why it is considered
> > > wrong to fan out one request into two. That code could be
> > > reworked such that the block layer is not involved as Adrian
> > > Hunter explained. However, before someone spends time on making
> > > these changes I think that someone should provide more
> > > information about why it is considered wrong to fan out one
> > > request into two.
> > 
> > The original request consumes a tag from that queue's tagset. If
> > the lifetime of that tag depends on that same queue having another
> > free tag, you can deadlock.
> 
> And to expand on that, one potential solution would be to require as
> many reserved tags as normal tags, and have the cloned/direct insert
> grab requests out of the reserved pool. That guarantees the forward
> progress that is currently violated by randomly requiring an extra
> tag.

Another potential way of doing this might be to transmit the buffer
information as a separate scatterlist, a bit like DIF/DIX.  At the
bottom of the stack, the write buffer has to complete before the
dependent command so we could actually enforce that right at the driver
level using the same tag since the two commands are sequential.

James


