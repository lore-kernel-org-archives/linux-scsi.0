From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/13] zfcp: remove unused references, declarations and flags
Date: Wed, 01 Oct 2008 12:42:16 +0200
Message-ID: <20081001104758.549683000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:54473 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYJAKsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:09 -0400
Content-Disposition: inline; filename=zfcp_unused_refs.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

 - Remove unused references and declarations, including one instance
   of the FC ls_adisc struct that has been defined twice.
 - Also remove the flags COMMON_OPENING, COMMON_CLOSING,
   ADAPTER_REGISTERED and XPORT_OK that are only set and cleared, but
   not checked anywhere.
 - Remove the zfcp specific atomic_test_mask makro. Simply use
   atomic_read directly instead.
 - Remove the zfcp internal sg helper functions and switch the places
   where it is still used to call sg_virt directly.
 - With the update of the QDIO code, the QDIO data structures no
   longer use the volatile type qualifier. Now we can also remove the
   volatile qualifiers from the zfcp code.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-09-30 13:11:23.000000000 +0200
@@ -67,14 +67,14 @@ static void zfcp_ccw_remove(struct ccw_d
 
 	list_for_each_entry_safe(port, p, &adapter->port_remove_lh, list) {
 		list_for_each_entry_safe(unit, u, &port->unit_remove_lh, list) {
-			if (atomic_test_mask(ZFCP_STATUS_UNIT_REGISTERED,
-				&unit->status))
+			if (atomic_read(&unit->status) &
+			    ZFCP_STATUS_UNIT_REGISTERED)
 				scsi_remove_device(unit->device);
 			zfcp_unit_dequeue(unit);
 		}
 		zfcp_port_dequeue(port);
 	}
-	zfcp_adapter_wait(adapter);
+	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
 	zfcp_adapter_dequeue(adapter);
 
 	up(&zfcp_data.config_sema);
--- a/drivers/s390/scsi/zfcp_def.h	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-09-30 13:11:23.000000000 +0200
@@ -39,29 +39,6 @@
 
 /********************* GENERAL DEFINES *********************************/
 
-/**
- * zfcp_sg_to_address - determine kernel address from struct scatterlist
- * @list: struct scatterlist
- * Return: kernel address
- */
-static inline void *
-zfcp_sg_to_address(struct scatterlist *list)
-{
-	return sg_virt(list);
-}
-
-/**
- * zfcp_address_to_sg - set up struct scatterlist from kernel address
- * @address: kernel address
- * @list: struct scatterlist
- * @size: buffer size
- */
-static inline void
-zfcp_address_to_sg(void *address, struct scatterlist *list, unsigned int size)
-{
-	sg_set_buf(list, address, size);
-}
-
 #define REQUEST_LIST_SIZE 128
 
 /********************* SCSI SPECIFIC DEFINES *********************************/
@@ -218,13 +195,6 @@ struct fcp_logo {
 #define ZFCP_LS_RSCN			0x61
 #define ZFCP_LS_RNID			0x78
 
-struct zfcp_ls_rjt_par {
-	u8 action;
- 	u8 reason_code;
- 	u8 reason_expl;
- 	u8 vendor_unique;
-} __attribute__ ((packed));
-
 struct zfcp_ls_adisc {
 	u8		code;
 	u8		field[3];
@@ -234,20 +204,6 @@ struct zfcp_ls_adisc {
 	u32		nport_id;
 } __attribute__ ((packed));
 
-struct zfcp_ls_adisc_acc {
-	u8		code;
-	u8		field[3];
-	u32		hard_nport_id;
-	u64		wwpn;
-	u64		wwnn;
-	u32		nport_id;
-} __attribute__ ((packed));
-
-struct zfcp_rc_entry {
-	u8 code;
-	const char *description;
-};
-
 /*
  * FC-GS-2 stuff
  */
@@ -281,9 +237,7 @@ struct zfcp_rc_entry {
 #define ZFCP_STATUS_COMMON_RUNNING		0x40000000
 #define ZFCP_STATUS_COMMON_ERP_FAILED		0x20000000
 #define ZFCP_STATUS_COMMON_UNBLOCKED		0x10000000
-#define ZFCP_STATUS_COMMON_OPENING              0x08000000
 #define ZFCP_STATUS_COMMON_OPEN                 0x04000000
-#define ZFCP_STATUS_COMMON_CLOSING              0x02000000
 #define ZFCP_STATUS_COMMON_ERP_INUSE		0x01000000
 #define ZFCP_STATUS_COMMON_ACCESS_DENIED	0x00800000
 #define ZFCP_STATUS_COMMON_ACCESS_BOXED		0x00400000
@@ -291,14 +245,12 @@ struct zfcp_rc_entry {
 
 /* adapter status */
 #define ZFCP_STATUS_ADAPTER_QDIOUP		0x00000002
-#define ZFCP_STATUS_ADAPTER_REGISTERED		0x00000004
 #define ZFCP_STATUS_ADAPTER_XCONFIG_OK		0x00000008
 #define ZFCP_STATUS_ADAPTER_HOST_CON_INIT	0x00000010
 #define ZFCP_STATUS_ADAPTER_ERP_THREAD_UP	0x00000020
 #define ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL	0x00000080
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
-#define ZFCP_STATUS_ADAPTER_XPORT_OK		0x00000800
 
 /* FC-PH/FC-GS well-known address identifiers for generic services */
 #define ZFCP_DID_MANAGEMENT_SERVICE		0xFFFFFA
@@ -321,20 +273,16 @@ struct zfcp_rc_entry {
 		 ZFCP_STATUS_PORT_NO_SCSI_ID)
 
 /* logical unit status */
-#define ZFCP_STATUS_UNIT_TEMPORARY		0x00000002
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
 #define ZFCP_STATUS_UNIT_REGISTERED		0x00000010
 #define ZFCP_STATUS_UNIT_SCSI_WORK_PENDING	0x00000020
 
 /* FSF request status (this does not have a common part) */
-#define ZFCP_STATUS_FSFREQ_NOT_INIT		0x00000000
-#define ZFCP_STATUS_FSFREQ_POOL  		0x00000001
 #define ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT	0x00000002
 #define ZFCP_STATUS_FSFREQ_COMPLETED		0x00000004
 #define ZFCP_STATUS_FSFREQ_ERROR		0x00000008
 #define ZFCP_STATUS_FSFREQ_CLEANUP		0x00000010
-#define ZFCP_STATUS_FSFREQ_ABORTING		0x00000020
 #define ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED	0x00000040
 #define ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED       0x00000080
 #define ZFCP_STATUS_FSFREQ_ABORTED              0x00000100
@@ -475,7 +423,7 @@ struct zfcp_erp_action {
 	struct zfcp_adapter *adapter; /* device which should be recovered */
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
-	volatile u32 status;	      /* recovery status */
+	u32		status;	      /* recovery status */
 	u32 step;	              /* active step of this erp action */
 	struct zfcp_fsf_req *fsf_req; /* fsf request currently pending
 					 for this action */
@@ -626,7 +574,7 @@ struct zfcp_fsf_req {
 	u8			sbal_response;	/* SBAL used in interrupt */
 	wait_queue_head_t      completion_wq;  /* can be used by a routine
 						  to wait for completion */
-	volatile u32	       status;	       /* status of this request */
+	u32			status;	       /* status of this request */
 	u32		       fsf_command;    /* FSF Command copy */
 	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
 	u32		       seq_no;         /* Sequence number of request */
@@ -678,14 +626,7 @@ struct zfcp_fsf_req_qtcb {
 #define ZFCP_SET                0x00000100
 #define ZFCP_CLEAR              0x00000200
 
-#ifndef atomic_test_mask
-#define atomic_test_mask(mask, target) \
-           ((atomic_read(target) & mask) == mask)
-#endif
-
 #define zfcp_get_busid_by_adapter(adapter) (adapter->ccw_device->dev.bus_id)
-#define zfcp_get_busid_by_port(port) (zfcp_get_busid_by_adapter(port->adapter))
-#define zfcp_get_busid_by_unit(unit) (zfcp_get_busid_by_port(unit->port))
 
 /*
  * Helper functions for request ID management.
@@ -746,12 +687,6 @@ zfcp_unit_put(struct zfcp_unit *unit)
 }
 
 static inline void
-zfcp_unit_wait(struct zfcp_unit *unit)
-{
-	wait_event(unit->remove_wq, atomic_read(&unit->refcount) == 0);
-}
-
-static inline void
 zfcp_port_get(struct zfcp_port *port)
 {
 	atomic_inc(&port->refcount);
@@ -765,12 +700,6 @@ zfcp_port_put(struct zfcp_port *port)
 }
 
 static inline void
-zfcp_port_wait(struct zfcp_port *port)
-{
-	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
-}
-
-static inline void
 zfcp_adapter_get(struct zfcp_adapter *adapter)
 {
 	atomic_inc(&adapter->refcount);
@@ -783,10 +712,4 @@ zfcp_adapter_put(struct zfcp_adapter *ad
 		wake_up(&adapter->remove_wq);
 }
 
-static inline void
-zfcp_adapter_wait(struct zfcp_adapter *adapter)
-{
-	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
-}
-
 #endif /* ZFCP_DEF_H */
--- a/drivers/s390/scsi/zfcp_fc.c	2008-09-30 13:11:08.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-09-30 13:11:23.000000000 +0200
@@ -47,10 +47,11 @@ static void _zfcp_fc_incoming_rscn(struc
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
-		if (atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
+		if ((atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA) ==
+		      ZFCP_STATUS_PORT_WKA)
 			continue;
 		/* FIXME: ZFCP_STATUS_PORT_DID_DID check is racy */
-		if (!atomic_test_mask(ZFCP_STATUS_PORT_DID_DID, &port->status))
+		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_DID_DID))
 			/* Try to connect to unused ports anyway. */
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -255,14 +256,14 @@ struct zfcp_els_adisc {
 	struct scatterlist req;
 	struct scatterlist resp;
 	struct zfcp_ls_adisc ls_adisc;
-	struct zfcp_ls_adisc_acc ls_adisc_acc;
+	struct zfcp_ls_adisc ls_adisc_acc;
 };
 
 static void zfcp_fc_adisc_handler(unsigned long data)
 {
 	struct zfcp_els_adisc *adisc = (struct zfcp_els_adisc *) data;
 	struct zfcp_port *port = adisc->els.port;
-	struct zfcp_ls_adisc_acc *ls_adisc = &adisc->ls_adisc_acc;
+	struct zfcp_ls_adisc *ls_adisc = &adisc->ls_adisc_acc;
 
 	if (adisc->els.status) {
 		/* request rejected or timed out */
@@ -295,7 +296,7 @@ static int zfcp_fc_adisc(struct zfcp_por
 	sg_init_one(adisc->els.req, &adisc->ls_adisc,
 		    sizeof(struct zfcp_ls_adisc));
 	sg_init_one(adisc->els.resp, &adisc->ls_adisc_acc,
-		    sizeof(struct zfcp_ls_adisc_acc));
+		    sizeof(struct zfcp_ls_adisc));
 
 	adisc->els.req_count = 1;
 	adisc->els.resp_count = 1;
@@ -345,16 +346,16 @@ static int zfcp_scan_get_nameserver(stru
 	if (!adapter->nameserver_port)
 		return -EINTR;
 
-	if (!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-			       &adapter->nameserver_port->status)) {
+	if (!(atomic_read(&adapter->nameserver_port->status) &
+	      ZFCP_STATUS_COMMON_UNBLOCKED)) {
 		ret = zfcp_erp_port_reopen(adapter->nameserver_port, 0, 148,
 					   NULL);
 		if (ret)
 			return ret;
 		zfcp_erp_wait(adapter);
 	}
-	return !atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-				  &adapter->nameserver_port->status);
+	return !(atomic_read(&adapter->nameserver_port->status) &
+		 ZFCP_STATUS_COMMON_UNBLOCKED);
 }
 
 static void zfcp_gpn_ft_handler(unsigned long _done)
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-09-30 13:11:23.000000000 +0200
@@ -28,7 +28,7 @@ static int zfcp_qdio_buffers_enqueue(str
 	return 0;
 }
 
-static volatile struct qdio_buffer_element *
+static struct qdio_buffer_element *
 zfcp_qdio_sbale(struct zfcp_qdio_queue *q, int sbal_idx, int sbale_idx)
 {
 	return &q->sbal[sbal_idx]->element[sbale_idx];
@@ -145,7 +145,7 @@ static void zfcp_qdio_int_resp(struct cc
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) parm;
 	struct zfcp_qdio_queue *queue = &adapter->resp_q;
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	int sbal_idx, sbale_idx, sbal_no;
 
 	if (unlikely(qdio_err)) {
@@ -190,8 +190,7 @@ static void zfcp_qdio_int_resp(struct cc
  * @fsf_req: pointer to struct fsf_req
  * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
-volatile struct qdio_buffer_element *
-zfcp_qdio_sbale_req(struct zfcp_fsf_req *req)
+struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_fsf_req *req)
 {
 	return zfcp_qdio_sbale(&req->adapter->req_q, req->sbal_last, 0);
 }
@@ -201,8 +200,7 @@ zfcp_qdio_sbale_req(struct zfcp_fsf_req 
  * @fsf_req: pointer to struct fsf_req
  * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
-volatile struct qdio_buffer_element *
-zfcp_qdio_sbale_curr(struct zfcp_fsf_req *req)
+struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_fsf_req *req)
 {
 	return zfcp_qdio_sbale(&req->adapter->req_q, req->sbal_last,
 			       req->sbale_curr);
@@ -216,10 +214,10 @@ static void zfcp_qdio_sbal_limit(struct 
 					% QDIO_MAX_BUFFERS_PER_Q;
 }
 
-static volatile struct qdio_buffer_element *
+static struct qdio_buffer_element *
 zfcp_qdio_sbal_chain(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 
 	/* set last entry flag in current SBALE of current SBAL */
 	sbale = zfcp_qdio_sbale_curr(fsf_req);
@@ -250,7 +248,7 @@ zfcp_qdio_sbal_chain(struct zfcp_fsf_req
 	return sbale;
 }
 
-static volatile struct qdio_buffer_element *
+static struct qdio_buffer_element *
 zfcp_qdio_sbale_next(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
 {
 	if (fsf_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
@@ -273,7 +271,7 @@ static int zfcp_qdio_fill_sbals(struct z
 				unsigned int sbtype, void *start_addr,
 				unsigned int total_length)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	unsigned long remaining, length;
 	void *addr;
 
@@ -308,7 +306,7 @@ static int zfcp_qdio_fill_sbals(struct z
 int zfcp_qdio_sbals_from_sg(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
 			    struct scatterlist *sg, int max_sbals)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	int retval, bytes = 0;
 
 	/* figure out last allowed SBAL */
@@ -345,7 +343,7 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 	int first = fsf_req->sbal_first;
 	int count = fsf_req->sbal_number;
 	int retval, pci, pci_batch;
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 
 	/* acknowledgements for transferred buffers */
 	pci_batch = req_q->pci_batch + count;
@@ -419,7 +417,7 @@ void zfcp_qdio_close(struct zfcp_adapter
 	struct zfcp_qdio_queue *req_q;
 	int first, count;
 
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return;
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
@@ -451,10 +449,10 @@ void zfcp_qdio_close(struct zfcp_adapter
  */
 int zfcp_qdio_open(struct zfcp_adapter *adapter)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	int cc;
 
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
 		return -EIO;
 
 	if (qdio_establish(&adapter->qdio_init_data))
--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:11:23.000000000 +0200
@@ -669,8 +669,6 @@ static int zfcp_erp_adapter_strategy_ope
 	int ret;
 	struct zfcp_adapter *adapter = act->adapter;
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-
 	write_lock_irq(&adapter->erp_lock);
 	zfcp_erp_action_to_running(act);
 	write_unlock_irq(&adapter->erp_lock);
@@ -741,8 +739,7 @@ static int zfcp_erp_adapter_strategy_gen
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
  failed_qdio:
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
-			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-			  ZFCP_STATUS_ADAPTER_XPORT_OK,
+			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
 			  &act->adapter->status);
 	return retval;
 }
@@ -751,15 +748,11 @@ static int zfcp_erp_adapter_strategy(str
 {
 	int retval;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &act->adapter->status);
 	zfcp_erp_adapter_strategy_generic(act, 1); /* close */
-	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING, &act->adapter->status);
 	if (act->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
 		return ZFCP_ERP_EXIT;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &act->adapter->status);
 	retval = zfcp_erp_adapter_strategy_generic(act, 0); /* open */
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING, &act->adapter->status);
 
 	if (retval == ZFCP_ERP_FAILED)
 		ssleep(8);
@@ -783,9 +776,7 @@ static int zfcp_erp_port_forced_strategy
 
 static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
-			  ZFCP_STATUS_COMMON_CLOSING |
-			  ZFCP_STATUS_COMMON_ACCESS_DENIED |
+	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_PORT_DID_DID |
 			  ZFCP_STATUS_PORT_PHYS_CLOSING |
 			  ZFCP_STATUS_PORT_INVALID_WWPN,
@@ -998,9 +989,7 @@ static int zfcp_erp_port_strategy(struct
 
 static void zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
 {
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
-			  ZFCP_STATUS_COMMON_CLOSING |
-			  ZFCP_STATUS_COMMON_ACCESS_DENIED |
+	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_UNIT_SHARED |
 			  ZFCP_STATUS_UNIT_READONLY,
 			  &unit->status);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-09-30 13:11:23.000000000 +0200
@@ -621,7 +621,6 @@ static void zfcp_fsf_exchange_port_evalu
 
 static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_adapter *adapter = req->adapter;
 	struct fsf_qtcb *qtcb = req->qtcb;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
@@ -630,11 +629,9 @@ static void zfcp_fsf_exchange_port_data_
 	switch (qtcb->header.fsf_status) {
 	case FSF_GOOD:
 		zfcp_fsf_exchange_port_evaluate(req);
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
 		zfcp_fsf_exchange_port_evaluate(req);
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
 		zfcp_fsf_link_down_info_eval(req, 43,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
@@ -708,7 +705,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 						u32 fsf_cmd, int req_flags,
 						mempool_t *pool)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 
 	struct zfcp_fsf_req *req;
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
@@ -810,7 +807,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 {
 	struct zfcp_fsf_req *req;
 	struct fsf_status_read_buffer *sr_buf;
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	int retval = -EIO;
 
 	spin_lock_bh(&adapter->req_q.lock);
@@ -923,7 +920,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 						struct zfcp_unit *unit,
 						int req_flags)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 
 	spin_lock(&adapter->req_q.lock);
@@ -1171,8 +1168,8 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 		goto out;
 	}
 
-	ret = zfcp_fsf_setup_sbals(req, els->req, els->resp,
-				   FSF_MAX_SBALS_PER_ELS_REQ);
+	ret = zfcp_fsf_setup_sbals(req, els->req, els->resp, 2);
+
 	if (ret)
 		goto failed_send;
 
@@ -1201,7 +1198,7 @@ out:
 
 int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	int retval = -EIO;
@@ -1245,7 +1242,7 @@ out:
 int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
 				       struct fsf_qtcb_bottom_config *data)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
@@ -1294,7 +1291,7 @@ out:
  */
 int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	int retval = -EIO;
@@ -1341,7 +1338,7 @@ out:
 int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
 				     struct fsf_qtcb_bottom_port *data)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
@@ -1386,7 +1383,7 @@ static void zfcp_fsf_open_port_handler(s
 	struct fsf_plogi *plogi;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		goto skip_fsfstatus;
+		return;
 
 	switch (header->fsf_status) {
 	case FSF_PORT_ALREADY_OPEN:
@@ -1456,9 +1453,6 @@ static void zfcp_fsf_open_port_handler(s
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
-
-skip_fsfstatus:
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING, &port->status);
 }
 
 /**
@@ -1468,7 +1462,7 @@ skip_fsfstatus:
  */
 int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1495,7 +1489,6 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	req->data = erp_action->port;
 	req->erp_action = erp_action;
 	erp_action->fsf_req = req;
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->port->status);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
@@ -1513,7 +1506,7 @@ static void zfcp_fsf_close_port_handler(
 	struct zfcp_port *port = req->data;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		goto skip_fsfstatus;
+		return;
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
@@ -1528,9 +1521,6 @@ static void zfcp_fsf_close_port_handler(
 					    ZFCP_CLEAR);
 		break;
 	}
-
-skip_fsfstatus:
-	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING, &port->status);
 }
 
 /**
@@ -1540,7 +1530,7 @@ skip_fsfstatus:
  */
 int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1566,7 +1556,6 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	req->erp_action = erp_action;
 	req->qtcb->header.port_handle = erp_action->port->handle;
 	erp_action->fsf_req = req;
-	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->port->status);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
@@ -1637,7 +1626,7 @@ skip_fsfstatus:
  */
 int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1688,7 +1677,7 @@ static void zfcp_fsf_open_unit_handler(s
 	int exclusive, readwrite;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		goto skip_fsfstatus;
+		return;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_COMMON_ACCESS_BOXED |
@@ -1798,9 +1787,6 @@ static void zfcp_fsf_open_unit_handler(s
 		}
 		break;
 	}
-
-skip_fsfstatus:
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING, &unit->status);
 }
 
 /**
@@ -1810,7 +1796,7 @@ skip_fsfstatus:
  */
 int zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1841,8 +1827,6 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE))
 		req->qtcb->bottom.support.option = FSF_OPEN_LUN_SUPPRESS_BOXING;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
-
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
@@ -1859,7 +1843,7 @@ static void zfcp_fsf_close_unit_handler(
 	struct zfcp_unit *unit = req->data;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		goto skip_fsfstatus;
+		return;
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
@@ -1889,8 +1873,6 @@ static void zfcp_fsf_close_unit_handler(
 		atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
 		break;
 	}
-skip_fsfstatus:
-	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING, &unit->status);
 }
 
 /**
@@ -1900,7 +1882,7 @@ skip_fsfstatus:
  */
 int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1926,7 +1908,6 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	req->data = erp_action->unit;
 	req->erp_action = erp_action;
 	erp_action->fsf_req = req;
-	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->unit->status);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
@@ -2275,7 +2256,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 					   struct zfcp_unit *unit,
 					   u8 tm_flags, int req_flags)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd_iu *fcp_cmnd_iu;
 
@@ -2335,7 +2316,7 @@ static void zfcp_fsf_control_file_handle
 struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 					   struct zfcp_fsf_cfdc *fsf_cfdc)
 {
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	struct fsf_qtcb_bottom_support *bottom;
 	int direction, retval = -EIO, bytes;
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-09-30 13:11:23.000000000 +0200
@@ -183,7 +183,6 @@ static int zfcp_scsi_eh_abort_handler(st
 		return retval;
 	}
 	fsf_req->data = NULL;
-	fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTING;
 
 	/* don't access old fsf_req after releasing the abort_lock */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
@@ -313,7 +312,6 @@ int zfcp_adapter_scsi_register(struct zf
 		scsi_host_put(adapter->scsi_host);
 		return -EIO;
 	}
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_REGISTERED, &adapter->status);
 
 	return 0;
 }
@@ -337,7 +335,6 @@ void zfcp_adapter_scsi_unregister(struct
 	scsi_remove_host(shost);
 	scsi_host_put(shost);
 	adapter->scsi_host = NULL;
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_REGISTERED, &adapter->status);
 
 	return;
 }
--- a/drivers/s390/scsi/zfcp_aux.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-09-30 13:11:23.000000000 +0200
@@ -351,7 +351,7 @@ err_out_free:
  */
 void zfcp_unit_dequeue(struct zfcp_unit *unit)
 {
-	zfcp_unit_wait(unit);
+	wait_event(unit->remove_wq, atomic_read(&unit->refcount) == 0);
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&unit->list);
 	write_unlock_irq(&zfcp_data.config_lock);
@@ -740,7 +740,7 @@ err_out:
  */
 void zfcp_port_dequeue(struct zfcp_port *port)
 {
-	zfcp_port_wait(port);
+	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&port->list);
 	port->adapter->ports--;
--- a/drivers/s390/scsi/zfcp_fsf.h	2008-09-30 13:11:08.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-09-30 13:11:23.000000000 +0200
@@ -71,13 +71,6 @@
 #define FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED	0x00000041
 #define FSF_ELS_COMMAND_REJECTED		0x00000050
 #define FSF_GENERIC_COMMAND_REJECTED		0x00000051
-#define FSF_OPERATION_PARTIALLY_SUCCESSFUL	0x00000052
-#define FSF_AUTHORIZATION_FAILURE		0x00000053
-#define FSF_CFDC_ERROR_DETECTED			0x00000054
-#define FSF_CONTROL_FILE_UPDATE_ERROR		0x00000055
-#define FSF_CONTROL_FILE_TOO_LARGE		0x00000056
-#define FSF_ACCESS_CONFLICT_DETECTED		0x00000057
-#define FSF_CONFLICTS_OVERRULED			0x00000058
 #define FSF_PORT_BOXED				0x00000059
 #define FSF_LUN_BOXED				0x0000005A
 #define FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE	0x0000005B
@@ -85,9 +78,7 @@
 #define FSF_REQUEST_SIZE_TOO_LARGE		0x00000061
 #define FSF_RESPONSE_SIZE_TOO_LARGE		0x00000062
 #define FSF_SBAL_MISMATCH			0x00000063
-#define FSF_OPEN_PORT_WITHOUT_PRLI		0x00000064
 #define FSF_ADAPTER_STATUS_AVAILABLE		0x000000AD
-#define FSF_FCP_RSP_AVAILABLE			0x000000AF
 #define FSF_UNKNOWN_COMMAND			0x000000E2
 #define FSF_UNKNOWN_OP_SUBTYPE                  0x000000E3
 #define FSF_INVALID_COMMAND_OPTION              0x000000E5
@@ -102,20 +93,9 @@
 #define FSF_SQ_RETRY_IF_POSSIBLE		0x02
 #define FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED	0x03
 #define FSF_SQ_INVOKE_LINK_TEST_PROCEDURE	0x04
-#define FSF_SQ_ULP_PROGRAMMING_ERROR		0x05
 #define FSF_SQ_COMMAND_ABORTED			0x06
 #define FSF_SQ_NO_RETRY_POSSIBLE		0x07
 
-/* FSF status qualifier for CFDC commands */
-#define FSF_SQ_CFDC_HARDENED_ON_SE		0x00000000
-#define FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE	0x00000001
-#define FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE2	0x00000002
-/* CFDC subtable codes */
-#define FSF_SQ_CFDC_SUBTABLE_OS			0x0001
-#define FSF_SQ_CFDC_SUBTABLE_PORT_WWPN		0x0002
-#define FSF_SQ_CFDC_SUBTABLE_PORT_DID		0x0003
-#define FSF_SQ_CFDC_SUBTABLE_LUN		0x0004
-
 /* FSF status qualifier (most significant 4 bytes), local link down */
 #define FSF_PSQ_LINK_NO_LIGHT			0x00000004
 #define FSF_PSQ_LINK_WRAP_PLUG			0x00000008
@@ -145,7 +125,6 @@
 #define FSF_STATUS_READ_LINK_UP          	0x00000006
 #define FSF_STATUS_READ_NOTIFICATION_LOST	0x00000009
 #define FSF_STATUS_READ_CFDC_UPDATED		0x0000000A
-#define FSF_STATUS_READ_CFDC_HARDENED		0x0000000B
 #define FSF_STATUS_READ_FEATURE_UPDATE_ALERT	0x0000000C
 
 /* status subtypes in status read buffer */
@@ -159,20 +138,9 @@
 
 /* status subtypes for unsolicited status notification lost */
 #define FSF_STATUS_READ_SUB_INCOMING_ELS	0x00000001
-#define FSF_STATUS_READ_SUB_SENSE_DATA		0x00000002
-#define FSF_STATUS_READ_SUB_LINK_STATUS		0x00000004
-#define FSF_STATUS_READ_SUB_PORT_CLOSED		0x00000008
-#define FSF_STATUS_READ_SUB_BIT_ERROR_THRESHOLD	0x00000010
 #define FSF_STATUS_READ_SUB_ACT_UPDATED		0x00000020
-#define FSF_STATUS_READ_SUB_ACT_HARDENED	0x00000040
-#define FSF_STATUS_READ_SUB_FEATURE_UPDATE_ALERT 0x00000080
-
-/* status subtypes for CFDC */
-#define FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE	0x00000002
-#define FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE2 0x0000000F
 
 /* topologie that is detected by the adapter */
-#define FSF_TOPO_ERROR				0x00000000
 #define FSF_TOPO_P2P				0x00000001
 #define FSF_TOPO_FABRIC				0x00000002
 #define FSF_TOPO_AL				0x00000003
@@ -180,17 +148,13 @@
 /* data direction for FCP commands */
 #define FSF_DATADIR_WRITE			0x00000001
 #define FSF_DATADIR_READ			0x00000002
-#define FSF_DATADIR_READ_WRITE			0x00000003
 #define FSF_DATADIR_CMND			0x00000004
 
 /* fc service class */
-#define FSF_CLASS_1				0x00000001
-#define FSF_CLASS_2				0x00000002
 #define FSF_CLASS_3				0x00000003
 
 /* SBAL chaining */
 #define FSF_MAX_SBALS_PER_REQ			36
-#define FSF_MAX_SBALS_PER_ELS_REQ		2
 
 /* logging space behind QTCB */
 #define FSF_QTCB_LOG_SIZE			1024
@@ -200,50 +164,16 @@
 #define FSF_FEATURE_LUN_SHARING			0x00000004
 #define FSF_FEATURE_NOTIFICATION_LOST		0x00000008
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
-#define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
 #define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 
 /* host connection features */
 #define FSF_FEATURE_NPIV_MODE			0x00000001
-#define FSF_FEATURE_VM_ASSIGNED_WWPN		0x00000002
 
 /* option */
 #define FSF_OPEN_LUN_SUPPRESS_BOXING		0x00000001
-#define FSF_OPEN_LUN_REPLICATE_SENSE		0x00000002
-
-/* adapter types */
-#define FSF_ADAPTER_TYPE_FICON                  0x00000001
-#define FSF_ADAPTER_TYPE_FICON_EXPRESS          0x00000002
-
-/* port types */
-#define FSF_HBA_PORTTYPE_UNKNOWN		0x00000001
-#define FSF_HBA_PORTTYPE_NOTPRESENT		0x00000003
-#define FSF_HBA_PORTTYPE_NPORT			0x00000005
-#define FSF_HBA_PORTTYPE_PTP			0x00000021
-/* following are not defined and used by FSF Spec
-   but are additionally defined by FC-HBA */
-#define FSF_HBA_PORTTYPE_OTHER			0x00000002
-#define FSF_HBA_PORTTYPE_NOTPRESENT		0x00000003
-#define FSF_HBA_PORTTYPE_NLPORT			0x00000006
-#define FSF_HBA_PORTTYPE_FLPORT			0x00000007
-#define FSF_HBA_PORTTYPE_FPORT			0x00000008
-#define FSF_HBA_PORTTYPE_LPORT			0x00000020
-
-/* port states */
-#define FSF_HBA_PORTSTATE_UNKNOWN		0x00000001
-#define FSF_HBA_PORTSTATE_ONLINE		0x00000002
-#define FSF_HBA_PORTSTATE_OFFLINE		0x00000003
-#define FSF_HBA_PORTSTATE_LINKDOWN		0x00000006
-#define FSF_HBA_PORTSTATE_ERROR			0x00000007
-
-/* IO states of adapter */
-#define FSF_IOSTAT_NPORT_RJT			0x00000004
-#define FSF_IOSTAT_FABRIC_RJT			0x00000005
-#define FSF_IOSTAT_LS_RJT			0x00000009
 
 /* open LUN access flags*/
-#define FSF_UNIT_ACCESS_OPEN_LUN_ALLOWED	0x01000000
 #define FSF_UNIT_ACCESS_EXCLUSIVE		0x02000000
 #define FSF_UNIT_ACCESS_OUTBOUND_TRANSFER	0x10000000
 
@@ -265,11 +195,6 @@ struct fsf_queue_designator {
 	u32 res1;
 } __attribute__ ((packed));
 
-struct fsf_port_closed_payload {
-	struct fsf_queue_designator queue_designator;
-	u32                         port_handle;
-} __attribute__ ((packed));
-
 struct fsf_bit_error_payload {
 	u32 res1;
 	u32 link_failure_error_count;
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-09-30 13:11:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-09-30 13:11:23.000000000 +0200
@@ -831,7 +831,7 @@ void zfcp_san_dbf_event_ct_request(struc
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_port *port = ct->port;
 	struct zfcp_adapter *adapter = port->adapter;
-	struct ct_hdr *hdr = zfcp_sg_to_address(ct->req);
+	struct ct_hdr *hdr = sg_virt(ct->req);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
 	unsigned long flags;
@@ -865,7 +865,7 @@ void zfcp_san_dbf_event_ct_response(stru
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_port *port = ct->port;
 	struct zfcp_adapter *adapter = port->adapter;
-	struct ct_hdr *hdr = zfcp_sg_to_address(ct->resp);
+	struct ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
 	unsigned long flags;
@@ -922,8 +922,8 @@ void zfcp_san_dbf_event_els_request(stru
 
 	zfcp_san_dbf_event_els("oels", 2, fsf_req,
 			       fc_host_port_id(els->adapter->scsi_host),
-			       els->d_id, *(u8 *) zfcp_sg_to_address(els->req),
-			       zfcp_sg_to_address(els->req), els->req->length);
+			       els->d_id, *(u8 *) sg_virt(els->req),
+			       sg_virt(els->req), els->req->length);
 }
 
 /**
@@ -936,8 +936,7 @@ void zfcp_san_dbf_event_els_response(str
 
 	zfcp_san_dbf_event_els("rels", 2, fsf_req, els->d_id,
 			       fc_host_port_id(els->adapter->scsi_host),
-			       *(u8 *)zfcp_sg_to_address(els->req),
-			       zfcp_sg_to_address(els->resp),
+			       *(u8 *)sg_virt(els->req), sg_virt(els->resp),
 			       els->resp->length);
 }
 
--- a/drivers/s390/scsi/zfcp_ext.h	2008-09-30 13:11:08.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-09-30 13:11:23.000000000 +0200
@@ -135,10 +135,8 @@ extern struct zfcp_fsf_req *zfcp_fsf_abo
 extern int zfcp_qdio_allocate(struct zfcp_adapter *);
 extern void zfcp_qdio_free(struct zfcp_adapter *);
 extern int zfcp_qdio_send(struct zfcp_fsf_req *);
-extern volatile struct qdio_buffer_element *zfcp_qdio_sbale_req(
-						struct zfcp_fsf_req *);
-extern volatile struct qdio_buffer_element *zfcp_qdio_sbale_curr(
-						struct zfcp_fsf_req *);
+extern struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_fsf_req *);
+extern struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_fsf_req *);
 extern int zfcp_qdio_sbals_from_sg(struct zfcp_fsf_req *, unsigned long,
 				   struct scatterlist *, int);
 extern int zfcp_qdio_open(struct zfcp_adapter *);

-- 
