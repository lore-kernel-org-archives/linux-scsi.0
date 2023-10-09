Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63001E95A8E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 06:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345244AbjJIG7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 02:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344984AbjJIG7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 02:59:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E566A3;
        Sun,  8 Oct 2023 23:59:11 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S3qYW0kL2zVlQN;
        Mon,  9 Oct 2023 14:55:43 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 9 Oct 2023 14:59:09 +0800
Message-ID: <05c0b3ef-8643-3fac-c78a-2d04a10bb188@huawei.com>
Date:   Mon, 9 Oct 2023 14:59:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 0/4] SCSI: Fix issues between removing device and error
 handle
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <louhongxiang@huawei.com>
References: <20230928073543.3496394-1-haowenchao2@huawei.com>
Content-Language: en-US
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <20230928073543.3496394-1-haowenchao2@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/9/28 15:35, Wenchao Hao wrote:
> I am testing SCSI error handle with my previous scsi_debug error
> injection patches, and found some issues when removing device and
> error handler happened together.
> 
> These issues are triggered because devices in removing would be skipped
> when calling shost_for_each_device().
> 
> Three issues are found:
> 1. statistic info printed at beginning of scsi_error_handler is wrong
> 2. device reset is not triggered
> 3. IO requeued to request_queue would be hang after error handle
> 

These patches fix bug which is easy to recurrent when removing device
and error handle happened together, so friendly ping again...

> V2:
>    - Fix IO hang by run all devices' queue after error handler
>    - Do not modify shost_for_each_device() directly but add a new
>      helper to iterate devices but do not skip devices in removing
> 
> Wenchao Hao (4):
>    scsi: core: Add new helper to iterate all devices of host
>    scsi: scsi_error: Fix wrong statistic when print error info
>    scsi: scsi_error: Fix device reset is not triggered
>    scsi: scsi_core:  Fix IO hang when device removing
> 
>   drivers/scsi/scsi.c        | 43 +++++++++++++++++++++++++-------------
>   drivers/scsi/scsi_error.c  |  4 ++--
>   drivers/scsi/scsi_lib.c    |  2 +-
>   include/scsi/scsi_device.h | 25 +++++++++++++++++++---
>   4 files changed, 53 insertions(+), 21 deletions(-)
> 

