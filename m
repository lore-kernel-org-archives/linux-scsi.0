Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D020C35DF2
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 03:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 199CD24656
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 03:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBYDxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 22:53:42 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbgBYDxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Feb 2020 22:53:42 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 958CE18D3B7C676C789B;
        Tue, 25 Feb 2020 11:53:39 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.231) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 11:53:32 +0800
Message-ID: <5E549A3B.7030803@huawei.com>
Date:   Tue, 25 Feb 2020 11:53:31 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <jejb@linux.ibm.com>, Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <zhengchuan@huawei.com>,
        <jiangyiwen@huawei.com>, <robin.yb@huawei.com>
Subject: Re: [PATCH V2] scsi: add a new flag to set whether SCSI disks support
 WRITE_SAME_16 by default
References: <5E28118F.3070706@huawei.com> <5E3520A7.5030501@huawei.com> <yq14kw522c5.fsf@oracle.com> <5E3D2513.6050505@huawei.com>
In-Reply-To: <5E3D2513.6050505@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.231]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Are there any other opinions about this patch? If so, I can make
corresponding modifications.

Thanks
Alex
On 2020/2/7 16:51, AlexChen wrote:
> Hi Martin,
> 
> Thanks for your reply.
> 
>>> When the SCSI device is initialized, check whether it supports
>>> WRITE_SAME_16 or WRITE_SAME_10 in the sd_read_write_same(). If the
>>> back-end storage device does not support queries, it will not set
>>> sdkp->ws16 as 1.
>>
>> Your proposed code change is fine and to the point. However, I'd like to
>> understand why you are adding a workaround to the kernel instead of
>> fixing the affected device?
>>
>> Implementing support for either WRITE SAME(10) or REPORT SUPPORTED
>> OPERATION CODES is easy. And the latter in particular is beneficial for
>> discovering several other SCSI protocol features. It's a good command to
>> support in general.
>>
> 
>>From a maintenance perspective, I think the old storage device which does
> not support WRITE SAME query interface can be easily supported by adding
> a workaround to the kernel, instead of waiting for the storage device to
> implement the query interface.
> 
>> Also, we generally don't add features to the kernel without any
>> users. So if you add a blacklist flag, I would expect to see a set of
>> device strings to be added to scsi_devinfo.c.
> 
> Through my test, I found that HUAWEI's storage devices do not provide
> queries for WRITE_SAME_16 support.
> If the lists of such devices is written into the kernel code, will it
> be incomplete and difficult to maintain? On the other hand, It would be
> more flexible if we provided the module parameter 'dev_flags' to set.
> 
> Thanks
> Alex
> 


