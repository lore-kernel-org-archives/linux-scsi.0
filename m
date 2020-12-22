Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CA3C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 12:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 333D62312E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 12:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgLVM43 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 07:56:29 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2280 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgLVM43 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 07:56:29 -0500
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4D0bnb1Xt4z67QJC;
        Tue, 22 Dec 2020 20:51:47 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 22 Dec 2020 13:55:47 +0100
Received: from [10.47.1.120] (10.47.1.120) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 22 Dec
 2020 12:55:44 +0000
Subject: Re: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
To:     Jason Yan <yanaijie@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Hannes Reinecke <hare@suse.com>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
 <9674052e-3deb-2a45-6082-4a40a472a219@huawei.com>
 <7456f628-5e97-42ce-8738-9e661ad2f12a@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2672812e-91bd-4c60-696d-4000b1914ac6@huawei.com>
Date:   Tue, 22 Dec 2020 12:54:58 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7456f628-5e97-42ce-8738-9e661ad2f12a@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.1.120]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/12/2020 12:30, Jason Yan wrote:
>>      return event;
>>
>>
>> So default for phy->ha->event_thres is 32, and I can't imagine that 
> 
> The default value is 1024.

Ah, 32 is the minimum allowed set via sysfs.

> 
>> anyone has ever reconfigured this via sysfs or even required a value 
>> that large. Maybe Jason (cc'ed) knows better. It's an arbitrary value 
>> to say that the PHY is malfunctioning. I do note that there is the 
>> circular path sas_alloc_event() -> sas_notify_phy_event() -> 
>> sas_alloc_event() there also.
>>
>> Anyway, if the 32x event memories were per-allocated, maybe there is a 
>> clean method to manage this memory, which even works in atomic 
>> context, so we could avoid this rework (ignoring the context bugs you 
>> reported for a moment). I do also note that the sas_event_cache size 
>> is not huge.
>>
> 
> Pre-allocated memory is an option.(Which we have tried at the very 
> beginnig by Wang Yijing.)

Right, I remember this, but I think the concern was having a proper 
method to manage this pre-allocated memory then. And same problem now.

> 
> Or directly use GFP_ATOMIC is maybe better than passing flags from lldds.
> 

I think that if we don't really need this, then should not use it.

Thanks,
John
