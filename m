From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon dev_loss_tmo
Date: Tue, 21 Apr 2009 16:52:59 -0500
Message-ID: <49EE403B.8060005@cs.wisc.edu>
References: <20090409130439.042ff514@rwuerthntp> <49EE3E0D.7000403@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010009040808080007040804"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57583 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZDUVxK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 17:53:10 -0400
In-Reply-To: <49EE3E0D.7000403@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com

This is a multi-part message in MIME format.
--------------010009040808080007040804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Christie wrote:
> Ralph Wuerthner wrote:
>> Mike Christie wrote:
>>> James Smart wrote:
>>>> Pre-emptively terminate i/o on the rport if dev_loss_tmo has fired.
>>>> The desire is to terminate everything, so that the i/o is cleaned up
>>>> prior to the sdev's being unblocked, thus any outstanding 
>>>> timeouts/aborts
>>>> are avoided.
>>>>
>>>> Also, we do this early enough such that the rport's port_id field is
>>>> still valid. FCOE libFC code needs this info to find the i/o's to
>>>> terminate.
>>>>
>>>> -- james s
>>>>
>>>>  Signed-off-by: James Smart <james.smart@emulex.com>
>>>>
>>>>  ---
>>>>
>>>>  scsi_transport_fc.c |   11 ++++++++++-
>>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>>
>>>>
>>>> diff -upNr a/drivers/scsi/scsi_transport_fc.c 
>>>> b/drivers/scsi/scsi_transport_fc.c
>>>> --- a/drivers/scsi/scsi_transport_fc.c    2008-10-18 
>>>> 10:32:52.000000000 -0400
>>>> +++ b/drivers/scsi/scsi_transport_fc.c    2008-12-05 
>>>> 12:13:54.000000000 -0500
>>>> @@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_str
>>>>      rport->port_state = FC_PORTSTATE_NOTPRESENT;
>>>>      rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
>>>>  
>>>> +    /*
>>>> +     * Pre-emptively kill I/O rather than waiting for the work queue
>>>> +     * item to teardown the starget. (FCOE libFC folks prefer this
>>>> +     * and to have the rport_port_id still set when it's done).
>>>> +     */
>>>> +    spin_unlock_irqrestore(shost->host_lock, flags);
>>>> +    fc_terminate_rport_io(rport);
>>>> +
>>>> +    BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
>>>> +
>>> I think we could this this bug_on or we might hit a problem below 
>>> where this thread is changing the port_id but some other thread is 
>>> calling fc_remote_port_add and changging the port id.
>>>
>>> I think the problem is that fc_remote_port_add only calls 
>>> fc_flush_work which flushes the fc_host work_q:
>>>
>>>
>>> struct fc_rport *
>>> () (struct Scsi_Host *shost, int channel,
>>>          struct fc_rport_identifiers  *ids)
>>> {
>>>          struct fc_internal *fci = to_fc_internal(shost->transportt);
>>>          struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
>>>          struct fc_rport *rport;
>>>          unsigned long flags;
>>>          int match = 0;
>>>
>>>          /* ensure any stgt delete functions are done */
>>>          fc_flush_work(shost);
>>>
>>>
>>> But fc_timeout_deleted_rport dev_loss_work is running on the 
>>> devloss_work_q.
>>>
>>> So if fc_timeout_deleted_rport grabs the host lock first, it will set 
>>> the port state to FC_PORTSTATE_NOTPRESENT, then drop the lock.
>>>
>>> Once fc_timeout_delete_rport drops the lock, fc_remote_port_add could 
>>> have already passed the fc_flush_work() call because there was 
>>> nothing on it. fc_remote_port_add would then drop down to the list 
>>> search on the bindings array and see the remote port. It would then 
>>> start setting the port state, id and port_name and node_name, but at 
>>> the same time, because the host lock no longer guards it, 
>>> fc_timedout_deleted_rport could be fiddling with the same fields and 
>>> we could end up a mix of values or it could be running over the BUG_ON.
>>>
>>> Is that right?
>>>
>>> If so do we just want to flush the devloss_work_queue in 
>>> fc_remote_port_add?
>>>
>>>
>>>
>>>>      /* remove the identifiers that aren't used in the consisting 
>>>> binding */
>>>>      switch (fc_host->tgtid_bind_type) {
>>>>      case FC_TGTID_BIND_BY_WWPN:
>>>> @@ -3035,7 +3045,6 @@ fc_timeout_deleted_rport(struct work_str
>>>>       * went away and didn't come back - we'll remove
>>>>       * all attached scsi devices.
>>>>       */
>>>> -    spin_unlock_irqrestore(shost->host_lock, flags);
>>>>  
>>>>      scsi_target_unblock(&rport->dev);
>>>>      fc_queue_work(shost, &rport->stgt_delete_work);
>>>>
>>
>> One of our tester hit the problem Michael describes above: right after
>> releasing the shost->host_lock lock in fc_timeout_deleted_rport() the
>> remote port was rediscovered by the LLDD (in our case zfcp),
>> fc_remote_port_add() was called and BUG_ON() triggered.
>>
>> But flushing the devloss_work_queue in fc_remote_port_add() won't help
>> either because it still would be possible that right after the
>> flush_workqueue() call a timer could trigger and 
>> fc_timeout_deleted_rport()
> 
> 
> What timer could that be? Only the dev_loss_work delayed work calls 
> fc_timeout_deleted_rport.
> 
> Are you thinking about fc_rport_final_delete?
> 
> If you do the
>                 if (!cancel_delayed_work(&rport->dev_loss_work))
>                         fc_flush_devloss(shost);
> 
> sequence we should be ok I think, because after that point it should 
> have either been canceled or the work has completed.
> 

I did this in the attached patch. It also will prevent drivers from 
having to worry about about if the terminate rport IO or dev loss 
callback is running at the same time fc_remote_port_add is run.

--------------010009040808080007040804
Content-Type: text/plain;
 name="flush-everything.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="flush-everything.patch"

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a152f89..a45c5ed 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2564,6 +2564,10 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	/* ensure any stgt delete functions are done */
 	fc_flush_work(shost);
 
+	/* ensure dev loss or fast io fail are done */
+	if (!cancel_delayed_work(&rport->dev_loss_work))
+		fc_flush_devloss(shost);
+
 	/*
 	 * Search the list of "active" rports, for an rport that has been
 	 * deleted, but we've held off the real delete while the target

--------------010009040808080007040804--
