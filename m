Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D822C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 14:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A84860F38
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 14:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242441AbhJ0OPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 10:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242439AbhJ0OO7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 10:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4485C60E0B;
        Wed, 27 Oct 2021 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635343953;
        bh=7uqyQdn7aTLuLLNNnb9swS95tU5WJ2AnOQUdf11oYfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXFvqv930NHTcj3bADDQfSXme8k9n/LaahcuKPF9noBsfa35HZTCczNlTEt+NJZxO
         n2KkIZhEXkZB2WEJkZ/DSa+UYmHh47pEspZRmdVPrskQZnLR2IBHn7YFzVPfpNyLVR
         +eaAxwbEtqD0MVpqTjCdQIuLgDVZJe99t82jUTH2l22eRZsWRVm07op3BTwUUHXSux
         jcrnNbZxoMCrgCUXRWizTWE7CajHBR8UDuiz3yBbigkKm6GCeRmYjbYp+k4ChOJvQa
         YF5DpCA2Ry3qxlRfLUgbIUSgOuohozcW8TGpwDtgsq77+L53PdbrvbWzlTEdq5GYzM
         dIRETadydUa2Q==
Date:   Wed, 27 Oct 2021 07:12:31 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 06:16:19AM -0700, Bart Van Assche wrote:
> On 10/26/21 10:27 PM, Christoph Hellwig wrote:
> > On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
> > > If blk_insert_cloned_request() is moved into the device mapper then I
> > > think that blk_mq_request_issue_directly() will need to be exported.
> > 
> > Which is even worse.
> > 
> > > How
> > > about the (totally untested) patch below for removing the
> > > blk_insert_cloned_request() call from the UFS-HPB code?
> > 
> > Which again doesn't fix anything.  The problem is that it fans out one
> > request into two on the same queue, not the specific interface used.
> 
> That patch fixes the reported issue, namely removing the additional accounting
> caused by calling blk_insert_cloned_request(). Please explain why it is
> considered wrong to fan out one request into two. That code could be reworked
> such that the block layer is not involved as Adrian Hunter explained. However,
> before someone spends time on making these changes I think that someone should
> provide more information about why it is considered wrong to fan out one request
> into two.

The original request consumes a tag from that queue's tagset. If the
lifetime of that tag depends on that same queue having another free tag,
you can deadlock.
