From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/qla2xxx/: possible cleanups
Date: Mon, 5 Nov 2007 18:07:34 +0100
Message-ID: <20071105170734.GR12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59526 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757670AbXKERH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 12:07:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
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
  - qla_dbg.c: qla2x00_dump_pkt()
  - qla_mbx.c: qla2x00_system_error()
  - qla_mbx.c: qla2x00_get_serdes_params()
  - qla_mbx.c: qla2x00_get_idma_speed()
  - qla_mbx.c: qla24xx_get_vp_database()
  - qla_mbx.c: qla24xx_get_vp_entry()
- qla_os.c: remove some unneeded function prototypes

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qla2xxx/qla_attr.c |    6 +++---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |   25 -------------------------
 drivers/scsi/qla2xxx/qla_mbx.c  |   10 ++++++++++
 drivers/scsi/qla2xxx/qla_mid.c  |    6 +++---
 drivers/scsi/qla2xxx/qla_os.c   |   20 ++++++--------------
 drivers/scsi/qla2xxx/qla_sup.c  |    8 ++++----
 7 files changed, 28 insertions(+), 49 deletions(-)

2aa8a08454693ac86647fef919177da8fb5c5596 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fb388b8..cf822b6 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -9,7 +9,7 @@
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
 
-int qla24xx_vport_disable(struct fc_vport *, bool);
+static int qla24xx_vport_disable(struct fc_vport *, bool);
 
 /* SYSFS attributes --------------------------------------------------------- */
 
@@ -1113,7 +1113,7 @@ vport_create_failed_2:
 	return FC_VPORT_FAILED;
 }
 
-int
+static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
@@ -1146,7 +1146,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	return 0;
 }
 
-int
+static int
 qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index eaa04da..72e6202 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1428,6 +1428,7 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd)
 	printk("  sp flags=0x%x\n", sp->flags);
 }
 
+#if 0
 void
 qla2x00_dump_pkt(void *pkt)
 {
@@ -1442,6 +1443,7 @@ qla2x00_dump_pkt(void *pkt)
 	}
 	printk("\n");
 }
+#endif  /*  0  */
 
 #if defined(QL_DEBUG_ROUTINES)
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 09cb2a9..8a5d258 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -68,30 +68,20 @@ extern int num_hosts;
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
@@ -231,12 +220,6 @@ qla24xx_get_isp_stats(scsi_qla_host_t *, uint32_t *, uint32_t, uint16_t *);
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
 
@@ -250,9 +233,6 @@ extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
 
 extern int
-qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t *, uint16_t *);
-
-extern int
 qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
 
 /*
@@ -270,11 +250,7 @@ extern void qla2x00_free_irqs(scsi_qla_host_t *);
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
@@ -321,7 +297,6 @@ extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
-extern void qla2x00_dump_pkt(void *);
 
 /*
  * Global Function Prototypes in qla_gs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ccd662a..7458072 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2331,6 +2331,8 @@ atarget_done:
 	return rval;
 }
 
+#if 0
+
 int
 qla2x00_system_error(scsi_qla_host_t *ha)
 {
@@ -2402,6 +2404,8 @@ qla2x00_get_serdes_params(scsi_qla_host_t *ha, uint16_t *sw_em_1g,
 	return rval;
 }
 
+#endif  /*  0  */
+
 /**
  * qla2x00_set_serdes_params() -
  * @ha: HA context
@@ -2548,6 +2552,7 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 	return rval;
 }
 
+#if 0
 int
 qla2x00_get_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
     uint16_t *port_speed, uint16_t *mb)
@@ -2590,6 +2595,7 @@ qla2x00_get_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 
 	return rval;
 }
+#endif  /*  0  */
 
 int
 qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
@@ -2634,6 +2640,8 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	return rval;
 }
 
+#if 0
+
 /*
  * qla24xx_get_vp_database
  *	Get the VP's database for all configured ports.
@@ -2724,6 +2732,8 @@ qla24xx_get_vp_entry(scsi_qla_host_t *ha, uint16_t size, int vp_id)
 	return rval;
 }
 
+#endif  /*  0  */
+
 void
 qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 	struct vp_rpt_id_entry_24xx *rptid_entry)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 821ee74..3cf1495 100644
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
@@ -78,7 +78,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	up(&ha->vport_sem);
 }
 
-scsi_qla_host_t *
+static scsi_qla_host_t *
 qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
@@ -270,7 +270,7 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 	qla24xx_enable_vp(vha);
 }
 
-int
+static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a5bcf1f..217b383 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -111,7 +111,7 @@ static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 
-struct scsi_host_template qla2x00_driver_template = {
+static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla2x00_queuecommand,
@@ -179,13 +179,6 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
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
@@ -203,7 +196,7 @@ qla2x00_restart_timer(scsi_qla_host_t *ha, unsigned long interval)
 	mod_timer(&ha->timer, jiffies + interval * HZ);
 }
 
-__inline__ void
+static __inline__ void
 qla2x00_stop_timer(scsi_qla_host_t *ha)
 {
 	del_timer_sync(&ha->timer);
@@ -214,12 +207,11 @@ static int qla2x00_do_dpc(void *data);
 
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
 
@@ -2016,7 +2008,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 *      0  = success.
 *      1  = failure.
 */
-uint8_t
+static uint8_t
 qla2x00_mem_alloc(scsi_qla_host_t *ha)
 {
 	char	name[16];
@@ -2213,7 +2205,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 * Input:
 *      ha = adapter block pointer.
 */
-void
+static void
 qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ad2fa01..3865356 100644
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

