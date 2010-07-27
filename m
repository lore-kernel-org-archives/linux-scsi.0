From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/28] libfc: IO errors on link down due to cable unplug
Date: Tue, 27 Jul 2010 17:08:44 -0500
Message-ID: <4C4F58EC.8010009@cs.wisc.edu>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>	 <20100720221920.17116.59505.stgit@localhost.localdomain>	 <4C466986.5040801@cs.wisc.edu> <1280266320.31061.2590.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51203 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0G0WFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 18:05:08 -0400
In-Reply-To: <1280266320.31061.2590.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Robert Love <robert.w.love@intel.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, devel@open-fcoe.org

On 07/27/2010 04:32 PM, Vasu Dev wrote:
> On Tue, 2010-07-20 at 22:29 -0500, Mike Christie wrote:
>> On 07/20/2010 05:19 PM, Robert Love wrote:
>>> From: Vasu Dev<vasu.dev@intel.com>
>>>
>>> In this case, sync IO fails with EIO(5) errors as:-
>>>
>>> "Thread:1 System call error:5 - Input/output error (::pwrite() failed)".
>>>
>>> This is due to IO time out while libfc doing link down processing
>>> to block all rports and if timed out IO was at last retry
>>> attempt then it fails to user with EIO error followed by
>>> these log messages.
>>>
>>> [77848.612169] host2: rport bf0015: Delete port
>>> [77848.612221] host2: rport e10aef: work delete
>>> [77848.612232] host2: rport e10002: work event 3
>>> [77848.612422] sd 2:0:1:1: [sdi] Unhandled error code
>>> [77848.612426] sd 2:0:1:1: [sdi] Result: hostbyte=DID_ERROR
>>> driverbyte=DRIVER_OK
>>> [77848.612431] sd 2:0:1:1: [sdi] CDB: Write(10): 2a 00 00 00 11 20 00 00 20 00
>>> [77848.612445] end_request: I/O error, dev sdi, sector 4384
>>> [77848.612553] sd 2:0:1:2: [sdj] Unhandled error code
>>>
>>> To fix these EIO errors, such timed out incomplete IOs needs
>>> to be re-queued without counting retry attempt and this patch
>>> does that using DID_REQUEUE scsi code.
>>>
>>> Signed-off-by: Vasu Dev<vasu.dev@intel.com>
>>> Signed-off-by: Robert Love<robert.w.love@intel.com>
>>> ---
>>>    drivers/scsi/libfc/fc_fcp.c |    5 +++++
>>>    1 files changed, 5 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
>>> index a0a3ae7..61a1297 100644
>>> --- a/drivers/scsi/libfc/fc_fcp.c
>>> +++ b/drivers/scsi/libfc/fc_fcp.c
>>> @@ -1971,6 +1971,11 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
>>>    		break;
>>>    	}
>>>
>>> +	if (lport->state != LPORT_ST_READY&&   fsp->status_code != FC_COMPLETE) {
>>> +		sc_cmd->result = (DID_REQUEUE<<   16);
>>> +		FC_FCP_DBG(fsp, "Returning DID_REQUEUE to scsi-ml\n");
>>> +	}
>>> +
>>
>> If it is a tape command, you do not want to use DID_REQUEUE do you?
>>
>
> I wasn't sure of using DID_REQUEUE here and therefore I did RFC first at
> http://www.open-fcoe.org/pipermail/devel/2010-June/010360.html.  As I
> understand DID_REQUEUE would block the sdev and would do unconditional
> retry and now I see that is issue with tapes as you pointed above, so
> I'll remove its use here but help me understand use of DID_REQUEUE, I
> mean are LLLD expected to make additional checks before indicating
> DID_REQUEUE to scsi-ml ?


I think you would want to use it in case where you want to block the 
sdev and you know the IO had not started. So some drivers use it if they 
get an error the indicated the port/target rejected the IO before it 
even started and there might be a tmp resource issue.

>
>> You are using the fc class API to delete the rport in this scenario,
>> right?
>
> Yes.
>
>> If so normally I think you would use DID_TRANSPORT_DISRUPTED.
>> This is going to give you an error if it is the last retry like
>> DID_ERROR though.
>>
>
> Effectively both would do same, so changing DID_TRANSPORT_DISRUPTED
> won't change anything or perhaps I'm missing something here.

The behavior is the same, but the error code that gets logged is more 
clear I think.

>
>> It seems weird to try and work around the IO erorr in this case because
>> it is the last retry so it should fail. If the port keeps going down and
>> up, then with your patch you could keep retrying the IO forever.
>>
>
> I think last try should not fail due to link down if rports comes back
> before dev_loss_tmo or fast_io_fail_tmo, such IOs should get their last
> try attempt again once rport are back instead throwing IO error just
> before port is getting blocked, that is the whole purpose of rport block
> states.

Just to make sure we are on the same page. Didn't the command get a 
chance to run on its last retry, but the port came down while it was 
executing. I am just saying that should count as a try, but with your 
patch you are giving it another retry. So instead of 5 it gets 6. And 
actually you are throwing out retries for this case so it runs until it 
times out (times out in scsi_softirq_done).


If you want that behavior and people argee it is the right think to do 
then I think we should apply it to all drivers, so users can expect the 
same behavior. Use DID_TRANSPORT_DISRUPTED in the driver, but then in 
scsi_error.c change that to check for tape devices. In the non tape case 
then just always retry until the command times out (time out in 
scsi_softirq_done. I do not mean timeout like when the scsi eh runs).


If the command never got a chance to start, then forget all this. I am 
wrong and DID_REQUEUE is fine.


>
>> This isn't one of those races where you are blocking the rport, but the
>> IO keeps coming around so the retries are used really quickly right (the
>> driver looks like it has the fc class and internal state checks to
>> prevent this but I wanted to make sure).
>
> I'm trying to fix IO error due to failed last attempt on a IO just after
> link down and its rport yet to move to block state from pending rport
> event_work. The libfc already has checks once rport or lport no longer
> ready for new IO try and that is not an issue here. It is very rare case
> with very tiny time window as rport block, so I can replace DID_REQUEUE
> here by DID_IMM_RETRY and I verified that works, will that be okay ?

DID_IMM_RETRY has the exact same issues.


>
> This tiny time windows can be further reduced by use of wmb() on rport
> state change to block and lport getting out of ready since their states
> are checked w/o lock in queuecommand path. I can do that as separate
> patch only if needed and it really helps some corner case.
>

That is not really the issue.
