Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D87C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 22:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C4F61390
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 22:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344384AbhI3WLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:11:53 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:39634 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhI3WLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 18:11:53 -0400
Received: by mail-pg1-f171.google.com with SMTP id g184so7608682pgc.6
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 15:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lPlU6kky2n0HxrX6mr8iuU24AHsH1p7eqRHVEikZDfQ=;
        b=bA0OBUlRyDyND3yrD2N8Nu9gSphzed1IQmkdKg05Px5ZVgut2ukGwqyk+WYyF3RWBf
         CrZZRAQI9l9aNBU5aI82hgCfRDPzxMMbQKhqY68rIoTMRpYrG0RiYTTKhJPJwbNqqRVz
         FAtq+BSNTveNL1tjjikdStxgHfLoVfovHUy2eA+KMGSCLBfKx51bYLmiNI26rUH20MRU
         zG7TOpz3w72V7BMe1y2PuYtSfiXeq/TSZzm6nUNIsEqMrmNIbUz+GU4mw8FJBM+oJtol
         h7AlZnwJ/+ejPpNOHA1GOB10CFuxE6vr8IC16YZRjjOlGt2mwT4Z2G5Jv+9KZDQe13iC
         Gvyg==
X-Gm-Message-State: AOAM530YfQGtNMcE+cKeY/pueGGO5lsJWv4vz+0RtdctlTLSAAAyBpxW
        RIUONkAe/oRwoS+zuEAZF0k=
X-Google-Smtp-Source: ABdhPJzXNT8oaAYW5Kmw33A9/scqFf78v/m86MWbj3rWZfUSviddU3YMnJJvwveX5Q+Pfc9SfPQyIA==
X-Received: by 2002:a63:1d58:: with SMTP id d24mr6958625pgm.316.1633039809716;
        Thu, 30 Sep 2021 15:10:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:82b7:f0a2:c63d:c44e])
        by smtp.gmail.com with ESMTPSA id x9sm4123975pfo.172.2021.09.30.15.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 15:10:09 -0700 (PDT)
Subject: Re: [PATCH V6 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20210930124224.114031-1-adrian.hunter@intel.com>
 <20210930124224.114031-2-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9e8ecb60-dc1b-2fd7-3ae4-bfa720f98769@acm.org>
Date:   Thu, 30 Sep 2021 15:10:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930124224.114031-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 5:42 AM, Adrian Hunter wrote:
> There is no guarantee to be able to enter the queue if requests are
> blocked. That is because freezing the queue will block entry to the
> queue, but freezing also waits for outstanding requests which can make
> no progress while the queue is blocked.
> 
> That situation can happen when the error handler issues requests to
> clear unit attention condition. Requests are blocked if the ufshcd_state is
> UFSHCD_STATE_EH_SCHEDULED_FATAL, which can happen as a result of
> prior error handler activity. Requests cannot make progress when
> ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error
> handler can change that, so if the error handler is waiting to enter
> the queue and blk_mq_freeze_queue() is waiting for outstanding requests,
> they will deadlock.
> 
> Fix by issuing REQUEST_SENSE directly avoiding the SCSI queues, in
> a similar fashion as other device commands.

Hi Adrian,

Although I appreciate all the work that you have done on this patch, there
is at least one application (the Android Trusty software) that needs the
RPMB unit attention information to work correctly. Hence my request to drop
this patch and to integrate the following patch series in the upstream kernel:
https://lore.kernel.org/linux-scsi/aacbec00-34e8-f082-51a5-15391bf99710@acm.org/T/#t

Thanks,

Bart.
