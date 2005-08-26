From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 14:48:10 -0400
Message-ID: <430F63EA.7020400@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>	 <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com>	 <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>	 <430F46AA.2050305@adaptec.com> <1125076960.5079.61.camel@mulgrave> <430F5C8F.3030708@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:7083 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030184AbVHZSsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 14:48:21 -0400
In-Reply-To: <430F5C8F.3030708@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <jejb@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> On 08/26/05 13:22, James Bottomley wrote:
> 
>>On Fri, 2005-08-26 at 12:43 -0400, Luben Tuikov wrote:
>>
>>
>>>>A move away from forced HCIL addressing would be a good thing.
>>>>
>>>>However, its impossible to completely move away from addressing, as 
>>>>userspace and the SCSI core need ways to route CDBs to devices based on 
>>>>address.
>>>
>>>They can use _anyone_ label in the label list of the LU.
>>
>>
>>I think what Jeff means is that the mid-layer needs to know which LLD to
>>send the CDB to.
> 
> 
> No, I thought he meant about user space apps, *NOT* SCSI Core.
> 
> Since, the transport found the device on the domain (NOT LU!)
> it then calls SCSI Core to register it.
> 
> So you have:
> 
> task->scsi_domain_device->lldd->lldd_execute_task(task).
> 
> 
>>This is the routing information (and is really just
>>the host number).
> 
> 
> No host numbers, no routing information.  This is all
> transparent to SCSI Core, and NONE of its business.


Routing is an essential part of the SCSI core's duties.

The SCSI core is the resource manager responsible for routing messages 
[CDBs] to/from LLDs based on <scsi-specific device address>.  This 
includes resolution of kernel-specific identifiers (device major/minor, 
etc.) into <s.s.d.a.>.  This also includes direct use of 
userspace-provided identifiers as <s.s.d.a.>, such as via SG_IO ioctl.

Moving away from HCIL requires a lot of thought, including thinking 
about userland app breakage -- a big deal in Linux.

Ask yourself where all these HCIL-addressed CDBs come from...  each one 
of those CDB submittors must be updated from HCIL addressing/routing to 
transport-specific.

	Jeff



