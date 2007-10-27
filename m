From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/9] lpfc 8.2.3 : Added support for ASICs that report
	temperature
Date: Sat, 27 Oct 2007 13:37:05 -0400
Message-ID: <1193506625.8770.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46306 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbXJ0RhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:00 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHax9L021344
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:36:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Added support for ASICs that report temperature. Temperature notices are
 reported as events and logged. Temperature can be read via sysfs.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 10:33:48.000000000 -0400
@@ -86,6 +86,15 @@ lpfc_serialnum_show(struct class_device 
 }
 
 static ssize_t
+lpfc_temp_sensor_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	return snprintf(buf, PAGE_SIZE, "%d\n",phba->temp_sensor_support);
+}
+
+static ssize_t
 lpfc_modeldesc_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host  *shost = class_to_shost(cdev);
@@ -908,6 +917,8 @@ static CLASS_DEVICE_ATTR(used_rpi, S_IRU
 static CLASS_DEVICE_ATTR(max_xri, S_IRUGO, lpfc_max_xri_show, NULL);
 static CLASS_DEVICE_ATTR(used_xri, S_IRUGO, lpfc_used_xri_show, NULL);
 static CLASS_DEVICE_ATTR(npiv_info, S_IRUGO, lpfc_npiv_info_show, NULL);
+static CLASS_DEVICE_ATTR(lpfc_temp_sensor, S_IRUGO, lpfc_temp_sensor_show,
+			 NULL);
 

 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
@@ -1494,6 +1505,7 @@ struct class_device_attribute *lpfc_hba_
 	&class_device_attr_state,
 	&class_device_attr_num_discovered_ports,
 	&class_device_attr_lpfc_drvr_version,
+	&class_device_attr_lpfc_temp_sensor,
 	&class_device_attr_lpfc_log_verbose,
 	&class_device_attr_lpfc_lun_queue_depth,
 	&class_device_attr_lpfc_hba_queue_depth,
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 10:33:48.000000000 -0400
@@ -23,6 +23,8 @@ typedef int (*node_filter)(struct lpfc_n
 struct fc_rport;
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
 void lpfc_read_nv(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_config_async(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
+
 void lpfc_heart_beat(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
 		 struct lpfc_dmabuf *mp);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-10-27 10:33:48.000000000 -0400
@@ -569,6 +569,7 @@ struct lpfc_hba {
 	atomic_t slow_ring_trc_cnt;
 #endif
 
+	uint8_t temp_sensor_support;
 	/* Fields used for heart beat. */
 	unsigned long last_completion_time;
 	struct timer_list hb_tmofunc;
@@ -598,5 +599,15 @@ lpfc_is_link_up(struct lpfc_hba *phba)
 		phba->link_state == LPFC_HBA_READY;
 }
 
-#define FC_REG_DUMP_EVENT	0x10	/* Register for Dump events */
-
+#define FC_REG_DUMP_EVENT		0x10	/* Register for Dump events */
+#define FC_REG_TEMPERATURE_EVENT	0x20    /* Register for temperature
+						   event */
+
+struct temp_event {
+	uint32_t event_type;
+	uint32_t event_code;
+	uint32_t data;
+};
+#define LPFC_CRIT_TEMP		0x1
+#define LPFC_THRESHOLD_TEMP	0x2
+#define LPFC_NORMAL_TEMP	0x3
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 10:33:48.000000000 -0400
@@ -1228,7 +1228,8 @@ typedef struct {		/* FireFly BIU registe
 #define HS_FFER3       0x20000000	/* Bit 29 */
 #define HS_FFER2       0x40000000	/* Bit 30 */
 #define HS_FFER1       0x80000000	/* Bit 31 */
-#define HS_FFERM       0xFF000000	/* Mask for error bits 31:24 */
+#define HS_CRIT_TEMP   0x00000100	/* Bit 8  */
+#define HS_FFERM       0xFF000100	/* Mask for error bits 31:24 and 8 */
 
 /* Host Control Register */
 
@@ -1282,6 +1283,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_KILL_BOARD      0x24
 #define MBX_CONFIG_FARP     0x25
 #define MBX_BEACON          0x2A
+#define MBX_ASYNCEVT_ENABLE 0x33
 #define MBX_HEARTBEAT       0x31
 
 #define MBX_CONFIG_HBQ	    0x7C
@@ -1344,6 +1346,7 @@ typedef struct {		/* FireFly BIU registe
 
 /*  SLI_2 IOCB Command Set */
 
+#define CMD_ASYNC_STATUS        0x7C
 #define CMD_RCV_SEQUENCE64_CX   0x81
 #define CMD_XMIT_SEQUENCE64_CR  0x82
 #define CMD_XMIT_SEQUENCE64_CX  0x83
@@ -1406,6 +1409,8 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_BUSY                   0xffffff /* Attempted cmd to busy Mailbox */
 #define MBX_TIMEOUT                0xfffffe /* time-out expired waiting for */
 
+#define TEMPERATURE_OFFSET 0xB0	/* Slim offset for critical temperature event */
+
 /*
  *    Begin Structure Definitions for Mailbox Commands
  */
@@ -2606,6 +2611,18 @@ typedef struct {
 	uint32_t IPAddress;
 } CONFIG_FARP_VAR;
 
+/* Structure for MB Command MBX_ASYNCEVT_ENABLE (0x33) */
+
+typedef struct {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd:30;
+	uint32_t ring:2;	/* Ring for ASYNC_EVENT iocb Bits 0-1*/
+#else /*  __LITTLE_ENDIAN */
+	uint32_t ring:2;	/* Ring for ASYNC_EVENT iocb Bits 0-1*/
+	uint32_t rsvd:30;
+#endif
+} ASYNCEVT_ENABLE_VAR;
+
 /* Union of all Mailbox Command types */
 #define MAILBOX_CMD_WSIZE	32
 #define MAILBOX_CMD_SIZE	(MAILBOX_CMD_WSIZE * sizeof(uint32_t))
@@ -2645,6 +2662,7 @@ typedef union {
 	CONFIG_PORT_VAR varCfgPort;	/* cmd = 0x88 (CONFIG_PORT)  */
 	REG_VPI_VAR varRegVpi;		/* cmd = 0x96 (REG_VPI) */
 	UNREG_VPI_VAR varUnregVpi;	/* cmd = 0x97 (UNREG_VPI) */
+	ASYNCEVT_ENABLE_VAR varCfgAsyncEvent; /*cmd = x33 (CONFIG_ASYNC) */
 } MAILVARIANTS;
 
 /*
@@ -2987,6 +3005,21 @@ typedef struct {
 	uint32_t fcpt_Length;	/* transfer ready for IWRITE */
 } FCPT_FIELDS64;
 
+/* IOCB Command template for Async Status iocb commands */
+typedef struct {
+	uint32_t rsvd[4];
+	uint32_t param;
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint16_t evt_code;		/* High order bits word 5 */
+	uint16_t sub_ctxt_tag;		/* Low  order bits word 5 */
+#else   /*  __LITTLE_ENDIAN_BITFIELD */
+	uint16_t sub_ctxt_tag;		/* High order bits word 5 */
+	uint16_t evt_code;		/* Low  order bits word 5 */
+#endif
+} ASYNCSTAT_FIELDS;
+#define ASYNC_TEMP_WARN		0x100
+#define ASYNC_TEMP_SAFE		0x101
+
 /* IOCB Command template for CMD_IOCB_RCV_ELS64_CX (0xB7)
    or CMD_IOCB_RCV_SEQ64_CX (0xB5) */
 
@@ -3028,6 +3061,7 @@ typedef struct _IOCB {	/* IOCB structure
 		XMT_SEQ_FIELDS64 xseq64;	/* XMIT / BCAST cmd */
 		FCPI_FIELDS64 fcpi64;	/* FCP 64 bit Initiator template */
 		FCPT_FIELDS64 fcpt64;	/* FCP 64 bit target template */
+		ASYNCSTAT_FIELDS asyncstat; /* async_status iocb */
 
 		uint32_t ulpWord[IOCB_WORD_SZ - 2];	/* generic 6 'words' */
 	} un;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:33:48.000000000 -0400
@@ -212,6 +212,18 @@ out_free_mbox:
 	return 0;
 }
 
+/* Completion handler for config async event mailbox command. */
+static void
+lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
+{
+	if (pmboxq->mb.mbxStatus == MBX_SUCCESS)
+		phba->temp_sensor_support = 1;
+	else
+		phba->temp_sensor_support = 0;
+	mempool_free(pmboxq, phba->mbox_mem_pool);
+	return;
+}
+
 /************************************************************************/
 /*                                                                      */
 /*    lpfc_config_port_post                                             */
@@ -409,7 +421,21 @@ lpfc_config_port_post(struct lpfc_hba *p
 		return -EIO;
 	}
 	/* MBOX buffer will be freed in mbox compl */
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	lpfc_config_async(phba, pmb, LPFC_ELS_RING);
+	pmb->mbox_cmpl = lpfc_config_async_cmpl;
+	pmb->vport = phba->pport;
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
 
+	if ((rc != MBX_BUSY) && (rc != MBX_SUCCESS)) {
+		lpfc_printf_log(phba,
+				KERN_ERR,
+				LOG_INIT,
+				"0456 Adapter failed to issue "
+				"ASYNCEVT_ENABLE mbox status x%x \n.",
+				rc);
+		mempool_free(pmb, phba->mbox_mem_pool);
+	}
 	return (0);
 }
 
@@ -601,6 +627,8 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	struct lpfc_sli_ring  *pring;
 	struct lpfc_vport **vports;
 	uint32_t event_data;
+	unsigned long temperature;
+	struct temp_event temp_event_data;
 	struct Scsi_Host  *shost;
 	int i;
 
@@ -655,6 +683,33 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 			return;
 		}
 		lpfc_unblock_mgmt_io(phba);
+	} else if (phba->work_hs & HS_CRIT_TEMP) {
+		temperature = readl(phba->MBslimaddr + TEMPERATURE_OFFSET);
+		temp_event_data.event_type = FC_REG_TEMPERATURE_EVENT;
+		temp_event_data.event_code = LPFC_CRIT_TEMP;
+		temp_event_data.data = (uint32_t)temperature;
+
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0459 Adapter maximum temperature exceeded "
+				"(%ld), taking this port offline "
+				"Data: x%x x%x x%x\n",
+				temperature, phba->work_hs,
+				phba->work_status[0], phba->work_status[1]);
+
+		shost = lpfc_shost_from_vport(phba->pport);
+		fc_host_post_vendor_event(shost, fc_get_event_number(),
+					  sizeof(temp_event_data),
+					  (char *) &temp_event_data,
+					  SCSI_NL_VID_TYPE_PCI
+					  | PCI_VENDOR_ID_EMULEX);
+
+		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+		lpfc_offline_prep(phba);
+		lpfc_offline(phba);
+		lpfc_unblock_mgmt_io(phba);
+		phba->link_state = LPFC_HBA_ERROR;
+		lpfc_hba_down_post(phba);
+
 	} else {
 		/* The if clause above forces this code path when the status
 		 * failure is a value other than FFER6.  Do not call the offline
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2007-10-27 10:33:48.000000000 -0400
@@ -26,6 +26,7 @@
 #define LOG_IP                        0x20	/* IP traffic history */
 #define LOG_FCP                       0x40	/* FCP traffic history */
 #define LOG_NODE                      0x80	/* Node table events */
+#define LOG_TEMP                      0x100	/* Temperature sensor events */
 #define LOG_MISC                      0x400	/* Miscellaneous events */
 #define LOG_SLI                       0x800	/* SLI events */
 #define LOG_FCP_ERROR                 0x1000	/* log errors, not underruns */
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2007-10-27 10:33:48.000000000 -0400
@@ -82,6 +82,24 @@ lpfc_read_nv(struct lpfc_hba * phba, LPF
 }
 
 /**********************************************/
+/*  lpfc_config_async  Issue a                */
+/*  MBX_ASYNC_EVT_ENABLE mailbox command      */
+/**********************************************/
+void
+lpfc_config_async(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
+		uint32_t ring)
+{
+	MAILBOX_t *mb;
+
+	mb = &pmb->mb;
+	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
+	mb->mbxCommand = MBX_ASYNCEVT_ENABLE;
+	mb->un.varCfgAsyncEvent.ring = ring;
+	mb->mbxOwner = OWN_HOST;
+	return;
+}
+
+/**********************************************/
 /*  lpfc_heart_beat  Issue a HEART_BEAT       */
 /*                mailbox command             */
 /**********************************************/
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-10-26 16:59:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 10:33:48.000000000 -0400
@@ -199,6 +199,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_RCV_ELS_REQ_CX:
 	case CMD_RCV_SEQUENCE64_CX:
 	case CMD_RCV_ELS_REQ64_CX:
+	case CMD_ASYNC_STATUS:
 	case CMD_IOCB_RCV_SEQ64_CX:
 	case CMD_IOCB_RCV_ELS64_CX:
 	case CMD_IOCB_RCV_CONT64_CX:
@@ -754,6 +755,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_FLASH_WR_ULA:
 	case MBX_SET_DEBUG:
 	case MBX_LOAD_EXP_ROM:
+	case MBX_ASYNCEVT_ENABLE:
 	case MBX_REG_VPI:
 	case MBX_UNREG_VPI:
 	case MBX_HEARTBEAT:
@@ -953,6 +955,7 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba
 	return &new_hbq_entry->dbuf;
 }
 
+
 static int
 lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			    struct lpfc_iocbq *saveq)
@@ -964,6 +967,22 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 
 	match = 0;
 	irsp = &(saveq->iocb);
+
+	if (irsp->ulpCommand == CMD_ASYNC_STATUS) {
+		if (pring->lpfc_sli_rcv_async_status)
+			pring->lpfc_sli_rcv_async_status(phba, pring, saveq);
+		else
+			lpfc_printf_log(phba,
+					KERN_WARNING,
+					LOG_SLI,
+					"0316 Ring %d handler: unexpected "
+					"ASYNC_STATUS iocb received evt_code "
+					"0x%x\n",
+					pring->ringno,
+					irsp->un.asyncstat.evt_code);
+		return 1;
+	}
+
 	if ((irsp->ulpCommand == CMD_RCV_ELS_REQ64_CX)
 	    || (irsp->ulpCommand == CMD_RCV_ELS_REQ_CX)
 	    || (irsp->ulpCommand == CMD_IOCB_RCV_ELS64_CX)
@@ -2993,6 +3012,61 @@ lpfc_extra_ring_setup( struct lpfc_hba *
 	return 0;
 }
 
+void
+lpfc_sli_async_event_handler(struct lpfc_hba * phba,
+	struct lpfc_sli_ring * pring, struct lpfc_iocbq * iocbq)
+{
+	IOCB_t *icmd;
+	uint16_t evt_code;
+	uint16_t temp;
+	struct temp_event temp_event_data;
+	struct Scsi_Host *shost;
+
+	icmd = &iocbq->iocb;
+	evt_code = icmd->un.asyncstat.evt_code;
+	temp = icmd->ulpContext;
+
+	if ((evt_code != ASYNC_TEMP_WARN) &&
+		(evt_code != ASYNC_TEMP_SAFE)) {
+		lpfc_printf_log(phba,
+			KERN_ERR,
+			LOG_SLI,
+			"0327 Ring %d handler: unexpected ASYNC_STATUS"
+			" evt_code 0x%x\n",
+			pring->ringno,
+			icmd->un.asyncstat.evt_code);
+		return;
+	}
+	temp_event_data.data = (uint32_t)temp;
+	temp_event_data.event_type = FC_REG_TEMPERATURE_EVENT;
+	if (evt_code == ASYNC_TEMP_WARN) {
+		temp_event_data.event_code = LPFC_THRESHOLD_TEMP;
+		lpfc_printf_log(phba,
+				KERN_WARNING,
+				LOG_TEMP,
+				"0339 Adapter is very hot, please take "
+				"corrective action. temperature : %d Celsius\n",
+				temp);
+	}
+	if (evt_code == ASYNC_TEMP_SAFE) {
+		temp_event_data.event_code = LPFC_NORMAL_TEMP;
+		lpfc_printf_log(phba,
+				KERN_INFO,
+				LOG_TEMP,
+				"0340 Adapter temperature is OK now. "
+				"temperature : %d Celsius\n",
+				temp);
+	}
+
+	/* Send temperature change event to applications */
+	shost = lpfc_shost_from_vport(phba->pport);
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+		sizeof(temp_event_data), (char *) &temp_event_data,
+		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
+}
+
+
 int
 lpfc_sli_setup(struct lpfc_hba *phba)
 {
@@ -3059,6 +3133,8 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 			pring->fast_iotag = 0;
 			pring->iotag_ctr = 0;
 			pring->iotag_max = 4096;
+			pring->lpfc_sli_rcv_async_status =
+				lpfc_sli_async_event_handler;
 			pring->num_mask = 4;
 			pring->prt[0].profile = 0;	/* Mask 0 */
 			pring->prt[0].rctl = FC_ELS_REQ;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-10-27 10:33:48.000000000 -0400
@@ -166,6 +166,8 @@ struct lpfc_sli_ring {
 
 	struct lpfc_sli_ring_mask prt[LPFC_MAX_RING_MASK];
 	uint32_t num_mask;	/* number of mask entries in prt array */
+	void (*lpfc_sli_rcv_async_status) (struct lpfc_hba *,
+		struct lpfc_sli_ring *, struct lpfc_iocbq *);
 
 	struct lpfc_sli_ring_stat stats;	/* SLI statistical info */
 


