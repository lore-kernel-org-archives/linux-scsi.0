Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82D9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 11:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8772E23358
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 11:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbhAOLes (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 06:34:48 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2356 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbhAOLer (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 06:34:47 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DHJpn61gPz67c1b;
        Fri, 15 Jan 2021 19:28:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 15 Jan 2021 12:34:04 +0100
Received: from [10.47.4.21] (10.47.4.21) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Fri, 15 Jan
 2021 11:34:02 +0000
Subject: Re: [RESEND PATCH v3 0/4] iommu/iova: Solve longterm IOVA issue
To:     <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>
CC:     <xiyou.wangcong@gmail.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <chenxiang66@hisilicon.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <1605608734-84416-1-git-send-email-john.garry@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8830b44d-3893-6096-0cf1-37a1e8bc6c6b@huawei.com>
Date:   Fri, 15 Jan 2021 11:32:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1605608734-84416-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.4.21]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ linux-scsi (see 
https://lore.kernel.org/linux-iommu/1607538189-237944-4-git-send-email-john.garry@huawei.com/)

On 17/11/2020 10:25, John Garry wrote:
> This series contains a patch to solve the longterm IOVA issue which
> leizhen originally tried to address at [0].
> 
> A sieved kernel log is at the following, showing periodic dumps of IOVA
> sizes, per CPU and per depot bin, per IOVA size granule:
> https://raw.githubusercontent.com/hisilicon/kernel-dev/topic-iommu-5.10-iova-debug-v3/aging_test
> 
> Notice, for example, the following logs:
> [13175.355584] print_iova1 cpu_total=40135 depot_total=3866 total=44001
> [83483.457858] print_iova1 cpu_total=62532 depot_total=24476 total=87008
> 
> Where total IOVA rcache size has grown from 44K->87K over a long time.
> 

JFYI, I am able to reproduce this aging issue on another storage card, 
an LSI SAS 3008, so now it's harder to say it's an issue specific to a 
(buggy) single driver.

A log of the IOVA size dumps is here:
https://raw.githubusercontent.com/hisilicon/kernel-dev/064c4dc8869b3f2ad07edffceafde0b129f276b0/lsi3008_dmesg

Notice again how the total IOVA size goes up over time, like:
[ 68.176914] print_iova1 cpu_total=23663 depot_total=256 total=23919
[ 2337.008194] print_iova1 cpu_total=67361 depot_total=9088 total=76449
[17141.860078] print_iova1 cpu_total=73397 depot_total=10368 total=83765
[27087.850830] print_iova1 cpu_total=73386 depot_total=10624 total=84010
[10434.042877] print_iova1 cpu_total=90652 depot_total=12928 total=103580

I had to change some settings for that storage card to reproduce, though 
[0]. Could explain why no other reports.

So please consider this issue again...

Thanks,
john

[0] 
https://lore.kernel.org/linux-scsi/dd8e6fdc-397d-b6ad-3371-0b65d1932ad1@huawei.com/T/#m953d21446a5756981412c92d0924ca65c8d2f3a5

> Along with this patch, I included the following:
> - A smaller helper to clear all IOVAs for a domain
> - Change polarity of the IOVA magazine helpers
> - Small optimisation from Cong Wang included, which was never applied [1].
>    There was some debate of the other patches in that series, but this one
>    is quite straightforward.
> 
> Differnces to v2:
> - Update commit message for patch 3/4
