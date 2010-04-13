From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/1] qla2xxx: Add ISP82XX support.
Date: Mon, 12 Apr 2010 17:59:55 -0700
Message-ID: <1271120395-4510-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1271120395-4510-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39239 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754407Ab0DMBAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2010 21:00:00 -0400
In-Reply-To: <1271120395-4510-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Enhanced the driver to support new FCoE host bus adapter.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/Makefile     |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c   |   35 +-
 drivers/scsi/qla2xxx/qla_dbg.c    |    3 +
 drivers/scsi/qla2xxx/qla_def.h    |   54 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |   85 +
 drivers/scsi/qla2xxx/qla_gs.c     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c   |  233 +++-
 drivers/scsi/qla2xxx/qla_inline.h |    5 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |   74 +-
 drivers/scsi/qla2xxx/qla_isr.c    |   42 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |  158 ++-
 drivers/scsi/qla2xxx/qla_nx.c     | 3635 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.h     |  888 +++++++++
 drivers/scsi/qla2xxx/qla_os.c     |  346 ++++-
 drivers/scsi/qla2xxx/qla_sup.c    |   80 +-
 15 files changed, 5518 insertions(+), 125 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.h

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 1014db6..5df782f 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,5 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o
+		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
+        qla_nx.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0710e3c..c272af4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -41,6 +41,12 @@ qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	int reading;
 
+	if (IS_QLA82XX(ha)) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+			"Firmware dump not supported for ISP82xx\n"));
+		return count;
+	}
+
 	if (off != 0)
 		return (0);
 
@@ -313,8 +319,8 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		else if (start == (ha->flt_region_boot * 4) ||
 		    start == (ha->flt_region_fw * 4))
 			valid = 1;
-		else if (IS_QLA25XX(ha) || IS_QLA81XX(ha))
-		    valid = 1;
+		else if (IS_QLA25XX(ha) || IS_QLA8XXX_TYPE(ha))
+			valid = 1;
 		if (!valid) {
 			qla_printk(KERN_WARNING, ha,
 			    "Invalid start region 0x%x/0x%x.\n", start, size);
@@ -517,6 +523,7 @@ qla2x00_sysfs_write_reset(struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	int type;
 
 	if (off != 0)
@@ -551,6 +558,20 @@ qla2x00_sysfs_write_reset(struct kobject *kobj,
 			    "MPI reset failed on (%ld).\n", vha->host_no);
 		scsi_unblock_requests(vha->host);
 		break;
+	case 0x2025e:
+		if (!IS_QLA82XX(ha) || vha != base_vha) {
+			qla_printk(KERN_INFO, ha,
+			    "FCoE ctx reset not supported for host%ld.\n",
+			    vha->host_no);
+			return count;
+		}
+
+		qla_printk(KERN_INFO, ha,
+		    "Issuing FCoE CTX reset on host%ld.\n", vha->host_no);
+		set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		qla2x00_wait_for_fcoe_ctx_reset(vha);
+		break;
 	}
 	return count;
 }
@@ -836,7 +857,7 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 			continue;
 		if (iter->is4GBp_only == 2 && !IS_QLA25XX(vha->hw))
 			continue;
-		if (iter->is4GBp_only == 3 && !IS_QLA81XX(vha->hw))
+		if (iter->is4GBp_only == 3 && !(IS_QLA8XXX_TYPE(vha->hw)))
 			continue;
 
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
@@ -860,7 +881,7 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha)
 			continue;
 		if (iter->is4GBp_only == 2 && !IS_QLA25XX(ha))
 			continue;
-		if (iter->is4GBp_only == 3 && !IS_QLA81XX(ha))
+		if (iter->is4GBp_only == 3 && !!(IS_QLA8XXX_TYPE(vha->hw)))
 			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
@@ -1233,7 +1254,7 @@ qla2x00_vlan_id_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	if (!IS_QLA81XX(vha->hw))
+	if (!IS_QLA8XXX_TYPE(vha->hw))
 		return snprintf(buf, PAGE_SIZE, "\n");
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", vha->fcoe_vlan_id);
@@ -1245,7 +1266,7 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	if (!IS_QLA81XX(vha->hw))
+	if (!IS_QLA8XXX_TYPE(vha->hw))
 		return snprintf(buf, PAGE_SIZE, "\n");
 
 	return snprintf(buf, PAGE_SIZE, "%02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -1922,7 +1943,7 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	if (IS_QLA81XX(ha))
+	if (IS_QLA8XXX_TYPE(ha))
 		speed = FC_PORTSPEED_10GBIT;
 	else if (IS_QLA25XX(ha))
 		speed = FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT |
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cb2eca4..89bfc11 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -769,6 +769,9 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	void		*nxt;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
+	if (IS_QLA82XX(ha))
+		return;
+
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c51bd4e..edb7a70 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -34,6 +34,7 @@
 #include <scsi/scsi_bsg_fc.h>
 
 #include "qla_bsg.h"
+#include "qla_nx.h"
 #define QLA2XXX_DRIVER_NAME  "qla2xxx"
 
 /*
@@ -207,6 +208,7 @@ typedef struct srb {
  * SRB flag definitions
  */
 #define SRB_DMA_VALID		BIT_0	/* Command sent to ISP */
+#define SRB_FCP_CMND_DMA_VALID	BIT_12  /* FCP command in IOCB */
 
 /*
  * SRB extensions.
@@ -417,6 +419,7 @@ typedef union {
 		struct device_reg_2xxx isp;
 		struct device_reg_24xx isp24;
 		struct device_reg_25xxmq isp25mq;
+		struct device_reg_82xx isp82;
 } device_reg_t;
 
 #define ISP_REQ_Q_IN(ha, reg) \
@@ -2112,6 +2115,7 @@ struct isp_operations {
 
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
 	int (*start_scsi) (srb_t *);
+	int (*abort_isp) (struct scsi_qla_host *);
 };
 
 /* MSI-X Support *************************************************************/
@@ -2386,7 +2390,8 @@ struct qla_hw_data {
 #define DT_ISP2532                      BIT_11
 #define DT_ISP8432                      BIT_12
 #define DT_ISP8001			BIT_13
-#define DT_ISP_LAST			(DT_ISP8001 << 1)
+#define DT_ISP8021			BIT_14
+#define DT_ISP_LAST			(DT_ISP8021 << 1)
 
 #define DT_IIDMA                        BIT_26
 #define DT_FWI2                         BIT_27
@@ -2409,6 +2414,7 @@ struct qla_hw_data {
 #define IS_QLA2532(ha)  (DT_MASK(ha) & DT_ISP2532)
 #define IS_QLA8432(ha)  (DT_MASK(ha) & DT_ISP8432)
 #define IS_QLA8001(ha)	(DT_MASK(ha) & DT_ISP8001)
+#define IS_QLA82XX(ha)	(DT_MASK(ha) & DT_ISP8021)
 
 #define IS_QLA23XX(ha)  (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
 			IS_QLA6312(ha) || IS_QLA6322(ha))
@@ -2419,8 +2425,10 @@ struct qla_hw_data {
 #define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
 				IS_QLA84XX(ha))
 #define IS_QLA81XX(ha)		(IS_QLA8001(ha))
+#define IS_QLA8XXX_TYPE(ha)	(IS_QLA81XX(ha) || IS_QLA82XX(ha))
 #define IS_QLA2XXX_MIDTYPE(ha)	(IS_QLA24XX(ha) || IS_QLA84XX(ha) || \
-				IS_QLA25XX(ha) || IS_QLA81XX(ha))
+				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
+				IS_QLA82XX(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha))
 #define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && \
 				(ha)->flags.msix_enabled)
@@ -2603,6 +2611,7 @@ struct qla_hw_data {
 	uint32_t        flt_region_npiv_conf;
 	uint32_t	flt_region_gold_fw;
 	uint32_t	flt_region_fcp_prio;
+	uint32_t	flt_region_bootload;
 
 	/* Needed for BEACON */
 	uint16_t        beacon_blink_led;
@@ -2634,6 +2643,38 @@ struct qla_hw_data {
 
 	/* FCP_CMND priority support */
 	struct qla_fcp_prio_cfg *fcp_prio_cfg;
+
+	struct dma_pool *dl_dma_pool;
+#define DSD_LIST_DMA_POOL_SIZE  512
+
+	struct dma_pool *fcp_cmnd_dma_pool;
+	mempool_t       *ctx_mempool;
+#define FCP_CMND_DMA_POOL_SIZE 512
+
+	unsigned long	nx_pcibase;		/* Base I/O address */
+	uint8_t		*nxdb_rd_ptr;		/* Doorbell read pointer */
+	unsigned long	nxdb_wr_ptr;		/* Door bell write pointer */
+	unsigned long	first_page_group_start;
+	unsigned long	first_page_group_end;
+
+	uint32_t	crb_win;
+	uint32_t	curr_window;
+	uint32_t	ddr_mn_window;
+	unsigned long	mn_win_crb;
+	unsigned long	ms_win_crb;
+	int		qdr_sn_window;
+	uint32_t	nx_dev_init_timeout;
+	uint32_t	nx_reset_timeout;
+	rwlock_t	hw_lock;
+	uint16_t	portnum;		/* port number */
+	int		link_width;
+	struct fw_blob	*hablob;
+	struct qla82xx_legacy_intr_set nx_legacy_intr;
+
+	uint16_t	gbl_dsd_inuse;
+	uint16_t	gbl_dsd_avail;
+	struct list_head gbl_dsd_list;
+#define NUM_DSD_CHAIN 4096
 };
 
 /*
@@ -2686,10 +2727,13 @@ typedef struct scsi_qla_host {
 #define VP_DPC_NEEDED		14	/* wake up for VP dpc handling */
 #define UNLOADING		15
 #define NPIV_CONFIG_NEEDED	16
+#define ISP_UNRECOVERABLE	17
+#define FCOE_CTX_RESET_NEEDED	18	/* Initiate FCoE context reset */
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
 #define DFLG_NO_CABLE		BIT_1
+#define DFLG_DEV_FAILED		BIT_5
 
 	/* ISP configuration data. */
 	uint16_t	loop_id;		/* Host adapter loop id */
@@ -2747,6 +2791,8 @@ typedef struct scsi_qla_host {
 #define VP_ERR_ADAP_NORESOURCES	5
 	struct qla_hw_data *hw;
 	struct req_que *req;
+	int		fw_heartbeat_counter;
+	int		seconds_since_last_heartbeat;
 } scsi_qla_host_t;
 
 /*
@@ -2799,6 +2845,10 @@ typedef struct scsi_qla_host {
 #define OPTROM_SIZE_24XX	0x100000
 #define OPTROM_SIZE_25XX	0x200000
 #define OPTROM_SIZE_81XX	0x400000
+#define OPTROM_SIZE_82XX	0x800000
+
+#define OPTROM_BURST_SIZE	0x1000
+#define OPTROM_BURST_DWORDS	(OPTROM_BURST_SIZE / 4)
 
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5efd4c0..cff5a4a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -44,6 +44,7 @@ extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 extern void qla2x00_update_fcports(scsi_qla_host_t *);
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
+extern void qla2x00_abort_isp_cleanup(scsi_qla_host_t *);
 
 extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 
@@ -79,6 +80,9 @@ extern int ql2xmaxqueues;
 extern int ql2xmultique_tag;
 extern int ql2xfwloadbin;
 extern int ql2xetsenable;
+extern int ql2xshiftctondsd;
+extern int ql2xdbwr;
+extern int ql2xdontresethba;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -135,6 +139,7 @@ extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
 extern int qla2x00_wait_for_chip_reset(scsi_qla_host_t *);
+extern int qla2x00_wait_for_fcoe_ctx_reset(scsi_qla_host_t *);
 
 extern void qla2xxx_wake_dpc(struct scsi_qla_host *);
 extern void qla2x00_alert_all_vps(struct rsp_que *, uint16_t *);
@@ -157,6 +162,9 @@ int __qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 						uint16_t, uint16_t, uint8_t);
 extern int qla2x00_start_sp(srb_t *);
 extern void qla2x00_ctx_sp_free(srb_t *);
+extern uint16_t qla24xx_calc_iocbs(uint16_t);
+extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *, uint16_t);
+
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -343,6 +351,7 @@ qla24xx_process_response_queue(struct scsi_qla_host *, struct rsp_que *);
 extern int qla2x00_request_irqs(struct qla_hw_data *, struct rsp_que *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
 
+extern int qla2x00_get_data_rate(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_sup.c source file.
  */
@@ -466,6 +475,82 @@ extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 
+/* qla82xx related functions */
+
+/* PCI related functions */
+extern int qla82xx_pci_config(struct scsi_qla_host *);
+extern int qla82xx_pci_mem_read_2M(struct qla_hw_data *, u64, void *, int);
+extern int qla82xx_pci_mem_write_2M(struct qla_hw_data *, u64, void *, int);
+extern char *qla82xx_pci_info_str(struct scsi_qla_host *, char *);
+extern int qla82xx_pci_region_offset(struct pci_dev *, int);
+extern int qla82xx_pci_region_len(struct pci_dev *, int);
+extern int qla82xx_iospace_config(struct qla_hw_data *);
+
+/* Initialization related functions */
+extern void qla82xx_reset_chip(struct scsi_qla_host *);
+extern void qla82xx_config_rings(struct scsi_qla_host *);
+extern int qla82xx_nvram_config(struct scsi_qla_host *);
+extern int qla82xx_pinit_from_rom(scsi_qla_host_t *);
+extern int qla82xx_load_firmware(scsi_qla_host_t *);
+extern int qla82xx_reset_hw(scsi_qla_host_t *);
+extern int qla82xx_load_risc_blob(scsi_qla_host_t *, uint32_t *);
+extern void qla82xx_watchdog(scsi_qla_host_t *);
+
+/* Firmware and flash related functions */
+extern int qla82xx_load_risc(scsi_qla_host_t *, uint32_t *);
+extern uint8_t *qla82xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
+extern int qla82xx_write_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
+
+/* Mailbox related functions */
+extern int qla82xx_abort_isp(scsi_qla_host_t *);
+extern int qla82xx_restart_isp(scsi_qla_host_t *);
+
+/* IOCB related functions */
+extern int qla82xx_start_scsi(srb_t *);
+
+/* Interrupt related */
+extern irqreturn_t qla82xx_intr_handler(int, void *);
+extern irqreturn_t qla82xx_msi_handler(int, void *);
+extern irqreturn_t qla82xx_msix_default(int, void *);
+extern irqreturn_t qla82xx_msix_rsp_q(int, void *);
+extern void qla82xx_enable_intrs(struct qla_hw_data *);
+extern void qla82xx_disable_intrs(struct qla_hw_data *);
+extern void qla82xx_mbx_completion(scsi_qla_host_t *, uint16_t);
+extern void qla82xx_poll(int, void *);
+extern void qla82xx_init_flags(struct qla_hw_data *);
+
+/* ISP 8021 hardware related */
+extern int qla82xx_crb_win_lock(struct qla_hw_data *);
+extern void qla82xx_crb_win_unlock(struct qla_hw_data *);
+extern int qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *, ulong *);
+extern int qla82xx_wr_32(struct qla_hw_data *, ulong, u32);
+extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
+extern int qla82xx_rdmem(struct qla_hw_data *, u64, void *, int);
+extern int qla82xx_wrmem(struct qla_hw_data *, u64, void *, int);
+extern int qla82xx_check_for_bad_spd(struct qla_hw_data *);
+extern int qla82xx_load_fw(scsi_qla_host_t *);
+extern int qla82xx_rom_lock(struct qla_hw_data *);
+extern void qla82xx_rom_unlock(struct qla_hw_data *);
+extern int qla82xx_rom_fast_read(struct qla_hw_data *, int , int *);
+extern int qla82xx_do_rom_fast_read(struct qla_hw_data *, int, int *);
+extern unsigned long qla82xx_decode_crb_addr(unsigned long);
+
+/* ISP 8021 IDC */
+extern void qla82xx_clear_drv_active(struct qla_hw_data *);
+extern int qla82xx_idc_lock(struct qla_hw_data *);
+extern void qla82xx_idc_unlock(struct qla_hw_data *);
+extern int qla82xx_device_state_handler(scsi_qla_host_t *);
+
+extern void qla2x00_set_model_info(scsi_qla_host_t *, uint8_t *,
+    size_t, char *);
+extern int qla82xx_mbx_intr_enable(scsi_qla_host_t *);
+extern int qla82xx_mbx_intr_disable(scsi_qla_host_t *);
+extern void qla82xx_start_iocbs(srb_t *);
+extern int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *);
+extern void qla82xx_wait_for_pending_commands(scsi_qla_host_t *);
+
 /* BSG related functions */
 extern int qla24xx_bsg_request(struct fc_bsg_job *);
 extern int qla24xx_bsg_timeout(struct fc_bsg_job *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 4647015..872c55f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1535,7 +1535,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
-	if (IS_QLA81XX(ha))
+	if (IS_QLA8XXX_TYPE(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(
 		    FDMI_PORT_SPEED_10GB);
 	else if (IS_QLA25XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8517aa4..55540d2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -328,6 +328,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		if (rval)
 			return (rval);
 	}
+
 	if (IS_QLA84XX(ha)) {
 		ha->cs84xx = qla84xx_get_chip(vha);
 		if (!ha->cs84xx) {
@@ -961,6 +962,9 @@ qla24xx_chip_diag(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 
+	if (IS_QLA82XX(ha))
+		return QLA_SUCCESS;
+
 	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * req->length;
 
 	rval = qla2x00_mbx_reg_test(vha);
@@ -1183,6 +1187,12 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 	unsigned long flags;
 	uint16_t fw_major_version;
 
+	if (IS_QLA82XX(ha)) {
+		rval = ha->isp_ops->load_risc(vha, &srisc_address);
+		if (rval == QLA_SUCCESS)
+			goto enable_82xx_npiv;
+	}
+
 	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
 		/* Disable SRAM, Instruction RAM and GP RAM parity.  */
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1208,6 +1218,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 			rval = qla2x00_execute_fw(vha, srisc_address);
 			/* Retrieve firmware information. */
 			if (rval == QLA_SUCCESS) {
+enable_82xx_npiv:
 				fw_major_version = ha->fw_major_version;
 				rval = qla2x00_get_fw_version(vha,
 				    &ha->fw_major_version,
@@ -1232,8 +1243,10 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				    &ha->fw_xcb_count, NULL, NULL,
 				    &ha->max_npiv_vports, NULL);
 
-				if (!fw_major_version && ql2xallocfwdump)
-					qla2x00_alloc_fw_dump(vha);
+				if (!fw_major_version && ql2xallocfwdump) {
+					if (!IS_QLA82XX(ha))
+						qla2x00_alloc_fw_dump(vha);
+				}
 			}
 		} else {
 			DEBUG2(printk(KERN_INFO
@@ -1390,6 +1403,9 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA82XX(ha))
+		return;
+
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
 		return;
@@ -1824,7 +1840,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	return(rval);
 }
 
-static inline void
+inline void
 qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 	char *def)
 {
@@ -1832,7 +1848,7 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 	uint16_t index;
 	struct qla_hw_data *ha = vha->hw;
 	int use_tbl = !IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) &&
-	    !IS_QLA81XX(ha);
+	    !IS_QLA8XXX_TYPE(ha);
 
 	if (memcmp(model, BINZERO, len) != 0) {
 		strncpy(ha->model_number, model, len);
@@ -3552,6 +3568,45 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 				qla2x00_rport_del(fcport);
 }
 
+void
+qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
+	struct scsi_qla_host *tvp;
+
+	vha->flags.online = 0;
+	ha->flags.chip_reset_done = 0;
+	clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	ha->qla_stats.total_isp_aborts++;
+
+	qla_printk(KERN_INFO, ha,
+	    "Performing ISP error recovery - ha= %p.\n", ha);
+
+	/* Chip reset does not apply to 82XX */
+	if (!IS_QLA82XX(ha))
+		ha->isp_ops->reset_chip(vha);
+
+	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+		atomic_set(&vha->loop_state, LOOP_DOWN);
+		qla2x00_mark_all_devices_lost(vha, 0);
+		list_for_each_entry_safe(vp, tvp, &base_vha->hw->vp_list, list)
+			qla2x00_mark_all_devices_lost(vp, 0);
+	} else {
+		if (!atomic_read(&vha->loop_down_timer))
+			atomic_set(&vha->loop_down_timer,
+			    LOOP_DOWN_TIME);
+	}
+
+	/* Make sure for ISP 82XX IO DMA is complete */
+	if (IS_QLA82XX(ha))
+		qla82xx_wait_for_pending_commands(vha);
+
+	/* Requeue all commands in outstanding command list. */
+	qla2x00_abort_all_cmds(vha, DID_RESET << 16);
+}
+
 /*
 *  qla2x00_abort_isp
 *      Resets ISP and aborts all outstanding commands.
@@ -3573,27 +3628,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 
 	if (vha->flags.online) {
-		vha->flags.online = 0;
-		ha->flags.chip_reset_done = 0;
-		clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		ha->qla_stats.total_isp_aborts++;
-
-		qla_printk(KERN_INFO, ha,
-		    "Performing ISP error recovery - ha= %p.\n", ha);
-		ha->isp_ops->reset_chip(vha);
-
-		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
-			atomic_set(&vha->loop_state, LOOP_DOWN);
-			qla2x00_mark_all_devices_lost(vha, 0);
-		} else {
-			if (!atomic_read(&vha->loop_down_timer))
-				atomic_set(&vha->loop_down_timer,
-				    LOOP_DOWN_TIME);
-		}
-
-		/* Requeue all commands in outstanding command list. */
-		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
+		qla2x00_abort_isp_cleanup(vha);
 
 		if (unlikely(pci_channel_offline(ha->pdev) &&
 		    ha->flags.pci_channel_io_perm_failure)) {
@@ -3849,6 +3884,9 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (IS_QLA82XX(ha))
+		return;
+
 	vha->flags.online = 0;
 	ha->isp_ops->disable_intrs(ha);
 
@@ -3912,6 +3950,8 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	}
 	ha->nvram_size = sizeof(struct nvram_24xx);
 	ha->vpd_size = FA_NVRAM_VPD_SIZE;
+	if (IS_QLA82XX(ha))
+		ha->vpd_size = FA_VPD_SIZE_82XX;
 
 	/* Get VPD data into cache */
 	ha->vpd = ha->nvram + VPD_OFFSET;
@@ -4775,7 +4815,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	 * Setup driver NVRAM options.
 	 */
 	qla2x00_set_model_info(vha, nv->model_name, sizeof(nv->model_name),
-	    "QLE81XX");
+	    "QLE8XXX");
 
 	/* Use alternate WWN? */
 	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
@@ -4898,6 +4938,147 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	return (rval);
 }
 
+int
+qla82xx_restart_isp(scsi_qla_host_t *vha)
+{
+	int status, rval;
+	uint32_t wait_time;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
+	struct scsi_qla_host *vp;
+	struct scsi_qla_host *tvp;
+
+	status = qla2x00_init_rings(vha);
+	if (!status) {
+		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+		ha->flags.chip_reset_done = 1;
+
+		status = qla2x00_fw_ready(vha);
+		if (!status) {
+			qla_printk(KERN_INFO, ha,
+			"%s(): Start configure loop, "
+			"status = %d\n", __func__, status);
+
+			/* Issue a marker after FW becomes ready. */
+			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
+
+			vha->flags.online = 1;
+			/* Wait at most MAX_TARGET RSCNs for a stable link. */
+			wait_time = 256;
+			do {
+				clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+				qla2x00_configure_loop(vha);
+				wait_time--;
+			} while (!atomic_read(&vha->loop_down_timer) &&
+			    !(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags)) &&
+			    wait_time &&
+			    (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)));
+		}
+
+		/* if no cable then assume it's good */
+		if ((vha->device_flags & DFLG_NO_CABLE))
+			status = 0;
+
+		qla_printk(KERN_INFO, ha,
+			"%s(): Configure loop done, status = 0x%x\n",
+			__func__, status);
+	}
+
+	if (!status) {
+		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+
+		if (!atomic_read(&vha->loop_down_timer)) {
+			/*
+			 * Issue marker command only when we are going
+			 * to start the I/O .
+			 */
+			vha->marker_needed = 1;
+		}
+
+		vha->flags.online = 1;
+
+		ha->isp_ops->enable_intrs(ha);
+
+		ha->isp_abort_cnt = 0;
+		clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
+
+		if (ha->fce) {
+			ha->flags.fce_enabled = 1;
+			memset(ha->fce, 0,
+			    fce_calc_size(ha->fce_bufs));
+			rval = qla2x00_enable_fce_trace(vha,
+			    ha->fce_dma, ha->fce_bufs, ha->fce_mb,
+			    &ha->fce_bufs);
+			if (rval) {
+				qla_printk(KERN_WARNING, ha,
+				    "Unable to reinitialize FCE "
+				    "(%d).\n", rval);
+				ha->flags.fce_enabled = 0;
+			}
+		}
+
+		if (ha->eft) {
+			memset(ha->eft, 0, EFT_SIZE);
+			rval = qla2x00_enable_eft_trace(vha,
+			    ha->eft_dma, EFT_NUM_BUFFERS);
+			if (rval) {
+				qla_printk(KERN_WARNING, ha,
+				    "Unable to reinitialize EFT "
+				    "(%d).\n", rval);
+			}
+		}
+	} else {	/* failed the ISP abort */
+		vha->flags.online = 1;
+		if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+			if (ha->isp_abort_cnt == 0) {
+				qla_printk(KERN_WARNING, ha,
+				    "ISP error recovery failed - "
+				    "board disabled\n");
+				/*
+				 * The next call disables the board
+				 * completely.
+				 */
+				ha->isp_ops->reset_adapter(vha);
+				vha->flags.online = 0;
+				clear_bit(ISP_ABORT_RETRY,
+					&vha->dpc_flags);
+				status = 0;
+			} else { /* schedule another ISP abort */
+				ha->isp_abort_cnt--;
+				qla_printk(KERN_INFO, ha,
+					"qla%ld: ISP abort - "
+					"retry remaining %d\n",
+					vha->host_no, ha->isp_abort_cnt);
+				status = 1;
+			}
+		} else {
+			ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
+			qla_printk(KERN_INFO, ha,
+				"(%ld): ISP error recovery "
+				"- retrying (%d) more times\n",
+				vha->host_no, ha->isp_abort_cnt);
+			set_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
+			status = 1;
+		}
+	}
+
+	if (!status) {
+		DEBUG(printk(KERN_INFO
+			"qla82xx_restart_isp(%ld): succeeded.\n",
+			vha->host_no));
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
+			if (vp->vp_idx)
+				qla2x00_vp_abort_isp(vp);
+		}
+	} else {
+		qla_printk(KERN_INFO, ha,
+			"qla82xx_restart_isp: **** FAILED ****\n");
+	}
+
+	return status;
+}
+
 void
 qla81xx_update_fw_options(scsi_qla_host_t *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 5e0a709..ad53c64 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -37,7 +37,10 @@ qla2x00_poll(struct rsp_que *rsp)
 	unsigned long flags;
 	struct qla_hw_data *ha = rsp->hw;
 	local_irq_save(flags);
-	ha->isp_ops->intr_handler(0, rsp);
+	if (IS_QLA82XX(ha))
+		qla82xx_poll(0, rsp);
+	else
+		ha->isp_ops->intr_handler(0, rsp);
 	local_irq_restore(flags);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8299a98..d792ae3 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -506,7 +506,10 @@ qla2x00_req_pkt(struct scsi_qla_host *vha, struct req_que *req,
 				cnt = (uint16_t)
 					RD_REG_DWORD(&reg->isp25mq.req_q_out);
 			else {
-				if (IS_FWI2_CAPABLE(ha))
+				if (IS_QLA82XX(ha))
+					cnt = (uint16_t)RD_REG_DWORD(
+					    &reg->isp82.req_q_out);
+				else if (IS_FWI2_CAPABLE(ha))
 					cnt = (uint16_t)RD_REG_DWORD(
 						&reg->isp24.req_q_out);
 				else
@@ -579,11 +582,29 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 		req->ring_ptr++;
 
 	/* Set chip new ring index. */
-	if (ha->mqenable) {
+	if (IS_QLA82XX(ha)) {
+		uint32_t dbval = 0x04 | (ha->portnum << 5);
+
+		/* write, read and verify logic */
+		dbval = dbval | (req->id << 8) | (req->ring_index << 16);
+		if (ql2xdbwr)
+			qla82xx_wr_32(ha, ha->nxdb_wr_ptr, dbval);
+		else {
+			WRT_REG_DWORD(
+				(unsigned long __iomem *)ha->nxdb_wr_ptr,
+				dbval);
+			wmb();
+			while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+				WRT_REG_DWORD((unsigned long __iomem *)
+					ha->nxdb_wr_ptr, dbval);
+				wmb();
+			}
+		}
+	} else if (ha->mqenable) {
+		/* Set chip new ring index. */
 		WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
 		RD_REG_DWORD(&ioreg->hccr);
-	}
-	else {
+	} else {
 		if (IS_FWI2_CAPABLE(ha)) {
 			WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
 			RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
@@ -604,7 +625,7 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
  *
  * Returns the number of IOCB entries needed to store @dsds.
  */
-static inline uint16_t
+inline uint16_t
 qla24xx_calc_iocbs(uint16_t dsds)
 {
 	uint16_t iocbs;
@@ -626,7 +647,7 @@ qla24xx_calc_iocbs(uint16_t dsds)
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
  */
-static inline void
+inline void
 qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
     uint16_t tot_dsds)
 {
@@ -931,24 +952,31 @@ qla2x00_start_iocbs(srb_t *sp)
 	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
 	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
 
-	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else
-		req->ring_ptr++;
-
-	/* Set chip new ring index. */
-	if (ha->mqenable) {
-		WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
-		RD_REG_DWORD(&ioreg->hccr);
-	} else if (IS_FWI2_CAPABLE(ha)) {
-		WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
-		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+	if (IS_QLA82XX(ha)) {
+		qla82xx_start_iocbs(sp);
 	} else {
-		WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp), req->ring_index);
-		RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+		/* Adjust ring index. */
+		req->ring_index++;
+		if (req->ring_index == req->length) {
+			req->ring_index = 0;
+			req->ring_ptr = req->ring;
+		} else
+			req->ring_ptr++;
+
+		/* Set chip new ring index. */
+		if (ha->mqenable) {
+			WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
+			RD_REG_DWORD(&ioreg->hccr);
+		} else if (IS_QLA82XX(ha)) {
+			qla82xx_start_iocbs(sp);
+		} else if (IS_FWI2_CAPABLE(ha)) {
+			WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
+			RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+		} else {
+			WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp),
+				req->ring_index);
+			RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+		}
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index db539b0..f1ac62d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -326,7 +326,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
-	if (IS_QLA81XX(ha))
+	if (IS_QLA8XXX_TYPE(ha))
 		goto skip_rio;
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:
@@ -544,7 +544,7 @@ skip_rio:
 		if (IS_QLA2100(ha))
 			break;
 
-		if (IS_QLA81XX(ha))
+		if (IS_QLA8XXX_TYPE(ha))
 			DEBUG2(printk("scsi(%ld): DCBX Completed -- %04x %04x "
 			    "%04x\n", vha->host_no, mb[1], mb[2], mb[3]));
 		else
@@ -845,7 +845,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		qla2x00_sp_compl(ha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld) Req:%d: Invalid ISP SCSI completion"
-			" handle(%d)\n", vha->host_no, req->id, index));
+			" handle(0x%x)\n", vha->host_no, req->id, index));
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid ISP SCSI completion handle\n");
 
@@ -1337,6 +1337,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	handle = (uint32_t) LSW(sts->handle);
 	que = MSW(sts->handle);
 	req = ha->req_q_map[que];
+
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
 		qla2x00_process_completed_request(vha, req, handle);
@@ -1806,6 +1807,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct rsp_que *rsp)
 {
 	struct sts_entry_24xx *pkt;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!vha->flags.online)
 		return;
@@ -1866,7 +1868,11 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	}
 
 	/* Adjust ring index */
-	WRT_REG_DWORD(rsp->rsp_q_out, rsp->ring_index);
+	if (IS_QLA82XX(ha)) {
+		struct device_reg_82xx __iomem *reg = &ha->iobase->isp82;
+		WRT_REG_DWORD(&reg->rsp_q_out[0], rsp->ring_index);
+	} else
+		WRT_REG_DWORD(rsp->rsp_q_out, rsp->ring_index);
 }
 
 static void
@@ -2169,6 +2175,11 @@ static struct qla_init_msix_entry msix_entries[3] = {
 	{ "qla2xxx (multiq)", qla25xx_msix_rsp_q },
 };
 
+static struct qla_init_msix_entry qla82xx_msix_entries[2] = {
+	{ "qla2xxx (default)", qla82xx_msix_default },
+	{ "qla2xxx (rsp_q)", qla82xx_msix_rsp_q },
+};
+
 static void
 qla24xx_disable_msix(struct qla_hw_data *ha)
 {
@@ -2195,7 +2206,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	struct qla_msix_entry *qentry;
 
 	entries = kzalloc(sizeof(struct msix_entry) * ha->msix_count,
-					GFP_KERNEL);
+			GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
 
@@ -2240,8 +2251,15 @@ msix_failed:
 	/* Enable MSI-X vectors for the base queue */
 	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
-		ret = request_irq(qentry->vector, msix_entries[i].handler,
-					0, msix_entries[i].name, rsp);
+		if (IS_QLA82XX(ha)) {
+			ret = request_irq(qentry->vector,
+				qla82xx_msix_entries[i].handler,
+				0, qla82xx_msix_entries[i].name, rsp);
+		} else {
+			ret = request_irq(qentry->vector,
+				msix_entries[i].handler,
+				0, msix_entries[i].name, rsp);
+		}
 		if (ret) {
 			qla_printk(KERN_WARNING, ha,
 			"MSI-X: Unable to register handler -- %x/%d.\n",
@@ -2272,7 +2290,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
-		!IS_QLA8432(ha) && !IS_QLA8001(ha))
+		!IS_QLA8432(ha) && !IS_QLA8XXX_TYPE(ha))
 		goto skip_msi;
 
 	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
@@ -2302,7 +2320,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		goto clear_risc_ints;
 	}
 	qla_printk(KERN_WARNING, ha,
-	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
+	    "MSI-X: Falling back-to MSI mode -- %d.\n", ret);
 skip_msix:
 
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
@@ -2313,7 +2331,9 @@ skip_msix:
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
 		ha->flags.msi_enabled = 1;
-	}
+	} else
+		qla_printk(KERN_WARNING, ha,
+		    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
@@ -2331,7 +2351,7 @@ clear_risc_ints:
 	 * FIXME: Noted that 8014s were being dropped during NK testing.
 	 * Timing deltas during MSI-X/INTa transitions?
 	 */
-	if (IS_QLA81XX(ha))
+	if (IS_QLA81XX(ha) || IS_QLA82XX(ha))
 		goto fail;
 	spin_lock_irq(&ha->hardware_lock);
 	if (IS_FWI2_CAPABLE(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bce6cd4..2f30332 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -49,6 +49,14 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	if (ha->pdev->error_state > pci_channel_io_frozen)
 		return QLA_FUNCTION_TIMEOUT;
 
+	if (vha->device_flags & DFLG_DEV_FAILED) {
+		DEBUG2_3_11(qla_printk(KERN_WARNING, ha,
+			"%s(%ld): Device in failed state, "
+			"timeout MBX Exiting.\n",
+			__func__, base_vha->host_no));
+		return QLA_FUNCTION_TIMEOUT;
+	}
+
 	reg = ha->iobase;
 	io_lock_on = base_vha->flags.init_done;
 
@@ -85,7 +93,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Load mailbox registers. */
-	if (IS_FWI2_CAPABLE(ha))
+	if (IS_QLA82XX(ha))
+		optr = (uint16_t __iomem *)&reg->isp82.mailbox_in[0];
+	else if (IS_FWI2_CAPABLE(ha) && !IS_QLA82XX(ha))
 		optr = (uint16_t __iomem *)&reg->isp24.mailbox0;
 	else
 		optr = (uint16_t __iomem *)MAILBOX_REG(ha, &reg->isp, 0);
@@ -133,7 +143,18 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	if ((!abort_active && io_lock_on) || IS_NOPOLLING_TYPE(ha)) {
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		if (IS_FWI2_CAPABLE(ha))
+		if (IS_QLA82XX(ha)) {
+			if (RD_REG_DWORD(&reg->isp82.hint) &
+				HINT_MBX_INT_PENDING) {
+				spin_unlock_irqrestore(&ha->hardware_lock,
+					flags);
+				DEBUG2_3_11(printk(KERN_INFO
+				    "%s(%ld): Pending Mailbox timeout. "
+				    "Exiting.\n", __func__, base_vha->host_no));
+				return QLA_FUNCTION_TIMEOUT;
+			}
+			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
+		} else if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
@@ -147,7 +168,18 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
 		    base_vha->host_no, command));
 
-		if (IS_FWI2_CAPABLE(ha))
+		if (IS_QLA82XX(ha)) {
+			if (RD_REG_DWORD(&reg->isp82.hint) &
+				HINT_MBX_INT_PENDING) {
+				spin_unlock_irqrestore(&ha->hardware_lock,
+					flags);
+				DEBUG2_3_11(printk(KERN_INFO
+				    "%s(%ld): Pending Mailbox timeout. "
+				    "Exiting.\n", __func__, base_vha->host_no));
+				return QLA_FUNCTION_TIMEOUT;
+			}
+			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
+		} else if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
@@ -264,7 +296,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 			set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 			clear_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
-			if (qla2x00_abort_isp(base_vha)) {
+			if (ha->isp_ops->abort_isp(base_vha)) {
 				/* Failed. retry later. */
 				set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 			}
@@ -952,7 +984,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_0;
 	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	if (IS_QLA81XX(vha->hw))
+	if (IS_QLA8XXX_TYPE(vha->hw))
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -978,7 +1010,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 		DEBUG11(printk("qla2x00_get_adapter_id(%ld): done.\n",
 		    vha->host_no));
 
-		if (IS_QLA81XX(vha->hw)) {
+		if (IS_QLA8XXX_TYPE(vha->hw)) {
 			vha->fcoe_vlan_id = mcp->mb[9] & 0xfff;
 			vha->fcoe_fcf_idx = mcp->mb[10];
 			vha->fcoe_vn_port_mac[5] = mcp->mb[11] >> 8;
@@ -1076,6 +1108,10 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    vha->host_no));
 
+	if (IS_QLA82XX(ha) && ql2xdbwr)
+		qla82xx_wr_32(ha, ha->nxdb_wr_ptr,
+			(0x04 | (ha->portnum << 5) | (0 << 8) | (0 << 16)));
+
 	if (ha->flags.npiv_supported)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
 	else
@@ -1408,7 +1444,7 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (IS_QLA81XX(vha->hw)) {
+	if (IS_QLA8XXX_TYPE(vha->hw)) {
 		/* Logout across all FCFs. */
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 		mcp->mb[1] = BIT_1;
@@ -2797,7 +2833,7 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
 	mcp->mb[2] = BIT_0;
-	if (IS_QLA81XX(vha->hw))
+	if (IS_QLA8XXX_TYPE(vha->hw))
 		mcp->mb[3] = port_speed & (BIT_5|BIT_4|BIT_3|BIT_2|BIT_1|BIT_0);
 	else
 		mcp->mb[3] = port_speed & (BIT_2|BIT_1|BIT_0);
@@ -3586,7 +3622,7 @@ qla2x00_get_xgmac_stats(scsi_qla_host_t *vha, dma_addr_t stats_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA81XX(vha->hw))
+	if (!IS_QLA8XXX_TYPE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
@@ -3624,7 +3660,7 @@ qla2x00_get_dcbx_params(scsi_qla_host_t *vha, dma_addr_t tlv_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA81XX(vha->hw))
+	if (!IS_QLA8XXX_TYPE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
@@ -3685,7 +3721,8 @@ qla2x00_read_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t *data)
 }
 
 int
-qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mresp)
+qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
+	uint16_t *mresp)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -3720,7 +3757,7 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *
 
 	mcp->out_mb = MBX_21|MBX_20|MBX_19|MBX_18|MBX_17|MBX_16|MBX_15|
 	    MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_7|MBX_6|MBX_1|MBX_0;
-	if (IS_QLA81XX(vha->hw))
+	if (IS_QLA8XXX_TYPE(vha->hw))
 		mcp->out_mb |= MBX_2;
 	mcp->in_mb = MBX_19|MBX_18|MBX_3|MBX_2|MBX_1|MBX_0;
 
@@ -3732,9 +3769,11 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk(KERN_WARNING
-		    "(%ld): failed=%x mb[0]=0x%x "
-			"mb[1]=0x%x mb[2]=0x%x mb[3]=0x%x mb[18]=0x%x mb[19]=0x%x. \n", vha->host_no, rval,
-			mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[18], mcp->mb[19]));
+			"(%ld): failed=%x mb[0]=0x%x "
+			"mb[1]=0x%x mb[2]=0x%x mb[3]=0x%x mb[18]=0x%x "
+			"mb[19]=0x%x.\n",
+			vha->host_no, rval, mcp->mb[0], mcp->mb[1], mcp->mb[2],
+			mcp->mb[3], mcp->mb[18], mcp->mb[19]));
 	} else {
 		DEBUG2(printk(KERN_WARNING
 		    "scsi(%ld): done.\n", vha->host_no));
@@ -3748,7 +3787,8 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *
 }
 
 int
-qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mresp)
+qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
+	uint16_t *mresp)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -3760,9 +3800,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mres
 	memset(mcp->mb, 0 , sizeof(mcp->mb));
 	mcp->mb[0] = MBC_DIAGNOSTIC_ECHO;
 	mcp->mb[1] = mreq->options | BIT_6;	/* BIT_6 specifies 64bit address */
-	if (IS_QLA81XX(ha))
+	if (IS_QLA8XXX_TYPE(ha)) {
 		mcp->mb[1] |= BIT_15;
-	mcp->mb[2] = IS_QLA81XX(ha) ? vha->fcoe_fcf_idx : 0;
+		mcp->mb[2] = vha->fcoe_fcf_idx;
+	}
 	mcp->mb[16] = LSW(mreq->rcv_dma);
 	mcp->mb[17] = MSW(mreq->rcv_dma);
 	mcp->mb[6] = LSW(MSD(mreq->rcv_dma));
@@ -3777,13 +3818,13 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mres
 
 	mcp->out_mb = MBX_21|MBX_20|MBX_17|MBX_16|MBX_15|
 	    MBX_14|MBX_10|MBX_7|MBX_6|MBX_1|MBX_0;
-	if (IS_QLA81XX(ha))
+	if (IS_QLA8XXX_TYPE(ha))
 		mcp->out_mb |= MBX_2;
 
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) || IS_QLA81XX(ha))
+	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) || IS_QLA8XXX_TYPE(ha))
 		mcp->in_mb |= MBX_1;
-	if (IS_QLA81XX(ha))
+	if (IS_QLA8XXX_TYPE(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
@@ -3875,7 +3916,8 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, vha->host_no));
+	DEBUG11(qla_printk(KERN_INFO, ha,
+		"%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_DATA_RATE;
 	mcp->mb[1] = 0;
@@ -3943,3 +3985,75 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 
 	return rval;
 }
+
+int
+qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
+{
+	int rval;
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(qla_printk(KERN_INFO, ha,
+		"%s(%ld): entered.\n", __func__, vha->host_no));
+
+	memset(mcp, 0, sizeof(mbx_cmd_t));
+	mcp->mb[0] = MBC_TOGGLE_INTR;
+	mcp->mb[1] = 1;
+
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(qla_printk(KERN_WARNING, ha,
+			"%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+			vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(qla_printk(KERN_INFO, ha,
+			"%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
+
+int
+qla82xx_mbx_intr_disable(scsi_qla_host_t *vha)
+{
+	int rval;
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA82XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(qla_printk(KERN_INFO, ha,
+		"%s(%ld): entered.\n", __func__, vha->host_no));
+
+	memset(mcp, 0, sizeof(mbx_cmd_t));
+	mcp->mb[0] = MBC_TOGGLE_INTR;
+	mcp->mb[1] = 0;
+
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(qla_printk(KERN_WARNING, ha,
+			"%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+			vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(qla_printk(KERN_INFO, ha,
+			"%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
new file mode 100644
index 0000000..495ff1a
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -0,0 +1,3635 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2008 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include "qla_def.h"
+#include <linux/delay.h>
+#include <linux/pci.h>
+
+#define MASK(n)			((1ULL<<(n))-1)
+#define MN_WIN(addr) (((addr & 0x1fc0000) >> 1) | \
+	((addr >> 25) & 0x3ff))
+#define OCM_WIN(addr) (((addr & 0x1ff0000) >> 1) | \
+	((addr >> 25) & 0x3ff))
+#define MS_WIN(addr) (addr & 0x0ffc0000)
+#define QLA82XX_PCI_MN_2M   (0)
+#define QLA82XX_PCI_MS_2M   (0x80000)
+#define QLA82XX_PCI_OCM0_2M (0xc0000)
+#define VALID_OCM_ADDR(addr) (((addr) & 0x3f800) != 0x3f800)
+#define GET_MEM_OFFS_2M(addr) (addr & MASK(18))
+
+/* CRB window related */
+#define CRB_BLK(off)	((off >> 20) & 0x3f)
+#define CRB_SUBBLK(off)	((off >> 16) & 0xf)
+#define CRB_WINDOW_2M	(0x130060)
+#define QLA82XX_PCI_CAMQM_2M_END	(0x04800800UL)
+#define CRB_HI(off)	((qla82xx_crb_hub_agt[CRB_BLK(off)] << 20) | \
+			((off) & 0xf0000))
+#define QLA82XX_PCI_CAMQM_2M_BASE	(0x000ff800UL)
+#define CRB_INDIRECT_2M	(0x1e0000UL)
+
+static inline void *qla82xx_pci_base_offsetfset(struct qla_hw_data *ha,
+    unsigned long off)
+{
+	if ((off < ha->first_page_group_end) &&
+	    (off >= ha->first_page_group_start))
+		return (void *)(ha->nx_pcibase + off);
+
+	return NULL;
+}
+
+#define MAX_CRB_XFORM 60
+static unsigned long crb_addr_xform[MAX_CRB_XFORM];
+int qla82xx_crb_table_initialized;
+
+#define qla82xx_crb_addr_transform(name) \
+	(crb_addr_xform[QLA82XX_HW_PX_MAP_CRB_##name] = \
+	QLA82XX_HW_CRB_HUB_AGT_ADR_##name << 20)
+
+static void qla82xx_crb_addr_transform_setup(void)
+{
+	qla82xx_crb_addr_transform(XDMA);
+	qla82xx_crb_addr_transform(TIMR);
+	qla82xx_crb_addr_transform(SRE);
+	qla82xx_crb_addr_transform(SQN3);
+	qla82xx_crb_addr_transform(SQN2);
+	qla82xx_crb_addr_transform(SQN1);
+	qla82xx_crb_addr_transform(SQN0);
+	qla82xx_crb_addr_transform(SQS3);
+	qla82xx_crb_addr_transform(SQS2);
+	qla82xx_crb_addr_transform(SQS1);
+	qla82xx_crb_addr_transform(SQS0);
+	qla82xx_crb_addr_transform(RPMX7);
+	qla82xx_crb_addr_transform(RPMX6);
+	qla82xx_crb_addr_transform(RPMX5);
+	qla82xx_crb_addr_transform(RPMX4);
+	qla82xx_crb_addr_transform(RPMX3);
+	qla82xx_crb_addr_transform(RPMX2);
+	qla82xx_crb_addr_transform(RPMX1);
+	qla82xx_crb_addr_transform(RPMX0);
+	qla82xx_crb_addr_transform(ROMUSB);
+	qla82xx_crb_addr_transform(SN);
+	qla82xx_crb_addr_transform(QMN);
+	qla82xx_crb_addr_transform(QMS);
+	qla82xx_crb_addr_transform(PGNI);
+	qla82xx_crb_addr_transform(PGND);
+	qla82xx_crb_addr_transform(PGN3);
+	qla82xx_crb_addr_transform(PGN2);
+	qla82xx_crb_addr_transform(PGN1);
+	qla82xx_crb_addr_transform(PGN0);
+	qla82xx_crb_addr_transform(PGSI);
+	qla82xx_crb_addr_transform(PGSD);
+	qla82xx_crb_addr_transform(PGS3);
+	qla82xx_crb_addr_transform(PGS2);
+	qla82xx_crb_addr_transform(PGS1);
+	qla82xx_crb_addr_transform(PGS0);
+	qla82xx_crb_addr_transform(PS);
+	qla82xx_crb_addr_transform(PH);
+	qla82xx_crb_addr_transform(NIU);
+	qla82xx_crb_addr_transform(I2Q);
+	qla82xx_crb_addr_transform(EG);
+	qla82xx_crb_addr_transform(MN);
+	qla82xx_crb_addr_transform(MS);
+	qla82xx_crb_addr_transform(CAS2);
+	qla82xx_crb_addr_transform(CAS1);
+	qla82xx_crb_addr_transform(CAS0);
+	qla82xx_crb_addr_transform(CAM);
+	qla82xx_crb_addr_transform(C2C1);
+	qla82xx_crb_addr_transform(C2C0);
+	qla82xx_crb_addr_transform(SMB);
+	qla82xx_crb_addr_transform(OCM0);
+	/*
+	 * Used only in P3 just define it for P2 also.
+	 */
+	qla82xx_crb_addr_transform(I2C0);
+
+	qla82xx_crb_table_initialized = 1;
+}
+
+struct crb_128M_2M_block_map crb_128M_2M_map[64] = {
+	{{{0, 0,         0,         0} } },
+	{{{1, 0x0100000, 0x0102000, 0x120000},
+	{1, 0x0110000, 0x0120000, 0x130000},
+	{1, 0x0120000, 0x0122000, 0x124000},
+	{1, 0x0130000, 0x0132000, 0x126000},
+	{1, 0x0140000, 0x0142000, 0x128000},
+	{1, 0x0150000, 0x0152000, 0x12a000},
+	{1, 0x0160000, 0x0170000, 0x110000},
+	{1, 0x0170000, 0x0172000, 0x12e000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{1, 0x01e0000, 0x01e0800, 0x122000},
+	{0, 0x0000000, 0x0000000, 0x000000} } } ,
+	{{{1, 0x0200000, 0x0210000, 0x180000} } },
+	{{{0, 0,         0,         0} } },
+	{{{1, 0x0400000, 0x0401000, 0x169000} } },
+	{{{1, 0x0500000, 0x0510000, 0x140000} } },
+	{{{1, 0x0600000, 0x0610000, 0x1c0000} } },
+	{{{1, 0x0700000, 0x0704000, 0x1b8000} } },
+	{{{1, 0x0800000, 0x0802000, 0x170000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{1, 0x08f0000, 0x08f2000, 0x172000} } },
+	{{{1, 0x0900000, 0x0902000, 0x174000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{1, 0x09f0000, 0x09f2000, 0x176000} } },
+	{{{0, 0x0a00000, 0x0a02000, 0x178000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{1, 0x0af0000, 0x0af2000, 0x17a000} } },
+	{{{0, 0x0b00000, 0x0b02000, 0x17c000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{1, 0x0bf0000, 0x0bf2000, 0x17e000} } },
+	{{{1, 0x0c00000, 0x0c04000, 0x1d4000} } },
+	{{{1, 0x0d00000, 0x0d04000, 0x1a4000} } },
+	{{{1, 0x0e00000, 0x0e04000, 0x1a0000} } },
+	{{{1, 0x0f00000, 0x0f01000, 0x164000} } },
+	{{{0, 0x1000000, 0x1004000, 0x1a8000} } },
+	{{{1, 0x1100000, 0x1101000, 0x160000} } },
+	{{{1, 0x1200000, 0x1201000, 0x161000} } },
+	{{{1, 0x1300000, 0x1301000, 0x162000} } },
+	{{{1, 0x1400000, 0x1401000, 0x163000} } },
+	{{{1, 0x1500000, 0x1501000, 0x165000} } },
+	{{{1, 0x1600000, 0x1601000, 0x166000} } },
+	{{{0, 0,         0,         0} } },
+	{{{0, 0,         0,         0} } },
+	{{{0, 0,         0,         0} } },
+	{{{0, 0,         0,         0} } },
+	{{{0, 0,         0,         0} } },
+	{{{0, 0,         0,         0} } },
+	{{{1, 0x1d00000, 0x1d10000, 0x190000} } },
+	{{{1, 0x1e00000, 0x1e01000, 0x16a000} } },
+	{{{1, 0x1f00000, 0x1f10000, 0x150000} } },
+	{{{0} } },
+	{{{1, 0x2100000, 0x2102000, 0x120000},
+	{1, 0x2110000, 0x2120000, 0x130000},
+	{1, 0x2120000, 0x2122000, 0x124000},
+	{1, 0x2130000, 0x2132000, 0x126000},
+	{1, 0x2140000, 0x2142000, 0x128000},
+	{1, 0x2150000, 0x2152000, 0x12a000},
+	{1, 0x2160000, 0x2170000, 0x110000},
+	{1, 0x2170000, 0x2172000, 0x12e000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000},
+	{0, 0x0000000, 0x0000000, 0x000000} } },
+	{{{1, 0x2200000, 0x2204000, 0x1b0000} } },
+	{{{0} } },
+	{{{0} } },
+	{{{0} } },
+	{{{0} } },
+	{{{0} } },
+	{{{1, 0x2800000, 0x2804000, 0x1a4000} } },
+	{{{1, 0x2900000, 0x2901000, 0x16b000} } },
+	{{{1, 0x2a00000, 0x2a00400, 0x1ac400} } },
+	{{{1, 0x2b00000, 0x2b00400, 0x1ac800} } },
+	{{{1, 0x2c00000, 0x2c00400, 0x1acc00} } },
+	{{{1, 0x2d00000, 0x2d00400, 0x1ad000} } },
+	{{{1, 0x2e00000, 0x2e00400, 0x1ad400} } },
+	{{{1, 0x2f00000, 0x2f00400, 0x1ad800} } },
+	{{{1, 0x3000000, 0x3000400, 0x1adc00} } },
+	{{{0, 0x3100000, 0x3104000, 0x1a8000} } },
+	{{{1, 0x3200000, 0x3204000, 0x1d4000} } },
+	{{{1, 0x3300000, 0x3304000, 0x1a0000} } },
+	{{{0} } },
+	{{{1, 0x3500000, 0x3500400, 0x1ac000} } },
+	{{{1, 0x3600000, 0x3600400, 0x1ae000} } },
+	{{{1, 0x3700000, 0x3700400, 0x1ae400} } },
+	{{{1, 0x3800000, 0x3804000, 0x1d0000} } },
+	{{{1, 0x3900000, 0x3904000, 0x1b4000} } },
+	{{{1, 0x3a00000, 0x3a04000, 0x1d8000} } },
+	{{{0} } },
+	{{{0} } },
+	{{{1, 0x3d00000, 0x3d04000, 0x1dc000} } },
+	{{{1, 0x3e00000, 0x3e01000, 0x167000} } },
+	{{{1, 0x3f00000, 0x3f01000, 0x168000} } }
+};
+
+/*
+ * top 12 bits of crb internal address (hub, agent)
+ */
+unsigned qla82xx_crb_hub_agt[64] = {
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PS,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_MN,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_MS,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SRE,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_NIU,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_QMN,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN3,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2Q,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_TIMR,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_ROMUSB,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN4,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_XDMA,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN3,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGND,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGNI,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS3,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGSI,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SN,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_EG,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PS,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_CAM,
+	0,
+	0,
+	0,
+	0,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_TIMR,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX3,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX4,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX5,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX6,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX7,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_XDMA,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2Q,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_ROMUSB,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX8,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX9,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_OCM0,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SMB,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2C0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2C1,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGNC,
+	0,
+};
+
+/*
+ * In: 'off' is offset from CRB space in 128M pci map
+ * Out: 'off' is 2M pci map addr
+ * side effect: lock crb window
+ */
+static void
+qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
+{
+	u32 win_read;
+
+	ha->crb_win = CRB_HI(*off);
+	writel(ha->crb_win,
+		(void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+
+	/* Read back value to make sure write has gone through before trying
+	 * to use it.
+	 */
+	win_read = RD_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	if (win_read != ha->crb_win) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "%s: Written crbwin (0x%x) != Read crbwin (0x%x), "
+		    "off=0x%lx\n", __func__, ha->crb_win, win_read, *off));
+	}
+	*off = (*off & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
+}
+
+static inline unsigned long
+qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
+{
+	/* See if we are currently pointing to the region we want to use next */
+	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_DDR_NET)) {
+		/* No need to change window. PCIX and PCIEregs are in both
+		 * regs are in both windows.
+		 */
+		return off;
+	}
+
+	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_PCIX_HOST2)) {
+		/* We are in first CRB window */
+		if (ha->curr_window != 0)
+			WARN_ON(1);
+		return off;
+	}
+
+	if ((off > QLA82XX_CRB_PCIX_HOST2) && (off < QLA82XX_CRB_MAX)) {
+		/* We are in second CRB window */
+		off = off - QLA82XX_CRB_PCIX_HOST2 + QLA82XX_CRB_PCIX_HOST;
+
+		if (ha->curr_window != 1)
+			return off;
+
+		/* We are in the QM or direct access
+		 * register region - do nothing
+		 */
+		if ((off >= QLA82XX_PCI_DIRECT_CRB) &&
+			(off < QLA82XX_PCI_CAMQM_MAX))
+			return off;
+	}
+	/* strange address given */
+	qla_printk(KERN_WARNING, ha,
+		"%s: Warning: unm_nic_pci_set_crbwindow called with"
+		" an unknown address(%llx)\n", QLA2XXX_DRIVER_NAME, off);
+	return off;
+}
+
+int
+qla82xx_wr_32(struct qla_hw_data *ha, ulong off, u32 data)
+{
+	unsigned long flags = 0;
+	int rv;
+
+	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
+
+	BUG_ON(rv == -1);
+
+	if (rv == 1) {
+		write_lock_irqsave(&ha->hw_lock, flags);
+		qla82xx_crb_win_lock(ha);
+		qla82xx_pci_set_crbwindow_2M(ha, &off);
+	}
+
+	writel(data, (void __iomem *)off);
+
+	if (rv == 1) {
+		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+	}
+	return 0;
+}
+
+int
+qla82xx_rd_32(struct qla_hw_data *ha, ulong off)
+{
+	unsigned long flags = 0;
+	int rv;
+	u32 data;
+
+	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
+
+	BUG_ON(rv == -1);
+
+	if (rv == 1) {
+		write_lock_irqsave(&ha->hw_lock, flags);
+		qla82xx_crb_win_lock(ha);
+		qla82xx_pci_set_crbwindow_2M(ha, &off);
+	}
+	data = RD_REG_DWORD((void __iomem *)off);
+
+	if (rv == 1) {
+		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+	}
+	return data;
+}
+
+#define CRB_WIN_LOCK_TIMEOUT 100000000
+int qla82xx_crb_win_lock(struct qla_hw_data *ha)
+{
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore3 from PCI HW block */
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= CRB_WIN_LOCK_TIMEOUT)
+			return -1;
+		timeout++;
+	}
+	qla82xx_wr_32(ha, QLA82XX_CRB_WIN_LOCK_ID, ha->portnum);
+	return 0;
+}
+
+#define IDC_LOCK_TIMEOUT 100000000
+int qla82xx_idc_lock(struct qla_hw_data *ha)
+{
+	int i;
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore5 from PCI HW block */
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= IDC_LOCK_TIMEOUT)
+			return -1;
+
+		timeout++;
+
+		/* Yield CPU */
+		if (!in_interrupt())
+			schedule();
+		else {
+			for (i = 0; i < 20; i++)
+				cpu_relax();
+		}
+	}
+
+	return 0;
+}
+
+void qla82xx_idc_unlock(struct qla_hw_data *ha)
+{
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_UNLOCK));
+}
+
+int
+qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong *off)
+{
+	struct crb_128M_2M_sub_block_map *m;
+
+	if (*off >= QLA82XX_CRB_MAX)
+		return -1;
+
+	if (*off >= QLA82XX_PCI_CAMQM && (*off < QLA82XX_PCI_CAMQM_2M_END)) {
+		*off = (*off - QLA82XX_PCI_CAMQM) +
+		    QLA82XX_PCI_CAMQM_2M_BASE + ha->nx_pcibase;
+		return 0;
+	}
+
+	if (*off < QLA82XX_PCI_CRBSPACE)
+		return -1;
+
+	*off -= QLA82XX_PCI_CRBSPACE;
+
+	/* Try direct map */
+	m = &crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
+
+	if (m->valid && (m->start_128M <= *off) && (m->end_128M > *off)) {
+		*off = *off + m->start_2M - m->start_128M + ha->nx_pcibase;
+		return 0;
+	}
+	/* Not in direct map, use crb window */
+	return 1;
+}
+
+/*  PCI Windowing for DDR regions.  */
+#define QLA82XX_ADDR_IN_RANGE(addr, low, high) \
+	(((addr) <= (high)) && ((addr) >= (low)))
+/*
+ * check memory access boundary.
+ * used by test agent. support ddr access only for now
+ */
+static unsigned long
+qla82xx_pci_mem_bound_check(struct qla_hw_data *ha,
+	unsigned long long addr, int size)
+{
+	if (!QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
+		QLA82XX_ADDR_DDR_NET_MAX) ||
+		!QLA82XX_ADDR_IN_RANGE(addr + size - 1, QLA82XX_ADDR_DDR_NET,
+		QLA82XX_ADDR_DDR_NET_MAX) ||
+		((size != 1) && (size != 2) && (size != 4) && (size != 8)))
+			return 0;
+	else
+		return 1;
+}
+
+int qla82xx_pci_set_window_warning_count;
+
+unsigned long
+qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
+{
+	int window;
+	u32 win_read;
+
+	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
+		QLA82XX_ADDR_DDR_NET_MAX)) {
+		/* DDR network side */
+		window = MN_WIN(addr);
+		ha->ddr_mn_window = window;
+		qla82xx_wr_32(ha,
+			ha->mn_win_crb | QLA82XX_PCI_CRBSPACE, window);
+		win_read = qla82xx_rd_32(ha,
+			ha->mn_win_crb | QLA82XX_PCI_CRBSPACE);
+		if ((win_read << 17) != window) {
+			qla_printk(KERN_WARNING, ha,
+			    "%s: Written MNwin (0x%x) != Read MNwin (0x%x)\n",
+			    __func__, window, win_read);
+		}
+		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_DDR_NET;
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0,
+		QLA82XX_ADDR_OCM0_MAX)) {
+		unsigned int temp1;
+		if ((addr & 0x00ff800) == 0xff800) {
+			qla_printk(KERN_WARNING, ha,
+			    "%s: QM access not handled.\n", __func__);
+			addr = -1UL;
+		}
+		window = OCM_WIN(addr);
+		ha->ddr_mn_window = window;
+		qla82xx_wr_32(ha,
+			ha->mn_win_crb | QLA82XX_PCI_CRBSPACE, window);
+		win_read = qla82xx_rd_32(ha,
+			ha->mn_win_crb | QLA82XX_PCI_CRBSPACE);
+		temp1 = ((window & 0x1FF) << 7) |
+		    ((window & 0x0FFFE0000) >> 17);
+		if (win_read != temp1) {
+			qla_printk(KERN_WARNING, ha,
+			    "%s: Written OCMwin (0x%x) != Read OCMwin (0x%x)\n",
+			    __func__, temp1, win_read);
+		}
+		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_OCM0_2M;
+
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET,
+		QLA82XX_P3_ADDR_QDR_NET_MAX)) {
+		/* QDR network side */
+		window = MS_WIN(addr);
+		ha->qdr_sn_window = window;
+		qla82xx_wr_32(ha,
+			ha->ms_win_crb | QLA82XX_PCI_CRBSPACE, window);
+		win_read = qla82xx_rd_32(ha,
+			ha->ms_win_crb | QLA82XX_PCI_CRBSPACE);
+		if (win_read != window) {
+			qla_printk(KERN_WARNING, ha,
+			    "%s: Written MSwin (0x%x) != Read MSwin (0x%x)\n",
+			    __func__, window, win_read);
+		}
+		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_QDR_NET;
+	} else {
+		/*
+		 * peg gdb frequently accesses memory that doesn't exist,
+		 * this limits the chit chat so debugging isn't slowed down.
+		 */
+		if ((qla82xx_pci_set_window_warning_count++ < 8) ||
+		    (qla82xx_pci_set_window_warning_count%64 == 0)) {
+			qla_printk(KERN_WARNING, ha,
+			    "%s: Warning:%s Unknown address range!\n", __func__,
+			    QLA2XXX_DRIVER_NAME);
+		}
+		addr = -1UL;
+	}
+	return addr;
+}
+
+/* check if address is in the same windows as the previous access */
+static int qla82xx_pci_is_same_window(struct qla_hw_data *ha,
+	unsigned long long addr)
+{
+	int			window;
+	unsigned long long	qdr_max;
+
+	qdr_max = QLA82XX_P3_ADDR_QDR_NET_MAX;
+
+	/* DDR network side */
+	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
+		QLA82XX_ADDR_DDR_NET_MAX))
+		BUG();
+	else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0,
+		QLA82XX_ADDR_OCM0_MAX))
+		return 1;
+	else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM1,
+		QLA82XX_ADDR_OCM1_MAX))
+		return 1;
+	else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET, qdr_max)) {
+		/* QDR network side */
+		window = ((addr - QLA82XX_ADDR_QDR_NET) >> 22) & 0x3f;
+		if (ha->qdr_sn_window == window)
+			return 1;
+	}
+	return 0;
+}
+
+static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
+	u64 off, void *data, int size)
+{
+	unsigned long   flags;
+	void           *addr;
+	int             ret = 0;
+	u64             start;
+	uint8_t         *mem_ptr = NULL;
+	unsigned long   mem_base;
+	unsigned long   mem_page;
+
+	write_lock_irqsave(&ha->hw_lock, flags);
+
+	/*
+	 * If attempting to access unknown address or straddle hw windows,
+	 * do not access.
+	 */
+	start = qla82xx_pci_set_window(ha, off);
+	if ((start == -1UL) ||
+		(qla82xx_pci_is_same_window(ha, off + size - 1) == 0)) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		qla_printk(KERN_ERR, ha,
+			"%s out of bound pci memory access. "
+			"offset is 0x%llx\n", QLA2XXX_DRIVER_NAME, off);
+		return -1;
+	}
+
+	addr = qla82xx_pci_base_offsetfset(ha, start);
+	if (!addr) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		mem_base = pci_resource_start(ha->pdev, 0);
+		mem_page = start & PAGE_MASK;
+		/* Map two pages whenever user tries to access addresses in two
+		* consecutive pages.
+		*/
+		if (mem_page != ((start + size - 1) & PAGE_MASK))
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
+		else
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
+		if (mem_ptr == 0UL) {
+			*(u8  *)data = 0;
+			return -1;
+		}
+		addr = mem_ptr;
+		addr += start & (PAGE_SIZE - 1);
+		write_lock_irqsave(&ha->hw_lock, flags);
+	}
+
+	switch (size) {
+	case 1:
+		*(u8  *)data = readb(addr);
+		break;
+	case 2:
+		*(u16 *)data = readw(addr);
+		break;
+	case 4:
+		*(u32 *)data = readl(addr);
+		break;
+	case 8:
+		*(u64 *)data = readq(addr);
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+
+	if (mem_ptr)
+		iounmap(mem_ptr);
+	return ret;
+}
+
+static int
+qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
+	u64 off, void *data, int size)
+{
+	unsigned long   flags;
+	void           *addr;
+	int             ret = 0;
+	u64             start;
+	uint8_t         *mem_ptr = NULL;
+	unsigned long   mem_base;
+	unsigned long   mem_page;
+
+	write_lock_irqsave(&ha->hw_lock, flags);
+
+	/*
+	 * If attempting to access unknown address or straddle hw windows,
+	 * do not access.
+	 */
+	start = qla82xx_pci_set_window(ha, off);
+	if ((start == -1UL) ||
+		(qla82xx_pci_is_same_window(ha, off + size - 1) == 0)) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		qla_printk(KERN_ERR, ha,
+			"%s out of bound pci memory access. "
+			"offset is 0x%llx\n", QLA2XXX_DRIVER_NAME, off);
+		return -1;
+	}
+
+	addr = qla82xx_pci_base_offsetfset(ha, start);
+	if (!addr) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		mem_base = pci_resource_start(ha->pdev, 0);
+		mem_page = start & PAGE_MASK;
+		/* Map two pages whenever user tries to access addresses in two
+		 * consecutive pages.
+		 */
+		if (mem_page != ((start + size - 1) & PAGE_MASK))
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE*2);
+		else
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
+		if (mem_ptr == 0UL)
+			return -1;
+
+		addr = mem_ptr;
+		addr += start & (PAGE_SIZE - 1);
+		write_lock_irqsave(&ha->hw_lock, flags);
+	}
+
+	switch (size) {
+	case 1:
+		writeb(*(u8  *)data, addr);
+		break;
+	case 2:
+		writew(*(u16 *)data, addr);
+		break;
+	case 4:
+		writel(*(u32 *)data, addr);
+		break;
+	case 8:
+		writeq(*(u64 *)data, addr);
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+	if (mem_ptr)
+		iounmap(mem_ptr);
+	return ret;
+}
+
+int
+qla82xx_wrmem(struct qla_hw_data *ha, u64 off, void *data, int size)
+{
+	int i, j, ret = 0, loop, sz[2], off0;
+	u32 temp;
+	u64 off8, mem_crb, tmpw, word[2] = {0, 0};
+#define MAX_CTL_CHECK   1000
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX) {
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	} else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_write_direct(ha, off,
+			    data, size);
+	}
+
+	off8 = off & 0xfffffff8;
+	off0 = off & 0x7;
+	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
+	sz[1] = size - sz[0];
+	loop = ((off0 + size - 1) >> 3) + 1;
+
+	if ((size != 8) || (off0 != 0))  {
+		for (i = 0; i < loop; i++) {
+			if (qla82xx_rdmem(ha, off8 + (i << 3), &word[i], 8))
+				return -1;
+		}
+	}
+
+	switch (size) {
+	case 1:
+		tmpw = *((u8 *)data);
+		break;
+	case 2:
+		tmpw = *((u16 *)data);
+		break;
+	case 4:
+		tmpw = *((u32 *)data);
+		break;
+	case 8:
+	default:
+		tmpw = *((u64 *)data);
+		break;
+	}
+
+	word[0] &= ~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+	word[0] |= tmpw << (off0 * 8);
+
+	if (loop == 2) {
+		word[1] &= ~(~0ULL << (sz[1] * 8));
+		word[1] |= tmpw >> (sz[0] * 8);
+	}
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << 3);
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
+		temp = word[i] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
+		temp = (word[i] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
+		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			qla_printk(KERN_WARNING, ha,
+				"%s: Fail to write through agent\n",
+				QLA2XXX_DRIVER_NAME);
+			ret = -1;
+			break;
+		}
+	}
+	return ret;
+}
+
+int
+qla82xx_rdmem(struct qla_hw_data *ha, u64 off, void *data, int size)
+{
+	int i, j = 0, k, start, end, loop, sz[2], off0[2];
+	u32 temp;
+	u64 off8, val, mem_crb, word[2] = {0, 0};
+#define MAX_CTL_CHECK   1000
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_read_direct(ha, off,
+				data, size);
+	}
+
+	off8 = off & 0xfffffff8;
+	off0[0] = off & 0x7;
+	off0[1] = 0;
+	sz[0] = (size < (8 - off0[0])) ? size : (8 - off0[0]);
+	sz[1] = size - sz[0];
+	loop = ((off0[0] + size - 1) >> 3) + 1;
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << 3);
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_HI, temp);
+		temp = MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			qla_printk(KERN_INFO, ha,
+				"%s: Fail to read through agent\n",
+				QLA2XXX_DRIVER_NAME);
+			break;
+		}
+
+		start = off0[i] >> 2;
+		end   = (off0[i] + sz[i] - 1) >> 2;
+		for (k = start; k <= end; k++) {
+			temp = qla82xx_rd_32(ha,
+			    mem_crb + MIU_TEST_AGT_RDDATA(k));
+			word[i] |= ((u64)temp << (32 * k));
+		}
+	}
+
+	if (j >= MAX_CTL_CHECK)
+		return -1;
+
+	if (sz[0] == 8) {
+		val = word[0];
+	} else {
+		val = ((word[0] >> (off0[0] * 8)) & (~(~0ULL << (sz[0] * 8)))) |
+			((word[1] & (~(~0ULL << (sz[1] * 8)))) << (sz[0] * 8));
+	}
+
+	switch (size) {
+	case 1:
+		*(u8  *)data = val;
+		break;
+	case 2:
+		*(u16 *)data = val;
+		break;
+	case 4:
+		*(u32 *)data = val;
+		break;
+	case 8:
+		*(u64 *)data = val;
+		break;
+	}
+	return 0;
+}
+
+#define MTU_FUDGE_FACTOR 100
+unsigned long qla82xx_decode_crb_addr(unsigned long addr)
+{
+	int i;
+	unsigned long base_addr, offset, pci_base;
+
+	if (!qla82xx_crb_table_initialized)
+		qla82xx_crb_addr_transform_setup();
+
+	pci_base = ADDR_ERROR;
+	base_addr = addr & 0xfff00000;
+	offset = addr & 0x000fffff;
+
+	for (i = 0; i < MAX_CRB_XFORM; i++) {
+		if (crb_addr_xform[i] == base_addr) {
+			pci_base = i << 20;
+			break;
+		}
+	}
+	if (pci_base == ADDR_ERROR)
+		return pci_base;
+	return pci_base + offset;
+}
+
+static long rom_max_timeout = 100;
+static long qla82xx_rom_lock_timeout = 100;
+
+int
+qla82xx_rom_lock(struct qla_hw_data *ha)
+{
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore2 from PCI HW block */
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= qla82xx_rom_lock_timeout)
+			return -1;
+		timeout++;
+	}
+	qla82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, ROM_LOCK_DRIVER);
+	return 0;
+}
+
+int
+qla82xx_wait_rom_busy(struct qla_hw_data *ha)
+{
+	long timeout = 0;
+	long done = 0 ;
+
+	while (done == 0) {
+		done = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_STATUS);
+		done &= 4;
+		timeout++;
+		if (timeout >= rom_max_timeout) {
+			DEBUG(qla_printk(KERN_INFO, ha,
+				"%s: Timeout reached waiting for rom busy",
+				QLA2XXX_DRIVER_NAME));
+			return -1;
+		}
+	}
+	return 0;
+}
+
+int
+qla82xx_wait_rom_done(struct qla_hw_data *ha)
+{
+	long timeout = 0;
+	long done = 0 ;
+
+	while (done == 0) {
+		done = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_STATUS);
+		done &= 2;
+		timeout++;
+		if (timeout >= rom_max_timeout) {
+			DEBUG(qla_printk(KERN_INFO, ha,
+				"%s: Timeout reached  waiting for rom done",
+				QLA2XXX_DRIVER_NAME));
+			return -1;
+		}
+	}
+	return 0;
+}
+
+int
+qla82xx_do_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
+{
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, addr);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 3);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, 0xb);
+	qla82xx_wait_rom_busy(ha);
+	if (qla82xx_wait_rom_done(ha)) {
+		qla_printk(KERN_WARNING, ha,
+			"%s: Error waiting for rom done\n",
+			QLA2XXX_DRIVER_NAME);
+		return -1;
+	}
+	/* Reset abyte_cnt and dummy_byte_cnt */
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
+	udelay(10);
+	cond_resched();
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
+	*valp = qla82xx_rd_32(ha, QLA82XX_ROMUSB_ROM_RDATA);
+	return 0;
+}
+
+int
+qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
+{
+	int ret, loops = 0;
+
+	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
+		udelay(100);
+		schedule();
+		loops++;
+	}
+	if (loops >= 50000) {
+		qla_printk(KERN_INFO, ha,
+			"%s: qla82xx_rom_lock failed\n",
+			QLA2XXX_DRIVER_NAME);
+		return -1;
+	}
+	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	return ret;
+}
+
+int
+qla82xx_read_status_reg(struct qla_hw_data *ha, uint32_t *val)
+{
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_RDSR);
+	qla82xx_wait_rom_busy(ha);
+	if (qla82xx_wait_rom_done(ha)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Error waiting for rom done\n");
+		return -1;
+	}
+	*val = qla82xx_rd_32(ha, QLA82XX_ROMUSB_ROM_RDATA);
+	return 0;
+}
+
+int
+qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
+{
+	long timeout = 0;
+	uint32_t done = 1 ;
+	uint32_t val;
+	int ret = 0;
+
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
+	while ((done != 0) && (ret == 0)) {
+		ret = qla82xx_read_status_reg(ha, &val);
+		done = val & 1;
+		timeout++;
+		udelay(10);
+		cond_resched();
+		if (timeout >= 50000) {
+			qla_printk(KERN_WARNING, ha,
+			    "Timeout reached  waiting for write finish");
+			return -1;
+		}
+	}
+	return ret;
+}
+
+int
+qla82xx_flash_set_write_enable(struct qla_hw_data *ha)
+{
+	uint32_t val;
+	qla82xx_wait_rom_busy(ha);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_WREN);
+	qla82xx_wait_rom_busy(ha);
+	if (qla82xx_wait_rom_done(ha))
+		return -1;
+	if (qla82xx_read_status_reg(ha, &val) != 0)
+		return -1;
+	if ((val & 2) != 2)
+		return -1;
+	return 0;
+}
+
+int
+qla82xx_write_status_reg(struct qla_hw_data *ha, uint32_t val)
+{
+	if (qla82xx_flash_set_write_enable(ha))
+		return -1;
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, val);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, 0x1);
+	if (qla82xx_wait_rom_done(ha)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Error waiting for rom done\n");
+		return -1;
+	}
+	return qla82xx_flash_wait_write_finish(ha);
+}
+
+int
+qla82xx_write_disable_flash(struct qla_hw_data *ha)
+{
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_WRDI);
+	if (qla82xx_wait_rom_done(ha)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Error waiting for rom done\n");
+		return -1;
+	}
+	return 0;
+}
+
+int
+ql82xx_rom_lock_d(struct qla_hw_data *ha)
+{
+	int loops = 0;
+	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
+		udelay(100);
+		cond_resched();
+		loops++;
+	}
+	if (loops >= 50000) {
+		qla_printk(KERN_WARNING, ha, "ROM lock failed\n");
+		return -1;
+	}
+	return 0;;
+}
+
+int
+qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
+	uint32_t data)
+{
+	int ret = 0;
+
+	ret = ql82xx_rom_lock_d(ha);
+	if (ret < 0) {
+		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		return ret;
+	}
+
+	if (qla82xx_flash_set_write_enable(ha))
+		goto done_write;
+
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, data);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, flashaddr);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 3);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_PP);
+	qla82xx_wait_rom_busy(ha);
+	if (qla82xx_wait_rom_done(ha)) {
+		qla_printk(KERN_WARNING, ha,
+			"Error waiting for rom done\n");
+		ret = -1;
+		goto done_write;
+	}
+
+	ret = qla82xx_flash_wait_write_finish(ha);
+
+done_write:
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	return ret;
+}
+
+/* This routine does CRB initialize sequence
+ *  to put the ISP into operational state
+ */
+int qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
+{
+	int addr, val;
+	int i ;
+	struct crb_addr_pair *buf;
+	unsigned long off;
+	unsigned offset, n;
+	struct qla_hw_data *ha = vha->hw;
+
+	struct crb_addr_pair {
+		long addr;
+		long data;
+	};
+
+	/* Halt all the indiviual PEGs and other blocks of the ISP */
+	qla82xx_rom_lock(ha);
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+		/* don't reset CAM block on reset */
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
+	else
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+
+	/* Read the signature value from the flash.
+	 * Offset 0: Contain signature (0xcafecafe)
+	 * Offset 4: Offset and number of addr/value pairs
+	 * that present in CRB initialize sequence
+	 */
+	if (qla82xx_rom_fast_read(ha, 0, &n) != 0 || n != 0xcafecafeUL ||
+	    qla82xx_rom_fast_read(ha, 4, &n) != 0) {
+		qla_printk(KERN_WARNING, ha,
+		    "[ERROR] Reading crb_init area: n: %08x\n", n);
+		return -1;
+	}
+
+	/* Offset in flash = lower 16 bits
+	 * Number of enteries = upper 16 bits
+	 */
+	offset = n & 0xffffU;
+	n = (n >> 16) & 0xffffU;
+
+	/* number of addr/value pair should not exceed 1024 enteries */
+	if (n  >= 1024) {
+		qla_printk(KERN_WARNING, ha,
+		    "%s: %s:n=0x%x [ERROR] Card flash not initialized.\n",
+		    QLA2XXX_DRIVER_NAME, __func__, n);
+		return -1;
+	}
+
+	qla_printk(KERN_INFO, ha,
+	    "%s: %d CRB init values found in ROM.\n", QLA2XXX_DRIVER_NAME, n);
+
+	buf = kmalloc(n * sizeof(struct crb_addr_pair), GFP_KERNEL);
+	if (buf == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "%s: [ERROR] Unable to malloc memory.\n",
+		    QLA2XXX_DRIVER_NAME);
+		return -1;
+	}
+
+	for (i = 0; i < n; i++) {
+		if (qla82xx_rom_fast_read(ha, 8*i + 4*offset, &val) != 0 ||
+		    qla82xx_rom_fast_read(ha, 8*i + 4*offset + 4, &addr) != 0) {
+			kfree(buf);
+			return -1;
+		}
+
+		buf[i].addr = addr;
+		buf[i].data = val;
+	}
+
+	for (i = 0; i < n; i++) {
+		/* Translate internal CRB initialization
+		 * address to PCI bus address
+		 */
+		off = qla82xx_decode_crb_addr((unsigned long)buf[i].addr) +
+		    QLA82XX_PCI_CRBSPACE;
+		/* Not all CRB  addr/value pair to be written,
+		 * some of them are skipped
+		 */
+
+		/* skipping cold reboot MAGIC */
+		if (off == QLA82XX_CAM_RAM(0x1fc))
+			continue;
+
+		/* do not reset PCI */
+		if (off == (ROMUSB_GLB + 0xbc))
+			continue;
+
+		/* skip core clock, so that firmware can increase the clock */
+		if (off == (ROMUSB_GLB + 0xc8))
+			continue;
+
+		/* skip the function enable register */
+		if (off == QLA82XX_PCIE_REG(PCIE_SETUP_FUNCTION))
+			continue;
+
+		if (off == QLA82XX_PCIE_REG(PCIE_SETUP_FUNCTION2))
+			continue;
+
+		if ((off & 0x0ff00000) == QLA82XX_CRB_SMB)
+			continue;
+
+		if ((off & 0x0ff00000) == QLA82XX_CRB_DDR_NET)
+			continue;
+
+		if (off == ADDR_ERROR) {
+			qla_printk(KERN_WARNING, ha,
+			    "%s: [ERROR] Unknown addr: 0x%08lx\n",
+			    QLA2XXX_DRIVER_NAME, buf[i].addr);
+			continue;
+		}
+
+		if (off == (QLA82XX_CRB_PEG_NET_1 + 0x18)) {
+			if (!QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision))
+				buf[i].data = 0x1020;
+		}
+
+		qla82xx_wr_32(ha, off, buf[i].data);
+
+		/* ISP requires much bigger delay to settle down,
+		 * else crb_window returns 0xffffffff
+		 */
+		if (off == QLA82XX_ROMUSB_GLB_SW_RESET)
+			msleep(1000);
+
+		/* ISP requires millisec delay between
+		 * successive CRB register updation
+		 */
+		msleep(1);
+	}
+
+	kfree(buf);
+
+	/* Resetting the data and instruction cache */
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_D+0xec, 0x1e);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_D+0x4c, 8);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_I+0x4c, 8);
+
+	/* Clear all protocol processing engines */
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0+0xc, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_1+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_1+0xc, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_2+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_2+0xc, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_3+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_3+0xc, 0);
+	return 0;
+}
+
+int qla82xx_check_for_bad_spd(struct qla_hw_data *ha)
+{
+	u32 val = 0;
+	val = qla82xx_rd_32(ha, BOOT_LOADER_DIMM_STATUS);
+	val &= QLA82XX_BOOT_LOADER_MN_ISSUE;
+	if (val & QLA82XX_PEG_TUNE_MN_SPD_ZEROED) {
+		qla_printk(KERN_INFO, ha,
+			"Memory DIMM SPD not programmed. "
+			" Assumed valid.\n");
+		return 1;
+	} else if (val) {
+		qla_printk(KERN_INFO, ha,
+			"Memory DIMM type incorrect.Info:%08X.\n", val);
+		return 2;
+	}
+	return 0;
+}
+
+int
+qla82xx_fw_load_from_flash(struct qla_hw_data *ha)
+{
+	int  i;
+	long size = 0;
+	long flashaddr = BOOTLD_START, memaddr = BOOTLD_START;
+	u64 data;
+	u32 high, low;
+	size = (IMAGE_START - BOOTLD_START) / 8;
+
+	for (i = 0; i < size; i++) {
+		if ((qla82xx_rom_fast_read(ha, flashaddr, (int *)&low)) ||
+		    (qla82xx_rom_fast_read(ha, flashaddr + 4, (int *)&high))) {
+			return -1;
+		}
+		data = ((u64)high << 32) | low ;
+		qla82xx_pci_mem_write_2M(ha, memaddr, &data, 8);
+		flashaddr += 8;
+		memaddr += 8;
+
+		if (i % 0x1000 == 0)
+			msleep(1);
+	}
+	udelay(100);
+	read_lock(&ha->hw_lock);
+	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
+		qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
+	} else {
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001d);
+	}
+	read_unlock(&ha->hw_lock);
+	return 0;
+}
+
+int
+qla82xx_pci_mem_read_2M(struct qla_hw_data *ha,
+		u64 off, void *data, int size)
+{
+	int i, j = 0, k, start, end, loop, sz[2], off0[2];
+	int	      shift_amount;
+	uint32_t      temp;
+	uint64_t      off8, val, mem_crb, word[2] = {0, 0};
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_read_direct(ha,
+			    off, data, size);
+	}
+
+	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
+		off8 = off & 0xfffffff0;
+		off0[0] = off & 0xf;
+		sz[0] = (size < (16 - off0[0])) ? size : (16 - off0[0]);
+		shift_amount = 4;
+	} else {
+		off8 = off & 0xfffffff8;
+		off0[0] = off & 0x7;
+		sz[0] = (size < (8 - off0[0])) ? size : (8 - off0[0]);
+		shift_amount = 4;
+	}
+	loop = ((off0[0] + size - 1) >> shift_amount) + 1;
+	off0[1] = 0;
+	sz[1] = size - sz[0];
+
+	/*
+	 * don't lock here - write_wx gets the lock if each time
+	 * write_lock_irqsave(&adapter->adapter_lock, flags);
+	 * netxen_nic_pci_change_crbwindow_128M(adapter, 0);
+	 */
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << shift_amount);
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_HI, temp);
+		temp = MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			if (printk_ratelimit())
+				dev_err(&ha->pdev->dev,
+				    "failed to read through agent\n");
+			break;
+		}
+
+		start = off0[i] >> 2;
+		end   = (off0[i] + sz[i] - 1) >> 2;
+		for (k = start; k <= end; k++) {
+			temp = qla82xx_rd_32(ha,
+					mem_crb + MIU_TEST_AGT_RDDATA(k));
+			word[i] |= ((uint64_t)temp << (32 * (k & 1)));
+		}
+	}
+
+	/*
+	 * netxen_nic_pci_change_crbwindow_128M(adapter, 1);
+	 * write_unlock_irqrestore(&adapter->adapter_lock, flags);
+	 */
+
+	if (j >= MAX_CTL_CHECK)
+		return -1;
+
+	if ((off0[0] & 7) == 0) {
+		val = word[0];
+	} else {
+		val = ((word[0] >> (off0[0] * 8)) & (~(~0ULL << (sz[0] * 8)))) |
+			((word[1] & (~(~0ULL << (sz[1] * 8)))) << (sz[0] * 8));
+	}
+
+	switch (size) {
+	case 1:
+		*(uint8_t  *)data = val;
+		break;
+	case 2:
+		*(uint16_t *)data = val;
+		break;
+	case 4:
+		*(uint32_t *)data = val;
+		break;
+	case 8:
+		*(uint64_t *)data = val;
+		break;
+	}
+	return 0;
+}
+
+int
+qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
+		u64 off, void *data, int size)
+{
+	int i, j, ret = 0, loop, sz[2], off0;
+	int scale, shift_amount, p3p, startword;
+	uint32_t temp;
+	uint64_t off8, mem_crb, tmpw, word[2] = {0, 0};
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_write_direct(ha,
+			    off, data, size);
+	}
+
+	off0 = off & 0x7;
+	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
+	sz[1] = size - sz[0];
+
+	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
+		off8 = off & 0xfffffff0;
+		loop = (((off & 0xf) + size - 1) >> 4) + 1;
+		shift_amount = 4;
+		scale = 2;
+		p3p = 1;
+		startword = (off & 0xf)/8;
+	} else {
+		off8 = off & 0xfffffff8;
+		loop = ((off0 + size - 1) >> 3) + 1;
+		shift_amount = 3;
+		scale = 1;
+		p3p = 0;
+		startword = 0;
+	}
+
+	if (p3p || (size != 8) || (off0 != 0)) {
+		for (i = 0; i < loop; i++) {
+			if (qla82xx_pci_mem_read_2M(ha, off8 +
+			    (i << shift_amount), &word[i * scale], 8))
+				return -1;
+		}
+	}
+
+	switch (size) {
+	case 1:
+		tmpw = *((uint8_t *)data);
+		break;
+	case 2:
+		tmpw = *((uint16_t *)data);
+		break;
+	case 4:
+		tmpw = *((uint32_t *)data);
+		break;
+	case 8:
+	default:
+		tmpw = *((uint64_t *)data);
+		break;
+	}
+
+	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
+		if (sz[0] == 8) {
+			word[startword] = tmpw;
+		} else {
+			word[startword] &=
+				~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+			word[startword] |= tmpw << (off0 * 8);
+		}
+		if (sz[1] != 0) {
+			word[startword+1] &= ~(~0ULL << (sz[1] * 8));
+			word[startword+1] |= tmpw >> (sz[0] * 8);
+		}
+	} else {
+		word[startword] &= ~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+		word[startword] |= tmpw << (off0 * 8);
+
+		if (loop == 2) {
+			word[1] &= ~(~0ULL << (sz[1] * 8));
+			word[1] |= tmpw >> (sz[0] * 8);
+		}
+	}
+
+	/*
+	 * don't lock here - write_wx gets the lock if each time
+	 * write_lock_irqsave(&adapter->adapter_lock, flags);
+	 * netxen_nic_pci_change_crbwindow_128M(adapter, 0);
+	 */
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << shift_amount);
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
+		temp = word[i * scale] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
+		temp = (word[i * scale] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
+		if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
+			temp = word[i*scale + 1] & 0xffffffff;
+			qla82xx_wr_32(ha, mem_crb +
+			    MIU_TEST_AGT_WRDATA_UPPER_LO, temp);
+			temp = (word[i*scale + 1] >> 32) & 0xffffffff;
+			qla82xx_wr_32(ha, mem_crb +
+			    MIU_TEST_AGT_WRDATA_UPPER_HI, temp);
+		}
+
+		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			if (printk_ratelimit())
+				dev_err(&ha->pdev->dev,
+				    "failed to write through agent\n");
+			ret = -1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/* PCI related functions */
+char *
+qla82xx_pci_info_str(struct scsi_qla_host *vha, char *str)
+{
+	int pcie_reg;
+	struct qla_hw_data *ha = vha->hw;
+	char lwstr[6];
+	uint16_t lnk;
+
+	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pci_read_config_word(ha->pdev, pcie_reg + PCI_EXP_LNKSTA, &lnk);
+	ha->link_width = (lnk >> 4) & 0x3f;
+
+	strcpy(str, "PCIe (");
+	strcat(str, "2.5Gb/s ");
+	snprintf(lwstr, sizeof(lwstr), "x%d)", ha->link_width);
+	strcat(str, lwstr);
+	return str;
+}
+
+int qla82xx_pci_region_offset(struct pci_dev *pdev, int region)
+{
+	unsigned long val = 0;
+	u32 control;
+
+	switch (region) {
+	case 0:
+		val = 0;
+		break;
+	case 1:
+		pci_read_config_dword(pdev, QLA82XX_PCI_REG_MSIX_TBL, &control);
+		val = control + QLA82XX_MSIX_TBL_SPACE;
+		break;
+	}
+	return val;
+}
+
+int qla82xx_pci_region_len(struct pci_dev *pdev, int region)
+{
+	unsigned long val = 0;
+	u32 control;
+	switch (region) {
+	case 0:
+		pci_read_config_dword(pdev, QLA82XX_PCI_REG_MSIX_TBL, &control);
+		val = control;
+		break;
+	case 1:
+		val = pci_resource_len(pdev, 0) -
+		    qla82xx_pci_region_offset(pdev, 1);
+		break;
+	}
+	return val;
+}
+
+int
+qla82xx_iospace_config(struct qla_hw_data *ha)
+{
+	uint32_t len = 0;
+
+	if (pci_request_regions(ha->pdev, QLA2XXX_DRIVER_NAME)) {
+		qla_printk(KERN_WARNING, ha,
+			"Failed to reserve selected regions (%s)\n",
+			pci_name(ha->pdev));
+		goto iospace_error_exit;
+	}
+
+	/* Use MMIO operations for all accesses. */
+	if (!(pci_resource_flags(ha->pdev, 0) & IORESOURCE_MEM)) {
+		qla_printk(KERN_ERR, ha,
+			"region #0 not an MMIO resource (%s), aborting\n",
+			pci_name(ha->pdev));
+		goto iospace_error_exit;
+	}
+
+	len = pci_resource_len(ha->pdev, 0);
+	ha->nx_pcibase =
+	    (unsigned long)ioremap(pci_resource_start(ha->pdev, 0), len);
+	if (!ha->nx_pcibase) {
+		qla_printk(KERN_ERR, ha,
+		    "cannot remap pcibase MMIO (%s), aborting\n",
+		    pci_name(ha->pdev));
+		pci_release_regions(ha->pdev);
+		goto iospace_error_exit;
+	}
+
+	/* Mapping of IO base pointer */
+	ha->iobase = (device_reg_t __iomem *)((uint8_t *)ha->nx_pcibase +
+	    0xbc000 + (ha->pdev->devfn << 11));
+
+	if (!ql2xdbwr) {
+		ha->nxdb_wr_ptr =
+		    (unsigned long)ioremap((pci_resource_start(ha->pdev, 4) +
+		    (ha->pdev->devfn << 12)), 4);
+		if (!ha->nxdb_wr_ptr) {
+			qla_printk(KERN_ERR, ha,
+			    "cannot remap MMIO (%s), aborting\n",
+			    pci_name(ha->pdev));
+			pci_release_regions(ha->pdev);
+			goto iospace_error_exit;
+		}
+
+		/* Mapping of IO base pointer,
+		 * door bell read and write pointer
+		 */
+		ha->nxdb_rd_ptr = (uint8_t *) ha->nx_pcibase + (512 * 1024) +
+		    (ha->pdev->devfn * 8);
+	} else {
+		ha->nxdb_wr_ptr = (ha->pdev->devfn == 6 ?
+			QLA82XX_CAMRAM_DB1 :
+			QLA82XX_CAMRAM_DB2);
+	}
+
+	ha->max_req_queues = ha->max_rsp_queues = 1;
+	ha->msix_count = ha->max_rsp_queues + 1;
+	return 0;
+
+iospace_error_exit:
+	return -ENOMEM;
+}
+
+/* GS related functions */
+
+/* Initialization related functions */
+
+/**
+ * qla82xx_pci_config() - Setup ISP82xx PCI configuration registers.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+*/
+int
+qla82xx_pci_config(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	int ret;
+
+	pci_set_master(ha->pdev);
+	ret = pci_set_mwi(ha->pdev);
+	ha->chip_revision = ha->pdev->revision;
+	return 0;
+}
+
+/**
+ * qla82xx_reset_chip() - Setup ISP82xx PCI configuration registers.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+void
+qla82xx_reset_chip(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	ha->isp_ops->disable_intrs(ha);
+}
+
+void qla82xx_config_rings(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_82xx __iomem *reg = &ha->iobase->isp82;
+	struct init_cb_81xx *icb;
+	struct req_que *req = ha->req_q_map[0];
+	struct rsp_que *rsp = ha->rsp_q_map[0];
+
+	/* Setup ring parameters in initialization control block. */
+	icb = (struct init_cb_81xx *)ha->init_cb;
+	icb->request_q_outpointer = __constant_cpu_to_le16(0);
+	icb->response_q_inpointer = __constant_cpu_to_le16(0);
+	icb->request_q_length = cpu_to_le16(req->length);
+	icb->response_q_length = cpu_to_le16(rsp->length);
+	icb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
+	icb->request_q_address[1] = cpu_to_le32(MSD(req->dma));
+	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
+	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
+
+	icb->version = 1;
+	icb->frame_payload_size = 2112;
+	icb->execution_throttle = 8;
+	icb->exchange_count = 128;
+	icb->login_retry_count = 8;
+
+	WRT_REG_DWORD((unsigned long  __iomem *)&reg->req_q_out[0], 0);
+	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_in[0], 0);
+	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_out[0], 0);
+}
+
+int qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
+{
+	u64 *ptr64;
+	u32 i, flashaddr, size;
+	__le64 data;
+
+	size = (IMAGE_START - BOOTLD_START) / 8;
+
+	ptr64 = (u64 *)&ha->hablob->fw->data[BOOTLD_START];
+	flashaddr = BOOTLD_START;
+
+	for (i = 0; i < size; i++) {
+		data = cpu_to_le64(ptr64[i]);
+		qla82xx_pci_mem_write_2M(ha, flashaddr, &data, 8);
+		flashaddr += 8;
+	}
+
+	size = *(u32 *)&ha->hablob->fw->data[FW_SIZE_OFFSET];
+	size = (__force u32)cpu_to_le32(size) / 8;
+	ptr64 = (u64 *)&ha->hablob->fw->data[IMAGE_START];
+	flashaddr = FLASH_ADDR_START;
+
+	for (i = 0; i < size; i++) {
+		data = cpu_to_le64(ptr64[i]);
+
+		if (qla82xx_pci_mem_write_2M(ha, flashaddr, &data, 8))
+			return -EIO;
+		flashaddr += 8;
+	}
+
+	/* Write a magic value to CAMRAM register
+	 * at a specified offset to indicate
+	 * that all data is written and
+	 * ready for firmware to initialize.
+	 */
+	qla82xx_wr_32(ha, QLA82XX_CAM_RAM(0x1fc), 0x12345678);
+
+	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
+		qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
+	} else
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001d);
+	return 0;
+}
+
+int qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
+{
+	u32 val = 0;
+	int retries = 60;
+
+	do {
+		read_lock(&ha->hw_lock);
+		val = qla82xx_rd_32(ha, CRB_CMDPEG_STATE);
+		read_unlock(&ha->hw_lock);
+
+		switch (val) {
+		case PHAN_INITIALIZE_COMPLETE:
+		case PHAN_INITIALIZE_ACK:
+			return QLA_SUCCESS;
+		case PHAN_INITIALIZE_FAILED:
+			break;
+		default:
+			break;
+		}
+		qla_printk(KERN_WARNING, ha,
+			"CRB_CMDPEG_STATE: 0x%x and retries: 0x%x\n",
+			val, retries);
+
+		msleep(500);
+
+	} while (--retries);
+
+	qla_printk(KERN_INFO, ha,
+	    "Cmd Peg initialization failed: 0x%x.\n", val);
+
+	qla82xx_check_for_bad_spd(ha);
+	val = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_PEGTUNE_DONE);
+	read_lock(&ha->hw_lock);
+	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, PHAN_INITIALIZE_FAILED);
+	read_unlock(&ha->hw_lock);
+	return QLA_FUNCTION_FAILED;
+}
+
+int qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
+{
+	u32 val = 0;
+	int retries = 60;
+
+	do {
+		read_lock(&ha->hw_lock);
+		val = qla82xx_rd_32(ha, CRB_RCVPEG_STATE);
+		read_unlock(&ha->hw_lock);
+
+		switch (val) {
+		case PHAN_INITIALIZE_COMPLETE:
+		case PHAN_INITIALIZE_ACK:
+			return QLA_SUCCESS;
+		case PHAN_INITIALIZE_FAILED:
+			break;
+		default:
+			break;
+		}
+
+		qla_printk(KERN_WARNING, ha,
+			"CRB_RCVPEG_STATE: 0x%x and retries: 0x%x\n",
+			val, retries);
+
+		msleep(500);
+
+	} while (--retries);
+
+	qla_printk(KERN_INFO, ha,
+		"Rcv Peg initialization failed: 0x%x.\n", val);
+	read_lock(&ha->hw_lock);
+	qla82xx_wr_32(ha, CRB_RCVPEG_STATE, PHAN_INITIALIZE_FAILED);
+	read_unlock(&ha->hw_lock);
+	return QLA_FUNCTION_FAILED;
+}
+
+/* ISR related functions */
+uint32_t qla82xx_isr_int_target_mask_enable[8] = {
+	ISR_INT_TARGET_MASK, ISR_INT_TARGET_MASK_F1,
+	ISR_INT_TARGET_MASK_F2, ISR_INT_TARGET_MASK_F3,
+	ISR_INT_TARGET_MASK_F4, ISR_INT_TARGET_MASK_F5,
+	ISR_INT_TARGET_MASK_F7, ISR_INT_TARGET_MASK_F7
+};
+
+uint32_t qla82xx_isr_int_target_status[8] = {
+	ISR_INT_TARGET_STATUS, ISR_INT_TARGET_STATUS_F1,
+	ISR_INT_TARGET_STATUS_F2, ISR_INT_TARGET_STATUS_F3,
+	ISR_INT_TARGET_STATUS_F4, ISR_INT_TARGET_STATUS_F5,
+	ISR_INT_TARGET_STATUS_F7, ISR_INT_TARGET_STATUS_F7
+};
+
+static struct qla82xx_legacy_intr_set legacy_intr[] = \
+	QLA82XX_LEGACY_INTR_CONFIG;
+
+/*
+ * qla82xx_mbx_completion() - Process mailbox command completions.
+ * @ha: SCSI driver HA context
+ * @mb0: Mailbox0 register
+ */
+void
+qla82xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
+{
+	uint16_t	cnt;
+	uint16_t __iomem *wptr;
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_82xx __iomem *reg = &ha->iobase->isp82;
+	wptr = (uint16_t __iomem *)&reg->mailbox_out[1];
+
+	/* Load return mailbox registers. */
+	ha->flags.mbox_int = 1;
+	ha->mailbox_out[0] = mb0;
+
+	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
+		ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
+		wptr++;
+	}
+
+	if (ha->mcp) {
+		DEBUG3_11(printk(KERN_INFO "%s(%ld): "
+			"Got mailbox completion. cmd=%x.\n",
+			__func__, vha->host_no, ha->mcp->mb[0]));
+	} else {
+		qla_printk(KERN_INFO, ha,
+			"%s(%ld): MBX pointer ERROR!\n",
+			__func__, vha->host_no);
+	}
+}
+
+/*
+ * qla82xx_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
+ * @irq:
+ * @dev_id: SCSI driver HA context
+ * @regs:
+ *
+ * Called by system whenever the host adapter generates an interrupt.
+ *
+ * Returns handled flag.
+ */
+irqreturn_t
+qla82xx_intr_handler(int irq, void *dev_id)
+{
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
+	struct device_reg_82xx __iomem *reg;
+	int status = 0, status1 = 0;
+	unsigned long	flags;
+	unsigned long	iter;
+	uint32_t	stat;
+	uint16_t	mb[4];
+
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = rsp->hw;
+
+	if (!ha->flags.msi_enabled) {
+		status = qla82xx_rd_32(ha, ISR_INT_VECTOR);
+		if (!(status & ha->nx_legacy_intr.int_vec_bit))
+			return IRQ_NONE;
+
+		status1 = qla82xx_rd_32(ha, ISR_INT_STATE_REG);
+		if (!ISR_IS_LEGACY_INTR_TRIGGERED(status1))
+			return IRQ_NONE;
+	}
+
+	/* clear the interrupt */
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_status_reg, 0xffffffff);
+
+	/* read twice to ensure write is flushed */
+	qla82xx_rd_32(ha, ISR_INT_VECTOR);
+	qla82xx_rd_32(ha, ISR_INT_VECTOR);
+
+	reg = &ha->iobase->isp82;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	vha = pci_get_drvdata(ha->pdev);
+	for (iter = 1; iter--; ) {
+
+		if (RD_REG_DWORD(&reg->host_int)) {
+			stat = RD_REG_DWORD(&reg->host_status);
+			if (stat & HSRX_RISC_PAUSED) {
+				if (pci_channel_offline(ha->pdev))
+					break;
+
+				qla_printk(KERN_INFO, ha, "RISC paused\n");
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+				break;
+			} else if ((stat & HSRX_RISC_INT) == 0)
+				break;
+
+			switch (stat & 0xff) {
+			case 0x1:
+			case 0x2:
+			case 0x10:
+			case 0x11:
+				qla82xx_mbx_completion(vha, MSW(stat));
+				status |= MBX_INTERRUPT;
+				break;
+			case 0x12:
+				mb[0] = MSW(stat);
+				mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
+				mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
+				mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+				qla2x00_async_event(vha, rsp, mb);
+				break;
+			case 0x13:
+				qla24xx_process_response_queue(vha, rsp);
+				break;
+			default:
+				DEBUG2(printk("scsi(%ld): "
+					" Unrecognized interrupt type (%d).\n",
+					vha->host_no, stat & 0xff));
+				break;
+			}
+		}
+		WRT_REG_DWORD(&reg->host_int, 0);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (!ha->flags.msi_enabled)
+		qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
+
+#ifdef QL_DEBUG_LEVEL_17
+	if (!irq && ha->flags.eeh_busy)
+		qla_printk(KERN_WARNING, ha,
+		    "isr: status %x, cmd_flags %lx, mbox_int %x, stat %x\n",
+		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
+#endif
+
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
+	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		complete(&ha->mbx_intr_comp);
+	}
+	return IRQ_HANDLED;
+}
+
+irqreturn_t
+qla82xx_msix_default(int irq, void *dev_id)
+{
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
+	struct device_reg_82xx __iomem *reg;
+	int status = 0;
+	unsigned long flags;
+	uint32_t stat;
+	uint16_t mb[4];
+
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = rsp->hw;
+
+	reg = &ha->iobase->isp82;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	vha = pci_get_drvdata(ha->pdev);
+	do {
+		if (RD_REG_DWORD(&reg->host_int)) {
+			stat = RD_REG_DWORD(&reg->host_status);
+			if (stat & HSRX_RISC_PAUSED) {
+				if (pci_channel_offline(ha->pdev))
+					break;
+
+				qla_printk(KERN_INFO, ha, "RISC paused\n");
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+				break;
+			} else if ((stat & HSRX_RISC_INT) == 0)
+				break;
+
+			switch (stat & 0xff) {
+			case 0x1:
+			case 0x2:
+			case 0x10:
+			case 0x11:
+				qla82xx_mbx_completion(vha, MSW(stat));
+				status |= MBX_INTERRUPT;
+				break;
+			case 0x12:
+				mb[0] = MSW(stat);
+				mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
+				mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
+				mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+				qla2x00_async_event(vha, rsp, mb);
+				break;
+			case 0x13:
+				qla24xx_process_response_queue(vha, rsp);
+				break;
+			default:
+				DEBUG2(printk("scsi(%ld): "
+					" Unrecognized interrupt type (%d).\n",
+					vha->host_no, stat & 0xff));
+				break;
+			}
+		}
+		WRT_REG_DWORD(&reg->host_int, 0);
+	} while (0);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+#ifdef QL_DEBUG_LEVEL_17
+	if (!irq && ha->flags.eeh_busy)
+		qla_printk(KERN_WARNING, ha,
+			"isr: status %x, cmd_flags %lx, mbox_int %x, stat %x\n",
+			status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
+#endif
+
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
+		(status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+			set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+			complete(&ha->mbx_intr_comp);
+	}
+	return IRQ_HANDLED;
+}
+
+irqreturn_t
+qla82xx_msix_rsp_q(int irq, void *dev_id)
+{
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
+	struct device_reg_82xx __iomem *reg;
+
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer\n", __func__);
+		return IRQ_NONE;
+	}
+
+	ha = rsp->hw;
+	reg = &ha->iobase->isp82;
+	spin_lock_irq(&ha->hardware_lock);
+	vha = pci_get_drvdata(ha->pdev);
+	qla24xx_process_response_queue(vha, rsp);
+	WRT_REG_DWORD(&reg->host_int, 0);
+	spin_unlock_irq(&ha->hardware_lock);
+	return IRQ_HANDLED;
+}
+
+void
+qla82xx_poll(int irq, void *dev_id)
+{
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
+	struct device_reg_82xx __iomem *reg;
+	int status = 0;
+	uint32_t stat;
+	uint16_t mb[4];
+	unsigned long flags;
+
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer\n", __func__);
+		return;
+	}
+	ha = rsp->hw;
+
+	reg = &ha->iobase->isp82;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	vha = pci_get_drvdata(ha->pdev);
+
+	if (RD_REG_DWORD(&reg->host_int)) {
+		stat = RD_REG_DWORD(&reg->host_status);
+		switch (stat & 0xff) {
+		case 0x1:
+		case 0x2:
+		case 0x10:
+		case 0x11:
+			qla82xx_mbx_completion(vha, MSW(stat));
+			status |= MBX_INTERRUPT;
+			break;
+		case 0x12:
+			mb[0] = MSW(stat);
+			mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
+			mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
+			mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+			qla2x00_async_event(vha, rsp, mb);
+			break;
+		case 0x13:
+			qla24xx_process_response_queue(vha, rsp);
+			break;
+		default:
+			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
+				"(%d).\n",
+				vha->host_no, stat & 0xff));
+			break;
+		}
+	}
+	WRT_REG_DWORD(&reg->host_int, 0);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+void
+qla82xx_enable_intrs(struct qla_hw_data *ha)
+{
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	qla82xx_mbx_intr_enable(vha);
+	spin_lock_irq(&ha->hardware_lock);
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
+	spin_unlock_irq(&ha->hardware_lock);
+	ha->interrupts_on = 1;
+}
+
+void
+qla82xx_disable_intrs(struct qla_hw_data *ha)
+{
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	qla82xx_mbx_intr_disable(vha);
+	spin_lock_irq(&ha->hardware_lock);
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0x0400);
+	spin_unlock_irq(&ha->hardware_lock);
+	ha->interrupts_on = 0;
+}
+
+void qla82xx_init_flags(struct qla_hw_data *ha)
+{
+	struct qla82xx_legacy_intr_set *nx_legacy_intr;
+
+	/* ISP 8021 initializations */
+	rwlock_init(&ha->hw_lock);
+	ha->qdr_sn_window = -1;
+	ha->ddr_mn_window = -1;
+	ha->curr_window = 255;
+	ha->portnum = PCI_FUNC(ha->pdev->devfn);
+	nx_legacy_intr = &legacy_intr[ha->portnum];
+	ha->nx_legacy_intr.int_vec_bit = nx_legacy_intr->int_vec_bit;
+	ha->nx_legacy_intr.tgt_status_reg = nx_legacy_intr->tgt_status_reg;
+	ha->nx_legacy_intr.tgt_mask_reg = nx_legacy_intr->tgt_mask_reg;
+	ha->nx_legacy_intr.pci_int_reg = nx_legacy_intr->pci_int_reg;
+}
+
+static inline void
+qla82xx_set_drv_active(scsi_qla_host_t *vha)
+{
+	uint32_t drv_active;
+	struct qla_hw_data *ha = vha->hw;
+
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+
+	/* If reset value is all FF's, initialize DRV_ACTIVE */
+	if (drv_active == 0xffffffff) {
+		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, 0);
+		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	}
+	drv_active |= (1 << (ha->portnum * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, drv_active);
+}
+
+inline void
+qla82xx_clear_drv_active(struct qla_hw_data *ha)
+{
+	uint32_t drv_active;
+
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	drv_active &= ~(1 << (ha->portnum * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, drv_active);
+}
+
+static inline int
+qla82xx_need_reset(struct qla_hw_data *ha)
+{
+	uint32_t drv_state;
+	int rval;
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	rval = drv_state & (1 << (ha->portnum * 4));
+	return rval;
+}
+
+static inline void
+qla82xx_set_rst_ready(struct qla_hw_data *ha)
+{
+	uint32_t drv_state;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+
+	/* If reset value is all FF's, initialize DRV_STATE */
+	if (drv_state == 0xffffffff) {
+		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
+		drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	}
+	drv_state |= (QLA82XX_DRVST_RST_RDY << (ha->portnum * 4));
+	qla_printk(KERN_INFO, ha,
+		"%s(%ld):drv_state = 0x%x\n",
+		__func__, vha->host_no, drv_state);
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, drv_state);
+}
+
+static inline void
+qla82xx_clear_rst_ready(struct qla_hw_data *ha)
+{
+	uint32_t drv_state;
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	drv_state &= ~(QLA82XX_DRVST_RST_RDY << (ha->portnum * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, drv_state);
+}
+
+static inline void
+qla82xx_set_qsnt_ready(struct qla_hw_data *ha)
+{
+	uint32_t qsnt_state;
+
+	qsnt_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	qsnt_state |= (QLA82XX_DRVST_QSNT_RDY << (ha->portnum * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, qsnt_state);
+}
+
+int qla82xx_load_fw(scsi_qla_host_t *vha)
+{
+	int rst;
+	struct fw_blob *blob;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Put both the PEG CMD and RCV PEG to default state
+	 * of 0 before resetting the hardware
+	 */
+	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, 0);
+	qla82xx_wr_32(ha, CRB_RCVPEG_STATE, 0);
+
+	if (qla82xx_pinit_from_rom(vha) != QLA_SUCCESS) {
+		qla_printk(KERN_ERR, ha,
+			"%s: Error during CRB Initialization\n", __func__);
+		return QLA_FUNCTION_FAILED;
+	}
+	udelay(500);
+
+	/* Bring QM and CAMRAM out of reset */
+	rst = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET);
+	rst &= ~((1 << 28) | (1 << 24));
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, rst);
+
+	/*
+	 * FW Load priority:
+	 * 1) Operational firmware residing in flash.
+	 * 2) Firmware via request-firmware interface (.bin file).
+	 */
+	if (ql2xfwloadbin == 2)
+		goto try_blob_fw;
+
+	qla_printk(KERN_INFO, ha,
+		"Attempting to load firmware from flash\n");
+
+	if (qla82xx_fw_load_from_flash(ha) == QLA_SUCCESS) {
+		qla_printk(KERN_ERR, ha,
+			"Firmware loaded successfully from flash\n");
+		return QLA_SUCCESS;
+	}
+try_blob_fw:
+	qla_printk(KERN_INFO, ha,
+	    "Attempting to load firmware from blob\n");
+
+	/* Load firmware blob. */
+	blob = ha->hablob = qla2x00_request_firmware(vha);
+	if (!blob) {
+		qla_printk(KERN_ERR, ha,
+			"Firmware image not present.\n");
+		goto fw_load_failed;
+	}
+
+	if (qla82xx_fw_load_from_blob(ha) == QLA_SUCCESS) {
+		qla_printk(KERN_ERR, ha,
+			"%s: Firmware loaded successfully "
+			" from binary blob\n", __func__);
+		return QLA_SUCCESS;
+	} else {
+		qla_printk(KERN_ERR, ha,
+		    "Firmware load failed from binary blob\n");
+		blob->fw = NULL;
+		blob = NULL;
+		goto fw_load_failed;
+	}
+	return QLA_SUCCESS;
+
+fw_load_failed:
+	return QLA_FUNCTION_FAILED;
+}
+
+static int
+qla82xx_start_firmware(scsi_qla_host_t *vha)
+{
+	int           pcie_cap;
+	uint16_t      lnk;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* scrub dma mask expansion register */
+	qla82xx_wr_32(ha, CRB_DMA_SHIFT, 0x55555555);
+
+	/* Overwrite stale initialization register values */
+	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS1, 0);
+	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS2, 0);
+
+	if (qla82xx_load_fw(vha) != QLA_SUCCESS) {
+		qla_printk(KERN_INFO, ha,
+			"%s: Error trying to start fw!\n", __func__);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	/* Handshake with the card before we register the devices. */
+	if (qla82xx_check_cmdpeg_state(ha) != QLA_SUCCESS) {
+		qla_printk(KERN_INFO, ha,
+			"%s: Error during card handshake!\n", __func__);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	/* Negotiated Link width */
+	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
+	ha->link_width = (lnk >> 4) & 0x3f;
+
+	/* Synchronize with Receive peg */
+	return qla82xx_check_rcvpeg_state(ha);
+}
+
+static inline int
+qla2xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
+	uint16_t tot_dsds)
+{
+	uint32_t *cur_dsd = NULL;
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct scsi_cmnd *cmd;
+	struct	scatterlist *cur_seg;
+	uint32_t *dsd_seg;
+	void *next_dsd;
+	uint8_t avail_dsds;
+	uint8_t first_iocb = 1;
+	uint32_t dsd_list_len;
+	struct dsd_dma *dsd_ptr;
+	struct ct6_dsd *ctx;
+
+	cmd = sp->cmd;
+
+	/* Update entry type to indicate Command Type 3 IOCB */
+	*((uint32_t *)(&cmd_pkt->entry_type)) =
+		__constant_cpu_to_le32(COMMAND_TYPE_6);
+
+	/* No data transfer */
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
+		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		return 0;
+	}
+
+	vha = sp->fcport->vha;
+	ha = vha->hw;
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		cmd_pkt->control_flags =
+		    __constant_cpu_to_le16(CF_WRITE_DATA);
+		ha->qla_stats.output_bytes += scsi_bufflen(cmd);
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		cmd_pkt->control_flags =
+		    __constant_cpu_to_le16(CF_READ_DATA);
+		ha->qla_stats.input_bytes += scsi_bufflen(cmd);
+	}
+
+	cur_seg = scsi_sglist(cmd);
+	ctx = sp->ctx;
+
+	while (tot_dsds) {
+		avail_dsds = (tot_dsds > QLA_DSDS_PER_IOCB) ?
+		    QLA_DSDS_PER_IOCB : tot_dsds;
+		tot_dsds -= avail_dsds;
+		dsd_list_len = (avail_dsds + 1) * QLA_DSD_SIZE;
+
+		dsd_ptr = list_first_entry(&ha->gbl_dsd_list,
+		    struct dsd_dma, list);
+		next_dsd = dsd_ptr->dsd_addr;
+		list_del(&dsd_ptr->list);
+		ha->gbl_dsd_avail--;
+		list_add_tail(&dsd_ptr->list, &ctx->dsd_list);
+		ctx->dsd_use_cnt++;
+		ha->gbl_dsd_inuse++;
+
+		if (first_iocb) {
+			first_iocb = 0;
+			dsd_seg = (uint32_t *)&cmd_pkt->fcp_data_dseg_address;
+			*dsd_seg++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
+			*dsd_seg++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
+			*dsd_seg++ = dsd_list_len;
+		} else {
+			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = dsd_list_len;
+		}
+		cur_dsd = (uint32_t *)next_dsd;
+		while (avail_dsds) {
+			dma_addr_t	sle_dma;
+
+			sle_dma = sg_dma_address(cur_seg);
+			*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+			*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+			cur_seg++;
+			avail_dsds--;
+		}
+	}
+
+	/* Null termination */
+	*cur_dsd++ =  0;
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	cmd_pkt->control_flags |= CF_DATA_SEG_DESCR_ENABLE;
+	return 0;
+}
+
+/*
+ * qla82xx_calc_dsd_lists() - Determine number of DSD list required
+ * for Command Type 6.
+ *
+ * @dsds: number of data segment decriptors needed
+ *
+ * Returns the number of dsd list needed to store @dsds.
+ */
+inline uint16_t
+qla82xx_calc_dsd_lists(uint16_t dsds)
+{
+	uint16_t dsd_lists = 0;
+
+	dsd_lists = (dsds/QLA_DSDS_PER_IOCB);
+	if (dsds % QLA_DSDS_PER_IOCB)
+		dsd_lists++;
+	return dsd_lists;
+}
+
+/*
+ * qla82xx_start_scsi() - Send a SCSI command to the ISP
+ * @sp: command to send to the ISP
+ *
+ * Returns non-zero if a failure occured, else zero.
+ */
+int
+qla82xx_start_scsi(srb_t *sp)
+{
+	int		ret, nseg;
+	unsigned long   flags;
+	struct scsi_cmnd *cmd;
+	uint32_t	*clr_ptr;
+	uint32_t        index;
+	uint32_t	handle;
+	uint16_t	cnt;
+	uint16_t	req_cnt;
+	uint16_t	tot_dsds;
+	struct device_reg_82xx __iomem *reg;
+	uint32_t dbval;
+	uint32_t *fcp_dl;
+	uint8_t additional_cdb_len;
+	struct ct6_dsd *ctx;
+	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
+
+	/* Setup device pointers. */
+	ret = 0;
+	reg = &ha->iobase->isp82;
+	cmd = sp->cmd;
+	req = vha->req;
+	rsp = ha->rsp_q_map[0];
+
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	dbval = 0x04 | (ha->portnum << 5);
+
+	/* Send marker if required */
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, req,
+			rsp, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+		vha->marker_needed = 0;
+	}
+
+	/* Acquire ring specific lock */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+	if (index == MAX_OUTSTANDING_COMMANDS)
+		goto queuing_error;
+
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (scsi_sg_count(cmd)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+	} else
+		nseg = 0;
+
+	tot_dsds = nseg;
+
+	if (tot_dsds > ql2xshiftctondsd) {
+		struct cmd_type_6 *cmd_pkt;
+		uint16_t more_dsd_lists = 0;
+		struct dsd_dma *dsd_ptr;
+		uint16_t i;
+
+		more_dsd_lists = qla82xx_calc_dsd_lists(tot_dsds);
+		if ((more_dsd_lists + ha->gbl_dsd_inuse) >= NUM_DSD_CHAIN)
+			goto queuing_error;
+
+		if (more_dsd_lists <= ha->gbl_dsd_avail)
+			goto sufficient_dsds;
+		else
+			more_dsd_lists -= ha->gbl_dsd_avail;
+
+		for (i = 0; i < more_dsd_lists; i++) {
+			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
+			if (!dsd_ptr)
+				goto queuing_error;
+
+			dsd_ptr->dsd_addr = dma_pool_alloc(ha->dl_dma_pool,
+				GFP_ATOMIC, &dsd_ptr->dsd_list_dma);
+			if (!dsd_ptr->dsd_addr) {
+				kfree(dsd_ptr);
+				goto queuing_error;
+			}
+			list_add_tail(&dsd_ptr->list, &ha->gbl_dsd_list);
+			ha->gbl_dsd_avail++;
+		}
+
+sufficient_dsds:
+		req_cnt = 1;
+
+		ctx = sp->ctx = mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
+		if (!sp->ctx) {
+			DEBUG(printk(KERN_INFO
+				"%s(%ld): failed to allocate"
+				" ctx.\n", __func__, vha->host_no));
+			goto queuing_error;
+		}
+		memset(ctx, 0, sizeof(struct ct6_dsd));
+		ctx->fcp_cmnd = dma_pool_alloc(ha->fcp_cmnd_dma_pool,
+			GFP_ATOMIC, &ctx->fcp_cmnd_dma);
+		if (!ctx->fcp_cmnd) {
+			DEBUG2_3(printk("%s(%ld): failed to allocate"
+				" fcp_cmnd.\n", __func__, vha->host_no));
+			goto queuing_error_fcp_cmnd;
+		}
+
+		/* Initialize the DSD list and dma handle */
+		INIT_LIST_HEAD(&ctx->dsd_list);
+		ctx->dsd_use_cnt = 0;
+
+		if (cmd->cmd_len > 16) {
+			additional_cdb_len = cmd->cmd_len - 16;
+			if ((cmd->cmd_len % 4) != 0) {
+				/* SCSI command bigger than 16 bytes must be
+				 * multiple of 4
+				 */
+				goto queuing_error_fcp_cmnd;
+			}
+			ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
+		} else {
+			additional_cdb_len = 0;
+			ctx->fcp_cmnd_len = 12 + 16 + 4;
+		}
+
+		cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
+		cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+
+		/* Zero out remaining portion of packet. */
+		/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
+		clr_ptr = (uint32_t *)cmd_pkt + 2;
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+		cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+		/* Set NPORT-ID and LUN number*/
+		cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+		cmd_pkt->vp_index = sp->fcport->vp_idx;
+
+		/* Build IOCB segments */
+		if (qla2xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds))
+			goto queuing_error_fcp_cmnd;
+
+		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+
+		/* build FCP_CMND IU */
+		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
+		int_to_scsilun(sp->cmd->device->lun, &ctx->fcp_cmnd->lun);
+		ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
+
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
+			ctx->fcp_cmnd->additional_cdb_len |= 1;
+		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+			ctx->fcp_cmnd->additional_cdb_len |= 2;
+
+		memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
+
+		fcp_dl = (uint32_t *)(ctx->fcp_cmnd->cdb + 16 +
+		    additional_cdb_len);
+		*fcp_dl = htonl((uint32_t)scsi_bufflen(cmd));
+
+		cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(ctx->fcp_cmnd_len);
+		cmd_pkt->fcp_cmnd_dseg_address[0] =
+		    cpu_to_le32(LSD(ctx->fcp_cmnd_dma));
+		cmd_pkt->fcp_cmnd_dseg_address[1] =
+		    cpu_to_le32(MSD(ctx->fcp_cmnd_dma));
+
+		sp->flags |= SRB_FCP_CMND_DMA_VALID;
+		cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+		/* Set total data segment count. */
+		cmd_pkt->entry_count = (uint8_t)req_cnt;
+		/* Specify response queue number where
+		 * completion should happen
+		 */
+		cmd_pkt->entry_status = (uint8_t) rsp->id;
+	} else {
+		struct cmd_type_7 *cmd_pkt;
+		req_cnt = qla24xx_calc_iocbs(tot_dsds);
+		if (req->cnt < (req_cnt + 2)) {
+			cnt = (uint16_t)RD_REG_DWORD_RELAXED(
+			    &reg->req_q_out[0]);
+			if (req->ring_index < cnt)
+				req->cnt = cnt - req->ring_index;
+			else
+				req->cnt = req->length -
+					(req->ring_index - cnt);
+		}
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+
+		cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
+		cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+
+		/* Zero out remaining portion of packet. */
+		/* tagged queuing modifier -- default is TSK_SIMPLE (0).*/
+		clr_ptr = (uint32_t *)cmd_pkt + 2;
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+		cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+		/* Set NPORT-ID and LUN number*/
+		cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+		cmd_pkt->vp_index = sp->fcport->vp_idx;
+
+		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
+			sizeof(cmd_pkt->lun));
+
+		/* Load SCSI command packet. */
+		memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+		host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
+
+		cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+
+		/* Build IOCB segments */
+		qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds);
+
+		/* Set total data segment count. */
+		cmd_pkt->entry_count = (uint8_t)req_cnt;
+		/* Specify response queue number where
+		 * completion should happen.
+		 */
+		cmd_pkt->entry_status = (uint8_t) rsp->id;
+
+	}
+	/* Build command packet. */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
+	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	req->cnt -= req_cnt;
+	wmb();
+
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else
+		req->ring_ptr++;
+
+	sp->flags |= SRB_DMA_VALID;
+
+	/* Set chip new ring index. */
+	/* write, read and verify logic */
+	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
+	if (ql2xdbwr)
+		qla82xx_wr_32(ha, ha->nxdb_wr_ptr, dbval);
+	else {
+		WRT_REG_DWORD(
+			(unsigned long __iomem *)ha->nxdb_wr_ptr,
+			dbval);
+		wmb();
+		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+			WRT_REG_DWORD(
+				(unsigned long __iomem *)ha->nxdb_wr_ptr,
+				dbval);
+			wmb();
+		}
+	}
+
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return QLA_SUCCESS;
+
+queuing_error_fcp_cmnd:
+	dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd, ctx->fcp_cmnd_dma);
+queuing_error:
+	if (tot_dsds)
+		scsi_dma_unmap(cmd);
+
+	if (sp->ctx) {
+		mempool_free(sp->ctx, ha->ctx_mempool);
+		sp->ctx = NULL;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_FUNCTION_FAILED;
+}
+
+uint32_t *
+qla82xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
+	uint32_t length)
+{
+	uint32_t i;
+	uint32_t val;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Dword reads to flash. */
+	for (i = 0; i < length/4; i++, faddr += 4) {
+		if (qla82xx_rom_fast_read(ha, faddr, &val)) {
+			qla_printk(KERN_WARNING, ha,
+			    "Do ROM fast read failed\n");
+			goto done_read;
+		}
+		dwptr[i] = __constant_cpu_to_le32(val);
+	}
+done_read:
+	return dwptr;
+}
+
+int
+qla82xx_unprotect_flash(struct qla_hw_data *ha)
+{
+	int ret;
+	uint32_t val;
+
+	ret = ql82xx_rom_lock_d(ha);
+	if (ret < 0) {
+		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		return ret;
+	}
+
+	ret = qla82xx_read_status_reg(ha, &val);
+	if (ret < 0)
+		goto done_unprotect;
+
+	val &= ~(0x7 << 2);
+	ret = qla82xx_write_status_reg(ha, val);
+	if (ret < 0) {
+		val |= (0x7 << 2);
+		qla82xx_write_status_reg(ha, val);
+	}
+
+	if (qla82xx_write_disable_flash(ha) != 0)
+		qla_printk(KERN_WARNING, ha, "Write disable failed\n");
+
+done_unprotect:
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	return ret;
+}
+
+int
+qla82xx_protect_flash(struct qla_hw_data *ha)
+{
+	int ret;
+	uint32_t val;
+
+	ret = ql82xx_rom_lock_d(ha);
+	if (ret < 0) {
+		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		return ret;
+	}
+
+	ret = qla82xx_read_status_reg(ha, &val);
+	if (ret < 0)
+		goto done_protect;
+
+	val |= (0x7 << 2);
+	/* LOCK all sectors */
+	ret = qla82xx_write_status_reg(ha, val);
+	if (ret < 0)
+		qla_printk(KERN_WARNING, ha, "Write status register failed\n");
+
+	if (qla82xx_write_disable_flash(ha) != 0)
+		qla_printk(KERN_WARNING, ha, "Write disable failed\n");
+done_protect:
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	return ret;
+}
+
+int
+qla82xx_erase_sector(struct qla_hw_data *ha, int addr)
+{
+	int ret = 0;
+
+	ret = ql82xx_rom_lock_d(ha);
+	if (ret < 0) {
+		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		return ret;
+	}
+
+	qla82xx_flash_set_write_enable(ha);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, addr);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 3);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_SE);
+
+	if (qla82xx_wait_rom_done(ha)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Error waiting for rom done\n");
+		ret = -1;
+		goto done;
+	}
+	ret = qla82xx_flash_wait_write_finish(ha);
+done:
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	return ret;
+}
+
+/*
+ * Address and length are byte address
+ */
+uint8_t *
+qla82xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
+	uint32_t offset, uint32_t length)
+{
+	scsi_block_requests(vha->host);
+	qla82xx_read_flash_data(vha, (uint32_t *)buf, offset, length);
+	scsi_unblock_requests(vha->host);
+	return buf;
+}
+
+static int
+qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
+	uint32_t faddr, uint32_t dwords)
+{
+	int ret;
+	uint32_t liter;
+	uint32_t sec_mask, rest_addr;
+	dma_addr_t optrom_dma;
+	void *optrom = NULL;
+	int page_mode = 0;
+	struct qla_hw_data *ha = vha->hw;
+
+	ret = -1;
+
+	/* Prepare burst-capable write on supported ISPs. */
+	if (page_mode && !(faddr & 0xfff) &&
+	    dwords > OPTROM_BURST_DWORDS) {
+		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+		    &optrom_dma, GFP_KERNEL);
+		if (!optrom) {
+			qla_printk(KERN_DEBUG, ha,
+				"Unable to allocate memory for optrom "
+				"burst write (%x KB).\n",
+				OPTROM_BURST_SIZE / 1024);
+		}
+	}
+
+	rest_addr = ha->fdt_block_size - 1;
+	sec_mask = ~rest_addr;
+
+	ret = qla82xx_unprotect_flash(ha);
+	if (ret) {
+		qla_printk(KERN_WARNING, ha,
+			"Unable to unprotect flash for update.\n");
+		goto write_done;
+	}
+
+	for (liter = 0; liter < dwords; liter++, faddr += 4, dwptr++) {
+		/* Are we at the beginning of a sector? */
+		if ((faddr & rest_addr) == 0) {
+
+			ret = qla82xx_erase_sector(ha, faddr);
+			if (ret) {
+				DEBUG9(qla_printk(KERN_ERR, ha,
+				    "Unable to erase sector: "
+				    "address=%x.\n", faddr));
+				break;
+			}
+		}
+
+		/* Go with burst-write. */
+		if (optrom && (liter + OPTROM_BURST_DWORDS) <= dwords) {
+			/* Copy data to DMA'ble buffer. */
+			memcpy(optrom, dwptr, OPTROM_BURST_SIZE);
+
+			ret = qla2x00_load_ram(vha, optrom_dma,
+			    (ha->flash_data_off | faddr),
+			    OPTROM_BURST_DWORDS);
+			if (ret != QLA_SUCCESS) {
+				qla_printk(KERN_WARNING, ha,
+				    "Unable to burst-write optrom segment "
+				    "(%x/%x/%llx).\n", ret,
+				    (ha->flash_data_off | faddr),
+				    (unsigned long long)optrom_dma);
+				qla_printk(KERN_WARNING, ha,
+				    "Reverting to slow-write.\n");
+
+				dma_free_coherent(&ha->pdev->dev,
+				    OPTROM_BURST_SIZE, optrom, optrom_dma);
+				optrom = NULL;
+			} else {
+				liter += OPTROM_BURST_DWORDS - 1;
+				faddr += OPTROM_BURST_DWORDS - 1;
+				dwptr += OPTROM_BURST_DWORDS - 1;
+				continue;
+			}
+		}
+
+		ret = qla82xx_write_flash_dword(ha, faddr,
+		    cpu_to_le32(*dwptr));
+		if (ret) {
+			DEBUG9(printk(KERN_DEBUG "%s(%ld) Unable to program"
+			    "flash address=%x data=%x.\n", __func__,
+			    ha->host_no, faddr, *dwptr));
+			break;
+		}
+	}
+
+	ret = qla82xx_protect_flash(ha);
+	if (ret)
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to protect flash after update.\n");
+write_done:
+	if (optrom)
+		dma_free_coherent(&ha->pdev->dev,
+		    OPTROM_BURST_SIZE, optrom, optrom_dma);
+	return ret;
+}
+
+int
+qla82xx_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
+	uint32_t offset, uint32_t length)
+{
+	int rval;
+
+	/* Suspend HBA. */
+	scsi_block_requests(vha->host);
+	rval = qla82xx_write_flash_data(vha, (uint32_t *)buf, offset,
+		length >> 2);
+	scsi_unblock_requests(vha->host);
+
+	/* Convert return ISP82xx to generic */
+	if (rval)
+		rval = QLA_FUNCTION_FAILED;
+	else
+		rval = QLA_SUCCESS;
+	return rval;
+}
+
+void
+qla82xx_start_iocbs(srb_t *sp)
+{
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	struct device_reg_82xx __iomem *reg;
+	uint32_t dbval;
+
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else
+		req->ring_ptr++;
+
+	reg = &ha->iobase->isp82;
+	dbval = 0x04 | (ha->portnum << 5);
+
+	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
+	WRT_REG_DWORD((unsigned long __iomem *)ha->nxdb_wr_ptr, dbval);
+	wmb();
+	while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+		WRT_REG_DWORD((unsigned long  __iomem *)ha->nxdb_wr_ptr, dbval);
+		wmb();
+	}
+}
+
+/*
+ * qla82xx_device_bootstrap
+ *    Initialize device, set DEV_READY, start fw
+ *
+ * Note:
+ *      IDC lock must be held upon entry
+ *
+ * Return:
+ *    Success : 0
+ *    Failed  : 1
+ */
+static int
+qla82xx_device_bootstrap(scsi_qla_host_t *vha)
+{
+	int rval, i, timeout;
+	uint32_t old_count, count;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (qla82xx_need_reset(ha))
+		goto dev_initialize;
+
+	old_count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+
+	for (i = 0; i < 10; i++) {
+		timeout = msleep_interruptible(200);
+		if (timeout) {
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+				QLA82XX_DEV_FAILED);
+			return QLA_FUNCTION_FAILED;
+		}
+
+		count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+		if (count != old_count)
+			goto dev_ready;
+	}
+
+dev_initialize:
+	/* set to DEV_INITIALIZING */
+	qla_printk(KERN_INFO, ha, "HW State: INITIALIZING\n");
+	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_INITIALIZING);
+
+	/* Driver that sets device state to initializating sets IDC version */
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION, QLA82XX_IDC_VERSION);
+
+	qla82xx_idc_unlock(ha);
+	rval = qla82xx_start_firmware(vha);
+	qla82xx_idc_lock(ha);
+
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_INFO, ha, "HW State: FAILED\n");
+		qla82xx_clear_drv_active(ha);
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_FAILED);
+		return rval;
+	}
+
+dev_ready:
+	qla_printk(KERN_INFO, ha, "HW State: READY\n");
+	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_READY);
+
+	return QLA_SUCCESS;
+}
+
+static void
+qla82xx_dev_failed_handler(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Disable the board */
+	qla_printk(KERN_INFO, ha, "Disabling the board\n");
+
+	/* Set DEV_FAILED flag to disable timer */
+	vha->device_flags |= DFLG_DEV_FAILED;
+	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
+	qla2x00_mark_all_devices_lost(vha, 0);
+	vha->flags.online = 0;
+	vha->flags.init_done = 0;
+}
+
+/*
+ * qla82xx_need_reset_handler
+ *    Code to start reset sequence
+ *
+ * Note:
+ *      IDC lock must be held upon entry
+ *
+ * Return:
+ *    Success : 0
+ *    Failed  : 1
+ */
+static void
+qla82xx_need_reset_handler(scsi_qla_host_t *vha)
+{
+	uint32_t dev_state, drv_state, drv_active;
+	unsigned long reset_timeout;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+
+	if (vha->flags.online) {
+		qla82xx_idc_unlock(ha);
+		qla2x00_abort_isp_cleanup(vha);
+		ha->isp_ops->get_flash_version(vha, req->ring);
+		ha->isp_ops->nvram_config(vha);
+		qla82xx_idc_lock(ha);
+	}
+
+	qla82xx_set_rst_ready(ha);
+
+	/* wait for 10 seconds for reset ack from all functions */
+	reset_timeout = jiffies + (ha->nx_reset_timeout * HZ);
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+
+	while (drv_state != drv_active) {
+		if (time_after_eq(jiffies, reset_timeout)) {
+			qla_printk(KERN_INFO, ha,
+				"%s: RESET TIMEOUT!\n", QLA2XXX_DRIVER_NAME);
+			break;
+		}
+		qla82xx_idc_unlock(ha);
+		msleep(1000);
+		qla82xx_idc_lock(ha);
+		drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	}
+
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	/* Force to DEV_COLD unless someone else is starting a reset */
+	if (dev_state != QLA82XX_DEV_INITIALIZING) {
+		qla_printk(KERN_INFO, ha, "HW State: COLD/RE-INIT\n");
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_COLD);
+	}
+}
+
+static void
+qla82xx_check_fw_alive(scsi_qla_host_t *vha)
+{
+	uint32_t fw_heartbeat_counter, halt_status;
+	struct qla_hw_data *ha = vha->hw;
+
+	fw_heartbeat_counter = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+	if (vha->fw_heartbeat_counter == fw_heartbeat_counter) {
+		vha->seconds_since_last_heartbeat++;
+		/* FW not alive after 2 seconds */
+		if (vha->seconds_since_last_heartbeat == 2) {
+			vha->seconds_since_last_heartbeat = 0;
+			halt_status = qla82xx_rd_32(ha,
+				QLA82XX_PEG_HALT_STATUS1);
+			if (halt_status & HALT_STATUS_UNRECOVERABLE) {
+				set_bit(ISP_UNRECOVERABLE, &vha->dpc_flags);
+			} else {
+				qla_printk(KERN_INFO, ha,
+					"scsi(%ld): %s - detect abort needed\n",
+					vha->host_no, __func__);
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			}
+			qla2xxx_wake_dpc(vha);
+		}
+	}
+	vha->fw_heartbeat_counter = fw_heartbeat_counter;
+}
+
+/*
+ * qla82xx_device_state_handler
+ *	Main state handler
+ *
+ * Note:
+ *      IDC lock must be held upon entry
+ *
+ * Return:
+ *    Success : 0
+ *    Failed  : 1
+ */
+int
+qla82xx_device_state_handler(scsi_qla_host_t *vha)
+{
+	uint32_t dev_state;
+	uint32_t drv_active;
+	int rval = QLA_SUCCESS;
+	unsigned long dev_init_timeout;
+	struct qla_hw_data *ha = vha->hw;
+
+	qla82xx_idc_lock(ha);
+	if (!vha->flags.init_done)
+		qla82xx_set_drv_active(vha);
+
+	/* Set cold state*/
+	if (!PCI_FUNC(ha->pdev->devfn & 1)) {
+
+		/* Check if other functions alive, else set dev state
+		 * to cold
+		 */
+		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+		drv_active &= ~(1 << (ha->portnum * 4));
+		drv_active &= ~(1 << ((ha->portnum + 1) * 4));
+
+		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		if (!drv_active) {
+
+			switch (dev_state) {
+			case QLA82XX_DEV_COLD:
+			case QLA82XX_DEV_READY:
+			case QLA82XX_DEV_INITIALIZING:
+			case QLA82XX_DEV_NEED_RESET:
+			case QLA82XX_DEV_NEED_QUIESCENT:
+			case QLA82XX_DEV_QUIESCENT:
+			case QLA82XX_DEV_FAILED:
+				break;
+			default:
+				qla_printk(KERN_INFO, ha,
+					"No other function exist,"
+					" resetting dev state to COLD\n");
+				qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+					QLA82XX_DEV_COLD);
+				break;
+			}
+		}
+	}
+
+	/* wait for 30 seconds for device to go ready */
+	dev_init_timeout = jiffies + (ha->nx_dev_init_timeout * HZ);
+
+	while (1) {
+
+		if (time_after_eq(jiffies, dev_init_timeout)) {
+			DEBUG(qla_printk(KERN_INFO, ha,
+				"%s: device init failed!\n",
+				QLA2XXX_DRIVER_NAME));
+			rval = QLA_FUNCTION_FAILED;
+			break;
+		}
+		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		switch (dev_state) {
+		case QLA82XX_DEV_READY:
+			goto exit;
+		case QLA82XX_DEV_COLD:
+			rval = qla82xx_device_bootstrap(vha);
+			goto exit;
+		case QLA82XX_DEV_INITIALIZING:
+			qla82xx_idc_unlock(ha);
+			msleep(1000);
+			qla82xx_idc_lock(ha);
+			break;
+		case QLA82XX_DEV_NEED_RESET:
+			if (!ql2xdontresethba)
+				qla82xx_need_reset_handler(vha);
+			break;
+		case QLA82XX_DEV_NEED_QUIESCENT:
+			qla82xx_set_qsnt_ready(ha);
+		case QLA82XX_DEV_QUIESCENT:
+			qla82xx_idc_unlock(ha);
+			msleep(1000);
+			qla82xx_idc_lock(ha);
+			break;
+		case QLA82XX_DEV_FAILED:
+			qla82xx_dev_failed_handler(vha);
+			rval = QLA_FUNCTION_FAILED;
+			goto exit;
+		default:
+			qla82xx_idc_unlock(ha);
+			msleep(1000);
+			qla82xx_idc_lock(ha);
+		}
+	}
+exit:
+	qla82xx_idc_unlock(ha);
+	return rval;
+}
+
+void qla82xx_watchdog(scsi_qla_host_t *vha)
+{
+	uint32_t dev_state;
+	struct qla_hw_data *ha = vha->hw;
+
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+
+	/* don't poll if reset is going on */
+	if (!(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))) {
+		if (dev_state == QLA82XX_DEV_NEED_RESET) {
+			qla_printk(KERN_WARNING, ha,
+				"%s(): Adapter reset needed!\n", __func__);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		} else {
+			qla82xx_check_fw_alive(vha);
+		}
+	}
+}
+
+int qla82xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+	rval = qla82xx_device_state_handler(vha);
+	return rval;
+}
+
+/*
+ *  qla82xx_abort_isp
+ *      Resets ISP and aborts all outstanding commands.
+ *
+ * Input:
+ *      ha           = adapter block pointer.
+ *
+ * Returns:
+ *      0 = success
+ */
+int
+qla82xx_abort_isp(scsi_qla_host_t *vha)
+{
+	int rval;
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t dev_state;
+
+	if (vha->device_flags & DFLG_DEV_FAILED) {
+		qla_printk(KERN_WARNING, ha,
+			"%s(%ld): Device in failed state, "
+			"Exiting.\n", __func__, vha->host_no);
+		return QLA_SUCCESS;
+	}
+
+	qla82xx_idc_lock(ha);
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	if (dev_state != QLA82XX_DEV_INITIALIZING) {
+		qla_printk(KERN_INFO, ha, "HW State: NEED RESET\n");
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			QLA82XX_DEV_NEED_RESET);
+	} else
+		qla_printk(KERN_INFO, ha, "HW State: DEVICE INITIALIZING\n");
+	qla82xx_idc_unlock(ha);
+
+	rval = qla82xx_device_state_handler(vha);
+
+	qla82xx_idc_lock(ha);
+	qla82xx_clear_rst_ready(ha);
+	qla82xx_idc_unlock(ha);
+
+	if (rval == QLA_SUCCESS)
+		qla82xx_restart_isp(vha);
+	return rval;
+}
+
+/*
+ *  qla82xx_fcoe_ctx_reset
+ *      Perform a quick reset and aborts all outstanding commands.
+ *      This will only perform an FCoE context reset and avoids a full blown
+ *      chip reset.
+ *
+ * Input:
+ *      ha = adapter block pointer.
+ *      is_reset_path = flag for identifying the reset path.
+ *
+ * Returns:
+ *      0 = success
+ */
+int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *vha)
+{
+	int rval = QLA_FUNCTION_FAILED;
+
+	if (vha->flags.online) {
+		/* Abort all outstanding commands, so as to be requeued later */
+		qla2x00_abort_isp_cleanup(vha);
+	}
+
+	/* Stop currently executing firmware.
+	 * This will destroy existing FCoE context at the F/W end.
+	 */
+	qla2x00_try_to_stop_firmware(vha);
+
+	/* Restart. Creates a new FCoE context on INIT_FIRMWARE. */
+	rval = qla82xx_restart_isp(vha);
+
+	return rval;
+}
+
+/*
+ * qla2x00_wait_for_fcoe_ctx_reset
+ *    Wait till the FCoE context is reset.
+ *
+ * Note:
+ *    Does context switching here.
+ *    Release SPIN_LOCK (if any) before calling this routine.
+ *
+ * Return:
+ *    Success (fcoe_ctx reset is done) : 0
+ *    Failed  (fcoe_ctx reset not completed within max loop timout ) : 1
+ */
+int qla2x00_wait_for_fcoe_ctx_reset(scsi_qla_host_t *vha)
+{
+	int status = QLA_FUNCTION_FAILED;
+	unsigned long wait_reset;
+
+	wait_reset = jiffies + (MAX_LOOP_TIMEOUT * HZ);
+	while ((test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags) ||
+	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+	    && time_before(jiffies, wait_reset)) {
+
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ);
+
+		if (!test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags) &&
+		    !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
+			status = QLA_SUCCESS;
+			break;
+		}
+	}
+	DEBUG2(printk(KERN_INFO
+	    "%s status=%d\n", __func__, status));
+
+	return status;
+}
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
new file mode 100644
index 0000000..7804bbb
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -0,0 +1,888 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2008 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#ifndef __QLA_NX_H
+#define __QLA_NX_H
+
+/*
+ * Following are the states of the Phantom. Phantom will set them and
+ * Host will read to check if the fields are correct.
+*/
+#define PHAN_INITIALIZE_FAILED	      0xffff
+#define PHAN_INITIALIZE_COMPLETE      0xff01
+
+/* Host writes the following to notify that it has done the init-handshake */
+#define PHAN_INITIALIZE_ACK	      0xf00f
+#define PHAN_PEG_RCV_INITIALIZED      0xff01
+
+/*CRB_RELATED*/
+#define QLA82XX_CRB_BASE	QLA82XX_CAM_RAM(0x200)
+#define QLA82XX_REG(X)		(QLA82XX_CRB_BASE+(X))
+
+#define CRB_CMDPEG_STATE		QLA82XX_REG(0x50)
+#define CRB_RCVPEG_STATE		QLA82XX_REG(0x13c)
+#define BOOT_LOADER_DIMM_STATUS		QLA82XX_REG(0x54)
+#define CRB_DMA_SHIFT			QLA82XX_REG(0xcc)
+
+#define QLA82XX_HW_H0_CH_HUB_ADR    0x05
+#define QLA82XX_HW_H1_CH_HUB_ADR    0x0E
+#define QLA82XX_HW_H2_CH_HUB_ADR    0x03
+#define QLA82XX_HW_H3_CH_HUB_ADR    0x01
+#define QLA82XX_HW_H4_CH_HUB_ADR    0x06
+#define QLA82XX_HW_H5_CH_HUB_ADR    0x07
+#define QLA82XX_HW_H6_CH_HUB_ADR    0x08
+
+/*  Hub 0 */
+#define QLA82XX_HW_MN_CRB_AGT_ADR   0x15
+#define QLA82XX_HW_MS_CRB_AGT_ADR   0x25
+
+/*  Hub 1 */
+#define QLA82XX_HW_PS_CRB_AGT_ADR	0x73
+#define QLA82XX_HW_QMS_CRB_AGT_ADR	0x00
+#define QLA82XX_HW_RPMX3_CRB_AGT_ADR	0x0b
+#define QLA82XX_HW_SQGS0_CRB_AGT_ADR	0x01
+#define QLA82XX_HW_SQGS1_CRB_AGT_ADR	0x02
+#define QLA82XX_HW_SQGS2_CRB_AGT_ADR	0x03
+#define QLA82XX_HW_SQGS3_CRB_AGT_ADR	0x04
+#define QLA82XX_HW_C2C0_CRB_AGT_ADR	0x58
+#define QLA82XX_HW_C2C1_CRB_AGT_ADR	0x59
+#define QLA82XX_HW_C2C2_CRB_AGT_ADR	0x5a
+#define QLA82XX_HW_RPMX2_CRB_AGT_ADR	0x0a
+#define QLA82XX_HW_RPMX4_CRB_AGT_ADR	0x0c
+#define QLA82XX_HW_RPMX7_CRB_AGT_ADR	0x0f
+#define QLA82XX_HW_RPMX9_CRB_AGT_ADR	0x12
+#define QLA82XX_HW_SMB_CRB_AGT_ADR	0x18
+
+/*  Hub 2 */
+#define QLA82XX_HW_NIU_CRB_AGT_ADR	0x31
+#define QLA82XX_HW_I2C0_CRB_AGT_ADR	0x19
+#define QLA82XX_HW_I2C1_CRB_AGT_ADR	0x29
+
+#define QLA82XX_HW_SN_CRB_AGT_ADR	0x10
+#define QLA82XX_HW_I2Q_CRB_AGT_ADR	0x20
+#define QLA82XX_HW_LPC_CRB_AGT_ADR	0x22
+#define QLA82XX_HW_ROMUSB_CRB_AGT_ADR	0x21
+#define QLA82XX_HW_QM_CRB_AGT_ADR	0x66
+#define QLA82XX_HW_SQG0_CRB_AGT_ADR	0x60
+#define QLA82XX_HW_SQG1_CRB_AGT_ADR	0x61
+#define QLA82XX_HW_SQG2_CRB_AGT_ADR	0x62
+#define QLA82XX_HW_SQG3_CRB_AGT_ADR	0x63
+#define QLA82XX_HW_RPMX1_CRB_AGT_ADR	0x09
+#define QLA82XX_HW_RPMX5_CRB_AGT_ADR	0x0d
+#define QLA82XX_HW_RPMX6_CRB_AGT_ADR	0x0e
+#define QLA82XX_HW_RPMX8_CRB_AGT_ADR	0x11
+
+/*  Hub 3 */
+#define QLA82XX_HW_PH_CRB_AGT_ADR	0x1A
+#define QLA82XX_HW_SRE_CRB_AGT_ADR	0x50
+#define QLA82XX_HW_EG_CRB_AGT_ADR	0x51
+#define QLA82XX_HW_RPMX0_CRB_AGT_ADR	0x08
+
+/*  Hub 4 */
+#define QLA82XX_HW_PEGN0_CRB_AGT_ADR	0x40
+#define QLA82XX_HW_PEGN1_CRB_AGT_ADR	0x41
+#define QLA82XX_HW_PEGN2_CRB_AGT_ADR	0x42
+#define QLA82XX_HW_PEGN3_CRB_AGT_ADR	0x43
+#define QLA82XX_HW_PEGNI_CRB_AGT_ADR	0x44
+#define QLA82XX_HW_PEGND_CRB_AGT_ADR	0x45
+#define QLA82XX_HW_PEGNC_CRB_AGT_ADR	0x46
+#define QLA82XX_HW_PEGR0_CRB_AGT_ADR	0x47
+#define QLA82XX_HW_PEGR1_CRB_AGT_ADR	0x48
+#define QLA82XX_HW_PEGR2_CRB_AGT_ADR	0x49
+#define QLA82XX_HW_PEGR3_CRB_AGT_ADR	0x4a
+#define QLA82XX_HW_PEGN4_CRB_AGT_ADR	0x4b
+
+/*  Hub 5 */
+#define QLA82XX_HW_PEGS0_CRB_AGT_ADR	0x40
+#define QLA82XX_HW_PEGS1_CRB_AGT_ADR	0x41
+#define QLA82XX_HW_PEGS2_CRB_AGT_ADR	0x42
+#define QLA82XX_HW_PEGS3_CRB_AGT_ADR	0x43
+#define QLA82XX_HW_PEGSI_CRB_AGT_ADR	0x44
+#define QLA82XX_HW_PEGSD_CRB_AGT_ADR	0x45
+#define QLA82XX_HW_PEGSC_CRB_AGT_ADR	0x46
+
+/*  Hub 6 */
+#define QLA82XX_HW_CAS0_CRB_AGT_ADR	0x46
+#define QLA82XX_HW_CAS1_CRB_AGT_ADR	0x47
+#define QLA82XX_HW_CAS2_CRB_AGT_ADR	0x48
+#define QLA82XX_HW_CAS3_CRB_AGT_ADR	0x49
+#define QLA82XX_HW_NCM_CRB_AGT_ADR	0x16
+#define QLA82XX_HW_TMR_CRB_AGT_ADR	0x17
+#define QLA82XX_HW_XDMA_CRB_AGT_ADR	0x05
+#define QLA82XX_HW_OCM0_CRB_AGT_ADR	0x06
+#define QLA82XX_HW_OCM1_CRB_AGT_ADR	0x07
+
+/*  This field defines PCI/X adr [25:20] of agents on the CRB */
+/*  */
+#define QLA82XX_HW_PX_MAP_CRB_PH	0
+#define QLA82XX_HW_PX_MAP_CRB_PS	1
+#define QLA82XX_HW_PX_MAP_CRB_MN	2
+#define QLA82XX_HW_PX_MAP_CRB_MS	3
+#define QLA82XX_HW_PX_MAP_CRB_SRE	5
+#define QLA82XX_HW_PX_MAP_CRB_NIU	6
+#define QLA82XX_HW_PX_MAP_CRB_QMN	7
+#define QLA82XX_HW_PX_MAP_CRB_SQN0	8
+#define QLA82XX_HW_PX_MAP_CRB_SQN1	9
+#define QLA82XX_HW_PX_MAP_CRB_SQN2	10
+#define QLA82XX_HW_PX_MAP_CRB_SQN3	11
+#define QLA82XX_HW_PX_MAP_CRB_QMS	12
+#define QLA82XX_HW_PX_MAP_CRB_SQS0	13
+#define QLA82XX_HW_PX_MAP_CRB_SQS1	14
+#define QLA82XX_HW_PX_MAP_CRB_SQS2	15
+#define QLA82XX_HW_PX_MAP_CRB_SQS3	16
+#define QLA82XX_HW_PX_MAP_CRB_PGN0	17
+#define QLA82XX_HW_PX_MAP_CRB_PGN1	18
+#define QLA82XX_HW_PX_MAP_CRB_PGN2	19
+#define QLA82XX_HW_PX_MAP_CRB_PGN3	20
+#define QLA82XX_HW_PX_MAP_CRB_PGN4	QLA82XX_HW_PX_MAP_CRB_SQS2
+#define QLA82XX_HW_PX_MAP_CRB_PGND	21
+#define QLA82XX_HW_PX_MAP_CRB_PGNI	22
+#define QLA82XX_HW_PX_MAP_CRB_PGS0	23
+#define QLA82XX_HW_PX_MAP_CRB_PGS1	24
+#define QLA82XX_HW_PX_MAP_CRB_PGS2	25
+#define QLA82XX_HW_PX_MAP_CRB_PGS3	26
+#define QLA82XX_HW_PX_MAP_CRB_PGSD	27
+#define QLA82XX_HW_PX_MAP_CRB_PGSI	28
+#define QLA82XX_HW_PX_MAP_CRB_SN	29
+#define QLA82XX_HW_PX_MAP_CRB_EG	31
+#define QLA82XX_HW_PX_MAP_CRB_PH2	32
+#define QLA82XX_HW_PX_MAP_CRB_PS2	33
+#define QLA82XX_HW_PX_MAP_CRB_CAM	34
+#define QLA82XX_HW_PX_MAP_CRB_CAS0	35
+#define QLA82XX_HW_PX_MAP_CRB_CAS1	36
+#define QLA82XX_HW_PX_MAP_CRB_CAS2	37
+#define QLA82XX_HW_PX_MAP_CRB_C2C0	38
+#define QLA82XX_HW_PX_MAP_CRB_C2C1	39
+#define QLA82XX_HW_PX_MAP_CRB_TIMR	40
+#define QLA82XX_HW_PX_MAP_CRB_RPMX1	42
+#define QLA82XX_HW_PX_MAP_CRB_RPMX2	43
+#define QLA82XX_HW_PX_MAP_CRB_RPMX3	44
+#define QLA82XX_HW_PX_MAP_CRB_RPMX4	45
+#define QLA82XX_HW_PX_MAP_CRB_RPMX5	46
+#define QLA82XX_HW_PX_MAP_CRB_RPMX6	47
+#define QLA82XX_HW_PX_MAP_CRB_RPMX7	48
+#define QLA82XX_HW_PX_MAP_CRB_XDMA	49
+#define QLA82XX_HW_PX_MAP_CRB_I2Q	50
+#define QLA82XX_HW_PX_MAP_CRB_ROMUSB	51
+#define QLA82XX_HW_PX_MAP_CRB_CAS3	52
+#define QLA82XX_HW_PX_MAP_CRB_RPMX0	53
+#define QLA82XX_HW_PX_MAP_CRB_RPMX8	54
+#define QLA82XX_HW_PX_MAP_CRB_RPMX9	55
+#define QLA82XX_HW_PX_MAP_CRB_OCM0	56
+#define QLA82XX_HW_PX_MAP_CRB_OCM1	57
+#define QLA82XX_HW_PX_MAP_CRB_SMB	58
+#define QLA82XX_HW_PX_MAP_CRB_I2C0	59
+#define QLA82XX_HW_PX_MAP_CRB_I2C1	60
+#define QLA82XX_HW_PX_MAP_CRB_LPC	61
+#define QLA82XX_HW_PX_MAP_CRB_PGNC	62
+#define QLA82XX_HW_PX_MAP_CRB_PGR0	63
+#define QLA82XX_HW_PX_MAP_CRB_PGR1	4
+#define QLA82XX_HW_PX_MAP_CRB_PGR2	30
+#define QLA82XX_HW_PX_MAP_CRB_PGR3	41
+
+/*  This field defines CRB adr [31:20] of the agents */
+/*  */
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_MN	    ((QLA82XX_HW_H0_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_MN_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PH	    ((QLA82XX_HW_H0_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PH_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_MS	    ((QLA82XX_HW_H0_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_MS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PS	    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SS	    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX3    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_QMS	    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_QMS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS0     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQGS0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS1     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQGS1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS2     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQGS2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS3     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQGS3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_C2C0     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_C2C0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_C2C1     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_C2C1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX2    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX4    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX4_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX7    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX7_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX9    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX9_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SMB	    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SMB_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_NIU	    ((QLA82XX_HW_H2_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_NIU_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_I2C0     ((QLA82XX_HW_H2_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_I2C0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_I2C1     ((QLA82XX_HW_H2_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_I2C1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SRE	    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SRE_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_EG	    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_EG_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX0    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_QMN	    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_QM_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN0     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQG0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN1     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQG1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN2     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQG2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN3     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SQG3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX1    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX5    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX5_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX6    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX6_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX8    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_RPMX8_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS0     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_CAS0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS1     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_CAS1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS2     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_CAS2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS3     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_CAS3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGNI     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGNI_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGND     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGND_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN0     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGN0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN1     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGN1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN2     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGN2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN3     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGN3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN4	   ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGN4_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGNC     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGNC_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR0     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGR0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR1     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGR1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR2     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGR2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR3     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGR3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGSI     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGSI_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGSD     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGSD_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS0     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGS0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS1     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGS1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS2     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGS2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS3     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGS3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGSC     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_PEGSC_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAM	    ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_NCM_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_TIMR     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_TMR_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_XDMA     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_XDMA_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SN	    ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_SN_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_I2Q	    ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_I2Q_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_ROMUSB   ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_ROMUSB_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_OCM0     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_OCM0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_OCM1     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_OCM1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_LPC	    ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+	QLA82XX_HW_LPC_CRB_AGT_ADR)
+
+#define ROMUSB_GLB				(QLA82XX_CRB_ROMUSB + 0x00000)
+#define QLA82XX_ROMUSB_GLB_PEGTUNE_DONE		(ROMUSB_GLB + 0x005c)
+#define QLA82XX_ROMUSB_GLB_STATUS		(ROMUSB_GLB + 0x0004)
+#define QLA82XX_ROMUSB_GLB_SW_RESET		(ROMUSB_GLB + 0x0008)
+#define QLA82XX_ROMUSB_ROM_ADDRESS		(ROMUSB_ROM + 0x0008)
+#define QLA82XX_ROMUSB_ROM_WDATA		(ROMUSB_ROM + 0x000c)
+#define QLA82XX_ROMUSB_ROM_ABYTE_CNT		(ROMUSB_ROM + 0x0010)
+#define QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT	(ROMUSB_ROM + 0x0014)
+#define QLA82XX_ROMUSB_ROM_RDATA		(ROMUSB_ROM + 0x0018)
+
+#define ROMUSB_ROM				(QLA82XX_CRB_ROMUSB + 0x10000)
+#define QLA82XX_ROMUSB_ROM_INSTR_OPCODE		(ROMUSB_ROM + 0x0004)
+#define QLA82XX_ROMUSB_GLB_CAS_RST		(ROMUSB_GLB + 0x0038)
+
+/* Lock IDs for ROM lock */
+#define ROM_LOCK_DRIVER       0x0d417340
+
+#define QLA82XX_PCI_CRB_WINDOWSIZE 0x00100000	 /* all are 1MB windows */
+#define QLA82XX_PCI_CRB_WINDOW(A) \
+	(QLA82XX_PCI_CRBSPACE + (A)*QLA82XX_PCI_CRB_WINDOWSIZE)
+#define QLA82XX_CRB_C2C_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_C2C0)
+#define QLA82XX_CRB_C2C_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_C2C1)
+#define QLA82XX_CRB_C2C_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_C2C2)
+#define QLA82XX_CRB_CAM \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAM)
+#define QLA82XX_CRB_CASPER \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS)
+#define QLA82XX_CRB_CASPER_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS0)
+#define QLA82XX_CRB_CASPER_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS1)
+#define QLA82XX_CRB_CASPER_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS2)
+#define QLA82XX_CRB_DDR_MD \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_MS)
+#define QLA82XX_CRB_DDR_NET \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_MN)
+#define QLA82XX_CRB_EPG \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_EG)
+#define QLA82XX_CRB_I2Q \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_I2Q)
+#define QLA82XX_CRB_NIU \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_NIU)
+
+#define QLA82XX_CRB_PCIX_HOST \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PH)
+#define QLA82XX_CRB_PCIX_HOST2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PH2)
+#define QLA82XX_CRB_PCIX_MD \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PS)
+#define QLA82XX_CRB_PCIE \
+	QLA82XX_CRB_PCIX_MD
+
+/* window 1 pcie slot */
+#define QLA82XX_CRB_PCIE2	 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PS2)
+#define QLA82XX_CRB_PEG_MD_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS0)
+#define QLA82XX_CRB_PEG_MD_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS1)
+#define QLA82XX_CRB_PEG_MD_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS2)
+#define QLA82XX_CRB_PEG_MD_3 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS3)
+#define QLA82XX_CRB_PEG_MD_3 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS3)
+#define QLA82XX_CRB_PEG_MD_D \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGSD)
+#define QLA82XX_CRB_PEG_MD_I \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGSI)
+#define QLA82XX_CRB_PEG_NET_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN0)
+#define QLA82XX_CRB_PEG_NET_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN1)
+#define QLA82XX_CRB_PEG_NET_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN2)
+#define QLA82XX_CRB_PEG_NET_3 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN3)
+#define QLA82XX_CRB_PEG_NET_4 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN4)
+#define QLA82XX_CRB_PEG_NET_D \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGND)
+#define QLA82XX_CRB_PEG_NET_I \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGNI)
+#define QLA82XX_CRB_PQM_MD \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_QMS)
+#define QLA82XX_CRB_PQM_NET \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_QMN)
+#define QLA82XX_CRB_QDR_MD \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SS)
+#define QLA82XX_CRB_QDR_NET \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SN)
+#define QLA82XX_CRB_ROMUSB \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_ROMUSB)
+#define QLA82XX_CRB_RPMX_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX0)
+#define QLA82XX_CRB_RPMX_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX1)
+#define QLA82XX_CRB_RPMX_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX2)
+#define QLA82XX_CRB_RPMX_3 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX3)
+#define QLA82XX_CRB_RPMX_4 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX4)
+#define QLA82XX_CRB_RPMX_5 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX5)
+#define QLA82XX_CRB_RPMX_6 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX6)
+#define QLA82XX_CRB_RPMX_7 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX7)
+#define QLA82XX_CRB_SQM_MD_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS0)
+#define QLA82XX_CRB_SQM_MD_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS1)
+#define QLA82XX_CRB_SQM_MD_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS2)
+#define QLA82XX_CRB_SQM_MD_3 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS3)
+#define QLA82XX_CRB_SQM_NET_0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN0)
+#define QLA82XX_CRB_SQM_NET_1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN1)
+#define QLA82XX_CRB_SQM_NET_2 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN2)
+#define QLA82XX_CRB_SQM_NET_3 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN3)
+#define QLA82XX_CRB_SRE \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SRE)
+#define QLA82XX_CRB_TIMER \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_TIMR)
+#define QLA82XX_CRB_XDMA \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_XDMA)
+#define QLA82XX_CRB_I2C0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_I2C0)
+#define QLA82XX_CRB_I2C1 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_I2C1)
+#define QLA82XX_CRB_OCM0 \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_OCM0)
+#define QLA82XX_CRB_SMB \
+	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SMB)
+#define QLA82XX_CRB_MAX \
+	QLA82XX_PCI_CRB_WINDOW(64)
+
+/*
+ * ====================== BASE ADDRESSES ON-CHIP ======================
+ * Base addresses of major components on-chip.
+ * ====================== BASE ADDRESSES ON-CHIP ======================
+ */
+#define QLA82XX_ADDR_DDR_NET		(0x0000000000000000ULL)
+#define QLA82XX_ADDR_DDR_NET_MAX	(0x000000000fffffffULL)
+
+/* Imbus address bit used to indicate a host address. This bit is
+ * eliminated by the pcie bar and bar select before presentation
+ * over pcie. */
+/* host memory via IMBUS */
+#define QLA82XX_P2_ADDR_PCIE		(0x0000000800000000ULL)
+#define QLA82XX_P3_ADDR_PCIE		(0x0000008000000000ULL)
+#define QLA82XX_ADDR_PCIE_MAX		(0x0000000FFFFFFFFFULL)
+#define QLA82XX_ADDR_OCM0		(0x0000000200000000ULL)
+#define QLA82XX_ADDR_OCM0_MAX		(0x00000002000fffffULL)
+#define QLA82XX_ADDR_OCM1		(0x0000000200400000ULL)
+#define QLA82XX_ADDR_OCM1_MAX		(0x00000002004fffffULL)
+#define QLA82XX_ADDR_QDR_NET		(0x0000000300000000ULL)
+
+#define QLA82XX_P2_ADDR_QDR_NET_MAX	(0x00000003001fffffULL)
+#define QLA82XX_P3_ADDR_QDR_NET_MAX	(0x0000000303ffffffULL)
+
+#define QLA82XX_PCI_CRBSPACE		(unsigned long)0x06000000
+#define QLA82XX_PCI_DIRECT_CRB		(unsigned long)0x04400000
+#define QLA82XX_PCI_CAMQM		(unsigned long)0x04800000
+#define QLA82XX_PCI_CAMQM_MAX		(unsigned long)0x04ffffff
+#define QLA82XX_PCI_DDR_NET		(unsigned long)0x00000000
+#define QLA82XX_PCI_QDR_NET		(unsigned long)0x04000000
+#define QLA82XX_PCI_QDR_NET_MAX		(unsigned long)0x043fffff
+
+/*
+ *   Register offsets for MN
+ */
+#define MIU_CONTROL			(0x000)
+#define MIU_TAG				(0x004)
+#define MIU_TEST_AGT_CTRL		(0x090)
+#define MIU_TEST_AGT_ADDR_LO		(0x094)
+#define MIU_TEST_AGT_ADDR_HI		(0x098)
+#define MIU_TEST_AGT_WRDATA_LO		(0x0a0)
+#define MIU_TEST_AGT_WRDATA_HI		(0x0a4)
+#define MIU_TEST_AGT_WRDATA(i)		(0x0a0+(4*(i)))
+#define MIU_TEST_AGT_RDDATA_LO		(0x0a8)
+#define MIU_TEST_AGT_RDDATA_HI		(0x0ac)
+#define MIU_TEST_AGT_RDDATA(i)		(0x0a8+(4*(i)))
+#define MIU_TEST_AGT_ADDR_MASK		0xfffffff8
+#define MIU_TEST_AGT_UPPER_ADDR(off)	(0)
+
+/* MIU_TEST_AGT_CTRL flags. work for SIU as well */
+#define MIU_TA_CTL_START	1
+#define MIU_TA_CTL_ENABLE	2
+#define MIU_TA_CTL_WRITE	4
+#define MIU_TA_CTL_BUSY		8
+
+/*CAM RAM */
+# define QLA82XX_CAM_RAM_BASE		(QLA82XX_CRB_CAM + 0x02000)
+# define QLA82XX_CAM_RAM(reg)		(QLA82XX_CAM_RAM_BASE + (reg))
+
+#define QLA82XX_PEG_TUNE_MN_SPD_ZEROED	0x80000000
+#define QLA82XX_BOOT_LOADER_MN_ISSUE	0xff00ffff
+#define QLA82XX_PORT_MODE_ADDR		(QLA82XX_CAM_RAM(0x24))
+#define QLA82XX_PEG_HALT_STATUS1	(QLA82XX_CAM_RAM(0xa8))
+#define QLA82XX_PEG_HALT_STATUS2	(QLA82XX_CAM_RAM(0xac))
+#define QLA82XX_PEG_ALIVE_COUNTER	(QLA82XX_CAM_RAM(0xb0))
+
+#define QLA82XX_CAMRAM_DB1		(QLA82XX_CAM_RAM(0x1b8))
+#define QLA82XX_CAMRAM_DB2		(QLA82XX_CAM_RAM(0x1bc))
+
+#define HALT_STATUS_UNRECOVERABLE	0x80000000
+#define HALT_STATUS_RECOVERABLE		0x40000000
+
+/* Driver Coexistence Defines */
+#define QLA82XX_CRB_DRV_ACTIVE	     (QLA82XX_CAM_RAM(0x138))
+#define QLA82XX_CRB_DEV_STATE	     (QLA82XX_CAM_RAM(0x140))
+#define QLA82XX_CRB_DEV_PART_INFO    (QLA82XX_CAM_RAM(0x14c))
+#define QLA82XX_CRB_DRV_IDC_VERSION  (QLA82XX_CAM_RAM(0x174))
+#define QLA82XX_CRB_DRV_STATE	     (QLA82XX_CAM_RAM(0x144))
+#define QLA82XX_CRB_DRV_SCRATCH      (QLA82XX_CAM_RAM(0x148))
+#define QLA82XX_CRB_DEV_PART_INFO    (QLA82XX_CAM_RAM(0x14c))
+
+/* Every driver should use these Device State */
+#define QLA82XX_DEV_COLD	    1
+#define QLA82XX_DEV_INITIALIZING    2
+#define QLA82XX_DEV_READY	    3
+#define QLA82XX_DEV_NEED_RESET	    4
+#define QLA82XX_DEV_NEED_QUIESCENT  5
+#define QLA82XX_DEV_FAILED	    6
+#define QLA82XX_DEV_QUIESCENT	    7
+
+#define QLA82XX_IDC_VERSION			1
+#define QLA82XX_ROM_DEV_INIT_TIMEOUT		30
+#define QLA82XX_ROM_DRV_RESET_ACK_TIMEOUT	10
+
+#define QLA82XX_ROM_LOCK_ID		(QLA82XX_CAM_RAM(0x100))
+#define QLA82XX_CRB_WIN_LOCK_ID		(QLA82XX_CAM_RAM(0x124))
+#define QLA82XX_FW_VERSION_MAJOR	(QLA82XX_CAM_RAM(0x150))
+#define QLA82XX_FW_VERSION_MINOR	(QLA82XX_CAM_RAM(0x154))
+#define QLA82XX_FW_VERSION_SUB		(QLA82XX_CAM_RAM(0x158))
+#define QLA82XX_PCIE_REG(reg)		(QLA82XX_CRB_PCIE + (reg))
+
+#define PCIE_CHICKEN3			(0x120c8)
+#define PCIE_SETUP_FUNCTION		(0x12040)
+#define PCIE_SETUP_FUNCTION2		(0x12048)
+
+#define QLA82XX_PCIX_PS_REG(reg)	(QLA82XX_CRB_PCIX_MD + (reg))
+#define QLA82XX_PCIX_PS2_REG(reg)	(QLA82XX_CRB_PCIE2 + (reg))
+
+#define PCIE_SEM2_LOCK	     (0x1c010)	/* Flash lock	*/
+#define PCIE_SEM2_UNLOCK     (0x1c014)	/* Flash unlock */
+#define PCIE_SEM5_LOCK	     (0x1c028)	/* Coexistence lock   */
+#define PCIE_SEM5_UNLOCK     (0x1c02c)	/* Coexistence unlock */
+#define PCIE_SEM7_LOCK	     (0x1c038)	/* crb win lock */
+#define PCIE_SEM7_UNLOCK     (0x1c03c)	/* crbwin unlock*/
+
+/* Different drive state */
+#define QLA82XX_DRVST_NOT_RDY		0
+#define	QLA82XX_DRVST_RST_RDY		1
+#define QLA82XX_DRVST_QSNT_RDY		2
+
+/*
+ * The PCI VendorID and DeviceID for our board.
+ */
+#define PCI_DEVICE_ID_QLOGIC_ISP8021		0x8021
+
+#define QLA82XX_MSIX_TBL_SPACE			8192
+#define QLA82XX_PCI_REG_MSIX_TBL		0x44
+#define QLA82XX_PCI_MSIX_CONTROL		0x40
+
+struct crb_128M_2M_sub_block_map {
+	unsigned valid;
+	unsigned start_128M;
+	unsigned end_128M;
+	unsigned start_2M;
+};
+
+struct crb_128M_2M_block_map {
+	struct crb_128M_2M_sub_block_map sub_block[16];
+};
+
+struct crb_addr_pair {
+	long addr;
+	long data;
+};
+
+#define ADDR_ERROR ((unsigned long) 0xffffffff)
+#define MAX_CTL_CHECK	1000
+
+/***************************************************************************
+ *		PCI related defines.
+ **************************************************************************/
+
+/*
+ * Interrupt related defines.
+ */
+#define PCIX_TARGET_STATUS	(0x10118)
+#define PCIX_TARGET_STATUS_F1	(0x10160)
+#define PCIX_TARGET_STATUS_F2	(0x10164)
+#define PCIX_TARGET_STATUS_F3	(0x10168)
+#define PCIX_TARGET_STATUS_F4	(0x10360)
+#define PCIX_TARGET_STATUS_F5	(0x10364)
+#define PCIX_TARGET_STATUS_F6	(0x10368)
+#define PCIX_TARGET_STATUS_F7	(0x1036c)
+
+#define PCIX_TARGET_MASK	(0x10128)
+#define PCIX_TARGET_MASK_F1	(0x10170)
+#define PCIX_TARGET_MASK_F2	(0x10174)
+#define PCIX_TARGET_MASK_F3	(0x10178)
+#define PCIX_TARGET_MASK_F4	(0x10370)
+#define PCIX_TARGET_MASK_F5	(0x10374)
+#define PCIX_TARGET_MASK_F6	(0x10378)
+#define PCIX_TARGET_MASK_F7	(0x1037c)
+
+/*
+ * Message Signaled Interrupts
+ */
+#define PCIX_MSI_F0		(0x13000)
+#define PCIX_MSI_F1		(0x13004)
+#define PCIX_MSI_F2		(0x13008)
+#define PCIX_MSI_F3		(0x1300c)
+#define PCIX_MSI_F4		(0x13010)
+#define PCIX_MSI_F5		(0x13014)
+#define PCIX_MSI_F6		(0x13018)
+#define PCIX_MSI_F7		(0x1301c)
+#define PCIX_MSI_F(FUNC)	(0x13000 + ((FUNC) * 4))
+#define PCIX_INT_VECTOR		(0x10100)
+#define PCIX_INT_MASK		(0x10104)
+
+/*
+ * Interrupt state machine and other bits.
+ */
+#define PCIE_MISCCFG_RC		(0x1206c)
+
+#define ISR_INT_TARGET_STATUS \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS))
+#define ISR_INT_TARGET_STATUS_F1 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F1))
+#define ISR_INT_TARGET_STATUS_F2 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F2))
+#define ISR_INT_TARGET_STATUS_F3 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F3))
+#define ISR_INT_TARGET_STATUS_F4 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F4))
+#define ISR_INT_TARGET_STATUS_F5 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F5))
+#define ISR_INT_TARGET_STATUS_F6 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F6))
+#define ISR_INT_TARGET_STATUS_F7 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F7))
+
+#define ISR_INT_TARGET_MASK \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK))
+#define ISR_INT_TARGET_MASK_F1 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F1))
+#define ISR_INT_TARGET_MASK_F2 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F2))
+#define ISR_INT_TARGET_MASK_F3 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F3))
+#define ISR_INT_TARGET_MASK_F4 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F4))
+#define ISR_INT_TARGET_MASK_F5 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F5))
+#define ISR_INT_TARGET_MASK_F6 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F6))
+#define ISR_INT_TARGET_MASK_F7 \
+	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F7))
+
+#define ISR_INT_VECTOR \
+	(QLA82XX_PCIX_PS_REG(PCIX_INT_VECTOR))
+#define ISR_INT_MASK \
+	(QLA82XX_PCIX_PS_REG(PCIX_INT_MASK))
+#define ISR_INT_STATE_REG \
+	(QLA82XX_PCIX_PS_REG(PCIE_MISCCFG_RC))
+
+#define	ISR_MSI_INT_TRIGGER(FUNC) \
+	(QLA82XX_PCIX_PS_REG(PCIX_MSI_F(FUNC)))
+
+#define	ISR_IS_LEGACY_INTR_IDLE(VAL)		(((VAL) & 0x300) == 0)
+#define	ISR_IS_LEGACY_INTR_TRIGGERED(VAL)	(((VAL) & 0x300) == 0x200)
+
+/*
+ * PCI Interrupt Vector Values.
+ */
+#define	PCIX_INT_VECTOR_BIT_F0	0x0080
+#define	PCIX_INT_VECTOR_BIT_F1	0x0100
+#define	PCIX_INT_VECTOR_BIT_F2	0x0200
+#define	PCIX_INT_VECTOR_BIT_F3	0x0400
+#define	PCIX_INT_VECTOR_BIT_F4	0x0800
+#define	PCIX_INT_VECTOR_BIT_F5	0x1000
+#define	PCIX_INT_VECTOR_BIT_F6	0x2000
+#define	PCIX_INT_VECTOR_BIT_F7	0x4000
+
+struct qla82xx_legacy_intr_set {
+	uint32_t	int_vec_bit;
+	uint32_t	tgt_status_reg;
+	uint32_t	tgt_mask_reg;
+	uint32_t	pci_int_reg;
+};
+
+#define QLA82XX_LEGACY_INTR_CONFIG					\
+{									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F0,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS,		\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(0) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F1,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F1,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F1,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(1) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F2,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F2,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F2,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(2) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F3,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F3,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F3,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(3) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F4,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F4,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F4,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(4) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F5,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F5,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F5,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(5) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F6,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F6,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F6,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(6) },	\
+									\
+	{								\
+		.int_vec_bit	=	PCIX_INT_VECTOR_BIT_F7,		\
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F7,	\
+		.tgt_mask_reg	=	ISR_INT_TARGET_MASK_F7,		\
+		.pci_int_reg	=	ISR_MSI_INT_TRIGGER(7) },	\
+}
+
+#define	BOOTLD_START		0x10000
+#define	IMAGE_START		0x100000
+#define FLASH_ADDR_START	0x43000
+
+/* Magic number to let user know flash is programmed */
+#define QLA82XX_BDINFO_MAGIC	0x12345678
+#define FW_SIZE_OFFSET		(0x3e840c)
+
+#define QLA82XX_IS_REVISION_P3PLUS(_rev_)	((_rev_) >= 0x50)
+#define MIU_TEST_AGT_WRDATA_UPPER_LO		(0x0b0)
+#define	MIU_TEST_AGT_WRDATA_UPPER_HI		(0x0b4)
+
+#ifndef readq
+static inline u64 readq(void __iomem *addr)
+{
+	return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
+}
+#endif
+
+#ifndef writeq
+static inline void writeq(u64 val, void __iomem *addr)
+{
+	writel(((u32) (val)), (addr));
+	writel(((u32) (val >> 32)), (addr + 4));
+}
+#endif
+
+/* Request and response queue size */
+#define REQUEST_ENTRY_CNT_82XX		128	/* Number of request entries. */
+#define RESPONSE_ENTRY_CNT_82XX		128	/* Number of response entries.*/
+
+/*
+ * ISP 8021 I/O Register Set structure definitions.
+ */
+struct device_reg_82xx {
+	uint32_t req_q_out[64];		/* Request Queue out-Pointer (64 * 4) */
+	uint32_t rsp_q_in[64];		/* Response Queue In-Pointer. */
+	uint32_t rsp_q_out[64];		/* Response Queue Out-Pointer. */
+
+	uint16_t mailbox_in[32];	/* Mail box In registers */
+	uint16_t unused_1[32];
+	uint32_t hint;			/* Host interrupt register */
+#define	HINT_MBX_INT_PENDING	BIT_0
+	uint16_t unused_2[62];
+	uint16_t mailbox_out[32];	/* Mail box Out registers */
+	uint32_t unused_3[48];
+
+	uint32_t host_status;		/* host status */
+#define HSRX_RISC_INT		BIT_15	/* RISC to Host interrupt. */
+#define HSRX_RISC_PAUSED	BIT_8	/* RISC Paused. */
+	uint32_t host_int;		/* Interrupt status. */
+#define ISRX_NX_RISC_INT	BIT_0	/* RISC interrupt. */
+};
+
+struct fcp_cmnd {
+	struct scsi_lun lun;
+	uint8_t crn;
+	uint8_t task_attribute;
+	uint8_t task_managment;
+	uint8_t additional_cdb_len;
+	uint8_t cdb[260]; /* 256 for CDB len and 4 for FCP_DL */
+};
+
+struct dsd_dma {
+	struct list_head list;
+	dma_addr_t dsd_list_dma;
+	void *dsd_addr;
+};
+
+#define QLA_DSDS_PER_IOCB	37
+#define QLA_DSD_SIZE		12
+struct ct6_dsd {
+	uint16_t fcp_cmnd_len;
+	dma_addr_t fcp_cmnd_dma;
+	struct fcp_cmnd *fcp_cmnd;
+	int dsd_use_cnt;
+	struct list_head dsd_list;
+};
+
+#define MBC_TOGGLE_INTR			0x10
+
+/* Flash  offset */
+#define FLT_REG_BOOTLOAD_82XX	0x72
+#define FLT_REG_BOOT_CODE_82XX	0x78
+#define FLT_REG_FW_82XX		0x74
+#define FLT_REG_GOLD_FW_82XX	0x75
+#define FLT_REG_VPD_82XX	0x81
+
+#define	FA_VPD_SIZE_82XX	0x400
+
+#define FA_FLASH_LAYOUT_ADDR_82	0xFC400
+
+/******************************************************************************
+*
+*    Definitions specific to M25P flash
+*
+*******************************************************************************
+*   Instructions
+*/
+#define M25P_INSTR_WREN		0x06
+#define M25P_INSTR_WRDI		0x04
+#define M25P_INSTR_RDID		0x9f
+#define M25P_INSTR_RDSR		0x05
+#define M25P_INSTR_WRSR		0x01
+#define M25P_INSTR_READ		0x03
+#define M25P_INSTR_FAST_READ	0x0b
+#define M25P_INSTR_PP		0x02
+#define M25P_INSTR_SE		0xd8
+#define M25P_INSTR_BE		0xc7
+#define M25P_INSTR_DP		0xb9
+#define M25P_INSTR_RES		0xab
+
+#endif
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f318206..b1adeb7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -29,6 +29,11 @@ char qla2x00_version_str[40];
  */
 static struct kmem_cache *srb_cachep;
 
+/*
+ * CT6 CTX allocation cache
+ */
+static struct kmem_cache *ctx_cachep;
+
 int ql2xlogintimeout = 20;
 module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xlogintimeout,
@@ -65,6 +70,12 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 		"Option to enable extended error logging, "
 		"Default is 0 - no logging. 1 - log errors.");
 
+int ql2xshiftctondsd = 6;
+module_param(ql2xshiftctondsd, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xshiftctondsd,
+		"Set to control shifting of command type processing "
+		"based on total number of SG elements.");
+
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 int ql2xfdmienable=1;
@@ -114,6 +125,21 @@ MODULE_PARM_DESC(ql2xetsenable,
 		"Enables firmware ETS burst."
 		"Default is 0 - skip ETS enablement.");
 
+int ql2xdbwr;
+module_param(ql2xdbwr, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xdbwr,
+	"Option to specify scheme for request queue posting\n"
+	" 0 -- Regular doorbell.\n"
+	" 1 -- CAMRAM doorbell (faster).\n");
+
+int ql2xdontresethba;
+module_param(ql2xdontresethba, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xdontresethba,
+	"Option to specify reset behaviour\n"
+	" 0 (Default) -- Reset on failure.\n"
+	" 1 -- Do not reset on failure.\n");
+
+
 /*
  * SCSI host template entry points
  */
@@ -183,6 +209,10 @@ qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
 static inline void
 qla2x00_restart_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
+	/* Currently used for 82XX only. */
+	if (vha->device_flags & DFLG_DEV_FAILED)
+		return;
+
 	mod_timer(&vha->timer, jiffies + interval * HZ);
 }
 
@@ -739,7 +769,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		if (sp == NULL)
 			continue;
-		if (sp->ctx)
+		if ((sp->ctx) && !(sp->flags & SRB_FCP_CMND_DMA_VALID))
 			continue;
 		if (sp->cmd != cmd)
 			continue;
@@ -834,6 +864,24 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 	return status;
 }
 
+void qla82xx_wait_for_pending_commands(scsi_qla_host_t *vha)
+{
+	int cnt;
+	srb_t *sp;
+	struct req_que *req = vha->req;
+
+	DEBUG2(qla_printk(KERN_INFO, vha->hw,
+		"Waiting for pending commands\n"));
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
+			sp, WAIT_HOST) == QLA_SUCCESS) {
+			DEBUG2(qla_printk(KERN_INFO, vha->hw,
+				"Done wait for pending commands\n"));
+		}
+	}
+}
+
 static char *reset_errors[] = {
 	"HBA not online",
 	"HBA not ready",
@@ -1020,11 +1068,19 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		if (qla2x00_vp_abort_isp(vha))
 			goto eh_host_reset_lock;
 	} else {
+		if (IS_QLA82XX(vha->hw)) {
+			if (!qla82xx_fcoe_ctx_reset(vha)) {
+				/* Ctx reset success */
+				ret = SUCCESS;
+				goto eh_host_reset_lock;
+			}
+			/* fall thru if ctx reset failed */
+		}
 		if (ha->wq)
 			flush_workqueue(ha->wq);
 
 		set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-		if (qla2x00_abort_isp(base_vha)) {
+		if (ha->isp_ops->abort_isp(base_vha)) {
 			clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 			/* failed. schedule dpc to try */
 			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
@@ -1078,7 +1134,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 		}
 	}
 
-	if (ha->flags.enable_lip_full_login && !IS_QLA81XX(ha)) {
+	if (ha->flags.enable_lip_full_login && !IS_QLA8XXX_TYPE(ha)) {
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): failed: "
@@ -1125,7 +1181,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
 				req->outstanding_cmds[cnt] = NULL;
-				if (!sp->ctx) {
+				if (!sp->ctx ||
+				(sp->flags & SRB_FCP_CMND_DMA_VALID)) {
 					sp->cmd->result = res;
 					qla2x00_sp_compl(ha, sp);
 				} else {
@@ -1387,6 +1444,7 @@ static struct isp_operations qla2100_isp_ops = {
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
 	.start_scsi		= qla2x00_start_scsi,
+	.abort_isp		= qla2x00_abort_isp,
 };
 
 static struct isp_operations qla2300_isp_ops = {
@@ -1422,6 +1480,7 @@ static struct isp_operations qla2300_isp_ops = {
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
 	.start_scsi		= qla2x00_start_scsi,
+	.abort_isp		= qla2x00_abort_isp,
 };
 
 static struct isp_operations qla24xx_isp_ops = {
@@ -1457,6 +1516,7 @@ static struct isp_operations qla24xx_isp_ops = {
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_start_scsi,
+	.abort_isp		= qla2x00_abort_isp,
 };
 
 static struct isp_operations qla25xx_isp_ops = {
@@ -1492,6 +1552,7 @@ static struct isp_operations qla25xx_isp_ops = {
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_start_scsi,
+	.abort_isp		= qla2x00_abort_isp,
 };
 
 static struct isp_operations qla81xx_isp_ops = {
@@ -1527,6 +1588,43 @@ static struct isp_operations qla81xx_isp_ops = {
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_start_scsi,
+	.abort_isp		= qla2x00_abort_isp,
+};
+
+static struct isp_operations qla82xx_isp_ops = {
+	.pci_config		= qla82xx_pci_config,
+	.reset_chip		= qla82xx_reset_chip,
+	.chip_diag		= qla24xx_chip_diag,
+	.config_rings		= qla82xx_config_rings,
+	.reset_adapter		= qla24xx_reset_adapter,
+	.nvram_config		= qla81xx_nvram_config,
+	.update_fw_options	= qla24xx_update_fw_options,
+	.load_risc		= qla82xx_load_risc,
+	.pci_info_str		= qla82xx_pci_info_str,
+	.fw_version_str		= qla24xx_fw_version_str,
+	.intr_handler		= qla82xx_intr_handler,
+	.enable_intrs		= qla82xx_enable_intrs,
+	.disable_intrs		= qla82xx_disable_intrs,
+	.abort_command		= qla24xx_abort_command,
+	.target_reset		= qla24xx_abort_target,
+	.lun_reset		= qla24xx_lun_reset,
+	.fabric_login		= qla24xx_login_fabric,
+	.fabric_logout		= qla24xx_fabric_logout,
+	.calc_req_entries	= NULL,
+	.build_iocbs		= NULL,
+	.prep_ms_iocb		= qla24xx_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla24xx_prep_ms_fdmi_iocb,
+	.read_nvram		= qla24xx_read_nvram_data,
+	.write_nvram		= qla24xx_write_nvram_data,
+	.fw_dump		= qla24xx_fw_dump,
+	.beacon_on		= qla24xx_beacon_on,
+	.beacon_off		= qla24xx_beacon_off,
+	.beacon_blink		= qla24xx_beacon_blink,
+	.read_optrom		= qla82xx_read_optrom_data,
+	.write_optrom		= qla82xx_write_optrom_data,
+	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi             = qla82xx_start_scsi,
+	.abort_isp		= qla82xx_abort_isp,
 };
 
 static inline void
@@ -1615,10 +1713,22 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP8021:
+		ha->device_type |= DT_ISP8021;
+		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
+		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
+		/* Initialize 82XX ISP flags */
+		qla82xx_init_flags(ha);
+		break;
 	}
 
-	/* Get adapter physical port no from interrupt pin register. */
-	pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
+	if (IS_QLA82XX(ha))
+		ha->port_no = !(ha->portnum & 1);
+	else
+		/* Get adapter physical port no from interrupt pin register. */
+		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
+
 	if (ha->port_no & 1)
 		ha->flags.port0 = 1;
 	else
@@ -1632,6 +1742,9 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 	uint16_t msix;
 	int cpus;
 
+	if (IS_QLA82XX(ha))
+		return qla82xx_iospace_config(ha);
+
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
 		qla_printk(KERN_WARNING, ha,
@@ -1775,7 +1888,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8001) {
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8001 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8021) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		mem_only = 1;
 	}
@@ -1905,6 +2019,19 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA_81XX;
 		ha->nvram_conf_off = ~0;
 		ha->nvram_data_off = ~0;
+	} else if (IS_QLA82XX(ha)) {
+		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		req_length = REQUEST_ENTRY_CNT_82XX;
+		rsp_length = RESPONSE_ENTRY_CNT_82XX;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
+		ha->gid_list_info_size = 8;
+		ha->optrom_size = OPTROM_SIZE_82XX;
+		ha->isp_ops = &qla82xx_isp_ops;
+		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
+		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;
+		ha->nvram_conf_off = FARX_ACCESS_NVRAM_CONF;
+		ha->nvram_data_off = FARX_ACCESS_NVRAM_DATA;
 	}
 
 	mutex_init(&ha->vport_lock);
@@ -1977,6 +2104,7 @@ que_init:
 		" pointers\n");
 		goto probe_init_failed;
 	}
+
 	ha->rsp_q_map[0] = rsp;
 	ha->req_q_map[0] = req;
 	rsp->req = req;
@@ -1995,6 +2123,12 @@ que_init:
 		rsp->rsp_q_out =  &ha->mqiobase->isp25mq.rsp_q_out;
 	}
 
+	if (IS_QLA82XX(ha)) {
+		req->req_q_out = &ha->iobase->isp82.req_q_out[0];
+		rsp->rsp_q_in = &ha->iobase->isp82.rsp_q_in[0];
+		rsp->rsp_q_out = &ha->iobase->isp82.rsp_q_out[0];
+	}
+
 	if (qla2x00_initialize_adapter(base_vha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
@@ -2003,6 +2137,14 @@ que_init:
 		    "Adapter flags %x.\n",
 		    base_vha->host_no, base_vha->device_flags));
 
+		if (IS_QLA82XX(ha)) {
+			qla82xx_idc_lock(ha);
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+				QLA82XX_DEV_FAILED);
+			qla82xx_idc_unlock(ha);
+			qla_printk(KERN_INFO, ha, "HW State: FAILED\n");
+		}
+
 		ret = -ENODEV;
 		goto probe_failed;
 	}
@@ -2041,6 +2183,8 @@ skip_dpc:
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    base_vha->host_no, ha));
 
+	ha->isp_ops->enable_intrs(ha);
+
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
@@ -2048,8 +2192,6 @@ skip_dpc:
 	base_vha->flags.init_done = 1;
 	base_vha->flags.online = 1;
 
-	ha->isp_ops->enable_intrs(ha);
-
 	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(base_vha);
@@ -2091,9 +2233,17 @@ probe_failed:
 	scsi_host_put(base_vha->host);
 
 probe_hw_failed:
-	if (ha->iobase)
-		iounmap(ha->iobase);
-
+	if (IS_QLA82XX(ha)) {
+		qla82xx_idc_lock(ha);
+		qla82xx_clear_drv_active(ha);
+		qla82xx_idc_unlock(ha);
+		iounmap((device_reg_t __iomem *)ha->nx_pcibase);
+		if (!ql2xdbwr)
+			iounmap((device_reg_t __iomem *)ha->nxdb_wr_ptr);
+	} else {
+		if (ha->iobase)
+			iounmap(ha->iobase);
+	}
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
 	ha = NULL;
@@ -2160,11 +2310,17 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_host_put(base_vha->host);
 
-	if (ha->iobase)
-		iounmap(ha->iobase);
+	if (IS_QLA82XX(ha)) {
+		iounmap((device_reg_t __iomem *)ha->nx_pcibase);
+		if (!ql2xdbwr)
+			iounmap((device_reg_t __iomem *)ha->nxdb_wr_ptr);
+	} else {
+		if (ha->iobase)
+			iounmap(ha->iobase);
 
-	if (ha->mqiobase)
-		iounmap(ha->mqiobase);
+		if (ha->mqiobase)
+			iounmap(ha->mqiobase);
+	}
 
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
@@ -2213,8 +2369,10 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	vha->flags.online = 0;
 
 	/* turn-off interrupts on the card */
-	if (ha->interrupts_on)
+	if (ha->interrupts_on) {
+		vha->flags.init_done = 0;
 		ha->isp_ops->disable_intrs(ha);
+	}
 
 	qla2x00_free_irqs(vha);
 
@@ -2359,10 +2517,25 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->srb_mempool)
 		goto fail_free_gid_list;
 
+	if (IS_QLA82XX(ha)) {
+		/* Allocate cache for CT6 Ctx. */
+		if (!ctx_cachep) {
+			ctx_cachep = kmem_cache_create("qla2xxx_ctx",
+				sizeof(struct ct6_dsd), 0,
+				SLAB_HWCACHE_ALIGN, NULL);
+			if (!ctx_cachep)
+				goto fail_free_gid_list;
+		}
+		ha->ctx_mempool = mempool_create_slab_pool(SRB_MIN_REQ,
+			ctx_cachep);
+		if (!ha->ctx_mempool)
+			goto fail_free_srb_mempool;
+	}
+
 	/* Get memory for cached NVRAM */
 	ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
 	if (!ha->nvram)
-		goto fail_free_srb_mempool;
+		goto fail_free_ctx_mempool;
 
 	snprintf(name, sizeof(name), "%s_%d", QLA2XXX_DRIVER_NAME,
 		ha->pdev->device);
@@ -2371,6 +2544,24 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->s_dma_pool)
 		goto fail_free_nvram;
 
+	if (IS_QLA82XX(ha)) {
+		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+			DSD_LIST_DMA_POOL_SIZE, 8, 0);
+		if (!ha->dl_dma_pool) {
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - dl_dma_pool\n");
+			goto fail_s_dma_pool;
+		}
+
+		ha->fcp_cmnd_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+			FCP_CMND_DMA_POOL_SIZE, 8, 0);
+		if (!ha->fcp_cmnd_dma_pool) {
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - fcp_cmnd_dma_pool\n");
+			goto fail_dl_dma_pool;
+		}
+	}
+
 	/* Allocate memory for SNS commands */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 	/* Get consistent memory allocated for SNS commands */
@@ -2437,13 +2628,15 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		ha->npiv_info = NULL;
 
 	/* Get consistent memory allocated for EX-INIT-CB. */
-	if (IS_QLA81XX(ha)) {
+	if (IS_QLA8XXX_TYPE(ha)) {
 		ha->ex_init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
 		    &ha->ex_init_cb_dma);
 		if (!ha->ex_init_cb)
 			goto fail_ex_init_cb;
 	}
 
+	INIT_LIST_HEAD(&ha->gbl_dsd_list);
+
 	INIT_LIST_HEAD(&ha->vp_list);
 	return 1;
 
@@ -2473,11 +2666,24 @@ fail_free_ms_iocb:
 	ha->ms_iocb = NULL;
 	ha->ms_iocb_dma = 0;
 fail_dma_pool:
+	if (IS_QLA82XX(ha)) {
+		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
+		ha->fcp_cmnd_dma_pool = NULL;
+	}
+fail_dl_dma_pool:
+	if (IS_QLA82XX(ha)) {
+		dma_pool_destroy(ha->dl_dma_pool);
+		ha->dl_dma_pool = NULL;
+	}
+fail_s_dma_pool:
 	dma_pool_destroy(ha->s_dma_pool);
 	ha->s_dma_pool = NULL;
 fail_free_nvram:
 	kfree(ha->nvram);
 	ha->nvram = NULL;
+fail_free_ctx_mempool:
+	mempool_destroy(ha->ctx_mempool);
+	ha->ctx_mempool = NULL;
 fail_free_srb_mempool:
 	mempool_destroy(ha->srb_mempool);
 	ha->srb_mempool = NULL;
@@ -2546,7 +2752,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 
 	if (ha->ex_init_cb)
-		dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
+		dma_pool_free(ha->s_dma_pool,
+			ha->ex_init_cb, ha->ex_init_cb_dma);
 
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
@@ -2555,14 +2762,39 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
 		ha->gid_list_dma);
 
+	if (IS_QLA82XX(ha)) {
+		if (!list_empty(&ha->gbl_dsd_list)) {
+			struct dsd_dma *dsd_ptr, *tdsd_ptr;
+
+			/* clean up allocated prev pool */
+			list_for_each_entry_safe(dsd_ptr,
+				tdsd_ptr, &ha->gbl_dsd_list, list) {
+				dma_pool_free(ha->dl_dma_pool,
+				dsd_ptr->dsd_addr, dsd_ptr->dsd_list_dma);
+				list_del(&dsd_ptr->list);
+				kfree(dsd_ptr);
+			}
+		}
+	}
+
+	if (ha->dl_dma_pool)
+		dma_pool_destroy(ha->dl_dma_pool);
+
+	if (ha->fcp_cmnd_dma_pool)
+		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
+
+	if (ha->ctx_mempool)
+		mempool_destroy(ha->ctx_mempool);
+
 	if (ha->init_cb)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
-		ha->init_cb, ha->init_cb_dma);
+			ha->init_cb, ha->init_cb_dma);
 	vfree(ha->optrom_buffer);
 	kfree(ha->nvram);
 	kfree(ha->npiv_info);
 
 	ha->srb_mempool = NULL;
+	ha->ctx_mempool = NULL;
 	ha->eft = NULL;
 	ha->eft_dma = 0;
 	ha->sns_cmd = NULL;
@@ -2577,6 +2809,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->ex_init_cb_dma = 0;
 
 	ha->s_dma_pool = NULL;
+	ha->dl_dma_pool = NULL;
+	ha->fcp_cmnd_dma_pool = NULL;
 
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
@@ -2904,6 +3138,45 @@ qla2x00_do_dpc(void *data)
 
 		qla2x00_do_work(base_vha);
 
+		if (IS_QLA82XX(ha)) {
+			if (test_and_clear_bit(ISP_UNRECOVERABLE,
+				&base_vha->dpc_flags)) {
+				qla82xx_idc_lock(ha);
+				qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+					QLA82XX_DEV_FAILED);
+				qla82xx_idc_unlock(ha);
+				qla_printk(KERN_INFO, ha,
+					"HW State: FAILED\n");
+				qla82xx_device_state_handler(base_vha);
+				continue;
+			}
+
+			if (test_and_clear_bit(FCOE_CTX_RESET_NEEDED,
+				&base_vha->dpc_flags)) {
+
+				DEBUG(printk(KERN_INFO
+					"scsi(%ld): dpc: sched "
+					"qla82xx_fcoe_ctx_reset ha = %p\n",
+					base_vha->host_no, ha));
+				if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
+					&base_vha->dpc_flags))) {
+					if (qla82xx_fcoe_ctx_reset(base_vha)) {
+						/* FCoE-ctx reset failed.
+						 * Escalate to chip-reset
+						 */
+						set_bit(ISP_ABORT_NEEDED,
+							&base_vha->dpc_flags);
+					}
+					clear_bit(ABORT_ISP_ACTIVE,
+						&base_vha->dpc_flags);
+				}
+
+				DEBUG(printk("scsi(%ld): dpc:"
+					" qla82xx_fcoe_ctx_reset end\n",
+					base_vha->host_no));
+			}
+		}
+
 		if (test_and_clear_bit(ISP_ABORT_NEEDED,
 						&base_vha->dpc_flags)) {
 
@@ -2913,7 +3186,7 @@ qla2x00_do_dpc(void *data)
 			if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
 			    &base_vha->dpc_flags))) {
 
-				if (qla2x00_abort_isp(base_vha)) {
+				if (ha->isp_ops->abort_isp(base_vha)) {
 					/* failed. retry later */
 					set_bit(ISP_ABORT_NEEDED,
 					    &base_vha->dpc_flags);
@@ -3061,8 +3334,18 @@ qla2x00_sp_compl(struct qla_hw_data *ha, srb_t *sp)
 
 	qla2x00_sp_free_dma(sp);
 
-	mempool_free(sp, ha->srb_mempool);
+	if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
+		struct ct6_dsd *ctx = sp->ctx;
+		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd,
+			ctx->fcp_cmnd_dma);
+		list_splice(&ctx->dsd_list, &ha->gbl_dsd_list);
+		ha->gbl_dsd_inuse -= ctx->dsd_use_cnt;
+		ha->gbl_dsd_avail += ctx->dsd_use_cnt;
+		mempool_free(sp->ctx, ha->ctx_mempool);
+		sp->ctx = NULL;
+	}
 
+	mempool_free(sp, ha->srb_mempool);
 	cmd->scsi_done(cmd);
 }
 
@@ -3087,6 +3370,9 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 
+	if (IS_QLA82XX(ha))
+		qla82xx_watchdog(vha);
+
 	/* Hardware read to raise pending EEH errors during mailbox waits. */
 	if (!pci_channel_offline(ha->pdev))
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
@@ -3201,6 +3487,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	    start_dpc ||
 	    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) ||
 	    test_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags) ||
+	    test_bit(ISP_UNRECOVERABLE, &vha->dpc_flags) ||
+	    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags) ||
 	    test_bit(VP_DPC_NEEDED, &vha->dpc_flags) ||
 	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags)))
 		qla2xxx_wake_dpc(vha);
@@ -3210,7 +3498,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 
 /* Firmware interface routines. */
 
-#define FW_BLOBS	7
+#define FW_BLOBS	8
 #define FW_ISP21XX	0
 #define FW_ISP22XX	1
 #define FW_ISP2300	2
@@ -3218,6 +3506,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 #define FW_ISP24XX	4
 #define FW_ISP25XX	5
 #define FW_ISP81XX	6
+#define FW_ISP82XX	7
 
 #define FW_FILE_ISP21XX	"ql2100_fw.bin"
 #define FW_FILE_ISP22XX	"ql2200_fw.bin"
@@ -3226,6 +3515,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
 #define FW_FILE_ISP81XX	"ql8100_fw.bin"
+#define FW_FILE_ISP82XX	"ql8200_fw.bin"
 
 static DEFINE_MUTEX(qla_fw_lock);
 
@@ -3237,6 +3527,7 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP24XX, },
 	{ .name = FW_FILE_ISP25XX, },
 	{ .name = FW_FILE_ISP81XX, },
+	{ .name = FW_FILE_ISP82XX, },
 };
 
 struct fw_blob *
@@ -3260,6 +3551,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP25XX];
 	} else if (IS_QLA81XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP81XX];
+	} else if (IS_QLA82XX(ha)) {
+		blob = &qla_fw_blobs[FW_ISP82XX];
 	}
 
 	mutex_lock(&qla_fw_lock);
@@ -3400,7 +3693,7 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		msleep(1000);
 
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-	if (qla2x00_abort_isp(base_vha) == QLA_SUCCESS)
+	if (ha->isp_ops->abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
@@ -3453,6 +3746,7 @@ static struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5432) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2532) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8001) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8021) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
@@ -3524,6 +3818,8 @@ qla2x00_module_exit(void)
 	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
+	if (ctx_cachep)
+		kmem_cache_destroy(ctx_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 	fc_release_transport(qla2xxx_transport_vport_template);
 }
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index e74552c..de92504 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -423,9 +423,6 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 /* Flash Manipulation Routines                                               */
 /*****************************************************************************/
 
-#define OPTROM_BURST_SIZE	0x1000
-#define OPTROM_BURST_DWORDS	(OPTROM_BURST_SIZE / 4)
-
 static inline uint32_t
 flash_conf_addr(struct qla_hw_data *ha, uint32_t faddr)
 {
@@ -565,6 +562,10 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 		*start = FA_FLASH_LAYOUT_ADDR;
 	else if (IS_QLA81XX(ha))
 		*start = FA_FLASH_LAYOUT_ADDR_81;
+	else if (IS_QLA82XX(ha)) {
+		*start = FA_FLASH_LAYOUT_ADDR_82;
+		goto end;
+	}
 	/* Begin with first PCI expansion ROM header. */
 	buf = (uint8_t *)req->ring;
 	dcode = (uint32_t *)req->ring;
@@ -709,10 +710,14 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			break;
 		case FLT_REG_VPD_0:
 			ha->flt_region_vpd_nvram = start;
+			if (IS_QLA82XX(ha))
+				break;
 			if (ha->flags.port0)
 				ha->flt_region_vpd = start;
 			break;
 		case FLT_REG_VPD_1:
+			if (IS_QLA82XX(ha))
+				break;
 			if (!ha->flags.port0)
 				ha->flt_region_vpd = start;
 			break;
@@ -746,6 +751,21 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			if (!ha->flags.port0)
 				ha->flt_region_fcp_prio = start;
 			break;
+		case FLT_REG_BOOT_CODE_82XX:
+			ha->flt_region_boot = start;
+			break;
+		case FLT_REG_FW_82XX:
+			ha->flt_region_fw = start;
+			break;
+		case FLT_REG_GOLD_FW_82XX:
+			ha->flt_region_gold_fw = start;
+			break;
+		case FLT_REG_BOOTLOAD_82XX:
+			ha->flt_region_bootload = start;
+			break;
+		case FLT_REG_VPD_82XX:
+			ha->flt_region_vpd = start;
+			break;
 		}
 	}
 	goto done;
@@ -791,7 +811,7 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	uint16_t *wptr;
 	struct qla_fdt_layout *fdt;
 	uint8_t	man_id, flash_id;
-	uint16_t mid, fid;
+	uint16_t mid = 0, fid = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 
@@ -832,6 +852,10 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	goto done;
 no_flash_data:
 	loc = locations[0];
+	if (IS_QLA82XX(ha)) {
+		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		goto done;
+	}
 	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
 	mid = man_id;
 	fid = flash_id;
@@ -869,6 +893,31 @@ done:
 	    ha->fdt_block_size));
 }
 
+static void
+qla2xxx_get_idc_param(scsi_qla_host_t *vha)
+{
+#define QLA82XX_IDC_PARAM_ADDR       0x003e885c
+	uint32_t *wptr;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+
+	if (!IS_QLA82XX(ha))
+		return;
+
+	wptr = (uint32_t *)req->ring;
+	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
+		QLA82XX_IDC_PARAM_ADDR , 8);
+
+	if (*wptr == __constant_cpu_to_le32(0xffffffff)) {
+		ha->nx_dev_init_timeout = QLA82XX_ROM_DEV_INIT_TIMEOUT;
+		ha->nx_reset_timeout = QLA82XX_ROM_DRV_RESET_ACK_TIMEOUT;
+	} else {
+		ha->nx_dev_init_timeout = le32_to_cpu(*wptr++);
+		ha->nx_reset_timeout = le32_to_cpu(*wptr);
+	}
+	return;
+}
+
 int
 qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 {
@@ -876,7 +925,7 @@ qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 	uint32_t flt_addr;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_QLA81XX(ha))
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_QLA8XXX_TYPE(ha))
 		return QLA_SUCCESS;
 
 	ret = qla2xxx_find_flt_start(vha, &flt_addr);
@@ -885,6 +934,7 @@ qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 
 	qla2xxx_get_flt_info(vha, flt_addr);
 	qla2xxx_get_fdt_info(vha);
+	qla2xxx_get_idc_param(vha);
 
 	return QLA_SUCCESS;
 }
@@ -901,7 +951,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	struct qla_npiv_entry *entry;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_QLA81XX(ha))
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_QLA8XXX_TYPE(ha))
 		return;
 
 	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
@@ -1194,6 +1244,9 @@ qla24xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 	uint32_t *dwptr;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA82XX(ha))
+		return  buf;
+
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++)
@@ -1249,6 +1302,9 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 
 	ret = QLA_SUCCESS;
 
+	if (IS_QLA82XX(ha))
+		return ret;
+
 	/* Enable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
@@ -1360,6 +1416,9 @@ qla2x00_beacon_blink(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
+	if (IS_QLA82XX(ha))
+		return;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Save the Original GPIOE. */
@@ -1541,6 +1600,9 @@ qla24xx_beacon_on(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (IS_QLA82XX(ha))
+		return QLA_SUCCESS;
+
 	if (ha->beacon_blink_led == 0) {
 		/* Enable firmware for update */
 		ha->fw_options[1] |= ADD_FO1_DISABLE_GPIO_LED_CTRL;
@@ -1583,6 +1645,9 @@ qla24xx_beacon_off(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (IS_QLA82XX(ha))
+		return QLA_SUCCESS;
+
 	ha->beacon_blink_led = 0;
 	ha->beacon_color_state = QLA_LED_ALL_ON;
 
@@ -2592,6 +2657,9 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	int i;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA82XX(ha))
+		return ret;
+
 	if (!mbuf)
 		return QLA_FUNCTION_FAILED;
 
-- 
1.6.2.rc1.30.gd43c

