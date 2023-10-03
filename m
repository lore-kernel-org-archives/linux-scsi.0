Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FCCE7AD77
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 17:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbjJCR20 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjJCR20 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 13:28:26 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909DD9B
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 10:28:23 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-68fb85afef4so995216b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 10:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696354103; x=1696958903;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6EtorarqtxI211Ng2Jchw7++TNi7Tlo0GlfOYxmY1cA=;
        b=LGr8rSKz3nlHxiLwH7tOACI2X4cJ7sE8Z/Y5IfyWF2jThfIRpHLKwVNRR7mCXuEJOY
         0cSiklkgD0w4QJKZk0hW2I+zH35mFe7dZRLV9spXevDXTiNma194eJVu8QmNUnbTRcIM
         RZ24qBdXaRX6tKkTd4FBlnO4O6YnkhSYUKUHWp82zh2n8v6Fll56F2pVE+uNrTLqhPTb
         2SWmZh2dBoA8kLAfgri536bwP2Zq6aE0HqXaqZ6Jr/1mWYQGi4wZPe9zzIFmMO66z8R3
         flDinTVk7gH/hKRC9vkAne+xP2XGp7b1KrJa3/eawEf81WB9F67sQdOXAGSPy5OrfYl1
         WZ3A==
X-Gm-Message-State: AOJu0YwAlxzNGBOKDxvzMCvXvz17VL/qs+Z7YLPZ/BBdeoaCYPZVWK+u
        iQeNuveqfAmXJ0K+scl9GKQ=
X-Google-Smtp-Source: AGHT+IEeOcVw2i+JnEKc+ZIkWIXbxdCY0PNLUyUbxOLkEBsKFA4qDJU7cIQ30POxY1ISbphOhxNJKQ==
X-Received: by 2002:a05:6a21:9986:b0:160:cf09:8019 with SMTP id ve6-20020a056a21998600b00160cf098019mr150416pzb.32.1696354102895;
        Tue, 03 Oct 2023 10:28:22 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:fc96:5ba7:a6f5:b187? ([2620:15c:211:201:fc96:5ba7:a6f5:b187])
        by smtp.gmail.com with ESMTPSA id p22-20020a637416000000b0056c2de1f32esm1641630pgc.78.2023.10.03.10.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 10:28:21 -0700 (PDT)
Message-ID: <11c80afe-ad85-4676-bce1-e7bf1feeb458@acm.org>
Date:   Tue, 3 Oct 2023 10:28:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: correct clear tm error log
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
References: <20231003022002.25578-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231003022002.25578-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/23 19:20, peter.wang@mediatek.com wrote:
> The clear tm function error log is inverted.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
