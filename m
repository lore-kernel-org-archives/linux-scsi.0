From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Fri, 04 Nov 2011 13:07:53 +0900
Message-ID: <4EB36519.5010003@ce.jp.nec.com>
References: <4E9BEB68.1050707@ce.jp.nec.com> <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com> <4E9D7FA8.9000000@ce.jp.nec.com> <20111018154542.GB3869@osiris.boeblingen.de.ibm.com> <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com> <20111031100557.GA2621@osiris.boeblingen.de.ibm.com> <1320057746.2964.1.camel@dabdike> <4EAE8A7E.8000504@ce.jp.nec.com> <20111031130004.GB4768@osiris.boeblingen.de.ibm.com> <4EB13972.30308@ce.jp.nec.com> <20111102134730.GA2490@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41941 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1KDEIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2011 00:08:11 -0400
In-Reply-To: <20111102134730.GA2490@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, Mike Snitzer <snitzer@redhat.com>, gmuelas@de.ibm.com

On 11/02/11 22:47, Heiko Carstens wrote:
> On Wed, Nov 02, 2011 at 09:37:06PM +0900, Jun'ichi Nomura wrote:
>> On 10/31/11 22:00, Heiko Carstens wrote:
>>> On Mon, Oct 31, 2011 at 08:46:06PM +0900, Jun'ichi Nomura wrote:
>>>> Hm, dm_softirq_done is generic completion code of original
>>>> request in dm-multipath.
>>>> So oops here might be another manifestation of use-after-free.
>>>>
>>>> Do you always hit the oops at the same address?
>>>
>>> I think we saw this bug the first time. But before that the scsi
>>> logging level was higher. Gonzalo is trying to recreate it with
>>> the same (old) scsi logging level.
>>> Afterwards we will try with barrier=0.
>>>
>>> Both on v3.0.7 btw.
>>>
>>>> Could you find corresponding source code line for
>>>> the crashed address, dm_softirq_done+0x72/0x140,
>>>> and which pointer was invalid?
>>>
>>> It crashes in the inlined function dm_done() when trying to
>>> dereference tio (aka clone->end_io_data):
>>>
>>> static void dm_done(struct request *clone, int error, bool mapped)
>>> {
>>>         int r = error;
>>>         struct dm_rq_target_io *tio = clone->end_io_data;
>>>         dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
>>
>> Thank you. But, hmm. I have no idea about scenario.
>>
>> struct dm_rq_target_io is a container of clone request
>> and clone->end_io_data points to its container.
>>
>>   struct dm_rq_target_io {
>>         struct mapped_device *md;
>>         struct dm_target *ti;
>>         struct request *orig, clone;
>>         int error;
>>         union map_info info;
>>   };
>>
>> If clone can be dereferenced, clone->end_io_data should be, too.
> 
> If it helps: the above *ti pointer is the only one that points to
> an (invalid) vmalloc area address. Invalid means the page was unmapped
> because it was freed because of DEBUG_PAGEALLOC.
> All other addresses I followed to get to this one belong to
> the 1:1 mapping of the kernel, so no vmalloc involved.

Thanks, ok it was ti which was invalid. Not tio.
ti is a pointer to dm table entry, which is vmalloc-ed.
So it means the dm table was replaced while I/O was in-flight.

dm has a machanism to prevent it: in dm_suspend(),
stop_queue() is called to stop block queue processing
and no new I/O becomes in-flight after that.
Then all in-flight I/Os are waited to be completed or requeued
(dm_wait_for_completion()).
If the wait was successful, the table can become "suspended",
i.e. ready to be replaced.

So ti should be always valid.
Hmm..

-- 
Jun'ichi Nomura, NEC Corporation
