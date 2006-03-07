From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Tue, 7 Mar 2006 13:19:19 -0500
Message-ID: <2FBC50BB-5536-4E6F-9D02-7E9AE7174368@egenera.com>
References: <44071BA4.3030808@vlnb.net> <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com> <440DC897.6080408@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:64992 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751413AbWCGSTZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 13:19:25 -0500
In-Reply-To: <440DC897.6080408@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org


On Mar 7, 2006, at 12:53 PM, Vladislav Bolkhovitin wrote:

> Steve Byan wrote:
>> On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
>>> Could anyone advice how a SCSI target device can IO-throttle its   
>>> initiators, i.e. prevent them from queuing too many commands,  
>>> please?
>>>
>>> I suppose, the best way for doing this is to inform the  
>>> initiators  about the maximum queue depth X of the target device,  
>>> so any of the  initiators will not send more than X commands. But  
>>> I have not found  anything similar to that on INQUIRY or MODE  
>>> SENSE pages. Have I  missed something? Just returning QUEUE FULL  
>>> status doesn't look to  be correct, because it can lead to out of  
>>> order commands execution.
>> Returning QUEUE FULL status is correct, unless the initiator does  
>> not  have any pending commands on the LUN, in which case you  
>> should return  BUSY. Yes, this can lead to out-of-order execution.  
>> That's why tapes  have traditionally not used SCSI command queuing.
>> Look into the unit attention interlock feature added to SCSI as a   
>> result of uncovering this issue during the development of the  
>> iSCSI  standard.
>>> Apparently, hardware SCSI targets don't suffer from queuing   
>>> overflow and don't return all the time QUEUE FULL status, so the   
>>> must be a way to do the throttling more elegantly.
>> No, they just have big queues.
>
> Thanks for the reply!
>
> Things are getting clearer for me now, but still there are few  
> things that are not very clear for me. Hope, they won't require too  
> long answers. I'm asking, because we in SCST project (SCSI target  
> mid-level for Linux + some target drivers, http:// 
> scst.sourceforge.net) must emulate correct SCSI target device  
> behavior under any IO load, including extreme high one.
>
>  - Can you estimate, please, how big target commands queue should  
> be in order to initiators will never receive QUEUE FULL status?  
> Considering case that initiators are Linux-based and each has a  
> separate and independent queue.

Do you have a per-target pool of resources for handing commands, or  
are the pools per-logical unit?

I'm not sure you could size the queue so that TASK_SET_FULL is never  
returned. Just accept the fact the the target must return  
TASK_SET_FULL or BUSY sometimes.

As a data-point, some modern SCSI disks support queue depths in the  
range of 128 to 256 commands.

>  - The queue could be so big that the last command in it could not  
> been processed before the initiator's timeout, then, after the  
> timeout was hit, the initiator would start issuing ABORTs for the  
> timeouted command. Is it OK behavior?

Well, it's the behavior implied by the SCSI standard; that is, on a  
timeout, the initiator should abort the command. If an initiator sets  
it's timeout to less than the queuing delay at the server, I wouldn't  
call that "OK behavior", but it's not the target's fault, it's the  
initiator's fault.

> Or rather misconfiguration (of who, initiator or target?)? Does the  
> initiator in such situation supposed to reissue the command after  
> the preceding ones finished, or behave somehow else?

I think it's up to the class driver to decide whether to retry a  
command after it times-out.

> Apparently, ABORTs must hit the performance at the similar degree  
> as too many QUEUE FULLs, if not more.

Much worse, I would think.

> Seems, we should setup on the target queue with virtually unlimited  
> size and, if an initiator is dumb enough to queue so much commands  
> that there will be timeouts, then it will be its problem and duty  
> to rule the situation without performance loss. Does it looks OK?

I don't think you need to pick an unlimited size. Something on the  
order of 128 to 512 commands should be sufficient. If you have  
multiple logical units, you could probably combine them in a common  
pool and somewhat reduce the number of command resources you allocate  
per logical unit, on the theory that they'll not all be fully  
utilized at the same time.


By the way, make sure you don't deadlock trying to obtain command- 
resources to return TASK_SET_FULL or BUSY to a command in the case  
where the pool of command-resources is exhausted. This is one of the  
tricky bits.


Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


