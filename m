Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993E2C352A1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 19:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiLFT4n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 14:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLFT4m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 14:56:42 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3866232B8B
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 11:56:41 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id x13so6959093ilp.8
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2022 11:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Pr5A82QMDS3439cV/l0TiwyD6oe8HTmjdxBAYHIenkw=;
        b=5gZ4Gpu/Xoh5ChxX8vn4yDQ839Y02gORAbRJKicZwrHFBH0NIchUZDW6Y615MW8Cuo
         ZdO4L3CqvKD9JNcgHJjpe9/mjrs85Al83QInqMzjcK62pr1wgEqU8ZhTAJi4Ib3ahj7k
         BZlEtq3KfssqlsY9tZQIx0vaLlC9u3vbxT8LvjuAL1GnsClNkR2tm4WIKQeodHoXdkZE
         KiPCEIcEoxIg4QSjQNTqtlAXIew+2ghnCH4ev8+TU75YzUKjhKWJSMnNxTy27fwj8JCb
         XWwul5V7p/Z+1rXby5ETA9G2t4IWGRXtyRcQ3Cmi0XJKOmS3YkN3oRqED74z2Db+6nws
         ZSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pr5A82QMDS3439cV/l0TiwyD6oe8HTmjdxBAYHIenkw=;
        b=3MGeTVs925Od+aQfP+194mQdBUdag3+9AimiBOgRA3sdm9NnI429BRHzrxeiCx/Uv6
         75OL7IM/1bog4mmhjer5BZBvVOQUB+5uPGm5n62e7tppMYTIosAe6nZU2jrLrTrHB6k5
         hp2+cKwsHb47i4Lwp5J+FvHQdgyb4D7nDpqLxVtedYTEfNvIZtj4hmgvq+lKq4z5qc9b
         yFUpQ9fGESzxetI483iIFP3MZs6DXp05CnxXzoR8tb+mCa8IeJd0pVOiZwT0bEfc7gwc
         gwEwYDZt4p5xgYl+a7Azbslgzy8ngHQE2DR73drC0QBiuxaM/x5mUZSlT5GWPnX3w3qn
         7KSw==
X-Gm-Message-State: ANoB5pkJiTUFuM/sFS7dGa7AifjE77WkJN5FfuImghL/oU/Qkv7ZJuVe
        WKrhxj+V/j7tNYzaX0/OnwG1/mXpAzyWEwA7wCveNQ==
X-Google-Smtp-Source: AA0mqf5weYpfxnfmeNEaWEQd5GuamfhCWZUc6GKCqEjTgjj47RKtDegoyGS/7Ff3WUue6RAch00gS/qlXcQ0t/Pzp84=
X-Received: by 2002:a05:6e02:1c8d:b0:303:71ee:7b6b with SMTP id
 w13-20020a056e021c8d00b0030371ee7b6bmr2852396ill.147.1670356600505; Tue, 06
 Dec 2022 11:56:40 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com> <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
In-Reply-To: <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 6 Dec 2022 21:56:05 +0200
Message-ID: <CAJs=3_CWrO34KBxN_eNVyibRNYUP9tzmywnmq2W+9uMYwbQdBA@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> Why does the above data structure only refer to SLC and MLC but not to
> TLC or QLC?

This has been discussed before.
The data structure follows the virtio spec
(https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html)

> How will this data structure be extended without having to introduce a
> new ioctl?

There are no more lifetime parameters defined in the virtio spec.
Please note that this is a virtio block specific ioctl, not a block generic one.
