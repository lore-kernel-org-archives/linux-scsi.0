From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Mon, 22 Mar 2010 15:12:40 +0100
Message-ID: <20100322141239.GB6953@schmichrtp.mainz.de.ibm.com>
References: <4BA1AB14.6020600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:35942 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0CVOMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2010 10:12:42 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o2MECeJg031994
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2010 14:12:40 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2MECeIH868468
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2010 14:12:40 GMT
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2MECeMr009645
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2010 14:12:40 GMT
Content-Disposition: inline
In-Reply-To: <4BA1AB14.6020600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Mar 17, 2010 at 11:24:52PM -0500, Mike Christie wrote:
> On 03/16/2010 08:04 AM, Christof Schmitt wrote:
> >On Tue, Mar 09, 2010 at 09:14:37AM -0500, James Smart wrote:
> >>I don't ever expect to see large dev_loss_tmo values, but the patch is fine.
> >>
> >>Acked-by: James Smart<james.smart@emulex.com>
> >>
> >>-- james s
> >>
> >>
> >>Hannes Reinecke wrote:
> >>>The rport structure defines dev_loss_tmo as u32, which is
> >>>later multiplied with HZ to get the actual timeout value.
> >>>This might overflow for large dev_loss_tmo values. So we
> >>>should be better using u64 as intermediate variables here
> >>>to protect against overflow.
> >>>
> >>>Signed-off-by: Hannes Reinecke<hare@suse.de>
> >[...]
> >
> >I guess this is the intended use to prevent the dev_loss_tmo from
> >removing the SCSI devices:
> >http://git.kernel.org/?p=linux/kernel/git/hare/multipath-tools.git;a=commitdiff;h=b9903e2e8a6cdc5042897719fbae6c9346820bbf;hp=ed1dc6164fe530d146cfe65d4f99e44ec9b54b95
> >
> >But does this raise the question again how to run SCSI EH with remote
> >port failures?
> >
> >The SCSI FC LLDs call fc_block_scsi_eh to wait until the fc_rport
> >leaves the state FC_PORTSTATE_BLOCKED. This effectively prevents SCSI
> >devices from being taken offline when there is a command timeout and
> >the fc_rport is BLOCKED. With the large dev_loss_tmo, the dev_loss_tmo
> >never expires and a problem with a single remote port can block the
> >host error handler.
> >
> 
> I did the attached patch for a problem where we were supposed to be
> getting a RSCN but we were not, so the scsi eh ended up running.
> Then we sat in the scsi eh for a long time. multipath was being
> used, so we wanted to fast fail, but the the fc block scsi eh helper
> only waits for the rport state to change.
> 
> It ended up the switch was busted and should have given a RSCN, but
> I think the patch is helpful for your problem where we fall into the
> long wait for legitimate reasons.
> 
> This patch works nicely when using multipath to get IO failed and
> hosts unblocked, but the problem is that it could offline the
> devices more quickly than what we are prepared for. We have
> something similar for iscsi, but the iscsi userspace daemon has a
> way to set the device back to running when it recovers. FC does not,
> and dm-multipath does not do this, so I am not pushing the patch.
> 
> I think if we can figure something out for that offline issue the
> patch could be helpful. I was thinking that if the the scsi eh
> failed because the fast io fail timer fired, then we could set the
> devices to a new state. The scsi_transport_fc and
> scsi_transport_iscsi code could use this new device state to
> indicate that the fast io fail timer has fired and we are failing
> IO, but the device is not in offline state and is not blocked.

Thanks for providing the information and ideas. I think the main point
is to get the information that I/O has been failed to the scsi eh.
What about introducing a return value to indicate that I/O has been
failed with terminate_rport_io? This is a first shot to implement this
for the abort callback, but it needs to be extended for the other
callbacks as well. Or should a new SCSI device state be preferred?

---
 drivers/scsi/scsi_error.c        |    5 +++--
 drivers/scsi/scsi_transport_fc.c |   20 +++++++++++++++-----
 include/scsi/scsi.h              |    1 +
 include/scsi/scsi_transport_fc.h |    2 +-
 4 files changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/scsi/scsi_error.c	2009-12-03 17:41:27.000000000 +0100
+++ b/drivers/scsi/scsi_error.c	2010-03-22 14:58:07.000000000 +0100
@@ -956,10 +956,11 @@ static int scsi_eh_abort_cmds(struct lis
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
-		if (rtn == SUCCESS) {
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (!scsi_device_online(scmd->device) ||
-			    !scsi_eh_tur(scmd)) {
+			    !scsi_eh_tur(scmd) ||
+			    rtn == FAST_IO_FAIL) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
 				
--- a/drivers/scsi/scsi_transport_fc.c	2010-02-26 12:59:27.000000000 +0100
+++ b/drivers/scsi/scsi_transport_fc.c	2010-03-22 14:56:28.000000000 +0100
@@ -3162,23 +3162,33 @@ fc_scsi_scan_rport(struct work_struct *w
  *
  * This routine can be called from a FC LLD scsi_eh callback. It
  * blocks the scsi_eh thread until the fc_rport leaves the
- * FC_PORTSTATE_BLOCKED. This is necessary to avoid the scsi_eh
- * failing recovery actions for blocked rports which would lead to
- * offlined SCSI devices.
+ * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
+ * necessary to avoid the scsi_eh failing recovery actions for blocked
+ * rports which would lead to offlined SCSI devices.
+ *
+ * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
+ * 	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
+ * 	    passed back to scsi_eh.
  */
-void fc_block_scsi_eh(struct scsi_cmnd *cmnd)
+int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+	while (rport->port_state == FC_PORTSTATE_BLOCKED &&
+	       !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+		return FAST_IO_FAIL;
+
+	return 0;
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
--- a/include/scsi/scsi.h	2010-02-26 12:59:46.000000000 +0100
+++ b/include/scsi/scsi.h	2010-03-22 14:56:48.000000000 +0100
@@ -423,6 +423,7 @@ static inline int scsi_is_wlun(unsigned 
 #define ADD_TO_MLQUEUE  0x2006
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
+#define FAST_IO_FAIL	0x2009
 
 /*
  * Midlevel queue return values.
--- a/include/scsi/scsi_transport_fc.h	2009-11-05 16:59:33.000000000 +0100
+++ b/include/scsi/scsi_transport_fc.h	2010-03-22 14:41:36.000000000 +0100
@@ -807,6 +807,6 @@ void fc_host_post_vendor_event(struct Sc
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-void fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
 
 #endif /* SCSI_TRANSPORT_FC_H */

The low-level driver simply passes the FAST_IO_FAIL from the eh callback
back to scsi eh:

---
 drivers/s390/scsi/zfcp_scsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2010-03-02 14:02:37.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2010-03-22 14:50:31.000000000 +0100
@@ -174,7 +174,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
 	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
-	int retval = SUCCESS;
+	int retval = SUCCESS, ret;
 	int retry = 3;
 	char *dbf_tag;
 
@@ -199,7 +199,9 @@ static int zfcp_scsi_eh_abort_handler(st
 			break;
 
 		zfcp_erp_wait(adapter);
-		fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(scpnt);
+		if (ret)
+			return ret;
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_dbf_scsi_abort("nres", adapter->dbf, scpnt, NULL,
