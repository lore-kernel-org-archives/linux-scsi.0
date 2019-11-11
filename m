Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841A2C17441
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 14:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE5B21783
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 14:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKOCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 09:02:30 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbfKKOCa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 09:02:30 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id C723AA11B5AAFA1A164C;
        Mon, 11 Nov 2019 14:02:28 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 11 Nov 2019 14:02:27 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 11 Nov
 2019 14:02:28 +0000
Subject: Re: [PATCH 6/6] scsi: hisi_sas: Expose multiple hw queues for v3 as
 experimental
To:     Ming Lei <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
 <1571926881-75524-7-git-send-email-john.garry@huawei.com>
 <20191027081910.GB16704@ming.t460p>
From:   John Garry <john.garry@huawei.com>
Message-ID: <bd3b09f7-4a51-7cec-49c4-8e2eab3bdfd0@huawei.com>
Date:   Mon, 11 Nov 2019 14:02:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191027081910.GB16704@ming.t460p>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/10/2019 08:19, Ming Lei wrote:
>>   	.this_id		= -1,
>> @@ -3265,8 +3300,14 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   	shost->max_lun = ~0;
>>   	shost->max_channel = 1;
>>   	shost->max_cmd_len = 16;
>> -	shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
>> -	shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
>> +

Hi Ming,

I mentioned in the thread "blk-mq: improvement on handling IO during CPU 
hotplug" that I was using this series to test that patchset.

So just with this patchset (and without yours), I get what looks like 
some IO errors in the LLDD. The error is an underflow error. I can't 
figure out what is the cause.

I'm wondering if the SCSI command is getting corrupted someway.

>> +	if (expose_mq_experimental) {
>> +		shost->can_queue = HISI_SAS_MAX_COMMANDS;
>> +		shost->cmd_per_lun = HISI_SAS_MAX_COMMANDS;
> The above is contradictory with current 'nr_hw_queues''s meaning,
> see commit on Scsi_Host.nr_hw_queues.
> 

Right, so I am generating the hostwide tag in the LLDD. And the Scsi 
host-wide host_busy counter should ensure that we don't pump too much IO 
to the HBA.

What other problem will this cause?

Thanks,
John

> 
>          /*
>           * In scsi-mq mode, the number of hardware queues supported by the LLD.
>           *
>           * Note: it is assumed that each hardware queue has a queue depth of
>           * can_queue. In other words, the total queue depth per host
>           * is nr_hw_queues * can_queue.
>           */
> 
> Also this implementation wastes memory too much.
> 
> 
> thanks,
> Ming

