From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
Date: Fri, 17 Oct 2008 14:37:14 -0400
Message-ID: <48F8DB5A.1070606@redhat.com>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>	 <6416EE16C1AF1E4C86882867E4DD0FF602B1F971@CORPUSMX40B.corp.emc.com>	 <1224264890.3368.24.camel@localhost.localdomain>	 <6416EE16C1AF1E4C86882867E4DD0FF65CFD0F@CORPUSMX40B.corp.emc.com> <1224268412.3368.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYJQShR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 14:37:17 -0400
In-Reply-To: <1224268412.3368.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Levy_Jerome@emc.com, linux-scsi@vger.kernel.org, berthiaume_wayne@emc.com

James Bottomley wrote:
> On Fri, 2008-10-17 at 14:17 -0400, Levy_Jerome@emc.com wrote:
>   
>> The change was the addition of rq->flags = 0; the memset isn't mine.
>> Sorry about the whitespace -- I'm still a bit new at this. 
>>     
>
> That's OK.
>
> Documentation/SubmittingPatches
> Documentation/email-clients.txt
>
> contain useful information.
>
>   
>> As to why it's necessary, I've had boot-time oopses on two completely
>> different hosts -- one iSCSI, one FC -- which both resolved to exactly
>> the same code; bizarre values in rq->flags. The source seems to OR the
>> desired values in but never actually initializes rq->flags (the memset
>> initializes the CDB, not the flags variable), so I added the line to
>> do so. After testing the old module to confirm the oops still occurred
>> regularly, I installed the new code and have since (in over 100
>> reboots) been unable to reproduce the oops. 
>>     
>
> No, my point is that this was fixed by a memset to zero of the request
> in blk_rq_init() in 2.6.26 (so it fixed every other problem, not just
> the one in dm_emc).  I think the kernel you're testing is too old to see
> the generic fix (based on what the diff contained).
>
> James
>   
Of course, if you see this with a vendor specific (older) kernel, you 
can follow up with the vendor and log a bugzilla ticket for that kernel.

Ric

