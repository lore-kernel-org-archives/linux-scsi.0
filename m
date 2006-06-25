From: akpm@osdl.org
Subject: [patch 02/26] drivers/scsi/aic7xxx/: possible cleanups
Date: Sun, 25 Jun 2006 01:58:42 -0700
Message-ID: <200606250858.k5P8wgZN021178@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11158 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932129AbWFYJCT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 05:02:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

- make needlessly global code static

- #if 0 the following unused global functions:
  - aic79xx_core.c: ahd_print_scb
  - aic79xx_core.c: ahd_suspend
  - aic79xx_core.c: ahd_resume
  - aic79xx_core.c: ahd_dump_scbs
  - aic79xx_osm.c: ahd_softc_comp

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx.h         |   53 ----
 drivers/scsi/aic7xxx/aic79xx_core.c    |  260 ++++++++++++++---------
 drivers/scsi/aic7xxx/aic79xx_inline.h  |   30 --
 drivers/scsi/aic7xxx/aic79xx_osm.c     |    2 
 drivers/scsi/aic7xxx/aic79xx_osm.h     |    5 
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    2 
 drivers/scsi/aic7xxx/aic79xx_pci.c     |    7 
 drivers/scsi/aic7xxx/aic79xx_proc.c    |    2 
 drivers/scsi/aic7xxx/aic7xxx.h         |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm.c     |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm.h     |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    2 
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |    4 
 13 files changed, 175 insertions(+), 198 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -52,7 +52,7 @@
 
 
 /***************************** Lookup Tables **********************************/
-char *ahd_chip_names[] =
+static char *ahd_chip_names[] =
 {
 	"NONE",
 	"aic7901",
@@ -237,10 +237,33 @@ static int		ahd_handle_target_cmd(struct
 					      struct target_cmd *cmd);
 #endif
 
+static int		ahd_abort_scbs(struct ahd_softc *ahd, int target,
+				       char channel, int lun, u_int tag,
+				       role_t role, uint32_t status);
+static void		ahd_alloc_scbs(struct ahd_softc *ahd);
+static void		ahd_busy_tcl(struct ahd_softc *ahd, u_int tcl,
+				     u_int scbid);
+static void		ahd_calc_residual(struct ahd_softc *ahd,
+					  struct scb *scb);
+static void		ahd_clear_critical_section(struct ahd_softc *ahd);
+static void		ahd_clear_intstat(struct ahd_softc *ahd);
+static void		ahd_enable_coalescing(struct ahd_softc *ahd,
+					      int enable);
+static u_int		ahd_find_busy_tcl(struct ahd_softc *ahd, u_int tcl);
+static void		ahd_freeze_devq(struct ahd_softc *ahd,
+					struct scb *scb);
+static void		ahd_handle_scb_status(struct ahd_softc *ahd,
+					      struct scb *scb);
+static struct ahd_phase_table_entry* ahd_lookup_phase_entry(int phase);
+static void		ahd_shutdown(void *arg);
+static void		ahd_update_coalescing_values(struct ahd_softc *ahd,
+						     u_int timer,
+						     u_int maxcmds,
+						     u_int mincmds);
+static int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
+static int		ahd_wait_seeprom(struct ahd_softc *ahd);
+
 /******************************** Private Inlines *****************************/
-static __inline void	ahd_assert_atn(struct ahd_softc *ahd);
-static __inline int	ahd_currently_packetized(struct ahd_softc *ahd);
-static __inline int	ahd_set_active_fifo(struct ahd_softc *ahd);
 
 static __inline void
 ahd_assert_atn(struct ahd_softc *ahd)
@@ -294,11 +317,44 @@ ahd_set_active_fifo(struct ahd_softc *ah
 	}
 }
 
+static __inline void
+ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
+{
+	ahd_busy_tcl(ahd, tcl, SCB_LIST_NULL);
+}
+
+/*
+ * Determine whether the sequencer reported a residual
+ * for this SCB/transaction.
+ */
+static __inline void
+ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
+{
+	uint32_t sgptr;
+
+	sgptr = ahd_le32toh(scb->hscb->sgptr);
+	if ((sgptr & SG_STATUS_VALID) != 0)
+		ahd_calc_residual(ahd, scb);
+}
+
+static __inline void
+ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
+{
+	uint32_t sgptr;
+
+	sgptr = ahd_le32toh(scb->hscb->sgptr);
+	if ((sgptr & SG_STATUS_VALID) != 0)
+		ahd_handle_scb_status(ahd, scb);
+	else
+		ahd_done(ahd, scb);
+}
+
+
 /************************* Sequencer Execution Control ************************/
 /*
  * Restart the sequencer program from address zero
  */
-void
+static void
 ahd_restart(struct ahd_softc *ahd)
 {
 
@@ -342,7 +398,7 @@ ahd_restart(struct ahd_softc *ahd)
 	ahd_unpause(ahd);
 }
 
-void
+static void
 ahd_clear_fifo(struct ahd_softc *ahd, u_int fifo)
 {
 	ahd_mode_state	 saved_modes;
@@ -366,7 +422,7 @@ ahd_clear_fifo(struct ahd_softc *ahd, u_
  * Flush and completed commands that are sitting in the command
  * complete queues down on the chip but have yet to be dma'ed back up.
  */
-void
+static void
 ahd_flush_qoutfifo(struct ahd_softc *ahd)
 {
 	struct		scb *scb;
@@ -905,6 +961,51 @@ ahd_handle_hwerrint(struct ahd_softc *ah
 	ahd_free(ahd);
 }
 
+#ifdef AHD_DEBUG
+static void
+ahd_dump_sglist(struct scb *scb)
+{
+	int i;
+
+	if (scb->sg_count > 0) {
+		if ((scb->ahd_softc->flags & AHD_64BIT_ADDRESSING) != 0) {
+			struct ahd_dma64_seg *sg_list;
+
+			sg_list = (struct ahd_dma64_seg*)scb->sg_list;
+			for (i = 0; i < scb->sg_count; i++) {
+				uint64_t addr;
+				uint32_t len;
+
+				addr = ahd_le64toh(sg_list[i].addr);
+				len = ahd_le32toh(sg_list[i].len);
+				printf("sg[%d] - Addr 0x%x%x : Length %d%s\n",
+				       i,
+				       (uint32_t)((addr >> 32) & 0xFFFFFFFF),
+				       (uint32_t)(addr & 0xFFFFFFFF),
+				       sg_list[i].len & AHD_SG_LEN_MASK,
+				       (sg_list[i].len & AHD_DMA_LAST_SEG)
+				     ? " Last" : "");
+			}
+		} else {
+			struct ahd_dma_seg *sg_list;
+
+			sg_list = (struct ahd_dma_seg*)scb->sg_list;
+			for (i = 0; i < scb->sg_count; i++) {
+				uint32_t len;
+
+				len = ahd_le32toh(sg_list[i].len);
+				printf("sg[%d] - Addr 0x%x%x : Length %d%s\n",
+				       i,
+				       (len & AHD_SG_HIGH_ADDR_MASK) >> 24,
+				       ahd_le32toh(sg_list[i].addr),
+				       len & AHD_SG_LEN_MASK,
+				       len & AHD_DMA_LAST_SEG ? " Last" : "");
+			}
+		}
+	}
+}
+#endif  /*  AHD_DEBUG  */
+
 void
 ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 {
@@ -2523,7 +2624,7 @@ ahd_force_renegotiation(struct ahd_softc
 }
 
 #define AHD_MAX_STEPS 2000
-void
+static void
 ahd_clear_critical_section(struct ahd_softc *ahd)
 {
 	ahd_mode_state	saved_modes;
@@ -2646,7 +2747,7 @@ ahd_clear_critical_section(struct ahd_so
 /*
  * Clear any pending interrupt status.
  */
-void
+static void
 ahd_clear_intstat(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, ~(AHD_MODE_UNKNOWN_MSK|AHD_MODE_CFG_MSK),
@@ -2677,6 +2778,8 @@ ahd_clear_intstat(struct ahd_softc *ahd)
 #ifdef AHD_DEBUG
 uint32_t ahd_debug = AHD_DEBUG_OPTS;
 #endif
+
+#if 0
 void
 ahd_print_scb(struct scb *scb)
 {
@@ -2701,49 +2804,7 @@ ahd_print_scb(struct scb *scb)
 	       SCB_GET_TAG(scb));
 	ahd_dump_sglist(scb);
 }
-
-void
-ahd_dump_sglist(struct scb *scb)
-{
-	int i;
-
-	if (scb->sg_count > 0) {
-		if ((scb->ahd_softc->flags & AHD_64BIT_ADDRESSING) != 0) {
-			struct ahd_dma64_seg *sg_list;
-
-			sg_list = (struct ahd_dma64_seg*)scb->sg_list;
-			for (i = 0; i < scb->sg_count; i++) {
-				uint64_t addr;
-				uint32_t len;
-
-				addr = ahd_le64toh(sg_list[i].addr);
-				len = ahd_le32toh(sg_list[i].len);
-				printf("sg[%d] - Addr 0x%x%x : Length %d%s\n",
-				       i,
-				       (uint32_t)((addr >> 32) & 0xFFFFFFFF),
-				       (uint32_t)(addr & 0xFFFFFFFF),
-				       sg_list[i].len & AHD_SG_LEN_MASK,
-				       (sg_list[i].len & AHD_DMA_LAST_SEG)
-				     ? " Last" : "");
-			}
-		} else {
-			struct ahd_dma_seg *sg_list;
-
-			sg_list = (struct ahd_dma_seg*)scb->sg_list;
-			for (i = 0; i < scb->sg_count; i++) {
-				uint32_t len;
-
-				len = ahd_le32toh(sg_list[i].len);
-				printf("sg[%d] - Addr 0x%x%x : Length %d%s\n",
-				       i,
-				       (len & AHD_SG_HIGH_ADDR_MASK) >> 24,
-				       ahd_le32toh(sg_list[i].addr),
-				       len & AHD_SG_LEN_MASK,
-				       len & AHD_DMA_LAST_SEG ? " Last" : "");
-			}
-		}
-	}
-}
+#endif  /*  0  */
 
 /************************* Transfer Negotiation *******************************/
 /*
@@ -2906,7 +2967,7 @@ ahd_find_syncrate(struct ahd_softc *ahd,
  * Truncate the given synchronous offset to a value the
  * current adapter type and syncrate are capable of.
  */
-void
+static void
 ahd_validate_offset(struct ahd_softc *ahd,
 		    struct ahd_initiator_tinfo *tinfo,
 		    u_int period, u_int *offset, int wide,
@@ -2937,7 +2998,7 @@ ahd_validate_offset(struct ahd_softc *ah
  * Truncate the given transfer width parameter to a value the
  * current adapter type is capable of.
  */
-void
+static void
 ahd_validate_width(struct ahd_softc *ahd, struct ahd_initiator_tinfo *tinfo,
 		   u_int *bus_width, role_t role)
 {
@@ -3464,7 +3525,7 @@ ahd_print_devinfo(struct ahd_softc *ahd,
 	       devinfo->target, devinfo->lun);
 }
 
-struct ahd_phase_table_entry*
+static struct ahd_phase_table_entry*
 ahd_lookup_phase_entry(int phase)
 {
 	struct ahd_phase_table_entry *entry;
@@ -5349,7 +5410,7 @@ ahd_free(struct ahd_softc *ahd)
 	return;
 }
 
-void
+static void
 ahd_shutdown(void *arg)
 {
 	struct	ahd_softc *ahd;
@@ -5478,7 +5539,7 @@ ahd_reset(struct ahd_softc *ahd, int rei
 /*
  * Determine the number of SCBs available on the controller
  */
-int
+static int
 ahd_probe_scbs(struct ahd_softc *ahd) {
 	int i;
 
@@ -5927,7 +5988,7 @@ ahd_free_scb(struct ahd_softc *ahd, stru
 	ahd_platform_scb_free(ahd, scb);
 }
 
-void
+static void
 ahd_alloc_scbs(struct ahd_softc *ahd)
 {
 	struct scb_data *scb_data;
@@ -6980,7 +7041,7 @@ ahd_intr_enable(struct ahd_softc *ahd, i
 	ahd_outb(ahd, HCNTRL, hcntrl);
 }
 
-void
+static void
 ahd_update_coalescing_values(struct ahd_softc *ahd, u_int timer, u_int maxcmds,
 			     u_int mincmds)
 {
@@ -6998,7 +7059,7 @@ ahd_update_coalescing_values(struct ahd_
 	ahd_outb(ahd, INT_COALESCING_MINCMDS, -mincmds);
 }
 
-void
+static void
 ahd_enable_coalescing(struct ahd_softc *ahd, int enable)
 {
 
@@ -7068,6 +7129,7 @@ ahd_pause_and_flushwork(struct ahd_softc
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
+#if 0
 int
 ahd_suspend(struct ahd_softc *ahd)
 {
@@ -7081,7 +7143,9 @@ ahd_suspend(struct ahd_softc *ahd)
 	ahd_shutdown(ahd);
 	return (0);
 }
+#endif  /*  0  */
 
+#if 0
 int
 ahd_resume(struct ahd_softc *ahd)
 {
@@ -7091,6 +7155,7 @@ ahd_resume(struct ahd_softc *ahd)
 	ahd_restart(ahd);
 	return (0);
 }
+#endif  /*  0  */
 
 /************************** Busy Target Table *********************************/
 /*
@@ -7123,7 +7188,7 @@ ahd_index_busy_tcl(struct ahd_softc *ahd
 /*
  * Return the untagged transaction id for a given target/channel lun.
  */
-u_int
+static u_int
 ahd_find_busy_tcl(struct ahd_softc *ahd, u_int tcl)
 {
 	u_int scbid;
@@ -7136,7 +7201,7 @@ ahd_find_busy_tcl(struct ahd_softc *ahd,
 	return (scbid);
 }
 
-void
+static void
 ahd_busy_tcl(struct ahd_softc *ahd, u_int tcl, u_int scbid)
 {
 	u_int scb_offset;
@@ -7184,7 +7249,7 @@ ahd_match_scb(struct ahd_softc *ahd, str
 	return match;
 }
 
-void
+static void
 ahd_freeze_devq(struct ahd_softc *ahd, struct scb *scb)
 {
 	int	target;
@@ -7688,7 +7753,7 @@ ahd_add_scb_to_free_list(struct ahd_soft
  * been modified from CAM_REQ_INPROG.  This routine assumes that the sequencer
  * is paused before it is called.
  */
-int
+static int
 ahd_abort_scbs(struct ahd_softc *ahd, int target, char channel,
 	       int lun, u_int tag, role_t role, uint32_t status)
 {
@@ -8017,18 +8082,8 @@ ahd_stat_timer(void *arg)
 }
 
 /****************************** Status Processing *****************************/
-void
-ahd_handle_scb_status(struct ahd_softc *ahd, struct scb *scb)
-{
-	if (scb->hscb->shared_data.istatus.scsi_status != 0) {
-		ahd_handle_scsi_status(ahd, scb);
-	} else {
-		ahd_calc_residual(ahd, scb);
-		ahd_done(ahd, scb);
-	}
-}
 
-void
+static void
 ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct	hardware_scb *hscb;
@@ -8236,10 +8291,21 @@ ahd_handle_scsi_status(struct ahd_softc 
 	}
 }
 
+static void
+ahd_handle_scb_status(struct ahd_softc *ahd, struct scb *scb)
+{
+	if (scb->hscb->shared_data.istatus.scsi_status != 0) {
+		ahd_handle_scsi_status(ahd, scb);
+	} else {
+		ahd_calc_residual(ahd, scb);
+		ahd_done(ahd, scb);
+	}
+}
+
 /*
  * Calculate the residual for a just completed SCB.
  */
-void
+static void
 ahd_calc_residual(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct hardware_scb *hscb;
@@ -9090,6 +9156,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 		ahd_unpause(ahd);
 }
 
+#if 0
 void
 ahd_dump_scbs(struct ahd_softc *ahd)
 {
@@ -9115,6 +9182,7 @@ ahd_dump_scbs(struct ahd_softc *ahd)
 	ahd_set_scbptr(ahd, saved_scb_index);
 	ahd_restore_modes(ahd, saved_modes);
 }
+#endif  /*  0  */
 
 /**************************** Flexport Logic **********************************/
 /*
@@ -9217,7 +9285,7 @@ ahd_write_seeprom(struct ahd_softc *ahd,
 /*
  * Wait ~100us for the serial eeprom to satisfy our request.
  */
-int
+static int
 ahd_wait_seeprom(struct ahd_softc *ahd)
 {
 	int cnt;
@@ -9235,7 +9303,7 @@ ahd_wait_seeprom(struct ahd_softc *ahd)
  * Validate the two checksums in the per_channel
  * vital product data struct.
  */
-int
+static int
 ahd_verify_vpd_cksum(struct vpd_config *vpd)
 {
 	int i;
@@ -9314,6 +9382,24 @@ ahd_release_seeprom(struct ahd_softc *ah
 	/* Currently a no-op */
 }
 
+/*
+ * Wait at most 2 seconds for flexport arbitration to succeed.
+ */
+static int
+ahd_wait_flexport(struct ahd_softc *ahd)
+{
+	int cnt;
+
+	AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
+	cnt = 1000000 * 2 / 5;
+	while ((ahd_inb(ahd, BRDCTL) & FLXARBACK) == 0 && --cnt)
+		ahd_delay(5);
+
+	if (cnt == 0)
+		return (ETIMEDOUT);
+	return (0);
+}
+
 int
 ahd_write_flexport(struct ahd_softc *ahd, u_int addr, u_int value)
 {
@@ -9355,24 +9441,6 @@ ahd_read_flexport(struct ahd_softc *ahd,
 	return (0);
 }
 
-/*
- * Wait at most 2 seconds for flexport arbitration to succeed.
- */
-int
-ahd_wait_flexport(struct ahd_softc *ahd)
-{
-	int cnt;
-
-	AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
-	cnt = 1000000 * 2 / 5;
-	while ((ahd_inb(ahd, BRDCTL) & FLXARBACK) == 0 && --cnt)
-		ahd_delay(5);
-
-	if (cnt == 0)
-		return (ETIMEDOUT);
-	return (0);
-}
-
 /************************* Target Mode ****************************************/
 #ifdef AHD_TARGET_MODE
 cam_status
diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx.h
@@ -972,8 +972,6 @@ int		ahd_read_seeprom(struct ahd_softc *
 
 int		ahd_write_seeprom(struct ahd_softc *ahd, uint16_t *buf,
 				  u_int start_addr, u_int count);
-int		ahd_wait_seeprom(struct ahd_softc *ahd);
-int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
 int		ahd_verify_cksum(struct seeprom_config *sc);
 int		ahd_acquire_seeprom(struct ahd_softc *ahd);
 void		ahd_release_seeprom(struct ahd_softc *ahd);
@@ -1320,8 +1318,6 @@ struct ahd_pci_identity {
 	char			*name;
 	ahd_device_setup_t	*setup;
 };
-extern struct ahd_pci_identity ahd_pci_ident_table [];
-extern const u_int ahd_num_pci_devs;
 
 /***************************** VL/EISA Declarations ***************************/
 struct aic7770_identity {
@@ -1339,15 +1335,6 @@ extern const int ahd_num_aic7770_devs;
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
 void			ahd_reset_cmds_pending(struct ahd_softc *ahd);
-u_int			ahd_find_busy_tcl(struct ahd_softc *ahd, u_int tcl);
-void			ahd_busy_tcl(struct ahd_softc *ahd,
-				     u_int tcl, u_int busyid);
-static __inline void	ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl);
-static __inline void
-ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
-{
-	ahd_busy_tcl(ahd, tcl, SCB_LIST_NULL);
-}
 
 /***************************** PCI Front End *********************************/
 struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
@@ -1356,7 +1343,6 @@ int			  ahd_pci_config(struct ahd_softc 
 int	ahd_pci_test_register_access(struct ahd_softc *);
 
 /************************** SCB and SCB queue management **********************/
-int		ahd_probe_scbs(struct ahd_softc *);
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
 					 struct scb *scb);
 int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
@@ -1374,33 +1360,20 @@ int			 ahd_parse_vpddata(struct ahd_soft
 int			 ahd_parse_cfgdata(struct ahd_softc *ahd,
 					   struct seeprom_config *sc);
 void			 ahd_intr_enable(struct ahd_softc *ahd, int enable);
-void			 ahd_update_coalescing_values(struct ahd_softc *ahd,
-						      u_int timer,
-						      u_int maxcmds,
-						      u_int mincmds);
-void			 ahd_enable_coalescing(struct ahd_softc *ahd,
-					       int enable);
 void			 ahd_pause_and_flushwork(struct ahd_softc *ahd);
 int			 ahd_suspend(struct ahd_softc *ahd); 
-int			 ahd_resume(struct ahd_softc *ahd);
 void			 ahd_set_unit(struct ahd_softc *, int);
 void			 ahd_set_name(struct ahd_softc *, char *);
 struct scb		*ahd_get_scb(struct ahd_softc *ahd, u_int col_idx);
 void			 ahd_free_scb(struct ahd_softc *ahd, struct scb *scb);
-void			 ahd_alloc_scbs(struct ahd_softc *ahd);
 void			 ahd_free(struct ahd_softc *ahd);
 int			 ahd_reset(struct ahd_softc *ahd, int reinit);
-void			 ahd_shutdown(void *arg);
 int			 ahd_write_flexport(struct ahd_softc *ahd,
 					    u_int addr, u_int value);
 int			 ahd_read_flexport(struct ahd_softc *ahd, u_int addr,
 					   uint8_t *value);
-int			 ahd_wait_flexport(struct ahd_softc *ahd);
 
 /*************************** Interrupt Services *******************************/
-void			ahd_pci_intr(struct ahd_softc *ahd);
-void			ahd_clear_intstat(struct ahd_softc *ahd);
-void			ahd_flush_qoutfifo(struct ahd_softc *ahd);
 void			ahd_run_qoutfifo(struct ahd_softc *ahd);
 #ifdef AHD_TARGET_MODE
 void			ahd_run_tqinfifo(struct ahd_softc *ahd, int paused);
@@ -1409,7 +1382,6 @@ void			ahd_handle_hwerrint(struct ahd_so
 void			ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat);
 void			ahd_handle_scsiint(struct ahd_softc *ahd,
 					   u_int intstat);
-void			ahd_clear_critical_section(struct ahd_softc *ahd);
 
 /***************************** Error Recovery *********************************/
 typedef enum {
@@ -1426,23 +1398,9 @@ int			ahd_search_disc_list(struct ahd_so
 					     char channel, int lun, u_int tag,
 					     int stop_on_first, int remove,
 					     int save_state);
-void			ahd_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 int			ahd_reset_channel(struct ahd_softc *ahd, char channel,
 					  int initiate_reset);
-int			ahd_abort_scbs(struct ahd_softc *ahd, int target,
-				       char channel, int lun, u_int tag,
-				       role_t role, uint32_t status);
-void			ahd_restart(struct ahd_softc *ahd);
-void			ahd_clear_fifo(struct ahd_softc *ahd, u_int fifo);
-void			ahd_handle_scb_status(struct ahd_softc *ahd,
-					      struct scb *scb);
-void			ahd_handle_scsi_status(struct ahd_softc *ahd,
-					       struct scb *scb);
-void			ahd_calc_residual(struct ahd_softc *ahd,
-					  struct scb *scb);
 /*************************** Utility Functions ********************************/
-struct ahd_phase_table_entry*
-			ahd_lookup_phase_entry(int phase);
 void			ahd_compile_devinfo(struct ahd_devinfo *devinfo,
 					    u_int our_id, u_int target,
 					    u_int lun, char channel,
@@ -1450,14 +1408,6 @@ void			ahd_compile_devinfo(struct ahd_de
 /************************** Transfer Negotiation ******************************/
 void			ahd_find_syncrate(struct ahd_softc *ahd, u_int *period,
 					  u_int *ppr_options, u_int maxsync);
-void			ahd_validate_offset(struct ahd_softc *ahd,
-					    struct ahd_initiator_tinfo *tinfo,
-					    u_int period, u_int *offset,
-					    int wide, role_t role);
-void			ahd_validate_width(struct ahd_softc *ahd,
-					   struct ahd_initiator_tinfo *tinfo,
-					   u_int *bus_width,
-					   role_t role);
 /*
  * Negotiation types.  These are used to qualify if we should renegotiate
  * even if our goal and current transport parameters are identical.
@@ -1527,10 +1477,8 @@ extern uint32_t ahd_debug;
 #define AHD_SHOW_INT_COALESCING	0x10000
 #define AHD_DEBUG_SEQUENCER	0x20000
 #endif
-void			ahd_print_scb(struct scb *scb);
 void			ahd_print_devinfo(struct ahd_softc *ahd,
 					  struct ahd_devinfo *devinfo);
-void			ahd_dump_sglist(struct scb *scb);
 void			ahd_dump_card_state(struct ahd_softc *ahd);
 int			ahd_print_register(ahd_reg_parse_entry_t *table,
 					   u_int num_entries,
@@ -1539,5 +1487,4 @@ int			ahd_print_register(ahd_reg_parse_e
 					   u_int value,
 					   u_int *cur_column,
 					   u_int wrap_point);
-void			ahd_dump_scbs(struct ahd_softc *ahd);
 #endif /* _AIC79XX_H_ */
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_inline.h
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -418,10 +418,6 @@ ahd_targetcmd_offset(struct ahd_softc *a
 }
 
 /*********************** Miscelaneous Support Functions ***********************/
-static __inline void	ahd_complete_scb(struct ahd_softc *ahd,
-					 struct scb *scb);
-static __inline void	ahd_update_residual(struct ahd_softc *ahd,
-					    struct scb *scb);
 static __inline struct ahd_initiator_tinfo *
 			ahd_fetch_transinfo(struct ahd_softc *ahd,
 					    char channel, u_int our_id,
@@ -467,32 +463,6 @@ static __inline uint32_t
 			ahd_get_sense_bufaddr(struct ahd_softc *ahd,
 					      struct scb *scb);
 
-static __inline void
-ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
-{
-	uint32_t sgptr;
-
-	sgptr = ahd_le32toh(scb->hscb->sgptr);
-	if ((sgptr & SG_STATUS_VALID) != 0)
-		ahd_handle_scb_status(ahd, scb);
-	else
-		ahd_done(ahd, scb);
-}
-
-/*
- * Determine whether the sequencer reported a residual
- * for this SCB/transaction.
- */
-static __inline void
-ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
-{
-	uint32_t sgptr;
-
-	sgptr = ahd_le32toh(scb->hscb->sgptr);
-	if ((sgptr & SG_STATUS_VALID) != 0)
-		ahd_calc_residual(ahd, scb);
-}
-
 /*
  * Return pointers to the transfer negotiation information
  * for the specified our_id/remote_id pair.
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -312,7 +312,7 @@ static uint32_t aic79xx_seltime;
  * force all outstanding transactions to be serviced prior to a new
  * transaction.
  */
-uint32_t aic79xx_periodic_otag;
+static uint32_t aic79xx_periodic_otag;
 
 /* Some storage boxes are using an LSI chip which has a bug making it
  * impossible to use aic79xx Rev B chip in 320 speeds.  The following
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -515,9 +515,6 @@ struct info_str {
 	int pos;
 };
 
-void	ahd_format_transinfo(struct info_str *info,
-			     struct ahd_transinfo *tinfo);
-
 /******************************** Locking *************************************/
 static __inline void
 ahd_lockinit(struct ahd_softc *ahd)
@@ -591,8 +588,6 @@ ahd_unlock(struct ahd_softc *ahd, unsign
 #define PCIXM_STATUS_MAXCRDS	0x1C00	/* Maximum Cumulative Read Size */
 #define PCIXM_STATUS_RCVDSCEM	0x2000	/* Received a Split Comp w/Error msg */
 
-extern struct pci_driver aic79xx_pci_driver;
-
 typedef enum
 {
 	AHD_POWER_STATE_D0,
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -82,7 +82,7 @@ static struct pci_device_id ahd_linux_pc
 
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
 
-struct pci_driver aic79xx_pci_driver = {
+static struct pci_driver aic79xx_pci_driver = {
 	.name		= "aic79xx",
 	.probe		= ahd_linux_pci_dev_probe,
 	.remove		= ahd_linux_pci_dev_remove,
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -97,7 +97,7 @@ static ahd_device_setup_t ahd_aic7901A_s
 static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-struct ahd_pci_identity ahd_pci_ident_table [] =
+static struct ahd_pci_identity ahd_pci_ident_table [] =
 {
 	/* aic7901 based controllers */
 	{
@@ -201,7 +201,7 @@ struct ahd_pci_identity ahd_pci_ident_ta
 	}
 };
 
-const u_int ahd_num_pci_devs = ARRAY_SIZE(ahd_pci_ident_table);
+static const u_int ahd_num_pci_devs = ARRAY_SIZE(ahd_pci_ident_table);
 		
 #define	DEVCONFIG		0x40
 #define		PCIXINITPAT	0x0000E000ul
@@ -245,6 +245,7 @@ static int	ahd_check_extport(struct ahd_
 static void	ahd_configure_termination(struct ahd_softc *ahd,
 					  u_int adapter_control);
 static void	ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat);
+static void	ahd_pci_intr(struct ahd_softc *ahd);
 
 struct ahd_pci_identity *
 ahd_find_pci_device(ahd_dev_softc_t pci)
@@ -757,7 +758,7 @@ static const char *pci_status_strings[] 
 	"%s: Address or Write Phase Parity Error Detected in %s.\n"
 };
 
-void
+static void
 ahd_pci_intr(struct ahd_softc *ahd)
 {
 	uint8_t		pci_status[8];
diff -puN drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_proc.c
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -136,7 +136,7 @@ copy_info(struct info_str *info, char *f
 	return (len);
 }
 
-void
+static void
 ahd_format_transinfo(struct info_str *info, struct ahd_transinfo *tinfo)
 {
 	u_int speed;
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx.h
--- a/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1135,8 +1135,6 @@ struct ahc_pci_identity {
 	char			*name;
 	ahc_device_setup_t	*setup;
 };
-extern struct ahc_pci_identity ahc_pci_ident_table[];
-extern const u_int ahc_num_pci_devs;
 
 /***************************** VL/EISA Declarations ***************************/
 struct aic7770_identity {
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -328,7 +328,7 @@ static uint32_t aic7xxx_seltime;
  * force all outstanding transactions to be serviced prior to a new
  * transaction.
  */
-uint32_t aic7xxx_periodic_otag;
+static uint32_t aic7xxx_periodic_otag;
 
 /*
  * Module information and settable options.
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -534,8 +534,6 @@ ahc_unlock(struct ahc_softc *ahc, unsign
 #define PCIR_SUBVEND_0	0x2c
 #define PCIR_SUBDEV_0	0x2e
 
-extern struct pci_driver aic7xxx_pci_driver;
-
 typedef enum
 {
 	AHC_POWER_STATE_D0,
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -130,7 +130,7 @@ static struct pci_device_id ahc_linux_pc
 
 MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
 
-struct pci_driver aic7xxx_pci_driver = {
+static struct pci_driver aic7xxx_pci_driver = {
 	.name		= "aic7xxx",
 	.probe		= ahc_linux_pci_dev_probe,
 	.remove		= ahc_linux_pci_dev_remove,
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-aic7xxx-possible-cleanups
+++ a/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -168,7 +168,7 @@ static ahc_device_setup_t ahc_aha394XX_s
 static ahc_device_setup_t ahc_aha494XX_setup;
 static ahc_device_setup_t ahc_aha398XX_setup;
 
-struct ahc_pci_identity ahc_pci_ident_table [] =
+static struct ahc_pci_identity ahc_pci_ident_table [] =
 {
 	/* aic7850 based controllers */
 	{
@@ -559,7 +559,7 @@ struct ahc_pci_identity ahc_pci_ident_ta
 	}
 };
 
-const u_int ahc_num_pci_devs = ARRAY_SIZE(ahc_pci_ident_table);
+static const u_int ahc_num_pci_devs = ARRAY_SIZE(ahc_pci_ident_table);
 		
 #define AHC_394X_SLOT_CHANNEL_A	4
 #define AHC_394X_SLOT_CHANNEL_B	5
_
