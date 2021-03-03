Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4922C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C047064EBA
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359474AbhCDAdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245087AbhCCPab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 10:30:31 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E440FC061764
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 07:29:04 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id b189so6829030vsd.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 07:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KOWZlUd6GenvEODNx0fWlP0gjvoHrfVm7N8nZQCNQL0=;
        b=FpnWCZFCt1C6WPgz7+OSlhAdqVmA42QAhTgXZ2QMp56oLAHlvQMv+tJqfpNqvnIBgD
         fpxO5Jo4Ge+c6pGT8QAKVdbLSs/xogc1bUai5y9rRLTqpmYfGE2C+m4HEbYqkdjHHYKD
         2gUTwbL2WJWLlrIrIniUod0YrEUe0SKihThelsp4gxO9jDXTh83AgdSUUWxdhkWOdSAt
         PpFUPeK5rOz9rgFPhfeo9hlunOh3qy6A2w5SSVNBNV8wnURF+RP+8OKz2q7KMLnqL/ib
         R2esezvtQgho9wkh4TEqhP8dw0SNUHiyFwl1K39GPCwjrTfcT615ihTIaUNZjH1WYOBi
         jyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KOWZlUd6GenvEODNx0fWlP0gjvoHrfVm7N8nZQCNQL0=;
        b=EFkcIt105t+8gDVZGShbQr1gYPRSLsD6tsiKQYOZ99LZKn1BysihIanmvyNr8vq6hU
         ju30hoTwETTRjiMN6MxJLqUriy9+I8iUfMXY0KTtkmpcBMGHbR63viiNnq3O1YoOWQJs
         lUeC1CQwzkC+iCJxb+75Y0IhGeZmaSqnmCS17g0Z+7qfPS+TMB7h8hdI56VPus8rSNBN
         f+o+PDmOYQ9y6BR2pNxICLFNqeQwVOkFmt9Q23ITrC6WPvf+BX4gVXeqQixaWiNamA8G
         b4p0VpD5UwY83OZPRt1vn/sjjQ/HNW4Bh5rxq2ZbE7YpDi7cWtCQdVO5kmKDNT3iUmUF
         x1Yw==
X-Gm-Message-State: AOAM533Zuvt6gL7gCy06DZy6jN8HIxt8cJthdk8WOt1Bw7TCH1/RjDyJ
        00En0Oy5luLMORzMM1Yc03qRkVRXgvbWA79EkgL5oQ==
X-Google-Smtp-Source: ABdhPJyrMWEfKBZY3DeXglIQDTpc048s6+gDeeM5HlJiXjN9GYj1RqokOu+ImCuZ5/X2z85T2eCuZOgZUt0dteUT/ks=
X-Received: by 2002:a67:ec7:: with SMTP id 190mr2237954vso.42.1614785343976;
 Wed, 03 Mar 2021 07:29:03 -0800 (PST)
MIME-Version: 1.0
References: <20210303135500.24673-1-alex.bennee@linaro.org> <20210303135500.24673-2-alex.bennee@linaro.org>
In-Reply-To: <20210303135500.24673-2-alex.bennee@linaro.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 3 Mar 2021 16:28:27 +0100
Message-ID: <CAPDyKFrJJEyF95s3tVjFWFK3rq0OdJh9ec_ihg-S7uFCtPKTdQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] rpmb: add Replay Protected Memory Block (RPMB) subsystem
To:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Uvarov <maxim.uvarov@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Ruchika Gupta <ruchika.gupta@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>, yang.huang@intel.com,
        bing.zhu@intel.com, Matti.Moell@opensynergy.com,
        hmo@opensynergy.com,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 3 Mar 2021 at 14:55, Alex Benn=C3=A9e <alex.bennee@linaro.org> wrot=
e:
>
> A number of storage technologies support a specialised hardware
> partition designed to be resistant to replay attacks. The underlying
> HW protocols differ but the operations are common. The RPMB partition
> cannot be accessed via standard block layer, but by a set of specific
> commands: WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY. Such a
> partition provides authenticated and replay protected access, hence
> suitable as a secure storage.
>
> The RPMB layer aims to provide in-kernel API for Trusted Execution
> Environment (TEE) devices that are capable to securely compute block
> frame signature. In case a TEE device wishes to store a replay
> protected data, requests the storage device via RPMB layer to store
> the data.
>
> A TEE device driver can claim the RPMB interface, for example, via
> class_interface_register(). The RPMB layer provides a series of
> operations for interacting with the device.
>
>   * program_key - a one time operation for setting up a new device
>   * get_capacity - introspect the device capacity
>   * get_write_count - check the write counter
>   * write_blocks - write a series of blocks to the RPMB device
>   * read_blocks - read a series of blocks from the RPMB device
>
> The detailed operation of implementing the access is left to the TEE
> device driver itself.
>
> [This is based-on Thomas Winkler's proposed API from:
>
>   https://lore.kernel.org/linux-mmc/1478548394-8184-2-git-send-email-toma=
s.winkler@intel.com/
>
> The principle difference is the framing details and HW specific
> bits (JDEC vs NVME frames) are left to the lower level TEE driver to
> worry about. The eventual userspace ioctl interface will aim to be
> similarly generic. This is an RFC to follow up on:
>
>   Subject: RPMB user space ABI
>   Date: Thu, 11 Feb 2021 14:07:00 +0000
>   Message-ID: <87mtwashi4.fsf@linaro.org>]
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Linus  Walleij <linus.walleij@linaro.org>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Alex, I promise to have a closer look at this and provide my opinions.

However, it looks like you have posted patch 1 and patch2, but the
remainder 3, 4, 5 I can't find. Was this perhaps intentional?

Moreover, I think these kinds of changes deserve a proper
cover-letter, describing the overall goal with the series. Can you
perhaps re-submit, so clarify things.

Kind regards
Uffe

> ---
>  MAINTAINERS                |   7 +
>  drivers/char/Kconfig       |   2 +
>  drivers/char/Makefile      |   1 +
>  drivers/char/rpmb/Kconfig  |  11 +
>  drivers/char/rpmb/Makefile |   7 +
>  drivers/char/rpmb/core.c   | 429 +++++++++++++++++++++++++++++++++++++
>  include/linux/rpmb.h       | 163 ++++++++++++++
>  7 files changed, 620 insertions(+)
>  create mode 100644 drivers/char/rpmb/Kconfig
>  create mode 100644 drivers/char/rpmb/Makefile
>  create mode 100644 drivers/char/rpmb/core.c
>  create mode 100644 include/linux/rpmb.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bfc1b86e3e73..076f3983526c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15369,6 +15369,13 @@ T:     git git://linuxtv.org/media_tree.git
>  F:     Documentation/devicetree/bindings/media/allwinner,sun8i-a83t-de2-=
rotate.yaml
>  F:     drivers/media/platform/sunxi/sun8i-rotate/
>
> +RPMB SUBSYSTEM
> +M:     ?
> +L:     linux-kernel@vger.kernel.org
> +S:     Supported
> +F:     drivers/char/rpmb/*
> +F:     include/linux/rpmb.h
> +
>  RTL2830 MEDIA DRIVER
>  M:     Antti Palosaari <crope@iki.fi>
>  L:     linux-media@vger.kernel.org
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index d229a2d0c017..a7834cc3e0ea 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -471,6 +471,8 @@ config ADI
>           and SSM (Silicon Secured Memory).  Intended consumers of this
>           driver include crash and makedumpfile.
>
> +source "drivers/char/rpmb/Kconfig"
> +
>  endmenu
>
>  config RANDOM_TRUST_CPU
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index ffce287ef415..0eed6e21a7a7 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -47,3 +47,4 @@ obj-$(CONFIG_PS3_FLASH)               +=3D ps3flash.o
>  obj-$(CONFIG_XILLYBUS)         +=3D xillybus/
>  obj-$(CONFIG_POWERNV_OP_PANEL) +=3D powernv-op-panel.o
>  obj-$(CONFIG_ADI)              +=3D adi.o
> +obj-$(CONFIG_RPMB)             +=3D rpmb/
> diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
> new file mode 100644
> index 000000000000..431c2823cf70
> --- /dev/null
> +++ b/drivers/char/rpmb/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2015-2019, Intel Corporation.
> +
> +config RPMB
> +       tristate "RPMB partition interface"
> +       help
> +         Unified RPMB partition interface for eMMC and UFS.
> +         Provides interface for in kernel security controllers to
> +         access RPMB partition.
> +
> +         If unsure, select N.
> diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
> new file mode 100644
> index 000000000000..24d4752a9a53
> --- /dev/null
> +++ b/drivers/char/rpmb/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2015-2019, Intel Corporation.
> +
> +obj-$(CONFIG_RPMB) +=3D rpmb.o
> +rpmb-objs +=3D core.o
> +
> +ccflags-y +=3D -D__CHECK_ENDIAN__
> diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
> new file mode 100644
> index 000000000000..a2e21c14986a
> --- /dev/null
> +++ b/drivers/char/rpmb/core.c
> @@ -0,0 +1,429 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2015 - 2019 Intel Corporation. All rights reserved.
> + * Copyright(c) 2021 - Linaro Ltd.
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +
> +#include <linux/rpmb.h>
> +
> +static DEFINE_IDA(rpmb_ida);
> +
> +/**
> + * rpmb_dev_get() - increase rpmb device ref counter
> + * @rdev: rpmb device
> + */
> +struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev)
> +{
> +       return get_device(&rdev->dev) ? rdev : NULL;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_get);
> +
> +/**
> + * rpmb_dev_put() - decrease rpmb device ref counter
> + * @rdev: rpmb device
> + */
> +void rpmb_dev_put(struct rpmb_dev *rdev)
> +{
> +       put_device(&rdev->dev);
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_put);
> +
> +/**
> + * rpmb_program_key() - program the RPMB access key
> + * @rdev: rpmb device
> + * @key: key data
> + * @keylen: length of key data
> + *
> + * A successful programming of the key implies it has been set by the
> + * driver and can be used.
> + *
> + * Return:
> + * *        0 on success
> + * *        -EINVAL on wrong parameters
> + * *        -EPERM key already programmed
> + * *        -EOPNOTSUPP if device doesn't support the requested operatio=
n
> + * *        < 0 if the operation fails
> + */
> +int rpmb_program_key(struct rpmb_dev *rdev, key_serial_t keyid)
> +{
> +       int err;
> +
> +       if (!rdev || !keyid)
> +               return -EINVAL;
> +
> +       mutex_lock(&rdev->lock);
> +       err =3D -EOPNOTSUPP;
> +       if (rdev->ops && rdev->ops->program_key) {
> +               err =3D rdev->ops->program_key(rdev->dev.parent, rdev->ta=
rget,
> +                                            keyid);
> +       }
> +       mutex_unlock(&rdev->lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_program_key);
> +
> +/**
> + * rpmb_get_capacity() - returns the capacity of the rpmb device
> + * @rdev: rpmb device
> + *
> + * Return:
> + * *        capacity of the device in units of 128K, on success
> + * *        -EINVAL on wrong parameters
> + * *        -EOPNOTSUPP if device doesn't support the requested operatio=
n
> + * *        < 0 if the operation fails
> + */
> +int rpmb_get_capacity(struct rpmb_dev *rdev)
> +{
> +       int err;
> +
> +       if (!rdev)
> +               return -EINVAL;
> +
> +       mutex_lock(&rdev->lock);
> +       err =3D -EOPNOTSUPP;
> +       if (rdev->ops && rdev->ops->get_capacity)
> +               err =3D rdev->ops->get_capacity(rdev->dev.parent, rdev->t=
arget);
> +       mutex_unlock(&rdev->lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_get_capacity);
> +
> +/**
> + * rpmb_get_write_count() - returns the write counter of the rpmb device
> + * @rdev: rpmb device
> + *
> + * Return:
> + * *        counter
> + * *        -EINVAL on wrong parameters
> + * *        -EOPNOTSUPP if device doesn't support the requested operatio=
n
> + * *        < 0 if the operation fails
> + */
> +int rpmb_get_write_count(struct rpmb_dev *rdev)
> +{
> +       int err;
> +
> +       if (!rdev)
> +               return -EINVAL;
> +
> +       mutex_lock(&rdev->lock);
> +       err =3D -EOPNOTSUPP;
> +       if (rdev->ops && rdev->ops->get_write_count)
> +               err =3D rdev->ops->get_write_count(rdev->dev.parent, rdev=
->target);
> +       mutex_unlock(&rdev->lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_get_write_count);
> +
> +/**
> + * rpmb_write_blocks() - write data to RPMB device
> + * @rdev: rpmb device
> + * @addr: block address (index of first block - 256B blocks)
> + * @count: number of 256B blosks
> + * @data: pointer to data to program
> + *
> + * Write a series of blocks to the RPMB device.
> + *
> + * Return:
> + * *        0 on success
> + * *        -EINVAL on wrong parameters
> + * *        -EACCESS no key set
> + * *        -EOPNOTSUPP if device doesn't support the requested operatio=
n
> + * *        < 0 if the operation fails
> + */
> +int rpmb_write_blocks(struct rpmb_dev *rdev, key_serial_t keyid, int add=
r,
> +                     int count, u8 *data)
> +{
> +       int err;
> +
> +       if (!rdev || !count || !data)
> +               return -EINVAL;
> +
> +       mutex_lock(&rdev->lock);
> +       err =3D -EOPNOTSUPP;
> +       if (rdev->ops && rdev->ops->write_blocks) {
> +               err =3D rdev->ops->write_blocks(rdev->dev.parent, rdev->t=
arget, keyid,
> +                                             addr, count, data);
> +       }
> +       mutex_unlock(&rdev->lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_write_blocks);
> +
> +/**
> + * rpmb_read_blocks() - read data from RPMB device
> + * @rdev: rpmb device
> + * @addr: block address (index of first block - 256B blocks)
> + * @count: number of 256B blocks
> + * @data: pointer to data to read
> + *
> + * Read a series of one or more blocks from the RPMB device.
> + *
> + * Return:
> + * *        0 on success
> + * *        -EINVAL on wrong parameters
> + * *        -EACCESS no key set
> + * *        -EOPNOTSUPP if device doesn't support the requested operatio=
n
> + * *        < 0 if the operation fails
> + */
> +int rpmb_read_blocks(struct rpmb_dev *rdev, int addr, int count, u8 *dat=
a)
> +{
> +       int err;
> +
> +       if (!rdev || !count || !data)
> +               return -EINVAL;
> +
> +       mutex_lock(&rdev->lock);
> +       err =3D -EOPNOTSUPP;
> +       if (rdev->ops && rdev->ops->read_blocks) {
> +               err =3D rdev->ops->read_blocks(rdev->dev.parent, rdev->ta=
rget,
> +                                            addr, count, data);
> +       }
> +       mutex_unlock(&rdev->lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_read_blocks);
> +
> +
> +static void rpmb_dev_release(struct device *dev)
> +{
> +       struct rpmb_dev *rdev =3D to_rpmb_dev(dev);
> +
> +       ida_simple_remove(&rpmb_ida, rdev->id);
> +       kfree(rdev);
> +}
> +
> +struct class rpmb_class =3D {
> +       .name =3D "rpmb",
> +       .owner =3D THIS_MODULE,
> +       .dev_release =3D rpmb_dev_release,
> +};
> +EXPORT_SYMBOL(rpmb_class);
> +
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
> +       device_del(&rdev->dev);
> +       mutex_unlock(&rdev->lock);
> +
> +       rpmb_dev_put(rdev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_unregister);
> +
> +/**
> + * rpmb_dev_unregister_by_device() - unregister RPMB partition
> + *     from the RPMB subsystem
> + * @dev: the parent device of the rpmb device
> + * @target: RPMB target/region within the physical device
> + * Return:
> + * *        0 on success
> + * *        -EINVAL on wrong parameters
> + * *        -ENODEV if a device cannot be find.
> + */
> +int rpmb_dev_unregister_by_device(struct device *dev, u8 target)
> +{
> +       struct rpmb_dev *rdev;
> +
> +       if (!dev)
> +               return -EINVAL;
> +
> +       rdev =3D rpmb_dev_find_by_device(dev, target);
> +       if (!rdev) {
> +               dev_warn(dev, "no disk found %s\n", dev_name(dev->parent)=
);
> +               return -ENODEV;
> +       }
> +
> +       rpmb_dev_put(rdev);
> +
> +       return rpmb_dev_unregister(rdev);
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_unregister_by_device);
> +
> +/**
> + * rpmb_dev_get_drvdata() - driver data getter
> + * @rdev: rpmb device
> + *
> + * Return: driver private data
> + */
> +void *rpmb_dev_get_drvdata(const struct rpmb_dev *rdev)
> +{
> +       return dev_get_drvdata(&rdev->dev);
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_get_drvdata);
> +
> +/**
> + * rpmb_dev_set_drvdata() - driver data setter
> + * @rdev: rpmb device
> + * @data: data to store
> + */
> +void rpmb_dev_set_drvdata(struct rpmb_dev *rdev, void *data)
> +{
> +       dev_set_drvdata(&rdev->dev, data);
> +}
> +EXPORT_SYMBOL_GPL(rpmb_dev_set_drvdata);
> +
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
> +       if (!ops->get_write_count)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->write_blocks)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!ops->read_blocks)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (ops->type =3D=3D RPMB_TYPE_ANY || ops->type > RPMB_TYPE_MAX)
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
> +       ret =3D device_register(&rdev->dev);
> +       if (ret)
> +               goto exit;
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
> +static int __init rpmb_init(void)
> +{
> +       ida_init(&rpmb_ida);
> +       class_register(&rpmb_class);
> +       return 0;
> +}
> +
> +static void __exit rpmb_exit(void)
> +{
> +       class_unregister(&rpmb_class);
> +       ida_destroy(&rpmb_ida);
> +}
> +
> +subsys_initcall(rpmb_init);
> +module_exit(rpmb_exit);
> +
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("RPMB class");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
> new file mode 100644
> index 000000000000..718ba7c91ecd
> --- /dev/null
> +++ b/include/linux/rpmb.h
> @@ -0,0 +1,163 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
> +/*
> + * Copyright (C) 2015-2019 Intel Corp. All rights reserved
> + * Copyright (C) 2021 Linaro Ltd
> + */
> +#ifndef __RPMB_H__
> +#define __RPMB_H__
> +
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/kref.h>
> +#include <linux/key.h>
> +
> +/**
> + * struct rpmb_ops - RPMB ops to be implemented by underlying block devi=
ce
> + *
> + * @program_key    : program device key (once only op).
> + * @get_capacity   : rpmb size in 128K units in for region/target.
> + * @get_write_count: return the device write counter
> + * @write_blocks   : write blocks to RPMB device
> + * @read_blocks    : read blocks from RPMB device
> + * @block_size     : block size in half sectors (1 =3D=3D 256B)
> + * @wr_cnt_max     : maximal number of blocks that can be
> + *                   written in one access.
> + * @rd_cnt_max     : maximal number of blocks that can be
> + *                   read in one access.
> + * @auth_method    : rpmb_auth_method
> + * @dev_id         : unique device identifier
> + * @dev_id_len     : unique device identifier length
> + */
> +struct rpmb_ops {
> +       int (*program_key)(struct device *dev, u8 target, key_serial_t ke=
yid);
> +       int (*get_capacity)(struct device *dev, u8 target);
> +       int (*get_write_count)(struct device *dev, u8 target);
> +       int (*write_blocks)(struct device *dev, u8 target, key_serial_t k=
eyid,
> +                           int addr, int count, u8 *data);
> +       int (*read_blocks)(struct device *dev, u8 target,
> +                          int addr, int count, u8 *data);
> +       u16 block_size;
> +       u16 wr_cnt_max;
> +       u16 rd_cnt_max;
> +       u16 auth_method;
> +       const u8 *dev_id;
> +       size_t dev_id_len;
> +};
> +
> +/**
> + * struct rpmb_dev - device which can support RPMB partition
> + *
> + * @lock       : the device lock
> + * @dev        : device
> + * @id         : device id
> + * @target     : RPMB target/region within the physical device
> + * @ops        : operation exported by block layer
> + */
> +struct rpmb_dev {
> +       struct mutex lock; /* device serialization lock */
> +       struct device dev;
> +       int id;
> +       u8 target;
> +       const struct rpmb_ops *ops;
> +};
> +
> +#define to_rpmb_dev(x) container_of((x), struct rpmb_dev, dev)
> +
> +#if IS_ENABLED(CONFIG_RPMB)
> +struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev);
> +void rpmb_dev_put(struct rpmb_dev *rdev);
> +struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent, u8 targe=
t);
> +struct rpmb_dev *rpmb_dev_get_by_type(u32 type);
> +struct rpmb_dev *rpmb_dev_register(struct device *dev, u8 target,
> +                                  const struct rpmb_ops *ops);
> +void *rpmb_dev_get_drvdata(const struct rpmb_dev *rdev);
> +void rpmb_dev_set_drvdata(struct rpmb_dev *rdev, void *data);
> +int rpmb_dev_unregister(struct rpmb_dev *rdev);
> +int rpmb_dev_unregister_by_device(struct device *dev, u8 target);
> +int rpmb_program_key(struct rpmb_dev *rdev, key_serial_t keyid);
> +int rpmb_get_capacity(struct rpmb_dev *rdev);
> +int rpmb_get_write_count(struct rpmb_dev *rdev);
> +int rpmb_write_blocks(struct rpmb_dev *rdev, key_serial_t keyid,
> +                     int addr, int count, u8 *data);
> +int rpmb_read_blocks(struct rpmb_dev *rdev, int addr, int count, u8 *dat=
a);
> +
> +#else
> +static inline struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev)
> +{
> +       return NULL;
> +}
> +
> +static inline void rpmb_dev_put(struct rpmb_dev *rdev) { }
> +
> +static inline struct rpmb_dev *rpmb_dev_find_by_device(struct device *pa=
rent,
> +                                                      u8 target)
> +{
> +       return NULL;
> +}
> +
> +static inline
> +struct rpmb_dev *rpmb_dev_get_by_type(enum rpmb_type type)
> +{
> +       return NULL;
> +}
> +
> +static inline void *rpmb_dev_get_drvdata(const struct rpmb_dev *rdev)
> +{
> +       return NULL;
> +}
> +
> +static inline void rpmb_dev_set_drvdata(struct rpmb_dev *rdev, void *dat=
a)
> +{
> +}
> +
> +static inline struct rpmb_dev *
> +rpmb_dev_register(struct device *dev, u8 target, const struct rpmb_ops *=
ops)
> +{
> +       return NULL;
> +}
> +
> +static inline int rpmb_dev_unregister(struct rpmb_dev *dev)
> +{
> +       return 0;
> +}
> +
> +static inline int rpmb_dev_unregister_by_device(struct device *dev, u8 t=
arget)
> +{
> +       return 0;
> +}
> +
> +static inline int rpmb_program_key(struct rpmb_dev *rdev, key_serial_t k=
eyid)
> +{
> +       return 0;
> +}
> +
> +static inline rpmb_set_key(struct rpmb_dev *rdev, u8 *key, int keylen);
> +{
> +       return 0;
> +}
> +
> +static inline int rpmb_get_capacity(struct rpmb_dev *rdev)
> +{
> +       return 0;
> +}
> +
> +static inline int rpmb_get_write_count(struct rpmb_dev *rdev)
> +{
> +       return 0;
> +}
> +
> +static inline int rpmb_write_blocks(struct rpmb_dev *rdev, int addr, int=
 count,
> +                                   u8 *data)
> +{
> +       return 0;
> +}
> +
> +static inline int rpmb_read_blocks(struct rpmb_dev *rdev, int addr, int =
count,
> +                                  u8 *data)
> +{
> +       return 0;
> +}
> +
> +#endif /* CONFIG_RPMB */
> +
> +#endif /* __RPMB_H__ */
> --
> 2.20.1
>
