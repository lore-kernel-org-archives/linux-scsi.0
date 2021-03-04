Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C963C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 21:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52A864F70
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 21:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhCDVJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 16:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbhCDVJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 16:09:10 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1754DC061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 13:08:30 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id x19so6942311ooj.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 13:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J50JP3psap6N5U8PJK0VaCpx/DyKv1Z4rwk0hsyasT8=;
        b=ShyKNcNe0s0B6TrwHg0Wrd8VbmCyL1Xz57elLS6JF0EdStg0/ngISbRwFn1CLIPeLQ
         YVvSUGEXyQEVCph+woW0FUxzpLDFcTabpL6xX2i6/WRjXhXFGlDskORQ9B0mQPxYtg2t
         YBOAb+kBsnKPty8uVhU13LF9HCQXVeE1A3sfx5Rd0lPsTBk5mKU6u9mDI6SUQaYc3hev
         ux40KnR+33BvAXJuy2pCJQPqGqlQnNh22/SGf8FykKSMx5xvrUF5toRcH3XbkFQ4C94h
         Oa3J5nicZhpc/BfNjgNlE84ecbz4LPkHu1RRHzgVIMGV7bkFr9233JD85rsrbV1cRosI
         qROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J50JP3psap6N5U8PJK0VaCpx/DyKv1Z4rwk0hsyasT8=;
        b=OAGZSa0E1k6RHobPTxu3Xz036rtT/Pr40zaP5BrbMcN0Lj/+uY0rwKrDlnbFpB8Oyh
         CNoqrMVvTYjw9Qfb7/ig62ZpfDc+tCI27GQcqIfgVTb/1JWIC7OZAIiTpoIJdcwNV6ML
         RKsThuIUDAziscIJJSWhRhiqn6jRIdjEdiEQIlRjX8/9VUqOgZ1Df2opMjBDbLHDyJCY
         17/EljAjmKZy6KLXgIlQFMYJpoUuEbBb+VEcsMaHE8tKNzjKTr3MhteZ7No4dR1DcjCT
         L++Udoy7e0YzydmC5AYGZL97B6NZ4l0lFeXBe0HX0+hsNb23xFQ0/D5udSMt12uVjacr
         3Wag==
X-Gm-Message-State: AOAM531kBOQYhAnZEQu5FnDeTvFeIurWTNhMeq2vhpIyH96nt9zsbQdv
        9ULzrNKkxgzL+nRdPqKxQf1k5w==
X-Google-Smtp-Source: ABdhPJzWucZnTdO/uERt2VBCoCRe2xsIaNV+ExSTp8LMx7Rb5gJc0pZ8OQWp63VN1VXTBobe38tUdQ==
X-Received: by 2002:a4a:9019:: with SMTP id i25mr4896429oog.8.1614892108728;
        Thu, 04 Mar 2021 13:08:28 -0800 (PST)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id n11sm66378oij.51.2021.03.04.13.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 13:08:28 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id f3so31663539oiw.13;
        Thu, 04 Mar 2021 13:08:28 -0800 (PST)
X-Received: by 2002:aca:4fd3:: with SMTP id d202mr4233275oib.11.1614892107343;
 Thu, 04 Mar 2021 13:08:27 -0800 (PST)
MIME-Version: 1.0
References: <20210303135500.24673-1-alex.bennee@linaro.org> <20210303135500.24673-3-alex.bennee@linaro.org>
In-Reply-To: <20210303135500.24673-3-alex.bennee@linaro.org>
From:   Arnd Bergmann <arnd@linaro.org>
Date:   Thu, 4 Mar 2021 22:08:11 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2e3zNqMJSN-LAAjYmy8Gr=wjn5MMDMinxawOWcMgo7Ww@mail.gmail.com>
Message-ID: <CAK8P3a2e3zNqMJSN-LAAjYmy8Gr=wjn5MMDMinxawOWcMgo7Ww@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] char: rpmb: provide a user space interface
To:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Uvarov <maxim.uvarov@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        ruchika.gupta@linaro.org,
        "Winkler, Tomas" <tomas.winkler@intel.com>, yang.huang@intel.com,
        bing.zhu@intel.com, Matti.Moell@opensynergy.com,
        hmo@opensynergy.com, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Avri Altman <avri.altman@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 3, 2021 at 2:54 PM Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
>
> +       /* the rpmb is single open! */
> +       if (test_and_set_bit(RPMB_DEV_OPEN, &rdev->status))
> +               return -EBUSY;

open counters on device nodes are fundamentally broken, because
they do not stop you from using dup() or sharing the file descriptor
across a fork. Just remove this.

> +static long rpmb_ioctl_ver_cmd(struct rpmb_dev *rdev,
> +                              struct rpmb_ioc_ver_cmd __user *ptr)
> +{
> +       struct rpmb_ioc_ver_cmd ver =3D {
> +               .api_version =3D RPMB_API_VERSION,
> +       };
> +
> +       return copy_to_user(ptr, &ver, sizeof(ver)) ? -EFAULT : 0;
> +}

Similarly, API versions are fundamentally flawed, as the kernel requires
us to keep compatibility with existing user space. Remove this as well.

> +static long rpmb_ioctl_cap_cmd(struct rpmb_dev *rdev,
> +                              struct rpmb_ioc_cap_cmd __user *ptr)
> +{
> +       struct rpmb_ioc_cap_cmd cap;

Better do a memset() here to ensure this does not leak kernel
stack data to user space.


> +static const struct file_operations rpmb_fops =3D {
> +       .open           =3D rpmb_open,
> +       .release        =3D rpmb_release,
> +       .unlocked_ioctl =3D rpmb_ioctl,
> +       .owner          =3D THIS_MODULE,
> +       .llseek         =3D noop_llseek,
> +};

Add

       .compat_ioctl =3D compat_ptr_ioctl

to make it work for 32-bit user space on 64-bit kernels.

> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
> +/*
> + * Copyright (C) 2015-2018 Intel Corp. All rights reserved
> + */
> +#ifdef CONFIG_RPMB_INTF_DEV
> +int __init rpmb_cdev_init(void);
> +void __exit rpmb_cdev_exit(void);
> +void rpmb_cdev_prepare(struct rpmb_dev *rdev);
> +void rpmb_cdev_add(struct rpmb_dev *rdev);
> +void rpmb_cdev_del(struct rpmb_dev *rdev);
> +#else
> +static inline int __init rpmb_cdev_init(void) { return 0; }

I don't think it's necessary to make the user interface optional,
I'd just always provide these.

>
> +#define RPMB_API_VERSION 0x80000001

Remove this

> + */
> +struct rpmb_ioc_ver_cmd {
> +       __u32 api_version;
> +} __packed;

And this

> +
> +enum rpmb_auth_method {
> +       RPMB_HMAC_ALGO_SHA_256 =3D 0,
> +};
> +
> +/**
> + * struct rpmb_ioc_cap_cmd - rpmb capabilities
> + *
> + * @target: rpmb target/region within RPMB partition.
> + * @capacity: storage capacity (in units of 128K)
> + * @block_size: storage data block size (in units of 256B)
> + * @wr_cnt_max: maximal number of block that can be written in a single =
request.
> + * @rd_cnt_max: maximal number of block that can be read in a single req=
uest.
> + * @auth_method: authentication method: currently always HMAC_SHA_256
> + * @reserved: reserved to align to 4 bytes.
> + */
> +struct rpmb_ioc_cap_cmd {
> +       __u16 target;
> +       __u16 capacity;
> +       __u16 block_size;
> +       __u16 wr_cnt_max;
> +       __u16 rd_cnt_max;
> +       __u16 auth_method;
> +       __u16 reserved;
> +} __attribute__((packed));
> +

Remove the packed attribute, it does not change the structure layout but
just makes it less efficient to access on architectures that turn unaligned
loads and stores into byte accesses.

> +/**
> + * struct rpmb_ioc_blocks_cmd - read/write blocks to/from RPMB
> + *
> + * @keyid: key_serial_t of key to use
> + * @addr: index into device (units of 256B blocks)
> + * @count: number of 256B blocks
> + * @data: pointer to data to write/read
> + */
> +struct rpmb_ioc_blocks_cmd {
> +       __s32 key; /* key_serial_t */
> +       __u32 addr;
> +       __u32 count;
> +       __u8 __user *data;
> +} __attribute__((packed));

ioctl structures should generally not have pointers in them. If this can be=
 done
one block at a time, you can have the 256 bytes as part of the structure.

This probably needs a redesign anyway based on Tomas' feedback though.

If you end up needing a pointer, use a __u64 member  with
u64_to_user_ptr() as described in Documentation/driver-api/ioctl.rst

> +#define RPMB_IOC_VER_CMD     _IOR(0xB8, 80, struct rpmb_ioc_ver_cmd)
> +#define RPMB_IOC_CAP_CMD     _IOR(0xB8, 81, struct rpmb_ioc_cap_cmd)
> +#define RPMB_IOC_PKEY_CMD    _IOW(0xB8, 82, key_serial_t)
> +#define RPMB_IOC_COUNTER_CMD _IOR(0xB8, 84, int)
> +#define RPMB_IOC_WBLOCKS_CMD _IOW(0xB8, 85, struct rpmb_ioc_blocks_cmd)
> +#define RPMB_IOC_RBLOCKS_CMD _IOR(0xB8, 86, struct rpmb_ioc_blocks_cmd)

The last one should be _IOWR(), not _IOR(), since you write the metadata an=
d
read the data.

      Arnd
