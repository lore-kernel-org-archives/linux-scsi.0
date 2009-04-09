From: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon
 dev_loss_tmo
Date: Thu, 9 Apr 2009 13:04:39 +0200
Message-ID: <20090409130439.042ff514@rwuerthntp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:62739 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZDILEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 07:04:43 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n39B4g1x082358
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 11:04:42 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n39B4gb03428362
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 12:04:42 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n39B4fpZ032080
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 12:04:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: michaelc@cs.wisc.edu

Mike Christie wrote:
> James Smart wrote:
> > Pre-emptively terminate i/o on the rport if dev_loss_tmo has fired.
> > The desire is to terminate everything, so that the i/o is cleaned up
> > prior to the sdev's being unblocked, thus any outstanding timeouts/aborts
> > are avoided.
> > 
> > Also, we do this early enough such that the rport's port_id field is
> > still valid. FCOE libFC code needs this info to find the i/o's to
> > terminate.
> > 
> > -- james s
> > 
> >  Signed-off-by: James Smart <james.smart@emulex.com>
> > 
> >  ---
> > 
> >  scsi_transport_fc.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > 
> > diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> > --- a/drivers/scsi/scsi_transport_fc.c	2008-10-18 10:32:52.000000000 -0400
> > +++ b/drivers/scsi/scsi_transport_fc.c	2008-12-05 12:13:54.000000000 -0500
> > @@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_str
> >  	rport->port_state = FC_PORTSTATE_NOTPRESENT;
> >  	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
> >  
> > +	/*
> > +	 * Pre-emptively kill I/O rather than waiting for the work queue
> > +	 * item to teardown the starget. (FCOE libFC folks prefer this
> > +	 * and to have the rport_port_id still set when it's done).
> > +	 */
> > +	spin_unlock_irqrestore(shost->host_lock, flags);
> > +	fc_terminate_rport_io(rport);
> > +
> > +	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
> > +
> 
> I think we could this this bug_on or we might hit a problem below where 
> this thread is changing the port_id but some other thread is calling 
> fc_remote_port_add and changging the port id.
> 
> I think the problem is that fc_remote_port_add only calls fc_flush_work 
> which flushes the fc_host work_q:
> 
> 
> struct fc_rport *
> () (struct Scsi_Host *shost, int channel,
>          struct fc_rport_identifiers  *ids)
> {
>          struct fc_internal *fci = to_fc_internal(shost->transportt);
>          struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
>          struct fc_rport *rport;
>          unsigned long flags;
>          int match = 0;
> 
>          /* ensure any stgt delete functions are done */
>          fc_flush_work(shost);
> 
> 
> But fc_timeout_deleted_rport dev_loss_work is running on the devloss_work_q.
> 
> So if fc_timeout_deleted_rport grabs the host lock first, it will set 
> the port state to FC_PORTSTATE_NOTPRESENT, then drop the lock.
> 
> Once fc_timeout_delete_rport drops the lock, fc_remote_port_add could 
> have already passed the fc_flush_work() call because there was nothing 
> on it. fc_remote_port_add would then drop down to the list search on the 
> bindings array and see the remote port. It would then start setting the 
> port state, id and port_name and node_name, but at the same time, 
> because the host lock no longer guards it, fc_timedout_deleted_rport 
> could be fiddling with the same fields and we could end up a mix of 
> values or it could be running over the BUG_ON.
> 
> Is that right?
> 
> If so do we just want to flush the devloss_work_queue in fc_remote_port_add?
> 
> 
> 
> >  	/* remove the identifiers that aren't used in the consisting binding */
> >  	switch (fc_host->tgtid_bind_type) {
> >  	case FC_TGTID_BIND_BY_WWPN:
> > @@ -3035,7 +3045,6 @@ fc_timeout_deleted_rport(struct work_str
> >  	 * went away and didn't come back - we'll remove
> >  	 * all attached scsi devices.
> >  	 */
> > -	spin_unlock_irqrestore(shost->host_lock, flags);
> >  
> >  	scsi_target_unblock(&rport->dev);
> >  	fc_queue_work(shost, &rport->stgt_delete_work);
> > 

One of our tester hit the problem Michael describes above: right after
releasing the shost->host_lock lock in fc_timeout_deleted_rport() the
remote port was rediscovered by the LLDD (in our case zfcp),
fc_remote_port_add() was called and BUG_ON() triggered.

But flushing the devloss_work_queue in fc_remote_port_add() won't help
either because it still would be possible that right after the
flush_workqueue() call a timer could trigger and fc_timeout_deleted_rport()
can be called on a different cpu before fc_remote_port_add() grabs
the lock and we end up again with inconsistent data.

To me the purpose of the BUG_ON() is not clear: re-adding a remote port
should be possible at any time even after the devloss timeout triggered.
And as Michael already mentioned, modifying the identifiers without
holding the lock can lead to inconsistent remote port data. What about
the following solution:

---
 drivers/scsi/scsi_transport_fc.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

Index: linux-2.5/drivers/scsi/scsi_transport_fc.c
===================================================================
--- linux-2.5.orig/drivers/scsi/scsi_transport_fc.c
+++ linux-2.5/drivers/scsi/scsi_transport_fc.c
@@ -3027,25 +3027,27 @@ fc_timeout_deleted_rport(struct work_str
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	fc_terminate_rport_io(rport);
 
-	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
-
 	/* remove the identifiers that aren't used in the consisting binding */
-	switch (fc_host->tgtid_bind_type) {
-	case FC_TGTID_BIND_BY_WWPN:
-		rport->node_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_WWNN:
-		rport->port_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_ID:
-		rport->node_name = -1;
-		rport->port_name = -1;
-		break;
-	case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
-		break;
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {
+		switch (fc_host->tgtid_bind_type) {
+		case FC_TGTID_BIND_BY_WWPN:
+			rport->node_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_WWNN:
+			rport->port_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_ID:
+			rport->node_name = -1;
+			rport->port_name = -1;
+			break;
+		case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
+			break;
+		}
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/*
 	 * As this only occurs if the remote port (scsi target)

--
Ralph Wuerthner
