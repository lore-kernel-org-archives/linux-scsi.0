Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CB8EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 21:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjGQVCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 17:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjGQVCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 17:02:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A520A4
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 14:01:59 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-977e0fbd742so672637766b.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 14:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689627718; x=1692219718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B+yMs4zqia6Ar3W3JHKSihsmMp/Z0WiqTJap10w82nI=;
        b=PZqogpatnNzbBlCK9BjVxWIfzGODsb8vSN5YyRLrjZWPCtSNylcyiK6Tv/RRuHwrNk
         9zGN0fHlT2AzkkzRIf4NoZdr6DT/DOnoislUamV5svKj4/At20cSICQ+mAWTsSvl//Rq
         30CyGQWw31e03+ZtgLpTaIyxyN/QXlymCfNUP+4/v6514Ky4m96GCG6HcvHYbUOPAb/Q
         FO2gVXGFlHKJiLQWBQD8wLcH/8WbiW27oask0ohyZM+7aFl924oIyJXPgmg1vqpXH118
         q+/GPv9MSIvRn26FoZIEyJLIbNKJKxuOE35ki/HbF+L0XPhrWwUA2yrKEPW/NwR9T/UR
         ysSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689627718; x=1692219718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+yMs4zqia6Ar3W3JHKSihsmMp/Z0WiqTJap10w82nI=;
        b=P0uoXKOQV2N+9gPBXsBK2DpbqprDTx59Tm4RVSRzT6DiTZBq4lnOtbdX5m2gTdJpUq
         /FoXXXyG0vCAwfAuIPvF985FQn53Uam84gbJenydbVXwiimI3RLNSjhN5L6qSqmTZS/u
         QFMYd+YPoTXoq/RCBbyKmvCbMoqUany1ScdxOb2Tn+wYLtw7zWwanz3jjxVplDEGMkbl
         KlNYe3i/qGzHub8hwQD0La4m1A4hUJZZ8g/AXnv2QhaKBXcfXOYgq+Z92NkFCc0CxOvH
         J7WH+hRp5+T5+86/bkfKsZQJDyqq4w89XZu7t+8hZ2FKAYk8q88QTYRyjQc7+rdp5VEK
         e66Q==
X-Gm-Message-State: ABy/qLbyfpa4F65XqMzO6szcqjhJLWwuJjoWLk09e/YK/ZvEx5O/X6oZ
        AdOeW54JrPTAmfcoLyjZwznF2O5kGVV4bA==
X-Google-Smtp-Source: APBJJlG1Su7ThHq6X6RjA+enuwpsyMM6n/5UUDDVZ01rdrEI5HnNViRNCkrO57vzfqcVbOoFtBIpow==
X-Received: by 2002:a17:906:7790:b0:997:deb1:ff6a with SMTP id s16-20020a170906779000b00997deb1ff6amr213491ejm.22.1689627717747;
        Mon, 17 Jul 2023 14:01:57 -0700 (PDT)
Received: from ?IPV6:2003:c5:873b:7c7c:f26a:b9b2:ec4f:e89a? (p200300c5873b7c7cf26ab9b2ec4fe89a.dip0.t-ipconnect.de. [2003:c5:873b:7c7c:f26a:b9b2:ec4f:e89a])
        by smtp.gmail.com with ESMTPSA id o21-20020a1709061b1500b0099364d9f0e6sm143166ejg.117.2023.07.17.14.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 14:01:57 -0700 (PDT)
Message-ID: <bfe49690-7127-94af-ae2d-0a09000e33be@gmail.com>
Date:   Mon, 17 Jul 2023 23:01:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] scsi: ufs: Remove HPB support
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
References: <20230717193827.2001174-1-bvanassche@acm.org>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230717193827.2001174-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.07.23 9:36 PM, Bart Van Assche wrote:
> Interest among UFS users in HPB has reduced significantly. Hence remove
> HPB support from the kernel.
>
> Cc: Avri Altman<avri.altman@wdc.com>
> Cc: Bean Huo<beanhuo@micron.com>
> Cc: ChanWoo Lee<cw9316.lee@samsung.com>
> Cc: Daejun Park<daejun7.park@samsung.com>
> Cc: Keoseong Park<keosung.park@samsung.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>


