Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1286EC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue,  9 May 2023 16:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjEIQbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 May 2023 12:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjEIQbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2023 12:31:05 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D98422D;
        Tue,  9 May 2023 09:30:59 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-64395e2a715so6032320b3a.3;
        Tue, 09 May 2023 09:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683649859; x=1686241859;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5zwYmC5Iapd68RqlxFcQ96Glwp7DmSHjoyhPhYBPtpA=;
        b=g//OZiE/cujbj3Z0yGhCGShvfVGmqXy2SFPdGApjjo3mJAqYBlMWpmkzP3e6DrIlKN
         GIGCBejJ9MjPF9Hzxe162PFt8WhrcbWqBvZuIuMFRyomBkFzFcs0Dd2+fifYYmdqSmpp
         XbSFABF3hnN3kxWmRCzYv97NAQdqIiRjmi8mgqQfDaEsV6o2lUYePGQqwL5vPoCrq2b+
         8mmmBVnne/JdkehCRlx+JxWwytv+SzV8v+lXTn/zwPmSyGGQhJpwEzOKHUC3pbQho1EU
         Vr18IPT2zk88eLiQwbwlWqGfqXbcQVMMSB4zoC03J3JAvnviqQg7Ofldbu6zQDOgpa2q
         yk6g==
X-Gm-Message-State: AC+VfDzIaHAUziKngQC9K9Br3uVQASQ8Sp1qsdlS1iR3sxFwjJ1k39z/
        rMAlT0TbR8plM8TU5mRLvAU=
X-Google-Smtp-Source: ACHHUZ7mxN7fZJGUConRfJ0Y1JY/m20MYrK734Vrj+cvrSI5OeKIqRvsnQaKeL0n2WbpKZXrMqwijw==
X-Received: by 2002:a05:6a00:15c6:b0:647:7ee8:6251 with SMTP id o6-20020a056a0015c600b006477ee86251mr1911118pfu.21.1683649858777;
        Tue, 09 May 2023 09:30:58 -0700 (PDT)
Received: from ?IPV6:2001:4958:15a0:30:e15c:df42:f610:1b21? ([2001:4958:15a0:30:e15c:df42:f610:1b21])
        by smtp.gmail.com with ESMTPSA id n14-20020a62e50e000000b0064399be15f0sm1948312pff.183.2023.05.09.09.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 09:30:58 -0700 (PDT)
Message-ID: <6192fa07-ec6f-0464-deb6-c3e9f69f6ebf@acm.org>
Date:   Tue, 9 May 2023 09:30:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 2/2] ufs: don't use the fair tag sharings
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>, Ed Tsai <ed.tsai@mediatek.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
        "naomi.chu@mediatek.com" <naomi.chu@mediatek.com>,
        "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>
References: <20230509065230.32552-1-ed.tsai@mediatek.com>
 <20230509065230.32552-3-ed.tsai@mediatek.com>
 <DM6PR04MB6575753742F933DE192E7325FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
 <dcfae203-005f-928b-37d6-7ee5bb4e2971@acm.org>
 <DM6PR04MB6575F344EF2D962103888A56FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F344EF2D962103888A56FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/9/23 09:19, Avri Altman wrote:
> Following your argument, then why fair allocation exists in the first place?

Does this patch answer your question?

[PATCH v2] block: Improve shared tag set performance
https://lore.kernel.org/linux-block/20230103195337.158625-1-bvanassche@acm.org/

Thanks,

Bart.

