From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 15 Mar 2013 14:41:23 +0100
Message-ID: <51432503.5000703@acm.org>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org> <514315F7.4010101@redhat.com> <5143183B.1070300@acm.org> <514321FD.7090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:49769 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CONl2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Mar 2013 09:41:28 -0400
In-Reply-To: <514321FD.7090507@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

On 03/15/13 14:28, Bryn M. Reeves wrote:
> On 03/15/2013 12:46 PM, Bart Van Assche wrote:
>> The SCSI EH keeps trying until all outstanding request have been
>> finished. Does lpfc_host_reset_handler() invoke scsi_done() for
>
> I don't think so (ends up calling lpfc_sli_cancel_iocbs() via
> lpfc_hba_down_post() after shutting down the mailbox) but I've not seen
> the EH escalate all the way to host reset in most of my testing -
> usually some time after reaching the bus reset remaining IOs timeout and
> the error bubbles up to device-mapper (all the cases I'm looking at are
> devices managed by a dm-multipath target).
>
> The problem is that getting to this stage can take a very long time -
> much longer than most cluster's node eviction timer for e.g. which is
> the source of much of the complaint about this behaviour.
>
>> outstanding requests ? If not, how about modifying
>> lpfc_host_reset_handler() such that it finishes all outstanding requests
>> if the remote port is not reachable ?
>
> I'm not sure how safe that is in this situation - James mentioned in the
> I_T nexus reset thread concerns about frames that could be delayed etc.
> in the fabric if the host unilaterally abandons IOs (not sure of the
> details for lpfc at this level).

How about using the value of scsi_cmnd.jiffies_at_alloc to finish only 
those SCSI commands in the host reset handler that exceeded a certain 
processing time ?

Bart.

