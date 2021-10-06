Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8108CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 13:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A07E6113A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 13:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbhJFN1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 09:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238881AbhJFN0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 09:26:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633526680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PhQKrj6CTy/IMZheSbTjJtRay2DZf3eElNhZxG86YDA=;
        b=Wn1FfYYPP2ByTZhOcVoK7seiFiEacKNk5sg8k1F7KdcFoYmqVJObubIbfErZawhH5be/x4
        MjSHZLeJ0z6LQ/yBX2oaGSY+ZeR43CxCUQF4qMx7upQFM8X/sx0pI/1zXaKwkqvp6n+IX3
        eVBTfVDRf2O/Qm81kKTKlwrahH5PZh4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-fbefkzuONLq9oqJ_Z0iJjw-1; Wed, 06 Oct 2021 09:24:37 -0400
X-MC-Unique: fbefkzuONLq9oqJ_Z0iJjw-1
Received: by mail-qk1-f200.google.com with SMTP id j6-20020a05620a288600b0045e5d85ca17so2117591qkp.16
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 06:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PhQKrj6CTy/IMZheSbTjJtRay2DZf3eElNhZxG86YDA=;
        b=JrWXHRoiByGZcqHsUNmAgA2NvJ04f37ALfAgE/JjRcLldvV/pbM7FJpGl/+9roQ9lB
         yj0JQZ6w/qERlDNz3OrFekprZDUNM+P/+NUFOB17Wf0gpQKILq1ABgHf8l5HLJ+Pt0xk
         y8eXcPD734xycunCruMeuuqUk9QOw7H8nJfT2cnV2Z7eKADQUWQYVIwSz66On+D6urqt
         3uVoAEVYPSqw0/12ydYLHttDZv6RIaE/pqLBDKMheNo2l24KDZj/mc5f0PfJ25NLfj69
         plc/WeS0rcDBVGYRjFbo1gNN7vbb5QGdkxTRdBkKPo0cLC6Z4yTlrvBSSkrtMzffr4DM
         XIUQ==
X-Gm-Message-State: AOAM531ZVUUpj6FJ2dZQ5qSULcokB+6d9S76mXdK6Z8TDRqSdbRSNlhe
        /VemAzF6ZmFh/u37WtX5veMyUsxTPSTM6c/ZBcjL481ObA/eIziqxmcsbMnwgC+rahYsKqO8Ng6
        6id/ptOnUnx7E0+Dp63NL
X-Received: by 2002:a37:9d16:: with SMTP id g22mr19915883qke.158.1633526676977;
        Wed, 06 Oct 2021 06:24:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwU5K9sLtf2F8/ZVmQbICWiONRseEkHUAhaNdvw8PixzCkidZf3Sgubc2NbR+xRlb/+oJjIrw==
X-Received: by 2002:a37:9d16:: with SMTP id g22mr19915860qke.158.1633526676823;
        Wed, 06 Oct 2021 06:24:36 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id s14sm5011152qtc.9.2021.10.06.06.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:24:36 -0700 (PDT)
Date:   Wed, 6 Oct 2021 09:24:35 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 1/4] blk-crypto-fallback: properly prefix function and
 struct names
Message-ID: <YV2jk1su5caAZmVP@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
 <20210929163600.52141-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929163600.52141-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29 2021 at 12:35P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> For clarity, avoid using just the "blk_crypto_" prefix for functions and
> structs that are specific to blk-crypto-fallback.  Instead, use
> "blk_crypto_fallback_".  Some places already did this, but others
> didn't.
> 
> This is also a prerequisite for using "struct blk_crypto_keyslot" to
> mean a generic blk-crypto keyslot (which is what it sounds like).
> Rename the fallback one to "struct blk_crypto_fallback_keyslot".
> 
> No change in behavior.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

