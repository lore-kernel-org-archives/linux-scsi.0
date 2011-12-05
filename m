From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: dm-mpath: Clear map_context pointer when requeuing
Date: Mon, 05 Dec 2011 19:49:33 +0900
Message-ID: <4EDCA1BD.1000708@ce.jp.nec.com>
References: <1322663118-53387-1-git-send-email-hare@suse.de>
	<20111130144951.GA13775@redhat.com>
	<4ED6C67A.3060305@ce.jp.nec.com> <4ED8FA8F.20109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ED8FA8F.20109@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

On 12/03/11 01:19, Hannes Reinecke wrote:
>>>> When requeing a request we should be clearing the map_context
>>>> pointer, otherwise we might access an invalid memory location.
>>
>> Could you elaborate on the mechanism how the map_context->ptr
>> (= mpio) is accessed after freeing it?
>>
> In short: No. Pure guesswork :-)

Guesswork is OK :)

But..

> The longer answer here is that 'map_context' is managed by the
> caller for multipath_map().
> So in theory the caller is free to re-use the map_context whenever
> 'clone' is in use.
> So if 'clone' is terminated when it's still requeued the caller
> might be calling multipath_end_io(), at which point map_context->ptr
> will be pointing to an invalid memory location.

With that logic, 'map_context->ptr = NULL' would just replace
the invalid memory access by NULL pointer dereference,
because there is no NULL-check for map_context->ptr.
Right?

> But as I said, this is not a detailed analysis. It's good enough
> for me that it solves the problem :-)
> 
>> mpio is known to be non-NULL where it is used. So clearing the pointer
>> should not make any difference in logic.
>>
> It does, see above.
> 
>> If this is a preventive change so that we can see NULL dereference
>> instead of random invalid access if anything happens, it should be
>> noted in the patch description and in the code.
>> Otherwise, somebody looking at the code/change in future might be
>> confused: "why we have to clear this pointer?"
>>
>> And there are other places where mpio is freed.
>> (E.g. in dispatch_queued_ios() in dm-mpath.c)
>> Don't we need the same change there?
>>
> I don't think so. It's just from multipath_map() where we need to
> ensure map_context->ptr is correct. All the other places will not
> touch the map_context->ptr again.

For DM_MAPIO_REQUEUE, both multipath_map() and dispatch_queued_ios()
end up with dm_requeue_unmapped_request().
What is the difference?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
