Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0378C77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 17:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjDURZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 13:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjDURZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 13:25:50 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA6013C09;
        Fri, 21 Apr 2023 10:25:49 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1a66e7a52d3so20240785ad.0;
        Fri, 21 Apr 2023 10:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682097949; x=1684689949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQs82gH5EVISyPeyNZ2iMKvsiMLPelCfXsrpU3XIeTo=;
        b=QlLcffZKSWpaoQgZaCOM1PbEAUSL+iDzMLWxV8PkdtJcCE30Dqn9rO0NSwlQlQddJT
         c+lQgNwioo5J9c6jbQUIscL4FQANbwu71deCDcDfoITLT1ukv0nCA7HUVcNbWzpcnMA7
         87RwSB5I9DgM1goLdueJ1A+1HtUTXpk0VCkOpZF0ie7ma10BuSnhvMxrEmC8IYoyIdOG
         9u6zxLtmBGrm6nuAOyLBQzwxe3no0mypItQD8EJp+XQBTR0Epwfb4BMw/NGxYbu6YQVj
         wgXvYmN3V/agF1R6EUe95+xibng5Y9uyq9nTO5vsUD4CbAkr9bgWNnnPeb2DYfmKAw90
         853w==
X-Gm-Message-State: AAQBX9fC3zxZogSR9MSVBpZgtu19WKvy0nKVPuNgVeSzTTJNcYaf09gu
        8i2XVnJYALxMDS1UPO7S0Cc=
X-Google-Smtp-Source: AKy350YL/mh/hXPZK7lwtFCdyt+oJHtYr2JBiXgiHmnV0Gg8WVyxNewBlUw1Yp+SzWaQFH7hIwKMGw==
X-Received: by 2002:a17:902:8498:b0:19f:2328:beee with SMTP id c24-20020a170902849800b0019f2328beeemr5124487plo.11.1682097949243;
        Fri, 21 Apr 2023 10:25:49 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id w15-20020a170902d70f00b001a6c58e95d7sm2973074ply.269.2023.04.21.10.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 10:25:48 -0700 (PDT)
Message-ID: <8e4a9151-10e3-28a4-3263-25e67437ffbe@acm.org>
Date:   Fri, 21 Apr 2023 10:25:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/1] ufs: core: fix &hwq->cq_lock deadlock issue
Content-Language: en-US
To:     Alice Chao <alice.chao@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, quic_asutoshd@quicinc.com,
        quic_cang@quicinc.com, mani@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     stanley.chu@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, powen.kao@mediatek.com,
        naomi.chu@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        wsd_upstream@mediatek.com
References: <20230421075636.24946-1-alice.chao@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230421075636.24946-1-alice.chao@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/23 00:56, Alice Chao wrote:
> When ufshcd_err_handler() is executed, CQ event interrupt can enter
> waiting for the same lock. It could happened in upstream code path
> ufshcd_handle_mcq_cq_events() and also in ufs_mtk_mcq_intr(). This
> warning message will be generated when &hwq->cq_lock is used in IRQ
> context with IRQ enabled. Use ufshcd_mcq_poll_cqe_lock() with
> spin_lock_irqsave instead of spin_lock to resolve the deadlock issue.

Please add a Fixes: tag.

Thanks,

Bart.

