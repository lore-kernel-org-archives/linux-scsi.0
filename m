From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: dm-mpath: Clear map_context pointer when requeuing
Date: Tue, 06 Dec 2011 13:44:45 +0900
Message-ID: <4EDD9DBD.7000603@ce.jp.nec.com>
References: <1322663118-53387-1-git-send-email-hare@suse.de> <20111130144951.GA13775@redhat.com> <4ED6C67A.3060305@ce.jp.nec.com> <4ED8FA8F.20109@suse.de> <4EDCA1BD.1000708@ce.jp.nec.com> <4EDCEFFE.6080702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55465 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1LFFOR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2011 00:14:17 -0500
In-Reply-To: <4EDCEFFE.6080702@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com

Hi Hannes,

On 12/06/11 01:23, Hannes Reinecke wrote:
>>> The longer answer here is that 'map_context' is managed by the
>>> caller for multipath_map().
>>> So in theory the caller is free to re-use the map_context whenever
>>> 'clone' is in use.
>>> So if 'clone' is terminated when it's still requeued the caller
>>> might be calling multipath_end_io(), at which point map_context->ptr
>>> will be pointing to an invalid memory location.
>>
>> With that logic, 'map_context->ptr = NULL' would just replace
>> the invalid memory access by NULL pointer dereference,
>> because there is no NULL-check for map_context->ptr.
>> Right?
>>
> No. Observation here is that
> multipath_end_io() absolutely required map_context->ptr to be set to a sane value.
> But without the fix map_context->ptr in multipath_end_io() will point to an uninitialized location, thus causing the error.

multipath_end_io() should not be called in such a case.
If it is, that's the bug we have to fix.

> But having checked the functions, it really looks as if we'd need another patch on top of which to check for NULL mpio in do_end_io().

See? Since there is no NULL-check, I couldn't understand
why the original patch fix anything.

> Probably sheer luck we didn't hit that.

It is not by luck.

Request status is controlled; clone is either mapped or unmapped.
  * Mapped clone is sent to lower driver and rq->end_io calls back on
    completion. map_context->ptr is valid.
    For termination, multipath_end_io() is called via softirq_done after
    dm_complete_request().
  * Unmapped clone is intermediate state which is under full control of dm.
    map_context->ptr may be invalid.
    It may be terminated by dm_kill_unmapped_request(), that bypasses
    multipath_end_io().
For requeueing, clone is first unmapped then freed
and the original unprep-ed request is requeued.

When block layer directly calls blk_end_request for re-queued request,
multipath_end_io() is not called. So that's fine.

> I'll be sending an updated patch.

If you update the patch, I think we should BUG_ON
if mpio is NULL in multipath_end_io().
Then I can understand the meaning of the patch as enhancement/clean-up.
It's not a bug fix.

>>> But as I said, this is not a detailed analysis. It's good enough
>>> for me that it solves the problem :-)
>>>
>>>> mpio is known to be non-NULL where it is used. So clearing the pointer
>>>> should not make any difference in logic.
>>>>
>>> It does, see above.
>>>
>>>> If this is a preventive change so that we can see NULL dereference
>>>> instead of random invalid access if anything happens, it should be
>>>> noted in the patch description and in the code.
>>>> Otherwise, somebody looking at the code/change in future might be
>>>> confused: "why we have to clear this pointer?"
>>>>
>>>> And there are other places where mpio is freed.
>>>> (E.g. in dispatch_queued_ios() in dm-mpath.c)
>>>> Don't we need the same change there?
>>>>
>>> I don't think so. It's just from multipath_map() where we need to
>>> ensure map_context->ptr is correct. All the other places will not
>>> touch the map_context->ptr again.
>>
>> For DM_MAPIO_REQUEUE, both multipath_map() and dispatch_queued_ios()
>> end up with dm_requeue_unmapped_request().
>> What is the difference?
>>
> Difference is that dispatch_queued_ios() only deals with queued requests, ie where it's already known this request is queued.
> For multipath_map() it's not and the block layer might decide to abort the request on its own, thus calling multipath_end_io() directly, regardless of the return value of multipath_map().

Hmm, I can't follow the reasoning.
What do you mean by "the block layer might decide to abort
the request on its own"?
If block layer aborts an unprep-ed request via softirq_done,
I'm afraid that causes more problems; e.g. breaks SCSI.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
