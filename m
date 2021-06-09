Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88CEC48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 14:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 936CA613BE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 14:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbhFIOWh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 10:22:37 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5361 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbhFIOWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 10:22:34 -0400
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0TgY51psz6tw1;
        Wed,  9 Jun 2021 22:16:41 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 dggeml756-chm.china.huawei.com (10.1.199.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 9 Jun 2021 22:20:33 +0800
Subject: Re: [PATCH v2] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     John Garry <john.garry@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        <wubo40@huawei.com>
References: <20210609093631.2557822-1-yuyufen@huawei.com>
 <9c67a92d-b9df-0e0c-5dda-e9dbeffec48f@huawei.com>
 <747c1ca6-4585-d6f1-4653-b3e2f907e362@huawei.com>
 <8f100f32-28fd-455d-0b25-163c48065f06@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <bc942009-7bec-8343-6206-e8dfb3100698@huawei.com>
Date:   Wed, 9 Jun 2021 22:20:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <8f100f32-28fd-455d-0b25-163c48065f06@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml756-chm.china.huawei.com (10.1.199.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2021/6/9 21:13, John Garry 写道:
> 
>>> I just noticed that libsas.h already has a prototype for 
>>> sas_slave_alloc() - any idea why?
>>
>> sas_slave_alloc() was implemented in the history and it was removed in 
>> this commit: 9508a66f898d. And it seems the prototype was left over 
>> since then.
>> .
> 
> ok, understood.
> 
> So how about backporting this also? I have no idea when the regression 
> was introduced and prob cannot test as it predates hisi_sas support.
> 

This function before did nothing but initialized the ata port. The
commit removed the function just moved the initialization somewhere
else.

-int sas_slave_alloc(struct scsi_device *scsi_dev)
-{
-       struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-
-       if (dev_is_sata(dev))
-               return ata_sas_port_init(dev->sata_dev.ap);
-
-       return 0;
-}


It looks like it's not related to this issue. And I guess it is
not a regression. This issue only exists when user do a manual scan and
at the same time the device is offlined. Few people will do that actually.

> BTW, we also have a dangling prototype for sas_init_ex_attr(), if 
> someone wants to delete that...
> 
> Thanks,
> John
> .
