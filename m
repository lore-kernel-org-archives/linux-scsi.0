From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [7/18]  qla2xxx: Tape command handling fixes
Date: Mon, 21 Jun 2004 22:53:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055332.GA8432@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:424 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266594AbUFVFts (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:49:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1843 04/06/04 08:09:21 andrew.vasquez@apc.qlogic.com +3 -0
  Fix several tape handling issue:
  
  1) When the firmware receives the LOGO from the device, any
  active exchanges will be returned with a completion status
  of 0x29 -- this will cause the port to be marked as lost and
  request made to the DPC routine to begin a relogin attempt.
  The problem is, since we've never actually logged out of the
  device and cannot do so in interrupt context, we must be
  sure to perform the logout before the qla2x00_fabric_login()
  in the RELOGIN_NEEDED code.
  
  2) Sets the Get Port Database options to ZERO when issuing
  the call to qla2x00_get_port_database().  This consolidates
  actuall login handling in the place it should be, in the
  previous qla2x00_fabric_login() call rather than depending
  on any 'hidden' behaviour of the firmware.  If a device did
  a LOGO after the login, then any subsequent exachanges will
  be returned with an 0x29 completion status and the
  RELOGIN_NEEDED code will handle the login.
  
  3) Finally, if the master and slave state do not indicate a
  logged-in state from the Get Port Database call, then one
  cannot depend on the information returned from the firmware
  -- the firmware typically wipes out the PCB information for
  a given loopID when logged out.  So, return immediately with
  a failed status.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c |    2 -
 drivers/scsi/qla2xxx/qla_mbx.c  |   54 ++++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_os.c   |    9 +++++-
 3 files changed, 36 insertions(+), 29 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:37:56 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:37:56 -07:00
@@ -2886,7 +2886,7 @@
 
 	rval = qla2x00_fabric_login(ha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
-		rval = qla2x00_get_port_database(ha, fcport, BIT_1 | BIT_0);
+		rval = qla2x00_get_port_database(ha, fcport, 0);
 		if (rval != QLA_SUCCESS) {
 			qla2x00_fabric_logout(ha, fcport->loop_id);
 		} else {
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-21 15:37:56 -07:00
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-21 15:37:56 -07:00
@@ -1431,35 +1431,37 @@
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	rval = qla2x00_mailbox_command(ha, mcp);
+	if (rval != QLA_SUCCESS)
+		goto gpd_error_out;
 
-	if (rval == QLA_SUCCESS) {
-		/* Names are little-endian. */
-		memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
-		memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
-
-		/* Get port_id of device. */
-		fcport->d_id.b.al_pa = pd->port_id[2];
-		fcport->d_id.b.area = pd->port_id[3];
-		fcport->d_id.b.domain = pd->port_id[0];
-		fcport->d_id.b.rsvd_1 = 0;
-
-		/* Check for device require authentication. */
-		pd->common_features & BIT_5 ? (fcport->flags |= FCF_AUTH_REQ) :
-		    (fcport->flags &= ~FCF_AUTH_REQ);
-
-		/* If not target must be initiator or unknown type. */
-		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0) {
-			fcport->port_type = FCT_INITIATOR;
-		} else {
-			fcport->port_type = FCT_TARGET;
-
-			/* Check for logged in. */
-			if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
-			    pd->slave_state != PD_STATE_PORT_LOGGED_IN)
-				rval = QLA_FUNCTION_FAILED;
-		}
+	/* Check for logged in state. */
+	if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
+	    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
+		rval = QLA_FUNCTION_FAILED;
+		goto gpd_error_out;
 	}
 
+	/* Names are little-endian. */
+	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
+	memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
+
+	/* Get port_id of device. */
+	fcport->d_id.b.al_pa = pd->port_id[2];
+	fcport->d_id.b.area = pd->port_id[3];
+	fcport->d_id.b.domain = pd->port_id[0];
+	fcport->d_id.b.rsvd_1 = 0;
+
+	/* Check for device require authentication. */
+	pd->common_features & BIT_5 ? (fcport->flags |= FCF_AUTH_REQ) :
+	    (fcport->flags &= ~FCF_AUTH_REQ);
+
+	/* If not target must be initiator or unknown type. */
+	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
+		fcport->port_type = FCT_INITIATOR;
+	else
+		fcport->port_type = FCT_TARGET;
+
+gpd_error_out:
 	pci_free_consistent(ha->pdev, PORT_DATABASE_SIZE, pd, pd_dma);
 
 	if (rval != QLA_SUCCESS) {
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:37:56 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:37:56 -07:00
@@ -3428,10 +3428,15 @@
 				    fcport->login_retry) {
 
 					fcport->login_retry--;
-					if (fcport->flags & FCF_FABRIC_DEVICE)
+					if (fcport->flags & FCF_FABRIC_DEVICE) {
+						if (fcport->flags &
+						    FCF_TAPE_PRESENT)
+							qla2x00_fabric_logout(
+							    ha,
+							    fcport->loop_id);
 						status = qla2x00_fabric_login(
 						    ha, fcport, &next_loopid);
-					else 	
+					} else
 						status =
 						    qla2x00_local_device_login(
 							ha, fcport->loop_id);
