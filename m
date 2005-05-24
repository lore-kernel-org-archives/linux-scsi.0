From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Tue, 24 May 2005 14:01:04 -0700
Message-ID: <42939610.3070104@cs.wisc.edu>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49799 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262072AbVEXVBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 17:01:12 -0400
In-Reply-To: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Alex Aizman wrote:
> James Bottomley wrote:
> 
>>On Sat, 2005-05-21 at 14:39 -0700, Mike Christie wrote:
>>
>>>`-- session1
>>>    |-- connection1:0
>>>    `-- target1:0:0
>>>        |-- 1:0:0:0
>>
>>I understand that session1 represents the physical connection 
>>between the target and the initiator, but what's connection1:0?
> 
> 
> It's a leading transport connection of the session1 (above). Quoting the
> spec (http://www.faqs.org/rfcs/rfc3720.html):
> 
>    - According to [SAM2], the I_T nexus is a relationship
>      between a SCSI Initiator Port and a SCSI Target Port.  For iSCSI,
>      this relationship is a session, defined as a relationship between
>      an iSCSI Initiator's end of the session (SCSI Initiator Port) and
>      the iSCSI Target's Portal Group.  
> 
> The session itself is not a "physical connection"; it aggregates one or more
> transport connections between a given SCSI Initiator Port and a SCSI Target
> Port. There is always at least one (leading) connection.
> 

So just to be clear, open-iscsi can support multiple connections per 
session. Do you want us to completely remove this feature for mainline? 
I know you and christoph have given me this answer many times before, 
but not seeing a reply to Nicholas's question about just disabling may 
have created some doubt as to the extent people have to go? Since 
open-iscsi pushed the connection management code to userspace, removing 
MCS from the driver will not be too terrible a job for us though.

The connection dir for single connection sessions though is just a nice 
way to export the kernel structure's info and have it also reflect the 
iSCSI RFC's definitions at the same time. For sfnet we used to throw 
everything in one dir becuase it did not have a connection structure so 
it simplified refcounting.



