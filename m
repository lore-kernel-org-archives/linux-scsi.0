From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [4/15]  qla2xxx: PortID binding fixes
Date: Thu, 6 May 2004 22:51:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055145.GA4901@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:16364 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263024AbUEGFuB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:50:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1925 04/04/30 10:48:48 andrew.vasquez@apc.qlogic.com +1 -0
  Fix problem where port ID binding would not be honoured when
  a device was moved within the fabric.

 drivers/scsi/qla2xxx/qla_init.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:13:47 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:13:47 2004
@@ -3290,6 +3290,7 @@
 static uint16_t
 qla2x00_fcport_bind(scsi_qla_host_t *ha, fc_port_t *fcport) 
 {
+	int		found;
 	uint16_t	tgt;
 	os_tgt_t	*tq;
 
@@ -3298,18 +3299,32 @@
 		if ((tq = TGT_Q(ha, tgt)) == NULL)
 			continue;
 
-		if (ha->binding_type == BIND_BY_PORT_ID &&
-		    fcport->d_id.b24 == tq->d_id.b24) {
-			memcpy(tq->node_name, fcport->node_name, WWN_SIZE);
-			memcpy(tq->port_name, fcport->port_name, WWN_SIZE);
+		found = 0;
+		switch (ha->binding_type) {
+		case BIND_BY_PORT_ID:
+			if (fcport->d_id.b24 == tq->d_id.b24) {
+				memcpy(tq->node_name, fcport->node_name,
+				    WWN_SIZE);
+				memcpy(tq->port_name, fcport->port_name,
+				    WWN_SIZE);
+				found++;
+			}
 			break;
-		}
-
-		if (memcmp(fcport->port_name, tq->port_name, WWN_SIZE) == 0) {
-			/* In case of persistent binding, update the WWNN */
-			memcpy(tq->node_name, fcport->node_name, WWN_SIZE);
+		case BIND_BY_PORT_NAME:    
+			if (memcmp(fcport->port_name, tq->port_name,
+			    WWN_SIZE) == 0) {
+				/*
+				 * In case of persistent binding, update the
+				 * WWNN.
+				 */
+				memcpy(tq->node_name, fcport->node_name,
+				    WWN_SIZE);
+				found++;
+			}
 			break;
 		}
+		if (found)
+		    break;	
 	}
 
 	/* TODO: honor the ConfigRequired flag */
