From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Fri, 10 Feb 2017 07:59:19 +0100
Message-ID: <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com>
 <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com>
 <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de>
 <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdBJHer (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Feb 2017 02:34:47 -0500
In-Reply-To: <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

On 02/10/2017 05:43 AM, Sreekanth Reddy wrote:
> On Thu, Feb 9, 2017 at 6:42 PM, Hannes Reinecke <hare@suse.de> wrote:
>> On 02/09/2017 02:03 PM, Sreekanth Reddy wrote:
[ .. ]
>>>
>>>
>>> Hannes,
>>>
>>> I have created a md raid0 with 4 SAS SSD drives using below command,
>>> #mdadm --create /dev/md0 --level=0 --raid-devices=4 /dev/sdg /dev/sdh
>>> /dev/sdi /dev/sdj
>>>
>>> And here is 'mdadm --detail /dev/md0' command output,
>>> --------------------------------------------------------------------------------------------------------------------------
>>> /dev/md0:
>>>         Version : 1.2
>>>   Creation Time : Thu Feb  9 14:38:47 2017
>>>      Raid Level : raid0
>>>      Array Size : 780918784 (744.74 GiB 799.66 GB)
>>>    Raid Devices : 4
>>>   Total Devices : 4
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Thu Feb  9 14:38:47 2017
>>>           State : clean
>>>  Active Devices : 4
>>> Working Devices : 4
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>      Chunk Size : 512K
>>>
>>>            Name : host_name
>>>            UUID : b63f9da7:b7de9a25:6a46ca00:42214e22
>>>          Events : 0
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0       8       96        0      active sync   /dev/sdg
>>>        1       8      112        1      active sync   /dev/sdh
>>>        2       8      144        2      active sync   /dev/sdj
>>>        3       8      128        3      active sync   /dev/sdi
>>> ------------------------------------------------------------------------------------------------------------------------------
>>>
>>> Then I have used below fio profile to run 4K sequence read operations
>>> with nr_hw_queues=1 driver and with nr_hw_queues=24 driver (as my
>>> system has two numa node and each with 12 cpus).
>>> -----------------------------------------------------
>>> global]
>>> ioengine=libaio
>>> group_reporting
>>> direct=1
>>> rw=read
>>> bs=4k
>>> allow_mounted_write=0
>>> iodepth=128
>>> runtime=150s
>>>
>>> [job1]
>>> filename=/dev/md0
>>> -----------------------------------------------------
>>>
>>> Here are the fio results when nr_hw_queues=1 (i.e. single request
>>> queue) with various number of job counts
>>> 1JOB 4k read  : io=213268MB, bw=1421.8MB/s, iops=363975, runt=150001msec
>>> 2JOBs 4k read : io=309605MB, bw=2064.2MB/s, iops=528389, runt=150001msec
>>> 4JOBs 4k read : io=281001MB, bw=1873.4MB/s, iops=479569, runt=150002msec
>>> 8JOBs 4k read : io=236297MB, bw=1575.2MB/s, iops=403236, runt=150016msec
>>>
>>> Here are the fio results when nr_hw_queues=24 (i.e. multiple request
>>> queue) with various number of job counts
>>> 1JOB 4k read   : io=95194MB, bw=649852KB/s, iops=162463, runt=150001msec
>>> 2JOBs 4k read : io=189343MB, bw=1262.3MB/s, iops=323142, runt=150001msec
>>> 4JOBs 4k read : io=314832MB, bw=2098.9MB/s, iops=537309, runt=150001msec
>>> 8JOBs 4k read : io=277015MB, bw=1846.8MB/s, iops=472769, runt=150001msec
>>>
>>> Here we can see that on less number of jobs count, single request
>>> queue (nr_hw_queues=1) is giving more IOPs than multi request
>>> queues(nr_hw_queues=24).
>>>
>>> Can you please share your fio profile, so that I can try same thing on
>>> my system.
>>>
>> Have you tried with the latest git update from Jens for-4.11/block (or
>> for-4.11/next) branch?
> 
> I am using below git repo,
> 
> https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/log/?h=4.11/scsi-queue
> 
> Today I will try with Jens for-4.11/block.
> 
By all means, do.

>> I've found that using the mq-deadline scheduler has a noticeable
>> performance boost.
>>
>> The fio job I'm using is essentially the same; you just should make sure
>> to specify a 'numjob=' statement in there.
>> Otherwise fio will just use a single CPU, which of course leads to
>> averse effects in the multiqueue case.
> 
> Yes I am providing 'numjob=' on fio command line as shown below,
> 
> # fio md_fio_profile --numjobs=8 --output=fio_results.txt
> 
Still, it looks as if you'd be using less jobs than you have CPUs.
Which means you'll be running into a tag starvation scenario on those
CPUs, especially for the small blocksizes.
What are the results if you set 'numjobs' to the number of CPUs?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
