Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E3FC07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5667611CB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhGMBaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 21:30:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10472 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhGMBaE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 21:30:04 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GP2wF2pmjzccpf;
        Tue, 13 Jul 2021 09:23:57 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 09:27:13 +0800
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 09:27:12 +0800
Subject: Re: [bug report]scsi: drive letter drift problem
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Jason Wang" <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        "Wu Bo" <wubo40@huawei.com>, <linfeilong@huawei.com>,
        <yuzhanzhan@huawei.com>
References: <7ae2293e-71a9-f68e-0bfb-b4a70ecf493e@huawei.com>
 <YOwMiYRmGYskOn7A@stefanha-x1.localdomain>
From:   Wenchao Hao <haowenchao@huawei.com>
Message-ID: <8d752421-310f-46d6-fbae-bd72a05d4021@huawei.com>
Date:   Tue, 13 Jul 2021 09:27:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YOwMiYRmGYskOn7A@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/7/12 17:34, Stefan Hajnoczi wrote:
> On Mon, Jul 12, 2021 at 12:47:05PM +0800, Wenchao Hao wrote:
>> We deploy two SCSI disk in one SCSI host(virtio-scsi bus) for one machine,
>> whose ids are [0:0:0:0] and [0:0:1:0].
>>
>> Mostly, the device letter are assigned as following after reboot:
>> [0:0:0:0] --> sda
>> [0:0:1:0] --> sdb
>>
>> While in rare cases, the device letter shown as following:
>> [0:0:0:0] --> sdb
>> [0:0:1:0] --> sda
>>
>> Could we guarantee "sda" is assigned to [0:0:0:0] and "sdb" is assigned to
>> [0:0:1:0] or not?
>> If we can, then how?
> Is there a stable ID that you can use in /dev/disk/by-*?
>
> Stefan

Thanks, we found /dev/disk/by-path may be helpful

