Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EFEC00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 18:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiHBSo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHBSo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 14:44:56 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CC713F97
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 11:44:55 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d20so6928897pfq.5
        for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2022 11:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VPF0vMX22RY8iv0joXSl/t6XXMxjwgYOrNmCNv008jw=;
        b=I5kutBpZlQ78blpSKfM2ebN5bW2/3ya8mUpqANqEjoZuHW8bS4enOOk2n50Qa9NKuP
         ktc6QVY3Cv0J9vDWuH5soSkA8f2c6rOrypxg1k4XsnNN5/tNOGNdZQ7UF7i0gB8EyI2q
         fCZrMWeIQyotxhq0wVNWB1Z2PmyyYMfIf+baQvPqu1CiuooMSa5qYxSQulnnMvwtWPFt
         m0YW3079I1mUSFxvMYGdQhOaYYXnBgyhpXgUPSCoK2vp4KsIzfk93W4fkLR7bSDFVIQg
         26TIBudytFeJrwukjWf4frKVs9+s07vlX3FM3Ljh7WxrBPnLvrSfJCovsBsx/xlOvU/7
         0w/w==
X-Gm-Message-State: AJIora/9hp5axjJ2tGS+MijlOGtM4vAvRTrIHfx5gHRyBiVSFVA5ZS+G
        GHUritC1JYTQfpds+dVO6QY=
X-Google-Smtp-Source: AGRyM1tH5gORP4aBc94gwhTvKp5cvaXIpWrglluF9eeJJY69FzUxUTThyoizYO5+OT0B7hgQ2HI8sA==
X-Received: by 2002:a63:1324:0:b0:419:afb2:af7b with SMTP id i36-20020a631324000000b00419afb2af7bmr17856752pgl.367.1659465894715;
        Tue, 02 Aug 2022 11:44:54 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5297:9162:3271:e5df? ([2620:15c:211:201:5297:9162:3271:e5df])
        by smtp.gmail.com with ESMTPSA id e19-20020a17090ac21300b001f320faea95sm11265245pjt.2.2022.08.02.11.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 11:44:53 -0700 (PDT)
Message-ID: <06b8cb30-f308-63bd-b073-83c9add87cd3@acm.org>
Date:   Tue, 2 Aug 2022 11:44:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 1/2] ufs: core: introduce a choice of wb toggle during
 clock scaling
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220802143223.1276-1-peter.wang@mediatek.com>
 <20220802143223.1276-2-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220802143223.1276-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/22 07:32, peter.wang@mediatek.com wrote:
> +	/* Allow WB with clk scaling */

This comment is misleading. Consider changing this comment into 
something like "Enable WB when scaling up the clock and disable WB when 
scaling the clock down".

> +	UFSHCD_CAP_WB_WITH_CLK_SCALING			= 1 << 12,

Whether or not the WriteBooster is toggled when the clock is scaled is 
not a host controller capability. It is a policy that is tied by this 
patch to the host controller. So I think that using the "UFSHCD_CAP_" 
prefix is misleading. Consider using e.g. the prefix UFSHCD_POLICY_.

 > +static inline bool ufshcd_can_wb_during_scaling(struct ufs_hba *hba)
 > +{
 > +	return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
 > +}

The name of this function is misleading. Consider renaming this function 
into e.g. ufshcd_enable_wb_if_scaling_up().

Thanks,

Bart.
