From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Tue, 11 Jul 2017 18:34:02 +0100
Message-ID: <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com>
References: <20170616082755.22832-1-hch@lst.de>
 <1499701840.3555.7.camel@wdc.com>
 <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
 <1499779970.3345.1.camel@wdc.com>
 <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
 <1499788012.2586.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9741 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932358AbdGKReY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 13:34:24 -0400
In-Reply-To: <1499788012.2586.12.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linuxarm@huawei.com" <linuxarm@huawei.com>

On 11/07/2017 16:46, Bart Van Assche wrote:
> On Tue, 2017-07-11 at 15:14 +0100, John Garry wrote:
>> On 11/07/2017 14:32, Bart Van Assche wrote:
>>> On Tue, 2017-07-11 at 11:22 +0100, John Garry wrote:
>>>> On 10/07/2017 16:50, Bart Van Assche wrote:
>>>>> Since a fix for the performance regression triggered by this patch will be upstream
>>>>> soon (see also https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-linus&id=32825c45ff8f4cce937ab85b030dc693ceb1aa0a):
>>>>>
>>>>
>>>> FYI, on linux-next 20170711 (which now includes the above patch Bart
>>>> mentioned) we see a large performance regression on hisi_sas (LLDD does
>>>> not config shost for mq).
>>>>
>>>> fio read mode iops goes from ~833K (scsi_mod.use_blk_mq=n on cmdline) to
>>>> ~320K
>>>
>>> Hello John,
>>>
>>> Thanks for the feedback. Is the kernel config with which these measurements
>>> were performed available somewhere?
>>
>> It is the default arm64 defconfig with the following changes:
>> CONFIG_ARM_SMMU_V3=n
>> CONFIG_9P_FS=n
>>
>> We were getting a compile error in the 9p fs code, so disabled it.
>> Turning on the IOMMU drops performance across the board for our
>> platform, so just disabling it for the test.
>
> Hello John,
>
> What block driver controls the block device for which the performance regression
> has been observed? How many hardware queues were created by that block driver
> (see also /sys/block/*/mq/...)?

Hi Bart,

Here's the shost init for our SCSI LLDD:
http://elixir.free-electrons.com/linux/latest/source/drivers/scsi/hisi_sas/hisi_sas_main.c#L1736

So we don't set hr_hw_queues (which would mean = 0), so this should set 
shost->tag_set.nr_hw_queues to 1 in scsi_mq_setup_tags().

FWIW, I can confirm sysfs entry when I get hw access tomorrow.

John

I'm asking this because the number of hardware
> queues controls which I/O scheduler is selected as default. From block/elevator.c:
>



> 		if (q->mq_ops) {
> 			if (q->nr_hw_queues == 1)
> 				e = elevator_get("mq-deadline", false);
> 			if (!e)
> 				return 0;
> 		} else
> 			e = elevator_get(CONFIG_DEFAULT_IOSCHED, false);
>
> Bart.
>
