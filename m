From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]qla4xxx:Add support for Async Message PDUs [REPOST with
 fixes]
Date: Thu, 01 May 2008 09:59:08 -0500
Message-ID: <4819DABC.4070501@cs.wisc.edu>
References: <1208551487.5159.5.camel@d5102avq18960.qlogic.org>	 <480E1063.2060308@cs.wisc.edu>	 <1209052918.6212.4.camel@d5102avq18960.qlogic.org>	 <4810B818.8040301@cs.wisc.edu>	 <1209151382.6212.21.camel@d5102avq18960.qlogic.org>	 <48135B59.9080103@cs.wisc.edu> <1209580554.18057.15.camel@d5102avq18960>	 <4818C721.9090701@cs.wisc.edu>  <4818CA4D.3040204@cs.wisc.edu> <1209602162.20166.9.camel@d5102avq18960>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48109 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbYEAO7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2008 10:59:16 -0400
In-Reply-To: <1209602162.20166.9.camel@d5102avq18960>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> On Wed, 2008-04-30 at 14:36 -0500, Mike Christie wrote:
>> Mike Christie wrote:
>>> David C Somayajulu wrote:
>>>> +        }
>>>> +        if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e) {
>>>> +            /* induce rescan */
>>>> +            iscsi_block_session(ddb_entry->sess);
>>>> +            iscsi_unblock_session(ddb_entry->sess);
>>>> +        }
>>> I think I was wrong off list. We could actually just call 
>>> iscsi_unblock_session, but we do not know the state of the session do 
>>> we? If we got a event that indicated the session was failed could we 
>>> have a block queued up and this would reverse it by accident?
>>>
>>> I was thinking that because qla4xxx_process_aen is called before this we 
>>> could just check the ddb state, but we can call iscsi_block_session from 
>>> the interrupt handler to queue up a block so I think that could race 
>>> with the unblock call here.
>> Maybe to handle the race we do not want to call qla4xxx_mark_device_busy 
>> when we get SCS_TIMEOUT. If we get a ddb aen then could we just wait for 
>> that and all those events would be serialized through the dpc thread?
>>
>> What does SCS_TIMEOUT mean?
> I think the driver on receiving the Async Message PDU of type
> ISCSI_ASYNC_MSG_SCSI_EVENT, should first retrieve the DDB state. If the
> session is still not active, it should block it. If the DDB state

You should not need to block it though. qla4xxx_process_aen will have 
done this already when it set the ddb state, wouldn't it? I am saying if 
the ddb state indicates that it is not active then the session should be 
in the blocked state by the time we get to handling the iscsi async event.


> indicates the session is active, then call iscsi_unblock_session() if
> rescan is needed. What do you think of this solution ?
> 
> SCS_TIMEOUT is generated when there is a transport layer timeout for one
> of the PDUs issued as result of an IOCB.
> 

Do you need some locking or something then? If the dpc thread is about 
to check the ddb state to handle the iscsi async pdu like we said above, 
then we get a SCS_TIMEOUT, could the dpc thread read the ddb state and 
see a good ddb state, then the SCS_TIMEOUT handling would set the state 
to DDB_STATE_MISSING and queue a block. The dpc thread would then queue 
a unblock early?

