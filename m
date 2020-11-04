Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C880C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 18:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDCDD20759
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 18:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgKDS0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:26:48 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2051 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729488AbgKDS0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 13:26:48 -0500
X-Greylist: delayed 1093 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2020 13:26:48 EST
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CRF3T1YLBz67HGN;
        Thu,  5 Nov 2020 02:07:01 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 4 Nov 2020 19:08:32 +0100
Received: from [10.47.0.132] (10.47.0.132) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 4 Nov 2020
 18:08:31 +0000
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Qian Cai <cai@redhat.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     Sumit Saxena <sumit.saxena@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        Hannes Reinecke <hare@suse.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <1597850436-116171-18-git-send-email-john.garry@huawei.com>
 <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
 <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com>
 <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
 <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com>
 <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
 <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
Date:   Wed, 4 Nov 2020 18:08:28 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.132]
X-ClientProxiedBy: lhreml724-chm.china.huawei.com (10.201.108.75) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/11/2020 16:07, Kashyap Desai wrote:
>>>
>>> v5.10-rc2 is also broken here.
>>
>> John, Kashyap, any update on this? If this is going to take a while to fix
>> it
>> proper, should I send a patch to revert this or at least disable the
>> feature by
>> default for megaraid_sas in the meantime, so it no longer breaks the
>> existing
>> systems out there?
> 
> I am trying to get similar h/w to try out. All my current h/w works fine.
> Give me couple of days' time.
> If this is not obviously common issue and need time, we will go with module
> parameter disable method.
> I will let you know.

Hi Kashyap,

Please also consider just disabling for this card, so any other possible 
issues are unearthed on other cards. I don't have this card or any x86 
machine to test it unfortunately to assist.

BTW, just to be clear, did you try the same .config as Qian Cai?

Thanks,
John
