Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0784C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 13:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84754206F9
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 13:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbhAZNZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731118AbhAZJ6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 04:58:48 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4CDC061794
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 01:58:33 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id n18so8693491vsa.12
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 01:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V09Ue7aLBQ6MasDKq8tKkbzc8OyCG8WfSUIi+pxHZ0A=;
        b=CHlVroXsOgdhhTPTerkwYExyowok7JnOu1dgx3Qe5C+WdAY9SuwbHHYtgflWAiyHXA
         6nk/cPRyb5qitgEgrQ12v8btdOrwCH8AVbfR2laYZKDz9gIq8s04GFaa8x7ElPb8GbKT
         oOqLh6fukCxIin4MRGYp8DW83XwqXltmRrbonhhJnmIVBkrjVn8FwpIfUufmCoRazpIz
         82fdB/S7WvPikAR9P3PR8RboYxAWzp+XCg7dvH9rw7hJ2wqNHi2YgpHDfMqYnhe3ZBpS
         9SK3HgV7HU9TxNcbi+YXXZ0B88xcLL3pB3p45beQAXEZ5qXZJKE0nrXFxMFEcaokAX0k
         XoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V09Ue7aLBQ6MasDKq8tKkbzc8OyCG8WfSUIi+pxHZ0A=;
        b=qOtyIG2cspja5jQE+ceJ06LOEzMYpgv9m/kXVRTJLN97PE9O+Q3cIDsZgpiho2MYWp
         k+4yKspkDSRpt3iqqVaxs3fje+Nd0snL+/vBBxAt557OvsGu9HrJZkBeLqkge8+0uMsv
         eDwITIIjAWQuKEeHOhrCUIraXpGq2vSI385+mYIfoFYJuISUEuYhBF7DHrq5wB8fBacG
         wxCu2www3aRkSZB9Iyi077rx5QSzku5Eb6PP9tGw+Pr0pGyUZJyN8MvUCd97E27vlzOw
         6uHO1ix0BHgEvH421oaA2URecbrqSSGOQQybY84+cSwtILkLyGCLmB8F9Jo8G++AVES2
         xDJA==
X-Gm-Message-State: AOAM532McdfCwo4GAejGzjyM1AyZK0SegBPKVg0irV0LvrsAnyQXVm4G
        oHWdMi8NKC67HZZcuJNyFH3LG1aNjoXxt+oS4bP+1LVDfeJxAg==
X-Google-Smtp-Source: ABdhPJyxfS6eXOv4r25zRNMylO+JLPVa+hbsuQ550KJ78Oyz1/Jpr4fsWYgKLy/30YnR5meyw9A4c2VWMyETl9lCtpM=
X-Received: by 2002:a67:7f41:: with SMTP id a62mr3552156vsd.55.1611655112263;
 Tue, 26 Jan 2021 01:58:32 -0800 (PST)
MIME-Version: 1.0
References: <20210121082155.111333-1-ebiggers@kernel.org> <20210121082155.111333-2-ebiggers@kernel.org>
 <CAA+FYZerh02JXSKghCKuG29ATdYU_=2O93moGnLgD6Jv2v2auQ@mail.gmail.com>
 <YA8pMDqHsKZA0zfR@sol.localdomain> <3b1b6a94-f283-e8a3-8638-6475d0323c30@kernel.dk>
In-Reply-To: <3b1b6a94-f283-e8a3-8638-6475d0323c30@kernel.dk>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 26 Jan 2021 10:57:55 +0100
Message-ID: <CAPDyKFoU1ciLfDig5XkULK-CBkCsmsbAgpyo51O8LEsTr3Q+Sg@mail.gmail.com>
Subject: Re: [PATCH 1/2] block/keyslot-manager: introduce devm_blk_ksm_init()
To:     Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>
Cc:     Satya Tangirala <satyat@google.com>,
        linux-block <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 25 Jan 2021 at 22:16, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/25/21 1:25 PM, Eric Biggers wrote:
> > On Mon, Jan 25, 2021 at 12:14:00PM -0800, Satya Tangirala wrote:
> >> On Thu, Jan 21, 2021 at 12:23 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >>>
> >>> From: Eric Biggers <ebiggers@google.com>
> >>>
> >>> Add a resource-managed variant of blk_ksm_init() so that drivers don't
> >>> have to worry about calling blk_ksm_destroy().
> >>>
> >>> Note that the implementation uses a custom devres action to call
> >>> blk_ksm_destroy() rather than switching the two allocations to be
> >>> directly devres-managed, e.g. with devm_kmalloc().  This is because we
> >>> need to keep zeroing the memory containing the keyslots when it is
> >>> freed, and also because we want to continue using kvmalloc() (and there
> >>> is no devm_kvmalloc()).
> >>>
> >>> Signed-off-by: Eric Biggers <ebiggers@google.com>
> > [..]
> >>> diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
> >>> index 18f3f5346843f..443ad817c6c57 100644
> >>> --- a/include/linux/keyslot-manager.h
> >>> +++ b/include/linux/keyslot-manager.h
> >>> @@ -85,6 +85,9 @@ struct blk_keyslot_manager {
> >>>
> >>>  int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots);
> >>>
> >>> +int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
> >>> +                     unsigned int num_slots);
> >>> +
> >>>  blk_status_t blk_ksm_get_slot_for_key(struct blk_keyslot_manager *ksm,
> >>>                                       const struct blk_crypto_key *key,
> >>>                                       struct blk_ksm_keyslot **slot_ptr);
> >>> --
> >>
> >> Looks good to me. Please feel free to add
> >> Reviewed-by: Satya Tangirala <satyat@google.com>
> >
> > Thanks Satya.  Jens, any objection to this patch going in through the MMC tree?
>
> No objections from me, doesn't look like we have any real worries of
> conflicts.

Applied to my mmc for the next branch, by adding Jens' ack. Thanks everybody!

Kind regards
Uffe
