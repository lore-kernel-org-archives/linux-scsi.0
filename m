Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C7FC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65EE216FD
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbhAYU00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 15:26:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732233AbhAYU0D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 15:26:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F8A216FD;
        Mon, 25 Jan 2021 20:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611606322;
        bh=0DQ0hieJIubC2ErePBI6tYhCsnNTrwCHePU+xqwsvc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WpK0G+/Nb32mOacujn4ucN7wpX1qUQ5eiUrb+/yzD6uHKqr8tB3MNSH1FY8LHQdQ4
         M0meXb+KD8CzHntKpMyHLXOrD55rLvksOtr3Iahw9xjTOQh+B6mzD0OGmW2yyU9jCt
         TiBjuecI9GrcnX8T3lQnhNeE8lwyRtILZCyDTYPY5xUxk3smXcpzzL+An1svFFC35q
         mnmMy+3GrnD0iEnTIDGS9h+iRWvMmHaUNbbEdWAABUv3rEMDfilX6WZITgeP3j5ASI
         FDacDpiFH6pIMFuiJQvsMcsZnfMK2exj85pkBgcWSGypITRi7zBt0UGBXcoswlQjXW
         icDfMUGw5oL1A==
Date:   Mon, 25 Jan 2021 12:25:20 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/2] block/keyslot-manager: introduce devm_blk_ksm_init()
Message-ID: <YA8pMDqHsKZA0zfR@sol.localdomain>
References: <20210121082155.111333-1-ebiggers@kernel.org>
 <20210121082155.111333-2-ebiggers@kernel.org>
 <CAA+FYZerh02JXSKghCKuG29ATdYU_=2O93moGnLgD6Jv2v2auQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+FYZerh02JXSKghCKuG29ATdYU_=2O93moGnLgD6Jv2v2auQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 25, 2021 at 12:14:00PM -0800, Satya Tangirala wrote:
> On Thu, Jan 21, 2021 at 12:23 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add a resource-managed variant of blk_ksm_init() so that drivers don't
> > have to worry about calling blk_ksm_destroy().
> >
> > Note that the implementation uses a custom devres action to call
> > blk_ksm_destroy() rather than switching the two allocations to be
> > directly devres-managed, e.g. with devm_kmalloc().  This is because we
> > need to keep zeroing the memory containing the keyslots when it is
> > freed, and also because we want to continue using kvmalloc() (and there
> > is no devm_kvmalloc()).
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
[..]
> > diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
> > index 18f3f5346843f..443ad817c6c57 100644
> > --- a/include/linux/keyslot-manager.h
> > +++ b/include/linux/keyslot-manager.h
> > @@ -85,6 +85,9 @@ struct blk_keyslot_manager {
> >
> >  int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots);
> >
> > +int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
> > +                     unsigned int num_slots);
> > +
> >  blk_status_t blk_ksm_get_slot_for_key(struct blk_keyslot_manager *ksm,
> >                                       const struct blk_crypto_key *key,
> >                                       struct blk_ksm_keyslot **slot_ptr);
> > --
>
> Looks good to me. Please feel free to add
> Reviewed-by: Satya Tangirala <satyat@google.com>

Thanks Satya.  Jens, any objection to this patch going in through the MMC tree?

- Eric
