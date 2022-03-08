Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646B3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 22:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344587AbiCHWMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 17:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiCHWMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 17:12:40 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE974927F
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 14:11:43 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id r12so336037pla.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2022 14:11:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zsuN6YZ8l60CNL3ec8tnGiB7TFkpcMErgCfCkAo2B4I=;
        b=P8rFg5YSudAH8/QklYVPFzCws0nWEWVdNuyvraoCY3nABz9ayr8BxBuUSv8JOtiQ1g
         x3CIz0Pcbp/CD2wj7GCGc0Yx5MVjZz/kMucv6fEUo/bTLLxoAfaWuvRZiiKtrYm0JPDZ
         JvTn1YQZNecIfv20XYVeeEuuLuLsw0BK0pUj1JK4YVKA2kOHzoFlgEEqdMVVhnRxN/BN
         yplPpU1WjXBynGAU7EdJ4T9RNv7kg9YxIeAwfo9bhNuLzODLXFd3S6scpimmut/QCbTS
         3KiQycCwnVGcBIsSrx9Biq57kokuy798HYSNP2NBu4cJ+9RLd/8knbUt/7WzAe3ecLPk
         Kyfw==
X-Gm-Message-State: AOAM532L0eyCOgKKgpcOzAcwb4X/zPrpHNajrwAIRDX0edId7U0a3H1P
        5+qJRV+hmsl6o22FgSqvPlA=
X-Google-Smtp-Source: ABdhPJwy/p0tWeBMYKahZbXIxu9gJnAw5AeTU3wvkcEtpbhfcyhI3vDafIBBiSgYY92GvI/w0YJzLg==
X-Received: by 2002:a17:90a:bf91:b0:1b9:bda3:10ff with SMTP id d17-20020a17090abf9100b001b9bda310ffmr6956053pjs.38.1646777502510;
        Tue, 08 Mar 2022 14:11:42 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:88cc:528c:d341:9395? ([2620:15c:211:201:88cc:528c:d341:9395])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00228600b004f709f5f3c1sm60541pfe.28.2022.03.08.14.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 14:11:42 -0800 (PST)
Message-ID: <4f464024-d114-dafb-8a0d-fa77c6fdd5d6@acm.org>
Date:   Tue, 8 Mar 2022 14:11:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, mikebi@micron.com,
        beanhuo@micron.com
References: <20220307111752.10465-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220307111752.10465-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 03:17, peter.wang@mediatek.com wrote:
> When ufs init without scmd->device->sector_size set,
> scsi_get_lba will get a wrong shift number and ubsan error.
> shift exponent 4294967286 is too large for 64-bit type
> 'sector_t' (aka 'unsigned long long')
> Call scsi_get_lba only when opcode is READ_10/WRITE_10/UNMAP.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
