From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Wed, 9 Nov 2016 12:35:23 -0800
Message-ID: <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com> <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
 <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>, john.garry2@mail.dcu.ie, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lindar_liu@usish.com, jinpu.wang@profitbricks.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 9, 2016 at 11:09 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Nov 9, 2016 at 9:36 AM, John Garry <john.garry@huawei.com> wrote:
>> On 09/11/2016 12:28, John Garry wrote:
>>>
>>> On 03/11/2016 14:58, John Garry wrote:
>>>>
>>>> The following patch introduces an annoying WARN
>>>> when a device is removed from the SAS topology:
>>>> [SCSI] libsas: prevent domain rediscovery competing with ata error
>>>> handling
>>>>
>>>
>>> Are there any views on this patch? I would have thought that the parties
>>> who use the drivers based on libsas would be interested in fixing this
>>> bug.
>>>
>>
>> I should have added the before and after logs earlier, so the issue is
>> illustrated. Now attached. When a 24-port expander is unplugged we get >6k
>> lines of WARN on the console, lasting >30 seconds. Not nice.
>>
>
> I might be mistaken, but this patch seems functionally identical to
> this attempt:
>
> http://marc.info/?l=linux-scsi&m=143459794823595&w=2
>
> i.e. it moves the port destruction to the workqueue and still suffers
> from the flutter problem:
>
> http://marc.info/?l=linux-scsi&m=143801026028006&w=2
> http://marc.info/?l=linux-scsi&m=143801971131073&w=2
>
> Perhaps we instead need to quiet this warning?
>
> http://marc.info/?l=linux-scsi&m=143802229932175&w=2

Alternatively we need a mechanism to cancel in-flight port shutdown
requests when we start re-attaching devices before queued port
destruction events have run.
