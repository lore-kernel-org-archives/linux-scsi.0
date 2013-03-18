From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Mon, 18 Mar 2013 16:54:10 -0500
Message-ID: <51478D02.5080404@tributary.com>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org> <514315F7.4010101@redhat.com> <5143183B.1070300@acm.org> <514321FD.7090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:55190 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab3CRVyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Mar 2013 17:54:14 -0400
In-Reply-To: <514321FD.7090507@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

On 3/15/2013 8:28 AM, Bryn M. Reeves wrote:
> On 03/15/2013 12:46 PM, Bart Van Assche wrote:
>> The SCSI EH keeps trying until all outstanding request have been 
>> finished. Does lpfc_host_reset_handler() invoke scsi_done() for
> 
> I don't think so (ends up calling lpfc_sli_cancel_iocbs() via 
> lpfc_hba_down_post() after shutting down the mailbox) but I've not seen the
> EH escalate all the way to host reset in most of my testing -
...
> The problem is that getting to this stage can take a very long time - much
> longer than most cluster's node eviction timer for e.g. which is the source
> of much of the complaint about this behaviour.

>> outstanding requests ? If not, how about modifying 
>> lpfc_host_reset_handler() such that it finishes all outstanding requests 
>> if the remote port is not reachable ?

	It does call the done() function on the outstanding command IOCBs after the
lpfc_reset_flush_io_context() call aborts them. The "problem" is that they are
returned with ScsiResult(DID_REQUEUE, 0) which basically queues them back to the
port as long as the port is still "up". Which results in the commands hanging
out until their timeouts expire (if the device isn't responding).

	If the device does resume after the reset, in the case of a tape device it is
possible corrupt the tape because the 2900's get trapped by the TUR in the eh
routines depending on which commands were hung. Take write for example, the
reset can result in a tape rewind, and when the write gets fired back at the
device the tape is at BOT and effectively erases all data already on the tape.
Whops!

	Also, as I stated elsewhere, in my testing its impossible to escalate beyond
the flush_io_context() in the lpfc_device_reset_handler driver because it always
returns true if the card firmware is responding.



