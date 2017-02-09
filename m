From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Thu, 9 Feb 2017 18:33:30 +0530
Message-ID: <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:35404 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdBINDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 08:03:32 -0500
Received: by mail-qt0-f172.google.com with SMTP id x49so2760932qtc.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2017 05:03:32 -0800 (PST)
In-Reply-To: <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

On Wed, Feb 1, 2017 at 1:13 PM, Hannes Reinecke <hare@suse.de> wrote:
>
> On 02/01/2017 08:07 AM, Kashyap Desai wrote:
>>>
>>> -----Original Message-----
>>> From: Hannes Reinecke [mailto:hare@suse.de]
>>> Sent: Wednesday, February 01, 2017 12:21 PM
>>> To: Kashyap Desai; Christoph Hellwig
>>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
>>> Sathya
>>> Prakash Veerichetty; PDL-MPT-FUSIONLINUX; Sreekanth Reddy
>>> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>>>
>>> On 01/31/2017 06:54 PM, Kashyap Desai wrote:
>>>>>
>>>>> -----Original Message-----
>>>>> From: Hannes Reinecke [mailto:hare@suse.de]
>>>>> Sent: Tuesday, January 31, 2017 4:47 PM
>>>>> To: Christoph Hellwig
>>>>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
>>>>
>>>> Sathya
>>>>>
>>>>> Prakash; Kashyap Desai; mpt-fusionlinux.pdl@broadcom.com
>>>>> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>>>>>
>>>>> On 01/31/2017 11:02 AM, Christoph Hellwig wrote:
>>>>>>
>>>>>> On Tue, Jan 31, 2017 at 10:25:50AM +0100, Hannes Reinecke wrote:
>>>>>>>
>>>>>>> Hi all,
>>>>>>>
>>>>>>> this is a patchset to enable full multiqueue support for the
>>>>>>> mpt3sas
>>>>>
>>>>> driver.
>>>>>>>
>>>>>>> While the HBA only has a single mailbox register for submitting
>>>>>>> commands, it does have individual receive queues per MSI-X
>>>>>>> interrupt and as such does benefit from converting it to full
>>>>>>> multiqueue
>>>>
>>>> support.
>>>>>>
>>>>>>
>>>>>> Explanation and numbers on why this would be beneficial, please.
>>>>>> We should not need multiple submissions queues for a single register
>>>>>> to benefit from multiple completion queues.
>>>>>>
>>>>> Well, the actual throughput very strongly depends on the blk-mq-sched
>>>>> patches from Jens.
>>>>> As this is barely finished I didn't post any numbers yet.
>>>>>
>>>>> However:
>>>>> With multiqueue support:
>>>>> 4k seq read : io=3D60573MB, bw=3D1009.2MB/s, iops=3D258353, runt=3D
>>>
>>> 60021msec
>>>>>
>>>>> With scsi-mq on 1 queue:
>>>>> 4k seq read : io=3D17369MB, bw=3D296291KB/s, iops=3D74072, runt=3D 60=
028msec
>>>>> So yes, there _is_ a benefit.


Hannes,

I have created a md raid0 with 4 SAS SSD drives using below command,
#mdadm --create /dev/md0 --level=3D0 --raid-devices=3D4 /dev/sdg /dev/sdh
/dev/sdi /dev/sdj

And here is 'mdadm --detail /dev/md0' command output,
---------------------------------------------------------------------------=
-----------------------------------------------
/dev/md0:
        Version : 1.2
  Creation Time : Thu Feb  9 14:38:47 2017
     Raid Level : raid0
     Array Size : 780918784 (744.74 GiB 799.66 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Thu Feb  9 14:38:47 2017
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : host_name
           UUID : b63f9da7:b7de9a25:6a46ca00:42214e22
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       96        0      active sync   /dev/sdg
       1       8      112        1      active sync   /dev/sdh
       2       8      144        2      active sync   /dev/sdj
       3       8      128        3      active sync   /dev/sdi
---------------------------------------------------------------------------=
---------------------------------------------------

Then I have used below fio profile to run 4K sequence read operations
with nr_hw_queues=3D1 driver and with nr_hw_queues=3D24 driver (as my
system has two numa node and each with 12 cpus).
-----------------------------------------------------
global]
ioengine=3Dlibaio
group_reporting
direct=3D1
rw=3Dread
bs=3D4k
allow_mounted_write=3D0
iodepth=3D128
runtime=3D150s

[job1]
filename=3D/dev/md0
-----------------------------------------------------

Here are the fio results when nr_hw_queues=3D1 (i.e. single request
queue) with various number of job counts
1JOB 4k read  : io=3D213268MB, bw=3D1421.8MB/s, iops=3D363975, runt=3D15000=
1msec
2JOBs 4k read : io=3D309605MB, bw=3D2064.2MB/s, iops=3D528389, runt=3D15000=
1msec
4JOBs 4k read : io=3D281001MB, bw=3D1873.4MB/s, iops=3D479569, runt=3D15000=
2msec
8JOBs 4k read : io=3D236297MB, bw=3D1575.2MB/s, iops=3D403236, runt=3D15001=
6msec

Here are the fio results when nr_hw_queues=3D24 (i.e. multiple request
queue) with various number of job counts
1JOB 4k read   : io=3D95194MB, bw=3D649852KB/s, iops=3D162463, runt=3D15000=
1msec
2JOBs 4k read : io=3D189343MB, bw=3D1262.3MB/s, iops=3D323142, runt=3D15000=
1msec
4JOBs 4k read : io=3D314832MB, bw=3D2098.9MB/s, iops=3D537309, runt=3D15000=
1msec
8JOBs 4k read : io=3D277015MB, bw=3D1846.8MB/s, iops=3D472769, runt=3D15000=
1msec

Here we can see that on less number of jobs count, single request
queue (nr_hw_queues=3D1) is giving more IOPs than multi request
queues(nr_hw_queues=3D24).

Can you please share your fio profile, so that I can try same thing on
my system.

Thanks,
Sreekanth


>>>>>
>>>>>
>>>>> (Which is actually quite cool, as these tests were done on a SAS3
>>>>> HBA,
>>>>
>>>> so
>>>>>
>>>>> we're getting close to the theoretical maximum of 1.2GB/s).
>>>>> (Unlike the single-queue case :-)
>>>>
>>>>
>>>> Hannes -
>>>>
>>>> Can you share detail about setup ? How many drives do you have and how
>>>> is connection (enclosure -> drives. ??) ?
>>>> To me it looks like current mpt3sas driver might be taking more hit in
>>>> spinlock operation (penalty on NUMA arch is more compare to single
>>>> core
>>>> server) unlike we have in megaraid_sas driver use of shared blk tag.
>>>>
>>> The tests were done with a single LSI SAS3008 connected to a NetApp E-
>>> series (2660), using 4 LUNs under MD-RAID0.
>>>
>>> Megaraid_sas is even worse here; due to the odd nature of the 'fusion'
>>> implementation we're ending up having _two_ sets of tags, making it rea=
lly
>>> hard to use scsi-mq here.
>>
>>
>> Current megaraid_sas as single submission queue exposed to the blk-mq wi=
ll
>> not encounter similar performance issue.
>> We may not see significant improvement of performance if we attempt the =
same
>> for megaraid_sas driver.
>> We had similar discussion for megaraid_sas and hpsa.
>> http://www.spinics.net/lists/linux-scsi/msg101838.html
>>
>> I am seeing this patch series is similar attempt for mpt3sas..Am I missi=
ng
>> anything ?
>>
> No, you don't. That is precisely the case.
>
> The different here is that mpt3sas is actually exposing hardware capabili=
ties, whereas with megaraid_sas (and hpsa) we're limited by the hardware im=
plementation to a single completion queue shared between HBA and OS.
> With mpt3sas we're having per-interrupt completion queues (well, for newe=
r firmware :-) so we can take advantage of scsi-mq.
>
> (And if someone had done a _proper_ design of the megaraid_sas_fusion thi=
ng by exposing several submission and completion queues for megaraid_sas it=
self instead of bolting the existing megaraid_sas single queue approach ont=
op of the mpt3sas multiqueue design we could have done the same thing there=
 ... sigh)
>
>> Megaraid_sas driver just do indexing from blk_tag and fire IO quick enou=
gh
>> unlike mpt3sas where we have  lock contention @driver level as bottlenec=
k.
>>
>>> (Not that I didn't try; but lacking a proper backend it's really hard t=
o
>>> evaluate
>>> the benefit of those ... spinning HDDs simply don't cut it here)
>>>
>>>> I mean " [PATCH 08/10] mpt3sas: lockless command submission for scsi-
>>>
>>> mq"
>>>>
>>>> patch is improving performance removing spinlock overhead and
>>>> attempting to get request using blk_tags.
>>>> Are you seeing performance improvement  if you hard code nr_hw_queues
>>>> =3D 1 in below code changes part of "[PATCH 10/10] mpt3sas: scsi-mq
>>>> interrupt steering"
>>>>
>>> No. The numbers posted above are generated with exactly that patch; the
>>> first line is running with nr_hw_queues=3D32 and the second line with
>>> nr_hw_queues=3D1.
>>
>>
>> Thanks Hannes. That clarifies.  Can you share <fio> script you have used=
 ?
>>
>> If my  understanding correct, you will see theoretical maximum of 1.2GBp=
/s
>> if you restrict your work load to single numa node. This is just for
>> understanding if <mpt3sas> driver spinlocks are adding overhead. We have
>> seen such overhead on multi-socket server and it is reasonable to reduce
>> lock in mpt3sas driver, but only concern is exposing HBA for multiple
>> submission queue to blk-mq is really not required and trying to figure o=
ut
>> if we have any side effect of doing that.
>>
> Well, the HBA has per-MSIx completion queues, so I don't see any issues w=
ith exposing them.
> blk-mq is designed to handle per-CPU queues, so exposing all hardware que=
ues will be beneficial especially in a low-latency context; and as the expe=
riments show, even when connected to an external storage there is a benefit=
 to be had.
>
> But exposing all queues might even reduce or even resolve your FW Fault s=
tatus 0x2100 state; with that patch you now have each queue pulling request=
 off the completion queue and updating the reply post host index in paralle=
l, making the situation far more unlikely.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
