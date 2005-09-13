From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 2/6] zfcp: remove union zfcp_req_data, use unit refcount for FCP commands
Date: Tue, 13 Sep 2005 21:47:52 +0200
Message-ID: <20050913194752.GA7671@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:3578 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S932424AbVIMTua
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 15:50:30 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j8DJoSd7171304
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 19:50:28 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8DJoS7u141814
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:50:28 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j8DJoSLX024252
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:50:28 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: remove union zfcp_req_data, use unit refcount for FCP commands

o union zfcp_req_data removed
o increment unit refcount when processing FCP commands
 (This fixes a theoretical race: When all scsi commands of a unit
  are aborted and the scsi_device is removed then the unit could be
  removed before all fsf_requests of that unit are completely processed.)

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_aux.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_aux.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_aux.c	2005-09-13 20:32:42.148906409 +0200
@@ -141,7 +141,7 @@ zfcp_cmd_dbf_event_fsf(const char *text,
 
 	spin_lock_irqsave(&adapter->dbf_lock, flags);
 	if (zfcp_fsf_req_is_scsi_cmnd(fsf_req)) {
-		scsi_cmnd = fsf_req->data.send_fcp_command_task.scsi_cmnd;
+		scsi_cmnd = (struct scsi_cmnd*) fsf_req->data;
 		debug_text_event(adapter->cmd_dbf, level, "fsferror");
 		debug_text_event(adapter->cmd_dbf, level, text);
 		debug_event(adapter->cmd_dbf, level, &fsf_req,
@@ -167,14 +167,12 @@ void
 zfcp_cmd_dbf_event_scsi(const char *text, struct scsi_cmnd *scsi_cmnd)
 {
 	struct zfcp_adapter *adapter;
-	union zfcp_req_data *req_data;
 	struct zfcp_fsf_req *fsf_req;
 	int level = ((host_byte(scsi_cmnd->result) != 0) ? 1 : 5);
 	unsigned long flags;
 
 	adapter = (struct zfcp_adapter *) scsi_cmnd->device->host->hostdata[0];
-	req_data = (union zfcp_req_data *) scsi_cmnd->host_scribble;
-	fsf_req = (req_data ? req_data->send_fcp_command_task.fsf_req : NULL);
+	fsf_req = (struct zfcp_fsf_req  *) scsi_cmnd->host_scribble;
 	spin_lock_irqsave(&adapter->dbf_lock, flags);
 	debug_text_event(adapter->cmd_dbf, level, "hostbyte");
 	debug_text_event(adapter->cmd_dbf, level, text);
@@ -1609,7 +1607,7 @@ zfcp_fsf_incoming_els(struct zfcp_fsf_re
 	u32 els_type;
 	struct zfcp_adapter *adapter;
 
-	status_buffer = fsf_req->data.status_read.buffer;
+	status_buffer = (struct fsf_status_read_buffer *) fsf_req->data;
 	els_type = *(u32 *) (status_buffer->payload);
 	adapter = fsf_req->adapter;
 
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_def.h linux-2.6.14-rc1/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_def.h	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_def.h	2005-09-13 20:32:42.148906409 +0200
@@ -635,45 +635,6 @@ struct zfcp_adapter_mempool {
 	mempool_t *data_gid_pn;
 };
 
-struct  zfcp_exchange_config_data{
-};
-
-struct zfcp_open_port {
-        struct zfcp_port *port;
-};
-
-struct zfcp_close_port {
-	struct zfcp_port *port;
-};
-
-struct zfcp_open_unit {
-	struct zfcp_unit *unit;
-};
-
-struct zfcp_close_unit {
-	struct zfcp_unit *unit;
-};
-
-struct zfcp_close_physical_port {
-        struct zfcp_port *port;
-};
-
-struct zfcp_send_fcp_command_task {
-	struct zfcp_fsf_req *fsf_req;
-	struct zfcp_unit *unit;
- 	struct scsi_cmnd *scsi_cmnd;
-	unsigned long start_jiffies;
-};
-
-struct zfcp_send_fcp_command_task_management {
-	struct zfcp_unit *unit;
-};
-
-struct zfcp_abort_fcp_command {
-	struct zfcp_fsf_req *fsf_req;
-	struct zfcp_unit *unit;
-};
-
 /*
  * header for CT_IU
  */
@@ -781,33 +742,6 @@ struct zfcp_send_els {
 	int status;
 };
 
-struct zfcp_status_read {
-	struct fsf_status_read_buffer *buffer;
-};
-
-struct zfcp_fsf_done {
-	struct completion *complete;
-	int status;
-};
-
-/* request specific data */
-union zfcp_req_data {
-	struct zfcp_exchange_config_data exchange_config_data;
-	struct zfcp_open_port		  open_port;
-	struct zfcp_close_port		  close_port;
-	struct zfcp_open_unit		  open_unit;
-	struct zfcp_close_unit		  close_unit;
-	struct zfcp_close_physical_port	  close_physical_port;
-	struct zfcp_send_fcp_command_task send_fcp_command_task;
-        struct zfcp_send_fcp_command_task_management
-					  send_fcp_command_task_management;
-	struct zfcp_abort_fcp_command	  abort_fcp_command;
-	struct zfcp_send_ct *send_ct;
-	struct zfcp_send_els *send_els;
-	struct zfcp_status_read 	  status_read;
-	struct fsf_qtcb_bottom_port *port_data;
-};
-
 struct zfcp_qdio_queue {
 	struct qdio_buffer *buffer[QDIO_MAX_BUFFERS_PER_Q]; /* SBALs */
 	u8		   free_index;	      /* index of next free bfr
@@ -963,11 +897,12 @@ struct zfcp_fsf_req {
 	u32		       fsf_command;    /* FSF Command copy */
 	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
 	u32		       seq_no;         /* Sequence number of request */
-        union zfcp_req_data    data;           /* Info fields of request */ 
+        unsigned long          data;           /* private data of request */ 
 	struct zfcp_erp_action *erp_action;    /* used if this request is
 						  issued on behalf of erp */
 	mempool_t	       *pool;	       /* used if request was alloacted
 						  from emergency pool */
+	struct zfcp_unit       *unit;
 };
 
 typedef void zfcp_fsf_req_handler_t(struct zfcp_fsf_req*);
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_fsf.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_fsf.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_fsf.c	2005-09-13 20:32:42.000000000 +0200
@@ -821,7 +821,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
 		goto failed_buf;
 	}
 	memset(status_buffer, 0, sizeof (struct fsf_status_read_buffer));
-	fsf_req->data.status_read.buffer = status_buffer;
+	fsf_req->data = (unsigned long) status_buffer;
 
 	/* insert pointer to respective buffer */
 	sbale = zfcp_qdio_sbale_curr(fsf_req);
@@ -859,7 +859,7 @@ zfcp_fsf_status_read_port_closed(struct 
 	struct zfcp_port *port;
 	unsigned long flags;
 
-	status_buffer = fsf_req->data.status_read.buffer;
+	status_buffer = (struct fsf_status_read_buffer *) fsf_req->data;
 	adapter = fsf_req->adapter;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
@@ -918,7 +918,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 	int retval = 0;
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_status_read_buffer *status_buffer =
-	    fsf_req->data.status_read.buffer;
+		(struct fsf_status_read_buffer *) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		mempool_free(status_buffer, adapter->pool.data_status_read);
@@ -1093,7 +1093,7 @@ zfcp_fsf_abort_fcp_command(unsigned long
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	fsf_req->data.abort_fcp_command.unit = unit;
+	fsf_req->data = (unsigned long) unit;
 
 	/* set handles of unit and its parent port in QTCB */
 	fsf_req->qtcb->header.lun_handle = unit->handle;
@@ -1139,7 +1139,7 @@ static int
 zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *new_fsf_req)
 {
 	int retval = -EINVAL;
-	struct zfcp_unit *unit = new_fsf_req->data.abort_fcp_command.unit;
+	struct zfcp_unit *unit;
 	unsigned char status_qual =
 	    new_fsf_req->qtcb->header.fsf_status_qual.word[0];
 
@@ -1150,6 +1150,8 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		goto skip_fsfstatus;
 	}
 
+	unit = (struct zfcp_unit *) new_fsf_req->data;
+
 	/* evaluate FSF status in QTCB */
 	switch (new_fsf_req->qtcb->header.fsf_status) {
 
@@ -1414,7 +1416,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 	fsf_req->qtcb->header.port_handle = port->handle;
 	fsf_req->qtcb->bottom.support.service_class = adapter->fc_service_class;
 	fsf_req->qtcb->bottom.support.timeout = ct->timeout;
-        fsf_req->data.send_ct = ct;
+        fsf_req->data = (unsigned long) ct;
 
 	/* start QDIO request for this FSF request */
 	ret = zfcp_fsf_req_send(fsf_req, ct->timer);
@@ -1445,10 +1447,10 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
  * zfcp_fsf_send_ct_handler - handler for Generic Service requests
  * @fsf_req: pointer to struct zfcp_fsf_req
  *
- * Data specific for the Generic Service request is passed by
- * fsf_req->data.send_ct
- * Usually a specific handler for the request is called via
- * fsf_req->data.send_ct->handler at end of this function.
+ * Data specific for the Generic Service request is passed using
+ * fsf_req->data. There we find the pointer to struct zfcp_send_ct.
+ * Usually a specific handler for the CT request is called which is
+ * found in this structure.
  */
 static int
 zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *fsf_req)
@@ -1462,7 +1464,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 	u16 subtable, rule, counter;
 
 	adapter = fsf_req->adapter;
-	send_ct = fsf_req->data.send_ct;
+	send_ct = (struct zfcp_send_ct *) fsf_req->data;
 	port = send_ct->port;
 	header = &fsf_req->qtcb->header;
 	bottom = &fsf_req->qtcb->bottom.support;
@@ -1714,7 +1716,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 	fsf_req->qtcb->bottom.support.d_id = d_id;
 	fsf_req->qtcb->bottom.support.service_class = adapter->fc_service_class;
 	fsf_req->qtcb->bottom.support.timeout = ZFCP_ELS_TIMEOUT;
-	fsf_req->data.send_els = els;
+	fsf_req->data = (unsigned long) els;
 
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
 
@@ -1746,10 +1748,10 @@ zfcp_fsf_send_els(struct zfcp_send_els *
  * zfcp_fsf_send_els_handler - handler for ELS commands
  * @fsf_req: pointer to struct zfcp_fsf_req
  *
- * Data specific for the ELS command is passed by
- * fsf_req->data.send_els
- * Usually a specific handler for the command is called via
- * fsf_req->data.send_els->handler at end of this function.
+ * Data specific for the ELS command is passed using
+ * fsf_req->data. There we find the pointer to struct zfcp_send_els.
+ * Usually a specific handler for the ELS command is called which is
+ * found in this structure.
  */
 static int zfcp_fsf_send_els_handler(struct zfcp_fsf_req *fsf_req)
 {
@@ -1762,7 +1764,7 @@ static int zfcp_fsf_send_els_handler(str
 	int retval = -EINVAL;
 	u16 subtable, rule, counter;
 
-	send_els = fsf_req->data.send_els;
+	send_els = (struct zfcp_send_els *) fsf_req->data;
 	adapter = send_els->adapter;
 	port = send_els->port;
 	d_id = send_els->d_id;
@@ -2211,12 +2213,12 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 		goto out;
 	}
 
+	fsf_req->data = (unsigned long) data;
+
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-        fsf_req->data.port_data = data;
-
 	init_timer(timer);
 	timer->function = zfcp_fsf_request_timeout_handler;
 	timer->data = (unsigned long) adapter;
@@ -2257,7 +2259,9 @@ static void
 zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *fsf_req)
 {
 	struct fsf_qtcb_bottom_port *bottom;
-	struct fsf_qtcb_bottom_port *data = fsf_req->data.port_data;
+	struct fsf_qtcb_bottom_port *data;
+
+	data = (struct fsf_qtcb_bottom_port*) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
@@ -2312,7 +2316,7 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 
 	erp_action->fsf_req->qtcb->bottom.support.d_id = erp_action->port->d_id;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->port->status);
-	erp_action->fsf_req->data.open_port.port = erp_action->port;
+	erp_action->fsf_req->data = (unsigned long) erp_action->port;
 	erp_action->fsf_req->erp_action = erp_action;
 
 	/* start QDIO request for this FSF request */
@@ -2353,7 +2357,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 	struct fsf_qtcb_header *header;
 	u16 subtable, rule, counter;
 
-	port = fsf_req->data.open_port.port;
+	port = (struct zfcp_port *) fsf_req->data;
 	header = &fsf_req->qtcb->header;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
@@ -2566,7 +2570,7 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->port->status);
-	erp_action->fsf_req->data.close_port.port = erp_action->port;
+	erp_action->fsf_req->data = (unsigned long) erp_action->port;
 	erp_action->fsf_req->erp_action = erp_action;
 	erp_action->fsf_req->qtcb->header.port_handle =
 	    erp_action->port->handle;
@@ -2606,7 +2610,7 @@ zfcp_fsf_close_port_handler(struct zfcp_
 	int retval = -EINVAL;
 	struct zfcp_port *port;
 
-	port = fsf_req->data.close_port.port;
+	port = (struct zfcp_port *) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		/* don't change port status in our bookkeeping */
@@ -2703,7 +2707,7 @@ zfcp_fsf_close_physical_port(struct zfcp
 	atomic_set_mask(ZFCP_STATUS_PORT_PHYS_CLOSING,
 			&erp_action->port->status);
 	/* save a pointer to this port */
-	erp_action->fsf_req->data.close_physical_port.port = erp_action->port;
+	erp_action->fsf_req->data = (unsigned long) erp_action->port;
 	/* port to be closeed */
 	erp_action->fsf_req->qtcb->header.port_handle =
 	    erp_action->port->handle;
@@ -2747,7 +2751,7 @@ zfcp_fsf_close_physical_port_handler(str
 	struct fsf_qtcb_header *header;
 	u16 subtable, rule, counter;
 
-	port = fsf_req->data.close_physical_port.port;
+	port = (struct zfcp_port *) fsf_req->data;
 	header = &fsf_req->qtcb->header;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
@@ -2911,7 +2915,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 	erp_action->fsf_req->qtcb->bottom.support.option =
 		FSF_OPEN_LUN_SUPPRESS_BOXING;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
-	erp_action->fsf_req->data.open_unit.unit = erp_action->unit;
+	erp_action->fsf_req->data = (unsigned long) erp_action->unit;
 	erp_action->fsf_req->erp_action = erp_action;
 
 	/* start QDIO request for this FSF request */
@@ -2957,7 +2961,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 	u16 subtable, rule, counter;
 	u32 allowed, exclusive, readwrite;
 
-	unit = fsf_req->data.open_unit.unit;
+	unit = (struct zfcp_unit *) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		/* don't change unit status in our bookkeeping */
@@ -3242,7 +3246,7 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 	    erp_action->port->handle;
 	erp_action->fsf_req->qtcb->header.lun_handle = erp_action->unit->handle;
 	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->unit->status);
-	erp_action->fsf_req->data.close_unit.unit = erp_action->unit;
+	erp_action->fsf_req->data = (unsigned long) erp_action->unit;
 	erp_action->fsf_req->erp_action = erp_action;
 
 	/* start QDIO request for this FSF request */
@@ -3281,7 +3285,7 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 	int retval = -EINVAL;
 	struct zfcp_unit *unit;
 
-	unit = fsf_req->data.close_unit.unit;	/* restore unit */
+	unit = (struct zfcp_unit *) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		/* don't change unit status in our bookkeeping */
@@ -3436,21 +3440,14 @@ zfcp_fsf_send_fcp_command_task(struct zf
 		goto failed_req_create;
 	}
 
-	/*
-	 * associate FSF request with SCSI request
-	 * (need this for look up on abort)
-	 */
-	fsf_req->data.send_fcp_command_task.fsf_req = fsf_req;
-	scsi_cmnd->host_scribble = (char *) &(fsf_req->data);
+	zfcp_unit_get(unit);
+	fsf_req->unit = unit;
 
-	/*
-	 * associate SCSI command with FSF request
-	 * (need this for look up on normal command completion)
-	 */
-	fsf_req->data.send_fcp_command_task.scsi_cmnd = scsi_cmnd;
-	fsf_req->data.send_fcp_command_task.start_jiffies = jiffies;
-	fsf_req->data.send_fcp_command_task.unit = unit;
-	ZFCP_LOG_DEBUG("unit=%p, fcp_lun=0x%016Lx\n", unit, unit->fcp_lun);
+	/* associate FSF request with SCSI request (for look up on abort) */
+	scsi_cmnd->host_scribble = (char *) fsf_req;
+
+	/* associate SCSI command with FSF request */
+	fsf_req->data = (unsigned long) scsi_cmnd;
 
 	/* set handles of unit and its parent port in QTCB */
 	fsf_req->qtcb->header.lun_handle = unit->handle;
@@ -3584,6 +3581,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
  send_failed:
  no_fit:
  failed_scsi_cmnd:
+	zfcp_unit_put(unit);
 	zfcp_fsf_req_free(fsf_req);
 	fsf_req = NULL;
 	scsi_cmnd->host_scribble = NULL;
@@ -3640,7 +3638,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	 * hold a pointer to the unit being target of this
 	 * task management request
 	 */
-	fsf_req->data.send_fcp_command_task_management.unit = unit;
+	fsf_req->data = (unsigned long) unit;
 
 	/* set FSF related fields in QTCB */
 	fsf_req->qtcb->header.lun_handle = unit->handle;
@@ -3706,9 +3704,9 @@ zfcp_fsf_send_fcp_command_handler(struct
 	header = &fsf_req->qtcb->header;
 
 	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT))
-		unit = fsf_req->data.send_fcp_command_task_management.unit;
+		unit = (struct zfcp_unit *) fsf_req->data;
 	else
-		unit = fsf_req->data.send_fcp_command_task.unit;
+		unit = fsf_req->unit;
 
 	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		/* go directly to calls of special handlers */
@@ -3947,6 +3945,8 @@ zfcp_fsf_send_fcp_command_handler(struct
 		    zfcp_fsf_send_fcp_command_task_management_handler(fsf_req);
 	} else {
 		retval = zfcp_fsf_send_fcp_command_task_handler(fsf_req);
+		fsf_req->unit = NULL;
+		zfcp_unit_put(unit);
 	}
 	return retval;
 }
@@ -3970,10 +3970,10 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	u32 sns_len;
 	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
 	unsigned long flags;
-	struct zfcp_unit *unit = fsf_req->data.send_fcp_command_task.unit;
+	struct zfcp_unit *unit = fsf_req->unit;
 
 	read_lock_irqsave(&fsf_req->adapter->abort_lock, flags);
-	scpnt = fsf_req->data.send_fcp_command_task.scsi_cmnd;
+	scpnt = (struct scsi_cmnd *) fsf_req->data;
 	if (unlikely(!scpnt)) {
 		ZFCP_LOG_DEBUG
 		    ("Command with fsf_req %p is not associated to "
@@ -4198,8 +4198,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
 	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
-	struct zfcp_unit *unit =
-	    fsf_req->data.send_fcp_command_task_management.unit;
+	struct zfcp_unit *unit = (struct zfcp_unit *) fsf_req->data;
 
 	del_timer(&fsf_req->adapter->scsi_er_timer);
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_scsi.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_scsi.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_scsi.c	2005-09-13 20:34:42.098906409 +0200
@@ -414,67 +414,37 @@ zfcp_port_lookup(struct zfcp_adapter *ad
 	return (struct zfcp_port *) NULL;
 }
 
-/*
- * function:	zfcp_scsi_eh_abort_handler
- *
- * purpose:	tries to abort the specified (timed out) SCSI command
- *
- * note: 	We do not need to care for a SCSI command which completes
- *		normally but late during this abort routine runs.
- *		We are allowed to return late commands to the SCSI stack.
- *		It tracks the state of commands and will handle late commands.
- *		(Usually, the normal completion of late commands is ignored with
- *		respect to the running abort operation. Grep for 'done_late'
- *		in the SCSI stacks sources.)
- *
- * returns:	SUCCESS	- command has been aborted and cleaned up in internal
- *			  bookkeeping,
- *			  SCSI stack won't be called for aborted command
- *		FAILED	- otherwise
+/**
+ * zfcp_scsi_eh_abort_handler - abort the specified SCSI command
+ * @scpnt: pointer to scsi_cmnd to be aborted 
+ * Return: SUCCESS - command has been aborted and cleaned up in internal
+ *          bookkeeping, SCSI stack won't be called for aborted command
+ *         FAILED - otherwise
+ *
+ * We do not need to care for a SCSI command which completes normally
+ * but late during this abort routine runs.  We are allowed to return
+ * late commands to the SCSI stack.  It tracks the state of commands and
+ * will handle late commands.  (Usually, the normal completion of late
+ * commands is ignored with respect to the running abort operation.)
  */
 int
-__zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
+zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
+ 	struct Scsi_Host *scsi_host;
+ 	struct zfcp_adapter *adapter;
+	struct zfcp_unit *unit;
 	int retval = SUCCESS;
 	struct zfcp_fsf_req *new_fsf_req, *old_fsf_req;
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) scpnt->device->host->hostdata[0];
-	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
-	struct zfcp_port *port = unit->port;
-	struct Scsi_Host *scsi_host = scpnt->device->host;
-	union zfcp_req_data *req_data = NULL;
 	unsigned long flags;
-	u32 status = 0;
 
-	/* the components of a abort_dbf record (fixed size record) */
-	u64 dbf_scsi_cmnd = (unsigned long) scpnt;
-	char dbf_opcode[ZFCP_ABORT_DBF_LENGTH];
-	wwn_t dbf_wwn = port->wwpn;
-	fcp_lun_t dbf_fcp_lun = unit->fcp_lun;
-	u64 dbf_retries = scpnt->retries;
-	u64 dbf_allowed = scpnt->allowed;
-	u64 dbf_timeout = 0;
-	u64 dbf_fsf_req = 0;
-	u64 dbf_fsf_status = 0;
-	u64 dbf_fsf_qual[2] = { 0, 0 };
-	char dbf_result[ZFCP_ABORT_DBF_LENGTH] = "##undef";
-
-	memset(dbf_opcode, 0, ZFCP_ABORT_DBF_LENGTH);
-	memcpy(dbf_opcode,
-	       scpnt->cmnd,
-	       min(scpnt->cmd_len, (unsigned char) ZFCP_ABORT_DBF_LENGTH));
+	scsi_host = scpnt->device->host;
+	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
+	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 
 	ZFCP_LOG_INFO("aborting scsi_cmnd=%p on adapter %s\n",
 		      scpnt, zfcp_get_busid_by_adapter(adapter));
 
-	spin_unlock_irq(scsi_host->host_lock);
-
-	/*
-	 * Race condition between normal (late) completion and abort has
-	 * to be avoided.
-	 * The entirity of all accesses to scsi_req have to be atomic.
-	 * scsi_req is usually part of the fsf_req and thus we block the
-	 * release of fsf_req as long as we need to access scsi_req.
-	 */
+	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
 	/*
@@ -484,144 +454,48 @@ __zfcp_scsi_eh_abort_handler(struct scsi
 	 * this routine returns. (scpnt is parameter passed to this routine
 	 * and must not disappear during abort even on late completion.)
 	 */
-	req_data = (union zfcp_req_data *) scpnt->host_scribble;
-	/* DEBUG */
-	ZFCP_LOG_DEBUG("req_data=%p\n", req_data);
-	if (!req_data) {
-		ZFCP_LOG_DEBUG("late command completion overtook abort\n");
-		/*
-		 * That's it.
-		 * Do not initiate abort but return SUCCESS.
-		 */
-		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		retval = SUCCESS;
-		strncpy(dbf_result, "##late1", ZFCP_ABORT_DBF_LENGTH);
-		goto out;
-	}
-
-	/* Figure out which fsf_req needs to be aborted. */
-	old_fsf_req = req_data->send_fcp_command_task.fsf_req;
-
-	dbf_fsf_req = (unsigned long) old_fsf_req;
-	dbf_timeout =
-	    (jiffies - req_data->send_fcp_command_task.start_jiffies) / HZ;
-
-	ZFCP_LOG_DEBUG("old_fsf_req=%p\n", old_fsf_req);
+	old_fsf_req = (struct zfcp_fsf_req *) scpnt->host_scribble;
 	if (!old_fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		ZFCP_LOG_NORMAL("bug: no old fsf request found\n");
-		ZFCP_LOG_NORMAL("req_data:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) req_data, sizeof (union zfcp_req_data));
 		ZFCP_LOG_NORMAL("scsi_cmnd:\n");
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) scpnt, sizeof (struct scsi_cmnd));
 		retval = FAILED;
-		strncpy(dbf_result, "##bug:r", ZFCP_ABORT_DBF_LENGTH);
 		goto out;
 	}
-	old_fsf_req->data.send_fcp_command_task.scsi_cmnd = NULL;
-	/* mark old request as being aborted */
+	old_fsf_req->data = 0;
 	old_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTING;
-	/*
-	 * We have to collect all information (e.g. unit) needed by 
-	 * zfcp_fsf_abort_fcp_command before calling that routine
-	 * since that routine is not allowed to access
-	 * fsf_req which it is going to abort.
-	 * This is because of we need to release fsf_req_list_lock
-	 * before calling zfcp_fsf_abort_fcp_command.
-	 * Since this lock will not be held, fsf_req may complete
-	 * late and may be released meanwhile.
-	 */
-	ZFCP_LOG_DEBUG("unit 0x%016Lx (%p)\n", unit->fcp_lun, unit);
 
-	/*
-	 * We block (call schedule)
-	 * That's why we must release the lock and enable the
-	 * interrupts before.
-	 * On the other hand we do not need the lock anymore since
-	 * all critical accesses to scsi_req are done.
-	 */
+	/* don't access old_fsf_req after releasing the abort_lock */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 	/* call FSF routine which does the abort */
 	new_fsf_req = zfcp_fsf_abort_fcp_command((unsigned long) old_fsf_req,
 						 adapter, unit, 0);
-	ZFCP_LOG_DEBUG("new_fsf_req=%p\n", new_fsf_req);
 	if (!new_fsf_req) {
 		retval = FAILED;
 		ZFCP_LOG_NORMAL("error: initiation of Abort FCP Cmnd "
 				"failed\n");
-		strncpy(dbf_result, "##nores", ZFCP_ABORT_DBF_LENGTH);
 		goto out;
 	}
 
 	/* wait for completion of abort */
-	ZFCP_LOG_DEBUG("waiting for cleanup...\n");
-#if 1
-	/*
-	 * FIXME:
-	 * copying zfcp_fsf_req_wait_and_cleanup code is not really nice
-	 */
 	__wait_event(new_fsf_req->completion_wq,
 		     new_fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
-	status = new_fsf_req->status;
-	dbf_fsf_status = new_fsf_req->qtcb->header.fsf_status;
-	/*
-	 * Ralphs special debug load provides timestamps in the FSF
-	 * status qualifier. This might be specified later if being
-	 * useful for debugging aborts.
-	 */
-	dbf_fsf_qual[0] =
-	    *(u64 *) & new_fsf_req->qtcb->header.fsf_status_qual.word[0];
-	dbf_fsf_qual[1] =
-	    *(u64 *) & new_fsf_req->qtcb->header.fsf_status_qual.word[2];
 	zfcp_fsf_req_free(new_fsf_req);
-#else
-	retval = zfcp_fsf_req_wait_and_cleanup(new_fsf_req,
-					       ZFCP_UNINTERRUPTIBLE, &status);
-#endif
-	ZFCP_LOG_DEBUG("Waiting for cleanup complete, status=0x%x\n", status);
+
 	/* status should be valid since signals were not permitted */
-	if (status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
+	if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
 		retval = SUCCESS;
-		strncpy(dbf_result, "##succ", ZFCP_ABORT_DBF_LENGTH);
-	} else if (status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
+	} else if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
 		retval = SUCCESS;
-		strncpy(dbf_result, "##late2", ZFCP_ABORT_DBF_LENGTH);
 	} else {
 		retval = FAILED;
-		strncpy(dbf_result, "##fail", ZFCP_ABORT_DBF_LENGTH);
 	}
-
  out:
-	debug_event(adapter->abort_dbf, 1, &dbf_scsi_cmnd, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_opcode, ZFCP_ABORT_DBF_LENGTH);
-	debug_event(adapter->abort_dbf, 1, &dbf_wwn, sizeof (wwn_t));
-	debug_event(adapter->abort_dbf, 1, &dbf_fcp_lun, sizeof (fcp_lun_t));
-	debug_event(adapter->abort_dbf, 1, &dbf_retries, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_allowed, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_timeout, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_req, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_status, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_qual[0], sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_qual[1], sizeof (u64));
-	debug_text_event(adapter->abort_dbf, 1, dbf_result);
-
-	spin_lock_irq(scsi_host->host_lock);
 	return retval;
 }
 
-int
-zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
-{
-	int rc;
-	struct Scsi_Host *scsi_host = scpnt->device->host;
-	spin_lock_irq(scsi_host->host_lock);
-	rc = __zfcp_scsi_eh_abort_handler(scpnt);
-	spin_unlock_irq(scsi_host->host_lock);
-	return rc;
-}
-
 /*
  * function:	zfcp_scsi_eh_device_reset_handler
  *
