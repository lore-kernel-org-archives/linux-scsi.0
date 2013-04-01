From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Mon, 1 Apr 2013 16:51:13 -0400
Message-ID: <5159F341.2070005@emulex.com>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41626 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab3DAUvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Apr 2013 16:51:17 -0400
In-Reply-To: <51430C4A.7090308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

Hannes,

I'm finally going through this thread.  I'm a bit uncomfortable about 
making the rport state writeable.  The rport state is tightly tied to 
the driver's discovery engine, and I'm concerned about some of the 
callbacks firing, such as the rport_delete(), and the driver taking an 
action that isn't legit as the driver wasn't the one that called the 
fc_remote_port_delete() call.

I expect, at least in the lpfc driver, we would require a change to work 
with this. Although, we had to add an ugly internal reference counter 
mechanism so we didn't actually early-free structures, that may have 
saved your changing of this.

-- james  s


On 3/15/2013 7:55 AM, Hannes Reinecke wrote:
> On 03/14/2013 07:09 PM, Steffen Maier wrote:
>> Just for my understanding:
>> So this is a bit like writing 0 into the failed attribute of a
>> zfcp_port in sysfs (zfcp_sysfs_port_failed_store()) which forces a
>> port reopen recovery including a sequence of fc_remote_port_delete
>> and fc_remote_port_add?
> Sorta.
> This patch simulates the result of an RSCN where this remote port is 
> missing. So the fast_io_fail / dev_loss_tmo mechanism is triggered 
> (until further notice).
> It'll be reset with the next RSCN or by manually resetting the port 
> state.
>
>> If so, it sounds good to have this functionality for any FC LLD in
>> common code.
>
> That's why I posted this code :-)
> Rationale for this patch is a weird test case with brocade switches;
> there you can actually disable a _target_ port. So the port isn't
> reachable anymore but no RSCN is send.
> And the LLDD is forced into error recovery which'll take _ages_ as 
> each and every command send during error recovery will time out.
>
>> (And I can think about deprecating parts of zfcp code, next we could
>> consider the same for zfcp's forced LUN and adapter recovery or
>> maybe this already exists as sdev's writable state attribute and the
>> adapter recovery can be performed manually by walking all fc_rports
>> writing their port_state.)
>>
> I don't think the sdev 'state' attribute is useable here; it doesn't 
> trigger a rediscovery. You'd want to use 'rescan' here.
> But yeah, that would be one of the goals.
>
> Still waiting for some response to the patch, though.
> Testing has been successful on our side, plus I've posted
> a patchset for multipath-tools utilizing this patch.
>
> So it would be good if it could be included.
>
> James?
>
> Cheers,
>
> Hannes

