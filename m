Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB056C4320A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 01:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16C760F41
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 01:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhG1BcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 21:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhG1BcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 21:32:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08295C061757
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 18:32:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso7600904pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 18:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5rj+Jk8FZe2NEOutgAZKHy8g5XY1Cgm2OZ1BjO0VAd0=;
        b=oTfMUw2EkafM0zM+vz7MUGjWHsAMLTsK1efDco2LoDl5YGkfsXIthZivNODcSebRY9
         6u3W5VS3Ily4bMwwrikZiTJXxDtP16BTyXHbExHnbwePelhCg5MaWUy4GKzM3SHe8p9V
         3MF5Wri2SJBEpdKM+XpKWKCd3SAm+kBHVwunaeghnGmCmjvRdl4n8LpZiCFx5JvpCKmI
         /unIogdFHU/VuHO2fWC4udd4cr8kFaO//dYM1PcRSsqnGBG7sduKIrP9xOSBYWJuzzii
         E3z7qD4fxDaApSnavwNLbZKPYDhL92d2UZf/iAzq6C9nWM1hE/ER7gzt5RUgLjHv/D6E
         iTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5rj+Jk8FZe2NEOutgAZKHy8g5XY1Cgm2OZ1BjO0VAd0=;
        b=dDdCltjXn4qaTs12D1uj5Cl9UtKB2E+ImUO2jWBGjxYd3ogYsiEE50oX91EHB+HD21
         8bjrY7rSOiFQoKg2844aM+ODotZ1Dh/nshSMN6HTWsQo9o65yBIemHpB41YP6ihjzSJU
         oqWt1J8oe58+HA2DOfmVWO9iQBLi6I2s3/h1vwUQMXICh2e+wmgAaYFGKro/hJxvf29w
         SiBOpwgvxHLug5F4kcmGsFD98I/A2ud+poEwqzOUKLeKXhQPEwU82K8ativhu3WIkAFA
         8LS/GNCwZFQBsggOKA41lw2B9GZdhv0oZ8WrO8/iB1HtgEyiPfA22TF0BWrv3q8Vztjj
         N0fg==
X-Gm-Message-State: AOAM533lVHTJ4T+b1z/tJPQSOEkCZ+p94QjZCgbxo9rEluXmeTgREvrf
        o4J1ufoGyHH1CXrKGB+k+84drw==
X-Google-Smtp-Source: ABdhPJzArq/2MSZEt4PoQH1xCrFAgDVmP1R6cTFs/nEA3E2TCkL7htHdSRGpAC/pEHilHz8mnYqRCA==
X-Received: by 2002:a65:5083:: with SMTP id r3mr8039958pgp.161.1627435937627;
        Tue, 27 Jul 2021 18:32:17 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id w10sm5544576pgl.46.2021.07.27.18.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 18:32:17 -0700 (PDT)
Subject: Re: [PATCH 01/24] bsg: remove support for SCSI_IOCTL_SEND_COMMAND
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
References: <20210724072033.1284840-1-hch@lst.de>
 <20210724072033.1284840-2-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b3e2bea6-3ba9-11d6-f054-e1fa62be466f@kernel.dk>
Date:   Tue, 27 Jul 2021 19:32:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210724072033.1284840-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/24/21 1:20 AM, Christoph Hellwig wrote:
> SCSI_IOCTL_SEND_COMMAND has been deprecated longer than bsg exists
> and has been warning for just as long.  More importantly it harcodes
> SCSI CDBs and thus will do the wrong thing on non-scsi bsg nodes.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

