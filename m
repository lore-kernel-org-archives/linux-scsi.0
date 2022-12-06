Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EE3C352A1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 18:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLFS7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 13:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiLFS73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 13:59:29 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D9136C68
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 10:59:29 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id t18so5051565pfq.13
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2022 10:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIPweIwuij1QW1uQnto7kf0CevT66V2jnSmHF5fZ+JE=;
        b=0DQ1OAynN9SHWasp/tTExZrBORFaGjRTpprljYa4FgDDyHBobn9RlpTXJsDCXdLXYU
         /IIlkGKzZH9E7tDy2yHOpE5GGjEl96f+fujX2z1x3nRKXNcOHfm4B1JKB9FFG+5GLuAi
         gZtzRbeZWoSqxvePXR+kdGlR5rpudtnH2cAbV38nY01gAmITBNF6jjjZ6NNSPzT+4Maw
         +RkyPd/b2vv5sE9dUeCac9cb2SeuFJU5Dw3wiUdy00Js1nLaSGKBywCNb1hRmSO6mCTP
         0/OgdTh/MI3SrIxXZgAc8/thfUipX209BACDnHD9bBi5Z0E+2AtK0oAcSRfZ7dm2Gf6d
         aVww==
X-Gm-Message-State: ANoB5pmgHy8meG7a//RAmTSmA3wrsgkhlkHn7iYLeN1tBSDHb0rc0Byr
        hFfNowDFqZmQ+WPACQ5eNeM=
X-Google-Smtp-Source: AA0mqf4p6i2fAAhb1xdnLc/NBlN9AkOTc6XV6rVLPFHKAOyjaZJVPHTqkCLTKcmMw/Jigu8uw18DTQ==
X-Received: by 2002:a62:1c49:0:b0:575:b4c0:f664 with SMTP id c70-20020a621c49000000b00575b4c0f664mr34524264pfc.56.1670353168873;
        Tue, 06 Dec 2022 10:59:28 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6220:45e1:53d2:e1cb? ([2620:15c:211:201:6220:45e1:53d2:e1cb])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090311cf00b00176b63535adsm13052736plh.260.2022.12.06.10.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:59:28 -0800 (PST)
Message-ID: <2f88c2df-abc0-2415-8085-162e96de356c@acm.org>
Date:   Tue, 6 Dec 2022 10:59:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
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
References: <20221206031109.10609-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221206031109.10609-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/5/22 19:11, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
