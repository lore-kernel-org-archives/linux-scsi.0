From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Mon, 13 Feb 2017 11:45:05 +0530
Message-ID: <CAK=zhgqQ2x5d9Mzo89V95WS8SB0Xqyw4YtL4=cAr_PEv6GS1gQ@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de> <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
 <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35418 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdBMGPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 01:15:07 -0500
Received: by mail-qk0-f182.google.com with SMTP id u25so85120426qki.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 22:15:06 -0800 (PST)
In-Reply-To: <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

On Fri, Feb 10, 2017 at 12:29 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/10/2017 05:43 AM, Sreekanth Reddy wrote:
>> On Thu, Feb 9, 2017 at 6:42 PM, Hannes Reinecke <hare@suse.de> wrote:
>>> On 02/09/2017 02:03 PM, Sreekanth Reddy wrote:
> [ .. ]
>>>>
>>>>
>>>> Hannes,
>>>>
>>>> I have created a md raid0 with 4 SAS SSD drives using below command,
>>>> #mdadm --create /dev/md0 --level=3D0 --raid-devices=3D4 /dev/sdg /dev/=
sdh
>>>> /dev/sdi /dev/sdj
>>>>
>>>> And here is 'mdadm --detail /dev/md0' command output,
>>>> ----------------------------------------------------------------------=
----------------------------------------------------
>>>> /dev/md0:
>>>>         Version : 1.2
>>>>   Creation Time : Thu Feb  9 14:38:47 2017
>>>>      Raid Level : raid0
>>>>      Array Size : 780918784 (744.74 GiB 799.66 GB)
>>>>    Raid Devices : 4
>>>>   Total Devices : 4
>>>>     Persistence : Superblock is persistent
>>>>
>>>>     Update Time : Thu Feb  9 14:38:47 2017
>>>>           State : clean
>>>>  Active Devices : 4
>>>> Working Devices : 4
>>>>  Failed Devices : 0
>>>>   Spare Devices : 0
>>>>
>>>>      Chunk Size : 512K
>>>>
>>>>            Name : host_name
>>>>            UUID : b63f9da7:b7de9a25:6a46ca00:42214e22
>>>>          Events : 0
>>>>
>>>>     Number   Major   Minor   RaidDevice State
>>>>        0       8       96        0      active sync   /dev/sdg
>>>>        1       8      112        1      active sync   /dev/sdh
>>>>        2       8      144        2      active sync   /dev/sdj
>>>>        3       8      128        3      active sync   /dev/sdi
>>>> ----------------------------------------------------------------------=
--------------------------------------------------------
>>>>
>>>> Then I have used below fio profile to run 4K sequence read operations
>>>> with nr_hw_queues=3D1 driver and with nr_hw_queues=3D24 driver (as my
>>>> system has two numa node and each with 12 cpus).
>>>> -----------------------------------------------------
>>>> global]
>>>> ioengine=3Dlibaio
>>>> group_reporting
>>>> direct=3D1
>>>> rw=3Dread
>>>> bs=3D4k
>>>> allow_mounted_write=3D0
>>>> iodepth=3D128
>>>> runtime=3D150s
>>>>
>>>> [job1]
>>>> filename=3D/dev/md0
>>>> -----------------------------------------------------
>>>>
>>>> Here are the fio results when nr_hw_queues=3D1 (i.e. single request
>>>> queue) with various number of job counts
>>>> 1JOB 4k read  : io=3D213268MB, bw=3D1421.8MB/s, iops=3D363975, runt=3D=
150001msec
>>>> 2JOBs 4k read : io=3D309605MB, bw=3D2064.2MB/s, iops=3D528389, runt=3D=
150001msec
>>>> 4JOBs 4k read : io=3D281001MB, bw=3D1873.4MB/s, iops=3D479569, runt=3D=
150002msec
>>>> 8JOBs 4k read : io=3D236297MB, bw=3D1575.2MB/s, iops=3D403236, runt=3D=
150016msec
>>>>
>>>> Here are the fio results when nr_hw_queues=3D24 (i.e. multiple request
>>>> queue) with various number of job counts
>>>> 1JOB 4k read   : io=3D95194MB, bw=3D649852KB/s, iops=3D162463, runt=3D=
150001msec
>>>> 2JOBs 4k read : io=3D189343MB, bw=3D1262.3MB/s, iops=3D323142, runt=3D=
150001msec
>>>> 4JOBs 4k read : io=3D314832MB, bw=3D2098.9MB/s, iops=3D537309, runt=3D=
150001msec
>>>> 8JOBs 4k read : io=3D277015MB, bw=3D1846.8MB/s, iops=3D472769, runt=3D=
150001msec
>>>>
>>>> Here we can see that on less number of jobs count, single request
>>>> queue (nr_hw_queues=3D1) is giving more IOPs than multi request
>>>> queues(nr_hw_queues=3D24).
>>>>
>>>> Can you please share your fio profile, so that I can try same thing on
>>>> my system.
>>>>
>>> Have you tried with the latest git update from Jens for-4.11/block (or
>>> for-4.11/next) branch?
>>
>> I am using below git repo,
>>
>> https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/log/?h=3D4.11/=
scsi-queue
>>
>> Today I will try with Jens for-4.11/block.
>>
> By all means, do.
>
>>> I've found that using the mq-deadline scheduler has a noticeable
>>> performance boost.
>>>
>>> The fio job I'm using is essentially the same; you just should make sur=
e
>>> to specify a 'numjob=3D' statement in there.
>>> Otherwise fio will just use a single CPU, which of course leads to
>>> averse effects in the multiqueue case.
>>
>> Yes I am providing 'numjob=3D' on fio command line as shown below,
>>
>> # fio md_fio_profile --numjobs=3D8 --output=3Dfio_results.txt
>>
> Still, it looks as if you'd be using less jobs than you have CPUs.
> Which means you'll be running into a tag starvation scenario on those
> CPUs, especially for the small blocksizes.
> What are the results if you set 'numjobs' to the number of CPUs?
>

Hannes,

Tried on Jens for-4.11/block kernel repo and also set each block PD's
scheduler as 'mq-deadline', and here is my results for 4K SR on md0
(raid0 with 4 drives). I have 24 CPUs and so tried even with setting
numjobs=3D24.

fio results when nr_hw_queues=3D1 (i.e. single request queue) with
various number of job counts

4k read when numjobs=3D1 : io=3D215553MB, bw=3D1437.9MB/s, iops=3D367874,
runt=3D150001msec
4k read when numjobs=3D2 : io=3D307771MB, bw=3D2051.9MB/s, iops=3D525258,
runt=3D150001msec
4k read when numjobs=3D4 : io=3D300382MB, bw=3D2002.6MB/s, iops=3D512644,
runt=3D150002msec
4k read when numjobs=3D8 : io=3D320609MB, bw=3D2137.4MB/s, iops=3D547162,
runt=3D150003msec
4k read when numjobs=3D24: io=3D275701MB, bw=3D1837.1MB/s, iops=3D470510,
runt=3D150006msec

fio results when nr_hw_queues=3D24 (i.e. multiple request queue) with
various number of job counts,

4k read when numjobs=3D1 : io=3D177600MB, bw=3D1183.2MB/s, iops=3D303102,
runt=3D150001msec
4k read when numjobs=3D2 : io=3D182416MB, bw=3D1216.1MB/s, iops=3D311320,
runt=3D150001msec
4k read when numjobs=3D4 : io=3D347553MB, bw=3D2316.2MB/s, iops=3D593149,
runt=3D150002msec
4k read when numjobs=3D8 : io=3D349995MB, bw=3D2333.3MB/s, iops=3D597312,
runt=3D150003msec
4k read when numjobs=3D24: io=3D350618MB, bw=3D2337.4MB/s, iops=3D598359,
runt=3D150007msec

On less number of jobs single queue performing better. Where as on
more number of jobs multi-queue is performing better.

Thanks,
Sreekanth


> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
