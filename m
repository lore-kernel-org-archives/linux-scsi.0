From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Fri, 10 Feb 2017 10:13:09 +0530
Message-ID: <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com> <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33593 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBJEoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 23:44:01 -0500
Received: by mail-qk0-f172.google.com with SMTP id s140so27923263qke.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2017 20:43:11 -0800 (PST)
In-Reply-To: <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

On Thu, Feb 9, 2017 at 6:42 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/09/2017 02:03 PM, Sreekanth Reddy wrote:
>> On Wed, Feb 1, 2017 at 1:13 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>
>>> On 02/01/2017 08:07 AM, Kashyap Desai wrote:
>>>>>
>>>>> -----Original Message-----
>>>>> From: Hannes Reinecke [mailto:hare@suse.de]
>>>>> Sent: Wednesday, February 01, 2017 12:21 PM
>>>>> To: Kashyap Desai; Christoph Hellwig
>>>>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
>>>>> Sathya
>>>>> Prakash Veerichetty; PDL-MPT-FUSIONLINUX; Sreekanth Reddy
>>>>> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>>>>>
>>>>> On 01/31/2017 06:54 PM, Kashyap Desai wrote:
>>>>>>>
>>>>>>> -----Original Message-----
>>>>>>> From: Hannes Reinecke [mailto:hare@suse.de]
>>>>>>> Sent: Tuesday, January 31, 2017 4:47 PM
>>>>>>> To: Christoph Hellwig
>>>>>>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org=
;
>>>>>>
>>>>>> Sathya
>>>>>>>
>>>>>>> Prakash; Kashyap Desai; mpt-fusionlinux.pdl@broadcom.com
>>>>>>> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>>>>>>>
>>>>>>> On 01/31/2017 11:02 AM, Christoph Hellwig wrote:
>>>>>>>>
>>>>>>>> On Tue, Jan 31, 2017 at 10:25:50AM +0100, Hannes Reinecke wrote:
>>>>>>>>>
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> this is a patchset to enable full multiqueue support for the
>>>>>>>>> mpt3sas
>>>>>>>
>>>>>>> driver.
>>>>>>>>>
>>>>>>>>> While the HBA only has a single mailbox register for submitting
>>>>>>>>> commands, it does have individual receive queues per MSI-X
>>>>>>>>> interrupt and as such does benefit from converting it to full
>>>>>>>>> multiqueue
>>>>>>
>>>>>> support.
>>>>>>>>
>>>>>>>>
>>>>>>>> Explanation and numbers on why this would be beneficial, please.
>>>>>>>> We should not need multiple submissions queues for a single regist=
er
>>>>>>>> to benefit from multiple completion queues.
>>>>>>>>
>>>>>>> Well, the actual throughput very strongly depends on the blk-mq-sch=
ed
>>>>>>> patches from Jens.
>>>>>>> As this is barely finished I didn't post any numbers yet.
>>>>>>>
>>>>>>> However:
>>>>>>> With multiqueue support:
>>>>>>> 4k seq read : io=3D60573MB, bw=3D1009.2MB/s, iops=3D258353, runt=3D
>>>>>
>>>>> 60021msec
>>>>>>>
>>>>>>> With scsi-mq on 1 queue:
>>>>>>> 4k seq read : io=3D17369MB, bw=3D296291KB/s, iops=3D74072, runt=3D =
60028msec
>>>>>>> So yes, there _is_ a benefit.
>>
>>
>> Hannes,
>>
>> I have created a md raid0 with 4 SAS SSD drives using below command,
>> #mdadm --create /dev/md0 --level=3D0 --raid-devices=3D4 /dev/sdg /dev/sd=
h
>> /dev/sdi /dev/sdj
>>
>> And here is 'mdadm --detail /dev/md0' command output,
>> ------------------------------------------------------------------------=
--------------------------------------------------
>> /dev/md0:
>>         Version : 1.2
>>   Creation Time : Thu Feb  9 14:38:47 2017
>>      Raid Level : raid0
>>      Array Size : 780918784 (744.74 GiB 799.66 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Thu Feb  9 14:38:47 2017
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>      Chunk Size : 512K
>>
>>            Name : host_name
>>            UUID : b63f9da7:b7de9a25:6a46ca00:42214e22
>>          Events : 0
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       96        0      active sync   /dev/sdg
>>        1       8      112        1      active sync   /dev/sdh
>>        2       8      144        2      active sync   /dev/sdj
>>        3       8      128        3      active sync   /dev/sdi
>> ------------------------------------------------------------------------=
------------------------------------------------------
>>
>> Then I have used below fio profile to run 4K sequence read operations
>> with nr_hw_queues=3D1 driver and with nr_hw_queues=3D24 driver (as my
>> system has two numa node and each with 12 cpus).
>> -----------------------------------------------------
>> global]
>> ioengine=3Dlibaio
>> group_reporting
>> direct=3D1
>> rw=3Dread
>> bs=3D4k
>> allow_mounted_write=3D0
>> iodepth=3D128
>> runtime=3D150s
>>
>> [job1]
>> filename=3D/dev/md0
>> -----------------------------------------------------
>>
>> Here are the fio results when nr_hw_queues=3D1 (i.e. single request
>> queue) with various number of job counts
>> 1JOB 4k read  : io=3D213268MB, bw=3D1421.8MB/s, iops=3D363975, runt=3D15=
0001msec
>> 2JOBs 4k read : io=3D309605MB, bw=3D2064.2MB/s, iops=3D528389, runt=3D15=
0001msec
>> 4JOBs 4k read : io=3D281001MB, bw=3D1873.4MB/s, iops=3D479569, runt=3D15=
0002msec
>> 8JOBs 4k read : io=3D236297MB, bw=3D1575.2MB/s, iops=3D403236, runt=3D15=
0016msec
>>
>> Here are the fio results when nr_hw_queues=3D24 (i.e. multiple request
>> queue) with various number of job counts
>> 1JOB 4k read   : io=3D95194MB, bw=3D649852KB/s, iops=3D162463, runt=3D15=
0001msec
>> 2JOBs 4k read : io=3D189343MB, bw=3D1262.3MB/s, iops=3D323142, runt=3D15=
0001msec
>> 4JOBs 4k read : io=3D314832MB, bw=3D2098.9MB/s, iops=3D537309, runt=3D15=
0001msec
>> 8JOBs 4k read : io=3D277015MB, bw=3D1846.8MB/s, iops=3D472769, runt=3D15=
0001msec
>>
>> Here we can see that on less number of jobs count, single request
>> queue (nr_hw_queues=3D1) is giving more IOPs than multi request
>> queues(nr_hw_queues=3D24).
>>
>> Can you please share your fio profile, so that I can try same thing on
>> my system.
>>
> Have you tried with the latest git update from Jens for-4.11/block (or
> for-4.11/next) branch?

I am using below git repo,

https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/log/?h=3D4.11/scs=
i-queue

Today I will try with Jens for-4.11/block.

> I've found that using the mq-deadline scheduler has a noticeable
> performance boost.
>
> The fio job I'm using is essentially the same; you just should make sure
> to specify a 'numjob=3D' statement in there.
> Otherwise fio will just use a single CPU, which of course leads to
> averse effects in the multiqueue case.

Yes I am providing 'numjob=3D' on fio command line as shown below,

# fio md_fio_profile --numjobs=3D8 --output=3Dfio_results.txt

Thanks,
Sreekanth

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
