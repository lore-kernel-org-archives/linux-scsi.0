Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DBEC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 17:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC077611AD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 17:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhETR0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 13:26:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4705 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhETR0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 13:26:35 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmGl5110Gz16QXk;
        Fri, 21 May 2021 01:22:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 01:25:11 +0800
Received: from [10.47.87.246] (10.47.87.246) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 18:25:09 +0100
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
To:     Bart Van Assche <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
 <988856ad-8e89-97e4-f8fe-54c1ca1b4a93@acm.org>
 <a838c8e2-6513-a266-f145-5bcaed0a4f96@huawei.com>
 <439c6fb8-3799-bfae-7f44-9f8c26a7bf79@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <457d23a9-deb0-4ee1-fe7f-5a63605d9686@huawei.com>
Date:   Thu, 20 May 2021 18:24:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <439c6fb8-3799-bfae-7f44-9f8c26a7bf79@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.246]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/05/2021 17:57, Bart Van Assche wrote:
>> not be limited to 16b?
> Maybe I'm missing something but it is not clear to me why different
> structures in the SCSI headers use different data types for can_queue
> and cmd_per_lun?

For cmd_per_lun, is it related to SCSI task tag limit? SAM-3 says upto 
64b for task tag, but then SAS uses 16b for TMF tag, so not sure.

Someone with more SCSI spec knowledge than we can clarify this.

> 
> $ git grep -nHEw '(cmd_per_lun|can_queue);' include/scsi
> include/scsi/scsi_device.h:318:	unsigned int		can_queue;
> include/scsi/scsi_host.h:372:	int can_queue;
> include/scsi/scsi_host.h:425:	short cmd_per_lun;
> include/scsi/scsi_host.h:612:	int can_queue;
> include/scsi/scsi_host.h:613:	short cmd_per_lun;
> 
>> It seems intentional that can_queue is int and cmd_per_lun is short.
> Intentional? It is not clear to me why? Even high-performance drivers
> like iSER and SRP set can_queue by default to a value that fits well in
> a 16-bit variable (512 and 64 respectively). The highest value that I
> found after a quick search is the following:
> 
>   #define ISCSI_TOTAL_CMDS_MAX		4096

I guess int was used for can_queue as an arbitrarily big number.

And if we try to use 16b for can_queue, reducing size of 
variables/structure members sometimes breaks things, from my experience.

Thanks,
John



