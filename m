Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC18C433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 12:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342A964DDA
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 12:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhBOMrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 07:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhBOMrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2021 07:47:03 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFABFC061756
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 04:46:22 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u14so8742038wri.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 04:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=user-agent:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A15rY6Q2dsPIqCz33RJVqDEPuYAVE90BLBpsO2QsoA8=;
        b=dy4ndi0FVQKHpnWLrvojYRRZ7Z0FSDpbqubvH81x2YHRlPHmYbTtqkOTMOnBqutGCj
         BAZ/13UZ7n/rm6PlLTonfpvxq7XptthgeWpF9V4h8L8mXIEd4ZuTgWsEB38bBe8tiZrm
         fEcQxrtunUWIP6miHGn6HGrlsUoR+DdhZKa8vVOznlgZXrHrNWfrq+B6ahocIhdTxWnZ
         Zen4NTCO6qDdWZ7hr3JJDhAWYqYk5N4o7ZQDfteT3Qu5l3rPrujIuOQVWNayyEfb4piz
         sCohCf8iJNLsafqyRuhaDrtaQgvHUZrLWGmPxW95JAiDeK69uoj0yggn1b6hRo82C5y2
         X6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=A15rY6Q2dsPIqCz33RJVqDEPuYAVE90BLBpsO2QsoA8=;
        b=n1/Il0Hac23XAzHk89kDzWHSyxxVFRSDY/ap7CiUfor84OkXkgmGrB9DsbhNQElsWw
         NtSzdXPoZmB0jDHvVN51pmtyyQym2eX6Im0BtzUw1S/B2PX0Dgh677Z43EqVLOKuU1s/
         K6JwnISYEI1Axa8iWUlBr+qzh+MzNC49EAppKiAcb32lfFypt8qtLsKT9BymAnq2hfxK
         TaY0jwS8xLHSySnK31T9T/AHoBJmyjO0iQUDNSMdiT91IIJkYqM74e2hf0XM4bpf1dNE
         aHw9fwiMiuemzfTo3fLOcsgA8rf6V0LFgUx0D8uZ5jIXnAeMpgj0N6ldbhF3mCQdKZlq
         pMyQ==
X-Gm-Message-State: AOAM531VH+/mruVZ2dQF2sPRnqfb7AEusr4uwi7QrSZ/6u6AT2SJUCXx
        ZG1RQviFZ3/wFhU7EJXX0HkZnw==
X-Google-Smtp-Source: ABdhPJwBga4tSgNDKfwze/eJGnZcOM3JW+RCuJZb/Vfyqnk6s3PAP8Z6w77iJRe0ND6ZRWRMu5Z5pg==
X-Received: by 2002:a5d:50c8:: with SMTP id f8mr5187435wrt.69.1613393181489;
        Mon, 15 Feb 2021 04:46:21 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j71sm25969899wmj.31.2021.02.15.04.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 04:46:20 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id ED01A1FF7E;
        Mon, 15 Feb 2021 12:46:19 +0000 (GMT)
User-agent: mu4e 1.5.8; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     linux-kernel@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@vger.kernel.org" <linux-nvme@vger.kernel.org>
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Huang Yang <yang.huang@intel.com>,
        Ruchika Gupta <ruchika.gupta@linaro.org>
Subject: RPMB user space ABI
Date:   Thu, 11 Feb 2021 14:07:00 +0000
Message-ID: <87mtwashi4.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Last year while I was implementing a virtio-rpmb backend for QEMU I
ended up using patches from the ACRN tree which was based on Thomas'
patches last posted in 2016:

  https://lore.kernel.org/lkml/1478548394-8184-1-git-send-email-tomas.winkl=
er@intel.com/

which I bastardised into a testing tree on a more recent kernel:

  https://git.linaro.org/people/alex.bennee/linux.git/log/?h=3Dtesting/virt=
io-rpmb

The main reason I hacked them around was because the VirtIO spec had
since been finalised and had a very different framing structure. The
original proposed ABI provided for an ioctl which sent JDEC frames to
the underlying device. This was later expanded to support NVME style
frames. Neither of these frame sequences matched the final VirtIO
specification.

It seems to me having the ioctl ABI at this level exposes too many
underlying HW details to user space. With the number of HW devices that
providing RPMB features likely to grow from the current 3 (eMMC/JDEC,
NVME, VirtIO) it seems this ABI should operate at a higher level, e.g.:

      PROGRAM_KEY
      GET_WRITE_COUNTER
      WRITE_DATA
      READ_DATA

and I guess some sort of asynchronous result check?

It would then be for the kernel to take the higher level concepts and
translate them to the final frames required to talk to the actual HW (if
indeed there is some).

Does this seem reasonable? Is this orthogonal to any access to RPMB
partitions that file-systems might want to do?

--=20
Alex Benn=C3=A9e
