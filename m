From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Fri, 3 Mar 2006 13:07:41 -0500
Message-ID: <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com>
References: <44071BA4.3030808@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:12242 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1161005AbWCCSHr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 13:07:47 -0500
In-Reply-To: <44071BA4.3030808@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org


On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:

> Could anyone advice how a SCSI target device can IO-throttle its  
> initiators, i.e. prevent them from queuing too many commands, please?
>
> I suppose, the best way for doing this is to inform the initiators  
> about the maximum queue depth X of the target device, so any of the  
> initiators will not send more than X commands. But I have not found  
> anything similar to that on INQUIRY or MODE SENSE pages. Have I  
> missed something? Just returning QUEUE FULL status doesn't look to  
> be correct, because it can lead to out of order commands execution.

Returning QUEUE FULL status is correct, unless the initiator does not  
have any pending commands on the LUN, in which case you should return  
BUSY. Yes, this can lead to out-of-order execution. That's why tapes  
have traditionally not used SCSI command queuing.

Look into the unit attention interlock feature added to SCSI as a  
result of uncovering this issue during the development of the iSCSI  
standard.

> Apparently, hardware SCSI targets don't suffer from queuing  
> overflow and don't return all the time QUEUE FULL status, so the  
> must be a way to do the throttling more elegantly.

No, they just have big queues.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


