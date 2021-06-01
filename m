Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12D3C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 16:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0123610E7
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 16:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhFAQYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 12:24:32 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44957 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbhFAQYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 12:24:31 -0400
Received: by mail-pf1-f176.google.com with SMTP id u18so1601776pfk.11;
        Tue, 01 Jun 2021 09:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a+Tv9Ay4ki6fzCru5B5uDZBCMDiZwHl1GhoT7S+ieyE=;
        b=EhUWLwDXRiHrE71kYsUYkZZaLjy2HiyDKQ/qmLWHG1cPNaJ8Aopd034T3eHTaByToY
         fqy+OsZLyosKieJ6E1VadWCD+y5w94Nk2r5ZoYevZ6j/wGUomqOp7dkaMZkuKQTOyvPQ
         ynuRAp0TXoXuDC16+wRpJ9pUlPVyXXSzR1AKRWvv969dEY4dfZ2LBP9k6ghyT02jamrY
         Mw3Awa9ucvXQdKOmqZbz5gMBwheoCUc5+hdzYoKe50Q3Z7lr7Q4NNqd6doZp+4gtzjRq
         daBKCCH2h3qLk6YvE5dUrD4BLoHhv7Hbd6MP7awpSbPJ6pKC8BJ0MFFQ7kcYyBaSUbZs
         BVuQ==
X-Gm-Message-State: AOAM532bkfJ1a6hLOOjkZI1LWn2WXPWo3mUhSQDJp/rvZYp10F8uP2Bz
        kbgX0NA4sS5MAGyhm1aHULA=
X-Google-Smtp-Source: ABdhPJylD5SLoWgCzDx1Q/SKarLPo0/7oxEowLo+WZPWfEBUfr2J0eF0NK9LCngk4DzfNitquRZayw==
X-Received: by 2002:a63:1224:: with SMTP id h36mr28862318pgl.296.1622564570126;
        Tue, 01 Jun 2021 09:22:50 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i14sm8589037pgc.57.2021.06.01.09.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 09:22:49 -0700 (PDT)
Subject: Re: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
To:     Can Guo <cang@codeaurora.org>, Avri Altman <Avri.Altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-8-avri.altman@wdc.com>
 <be5c0c390d7c0cf13e67f51cdc7dd8c2@codeaurora.org>
 <DM6PR04MB65755EE82C8D19B27E8B576BFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <5dc7f93e6a1b1328fe8b5bb28a9ea34f@codeaurora.org>
 <DM6PR04MB657542A19075691EC60BCEB7FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7953c9c3-d30c-496f-9fb3-15aa1a7e3e4a@acm.org>
Date:   Tue, 1 Jun 2021 09:22:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB657542A19075691EC60BCEB7FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 12:55 AM, Avri Altman wrote:
>> On 2021-03-16 17:21, Avri Altman wrote:
[ ... ]
>>>> And, which lock is protecting rgn->list_expired_rgn? If two
>>>> read_to_handler works
>>>> are running in parallel, one can be inserting it to its expired_list
>>>> while another
>>>> can be deleting it.
>>> The timeout handler, being a delayed work, is meant to run every
>>> polling period.
>>> Originally, I had it protected from 2 handlers running concurrently,
>>> But I removed it following Daejun's comment, which I accepted,
>>> Since it is always scheduled using the same polling period.
>>
>> But one can set the delay to 0 through sysfs, right?
>
> Will restore the protection.  Thanks.

(replying to an email from 2.5 months ago)

Hi Can,

How can two read_to_handler works run in parallel? How can it make a
difference whether or not the delay can be set to zero? Are you aware
that since kernel v3.7 (released in 2012) all workqueues are
non-reentrant? See also commit dbf2576e37da ("workqueue: make all
workqueues non-reentrant"). From the description of that commit:

    This patch makes all workqueues non-reentrant.  If a work item is
    executing on a different CPU when queueing is requested, it is
    always queued to that CPU.  This guarantees that any given work item
    can be executing on one CPU at maximum and if a work item is queued
    and executing, both are on the same CPU.

Thanks,

Bart.
