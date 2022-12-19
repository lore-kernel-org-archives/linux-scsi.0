Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9CDC10F1B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 08:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiLSIkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 03:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiLSIkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 03:40:18 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193B8A19C
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 00:40:17 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 124so5754013pfy.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 00:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f8+bSmaA0cmp16x26bRQ/cm+4zQqtY1wbwdEpQv5OiY=;
        b=x3TU33kLDcq/fKKT5qEHxp4k2dRmZICETK7MtPkScTvO3f4q0zn/lKiLXv5/E4poHh
         ohcn17PYGrtMr7icJoKrtIh1wNpyHZrW8qXbxXAJuCD7Cu60bPhfFEtBZJrqAqyzdZ4k
         BfpPqfxo/eY7Rbs8thLo2rI+w4ExHV84kb8cnzQzgyXEO9j+fLgl9NqWIjcv/UOfM6MJ
         h2r8rSKyhv6IS16fz9VXUNe70HAEbgY2CbzOb7K0nchnNIyNmEnZhm3HNK1umwI2830K
         AkAG9tBUOawIoOK8pjc76Mc9/yazdENIRmrWYKP3MSbdTk6aBVOaXrXuTXaUl8TYmmWh
         sZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f8+bSmaA0cmp16x26bRQ/cm+4zQqtY1wbwdEpQv5OiY=;
        b=RrWuIo/MWfwnnqK8bwK+oRmdyTjo0fGPUD8DlWtqMzpwwoh7hZ8NDlvHU+mxZ4Chvo
         GTl6JFH+feSVaL6ieCDu4Y5+qiZnDcaC89PrTZz9ZJikG+x4AQ/Fazl8wxbV8kLTFe7F
         VwQFfMOsK+Ar7yxhh2BVfQ3awQYyk4hlidDobX5o4aBOAEGcPMkLBk7Vn9p3Y2pIGx/C
         /IMRReJUWrviNRHEzlrvnmQGTe2xij/huTuIQZHxgFM9GxhMFChPZxsmtff9/bVjnDkD
         4UKMRNTJjR+INKclQLsJeWBOfm6xaU8j7fNxoloepuEgDNpT2UDNz+Wm1+dY5Z1lJapw
         pVNg==
X-Gm-Message-State: ANoB5plhC4UR8ZK+udXSrGfdMvebTX9mBOdfTmUrHXHa45FjeaEagoNq
        2fwgYuMDEJ+bMGHabswyu8qa1wKIEXkeHpSxYEe/8A==
X-Google-Smtp-Source: AA0mqf6fHrB24kpKRZtxJ/jl4cyycBpONCwoE9u9Hwo5PX1mANCykQgJBY1PwHfLY1yPaXCstzW+unZ0wtSJyelyLd8=
X-Received: by 2002:aa7:9acc:0:b0:577:81cb:4761 with SMTP id
 x12-20020aa79acc000000b0057781cb4761mr9183983pfp.46.1671439216472; Mon, 19
 Dec 2022 00:40:16 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com> <20221219025404-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221219025404-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Mon, 19 Dec 2022 10:39:39 +0200
Message-ID: <CAJs=3_CWQ3T1O5RofstwkczpgoJym5X4xBQmdQCtt573sHUOKg@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,
Sorry, I had no time to create a new version.
I'll do it today.

Alvaro
