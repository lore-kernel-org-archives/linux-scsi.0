From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SCSI target and IO-throttling
Date: Fri, 03 Mar 2006 19:47:05 +0100
Message-ID: <44088F29.5030009@s5r6.in-berlin.de>
References: <44071BA4.3030808@vlnb.net> <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:8841 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1161025AbWCCStL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 13:49:11 -0500
In-Reply-To: <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

Steve Byan wrote:
> On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
>> Could anyone advice how a SCSI target device can IO-throttle its  
>> initiators, i.e. prevent them from queuing too many commands, please?
>>
>> I suppose, the best way for doing this is to inform the initiators  
>> about the maximum queue depth X of the target device,
[...]
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
[...]
> No, they just have big queues.

Depending on the the transport protocol, the problem of queue depth at 
the target may not even exist in the first place. This is the case with 
SBP-2 where the queue of command blocks resides at the initiator.
-- 
Stefan Richter
-=====-=-==- --== ---==
http://arcgraph.de/sr/
