From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH]  qla2xxx: Cleanup FC remote port registration.
Date: Fri, 8 Jul 2005 18:00:36 -0700
Message-ID: <20050709010036.GJ24126@plap.qlogic.org>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com> <20050709005626.GG24126@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32630 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263063AbVGIBAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2005 21:00:38 -0400
Content-Disposition: inline
In-Reply-To: <20050709005626.GG24126@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Cleanup FC remote port registration.

Due to the inherent behaviour (an immediate scan) of adding
a 'target'-role-capable rport via fc_remote_port_add(),
split the registration into two steps -- addition as
unknown-type role, then use fc_remote_port_rolchg() with
appropriate role (based on PLOGI/PRLI bits).  This allows
for a more cleaner rport->dd_data management as can be seen
with the simplified qla2xxx_slave_alloc() function.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_init.c |   17 ++++++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |   16 +---------------
 2 files changed, 11 insertions(+), 22 deletions(-)

d2b87ba88e4ddfd08931ce2e0d836a2dd1e68ca4
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2068,21 +2068,24 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
 	    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
+	fcport->rport = rport = fc_remote_port_add(ha->host, 0, &rport_ids);
+	if (!rport) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate fc remote port!\n");
+		return;
+	}
+	rport->dd_data = fcport;
+
+	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	if (fcport->port_type == FCT_INITIATOR)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 	if (fcport->port_type == FCT_TARGET)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
-
-	fcport->rport = rport = fc_remote_port_add(ha->host, 0, &rport_ids);
-	if (!rport)
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to allocate fc remote port!\n");
+	fc_remote_port_rolechg(rport, rport_ids.roles);
 
 	if (rport->scsi_target_id != -1 &&
 	    rport->scsi_target_id < ha->host->max_id)
 		fcport->os_target_id = rport->scsi_target_id;
-
-	rport->dd_data = fcport;
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1071,26 +1071,12 @@ qla2x00_device_reset(scsi_qla_host_t *ha
 static int
 qla2xxx_slave_alloc(struct scsi_device *sdev)
 {
-	scsi_qla_host_t *ha = to_qla_host(sdev->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	fc_port_t *fcport;
-	int found;
 
 	if (!rport)
 		return -ENXIO;
 
-	found = 0;
-	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (rport->port_name ==
-		    be64_to_cpu(*(uint64_t *)fcport->port_name)) {
-			found++;
-			break;
-		}
-	}
-	if (!found)
-		return -ENXIO;
-
-	sdev->hostdata = fcport;
+	sdev->hostdata = rport->dd_data;
 
 	return 0;
 }
------------
