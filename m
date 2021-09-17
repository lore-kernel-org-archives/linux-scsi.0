Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050B3C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28966103B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhIQRuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 13:50:03 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:46811 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbhIQRuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 13:50:03 -0400
Received: by mail-pl1-f177.google.com with SMTP id bg1so6625230plb.13
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 10:48:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZxM/wu3qd0MxbrCAH6CDrxrs6Elgj/HrBaTbXQV5m0g=;
        b=QuCZkZUlOII9T2V9C7qVW126pJuTI1zlong5ooIZlu71yA5eoYK8QKO3rqSOF4l5Eo
         pUc6yy9RGlVEdrneaxLSkLgar/ap7nDnDXmRnCA+cSyeTJBe/Cm0FtU9YdGP/T+MfrXC
         LFlw/O+ETZLz8BWxoKsDF/TKlB6U/FzC9IPC5+hMe0KXJLNE3jEPay28D6neYKUUdQrO
         qTotouDziBTb0CtFFmVtwnFJOVAnx2o1P4LLSuW6PRTcl/yeE5q5Gpky3JhK939NtJEb
         pfi65BKn3pzCo5Ou1rTHmTzkAIOMoqTS9UEBhwQpDuX+lmjtehF3avFzVpWKFS6BJken
         dpLQ==
X-Gm-Message-State: AOAM533f5W6tnrINynVfQ52aiOYQ00JYRCURsqW1DgZboidM6/E+vuqq
        Y7fcLVj2gNMFAUopjz6uT2TdT4hv4hM=
X-Google-Smtp-Source: ABdhPJxEZFIKnKbqv5k3Vg4hBwzpXGwsGW+B31JK9/okryKMri4G7rt8xMmPvwENW0XJvtt5tm1+7A==
X-Received: by 2002:a17:90b:1b45:: with SMTP id nv5mr22311744pjb.222.1631900920076;
        Fri, 17 Sep 2021 10:48:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id c15sm5795464pfn.105.2021.09.17.10.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 10:48:39 -0700 (PDT)
Subject: Re: [PATCH] Revert "scsi: ufs: Synchronize SCSI and UFS error
 handling"
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org
References: <20210917144349.14058-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4b71f7e1-668f-a8ac-0fc2-d619888ec2dc@acm.org>
Date:   Fri, 17 Sep 2021 10:48:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917144349.14058-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 7:43 AM, Adrian Hunter wrote:
> This reverts commit a113eaaf86373362b053279049907ff82b5df6c8.

I was hoping for a fix instead of a revert. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
