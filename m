Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9124C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 20:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B22C2067D
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 20:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kali.org header.i=@kali.org header.b="c0a4aSV0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgGGUFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 16:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgGGUFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 16:05:52 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAC5C061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 13:05:52 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g37so11527290otb.9
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SYsVEkGw4Su4wBauO9K1p3fqyOIu+6zzCE2sgTApDi0=;
        b=c0a4aSV0i7VGWYeJtAz+EjKYebGOugJC/B9QBavVkIxetHpYOVy2I3nPaPPNH3B+Ay
         CYjdlOmeWCA8hncH2oixj+nOe8/PEb83ko0pcWRk4aMFxCiStu1BIqbfk0xtg+G5rHUc
         v+yTtjnzoTgoE9RUz2HN4sMittX+nFfEnIqePY1Gow0SkytwoO8ReLwsOFDOwwXtA/7J
         gB+R9mpinNzjyAPdeDHXVwcfl577xGJeW3T5xB81+F656oPE2BM05qsBTYRAW42jCexZ
         72IM8xgp6ZKsVxb59080CEQ/VNUBek83e0B8QH2x2CgAFiTEtVpR3/muUKw2WYxUlV0K
         FlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SYsVEkGw4Su4wBauO9K1p3fqyOIu+6zzCE2sgTApDi0=;
        b=UU/xZJtsfJudDreF4Bg7/j4st9R1P9nAyWShVVZMA/nt6htTmSCJggOtWopUAg232H
         a6q2yMxIYDIZfvWoWEsIGORu/dyyGWif8ldUPL+zFS7wusv7ZkkDQaIyAYAKGVMaii/3
         LTiwr5hvLVlN5OLDsvQHCvOh2D3kLSHakH6ialH+ICXHrqtd6I2D3sbxzn682mqGmXLo
         jiGSvyaC/ZrAkPGcy6B4SQOpd6nY6Jv50GnXF+WK2C4vQITl7XZzvsaKu/B0713S9OR+
         TcslXnkOhzPbwbE8r4OfHvQmQY2hN/L974y5eDfLgLdx4r4R82m2Rp5WF+4h2oY706sk
         yMqg==
X-Gm-Message-State: AOAM530R5ldn8KqoH1ZytBrLslOm8L4u0Z6oKzophQyHCCo3GlXQuEvO
        cB6pmdyS+InjBPpy4k4MDu/W17jU8es=
X-Google-Smtp-Source: ABdhPJyfdwI11d+iAzXvPBn7hfMvteiVABDrzR0cv4GyTpYuN+JlFsx329dJzvCbmFaHEcnPDKLf2w==
X-Received: by 2002:a9d:7d8e:: with SMTP id j14mr49717115otn.35.1594152351722;
        Tue, 07 Jul 2020 13:05:51 -0700 (PDT)
Received: from Steevs-MBP.hackershack.net (cpe-173-175-113-3.satx.res.rr.com. [173.175.113.3])
        by smtp.gmail.com with ESMTPSA id 100sm5950020otu.52.2020.07.07.13.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 13:05:51 -0700 (PDT)
Subject: Re: [PATCH v5 5/5] scsi: ufs-qcom: add Inline Crypto Engine support
To:     Satya Tangirala <satyat@google.com>,
        Thara Gopinath <thara.gopinath@linaro.org>
Cc:     Eric Biggers <ebiggers@google.com>, linux-scsi@vger.kernel.org
References: <20200621173713.132879-1-ebiggers@kernel.org>
 <20200621173713.132879-6-ebiggers@kernel.org>
 <20200707191224.GA2203002@google.com>
From:   Steev Klimaszewski <steev@kali.org>
Message-ID: <a9d6e5af-aeea-ccc1-7538-ae9987b455f9@kali.org>
Date:   Tue, 7 Jul 2020 15:05:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707191224.GA2203002@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/7/20 2:12 PM, Satya Tangirala wrote:
>> Tested-by: Steev Klimaszewski <steev@kali.org> # Lenovo Yoga C630
>> Tested-by: Thara Gopinath <thara.gopinath@linaro.org> # db845c, sm8150-mtp, sm8250-mtp
> Hi Steev and Thara,
>
> I've sent out the patches that add inline encryption support to UFS
> (that these patches build upon) at
> https://lore.kernel.org/linux-scsi/20200706200414.2027450-1-satyat@google.com/
>
> Can I add "Tested-by"'s from both of you to that patch series?
>
> Thanks!
>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> ---
>>  MAINTAINERS                     |   2 +-
>>  drivers/scsi/ufs/Kconfig        |   1 +
>>  drivers/scsi/ufs/Makefile       |   4 +-
>>  drivers/scsi/ufs/ufs-qcom-ice.c | 245 ++++++++++++++++++++++++++++++++
>>  drivers/scsi/ufs/ufs-qcom.c     |  12 +-
>>  drivers/scsi/ufs/ufs-qcom.h     |  27 ++++
>>  6 files changed, 288 insertions(+), 3 deletions(-)
>>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
>>
>> -- 
>> 2.27.0

Hi Satya,

Yes you may!

-- Steev

