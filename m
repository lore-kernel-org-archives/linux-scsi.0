Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B052EC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 741F764E32
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhBJTlj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhBJTle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 14:41:34 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C595C061574;
        Wed, 10 Feb 2021 11:40:53 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a9so6290175ejr.2;
        Wed, 10 Feb 2021 11:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=po5ijgXq/itNxq2NSDWsJQ01HRqO1u556savPbCFYF0=;
        b=DH7oHCUbtmVf+gBb6G/xuBR7BeeOjeVnQ1nBGFlTRj8CvGeFEgEkAOYQnephetB5ub
         ztJ2+LmLlgqqyTTox6bxO3cJoMk4ADb8DuvjpXFFuHoheqMEK+DutF15lvRhCxKXQuPq
         Mm15GPOXfUnhJBYpBexXdTbDeLJ4JnlZxpKagVLEeacY3IpxQHYFl0y3IlswtW6BD32z
         U3POtX7NT2R4AulhJadvOY3HMS2M5bisIbnrAWqgW9ORIKnaeltzgBXwHTslqqvKAPuc
         LYGJ6xgJFTiOq9ddFdhckuqn2VIjmbb01AG61j/Lv1f23wgoBvQBnoK2GQ5jGb+gEI9W
         YeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=po5ijgXq/itNxq2NSDWsJQ01HRqO1u556savPbCFYF0=;
        b=EbfchscHvIQaqTFpUTQrVYRGQyEv3n6iHvPTsfycnxCr9QgMtt6NkriQfUeD7McAeL
         jkhJiVpYdz4v2KYMev/j5S/EY9vo+hcbCx1z4RF1p0NOuuWyNw8oY+DP67LkQ/0Mg789
         sBW90kYtINU8AvUvOVv/J1528N61lpyDJHl8bahgtRtEbdtaayu3D32rUpzXZC28IT2H
         3rL1YajAFsfZv3qPTdFZX4hfF9R/xv6CXZsKVXYi3IxC54JYPqwwx41NArt6iiXlhaup
         C3p2aTgD/5sj9o7B14WrAV/pDl4f39I/cwe1jbpvipbwmhuyMGLGeZYrhHc/UHECzFn2
         aFtQ==
X-Gm-Message-State: AOAM532MQJOFJemolhSqN3+7WYLkTFb1ydAfJCdsmTvZBaXXDntoKr9f
        hoU0XSo434tqS1xmm+lWXw2ZXgQKtwU=
X-Google-Smtp-Source: ABdhPJy147kpEscUld58sqEFbgwJZtFXXVovhx/sE5ZrNbimsKtgl82qCYeqpDeyb2HbUzbnP/4tYg==
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr4524458ejr.177.1612986052293;
        Wed, 10 Feb 2021 11:40:52 -0800 (PST)
Received: from localhost (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id u18sm2041825ejc.76.2021.02.10.11.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:40:51 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 0/2] uio and tcmu: Fix memory leak in tcmu by adding new uio feature
Date:   Wed, 10 Feb 2021 20:40:29 +0100
Message-Id: <20210210194031.7422-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of weeks ago I found a huge memory leak in tcmu:

tcmu needs to keep resources as long as userspace holds the uio
device open or mmap'ed. Therefore tcmu increments and decrements
a refcnt during uio_info::uio_open (tcmu_open) and
uio_info::uio_release (tcmu_release).

If via configFS user tries to destroy a tcmu device, tcmu calls
uio_unregister_device(). If during this call userspace daemon
still holds the uio device open or mmap'ed, uio does not call
tcmu_release when userspace later closes and munmaps the uio
device. So refcnt never drops to 0 and resources are not freed.

My first attempt to fix the problem you can find here:
  https://lore.kernel.org/linux-scsi/20201218141534.9918-1-bostroesser@gmail.com/
That fix delayed calling uio_unregister_device until tcmu_release
was called. To make userspace aware of the device going to be
destroyed without calling uio_unregister_device, the patch
inserted the following code snippet in tcmu:

  /* reset uio_info->irq, so uio will reject read() and write() */
  udev->uio_info.irq = 0;
  /* Set bit, so we can reject later calls to tcmu_open and tcmu_mmap */
  set_bit(TCMU_DEV_BIT_GOING_DOWN, &udev->flags);
  /* wake up possible sleeper in uio_read(), it will return -EIO */
  uio_event_notify(&udev->uio_info);

Especially resetting uio_info::irq on an alive uio device is not
very clean, I think.

Therefore I'm sending a small series of two patches as a second
attempt to fix the memory leak.

Patch 1 adds the new optional callback uio_info::late_release
which is called if userspace closes or munmaps the uio device
after uio_register_device was called.

Patch 2 is a one liner that uses the new feature in tcmu.
No further changes in tcmu are necessary.

I'm wondering whether the new feature in uio can be useful for
other drivers also, e.g. uio_hv_generic?


The patches were made on top of Martin's for-next branch.
But they probably will apply to most other recent trees.


Bode Stroesser (2):
  uio: Add late_release callback to uio_info
  scsi: target: tcmu: Fix memory leak by using new uio callback

 Documentation/driver-api/uio-howto.rst | 10 ++++++++++
 drivers/target/target_core_user.c      |  1 +
 drivers/uio/uio.c                      |  4 ++++
 include/linux/uio_driver.h             |  4 ++++
 4 files changed, 19 insertions(+)

-- 
2.12.3

