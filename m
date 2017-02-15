From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Wed, 15 Feb 2017 13:57:38 +0530
Message-ID: <CAK=zhgqiCh+5tD+kHD15Xef5MnJM0SG=LaP=+cM-40VtMSH7Ew@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de> <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
 <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de> <CAK=zhgqQ2x5d9Mzo89V95WS8SB0Xqyw4YtL4=cAr_PEv6GS1gQ@mail.gmail.com>
 <2770c802-b8b2-9035-c760-c5b970a9bd99@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33569 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdBOI1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 03:27:40 -0500
Received: by mail-qk0-f173.google.com with SMTP id p22so53317206qka.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2017 00:27:40 -0800 (PST)
In-Reply-To: <2770c802-b8b2-9035-c760-c5b970a9bd99@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

On Mon, Feb 13, 2017 at 6:41 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/13/2017 07:15 AM, Sreekanth Reddy wrote:
>> On Fri, Feb 10, 2017 at 12:29 PM, Hannes Reinecke <hare@suse.de> wrote:
>>> On 02/10/2017 05:43 AM, Sreekanth Reddy wrote:
>>>> On Thu, Feb 9, 2017 at 6:42 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>>> On 02/09/2017 02:03 PM, Sreekanth Reddy wrote:
>>> [ .. ]
>>>>>>
>>>>>>
>>>>>> Hannes,
>>>>>>
>>>>>> I have created a md raid0 with 4 SAS SSD drives using below command,
>>>>>> #mdadm --create /dev/md0 --level=0 --raid-devices=4 /dev/sdg /dev/sdh
>>>>>> /dev/sdi /dev/sdj
>>>>>>
>>>>>> And here is 'mdadm --detail /dev/md0' command output,
>>>>>> --------------------------------------------------------------------------------------------------------------------------
>>>>>> /dev/md0:
>>>>>>         Version : 1.2
>>>>>>   Creation Time : Thu Feb  9 14:38:47 2017
>>>>>>      Raid Level : raid0
>>>>>>      Array Size : 780918784 (744.74 GiB 799.66 GB)
>>>>>>    Raid Devices : 4
>>>>>>   Total Devices : 4
>>>>>>     Persistence : Superblock is persistent
>>>>>>
>>>>>>     Update Time : Thu Feb  9 14:38:47 2017
>>>>>>           State : clean
>>>>>>  Active Devices : 4
>>>>>> Working Devices : 4
>>>>>>  Failed Devices : 0
>>>>>>   Spare Devices : 0
>>>>>>
>>>>>>      Chunk Size : 512K
>>>>>>
>>>>>>            Name : host_name
>>>>>>            UUID : b63f9da7:b7de9a25:6a46ca00:42214e22
>>>>>>          Events : 0
>>>>>>
>>>>>>     Number   Major   Minor   RaidDevice State
>>>>>>        0       8       96        0      active sync   /dev/sdg
>>>>>>        1       8      112        1      active sync   /dev/sdh
>>>>>>        2       8      144        2      active sync   /dev/sdj
>>>>>>        3       8      128        3      active sync   /dev/sdi
>>>>>> ------------------------------------------------------------------------------------------------------------------------------
>>>>>>
>>>>>> Then I have used below fio profile to run 4K sequence read operations
>>>>>> with nr_hw_queues=1 driver and with nr_hw_queues=24 driver (as my
>>>>>> system has two numa node and each with 12 cpus).
>>>>>> -----------------------------------------------------
>>>>>> global]
>>>>>> ioengine=libaio
>>>>>> group_reporting
>>>>>> direct=1
>>>>>> rw=read
>>>>>> bs=4k
>>>>>> allow_mounted_write=0
>>>>>> iodepth=128
>>>>>> runtime=150s
>>>>>>
>>>>>> [job1]
>>>>>> filename=/dev/md0
>>>>>> -----------------------------------------------------
>>>>>>
>>>>>> Here are the fio results when nr_hw_queues=1 (i.e. single request
>>>>>> queue) with various number of job counts
>>>>>> 1JOB 4k read  : io=213268MB, bw=1421.8MB/s, iops=363975, runt=150001msec
>>>>>> 2JOBs 4k read : io=309605MB, bw=2064.2MB/s, iops=528389, runt=150001msec
>>>>>> 4JOBs 4k read : io=281001MB, bw=1873.4MB/s, iops=479569, runt=150002msec
>>>>>> 8JOBs 4k read : io=236297MB, bw=1575.2MB/s, iops=403236, runt=150016msec
>>>>>>
>>>>>> Here are the fio results when nr_hw_queues=24 (i.e. multiple request
>>>>>> queue) with various number of job counts
>>>>>> 1JOB 4k read   : io=95194MB, bw=649852KB/s, iops=162463, runt=150001msec
>>>>>> 2JOBs 4k read : io=189343MB, bw=1262.3MB/s, iops=323142, runt=150001msec
>>>>>> 4JOBs 4k read : io=314832MB, bw=2098.9MB/s, iops=537309, runt=150001msec
>>>>>> 8JOBs 4k read : io=277015MB, bw=1846.8MB/s, iops=472769, runt=150001msec
>>>>>>
>>>>>> Here we can see that on less number of jobs count, single request
>>>>>> queue (nr_hw_queues=1) is giving more IOPs than multi request
>>>>>> queues(nr_hw_queues=24).
>>>>>>
>>>>>> Can you please share your fio profile, so that I can try same thing on
>>>>>> my system.
>>>>>>
>>>>> Have you tried with the latest git update from Jens for-4.11/block (or
>>>>> for-4.11/next) branch?
>>>>
>>>> I am using below git repo,
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/log/?h=4.11/scsi-queue
>>>>
>>>> Today I will try with Jens for-4.11/block.
>>>>
>>> By all means, do.
>>>
>>>>> I've found that using the mq-deadline scheduler has a noticeable
>>>>> performance boost.
>>>>>
>>>>> The fio job I'm using is essentially the same; you just should make sure
>>>>> to specify a 'numjob=' statement in there.
>>>>> Otherwise fio will just use a single CPU, which of course leads to
>>>>> averse effects in the multiqueue case.
>>>>
>>>> Yes I am providing 'numjob=' on fio command line as shown below,
>>>>
>>>> # fio md_fio_profile --numjobs=8 --output=fio_results.txt
>>>>
>>> Still, it looks as if you'd be using less jobs than you have CPUs.
>>> Which means you'll be running into a tag starvation scenario on those
>>> CPUs, especially for the small blocksizes.
>>> What are the results if you set 'numjobs' to the number of CPUs?
>>>
>>
>> Hannes,
>>
>> Tried on Jens for-4.11/block kernel repo and also set each block PD's
>> scheduler as 'mq-deadline', and here is my results for 4K SR on md0
>> (raid0 with 4 drives). I have 24 CPUs and so tried even with setting
>> numjobs=24.
>>
>> fio results when nr_hw_queues=1 (i.e. single request queue) with
>> various number of job counts
>>
>> 4k read when numjobs=1 : io=215553MB, bw=1437.9MB/s, iops=367874,
>> runt=150001msec
>> 4k read when numjobs=2 : io=307771MB, bw=2051.9MB/s, iops=525258,
>> runt=150001msec
>> 4k read when numjobs=4 : io=300382MB, bw=2002.6MB/s, iops=512644,
>> runt=150002msec
>> 4k read when numjobs=8 : io=320609MB, bw=2137.4MB/s, iops=547162,
>> runt=150003msec
>> 4k read when numjobs=24: io=275701MB, bw=1837.1MB/s, iops=470510,
>> runt=150006msec
>>
>> fio results when nr_hw_queues=24 (i.e. multiple request queue) with
>> various number of job counts,
>>
>> 4k read when numjobs=1 : io=177600MB, bw=1183.2MB/s, iops=303102,
>> runt=150001msec
>> 4k read when numjobs=2 : io=182416MB, bw=1216.1MB/s, iops=311320,
>> runt=150001msec
>> 4k read when numjobs=4 : io=347553MB, bw=2316.2MB/s, iops=593149,
>> runt=150002msec
>> 4k read when numjobs=8 : io=349995MB, bw=2333.3MB/s, iops=597312,
>> runt=150003msec
>> 4k read when numjobs=24: io=350618MB, bw=2337.4MB/s, iops=598359,
>> runt=150007msec
>>
>> On less number of jobs single queue performing better. Where as on
>> more number of jobs multi-queue is performing better.
>>
> Thank you for these numbers. They do very much fit with my results.
>
> So it's as I suspected; with more parallelism we do gain from
> multiqueue. And with single-issue processes we do suffer a performance
> penalty.
>
> However, I strongly suspect that this is an issue with block-mq itself,
> and not so much with mpt3sas.
> Reason is that block-mq needs split the tag space into distinct ranges
> for each queue, and hence is hitting tag starvation far earlier the more
> queues are registered.
> block-mq _can_ work around this by moving the issuing process onto
> another CPU (and thus use the tagspace from there), but this involved
> calling 'schedule' in the hot path. And might well account for the
> performance drop here.
>
> I will be doing more tests with a high nr_hw_queue count and a low I/O
> issuer count; I really do guess that it's the block-layer which is
> performing suboptimal here.
> In any case, we will be discussing blk-mq performance at LSF/MM this
> year; I will be bringing up the poor single-queue performance there.
>
> At the end of the day, I strongly suspect that every self-respecting
> process doing heavy I/O already _is_ multithreaded, so I would not
> trying to optimize for the single-queue case.
>
> Cheers,
>
> Hannes


Hannes,

Result I have posted last time is with merge operation enabled in
block layer. If I disable merge operation then I don't see much
improvement  with multiple hw request queues. Here is the result,

fio results when nr_hw_queues=1,
4k read when numjobs=24: io=248387MB, bw=1655.1MB/s, iops=423905,
runt=150003msec

fio results when nr_hw_queues=24,
4k read when numjobs=24: io=263904MB, bw=1759.4MB/s, iops=450393,
runt=150001msec

Thanks,
Sreekanth
