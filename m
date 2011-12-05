From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-mpath: Clear map_context pointer when requeuing
Date: Mon, 05 Dec 2011 17:23:26 +0100
Message-ID: <4EDCEFFE.6080702@suse.de>
References: <1322663118-53387-1-git-send-email-hare@suse.de> <20111130144951.GA13775@redhat.com> <4ED6C67A.3060305@ce.jp.nec.com> <4ED8FA8F.20109@suse.de> <4EDCA1BD.1000708@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1LEOWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Dec 2011 09:22:24 -0500
In-Reply-To: <4EDCA1BD.1000708@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com

On 12/05/2011 11:49 AM, Jun'ichi Nomura wrote:
> Hi Hannes,
>
> On 12/03/11 01:19, Hannes Reinecke wrote:
>>>>> When requeing a request we should be clearing the map_context
>>>>> pointer, otherwise we might access an invalid memory location.
>>>
>>> Could you elaborate on the mechanism how the map_context->ptr
>>> (=3D mpio) is accessed after freeing it?
>>>
>> In short: No. Pure guesswork :-)
>
> Guesswork is OK :)
>
> But..
>
>> The longer answer here is that 'map_context' is managed by the
>> caller for multipath_map().
>> So in theory the caller is free to re-use the map_context whenever
>> 'clone' is in use.
>> So if 'clone' is terminated when it's still requeued the caller
>> might be calling multipath_end_io(), at which point map_context->ptr
>> will be pointing to an invalid memory location.
>
> With that logic, 'map_context->ptr =3D NULL' would just replace
> the invalid memory access by NULL pointer dereference,
> because there is no NULL-check for map_context->ptr.
> Right?
>
No. Observation here is that
multipath_end_io() absolutely required map_context->ptr to be set to a=20
sane value.
But without the fix map_context->ptr in multipath_end_io() will point t=
o=20
an uninitialized location, thus causing the error.

But having checked the functions, it really looks as if we'd need=20
another patch on top of which to check for NULL mpio in do_end_io().
Probably sheer luck we didn't hit that.

I'll be sending an updated patch.

>> But as I said, this is not a detailed analysis. It's good enough
>> for me that it solves the problem :-)
>>
>>> mpio is known to be non-NULL where it is used. So clearing the poin=
ter
>>> should not make any difference in logic.
>>>
>> It does, see above.
>>
>>> If this is a preventive change so that we can see NULL dereference
>>> instead of random invalid access if anything happens, it should be
>>> noted in the patch description and in the code.
>>> Otherwise, somebody looking at the code/change in future might be
>>> confused: "why we have to clear this pointer?"
>>>
>>> And there are other places where mpio is freed.
>>> (E.g. in dispatch_queued_ios() in dm-mpath.c)
>>> Don't we need the same change there?
>>>
>> I don't think so. It's just from multipath_map() where we need to
>> ensure map_context->ptr is correct. All the other places will not
>> touch the map_context->ptr again.
>
> For DM_MAPIO_REQUEUE, both multipath_map() and dispatch_queued_ios()
> end up with dm_requeue_unmapped_request().
> What is the difference?
>
Difference is that dispatch_queued_ios() only deals with queued=20
requests, ie where it's already known this request is queued.
=46or multipath_map() it's not and the block layer might decide to abor=
t=20
the request on its own, thus calling multipath_end_io() directly,=20
regardless of the return value of multipath_map().

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
