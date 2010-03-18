From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Wed, 17 Mar 2010 23:33:35 -0500
Message-ID: <4BA1AD1F.5060605@cs.wisc.edu>
References: <20100309091848.4C7412BD8B@ochil.suse.de> <4B9657CD.6000805@emulex.com> <20100316130454.GA15772@schmichrtp.mainz.de.ibm.com> <4BA0A3A8.8050905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36014 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab0CREaK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 00:30:10 -0400
In-Reply-To: <4BA0A3A8.8050905@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/17/2010 04:40 AM, Hannes Reinecke wrote:
> Christof Schmitt wrote:
>> On Tue, Mar 09, 2010 at 09:14:37AM -0500, James Smart wrote:
>>> I don't ever expect to see large dev_loss_tmo values, but the patch is fine.
>>>
>>> Acked-by: James Smart<james.smart@emulex.com>
>>>
>>> -- james s
>>>
>>>
>>> Hannes Reinecke wrote:
>>>> The rport structure defines dev_loss_tmo as u32, which is
>>>> later multiplied with HZ to get the actual timeout value.
>>>> This might overflow for large dev_loss_tmo values. So we
>>>> should be better using u64 as intermediate variables here
>>>> to protect against overflow.
>>>>
>>>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> [...]
>>
>> I guess this is the intended use to prevent the dev_loss_tmo from
>> removing the SCSI devices:
>> http://git.kernel.org/?p=linux/kernel/git/hare/multipath-tools.git;a=commitdiff;h=b9903e2e8a6cdc5042897719fbae6c9346820bbf;hp=ed1dc6164fe530d146cfe65d4f99e44ec9b54b95
>>
>> But does this raise the question again how to run SCSI EH with remote
>> port failures?
>>
>> The SCSI FC LLDs call fc_block_scsi_eh to wait until the fc_rport
>> leaves the state FC_PORTSTATE_BLOCKED. This effectively prevents SCSI
>> devices from being taken offline when there is a command timeout and
>> the fc_rport is BLOCKED. With the large dev_loss_tmo, the dev_loss_tmo
>> never expires and a problem with a single remote port can block the
>> host error handler.
>>
> I was under the impression that terminate_rport_io() would cancel/terminate
> all outstanding I/O, while any new I/O would be blocked due to FC_PORTSTATE_BLOCKED.
>

terminate_rport_io kills outstanding IO when the fast io fail or dev 
loss tmo fires. If the fast io fail tmo fires, then oustanding io is 
killed by terminate_rport_io and new IO is fast failed because 
fc_terminate_rport_io  will unblock the rport devices (before getting 
called the ~FC_RPORT_FAST_FAIL_TIMEDOUT bit is set) and when IO is sent 
to the driver fc_remote_port_chkready will see the bit is set and return 
DID_TRANSPORT_FASTFAILED.

In the other mail, I was saying we should add a new device state for 
when the fast io fail timer fires (iscsi has something similar in the 
replacement/recovery timeout) that we could set the device to indicate 
that IO is going to get failed, but the device is not exactly offlined 
by the scsi eh, not blocked, and not deleted or canceled.


> A device would only be taken offline if the full error recovery is run,
> something we cannot do (reliably) if the path is down, so from that
> point of view it totally reasonable to defer the error recovery here.
>
> However, I'm curious as how one could get into that state while
> the port is blocked.
> The only way I can imagine is that an I/O has started before the
> port entered FC_PORTSTATE_BLOCKED, and would return (with error)
> before terminate_rport_io has been called.
> So eh would be delayed due to fc_block_scsi_eh().
> But I would have assumed that terminate_rport_io() would terminate
> even this failing I/O with DID_TRANSPORT_FAILFAST (or somesuch),
> thus avoiding proper eh altogether.
>

If the link goes down while the scsi eh is running we hit the problem 
Chrisof is describing. If you pulled a cable while the the abort handler 
was being called, then when you hit the drivers abort handler, and you 
would hit the block. The terminate_rport_io call from the fast io fail 
handling just fails the IO. There is nothing in the scsi eh to see that 
all cmds are now accounted for and that it can stop trying to unjam the 
host. You have to wait until dev loss tmo fires and that changes the 
rport port_state out of blocked.
