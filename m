Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586E2C61DD8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 15:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 169552222C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 15:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="vJHuCgkL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgKPPkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 10:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730522AbgKPPkN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 10:40:13 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232F0C0613D3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2020 07:40:13 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id o11so17822187ioo.11
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2020 07:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tp0p5PHbr2FkOYp8vx6enMy9SJ7npMGO8ToOlTZAVD0=;
        b=vJHuCgkLtyaYNtKWJGKWTC2HAaX7Y9m8y1VpqDKgvUWa8d0I51VY3ALJeXJtOlsGpr
         QzxZZWfSIBe9Z9YJVgCkUF04iuHI0uFspV4JwGcoTFtYktgjnY7A8CRm243mremkxSFW
         /W8ZuC0hXxmoHn+ezTFvYhGe2XU1ttQu6xlHRIQZSFb9V/9nguKyH01uIZBsQIBla1sm
         kSpCVk0QJdWteogX0XEWe3MJV6jr1Lh++tWh99mrFKS4zYsaeRBflt08zg4X1OBFoLaD
         OZKwfBprL/CxXZIUp5e8ounGHLLXOFSswyyzQU1smV5YfKh+taZ0KanaNv47asHmejvk
         eLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tp0p5PHbr2FkOYp8vx6enMy9SJ7npMGO8ToOlTZAVD0=;
        b=DSNNq/RDuQgCzmjuUB7BxYVcK3jMgjo8g57HS5+oWwlcHcmSzExwg6mXczf3ADgvaq
         GHgJSVes/fTYB73a5ANi9Jk8NddYLXCB9L+m2Fb+qOdapO2N+SyAjYq+MWnQ0cLEJvj0
         3K3cqQiXZOF5QJB86j6PS2PIC03e+1yKBFjRaO2T1CnORdbGQ0/m8zraf5YePc6Xswyr
         clnKCY5c0O6mjc1cEsHpzROOzQxKLTpbxfOnNObUgaAgl6y7wKIcpY1TBCZhqUf+Tfhv
         6i1Rn0H0BRYn2ZWrNUEK4Hl0V84Or2cyUxV0GoW0dlK6l9lwEUDfyUpM9RFmB/kE9MIh
         kQTw==
X-Gm-Message-State: AOAM5318SyWBqpqFyOnqRJSUNHlC2dSk0JZ5LebOXTW+YwZqUduc1TsZ
        UnCiQOjVaMabaPshjQF2N7KSFg==
X-Google-Smtp-Source: ABdhPJzORiPywjBgXN2NzytHbmvXHQyepXDfzUWSZfRzXJXzcmliMaw8xrhzAaFsEhdxvHHHShuK7g==
X-Received: by 2002:a5e:9e0b:: with SMTP id i11mr3534187ioq.33.1605541212314;
        Mon, 16 Nov 2020 07:40:12 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i82sm10491839ill.84.2020.11.16.07.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 07:40:11 -0800 (PST)
Subject: Re: cleanup updating the size of block devices v3
To:     Christoph Hellwig <hch@lst.de>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20201116145809.410558-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <506876ff-65b0-7610-6f9e-8228fcd201c8@kernel.dk>
Date:   Mon, 16 Nov 2020 08:40:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 7:56 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series builds on top of the work that went into the last merge window,
> and make sure we have a single coherent interfac for updating the size of a
> block device.
> 
> Changes since v2:
>  - rebased to the set_capacity_revalidate_and_notify in mainline
>  - keep the loop_set_size function
>  - fix two mixed up acks

Applied 1-23 for 5.11, thanks.

-- 
Jens Axboe

