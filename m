Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2DCC83F01
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbjH3U1w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 16:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbjH3U1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 16:27:41 -0400
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F454B17
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 13:25:01 -0700 (PDT)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-34cacab5e34so648895ab.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 13:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693427019; x=1694031819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu+v5TcyzpQLtUTlfHhtPfmsTcuZLW0rXfwL8u5p7aU=;
        b=ROROTTiyxkem3QxxOMmhLRsJoLIFne7br09sh+fbuGXLiefQmT6+o0vmuDINAyx83e
         JG4klslesAJv/jix3Us5ij+Xx88Z2f9mfKJPaLWwaVMXMLA8z89UuSvHIDLV86K6ox4K
         kusfqpJX1yLttlxtBvD/5+05nfLeE+ElMiCQgb1QBsqYI2v+q+08Spmkmqx7md+jN5yi
         mJHLcfD4Qr0Mm61YCYWCABSE/+zKBjQle2uBjgHNQwcS1AYamikAVEmJoxDgHKZZWr6r
         OUC+ET1/swP5f1QZG+NacoChfWaE4bBZ+jwjpnHIaHuQ8Bo/ooJddWRipQu5gxWmvdjN
         4UNQ==
X-Gm-Message-State: AOJu0YzRY9UWgXxFWaugQEy5PmQquIuyzSYs0CLlp1ZMJ0UDeRq8zLaB
        9xAgD2jIN+zlJ1MNndj4GMkHtmU8Vw8=
X-Google-Smtp-Source: AGHT+IFSVljawPLxfiOGWs3tuZoCeomEGtwAcIarN3V/KEUAA8oEDaI18lulp3iPv7mcjjE/JJk9cA==
X-Received: by 2002:a05:6a20:4281:b0:14b:8023:33cb with SMTP id o1-20020a056a20428100b0014b802333cbmr4045233pzj.11.1693424470787;
        Wed, 30 Aug 2023 12:41:10 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id i25-20020a633c59000000b0055bf13811f5sm10542568pgn.15.2023.08.30.12.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 12:41:10 -0700 (PDT)
Message-ID: <884c6a53-cdef-4a38-a2b0-a40d46cd9d88@acm.org>
Date:   Wed, 30 Aug 2023 12:41:09 -0700
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

