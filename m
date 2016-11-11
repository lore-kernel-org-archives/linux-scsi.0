From: wangyijing <wangyijing@huawei.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Fri, 11 Nov 2016 16:49:53 +0800
Message-ID: <58258631.1090203@huawei.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
 <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
 <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
 <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
 <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
 <58257D52.6090507@huawei.com>
 <93ae84f6-75a2-f576-808e-f98c6256b6a6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <93ae84f6-75a2-f576-808e-f98c6256b6a6@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Dan Williams <dan.j.williams@intel.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, john.garry2@mail.dcu.ie, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, lindar_liu@usish.com, Tejun Heo <tj@kernel.org>, jinpu.wang@profitbricks.com
List-Id: linux-scsi@vger.kernel.org

>>> I have not seen the flutter issue. I am just trying to solve the horrible WARN dump.
>>> However I do understand that there may be a issue related to how we queue the events; there was a recent attempt to fix this, but it came to nothing:
>>> https://www.spinics.net/lists/linux-scsi/msg99991.html
>>
>> We found libsas hotplug several problems:
>> 1. sysfs warning calltrace(like the case you found);
> 
> Maybe you can then review my patch.

I did it, I think your solution to fix the sysfs calltrace issue is ok, and what I worried about is we still need to fix
the rest issues. So it's better if we could fix all issues one time.

> 
>> 2. hot-add and hot-remove work events may process out of order;
>> 3. in some extreme cases, libsas may miss some events, if the same event is still pending in workqueue.
>>
> 
> Can you tell me how to recreate #2 and #3?

Qilin Chen and Yousong He help me to reproduce it, I told them to reply this mail to tell you the test steps.
Some tests we did is make sas phy link flutter, so hardware would post phy down and phy up events sequentially.

1. scsi host workqueue receive phy down and phy up events.                                             in process                 new added
2. sas_deform_port would post a new destruct event to scsi host workqueue, so things in workqueue like [phy down-----phy up -----destruct]

So the phy down logic is separated by phy up, and it's not atomic, not safe, something unexpected would happen.

For case 3, we make hardware burst post lots pair of phy up and phy down events, so if libsas is processing the phy up event, the next
phy up event can not queue to scsi host workqueue again, it will lost, it's not we expect.

> 
>> It's a complex issue, we posted two patches, try to fix these issues, but now few people are interested in it  :(
>>
> 
> IIRC, you sent as RFC and got a "reviewed-by" from Hannes, so I'm not sure what else you want. BTW, I thought that the changes were quite drastic.

I agree, the changes seems something drastic. But I think current libsas hotplug framework has a big flaw.

> 
> John
> 
>>>
>>>>
>>>> Alternatively we need a mechanism to cancel in-flight port shutdown
>>>> requests when we start re-attaching devices before queued port
>>>> destruction events have run.
>>>>
>>>> .
>>>>
>>>
>>>
>>> _______________________________________________
>>> linuxarm mailing list
>>> linuxarm@huawei.com
>>> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
>>>
>>> .
>>>
>>
>>
>> .
>>
> 
> 
> 
> .
> 
