From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 4/8] zfcp: (cleanup) removed superfluous macros, struct members, typedefs
Date: Mon, 22 May 2006 18:18:19 +0200
Message-ID: <20060522161819.GA25256@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:57577 "EHLO
	mtagate6.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750961AbWEVQUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:20:52 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGKpYf130438
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:20:51 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGLq2o129674
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:21:52 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGKoGR018364
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:20:51 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: (cleanup) removed superfluous macros, struct members, typedefs

Removed some macros, struct members and typedefs which were
unused or not necessary.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

92c3715709bc413aeef3cbf814898b664b7de52e
 drivers/s390/scsi/zfcp_aux.c  |   15 +++-------
 drivers/s390/scsi/zfcp_def.h  |   47 ++++---------------------------
 drivers/s390/scsi/zfcp_erp.c  |    2 +
 drivers/s390/scsi/zfcp_fsf.c  |   62 +++++++++++++----------------------------
 drivers/s390/scsi/zfcp_fsf.h  |   21 ++------------
 drivers/s390/scsi/zfcp_qdio.c |    3 +-
 drivers/s390/scsi/zfcp_scsi.c |   13 +++------
 7 files changed, 41 insertions(+), 122 deletions(-)

92c3715709bc413aeef3cbf814898b664b7de52e
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 4a17ce4..bdaad55 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -740,7 +740,7 @@ struct zfcp_unit *
 zfcp_unit_enqueue(struct zfcp_port *port, fcp_lun_t fcp_lun)
 {
 	struct zfcp_unit *unit, *tmp_unit;
-	scsi_lun_t scsi_lun;
+	unsigned int scsi_lun;
 	int found;
 
 	/*
@@ -991,12 +991,6 @@ zfcp_adapter_enqueue(struct ccw_device *
 	/* intitialise SCSI ER timer */
 	init_timer(&adapter->scsi_er_timer);
 
-	/* set FC service class used per default */
-	adapter->fc_service_class = ZFCP_FC_SERVICE_CLASS_DEFAULT;
-
-	sprintf(adapter->name, "%s", zfcp_get_busid_by_adapter(adapter));
-	ASCEBC(adapter->name, strlen(adapter->name));
-
 	/* mark adapter unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
@@ -1347,18 +1341,19 @@ static void
 zfcp_fsf_incoming_els_plogi(struct zfcp_adapter *adapter,
 			    struct fsf_status_read_buffer *status_buffer)
 {
-	logi *els_logi = (logi *) status_buffer->payload;
+	struct fsf_plogi *els_plogi;
 	struct zfcp_port *port;
 	unsigned long flags;
 
+	els_plogi = (struct fsf_plogi *) status_buffer->payload;
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &adapter->port_list_head, list) {
-		if (port->wwpn == (*(wwn_t *) & els_logi->nport_wwn))
+		if (port->wwpn == (*(wwn_t *) &els_plogi->serv_param.wwpn))
 			break;
 	}
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
-	if (!port || (port->wwpn != (*(wwn_t *) & els_logi->nport_wwn))) {
+	if (!port || (port->wwpn != (*(wwn_t *) &els_plogi->serv_param.wwpn))) {
 		ZFCP_LOG_DEBUG("ignored incoming PLOGI for nonexisting port "
 			       "with d_id 0x%08x on adapter %s\n",
 			       status_buffer->d_id,
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 362af4d..e93272f 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -39,7 +39,6 @@ #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
-#include "../../fc4/fc.h"
 #include "zfcp_fsf.h"
 #include <asm/ccwdev.h>
 #include <asm/qdio.h>
@@ -78,13 +77,9 @@ zfcp_address_to_sg(void *address, struct
 	list->offset = ((unsigned long) address) & (PAGE_SIZE - 1);
 }
 
-/********************* SCSI SPECIFIC DEFINES *********************************/
-
-/* 32 bit for SCSI ID and LUN as long as the SCSI stack uses this type */
-typedef u32 scsi_id_t;
-typedef u32 scsi_lun_t;
+#define REQUEST_LIST_SIZE 128
 
-#define ZFCP_ERP_SCSI_LOW_MEM_TIMEOUT           (100*HZ)
+/********************* SCSI SPECIFIC DEFINES *********************************/
 #define ZFCP_SCSI_ER_TIMEOUT                    (100*HZ)
 
 /********************* CIO/QDIO SPECIFIC DEFINES *****************************/
@@ -222,8 +217,9 @@ #define RSP_CODE_TASKMAN_UNSUPP	 4
 #define RSP_CODE_TASKMAN_FAILED	 5
 
 /* see fc-fs */
-#define LS_FAN 0x60000000
-#define LS_RSCN 0x61040000
+#define LS_RSCN  0x61040000
+#define LS_LOGO  0x05000000
+#define LS_PLOGI 0x03000000
 
 struct fcp_rscn_head {
         u8  command;
@@ -252,13 +248,6 @@ #define ZFCP_NO_PORTS_PER_AREA    0x100
 #define ZFCP_NO_PORTS_PER_DOMAIN  0x10000
 #define ZFCP_NO_PORTS_PER_FABRIC  0x1000000
 
-struct fcp_fan {
-        u32 command;
-        u32 fport_did;
-        wwn_t fport_wwpn;
-        wwn_t fport_wwname;
-} __attribute__((packed));
-
 /* see fc-ph */
 struct fcp_logo {
         u32 command;
@@ -496,9 +485,6 @@ #define ZFCP_CT_TIMEOUT			(3 * R_A_TOV)
 
 #define ZFCP_NAME               "zfcp"
 
-/* read-only LUN sharing switch initial value */
-#define ZFCP_RO_LUN_SHARING_DEFAULTS 0
-
 /* independent log areas */
 #define ZFCP_LOG_AREA_OTHER	0
 #define ZFCP_LOG_AREA_SCSI	1
@@ -597,7 +583,6 @@ #endif
  * and unit
  */
 #define ZFCP_COMMON_FLAGS			0xfff00000
-#define ZFCP_SPECIFIC_FLAGS			0x000fffff
 
 /* common status bits */
 #define ZFCP_STATUS_COMMON_REMOVE		0x80000000
@@ -622,11 +607,6 @@ #define ZFCP_STATUS_ADAPTER_ERP_PENDING	
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
 #define ZFCP_STATUS_ADAPTER_XPORT_OK		0x00000800
 
-#define ZFCP_STATUS_ADAPTER_SCSI_UP			\
-		(ZFCP_STATUS_COMMON_UNBLOCKED |	\
-		 ZFCP_STATUS_ADAPTER_REGISTERED)
-
-
 /* FC-PH/FC-GS well-known address identifiers for generic services */
 #define ZFCP_DID_MANAGEMENT_SERVICE		0xFFFFFA
 #define ZFCP_DID_TIME_SERVICE			0xFFFFFB
@@ -641,7 +621,6 @@ #define ZFCP_STATUS_PORT_PHYS_CLOSING		0
 #define ZFCP_STATUS_PORT_NO_WWPN		0x00000008
 #define ZFCP_STATUS_PORT_NO_SCSI_ID		0x00000010
 #define ZFCP_STATUS_PORT_INVALID_WWPN		0x00000020
-#define ZFCP_STATUS_PORT_ACCESS_DENIED		0x00000040
 
 /* for ports with well known addresses */
 #define ZFCP_STATUS_PORT_WKA \
@@ -897,15 +876,12 @@ struct zfcp_adapter {
 	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
 	u32			peer_d_id;	   /* P2P peer D_ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
-	u8			fc_service_class;
 	u32			hydra_version;	   /* Hydra version */
 	u32			fsf_lic_version;
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
-	unsigned short          scsi_host_no;      /* Assigned host number */
-	unsigned char		name[9];
 	struct list_head	port_list_head;	   /* remote port list */
 	struct list_head        port_remove_lh;    /* head of ports to be
 						      removed */
@@ -997,7 +973,7 @@ struct zfcp_unit {
 						  refcount drop to zero */
 	struct zfcp_port       *port;	       /* remote port of unit */
 	atomic_t	       status;	       /* status of this logical unit */
-	scsi_lun_t	       scsi_lun;       /* own SCSI LUN */
+	unsigned int	       scsi_lun;       /* own SCSI LUN */
 	fcp_lun_t	       fcp_lun;	       /* own FCP_LUN */
 	u32		       handle;	       /* handle assigned by FSF */
         struct scsi_device     *device;        /* scsi device struct pointer */
@@ -1041,11 +1017,6 @@ struct zfcp_data {
 	struct list_head	adapter_list_head;  /* head of adapter list */
 	struct list_head	adapter_remove_lh;  /* head of adapters to be
 						       removed */
-        rwlock_t                status_read_lock;   /* for status read thread */
-        struct list_head        status_read_receive_head;
-        struct list_head        status_read_send_head;
-        struct semaphore        status_read_sema;
-	wait_queue_head_t	status_read_thread_wqh;
 	u32			adapters;	    /* # of adapters in list */
 	rwlock_t                config_lock;        /* serialises changes
 						       to adapter/port/unit
@@ -1084,9 +1055,6 @@ struct zfcp_fsf_req_pool_element {
 
 /********************** ZFCP SPECIFIC DEFINES ********************************/
 
-#define ZFCP_FSFREQ_CLEANUP_TIMEOUT	HZ/10
-
-#define ZFCP_KNOWN              0x00000001
 #define ZFCP_REQ_AUTO_CLEANUP	0x00000002
 #define ZFCP_WAIT_FOR_SBAL	0x00000004
 #define ZFCP_REQ_NO_QTCB	0x00000008
@@ -1094,9 +1062,6 @@ #define ZFCP_REQ_NO_QTCB	0x00000008
 #define ZFCP_SET                0x00000100
 #define ZFCP_CLEAR              0x00000200
 
-#define ZFCP_INTERRUPTIBLE	1
-#define ZFCP_UNINTERRUPTIBLE	0
-
 #ifndef atomic_test_mask
 #define atomic_test_mask(mask, target) \
            ((atomic_read(target) & mask) == mask)
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index ea2e7a3..ce852c0 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -3407,7 +3407,7 @@ zfcp_erp_adapter_access_changed(struct z
 		return;
 
 	debug_text_event(adapter->erp_dbf, 3, "a_access_recover");
-	debug_event(adapter->erp_dbf, 3, &adapter->name, 8);
+	debug_event(adapter->erp_dbf, 3, zfcp_get_busid_by_adapter(adapter), 8);
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	if (adapter->nameserver_port)
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 4475e41..83b68e3 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1416,7 +1416,8 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 
 	/* settings in QTCB */
 	fsf_req->qtcb->header.port_handle = port->handle;
-	fsf_req->qtcb->bottom.support.service_class = adapter->fc_service_class;
+	fsf_req->qtcb->bottom.support.service_class =
+		ZFCP_FC_SERVICE_CLASS_DEFAULT;
 	fsf_req->qtcb->bottom.support.timeout = ct->timeout;
         fsf_req->data = (unsigned long) ct;
 
@@ -1485,18 +1486,10 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		break;
 
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		if (adapter->fc_service_class <= 3) {
-			ZFCP_LOG_INFO("error: adapter %s does not support fc "
-				      "class %d.\n",
-				      zfcp_get_busid_by_port(port),
-				      adapter->fc_service_class);
-		} else {
-			ZFCP_LOG_INFO("bug: The fibre channel class at the "
-				      "adapter %s is invalid. "
-				      "(debug info %d)\n",
-				      zfcp_get_busid_by_port(port),
-				      adapter->fc_service_class);
-		}
+		ZFCP_LOG_INFO("error: adapter %s does not support fc "
+			      "class %d.\n",
+			      zfcp_get_busid_by_port(port),
+			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
 		debug_text_exception(adapter->erp_dbf, 0, "fsf_s_class_nsup");
 		zfcp_erp_adapter_shutdown(adapter, 0);
@@ -1719,7 +1712,8 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 
 	/* settings in QTCB */
 	fsf_req->qtcb->bottom.support.d_id = d_id;
-	fsf_req->qtcb->bottom.support.service_class = adapter->fc_service_class;
+	fsf_req->qtcb->bottom.support.service_class =
+		ZFCP_FC_SERVICE_CLASS_DEFAULT;
 	fsf_req->qtcb->bottom.support.timeout = ZFCP_ELS_TIMEOUT;
 	fsf_req->data = (unsigned long) els;
 
@@ -1789,18 +1783,10 @@ static int zfcp_fsf_send_els_handler(str
 		break;
 
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		if (adapter->fc_service_class <= 3) {
-			ZFCP_LOG_INFO("error: adapter %s does "
-				      "not support fibrechannel class %d.\n",
-				      zfcp_get_busid_by_adapter(adapter),
-				      adapter->fc_service_class);
-		} else {
-			ZFCP_LOG_INFO("bug: The fibrechannel class at "
-				      "adapter %s is invalid. "
-				      "(debug info %d)\n",
-				      zfcp_get_busid_by_adapter(adapter),
-				      adapter->fc_service_class);
-		}
+		ZFCP_LOG_INFO("error: adapter %s does not support fc "
+			      "class %d.\n",
+			      zfcp_get_busid_by_adapter(adapter),
+			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
 		debug_text_exception(adapter->erp_dbf, 0, "fsf_s_class_nsup");
 		zfcp_erp_adapter_shutdown(adapter, 0);
@@ -2974,8 +2960,8 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 	erp_action->fsf_req->qtcb->bottom.support.fcp_lun =
 		erp_action->unit->fcp_lun;
 	if (!(erp_action->adapter->connection_features & FSF_FEATURE_NPIV_MODE))
-	erp_action->fsf_req->qtcb->bottom.support.option =
-		FSF_OPEN_LUN_SUPPRESS_BOXING;
+		erp_action->fsf_req->qtcb->bottom.support.option =
+			FSF_OPEN_LUN_SUPPRESS_BOXING;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
 	erp_action->fsf_req->data = (unsigned long) erp_action->unit;
 	erp_action->fsf_req->erp_action = erp_action;
@@ -3550,7 +3536,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	}
 
 	/* set FC service class in QTCB (3 per default) */
-	fsf_req->qtcb->bottom.io.service_class = adapter->fc_service_class;
+	fsf_req->qtcb->bottom.io.service_class = ZFCP_FC_SERVICE_CLASS_DEFAULT;
 
 	/* set FCP_LUN in FCP_CMND IU in QTCB */
 	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
@@ -3689,7 +3675,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	fsf_req->qtcb->header.lun_handle = unit->handle;
 	fsf_req->qtcb->header.port_handle = unit->port->handle;
 	fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
-	fsf_req->qtcb->bottom.io.service_class = adapter->fc_service_class;
+	fsf_req->qtcb->bottom.io.service_class = ZFCP_FC_SERVICE_CLASS_DEFAULT;
 	fsf_req->qtcb->bottom.io.fcp_cmnd_length =
 		sizeof (struct fcp_cmnd_iu) + sizeof (fcp_dl_t);
 
@@ -3812,18 +3798,10 @@ zfcp_fsf_send_fcp_command_handler(struct
 		break;
 
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		if (fsf_req->adapter->fc_service_class <= 3) {
-			ZFCP_LOG_NORMAL("error: The adapter %s does "
-					"not support fibrechannel class %d.\n",
-					zfcp_get_busid_by_unit(unit),
-					fsf_req->adapter->fc_service_class);
-		} else {
-			ZFCP_LOG_NORMAL("bug: The fibrechannel class at "
-					"adapter %s is invalid. "
-					"(debug info %d)\n",
-					zfcp_get_busid_by_unit(unit),
-					fsf_req->adapter->fc_service_class);
-		}
+		ZFCP_LOG_INFO("error: adapter %s does not support fc "
+			      "class %d.\n",
+			      zfcp_get_busid_by_unit(unit),
+			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
 		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 				     "fsf_s_class_nsup");
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index ca16dca..7118661 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -22,8 +22,7 @@
 #ifndef FSF_H
 #define FSF_H
 
-#define FSF_QTCB_VERSION1			0x00000001
-#define FSF_QTCB_CURRENT_VERSION		FSF_QTCB_VERSION1
+#define FSF_QTCB_CURRENT_VERSION		0x00000001
 
 /* FSF commands */
 #define	FSF_QTCB_FCP_CMND			0x00000001
@@ -53,7 +52,7 @@ #define FSF_CFDC_OPTION_FORCE			0x000000
 #define FSF_CFDC_OPTION_FULL_ACCESS		0x00000002
 #define FSF_CFDC_OPTION_RESTRICTED_ACCESS	0x00000004
 
-/* FSF protocol stati */
+/* FSF protocol states */
 #define FSF_PROT_GOOD				0x00000001
 #define FSF_PROT_QTCB_VERSION_ERROR		0x00000010
 #define FSF_PROT_SEQ_NUMB_ERROR			0x00000020
@@ -65,7 +64,7 @@ #define FSF_PROT_LINK_DOWN              
 #define FSF_PROT_REEST_QUEUE                    0x00000800
 #define FSF_PROT_ERROR_STATE			0x01000000
 
-/* FSF stati */
+/* FSF states */
 #define FSF_GOOD				0x00000000
 #define FSF_PORT_ALREADY_OPEN			0x00000001
 #define FSF_LUN_ALREADY_OPEN			0x00000002
@@ -258,20 +257,6 @@ #define FSF_UNIT_ACCESS_OPEN_LUN_ALLOWED
 #define FSF_UNIT_ACCESS_EXCLUSIVE		0x02000000
 #define FSF_UNIT_ACCESS_OUTBOUND_TRANSFER	0x10000000
 
-struct fsf_queue_designator;
-struct fsf_status_read_buffer;
-struct fsf_port_closed_payload;
-struct fsf_bit_error_payload;
-union  fsf_prot_status_qual;
-struct fsf_qual_version_error;
-struct fsf_qual_sequence_error;
-struct fsf_qtcb_prefix;
-struct fsf_qtcb_header;
-struct fsf_qtcb_bottom_config;
-struct fsf_qtcb_bottom_support;
-struct fsf_qtcb_bottom_io;
-union  fsf_qtcb_bottom;
-
 struct fsf_queue_designator {
 	u8  cssid;
 	u8  chpid;
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index dfb6644..345a191 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -168,7 +168,8 @@ zfcp_qdio_allocate(struct zfcp_adapter *
 
 	init_data->cdev = adapter->ccw_device;
 	init_data->q_format = QDIO_SCSI_QFMT;
-	memcpy(init_data->adapter_name, &adapter->name, 8);
+	memcpy(init_data->adapter_name, zfcp_get_busid_by_adapter(adapter), 8);
+	ASCEBC(init_data->adapter_name, 8);
 	init_data->qib_param_field_format = 0;
 	init_data->qib_param_field = NULL;
 	init_data->input_slib_elements = NULL;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3a180d8..f198814 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -35,8 +35,8 @@ static int zfcp_scsi_eh_host_reset_handl
 static int zfcp_task_management_function(struct zfcp_unit *, u8,
 					 struct scsi_cmnd *);
 
-static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *, int, scsi_id_t,
-					  scsi_lun_t);
+static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *, int,
+					  unsigned int, unsigned int);
 
 static struct device_attribute *zfcp_sysfs_sdev_attrs[];
 
@@ -349,8 +349,8 @@ zfcp_scsi_queuecommand(struct scsi_cmnd 
 }
 
 static struct zfcp_unit *
-zfcp_unit_lookup(struct zfcp_adapter *adapter, int channel, scsi_id_t id,
-		 scsi_lun_t lun)
+zfcp_unit_lookup(struct zfcp_adapter *adapter, int channel, unsigned int id,
+		 unsigned int lun)
 {
 	struct zfcp_port *port;
 	struct zfcp_unit *unit, *retval = NULL;
@@ -608,10 +608,6 @@ zfcp_adapter_scsi_register(struct zfcp_a
 	adapter->scsi_host->unique_id = unique_id++;	/* FIXME */
 	adapter->scsi_host->max_cmd_len = ZFCP_MAX_SCSI_CMND_LENGTH;
 	adapter->scsi_host->transportt = zfcp_transport_template;
-	/*
-	 * Reverse mapping of the host number to avoid race condition
-	 */
-	adapter->scsi_host_no = adapter->scsi_host->host_no;
 
 	/*
 	 * save a pointer to our own adapter data structure within
@@ -647,7 +643,6 @@ zfcp_adapter_scsi_unregister(struct zfcp
 	scsi_remove_host(shost);
 	scsi_host_put(shost);
 	adapter->scsi_host = NULL;
-	adapter->scsi_host_no = 0;
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_REGISTERED, &adapter->status);
 
 	return;
-- 
1.3.3.gd5e3d

