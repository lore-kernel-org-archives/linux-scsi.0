Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CD1C636D7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 18:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjBUS7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 13:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBUS7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 13:59:25 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539562D15D;
        Tue, 21 Feb 2023 10:59:24 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id q11so6459018plx.5;
        Tue, 21 Feb 2023 10:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cL3ZFx6aC3gkxJxvOMXx9WjSRbCkQiOWXyY6yTANeM=;
        b=Gl7NgB436AAQcu2/oWYGc6x2Qpw+LXhPKv4jBjE7qDUMfyy0QVm2MP4pOkrnRx0k56
         pNbpp2Axh6HPo+n6WGeK8oygrBDr729POepsgNUu9JEN+Yhr5GNY96eRgm3Kd/Z3GNd1
         66UXnSIeCchoNlQVYTuEf9cDW7NGvxAd7jTFg5mIGbfKPfySRTvKOgk9MLLv9VrBRTM2
         ODuv4qdrEBGlQOe3S4lzj/Byf7/Az3Vl+bpeZmtSs4ebDtkaR/IhbKAjDBWxhhlsSY1E
         ZmOC9x1xzLf5kiTarCtYh5iswX8eXfEqmC+ZHAPqWhAX7VEOAik6TA9FDxb42sEfgYc5
         GEmg==
X-Gm-Message-State: AO0yUKXbQqcpQtGAp6t0nZuGhsueJXSvPeAh+ep0K4ipXy7eaaufGych
        v1rRLgqG0Y87OIJJ+YNP/CU=
X-Google-Smtp-Source: AK7set9lPF6cFg2TrDVnvULDaoSMrKvHt5cnFIbWmkWdEjEjRHpTKCF9iv2Q8wwA/KX5Nq0Lme09Rw==
X-Received: by 2002:a17:902:ec8e:b0:196:89bc:7100 with SMTP id x14-20020a170902ec8e00b0019689bc7100mr10171339plg.16.1677005963782;
        Tue, 21 Feb 2023 10:59:23 -0800 (PST)
Received: from ?IPV6:2620:0:1000:2514:6f67:63f5:599a:2f4c? ([2620:0:1000:2514:6f67:63f5:599a:2f4c])
        by smtp.gmail.com with ESMTPSA id bf3-20020a170902b90300b0019aa4c00ff4sm10231070plb.206.2023.02.21.10.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 10:59:23 -0800 (PST)
Message-ID: <8268452f-cc33-81cb-32be-a9e37f97894f@acm.org>
Date:   Tue, 21 Feb 2023 10:59:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/4] scsi: ufs: core: Fix mcq tag calcualtion
Content-Language: en-US
To:     Po-Wen Kao <powen.kao@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     wsd_upstream@mediatek.com, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, chun-hung.wu@mediatek.com,
        cc.chou@mediatek.com, eddie.huang@mediatek.com,
        mason.zhang@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230221152919.25837-1-powen.kao@mediatek.com>
 <20230221152919.25837-2-powen.kao@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230221152919.25837-2-powen.kao@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/21/23 07:29, Po-Wen Kao wrote:
> Transfer command descriptor is allocated in ufshcd_memory_alloc()
> and referenced by transfer request descriptor with stride size
> sizeof_utp_transfer_cmd_desc()
> instead of
> sizeof(struct utp_transfer_cmd_desc).
> 
> Consequently, computing tag by address offset should also refer to the
> same stride.
> 
> As suggested, sizeof_utp_transfer_cmd_desc() is further renamed to
> ufshcd_get_ucd_size().

This patch includes two changes:
(1) a bug fix.
(2) a name change for a function.

A Linux kernel patch should include only one logical change. Please 
split this patch.

Thanks,

Bart.
