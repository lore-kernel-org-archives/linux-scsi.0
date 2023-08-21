Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD5FEE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 11:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbjHULTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 07:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbjHULTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 07:19:07 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E2DD8
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 04:19:05 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-64b3ae681d1so16494926d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 04:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692616744; x=1693221544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MABuIgO/otMKwHO3IQArWtPwphnBdU0rfjs7SwDiKys=;
        b=olGcE6bbDPyeEpAEzSFYYVNDMYT1wyzD8qqPvo9MRoiT7DNGQ0QBoNkLz8Hv2jG8YT
         8jbYcrz4F2KoUgGnyNV1uJ1L7HWzLukD3M3f8MZICcx2S4xhaKTaKz7b0pwLaxa2LLAM
         qMU4+rjEatqcjMP0stIJ0wWgsQDJIhMmpf13tlWB4UUGWLMVau5oe3WgypqTCRJuSYl3
         ZD3B1ipxn269JkKbx97ZywEujLNcTJ/8nSjmaD6l8VqBNcNyaAEqDKqVPPxz0HbelLHJ
         N68TJ9cYDglounOK54pbz+Bf4FDr+WwJ5UJbHgB77Ve2EUcSGmKkiI5NR5y98WDN2G4y
         Evyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692616744; x=1693221544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MABuIgO/otMKwHO3IQArWtPwphnBdU0rfjs7SwDiKys=;
        b=UTlnEKzvjwXpgsF+5foshhJBnAwWpywD/fSJMA7dErQwLODwRqmTWQfLQXwaK+RoYc
         QReTmVxlN6YrE3kt09LwTIpZZxpxA7t/NiVRMDXVJfTX271dHYvp6dkwTWXRNltZjdla
         m+QJmri9bQ9dfAUm1h7aouSPvL5QmUg6oSjqoVN1OKLwHBxC1jrWydYtzdB7FvEk9vCF
         KgxYFmmEZvFobHe1b06tZkCfQFtUSsnfhZHSpB+23bRO+QD6Wm6KrW7TZ2yN851vPNt6
         aAnFgryNsZ3ypukSFkwMIB3lGZHq+M6jhPQ5yXCHjRzmDYbGIONXlwLc6I+RBzMKJ26s
         HH5w==
X-Gm-Message-State: AOJu0YyzxMzkg7/OUBHZrQOfHJeCMpdTvY7rZlqnrGz/5GKUw1uSVEIe
        bxINnbTSWlpKk/nfFeaGIOJcW18yZw20g7lHRJaglg==
X-Google-Smtp-Source: AGHT+IHc2VXTlDniE230YR2A78IFk4m6ZOcAIpq197VySFdMHqSmnKBxBuW3OgXSJMUg9onxvCuHYF6R5700PxdwiAY=
X-Received: by 2002:a0c:eb4c:0:b0:641:8878:29a6 with SMTP id
 c12-20020a0ceb4c000000b00641887829a6mr4708587qvq.65.1692616744117; Mon, 21
 Aug 2023 04:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230722014037.42647-1-shyamsaini@linux.microsoft.com>
 <20230722014037.42647-2-shyamsaini@linux.microsoft.com> <CAPDyKFoBC+GaGerGDEAjg9q4ayV9mMBKkfFk3nO-zcQzOZ_H6Q@mail.gmail.com>
 <b875892c-1777-d84a-987e-1b0d5ac29df@linux.microsoft.com> <94728786-b41b-1467-63c1-8e2d5acfa5e4@linaro.org>
 <CAFA6WYNPViMs=3cbNsEdhqnjNOUCsHE_8uqiDTzwCKDNNiDkCw@mail.gmail.com>
In-Reply-To: <CAFA6WYNPViMs=3cbNsEdhqnjNOUCsHE_8uqiDTzwCKDNNiDkCw@mail.gmail.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 21 Aug 2023 13:18:53 +0200
Message-ID: <CAHUa44Ek0k2b-igA6Gd1ZXVzibTh2sNDMnE-weQwFFKEZ_1jOA@mail.gmail.com>
Subject: Re: [RFC, PATCH 1/1] rpmb: add Replay Protected Memory Block (RPMB) driver
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Shyam Saini <shyamsaini@linux.microsoft.com>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, linux-scsi@vger.kernel.org,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Tyler Hicks <code@tyhicks.com>,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>,
        Paul Moore <paul@paul-moore.com>,
        Allen Pais <apais@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 21, 2023 at 12:03=E2=80=AFPM Sumit Garg <sumit.garg@linaro.org>=
 wrote:
>
> On Mon, 21 Aug 2023 at 15:19, Jerome Forissier
> <jerome.forissier@linaro.org> wrote:
> >
> >
> >
> > On 8/17/23 01:31, Shyam Saini wrote:
> > >
> > > Hi Ulf,
> > >
> > >> On Sat, 22 Jul 2023 at 03:41, Shyam Saini
> > >> <shyamsaini@linux.microsoft.com> wrote:
> > >>>
> > >>> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > >>>
> > >>> [This is patch 1 from [1] Alex's submission and this RPMB layer was
> > >>> originally proposed by [2]Thomas Winkler ]
> > >>>
> > >>> A number of storage technologies support a specialised hardware
> > >>> partition designed to be resistant to replay attacks. The underlyin=
g
> > >>> HW protocols differ but the operations are common. The RPMB partiti=
on
> > >>> cannot be accessed via standard block layer, but by a set of specif=
ic
> > >>> commands: WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY. Such a
> > >>> partition provides authenticated and replay protected access, hence
> > >>> suitable as a secure storage.
> > >>>
> > >>> The initial aim of this patch is to provide a simple RPMB Driver wh=
ich
> > >>> can be accessed by Linux's optee driver to facilitate fast-path for
> > >>> RPMB access to optee OS(secure OS) during the boot time. [1] Curren=
tly,
> > >>> Optee OS relies on user-tee supplicant to access eMMC RPMB partitio=
n.
> > >>>
> > >>> A TEE device driver can claim the RPMB interface, for example, via
> > >>> class_interface_register(). The RPMB driver provides a series of
> > >>> operations for interacting with the device.
> > >>
> > >> I don't quite follow this. More exactly, how will the TEE driver kno=
w
> > >> what RPMB device it should use?
> > >
> > > I don't have complete code to for this yet, but i think OP-TEE driver
> > > should register with RPMB subsystem and then we can have eMMC/UFS/NVM=
e
> > > specific implementation for RPMB operations.
> > >
> > > Linux optee driver can handle RPMB frames and pass it to RPMB subsyst=
em
> > >
>
> It would be better to have this OP-TEE use case fully implemented. So
> that we can justify it as a valid user for this proposed RPMB
> subsystem. If you are looking for any further suggestions then please
> let us know.

+1

>
> > > [1] U-Boot has mmc specific implementation
> > >
> > > I think OPTEE-OS has CFG_RPMB_FS_DEV_ID option
> > > CFG_RPMB_FS_DEV_ID=3D1 for /dev/mmcblk1rpmb,
> >
> > Correct. Note that tee-supplicant will ignore this device ID if --rmb-c=
id
> > is given and use the specified RPMB instead (the CID is a non-ambiguous=
 way
> > to identify a RPMB device).
> >
> > > but in case if a
> > > system has multiple RPMB devices such as UFS/eMMC/NVMe, one them
> > > should be declared as secure storage and optee should access that one=
 only.
> >
> > Indeed, that would be an equivalent of tee-supplicant's --rpmb-cid.
> >
> > > Sumit, do you have suggestions for this ?
> >
>
> I would suggest having an OP-TEE secure DT property that would provide
> the RPMB CID which is allocated to the secure world.

Another option is for OP-TEE to iterate over all RPMBs with a
programmed key and test if the key OP-TEE would use works. That should
avoid the problem of provisioning a device-unique secure DTB. I'd
expect that the RPMB key is programmed by a trusted provisioning tool
since allowing OP-TEE to program the RPMB key has never been secure,
not unless the OP-TEE binary is rollback protected.

Cheers,
Jens

>
> -Sumit
>
> >
> > --
> > Jerome
