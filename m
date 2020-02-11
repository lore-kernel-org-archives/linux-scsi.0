Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5991DC352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 11:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C8420873
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 11:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgBKLxH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 06:53:07 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2407 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbgBKLxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Feb 2020 06:53:07 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 388B67DD042C72863D18;
        Tue, 11 Feb 2020 11:53:06 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 11 Feb 2020 11:53:05 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 11 Feb
 2020 11:53:05 +0000
Subject: Re: [PATCH] scsi: Delete scsi_use_blk_mq
From:   John Garry <john.garry@huawei.com>
To:     Bart Van Assche <bvanassche@acm.org>, <jejb@linux.vnet.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1581355992-139274-1-git-send-email-john.garry@huawei.com>
 <3795ab1d-5282-458b-6199-91e3def32463@acm.org>
 <2e2ead7d-503e-3881-b837-7c689a4d44c6@huawei.com>
Message-ID: <ca2a7eee-0456-e158-307d-e9b6f32fbefd@huawei.com>
Date:   Tue, 11 Feb 2020 11:53:04 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <2e2ead7d-503e-3881-b837-7c689a4d44c6@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/02/2020 11:50, John Garry wrote:
> On 10/02/2020 22:37, Bart Van Assche wrote:
>> On 2/10/20 9:33 AM, John Garry wrote:
>>> -module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | 
>>> S_IRUGO);
>>
> 
> Hi Bart,
> 
>> Will this change cause trouble to shell scripts that set or read this 
>> parameter (/sys/module/scsi_mod/parameters/use_blk_mq)? 
> 
> The entry in Documentation/admin-guide/kernel-parameters.txt is gone for 
> 2 years now.
> 
> And it is not an archaic module param, it was introduced 6 years ago. As 
> such, I'd say that if a shell script was setup to access this parameter, 
> then it would prob also pre-check if it exists and gracefully accept 
> that it may not.
> 
> I will also note that there is still scsi_sysfs.c:show_use_blk_mq(), 
> which would stay.
> 
> What will the
>> impact be on systems where scsi_mod.use_blk_mq=Y is passed by GRUB to 
>> the kernel at boot time, e.g. because it has been set in the 
>> GRUB_CMDLINE_LINUX variable in /etc/default/grub?
> 
> The kernel should any params that does not recognize.

	          ^ ignore

> 
>>
> 
> Having said all that, I don't feel too strongly about deleting this - 
> it's only some tidy-up.
> 
> Thanks,
> John
> 
> .

