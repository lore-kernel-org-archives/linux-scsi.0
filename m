From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 5 Apr 2013 11:14:39 -0400
Message-ID: <515EEA5F.3010709@emulex.com>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org> <514315F7.4010101@redhat.com> <5143183B.1070300@acm.org> <514321FD.7090507@redhat.com> <51432503.5000703@acm.org> <51436DB0.8030406@cs.wisc.edu> <514372DC.40709@acm.org> <5146BDBD.3070408@suse.de> <5159F6E6.9030900@emulex.com> <515D1D2F.7050007@suse.de>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:34875 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3DEPOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 11:14:42 -0400
In-Reply-To: <515D1D2F.7050007@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, "Bryn M. Reeves" <bmr@redhat.com>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <jbottomley@parallels.com>

I understand your points. But you will need to contact the different LLD 
maintainers to ensure receiving a devloss_tmo_callbk() on an rport they 
had not called fc_remote_port_delete() for.  I know there's work on my 
side to validate it's ok.  First glance was ok, but..

-- james s


On 4/4/2013 2:26 AM, Hannes Reinecke wrote:
> On 04/01/2013 11:06 PM, James Smart wrote:
>> I think lpfc survives your rport state change as : part of the lld
>> behavior on the callback, to clean up reference counts, is to abort
>> all i/o that is outstanding to the rport.   So the ref checking not
>> only protects lpfc from prematurely freeing a structure (my real
>> concern), but also just happens to abort all i/o.  We got lucky.
>>
>> I still believe the I_T_nexus reset is the right way to solve this.
>>
> Yes, but this would be an even more intrusive patch.
> And we would need to implement yet another callback into the LLDDs
> which need to be implemented there, too.
>
> But for this to make any sense we would need to revamp the scsi
> error handler, as the current problem is that error recovery takes
> too long. Adding yet another callback will make the escalation chain
> even longer.
>
> So yeah, in the long run I_T nexus reset is the correct way of doing
> things, but in the short term I would opt to make port_state
> writeable to simulate an I_T nexus reset.
>
> Cheers,
>
> Hannes

