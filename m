From: michaelc@cs.wisc.edu
Subject: [PATCH 3/7] fc class: Add support for new transport
	errors
Date: Wed,  4 Jun 2008 20:41:42 -0500
Message-ID: <1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

When we block a rport and the driver implements the terminate
callback we will fail IO that was running quickly. However
IO that was in the scsi_device/block queue sits there until
the dev_loss_tmo fires, and this can make it look like IO is
lost because new IO will get executed but that IO stuck in
the blocked queue sits there for some time longer.

With this patch when the fast io fail tmo fires, we will
fail the blocked IO and any new IO. This patch also allows
all drivers to partially support the fast io fail tmo. If the
terminate io callback is not implemented, we will still fail blocked
IO and any new IO, so multipath can handle that. This means that for
drivers like qla2xxx which seem to fail the IO when the error is first
detected this will then allow drivers like lpfc and qla2xxx to have the
IO flushed to the upper layers when the fast io fail tmo is fired.

This patch also allows the fc and iscsi classes to implement the
same behavior. The timers are just unfornately named differently.

The next patches will convert the drivers to support this.

This patch has been lightly tested with lpfc and qla2xxx. I am not able
to test the role change handling.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |   15 ++++++++++-----
 include/scsi/scsi_transport_fc.h |    8 ++++++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5fd64e7..ea4906c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2156,8 +2156,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
-	if (ft->terminate_rport_io)
-		SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
 	BUG_ON(count > FC_RPORT_NUM_ATTRS);
 
@@ -2662,6 +2661,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 
 				spin_lock_irqsave(shost->host_lock, flags);
 
+				rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 				rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 
 				/* if target, initiate a scan */
@@ -2725,6 +2725,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			rport->port_id = ids->port_id;
 			rport->roles = ids->roles;
 			rport->port_state = FC_PORTSTATE_ONLINE;
+			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
 			if (fci->f->dd_fcrport_size)
 				memset(rport->dd_data, 0,
@@ -2807,7 +2808,6 @@ void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
 	int timeout = rport->dev_loss_tmo;
 	unsigned long flags;
 
@@ -2853,7 +2853,7 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	/* see if we need to kill io faster than waiting for device loss */
 	if ((rport->fast_io_fail_tmo != -1) &&
-	    (rport->fast_io_fail_tmo < timeout) && (i->f->terminate_rport_io))
+	    (rport->fast_io_fail_tmo < timeout))
 		fc_queue_devloss_work(shost, &rport->fail_io_work,
 					rport->fast_io_fail_tmo * HZ);
 
@@ -2930,6 +2930,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
+		rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		/* ensure any stgt delete functions are done */
@@ -3024,6 +3025,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	rport->supported_classes = FC_COS_UNSPECIFIED;
 	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
+	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
 	/* remove the identifiers that aren't used in the consisting binding */
 	switch (fc_host->tgtid_bind_type) {
@@ -3072,7 +3074,10 @@ fc_timeout_fail_rport_io(struct work_struct *work)
 	if (rport->port_state != FC_PORTSTATE_BLOCKED)
 		return;
 
-	i->f->terminate_rport_io(rport);
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
+	if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+	scsi_target_unblock(&rport->dev);
 }
 
 /**
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 06f72ba..4cf6fb0 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -338,6 +338,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 /* bit field values for struct fc_rport "flags" field: */
 #define FC_RPORT_DEVLOSS_PENDING	0x01
 #define FC_RPORT_SCAN_PENDING		0x02
+#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x03
 
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)
@@ -659,12 +660,15 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
-			result = DID_IMM_RETRY << 16;
+			result = DID_TRANSPORT_DISRUPTED << 16;
 		else
 			result = DID_NO_CONNECT << 16;
 		break;
 	case FC_PORTSTATE_BLOCKED:
-		result = DID_IMM_RETRY << 16;
+		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+			result = DID_TRANSPORT_FAILFAST << 16;
+		else
+			result = DID_TRANSPORT_DISRUPTED << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;
-- 
1.5.4.1
