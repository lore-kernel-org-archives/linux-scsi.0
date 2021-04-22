Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B879AC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E32461421
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhDVQjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:39:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2910 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhDVQjF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:39:05 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FR2sR6GNxz6wj95;
        Fri, 23 Apr 2021 00:28:11 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 18:38:29 +0200
Received: from [10.47.95.78] (10.47.95.78) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 22 Apr
 2021 17:38:28 +0100
Subject: Re: [PATCH] scsi: core: Cap initial sdev queue depth at
 shost.can_queue
To:     Ming Lei <ming.lei@redhat.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <dgilbert@interlog.com>
References: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
 <YH4aIECa/J/1uS5S@T590> <bba5f248-523d-0def-1a3e-bafeb2b7633f@huawei.com>
 <YIDTlD2Mq+U36Oqz@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <186be6c5-dbcd-d1fb-67c5-72b5a761568a@huawei.com>
Date:   Thu, 22 Apr 2021 17:35:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YIDTlD2Mq+U36Oqz@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.78]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/04/2021 02:38, Ming Lei wrote:
>> I would rather not change the values which are provided from the driver. I
>> would rather take the original values and try to use them in a sane way.
>>
>> I have not seen other places where driver shost config values are modified
>> by the core code.

Hi Ming,

> Wrt. .cmd_per_lun, I think it is safe to modify it into one correct
> depth because almost all drivers are just producer of .cmd_per_lun. And
> except for debug purpose, there are only three consumers of .cmd_per_lun
> in scsi, and all are for scsi_change_queue_depth():
> 
> 	process_message()
> 	scsi_alloc_sdev()
> 	virtscsi_change_queue_depth()

sg_ioctl_common() also looks to read it, but I can't imagine we could 
break that interface with either suggested change.

So I still prefer not to modify shost.cmd_per_lun, but if you feel 
strongly enough then I can look to make that change.

Thanks,
John

