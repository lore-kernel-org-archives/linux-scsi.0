Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BFFC83F12
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 17:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjH2RGO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbjH2RFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 13:05:52 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C1CAD
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:05:50 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c0d0bf18d6so37323485ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693328750; x=1693933550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu+v5TcyzpQLtUTlfHhtPfmsTcuZLW0rXfwL8u5p7aU=;
        b=YQetdtxuDuV8YkjDmB6lp0W2TEs5DVjX5WpR4y7ikMzk0f+ucwHQ99EljTj75/LGHM
         ZhutfNOh45LF/CULwXBtcT83uo48j4sZYHJc0Q0wunL8dFP7JknMuV+keCZB1gGrlRfJ
         LjTLTsujUKUZlfXPfFo6DJ/A6FB8lXWwSdcKl/rZb4z0QMYrI7s81sSGBgmm4DMojp65
         fxTiYYA4hbwKJzKcJ1DbbVTOf09LHZYe0ipeDi7QI6y728p36aOstvsOfAwDIX6aFF2u
         xGH4D1IfHkQhOk/C2Bzle2ED8Ei4sg0yLgO800QgrWKvMl6Y3SgnU5gOWsKgU2FIHRjW
         ohXA==
X-Gm-Message-State: AOJu0YxbSyvQ6wMWUarUFvuWRpcD/KV5lDc/sm+CWyBq51umeYcto8rq
        fro59THEcqIoS1ABb9jXVZId3gLTrHwW2g==
X-Google-Smtp-Source: AGHT+IEGg1A2gfIRrv0r2UaCtqWnbAB21E1HF+udH5pncfGtzM4fik1xfDzyAqvExxp9SxJ++KBxBw==
X-Received: by 2002:a17:902:d4d1:b0:1c1:ecff:a637 with SMTP id o17-20020a170902d4d100b001c1ecffa637mr6896911plg.15.1693328750112;
        Tue, 29 Aug 2023 10:05:50 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001bf5e24b2a8sm9595806plf.174.2023.08.29.10.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 10:05:49 -0700 (PDT)
Message-ID: <739965b5-346a-49ab-bee9-997cd8b5d7ae@acm.org>
Date:   Tue, 29 Aug 2023 10:05:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] ufs: core: fix abnormal scale up after scale down
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
        naomi.chu@mediatek.com
References: <20230823092948.22734-1-peter.wang@mediatek.com>
 <20230823092948.22734-4-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230823092948.22734-4-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/23 02:29, peter.wang@mediatek.com wrote:
> When no active_reqs, devfreq_monitor(Thread A) will suspend clock scaling.
> But it may have racing with clk_scaling.suspend_work(Thread B) and
> actually not suspend clock scaling(requue after suspend).
> Next time after polling_ms, devfreq_monitor read
> clk_scaling.window_start_t = 0 then scale up clock abnormal.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
