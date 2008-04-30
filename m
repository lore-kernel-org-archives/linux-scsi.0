From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]qla4xxx:Add support for Async Message PDUs [REPOST with
 fixes]
Date: Wed, 30 Apr 2008 14:36:45 -0500
Message-ID: <4818CA4D.3040204@cs.wisc.edu>
References: <1208551487.5159.5.camel@d5102avq18960.qlogic.org>	 <480E1063.2060308@cs.wisc.edu>	 <1209052918.6212.4.camel@d5102avq18960.qlogic.org>	 <4810B818.8040301@cs.wisc.edu>	 <1209151382.6212.21.camel@d5102avq18960.qlogic.org>	 <48135B59.9080103@cs.wisc.edu> <1209580554.18057.15.camel@d5102avq18960> <4818C721.9090701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46442 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbYD3Tgw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2008 15:36:52 -0400
In-Reply-To: <4818C721.9090701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

Mike Christie wrote:
> David C Somayajulu wrote:
>> +        }
>> +        if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e) {
>> +            /* induce rescan */
>> +            iscsi_block_session(ddb_entry->sess);
>> +            iscsi_unblock_session(ddb_entry->sess);
>> +        }
> 
> I think I was wrong off list. We could actually just call 
> iscsi_unblock_session, but we do not know the state of the session do 
> we? If we got a event that indicated the session was failed could we 
> have a block queued up and this would reverse it by accident?
> 
> I was thinking that because qla4xxx_process_aen is called before this we 
> could just check the ddb state, but we can call iscsi_block_session from 
> the interrupt handler to queue up a block so I think that could race 
> with the unblock call here.

Maybe to handle the race we do not want to call qla4xxx_mark_device_busy 
when we get SCS_TIMEOUT. If we get a ddb aen then could we just wait for 
that and all those events would be serialized through the dpc thread?

What does SCS_TIMEOUT mean?
