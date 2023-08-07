Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF08BC04A6A
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 15:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjHGPB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 11:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjHGPB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 11:01:28 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBFC10CA
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 08:01:25 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-d0548cf861aso4888965276.3
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2023 08:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691420485; x=1692025285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ou5UOAgRK9IFzp5RVUUxlwlvyWmk6ztlO9htLsNxvOQ=;
        b=LSrHXj53ID3RyCoPAuGuP076PetmyBBoLglo0czMgF4JeKxHlYxJr9swFuMKS54bKl
         36iSIYC3g+5Q6VXr1T1QaA8SwL2sDDinICR5vOZysshu4ZzfjTSIbLRt1hOCdU8XvOZL
         tRGz4znHZzarJytYckIj1ci+7xrKJA3jUZZm5Xb580BX3MLOaOv4+JQM+JVbJ2LIKsky
         BeHRN2rBIYINl/ZBMVo6Vnlnx+UdhEMYYsrxd769M4RZcOd1szT4Hw6DcvVc5ev7f0KM
         OdAYtDQ4cFbhsOwk6xoUyQBABQYms+tmCCU2FzrP8e8cfOQYxG2g2fnT2XXU0Nggg2QS
         K5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691420485; x=1692025285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ou5UOAgRK9IFzp5RVUUxlwlvyWmk6ztlO9htLsNxvOQ=;
        b=dg6sne+h1aKKtXxwhvKLu2zlH4QTP4+0O+nNYC1eIn+Hy5IOQZzMRO3qbUc5lgdNRp
         7jJ3p55Rjk7tef1iDedjvvcBqLBoihKiji/nok9bGgfPi4jpt6AUP2DzfSJcStQtss50
         u0Rn0lffMvngLb1+eHCKlz9f5XbHm5loWKKnJY8YyBYrtSwuUUE4aGTzde3JS0yulob4
         gGSUrtP0a+EbSVUcHhBxNLBktFjoWoiOpbYtNCp/zKDYSouotz2mWpANMeFgomoKxGd7
         oHFNe8JivMYJsMWQEhkw7Xjfcz5GFHkyg5YlFfBnuKcxqSbCnptDKx5j50GIi/XOqK7R
         FUZw==
X-Gm-Message-State: AOJu0YwsONRhd/mNZRQuUIwiO7LRgUd9fixuWqP8TpPp9/WYpYdCsXHs
        rGEc9QW1CjK1ycmM1GwXpdcx3uGFzc67SlNmy8pTbg==
X-Google-Smtp-Source: AGHT+IFfsbMkd+ynXUPcE2+wKzivGqSyO4/1FrdMlVRWegFnSXOFwJA6NY9cOo1Nb25e/hL9U+gXlOTNUp/pT+wD7bk=
X-Received: by 2002:a25:2f56:0:b0:d48:9ea:4266 with SMTP id
 v83-20020a252f56000000b00d4809ea4266mr5915927ybv.7.1691420484966; Mon, 07 Aug
 2023 08:01:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230722014037.42647-1-shyamsaini@linux.microsoft.com> <20230722014037.42647-2-shyamsaini@linux.microsoft.com>
In-Reply-To: <20230722014037.42647-2-shyamsaini@linux.microsoft.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 7 Aug 2023 17:00:48 +0200
Message-ID: <CAPDyKFoBC+GaGerGDEAjg9q4ayV9mMBKkfFk3nO-zcQzOZ_H6Q@mail.gmail.com>
Subject: Re: [RFC, PATCH 1/1] rpmb: add Replay Protected Memory Block (RPMB) driver
To:     Shyam Saini <shyamsaini@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, linux-scsi@vger.kernel.org,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Tyler Hicks <code@tyhicks.com>,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>,
        Paul Moore <paul@paul-moore.com>,
        Allen Pais <apais@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 22 Jul 2023 at 03:41, Shyam Saini
<shyamsaini@linux.microsoft.com> wrote:
>
> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> [This is patch 1 from [1] Alex's submission and this RPMB layer was
> originally proposed by [2]Thomas Winkler ]
>
> A number of storage technologies support a specialised hardware
> partition designed to be resistant to replay attacks. The underlying
> HW protocols differ but the operations are common. The RPMB partition
> cannot be accessed via standard block layer, but by a set of specific
> commands: WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY. Such a
> partition provides authenticated and replay protected access, hence
> suitable as a secure storage.
>
> The initial aim of this patch is to provide a simple RPMB Driver which
> can be accessed by Linux's optee driver to facilitate fast-path for
> RPMB access to optee OS(secure OS) during the boot time. [1] Currently,
> Optee OS relies on user-tee supplicant to access eMMC RPMB partition.
>
> A TEE device driver can claim the RPMB interface, for example, via
> class_interface_register(). The RPMB driver provides a series of
> operations for interacting with the device.

I don't quite follow this. More exactly, how will the TEE driver know
what RPMB device it should use?

>
>   * program_key - a one time operation for setting up a new device
>   * get_capacity - introspect the device capacity
>   * get_write_counter - check the write counter
>   * write_blocks - write a series of blocks to the RPMB device
>   * read_blocks - read a series of blocks from the RPMB device
>
> The detailed operation of implementing the access is left to the TEE
> device driver itself.
>
> The framing details and HW specific bits (JDEC vs NVME frames) are
> left to the lower level TEE driver to worry about.
>
> Without kernel fast path to RPMB access doesn't work when IMA try to
> extend ftpm's PCR registers.
>
> This fast-path would require additional work in linux optee driver and
> as well as in MMC driver.
>
> [1] https://lore.kernel.org/lkml/20220405093759.1126835-2-alex.bennee@lin=
aro.org/
> [2] https://lore.kernel.org/linux-mmc/1478548394-8184-2-git-send-email-to=
mas.winkler@intel.com/
> [3] https://optee.readthedocs.io/en/latest/architecture/secure_storage.ht=
ml
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
>

[...]

> +/**
> + * rpmb_dev_find_device() - return first matching rpmb device
> + * @data: data for the match function
> + * @match: the matching function
> + *
> + * Return: matching rpmb device or NULL on failure
> + */
> +static
> +struct rpmb_dev *rpmb_dev_find_device(const void *data,
> +                                     int (*match)(struct device *dev,
> +                                                  const void *data))
> +{
> +       struct device *dev;
> +
> +       dev =3D class_find_device(&rpmb_class, NULL, data, match);
> +
> +       return dev ? to_rpmb_dev(dev) : NULL;
> +}
> +
> +struct device_with_target {
> +       const struct device *dev;
> +       u8 target;
> +};
> +
> +static int match_by_parent(struct device *dev, const void *data)
> +{
> +       const struct device_with_target *d =3D data;
> +       struct rpmb_dev *rdev =3D to_rpmb_dev(dev);
> +
> +       return (d->dev && dev->parent =3D=3D d->dev && rdev->target =3D=
=3D d->target);
> +}
> +
> +/**
> + * rpmb_dev_find_by_device() - retrieve rpmb device from the parent devi=
ce
> + * @parent: parent device of the rpmb device
> + * @target: RPMB target/region within the physical device
> + *
> + * Return: NULL if there is no rpmb device associated with the parent de=
vice
> + */
> +struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent, u8 targe=
t)
> +{
> +       struct device_with_target t;
> +
> +       if (!parent)
> +               return NULL;
> +
> +       t.dev =3D parent;
> +       t.target =3D target;
> +
> +       return rpmb_dev_find_device(&t, match_by_parent);
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_find_by_device);

Is this what the TEE driver would be calling to find the rpmb device/partit=
ion?

> +
> +/**
> + * rpmb_dev_unregister() - unregister RPMB partition from the RPMB subsy=
stem
> + * @rdev: the rpmb device to unregister
> + * Return:
> + * *        0 on success
> + * *        -EINVAL on wrong parameters
> + */
> +int rpmb_dev_unregister(struct rpmb_dev *rdev)
> +{
> +       if (!rdev)
> +               return -EINVAL;
> +
> +       mutex_lock(&rdev->lock);
> +       rpmb_cdev_del(rdev);

I can't find the function above. I guess it should be included as a
part of the patch too?

> +       device_del(&rdev->dev);
> +       mutex_unlock(&rdev->lock);
> +
> +       rpmb_dev_put(rdev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_unregister);

[...]

> +/**
> + * rpmb_dev_register - register RPMB partition with the RPMB subsystem
> + * @dev: storage device of the rpmb device
> + * @target: RPMB target/region within the physical device
> + * @ops: device specific operations
> + *
> + * Return: a pointer to rpmb device
> + */
> +struct rpmb_dev *rpmb_dev_register(struct device *dev, u8 target,
> +                                  const struct rpmb_ops *ops)
> +{
> +       struct rpmb_dev *rdev;
> +       int id;
> +       int ret;
> +
> +       if (!dev || !ops)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->program_key)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->get_capacity)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->get_write_counter)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->write_blocks)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->read_blocks)
> +               return ERR_PTR(-EINVAL);
> +
> +       rdev =3D kzalloc(sizeof(*rdev), GFP_KERNEL);
> +       if (!rdev)
> +               return ERR_PTR(-ENOMEM);
> +
> +       id =3D ida_simple_get(&rpmb_ida, 0, 0, GFP_KERNEL);
> +       if (id < 0) {
> +               ret =3D id;
> +               goto exit;
> +       }
> +
> +       mutex_init(&rdev->lock);
> +       rdev->ops =3D ops;
> +       rdev->id =3D id;
> +       rdev->target =3D target;
> +
> +       dev_set_name(&rdev->dev, "rpmb%d", id);
> +       rdev->dev.class =3D &rpmb_class;
> +       rdev->dev.parent =3D dev;
> +
> +       rpmb_cdev_prepare(rdev);

Ditto.

> +
> +       ret =3D device_register(&rdev->dev);
> +       if (ret)
> +               goto exit;
> +
> +       rpmb_cdev_add(rdev);

Ditto.

> +
> +       dev_dbg(&rdev->dev, "registered device\n");
> +
> +       return rdev;
> +
> +exit:
> +       if (id >=3D 0)
> +               ida_simple_remove(&rpmb_ida, id);
> +       kfree(rdev);
> +       return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_register);
> +

[...]

Kind regards
Uffe
