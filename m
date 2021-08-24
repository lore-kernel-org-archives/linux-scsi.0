Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18365C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5AF660FE8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhHXDlz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:41:55 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:39861 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhHXDly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 23:41:54 -0400
Received: by mail-pl1-f178.google.com with SMTP id m17so4365184plc.6;
        Mon, 23 Aug 2021 20:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1IJpqO4B3Z7N5/PXofpZnmMF7pO3llTR5i+tE5urGjs=;
        b=JxYBKsYHUUpwSEiUWHeZE8sHZC1fawckWA8P007Ib6ZEzUZ7l6l4rS7Ct4hSQnDCKx
         D3lfjMAWUyXT69h2eyz2xu6+uZjfcWd554YjmZlx8pshbgMrcOxk0zNzxl7a7/0yLk+i
         htfDaiLkgtzma0bEMG+GbqgawaSGqW1Vg9Z7eSE2vkykgWSJUdVBcfLhWydCGrMVbYNq
         x1Hz/MsnpgPcHDIA+dZN+aB5riRhK0XES4DUAG7ElQu+ogvNCykIQsDHSDhHEdOpZCtH
         UcFMnxquVB3+YXtBfFYYYTEdrj1ot042/irl1fS52ePW3RcLVT/QfU/u6WzNfRnPCJQW
         IPqA==
X-Gm-Message-State: AOAM530huPzEYKmjylnkTZcYCEyWP4on9g929jG03cvbJx6qePGJ+rPF
        2bn8zo+Yz3M4tpiPbjb7LPs=
X-Google-Smtp-Source: ABdhPJwGRV8rG+bPFLGjxEW8VU0tUTXcsNMJCPGf4tHfVvY9haNFL/YrouJHzLXONI1Cs3sYyIAbJw==
X-Received: by 2002:a17:90a:4417:: with SMTP id s23mr1982741pjg.23.1629776470945;
        Mon, 23 Aug 2021 20:41:10 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:68:8a8:39ff:312? ([2601:647:4000:d7:68:8a8:39ff:312])
        by smtp.gmail.com with ESMTPSA id a20sm637453pjh.46.2021.08.23.20.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 20:41:10 -0700 (PDT)
Subject: Re: [PATCH v3] scsi: core: Fix hang of freezing queue between
 blocking and running device
To:     Li Jinlin <lijinlin3@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     john.garry@huawei.com, qiulaibin@huawei.com, linfeilong@huawei.com,
        wubo40@huawei.com
References: <20210824025921.3277629-1-lijinlin3@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c3215379-6e77-0d94-992c-8049d9bf3f46@acm.org>
Date:   Mon, 23 Aug 2021 20:41:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824025921.3277629-1-lijinlin3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/21 7:59 PM, Li Jinlin wrote:
> We found a hang issue, the test steps are as follows:
>   1. blocking device via scsi_device_set_state()
>   2. dd if=/dev/sda of=/mnt/t.log bs=1M count=10
>   3. echo none > /sys/block/sda/queue/scheduler
>   4. echo "running" >/sys/block/sda/device/state

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
