From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI LLDs, the SCSI error handler and host resource lifetime
Date: Wed, 21 Nov 2012 13:26:35 +0100
Message-ID: <50ACC87B.5010401@acm.org>
References: <50AB9286.8040403@acm.org> <50AC808D.1060700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:43232 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2KUM0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2012 07:26:38 -0500
In-Reply-To: <50AC808D.1060700@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11/21/12 08:19, Hannes Reinecke wrote:
> On 11/20/2012 03:24 PM, Bart Van Assche wrote:
>> If I interpret the SCSI error handler source code correctly then
>> scsi_unjam_host() may proceed concurrently with scsi_remove_host().
>> This means that the LLD eh_abort_handler callback may get invoked after
>> scsi_remove_host() finished. At least the SRP initiator (ib_srp) cleans
>> up resources necessary for aborting commands as soon as
>> scsi_remove_host() returns. That looks like a race condition to me. As
>> far as I can see it is only safe to clean up such resources after the
>> EH thread has been stopped. Any opinions about adding an additional
>> callback for this purpose in struct scsi_host_template ?
>>
>> Note: it doesn't look like a good idea to me to let scsi_remove_host()
>> wait until error recovery has finished since scsi_remove_host() may get
>> invoked from the context of a workqueue. If any work gets queued on the
>> same workqueue related to SCSI error handling letting scsi_remove_host()
>> wait for the error handler to finish might result in a deadlock.
>>
>> The patch below is a request for comments patch that does not only add a
>> callback to struct scsi_host_template but also fixes a (hard to trigger)
>> race condition in ib_srp: avoid that ib_destroy_cm_id() frees the IB RC
>> connection while srp_send_tsk_mgmt() is using it.
>>
> Hmm.
> This would still mean that the eh thread will run until finished.
> Which can take _A LOT_ of time (we're speaking hours here).
> I would rather have an additional return code in the various
> scsi_try_XXX functions to terminate the loop quickly.

How about combining both approaches ? I think the additional callback is 
needed anyway to prevent the race condition explained above. Making the 
SCSI EH stop quicker after scsi_remove_host() has been invoked looks 
like a good idea to me but I'm not sure that change alone is sufficient.

Bart.

