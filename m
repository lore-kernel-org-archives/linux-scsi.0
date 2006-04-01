From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [CMT 06/16] qla4xxx: driver review ql4_glbl.h
Date: Sat, 01 Apr 2006 11:52:18 -0600
Message-ID: <200604011752.k31HqIiV012107@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:4992 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S1751569AbWDARwb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 12:52:31 -0500
In-reply-to: 200604010418.k314Iqam008288@falcon30.maxeymade.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

"extern" is not needed for function decls.

++doug
--
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
new file mode 100644
index 0000000..530a7f6
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -0,0 +1,140 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#ifndef __QLA4x_GBL_H
+#define	__QLA4x_GBL_H

alignment - a tab snuck in here.

+
+/*
+ * Defined in ql4_os.c
+ */
+extern void qla4xxx_start_io(scsi_qla_host_t * ha);

-ENOTUSED

+extern srb_t *del_from_active_array(scsi_qla_host_t * ha, uint32_t index);
+extern void qla4xxx_srb_compl(scsi_qla_host_t *, srb_t *);
+extern int qla4xxx_reset_lun(scsi_qla_host_t * ha, ddb_entry_t * ddb_entry,
+				 int);
+extern int qla4xxx_soft_reset(scsi_qla_host_t *);
+extern const char *host_sts_msg[];

-ENOTUSED

+extern void qla4xxx_delete_timer_from_cmd(srb_t * srb);

-ENOTUSED

+extern scsi_qla_host_t *qla4xxx_get_adapter_handle(uint16_t instance);

-ENOTUSED

+extern void qla4xxx_free_ddb_list(scsi_qla_host_t * ha);
+extern void qla4xxx_mark_device_missing(scsi_qla_host_t *, ddb_entry_t *);
+extern int extended_error_logging;
+extern int ql4xdontresethba;
+
+/*
+ * Defined in  ql4_iocb.c
+ */
+extern int qla4xxx_send_marker(scsi_qla_host_t * ha,
+				   ddb_entry_t * ddb_entry, int);

-ENOTUSED

+extern int qla4xxx_send_marker_iocb(scsi_qla_host_t * ha,
+					ddb_entry_t * ddb_entry, int);
+extern int qla4xxx_get_req_pkt(scsi_qla_host_t *, QUEUE_ENTRY **);
+extern PDU_ENTRY *qla4xxx_get_pdu(scsi_qla_host_t *, uint32_t);
+extern void qla4xxx_free_pdu(scsi_qla_host_t *, PDU_ENTRY *);
+extern int qla4xxx_send_passthru0_iocb(scsi_qla_host_t *, uint16_t,
+					   uint16_t, dma_addr_t, uint32_t,
+					   uint32_t, uint16_t, uint32_t);
+
+/*
+ * Defined in  ql4_isr.c
+ */
+extern irqreturn_t qla4xxx_intr_handler(int, void *, struct pt_regs *);
+extern void qla4xxx_interrupt_service_routine(scsi_qla_host_t * ha,
+					      uint32_t intr_status);
+
+/*
+ * Defined in  ql4_init.c
+ */
+extern int qla4xxx_initialize_adapter(scsi_qla_host_t * ha,
+					  uint8_t renew_ddb_list);
+extern ddb_entry_t *qla4xxx_alloc_ddb(scsi_qla_host_t * ha,
+				      uint32_t fw_ddb_index);
+extern int qla4xxx_update_ddb_entry(scsi_qla_host_t * ha,
+					ddb_entry_t * ddb_entry,
+					uint32_t fw_ddb_index);
+extern int qla4xxx_get_fwddb_entry(scsi_qla_host_t * ha,
+				       uint16_t fw_ddb_index,
+				       DEV_DB_ENTRY * fw_ddb_entry,
+				       dma_addr_t fw_ddb_entry_dma,
+				       uint32_t * num_valid_ddb_entries,
+				       uint32_t * next_ddb_index,
+				       uint32_t * fw_ddb_device_state,
+				       uint32_t * time2wait,
+				       uint16_t * tcp_source_port_num,
+				       uint16_t * connection_id);
+extern int qla4xxx_relogin_device(scsi_qla_host_t * ha,
+				      ddb_entry_t * ddb_entry);
+extern int qla4xxx_send_command_to_isp(scsi_qla_host_t *, srb_t *);
+extern int qla4xxx_get_prop_12chars(scsi_qla_host_t * ha, uint8_t * propname,
+				    uint8_t * propval, uint8_t * db);

-ENOTUSED

+extern void qla4xxx_free_ddb(scsi_qla_host_t * ha, ddb_entry_t * ddb_entry);
+extern int qla4xxx_resize_ioctl_dma_buf(scsi_qla_host_t * ha,
+					    uint32_t size);

-ENOTUSED

+extern int qla4xxx_set_ddb_entry(scsi_qla_host_t * ha,
+				     uint16_t fw_ddb_index,
+				     DEV_DB_ENTRY * fw_ddb_entry,
+				     dma_addr_t fw_ddb_entry_dma);
+extern int qla4xxx_conn_open_session_login(scsi_qla_host_t * ha,
+					       uint16_t fw_ddb_index);
+extern int qla4xxx_process_ddb_changed(scsi_qla_host_t * ha,
+					   uint32_t fw_ddb_index,
+					   uint32_t state);
+extern int qla4xxx_init_rings(scsi_qla_host_t * ha);
+extern int qla4xxx_reinitialize_ddb_list(scsi_qla_host_t * ha);
+
+/*
+ * Defined in  ql4_mbx.c
+ */
+extern void qla4xxx_process_aen(scsi_qla_host_t * ha,
+				uint8_t flush_ddb_chg_aens);
+extern int qla4xxx_mailbox_command(scsi_qla_host_t * ha, uint8_t inCount,
+				       uint8_t outCount, uint32_t * mbx_cmd,
+				       uint32_t * mbx_sts);
+extern int qla4xxx_issue_iocb(scsi_qla_host_t * ha, void *buffer,
+				  dma_addr_t phys_addr, size_t size);
+extern int qla4xxx_get_flash(scsi_qla_host_t *, dma_addr_t, uint32_t,
+				 uint32_t);
+extern int qla4xxx_initialize_fw_cb(scsi_qla_host_t *);
+extern int qla4xxx_get_dhcp_ip_address(scsi_qla_host_t *);
+
+extern int qla4xxx_get_firmware_state(scsi_qla_host_t *);
+extern void qla4xxx_get_crash_record(scsi_qla_host_t *);
+extern int qla4xxx_conn_close_sess_logout(scsi_qla_host_t *, uint16_t,
+					      uint16_t, uint16_t);
+extern int qla4xxx_clear_database_entry(scsi_qla_host_t *, uint16_t);
+extern int qla4xxx_get_fw_version(scsi_qla_host_t * ha);
+extern int qla4xxx_get_firmware_status(scsi_qla_host_t * ha);
+extern void qla4xxx_get_conn_event_log(scsi_qla_host_t * ha);
+
+/*
+ * Defined in  ql4_inioct.c
+ */
+extern void qla4xxx_iocb_pass_done(scsi_qla_host_t * ha,
+				   PASSTHRU_STATUS_ENTRY * sts_entry);

-ENOTUSED

+
+/*
+ * Defined in  ql4_xioct.c
+ */
+extern void qla4xxx_scsi_pass_done(struct scsi_cmnd *cmd);

-ENOTUSED

+extern void qla4xxx_ioctl_sem_init(scsi_qla_host_t * ha);

-ENOTUSED

+
+/*
+ * Defined in  ql4_nvram.c
+ */
+extern u16 RD_NVRAM_WORD(scsi_qla_host_t *, int);
+extern int qla4xxx_is_nvram_configuration_valid(scsi_qla_host_t * ha);
+extern int ql4xxx_sem_lock(scsi_qla_host_t * ha, u32 sem_mask, u32 sem_bits);
+extern void ql4xxx_sem_unlock(scsi_qla_host_t * ha, u32 sem_mask);
+extern int ql4xxx_sem_spinlock(scsi_qla_host_t * ha, u32 sem_mask,
+			       u32 sem_bits);
+
+/*
+ * Defined in  ql4_dbg.c
+ */
+extern void qla4xxx_dump_buffer(uint8_t *, uint32_t);
+
+#endif				/* _QLA4x_GBL_H */
