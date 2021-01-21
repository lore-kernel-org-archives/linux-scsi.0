Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018D9C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A68E2239FD
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbhAUMxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 07:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731092AbhAUMwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 07:52:08 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC52C0613D3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jan 2021 04:51:27 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id o186so969364vso.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jan 2021 04:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zgnPGBkKt9kNKpgkGKnTC5rjq2geX+vqa9xRmEBMwE=;
        b=pXQCwGgMppqPSadWf53sSTB0HUmmPCYaaT27dxXo7mM1QOKRn7Ho9YEtX7n+bUep+n
         z/011Z9xbyhRk26aIrHf5DNOc0yTk5d7IPR/s/96L8IjtLsEuerl7S92wXCZbAQNuy4k
         EuKgxgBcZv9uzl3mZYkabID7w+j5Y3pjWn6ExJjKC4yg0ZYmmSKqI6FbP0urJH0LQeDX
         m21f14gaOrIGd6s/gs6DHaToFyEAYrMbUf5G8ASEfOeQC+X20Abu7ithv9soBQDBBPjA
         zhqu8n8pF5g922LMEvLaoBZyOiGbwVyNFVposjtbUZAhrA3PQmQVXO1BrBVCFJkiFZKQ
         2KVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zgnPGBkKt9kNKpgkGKnTC5rjq2geX+vqa9xRmEBMwE=;
        b=TR5TMgQyp2ckHPK/RfHPYnRb6/aFLMOiBS5nu+D7Wi3LleddNR7rQynanP1k9RSpNI
         B3RjEHOqrbR/Qb0jTr+vLFNNitVMnpgQ6RURAmXNJ3ysv0lPCLVfMuE6yEd/1z0QWn7r
         yPHvK1aaVxGLyNV8pUhFoBTuEtN56PZ9JR5A1MpHWe5vKChQgsHjF/1LUC0NeDkMxKNF
         RPaKBYgX04V6SVDrXBIL4QOBW7lFRnfh6p85+k1kCI8adho//vXI4OIHWvftkStEDjFw
         JQyhsNOxDF+igjle7FBQVkowC3E0EYDH6yIrURoDdqtPfJXknRv65XVneT8WbK7MTm6d
         U6hg==
X-Gm-Message-State: AOAM532nXFBOj0oV7kPZCbRWZCRj8uDf0+r/x4dSQID1jtj1vBBGS+53
        1bwoUEotLfsmEn1kSXD1sjr2qJnak9DBB6QBKyOxVw==
X-Google-Smtp-Source: ABdhPJySvUa1/ex7Gl2xWrraA+wD1lwy8FCAEtg9Bs8gkWN/0ze3SAxy8QOvi3C2ZJ6pjBGSHu7s/n5K+eisF3off/0=
X-Received: by 2002:a67:7f41:: with SMTP id a62mr9523888vsd.55.1611233486132;
 Thu, 21 Jan 2021 04:51:26 -0800 (PST)
MIME-Version: 1.0
References: <20210121082155.111333-1-ebiggers@kernel.org>
In-Reply-To: <20210121082155.111333-1-ebiggers@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 21 Jan 2021 13:50:49 +0100
Message-ID: <CAPDyKFrLn_4Csxc6BeRR0-zY+_RQuNqNSF9SmKk3Bx2WFJJ_Ag@mail.gmail.com>
Subject: Re: [PATCH 0/2] Resource-managed blk_ksm_init()
To:     Eric Biggers <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-block <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ Jens, Martin, James


On Thu, 21 Jan 2021 at 09:23, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This patchset adds a resource-managed variant of blk_ksm_init() so that
> drivers don't have to worry about calling blk_ksm_destroy().
>
> This was suggested during review of my patchset which adds eMMC inline
> encryption support
> (https://lkml.kernel.org/linux-mmc/20210104184542.4616-1-ebiggers@kernel.org/T/#u).
> That patchset proposes a second caller of blk_ksm_init().  But it can
> instead use the resource-managed variant, as can the UFS driver.
>
> My preference is that patch #1 be taken through the MMC tree together
> with my MMC patchset, so that we don't have to wait an extra cycle for
> the MMC changes.  Patch #2 can then go in later.

Sure, I can pick patch #1 through my mmc tree, but need an ack from
Jens to do it. Or whatever he prefers.

Another solution is to host immutable branches (if needed), so they
can be shared between our tree's, that works for me as well.

>
> Eric Biggers (2):
>   block/keyslot-manager: introduce devm_blk_ksm_init()
>   scsi: ufs: use devm_blk_ksm_init()
>
>  Documentation/block/inline-encryption.rst | 12 +++++-----
>  block/keyslot-manager.c                   | 29 +++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-crypto.c          |  9 ++-----
>  drivers/scsi/ufs/ufshcd-crypto.h          |  5 ----
>  drivers/scsi/ufs/ufshcd.c                 |  1 -
>  include/linux/keyslot-manager.h           |  3 +++
>  6 files changed, 40 insertions(+), 19 deletions(-)
>
> --
> 2.30.0
>

Kind regards
Uffe
