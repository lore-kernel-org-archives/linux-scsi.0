From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] libsas: Convert sas_proto users to sas_protocol
Date: Mon, 5 Nov 2007 11:51:17 -0800
Message-ID: <20071105195117.GB7010@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42030 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXKETvc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Nov 2007 14:51:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

sparse complains about the mixing of enums in libsas.  Since the
underlying numeric values of both enums are the same, combine them
to get rid of the warning.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_dev.c  |    6 +++---
 drivers/scsi/aic94xx/aic94xx_dump.c |    4 ++--
 drivers/scsi/aic94xx/aic94xx_hwi.c  |    2 +-
 drivers/scsi/aic94xx/aic94xx_scb.c  |    6 +++---
 drivers/scsi/aic94xx/aic94xx_task.c |   30 +++++++++++++++---------------
 drivers/scsi/aic94xx/aic94xx_tmf.c  |   12 ++++++------
 drivers/scsi/libsas/sas_discover.c  |    2 +-
 drivers/scsi/libsas/sas_expander.c  |    6 +++---
 drivers/scsi/libsas/sas_internal.h  |    2 +-
 include/scsi/libsas.h               |   18 +++++++++---------
 include/scsi/sas.h                  |   13 ++++++-------
 include/scsi/scsi_transport_sas.h   |    8 +-------
 12 files changed, 51 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
index 3dce618..72042ca 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -165,7 +165,7 @@ static int asd_init_target_ddb(struct domain_device *dev)
 	if (dev->port->oob_mode != SATA_OOB_MODE) {
 		flags |= OPEN_REQUIRED;
 		if ((dev->dev_type == SATA_DEV) ||
-		    (dev->tproto & SAS_PROTO_STP)) {
+		    (dev->tproto & SAS_PROTOCOL_STP)) {
 			struct smp_resp *rps_resp = &dev->sata_dev.rps_resp;
 			if (rps_resp->frame_type == SMP_RESPONSE &&
 			    rps_resp->function == SMP_REPORT_PHY_SATA &&
@@ -193,7 +193,7 @@ static int asd_init_target_ddb(struct domain_device *dev)
 	asd_ddbsite_write_byte(asd_ha, ddb, DDB_TARG_FLAGS, flags);
 
 	flags = 0;
-	if (dev->tproto & SAS_PROTO_STP)
+	if (dev->tproto & SAS_PROTOCOL_STP)
 		flags |= STP_CL_POL_NO_TX;
 	asd_ddbsite_write_byte(asd_ha, ddb, DDB_TARG_FLAGS2, flags);
 
@@ -201,7 +201,7 @@ static int asd_init_target_ddb(struct domain_device *dev)
 	asd_ddbsite_write_word(asd_ha, ddb, SEND_QUEUE_TAIL, 0xFFFF);
 	asd_ddbsite_write_word(asd_ha, ddb, SISTER_DDB, 0xFFFF);
 
-	if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTO_STP)) {
+	if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
 		i = asd_init_sata(dev);
 		if (i < 0) {
 			asd_free_ddb(asd_ha, ddb);
diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 6bd8e30..3d8c4ff 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -903,11 +903,11 @@ void asd_dump_frame_rcvd(struct asd_phy *phy,
 	int i;
 
 	switch ((dl->status_block[1] & 0x70) >> 3) {
-	case SAS_PROTO_STP:
+	case SAS_PROTOCOL_STP:
 		ASD_DPRINTK("STP proto device-to-host FIS:\n");
 		break;
 	default:
-	case SAS_PROTO_SSP:
+	case SAS_PROTOCOL_SSP:
 		ASD_DPRINTK("SAS proto IDENTIFY:\n");
 		break;
 	}
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index fb2be39..940a207 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -90,7 +90,7 @@ static int asd_init_phy(struct asd_phy *phy)
 
 	sas_phy->enabled = 1;
 	sas_phy->class = SAS;
-	sas_phy->iproto = SAS_PROTO_ALL;
+	sas_phy->iproto = SAS_PROTOCOL_ALL;
 	sas_phy->tproto = 0;
 	sas_phy->type = PHY_TYPE_PHYSICAL;
 	sas_phy->role = PHY_ROLE_INITIATOR;
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index db6ab1a..0febad4 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -788,12 +788,12 @@ void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc)
 
 		/* initiator port settings are in the hi nibble */
 		if (phy->sas_phy.role == PHY_ROLE_INITIATOR)
-			control_phy->port_type = SAS_PROTO_ALL << 4;
+			control_phy->port_type = SAS_PROTOCOL_ALL << 4;
 		else if (phy->sas_phy.role == PHY_ROLE_TARGET)
-			control_phy->port_type = SAS_PROTO_ALL;
+			control_phy->port_type = SAS_PROTOCOL_ALL;
 		else
 			control_phy->port_type =
-				(SAS_PROTO_ALL << 4) | SAS_PROTO_ALL;
+				(SAS_PROTOCOL_ALL << 4) | SAS_PROTOCOL_ALL;
 
 		/* link reset retries, this should be nominal */
 		control_phy->link_reset_retries = 10;
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index e0e58be..68ae5f1 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -187,7 +187,7 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 	ts->buf_valid_size = 0;
 	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
 	r = edb->vaddr;
-	if (task->task_proto == SAS_PROTO_SSP) {
+	if (task->task_proto == SAS_PROTOCOL_SSP) {
 		struct ssp_response_iu *iu =
 			r + 16 + sizeof(struct ssp_frame_hdr);
 
@@ -342,14 +342,14 @@ Again:
 	}
 
 	switch (task->task_proto) {
-	case SATA_PROTO:
-	case SAS_PROTO_STP:
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
 		asd_unbuild_ata_ascb(ascb);
 		break;
-	case SAS_PROTO_SMP:
+	case SAS_PROTOCOL_SMP:
 		asd_unbuild_smp_ascb(ascb);
 		break;
-	case SAS_PROTO_SSP:
+	case SAS_PROTOCOL_SSP:
 		asd_unbuild_ssp_ascb(ascb);
 	default:
 		break;
@@ -598,17 +598,17 @@ int asd_execute_task(struct sas_task *task, const int num,
 	list_for_each_entry(a, &alist, list) {
 		t = a->uldd_task;
 		a->uldd_timer = 1;
-		if (t->task_proto & SAS_PROTO_STP)
-			t->task_proto = SAS_PROTO_STP;
+		if (t->task_proto & SAS_PROTOCOL_STP)
+			t->task_proto = SAS_PROTOCOL_STP;
 		switch (t->task_proto) {
-		case SATA_PROTO:
-		case SAS_PROTO_STP:
+		case SAS_PROTOCOL_SATA:
+		case SAS_PROTOCOL_STP:
 			res = asd_build_ata_ascb(a, t, gfp_flags);
 			break;
-		case SAS_PROTO_SMP:
+		case SAS_PROTOCOL_SMP:
 			res = asd_build_smp_ascb(a, t, gfp_flags);
 			break;
-		case SAS_PROTO_SSP:
+		case SAS_PROTOCOL_SSP:
 			res = asd_build_ssp_ascb(a, t, gfp_flags);
 			break;
 		default:
@@ -645,14 +645,14 @@ out_err_unmap:
 			t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 			spin_unlock_irqrestore(&t->task_state_lock, flags);
 			switch (t->task_proto) {
-			case SATA_PROTO:
-			case SAS_PROTO_STP:
+			case SAS_PROTOCOL_SATA:
+			case SAS_PROTOCOL_STP:
 				asd_unbuild_ata_ascb(a);
 				break;
-			case SAS_PROTO_SMP:
+			case SAS_PROTOCOL_SMP:
 				asd_unbuild_smp_ascb(a);
 				break;
-			case SAS_PROTO_SSP:
+			case SAS_PROTOCOL_SSP:
 				asd_unbuild_ssp_ascb(a);
 			default:
 				break;
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index c0d0b7d..87b2f6e 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -372,21 +372,21 @@ int asd_abort_task(struct sas_task *task)
 	scb->header.opcode = ABORT_TASK;
 
 	switch (task->task_proto) {
-	case SATA_PROTO:
-	case SAS_PROTO_STP:
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
 		scb->abort_task.proto_conn_rate = (1 << 5); /* STP */
 		break;
-	case SAS_PROTO_SSP:
+	case SAS_PROTOCOL_SSP:
 		scb->abort_task.proto_conn_rate  = (1 << 4); /* SSP */
 		scb->abort_task.proto_conn_rate |= task->dev->linkrate;
 		break;
-	case SAS_PROTO_SMP:
+	case SAS_PROTOCOL_SMP:
 		break;
 	default:
 		break;
 	}
 
-	if (task->task_proto == SAS_PROTO_SSP) {
+	if (task->task_proto == SAS_PROTOCOL_SSP) {
 		scb->abort_task.ssp_frame.frame_type = SSP_TASK;
 		memcpy(scb->abort_task.ssp_frame.hashed_dest_addr,
 		       task->dev->hashed_sas_addr, HASHED_SAS_ADDR_SIZE);
@@ -512,7 +512,7 @@ static int asd_initiate_ssp_tmf(struct domain_device *dev, u8 *lun,
 	int res = 1;
 	struct scb *scb;
 
-	if (!(dev->tproto & SAS_PROTO_SSP))
+	if (!(dev->tproto & SAS_PROTOCOL_SSP))
 		return TMF_RESP_FUNC_ESUPP;
 
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL);
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 5f3a0d7..31b9af2 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -98,7 +98,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 			dev->dev_type = SATA_PM;
 		else
 			dev->dev_type = SATA_DEV;
-		dev->tproto = SATA_PROTO;
+		dev->tproto = SAS_PROTOCOL_SATA;
 	} else {
 		struct sas_identify_frame *id =
 			(struct sas_identify_frame *) dev->frame_rcvd;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8727436..27674fe 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -656,9 +656,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 	sas_ex_get_linkrate(parent, child, phy);
 
 #ifdef CONFIG_SCSI_SAS_ATA
-	if ((phy->attached_tproto & SAS_PROTO_STP) || phy->attached_sata_dev) {
+	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
 		child->dev_type = SATA_DEV;
-		if (phy->attached_tproto & SAS_PROTO_STP)
+		if (phy->attached_tproto & SAS_PROTOCOL_STP)
 			child->tproto = phy->attached_tproto;
 		if (phy->attached_sata_dev)
 			child->tproto |= SATA_DEV;
@@ -695,7 +695,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 		}
 	} else
 #endif
-	  if (phy->attached_tproto & SAS_PROTO_SSP) {
+	  if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
 		child->dev_type = SAS_END_DEV;
 		rphy = sas_end_device_alloc(phy->port);
 		/* FIXME: error handling */
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 2b8213b..baa0666 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -45,7 +45,7 @@
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
 int sas_show_class(enum sas_class class, char *buf);
-int sas_show_proto(enum sas_proto proto, char *buf);
+int sas_show_proto(enum sas_protocol proto, char *buf);
 int sas_show_linkrate(enum sas_linkrate linkrate, char *buf);
 int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 58aa2aa..fe24bbc 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -122,8 +122,8 @@ struct ex_phy {
 	u8   attached_sata_dev:1;
 	u8   attached_sata_ps:1;
 
-	enum sas_proto attached_tproto;
-	enum sas_proto attached_iproto;
+	enum sas_protocol attached_tproto;
+	enum sas_protocol attached_iproto;
 
 	u8   attached_sas_addr[SAS_ADDR_SIZE];
 	u8   attached_phy_id;
@@ -191,8 +191,8 @@ struct domain_device {
 
         struct list_head dev_list_node;
 
-        enum sas_proto    iproto;
-        enum sas_proto    tproto;
+        enum sas_protocol    iproto;
+        enum sas_protocol    tproto;
 
         struct sas_rphy *rphy;
 
@@ -245,8 +245,8 @@ struct asd_sas_port {
 	enum sas_class   class;
 	u8               sas_addr[SAS_ADDR_SIZE];
 	u8               attached_sas_addr[SAS_ADDR_SIZE];
-	enum sas_proto   iproto;
-	enum sas_proto   tproto;
+	enum sas_protocol   iproto;
+	enum sas_protocol   tproto;
 
 	enum sas_oob_mode oob_mode;
 
@@ -289,8 +289,8 @@ struct asd_sas_phy {
 
 	int            id;	  /* must be set */
 	enum sas_class class;
-	enum sas_proto iproto;
-	enum sas_proto tproto;
+	enum sas_protocol iproto;
+	enum sas_protocol tproto;
 
 	enum sas_phy_type  type;
 	enum sas_phy_role  role;
@@ -537,7 +537,7 @@ struct sas_task {
 	spinlock_t   task_state_lock;
 	unsigned     task_state_flags;
 
-	enum   sas_proto      task_proto;
+	enum   sas_protocol      task_proto;
 
 	/* Used by the discovery code. */
 	struct timer_list     timer;
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 2f4b6af..e9fd022 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -102,13 +102,12 @@ enum sas_dev_type {
 	SATA_PM_PORT= 8,
 };
 
-/* Partly from IDENTIFY address frame. */
-enum sas_proto {
-	SATA_PROTO    = 1,
-	SAS_PROTO_SMP = 2,	  /* protocol */
-	SAS_PROTO_STP = 4,	  /* protocol */
-	SAS_PROTO_SSP = 8,	  /* protocol */
-	SAS_PROTO_ALL = 0xE,
+enum sas_protocol {
+	SAS_PROTOCOL_SATA		= 0x01,
+	SAS_PROTOCOL_SMP		= 0x02,
+	SAS_PROTOCOL_STP		= 0x04,
+	SAS_PROTOCOL_SSP		= 0x08,
+	SAS_PROTOCOL_ALL		= 0x0E,
 };
 
 /* From the spec; local phys only */
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index abdfd2e..007d929 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -4,6 +4,7 @@
 #include <linux/transport_class.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <scsi/sas.h>
 
 struct scsi_transport_template;
 struct sas_rphy;
@@ -16,13 +17,6 @@ enum sas_device_type {
 	SAS_FANOUT_EXPANDER_DEVICE,
 };
 
-enum sas_protocol {
-	SAS_PROTOCOL_SATA		= 0x01,
-	SAS_PROTOCOL_SMP		= 0x02,
-	SAS_PROTOCOL_STP		= 0x04,
-	SAS_PROTOCOL_SSP		= 0x08,
-};
-
 static inline int sas_protocol_ata(enum sas_protocol proto)
 {
 	return ((proto & SAS_PROTOCOL_SATA) ||
