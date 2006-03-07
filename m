From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target and IO-throttling
Date: Tue, 07 Mar 2006 20:53:27 +0300
Message-ID: <440DC897.6080408@vlnb.net>
References: <44071BA4.3030808@vlnb.net> <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([195.208.234.171]:65450 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S1750817AbWCGRxg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 12:53:36 -0500
In-Reply-To: <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: linux-scsi@vger.kernel.org

Steve Byan wrote:
> 
> On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
> 
>> Could anyone advice how a SCSI target device can IO-throttle its  
>> initiators, i.e. prevent them from queuing too many commands, please?
>>
>> I suppose, the best way for doing this is to inform the initiators  
>> about the maximum queue depth X of the target device, so any of the  
>> initiators will not send more than X commands. But I have not found  
>> anything similar to that on INQUIRY or MODE SENSE pages. Have I  
>> missed something? Just returning QUEUE FULL status doesn't look to  be 
>> correct, because it can lead to out of order commands execution.
> 
> 
> Returning QUEUE FULL status is correct, unless the initiator does not  
> have any pending commands on the LUN, in which case you should return  
> BUSY. Yes, this can lead to out-of-order execution. That's why tapes  
> have traditionally not used SCSI command queuing.
> 
> Look into the unit attention interlock feature added to SCSI as a  
> result of uncovering this issue during the development of the iSCSI  
> standard.
> 
>> Apparently, hardware SCSI targets don't suffer from queuing  overflow 
>> and don't return all the time QUEUE FULL status, so the  must be a way 
>> to do the throttling more elegantly.
> 
> 
> No, they just have big queues.

Thanks for the reply!

Things are getting clearer for me now, but still there are few things 
that are not very clear for me. Hope, they won't require too long 
answers. I'm asking, because we in SCST project (SCSI target mid-level 
for Linux + some target drivers, http://scst.sourceforge.net) must 
emulate correct SCSI target device behavior under any IO load, including 
extreme high one.

  - Can you estimate, please, how big target commands queue should be in 
order to initiators will never receive QUEUE FULL status? Considering 
case that initiators are Linux-based and each has a separate and 
independent queue.

  - The queue could be so big that the last command in it could not been 
processed before the initiator's timeout, then, after the timeout was 
hit, the initiator would start issuing ABORTs for the timeouted command. 
Is it OK behavior? Or rather misconfiguration (of who, initiator or 
target?)? Does the initiator in such situation supposed to reissue the 
command after the preceding ones finished, or behave somehow else? 
Apparently, ABORTs must hit the performance at the similar degree as too 
many QUEUE FULLs, if not more.

Seems, we should setup on the target queue with virtually unlimited size 
and, if an initiator is dumb enough to queue so much commands that there 
will be timeouts, then it will be its problem and duty to rule the 
situation without performance loss. Does it looks OK?

Thanks,
Vlad

> Regards,
> -Steve


