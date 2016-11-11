From: wangyijing <wangyijing@huawei.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Fri, 11 Nov 2016 16:12:02 +0800
Message-ID: <58257D52.6090507@huawei.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
 <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
 <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
 <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
 <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([119.145.14.52]:1916 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755668AbcKKIUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2016 03:20:35 -0500
In-Reply-To: <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Dan Williams <dan.j.williams@intel.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, john.garry2@mail.dcu.ie, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, lindar_liu@usish.com, Tejun Heo <tj@kernel.org>, jinpu.wang@profitbricks.com

> 
> They're not the same. I don't see how your solution properly deals with remote sas_port deletion.
> 
> When we unplug a device connected to an expander, can't the sas_port be deleted twice, in sas_unregister_devs_sas_addr() from domain revalidation and also now in sas_destruct_devices()? I think that this gives a NULL dereference.
> And we still get the WARN as the sas_port has still been deleted before the device.
> 
> In my solution, we should always delete the sas_port after the attached device.
> 
>>>
>>> i.e. it moves the port destruction to the workqueue and still suffers
>>> from the flutter problem:
>>>
>>> http://marc.info/?l=linux-scsi&m=143801026028006&w=2
>>> http://marc.info/?l=linux-scsi&m=143801971131073&w=2
>>>
>>> Perhaps we instead need to quiet this warning?
>>>
>>> http://marc.info/?l=linux-scsi&m=143802229932175&w=2
> 
> I have not seen the flutter issue. I am just trying to solve the horrible WARN dump.
> However I do understand that there may be a issue related to how we queue the events; there was a recent attempt to fix this, but it came to nothing:
> https://www.spinics.net/lists/linux-scsi/msg99991.html

We found libsas hotplug several problems:
1. sysfs warning calltrace(like the case you found);
2. hot-add and hot-remove work events may process out of order;
3. in some extreme cases, libsas may miss some events, if the same event is still pending in workqueue.

It's a complex issue, we posted two patches, try to fix these issues, but now few people are interested in it  :(

> 
> Cheers,
> John
> 
>>
>> Alternatively we need a mechanism to cancel in-flight port shutdown
>> requests when we start re-attaching devices before queued port
>> destruction events have run.
>>
>> .
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

