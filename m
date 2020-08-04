Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDF3C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 16:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37124208A9
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 16:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SXN/9Lte"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgHDQV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 12:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgHDQVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 12:21:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BCAC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 09:21:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q76so3501862wme.4
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 09:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ST9UBbZKghuCFpLuvhcBi8OC0S5lAPRob4gGRkqUBQI=;
        b=SXN/9LteKBtddUwm0e5UMFZX3bzVy6GxJDciQvp2jhpu55QK068xpA0TfA0ee205Gq
         DgEXzVRWBbixlxxR6B5P0TtoYIbj4NJ9A9ZNkb7quhHTJZkqIkp0P909n8sCBYYLkAV2
         8AVP2oyeTNXt8vnnqVD/PXQoMn9T+CH8sjMFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ST9UBbZKghuCFpLuvhcBi8OC0S5lAPRob4gGRkqUBQI=;
        b=C7yF0s/89eTKTYM8t4859IDxbNYjpUXp+uiS/UujbXnKg68osLMCSzwhoQ+7yfEr/W
         u4A+HksqnK7cxTh/6pi7oow79HaXk4BgpNF6NQ/QRRI/U36VmlWEDcn8w9+F2nCgLCBg
         AUlSWIJKyL6G7jz0y4dLZoYjeoCV3A1S2SL2kANYGvTGtOJJh5IoJW5IjMjyOu0/zYUl
         K66tOYNfQFIZ9uu1HTLCA8mNnT3/xLjYrmAEBT5WE/fbX0xDniMr2+MvW0CTGJBNz7N2
         NsZZnXgBIXqki8i4HwF8bAHiZaWc6ZUpSVVq1HyCACBjOp1W+u96naGrOvnsmdjcA+RJ
         YVSg==
X-Gm-Message-State: AOAM533/PM5R665l2yvdtUi8DH10SP/jlqprJ/j7bb8wlB+H+0ChV99H
        lhI0pAHMnmnHPmUsSER2g9c86PKPzrEbkA==
X-Google-Smtp-Source: ABdhPJyzl7yOei+IZoGA9xJVGGHeQUKJPzBjfKEeN12WVpymiUK9Opk6H6+2KeAThLEQGdLe2xVkHA==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr3422486wmc.181.1596558089133;
        Tue, 04 Aug 2020 09:21:29 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z12sm29956754wrp.20.2020.08.04.09.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 09:21:28 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: Add the missed misc_deregister() for
 lpfc_init()
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200731065639.190646-1-jingxiangfeng@huawei.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <ace2c669-5fc6-e6c5-9d39-382ba02b1adf@broadcom.com>
Date:   Tue, 4 Aug 2020 09:21:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731065639.190646-1-jingxiangfeng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 7/30/2020 11:56 PM, Jing Xiangfeng wrote:
> lpfc_init() misses to call misc_deregister() in an error path. Add a
> label 'unregister' to fix it.
>
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
>
Looks fine.

Reviewed-by: James Smart <james.smart@broadcom.com>


Thanks

-- james

