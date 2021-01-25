Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E572EC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A687F22583
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbhAYUPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 15:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731193AbhAYUOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 15:14:52 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F347BC061756
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 12:14:11 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p72so29138843iod.12
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 12:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5oPVxsDUHFnjzZ37jztimVx7kT5rl5MLP23lod84D8k=;
        b=O7ObVy/vbDbvYgKIJLJJe1Y9IKfOCCLlQ6AzYhjLSNlxQ1feUkOZBwlBjw+UCjoO68
         SoONYMJJPORKbbwddqa0AP8EdbK0fP3GezYgLp2C7FF3PJT9bdhP+7EtHDzxCH3z1Hgr
         ZaDtA2Pb5lNw5h7P7YQp2ybuW1FNCqIq3AjX5MFuiFDJfI5sJ+tgm+v+KDfaSNsbZA3D
         t6QCSDvG9sY9qA0cmzpFWbArfD3avEasYZvSHAsSXvxqmTUst4QOhxubnaG2MPygpyIm
         r2s7yZdAYKTJFhAfIJwa2MgmhNICTcpq16Bcb8DmgRQdQ4y61MZsVNfs0dXPo5QNUSZd
         sFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5oPVxsDUHFnjzZ37jztimVx7kT5rl5MLP23lod84D8k=;
        b=ZSf1zj8otIX2pagWOodicyPTclgfod1OkSER2o3xLLkhTkvC56USEQpZVDit2Xb3Ni
         5qVWhvCZEzlpnPgaQa+XGJMWm0O8/fv4POlKg6gFnzOFXZYtvQiDleGaIGUZBv98gFpz
         eAdI5aNhGUfZB3QOzPTMEtN+RoDEQ11TGXBasJejV+Is3fzNuwu41zp5ZsiG6IrEs3LB
         voxwWQXJd9WItKOoBwjsIc94Wrso0DpHJDg3zZRb1rtqfKxNLLQk75j3Y/iSqW/RApNw
         PZTunsqwcpqDv7il6nc5r1oOm1WH0a9yC0dWBMsD7JYom6QBrMUOuuliL2+YCTPTtu6l
         SDyg==
X-Gm-Message-State: AOAM533Q5GvkAa9T+Q7NoWv3mdZJwgDMChLgHkTPWbXmsNqM95AQzajp
        Q4L5iR3OLrd/eKNN3UK7m+0gm/KBvDgup3J++SmVOQ==
X-Google-Smtp-Source: ABdhPJzMjR4NyG/6n7ZBSL9gkgUVYaYxJ5W7f+6z3TKM10CBC8DzB/dFVXPVii8iOsQguaod82m7mEWmkYOU3l7Har4=
X-Received: by 2002:a5e:8905:: with SMTP id k5mr1836963ioj.140.1611605651165;
 Mon, 25 Jan 2021 12:14:11 -0800 (PST)
MIME-Version: 1.0
References: <20210121082155.111333-1-ebiggers@kernel.org> <20210121082155.111333-2-ebiggers@kernel.org>
In-Reply-To: <20210121082155.111333-2-ebiggers@kernel.org>
From:   Satya Tangirala <satyat@google.com>
Date:   Mon, 25 Jan 2021 12:14:00 -0800
Message-ID: <CAA+FYZerh02JXSKghCKuG29ATdYU_=2O93moGnLgD6Jv2v2auQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] block/keyslot-manager: introduce devm_blk_ksm_init()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 21, 2021 at 12:23 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add a resource-managed variant of blk_ksm_init() so that drivers don't
> have to worry about calling blk_ksm_destroy().
>
> Note that the implementation uses a custom devres action to call
> blk_ksm_destroy() rather than switching the two allocations to be
> directly devres-managed, e.g. with devm_kmalloc().  This is because we
> need to keep zeroing the memory containing the keyslots when it is
> freed, and also because we want to continue using kvmalloc() (and there
> is no devm_kvmalloc()).
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/block/inline-encryption.rst | 12 +++++-----
>  block/keyslot-manager.c                   | 29 +++++++++++++++++++++++
>  include/linux/keyslot-manager.h           |  3 +++
>  3 files changed, 38 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
> index e75151e467d39..7f9b40d6b416b 100644
> --- a/Documentation/block/inline-encryption.rst
> +++ b/Documentation/block/inline-encryption.rst
> @@ -182,8 +182,9 @@ API presented to device drivers
>
>  A :c:type:``struct blk_keyslot_manager`` should be set up by device drivers in
>  the ``request_queue`` of the device. The device driver needs to call
> -``blk_ksm_init`` on the ``blk_keyslot_manager``, which specifying the number of
> -keyslots supported by the hardware.
> +``blk_ksm_init`` (or its resource-managed variant ``devm_blk_ksm_init``) on the
> +``blk_keyslot_manager``, while specifying the number of keyslots supported by
> +the hardware.
>
>  The device driver also needs to tell the KSM how to actually manipulate the
>  IE hardware in the device to do things like programming the crypto key into
> @@ -202,10 +203,9 @@ needs each and every of its keyslots to be reprogrammed with the key it
>  "should have" at the point in time when the function is called. This is useful
>  e.g. if a device loses all its keys on runtime power down/up.
>
> -``blk_ksm_destroy`` should be called to free up all resources used by a keyslot
> -manager upon ``blk_ksm_init``, once the ``blk_keyslot_manager`` is no longer
> -needed.
> -
> +If the driver used ``blk_ksm_init`` instead of ``devm_blk_ksm_init``, then
> +``blk_ksm_destroy`` should be called to free up all resources used by a
> +``blk_keyslot_manager`` once it is no longer needed.
>
>  Layered Devices
>  ===============
> diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
> index 86f8195d8039e..324bf4244f5fb 100644
> --- a/block/keyslot-manager.c
> +++ b/block/keyslot-manager.c
> @@ -29,6 +29,7 @@
>  #define pr_fmt(fmt) "blk-crypto: " fmt
>
>  #include <linux/keyslot-manager.h>
> +#include <linux/device.h>
>  #include <linux/atomic.h>
>  #include <linux/mutex.h>
>  #include <linux/pm_runtime.h>
> @@ -127,6 +128,34 @@ int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots)
>  }
>  EXPORT_SYMBOL_GPL(blk_ksm_init);
>
> +static void blk_ksm_destroy_callback(void *ksm)
> +{
> +       blk_ksm_destroy(ksm);
> +}
> +
> +/**
> + * devm_blk_ksm_init() - Resource-managed blk_ksm_init()
> + * @dev: The device which owns the blk_keyslot_manager.
> + * @ksm: The blk_keyslot_manager to initialize.
> + * @num_slots: The number of key slots to manage.
> + *
> + * Like blk_ksm_init(), but causes blk_ksm_destroy() to be called automatically
> + * on driver detach.
> + *
> + * Return: 0 on success, or else a negative error code.
> + */
> +int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
> +                     unsigned int num_slots)
> +{
> +       int err = blk_ksm_init(ksm, num_slots);
> +
> +       if (err)
> +               return err;
> +
> +       return devm_add_action_or_reset(dev, blk_ksm_destroy_callback, ksm);
> +}
> +EXPORT_SYMBOL_GPL(devm_blk_ksm_init);
> +
>  static inline struct hlist_head *
>  blk_ksm_hash_bucket_for_key(struct blk_keyslot_manager *ksm,
>                             const struct blk_crypto_key *key)
> diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
> index 18f3f5346843f..443ad817c6c57 100644
> --- a/include/linux/keyslot-manager.h
> +++ b/include/linux/keyslot-manager.h
> @@ -85,6 +85,9 @@ struct blk_keyslot_manager {
>
>  int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots);
>
> +int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
> +                     unsigned int num_slots);
> +
>  blk_status_t blk_ksm_get_slot_for_key(struct blk_keyslot_manager *ksm,
>                                       const struct blk_crypto_key *key,
>                                       struct blk_ksm_keyslot **slot_ptr);
> --
> 2.30.0
Looks good to me. Please feel free to add
Reviewed-by: Satya Tangirala <satyat@google.com>
