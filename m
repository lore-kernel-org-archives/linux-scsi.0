From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 4/6] scsi_error: do not escalate failed EH command
Date: Thu, 23 Mar 2017 14:11:34 +0100
Message-ID: <89441754-d40f-08ba-4531-359ef97b75aa@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-5-git-send-email-hare@suse.de>
 <20170314175611.GC19037@bblock-ThinkPad-W530>
 <aa4c4285-782f-bd41-2fe8-98f54c2c2d9d@suse.de>
 <20170316110142.GB11833@bblock-ThinkPad-W530>
 <6c23c34a-a59b-3c4b-7c43-92b87eabcf61@suse.de>
 <20170321190545.GB16847@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47983 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932997AbdCWNLi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Mar 2017 09:11:38 -0400
In-Reply-To: <20170321190545.GB16847@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 03/21/2017 08:05 PM, Benjamin Block wrote:
> On Thu, Mar 16, 2017 at 12:53:45PM +0100, Hannes Reinecke wrote:
>> On 03/16/2017 12:01 PM, Benjamin Block wrote:
>>> On Wed, Mar 15, 2017 at 02:54:16PM +0100, Hannes Reinecke wrote:
>>>> On 03/14/2017 06:56 PM, Benjamin Block wrote:
>>>>> Hello Hannes,
>>>>>
>>>>> On Wed, Mar 01, 2017 at 10:15:18AM +0100, Hannes Reinecke wrote:
>>>>>> When a command is sent as part of the error handling there
>>>>>> is not point whatsoever to start EH escalation when that
>>>>>> command fails; we are _already_ in the error handler,
>>>>>> and the escalation is about to commence anyway.
>>>>>> So just call 'scsi_try_to_abort_cmd()' to abort outstanding
>>>>>> commands and let the main EH routine handle the rest.
>>>>>>
>>>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>>>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>>>>>> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
>>>>>> ---
>>>>>>  drivers/scsi/scsi_error.c | 11 +----------
>>>>>>  1 file changed, 1 insertion(+), 10 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>>>>> index e1ca3b8..4613aa1 100644
>>>>>> --- a/drivers/scsi/scsi_error.c
>>>>>> +++ b/drivers/scsi/scsi_error.c
>>>>>> @@ -889,15 +889,6 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
>>>>>>  	return hostt->eh_abort_handler(scmd);
>>>>>>  }
>>>>>>
>>>>>> -static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>>>>>> -{
>>>>>> -	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
>>>>>> -		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
>>>>>> -			if (scsi_try_target_reset(scmd) != SUCCESS)
>>>>>> -				if (scsi_try_bus_reset(scmd) != SUCCESS)
>>>>>> -					scsi_try_host_reset(scmd);
>>>>>> -}
>>>>>> -
>>>>>>  /**
>>>>>>   * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recovery
>>>>>>   * @scmd:       SCSI command structure to hijack
>>>>>> @@ -1082,7 +1073,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>>>>>>  			break;
>>>>>>  		}
>>>>>>  	} else if (rtn != FAILED) {
>>>>>> -		scsi_abort_eh_cmnd(scmd);
>>>>>> +		scsi_try_to_abort_cmd(shost->hostt, scmd);
>>>>>>  		rtn = FAILED;
>>>>>>  	}
>>>>>
>>>>> The idea is sound, but this implementation would cause "use-after-free"s.
>>>>>
>>>>> I only know our own LLD well enough to judge, but with zFCP there will
>>>>> always be a chance that an abort fails - be it memory pressure,
>>>>> hardware/firmware behavior or internal EH in zFCP.
>>>>>
>>>>> Calling queuecommand() will mean for us in the LLD, that we allocate a
>>>>> unique internal request struct for the scsi_cmnd (struct
>>>>> zfcp_fsf_request) and add that to our internal hash-table with
>>>>> outstanding commands. We assume this scsi_cmnd-pointer is ours till we
>>>>> complete it via scsi_done are yield it via successful EH-actions.
>>>>>
>>>>> In case the abort fails, you fail to take back the ownership over the
>>>>> scsi command. Which in turn means possible "use-after-free"s when we
>>>>> still thinks the scsi command is ours, but EH has already overwritten
>>>>> the scsi-command with the original one. When we still get an answer or
>>>>> otherwise use the scsi_cmnd-pointer we would access an invalid one.
>>>>>
>>>> That is actually not try.
>>>> As soon as we're calling 'scsi_try_to_abort_command()' ownership is
>>>> assumed to reside in the SCSI midlayer;
>>>
>>> That can not be true. First of all, look at the function itself (v4.10):
>>>
>>> 	static int scsi_try_to_abort_cmd...
>>> 	{
>>> 		if (!hostt->eh_abort_handler)
>>> 			return FAILED;
>>>
>>> 		return hostt->eh_abort_handler(scmd);
>>> 	}
>>>
>>> If what you say is true, then this whole API of LLDs providing or
>>> choosing not to provide implementations for these function would be
>>> fundamentally broken.
>>> The function itself returns FAILED when there is no such function.. how
>>> is a LLD that does not implement it ever to know that you took ownership
>>> by calling scsi_try_to_abort_cmd()?
>>>
>> Well. Ok.
>>
>> _Actually_, the whole concept of 'ownership' in SCSI EH is a bit flaky.
>>
>> There are two ways of entering the error handler:
>> - SCSI command timeout
>> - Failing to evaluate the SCSI command status
>>
>> For the latter case ownership already _is_ with the SCSI midlayer, as
>> the LLDD called 'scsi_done' and with that moved ownership to the midlayer.
>>
>> The interesting part is command timeout.
>> Once a command timeout triggers the block layer is calling
>> 'blk_mark_rq_complete' to avoid any concurrent completions.
>> IE any calls to scsi_done() will be short-circuited with that,
>> effectively transferring ownership to SCSI midlayer.
>>
>> Now the SCSI midlayer has to inform the LLDD that it has taken
>> ownership; for that it calls the various eh_XXX callbacks into the LLDD.
>> While it's quite clear that SUCCESS signals a transfer of ownership to
>> SCSI ML, it's less clear what happens in the case of FAILED.
>> Problem here is that the eh_XXX callbacks actually serve a dual purpose;
>> one it to signal the transfer of ownership to SCSI ML and the other is
>> to actually _do_ some action on that command.
>>
>> But as FAILED is just _one_ value we have no idea in the midlayer if the
>> change of ownership actually took place.
>>
>> Which leads to the curious effect that _ultimatively_ control still
>> resides with the LLDD when host_reset fails, so we actually should
>> _never_ release the scsi command once host reset fails.
>>
>> With scsi_try_to_abort() things are slightly different in the way that
>> it's called _without_ SCSI EH being engaged.
>> However, as scsi_try_to_abort() is called from the timeout handler
>> (which assumes that ownership does now reside with the midlayer) I don't
>> see a problem with that.
>>
> 
> Yeah, I was aware of these things, but I think we are talking about 2
> different things/implications when we talk about 'ownership' in this
> context here. Which makes things seem to be worse than they are.
> 
> But we seem to agree on this: if eh_XXX returns FAILED, ownership
> ultimatively stays with the LLD. In which case the midlayer has to
> accommodate for the possibility that for example scsi_done is called.
> 
> Anyway, see below.
> 
>>
>> Where you are right, in fact, is that we should not return FAILED when
>> calling scsi_try_to_abort() when cleaning up EH commands; if the driver
>> does not implement this function then no cleanup can be done, so calling
>> scsi_try_to_abort() is just us being nice.
>>
>> And I actually can see a problem with cleaning up EH commands if
>> scsi_try_to_abort() returns FAILED; then the LLDD has potential _two_
>> stale references, one for the original command and one for the command
>> send from SCSI EH.
>> The only way I would imagine this ever worked was by _reusing_ the
>> references to the original command, effectively sending the TMF with the
>> same credentials the original SCSI command had.
>> If a driver (for whatever reason) does _not_ do this things will fall
>> apart indeed.
>>
>> However, this was always a problem with SCSI EH; even with the original
>> codepath we would have this problem, so I don't think it's a problem
>> with this patchset.
>>
>> Nevertheless, I'll be adding a fix for eh_try_to_abort() in the context
>> of cleaning up EH commands.
>>
> 
> I slept over this a night or two and then I remembered that to get to
> this point in the first place, at least one eh_XXX callback must have
> returned SUCCESS for the command that is reused to send the EH command.
> So the original reference to it should be forgotten already, if not,
> then that is indeed a LLD bug.
> 
> That makes it much less troubling. But then again, sorry to say, but
> that still leaves me with one objection:
> 
> When you ignore the FAIL return for the abort, it opens up the
> possibility to have an unrelated EH-Command completion being triggered
> from a previous EH-Command reference.
> 
> Lets say we have a command A for LUN 1 behind Port α, command B for LUN
> 2 behind Port β; and lets assume both FAIL the abort, so they get to the
> stage where EH-Commands might be send. Both will be successfully 'freed'
> after a LUN-Reset is issued for both 1 and 2.
> 
> After each LUN-Reset we send a TUR, which is the EH-Command. If A_{TUR}
> times out and the abort fails (again), then the LLD might still have a
> reference to A_{TUR} and with that also to its overwritten scsi_done
> function-pointer.
> 
> When we later send B_{TUR}, A_{TUR} might concurrently complete, call
> the scsi_done function-pointer to scsi_eh_done and complete the
> host-wide EH-completion that was setup for B_{TUR} (shost->eh_action).
> This is possible because shost->eh_action has a value different from
> NULL for B_{TUR}.
> 
Hmm. Yes, that's true. But that can be fixed by setting some new
eh_eflag in the command to indicate a TUR timeout.

> And apart from this clear problem, I also find it still troubling that
> we call scsi_eh_restore_cmnd() before being sure that the reference to
> the EH-Command was forgotten. Because of that, we all of a sudden
> 'restore' a reference to a command that the LLD already has forgotten
> before, just via a different 'LLD-Object'. And fields like
> scsi_cmnd->result from A become writeable again, although the
> 'LLD-Object' should only point to A_{TUR}. And at the same time we
> 'forget' references to parts of A_{TUR} that we queued that command
> with.. such as cmnd, cmnd_len, data_direction, ... . That is kinda the
> original point I complained about.
> 
Yeah, I see your point.

> All that was handled by the original code that escalated throughout the
> whole process, as ugly as it might be, before restoring the command and
> continuing with further possible EH-Commands. And yes, you are right,
> host-reset might also fail in the old code, leaving us essentially in
> the same mess. But then again, if host-reset fails, SCSI EH is pretty
> much lost anyway...
> 
Okay. So let's drop this patch until we've sorted this out.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
