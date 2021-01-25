Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F184C433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BF12074B
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732693AbhAYVXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732605AbhAYVW0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 16:22:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8991720719;
        Mon, 25 Jan 2021 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611609700;
        bh=z87QTkRSd+XZgm1xX6rbNmFYErK8Hx+A8b/nVcwjafQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eRMk6NoCYdyxGwPnOq88HKPT4ngh3uMdH95F+meH3edFPsjPpliSeg8dVUP7nhlK0
         bPTa/ct7ZgTdRXi/Bwbkj7oDNr7zyV1ExZuVu3hR7ULee3r2/t/6s942YfUHnqp9M9
         ZinRsW8WseK9qU9FyJnrWwP8cj/b4Amt67UwxeR62vfkS6rUzpnRSwDcZb0NY8Uu6o
         qI+a2t8bytpKpA/yLulc5PKWjNUye3F7YPqm46Va4vQrtrGPjLQuS0LX1ZjX7I7si4
         Tp+GFttjkl9nf0Owbun9f1gVgDY2bbc/rQF9KCJSHPd7nKX5bVdDIk1mr790YTcEx4
         VsbfMktcZGA8A==
Date:   Mon, 25 Jan 2021 13:21:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH 0/2] Resource-managed blk_ksm_init()
Message-ID: <YA82Y43vGr30v7Ml@gmail.com>
References: <20210121082155.111333-1-ebiggers@kernel.org>
 <CAPDyKFrLn_4Csxc6BeRR0-zY+_RQuNqNSF9SmKk3Bx2WFJJ_Ag@mail.gmail.com>
 <2d03dda2-adaf-a44a-922d-f3770e3da8f4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d03dda2-adaf-a44a-922d-f3770e3da8f4@kernel.dk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 25, 2021 at 02:14:32PM -0700, Jens Axboe wrote:
> On 1/21/21 5:50 AM, Ulf Hansson wrote:
> > + Jens, Martin, James
> > 
> > 
> > On Thu, 21 Jan 2021 at 09:23, Eric Biggers <ebiggers@kernel.org> wrote:
> >>
> >> This patchset adds a resource-managed variant of blk_ksm_init() so that
> >> drivers don't have to worry about calling blk_ksm_destroy().
> >>
> >> This was suggested during review of my patchset which adds eMMC inline
> >> encryption support
> >> (https://lkml.kernel.org/linux-mmc/20210104184542.4616-1-ebiggers@kernel.org/T/#u).
> >> That patchset proposes a second caller of blk_ksm_init().  But it can
> >> instead use the resource-managed variant, as can the UFS driver.
> >>
> >> My preference is that patch #1 be taken through the MMC tree together
> >> with my MMC patchset, so that we don't have to wait an extra cycle for
> >> the MMC changes.  Patch #2 can then go in later.
> > 
> > Sure, I can pick patch #1 through my mmc tree, but need an ack from
> > Jens to do it. Or whatever he prefers.
> 
> Or we can take it through the block tree, usually the easiest as
> it's the most likely source of potential conflicts. And that's true
> for both of them, as long as the SCSI side signs off on patch 2/2.
> 

As I mentioned, the issue is that my patchset to add eMMC inline encryption
support (https://lkml.kernel.org/r/20210121090140.326380-1-ebiggers@kernel.org)
depends on devm_blk_ksm_init(), as it was requested during review.

So if devm_blk_ksm_init() goes in through the block tree, Ulf won't be able to
take the eMMC patchset for 5.12.

- Eric
