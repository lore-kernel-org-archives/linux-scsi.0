Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39846C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 18:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiLESyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 13:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiLESx4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 13:53:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CDB1FF9E
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 10:53:54 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so12386118pjo.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 10:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hN16r2JqgO0aUt9hEV33NLw/555dF70HALoTZ9f98ns=;
        b=Fm9dfwrFeIHNqJDczZ8ygOt/Uha01dMRWprhcIoeUWieIM4pkz1xky0EJcPnQBQWe0
         m7GUZoU0/2aCb+0E0+M6kltGs6hlEENaCX5gfWhRnXRd0rye5mK3KgRvIyM/2Oob5UlE
         38SmhTUgfCQay5hI4WIf3FEGQSsP7+pCWGiu3ohS05iL+h2v7+4MM6ftNKTC3q+ULBws
         nL39f0K0e/CH9ck/0WnWtdA3yoVKa3Ds36+G8AkqXJGYa6Ma+P2vAgd/4nl8Sjjj7ig4
         xXJQXoxqZJQ1eNNeKYHnnOqVcnXQ7tDUkUNigzrEsoOXLZHKOOwqgr2IQdgxEPpBBKfc
         HsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hN16r2JqgO0aUt9hEV33NLw/555dF70HALoTZ9f98ns=;
        b=NrZQH1Y43hqd9JbJ6rjAZ36vorz7iuvB9tM55XiPTeT97+fLHx156XUD1WdGiHBMDP
         zIzcAqyzi15Eh19YLiE0bB3gBSdzDSkfH1kAt8CawbSwu15lqjRW7FuiuKs92cWBodoE
         nJL0iSAuTPgfQrD8JwDWfWr3abPoYdJ/LiuafVfrK2uQdYH9lBNpbVz+71Akpm0cj86T
         Goh1ZlIMyODTfG5fJKHCfi1dSfY7nRBFNN21Y6LdGPP2gW6imf/qvQhPe1rMFGHzZqXm
         67hetpOnH4e+NTyzmK/4LKlmTzjTqVGehUhw0WHoJn07TNxWkCpnKw55J9Wy2TMydBfv
         OquQ==
X-Gm-Message-State: ANoB5pmI+Xd+UgZSsx99MyFjr9PZy2rawMlHn//ZlquySPfWftbLEH1r
        NEN4FaOTz5xcTvhawUKgERQboi76zZ3IEj7p
X-Google-Smtp-Source: AA0mqf4PO6AFHe2UJAtP+NKsy/VfRk3d594BgBjTrOZGH8U7h8+eNxk2+VLeleDwTNhV8wJgpjSYkQ==
X-Received: by 2002:a17:902:e411:b0:189:8796:7813 with SMTP id m17-20020a170902e41100b0018987967813mr40667373ple.110.1670266434300;
        Mon, 05 Dec 2022 10:53:54 -0800 (PST)
Received: from ?IPV6:2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a? ([2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a])
        by smtp.gmail.com with ESMTPSA id o8-20020a170902778800b00189a7fbff33sm10880935pll.170.2022.12.05.10.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 10:53:53 -0800 (PST)
Message-ID: <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
Date:   Mon, 5 Dec 2022 11:53:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Content-Language: en-US
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/5/22 11:36 AM, Alvaro Karsz wrote:
> Hi,
> 
>> Is this based on some spec? Because it looks pretty odd to me. There
>> can be a pretty wide range of two/three/etc level cells with wildly
>> different ranges of durability. And there's really not a lot of slc
>> for generic devices these days, if any.
> 
> Yes, this is based on the virtio spec
> https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html
> section  5.2.6

And where did this come from?

-- 
Jens Axboe


