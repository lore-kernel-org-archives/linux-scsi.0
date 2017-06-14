From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: sas: scsi_queue_work can fail, so make callers
 aware
Date: Wed, 14 Jun 2017 15:05:10 +0200
Message-ID: <70f96f2d-e47f-a187-36ca-68127290897b@suse.de>
References: <20170614115243.17776-1-jthumshirn@suse.de>
 <1d42fe4e-f6fb-17f5-946f-a44637000372@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1d42fe4e-f6fb-17f5-946f-a44637000372@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, wangyijing@huawei.com, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 06/14/2017 02:57 PM, John Garry wrote:
> On 14/06/2017 12:52, Johannes Thumshirn wrote:
>> libsas uses scsi_queue_work() to queue it's internal event
>> notifications. scsi_queue_work() can return -EINVAL if the work queue
>> doesn't exist and it does call queue_work() which can return false if
>> the work is already queued.
>>
> 
> Hi Johannes,
> 
> When the queuing fails and we an report error, what is the caller, i.e.
> the LLDD, supposed to do with this information?
> 
> I mean, the LLDD is just reporting an event, like a broadcast event, and
> libsas could not handle it for some reason. The LLDD probably does not
> know how to handle this, apart from printing an error or maybe even
> disabling the originating PHY.

This depends on the event and the LLDD I guess. If it's -EINVAL (a.k.a
SCSI work queue not present) there's not much an LLDD can do about. If
it's a plain false, we could for instance report that we re-queue an
event or something similar.

>> Make the SAS event code capable of returning errors up to the caller,
>> which is handy when changing to dynamically allocated work in libsas
>> as well, as discussed here: https://lkml.org/lkml/2017/6/14/121.
> 
> I will comment on this patchset separately.

It's merrily a preparation patch for this libsas patchset and IFF we
want to merge it that way.

Should've made it clear in the log, sorry.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
