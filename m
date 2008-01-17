From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Code cleanups.
Date: Thu, 17 Jan 2008 09:02:15 -0800
Message-ID: <1200589340-19499-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYAQRCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:35 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Adrian Bunk <bunk@kernel.org>

From: Adrian Bunk <bunk@kernel.org>

- make the following needlessly global code static:
  - qla_attr.c: qla24xx_vport_delete()
  - qla_attr.c: qla24xx_vport_disable()
  - qla_mid.c: qla24xx_allocate_vp_id()
  - qla_mid.c: qla24xx_find_vhost_by_name()
  - qla_mid.c: qla2x00_do_dpc_vp()
  - qla_os.c: struct qla2x00_driver_template
  - qla_os.c: qla2x00_stop_timer()
  - qla_os.c: qla2x00_mem_alloc()
  - qla_os.c: qla2x00_mem_free()
  - qla_sup.c: qla2x00_lock_nvram_access()
  - qla_sup.c: qla2x00_unlock_nvram_access()
  - qla_sup.c: qla2x00_get_nvram_word()
  - qla_sup.c: qla2x00_write_nvram_word()
- #if 0 the following unused global functions:
  - qla_mbx.c: qla2x00_system_error()
- qla_os.c: remove some unneeded function prototypes
- removed unused functions:
  - qla_dbg.c: qla2x00_dump_pkt()
  - qla_mbx.c: qla2x00_get_serdes_params()
  - qla_mbx.c: qla2x00_get_idma_speed()
  - qla_mbx.c: qla24xx_get_vp_database()
  - qla_mbx.c: qla24xx_get_vp_entry()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Small modifications and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |   15 ----
 drivers/scsi/qla2xxx/qla_gbl.h  |   25 ------
 drivers/scsi/qla2xxx/qla_mbx.c  |  177 +--------------------------------------
 drivers/scsi/qla2xxx/qla_mid.c  |    6 +-
 drivers/scsi/qla2xxx/qla_os.c   |   20 ++---
 drivers/scsi/qla2xxx/qla_sup.c  |    8 +-
 7 files changed, 19 insertions(+), 238 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 22b3868..adf9732 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -9,7 +9,7 @@
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
 
-int qla24xx_vport_disable(struct fc_vport *, bool);
+static int qla24xx_vport_disable(struct fc_vport *, bool);
 
 /* SYSFS attributes --------------------------------------------------------- */
 
@@ -1129,7 +1129,7 @@ vport_create_failed_2:
 	return FC_VPORT_FAILED;
 }
 
-int
+static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
@@ -1162,7 +1162,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	return 0;
 }
 
-int
+static int
 qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index eaa04da..796c4ce 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1428,21 +1428,6 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd)
 	printk("  sp flags=0x%x\n", sp->flags);
 }
 
-void
-qla2x00_dump_pkt(void *pkt)
-{
-	uint32_t i;
-	uint8_t *data = (uint8_t *) pkt;
-
-	for (i = 0; i < 64; i++) {
-		if (!(i % 4))
-			printk("\n%02x: ", i);
-
-		printk("%02x ", data[i]);
-	}
-	printk("\n");
-}
-
 #if defined(QL_DEBUG_ROUTINES)
 /*
  * qla2x00_formatted_dump_buffer
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fa4455f..fd75539 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -70,30 +70,20 @@ extern int qla2x00_loop_reset(scsi_qla_host_t *);
 /*
  * Global Functions in qla_mid.c source file.
  */
-extern struct scsi_host_template qla2x00_driver_template;
 extern struct scsi_host_template qla24xx_driver_template;
 extern struct scsi_transport_template *qla2xxx_transport_vport_template;
-extern uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
 extern void qla2x00_timer(scsi_qla_host_t *);
 extern void qla2x00_start_timer(scsi_qla_host_t *, void *, unsigned long);
-extern void qla2x00_stop_timer(scsi_qla_host_t *);
-extern uint32_t qla24xx_allocate_vp_id(scsi_qla_host_t *);
 extern void qla24xx_deallocate_vp_id(scsi_qla_host_t *);
 extern int qla24xx_disable_vp (scsi_qla_host_t *);
 extern int qla24xx_enable_vp (scsi_qla_host_t *);
-extern void qla2x00_mem_free(scsi_qla_host_t *);
 extern int qla24xx_control_vp(scsi_qla_host_t *, int );
 extern int qla24xx_modify_vp_config(scsi_qla_host_t *);
 extern int qla2x00_send_change_request(scsi_qla_host_t *, uint16_t, uint16_t);
 extern void qla2x00_vp_stop_timer(scsi_qla_host_t *);
 extern int qla24xx_configure_vhba (scsi_qla_host_t *);
-extern int qla24xx_get_vp_entry(scsi_qla_host_t *, uint16_t, int);
-extern int qla24xx_get_vp_database(scsi_qla_host_t *, uint16_t);
-extern int qla2x00_do_dpc_vp(scsi_qla_host_t *);
 extern void qla24xx_report_id_acquisition(scsi_qla_host_t *,
     struct vp_rpt_id_entry_24xx *);
-extern scsi_qla_host_t * qla24xx_find_vhost_by_name(scsi_qla_host_t *,
-    uint8_t *);
 extern void qla2x00_do_dpc_all_vps(scsi_qla_host_t *);
 extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t * qla24xx_create_vhost(struct fc_vport *);
@@ -113,7 +103,6 @@ extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
 extern void qla2x00_alert_all_vps(scsi_qla_host_t *, uint16_t *);
 extern void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
 extern void qla2x00_vp_abort_isp(scsi_qla_host_t *);
-extern int qla24xx_vport_delete(struct fc_vport *);
 
 /*
  * Global Function Prototypes in qla_iocb.c source file.
@@ -232,12 +221,6 @@ qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
 extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *);
 extern int qla24xx_abort_target(fc_port_t *);
 
-extern int qla2x00_system_error(scsi_qla_host_t *);
-
-extern int
-qla2x00_get_serdes_params(scsi_qla_host_t *, uint16_t *, uint16_t *,
-    uint16_t *);
-
 extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
@@ -251,9 +234,6 @@ extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
 
 extern int
-qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t *, uint16_t *);
-
-extern int
 qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
 
 /*
@@ -271,11 +251,7 @@ extern void qla2x00_free_irqs(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_sup.c source file.
  */
-extern void qla2x00_lock_nvram_access(scsi_qla_host_t *);
-extern void qla2x00_unlock_nvram_access(scsi_qla_host_t *);
 extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
-extern uint16_t qla2x00_get_nvram_word(scsi_qla_host_t *, uint32_t);
-extern void qla2x00_write_nvram_word(scsi_qla_host_t *, uint32_t, uint16_t);
 extern uint32_t *qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
     uint32_t, uint32_t);
 extern uint8_t *qla2x00_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
@@ -322,7 +298,6 @@ extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
-extern void qla2x00_dump_pkt(void *);
 
 /*
  * Global Function Prototypes in qla_gs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d23d6fc..ee7899d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2248,6 +2248,8 @@ atarget_done:
 	return rval;
 }
 
+#if 0
+
 int
 qla2x00_system_error(scsi_qla_host_t *ha)
 {
@@ -2277,47 +2279,7 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	return rval;
 }
 
-/**
- * qla2x00_get_serdes_params() -
- * @ha: HA context
- *
- * Returns
- */
-int
-qla2x00_get_serdes_params(scsi_qla_host_t *ha, uint16_t *sw_em_1g,
-    uint16_t *sw_em_2g, uint16_t *sw_em_4g)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_SERDES_PARAMS;
-	mcp->mb[1] = 0;
-	mcp->out_mb = MBX_1|MBX_0;
-	mcp->in_mb = MBX_4|MBX_3|MBX_2|MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
-	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
-
-		if (sw_em_1g)
-			*sw_em_1g = mcp->mb[2];
-		if (sw_em_2g)
-			*sw_em_2g = mcp->mb[3];
-		if (sw_em_4g)
-			*sw_em_4g = mcp->mb[4];
-	}
-
-	return rval;
-}
+#endif  /*  0  */
 
 /**
  * qla2x00_set_serdes_params() -
@@ -2466,49 +2428,6 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 }
 
 int
-qla2x00_get_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
-    uint16_t *port_speed, uint16_t *mb)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	if (!IS_IIDMA_CAPABLE(ha))
-		return QLA_FUNCTION_FAILED;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_PORT_PARAMS;
-	mcp->mb[1] = loop_id;
-	mcp->mb[2] = mcp->mb[3] = mcp->mb[4] = mcp->mb[5] = 0;
-	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	/* Return mailbox statuses. */
-	if (mb != NULL) {
-		mb[0] = mcp->mb[0];
-		mb[1] = mcp->mb[1];
-		mb[3] = mcp->mb[3];
-		mb[4] = mcp->mb[4];
-		mb[5] = mcp->mb[5];
-	}
-
-	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
-	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
-		if (port_speed)
-			*port_speed = mcp->mb[3];
-	}
-
-	return rval;
-}
-
-int
 qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
     uint16_t port_speed, uint16_t *mb)
 {
@@ -2551,96 +2470,6 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	return rval;
 }
 
-/*
- * qla24xx_get_vp_database
- *	Get the VP's database for all configured ports.
- *
- * Input:
- *	ha = adapter block pointer.
- *	size = size of initialization control block.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla24xx_get_vp_database(scsi_qla_host_t *ha, uint16_t size)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("scsi(%ld):%s - entered.\n",
-	    ha->host_no, __func__));
-
-	mcp->mb[0] = MBC_MID_GET_VP_DATABASE;
-	mcp->mb[2] = MSW(ha->init_cb_dma);
-	mcp->mb[3] = LSW(ha->init_cb_dma);
-	mcp->mb[4] = 0;
-	mcp->mb[5] = 0;
-	mcp->mb[6] = MSW(MSD(ha->init_cb_dma));
-	mcp->mb[7] = LSW(MSD(ha->init_cb_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->buf_size = size;
-	mcp->flags = MBX_DMA_OUT;
-	mcp->tov = MBX_TOV_SECONDS;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x "
-		    "mb0=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0]));
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n",
-		    __func__, ha->host_no));
-	}
-
-	return rval;
-}
-
-int
-qla24xx_get_vp_entry(scsi_qla_host_t *ha, uint16_t size, int vp_id)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_MID_GET_VP_ENTRY;
-	mcp->mb[2] = MSW(ha->init_cb_dma);
-	mcp->mb[3] = LSW(ha->init_cb_dma);
-	mcp->mb[4] = 0;
-	mcp->mb[5] = 0;
-	mcp->mb[6] = MSW(MSD(ha->init_cb_dma));
-	mcp->mb[7] = LSW(MSD(ha->init_cb_dma));
-	mcp->mb[9] = vp_id;
-	mcp->out_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->buf_size = size;
-	mcp->flags = MBX_DMA_OUT;
-	mcp->tov = 30;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla24xx_get_vp_entry(%ld): failed=%x "
-		    "mb0=%x.\n",
-		    ha->host_no, rval, mcp->mb[0]));
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla24xx_get_vp_entry(%ld): done.\n",
-		    ha->host_no));
-	}
-
-	return rval;
-}
-
 void
 qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 	struct vp_rpt_id_entry_24xx *rptid_entry)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index dea3768..cf784cd 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -39,7 +39,7 @@ qla2x00_vp_stop_timer(scsi_qla_host_t *vha)
 	}
 }
 
-uint32_t
+static uint32_t
 qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint32_t vp_id;
@@ -77,7 +77,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	up(&ha->vport_sem);
 }
 
-scsi_qla_host_t *
+static scsi_qla_host_t *
 qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
@@ -265,7 +265,7 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 	qla24xx_enable_vp(vha);
 }
 
-int
+static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 19d0f95..2dd4371 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -110,7 +110,7 @@ static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 
-struct scsi_host_template qla2x00_driver_template = {
+static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla2x00_queuecommand,
@@ -178,13 +178,6 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
  * Timer routines
  */
 
-void qla2x00_timer(scsi_qla_host_t *);
-
-__inline__ void qla2x00_start_timer(scsi_qla_host_t *,
-    void *, unsigned long);
-static __inline__ void qla2x00_restart_timer(scsi_qla_host_t *, unsigned long);
-__inline__ void qla2x00_stop_timer(scsi_qla_host_t *);
-
 __inline__ void
 qla2x00_start_timer(scsi_qla_host_t *ha, void *func, unsigned long interval)
 {
@@ -202,7 +195,7 @@ qla2x00_restart_timer(scsi_qla_host_t *ha, unsigned long interval)
 	mod_timer(&ha->timer, jiffies + interval * HZ);
 }
 
-__inline__ void
+static __inline__ void
 qla2x00_stop_timer(scsi_qla_host_t *ha)
 {
 	del_timer_sync(&ha->timer);
@@ -213,12 +206,11 @@ static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
-void qla2x00_mem_free(scsi_qla_host_t *ha);
+static uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
+static void qla2x00_mem_free(scsi_qla_host_t *ha);
 static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
 static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
 static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
-void qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *);
 
 /* -------------------------------------------------------------------------- */
 
@@ -2008,7 +2000,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 *      0  = success.
 *      1  = failure.
 */
-uint8_t
+static uint8_t
 qla2x00_mem_alloc(scsi_qla_host_t *ha)
 {
 	char	name[16];
@@ -2205,7 +2197,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 * Input:
 *      ha = adapter block pointer.
 */
-void
+static void
 qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index af16c55..b68fb73 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -22,7 +22,7 @@ static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
  * qla2x00_lock_nvram_access() -
  * @ha: HA context
  */
-void
+static void
 qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
 {
 	uint16_t data;
@@ -55,7 +55,7 @@ qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
  * qla2x00_unlock_nvram_access() -
  * @ha: HA context
  */
-void
+static void
 qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -74,7 +74,7 @@ qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
  *
  * Returns the word read from nvram @addr.
  */
-uint16_t
+static uint16_t
 qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
 {
 	uint16_t	data;
@@ -93,7 +93,7 @@ qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
  * @addr: Address in NVRAM to write
  * @data: word to program
  */
-void
+static void
 qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
 {
 	int count;
-- 
1.5.4.rc3.14.g44397

