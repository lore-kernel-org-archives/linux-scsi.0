From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon
	dev_loss_tmo
Date: Wed, 22 Apr 2009 14:01:31 -0400
Message-ID: <1240423291.27035.3.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65014 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZDVSBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 14:01:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "ralphw@linux.vnet.ibm.com" <ralphw@linux.vnet.ibm.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

=EF=BB=BFMike, Ralph,

See if this helps. It compiles, but I haven't tested it.

This modifies the final deletion steps, after dev_loss_tmo has fired,
such that we keep a flag indicating we're deleting, and we only clear
the flag once the additional steps that we had to perform w/o lock,
are complete.  Then, in fc_remote_port_add(), when we fall into the
case of using the rports for the bindings, which corresponds to the
"open" unlocked code area, we stall and wait for the delete to
finish before completing the rest of the add.
=EF=BB=BF
I'm a little nervous about the delay in fc_remote_port_add, but it
should be quick, and our callees should be in a context that it's
allowed.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/scsi_transport_fc.c |   66
+++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_transport_fc.h |    5 ++
 2 files changed, 69 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c
b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2009-04-06 12:13:13.000000000
-0400
+++ b/drivers/scsi/scsi_transport_fc.c	2009-04-22 13:44:22.000000000
-0400
@@ -144,6 +144,7 @@ static struct {
 	{ FC_PORTSTATE_ERROR,		"Error" },
 	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
 	{ FC_PORTSTATE_DELETED,		"Deleted" },
+	{ FC_PORTSTATE_DELETING,	"Deleting" },
 };
 fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
 #define FC_PORTSTATE_MAX_NAMELEN	20
@@ -2347,9 +2348,28 @@ fc_starget_delete(struct work_struct *wo
 {
 	struct fc_rport *rport =3D
 		container_of(work, struct fc_rport, stgt_delete_work);
+	struct Scsi_Host *shost =3D rport_to_shost(rport);
+	unsigned long flags;
=20
 	fc_terminate_rport_io(rport);
 	scsi_remove_target(&rport->dev);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	rport->flags &=3D ~FC_RPORT_STGT_DEL_INPROG;
+
+	/*
+	 * if the final transition to NOTPRESENT was waiting on our
+	 * scsi teardown calls to finish, make the transition now.
+	 */
+	if (rport->flags & FC_RPORT_NOTPRESENT_NEEDED) {
+		BUG_ON(rport->port_state !=3D FC_PORTSTATE_DELETING);
+		rport->flags &=3D ~FC_RPORT_NOTPRESENT_NEEDED;
+		rport->port_state =3D FC_PORTSTATE_NOTPRESENT;
+		complete(&rport->deleting);
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
=20
=20
@@ -2694,6 +2714,19 @@ fc_remote_port_add(struct Scsi_Host *sho
 			}
=20
 			if (match) {
+				if (rport->port_state =3D=3D FC_PORTSTATE_DELETING) {
+					/*
+					 * We need to stall until the delete
+					 * steps are complete
+					 */
+					spin_unlock_irqrestore(shost->host_lock,
+								flags);
+					wait_for_completion(&rport->deleting);
+					spin_lock_irqsave(shost->host_lock,
+								flags);
+					BUG_ON(rport->port_state !=3D
+						FC_PORTSTATE_NOTPRESENT);
+				}
 				list_move_tail(&rport->peers, &fc_host->rports);
 				break;
 			}
@@ -3007,7 +3040,8 @@ fc_timeout_deleted_rport(struct work_str
 	rport->maxframe_size =3D -1;
 	rport->supported_classes =3D FC_COS_UNSPECIFIED;
 	rport->roles =3D FC_PORT_ROLE_UNKNOWN;
-	rport->port_state =3D FC_PORTSTATE_NOTPRESENT;
+	rport->port_state =3D FC_PORTSTATE_DELETING;
+	init_completion(&rport->deleting);
 	rport->flags &=3D ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 	rport->flags |=3D FC_RPORT_DEVLOSS_CALLBK_DONE;
=20
@@ -3019,7 +3053,8 @@ fc_timeout_deleted_rport(struct work_str
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	fc_terminate_rport_io(rport);
=20
-	BUG_ON(rport->port_state !=3D FC_PORTSTATE_NOTPRESENT);
+	spin_lock_irqsave(shost->host_lock, flags);
+	BUG_ON(rport->port_state !=3D FC_PORTSTATE_DELETING);
=20
 	/* remove the identifiers that aren't used in the consisting binding
*/
 	switch (fc_host->tgtid_bind_type) {
@@ -3040,12 +3075,20 @@ fc_timeout_deleted_rport(struct work_str
 	}
=20
 	/*
+	 * Indicate we have an outstanding workq element to delete
+	 * the starget
+	 */
+	rport->flags |=3D FC_RPORT_STGT_DEL_INPROG;
+
+	/*
 	 * As this only occurs if the remote port (scsi target)
 	 * went away and didn't come back - we'll remove
 	 * all attached scsi devices.
 	 */
 	fc_queue_work(shost, &rport->stgt_delete_work);
=20
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/*
 	 * Notify the driver that the rport is now dead. The LLDD will
 	 * also guarantee that any communication to the rport is terminated
@@ -3054,6 +3097,25 @@ fc_timeout_deleted_rport(struct work_str
 	 */
 	if (i->f->dev_loss_tmo_callbk)
 		i->f->dev_loss_tmo_callbk(rport);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	/*
+	 * if the starget teardown is complete, we can do the
+	 * DELETING->NOTPRESENT transition.
+	 */
+	if ( !(rport->flags & FC_RPORT_STGT_DEL_INPROG)) {
+		rport->port_state =3D FC_PORTSTATE_NOTPRESENT;
+		complete(&rport->deleting);
+
+	} else
+		/*
+		 * Otherwise, mark the rport so that starget teardown
+		 * does the DELETING->NOTPRESENT transition.
+		 */
+		rport->flags |=3D FC_RPORT_NOTPRESENT_NEEDED;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
=20
=20
diff -upNr a/include/scsi/scsi_transport_fc.h
b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2009-01-27 09:44:40.000000000
-0500
+++ b/include/scsi/scsi_transport_fc.h	2009-04-22 13:22:04.000000000
-0400
@@ -82,6 +82,7 @@ enum fc_port_state {
 	FC_PORTSTATE_ERROR,
 	FC_PORTSTATE_LOOPBACK,
 	FC_PORTSTATE_DELETED,
+	FC_PORTSTATE_DELETING,
 };
=20
=20
@@ -352,6 +353,7 @@ struct fc_rport {	/* aka fc_starget_attr
  	struct delayed_work fail_io_work;
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
+	struct completion deleting;
 } __attribute__((aligned(sizeof(unsigned long))));
=20
 /* bit field values for struct fc_rport "flags" field: */
@@ -359,6 +361,8 @@ struct fc_rport {	/* aka fc_starget_attr
 #define FC_RPORT_SCAN_PENDING		0x02
 #define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
 #define FC_RPORT_DEVLOSS_CALLBK_DONE	0x08
+#define FC_RPORT_STGT_DEL_INPROG	0x10
+#define FC_RPORT_NOTPRESENT_NEEDED	0x20
=20
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)
@@ -685,6 +689,7 @@ fc_remote_port_chkready(struct fc_rport=20
 			result =3D DID_NO_CONNECT << 16;
 		break;
 	case FC_PORTSTATE_BLOCKED:
+	case FC_PORTSTATE_DELETING:
 		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 			result =3D DID_TRANSPORT_FAILFAST << 16;
 		else


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
