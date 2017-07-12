From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Wed, 12 Jul 2017 09:26:04 +0100
Message-ID: <581a258d-3da8-5b01-f528-0ce11b74b65e@huawei.com>
References: <20170616082755.22832-1-hch@lst.de>
 <1499701840.3555.7.camel@wdc.com>
 <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
 <1499779970.3345.1.camel@wdc.com>
 <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
 <1499788012.2586.12.camel@wdc.com>
 <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8897 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933243AbdGLI1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 04:27:01 -0400
In-Reply-To: <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linuxarm@huawei.com" <linuxarm@huawei.com>

>> What block driver controls the block device for which the performance
>> regression
>> has been observed? How many hardware queues were created by that block
>> driver
>> (see also /sys/block/*/mq/...)?
>

Just confirming that we have only 1 queue:
/sys/block/sdc/mq/0 as example

> Hi Bart,
>
> Here's the shost init for our SCSI LLDD:
> http://elixir.free-electrons.com/linux/latest/source/drivers/scsi/hisi_sas/hisi_sas_main.c#L1736
>
>
> So we don't set hr_hw_queues (which would mean = 0), so this should set
> shost->tag_set.nr_hw_queues to 1 in scsi_mq_setup_tags().
>
> FWIW, I can confirm sysfs entry when I get hw access tomorrow.
>
> John
>
> I'm asking this because the number of hardware
>> queues controls which I/O scheduler is selected as default. From
>> block/elevator.c:
>>
>
>
>
>>         if (q->mq_ops) {
>>             if (q->nr_hw_queues == 1)
>>                 e = elevator_get("mq-deadline", false);
>>             if (!e)
>>                 return 0;
>>         } else
>>             e = elevator_get(CONFIG_DEFAULT_IOSCHED, false);
>>
>> Bart.
>>
>
>
> _______________________________________________
> linuxarm mailing list
> linuxarm@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
>
> .
>
