Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574FCC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 14:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2FB61103
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 14:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhIGOns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 10:43:48 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41630 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhIGOnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 10:43:47 -0400
Received: by mail-pf1-f181.google.com with SMTP id x7so7419160pfa.8
        for <linux-scsi@vger.kernel.org>; Tue, 07 Sep 2021 07:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qmh48OzG2AluiPhaXQXjRDDhLlmVWq4qB5wlRWopuE0=;
        b=b35zS2UIdhdddyF3/eR0RNzAQ2HQ9xOmP/YjK+uzs8y02IvRdYS/+2/eHflTOHOwMX
         DnzDDhbV/ZEarVz4ldU2dkoFL3ocJuOAbIkGmNpqvSP02hu//8q7cjSCWOd1K8Mjn/ls
         BbxPPZ8cEpTu1k6fuL2GZ4GowdsV0D5AkqBHUol5KlrS4XMw6gVmuvTY39g5gSyWneqo
         eed5HkoooOPQcZpAfqunLUJK4wzJS2e6Ed7Zl55FTftT/iODHW4CynioArecv0ZWr5x+
         j+OEBmE90vM6NPTlT9+fboIolFyBIkj7Lsov/1Buukpvhk7yEQZcPWfueRAielIL7zo6
         D/wg==
X-Gm-Message-State: AOAM531aAdjmeFz172rXEsSKXiO0gx6nHNUI4Wu72Rd/FSIq2h9pEpl8
        a8zYLovetvb72lwbT6O87KAjfFREUJI=
X-Google-Smtp-Source: ABdhPJw/auuDMpsVVEZMO7PPqEWNSOZ4H2OoweXP7IM0I8f/KTtGgaWGsuLOmCxAwau1vmo5PVG1eQ==
X-Received: by 2002:a63:4f0d:: with SMTP id d13mr17186664pgb.169.1631025760738;
        Tue, 07 Sep 2021 07:42:40 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q21sm13413987pgk.71.2021.09.07.07.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 07:42:39 -0700 (PDT)
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
Date:   Tue, 7 Sep 2021 07:42:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210905095153.6217-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/5/21 2:51 AM, Adrian Hunter wrote:
> There is no guarantee to be able to enter the queue if requests are
> blocked. That is because freezing the queue will block entry to the
> queue, but freezing also waits for outstanding requests which can make
> no progress while the queue is blocked.
> 
> That situation can happen when the error handler issues requests to
> clear unit attention condition. Requests can be blocked if the
> ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, which can happen
> as a result either of error handler activity, or theoretically a
> request that is issued after the error handler unblocks the queue
> but before clearing unit attention condition.
> 
> The deadlock is very unlikely, so the error handler can be expected
> to clear ua at some point anyway, so the simple solution is not to
> wait to enter the queue.

Do you agree that the interaction between ufshcd_scsi_block_requests() and
blk_mq_freeze_queue() can only lead to a deadlock if blk_queue_enter() is
called without using the BLK_MQ_REQ_NOWAIT flag and if unblocking SCSI
request processing can only happen by the same thread?

Do you agree that no ufshcd_clear_ua_wluns() caller blocks SCSI request
processing and hence that it is not necessary to add a "nowait" argument
to ufshcd_clear_ua_wluns()?

Thanks,

Bart.
