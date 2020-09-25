Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41559C4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 09:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F34BC2085B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 09:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgIYJ7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 05:59:34 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2918 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727520AbgIYJ7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 05:59:34 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8ADAA672542A80207087;
        Fri, 25 Sep 2020 10:59:32 +0100 (IST)
Received: from [127.0.0.1] (10.47.7.140) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 25 Sep
 2020 10:59:31 +0100
Subject: Re: [PATCH 3/4] pm80xx : Increase the number of outstanding IO
 supported
To:     Viswas G <Viswas.G@microchip.com.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
 <20200925061605.31628-4-Viswas.G@microchip.com.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c0603b76-28a6-4fe7-89c5-129ea0d6b344@huawei.com>
Date:   Fri, 25 Sep 2020 10:56:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200925061605.31628-4-Viswas.G@microchip.com.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.140]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/09/2020 07:16, Viswas G wrote:
> From: Viswas G<Viswas.G@microchip.com>
> 
> Increasing the number of Outstanding IOs from 256 to 1024.
> CCB and tag are allocated according to outstanding IOs.
> Also updating the can_queue value (max_out_io - PM8001_RESERVE_SLOT)
> to scsi midlayer.
> 
> Signed-off-by: Viswas G<Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi<Ruksar.devadi@microchip.com>

Any reason you can't also use the request->tag (instead of generating 
tags internally) for added performance boost? Many other LLDDs do this, 
as managing tags has a performance overhead.

Thanks,
John
