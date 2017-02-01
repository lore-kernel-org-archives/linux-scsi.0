From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Wed, 1 Feb 2017 07:51:02 +0100
Message-ID: <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53685 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdBAGvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 01:51:04 -0500
In-Reply-To: <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

On 01/31/2017 06:54 PM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Tuesday, January 31, 2017 4:47 PM
>> To: Christoph Hellwig
>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
> Sathya
>> Prakash; Kashyap Desai; mpt-fusionlinux.pdl@broadcom.com
>> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>>
>> On 01/31/2017 11:02 AM, Christoph Hellwig wrote:
>>> On Tue, Jan 31, 2017 at 10:25:50AM +0100, Hannes Reinecke wrote:
>>>> Hi all,
>>>>
>>>> this is a patchset to enable full multiqueue support for the mpt3sas
>> driver.
>>>> While the HBA only has a single mailbox register for submitting
>>>> commands, it does have individual receive queues per MSI-X interrupt
>>>> and as such does benefit from converting it to full multiqueue
> support.
>>>
>>> Explanation and numbers on why this would be beneficial, please.
>>> We should not need multiple submissions queues for a single register
>>> to benefit from multiple completion queues.
>>>
>> Well, the actual throughput very strongly depends on the blk-mq-sched
>> patches from Jens.
>> As this is barely finished I didn't post any numbers yet.
>>
>> However:
>> With multiqueue support:
>> 4k seq read : io=60573MB, bw=1009.2MB/s, iops=258353, runt= 60021msec
>> With scsi-mq on 1 queue:
>> 4k seq read : io=17369MB, bw=296291KB/s, iops=74072, runt= 60028msec So
>> yes, there _is_ a benefit.
>>
>> (Which is actually quite cool, as these tests were done on a SAS3 HBA,
> so
>> we're getting close to the theoretical maximum of 1.2GB/s).
>> (Unlike the single-queue case :-)
>
> Hannes -
>
> Can you share detail about setup ? How many drives do you have and how is
> connection (enclosure -> drives. ??) ?
> To me it looks like current mpt3sas driver might be taking more hit in
> spinlock operation (penalty on NUMA arch is more compare to single core
> server) unlike we have in megaraid_sas driver use of shared blk tag.
>
The tests were done with a single LSI SAS3008 connected to a NetApp 
E-series (2660), using 4 LUNs under MD-RAID0.

Megaraid_sas is even worse here; due to the odd nature of the 'fusion' 
implementation we're ending up having _two_ sets of tags, making it 
really hard to use scsi-mq here.
(Not that I didn't try; but lacking a proper backend it's really hard to 
evaluate the benefit of those ... spinning HDDs simply don't cut it here)

> I mean " [PATCH 08/10] mpt3sas: lockless command submission for scsi-mq"
> patch is improving performance removing spinlock overhead and attempting
> to get request using blk_tags.
> Are you seeing performance improvement  if you hard code nr_hw_queues = 1
> in below code changes part of "[PATCH 10/10] mpt3sas: scsi-mq interrupt
> steering"
>
No. The numbers posted above are generated with exactly that patch; the 
first line is running with nr_hw_queues=32 and the second line with 
nr_hw_queues=1.

Curiously, though, patch 8/10 also reduces the 'can_queue' value by 
dividing it by the number of CPUs (required for blk tag space scaling).
If I _increase_ can_queue after setting up the tagspace to the original 
value performance _drops_ again.
Most unexpected; I'll be doing more experimenting there.

Full results will be presented at VAULT, btw :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
