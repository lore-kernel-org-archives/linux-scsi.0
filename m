Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF03C64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 22:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjB0Wn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjB0Wns (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 17:43:48 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B9923DB4;
        Mon, 27 Feb 2023 14:43:15 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so11734159pjb.1;
        Mon, 27 Feb 2023 14:43:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCxd0o6I6PVpHD5qrk9QAafoCFUoiKj6VQ7yh68C05c=;
        b=pj9I6gwKSepklgj6KYDtEs0pMjYUoG3gNIjz0Wh2YIj35XCpgV84o44l0kaQkmlbnF
         Avj7UHRTJW4O05Pvzpzz+/a4EbSUmH+km8pXDfoK8YE9XtlAWyOWLoNL/rFtZiDV/xXr
         X5aQ860sSdMaozXYv+J7MfOoP63L+EqVJE+02ztABtVMPD3NsYggSH9B4wmB33/YeQrr
         mefHsfn/doNRKVuZ//jp28C9wxCz8mNye8CTQn8UL3J89z+mqHTqWBQNGZblm2pVlXNg
         kPd8XYf0r9mrhx98JcgvDXxlE6wq7pJQ1M0xx5sqos9tx6xlaYfi/wRN/ayNcMGK9nHF
         JGoQ==
X-Gm-Message-State: AO0yUKW7NtEGWhVmdM10i0f5aOBZBMcNu6aLHXkZqRlecaIkbDq5710H
        66+rIHURs4pJ3B49FYxLEufg2TZKBNU=
X-Google-Smtp-Source: AK7set98soD4yjnc2MvbeieY+/GJvE6ANtpYsxx5d+GZ34/Z/sdYAUIKvRTqAfLminupo0FWOhZgoQ==
X-Received: by 2002:a17:90b:1d88:b0:237:c52f:a54d with SMTP id pf8-20020a17090b1d8800b00237c52fa54dmr9522892pjb.21.1677537719315;
        Mon, 27 Feb 2023 14:41:59 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6cf3:f584:1162:e48a? ([2620:15c:211:201:6cf3:f584:1162:e48a])
        by smtp.gmail.com with ESMTPSA id k15-20020a637b4f000000b004fb26a80875sm4487449pgn.22.2023.02.27.14.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 14:41:58 -0800 (PST)
Message-ID: <f7e6028c-7ed9-a410-19c7-268ac701d03d@acm.org>
Date:   Mon, 27 Feb 2023 14:41:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 3/7] scsi: ufs: core: Fix mcq nr_hw_queues
Content-Language: en-US
To:     Po-Wen Kao <powen.kao@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
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
        jiajie.hao@mediatek.com
References: <20230222030427.957-1-powen.kao@mediatek.com>
 <20230222030427.957-4-powen.kao@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230222030427.957-4-powen.kao@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/21/23 19:04, Po-Wen Kao wrote:
> Need to add one to MAXQ to obtain number of hardware queue.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


