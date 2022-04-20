Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8507AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 09:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377336AbiDTJwy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 05:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377356AbiDTJwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 05:52:45 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E3120A2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 02:49:58 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w1so1891497lfa.4
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 02:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RCepIumJTc+Ol2eklYTZsUMqeV3qtoqi7hyo83V4aqk=;
        b=gVaCT+7OIMYXH+KQgG3R1m5lM3hafnJPhGorwfiQmGt5V8khRllDcINgtHp6n5Y+e8
         duRy3Z3zZA6lvGasXB7OVGssDIcJa7fgbLsvFdOOy0wikesnrQVsOUiyRiGzjgKOdzw8
         YzosyBgBB/NHcfV/1vPcWedKBN0gT9wCgSAm10t69Anw6Tn2pIuxOOaPRCuYieH+vSC5
         UgJfu2+r+udr/QF9Rw++/owF7naC1xR8QGiwydPOKDWCaAjR/eRQOJAc3w6j+SVMYQ2q
         uGpgxs9kOZd784QwUyeMdt3Rn8qXCH5IEwtegGKcbH69YRvjIp56TUzH0aPvNtrLelg7
         jLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCepIumJTc+Ol2eklYTZsUMqeV3qtoqi7hyo83V4aqk=;
        b=I4/P2o1upncVap0CO7vqLqTCDuFgZkGKq/pLNdZ2iIYjWbn7ME/F4tAj6jyxKIF1xs
         EeI1VZHJeEgtZlAwo/Xj4paGdUc77AjgXUlidu2NhD3aFLRgBJyUZnvmyLfKWPNhI5+1
         +29Rp6Vp94sR8oOdUTYJdxoIY5cxj5/hvycPTGkVmBdVBbEVhlNJu2F+aKi7ihzvIrz1
         BkhzgVVwdJfpMnpPD2SIWlaQ2nvaNmKFYUVy2i8LRsOJICbgcw6OgI56qoXY9WOtUPZY
         pRVKR+TevBZ0RRMGj110Kb1FS0wJ2J//6+J4ItTr5uX7N0fY4XI0BhTb1U2DXcF+IAjD
         arLQ==
X-Gm-Message-State: AOAM532N3/niA9eJuVKsH278S5CAtpkeZabTAmUuudLzPuqTfToySE/p
        fwOm3kMP3jBjHkuSaJ2VhkLTXp48MyB0H0swTo702g==
X-Google-Smtp-Source: ABdhPJwVV/2KkUbhjzlgqod62B3EQXJYwKQmE2jLEZwKYtYuapSWZYEHFGlbMpPNdskzDs5iCQd4yP9BBM5RVRPjs4I=
X-Received: by 2002:a05:651c:988:b0:24a:c21f:7057 with SMTP id
 b8-20020a05651c098800b0024ac21f7057mr13144998ljq.16.1650448196128; Wed, 20
 Apr 2022 02:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220420064745.1119823-1-hch@lst.de> <20220420064745.1119823-3-hch@lst.de>
In-Reply-To: <20220420064745.1119823-3-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 20 Apr 2022 11:49:19 +0200
Message-ID: <CAPDyKFogfRSePBJ21yP2n3tD6_H8g6EDRz19-bL_T_1BmcqD+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] blk-crypto: fix the blk_crypto_profile liftime
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Apr 2022 at 08:48, Christoph Hellwig <hch@lst.de> wrote:
>
> Once the blk_crypto_profile is exposed in sysfs it needs to stay alive
> as long as sysfs accesses are possibly pending.  Ensure that by removing
> the blk_crypto_kobj wrapper and just embedding the kobject into the
> actual blk_crypto_profile.  This requires the blk_crypto_profile
> structure to be dynamically allocated, which in turn requires a private
> data pointer for driver use.
>
> Fixes: 20f01f163203 ("blk-crypto: show crypto capabilities in sysfs")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I am not surprised that you seem to have found lifecycle issues, as
it's a rather complex path of how to deal with the resources
correctly. Just for mmc internally, we have three layers of code that
gets involved.

That said, I think the code in the $subject patch looks good to me,
but I have to admit that it's not a full in-depth review - and I
haven't done any tests.

Nevertheless, feel free to add:
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  Documentation/block/inline-encryption.rst |  10 +-
>  block/blk-crypto-fallback.c               |  20 +--
>  block/blk-crypto-profile.c                | 143 ++++++++++------------
>  drivers/md/dm-table.c                     |  28 +----
>  drivers/mmc/core/crypto.c                 |   4 +-
>  drivers/mmc/host/cqhci-crypto.c           |  16 ++-
>  drivers/scsi/ufs/ufshcd-crypto.c          |  31 ++---
>  drivers/scsi/ufs/ufshcd.h                 |   2 +-
>  include/linux/blk-crypto-profile.h        |  19 +--
>  include/linux/blkdev.h                    |   1 -
>  include/linux/mmc/host.h                  |   2 +-
>  11 files changed, 123 insertions(+), 153 deletions(-)
>
> diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
> index 4d151fbe20583..0d740b0f9faf3 100644
> --- a/Documentation/block/inline-encryption.rst
> +++ b/Documentation/block/inline-encryption.rst
> @@ -230,8 +230,8 @@ API presented to device drivers
>
>  A device driver that wants to support inline encryption must set up a
>  blk_crypto_profile in the request_queue of its device.  To do this, it first
> -must call ``blk_crypto_profile_init()`` (or its resource-managed variant
> -``devm_blk_crypto_profile_init()``), providing the number of keyslots.
> +must call ``blk_crypto_profile_alloc()`` (or its resource-managed variant
> +``devm_blk_crypto_profile_alloc()``), providing the number of keyslots.
>
>  Next, it must advertise its crypto capabilities by setting fields in the
>  blk_crypto_profile, e.g. ``modes_supported`` and ``max_dun_bytes_supported``.
> @@ -259,9 +259,9 @@ If there are situations where the inline encryption hardware loses the contents
>  of its keyslots, e.g. device resets, the driver must handle reprogramming the
>  keyslots.  To do this, the driver may call ``blk_crypto_reprogram_all_keys()``.
>
> -Finally, if the driver used ``blk_crypto_profile_init()`` instead of
> -``devm_blk_crypto_profile_init()``, then it is responsible for calling
> -``blk_crypto_profile_destroy()`` when the crypto profile is no longer needed.
> +Finally, if the driver used ``blk_crypto_profile_alloc()`` instead of
> +``devm_blk_crypto_profile_alloc()``, then it is responsible for calling
> +``blk_crypto_profile_put()`` when the crypto profile is no longer needed.
>
>  Layered Devices
>  ===============
> diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
> index 5d1aa5b1d30a1..729974028e448 100644
> --- a/block/blk-crypto-fallback.c
> +++ b/block/blk-crypto-fallback.c
> @@ -78,7 +78,7 @@ static struct blk_crypto_fallback_keyslot {
>         struct crypto_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
>  } *blk_crypto_keyslots;
>
> -static struct blk_crypto_profile blk_crypto_fallback_profile;
> +static struct blk_crypto_profile *blk_crypto_fallback_profile;
>  static struct workqueue_struct *blk_crypto_wq;
>  static mempool_t *blk_crypto_bounce_page_pool;
>  static struct bio_set crypto_bio_split;
> @@ -293,7 +293,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
>          * Get a blk-crypto-fallback keyslot that contains a crypto_skcipher for
>          * this bio's algorithm and key.
>          */
> -       blk_st = blk_crypto_get_keyslot(&blk_crypto_fallback_profile,
> +       blk_st = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
>                                         bc->bc_key, &slot);
>         if (blk_st != BLK_STS_OK) {
>                 src_bio->bi_status = blk_st;
> @@ -396,7 +396,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
>          * Get a blk-crypto-fallback keyslot that contains a crypto_skcipher for
>          * this bio's algorithm and key.
>          */
> -       blk_st = blk_crypto_get_keyslot(&blk_crypto_fallback_profile,
> +       blk_st = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
>                                         bc->bc_key, &slot);
>         if (blk_st != BLK_STS_OK) {
>                 bio->bi_status = blk_st;
> @@ -500,7 +500,7 @@ bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr)
>                 return false;
>         }
>
> -       if (!__blk_crypto_cfg_supported(&blk_crypto_fallback_profile,
> +       if (!__blk_crypto_cfg_supported(blk_crypto_fallback_profile,
>                                         &bc->bc_key->crypto_cfg)) {
>                 bio->bi_status = BLK_STS_NOTSUPP;
>                 return false;
> @@ -527,7 +527,7 @@ bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr)
>
>  int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key)
>  {
> -       return __blk_crypto_evict_key(&blk_crypto_fallback_profile, key);
> +       return __blk_crypto_evict_key(blk_crypto_fallback_profile, key);
>  }
>
>  static bool blk_crypto_fallback_inited;
> @@ -535,7 +535,7 @@ static int blk_crypto_fallback_init(void)
>  {
>         int i;
>         int err;
> -       struct blk_crypto_profile *profile = &blk_crypto_fallback_profile;
> +       struct blk_crypto_profile *profile;
>
>         if (blk_crypto_fallback_inited)
>                 return 0;
> @@ -546,10 +546,10 @@ static int blk_crypto_fallback_init(void)
>         if (err)
>                 goto out;
>
> -       err = blk_crypto_profile_init(profile, blk_crypto_num_keyslots);
> -       if (err)
> -               goto fail_free_bioset;
>         err = -ENOMEM;
> +       profile = blk_crypto_profile_alloc(blk_crypto_num_keyslots);
> +       if (!profile)
> +               goto fail_free_bioset;
>
>         profile->ll_ops = blk_crypto_fallback_ll_ops;
>         profile->max_dun_bytes_supported = BLK_CRYPTO_MAX_IV_SIZE;
> @@ -598,7 +598,7 @@ static int blk_crypto_fallback_init(void)
>  fail_free_wq:
>         destroy_workqueue(blk_crypto_wq);
>  fail_destroy_profile:
> -       blk_crypto_profile_destroy(profile);
> +       blk_crypto_profile_put(profile);
>  fail_free_bioset:
>         bioset_exit(&crypto_bio_split);
>  out:
> diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
> index 4f444323cb491..e4e14322d2f2e 100644
> --- a/block/blk-crypto-profile.c
> +++ b/block/blk-crypto-profile.c
> @@ -42,11 +42,6 @@ struct blk_crypto_keyslot {
>         struct blk_crypto_profile *profile;
>  };
>
> -struct blk_crypto_kobj {
> -       struct kobject kobj;
> -       struct blk_crypto_profile *profile;
> -};
> -
>  struct blk_crypto_attr {
>         struct attribute attr;
>         ssize_t (*show)(struct blk_crypto_profile *profile,
> @@ -55,7 +50,7 @@ struct blk_crypto_attr {
>
>  static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
>  {
> -       return container_of(kobj, struct blk_crypto_kobj, kobj)->profile;
> +       return container_of(kobj, struct blk_crypto_profile, kobj);
>  }
>
>  static struct blk_crypto_attr *attr_to_crypto_attr(struct attribute *attr)
> @@ -145,7 +140,14 @@ static const struct sysfs_ops blk_crypto_attr_ops = {
>
>  static void blk_crypto_release(struct kobject *kobj)
>  {
> -       kfree(container_of(kobj, struct blk_crypto_kobj, kobj));
> +       struct blk_crypto_profile *profile =
> +               container_of(kobj, struct blk_crypto_profile, kobj);
> +
> +       kvfree(profile->slot_hashtable);
> +       kvfree_sensitive(profile->slots,
> +                        sizeof(profile->slots[0]) * profile->num_slots);
> +       memzero_explicit(profile, sizeof(*profile));
> +       kfree(profile);
>  }
>
>  static struct kobj_type blk_crypto_ktype = {
> @@ -160,30 +162,20 @@ static struct kobj_type blk_crypto_ktype = {
>   */
>  int blk_crypto_sysfs_register(struct request_queue *q)
>  {
> -       struct blk_crypto_kobj *obj;
>         int err;
>
>         if (!q->crypto_profile)
>                 return 0;
>
> -       obj = kzalloc(sizeof(*obj), GFP_KERNEL);
> -       if (!obj)
> -               return -ENOMEM;
> -       obj->profile = q->crypto_profile;
> -
> -       err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
> -                                  "crypto");
> -       if (err) {
> -               kobject_put(&obj->kobj);
> -               return err;
> -       }
> -       q->crypto_kobject = &obj->kobj;
> -       return 0;
> +       err = kobject_add(&q->crypto_profile->kobj, &q->kobj, "crypto");
> +       if (err)
> +               kobject_put(&q->crypto_profile->kobj);
> +       return err;
>  }
>
>  void blk_crypto_sysfs_unregister(struct request_queue *q)
>  {
> -       kobject_put(q->crypto_kobject);
> +       kobject_del(&q->crypto_profile->kobj);
>  }
>
>  static inline void blk_crypto_hw_enter(struct blk_crypto_profile *profile)
> @@ -205,30 +197,13 @@ static inline void blk_crypto_hw_exit(struct blk_crypto_profile *profile)
>                 pm_runtime_put_sync(profile->dev);
>  }
>
> -/**
> - * blk_crypto_profile_init() - Initialize a blk_crypto_profile
> - * @profile: the blk_crypto_profile to initialize
> - * @num_slots: the number of keyslots
> - *
> - * Storage drivers must call this when starting to set up a blk_crypto_profile,
> - * before filling in additional fields.
> - *
> - * Return: 0 on success, or else a negative error code.
> - */
> -int blk_crypto_profile_init(struct blk_crypto_profile *profile,
> -                           unsigned int num_slots)
> +/* Initialize keyslot management data. */
> +static int blk_crypto_profile_init_slots(struct blk_crypto_profile *profile,
> +               unsigned int num_slots)
>  {
> +       unsigned int slot_hashtable_size;
>         unsigned int slot;
>         unsigned int i;
> -       unsigned int slot_hashtable_size;
> -
> -       memset(profile, 0, sizeof(*profile));
> -       init_rwsem(&profile->lock);
> -
> -       if (num_slots == 0)
> -               return 0;
> -
> -       /* Initialize keyslot management data. */
>
>         profile->slots = kvcalloc(num_slots, sizeof(profile->slots[0]),
>                                   GFP_KERNEL);
> @@ -261,48 +236,75 @@ int blk_crypto_profile_init(struct blk_crypto_profile *profile,
>                 kvmalloc_array(slot_hashtable_size,
>                                sizeof(profile->slot_hashtable[0]), GFP_KERNEL);
>         if (!profile->slot_hashtable)
> -               goto err_destroy;
> +               return -ENOMEM;
>         for (i = 0; i < slot_hashtable_size; i++)
>                 INIT_HLIST_HEAD(&profile->slot_hashtable[i]);
> -
>         return 0;
> +}
> +
> +/**
> + * blk_crypto_profile_alloc() - Allocate a blk_crypto_profile
> + * @num_slots: the number of keyslots
> + *
> + * Storage drivers must call this when starting to set up a blk_crypto_profile,
> + * before filling in additional fields.
> + *
> + * Return: pointer to the profile on success, or ele %NULL.
> + */
> +struct blk_crypto_profile *blk_crypto_profile_alloc(unsigned int num_slots)
> +{
> +       struct blk_crypto_profile *profile;
>
> -err_destroy:
> -       blk_crypto_profile_destroy(profile);
> -       return -ENOMEM;
> +       profile = kzalloc(sizeof(*profile), GFP_KERNEL);
> +       if (!profile)
> +               return NULL;
> +       kobject_init(&profile->kobj, &blk_crypto_ktype);
> +       init_rwsem(&profile->lock);
> +       if (num_slots && blk_crypto_profile_init_slots(profile, num_slots)) {
> +               blk_crypto_profile_put(profile);
> +               return NULL;
> +       }
> +
> +       return profile;
>  }
> -EXPORT_SYMBOL_GPL(blk_crypto_profile_init);
> +EXPORT_SYMBOL_GPL(blk_crypto_profile_alloc);
>
> -static void blk_crypto_profile_destroy_callback(void *profile)
> +void blk_crypto_profile_put(struct blk_crypto_profile *profile)
>  {
> -       blk_crypto_profile_destroy(profile);
> +       if (profile)
> +               kobject_put(&profile->kobj);
> +}
> +EXPORT_SYMBOL_GPL(blk_crypto_profile_put);
> +
> +static void blk_crypto_profile_put_callback(void *profile)
> +{
> +       blk_crypto_profile_put(profile);
>  }
>
>  /**
> - * devm_blk_crypto_profile_init() - Resource-managed blk_crypto_profile_init()
> + * devm_blk_crypto_profile_alloc() - Resource-managed blk_crypto_profile_alloc()
>   * @dev: the device which owns the blk_crypto_profile
> - * @profile: the blk_crypto_profile to initialize
>   * @num_slots: the number of keyslots
>   *
> - * Like blk_crypto_profile_init(), but causes blk_crypto_profile_destroy() to be
> + * Like blk_crypto_profile_alloc(), but causes blk_crypto_profile_put() to be
>   * called automatically on driver detach.
>   *
> - * Return: 0 on success, or else a negative error code.
> + * Return: profile on success, or else %NULL.
>   */
> -int devm_blk_crypto_profile_init(struct device *dev,
> -                                struct blk_crypto_profile *profile,
> +struct blk_crypto_profile *devm_blk_crypto_profile_alloc(struct device *dev,
>                                  unsigned int num_slots)
>  {
> -       int err = blk_crypto_profile_init(profile, num_slots);
> -
> -       if (err)
> -               return err;
> +       struct blk_crypto_profile *profile;
>
> -       return devm_add_action_or_reset(dev,
> -                                       blk_crypto_profile_destroy_callback,
> -                                       profile);
> +       profile = blk_crypto_profile_alloc(num_slots);
> +       if (!profile)
> +               return NULL;
> +       if (devm_add_action_or_reset(dev, blk_crypto_profile_put_callback,
> +                       profile))
> +               return NULL;
> +       return profile;
>  }
> -EXPORT_SYMBOL_GPL(devm_blk_crypto_profile_init);
> +EXPORT_SYMBOL_GPL(devm_blk_crypto_profile_alloc);
>
>  static inline struct hlist_head *
>  blk_crypto_hash_bucket_for_key(struct blk_crypto_profile *profile,
> @@ -585,17 +587,6 @@ void blk_crypto_reprogram_all_keys(struct blk_crypto_profile *profile)
>  }
>  EXPORT_SYMBOL_GPL(blk_crypto_reprogram_all_keys);
>
> -void blk_crypto_profile_destroy(struct blk_crypto_profile *profile)
> -{
> -       if (!profile)
> -               return;
> -       kvfree(profile->slot_hashtable);
> -       kvfree_sensitive(profile->slots,
> -                        sizeof(profile->slots[0]) * profile->num_slots);
> -       memzero_explicit(profile, sizeof(*profile));
> -}
> -EXPORT_SYMBOL_GPL(blk_crypto_profile_destroy);
> -
>  bool blk_crypto_register(struct blk_crypto_profile *profile,
>                          struct request_queue *q)
>  {
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e7d42f6335a2a..0d40f9e9eefbc 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1185,11 +1185,6 @@ static int dm_table_register_integrity(struct dm_table *t)
>
>  #ifdef CONFIG_BLK_INLINE_ENCRYPTION
>
> -struct dm_crypto_profile {
> -       struct blk_crypto_profile profile;
> -       struct mapped_device *md;
> -};
> -
>  struct dm_keyslot_evict_args {
>         const struct blk_crypto_key *key;
>         int err;
> @@ -1215,8 +1210,7 @@ static int dm_keyslot_evict_callback(struct dm_target *ti, struct dm_dev *dev,
>  static int dm_keyslot_evict(struct blk_crypto_profile *profile,
>                             const struct blk_crypto_key *key, unsigned int slot)
>  {
> -       struct mapped_device *md =
> -               container_of(profile, struct dm_crypto_profile, profile)->md;
> +       struct mapped_device *md = profile->private;
>         struct dm_keyslot_evict_args args = { key };
>         struct dm_table *t;
>         int srcu_idx;
> @@ -1250,15 +1244,7 @@ device_intersect_crypto_capabilities(struct dm_target *ti, struct dm_dev *dev,
>
>  void dm_destroy_crypto_profile(struct blk_crypto_profile *profile)
>  {
> -       struct dm_crypto_profile *dmcp = container_of(profile,
> -                                                     struct dm_crypto_profile,
> -                                                     profile);
> -
> -       if (!profile)
> -               return;
> -
> -       blk_crypto_profile_destroy(profile);
> -       kfree(dmcp);
> +       blk_crypto_profile_put(profile);
>  }
>
>  static void dm_table_destroy_crypto_profile(struct dm_table *t)
> @@ -1278,19 +1264,15 @@ static void dm_table_destroy_crypto_profile(struct dm_table *t)
>   */
>  static int dm_table_construct_crypto_profile(struct dm_table *t)
>  {
> -       struct dm_crypto_profile *dmcp;
>         struct blk_crypto_profile *profile;
>         struct dm_target *ti;
>         unsigned int i;
>         bool empty_profile = true;
>
> -       dmcp = kmalloc(sizeof(*dmcp), GFP_KERNEL);
> -       if (!dmcp)
> +       profile = blk_crypto_profile_alloc(0);
> +       if (!profile)
>                 return -ENOMEM;
> -       dmcp->md = t->md;
> -
> -       profile = &dmcp->profile;
> -       blk_crypto_profile_init(profile, 0);
> +       profile->private = t->md;
>         profile->ll_ops.keyslot_evict = dm_keyslot_evict;
>         profile->max_dun_bytes_supported = UINT_MAX;
>         memset(profile->modes_supported, 0xFF,
> diff --git a/drivers/mmc/core/crypto.c b/drivers/mmc/core/crypto.c
> index fec4fbf16a5b6..df3c002526cc7 100644
> --- a/drivers/mmc/core/crypto.c
> +++ b/drivers/mmc/core/crypto.c
> @@ -16,13 +16,13 @@ void mmc_crypto_set_initial_state(struct mmc_host *host)
>  {
>         /* Reset might clear all keys, so reprogram all the keys. */
>         if (host->caps2 & MMC_CAP2_CRYPTO)
> -               blk_crypto_reprogram_all_keys(&host->crypto_profile);
> +               blk_crypto_reprogram_all_keys(host->crypto_profile);
>  }
>
>  void mmc_crypto_setup_queue(struct request_queue *q, struct mmc_host *host)
>  {
>         if (host->caps2 & MMC_CAP2_CRYPTO)
> -               blk_crypto_register(&host->crypto_profile, q);
> +               blk_crypto_register(host->crypto_profile, q);
>  }
>  EXPORT_SYMBOL_GPL(mmc_crypto_setup_queue);
>
> diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
> index d5f4b6972f63e..6b1c111e9e4b2 100644
> --- a/drivers/mmc/host/cqhci-crypto.c
> +++ b/drivers/mmc/host/cqhci-crypto.c
> @@ -25,8 +25,7 @@ static const struct cqhci_crypto_alg_entry {
>  static inline struct cqhci_host *
>  cqhci_host_from_crypto_profile(struct blk_crypto_profile *profile)
>  {
> -       struct mmc_host *mmc =
> -               container_of(profile, struct mmc_host, crypto_profile);
> +       struct mmc_host *mmc = profile->private;
>
>         return mmc->cqe_private;
>  }
> @@ -169,7 +168,7 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
>  {
>         struct mmc_host *mmc = cq_host->mmc;
>         struct device *dev = mmc_dev(mmc);
> -       struct blk_crypto_profile *profile = &mmc->crypto_profile;
> +       struct blk_crypto_profile *profile;
>         unsigned int num_keyslots;
>         unsigned int cap_idx;
>         enum blk_crypto_mode_num blk_mode_num;
> @@ -180,6 +179,7 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
>             !(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
>                 goto out;
>
> +       err = -ENOMEM;
>         cq_host->crypto_capabilities.reg_val =
>                         cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
>
> @@ -189,10 +189,8 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
>         cq_host->crypto_cap_array =
>                 devm_kcalloc(dev, cq_host->crypto_capabilities.num_crypto_cap,
>                              sizeof(cq_host->crypto_cap_array[0]), GFP_KERNEL);
> -       if (!cq_host->crypto_cap_array) {
> -               err = -ENOMEM;
> +       if (!cq_host->crypto_cap_array)
>                 goto out;
> -       }
>
>         /*
>          * CCAP.CFGC is off by one, so the actual number of crypto
> @@ -200,10 +198,10 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
>          */
>         num_keyslots = cq_host->crypto_capabilities.config_count + 1;
>
> -       err = devm_blk_crypto_profile_init(dev, profile, num_keyslots);
> -       if (err)
> +       profile = devm_blk_crypto_profile_alloc(dev, num_keyslots);
> +       if (!profile)
>                 goto out;
> -
> +       profile->private = mmc;
>         profile->ll_ops = cqhci_crypto_ops;
>         profile->dev = dev;
>
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index 67402baf6faee..b48ff6046bdc8 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -52,8 +52,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
>                                          const struct blk_crypto_key *key,
>                                          unsigned int slot)
>  {
> -       struct ufs_hba *hba =
> -               container_of(profile, struct ufs_hba, crypto_profile);
> +       struct ufs_hba *hba = profile->private;
>         const union ufs_crypto_cap_entry *ccap_array = hba->crypto_cap_array;
>         const struct ufs_crypto_alg_entry *alg =
>                         &ufs_crypto_algs[key->crypto_cfg.crypto_mode];
> @@ -110,10 +109,7 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
>                                        const struct blk_crypto_key *key,
>                                        unsigned int slot)
>  {
> -       struct ufs_hba *hba =
> -               container_of(profile, struct ufs_hba, crypto_profile);
> -
> -       return ufshcd_clear_keyslot(hba, slot);
> +       return ufshcd_clear_keyslot(profile->private, slot);
>  }
>
>  bool ufshcd_crypto_enable(struct ufs_hba *hba)
> @@ -122,7 +118,7 @@ bool ufshcd_crypto_enable(struct ufs_hba *hba)
>                 return false;
>
>         /* Reset might clear all keys, so reprogram all the keys. */
> -       blk_crypto_reprogram_all_keys(&hba->crypto_profile);
> +       blk_crypto_reprogram_all_keys(hba->crypto_profile);
>         return true;
>  }
>
> @@ -168,6 +164,7 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>             !(hba->caps & UFSHCD_CAP_CRYPTO))
>                 goto out;
>
> +       err = -ENOMEM;
>         hba->crypto_capabilities.reg_val =
>                         cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
>         hba->crypto_cfg_register =
> @@ -175,22 +172,20 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>         hba->crypto_cap_array =
>                 devm_kcalloc(hba->dev, hba->crypto_capabilities.num_crypto_cap,
>                              sizeof(hba->crypto_cap_array[0]), GFP_KERNEL);
> -       if (!hba->crypto_cap_array) {
> -               err = -ENOMEM;
> +       if (!hba->crypto_cap_array)
>                 goto out;
> -       }
>
>         /* The actual number of configurations supported is (CFGC+1) */
> -       err = devm_blk_crypto_profile_init(
> -                       hba->dev, &hba->crypto_profile,
> +       hba->crypto_profile = devm_blk_crypto_profile_alloc(hba->dev,
>                         hba->crypto_capabilities.config_count + 1);
> -       if (err)
> +       if (!hba->crypto_profile)
>                 goto out;
>
> -       hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
> +       hba->crypto_profile->private = hba;
> +       hba->crypto_profile->ll_ops = ufshcd_crypto_ops;
>         /* UFS only supports 8 bytes for any DUN */
> -       hba->crypto_profile.max_dun_bytes_supported = 8;
> -       hba->crypto_profile.dev = hba->dev;
> +       hba->crypto_profile->max_dun_bytes_supported = 8;
> +       hba->crypto_profile->dev = hba->dev;
>
>         /*
>          * Cache all the UFS crypto capabilities and advertise the supported
> @@ -205,7 +200,7 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>                 blk_mode_num = ufshcd_find_blk_crypto_mode(
>                                                 hba->crypto_cap_array[cap_idx]);
>                 if (blk_mode_num != BLK_ENCRYPTION_MODE_INVALID)
> -                       hba->crypto_profile.modes_supported[blk_mode_num] |=
> +                       hba->crypto_profile->modes_supported[blk_mode_num] |=
>                                 hba->crypto_cap_array[cap_idx].sdus_mask * 512;
>         }
>
> @@ -236,5 +231,5 @@ void ufshcd_init_crypto(struct ufs_hba *hba)
>  void ufshcd_crypto_register(struct ufs_hba *hba, struct request_queue *q)
>  {
>         if (hba->caps & UFSHCD_CAP_CRYPTO)
> -               blk_crypto_register(&hba->crypto_profile, q);
> +               blk_crypto_register(hba->crypto_profile, q);
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 94f545be183aa..94edbe3721890 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -930,7 +930,7 @@ struct ufs_hba {
>         union ufs_crypto_capabilities crypto_capabilities;
>         union ufs_crypto_cap_entry *crypto_cap_array;
>         u32 crypto_cfg_register;
> -       struct blk_crypto_profile crypto_profile;
> +       struct blk_crypto_profile *crypto_profile;
>  #endif
>  #ifdef CONFIG_DEBUG_FS
>         struct dentry *debugfs_root;
> diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
> index bbab65bd54288..07745a4675f25 100644
> --- a/include/linux/blk-crypto-profile.h
> +++ b/include/linux/blk-crypto-profile.h
> @@ -8,6 +8,7 @@
>
>  #include <linux/bio.h>
>  #include <linux/blk-crypto.h>
> +#include <linux/kobject.h>
>
>  struct blk_crypto_profile;
>
> @@ -100,6 +101,11 @@ struct blk_crypto_profile {
>          */
>         struct device *dev;
>
> +       /**
> +        * @private: Optional private data for driver use.
> +        */
> +       void *private;
> +
>         /* private: The following fields shouldn't be accessed by drivers. */
>
>         /* Number of keyslots, or 0 if not applicable */
> @@ -127,14 +133,13 @@ struct blk_crypto_profile {
>
>         /* Per-keyslot data */
>         struct blk_crypto_keyslot *slots;
> -};
>
> -int blk_crypto_profile_init(struct blk_crypto_profile *profile,
> -                           unsigned int num_slots);
> +       struct kobject kobj;
> +};
>
> -int devm_blk_crypto_profile_init(struct device *dev,
> -                                struct blk_crypto_profile *profile,
> -                                unsigned int num_slots);
> +struct blk_crypto_profile *blk_crypto_profile_alloc(unsigned int num_slots);
> +struct blk_crypto_profile *devm_blk_crypto_profile_alloc(struct device *dev,
> +               unsigned int num_slots);
>
>  unsigned int blk_crypto_keyslot_index(struct blk_crypto_keyslot *slot);
>
> @@ -152,7 +157,7 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
>
>  void blk_crypto_reprogram_all_keys(struct blk_crypto_profile *profile);
>
> -void blk_crypto_profile_destroy(struct blk_crypto_profile *profile);
> +void blk_crypto_profile_put(struct blk_crypto_profile *profile);
>
>  void blk_crypto_intersect_capabilities(struct blk_crypto_profile *parent,
>                                        const struct blk_crypto_profile *child);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 34724b15813b7..390e3c4ad64b6 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -413,7 +413,6 @@ struct request_queue {
>
>  #ifdef CONFIG_BLK_INLINE_ENCRYPTION
>         struct blk_crypto_profile *crypto_profile;
> -       struct kobject *crypto_kobject;
>  #endif
>
>         unsigned int            rq_timeout;
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 7afb57cab00b7..8d6069503c0dc 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -495,7 +495,7 @@ struct mmc_host {
>
>         /* Inline encryption support */
>  #ifdef CONFIG_MMC_CRYPTO
> -       struct blk_crypto_profile crypto_profile;
> +       struct blk_crypto_profile *crypto_profile;
>  #endif
>
>         /* Host Software Queue support */
> --
> 2.30.2
>
