From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 15 Mar 2013 13:51:28 -0500
Message-ID: <51436DB0.8030406@cs.wisc.edu>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org> <514315F7.4010101@redhat.com> <5143183B.1070300@acm.org> <514321FD.7090507@redhat.com> <51432503.5000703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42810 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab3COSzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 14:55:54 -0400
In-Reply-To: <51432503.5000703@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>

On 03/15/2013 08:41 AM, Bart Van Assche wrote:
> On 03/15/13 14:28, Bryn M. Reeves wrote:
>> On 03/15/2013 12:46 PM, Bart Van Assche wrote:
>>> The SCSI EH keeps trying until all outstanding request have been
>>> finished. Does lpfc_host_reset_handler() invoke scsi_done() for


It does not really matter at that point for the scsi command timeout
case. When blk_complete_request is called by scsi_done, it will see the
command has timed out and so it will not be processed by that normal
completion path. The scsi eh basically owns the completion processing of
the command once it has timed out.

For the cleanup when the port is not reachable you had suggested is what
Hannes is proposing in the I_T nexus reset patch. The problem is making
sure that if the driver/class returns SUCCESS or FAST_IO_FAIL then they
do not touch the scsi cmnd struct again.

>>
>> I don't think so (ends up calling lpfc_sli_cancel_iocbs() via
>> lpfc_hba_down_post() after shutting down the mailbox) but I've not seen
>> the EH escalate all the way to host reset in most of my testing -
>> usually some time after reaching the bus reset remaining IOs timeout and
>> the error bubbles up to device-mapper (all the cases I'm looking at are
>> devices managed by a dm-multipath target).
>>
>> The problem is that getting to this stage can take a very long time -
>> much longer than most cluster's node eviction timer for e.g. which is
>> the source of much of the complaint about this behaviour.
>>
>>> outstanding requests ? If not, how about modifying
>>> lpfc_host_reset_handler() such that it finishes all outstanding requests
>>> if the remote port is not reachable ?
>>
>> I'm not sure how safe that is in this situation - James mentioned in the
>> I_T nexus reset thread concerns about frames that could be delayed etc.
>> in the fabric if the host unilaterally abandons IOs (not sure of the
>> details for lpfc at this level).
> 
> How about using the value of scsi_cmnd.jiffies_at_alloc to finish only
> those SCSI commands in the host reset handler that exceeded a certain
> processing time ?
> 

We basically do this now. When a scsi command times out the scsi layer
blocks the host from processing new commands and waits for all
outstanding commands to either finish normally or timeout. When all
commands have finished or timedout, then we start the scsi eh code. So,
by the time we have go to the scsi eh callbacks we are in a state where
all the commands being processed by the eh have exceeded a certain
processing time.

If you mean you want to drop the block and wait part, then I think it
could speed things up to do the abort callbacks while other IO is
running (as long as the driver can support it). However if the abort
fails and you need to escalate to operations like resets which interfere
with multiple commands, then the driver/scsi-ml does not have much
choice in what it does cleanup wise. There would be no point in checking
the jiffies_at_alloc. The commands that are going to be affected by the
tmf or host reset operation must be returned to the scsi-ml for retries
or failure upwards.
