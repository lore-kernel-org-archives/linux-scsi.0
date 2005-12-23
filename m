From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: More FC Transport Issues
Date: Fri, 23 Dec 2005 11:50:35 -0800
Message-ID: <20051223195035.GG1112@andrew-vasquezs-powerbook-g4-15.local>
References: <43AB36BC.8000003@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:34935 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1160999AbVLWTul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 14:50:41 -0500
Content-Disposition: inline
In-Reply-To: <43AB36BC.8000003@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@SGI.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James.Smart@Emulex.Com, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@SGI.com>

On Thu, 22 Dec 2005, Michael Reed wrote:

> It's possible the OOPS is related to the qla2xxx serialization issue I reported
> earlier.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113380446825841&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113458339109319&w=2

As far as the synchronization issues, could you try out the following.

---

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7b3efd5..dba240b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1664,7 +1664,7 @@ typedef struct fc_port {
 	uint8_t mp_byte;		/* multi-path byte (not used) */
     	uint8_t cur_path;		/* current path id */
 
-	struct fc_rport *rport;
+	struct fc_rport *rport, *drport;
 	u32 supported_classes;
 	struct work_struct rport_add_work;
 	struct work_struct rport_del_work;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c46d246..b99f547 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1687,10 +1687,16 @@ static void
 qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
+	struct fc_rport *rport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fcport->ha->hardware_lock, flags);
+	rport = fcport->drport;
+	fcport->drport = NULL;
+	spin_unlock_irqrestore(&fcport->ha->hardware_lock, flags);
+	if (rport)
+		fc_remote_port_delete(rport);
 
-	if (fcport->rport)
-		fc_remote_port_delete(fcport->rport);
-	fcport->rport = NULL;
 }
 
 /**
@@ -2081,10 +2087,10 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
 
-	if (fcport->rport) {
-		fc_remote_port_delete(fcport->rport);
-		fcport->rport = NULL;
-	}
+	if (fcport->drport)
+		qla2x00_rport_del(fcport);
+	if (fcport->rport)
+		return;
 
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c58c9d9..9842fb7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1627,6 +1627,20 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	pci_disable_device(ha->pdev);
 }
 
+static inline void
+qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (fcport->rport) {
+		fcport->drport = fcport->rport;
+		fcport->rport = NULL;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	schedule_work(&fcport->rport_del_work);
+}
+
 /*
  * qla2x00_mark_device_lost Updates fcport state when device goes offline.
  *
@@ -1639,8 +1653,8 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
     int do_login)
 {
-	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-		schedule_work(&fcport->rport_del_work);
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		qla2x00_schedule_rport_del(ha, fcport);
 
 	/*
 	 * We may need to retry the login, so don't change the state of the
@@ -1701,8 +1715,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-			schedule_work(&fcport->rport_del_work);
+		if (atomic_read(&fcport->state) == FCS_ONLINE)
+			qla2x00_schedule_rport_del(ha, fcport);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
