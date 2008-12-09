From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH 22/31] scsi: Make static
Date: Tue, 09 Dec 2008 23:52:37 +0100
Message-ID: <493EF6B5.8090303@gmail.com>
References: <493EA286.7080500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755786AbYLIWwx@vger.kernel.org>
In-Reply-To: <493EA286.7080500@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c   |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    3 +-
 drivers/scsi/dpt_i2o.c                |    2 +-
 drivers/scsi/gdth.c                   |    4 +-
 drivers/scsi/hptiop.c                 |    2 +-
 drivers/scsi/initio.c                 |   23 +++++++++++----------
 drivers/scsi/ips.c                    |    8 ++----
 drivers/scsi/megaraid/megaraid_mbox.c |    6 ++--
 drivers/scsi/ncr53c8xx.c              |   16 +++++++-------
 drivers/scsi/osst.c                   |   12 +++++-----
 drivers/scsi/pas16.c                  |    2 +-
 drivers/scsi/scsi_debug.c             |   35 +++++++++++++++++----------------
 drivers/scsi/scsi_sysfs.c             |    4 +-
 drivers/scsi/ses.c                    |    2 +-
 drivers/scsi/st.c                     |   10 ++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |    6 ++--
 drivers/scsi/t128.c                   |    3 +-
 17 files changed, 70 insertions(+), 70 deletions(-)

Note that there are many {DEVICE,DRIVER}_ATTR, but I think they can be static as
well.

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index e6f2bb7..7605720 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2213,7 +2213,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
  * by the capabilities of the bus connectivity of and sync settings for
  * the target.
  */
-const struct ahc_syncrate *
+static const struct ahc_syncrate *
 ahc_devlimited_syncrate(struct ahc_softc *ahc,
 			struct ahc_initiator_tinfo *tinfo,
 			u_int *period, u_int *ppr_options, role_t role)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fd2b978..40e5097 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1147,8 +1147,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
  * or forcing transfer negotiations on the next command to any
  * target.
  */
-void
-ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc)
+void static ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc)
 {
 	int i;
 	int numtarg;
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 6194ed5..f76c502 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3593,7 +3593,7 @@ static int adpt_i2o_systab_send(adpt_hba* pHba)
 
 #ifdef UARTDELAY 
 
-static static void adpt_delay(int millisec)
+static void adpt_delay(int millisec)
 {
 	int i;
 	for (i = 0; i < millisec; i++) {
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index fb247fd..285cf36 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -440,8 +440,8 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 		scp->scsi_done(scp);
 }
 
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-                   int timeout, u32 *info)
+static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
+		char *cmnd, int timeout, u32 *info)
 {
     gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index a48e499..7151964 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -608,7 +608,7 @@ static void hptiop_host_request_callback_itl(struct hptiop_hba *hba, u32 _tag)
 	hptiop_finish_scsi_req(hba, tag, req);
 }
 
-void hptiop_iop_request_callback_itl(struct hptiop_hba *hba, u32 tag)
+static void hptiop_iop_request_callback_itl(struct hptiop_hba *hba, u32 tag)
 {
 	struct hpt_iop_request_header __iomem *req;
 	struct hpt_iop_request_ioctl_command __iomem *p;
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e3f7397..df2c5ea 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -335,7 +335,7 @@ static void initio_se2_instr(unsigned long base, u8 instr)
  *
  *	Enable erase/write state of serial EEPROM
  */
-void initio_se2_ew_en(unsigned long base)
+static void initio_se2_ew_en(unsigned long base)
 {
 	initio_se2_instr(base, 0x30);	/* EWEN */
 	outb(0, base + TUL_NVRAM);	/* -CS  */
@@ -349,7 +349,7 @@ void initio_se2_ew_en(unsigned long base)
  *
  *	Disable erase/write state of serial EEPROM
  */
-void initio_se2_ew_ds(unsigned long base)
+static void initio_se2_ew_ds(unsigned long base)
 {
 	initio_se2_instr(base, 0);	/* EWDS */
 	outb(0, base + TUL_NVRAM);	/* -CS  */
@@ -894,7 +894,8 @@ static void initio_unlink_busy_scb(struct initio_host * host, struct scsi_ctrl_b
 	return;
 }
 
-struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun)
+static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host *host,
+		u16 tarlun)
 {
 	struct scsi_ctrl_blk *tmp, *prev;
 	u16 scbp_tarlun;
@@ -932,7 +933,7 @@ static void initio_append_done_scb(struct initio_host * host, struct scsi_ctrl_b
 	}
 }
 
-struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host * host)
+static struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *tmp;
 
@@ -1670,7 +1671,7 @@ static int initio_state_6(struct initio_host * host)
  *
  */
 
-int initio_state_7(struct initio_host * host)
+static int initio_state_7(struct initio_host *host)
 {
 	int cnt, i;
 
@@ -1756,7 +1757,7 @@ static int initio_xfer_data_out(struct initio_host * host)
 	return 0;		/* return to OS, wait xfer done , let jas_isr come in */
 }
 
-int initio_xpad_in(struct initio_host * host)
+static int initio_xpad_in(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
@@ -1780,7 +1781,7 @@ int initio_xpad_in(struct initio_host * host)
 	}
 }
 
-int initio_xpad_out(struct initio_host * host)
+static int initio_xpad_out(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
@@ -1805,7 +1806,7 @@ int initio_xpad_out(struct initio_host * host)
 	}
 }
 
-int initio_status_msg(struct initio_host * host)
+static int initio_status_msg(struct initio_host *host)
 {				/* status & MSG_IN */
 	struct scsi_ctrl_blk *scb = host->active;
 	u8 msg;
@@ -1855,7 +1856,7 @@ int initio_status_msg(struct initio_host * host)
 
 
 /* scsi bus free */
-int int_initio_busfree(struct initio_host * host)
+static int int_initio_busfree(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 
@@ -1925,7 +1926,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
  *	and continue processing that command.
  */
 
-int int_initio_resel(struct initio_host * host)
+static int int_initio_resel(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb;
 	struct target_control *active_tc;
@@ -2381,7 +2382,7 @@ static void initio_select_atn3(struct initio_host * host, struct scsi_ctrl_blk *
  *	Perform a device reset and abort all pending SCBs for the
  *	victim device
  */
-int initio_bus_device_reset(struct initio_host * host)
+static int initio_bus_device_reset(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index ef683f0..e53c1a4 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -780,7 +780,7 @@ ips_halt(struct notifier_block *nb, ulong event, void *buf)
 /*   Abort a command (using the new error code stuff)                       */
 /* Note: this routine is called under the io_request_lock                   */
 /****************************************************************************/
-int ips_eh_abort(struct scsi_cmnd *SC)
+static int ips_eh_abort(struct scsi_cmnd *SC)
 {
 	ips_ha_t *ha;
 	ips_copp_wait_item_t *item;
@@ -1271,8 +1271,7 @@ do_ipsintr(int irq, void *dev_id)
 /*   ASSUMES interrupts are disabled                                        */
 /*                                                                          */
 /****************************************************************************/
-int
-ips_intr_copperhead(ips_ha_t * ha)
+static int ips_intr_copperhead(ips_ha_t *ha)
 {
 	ips_stat_t *sp;
 	ips_scb_t *scb;
@@ -1335,8 +1334,7 @@ ips_intr_copperhead(ips_ha_t * ha)
 /*   ASSUMES interrupts are disabled                                        */
 /*                                                                          */
 /****************************************************************************/
-int
-ips_intr_morpheus(ips_ha_t * ha)
+static int ips_intr_morpheus(ips_ha_t *ha)
 {
 	ips_stat_t *sp;
 	ips_scb_t *scb;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 805bb61..58a7183 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -313,8 +313,8 @@ static struct pci_driver megaraid_pci_driver = {
 // definitions for the device attributes for exporting logical drive number
 // for a scsi address (Host, Channel, Id, Lun)
 
-DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR, megaraid_sysfs_show_app_hndl,
-		NULL);
+static DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR,
+		megaraid_sysfs_show_app_hndl, NULL);
 
 // Host template initializer for megaraid mbox sysfs device attributes
 static struct device_attribute *megaraid_shost_attrs[] = {
@@ -323,7 +323,7 @@ static struct device_attribute *megaraid_shost_attrs[] = {
 };
 
 
-DEVICE_ATTR(megaraid_mbox_ld, S_IRUSR, megaraid_sysfs_show_ldnum, NULL);
+static DEVICE_ATTR(megaraid_mbox_ld, S_IRUSR, megaraid_sysfs_show_ldnum, NULL);
 
 // Host template initializer for megaraid mbox sysfs device attributes
 static struct device_attribute *megaraid_sdev_attrs[] = {
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 3b7240e..43579f1 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -3442,7 +3442,7 @@ static	struct scripth scripth0 __initdata = {
 **==========================================================
 */
 
-void __init ncr_script_fill (struct script * scr, struct scripth * scrh)
+static void __init ncr_script_fill(struct script *scr, struct scripth *scrh)
 {
 	int	i;
 	ncrcmd	*p;
@@ -4813,7 +4813,7 @@ static void ncr_detach(struct ncb *np)
 **==========================================================
 */
 
-void ncr_complete (struct ncb *np, struct ccb *cp)
+static void ncr_complete(struct ncb *np, struct ccb *cp)
 {
 	struct scsi_cmnd *cmd;
 	struct tcb *tp;
@@ -5113,7 +5113,7 @@ static void ncr_ccb_skipped(struct ncb *np, struct ccb *cp)
 **	The NCR has completed CCBs.
 **	Look at the DONE QUEUE if enabled, otherwise scan all CCBs
 */
-void ncr_wakeup_done (struct ncb *np)
+static void ncr_wakeup_done(struct ncb *np)
 {
 	struct ccb *cp;
 #ifdef SCSI_NCR_CCB_DONE_SUPPORT
@@ -5159,7 +5159,7 @@ void ncr_wakeup_done (struct ncb *np)
 /*
 **	Complete all active CCBs.
 */
-void ncr_wakeup (struct ncb *np, u_long code)
+static void ncr_wakeup(struct ncb *np, u_long code)
 {
 	struct ccb *cp = np->ccb;
 
@@ -5202,7 +5202,7 @@ static void ncr_chip_reset(struct ncb *np, int delay)
 **==========================================================
 */
 
-void ncr_init (struct ncb *np, int reset, char * msg, u_long code)
+static void ncr_init(struct ncb *np, int reset, char *msg, u_long code)
 {
  	int	i;
 
@@ -5900,7 +5900,7 @@ static void ncr_log_hard_error(struct ncb *np, u16 sist, u_char dstat)
 **============================================================
 */
 
-void ncr_exception (struct ncb *np)
+static void ncr_exception(struct ncb *np)
 {
 	u_char	istat, dstat;
 	u16	sist;
@@ -6083,7 +6083,7 @@ void ncr_exception (struct ncb *np)
 **----------------------------------------------------------
 */
 
-void ncr_int_sto (struct ncb *np)
+static void ncr_int_sto(struct ncb *np)
 {
 	u_long dsa;
 	struct ccb *cp;
@@ -6689,7 +6689,7 @@ out:
 **==========================================================
 */
 
-void ncr_int_sir (struct ncb *np)
+static void ncr_int_sir(struct ncb *np)
 {
 	u_char scntl3;
 	u_char chg, ofs, per, fak, wide;
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 0ea78d9..37682d1 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5615,7 +5615,7 @@ static ssize_t osst_adr_rev_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
+static DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
 
 static ssize_t osst_linux_media_version_show(struct device *dev,
 					     struct device_attribute *attr,
@@ -5629,7 +5629,7 @@ static ssize_t osst_linux_media_version_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
+static DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
 
 static ssize_t osst_capacity_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
@@ -5642,7 +5642,7 @@ static ssize_t osst_capacity_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
+static DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
 
 static ssize_t osst_first_data_ppos_show(struct device *dev,
 					 struct device_attribute *attr,
@@ -5656,7 +5656,7 @@ static ssize_t osst_first_data_ppos_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
+static DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
 
 static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 					struct device_attribute *attr,
@@ -5670,7 +5670,7 @@ static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
+static DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
 
 static ssize_t osst_filemark_cnt_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -5683,7 +5683,7 @@ static ssize_t osst_filemark_cnt_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
+static DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
 
 static struct class *osst_sysfs_class;
 
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index f2018b4..ef99ad2 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -348,7 +348,7 @@ static int __init
  *
  */
 
-void __init pas16_setup(char *str, int *ints)
+static void __init pas16_setup(char *str, int *ints)
 {
     static int commandline_current = 0;
     int i;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 27c633f..b4bb95f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2202,7 +2202,7 @@ static ssize_t sdebug_delay_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(delay, S_IRUGO | S_IWUSR, sdebug_delay_show,
+static DRIVER_ATTR(delay, S_IRUGO | S_IWUSR, sdebug_delay_show,
 	    sdebug_delay_store);
 
 static ssize_t sdebug_opts_show(struct device_driver * ddp, char * buf)
@@ -2231,7 +2231,7 @@ opts_done:
 	scsi_debug_cmnd_count = 0;
 	return count;
 }
-DRIVER_ATTR(opts, S_IRUGO | S_IWUSR, sdebug_opts_show,
+static DRIVER_ATTR(opts, S_IRUGO | S_IWUSR, sdebug_opts_show,
 	    sdebug_opts_store);
 
 static ssize_t sdebug_ptype_show(struct device_driver * ddp, char * buf)
@@ -2249,7 +2249,8 @@ static ssize_t sdebug_ptype_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(ptype, S_IRUGO | S_IWUSR, sdebug_ptype_show, sdebug_ptype_store);
+static DRIVER_ATTR(ptype, S_IRUGO | S_IWUSR, sdebug_ptype_show,
+		sdebug_ptype_store);
 
 static ssize_t sdebug_dsense_show(struct device_driver * ddp, char * buf)
 {
@@ -2266,7 +2267,7 @@ static ssize_t sdebug_dsense_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(dsense, S_IRUGO | S_IWUSR, sdebug_dsense_show,
+static DRIVER_ATTR(dsense, S_IRUGO | S_IWUSR, sdebug_dsense_show,
 	    sdebug_dsense_store);
 
 static ssize_t sdebug_fake_rw_show(struct device_driver * ddp, char * buf)
@@ -2284,7 +2285,7 @@ static ssize_t sdebug_fake_rw_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(fake_rw, S_IRUGO | S_IWUSR, sdebug_fake_rw_show,
+static DRIVER_ATTR(fake_rw, S_IRUGO | S_IWUSR, sdebug_fake_rw_show,
 	    sdebug_fake_rw_store);
 
 static ssize_t sdebug_no_lun_0_show(struct device_driver * ddp, char * buf)
@@ -2302,7 +2303,7 @@ static ssize_t sdebug_no_lun_0_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(no_lun_0, S_IRUGO | S_IWUSR, sdebug_no_lun_0_show,
+static DRIVER_ATTR(no_lun_0, S_IRUGO | S_IWUSR, sdebug_no_lun_0_show,
 	    sdebug_no_lun_0_store);
 
 static ssize_t sdebug_num_tgts_show(struct device_driver * ddp, char * buf)
@@ -2321,20 +2322,20 @@ static ssize_t sdebug_num_tgts_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(num_tgts, S_IRUGO | S_IWUSR, sdebug_num_tgts_show,
+static DRIVER_ATTR(num_tgts, S_IRUGO | S_IWUSR, sdebug_num_tgts_show,
 	    sdebug_num_tgts_store);
 
 static ssize_t sdebug_dev_size_mb_show(struct device_driver * ddp, char * buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dev_size_mb);
 }
-DRIVER_ATTR(dev_size_mb, S_IRUGO, sdebug_dev_size_mb_show, NULL);
+static DRIVER_ATTR(dev_size_mb, S_IRUGO, sdebug_dev_size_mb_show, NULL);
 
 static ssize_t sdebug_num_parts_show(struct device_driver * ddp, char * buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_num_parts);
 }
-DRIVER_ATTR(num_parts, S_IRUGO, sdebug_num_parts_show, NULL);
+static DRIVER_ATTR(num_parts, S_IRUGO, sdebug_num_parts_show, NULL);
 
 static ssize_t sdebug_every_nth_show(struct device_driver * ddp, char * buf)
 {
@@ -2352,7 +2353,7 @@ static ssize_t sdebug_every_nth_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(every_nth, S_IRUGO | S_IWUSR, sdebug_every_nth_show,
+static DRIVER_ATTR(every_nth, S_IRUGO | S_IWUSR, sdebug_every_nth_show,
 	    sdebug_every_nth_store);
 
 static ssize_t sdebug_max_luns_show(struct device_driver * ddp, char * buf)
@@ -2371,14 +2372,14 @@ static ssize_t sdebug_max_luns_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(max_luns, S_IRUGO | S_IWUSR, sdebug_max_luns_show,
+static DRIVER_ATTR(max_luns, S_IRUGO | S_IWUSR, sdebug_max_luns_show,
 	    sdebug_max_luns_store);
 
 static ssize_t sdebug_scsi_level_show(struct device_driver * ddp, char * buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_scsi_level);
 }
-DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_show, NULL);
+static DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_show, NULL);
 
 static ssize_t sdebug_virtual_gb_show(struct device_driver * ddp, char * buf)
 {
@@ -2398,7 +2399,7 @@ static ssize_t sdebug_virtual_gb_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(virtual_gb, S_IRUGO | S_IWUSR, sdebug_virtual_gb_show,
+static DRIVER_ATTR(virtual_gb, S_IRUGO | S_IWUSR, sdebug_virtual_gb_show,
 	    sdebug_virtual_gb_store);
 
 static ssize_t sdebug_add_host_show(struct device_driver * ddp, char * buf)
@@ -2424,7 +2425,7 @@ static ssize_t sdebug_add_host_store(struct device_driver * ddp,
 	}
 	return count;
 }
-DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show,
+static DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show,
 	    sdebug_add_host_store);
 
 static ssize_t sdebug_vpd_use_hostno_show(struct device_driver * ddp,
@@ -2443,14 +2444,14 @@ static ssize_t sdebug_vpd_use_hostno_store(struct device_driver * ddp,
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(vpd_use_hostno, S_IRUGO | S_IWUSR, sdebug_vpd_use_hostno_show,
-	    sdebug_vpd_use_hostno_store);
+static DRIVER_ATTR(vpd_use_hostno, S_IRUGO | S_IWUSR,
+		sdebug_vpd_use_hostno_show, sdebug_vpd_use_hostno_store);
 
 static ssize_t sdebug_sector_size_show(struct device_driver * ddp, char * buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_sector_size);
 }
-DRIVER_ATTR(sector_size, S_IRUGO, sdebug_sector_size_show, NULL);
+static DRIVER_ATTR(sector_size, S_IRUGO, sdebug_sector_size_show, NULL);
 
 /* Note: The following function creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 93c28f3..e34a704 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -195,7 +195,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -271,7 +271,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1bcf3c3..2642d5d 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -264,7 +264,7 @@ struct ses_host_edev {
 	struct enclosure_device *edev;
 };
 
-int ses_match_host(struct enclosure_device *edev, void *data)
+static int ses_match_host(struct enclosure_device *edev, void *data)
 {
 	struct ses_host_edev *sed = data;
 	struct scsi_device *sdev;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c959bdc..c2dc969 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4334,7 +4334,7 @@ st_defined_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
+static DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
 
 static ssize_t
 st_defblk_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -4346,7 +4346,7 @@ st_defblk_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
+static DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
 
 static ssize_t
 st_defdensity_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -4360,7 +4360,7 @@ st_defdensity_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
+static DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
 
 static ssize_t
 st_defcompression_show(struct device *dev, struct device_attribute *attr,
@@ -4373,7 +4373,7 @@ st_defcompression_show(struct device *dev, struct device_attribute *attr,
 	return l;
 }
 
-DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
+static DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
 
 static ssize_t
 st_options_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -4414,7 +4414,7 @@ st_options_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
+static DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
 
 static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 {
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 98df165..9c545d0 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3807,7 +3807,7 @@ out_reject:
  *  a relevant information. :)
  */
 
-int sym_compute_residual(struct sym_hcb *np, struct sym_ccb *cp)
+static int sym_compute_residual(struct sym_hcb *np, struct sym_ccb *cp)
 {
 	int dp_sg, dp_sgmin, resid = 0;
 	int dp_ofs = 0;
@@ -5267,7 +5267,7 @@ int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, int timed_out)
  *  SCRATCHA is assumed to have been loaded with STARTPOS 
  *  before the SCRIPTS called the C code.
  */
-void sym_complete_error(struct sym_hcb *np, struct sym_ccb *cp)
+static void sym_complete_error(struct sym_hcb *np, struct sym_ccb *cp)
 {
 	struct scsi_device *sdev;
 	struct scsi_cmnd *cmd;
@@ -5398,7 +5398,7 @@ finish:
  *  The SCRIPTS processor is running while we are 
  *  completing successful commands.
  */
-void sym_complete_ok (struct sym_hcb *np, struct sym_ccb *cp)
+static void sym_complete_ok(struct sym_hcb *np, struct sym_ccb *cp)
 {
 	struct sym_tcb *tp;
 	struct sym_lcb *lp;
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 041eaaa..91b93b2 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -163,7 +163,8 @@ static struct signature {
  *
  */
 
-void __init t128_setup(char *str, int *ints){
+static void __init t128_setup(char *str, int *ints)
+{
     static int commandline_current = 0;
     int i;
     if (ints[0] != 2) 
