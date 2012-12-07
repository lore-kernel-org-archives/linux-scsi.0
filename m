From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Fri, 7 Dec 2012 14:58:29 -0500
Message-ID: <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:32951 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab2LGT6k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 14:58:40 -0500
In-Reply-To: <50C23C5A.9090907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <jbottomley@parallels.com>



On Fri, 7 Dec 2012, Mike Christie wrote:

> On 12/07/2012 08:51 AM, Hannes Reinecke wrote:
>> 'Bus reset' is not really applicable to FibreChannel, as
>> the concept of a bus doesn't apply. Hence all FC LLDD
>> simulate a 'bus reset' by sending a target reset to each
>> attached remote port, causing error handling to spill
>> over to unaffected devices.
>>
>> This patch implements a 'I_T nexus reset' handler,
>> which attempts to reset the I_T nexus to the remote
>> port. This way only the affected remote ports are
>> reset; other ports are left untouched.
>
> Is the I_T nexus reset we are doing in this patch supposed to be the
> same one defined in SAM? Was the I_T nexus reset TMF added to SAM at the
> same time the target reset one was removed? In SAM 4 and 5 there is no
> target reset anymore is there?
>
> I think we should just kill the bus reset use from the FC drivers. Add a
> new I_T nexus reset callout to the scsi_host_template or to the
> scsi_transport_template. Then have scsi-ml call just either target reset
> eh callout or I_T nexus eh reset callout depending on what the target
> supports.
>
> To figure out what the target supports could we do a REPORTED SUPPORTED
> TASK MANAGEMENT FUNCTION command. If the target supports that command
> and reports that the target supports the I_T nexus reset TMF then call
> that eh callback, else drop down to older target reset eh callback.
>
> It seems that if we do I_T nexus reset we do not need to also do a
> target reset do we?
>

It would be good to have a specific I_T nexus reset callout in either the
host or transport so we can clean things up.

Currently in the bus reset handler after we perform all the
target resets we wait for all the associated DMA activity to clear up
before we return from the bus_reset handler.  It would be good to have
the same capability in a new I_T nexus reset handler as well.

Also, are there certain port types we wouldn't want to send this reset to
such as tape?

>
>
>> @@ -3266,8 +3271,8 @@ fc_timeout_fail_rport_io(struct work_struct *work)
>>      if (rport->port_state != FC_PORTSTATE_BLOCKED)
>>              return;
>>
>> -    rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
>>      fc_terminate_rport_io(rport);
>> +    rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
>>  }
>>
>
> What was the reason for moving this? For the eh case in this patch was
> it causing IO to be failed with DID_TRANSPORT_FAILFAST when we wanted it
> failed with some other error.
>
>
>

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

