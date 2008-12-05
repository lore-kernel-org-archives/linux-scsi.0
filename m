From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon	dev_loss_tmo
 timeout
Date: Fri, 05 Dec 2008 16:29:59 -0600
Message-ID: <4939AB67.5010509@cs.wisc.edu>
References: <1228497483.8775.1.camel@ogier>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020803060806010205050200"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54724 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYLEWaJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 17:30:09 -0500
In-Reply-To: <1228497483.8775.1.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020803060806010205050200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Smart wrote:
> 
> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2008-10-18 10:32:52.000000000 -0400
> +++ b/drivers/scsi/scsi_transport_fc.c	2008-12-05 12:13:54.000000000 -0500
> @@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_str
> @@ -3035,7 +3045,6 @@ fc_timeout_deleted_rport(struct work_str
>  	 * went away and didn't come back - we'll remove
>  	 * all attached scsi devices.
>  	 */
> -	spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  	scsi_target_unblock(&rport->dev);
>  	fc_queue_work(shost, &rport->stgt_delete_work);
> 

We do not need this unblock call anymore. The added 
fc_terminate_rport_io will do this. I attached a patch that removes it 
for you.

--------------020803060806010205050200
Content-Type: text/plain;
 name="james-pre-emptively-terminate-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="james-pre-emptively-terminate-2.patch"

Pre-emptively terminate i/o on the rport if dev_loss_tmo has fired.
The desire is to terminate everything, so that the i/o is cleaned up
prior to the sdev's being unblocked, thus any outstanding timeouts/aborts
are avoided.
 
Also, we do this early enough such that the rport's port_id field is
still valid. FCOE libFC code needs this info to find the i/o's to
terminate.

 -- james s
 
Signed-off-by: James Smart <james.smart@emulex.com>
[michaelc@cs.wisc.edu.com: remove extra scsi_target_unblock call]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu.com>

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1e71abf..062304d 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
+	/*
+	 * Pre-emptively kill I/O rather than waiting for the work queue
+	 * item to teardown the starget. (FCOE libFC folks prefer this
+	 * and to have the rport_port_id still set when it's done).
+	 */
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	fc_terminate_rport_io(rport);
+
+	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
+
 	/* remove the identifiers that aren't used in the consisting binding */
 	switch (fc_host->tgtid_bind_type) {
 	case FC_TGTID_BIND_BY_WWPN:
@@ -3035,9 +3045,6 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	 * went away and didn't come back - we'll remove
 	 * all attached scsi devices.
 	 */
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	scsi_target_unblock(&rport->dev);
 	fc_queue_work(shost, &rport->stgt_delete_work);
 }
 

--------------020803060806010205050200--
