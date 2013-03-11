From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Mon, 11 Mar 2013 14:04:23 -0400
Message-ID: <b5c314a7-83ce-469e-8a59-7e35bd92b2b6@CMEXHTCAS2.ad.emulex.com>
References: <1355214219-17343-1-git-send-email-hare@suse.de> <5138E84B.8030803@cs.wisc.edu> <5138F4DF.9010906@tributary.com> <5138F67D.3070703@cs.wisc.edu> <5138FA21.8000000@tributary.com> <513E0EE6.7010909@suse.de>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:20839 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3CKSE1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Mar 2013 14:04:27 -0400
In-Reply-To: <513E0EE6.7010909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeremy Linton <jlinton@tributary.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Robert Elliot <elliot@hp.com>, "Smart, James" <James.Smart@Emulex.Com>


On 3/11/2013 1:05 PM, Hannes Reinecke wrote:
> On 03/07/2013 09:35 PM, Jeremy Linton wrote:
>> On 3/7/2013 2:20 PM, Mike Christie wrote:
>>> On 03/07/2013 02:13 PM, Jeremy Linton wrote:
>>>>     For lpfc, you never get to the code. Or rather when I was 
>>>> testing it, I
>>>> couldn't find any way to propagate an error beyond the initial
>>>> lpfc_reset_flush_io_context() call in lpfc_device_reset_handler().
>>>>
>>>>     That call pretty much always returns success indpependent of 
>>>> the remote
>>>> device because the firmware acks the context clear aborts, 
>>>> resulting in the
>>>> outstanding iocb count being zero (independent of both the mid 
>>>> layer status
>>>> and the actual device state).
>>>>
>>>
>>> Your lpfc patch fixes that right?
>>
>>     Yes. It allows the device reset to fail if the device doesn't 
>> respond to the
>> task mgmt request, or rejects it, etc.
>>
>>     It doesn't unjam the commands that get aborted by the 
>> flush_io_context() call.
>> Those have to depend on their timeouts. That is another patch...
>>
>>
>
> It's actually worse than that.
> lpfc_terminate_rport_io() calls lpfc_sli_abort_iocb(), which has this:
>
>
>          if (lpfc_is_link_up(phba))
>             abtsiocb->iocb.ulpCommand = CMD_ABORT_XRI_CN;
>         else
>             abtsiocb->iocb.ulpCommand = CMD_CLOSE_XRI_CN;
>
>         /* Setup callback routine and issue the command. */
>         abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
>         ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
>                           abtsiocb, 0);
>         if (ret_val == IOCB_ERROR) {
>             lpfc_sli_release_iocbq(phba, abtsiocb);
>             errcnt++;
>             continue;
>         }
>
>
> Ie we're calling into firmware and waiting for an async event telling 
> us that the command has been aborted (ideally).
> What I would like is some kind of synchronous call here, which would
> guarantee us that we won't run into use-after-free issues.
>
> Also 'lpfc_is_link_up' is clearly deficient here as the link itself 
> most likely is up, it's the I_T Nexus which is not.
>
> James, is it safe to use 'CMD_CLOSE_XRI_CN' even when the link is up?

No, it's not safe.  The ABORT, which sends an ABTS, is mandated so that 
the other end and ourselves maintain proper (unique) exchange id 
state.   CLOSE sends no link traffic - but can only be used if the login 
is broken (e.g. there's a different mechanism that communicated 
termination of exchange states).   I don't believe I can trust the logic 
in the OS about frames laying in wait in the fabric (maybe sent earlier, 
delayed at a switch, delivered after os thinks nexus is gone), so driver 
needs to terminate them properly.


>
> Which makes me wonder, how _exactly_ is I_T nexus reset supposed to 
> work? After all, we're trying to tell the target port that we cannot 
> talk to it anymore, right?
> Which has some hurdles, conceptually ...
> So from my POV I_T nexus reset can only be implemented on the 
> _initiator_ side, disregarding any target implementation.
> (which would be pointless anyway).
>
> Hmm. Probably have to ask T10 for clarification. Robert, any insights?


The I_T nexus reset should be a FC transport implicit logout call to the 
LLDD.  E.g. this becomes a transport-specific action on what it means to 
break the I_T nexus, which for FC, is to terminate the login.   This 
logout call allows the driver to do all the implicit work to kill 
exchange contexts and allows it to adjust the state of the target in 
it's FC discovery engine.  Question is - should the driver re-login ?   
Typically, this would be driven by a RSCN, which I'm guessing for this 
scenario, would not be occurring. If you knew it would, you could let 
the driver respond to the RSCN and re-login later.   If there's no RSCN, 
then I would assume we put a heartbeat into the transport to retry login 
(to a WWPN/WWNN basis - remembered from the I_T nexus reset) with the 
LLDD - a new interface as well - call it "establish I_T_nexus".

In lpfc's case - the Logout would allow the driver to take the CLOSE_XRI 
case, giving you the speed/asynchronicity you desire. Reuse of scsi job 
structures still can't occur until the driver returns then via the 
completion routines (as DMA related to them must be cancelled within the 
card by the ABORT/CLOSE commands - even if we know there shouldn't be 
something to DMA).

-- james s


>
> Cheers,
>
> Hannes
>
>

