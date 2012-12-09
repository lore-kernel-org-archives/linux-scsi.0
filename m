From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Sun, 09 Dec 2012 17:19:56 -0600
Message-ID: <50C51C9C.3060003@cs.wisc.edu>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu> <50C4B0DA.9090904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46999 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2LIXVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Dec 2012 18:21:03 -0500
In-Reply-To: <50C4B0DA.9090904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <jbottomley@parallels.com>

On 12/09/2012 09:40 AM, Hannes Reinecke wrote:
> Am 12/07/2012 07:58 PM, schrieb Mike Christie:
>> On 12/07/2012 08:51 AM, Hannes Reinecke wrote:
>>> 'Bus reset' is not really applicable to FibreChannel, as
>>> the concept of a bus doesn't apply. Hence all FC LLDD
>>> simulate a 'bus reset' by sending a target reset to each
>>> attached remote port, causing error handling to spill
>>> over to unaffected devices.
>>>
>>> This patch implements a 'I_T nexus reset' handler,
>>> which attempts to reset the I_T nexus to the remote
>>> port. This way only the affected remote ports are
>>> reset; other ports are left untouched.
>>
>> Is the I_T nexus reset we are doing in this patch supposed to be the
>> same one defined in SAM? Was the I_T nexus reset TMF added to SAM at the
>> same time the target reset one was removed? In SAM 4 and 5 there is no
>> target reset anymore is there?
>>
>> I think we should just kill the bus reset use from the FC drivers. Add a
>> new I_T nexus reset callout to the scsi_host_template or to the
>> scsi_transport_template. Then have scsi-ml call just either target reset
>> eh callout or I_T nexus eh reset callout depending on what the target
>> supports.
>>
>> To figure out what the target supports could we do a REPORTED SUPPORTED
>> TASK MANAGEMENT FUNCTION command. If the target supports that command
>> and reports that the target supports the I_T nexus reset TMF then call
>> that eh callback, else drop down to older target reset eh callback.
>>
>> It seems that if we do I_T nexus reset we do not need to also do a
>> target reset do we?
>>
> Hmm. I would rather check the actual LLDDs if they do anything sensible
> for target reset.
> If not we sure can remove it.


I am not suggesting to remove the target reset support completely. I am
just asking if we want to only do one or the other depending on what the
target supports. I was saying it is not clear to me why we need to do
both when in SAM 4 and 5 target reset TMF support looks like it is removed.



> 
>>
>>
>>> @@ -3266,8 +3271,8 @@ fc_timeout_fail_rport_io(struct work_struct *work)
>>>       if (rport->port_state != FC_PORTSTATE_BLOCKED)
>>>           return;
>>>
>>> -    rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
>>>       fc_terminate_rport_io(rport);
>>> +    rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
>>>   }
>>>
>>
>> What was the reason for moving this? For the eh case in this patch was
>> it causing IO to be failed with DID_TRANSPORT_FAILFAST when we wanted it
>> failed with some other error.
>>
> I wanted to ensure that fc_terminate_rport_io() was run when checking
> FC_RPORT_FAST_FAIL_TIMEOUT.
> Without the move there is a race window between clearing the flag and
> calling fc_terminate_rport_io(), which one might trigger by just
> checking the flag.
> 

What code is this? I am not sure what you mean. fc_terminate_rport_io is
always going to get run. There does not seem to be checks in it for
FC_RPORT_FAST_FAIL_TIMEOUT.

