From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] qla2xxx: remove dead code, add missing statics
Date: Mon, 1 Nov 2004 15:31:00 +0100
Message-ID: <20041101143100.GA10168@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:53673 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264530AbUKAObh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2004 09:31:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


===== drivers/scsi/qla2xxx/qla_devtbl.h 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/qla_devtbl.h	2004-03-12 18:08:32 +01:00
+++ edited/drivers/scsi/qla2xxx/qla_devtbl.h	2004-10-20 23:40:56 +02:00
@@ -3,7 +3,7 @@
 /*
  * Adapter model names.
  */
-char	*qla2x00_model_name[QLA_MODEL_NAMES] = {
+static char *qla2x00_model_name[QLA_MODEL_NAMES] = {
 	"QLA2340",	/* 0x100 */
 	"QLA2342",	/* 0x101 */
 	"QLA2344",	/* 0x102 */
@@ -39,7 +39,7 @@
 	"QLA4040C"	/* 0x120 */
 };
 
-char	*qla2x00_model_desc[QLA_MODEL_NAMES] = {
+static char *qla2x00_model_desc[QLA_MODEL_NAMES] = {
 	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x100 */
 	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x101 */
 	"133MHz PCI-X to 2Gb FC, Quad Channel",		/* 0x102 */
===== drivers/scsi/qla2xxx/qla_gbl.h 1.14 vs edited =====
--- 1.14/drivers/scsi/qla2xxx/qla_gbl.h	2004-09-06 21:07:52 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_gbl.h	2004-10-20 23:47:08 +02:00
@@ -45,8 +45,6 @@
 extern void qla2x00_rescan_fcports(scsi_qla_host_t *);
 
 extern void qla2x00_tgt_free(scsi_qla_host_t *ha, uint16_t t);
-extern os_tgt_t *qla2x00_tgt_alloc(scsi_qla_host_t *, uint16_t);
-extern os_lun_t * qla2x00_lun_alloc(scsi_qla_host_t *, uint16_t, uint16_t);
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
@@ -82,9 +80,6 @@
 
 extern void qla2x00_cmd_timeout(srb_t *);
 
-extern int qla2x00_queuecommand(struct scsi_cmnd *,
-    void (*)(struct scsi_cmnd *));
-
 extern int __qla2x00_suspend_lun(scsi_qla_host_t *, os_lun_t *, int, int, int);
 
 extern void qla2x00_done(scsi_qla_host_t *);
@@ -92,17 +87,11 @@
 extern void qla2x00_flush_failover_q(scsi_qla_host_t *, os_lun_t *);
 extern void qla2x00_reset_lun_fo_counts(scsi_qla_host_t *, os_lun_t *);
 
-extern int qla2x00_check_tgt_status(scsi_qla_host_t *, struct scsi_cmnd *);
-extern int qla2x00_check_port_status(scsi_qla_host_t *, fc_port_t *);
-
 extern void qla2x00_extend_timeout(struct scsi_cmnd *, int);
-extern srb_t * qla2x00_get_new_sp (scsi_qla_host_t *ha);
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
 
-extern int qla2x00_get_prop_xstr(scsi_qla_host_t *, char *, uint8_t *, int);
-
 extern void qla2x00_abort_queues(scsi_qla_host_t *, uint8_t);
 
 extern void qla2x00_blink_led(scsi_qla_host_t *);
@@ -112,8 +101,6 @@
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
-extern request_t *qla2x00_req_pkt(scsi_qla_host_t *);
-extern request_t *qla2x00_ms_req_pkt(scsi_qla_host_t *, srb_t *);
 extern void qla2x00_isp_cmd(scsi_qla_host_t *);
 
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
@@ -128,9 +115,6 @@
  * Global Function Prototypes in qla_mbx.c source file.
  */
 extern int
-qla2x00_mailbox_command(scsi_qla_host_t *, mbx_cmd_t *);
-
-extern int
 qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t);
 
 extern int
@@ -150,13 +134,6 @@
 qla2x00_set_fw_options(scsi_qla_host_t *, uint16_t *);
 
 extern int
-qla2x00_read_ram_word(scsi_qla_host_t *, uint16_t, uint16_t *);
-extern int
-qla2x00_write_ram_word(scsi_qla_host_t *, uint16_t, uint16_t);
-extern int
-qla2x00_write_ram_word_ext(scsi_qla_host_t *, uint32_t, uint16_t);
-
-extern int
 qla2x00_mbx_reg_test(scsi_qla_host_t *);
 
 extern int
@@ -168,9 +145,6 @@
 extern int
 qla2x00_abort_command(scsi_qla_host_t *, srb_t *);
 
-extern int
-qla2x00_abort_device(scsi_qla_host_t *, uint16_t, uint16_t);
-
 #if USE_ABORT_TGT
 extern int
 qla2x00_abort_target(fc_port_t *fcport);
@@ -198,9 +172,6 @@
 extern int
 qla2x00_get_port_name(scsi_qla_host_t *, uint16_t, uint8_t *, uint8_t);
 
-extern uint8_t
-qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, link_stat_t *, uint16_t *);
-
 extern int
 qla2x00_lip_reset(scsi_qla_host_t *);
 
@@ -222,19 +193,6 @@
 
 extern int
 qla2x00_get_id_list(scsi_qla_host_t *, void *, dma_addr_t, uint16_t *);
-
-extern int
-qla2x00_lun_reset(scsi_qla_host_t *, uint16_t, uint16_t);
-
-extern int
-qla2x00_send_rnid_mbx(scsi_qla_host_t *, uint16_t, uint8_t, dma_addr_t,
-    size_t, uint16_t *);
-
-extern int
-qla2x00_set_rnid_params_mbx(scsi_qla_host_t *, dma_addr_t, size_t, uint16_t *);
-
-extern int
-qla2x00_get_rnid_params_mbx(scsi_qla_host_t *, dma_addr_t, size_t, uint16_t *);
 
 extern int
 qla2x00_get_resource_cnts(scsi_qla_host_t *, uint16_t *, uint16_t *, uint16_t *,
===== drivers/scsi/qla2xxx/qla_init.c 1.37 vs edited =====
--- 1.37/drivers/scsi/qla2xxx/qla_init.c	2004-10-09 14:34:56 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_init.c	2004-10-20 23:49:03 +02:00
@@ -68,24 +68,12 @@
     fc_lun_t *);
 static void qla2x00_lun_free(scsi_qla_host_t *, uint16_t, uint16_t);
 
-static int qla2x00_bstr_to_hex(char *, uint8_t *, int);
-static int qla2x00_find_propname(scsi_qla_host_t *,
-    char *, char *, char *, int);
-#if 0
-static void qla2x00_get_lun_mask_from_config(scsi_qla_host_t *, fc_port_t *,
-    uint16_t, uint16_t);
-static int qla2x00_get_prop_16chars(scsi_qla_host_t *,
-    char *, char *, char *);
-static void qla2x00_get_properties(scsi_qla_host_t *, char *);
-
-static void qla2x00_cfg_persistent_binding(scsi_qla_host_t *);
-static os_tgt_t *qla2x00_persistent_bind(scsi_qla_host_t *, uint8_t *,
-    uint8_t *, port_id_t *, uint16_t);
-#endif
-
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 static void qla2x00_reset_adapter(scsi_qla_host_t *);
 
+static os_tgt_t *qla2x00_tgt_alloc(scsi_qla_host_t *, uint16_t);
+static os_lun_t *qla2x00_lun_alloc(scsi_qla_host_t *, uint16_t, uint16_t);
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
@@ -140,18 +128,6 @@
 
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
-#if 0
-	/*
-	 * If the user specified a device configuration on the command line
-	 * then use it as the configuration.  Otherwise, we scan for all
-	 * devices.
-	 */
-	if (ql2xdevconf) {
-		ha->cmdline = ql2xdevconf;
-		qla2x00_get_properties(ha, ql2xdevconf);
-	}
-#endif
-
 	retry = 10;
 	/*
 	 * Try to configure the loop.
@@ -3391,10 +3367,6 @@
 		tq->fcport = fcport;
 		set_bit(TQF_ONLINE, &tq->flags);
 		tq->port_down_retry_count = ha->port_down_retry_count;
-
-#if 0
-		qla2x00_get_lun_mask_from_config(ha, fcport, tgt, 0);
-#endif
 	}
 
 	if (tgt == MAX_TARGETS) {
@@ -3467,7 +3439,7 @@
  * Context:
  *	Kernel context.
  */
-os_tgt_t *
+static os_tgt_t *
 qla2x00_tgt_alloc(scsi_qla_host_t *ha, uint16_t tgt) 
 {
 	os_tgt_t	*tq;
@@ -3561,7 +3533,7 @@
  * Context:
  *	Kernel context.
  */
-os_lun_t *
+static os_lun_t *
 qla2x00_lun_alloc(scsi_qla_host_t *ha, uint16_t tgt, uint16_t lun) 
 {
 	os_lun_t	*lq;
@@ -3636,482 +3608,6 @@
 
 	return;
 }
-
-
-#if 0
-/*
- * qla2x00_get_lun_mask_from_config
- *      Get lun mask from the configuration parameters.
- *      Bit order is little endian.
- *
- * Input:
- * ha  -- Host adapter
- * tgt  -- target/device number
- * port -- pointer to port
- */
-static void
-qla2x00_get_lun_mask_from_config(scsi_qla_host_t *ha,
-    fc_port_t *fcport, uint16_t tgt, uint16_t dev_no) 
-{
-	char		propbuf[60]; /* size of search string */
-	int		rval, lun, bit;
-	lun_bit_mask_t	lun_mask, *mask_ptr = &lun_mask;
-
-	/* Get "target-N-device-N-lun-mask" as a 256 bit lun_mask*/
-	sprintf(propbuf, "scsi-qla%ld-tgt-%d-di-%d-lun-disabled",
-	    ha->instance, tgt, dev_no);
-
-	rval = qla2x00_get_prop_xstr(ha, propbuf,
-	    (uint8_t *)&lun_mask, sizeof(lun_bit_mask_t));
-	if (rval == sizeof(lun_bit_mask_t)) {
-		memset(&fcport->lun_mask, 0, sizeof(lun_bit_mask_t));
-		for (lun = 8 * sizeof(lun_bit_mask_t) - 1, bit = 0;
-		    lun >= 0; lun--, bit++) {
-			if (EXT_IS_LUN_BIT_SET(mask_ptr, lun))
-				EXT_SET_LUN_BIT((&fcport->lun_mask), bit);
-		}
-
-		DEBUG3(printk("scsi(%ld): returning lun mask for fcport "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x:\n",
-		    ha->host_no,
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7]));
-		DEBUG3(qla2x00_dump_buffer((uint8_t *)&fcport->lun_mask,
-		    sizeof(lun_bit_mask_t));)
-	}
-}
-#endif
-
-/*
- * qla2x00_bstr_to_hex
- *	Convert hex byte string to number.
- *
- * Input:
- *	s = byte string pointer.
- *	bp = byte pointer for number.
- *	size = number of bytes.
- *
- * Context:
- *	Kernel/Interrupt context.
- */
-static int
-qla2x00_bstr_to_hex(char *s, uint8_t *bp, int size) 
-{
-	int		cnt;
-	uint8_t		n;
-
-	for (cnt = 0; *s != '\0' && cnt / 2 < size; cnt++) {
-		if (*s >= 'A' && *s <= 'F') {
-			n = (*s++ - 'A') + 10;
-		} else if (*s >= 'a' && *s <= 'f') {
-			n = (*s++ - 'a') + 10;
-		} else if (*s >= '0' && *s <= '9') {
-			n = *s++ - '0';
-		} else {
-			cnt = 0;
-			break;
-		}
-
-		if (cnt & BIT_0)
-			*bp++ |= n;
-		else
-			*bp = n << 4;
-	}
-
-	/* fixme(dg) Need to swap data little endian */
-
-	return (cnt / 2);
-}
-
-/*
- * qla2x00_get_prop_xstr
- *      Get a string property value for the specified property name and
- *      convert from the property string found in the configuration file,
- *      which are ASCII characters representing nibbles, 2 characters represent
- *      the hexdecimal value for a byte in the byte array.
- *      The byte array is initialized to zero.
- *      The resulting converted value is in big endian format (MSB at byte0).
- *
- * Input:
- *      ha = adapter state pointer.
- *      propname = property name pointer.
- *      propval  = pointer where to store converted property val.
- *      size = max or expected size of 'propval' array.
- *
- * Returns:
- *      0 = empty value string or invalid character in string
- *      >0 = count of characters converted
- *      -1 = property not found
- *
- * Context:
- *      Kernel context.
- */
-int
-qla2x00_get_prop_xstr(scsi_qla_host_t *ha, 
-		char *propname, uint8_t *propval, int size) 
-{
-	char		*propstr;
-	int		rval = -1;
-	static char	buf[LINESIZE];
-
-	/* Get the requested property string */
-	rval = qla2x00_find_propname(ha, propname, buf, ha->cmdline, size*2);
-	DEBUG3(printk("%s(): Ret rval from find propname = %d\n",
-			__func__,
-			rval);)
-
-	propstr = &buf[0];
-	if (*propstr == '=')
-		propstr++;   /* ignore equal sign */
-
-	if (rval == 0) {  /* not found */
-		return (-1);
-	}
-
-	rval = qla2x00_bstr_to_hex(propstr, (uint8_t *)propval, size);
-	if (rval == 0) {
-		/* Invalid character in value string */
-		qla_printk(KERN_INFO, ha,
-			"%s(): %s Invalid hex string for property\n",
-			__func__,
-			propname);
-		qla_printk(KERN_INFO, ha,
-			" Invalid string - %s\n", 
-			propstr);
-	}
-
-	return (rval);
-}
-
-/*
- * qla2x00_find_propname
- *	Get property in database.
- *
- * Input:
- *	ha = adapter structure pointer.
- *      db = pointer to database
- *      propstr = pointer to dest array for string
- *	propname = name of property to search for.
- *	siz = size of property
- *
- * Returns:
- *	0 = no property
- *      size = index of property
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_find_propname(scsi_qla_host_t *ha, 
-			char *propname, char *propstr, 
-			char *db, int siz) 
-{
-	char	*cp;
-
-	/* find the specified string */
-	if (db) {
-		/* find the property name */
-		if ((cp = strstr(db,propname)) != NULL) {
-			while ((*cp)  && *cp != '=')
-				cp++;
-			if (*cp) {
-				strncpy(propstr, cp, siz+1);
-				propstr[siz+1] = '\0';
-				DEBUG(printk("qla2x00_find_propname: found "
-						"property = {%s}\n",
-						propstr);)
-				return (siz);   /* match */
-			}
-		}
-	}
-
-	return (0);
-}
-
-#if 0
-/*
- * qla2x00_get_prop_16chars
- *	Get an 8-byte property value for the specified property name by
- *      converting from the property string found in the configuration file.
- *      The resulting converted value is in big endian format (MSB at byte0).
- *
- * Input:
- *	ha = adapter state pointer.
- *	propname = property name pointer.
- *	propval  = pointer to location for the converted property val.
- *      db = pointer to database
- *
- * Returns:
- *	0 = value returned successfully.
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_get_prop_16chars(scsi_qla_host_t *ha,
-				char *propname, char *propval, char *db) 
-{
-	char		*propstr;
-	int		i, k;
-	int		rval;
-	uint8_t		nval;
-	uint8_t		*pchar;
-	uint8_t		*ret_byte;
-	uint8_t		*tmp_byte;
-	uint8_t		*retval = (uint8_t*)propval;
-	uint8_t		tmpval[8] = {0, 0, 0, 0, 0, 0, 0, 0};
-	uint16_t	max_byte_cnt = 8; /* 16 chars = 8 bytes */
-	uint16_t	max_strlen = 16;
-	static char	buf[LINESIZE];
-
-	rval = qla2x00_find_propname(ha, propname, buf, db, max_strlen);
-
-	propstr = &buf[0];
-	if (*propstr == '=')
-		propstr++;   /* ignore equal sign */
-
-	if (rval == 0) {
-		return (1);
-	}
-
-	/* Convert string to numbers. */
-	pchar = (uint8_t *)propstr;
-	tmp_byte = (uint8_t *)tmpval;
-
-	rval = 0;
-	for (i = 0; i < max_strlen; i++) {
-		/*
-		 * Check for invalid character, two at a time,
-		 * then convert them starting with first byte.
-		 */
-
-		if ((pchar[i] >= '0') && (pchar[i] <= '9')) {
-			nval = pchar[i] - '0';
-		} else if ((pchar[i] >= 'A') && (pchar[i] <= 'F')) {
-			nval = pchar[i] - 'A' + 10;
-		} else if ((pchar[i] >= 'a') && (pchar[i] <= 'f')) {
-			nval = pchar[i] - 'a' + 10;
-		} else {
-			/* invalid character */
-			rval = 1;
-			break;
-		}
-
-		if (i & BIT_0) {
-			*tmp_byte = *tmp_byte | nval;
-			tmp_byte++;
-		} else {
-			*tmp_byte = *tmp_byte | nval << 4;
-		}
-	}
-
-	if (rval != 0) {
-		/* Encountered invalid character. */
-		return (rval);
-	}
-
-	/* Copy over the converted value. */
-	ret_byte = retval;
-	tmp_byte = tmpval;
-
-	i = max_byte_cnt;
-	k = 0;
-	while (i--) {
-		*ret_byte++ = *tmp_byte++;
-	}
-
-	/* big endian retval[0]; */
-	return (0);
-}
-
-/*
-* qla2x00_get_properties
-*	Find all properties for the specified adapeter in
-*      command line.
-*
-* Input:
-*	ha = adapter block pointer.
-*	cmdline = pointer to command line string
-*
-* Context:
-*	Kernel context.
-*/
-static void
-qla2x00_get_properties(scsi_qla_host_t *ha, char *cmdline) 
-{
-	int	rval;
-	static char propbuf[LINESIZE];
-	uint8_t fc_name[8];
-
-	/* Adapter FC node names. */
-	sprintf(propbuf, "scsi-qla%d-adapter-node", (int) ha->instance);
-	rval = qla2x00_get_prop_16chars(ha, propbuf, fc_name, cmdline);
-	if (rval == QLA_SUCCESS)
-		memcpy(ha->init_cb->node_name, fc_name, WWN_SIZE);
-
-	/* DG 04/07 check portname of adapter */
-	sprintf(propbuf, "scsi-qla%d-adapter-port", (int)ha->instance);
-	rval = qla2x00_get_prop_16chars(ha, propbuf, fc_name, cmdline);
-	if (rval == QLA_SUCCESS &&
-	    memcmp(ha->init_cb->port_name, fc_name, WWN_SIZE)) {
-		/*
-		 * Adapter port name is WWN, and cannot be changed.
-		 * Inform users of the mismatch, then just continue driver
-		 * loading using the original adapter port name in NVRAM.
-		 */
-		qla_printk(KERN_WARNING, ha,
-		    "Found mismatch in adapter port names.\n");
-		qla_printk(KERN_INFO, ha,
-		    "       qla%ld port name found in NVRAM -> "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x\n",
-		    ha->instance,
-		    ha->init_cb->port_name[0],
-		    ha->init_cb->port_name[1],
-		    ha->init_cb->port_name[2],
-		    ha->init_cb->port_name[3],
-		    ha->init_cb->port_name[4],
-		    ha->init_cb->port_name[5],
-		    ha->init_cb->port_name[6],
-		    ha->init_cb->port_name[7]);
-		qla_printk(KERN_INFO, ha,
-		    "      qla%ld port name found on command line -> "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x\n",
-		    ha->instance,
-		    fc_name[0], fc_name[1], fc_name[2], fc_name[3],
-		    fc_name[4], fc_name[5], fc_name[6], fc_name[7]);
-		qla_printk(KERN_INFO, ha,
-		    "      Using port name from NVRAM.\n");
-	}
-
-	qla2x00_cfg_persistent_binding(ha);
-}
-
-/*
- * qla2x00_cfg_persistent_binding
- *	Get driver configuration file target persistent binding entries.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Context:
- *	Kernel context.
- */
-static void
-qla2x00_cfg_persistent_binding(scsi_qla_host_t *ha) 
-{
-	int		rval;
-	static char	propbuf[LINESIZE];
-	char		*cmdline = ha->cmdline;
-	uint16_t	tgt;
-	port_id_t	d_id;
-	uint8_t		portid[3];
-	uint8_t		port_name[8];
-
-	for (tgt = 0; tgt < MAX_TARGETS; tgt++) {
-		if (ha->binding_type == BIND_BY_PORT_ID) {
-			sprintf(propbuf, "scsi-qla%d-tgt-%d-di-0-pid",
-			    (int)ha->instance, tgt);
-			rval = qla2x00_get_prop_xstr(ha,
-			    propbuf, portid, sizeof(portid));
-			if (rval != sizeof(portid))
-				continue;
-			
-			memset(&d_id, 0, sizeof(port_id_t));
-			d_id.r.d_id[0] = portid[2];
-			d_id.r.d_id[1] = portid[1];
-			d_id.r.d_id[2] = portid[0];
-		} else {
-			sprintf(propbuf, "scsi-qla%d-tgt-%d-di-0-port",
-			    (int)ha->instance, tgt);
-			rval = qla2x00_get_prop_16chars(ha,
-			    propbuf, port_name, cmdline);
-			if (rval != QLA_SUCCESS)
-				continue;
-
-			/* Fallthru since port_name already populated */
-		}
-
-		/*
-		 * Create target context for device.
-		 */
-		if (ha->binding_type == BIND_BY_PORT_ID) {
-			qla2x00_persistent_bind(ha, NULL, NULL, &d_id, tgt);
-		} else {
-			qla2x00_persistent_bind(ha, NULL, port_name, NULL, tgt);
-		}
-	}
-}
-
-/*
- * qla2x00_persistent_bind
- *	Allocates target and fcport.
- *
- * Input:
- *	ha:		adapter state pointer.
- *	node_name:	node name pointer.
- *	port_name:	port name pointer.
- *	d_id:		port ID pointer.
- *	tgt:		OS target number.
- *
- * Returns:
- *	success = target queue pointer.
- *	failure = NULL.
- *
- * Context:
- *	Kernel context.
- */
-static os_tgt_t *
-qla2x00_persistent_bind(scsi_qla_host_t *ha, uint8_t *node_name,
-    uint8_t *port_name, port_id_t *d_id, uint16_t tgt)
-{
-	os_tgt_t	*tq;
-	uint16_t	tgt2;
-
-	/*
-	 * Check for duplicates.
-	 */
-	for (tgt2 = 0; tgt2 < MAX_TARGETS; tgt2++) {
-		if ((tq = TGT_Q(ha, tgt2)) == NULL) {
-			continue;
-		}
-
-		if (ha->binding_type == BIND_BY_PORT_ID) {
-			if (tq->d_id.b24 != d_id->b24) {
-				continue;
-			}
-		} else if (memcmp(tq->port_name, port_name, WWN_SIZE) != 0) {
-			continue;
-		}
-
-		qla_printk(KERN_WARNING, ha,
-		    "Duplicate persistent bindings found for "
-		    "WWPN: %02x%02x%02x%02x%02x%02x%02x%02x.\n", 
-		    port_name[0], port_name[1], port_name[2], port_name[3],
-		    port_name[4], port_name[5], port_name[6], port_name[7]);
-
-		return (tq);
-	}
-
-	tq = qla2x00_tgt_alloc(ha, tgt);
-	if (tq == NULL) {
-		return (NULL);
-	}
-
-	if (node_name != NULL) {
-		memcpy(tq->node_name, node_name, WWN_SIZE);
-	}
-	if (port_name != NULL) {
-		memcpy(tq->port_name, port_name, WWN_SIZE);
-	}
-	if (d_id != NULL) {
-		tq->d_id.b24 = d_id->b24;
-	}
-
-	return (tq);
-}
-#endif
 
 /*
 *  qla2x00_abort_isp
===== drivers/scsi/qla2xxx/qla_iocb.c 1.14 vs edited =====
--- 1.14/drivers/scsi/qla2xxx/qla_iocb.c	2004-10-09 14:33:48 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	2004-10-20 23:37:18 +02:00
@@ -27,6 +27,7 @@
 static inline uint16_t qla2x00_get_cmd_direction(struct scsi_cmnd *cmd);
 static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
 static inline cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *);
+static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -544,7 +545,7 @@
  *
  * Returns NULL if function failed, else, a pointer to the request packet.
  */
-request_t *
+static request_t *
 qla2x00_req_pkt(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
@@ -593,100 +594,6 @@
 		/* During init we issue marker directly */
 		if (!ha->marker_needed)
 			qla2x00_poll(ha);
-
-		spin_lock_irq(&ha->hardware_lock);
-	}
-	if (!pkt) {
-		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
-	}
-
-	return (pkt);
-}
-
-/**
- * qla2x00_ms_req_pkt() - Retrieve a Management Server request packet from
- * 				the request ring.
- * @ha: HA context
- * @sp: pointer to handle post function call
- *
- * Note: The caller must hold the hardware lock before calling this routine.
- *
- * Returns NULL if function failed, else, a pointer to the request packet.
- */
-request_t *
-qla2x00_ms_req_pkt(scsi_qla_host_t *ha, srb_t  *sp)
-{
-	device_reg_t __iomem *reg = ha->iobase;
-	request_t	*pkt = NULL;
-	uint16_t	cnt, i, index;
-	uint32_t	*dword_ptr;
-	uint32_t	timer;
-	uint8_t		found = 0;
-	uint16_t	req_cnt = 1;
-
-	/* Wait 1 second for slot. */
-	for (timer = HZ; timer; timer--) {
-		if ((req_cnt + 2) >= ha->req_q_cnt) {
-			/* Calculate number of free request entries. */
-			cnt = qla2x00_debounce_register(ISP_REQ_Q_OUT(ha, reg));
-			if (ha->req_ring_index < cnt) {
-				ha->req_q_cnt = cnt - ha->req_ring_index;
-			} else {
-				ha->req_q_cnt = ha->request_q_length -
-				    (ha->req_ring_index - cnt);
-			}
-		}
-
-		/* Check for room in outstanding command list. */
-		cnt = ha->current_outstanding_cmd;
-		for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
-			cnt++;
-			if (cnt == MAX_OUTSTANDING_COMMANDS)
-				cnt = 1;
-
-			if (ha->outstanding_cmds[cnt] == 0) {
-				found = 1;
-				ha->current_outstanding_cmd = cnt;
-				break;
-			}
-		}
-
-		/* If room for request in request ring. */
-		if (found && (req_cnt + 2) < ha->req_q_cnt) {
-			pkt = ha->request_ring_ptr;
-
-			/* Zero out packet. */
-			dword_ptr = (uint32_t *)pkt;
-			for (i = 0; i < REQUEST_ENTRY_SIZE / 4; i++ )
-				*dword_ptr++ = 0;
-
-			DEBUG5(printk("%s(): putting sp=%p in "
-			    "outstanding_cmds[%x]\n",
-			    __func__,
-			    sp, cnt));
-
-			ha->outstanding_cmds[cnt] = sp;
-
-			/* save the handle */
-			sp->cmd->host_scribble = (unsigned char *) (u_long) cnt;
-			CMD_SP(sp->cmd) = (void *)sp;
-
-			ha->req_q_cnt--;
-			pkt->handle = (uint32_t)cnt;
-
-			/* Set system defined field. */
-			pkt->sys_define = (uint8_t)ha->req_ring_index;
-			pkt->entry_status = 0;
-
-			break;
-		}
-
-		/* Release ring specific lock */
-		spin_unlock(&ha->hardware_lock);
-		udelay(20);
-
-		/* Check for pending interrupts. */
-		qla2x00_poll(ha);
 
 		spin_lock_irq(&ha->hardware_lock);
 	}
===== drivers/scsi/qla2xxx/qla_mbx.c 1.15 vs edited =====
--- 1.15/drivers/scsi/qla2xxx/qla_mbx.c	2004-10-09 14:33:48 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_mbx.c	2004-10-20 23:47:18 +02:00
@@ -53,7 +53,7 @@
  * Context:
  *	Kernel context.
  */
-int
+static int
 qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 {
 	int		rval;
@@ -676,135 +676,6 @@
 }
 
 /*
- * qla2x00_read_ram_word
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_read_ram_word(scsi_qla_host_t *ha, uint16_t addr, uint16_t *data)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("qla2x00_read_ram_word(%ld): entered.\n", ha->host_no);)
-
-	mcp->mb[0] = MBC_READ_RAM_WORD;
-	mcp->mb[1] = addr;
-	mcp->out_mb = MBX_1|MBX_0;
-	mcp->in_mb = MBX_0|MBX_2;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_read_ram_word(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
-	} else {
-		*data = mcp->mb[2];
-		DEBUG11(printk("qla2x00_read_ram_word(%ld): done.\n",
-		    ha->host_no);)
-	}
-
-	return rval;
-}
-
-/*
- * qla2x00_write_ram_word
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_write_ram_word(scsi_qla_host_t *ha, uint16_t addr, uint16_t data)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("qla2x00_write_ram_word(%ld): entered.\n",
-	    ha->host_no);)
-
-	mcp->mb[0] = MBC_WRITE_RAM_WORD;
-	mcp->mb[1] = addr;
-	mcp->mb[2] = data;
-	mcp->out_mb = MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_write_ram_word(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_write_ram_word(%ld): done.\n",
-		    ha->host_no);)
-	}
-
-	return rval;
-}
-
-/*
- * qla2x00_write_ram_word_ext
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_write_ram_word_ext(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_WRITE_RAM_WORD_EXTENDED;
-	mcp->mb[1] = LSW(addr);
-	mcp->mb[2] = data;
-	mcp->mb[8] = MSW(addr);
-	mcp->out_mb = MBX_8|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
-	}
-
-	return rval;
-}
-
-/*
  * qla2x00_mbx_reg_test
  *	Mailbox register wrap test.
  *
@@ -1032,62 +903,6 @@
 	return rval;
 }
 
-/*
- * qla2x00_abort_device
- *
- * Input:
- *	ha = adapter block pointer.
- *      loop_id  = FC loop ID
- *      lun  = SCSI LUN.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_abort_device(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("qla2x00_abort_device(%ld): entered.\n", ha->host_no);)
-
-	mcp->mb[0] = MBC_ABORT_DEVICE;
-	if (HAS_EXTENDED_IDS(ha))
-		mcp->mb[1] = loop_id;
-	else
-		mcp->mb[1] = loop_id << 8;
-	mcp->mb[2] = lun;
-	mcp->out_mb = MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	/* Issue marker command. */
-	qla2x00_marker(ha, loop_id, lun, MK_SYNC_ID_LUN);
-
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed Abort Device Mailbox command. Scheduling ISP "
-		    "abort.\n");
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active) 
-			up(ha->dpc_wait);
-		DEBUG2_3_11(printk("qla2x00_abort_device(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_abort_device(%ld): done.\n",
-		    ha->host_no);)
-	}
-
-	return rval;
-}
-
 #if USE_ABORT_TGT
 /*
  * qla2x00_abort_target
@@ -1599,101 +1414,6 @@
 }
 
 /*
- * qla2x00_get_link_status
- *
- * Input:
- *	ha = adapter block pointer.
- *	loop_id = device loop ID.
- *	ret_buf = pointer to link status return buffer.
- *
- * Returns:
- *	0 = success.
- *	BIT_0 = mem alloc error.
- *	BIT_1 = mailbox error.
- */
-uint8_t
-qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
-    link_stat_t *ret_buf, uint16_t *status)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-	link_stat_t *stat_buf;
-	dma_addr_t stat_buf_dma;
-
-	DEBUG11(printk("qla2x00_get_link_status(%ld): entered.\n",
-	    ha->host_no);)
-
-	stat_buf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &stat_buf_dma);
-	if (stat_buf == NULL) {
-		DEBUG2_3_11(printk("qla2x00_get_link_status(%ld): Failed to "
-		    "allocate memory.\n", ha->host_no));
-		return BIT_0;
-	}
-	memset(stat_buf, 0, sizeof(link_stat_t));
-
-	mcp->mb[0] = MBC_GET_LINK_STATUS;
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
-		mcp->mb[1] = loop_id;
-		mcp->mb[10] = 0;
-		mcp->out_mb |= MBX_10;
-	} else {
-		mcp->mb[1] = loop_id << 8;
-	}
-	mcp->mb[2] = MSW(stat_buf_dma);
-	mcp->mb[3] = LSW(stat_buf_dma);
-	mcp->mb[6] = MSW(MSD(stat_buf_dma));
-	mcp->mb[7] = LSW(MSD(stat_buf_dma));
-
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval == QLA_SUCCESS) {
-		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
-			DEBUG2_3_11(printk("qla2x00_get_link_status(%ld): cmd "
-			    "failed. mbx0=%x.\n", ha->host_no, mcp->mb[0]);)
-			status[0] = mcp->mb[0];
-			rval = BIT_1;
-		} else {
-			/* copy over data -- firmware data is LE. */
-			ret_buf->link_fail_cnt =
-			    le32_to_cpu(stat_buf->link_fail_cnt);
-			ret_buf->loss_sync_cnt =
-			    le32_to_cpu(stat_buf->loss_sync_cnt);
-			ret_buf->loss_sig_cnt =
-			    le32_to_cpu(stat_buf->loss_sig_cnt);
-			ret_buf->prim_seq_err_cnt =
-			    le32_to_cpu(stat_buf->prim_seq_err_cnt);
-			ret_buf->inval_xmit_word_cnt =
-			    le32_to_cpu(stat_buf->inval_xmit_word_cnt);
-			ret_buf->inval_crc_cnt =
-			    le32_to_cpu(stat_buf->inval_crc_cnt);
-
-			DEBUG11(printk("qla2x00_get_link_status(%ld): stat "
-			    "dump: fail_cnt=%d loss_sync=%d loss_sig=%d "
-			    "seq_err=%d inval_xmt_word=%d inval_crc=%d.\n",
-			    ha->host_no,
-			    stat_buf->link_fail_cnt, stat_buf->loss_sync_cnt,
-			    stat_buf->loss_sig_cnt, stat_buf->prim_seq_err_cnt,
-			    stat_buf->inval_xmit_word_cnt,
-			    stat_buf->inval_crc_cnt);)
-		}
-	} else {
-		/* Failed. */
-		DEBUG2_3_11(printk("qla2x00_get_link_status(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
-		rval = BIT_1;
-	}
-
-	dma_pool_free(ha->s_dma_pool, stat_buf, stat_buf_dma);
-
-	return rval;
-}
-
-/*
  * qla2x00_lip_reset
  *	Issue LIP reset mailbox command.
  *
@@ -2108,227 +1828,6 @@
 	}
 
 	return rval;
-}
-
-/*
- * qla2x00_lun_reset
- *	Issue lun reset mailbox command.
- *
- * Input:
- *	ha = adapter block pointer.
- *	loop_id = device loop ID.
- *      lun = lun to be reset.
- *	TARGET_QUEUE_LOCK must be released.
- *	ADAPTER_STATE_LOCK must be released.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_lun_reset(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun)
-{
-	int		rval;
-	mbx_cmd_t	mc;
-	mbx_cmd_t	*mcp = &mc;
-
-	mcp->mb[0] = MBC_LUN_RESET;
-	if (HAS_EXTENDED_IDS(ha))
-		mcp->mb[1] = loop_id;
-	else
-		mcp->mb[1] = loop_id << 8;
-	mcp->mb[2] = lun;
-	mcp->out_mb = MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		printk(KERN_WARNING "qla2x00_lun_reset(%d): failed = %d",
-		    (int)ha->instance, rval);
-	} else {
-		/*EMPTY*/
-	}
-
-	return rval;
-}
-
-/*
- * qla2x00_send_rnid_mbx
- *	Issue RNID ELS using mailbox command
- *
- * Input:
- *	ha = adapter state pointer.
- *	loop_id = loop ID of the target device.
- *	data_fmt = currently supports only 0xDF.
- *	buffer = buffer pointer.
- *	buf_size = size of buffer.
- *	mb_reg = pointer to return mailbox registers.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_send_rnid_mbx(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t data_fmt,
-    dma_addr_t buf_phys_addr, size_t buf_size, uint16_t *mb_reg)
-{
-	int		rval;
-	mbx_cmd_t	mc;
-	mbx_cmd_t	*mcp = &mc;
-
-	DEBUG11(printk("qla2x00_send_rnid_mbx(%ld): entered.\n",
-	    ha->host_no);)
-
-	mcp->mb[0] = MBC_SEND_RNID_ELS;
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
-		mcp->mb[1] = loop_id;
-		mcp->mb[10] = data_fmt;
-		mcp->out_mb |= MBX_10;
-	} else {
-		mcp->mb[1] = (loop_id << 8) | data_fmt;
-	}
-	mcp->mb[2] = MSW(buf_phys_addr);
-	mcp->mb[3] = LSW(buf_phys_addr);
-	mcp->mb[6] = MSW(MSD(buf_phys_addr));
-	mcp->mb[7] = LSW(MSD(buf_phys_addr));
-
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->buf_size = buf_size;
-	mcp->flags = MBX_DMA_IN;
-	mcp->tov = 30;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		memcpy(mb_reg, mcp->mb, 2 * 2); /* 2 status regs */
-
-		DEBUG2_3_11(printk("qla2x00_send_rnid_mbx(%ld): failed=%x "
-		    "mb[1]=%x.\n",
-		    ha->host_no, mcp->mb[0], mcp->mb[1]);)
-	} else {
-		/*EMPTY*/
-	 	DEBUG11(printk("qla2x00_send_rnid_mbx(%ld): done.\n",
-		     ha->host_no);)
-	}
-
-	return (rval);
-}
-
-/*
- * qla2x00_set_rnid_params_mbx
- *	Set RNID parameters using mailbox command
- *
- * Input:
- *	ha = adapter state pointer.
- *	buffer = buffer pointer.
- *	buf_size = size of buffer.
- *	mb_reg = pointer to return mailbox registers.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_set_rnid_params_mbx(scsi_qla_host_t *ha, dma_addr_t buf_phys_addr,
-    size_t buf_size, uint16_t *mb_reg)
-{
-	int		rval;
-	mbx_cmd_t	mc;
-	mbx_cmd_t	*mcp = &mc;
-
-	DEBUG11(printk("qla2x00_set_rnid_params_mbx(%ld): entered.\n",
-	    ha->host_no);)
-
-	mcp->mb[0] = MBC_SET_RNID_PARAMS;
-	mcp->mb[1] = 0;
-	mcp->mb[2] = MSW(buf_phys_addr);
-	mcp->mb[3] = LSW(buf_phys_addr);
-	mcp->mb[6] = MSW(MSD(buf_phys_addr));
-	mcp->mb[7] = LSW(MSD(buf_phys_addr));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->buf_size = buf_size;
-	mcp->flags = MBX_DMA_OUT;
-	mcp->tov = 30;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		memcpy(mb_reg, mcp->mb, 2 * 2); /* 2 status regs */
-
-		DEBUG2_3_11(printk("qla2x00_set_rnid_params_mbx(%ld): "
-		    "failed=%x mb[1]=%x.\n", ha->host_no, mcp->mb[0],
-		    mcp->mb[1]);)
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_set_rnid_params_mbx(%ld): done.\n",
-		    ha->host_no);)
-	}
-
-	return (rval);
-}
-
-/*
- * qla2x00_get_rnid_params_mbx
- *	Get RNID parameters using mailbox command
- *
- * Input:
- *	ha = adapter state pointer.
- *	buffer = buffer pointer.
- *	buf_size = size of buffer.
- *	mb_reg = pointer to return mailbox registers.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_get_rnid_params_mbx(scsi_qla_host_t *ha, dma_addr_t buf_phys_addr,
-    size_t buf_size, uint16_t *mb_reg)
-{
-	int		rval;
-	mbx_cmd_t	mc;
-	mbx_cmd_t	*mcp = &mc;
-
-	DEBUG11(printk("qla2x00_get_rnid_params_mbx(%ld): entered.\n",
-	    ha->host_no);)
-
-	mcp->mb[0] = MBC_GET_RNID_PARAMS;
-	mcp->mb[1] = 0;
-	mcp->mb[2] = MSW(buf_phys_addr);
-	mcp->mb[3] = LSW(buf_phys_addr);
-	mcp->mb[6] = MSW(MSD(buf_phys_addr));
-	mcp->mb[7] = LSW(MSD(buf_phys_addr));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->buf_size = buf_size;
-	mcp->flags = MBX_DMA_IN;
-	mcp->tov = 30;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		memcpy(mb_reg, mcp->mb, 2 * 2); /* 2 status regs */
-
-		DEBUG2_3_11(printk("qla2x00_get_rnid_params_mbx(%ld): "
-		    "failed=%x mb[1]=%x.\n", ha->host_no, mcp->mb[0],
-		    mcp->mb[1]);)
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_get_rnid_params_mbx(%ld): done.\n",
-		    ha->host_no);)
-	}
-
-	return (rval);
 }
 
 /*
===== drivers/scsi/qla2xxx/qla_os.c 1.49 vs edited =====
--- 1.49/drivers/scsi/qla2xxx/qla_os.c	2004-10-18 23:48:15 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-10-20 23:39:25 +02:00
@@ -151,6 +151,8 @@
  * SCSI host template entry points 
  */
 static int qla2xxx_slave_configure(struct scsi_device * device);
+static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
+		void (*fn)(struct scsi_cmnd *));
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
@@ -396,8 +398,9 @@
 
 static uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
 static void qla2x00_mem_free(scsi_qla_host_t *ha);
-int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
-void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
+static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
+static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
+static srb_t *qla2x00_get_new_sp(scsi_qla_host_t *ha);
 
 static ssize_t qla2x00_sysfs_read_fw_dump(struct kobject *, char *, loff_t,
     size_t);
@@ -428,13 +431,6 @@
 	.write = qla2x00_sysfs_write_nvram,
 };
 
-
-int
-qla2x00_set_info(char *buffer, int length, struct Scsi_Host *shost)
-{
-	return (-ENOSYS);  /* Currently this is a no-op */
-}
-
 /* -------------------------------------------------------------------------- */
 
 
@@ -583,7 +579,7 @@
 }
 
 /* -------------------------------------------------------------------------- */
-char *
+static char *
 qla2x00_get_pci_info_str(struct scsi_qla_host *ha, char *str)
 {
 	static char *pci_bus_modes[] = {
@@ -663,7 +659,7 @@
 * interrupt handler may call this routine as part of request-completion
 * handling).
 **************************************************************************/
-int
+static int
 qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 {
 	fc_port_t	*fcport;
@@ -956,7 +952,7 @@
  *    Success (Adapter is online) : 0
  *    Failed  (Adapter is offline/disabled) : 1
  */
-int 
+static int 
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
 	int 	 return_status;
@@ -1290,7 +1286,7 @@
 *
 * Note:
 **************************************************************************/
-int
+static int
 qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha, unsigned int t)
 {
 	int	cnt;
@@ -1502,7 +1498,7 @@
 *
 * Note:
 **************************************************************************/
-int
+static int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha)
 {
 	int	cnt;
@@ -2322,7 +2318,7 @@
 		    "%s: has data been written to the file. \n",
 		    __func__);)
 
-		return (qla2x00_set_info(buffer, length, shost));
+		return -ENOSYS;
 	}
 
 	if (start) {
@@ -2342,8 +2338,6 @@
 
 	copy_info(&info, "Driver version %s\n", qla2x00_version_str);
 
-	copy_info(&info, "Entry address = %p\n", qla2x00_set_info);
-
 	tmp_sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | 
 	    ha->serial1;
 	copy_info(&info, "ISP: %s, Serial# %c%05d\n",
@@ -3146,7 +3140,7 @@
  * 
  * Note: Sets the ref_count for non Null sp to one.
  */
-int
+static int
 qla2x00_allocate_sp_pool(scsi_qla_host_t *ha) 
 {
 	int      rval;
@@ -3165,7 +3159,7 @@
  *  This routine frees all adapter allocated memory.
  *  
  */
-void
+static void
 qla2x00_free_sp_pool( scsi_qla_host_t *ha) 
 {
 	if (ha->srb_mempool) {
@@ -3626,7 +3620,7 @@
  * output:
  *        srb_t * or NULL
  */
-srb_t *
+static srb_t *
 qla2x00_get_new_sp(scsi_qla_host_t *ha)
 {
 	srb_t *sp;
@@ -4327,105 +4321,6 @@
 	}
 }
 
-
-/**************************************************************************
-*   qla2x00_check_tgt_status
-*
-* Description:
-*     Checks to see if the target or loop is down.
-*
-* Input:
-*     cmd - pointer to Scsi cmd structure
-*
-* Returns:
-*   1 - if target is present
-*   0 - if target is not present
-*
-**************************************************************************/
-int
-qla2x00_check_tgt_status(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
-{
-	os_lun_t        *lq;
-	unsigned int	b, t, l;
-	fc_port_t	*fcport;
-
-	/* Generate LU queue on bus, target, LUN */
-	b = cmd->device->channel;
-	t = cmd->device->id;
-	l = cmd->device->lun;
-
-	if ((lq = GET_LU_Q(ha,t,l)) == NULL) {
-		return (QLA_FUNCTION_FAILED);
-	}
-
-	fcport = lq->fclun->fcport;
-
-	if (TGT_Q(ha, t) == NULL ||
-	    l >= ha->max_luns ||
-	    atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-	    atomic_read(&ha->loop_state) == LOOP_DEAD ||
-	    (!atomic_read(&ha->loop_down_timer) &&
-		atomic_read(&ha->loop_state) == LOOP_DOWN) ||
-	    test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) ||
-	    test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
-	    atomic_read(&ha->loop_state) != LOOP_READY) {
-
-		DEBUG(printk(KERN_INFO
-		    "scsi(%ld:%2d:%2d:%2d): %s connection is down\n",
-		    ha->host_no,
-		    b, t, l,
-		    __func__));
-
-		cmd->result = DID_NO_CONNECT << 16;
-		return (QLA_FUNCTION_FAILED);
-	}
-	return (QLA_SUCCESS);
-}
-
-/**************************************************************************
-*   qla2x00_check_port_status
-*
-* Description:
-*     Checks to see if the port or loop is down.
-*
-* Input:
-*     fcport - pointer to fc_port_t structure.
-*
-* Returns:
-*   1 - if port is present
-*   0 - if port is not present
-*
-**************************************************************************/
-int
-qla2x00_check_port_status(scsi_qla_host_t *ha, fc_port_t *fcport)
-{
-	if (fcport == NULL) {
-		return (QLA_FUNCTION_FAILED);
-	}
-
-	if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-	    atomic_read(&ha->loop_state) == LOOP_DEAD) {
-		return (QLA_FUNCTION_FAILED);
-	}
-
-	if ((atomic_read(&fcport->state) != FCS_ONLINE) || 
-	    (!atomic_read(&ha->loop_down_timer) &&
-		atomic_read(&ha->loop_state) == LOOP_DOWN) ||
-	    (test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)) ||
-	    test_bit(CFG_ACTIVE, &ha->cfg_flags) ||
-	    test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
-	    atomic_read(&ha->loop_state) != LOOP_READY) {
-
-		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): Connection is down. fcport=%p.\n",
-		    ha->host_no, fcport));
-
-		return (QLA_BUSY);
-	}
-
-	return (QLA_SUCCESS);
-}
-
 /* XXX(hch): crude hack to emulate a down_timeout() */
 int
 qla2x00_down_timeout(struct semaphore *sema, unsigned long timeout)
@@ -4530,9 +4425,7 @@
 	if (!qla2xxx_transport_template)
 		return -ENODEV;
 
-	printk(KERN_INFO
-	    "QLogic Fibre Channel HBA Driver (%p)\n", qla2x00_set_info);
-
+	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
 	return 0;
 }
 
===== drivers/scsi/qla2xxx/qla_rscn.c 1.9 vs edited =====
--- 1.9/drivers/scsi/qla2xxx/qla_rscn.c	2004-10-09 14:33:48 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_rscn.c	2004-10-20 23:37:43 +02:00
@@ -87,7 +87,7 @@
 /** 
  * Mailbox IOCB callback array.
  **/
-int (*iocb_function_cb_list[LAST_IOCB_CB])
+static int (*iocb_function_cb_list[LAST_IOCB_CB])
 	(scsi_qla_host_t *, struct io_descriptor *, struct mbx_entry *) = {
 
 	qla2x00_send_abort_iocb_cb,
