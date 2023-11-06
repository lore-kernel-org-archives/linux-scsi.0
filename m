Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535D0C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 18:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjKFSEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 13:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjKFSEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 13:04:54 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81634D47;
        Mon,  6 Nov 2023 10:04:51 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6c3363a2b93so4265175b3a.3;
        Mon, 06 Nov 2023 10:04:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699293891; x=1699898691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Hd8uhGvTzF9AgKLCd+Lbl7J9eRzvxUH/L+jeg+epcU=;
        b=nQsKFyjM7u2xbNggHOlmL3fjwP7ECxIyNhJShyZwF0wx3U3jacvp3qv3DhfrGp6fhU
         Ki8i3Fs9WBWxDfq2puk0RbE8ruSJHxbUshLOeAK8l8Mh0ZVhHmMMkmj0NZck7jMZQYck
         6aZdW8koIvm3tCnu/i7k3+ZHW4A+SVu11vId2e/QbIAmYe7EfP9dQ/k48N7LQQyc4+rC
         YbY2kwdIKnQovonADzmizjhWgxdbpLfmiMmZCTaqY54tbiNPNqa+jQa1GrQ5GFQn5KRR
         sophQmWnRb1XV7/0SjeKZ7KzX54SQhPQYCKH7wKAAQ6g3l+XJcutE4UPkKoKqrbwdsGQ
         /lLA==
X-Gm-Message-State: AOJu0YwOX4kf2f1yglbvkHT3ebPzCEuHRlOzQ7DMlKi4RTNDkG99Xfca
        QyKOW+coNw4gId0CrsWHfoU=
X-Google-Smtp-Source: AGHT+IG67a2JGponoHPmNCrlxe2OH3T4lJvGgK8UtvTUsThCl+UbtrEA9Chm1YEYKJhc0HFBHSl80A==
X-Received: by 2002:a05:6a20:8427:b0:16c:b95c:6d35 with SMTP id c39-20020a056a20842700b0016cb95c6d35mr39820960pzd.50.1699293890807;
        Mon, 06 Nov 2023 10:04:50 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:ac50:9303:758b:edb9? ([2620:0:1000:8411:ac50:9303:758b:edb9])
        by smtp.gmail.com with ESMTPSA id z19-20020a63e113000000b005b7e3eddb87sm74212pgh.61.2023.11.06.10.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 10:04:47 -0800 (PST)
Message-ID: <c5f9e06f-a098-49d0-9255-7cfc4dd3db10@acm.org>
Date:   Mon, 6 Nov 2023 10:04:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
References: <20231106075117.8995-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231106075117.8995-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/23 23:51, peter.wang@mediatek.com wrote:
> If command timeout happen and cq complete irq raise at the same time,
> ufshcd_mcq_abort null the lprb->cmd and NULL poiner KE in ISR.
> Below is error log.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
