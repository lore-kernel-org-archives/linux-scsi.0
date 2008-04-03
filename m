From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/21] qla2xxx: Use an rport's scsi_target_id member consistently throughout driver.
Date: Thu,  3 Apr 2008 13:13:16 -0700
Message-ID: <1207253612-15538-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846AbYDCUNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:35 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Rather than using a duplicate/cached value stored in the driver's
internal fcport structure.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    9 ++++++---
 drivers/scsi/qla2xxx/qla_def.h  |    2 --
 drivers/scsi/qla2xxx/qla_init.c |    4 ----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index aee0322..798cc61 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -900,7 +900,8 @@ qla2x00_get_starget_node_name(struct scsi_target *starget)
 	u64 node_name = 0;
 
 	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (starget->id == fcport->os_target_id) {
+		if (fcport->rport &&
+		    starget->id == fcport->rport->scsi_target_id) {
 			node_name = wwn_to_u64(fcport->node_name);
 			break;
 		}
@@ -918,7 +919,8 @@ qla2x00_get_starget_port_name(struct scsi_target *starget)
 	u64 port_name = 0;
 
 	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (starget->id == fcport->os_target_id) {
+		if (fcport->rport &&
+		    starget->id == fcport->rport->scsi_target_id) {
 			port_name = wwn_to_u64(fcport->port_name);
 			break;
 		}
@@ -936,7 +938,8 @@ qla2x00_get_starget_port_id(struct scsi_target *starget)
 	uint32_t port_id = ~0U;
 
 	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (starget->id == fcport->os_target_id) {
+		if (fcport->rport &&
+		    starget->id == fcport->rport->scsi_target_id) {
 			port_id = fcport->d_id.b.domain << 16 |
 			    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index aa9d216..f70c78b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1542,8 +1542,6 @@ typedef struct fc_port {
 	atomic_t state;
 	uint32_t flags;
 
-	unsigned int os_target_id;
-
 	int port_login_retry_count;
 	int login_retry;
 	atomic_t port_down_timer;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9b7ad59..e773697 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2251,10 +2251,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
 	if (fcport->port_type == FCT_TARGET)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
 	fc_remote_port_rolechg(rport, rport_ids.roles);
-
-	if (rport->scsi_target_id != -1 &&
-	    rport->scsi_target_id < ha->host->max_id)
-		fcport->os_target_id = rport->scsi_target_id;
 }
 
 /*
-- 
1.5.5.rc2

