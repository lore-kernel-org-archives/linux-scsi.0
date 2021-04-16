Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BF6C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3526117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhDPIgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 04:36:53 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2871 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbhDPIgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 04:36:50 -0400
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FM8WN5Hcxz689Vb;
        Fri, 16 Apr 2021 16:29:04 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 16 Apr 2021 10:36:23 +0200
Received: from [10.47.83.179] (10.47.83.179) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 16 Apr
 2021 09:36:23 +0100
Subject: Re: [PATCH] scsi_debug: fix cmd_per_lun, set to max_queue
To:     Ming Lei <ming.lei@redhat.com>
CC:     Douglas Gilbert <dgilbert@interlog.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <kashyap.desai@broadcom.com>,
        <axboe@kernel.dk>
References: <20210415015031.607153-1-dgilbert@interlog.com>
 <580349dc-0152-8f39-5f3c-be9115e3bf12@huawei.com> <YHjsXaVJJsQXwEPW@T590>
 <bd33c000-905a-b881-06ea-eef51c77566e@huawei.com> <YHlKRDOmMRPMKl5x@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <71e8b42a-f368-2477-ac83-60a750f157f6@huawei.com>
Date:   Fri, 16 Apr 2021 09:33:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YHlKRDOmMRPMKl5x@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.179]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/04/2021 09:26, Ming Lei wrote:
>>> 'cmd_per_lun' should have been set as correct from the beginning instead
>>> of capping it for changing queue depth:
>>>
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index 697c09ef259b..0d9954eabbb8 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -414,7 +414,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>>>    	shost->can_queue = sht->can_queue;
>>>    	shost->sg_tablesize = sht->sg_tablesize;
>>>    	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
>>> -	shost->cmd_per_lun = sht->cmd_per_lun;
>>> +	shost->cmd_per_lun = min_t(int, sht->cmd_per_lun, shost->can_queue);
>>>    	shost->no_write_same = sht->no_write_same;
>>>    	shost->host_tagset = sht->host_tagset;
>> My concern here is that it is a common pattern in LLDDs to overwrite the
>> initial shost member values between scsi_host_alloc() and scsi_add_host().
> OK, then can we move the fix into beginning of scsi_add_host()?

I suppose that would be ok, but we don't do much sanitizing shost values 
at that point. Apart from failing can_queue == 0. I suppose failing 
can_queue < cmd_per_lun could also be added.

Thanks,
John
