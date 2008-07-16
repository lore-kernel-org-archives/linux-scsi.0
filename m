From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 13:50:49 -0500
Message-ID: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

The rport->dd_data should be set by the time we get to the
queuecommand, but its data could be zerod out. This adds a check
like other drivers for this.

We also want to check fc_remote_port_chkready before the driver
bits, because the class could want to do something else.

Also some other review comments for this code path:

1. Do we need locking aruond the lp->state and status checks in
the queuecommand function?
2. Why do we fail the command with DID_NO_CONNECT if
FC_PAUSE is not supported. It seems like we want to retry
and then allow the class to fail or retry IO.
3. Same for the link_status DID_NO_CONNECT usage.
4. fc_lport_destroy, fc_fcp_destroy ordering in fcoe_destroy_interface does
not seem right. It looks like if we need to send a sync cache to the device
when it is removed it will always fail.

This patch was made over the last ones
http://www.open-fcoe.org/pipermail/devel/2008-July/000365.html
http://www.open-fcoe.org/pipermail/devel/2008-July/000368.html
http://www.open-fcoe.org/pipermail/devel/2008-July/000369.html

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/libfc/fc_fcp.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ea7c6bc..c2bbfa7 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1649,6 +1649,21 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 
 	lp = shost_priv(sc_cmd->device->host);
 
+	rval = fc_remote_port_chkready(rport);
+	if (rval) {
+		sc_cmd->result = rval;
+		done(sc_cmd);
+		goto out;
+	}
+
+	if (!*(struct fc_remote_port **)rport->dd_data) {
+		/* rport is transitioning */
+		sc_cmd->result = DID_IMM_RETRY << 16;
+		done(sc_cmd);
+		goto out;
+	}
+	rp = rport->dd_data;
+
 	if (lp->state != LPORT_ST_READY) {
 		if (lp->link_status & FC_PAUSE) {
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -1666,19 +1681,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		}
 	}
 
-	rval = fc_remote_port_chkready(rport);
-	if (rval) {
-		sc_cmd->result = rval;
-		done(sc_cmd);
-		goto out;
-	}
-	rp = rport->dd_data;
-	if (!rp) {
-		sc_cmd->result = DID_NO_CONNECT << 16;
-		done(sc_cmd);
-		goto out;
-	}
-
 	if (!(rp->rp_fcp_parm & FCP_SPPF_TARG_FCN)) {
 		sc_cmd->result = DID_NO_CONNECT << 16;
 		done(sc_cmd);
-- 
1.5.4.1
