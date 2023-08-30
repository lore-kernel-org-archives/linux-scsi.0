Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016CAC83F01
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 20:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbjH3U0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 16:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbjH3U0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 16:26:10 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC52ECD21
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 12:53:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bf078d5f33so211665ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 12:53:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693424822; x=1694029622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7uxS6jFbfP3ewnHJ55rgEk1lcD4TZvwx/MvbvZ9/xs=;
        b=YgCLE1R4s2pOMSf3QG+MpjwtTLk1Lg5j5MtSGMgzwlPMk4DFMuk/YauD4hC8z3hKbm
         u+0Ez+2pavUcdxbtfg10VGrzEP8jili1QtvbexqiP8wENZMhfeMOxsxo1NE5cpDDHvlW
         IgEijs3NrjXhAD2feFX28bdgYo7xXuz550FbZrNuRQtODwTcrMZBc1aekLj2Hacu4RZa
         4u+uFeKDiyjlW5IpZkylp7O9TuYT4X5GEV0vpnUMjtUqih6BtBescatRtQZOdGNuJQbj
         pV1J1b4P7fzrS8c9ZftlXZAi/mCaNqQm9kT9c+Lz48f986LR5y2orQ3nG19KT0MlbPq4
         otUQ==
X-Gm-Message-State: AOJu0Yz+bZQJsPAY1H7YruqM7dalbBcsFhbMWpLf6IemT6XRlBfn9CNS
        ajxiesmg3hr4gf4OfeZtTN4d0Rmm2Og=
X-Google-Smtp-Source: AGHT+IFzfrpd0+O4IZE90kBv0R8G1oWwBoCEhJ57vyOKcHcq8Wll43vHKGECUr55ZT76Ox9+eyURhQ==
X-Received: by 2002:a05:6830:1dad:b0:6b8:8f20:4cbc with SMTP id z13-20020a0568301dad00b006b88f204cbcmr3250425oti.13.1693424400868;
        Wed, 30 Aug 2023 12:40:00 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id i25-20020a633c59000000b0055bf13811f5sm10542568pgn.15.2023.08.30.12.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 12:40:00 -0700 (PDT)
Message-ID: <e2e7ad5b-a588-4c2c-8335-97d8e6b87368@acm.org>
Date:   Wed, 30 Aug 2023 12:39:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] ufs: core: only suspend clock scaling if scale
 down
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
 <20230823092948.22734-2-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230823092948.22734-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/23 02:29, peter.wang@mediatek.com wrote:
> If clock scale up and suspend clock scaling, ufs will keep high
> performance/power mode but no read/write requests on going.
> It is logic wrong and have power concern.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
