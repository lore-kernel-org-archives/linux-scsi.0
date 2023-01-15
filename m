Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725C7C3DA78
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Jan 2023 07:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjAOH4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Jan 2023 02:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjAOH4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jan 2023 02:56:06 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FC844B5
        for <linux-scsi@vger.kernel.org>; Sat, 14 Jan 2023 23:56:04 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 20so13516410pfu.13
        for <linux-scsi@vger.kernel.org>; Sat, 14 Jan 2023 23:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7mPR+tYk06dWyheXQlcDvaKFF6VE45BY4pbiBRMyTf0=;
        b=3NkR14+qMITtW5c/bhsV3TZxEqserp/0VOuYZNP4g42CclG/xB4agcQEBFDlmIceTy
         Dnb+Gl8ZEbazw6K9BfxSDP353kv8wFoCOzjafOmUpIbb4bA7nygi/+rMVSO+5njloKYR
         CozVxIQlSZAJd9UjP1d+cle8o4s32xooYBqoBz9VDUN4Kv2V66W4gZ/lzxrzL1gZJnQp
         K0Y17q39OljeeFaoVglpyHwGXhK4Mt6LJ+78vfLmrPrS6m4q6R7Fp2b5nvw978ioGuYa
         DvfLxm5eVIN11nZKAUWWpvXXHr/Z67Zvf6tZ92vL3945LZ7OFwpYeJ/q/rEZb0zOV70O
         U5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7mPR+tYk06dWyheXQlcDvaKFF6VE45BY4pbiBRMyTf0=;
        b=h2jpeoTv21blwuChH5OXl0KnxlZDI9eCOzgVaB+jQUqvGRN9HqHXHMSkZ+6nS2CFHA
         BfDS0qWEiX68Zi5Y7bgaO+9S4BiZVLOLRZ5jZWtza9MScm9aJd5ZYysoin0OPs3i1bGd
         6F4pDL2kgo+bw0/XciA5ML6CvCnVTw8S2FQ3UiH64qzXB7B4um4zphnB4AQOuQZjvP1H
         GnXKCw+a2md2PrPf5axI9k9GFyhCoI243d8S9zFuYej0krlrFLG9TlLhksqxnf1NUnKA
         yx15jmGo9Qs5h8/BnqzWCKSPut4iAJzb2KfLWTtyx/1iq+heqiog/3SJFxDSae9T+thQ
         yjSw==
X-Gm-Message-State: AFqh2kryh1ct/mGQRAgXSjaFiT6JByny02KXAVOVRZGLBswSj4El6XNv
        UDvcV+1RHsXu7E7gvxK5Vn0ByqFD9gIXtUgQZeqtYg==
X-Google-Smtp-Source: AMrXdXvAiyCmTWvJ9EHpfBDvUbeHLHSy+j5Yk8c2u2aPfRmZEEnLTIdJUxpu9gEHkkwwhxqg/OcINr2IlsC0dkOvol4=
X-Received: by 2002:a65:45c8:0:b0:48c:5903:2f5b with SMTP id
 m8-20020a6545c8000000b0048c59032f5bmr4778556pgr.504.1673769363038; Sat, 14
 Jan 2023 23:56:03 -0800 (PST)
MIME-Version: 1.0
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Sun, 15 Jan 2023 09:55:26 +0200
Message-ID: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
Subject: Virtio-blk extended lifetime feature
To:     virtualization <virtualization@lists.linux-foundation.org>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, egranata@google.com,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi guys,

While trying to upstream the implementation of VIRTIO_BLK_F_LIFETIME
feature, many developers suggested that this feature should be
extended to include more cell types, since its current implementation
in virtio spec is relevant for MMC and UFS devices only.

The VIRTIO_BLK_F_LIFETIME defines the following fields:

- pre_eol_info:  the percentage of reserved blocks that are consumed.
- device_lifetime_est_typ_a: wear of SLC cells.
- device_lifetime_est_typ_b: wear of MLC cells.

(https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html)

Following Michael's suggestion, I'd like to add to the virtio spec
with a new, extended lifetime command.
Since I'm more familiar with embedded type storage devices, I'd like
to ask you guys what fields you think should be included in the
extended command.

Thanks,

Alvaro
