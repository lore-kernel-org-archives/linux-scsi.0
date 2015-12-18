From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi-mq performance check
Date: Fri, 18 Dec 2015 17:05:22 +0100
Message-ID: <56742EC2.2020606@suse.de>
References: <56741F04.3070506@huawei.com> <56742168.6030200@suse.de>
 <56742403.7000108@sandisk.com> <567427E8.8010608@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbbLRQFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 11:05:25 -0500
In-Reply-To: <567427E8.8010608@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Bart Van Assche <bart.vanassche@sandisk.com>, hch@infradead.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>

On 12/18/2015 04:36 PM, John Garry wrote:
> On 18/12/2015 15:19, Bart Van Assche wrote:
>> On 12/18/2015 04:08 PM, Hannes Reinecke wrote:
>>> On 12/18/2015 03:58 PM, John Garry wrote:
>>>> Hi,
>>>>
>>>> I have started to enable scsi-mq on the HiSilicon SAS driver.
>>>>
>>>> Are there hints/checks I should use to make sure it is configured
>>>> correctly/optimally? In my initial testing I have seen some
>>>> performance improvements, but none like what I have seen in
>>>> presentations.
>>>>
>>> The whole thing is build around having symmetric submit and receive
>>> queues, so that we can tack a send/receive queue pair to the same
>>> CPU.
>>> With that we can ensure that we don't have any cache
>>> invalidation, as
>>> the request is already in the cache for that CPU when the
>>> completion is
>>> recieved. _And_ we can get rid of most spinlocks as other CPUs
>>> cannot
>>> access our request.
>>>
>>> So make sure to have the submit and receive queues properly done,
>>> and
>>> ensure you don't have any global resources within your driver which
>>> needs to be locked. Or move access to those resources out of the
>>> fast
>>> path.
>>
>> Hello John,
>>
>> It's great news that you started looking into scsi-mq support :-) As
>> Hannes wrote, if the performance improvement is not as big as you
>> expected this could be caused e.g. by lock contention. Are you
>> familiar
>> with the perf tool ? The perf tool can be a great help to verify
>> whether
>> lock contention occurs and also which lock(s) cause it.
>>
>> Bart.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Thanks for the replies.
>
> One of my main concerns is how we use a spinlock in our task exec
> function to prepare and deliver a frame to the hardware:
> hisi_sas_task_exec()
> {
>      ...
>
>      /* protect task_prep and start_delivery sequence */
>      spin_lock_irqsave(&hisi_hba->lock, flags);
>      rc =3D hisi_sas_task_prep(task, hisi_hba, is_tmf, tmf, &pass);
>      ...
>      hisi_hba->hw->start_delivery(hisi_hba);
>      spin_unlock_irqrestore(&hisi_hba->lock, flags);
>
>      ...
> }
>
> We have to lock due to how we reserve a slot in the delivery queue.
> We are looking to optimise this, but it's not straightforward.
>
> Perf is a good strategy, but, to be honest, I have not spent a lot
> of time looking at this so I'm looking for low hanging fruit initiall=
y.
>
> FYI, our hardware does have the same number of delivery and
> completion queues (32), and 16 cores. One thing to note is that a
> command which was sent on queue x is not quaranteed to complete on
> queue y.
>
=2E.. then don't bother looking at scsi-mq. That is the very thing it=20
relies on ...

Time to change the firmware?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
