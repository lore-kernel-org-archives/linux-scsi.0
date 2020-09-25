Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE18C4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 09:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1942083B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 09:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgIYJRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 05:17:04 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2917 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbgIYJRD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 05:17:03 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id B10E7B7FA071A95DE9EE;
        Fri, 25 Sep 2020 10:17:01 +0100 (IST)
Received: from [127.0.0.1] (10.47.7.140) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 25 Sep
 2020 10:17:00 +0100
Subject: Re: [PATCH 1/4] pm80xx : Increase number of supported queues.
To:     Viswas G <Viswas.G@microchip.com.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
 <20200925061605.31628-2-Viswas.G@microchip.com.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <28f395b6-42ca-0c2f-db09-6bef15178b55@huawei.com>
Date:   Fri, 25 Sep 2020 10:14:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200925061605.31628-2-Viswas.G@microchip.com.com>
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
> The number of supported Inbound and outbound queues is increased to 64,
> and the number of queues used are decided based on number of CPU cores
> online and number of msix allocated. Added locks per queue instead of
> global lock.
> 
> Signed-off-by: Viswas G<Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi<Ruksar.devadi@microchip.com>


In this series 
https://lore.kernel.org/linux-scsi/655385f6-ac59-da3b-11f9-1f8382e5c35b@huawei.com/T/#m174b66e43cb437b3fd0845742be6b011a69abb11, 
we allow the LLDD to expose hw queues to the upper layer for when the 
host requires a unique hostwide tag (which pm80xx seems to). This has 
certain advantages.

Have you considered making a similar change here?

Thanks,
John
