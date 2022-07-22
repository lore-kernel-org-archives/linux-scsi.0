Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47087C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 21:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiGVVHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 17:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiGVVHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 17:07:15 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7F4AFB6F
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 14:07:14 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id 17so5484069pfy.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 14:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pGzStEbIybdtsQTGpWdG5kec8IeEiARYjd83SFehxkU=;
        b=mGl5qSc535vf9Hdof+vY+kW3bEg3gIq7+sSd+JfJBMmqhWYCVzrkGkz9U9RSccEEqG
         fLqQRZmf/9F3nFZCczBLTvFyTtxskgEbEIjpQ5ZNJuUQLDKJYjoD7xMYe3TM/7803mQI
         m58Xq69GZ1T7ByAHJNA1zCBnpGAC/L6ZkSgde8Ba+kyhlRRzr1UKns9ic22by81YIxBn
         7HSUFykHNbVNf5rws26yM5/XxWUgxNOr/UzBRzcXBwIWqP84MWfWMgYnulNqETG1mjhy
         g4VDR0VXnwHvC50zLW8vvmelkrlp304KWyqKY2oO/vksQaQRz5/FRw8JV4eUea4DFaaa
         hwZg==
X-Gm-Message-State: AJIora9PajV8d/bLN5uKF+641IvB2VFbUVWIUCPH7H1JuaEp9F24YfYu
        nW5konoMCLrDyXJGf5NVGNRcx7wwSF8=
X-Google-Smtp-Source: AGRyM1vfFtBzYbmOPtYh2GvwYvNteJHnXHE3mc7G5rzhXgfxsC//wn68lAVjBvJAB5Du3DryFhDfIQ==
X-Received: by 2002:a05:6a00:1818:b0:52a:dabd:a232 with SMTP id y24-20020a056a00181800b0052adabda232mr1848030pfa.70.1658524033365;
        Fri, 22 Jul 2022 14:07:13 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:805b:3c64:6a1f:424c? ([2620:15c:211:201:805b:3c64:6a1f:424c])
        by smtp.gmail.com with ESMTPSA id n18-20020a170902969200b0016c37fe48casm4136747plp.193.2022.07.22.14.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 14:07:12 -0700 (PDT)
Message-ID: <60468f8f-c327-47d7-c6bf-bb73c9c84e9b@acm.org>
Date:   Fri, 22 Jul 2022 14:07:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] scsi: ufs: correct ufshcd_shutdown flow
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220719130208.29032-1-peter.wang@mediatek.com>
 <afb8d403-f8f5-5161-4680-ce2c3ae7787d@acm.org>
 <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/22 21:30, Peter Wang wrote:
> On 7/21/22 5:40 AM, Bart Van Assche wrote:
>> On 7/19/22 06:02, peter.wang@mediatek.com wrote:
>>> -    pm_runtime_get_sync(hba->dev);
>>> +    /* Wait ufshcd_wl_shutdown clear ufs state, timeout 500 ms */
>>> +    while (!ufshcd_is_ufs_dev_poweroff(hba) || 
>>> !ufshcd_is_link_off(hba)) {
>>> +        if (ktime_after(ktime_get(), timeout))
>>> +            goto out;
>>> +        msleep(1);
>>> +    }
>>
>> Please explain why this wait loop has been introduced.
> 
> Both ufshcd_shutdown and ufshcd_wl_shutdown could run concurrently.

Are you sure of this? In drivers/base/core.c I see a sequential loop in 
the device_shutdown() function. So how could two shutdown functions run 
concurrently?

Thanks,

Bart.
