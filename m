From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 6/7] zfcp: enhancement of zfcp debug features
Date: Sat, 3 Sep 2005 14:34:51 +0200
Message-ID: <20050903123451.GA7937@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:3534 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751408AbVICMhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:37:08 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83Cb6d7189672
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 12:37:06 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83Cb6ih169562
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:37:06 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83Cb5G6015472
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:37:06 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

From: Maxim Shchetynin <maxim@de.ibm.com>

zfcp: enhancement of zfcp debug features

Debug features (DBFs) els_dbf, cmd_dbf and abt_dbf were removed and
san_dbf, hba_dbf and scsi_dbf were introduced. The erp_dbf did not
change. 
The new traces improve debugging of problems with zfcp, scsi-stack,
multipath and hardware in the SAN. san_dbf traces things like ELS and
CT commands, hba_dbf saves HBA specific information of requests, and
scsi_dbf saves FCP and SCSI specific information of requests. Common
to all new DBFs is that they provide a so called structured view. This
significantly improves readability of the traces.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 Makefile    |    2 
 zfcp_aux.c  |  180 ----------
 zfcp_dbf.c  |  988 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 zfcp_def.h  |  213 ++++++++++--
 zfcp_ext.h  |   26 +
 zfcp_fsf.c  |  241 +++-----------
 zfcp_fsf.h  |    3 
 zfcp_qdio.c |   30 -
 zfcp_scsi.c |   46 ++
 9 files changed, 1299 insertions(+), 430 deletions(-)

diff -Nup linux-2.6.13/drivers/s390/scsi-orig/Makefile linux-2.6.13/drivers/s390/scsi/Makefile
--- linux-2.6.13/drivers/s390/scsi-orig/Makefile	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/Makefile	2005-09-03 12:23:14.000000000 +0200
@@ -3,7 +3,7 @@
 #
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
-	     zfcp_fsf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
+	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
 	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_aux.c linux-2.6.13/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_aux.c	2005-09-03 12:21:07.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_aux.c	2005-09-03 12:23:14.000000000 +0200
@@ -122,93 +122,6 @@ _zfcp_hex_dump(char *addr, int count)
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_OTHER
 
-static inline int
-zfcp_fsf_req_is_scsi_cmnd(struct zfcp_fsf_req *fsf_req)
-{
-	return ((fsf_req->fsf_command == FSF_QTCB_FCP_CMND) &&
-		!(fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT));
-}
-
-void
-zfcp_cmd_dbf_event_fsf(const char *text, struct zfcp_fsf_req *fsf_req,
-		       void *add_data, int add_length)
-{
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct scsi_cmnd *scsi_cmnd;
-	int level = 3;
-	int i;
-	unsigned long flags;
-
-	spin_lock_irqsave(&adapter->dbf_lock, flags);
-	if (zfcp_fsf_req_is_scsi_cmnd(fsf_req)) {
-		scsi_cmnd = (struct scsi_cmnd*) fsf_req->data;
-		debug_text_event(adapter->cmd_dbf, level, "fsferror");
-		debug_text_event(adapter->cmd_dbf, level, text);
-		debug_event(adapter->cmd_dbf, level, &fsf_req,
-			    sizeof (unsigned long));
-		debug_event(adapter->cmd_dbf, level, &fsf_req->seq_no,
-			    sizeof (u32));
-		debug_event(adapter->cmd_dbf, level, &scsi_cmnd,
-			    sizeof (unsigned long));
-		debug_event(adapter->cmd_dbf, level, &scsi_cmnd->cmnd,
-			    min(ZFCP_CMD_DBF_LENGTH, (int)scsi_cmnd->cmd_len));
-		for (i = 0; i < add_length; i += ZFCP_CMD_DBF_LENGTH)
-			debug_event(adapter->cmd_dbf,
-				    level,
-				    (char *) add_data + i,
-				    min(ZFCP_CMD_DBF_LENGTH, add_length - i));
-	}
-	spin_unlock_irqrestore(&adapter->dbf_lock, flags);
-}
-
-/* XXX additionally log unit if available */
-/* ---> introduce new parameter for unit, see 2.4 code */
-void
-zfcp_cmd_dbf_event_scsi(const char *text, struct scsi_cmnd *scsi_cmnd)
-{
-	struct zfcp_adapter *adapter;
-	struct zfcp_fsf_req *fsf_req;
-	int level = ((host_byte(scsi_cmnd->result) != 0) ? 1 : 5);
-	unsigned long flags;
-
-	adapter = (struct zfcp_adapter *) scsi_cmnd->device->host->hostdata[0];
-	fsf_req = (struct zfcp_fsf_req  *) scsi_cmnd->host_scribble;
-	spin_lock_irqsave(&adapter->dbf_lock, flags);
-	debug_text_event(adapter->cmd_dbf, level, "hostbyte");
-	debug_text_event(adapter->cmd_dbf, level, text);
-	debug_event(adapter->cmd_dbf, level, &scsi_cmnd->result, sizeof (u32));
-	debug_event(adapter->cmd_dbf, level, &scsi_cmnd,
-		    sizeof (unsigned long));
-	debug_event(adapter->cmd_dbf, level, &scsi_cmnd->cmnd,
-		    min(ZFCP_CMD_DBF_LENGTH, (int)scsi_cmnd->cmd_len));
-	if (likely(fsf_req)) {
-		debug_event(adapter->cmd_dbf, level, &fsf_req,
-			    sizeof (unsigned long));
-		debug_event(adapter->cmd_dbf, level, &fsf_req->seq_no,
-			    sizeof (u32));
-	} else {
-		debug_text_event(adapter->cmd_dbf, level, "");
-		debug_text_event(adapter->cmd_dbf, level, "");
-	}
-	spin_unlock_irqrestore(&adapter->dbf_lock, flags);
-}
-
-void
-zfcp_in_els_dbf_event(struct zfcp_adapter *adapter, const char *text,
-		      struct fsf_status_read_buffer *status_buffer, int length)
-{
-	int level = 1;
-	int i;
-
-	debug_text_event(adapter->in_els_dbf, level, text);
-	debug_event(adapter->in_els_dbf, level, &status_buffer->d_id, 8);
-	for (i = 0; i < length; i += ZFCP_IN_ELS_DBF_LENGTH)
-		debug_event(adapter->in_els_dbf,
-			    level,
-			    (char *) status_buffer->payload + i,
-			    min(ZFCP_IN_ELS_DBF_LENGTH, length - i));
-}
-
 /**
  * zfcp_device_setup - setup function
  * @str: pointer to parameter string
@@ -1015,81 +928,6 @@ zfcp_free_low_mem_buffers(struct zfcp_ad
 		mempool_destroy(adapter->pool.data_gid_pn);
 }
 
-/**
- * zfcp_adapter_debug_register - registers debug feature for an adapter
- * @adapter: pointer to adapter for which debug features should be registered
- * return: -ENOMEM on error, 0 otherwise
- */
-int
-zfcp_adapter_debug_register(struct zfcp_adapter *adapter)
-{
-	char dbf_name[20];
-
-	/* debug feature area which records SCSI command failures (hostbyte) */
-	spin_lock_init(&adapter->dbf_lock);
-
-	sprintf(dbf_name, ZFCP_CMD_DBF_NAME "%s",
-		zfcp_get_busid_by_adapter(adapter));
-	adapter->cmd_dbf = debug_register(dbf_name, ZFCP_CMD_DBF_INDEX,
-					  ZFCP_CMD_DBF_AREAS,
-					  ZFCP_CMD_DBF_LENGTH);
-	debug_register_view(adapter->cmd_dbf, &debug_hex_ascii_view);
-	debug_set_level(adapter->cmd_dbf, ZFCP_CMD_DBF_LEVEL);
-
-	/* debug feature area which records SCSI command aborts */
-	sprintf(dbf_name, ZFCP_ABORT_DBF_NAME "%s",
-		zfcp_get_busid_by_adapter(adapter));
-	adapter->abort_dbf = debug_register(dbf_name, ZFCP_ABORT_DBF_INDEX,
-					    ZFCP_ABORT_DBF_AREAS,
-					    ZFCP_ABORT_DBF_LENGTH);
-	debug_register_view(adapter->abort_dbf, &debug_hex_ascii_view);
-	debug_set_level(adapter->abort_dbf, ZFCP_ABORT_DBF_LEVEL);
-
-	/* debug feature area which records incoming ELS commands */
-	sprintf(dbf_name, ZFCP_IN_ELS_DBF_NAME "%s",
-		zfcp_get_busid_by_adapter(adapter));
-	adapter->in_els_dbf = debug_register(dbf_name, ZFCP_IN_ELS_DBF_INDEX,
-					     ZFCP_IN_ELS_DBF_AREAS,
-					     ZFCP_IN_ELS_DBF_LENGTH);
-	debug_register_view(adapter->in_els_dbf, &debug_hex_ascii_view);
-	debug_set_level(adapter->in_els_dbf, ZFCP_IN_ELS_DBF_LEVEL);
-
-	/* debug feature area which records erp events */
-	sprintf(dbf_name, ZFCP_ERP_DBF_NAME "%s",
-		zfcp_get_busid_by_adapter(adapter));
-	adapter->erp_dbf = debug_register(dbf_name, ZFCP_ERP_DBF_INDEX,
-					  ZFCP_ERP_DBF_AREAS,
-					  ZFCP_ERP_DBF_LENGTH);
-	debug_register_view(adapter->erp_dbf, &debug_hex_ascii_view);
-	debug_set_level(adapter->erp_dbf, ZFCP_ERP_DBF_LEVEL);
-
-	if (!(adapter->cmd_dbf && adapter->abort_dbf &&
-	      adapter->in_els_dbf && adapter->erp_dbf)) {
-		zfcp_adapter_debug_unregister(adapter);
-		return -ENOMEM;
-	}
-
-	return 0;
-
-}
-
-/**
- * zfcp_adapter_debug_unregister - unregisters debug feature for an adapter
- * @adapter: pointer to adapter for which debug features should be unregistered
- */
-void
-zfcp_adapter_debug_unregister(struct zfcp_adapter *adapter)
-{
- 	debug_unregister(adapter->abort_dbf);
- 	debug_unregister(adapter->cmd_dbf);
- 	debug_unregister(adapter->erp_dbf);
- 	debug_unregister(adapter->in_els_dbf);
-	adapter->abort_dbf = NULL;
-	adapter->cmd_dbf = NULL;
-	adapter->erp_dbf = NULL;
-	adapter->in_els_dbf = NULL;
-}
-
 void
 zfcp_dummy_release(struct device *dev)
 {
@@ -1460,10 +1298,6 @@ zfcp_fsf_incoming_els_rscn(struct zfcp_a
 	/* see FC-FS */
 	no_entries = (fcp_rscn_head->payload_len / 4);
 
-	zfcp_in_els_dbf_event(adapter, "##rscn", status_buffer,
-			      fcp_rscn_head->payload_len);
-
-	debug_text_event(adapter->erp_dbf, 1, "unsol_els_rscn:");
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
 		fcp_rscn_element++;
@@ -1495,8 +1329,6 @@ zfcp_fsf_incoming_els_rscn(struct zfcp_a
 			    (ZFCP_STATUS_PORT_DID_DID, &port->status)) {
 				ZFCP_LOG_INFO("incoming RSCN, trying to open "
 					      "port 0x%016Lx\n", port->wwpn);
-				debug_text_event(adapter->erp_dbf, 1,
-						 "unsol_els_rscnu:");
 				zfcp_erp_port_reopen(port,
 						     ZFCP_STATUS_COMMON_ERP_FAILED);
 				continue;
@@ -1522,8 +1354,6 @@ zfcp_fsf_incoming_els_rscn(struct zfcp_a
 				 */
 				ZFCP_LOG_INFO("incoming RSCN, trying to open "
 					      "port 0x%016Lx\n", port->wwpn);
-				debug_text_event(adapter->erp_dbf, 1,
-						 "unsol_els_rscnk:");
 				zfcp_test_link(port);
 			}
 		}
@@ -1539,8 +1369,6 @@ zfcp_fsf_incoming_els_plogi(struct zfcp_
 	struct zfcp_port *port;
 	unsigned long flags;
 
-	zfcp_in_els_dbf_event(adapter, "##plogi", status_buffer, 28);
-
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &adapter->port_list_head, list) {
 		if (port->wwpn == (*(wwn_t *) & els_logi->nport_wwn))
@@ -1554,8 +1382,6 @@ zfcp_fsf_incoming_els_plogi(struct zfcp_
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
-		debug_text_event(adapter->erp_dbf, 1, "unsol_els_plogi:");
-		debug_event(adapter->erp_dbf, 1, &els_logi->nport_wwn, 8);
 		zfcp_erp_port_forced_reopen(port, 0);
 	}
 }
@@ -1568,8 +1394,6 @@ zfcp_fsf_incoming_els_logo(struct zfcp_a
 	struct zfcp_port *port;
 	unsigned long flags;
 
-	zfcp_in_els_dbf_event(adapter, "##logo", status_buffer, 16);
-
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &adapter->port_list_head, list) {
 		if (port->wwpn == els_logo->nport_wwpn)
@@ -1583,8 +1407,6 @@ zfcp_fsf_incoming_els_logo(struct zfcp_a
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
-		debug_text_event(adapter->erp_dbf, 1, "unsol_els_logo:");
-		debug_event(adapter->erp_dbf, 1, &els_logo->nport_wwpn, 8);
 		zfcp_erp_port_forced_reopen(port, 0);
 	}
 }
@@ -1593,7 +1415,6 @@ static void
 zfcp_fsf_incoming_els_unknown(struct zfcp_adapter *adapter,
 			      struct fsf_status_read_buffer *status_buffer)
 {
-	zfcp_in_els_dbf_event(adapter, "##undef", status_buffer, 24);
 	ZFCP_LOG_NORMAL("warning: unknown incoming ELS 0x%08x "
 			"for adapter %s\n", *(u32 *) (status_buffer->payload),
 			zfcp_get_busid_by_adapter(adapter));
@@ -1611,6 +1432,7 @@ zfcp_fsf_incoming_els(struct zfcp_fsf_re
 	els_type = *(u32 *) (status_buffer->payload);
 	adapter = fsf_req->adapter;
 
+	zfcp_san_dbf_event_incoming_els(fsf_req);
 	if (els_type == LS_PLOGI)
 		zfcp_fsf_incoming_els_plogi(adapter, status_buffer);
 	else if (els_type == LS_LOGO)
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_dbf.c linux-2.6.13/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_dbf.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.13/drivers/s390/scsi/zfcp_dbf.c	2005-09-03 12:23:14.000000000 +0200
@@ -0,0 +1,988 @@
+/*
+ *
+ * linux/drivers/s390/scsi/zfcp_dbf.c
+ *
+ * FCP adapter driver for IBM eServer zSeries
+ *
+ * Debugging facilities
+ *
+ * (C) Copyright IBM Corp. 2005
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define ZFCP_DBF_REVISION "$Revision$"
+
+#include <asm/debug.h>
+#include <linux/ctype.h>
+#include "zfcp_ext.h"
+
+static u32 dbfsize = 4;
+
+module_param(dbfsize, uint, 0400);
+MODULE_PARM_DESC(dbfsize,
+		 "number of pages for each debug feature area (default 4)");
+
+#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_OTHER
+
+static inline int
+zfcp_dbf_stck(char *out_buf, const char *label, unsigned long long stck)
+{
+	unsigned long long sec;
+	struct timespec xtime;
+	int len = 0;
+
+	stck -= 0x8126d60e46000000LL - (0x3c26700LL * 1000000 * 4096);
+	sec = stck >> 12;
+	do_div(sec, 1000000);
+	xtime.tv_sec = sec;
+	stck -= (sec * 1000000) << 12;
+	xtime.tv_nsec = ((stck * 1000) >> 12);
+	len += sprintf(out_buf + len, "%-24s%011lu:%06lu\n",
+		       label, xtime.tv_sec, xtime.tv_nsec);
+
+	return len;
+}
+
+static int zfcp_dbf_tag(char *out_buf, const char *label, const char *tag)
+{
+	int len = 0, i;
+
+	len += sprintf(out_buf + len, "%-24s", label);
+	for (i = 0; i < ZFCP_DBF_TAG_SIZE; i++)
+		len += sprintf(out_buf + len, "%c", tag[i]);
+	len += sprintf(out_buf + len, "\n");
+
+	return len;
+}
+
+static int
+zfcp_dbf_view(char *out_buf, const char *label, const char *format, ...)
+{
+	va_list arg;
+	int len = 0;
+
+	len += sprintf(out_buf + len, "%-24s", label);
+	va_start(arg, format);
+	len += vsprintf(out_buf + len, format, arg);
+	va_end(arg);
+	len += sprintf(out_buf + len, "\n");
+
+	return len;
+}
+
+static int
+zfcp_dbf_view_dump(char *out_buf, const char *label,
+		   char *buffer, int buflen, int offset, int total_size)
+{
+	int len = 0;
+
+	if (offset == 0)
+		len += sprintf(out_buf + len, "%-24s  ", label);
+
+	while (buflen--) {
+		if (offset > 0) {
+			if ((offset % 32) == 0)
+				len += sprintf(out_buf + len, "\n%-24c  ", ' ');
+			else if ((offset % 4) == 0)
+				len += sprintf(out_buf + len, " ");
+		}
+		len += sprintf(out_buf + len, "%02x", *buffer++);
+		if (++offset == total_size) {
+			len += sprintf(out_buf + len, "\n");
+			break;
+		}
+	}
+
+	if (total_size == 0)
+		len += sprintf(out_buf + len, "\n");
+
+	return len;
+}
+
+static inline int
+zfcp_dbf_view_header(debug_info_t * id, struct debug_view *view, int area,
+		     debug_entry_t * entry, char *out_buf)
+{
+	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)DEBUG_DATA(entry);
+	int len = 0;
+
+	if (strncmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
+		len += zfcp_dbf_stck(out_buf + len, "timestamp",
+				     entry->id.stck);
+		len += zfcp_dbf_view(out_buf + len, "cpu", "%02i",
+				     entry->id.fields.cpuid);
+	} else {
+		len += zfcp_dbf_view_dump(out_buf + len, NULL,
+					  dump->data,
+					  dump->size,
+					  dump->offset, dump->total_size);
+		if ((dump->offset + dump->size) == dump->total_size)
+			len += sprintf(out_buf + len, "\n");
+	}
+
+	return len;
+}
+
+inline void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct fsf_qtcb *qtcb = fsf_req->qtcb;
+	union fsf_prot_status_qual *prot_status_qual =
+	    &qtcb->prefix.prot_status_qual;
+	union fsf_status_qual *fsf_status_qual = &qtcb->header.fsf_status_qual;
+	struct scsi_cmnd *scsi_cmnd;
+	struct zfcp_port *port;
+	struct zfcp_unit *unit;
+	struct zfcp_send_els *send_els;
+	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
+	struct zfcp_hba_dbf_record_response *response = &rec->type.response;
+	int level;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	memset(rec, 0, sizeof(struct zfcp_hba_dbf_record));
+	strncpy(rec->tag, "resp", ZFCP_DBF_TAG_SIZE);
+
+	if ((qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
+	    (qtcb->prefix.prot_status != FSF_PROT_FSF_STATUS_PRESENTED)) {
+		strncpy(rec->tag2, "perr", ZFCP_DBF_TAG_SIZE);
+		level = 1;
+	} else if (qtcb->header.fsf_status != FSF_GOOD) {
+		strncpy(rec->tag2, "ferr", ZFCP_DBF_TAG_SIZE);
+		level = 1;
+	} else if ((fsf_req->fsf_command == FSF_QTCB_OPEN_PORT_WITH_DID) ||
+		   (fsf_req->fsf_command == FSF_QTCB_OPEN_LUN)) {
+		strncpy(rec->tag2, "open", ZFCP_DBF_TAG_SIZE);
+		level = 4;
+	} else if ((prot_status_qual->doubleword[0] != 0) ||
+		   (prot_status_qual->doubleword[1] != 0) ||
+		   (fsf_status_qual->doubleword[0] != 0) ||
+		   (fsf_status_qual->doubleword[1] != 0)) {
+		strncpy(rec->tag2, "qual", ZFCP_DBF_TAG_SIZE);
+		level = 3;
+	} else {
+		strncpy(rec->tag2, "norm", ZFCP_DBF_TAG_SIZE);
+		level = 6;
+	}
+
+	response->fsf_command = fsf_req->fsf_command;
+	response->fsf_reqid = (unsigned long)fsf_req;
+	response->fsf_seqno = fsf_req->seq_no;
+	response->fsf_issued = fsf_req->issued;
+	response->fsf_prot_status = qtcb->prefix.prot_status;
+	response->fsf_status = qtcb->header.fsf_status;
+	memcpy(response->fsf_prot_status_qual,
+	       prot_status_qual, FSF_PROT_STATUS_QUAL_SIZE);
+	memcpy(response->fsf_status_qual,
+	       fsf_status_qual, FSF_STATUS_QUALIFIER_SIZE);
+	response->fsf_req_status = fsf_req->status;
+	response->sbal_first = fsf_req->sbal_first;
+	response->sbal_curr = fsf_req->sbal_curr;
+	response->sbal_last = fsf_req->sbal_last;
+	response->pool = fsf_req->pool != NULL;
+	response->erp_action = (unsigned long)fsf_req->erp_action;
+
+	switch (fsf_req->fsf_command) {
+	case FSF_QTCB_FCP_CMND:
+		if (fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
+			break;
+		scsi_cmnd = (struct scsi_cmnd *)fsf_req->data;
+		if (scsi_cmnd != NULL) {
+			response->data.send_fcp.scsi_cmnd
+			    = (unsigned long)scsi_cmnd;
+			response->data.send_fcp.scsi_serial
+			    = scsi_cmnd->serial_number;
+		}
+		break;
+
+	case FSF_QTCB_OPEN_PORT_WITH_DID:
+	case FSF_QTCB_CLOSE_PORT:
+	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
+		port = (struct zfcp_port *)fsf_req->data;
+		response->data.port.wwpn = port->wwpn;
+		response->data.port.d_id = port->d_id;
+		response->data.port.port_handle = qtcb->header.port_handle;
+		break;
+
+	case FSF_QTCB_OPEN_LUN:
+	case FSF_QTCB_CLOSE_LUN:
+		unit = (struct zfcp_unit *)fsf_req->data;
+		port = unit->port;
+		response->data.unit.wwpn = port->wwpn;
+		response->data.unit.fcp_lun = unit->fcp_lun;
+		response->data.unit.port_handle = qtcb->header.port_handle;
+		response->data.unit.lun_handle = qtcb->header.lun_handle;
+		break;
+
+	case FSF_QTCB_SEND_ELS:
+		send_els = (struct zfcp_send_els *)fsf_req->data;
+		response->data.send_els.d_id = qtcb->bottom.support.d_id;
+		response->data.send_els.ls_code = send_els->ls_code >> 24;
+		break;
+
+	case FSF_QTCB_ABORT_FCP_CMND:
+	case FSF_QTCB_SEND_GENERIC:
+	case FSF_QTCB_EXCHANGE_CONFIG_DATA:
+	case FSF_QTCB_EXCHANGE_PORT_DATA:
+	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
+	case FSF_QTCB_UPLOAD_CONTROL_FILE:
+		break;
+	}
+
+	debug_event(adapter->hba_dbf, level,
+		    rec, sizeof(struct zfcp_hba_dbf_record));
+	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+}
+
+inline void
+zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
+			     struct fsf_status_read_buffer *status_buffer)
+{
+	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	memset(rec, 0, sizeof(struct zfcp_hba_dbf_record));
+	strncpy(rec->tag, "stat", ZFCP_DBF_TAG_SIZE);
+	strncpy(rec->tag2, tag, ZFCP_DBF_TAG_SIZE);
+
+	rec->type.status.failed = adapter->status_read_failed;
+	if (status_buffer != NULL) {
+		rec->type.status.status_type = status_buffer->status_type;
+		rec->type.status.status_subtype = status_buffer->status_subtype;
+		memcpy(&rec->type.status.queue_designator,
+		       &status_buffer->queue_designator,
+		       sizeof(struct fsf_queue_designator));
+
+		switch (status_buffer->status_type) {
+		case FSF_STATUS_READ_SENSE_DATA_AVAIL:
+			rec->type.status.payload_size =
+			    ZFCP_DBF_UNSOL_PAYLOAD_SENSE_DATA_AVAIL;
+			break;
+
+		case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
+			rec->type.status.payload_size =
+			    ZFCP_DBF_UNSOL_PAYLOAD_BIT_ERROR_THRESHOLD;
+			break;
+
+		case FSF_STATUS_READ_LINK_DOWN:
+			rec->type.status.payload_size = sizeof(u64);
+			break;
+
+		}
+		memcpy(&rec->type.status.payload,
+		       &status_buffer->payload, rec->type.status.payload_size);
+	}
+
+	debug_event(adapter->hba_dbf, 2,
+		    rec, sizeof(struct zfcp_hba_dbf_record));
+	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+}
+
+inline void
+zfcp_hba_dbf_event_qdio(struct zfcp_adapter *adapter, unsigned int status,
+			unsigned int qdio_error, unsigned int siga_error,
+			int sbal_index, int sbal_count)
+{
+	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	memset(rec, 0, sizeof(struct zfcp_hba_dbf_record));
+	strncpy(rec->tag, "qdio", ZFCP_DBF_TAG_SIZE);
+	rec->type.qdio.status = status;
+	rec->type.qdio.qdio_error = qdio_error;
+	rec->type.qdio.siga_error = siga_error;
+	rec->type.qdio.sbal_index = sbal_index;
+	rec->type.qdio.sbal_count = sbal_count;
+	debug_event(adapter->hba_dbf, 0,
+		    rec, sizeof(struct zfcp_hba_dbf_record));
+	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+}
+
+static inline int
+zfcp_hba_dbf_view_response(char *out_buf,
+			   struct zfcp_hba_dbf_record_response *rec)
+{
+	int len = 0;
+
+	len += zfcp_dbf_view(out_buf + len, "fsf_command", "0x%08x",
+			     rec->fsf_command);
+	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
+			     rec->fsf_reqid);
+	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
+			     rec->fsf_seqno);
+	len += zfcp_dbf_stck(out_buf + len, "fsf_issued", rec->fsf_issued);
+	len += zfcp_dbf_view(out_buf + len, "fsf_prot_status", "0x%08x",
+			     rec->fsf_prot_status);
+	len += zfcp_dbf_view(out_buf + len, "fsf_status", "0x%08x",
+			     rec->fsf_status);
+	len += zfcp_dbf_view_dump(out_buf + len, "fsf_prot_status_qual",
+				  rec->fsf_prot_status_qual,
+				  FSF_PROT_STATUS_QUAL_SIZE,
+				  0, FSF_PROT_STATUS_QUAL_SIZE);
+	len += zfcp_dbf_view_dump(out_buf + len, "fsf_status_qual",
+				  rec->fsf_status_qual,
+				  FSF_STATUS_QUALIFIER_SIZE,
+				  0, FSF_STATUS_QUALIFIER_SIZE);
+	len += zfcp_dbf_view(out_buf + len, "fsf_req_status", "0x%08x",
+			     rec->fsf_req_status);
+	len += zfcp_dbf_view(out_buf + len, "sbal_first", "0x%02x",
+			     rec->sbal_first);
+	len += zfcp_dbf_view(out_buf + len, "sbal_curr", "0x%02x",
+			     rec->sbal_curr);
+	len += zfcp_dbf_view(out_buf + len, "sbal_last", "0x%02x",
+			     rec->sbal_last);
+	len += zfcp_dbf_view(out_buf + len, "pool", "0x%02x", rec->pool);
+
+	switch (rec->fsf_command) {
+	case FSF_QTCB_FCP_CMND:
+		if (rec->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
+			break;
+		len += zfcp_dbf_view(out_buf + len, "scsi_cmnd", "0x%0Lx",
+				     rec->data.send_fcp.scsi_cmnd);
+		len += zfcp_dbf_view(out_buf + len, "scsi_serial", "0x%016Lx",
+				     rec->data.send_fcp.scsi_serial);
+		break;
+
+	case FSF_QTCB_OPEN_PORT_WITH_DID:
+	case FSF_QTCB_CLOSE_PORT:
+	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
+		len += zfcp_dbf_view(out_buf + len, "wwpn", "0x%016Lx",
+				     rec->data.port.wwpn);
+		len += zfcp_dbf_view(out_buf + len, "d_id", "0x%06x",
+				     rec->data.port.d_id);
+		len += zfcp_dbf_view(out_buf + len, "port_handle", "0x%08x",
+				     rec->data.port.port_handle);
+		break;
+
+	case FSF_QTCB_OPEN_LUN:
+	case FSF_QTCB_CLOSE_LUN:
+		len += zfcp_dbf_view(out_buf + len, "wwpn", "0x%016Lx",
+				     rec->data.unit.wwpn);
+		len += zfcp_dbf_view(out_buf + len, "fcp_lun", "0x%016Lx",
+				     rec->data.unit.fcp_lun);
+		len += zfcp_dbf_view(out_buf + len, "port_handle", "0x%08x",
+				     rec->data.unit.port_handle);
+		len += zfcp_dbf_view(out_buf + len, "lun_handle", "0x%08x",
+				     rec->data.unit.lun_handle);
+		break;
+
+	case FSF_QTCB_SEND_ELS:
+		len += zfcp_dbf_view(out_buf + len, "d_id", "0x%06x",
+				     rec->data.send_els.d_id);
+		len += zfcp_dbf_view(out_buf + len, "ls_code", "0x%02x",
+				     rec->data.send_els.ls_code);
+		break;
+
+	case FSF_QTCB_ABORT_FCP_CMND:
+	case FSF_QTCB_SEND_GENERIC:
+	case FSF_QTCB_EXCHANGE_CONFIG_DATA:
+	case FSF_QTCB_EXCHANGE_PORT_DATA:
+	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
+	case FSF_QTCB_UPLOAD_CONTROL_FILE:
+		break;
+	}
+
+	return len;
+}
+
+static inline int
+zfcp_hba_dbf_view_status(char *out_buf, struct zfcp_hba_dbf_record_status *rec)
+{
+	int len = 0;
+
+	len += zfcp_dbf_view(out_buf + len, "failed", "0x%02x", rec->failed);
+	len += zfcp_dbf_view(out_buf + len, "status_type", "0x%08x",
+			     rec->status_type);
+	len += zfcp_dbf_view(out_buf + len, "status_subtype", "0x%08x",
+			     rec->status_subtype);
+	len += zfcp_dbf_view_dump(out_buf + len, "queue_designator",
+				  (char *)&rec->queue_designator,
+				  sizeof(struct fsf_queue_designator),
+				  0, sizeof(struct fsf_queue_designator));
+	len += zfcp_dbf_view_dump(out_buf + len, "payload",
+				  (char *)&rec->payload,
+				  rec->payload_size, 0, rec->payload_size);
+
+	return len;
+}
+
+static inline int
+zfcp_hba_dbf_view_qdio(char *out_buf, struct zfcp_hba_dbf_record_qdio *rec)
+{
+	int len = 0;
+
+	len += zfcp_dbf_view(out_buf + len, "status", "0x%08x", rec->status);
+	len += zfcp_dbf_view(out_buf + len, "qdio_error", "0x%08x",
+			     rec->qdio_error);
+	len += zfcp_dbf_view(out_buf + len, "siga_error", "0x%08x",
+			     rec->siga_error);
+	len += zfcp_dbf_view(out_buf + len, "sbal_index", "0x%02x",
+			     rec->sbal_index);
+	len += zfcp_dbf_view(out_buf + len, "sbal_count", "0x%02x",
+			     rec->sbal_count);
+
+	return len;
+}
+
+static int
+zfcp_hba_dbf_view_format(debug_info_t * id, struct debug_view *view,
+			 char *out_buf, const char *in_buf)
+{
+	struct zfcp_hba_dbf_record *rec = (struct zfcp_hba_dbf_record *)in_buf;
+	int len = 0;
+
+	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+		return 0;
+
+	len += zfcp_dbf_tag(out_buf + len, "tag", rec->tag);
+	if (isalpha(rec->tag2[0]))
+		len += zfcp_dbf_tag(out_buf + len, "tag2", rec->tag2);
+	if (strncmp(rec->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
+		len += zfcp_hba_dbf_view_response(out_buf + len,
+						  &rec->type.response);
+	else if (strncmp(rec->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
+		len += zfcp_hba_dbf_view_status(out_buf + len,
+						&rec->type.status);
+	else if (strncmp(rec->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
+		len += zfcp_hba_dbf_view_qdio(out_buf + len, &rec->type.qdio);
+
+	len += sprintf(out_buf + len, "\n");
+
+	return len;
+}
+
+struct debug_view zfcp_hba_dbf_view = {
+	"structured",
+	NULL,
+	&zfcp_dbf_view_header,
+	&zfcp_hba_dbf_view_format,
+	NULL,
+	NULL
+};
+
+inline void
+_zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
+			      fc_id_t s_id, fc_id_t d_id,
+			      void *buffer, int buflen)
+{
+	struct zfcp_send_ct *send_ct = (struct zfcp_send_ct *)fsf_req->data;
+	struct zfcp_port *port = send_ct->port;
+	struct zfcp_adapter *adapter = port->adapter;
+	struct ct_hdr *header = (struct ct_hdr *)buffer;
+	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
+	struct zfcp_san_dbf_record_ct *ct = &rec->type.ct;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	memset(rec, 0, sizeof(struct zfcp_san_dbf_record));
+	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
+	rec->fsf_reqid = (unsigned long)fsf_req;
+	rec->fsf_seqno = fsf_req->seq_no;
+	rec->s_id = s_id;
+	rec->d_id = d_id;
+	if (strncmp(tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
+		ct->type.request.cmd_req_code = header->cmd_rsp_code;
+		ct->type.request.revision = header->revision;
+		ct->type.request.gs_type = header->gs_type;
+		ct->type.request.gs_subtype = header->gs_subtype;
+		ct->type.request.options = header->options;
+		ct->type.request.max_res_size = header->max_res_size;
+	} else if (strncmp(tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
+		ct->type.response.cmd_rsp_code = header->cmd_rsp_code;
+		ct->type.response.revision = header->revision;
+		ct->type.response.reason_code = header->reason_code;
+		ct->type.response.reason_code_expl = header->reason_code_expl;
+		ct->type.response.vendor_unique = header->vendor_unique;
+	}
+	ct->payload_size =
+	    min(buflen - (int)sizeof(struct ct_hdr), ZFCP_DBF_CT_PAYLOAD);
+	memcpy(ct->payload, buffer + sizeof(struct ct_hdr), ct->payload_size);
+	debug_event(adapter->san_dbf, 3,
+		    rec, sizeof(struct zfcp_san_dbf_record));
+	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
+}
+
+inline void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
+	struct zfcp_port *port = ct->port;
+	struct zfcp_adapter *adapter = port->adapter;
+
+	_zfcp_san_dbf_event_common_ct("octc",
+				      fsf_req, adapter->s_id, port->d_id,
+				      zfcp_sg_to_address(ct->req),
+				      ct->req->length);
+}
+
+inline void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
+	struct zfcp_port *port = ct->port;
+	struct zfcp_adapter *adapter = port->adapter;
+
+	_zfcp_san_dbf_event_common_ct("rctc",
+				      fsf_req, port->d_id, adapter->s_id,
+				      zfcp_sg_to_address(ct->resp),
+				      ct->resp->length);
+}
+
+static inline void
+_zfcp_san_dbf_event_common_els(const char *tag, int level,
+			       struct zfcp_fsf_req *fsf_req,
+			       fc_id_t s_id, fc_id_t d_id, u8 ls_code,
+			       void *buffer, int buflen)
+{
+	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
+	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
+	unsigned long flags;
+	int offset = 0;
+
+	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	do {
+		memset(rec, 0, sizeof(struct zfcp_san_dbf_record));
+		if (offset == 0) {
+			strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
+			rec->fsf_reqid = (unsigned long)fsf_req;
+			rec->fsf_seqno = fsf_req->seq_no;
+			rec->s_id = s_id;
+			rec->d_id = d_id;
+			rec->type.els.ls_code = ls_code;
+			buflen = min(buflen, ZFCP_DBF_ELS_MAX_PAYLOAD);
+			rec->type.els.payload_size = buflen;
+			memcpy(rec->type.els.payload,
+			       buffer, min(buflen, ZFCP_DBF_ELS_PAYLOAD));
+			offset += min(buflen, ZFCP_DBF_ELS_PAYLOAD);
+		} else {
+			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
+			dump->total_size = buflen;
+			dump->offset = offset;
+			dump->size = min(buflen - offset,
+					 (int)sizeof(struct zfcp_san_dbf_record)
+					 - (int)sizeof(struct zfcp_dbf_dump));
+			memcpy(dump->data, buffer + offset, dump->size);
+			offset += dump->size;
+		}
+		debug_event(adapter->san_dbf, level,
+			    rec, sizeof(struct zfcp_san_dbf_record));
+	} while (offset < buflen);
+	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
+}
+
+inline void zfcp_san_dbf_event_els_request(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
+
+	_zfcp_san_dbf_event_common_els("oels", 2,
+				       fsf_req, els->adapter->s_id, els->d_id,
+				       *(u8 *) zfcp_sg_to_address(els->req),
+				       zfcp_sg_to_address(els->req),
+				       els->req->length);
+}
+
+inline void zfcp_san_dbf_event_els_response(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
+
+	_zfcp_san_dbf_event_common_els("rels", 2,
+				       fsf_req, els->d_id, els->adapter->s_id,
+				       *(u8 *) zfcp_sg_to_address(els->req),
+				       zfcp_sg_to_address(els->resp),
+				       els->resp->length);
+}
+
+inline void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct fsf_status_read_buffer *status_buffer =
+	    (struct fsf_status_read_buffer *)fsf_req->data;
+	int length = (int)status_buffer->length -
+	    (int)((void *)&status_buffer->payload - (void *)status_buffer);
+
+	_zfcp_san_dbf_event_common_els("iels", 1,
+				       fsf_req, status_buffer->d_id,
+				       adapter->s_id,
+				       *(u8 *) status_buffer->payload,
+				       (void *)status_buffer->payload, length);
+}
+
+static int
+zfcp_san_dbf_view_format(debug_info_t * id, struct debug_view *view,
+			 char *out_buf, const char *in_buf)
+{
+	struct zfcp_san_dbf_record *rec = (struct zfcp_san_dbf_record *)in_buf;
+	char *buffer = NULL;
+	int buflen = 0, total = 0;
+	int len = 0;
+
+	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+		return 0;
+
+	len += zfcp_dbf_tag(out_buf + len, "tag", rec->tag);
+	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
+			     rec->fsf_reqid);
+	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
+			     rec->fsf_seqno);
+	len += zfcp_dbf_view(out_buf + len, "s_id", "0x%06x", rec->s_id);
+	len += zfcp_dbf_view(out_buf + len, "d_id", "0x%06x", rec->d_id);
+
+	if (strncmp(rec->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
+		len += zfcp_dbf_view(out_buf + len, "cmd_req_code", "0x%04x",
+				     rec->type.ct.type.request.cmd_req_code);
+		len += zfcp_dbf_view(out_buf + len, "revision", "0x%02x",
+				     rec->type.ct.type.request.revision);
+		len += zfcp_dbf_view(out_buf + len, "gs_type", "0x%02x",
+				     rec->type.ct.type.request.gs_type);
+		len += zfcp_dbf_view(out_buf + len, "gs_subtype", "0x%02x",
+				     rec->type.ct.type.request.gs_subtype);
+		len += zfcp_dbf_view(out_buf + len, "options", "0x%02x",
+				     rec->type.ct.type.request.options);
+		len += zfcp_dbf_view(out_buf + len, "max_res_size", "0x%04x",
+				     rec->type.ct.type.request.max_res_size);
+		total = rec->type.ct.payload_size;
+		buffer = rec->type.ct.payload;
+		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
+	} else if (strncmp(rec->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
+		len += zfcp_dbf_view(out_buf + len, "cmd_rsp_code", "0x%04x",
+				     rec->type.ct.type.response.cmd_rsp_code);
+		len += zfcp_dbf_view(out_buf + len, "revision", "0x%02x",
+				     rec->type.ct.type.response.revision);
+		len += zfcp_dbf_view(out_buf + len, "reason_code", "0x%02x",
+				     rec->type.ct.type.response.reason_code);
+		len +=
+		    zfcp_dbf_view(out_buf + len, "reason_code_expl", "0x%02x",
+				  rec->type.ct.type.response.reason_code_expl);
+		len +=
+		    zfcp_dbf_view(out_buf + len, "vendor_unique", "0x%02x",
+				  rec->type.ct.type.response.vendor_unique);
+		total = rec->type.ct.payload_size;
+		buffer = rec->type.ct.payload;
+		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
+	} else if (strncmp(rec->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
+		   strncmp(rec->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
+		   strncmp(rec->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
+		len += zfcp_dbf_view(out_buf + len, "ls_code", "0x%02x",
+				     rec->type.els.ls_code);
+		total = rec->type.els.payload_size;
+		buffer = rec->type.els.payload;
+		buflen = min(total, ZFCP_DBF_ELS_PAYLOAD);
+	}
+
+	len += zfcp_dbf_view_dump(out_buf + len, "payload",
+				  buffer, buflen, 0, total);
+
+	if (buflen == total)
+		len += sprintf(out_buf + len, "\n");
+
+	return len;
+}
+
+struct debug_view zfcp_san_dbf_view = {
+	"structured",
+	NULL,
+	&zfcp_dbf_view_header,
+	&zfcp_san_dbf_view_format,
+	NULL,
+	NULL
+};
+
+static inline void
+_zfcp_scsi_dbf_event_common(const char *tag, const char *tag2, int level,
+			    struct zfcp_adapter *adapter,
+			    struct scsi_cmnd *scsi_cmnd,
+			    struct zfcp_fsf_req *new_fsf_req)
+{
+	struct zfcp_fsf_req *fsf_req =
+	    (struct zfcp_fsf_req *)scsi_cmnd->host_scribble;
+	struct zfcp_scsi_dbf_record *rec = &adapter->scsi_dbf_buf;
+	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
+	unsigned long flags;
+	struct fcp_rsp_iu *fcp_rsp;
+	char *fcp_rsp_info = NULL, *fcp_sns_info = NULL;
+	int offset = 0, buflen = 0;
+
+	spin_lock_irqsave(&adapter->scsi_dbf_lock, flags);
+	do {
+		memset(rec, 0, sizeof(struct zfcp_scsi_dbf_record));
+		if (offset == 0) {
+			strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
+			strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
+			if (scsi_cmnd->device) {
+				rec->scsi_id = scsi_cmnd->device->id;
+				rec->scsi_lun = scsi_cmnd->device->lun;
+			}
+			rec->scsi_result = scsi_cmnd->result;
+			rec->scsi_cmnd = (unsigned long)scsi_cmnd;
+			rec->scsi_serial = scsi_cmnd->serial_number;
+			memcpy(rec->scsi_opcode,
+			       &scsi_cmnd->cmnd,
+			       min((int)scsi_cmnd->cmd_len,
+				   ZFCP_DBF_SCSI_OPCODE));
+			rec->scsi_retries = scsi_cmnd->retries;
+			rec->scsi_allowed = scsi_cmnd->allowed;
+			if (fsf_req != NULL) {
+				fcp_rsp = (struct fcp_rsp_iu *)
+				    &(fsf_req->qtcb->bottom.io.fcp_rsp);
+				fcp_rsp_info =
+				    zfcp_get_fcp_rsp_info_ptr(fcp_rsp);
+				fcp_sns_info =
+				    zfcp_get_fcp_sns_info_ptr(fcp_rsp);
+
+				rec->type.fcp.rsp_validity =
+				    fcp_rsp->validity.value;
+				rec->type.fcp.rsp_scsi_status =
+				    fcp_rsp->scsi_status;
+				rec->type.fcp.rsp_resid = fcp_rsp->fcp_resid;
+				if (fcp_rsp->validity.bits.fcp_rsp_len_valid)
+					rec->type.fcp.rsp_code =
+					    *(fcp_rsp_info + 3);
+				if (fcp_rsp->validity.bits.fcp_sns_len_valid) {
+					buflen = min((int)fcp_rsp->fcp_sns_len,
+						     ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO);
+					rec->type.fcp.sns_info_len = buflen;
+					memcpy(rec->type.fcp.sns_info,
+					       fcp_sns_info,
+					       min(buflen,
+						   ZFCP_DBF_SCSI_FCP_SNS_INFO));
+					offset += min(buflen,
+						      ZFCP_DBF_SCSI_FCP_SNS_INFO);
+				}
+
+				rec->fsf_reqid = (unsigned long)fsf_req;
+				rec->fsf_seqno = fsf_req->seq_no;
+				rec->fsf_issued = fsf_req->issued;
+			}
+			if (new_fsf_req != NULL) {
+				rec->type.new_fsf_req.fsf_reqid =
+				    (unsigned long)
+				    new_fsf_req;
+				rec->type.new_fsf_req.fsf_seqno =
+				    new_fsf_req->seq_no;
+				rec->type.new_fsf_req.fsf_issued =
+				    new_fsf_req->issued;
+			}
+		} else {
+			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
+			dump->total_size = buflen;
+			dump->offset = offset;
+			dump->size = min(buflen - offset,
+					 (int)sizeof(struct
+						     zfcp_scsi_dbf_record) -
+					 (int)sizeof(struct zfcp_dbf_dump));
+			memcpy(dump->data, fcp_sns_info + offset, dump->size);
+			offset += dump->size;
+		}
+		debug_event(adapter->scsi_dbf, level,
+			    rec, sizeof(struct zfcp_scsi_dbf_record));
+	} while (offset < buflen);
+	spin_unlock_irqrestore(&adapter->scsi_dbf_lock, flags);
+}
+
+inline void
+zfcp_scsi_dbf_event_result(const char *tag, int level,
+			   struct zfcp_adapter *adapter,
+			   struct scsi_cmnd *scsi_cmnd)
+{
+	_zfcp_scsi_dbf_event_common("rslt",
+				    tag, level, adapter, scsi_cmnd, NULL);
+}
+
+inline void
+zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
+			  struct scsi_cmnd *scsi_cmnd,
+			  struct zfcp_fsf_req *new_fsf_req)
+{
+	_zfcp_scsi_dbf_event_common("abrt",
+				    tag, 1, adapter, scsi_cmnd, new_fsf_req);
+}
+
+inline void
+zfcp_scsi_dbf_event_devreset(const char *tag, u8 flag, struct zfcp_unit *unit,
+			     struct scsi_cmnd *scsi_cmnd)
+{
+	struct zfcp_adapter *adapter = unit->port->adapter;
+
+	_zfcp_scsi_dbf_event_common(flag == FCP_TARGET_RESET ? "trst" : "lrst",
+				    tag, 1, adapter, scsi_cmnd, NULL);
+}
+
+static int
+zfcp_scsi_dbf_view_format(debug_info_t * id, struct debug_view *view,
+			  char *out_buf, const char *in_buf)
+{
+	struct zfcp_scsi_dbf_record *rec =
+	    (struct zfcp_scsi_dbf_record *)in_buf;
+	int len = 0;
+
+	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+		return 0;
+
+	len += zfcp_dbf_tag(out_buf + len, "tag", rec->tag);
+	len += zfcp_dbf_tag(out_buf + len, "tag2", rec->tag2);
+	len += zfcp_dbf_view(out_buf + len, "scsi_id", "0x%08x", rec->scsi_id);
+	len += zfcp_dbf_view(out_buf + len, "scsi_lun", "0x%08x",
+			     rec->scsi_lun);
+	len += zfcp_dbf_view(out_buf + len, "scsi_result", "0x%08x",
+			     rec->scsi_result);
+	len += zfcp_dbf_view(out_buf + len, "scsi_cmnd", "0x%0Lx",
+			     rec->scsi_cmnd);
+	len += zfcp_dbf_view(out_buf + len, "scsi_serial", "0x%016Lx",
+			     rec->scsi_serial);
+	len += zfcp_dbf_view_dump(out_buf + len, "scsi_opcode",
+				  rec->scsi_opcode,
+				  ZFCP_DBF_SCSI_OPCODE,
+				  0, ZFCP_DBF_SCSI_OPCODE);
+	len += zfcp_dbf_view(out_buf + len, "scsi_retries", "0x%02x",
+			     rec->scsi_retries);
+	len += zfcp_dbf_view(out_buf + len, "scsi_allowed", "0x%02x",
+			     rec->scsi_allowed);
+	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
+			     rec->fsf_reqid);
+	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
+			     rec->fsf_seqno);
+	len += zfcp_dbf_stck(out_buf + len, "fsf_issued", rec->fsf_issued);
+	if (strncmp(rec->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
+		len +=
+		    zfcp_dbf_view(out_buf + len, "fcp_rsp_validity", "0x%02x",
+				  rec->type.fcp.rsp_validity);
+		len +=
+		    zfcp_dbf_view(out_buf + len, "fcp_rsp_scsi_status",
+				  "0x%02x", rec->type.fcp.rsp_scsi_status);
+		len +=
+		    zfcp_dbf_view(out_buf + len, "fcp_rsp_resid", "0x%08x",
+				  rec->type.fcp.rsp_resid);
+		len +=
+		    zfcp_dbf_view(out_buf + len, "fcp_rsp_code", "0x%08x",
+				  rec->type.fcp.rsp_code);
+		len +=
+		    zfcp_dbf_view(out_buf + len, "fcp_sns_info_len", "0x%08x",
+				  rec->type.fcp.sns_info_len);
+		len +=
+		    zfcp_dbf_view_dump(out_buf + len, "fcp_sns_info",
+				       rec->type.fcp.sns_info,
+				       min((int)rec->type.fcp.sns_info_len,
+					   ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
+				       rec->type.fcp.sns_info_len);
+	} else if (strncmp(rec->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0) {
+		len += zfcp_dbf_view(out_buf + len, "fsf_reqid_abort", "0x%0Lx",
+				     rec->type.new_fsf_req.fsf_reqid);
+		len += zfcp_dbf_view(out_buf + len, "fsf_seqno_abort", "0x%08x",
+				     rec->type.new_fsf_req.fsf_seqno);
+		len += zfcp_dbf_stck(out_buf + len, "fsf_issued",
+				     rec->type.new_fsf_req.fsf_issued);
+	} else if ((strncmp(rec->tag, "trst", ZFCP_DBF_TAG_SIZE) == 0) ||
+		   (strncmp(rec->tag, "lrst", ZFCP_DBF_TAG_SIZE) == 0)) {
+		len += zfcp_dbf_view(out_buf + len, "fsf_reqid_reset", "0x%0Lx",
+				     rec->type.new_fsf_req.fsf_reqid);
+		len += zfcp_dbf_view(out_buf + len, "fsf_seqno_reset", "0x%08x",
+				     rec->type.new_fsf_req.fsf_seqno);
+		len += zfcp_dbf_stck(out_buf + len, "fsf_issued",
+				     rec->type.new_fsf_req.fsf_issued);
+	}
+
+	len += sprintf(out_buf + len, "\n");
+
+	return len;
+}
+
+struct debug_view zfcp_scsi_dbf_view = {
+	"structured",
+	NULL,
+	&zfcp_dbf_view_header,
+	&zfcp_scsi_dbf_view_format,
+	NULL,
+	NULL
+};
+
+/**
+ * zfcp_adapter_debug_register - registers debug feature for an adapter
+ * @adapter: pointer to adapter for which debug features should be registered
+ * return: -ENOMEM on error, 0 otherwise
+ */
+int zfcp_adapter_debug_register(struct zfcp_adapter *adapter)
+{
+	char dbf_name[DEBUG_MAX_NAME_LEN];
+
+	/* debug feature area which records recovery activity */
+	spin_lock_init(&adapter->erp_dbf_lock);
+	sprintf(dbf_name, "zfcp_%s_erp", zfcp_get_busid_by_adapter(adapter));
+	adapter->erp_dbf = debug_register(dbf_name, dbfsize, 2,
+					  sizeof(struct zfcp_erp_dbf_record));
+	if (!adapter->erp_dbf)
+		goto failed;
+	debug_register_view(adapter->erp_dbf, &debug_hex_ascii_view);
+	debug_set_level(adapter->erp_dbf, 3);
+
+	/* debug feature area which records HBA (FSF and QDIO) conditions */
+	spin_lock_init(&adapter->hba_dbf_lock);
+	sprintf(dbf_name, "zfcp_%s_hba", zfcp_get_busid_by_adapter(adapter));
+	adapter->hba_dbf = debug_register(dbf_name, dbfsize, 1,
+					  sizeof(struct zfcp_hba_dbf_record));
+	if (!adapter->hba_dbf)
+		goto failed;
+	debug_register_view(adapter->hba_dbf, &debug_hex_ascii_view);
+	debug_register_view(adapter->hba_dbf, &zfcp_hba_dbf_view);
+	debug_set_level(adapter->hba_dbf, 3);
+
+	/* debug feature area which records SAN command failures and recovery */
+	spin_lock_init(&adapter->san_dbf_lock);
+	sprintf(dbf_name, "zfcp_%s_san", zfcp_get_busid_by_adapter(adapter));
+	adapter->san_dbf = debug_register(dbf_name, dbfsize, 1,
+					  sizeof(struct zfcp_san_dbf_record));
+	if (!adapter->san_dbf)
+		goto failed;
+	debug_register_view(adapter->san_dbf, &debug_hex_ascii_view);
+	debug_register_view(adapter->san_dbf, &zfcp_san_dbf_view);
+	debug_set_level(adapter->san_dbf, 6);
+
+	/* debug feature area which records SCSI command failures and recovery */
+	spin_lock_init(&adapter->scsi_dbf_lock);
+	sprintf(dbf_name, "zfcp_%s_scsi", zfcp_get_busid_by_adapter(adapter));
+	adapter->scsi_dbf = debug_register(dbf_name, dbfsize, 1,
+					   sizeof(struct zfcp_scsi_dbf_record));
+	if (!adapter->scsi_dbf)
+		goto failed;
+	debug_register_view(adapter->scsi_dbf, &debug_hex_ascii_view);
+	debug_register_view(adapter->scsi_dbf, &zfcp_scsi_dbf_view);
+	debug_set_level(adapter->scsi_dbf, 3);
+
+	return 0;
+
+ failed:
+	zfcp_adapter_debug_unregister(adapter);
+
+	return -ENOMEM;
+}
+
+/**
+ * zfcp_adapter_debug_unregister - unregisters debug feature for an adapter
+ * @adapter: pointer to adapter for which debug features should be unregistered
+ */
+void zfcp_adapter_debug_unregister(struct zfcp_adapter *adapter)
+{
+	debug_unregister(adapter->scsi_dbf);
+	debug_unregister(adapter->san_dbf);
+	debug_unregister(adapter->hba_dbf);
+	debug_unregister(adapter->erp_dbf);
+	adapter->scsi_dbf = NULL;
+	adapter->san_dbf = NULL;
+	adapter->hba_dbf = NULL;
+	adapter->erp_dbf = NULL;
+}
+
+#undef ZFCP_LOG_AREA
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.13/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_def.h	2005-09-03 12:21:07.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_def.h	2005-09-03 12:23:14.000000000 +0200
@@ -66,7 +66,7 @@
 /********************* GENERAL DEFINES *********************************/
 
 /* zfcp version number, it consists of major, minor, and patch-level number */
-#define ZFCP_VERSION		"4.3.0"
+#define ZFCP_VERSION		"4.4.0"
 
 /**
  * zfcp_sg_to_address - determine kernel address from struct scatterlist
@@ -281,6 +281,171 @@ struct fcp_logo {
 } __attribute__((packed));
 
 /*
+ * DBF stuff
+ */
+#define ZFCP_DBF_TAG_SIZE      4
+
+struct zfcp_dbf_dump {
+	u8 tag[ZFCP_DBF_TAG_SIZE];
+	u32 total_size;		/* size of total dump data */
+	u32 offset;		/* how much data has being already dumped */
+	u32 size;		/* how much data comes with this record */
+	u8 data[];		/* dump data */
+} __attribute__ ((packed));
+
+/* FIXME: to be inflated when reworking the erp dbf */
+struct zfcp_erp_dbf_record {
+	u8 dummy[16];
+} __attribute__ ((packed));
+
+struct zfcp_hba_dbf_record_response {
+	u32 fsf_command;
+	u64 fsf_reqid;
+	u32 fsf_seqno;
+	u64 fsf_issued;
+	u32 fsf_prot_status;
+	u32 fsf_status;
+	u8 fsf_prot_status_qual[FSF_PROT_STATUS_QUAL_SIZE];
+	u8 fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
+	u32 fsf_req_status;
+	u8 sbal_first;
+	u8 sbal_curr;
+	u8 sbal_last;
+	u8 pool;
+	u64 erp_action;
+	union {
+		struct {
+			u64 scsi_cmnd;
+			u64 scsi_serial;
+		} send_fcp;
+		struct {
+			u64 wwpn;
+			u32 d_id;
+			u32 port_handle;
+		} port;
+		struct {
+			u64 wwpn;
+			u64 fcp_lun;
+			u32 port_handle;
+			u32 lun_handle;
+		} unit;
+		struct {
+			u32 d_id;
+			u8 ls_code;
+		} send_els;
+	} data;
+} __attribute__ ((packed));
+
+struct zfcp_hba_dbf_record_status {
+	u8 failed;
+	u32 status_type;
+	u32 status_subtype;
+	struct fsf_queue_designator
+	 queue_designator;
+	u32 payload_size;
+#define ZFCP_DBF_UNSOL_PAYLOAD				80
+#define ZFCP_DBF_UNSOL_PAYLOAD_SENSE_DATA_AVAIL		32
+#define ZFCP_DBF_UNSOL_PAYLOAD_BIT_ERROR_THRESHOLD	56
+#define ZFCP_DBF_UNSOL_PAYLOAD_FEATURE_UPDATE_ALERT	2 * sizeof(u32)
+	u8 payload[ZFCP_DBF_UNSOL_PAYLOAD];
+} __attribute__ ((packed));
+
+struct zfcp_hba_dbf_record_qdio {
+	u32 status;
+	u32 qdio_error;
+	u32 siga_error;
+	u8 sbal_index;
+	u8 sbal_count;
+} __attribute__ ((packed));
+
+struct zfcp_hba_dbf_record {
+	u8 tag[ZFCP_DBF_TAG_SIZE];
+	u8 tag2[ZFCP_DBF_TAG_SIZE];
+	union {
+		struct zfcp_hba_dbf_record_response response;
+		struct zfcp_hba_dbf_record_status status;
+		struct zfcp_hba_dbf_record_qdio qdio;
+	} type;
+} __attribute__ ((packed));
+
+struct zfcp_san_dbf_record_ct {
+	union {
+		struct {
+			u16 cmd_req_code;
+			u8 revision;
+			u8 gs_type;
+			u8 gs_subtype;
+			u8 options;
+			u16 max_res_size;
+		} request;
+		struct {
+			u16 cmd_rsp_code;
+			u8 revision;
+			u8 reason_code;
+			u8 reason_code_expl;
+			u8 vendor_unique;
+		} response;
+	} type;
+	u32 payload_size;
+#define ZFCP_DBF_CT_PAYLOAD	24
+	u8 payload[ZFCP_DBF_CT_PAYLOAD];
+} __attribute__ ((packed));
+
+struct zfcp_san_dbf_record_els {
+	u8 ls_code;
+	u32 payload_size;
+#define ZFCP_DBF_ELS_PAYLOAD	32
+#define ZFCP_DBF_ELS_MAX_PAYLOAD 1024
+	u8 payload[ZFCP_DBF_ELS_PAYLOAD];
+} __attribute__ ((packed));
+
+struct zfcp_san_dbf_record {
+	u8 tag[ZFCP_DBF_TAG_SIZE];
+	u64 fsf_reqid;
+	u32 fsf_seqno;
+	u32 s_id;
+	u32 d_id;
+	union {
+		struct zfcp_san_dbf_record_ct ct;
+		struct zfcp_san_dbf_record_els els;
+	} type;
+} __attribute__ ((packed));
+
+struct zfcp_scsi_dbf_record {
+	u8 tag[ZFCP_DBF_TAG_SIZE];
+	u8 tag2[ZFCP_DBF_TAG_SIZE];
+	u32 scsi_id;
+	u32 scsi_lun;
+	u32 scsi_result;
+	u64 scsi_cmnd;
+	u64 scsi_serial;
+#define ZFCP_DBF_SCSI_OPCODE	16
+	u8 scsi_opcode[ZFCP_DBF_SCSI_OPCODE];
+	u8 scsi_retries;
+	u8 scsi_allowed;
+	u64 fsf_reqid;
+	u32 fsf_seqno;
+	u64 fsf_issued;
+	union {
+		struct {
+			u64 fsf_reqid;
+			u32 fsf_seqno;
+			u64 fsf_issued;
+		} new_fsf_req;
+		struct {
+			u8 rsp_validity;
+			u8 rsp_scsi_status;
+			u32 rsp_resid;
+			u8 rsp_code;
+#define ZFCP_DBF_SCSI_FCP_SNS_INFO	16
+#define ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO	256
+			u32 sns_info_len;
+			u8 sns_info[ZFCP_DBF_SCSI_FCP_SNS_INFO];
+		} fcp;
+	} type;
+} __attribute__ ((packed));
+
+/*
  * FC-FS stuff
  */
 #define R_A_TOV				10 /* seconds */
@@ -339,34 +504,6 @@ struct zfcp_rc_entry {
  */
 #define ZFCP_CT_TIMEOUT			(3 * R_A_TOV)
 
-
-/***************** S390 DEBUG FEATURE SPECIFIC DEFINES ***********************/
-
-/* debug feature entries per adapter */
-#define ZFCP_ERP_DBF_INDEX     1 
-#define ZFCP_ERP_DBF_AREAS     2
-#define ZFCP_ERP_DBF_LENGTH    16
-#define ZFCP_ERP_DBF_LEVEL     3
-#define ZFCP_ERP_DBF_NAME      "zfcperp"
-
-#define ZFCP_CMD_DBF_INDEX     2
-#define ZFCP_CMD_DBF_AREAS     1
-#define ZFCP_CMD_DBF_LENGTH    8
-#define ZFCP_CMD_DBF_LEVEL     3
-#define ZFCP_CMD_DBF_NAME      "zfcpcmd"
-
-#define ZFCP_ABORT_DBF_INDEX   2
-#define ZFCP_ABORT_DBF_AREAS   1
-#define ZFCP_ABORT_DBF_LENGTH  8
-#define ZFCP_ABORT_DBF_LEVEL   6
-#define ZFCP_ABORT_DBF_NAME    "zfcpabt"
-
-#define ZFCP_IN_ELS_DBF_INDEX  2
-#define ZFCP_IN_ELS_DBF_AREAS  1
-#define ZFCP_IN_ELS_DBF_LENGTH 8
-#define ZFCP_IN_ELS_DBF_LEVEL  6
-#define ZFCP_IN_ELS_DBF_NAME   "zfcpels"
-
 /******************** LOGGING MACROS AND DEFINES *****************************/
 
 /*
@@ -823,11 +960,18 @@ struct zfcp_adapter {
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
 	struct zfcp_port	*nameserver_port;  /* adapter's nameserver */
-        debug_info_t            *erp_dbf;          /* S/390 debug features */
-	debug_info_t            *abort_dbf;
-	debug_info_t            *in_els_dbf;
-	debug_info_t            *cmd_dbf;
-	spinlock_t              dbf_lock;
+	debug_info_t		*erp_dbf;
+	debug_info_t		*hba_dbf;
+	debug_info_t		*san_dbf;          /* debug feature areas */
+	debug_info_t		*scsi_dbf;
+	spinlock_t		erp_dbf_lock;
+	spinlock_t		hba_dbf_lock;
+	spinlock_t		san_dbf_lock;
+	spinlock_t		scsi_dbf_lock;
+	struct zfcp_erp_dbf_record	erp_dbf_buf;
+	struct zfcp_hba_dbf_record	hba_dbf_buf;
+	struct zfcp_san_dbf_record	san_dbf_buf;
+	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
 	struct device           generic_services;  /* directory for WKA ports */
@@ -902,6 +1046,7 @@ struct zfcp_fsf_req {
 						  issued on behalf of erp */
 	mempool_t	       *pool;	       /* used if request was alloacted
 						  from emergency pool */
+	unsigned long long     issued;         /* request sent time (STCK) */
 	struct zfcp_unit       *unit;
 };
 
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_ext.h linux-2.6.13/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_ext.h	2005-09-03 12:21:58.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_ext.h	2005-09-03 12:23:14.000000000 +0200
@@ -181,9 +181,25 @@ extern void zfcp_erp_port_access_changed
 extern void zfcp_erp_unit_access_changed(struct zfcp_unit *);
 
 /******************************** AUX ****************************************/
-extern void zfcp_cmd_dbf_event_fsf(const char *, struct zfcp_fsf_req *,
-				   void *, int);
-extern void zfcp_cmd_dbf_event_scsi(const char *, struct scsi_cmnd *);
-extern void zfcp_in_els_dbf_event(struct zfcp_adapter *, const char *,
-				  struct fsf_status_read_buffer *, int);
+extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
+extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
+					 struct fsf_status_read_buffer *);
+extern void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *,
+				    unsigned int, unsigned int, unsigned int,
+				    int, int);
+
+extern void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *);
+extern void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *);
+extern void zfcp_san_dbf_event_els_request(struct zfcp_fsf_req *);
+extern void zfcp_san_dbf_event_els_response(struct zfcp_fsf_req *);
+extern void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *);
+
+extern void zfcp_scsi_dbf_event_result(const char *, int, struct zfcp_adapter *,
+				       struct scsi_cmnd *);
+extern void zfcp_scsi_dbf_event_abort(const char *, struct zfcp_adapter *,
+				      struct scsi_cmnd *,
+				      struct zfcp_fsf_req *);
+extern void zfcp_scsi_dbf_event_devreset(const char *, u8, struct zfcp_unit *,
+					 struct scsi_cmnd *);
+
 #endif	/* ZFCP_EXT_H */
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.13/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.c	2005-09-03 12:21:58.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_fsf.c	2005-09-03 12:23:14.000000000 +0200
@@ -285,51 +285,51 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 {
 	int retval = 0;
 	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct fsf_qtcb *qtcb = fsf_req->qtcb;
+	union fsf_prot_status_qual *prot_status_qual =
+		&qtcb->prefix.prot_status_qual;
 
-	ZFCP_LOG_DEBUG("QTCB is at %p\n", fsf_req->qtcb);
+	zfcp_hba_dbf_event_fsf_response(fsf_req);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		ZFCP_LOG_DEBUG("fsf_req 0x%lx has been dismissed\n",
 			       (unsigned long) fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY; /* only for SCSI cmnds. */
-		zfcp_cmd_dbf_event_fsf("dismiss", fsf_req, NULL, 0);
 		goto skip_protstatus;
 	}
 
 	/* log additional information provided by FSF (if any) */
-	if (unlikely(fsf_req->qtcb->header.log_length)) {
+	if (unlikely(qtcb->header.log_length)) {
 		/* do not trust them ;-) */
-		if (fsf_req->qtcb->header.log_start > sizeof(struct fsf_qtcb)) {
+		if (qtcb->header.log_start > sizeof(struct fsf_qtcb)) {
 			ZFCP_LOG_NORMAL
 			    ("bug: ULP (FSF logging) log data starts "
 			     "beyond end of packet header. Ignored. "
 			     "(start=%i, size=%li)\n",
-			     fsf_req->qtcb->header.log_start,
+			     qtcb->header.log_start,
 			     sizeof(struct fsf_qtcb));
 			goto forget_log;
 		}
-		if ((size_t) (fsf_req->qtcb->header.log_start +
-		     fsf_req->qtcb->header.log_length)
+		if ((size_t) (qtcb->header.log_start + qtcb->header.log_length)
 		    > sizeof(struct fsf_qtcb)) {
 			ZFCP_LOG_NORMAL("bug: ULP (FSF logging) log data ends "
 					"beyond end of packet header. Ignored. "
 					"(start=%i, length=%i, size=%li)\n",
-					fsf_req->qtcb->header.log_start,
-					fsf_req->qtcb->header.log_length,
+					qtcb->header.log_start,
+					qtcb->header.log_length,
 					sizeof(struct fsf_qtcb));
 			goto forget_log;
 		}
 		ZFCP_LOG_TRACE("ULP log data: \n");
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (char *) fsf_req->qtcb +
-			      fsf_req->qtcb->header.log_start,
-			      fsf_req->qtcb->header.log_length);
+			      (char *) qtcb + qtcb->header.log_start,
+			      qtcb->header.log_length);
 	}
  forget_log:
 
 	/* evaluate FSF Protocol Status */
-	switch (fsf_req->qtcb->prefix.prot_status) {
+	switch (qtcb->prefix.prot_status) {
 
 	case FSF_PROT_GOOD:
 	case FSF_PROT_FSF_STATUS_PRESENTED:
@@ -340,14 +340,9 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"microcode of version 0x%x, the device driver "
 				"only supports 0x%x. Aborting.\n",
 				zfcp_get_busid_by_adapter(adapter),
-				fsf_req->qtcb->prefix.prot_status_qual.
-				version_error.fsf_version, ZFCP_QTCB_VERSION);
-		/* stop operation for this adapter */
-		debug_text_exception(adapter->erp_dbf, 0, "prot_ver_err");
+				prot_status_qual->version_error.fsf_version,
+				ZFCP_QTCB_VERSION);
 		zfcp_erp_adapter_shutdown(adapter, 0);
-		zfcp_cmd_dbf_event_fsf("qverserr", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -355,16 +350,10 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		ZFCP_LOG_NORMAL("bug: Sequence number mismatch between "
 				"driver (0x%x) and adapter %s (0x%x). "
 				"Restarting all operations on this adapter.\n",
-				fsf_req->qtcb->prefix.req_seq_no,
+				qtcb->prefix.req_seq_no,
 				zfcp_get_busid_by_adapter(adapter),
-				fsf_req->qtcb->prefix.prot_status_qual.
-				sequence_error.exp_req_seq_no);
-		debug_text_exception(adapter->erp_dbf, 0, "prot_seq_err");
-		/* restart operation on this adapter */
+				prot_status_qual->sequence_error.exp_req_seq_no);
 		zfcp_erp_adapter_reopen(adapter, 0);
-		zfcp_cmd_dbf_event_fsf("seqnoerr", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -375,22 +364,14 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"that used on adapter %s. "
 				"Stopping all operations on this adapter.\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_exception(adapter->erp_dbf, 0, "prot_unsup_qtcb");
 		zfcp_erp_adapter_shutdown(adapter, 0);
-		zfcp_cmd_dbf_event_fsf("unsqtcbt", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
-		zfcp_cmd_dbf_event_fsf("hconinit", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				&(adapter->status));
-		debug_text_event(adapter->erp_dbf, 3, "prot_con_init");
 		break;
 
 	case FSF_PROT_DUPLICATE_REQUEST_ID:
@@ -413,11 +394,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 					fsf_req,
 					zfcp_get_busid_by_adapter(adapter));
 		}
-		debug_text_exception(adapter->erp_dbf, 0, "prot_dup_id");
 		zfcp_erp_adapter_shutdown(adapter, 0);
-		zfcp_cmd_dbf_event_fsf("dupreqid", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -483,8 +460,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_REEST_QUEUE:
-		debug_text_event(adapter->erp_dbf, 1, "prot_reest_queue");
-		ZFCP_LOG_INFO("The local link to adapter with "
+		ZFCP_LOG_NORMAL("The local link to adapter with "
 			      "%s was re-plugged. "
 			      "Re-starting operations on this adapter.\n",
 			      zfcp_get_busid_by_adapter(adapter));
@@ -495,9 +471,6 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
 					| ZFCP_STATUS_COMMON_ERP_FAILED);
-		zfcp_cmd_dbf_event_fsf("reestque", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -507,12 +480,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"Restarting all operations on this "
 				"adapter.\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf, 0, "prot_err_sta");
-		/* restart operation on this adapter */
 		zfcp_erp_adapter_reopen(adapter, 0);
-		zfcp_cmd_dbf_event_fsf("proterrs", fsf_req,
-				       &fsf_req->qtcb->prefix.prot_status_qual,
-				       sizeof (union fsf_prot_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -524,11 +492,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"Stopping all operations on this adapter. "
 				"(debug info 0x%x).\n",
 				zfcp_get_busid_by_adapter(adapter),
-				fsf_req->qtcb->prefix.prot_status);
-		debug_text_event(adapter->erp_dbf, 0, "prot_inval:");
-		debug_exception(adapter->erp_dbf, 0,
-				&fsf_req->qtcb->prefix.prot_status,
-				sizeof (u32));
+				qtcb->prefix.prot_status);
 		zfcp_erp_adapter_shutdown(adapter, 0);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 	}
@@ -568,28 +532,18 @@ zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_
 				"(debug info 0x%x).\n",
 				zfcp_get_busid_by_adapter(fsf_req->adapter),
 				fsf_req->qtcb->header.fsf_command);
-		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-				     "fsf_s_unknown");
 		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("unknownc", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_FCP_RSP_AVAILABLE:
 		ZFCP_LOG_DEBUG("FCP Sense data will be presented to the "
 			       "SCSI stack.\n");
-		debug_text_event(fsf_req->adapter->erp_dbf, 3, "fsf_s_rsp");
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_astatus");
 		zfcp_fsf_fsfstatus_qual_eval(fsf_req);
 		break;
-
-	default:
-		break;
 	}
 
  skip_fsfstatus:
@@ -617,44 +571,28 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 
 	switch (fsf_req->qtcb->header.fsf_status_qual.word[0]) {
 	case FSF_SQ_FCP_RSP_AVAILABLE:
-		debug_text_event(fsf_req->adapter->erp_dbf, 4, "fsf_sq_rsp");
 		break;
 	case FSF_SQ_RETRY_IF_POSSIBLE:
 		/* The SCSI-stack may now issue retries or escalate */
-		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_sq_retry");
-		zfcp_cmd_dbf_event_fsf("sqretry", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_COMMAND_ABORTED:
 		/* Carry the aborted state on to upper layer */
-		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_sq_abort");
-		zfcp_cmd_dbf_event_fsf("sqabort", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTED;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_NO_RECOM:
-		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-				     "fsf_sq_no_rec");
 		ZFCP_LOG_NORMAL("bug: No recommendation could be given for a"
 				"problem on the adapter %s "
 				"Stopping all operations on this adapter. ",
 				zfcp_get_busid_by_adapter(fsf_req->adapter));
 		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("sqnrecom", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_ULP_PROGRAMMING_ERROR:
 		ZFCP_LOG_NORMAL("error: not enough SBALs for data transfer "
 				"(adapter %s)\n",
 				zfcp_get_busid_by_adapter(fsf_req->adapter));
-		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-				     "fsf_sq_ulp_err");
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
@@ -668,13 +606,6 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_sq_inval:");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-				&fsf_req->qtcb->header.fsf_status_qual.word[0],
-				sizeof (u32));
-		zfcp_cmd_dbf_event_fsf("squndef", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
@@ -696,11 +627,6 @@ zfcp_fsf_req_dispatch(struct zfcp_fsf_re
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	int retval = 0;
 
-	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		ZFCP_LOG_TRACE("fsf_req=%p, QTCB=%p\n", fsf_req, fsf_req->qtcb);
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (char *) fsf_req->qtcb, sizeof(struct fsf_qtcb));
-	}
 
 	switch (fsf_req->fsf_command) {
 
@@ -760,13 +686,13 @@ zfcp_fsf_req_dispatch(struct zfcp_fsf_re
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		ZFCP_LOG_NORMAL("bug: Command issued by the device driver is "
 				"not supported by the adapter %s\n",
-				zfcp_get_busid_by_adapter(fsf_req->adapter));
+				zfcp_get_busid_by_adapter(adapter));
 		if (fsf_req->fsf_command != fsf_req->qtcb->header.fsf_command)
 			ZFCP_LOG_NORMAL
 			    ("bug: Command issued by the device driver differs "
 			     "from the command returned by the adapter %s "
 			     "(debug info 0x%x, 0x%x).\n",
-			     zfcp_get_busid_by_adapter(fsf_req->adapter),
+			     zfcp_get_busid_by_adapter(adapter),
 			     fsf_req->fsf_command,
 			     fsf_req->qtcb->header.fsf_command);
 	}
@@ -774,8 +700,6 @@ zfcp_fsf_req_dispatch(struct zfcp_fsf_re
 	if (!erp_action)
 		return retval;
 
-	debug_text_event(adapter->erp_dbf, 3, "a_frh");
-	debug_event(adapter->erp_dbf, 3, &erp_action->action, sizeof (int));
 	zfcp_erp_async_handler(erp_action, 0);
 
 	return retval;
@@ -846,6 +770,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
  failed_buf:
 	zfcp_fsf_req_free(fsf_req);
  failed_req_create:
+	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
  out:
 	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
 	return retval;
@@ -921,35 +846,30 @@ zfcp_fsf_status_read_handler(struct zfcp
 		(struct fsf_status_read_buffer *) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
+		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, status_buffer);
 		mempool_free(status_buffer, adapter->pool.data_status_read);
 		zfcp_fsf_req_free(fsf_req);
 		goto out;
 	}
 
+	zfcp_hba_dbf_event_fsf_unsol("read", adapter, status_buffer);
+
 	switch (status_buffer->status_type) {
 
 	case FSF_STATUS_READ_PORT_CLOSED:
-		debug_text_event(adapter->erp_dbf, 3, "unsol_pclosed:");
-		debug_event(adapter->erp_dbf, 3,
-			    &status_buffer->d_id, sizeof (u32));
 		zfcp_fsf_status_read_port_closed(fsf_req);
 		break;
 
 	case FSF_STATUS_READ_INCOMING_ELS:
-		debug_text_event(adapter->erp_dbf, 3, "unsol_els:");
 		zfcp_fsf_incoming_els(fsf_req);
 		break;
 
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
-		debug_text_event(adapter->erp_dbf, 3, "unsol_sense:");
 		ZFCP_LOG_INFO("unsolicited sense data received (adapter %s)\n",
 			      zfcp_get_busid_by_adapter(adapter));
-                ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL, (char *) status_buffer,
-                              sizeof(struct fsf_status_read_buffer));
 		break;
 
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		debug_text_event(adapter->erp_dbf, 3, "unsol_bit_err:");
 		ZFCP_LOG_NORMAL("Bit error threshold data received:\n");
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) status_buffer,
@@ -980,35 +900,30 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_CFDC_UPDATED:
-		debug_text_event(adapter->erp_dbf, 2, "unsol_cfdc_update:");
-		ZFCP_LOG_INFO("CFDC has been updated on the adapter %s\n",
+		ZFCP_LOG_NORMAL("CFDC has been updated on the adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
 		zfcp_erp_adapter_access_changed(adapter);
 		break;
 
 	case FSF_STATUS_READ_CFDC_HARDENED:
-		debug_text_event(adapter->erp_dbf, 2, "unsol_cfdc_harden:");
 		switch (status_buffer->status_subtype) {
 		case FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE:
-			ZFCP_LOG_INFO("CFDC of adapter %s saved on SE\n",
+			ZFCP_LOG_NORMAL("CFDC of adapter %s saved on SE\n",
 				      zfcp_get_busid_by_adapter(adapter));
 			break;
 		case FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE2:
-			ZFCP_LOG_INFO("CFDC of adapter %s has been copied "
+			ZFCP_LOG_NORMAL("CFDC of adapter %s has been copied "
 				      "to the secondary SE\n",
 				zfcp_get_busid_by_adapter(adapter));
 			break;
 		default:
-			ZFCP_LOG_INFO("CFDC of adapter %s has been hardened\n",
+			ZFCP_LOG_NORMAL("CFDC of adapter %s has been hardened\n",
 				      zfcp_get_busid_by_adapter(adapter));
 		}
 		break;
 
 	default:
-		debug_text_event(adapter->erp_dbf, 0, "unsol_unknown:");
-		debug_exception(adapter->erp_dbf, 0,
-				&status_buffer->status_type, sizeof (u32));
-		ZFCP_LOG_NORMAL("bug: An unsolicited status packet of unknown "
+		ZFCP_LOG_NORMAL("warning: An unsolicited status packet of unknown "
 				"type was received (debug info 0x%x)\n",
 				status_buffer->status_type);
 		ZFCP_LOG_DEBUG("Dump of status_read_buffer %p:\n",
@@ -1418,6 +1333,8 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 	fsf_req->qtcb->bottom.support.timeout = ct->timeout;
         fsf_req->data = (unsigned long) ct;
 
+	zfcp_san_dbf_event_ct_request(fsf_req);
+
 	/* start QDIO request for this FSF request */
 	ret = zfcp_fsf_req_send(fsf_req, ct->timer);
 	if (ret) {
@@ -1476,6 +1393,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 	switch (header->fsf_status) {
 
         case FSF_GOOD:
+		zfcp_san_dbf_event_ct_response(fsf_req);
                 retval = 0;
 		break;
 
@@ -1720,6 +1638,8 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
 
+	zfcp_san_dbf_event_els_request(fsf_req);
+
 	/* start QDIO request for this FSF request */
 	ret = zfcp_fsf_req_send(fsf_req, els->timer);
 	if (ret) {
@@ -1777,6 +1697,7 @@ static int zfcp_fsf_send_els_handler(str
 	switch (header->fsf_status) {
 
 	case FSF_GOOD:
+		zfcp_san_dbf_event_els_response(fsf_req);
 		retval = 0;
 		break;
 
@@ -3309,9 +3230,6 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_phand_nv");
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("porthinv", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3330,9 +3248,6 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_lhand_nv");
 		zfcp_erp_port_reopen(unit->port, 0);
-		zfcp_cmd_dbf_event_fsf("lunhinv", fsf_req,
-				       &fsf_req->qtcb->header.fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3763,10 +3678,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_hand_mis");
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("handmism",
-				       fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3787,10 +3698,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 				     "fsf_s_class_nsup");
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("unsclass",
-				       fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3809,10 +3716,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_fcp_lun_nv");
 		zfcp_erp_port_reopen(unit->port, 0);
-		zfcp_cmd_dbf_event_fsf("fluninv",
-				       fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3851,10 +3754,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		debug_text_event(fsf_req->adapter->erp_dbf, 0,
 				 "fsf_s_dir_ind_nv");
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("dirinv",
-				       fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3870,10 +3769,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		debug_text_event(fsf_req->adapter->erp_dbf, 0,
 				 "fsf_s_cmd_len_nv");
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0);
-		zfcp_cmd_dbf_event_fsf("cleninv",
-				       fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -4043,7 +3938,6 @@ zfcp_fsf_send_fcp_command_task_handler(s
 			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 				      (char *) &fsf_req->qtcb->
 				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
-			zfcp_cmd_dbf_event_fsf("clenmis", fsf_req, NULL, 0);
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		case RSP_CODE_FIELD_INVALID:
@@ -4062,7 +3956,6 @@ zfcp_fsf_send_fcp_command_task_handler(s
 				      (char *) &fsf_req->qtcb->
 				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
 			set_host_byte(&scpnt->result, DID_ERROR);
-			zfcp_cmd_dbf_event_fsf("codeinv", fsf_req, NULL, 0);
 			goto skip_fsfstatus;
 		case RSP_CODE_RO_MISMATCH:
 			/* hardware bug */
@@ -4079,7 +3972,6 @@ zfcp_fsf_send_fcp_command_task_handler(s
 			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 				      (char *) &fsf_req->qtcb->
 				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
-			zfcp_cmd_dbf_event_fsf("codemism", fsf_req, NULL, 0);
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		default:
@@ -4096,7 +3988,6 @@ zfcp_fsf_send_fcp_command_task_handler(s
 			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 				      (char *) &fsf_req->qtcb->
 				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
-			zfcp_cmd_dbf_event_fsf("undeffcp", fsf_req, NULL, 0);
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		}
@@ -4158,19 +4049,17 @@ zfcp_fsf_send_fcp_command_task_handler(s
  skip_fsfstatus:
 	ZFCP_LOG_DEBUG("scpnt->result =0x%x\n", scpnt->result);
 
-	zfcp_cmd_dbf_event_scsi("response", scpnt);
+	if (scpnt->result != 0)
+		zfcp_scsi_dbf_event_result("erro", 3, fsf_req->adapter, scpnt);
+	else if (scpnt->retries > 0)
+		zfcp_scsi_dbf_event_result("retr", 4, fsf_req->adapter, scpnt);
+	else
+		zfcp_scsi_dbf_event_result("norm", 6, fsf_req->adapter, scpnt);
 
 	/* cleanup pointer (need this especially for abort) */
 	scpnt->host_scribble = NULL;
 
-	/*
-	 * NOTE:
-	 * according to the outcome of a discussion on linux-scsi we
-	 * don't need to grab the io_request_lock here since we use
-	 * the new eh
-	 */
 	/* always call back */
-
 	(scpnt->scsi_done) (scpnt);
 
 	/*
@@ -4563,15 +4452,16 @@ zfcp_fsf_req_sbal_check(unsigned long *f
  * set qtcb pointer in fsf_req and initialize QTCB
  */
 static inline void
-zfcp_fsf_req_qtcb_init(struct zfcp_fsf_req *fsf_req, u32 fsf_cmd)
+zfcp_fsf_req_qtcb_init(struct zfcp_fsf_req *fsf_req)
 {
 	if (likely(fsf_req->qtcb != NULL)) {
+		fsf_req->qtcb->prefix.req_seq_no = fsf_req->adapter->fsf_req_seq_no;
 		fsf_req->qtcb->prefix.req_id = (unsigned long)fsf_req;
 		fsf_req->qtcb->prefix.ulp_info = ZFCP_ULP_INFO_VERSION;
-		fsf_req->qtcb->prefix.qtcb_type = fsf_qtcb_type[fsf_cmd];
+		fsf_req->qtcb->prefix.qtcb_type = fsf_qtcb_type[fsf_req->fsf_command];
 		fsf_req->qtcb->prefix.qtcb_version = ZFCP_QTCB_VERSION;
 		fsf_req->qtcb->header.req_handle = (unsigned long)fsf_req;
-		fsf_req->qtcb->header.fsf_command = fsf_cmd;
+		fsf_req->qtcb->header.fsf_command = fsf_req->fsf_command;
 	}
 }
 
@@ -4639,7 +4529,10 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 		goto failed_fsf_req;
 	}
 
-        zfcp_fsf_req_qtcb_init(fsf_req, fsf_cmd);
+	fsf_req->adapter = adapter;
+	fsf_req->fsf_command = fsf_cmd;
+
+        zfcp_fsf_req_qtcb_init(fsf_req);
 
 	/* initialize waitqueue which may be used to wait on 
 	   this request completion */
@@ -4661,8 +4554,10 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 		goto failed_sbals;
 	}
 
-	fsf_req->adapter = adapter;	/* pointer to "parent" adapter */
-	fsf_req->fsf_command = fsf_cmd;
+	if (fsf_req->qtcb) {
+		fsf_req->seq_no = adapter->fsf_req_seq_no;
+		fsf_req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
+	}
 	fsf_req->sbal_number = 1;
 	fsf_req->sbal_first = req_queue->free_index;
 	fsf_req->sbal_curr = req_queue->free_index;
@@ -4713,9 +4608,9 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 	struct zfcp_adapter *adapter;
 	struct zfcp_qdio_queue *req_queue;
 	volatile struct qdio_buffer_element *sbale;
+	int inc_seq_no;
 	int new_distance_from_int;
 	unsigned long flags;
-	int inc_seq_no = 1;
 	int retval = 0;
 
 	adapter = fsf_req->adapter;
@@ -4729,23 +4624,13 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE, (char *) sbale[1].addr,
 		      sbale[1].length);
 
-	/* set sequence counter in QTCB */
-	if (likely(fsf_req->qtcb)) {
-		fsf_req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
-		fsf_req->seq_no = adapter->fsf_req_seq_no;
-		ZFCP_LOG_TRACE("FSF request %p of adapter %s gets "
-			       "FSF sequence counter value of %i\n",
-			       fsf_req,
-			       zfcp_get_busid_by_adapter(adapter),
-			       fsf_req->qtcb->prefix.req_seq_no);
-	} else
-		inc_seq_no = 0;
-
 	/* put allocated FSF request at list tail */
 	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 	list_add_tail(&fsf_req->list, &adapter->fsf_req_list_head);
 	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
 
+	inc_seq_no = (fsf_req->qtcb != NULL);
+
 	/* figure out expiration time of timeout and start timeout */
 	if (unlikely(timer)) {
 		timer->expires += jiffies;
@@ -4775,6 +4660,8 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 	req_queue->free_index %= QDIO_MAX_BUFFERS_PER_Q;  /* wrap if needed */
 	new_distance_from_int = zfcp_qdio_determine_pci(req_queue, fsf_req);
 
+	fsf_req->issued = get_clock();
+
 	retval = do_QDIO(adapter->ccw_device,
 			 QDIO_FLAG_SYNC_OUTPUT,
 			 0, fsf_req->sbal_first, fsf_req->sbal_number, NULL);
@@ -4813,15 +4700,11 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 		 * routines  resulting in missing sequence counter values
 		 * otherwise,
 		 */
+
 		/* Don't increase for unsolicited status */
-		if (likely(inc_seq_no)) {
+		if (inc_seq_no)
 			adapter->fsf_req_seq_no++;
-			ZFCP_LOG_TRACE
-			    ("FSF sequence counter value of adapter %s "
-			     "increased to %i\n",
-			     zfcp_get_busid_by_adapter(adapter),
-			     adapter->fsf_req_seq_no);
-		}
+
 		/* count FSF requests pending */
 		atomic_inc(&adapter->fsf_reqs_active);
 	}
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.h linux-2.6.13/drivers/s390/scsi/zfcp_fsf.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.h	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_fsf.h	2005-09-03 12:23:14.000000000 +0200
@@ -116,6 +116,7 @@
 #define FSF_INVALID_COMMAND_OPTION              0x000000E5
 /* #define FSF_ERROR                             0x000000FF  */
 
+#define FSF_PROT_STATUS_QUAL_SIZE		16
 #define FSF_STATUS_QUALIFIER_SIZE		16
 
 /* FSF status qualifier, recommendations */
@@ -311,6 +312,7 @@ struct fsf_qual_locallink_error {
 } __attribute__ ((packed));
 
 union fsf_prot_status_qual {
+	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
 	struct fsf_qual_locallink_error locallink_error;
@@ -331,6 +333,7 @@ union fsf_status_qual {
 	u8  byte[FSF_STATUS_QUALIFIER_SIZE];
 	u16 halfword[FSF_STATUS_QUALIFIER_SIZE / sizeof (u16)];
 	u32 word[FSF_STATUS_QUALIFIER_SIZE / sizeof (u32)];
+	u64 doubleword[FSF_STATUS_QUALIFIER_SIZE / sizeof(u64)];
 	struct fsf_queue_designator fsf_queue_designator;
 } __attribute__ ((packed));
 
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_qdio.c linux-2.6.13/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_qdio.c	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_qdio.c	2005-09-03 12:23:14.000000000 +0200
@@ -54,8 +54,7 @@ static inline int zfcp_qdio_sbals_from_b
 static qdio_handler_t zfcp_qdio_request_handler;
 static qdio_handler_t zfcp_qdio_response_handler;
 static int zfcp_qdio_handler_error_check(struct zfcp_adapter *,
-					 unsigned int,
-					 unsigned int, unsigned int);
+	unsigned int, unsigned int, unsigned int, int, int);
 
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_QDIO
 
@@ -214,22 +213,12 @@ zfcp_qdio_allocate(struct zfcp_adapter *
  *
  */
 static inline int
-zfcp_qdio_handler_error_check(struct zfcp_adapter *adapter,
-			      unsigned int status,
-			      unsigned int qdio_error, unsigned int siga_error)
+zfcp_qdio_handler_error_check(struct zfcp_adapter *adapter, unsigned int status,
+			      unsigned int qdio_error, unsigned int siga_error,
+			      int first_element, int elements_processed)
 {
 	int retval = 0;
 
-	if (ZFCP_LOG_CHECK(ZFCP_LOG_LEVEL_TRACE)) {
-		if (status & QDIO_STATUS_INBOUND_INT) {
-			ZFCP_LOG_TRACE("status is"
-				       " QDIO_STATUS_INBOUND_INT \n");
-		}
-		if (status & QDIO_STATUS_OUTBOUND_INT) {
-			ZFCP_LOG_TRACE("status is"
-				       " QDIO_STATUS_OUTBOUND_INT \n");
-		}
-	}
 	if (unlikely(status & QDIO_STATUS_LOOK_FOR_ERROR)) {
 		retval = -EIO;
 
@@ -237,9 +226,10 @@ zfcp_qdio_handler_error_check(struct zfc
 			      "qdio_error=0x%x, siga_error=0x%x)\n",
 			      status, qdio_error, siga_error);
 
-		/* Restarting IO on the failed adapter from scratch */
-		debug_text_event(adapter->erp_dbf, 1, "qdio_err");
+		zfcp_hba_dbf_event_qdio(adapter, status, qdio_error, siga_error,
+				first_element, elements_processed);
                /*
+               	* Restarting IO on the failed adapter from scratch.
                 * Since we have been using this adapter, it is save to assume
                 * that it is not failed but recoverable. The card seems to
                 * report link-up events by self-initiated queue shutdown.
@@ -282,7 +272,8 @@ zfcp_qdio_request_handler(struct ccw_dev
 		       first_element, elements_processed);
 
 	if (unlikely(zfcp_qdio_handler_error_check(adapter, status, qdio_error,
-					           siga_error)))
+						   siga_error, first_element,
+						   elements_processed)))
 		goto out;
 	/*
 	 * we stored address of struct zfcp_adapter  data structure
@@ -334,7 +325,8 @@ zfcp_qdio_response_handler(struct ccw_de
 	queue = &adapter->response_queue;
 
 	if (unlikely(zfcp_qdio_handler_error_check(adapter, status, qdio_error,
-					           siga_error)))
+						   siga_error, first_element,
+						   elements_processed)))
 		goto out;
 
 	/*
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c	2005-09-03 12:22:58.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c	2005-09-03 12:23:14.000000000 +0200
@@ -45,7 +45,8 @@ static int zfcp_scsi_eh_device_reset_han
 static int zfcp_scsi_eh_bus_reset_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *);
 static enum scsi_eh_timer_return zfcp_scsi_eh_timed_out(struct scsi_cmnd *);
-static int zfcp_task_management_function(struct zfcp_unit *, u8);
+static int zfcp_task_management_function(struct zfcp_unit *, u8,
+					 struct scsi_cmnd *);
 
 static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *, int, scsi_id_t,
 					  scsi_lun_t);
@@ -244,6 +245,10 @@ static void
 zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
 	set_host_byte(&scpnt->result, result);
+	if ((scpnt->device != NULL) && (scpnt->device->host != NULL))
+		zfcp_scsi_dbf_event_result("fail", 4,
+			(struct zfcp_adapter*) scpnt->device->host->hostdata[0],
+			scpnt);
 	/* return directly */
 	scpnt->scsi_done(scpnt);
 }
@@ -416,13 +421,12 @@ zfcp_port_lookup(struct zfcp_adapter *ad
 }
 
 int
-zfcp_scsi_abort_async(struct scsi_cmnd *scpnt,
- 		      struct zfcp_fsf_req **fsf_req_ptr)
+zfcp_scsi_abort_async(struct scsi_cmnd *scpnt, struct zfcp_fsf_req **fsf_req_ptr)
 {
  	struct Scsi_Host *scsi_host;
  	struct zfcp_adapter *adapter;
 	struct zfcp_unit *unit;
-  	struct zfcp_fsf_req *new_fsf_req;
+	struct zfcp_fsf_req *new_fsf_req = NULL;
   	struct zfcp_fsf_req *old_fsf_req;
   	int req_flags;
 	unsigned long flags;
@@ -447,6 +451,7 @@ zfcp_scsi_abort_async(struct scsi_cmnd *
 	old_fsf_req = (struct zfcp_fsf_req *) scpnt->host_scribble;
 	if (!old_fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
+		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, new_fsf_req);
 		if (fsf_req_ptr)
 			*fsf_req_ptr = NULL;
 		return SUCCESS;
@@ -463,6 +468,7 @@ zfcp_scsi_abort_async(struct scsi_cmnd *
 						 adapter, unit, req_flags);
 	if (!new_fsf_req) {
 		ZFCP_LOG_INFO("error: initiation of Abort FCP Command failed\n");
+		zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, new_fsf_req);
 		if (fsf_req_ptr)
 			*fsf_req_ptr = NULL;
 		return FAILED;
@@ -485,16 +491,21 @@ zfcp_scsi_abort_sync(struct scsi_cmnd *s
 		return retval;
 
   	/* wait for completion of abort */
-  	__wait_event(
-		fsf_req->completion_wq,
+	__wait_event(fsf_req->completion_wq,
 		fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
  	/* status should be valid since signals were not permitted */
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
+		zfcp_scsi_dbf_event_abort("okay", fsf_req->adapter, scpnt,
+					  fsf_req);
   		retval = SUCCESS;
 	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
+		zfcp_scsi_dbf_event_abort("lte2", fsf_req->adapter, scpnt,
+					  fsf_req);
   		retval = SUCCESS;
   	} else {
+		zfcp_scsi_dbf_event_abort("fail", fsf_req->adapter, scpnt,
+					  fsf_req);
   		retval = FAILED;
   	}
   
@@ -581,8 +592,9 @@ zfcp_scsi_eh_device_reset_handler(struct
 	 */
 	if (!atomic_test_mask(ZFCP_STATUS_UNIT_NOTSUPPUNITRESET,
 			      &unit->status)) {
-		retval =
-		    zfcp_task_management_function(unit, FCP_LOGICAL_UNIT_RESET);
+		retval = zfcp_task_management_function(unit,
+						       FCP_LOGICAL_UNIT_RESET,
+						       scpnt);
 		if (retval) {
 			ZFCP_LOG_DEBUG("unit reset failed (unit=%p)\n", unit);
 			if (retval == -ENOTSUPP)
@@ -598,7 +610,7 @@ zfcp_scsi_eh_device_reset_handler(struct
 			goto out;
 		}
 	}
-	retval = zfcp_task_management_function(unit, FCP_TARGET_RESET);
+	retval = zfcp_task_management_function(unit, FCP_TARGET_RESET, scpnt);
 	if (retval) {
 		ZFCP_LOG_DEBUG("target reset failed (unit=%p)\n", unit);
 		retval = FAILED;
@@ -611,7 +623,8 @@ zfcp_scsi_eh_device_reset_handler(struct
 }
 
 static int
-zfcp_task_management_function(struct zfcp_unit *unit, u8 tm_flags)
+zfcp_task_management_function(struct zfcp_unit *unit, u8 tm_flags,
+			      struct scsi_cmnd *scpnt)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 	struct zfcp_fsf_req *fsf_req;
@@ -625,6 +638,7 @@ zfcp_task_management_function(struct zfc
 			      "failed for unit 0x%016Lx on port 0x%016Lx on  "
 			      "adapter %s\n", unit->fcp_lun, unit->port->wwpn,
 			      zfcp_get_busid_by_adapter(adapter));
+		zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit, scpnt);
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -632,11 +646,17 @@ zfcp_task_management_function(struct zfc
 	__wait_event(fsf_req->completion_wq,
 		     fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	/* check completion status of task management function */
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED)
+	/*
+	 * check completion status of task management function
+	 */
+	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
+		zfcp_scsi_dbf_event_devreset("fail", tm_flags, unit, scpnt);
 		retval = -EIO;
-	else if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP)
+	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP) {
+		zfcp_scsi_dbf_event_devreset("nsup", tm_flags, unit, scpnt);
 		retval = -ENOTSUPP;
+	} else
+		zfcp_scsi_dbf_event_devreset("okay", tm_flags, unit, scpnt);
 
 	zfcp_fsf_req_free(fsf_req);
  out:
