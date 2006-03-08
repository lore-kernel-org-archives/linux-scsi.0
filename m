From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/aic7xxx/: possible cleanups
Date: Wed, 8 Mar 2006 14:31:05 +0100
Message-ID: <20060308133105.GJ4006@stusta.de>
References: <200603080816.k288G72x002153@shell0.pdx.osdl.net> <20060308122218.GH7301@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:3081 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751034AbWCHNbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 08:31:09 -0500
Content-Disposition: inline
In-Reply-To: <20060308122218.GH7301@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Mar 08, 2006 at 05:22:18AM -0700, Matthew Wilcox wrote:
> On Wed, Mar 08, 2006 at 12:14:18AM -0800, akpm@osdl.org wrote:
>...
> > @@ -155,7 +155,7 @@ typedef enum {
> >  	AHDMSG_1B,
> >  	AHDMSG_2B,
> >  	AHDMSG_EXT
> > -} ahd_msgtype;
> > +	} ahd_msgtype;
> >  static int		ahd_sent_msg(struct ahd_softc *ahd, ahd_msgtype type,
> >  				     u_int msgval, int full);
> >  static int		ahd_parse_msg(struct ahd_softc *ahd,
> 
>  - Introduces  some  wrong  whitespace  changes


Thanks for spotting, I don't know how this happened...

Updated patch below.


> > @@ -238,10 +238,33 @@ static int		ahd_handle_target_cmd(struct
> >  					      struct target_cmd *cmd);
> >  #endif
> >  
> > +static int		ahd_abort_scbs(struct ahd_softc *ahd, int target,
> > +				       char channel, int lun, u_int tag,
> > +				       role_t role, uint32_t status);
> 
>  - prototypes some functions, while ...
>...
> > +static __inline void
> > +ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
>...
> > +static __inline void
> > +ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
> > +{
>...
> > +static __inline void
> > +ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
>...
>  - ... moving others around.  Consistency?

There is some logic behind it:

The moved functions are static inline functions previously in header 
files that use other functions I made static.

The non-moved functions stayed at their places in the C files.

cu
Adrian


<--  snip  -->



From: Adrian Bunk <bunk@stusta.de>

- make needlessly global code static

- #if 0 the following unused global functions:
  - aic79xx_core.c: ahd_print_scb
  - aic79xx_core.c: ahd_suspend
  - aic79xx_core.c: ahd_resume
  - aic79xx_core.c: ahd_dump_scbs
  - aic79xx_osm.c: ahd_softc_comp

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/aic7xxx/aic79xx.h         |   53 -----
 drivers/scsi/aic7xxx/aic79xx_core.c    |  260 +++++++++++++++----------
 drivers/scsi/aic7xxx/aic79xx_inline.h  |   30 --
 drivers/scsi/aic7xxx/aic79xx_osm.c     |    4 
 drivers/scsi/aic7xxx/aic79xx_osm.h     |    6 
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    2 
 drivers/scsi/aic7xxx/aic79xx_pci.c     |    7 
 drivers/scsi/aic7xxx/aic79xx_proc.c    |    2 
 drivers/scsi/aic7xxx/aic7xxx.h         |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm.c     |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm.h     |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    2 
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |    4 
 13 files changed, 177 insertions(+), 199 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_core.c
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-02-27 20:57:26.000000000 -0800
@@ -52,7 +52,7 @@
 
 
 /***************************** Lookup Tables **********************************/
-char *ahd_chip_names[] =
+static char *ahd_chip_names[] =
 {
 	"NONE",
 	"aic7901",
@@ -238,10 +238,33 @@ static int		ahd_handle_target_cmd(struct
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
@@ -295,11 +318,44 @@ ahd_set_active_fifo(struct ahd_softc *ah
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
 
@@ -343,7 +399,7 @@ ahd_restart(struct ahd_softc *ahd)
 	ahd_unpause(ahd);
 }
 
-void
+static void
 ahd_clear_fifo(struct ahd_softc *ahd, u_int fifo)
 {
 	ahd_mode_state	 saved_modes;
@@ -367,7 +423,7 @@ ahd_clear_fifo(struct ahd_softc *ahd, u_
  * Flush and completed commands that are sitting in the command
  * complete queues down on the chip but have yet to be dma'ed back up.
  */
-void
+static void
 ahd_flush_qoutfifo(struct ahd_softc *ahd)
 {
 	struct		scb *scb;
@@ -906,6 +962,51 @@ ahd_handle_hwerrint(struct ahd_softc *ah
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
@@ -2542,7 +2643,7 @@ ahd_force_renegotiation(struct ahd_softc
 }
 
 #define AHD_MAX_STEPS 2000
-void
+static void
 ahd_clear_critical_section(struct ahd_softc *ahd)
 {
 	ahd_mode_state	saved_modes;
@@ -2665,7 +2766,7 @@ ahd_clear_critical_section(struct ahd_so
 /*
  * Clear any pending interrupt status.
  */
-void
+static void
 ahd_clear_intstat(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, ~(AHD_MODE_UNKNOWN_MSK|AHD_MODE_CFG_MSK),
@@ -2696,6 +2797,8 @@ ahd_clear_intstat(struct ahd_softc *ahd)
 #ifdef AHD_DEBUG
 uint32_t ahd_debug = AHD_DEBUG_OPTS;
 #endif
+
+#if 0
 void
 ahd_print_scb(struct scb *scb)
 {
@@ -2720,49 +2823,7 @@ ahd_print_scb(struct scb *scb)
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
@@ -2925,7 +2986,7 @@ ahd_find_syncrate(struct ahd_softc *ahd,
  * Truncate the given synchronous offset to a value the
  * current adapter type and syncrate are capable of.
  */
-void
+static void
 ahd_validate_offset(struct ahd_softc *ahd,
 		    struct ahd_initiator_tinfo *tinfo,
 		    u_int period, u_int *offset, int wide,
@@ -2956,7 +3017,7 @@ ahd_validate_offset(struct ahd_softc *ah
  * Truncate the given transfer width parameter to a value the
  * current adapter type is capable of.
  */
-void
+static void
 ahd_validate_width(struct ahd_softc *ahd, struct ahd_initiator_tinfo *tinfo,
 		   u_int *bus_width, role_t role)
 {
@@ -3483,7 +3544,7 @@ ahd_print_devinfo(struct ahd_softc *ahd,
 	       devinfo->target, devinfo->lun);
 }
 
-struct ahd_phase_table_entry*
+static struct ahd_phase_table_entry*
 ahd_lookup_phase_entry(int phase)
 {
 	struct ahd_phase_table_entry *entry;
@@ -5368,7 +5429,7 @@ ahd_free(struct ahd_softc *ahd)
 	return;
 }
 
-void
+static void
 ahd_shutdown(void *arg)
 {
 	struct	ahd_softc *ahd;
@@ -5497,7 +5558,7 @@ ahd_reset(struct ahd_softc *ahd, int rei
 /*
  * Determine the number of SCBs available on the controller
  */
-int
+static int
 ahd_probe_scbs(struct ahd_softc *ahd) {
 	int i;
 
@@ -5946,7 +6007,7 @@ ahd_free_scb(struct ahd_softc *ahd, stru
 	ahd_platform_scb_free(ahd, scb);
 }
 
-void
+static void
 ahd_alloc_scbs(struct ahd_softc *ahd)
 {
 	struct scb_data *scb_data;
@@ -6999,7 +7060,7 @@ ahd_intr_enable(struct ahd_softc *ahd, i
 	ahd_outb(ahd, HCNTRL, hcntrl);
 }
 
-void
+static void
 ahd_update_coalescing_values(struct ahd_softc *ahd, u_int timer, u_int maxcmds,
 			     u_int mincmds)
 {
@@ -7017,7 +7078,7 @@ ahd_update_coalescing_values(struct ahd_
 	ahd_outb(ahd, INT_COALESCING_MINCMDS, -mincmds);
 }
 
-void
+static void
 ahd_enable_coalescing(struct ahd_softc *ahd, int enable)
 {
 
@@ -7088,6 +7149,7 @@ ahd_pause_and_flushwork(struct ahd_softc
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
+#if 0
 int
 ahd_suspend(struct ahd_softc *ahd)
 {
@@ -7101,7 +7163,9 @@ ahd_suspend(struct ahd_softc *ahd)
 	ahd_shutdown(ahd);
 	return (0);
 }
+#endif  /*  0  */
 
+#if 0
 int
 ahd_resume(struct ahd_softc *ahd)
 {
@@ -7111,6 +7175,7 @@ ahd_resume(struct ahd_softc *ahd)
 	ahd_restart(ahd);
 	return (0);
 }
+#endif  /*  0  */
 
 /************************** Busy Target Table *********************************/
 /*
@@ -7143,7 +7208,7 @@ ahd_index_busy_tcl(struct ahd_softc *ahd
 /*
  * Return the untagged transaction id for a given target/channel lun.
  */
-u_int
+static u_int
 ahd_find_busy_tcl(struct ahd_softc *ahd, u_int tcl)
 {
 	u_int scbid;
@@ -7156,7 +7221,7 @@ ahd_find_busy_tcl(struct ahd_softc *ahd,
 	return (scbid);
 }
 
-void
+static void
 ahd_busy_tcl(struct ahd_softc *ahd, u_int tcl, u_int scbid)
 {
 	u_int scb_offset;
@@ -7204,7 +7269,7 @@ ahd_match_scb(struct ahd_softc *ahd, str
 	return match;
 }
 
-void
+static void
 ahd_freeze_devq(struct ahd_softc *ahd, struct scb *scb)
 {
 	int	target;
@@ -7708,7 +7773,7 @@ ahd_add_scb_to_free_list(struct ahd_soft
  * been modified from CAM_REQ_INPROG.  This routine assumes that the sequencer
  * is paused before it is called.
  */
-int
+static int
 ahd_abort_scbs(struct ahd_softc *ahd, int target, char channel,
 	       int lun, u_int tag, role_t role, uint32_t status)
 {
@@ -8056,18 +8121,8 @@ ahd_stat_timer(void *arg)
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
@@ -8275,10 +8330,21 @@ ahd_handle_scsi_status(struct ahd_softc 
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
@@ -9129,6 +9195,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 		ahd_unpause(ahd);
 }
 
+#if 0
 void
 ahd_dump_scbs(struct ahd_softc *ahd)
 {
@@ -9154,6 +9221,7 @@ ahd_dump_scbs(struct ahd_softc *ahd)
 	ahd_set_scbptr(ahd, saved_scb_index);
 	ahd_restore_modes(ahd, saved_modes);
 }
+#endif  /*  0  */
 
 /**************************** Flexport Logic **********************************/
 /*
@@ -9256,7 +9324,7 @@ ahd_write_seeprom(struct ahd_softc *ahd,
 /*
  * Wait ~100us for the serial eeprom to satisfy our request.
  */
-int
+static int
 ahd_wait_seeprom(struct ahd_softc *ahd)
 {
 	int cnt;
@@ -9274,7 +9342,7 @@ ahd_wait_seeprom(struct ahd_softc *ahd)
  * Validate the two checksums in the per_channel
  * vital product data struct.
  */
-int
+static int
 ahd_verify_vpd_cksum(struct vpd_config *vpd)
 {
 	int i;
@@ -9353,6 +9421,24 @@ ahd_release_seeprom(struct ahd_softc *ah
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
@@ -9394,24 +9480,6 @@ ahd_read_flexport(struct ahd_softc *ahd,
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
--- devel/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx.h	2006-02-27 20:57:26.000000000 -0800
@@ -974,8 +974,6 @@ int		ahd_read_seeprom(struct ahd_softc *
 
 int		ahd_write_seeprom(struct ahd_softc *ahd, uint16_t *buf,
 				  u_int start_addr, u_int count);
-int		ahd_wait_seeprom(struct ahd_softc *ahd);
-int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
 int		ahd_verify_cksum(struct seeprom_config *sc);
 int		ahd_acquire_seeprom(struct ahd_softc *ahd);
 void		ahd_release_seeprom(struct ahd_softc *ahd);
@@ -1322,8 +1320,6 @@ struct ahd_pci_identity {
 	char			*name;
 	ahd_device_setup_t	*setup;
 };
-extern struct ahd_pci_identity ahd_pci_ident_table [];
-extern const u_int ahd_num_pci_devs;
 
 /***************************** VL/EISA Declarations ***************************/
 struct aic7770_identity {
@@ -1341,15 +1337,6 @@ extern const int ahd_num_aic7770_devs;
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
@@ -1358,7 +1345,6 @@ int			  ahd_pci_config(struct ahd_softc 
 int	ahd_pci_test_register_access(struct ahd_softc *);
 
 /************************** SCB and SCB queue management **********************/
-int		ahd_probe_scbs(struct ahd_softc *);
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
 					 struct scb *scb);
 int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
@@ -1376,33 +1362,20 @@ int			 ahd_parse_vpddata(struct ahd_soft
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
@@ -1411,7 +1384,6 @@ void			ahd_handle_hwerrint(struct ahd_so
 void			ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat);
 void			ahd_handle_scsiint(struct ahd_softc *ahd,
 					   u_int intstat);
-void			ahd_clear_critical_section(struct ahd_softc *ahd);
 
 /***************************** Error Recovery *********************************/
 typedef enum {
@@ -1428,23 +1400,9 @@ int			ahd_search_disc_list(struct ahd_so
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
@@ -1452,14 +1410,6 @@ void			ahd_compile_devinfo(struct ahd_de
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
@@ -1529,10 +1479,8 @@ extern uint32_t ahd_debug;
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
@@ -1541,5 +1489,4 @@ int			ahd_print_register(ahd_reg_parse_e
 					   u_int value,
 					   u_int *cur_column,
 					   u_int wrap_point);
-void			ahd_dump_scbs(struct ahd_softc *ahd);
 #endif /* _AIC79XX_H_ */
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_inline.h
--- devel/drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_inline.h	2006-02-27 20:57:26.000000000 -0800
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
--- devel/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-02-27 20:57:26.000000000 -0800
@@ -312,7 +312,7 @@ static uint32_t aic79xx_seltime;
  * force all outstanding transactions to be serviced prior to a new
  * transaction.
  */
-uint32_t aic79xx_periodic_otag;
+static uint32_t aic79xx_periodic_otag;
 
 /* Some storage boxes are using an LSI chip which has a bug making it
  * impossible to use aic79xx Rev B chip in 320 speeds.  The following
@@ -810,6 +810,7 @@ ahd_dmamap_unload(struct ahd_softc *ahd,
 	return (0);
 }
 
+#if 0
 /********************* Platform Dependent Functions ***************************/
 /*
  * Compare "left hand" softc with "right hand" softc, returning:
@@ -863,6 +864,7 @@ ahd_softc_comp(struct ahd_softc *lahd, s
 	value = rahd->channel - lahd->channel;
 	return (value);
 }
+#endif  /*  0  */
 
 static void
 ahd_linux_setup_iocell_info(u_long index, int instance, int targ, int32_t value)
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_osm.h
--- devel/drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm.h	2006-02-27 20:57:26.000000000 -0800
@@ -518,9 +518,6 @@ struct info_str {
 	int pos;
 };
 
-void	ahd_format_transinfo(struct info_str *info,
-			     struct ahd_transinfo *tinfo);
-
 /******************************** Locking *************************************/
 static __inline void
 ahd_lockinit(struct ahd_softc *ahd)
@@ -594,8 +591,6 @@ ahd_unlock(struct ahd_softc *ahd, unsign
 #define PCIXM_STATUS_MAXCRDS	0x1C00	/* Maximum Cumulative Read Size */
 #define PCIXM_STATUS_RCVDSCEM	0x2000	/* Received a Split Comp w/Error msg */
 
-extern struct pci_driver aic79xx_pci_driver;
-
 typedef enum
 {
 	AHD_POWER_STATE_D0,
@@ -876,7 +871,6 @@ int	ahd_platform_abort_scbs(struct ahd_s
 irqreturn_t
 	ahd_linux_isr(int irq, void *dev_id, struct pt_regs * regs);
 void	ahd_platform_flushwork(struct ahd_softc *ahd);
-int	ahd_softc_comp(struct ahd_softc *, struct ahd_softc *);
 void	ahd_done(struct ahd_softc*, struct scb*);
 void	ahd_send_async(struct ahd_softc *, char channel,
 		       u_int target, u_int lun, ac_code, void *);
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- devel/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2006-02-27 20:57:26.000000000 -0800
@@ -82,7 +82,7 @@ static struct pci_device_id ahd_linux_pc
 
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
 
-struct pci_driver aic79xx_pci_driver = {
+static struct pci_driver aic79xx_pci_driver = {
 	.name		= "aic79xx",
 	.probe		= ahd_linux_pci_dev_probe,
 	.remove		= ahd_linux_pci_dev_remove,
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic79xx_pci.c
--- devel/drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_pci.c	2006-02-27 20:57:26.000000000 -0800
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
 
-const u_int ahd_num_pci_devs = NUM_ELEMENTS(ahd_pci_ident_table);
+static const u_int ahd_num_pci_devs = NUM_ELEMENTS(ahd_pci_ident_table);
 		
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
--- devel/drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_proc.c	2006-02-27 20:57:26.000000000 -0800
@@ -138,7 +138,7 @@ copy_info(struct info_str *info, char *f
 	return (len);
 }
 
-void
+static void
 ahd_format_transinfo(struct info_str *info, struct ahd_transinfo *tinfo)
 {
 	u_int speed;
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx.h
--- devel/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx.h	2006-02-27 20:57:26.000000000 -0800
@@ -1136,8 +1136,6 @@ struct ahc_pci_identity {
 	char			*name;
 	ahc_device_setup_t	*setup;
 };
-extern struct ahc_pci_identity ahc_pci_ident_table[];
-extern const u_int ahc_num_pci_devs;
 
 /***************************** VL/EISA Declarations ***************************/
 struct aic7770_identity {
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_osm.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-02-27 20:57:26.000000000 -0800
@@ -328,7 +328,7 @@ static uint32_t aic7xxx_seltime;
  * force all outstanding transactions to be serviced prior to a new
  * transaction.
  */
-uint32_t aic7xxx_periodic_otag;
+static uint32_t aic7xxx_periodic_otag;
 
 /*
  * Module information and settable options.
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_osm.h
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm.h~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-02-27 20:57:26.000000000 -0800
@@ -537,8 +537,6 @@ ahc_unlock(struct ahc_softc *ahc, unsign
 #define PCIR_SUBVEND_0	0x2c
 #define PCIR_SUBDEV_0	0x2e
 
-extern struct pci_driver aic7xxx_pci_driver;
-
 typedef enum
 {
 	AHC_POWER_STATE_D0,
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2006-02-27 20:57:26.000000000 -0800
@@ -130,7 +130,7 @@ static struct pci_device_id ahc_linux_pc
 
 MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
 
-struct pci_driver aic7xxx_pci_driver = {
+static struct pci_driver aic7xxx_pci_driver = {
 	.name		= "aic7xxx",
 	.probe		= ahc_linux_pci_dev_probe,
 	.remove		= ahc_linux_pci_dev_remove,
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-aic7xxx-possible-cleanups drivers/scsi/aic7xxx/aic7xxx_pci.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-aic7xxx-possible-cleanups	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_pci.c	2006-02-27 20:57:26.000000000 -0800
@@ -162,7 +162,7 @@ static ahc_device_setup_t ahc_aha394XX_s
 static ahc_device_setup_t ahc_aha494XX_setup;
 static ahc_device_setup_t ahc_aha398XX_setup;
 
-struct ahc_pci_identity ahc_pci_ident_table [] =
+static struct ahc_pci_identity ahc_pci_ident_table [] =
 {
 	/* aic7850 based controllers */
 	{
@@ -553,7 +553,7 @@ struct ahc_pci_identity ahc_pci_ident_ta
 	}
 };
 
-const u_int ahc_num_pci_devs = NUM_ELEMENTS(ahc_pci_ident_table);
+static const u_int ahc_num_pci_devs = NUM_ELEMENTS(ahc_pci_ident_table);
 		
 #define AHC_394X_SLOT_CHANNEL_A	4
 #define AHC_394X_SLOT_CHANNEL_B	5
_
