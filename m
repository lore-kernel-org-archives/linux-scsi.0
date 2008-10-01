From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/13] zfcp: remove all typedefs and replace them with standards
Date: Wed, 01 Oct 2008 12:42:18 +0200
Message-ID: <20081001104759.957110000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:44580 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYJAKsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:10 -0400
Content-Disposition: inline; filename=zfcp_cleanup_typdefs.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Remove typedefs from zfcp, use already existing types instead.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   |   21 +++++++++-------
 drivers/s390/scsi/zfcp_def.h   |   39 +++++++++++-------------------
 drivers/s390/scsi/zfcp_erp.c   |   10 ++++---
 drivers/s390/scsi/zfcp_ext.h   |   11 +++-----
 drivers/s390/scsi/zfcp_fc.c    |    2 -
 drivers/s390/scsi/zfcp_fsf.c   |   53 +++++++++++++++++++++++++++++------------
 drivers/s390/scsi/zfcp_scsi.c  |   14 ----------
 drivers/s390/scsi/zfcp_sysfs.c |   22 +++++++++--------
 8 files changed, 88 insertions(+), 84 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-10-01 10:14:52.000000000 +0200
@@ -88,11 +88,13 @@ static int __init zfcp_device_setup(char
 	strncpy(zfcp_data.init_busid, token, BUS_ID_SIZE);
 
 	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0, &zfcp_data.init_wwpn))
+	if (!token || strict_strtoull(token, 0,
+				(unsigned long long *) &zfcp_data.init_wwpn))
 		goto err_out;
 
 	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0, &zfcp_data.init_fcp_lun))
+	if (!token || strict_strtoull(token, 0,
+				(unsigned long long *) &zfcp_data.init_fcp_lun))
 		goto err_out;
 
 	kfree(str);
@@ -231,8 +233,7 @@ module_init(zfcp_module_init);
  *
  * Returns: pointer to zfcp_unit or NULL
  */
-struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *port,
-				       fcp_lun_t fcp_lun)
+struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *port, u64 fcp_lun)
 {
 	struct zfcp_unit *unit;
 
@@ -251,7 +252,7 @@ struct zfcp_unit *zfcp_get_unit_by_lun(s
  * Returns: pointer to zfcp_port or NULL
  */
 struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *adapter,
-					wwn_t wwpn)
+					u64 wwpn)
 {
 	struct zfcp_port *port;
 
@@ -276,7 +277,7 @@ static void zfcp_sysfs_unit_release(stru
  *
  * Sets up some unit internal structures and creates sysfs entry.
  */
-struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *port, fcp_lun_t fcp_lun)
+struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *port, u64 fcp_lun)
 {
 	struct zfcp_unit *unit;
 
@@ -290,7 +291,8 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
 
-	snprintf(unit->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx", fcp_lun);
+	snprintf(unit->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx",
+		 (unsigned long long) fcp_lun);
 	unit->sysfs_device.parent = &port->sysfs_device;
 	unit->sysfs_device.release = zfcp_sysfs_unit_release;
 	dev_set_drvdata(&unit->sysfs_device, unit);
@@ -620,7 +622,7 @@ static void zfcp_sysfs_port_release(stru
  * d_id is used to enqueue ports with a well known address like the Directory
  * Service for nameserver lookup.
  */
-struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *adapter, wwn_t wwpn,
+struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *adapter, u64 wwpn,
 				     u32 status, u32 d_id)
 {
 	struct zfcp_port *port;
@@ -644,7 +646,8 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set(&port->refcount, 0);
 
-	snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx", wwpn);
+	snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx",
+		 (unsigned long long) wwpn);
 	port->sysfs_device.parent = &adapter->ccw_device->dev;
 
 	port->sysfs_device.release = zfcp_sysfs_port_release;
--- a/drivers/s390/scsi/zfcp_def.h	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-10-01 10:14:52.000000000 +0200
@@ -78,11 +78,6 @@
 
 /*************** FIBRE CHANNEL PROTOCOL SPECIFIC DEFINES ********************/
 
-typedef unsigned long long wwn_t;
-typedef unsigned long long fcp_lun_t;
-/* data length field may be at variable position in FCP-2 FCP_CMND IU */
-typedef unsigned int       fcp_dl_t;
-
 /* timeout for name-server lookup (in seconds) */
 #define ZFCP_NS_GID_PN_TIMEOUT		10
 
@@ -106,7 +101,7 @@ typedef unsigned int       fcp_dl_t;
 
 /* FCP(-2) FCP_CMND IU */
 struct fcp_cmnd_iu {
-	fcp_lun_t fcp_lun;	   /* FCP logical unit number */
+	u64 fcp_lun;	   /* FCP logical unit number */
 	u8  crn;	           /* command reference number */
 	u8  reserved0:5;	   /* reserved */
 	u8  task_attribute:3;	   /* task attribute */
@@ -181,7 +176,7 @@ struct fcp_rscn_element {
 struct fcp_logo {
         u32 command;
         u32 nport_did;
-        wwn_t nport_wwpn;
+	u64 nport_wwpn;
 } __attribute__((packed));
 
 /*
@@ -330,7 +325,7 @@ struct ct_hdr {
  * a port name is required */
 struct ct_iu_gid_pn_req {
 	struct ct_hdr header;
-	wwn_t wwpn;
+	u64 wwpn;
 } __attribute__ ((packed));
 
 /* FS_ACC IU and data unit for GID_PN nameserver request */
@@ -339,8 +334,6 @@ struct ct_iu_gid_pn_resp {
 	u32 d_id;
 } __attribute__ ((packed));
 
-typedef void (*zfcp_send_ct_handler_t)(unsigned long);
-
 /**
  * struct zfcp_send_ct - used to pass parameters to function zfcp_fsf_send_ct
  * @wka_port: port where the request is sent to
@@ -360,7 +353,7 @@ struct zfcp_send_ct {
 	struct scatterlist *resp;
 	unsigned int req_count;
 	unsigned int resp_count;
-	zfcp_send_ct_handler_t handler;
+	void (*handler)(unsigned long);
 	unsigned long handler_data;
 	int timeout;
 	struct completion *completion;
@@ -377,8 +370,6 @@ struct zfcp_gid_pn_data {
         struct zfcp_port *port;
 };
 
-typedef void (*zfcp_send_els_handler_t)(unsigned long);
-
 /**
  * struct zfcp_send_els - used to pass parameters to function zfcp_fsf_send_els
  * @adapter: adapter where request is sent from
@@ -402,7 +393,7 @@ struct zfcp_send_els {
 	struct scatterlist *resp;
 	unsigned int req_count;
 	unsigned int resp_count;
-	zfcp_send_els_handler_t handler;
+	void (*handler)(unsigned long);
 	unsigned long handler_data;
 	struct completion *completion;
 	int ls_code;
@@ -468,8 +459,8 @@ struct zfcp_adapter {
 	atomic_t                refcount;          /* reference count */
 	wait_queue_head_t	remove_wq;         /* can be used to wait for
 						      refcount drop to zero */
-	wwn_t			peer_wwnn;	   /* P2P peer WWNN */
-	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
+	u64			peer_wwnn;	   /* P2P peer WWNN */
+	u64			peer_wwpn;	   /* P2P peer WWPN */
 	u32			peer_d_id;	   /* P2P peer D_ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u32			hydra_version;	   /* Hydra version */
@@ -546,8 +537,8 @@ struct zfcp_port {
 						  list */
 	u32		       units;	       /* # of logical units in list */
 	atomic_t	       status;	       /* status of this remote port */
-	wwn_t		       wwnn;	       /* WWNN if known */
-	wwn_t		       wwpn;	       /* WWPN */
+	u64		       wwnn;	       /* WWNN if known */
+	u64		       wwpn;	       /* WWPN */
 	u32		       d_id;	       /* D_ID */
 	u32		       handle;	       /* handle assigned by FSF */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
@@ -566,7 +557,7 @@ struct zfcp_unit {
 	struct zfcp_port       *port;	       /* remote port of unit */
 	atomic_t	       status;	       /* status of this logical unit */
 	unsigned int	       scsi_lun;       /* own SCSI LUN */
-	fcp_lun_t	       fcp_lun;	       /* own FCP_LUN */
+	u64		       fcp_lun;	       /* own FCP_LUN */
 	u32		       handle;	       /* handle assigned by FSF */
         struct scsi_device     *device;        /* scsi device struct pointer */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
@@ -620,11 +611,11 @@ struct zfcp_data {
 						       changes */
 	atomic_t		loglevel;            /* current loglevel */
 	char                    init_busid[BUS_ID_SIZE];
-	wwn_t                   init_wwpn;
-	fcp_lun_t               init_fcp_lun;
-	struct kmem_cache		*fsf_req_qtcb_cache;
-	struct kmem_cache		*sr_buffer_cache;
-	struct kmem_cache		*gid_pn_cache;
+	u64			init_wwpn;
+	u64			init_fcp_lun;
+	struct kmem_cache	*fsf_req_qtcb_cache;
+	struct kmem_cache	*sr_buffer_cache;
+	struct kmem_cache	*gid_pn_cache;
 };
 
 /* struct used by memory pools for fsf_requests */
--- a/drivers/s390/scsi/zfcp_ext.h	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-10-01 10:14:52.000000000 +0200
@@ -12,16 +12,14 @@
 #include "zfcp_def.h"
 
 /* zfcp_aux.c */
-extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *,
-					      fcp_lun_t);
-extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *,
-					       wwn_t);
+extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, u64);
+extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *, u64);
 extern int zfcp_adapter_enqueue(struct ccw_device *);
 extern void zfcp_adapter_dequeue(struct zfcp_adapter *);
-extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, wwn_t, u32,
+extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, u64, u32,
 					   u32);
 extern void zfcp_port_dequeue(struct zfcp_port *);
-extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, fcp_lun_t);
+extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, u64);
 extern void zfcp_unit_dequeue(struct zfcp_unit *);
 extern int zfcp_reqlist_isempty(struct zfcp_adapter *);
 extern void zfcp_sg_free_table(struct scatterlist *, int);
@@ -150,7 +148,6 @@ extern void zfcp_qdio_close(struct zfcp_
 extern struct zfcp_data zfcp_data;
 extern int zfcp_adapter_scsi_register(struct zfcp_adapter *);
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
-extern void zfcp_set_fcp_dl(struct fcp_cmnd_iu *, fcp_dl_t);
 extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
 extern struct fc_function_template zfcp_transport_functions;
 
--- a/drivers/s390/scsi/zfcp_fc.c	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-10-01 10:14:52.000000000 +0200
@@ -178,7 +178,7 @@ static void zfcp_fc_incoming_rscn(struct
 	schedule_work(&fsf_req->adapter->scan_work);
 }
 
-static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, wwn_t wwpn)
+static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, u64 wwpn)
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_port *port;
--- a/drivers/s390/scsi/zfcp_sysfs.c	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2008-10-01 10:14:52.000000000 +0200
@@ -26,9 +26,9 @@ static ZFCP_DEV_ATTR(_feat, _name, S_IRU
 ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, status, "0x%08x\n",
 		 atomic_read(&adapter->status));
 ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_wwnn, "0x%016llx\n",
-		 adapter->peer_wwnn);
+		 (unsigned long long) adapter->peer_wwnn);
 ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_wwpn, "0x%016llx\n",
-		 adapter->peer_wwpn);
+		 (unsigned long long) adapter->peer_wwpn);
 ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_d_id, "0x%06x\n",
 		 adapter->peer_d_id);
 ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, card_version, "0x%04x\n",
@@ -135,7 +135,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 {
 	struct zfcp_adapter *adapter = dev_get_drvdata(dev);
 	struct zfcp_port *port;
-	wwn_t wwpn;
+	u64 wwpn;
 	int retval = 0;
 
 	down(&zfcp_data.config_sema);
@@ -144,7 +144,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 		goto out;
 	}
 
-	if (strict_strtoull(buf, 0, &wwpn)) {
+	if (strict_strtoull(buf, 0, (unsigned long long *) &wwpn)) {
 		retval = -EINVAL;
 		goto out;
 	}
@@ -200,7 +200,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 {
 	struct zfcp_port *port = dev_get_drvdata(dev);
 	struct zfcp_unit *unit;
-	fcp_lun_t fcp_lun;
+	u64 fcp_lun;
 	int retval = -EINVAL;
 
 	down(&zfcp_data.config_sema);
@@ -209,7 +209,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 		goto out;
 	}
 
-	if (strict_strtoull(buf, 0, &fcp_lun))
+	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		goto out;
 
 	unit = zfcp_unit_enqueue(port, fcp_lun);
@@ -233,7 +233,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 {
 	struct zfcp_port *port = dev_get_drvdata(dev);
 	struct zfcp_unit *unit;
-	fcp_lun_t fcp_lun;
+	u64 fcp_lun;
 	int retval = 0;
 
 	down(&zfcp_data.config_sema);
@@ -242,7 +242,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 		goto out;
 	}
 
-	if (strict_strtoull(buf, 0, &fcp_lun)) {
+	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun)) {
 		retval = -EINVAL;
 		goto out;
 	}
@@ -380,8 +380,10 @@ static DEVICE_ATTR(_name, S_IRUGO, zfcp_
 
 ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
 	unit->port->adapter->ccw_device->dev.bus_id);
-ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n", unit->port->wwpn);
-ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n", unit->fcp_lun);
+ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n",
+		      (unsigned long long) unit->port->wwpn);
+ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n",
+		      (unsigned long long) unit->fcp_lun);
 
 struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
 	&dev_attr_fcp_lun,
--- a/drivers/s390/scsi/zfcp_erp.c	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-10-01 10:14:52.000000000 +0200
@@ -991,7 +991,8 @@ static int zfcp_erp_strategy_check_unit(
 			dev_err(&unit->port->adapter->ccw_device->dev,
 				"ERP failed for unit 0x%016Lx on "
 				"port 0x%016Lx\n",
-				unit->fcp_lun, unit->port->wwpn);
+				(unsigned long long)unit->fcp_lun,
+				(unsigned long long)unit->port->wwpn);
 			zfcp_erp_unit_failed(unit, 21, NULL);
 		}
 		break;
@@ -1021,7 +1022,7 @@ static int zfcp_erp_strategy_check_port(
 		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS) {
 			dev_err(&port->adapter->ccw_device->dev,
 				"ERP failed for remote port 0x%016Lx\n",
-				port->wwpn);
+				(unsigned long long)port->wwpn);
 			zfcp_erp_port_failed(port, 22, NULL);
 		}
 		break;
@@ -1199,7 +1200,8 @@ static void zfcp_erp_schedule_work(struc
 	if (!p) {
 		dev_err(&unit->port->adapter->ccw_device->dev,
 			"Registering unit 0x%016Lx on port 0x%016Lx failed\n",
-			unit->fcp_lun, unit->port->wwpn);
+			(unsigned long long)unit->fcp_lun,
+			(unsigned long long)unit->port->wwpn);
 		return;
 	}
 
@@ -1221,7 +1223,7 @@ static void zfcp_erp_rport_register(stru
 	if (!port->rport) {
 		dev_err(&port->adapter->ccw_device->dev,
 			"Registering port 0x%016Lx failed\n",
-			port->wwpn);
+			(unsigned long long)port->wwpn);
 		return;
 	}
 
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 10:15:26.000000000 +0200
@@ -68,7 +68,7 @@ static void zfcp_fsf_access_denied_port(
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	dev_warn(&req->adapter->ccw_device->dev,
 		 "Access denied to port 0x%016Lx\n",
-		 port->wwpn);
+		 (unsigned long long)port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
 	zfcp_erp_port_access_denied(port, 55, req);
@@ -81,7 +81,8 @@ static void zfcp_fsf_access_denied_unit(
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	dev_warn(&req->adapter->ccw_device->dev,
 		 "Access denied to unit 0x%016Lx on port 0x%016Lx\n",
-		 unit->fcp_lun, unit->port->wwpn);
+		 (unsigned long long)unit->fcp_lun,
+		 (unsigned long long)unit->port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
 	zfcp_erp_unit_access_denied(unit, 59, req);
@@ -1390,7 +1391,8 @@ static void zfcp_fsf_open_port_handler(s
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
 		dev_warn(&req->adapter->ccw_device->dev,
 			 "Not enough FCP adapter resources to open "
-			 "remote port 0x%016Lx\n", port->wwpn);
+			 "remote port 0x%016Lx\n",
+			 (unsigned long long)port->wwpn);
 		zfcp_erp_port_failed(port, 31, req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1403,7 +1405,7 @@ static void zfcp_fsf_open_port_handler(s
 		case FSF_SQ_NO_RETRY_POSSIBLE:
 			dev_warn(&req->adapter->ccw_device->dev,
 				 "Remote port 0x%016Lx could not be opened\n",
-				 port->wwpn);
+				 (unsigned long long)port->wwpn);
 			zfcp_erp_port_failed(port, 32, req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -1824,8 +1826,8 @@ static void zfcp_fsf_open_unit_handler(s
 			dev_warn(&adapter->ccw_device->dev,
 				 "LUN 0x%Lx on port 0x%Lx is already in "
 				 "use by CSS%d, MIF Image ID %x\n",
-				 unit->fcp_lun,
-				 unit->port->wwpn,
+				 (unsigned long long)unit->fcp_lun,
+				 (unsigned long long)unit->port->wwpn,
 				 queue_designator->cssid,
 				 queue_designator->hla);
 		else
@@ -1840,7 +1842,8 @@ static void zfcp_fsf_open_unit_handler(s
 		dev_warn(&adapter->ccw_device->dev,
 			 "No handle is available for LUN "
 			 "0x%016Lx on port 0x%016Lx\n",
-			 unit->fcp_lun, unit->port->wwpn);
+			 (unsigned long long)unit->fcp_lun,
+			 (unsigned long long)unit->port->wwpn);
 		zfcp_erp_unit_failed(unit, 34, req);
 		/* fall through */
 	case FSF_INVALID_COMMAND_OPTION:
@@ -1879,7 +1882,8 @@ static void zfcp_fsf_open_unit_handler(s
 				dev_info(&adapter->ccw_device->dev,
 					 "SCSI device at LUN 0x%016Lx on port "
 					 "0x%016Lx opened read-only\n",
-					 unit->fcp_lun, unit->port->wwpn);
+					 (unsigned long long)unit->fcp_lun,
+					 (unsigned long long)unit->port->wwpn);
         		}
 
         		if (exclusive && !readwrite) {
@@ -1887,7 +1891,8 @@ static void zfcp_fsf_open_unit_handler(s
 					"Exclusive read-only access not "
 					"supported (unit 0x%016Lx, "
 					"port 0x%016Lx)\n",
-					unit->fcp_lun, unit->port->wwpn);
+					(unsigned long long)unit->fcp_lun,
+					(unsigned long long)unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 35, req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0, 80, req);
@@ -1896,7 +1901,8 @@ static void zfcp_fsf_open_unit_handler(s
 					"Shared read-write access not "
 					"supported (unit 0x%016Lx, port "
 					"0x%016Lx\n)",
-					unit->fcp_lun, unit->port->wwpn);
+					(unsigned long long)unit->fcp_lun,
+					(unsigned long long)unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 36, req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0, 81, req);
@@ -2197,7 +2203,8 @@ static void zfcp_fsf_send_fcp_command_ha
 			"Incorrect direction %d, unit 0x%016Lx on port "
 			"0x%016Lx closed\n",
 			req->qtcb->bottom.io.data_direction,
-			unit->fcp_lun, unit->port->wwpn);
+			(unsigned long long)unit->fcp_lun,
+			(unsigned long long)unit->port->wwpn);
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2206,7 +2213,8 @@ static void zfcp_fsf_send_fcp_command_ha
 			"Incorrect CDB length %d, unit 0x%016Lx on "
 			"port 0x%016Lx closed\n",
 			req->qtcb->bottom.io.fcp_cmnd_length,
-			unit->fcp_lun, unit->port->wwpn);
+			(unsigned long long)unit->fcp_lun,
+			(unsigned long long)unit->port->wwpn);
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2237,6 +2245,20 @@ skip_fsfstatus:
 	}
 }
 
+static void zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_cmd, u32 fcp_dl)
+{
+	u32 *fcp_dl_ptr;
+
+	/*
+	 * fcp_dl_addr = start address of fcp_cmnd structure +
+	 * size of fixed part + size of dynamically sized add_dcp_cdb field
+	 * SEE FCP-2 documentation
+	 */
+	fcp_dl_ptr = (u32 *) ((unsigned char *) &fcp_cmd[1] +
+			(fcp_cmd->add_fcp_cdb_length << 2));
+	*fcp_dl_ptr = fcp_dl;
+}
+
 /**
  * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
  * @adapter: adapter where scsi command is issued
@@ -2322,7 +2344,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	memcpy(fcp_cmnd_iu->fcp_cdb, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
 
 	req->qtcb->bottom.io.fcp_cmnd_length = sizeof(struct fcp_cmnd_iu) +
-		fcp_cmnd_iu->add_fcp_cdb_length + sizeof(fcp_dl_t);
+		fcp_cmnd_iu->add_fcp_cdb_length + sizeof(u32);
 
 	real_bytes = zfcp_qdio_sbals_from_sg(req, sbtype,
 					     scsi_sglist(scsi_cmnd),
@@ -2334,7 +2356,8 @@ int zfcp_fsf_send_fcp_command_task(struc
 			dev_err(&adapter->ccw_device->dev,
 				"Oversize data package, unit 0x%016Lx "
 				"on port 0x%016Lx closed\n",
-				unit->fcp_lun, unit->port->wwpn);
+				(unsigned long long)unit->fcp_lun,
+				(unsigned long long)unit->port->wwpn);
 			zfcp_erp_unit_shutdown(unit, 0, 131, req);
 			retval = -EINVAL;
 		}
@@ -2397,7 +2420,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.io.fcp_cmnd_length = 	sizeof(struct fcp_cmnd_iu) +
-						sizeof(fcp_dl_t);
+						sizeof(u32);
 
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-10-01 10:14:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-10-01 10:14:52.000000000 +0200
@@ -21,20 +21,6 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
 	return fcp_sns_info_ptr;
 }
 
-void zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_cmd, fcp_dl_t fcp_dl)
-{
-	fcp_dl_t *fcp_dl_ptr;
-
-	/*
-	 * fcp_dl_addr = start address of fcp_cmnd structure +
-	 * size of fixed part + size of dynamically sized add_dcp_cdb field
-	 * SEE FCP-2 documentation
-	 */
-	fcp_dl_ptr = (fcp_dl_t *) ((unsigned char *) &fcp_cmd[1] +
-				   (fcp_cmd->add_fcp_cdb_length << 2));
-	*fcp_dl_ptr = fcp_dl;
-}
-
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;

-- 
