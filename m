Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E4AC433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 11:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8EA20774
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 11:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGILIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 07:08:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56482 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbgGILIQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jul 2020 07:08:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1D9735F93C593A6A1104;
        Thu,  9 Jul 2020 19:08:14 +0800 (CST)
Received: from [10.174.179.105] (10.174.179.105) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 9 Jul 2020
 19:08:09 +0800
Subject: Re: [PATCH] scsi: fcoe: add missed kfree() in an error path
To:     Markus Elfring <Markus.Elfring@web.de>,
        <linux-scsi@vger.kernel.org>
References: <977e2781-99ed-54c0-27ad-82d768a1c1e6@web.de>
 <5F067CDA.8010404@huawei.com> <ec1e1405-7582-0709-f2a5-a8b91e45fa1a@web.de>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Hannes Reinecke" <hare@suse.de>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neerav Parikh <Neerav.Parikh@intel.com>
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
Message-ID: <5F06FA99.7030705@huawei.com>
Date:   Thu, 9 Jul 2020 19:08:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <ec1e1405-7582-0709-f2a5-a8b91e45fa1a@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.105]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/7/9 15:22, Markus Elfring wrote:
>>>> fcoe_fdmi_info() misses to call kfree() in an error path.
>>>> Add the missed function call to fix it.
>>>
>>> I suggest to use an additional jump target for the completion
>>> of the desired exception handling.
>>>
>>>
>>> …
>>>> +++ b/drivers/scsi/fcoe/fcoe.c
>>>> @@ -830,6 +830,7 @@ static void fcoe_fdmi_info(struct fc_lport *lport, struct net_device *netdev)
>>>>            if (rc) {
>>>>                printk(KERN_INFO "fcoe: Failed to retrieve FDMI "
>>>>                        "information from netdev.\n");
>>>> +            kfree(fdmi);
>>>>                return;
>>>>            }
>>>
>>> -            return;
>>> +            goto free_fdmi;
>>>
>>>
>>> How do you think about to apply any further coding style adjustments?
>>
>> The local variable "fdmi" is invisible to the function.
>
> I have got understanding difficulties for this information.
> The function call “kfree(fdmi)” is already used at the end of this if branch.
> Thus I propose to add a label there.
>
> Do you notice any additional improvement possibilities for this software module?

Indeed, Will change in the next version.
Thanks for your review
>
> Regards,
> Markus
> .
>
