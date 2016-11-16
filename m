From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 02/11] hisi_sas: alloc queue id of slot according to
 device id
Date: Wed, 16 Nov 2016 10:02:47 +0000
Message-ID: <e6beb124-abe6-246f-9c9c-b69f63a4bdfa@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
 <1478522920-108145-3-git-send-email-john.garry@huawei.com>
 <CAMj5BkiMcsDsp+XvG3-zDVK2iWy-L0JvL2kcnAi7JkSeBzjpGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMj5BkiMcsDsp+XvG3-zDVK2iWy-L0JvL2kcnAi7JkSeBzjpGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhangfei Gao <zhangfei.gao@gmail.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 16/11/2016 01:41, Zhangfei Gao wrote:
> On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> Currently slots are allocated from queues in a round-robin fashion.
>> This causes a problem for internal commands in device mode. For this
>> mode, we should ensure that the internal abort command is the last
>> command seen in the host for that device. We can only ensure this when
>> we place the internal abort command after the preceding commands for
>> device that in the same queue, as there is no order in which the host
>> will select a queue to execute the next command.
>
> Is there performance penalty, since only one queue is supported for a device.

Hi Zhangfei,

 From testing I have not seen any noteable performance change. However, 
please note the comment on mq, below.

Cheers,
John

>
>>
>> This queue restriction makes supporting scsi mq more tricky in
>> the future, but should not be a blocker.
>>
>> Note: Even though v1 hw does not support internal abort, the
>>       allocation method is chosen to be the same for consistency.
>>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>
> Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>
