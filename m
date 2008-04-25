From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 2/5] aic7xxx: add static
Date: Fri, 25 Apr 2008 04:34:49 +0200
Message-ID: <200804250434.49377.vda.linux@googlemail.com>
References: <200804250432.16943.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JNUEI4KtM+xC9bt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:12185 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYDYCgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 22:36:03 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3380441fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 19:36:01 -0700 (PDT)
In-Reply-To: <200804250432.16943.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

--Boundary-00=_JNUEI4KtM+xC9bt
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch adds static (and sometimes const) keywords where appropriate.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_JNUEI4KtM+xC9bt
Content-Type: text/x-diff;
  charset="koi8-r";
  name="aic_debloat_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aic_debloat_2.diff"

--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic79xx.h	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx.h	Thu Apr 24 07:51:53 2008
@@ -1313,17 +1313,17 @@
 
 struct ahd_pci_identity {
 	uint64_t		 full_id;
 	uint64_t		 id_mask;
-	char			*name;
+	const char		*name;
 	ahd_device_setup_t	*setup;
 };
 
 /***************************** VL/EISA Declarations ***************************/
 struct aic7770_identity {
 	uint32_t		 full_id;
 	uint32_t		 id_mask;
-	char			*name;
+	const char		*name;
 	ahd_device_setup_t	*setup;
 };
 extern struct aic7770_identity aic7770_ident_table [];
 extern const int ahd_num_aic7770_devs;
@@ -1332,9 +1332,8 @@
 #define AHD_EISA_IOSIZE		0x100
 
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
-void			ahd_reset_cmds_pending(struct ahd_softc *ahd);
 
 /***************************** PCI Front End *********************************/
 struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
 int			  ahd_pci_config(struct ahd_softc *,
@@ -1375,18 +1374,8 @@
 					    u_int addr, u_int value);
 int			 ahd_read_flexport(struct ahd_softc *ahd, u_int addr,
 					   uint8_t *value);
 
-/*************************** Interrupt Services *******************************/
-void			ahd_run_qoutfifo(struct ahd_softc *ahd);
-#ifdef AHD_TARGET_MODE
-void			ahd_run_tqinfifo(struct ahd_softc *ahd, int paused);
-#endif
-void			ahd_handle_hwerrint(struct ahd_softc *ahd);
-void			ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat);
-void			ahd_handle_scsiint(struct ahd_softc *ahd,
-					   u_int intstat);
-
 /***************************** Error Recovery *********************************/
 typedef enum {
 	SEARCH_COMPLETE,
 	SEARCH_COUNT,
@@ -1478,9 +1467,9 @@
 #endif
 void			ahd_print_devinfo(struct ahd_softc *ahd,
 					  struct ahd_devinfo *devinfo);
 void			ahd_dump_card_state(struct ahd_softc *ahd);
-int			ahd_print_register(ahd_reg_parse_entry_t *table,
+int			ahd_print_register(const ahd_reg_parse_entry_t *table,
 					   u_int num_entries,
 					   const char *name,
 					   u_int address,
 					   u_int value,
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic79xx_core.c	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_core.c	Thu Apr 24 07:51:53 2008
@@ -265,8 +265,20 @@
 static int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
 				      int target, char channel, int lun,
 				      u_int tag, role_t role);
 
+static void		ahd_reset_cmds_pending(struct ahd_softc *ahd);
+
+/*************************** Interrupt Services *******************************/
+static void		ahd_run_qoutfifo(struct ahd_softc *ahd);
+#ifdef AHD_TARGET_MODE
+static void		ahd_run_tqinfifo(struct ahd_softc *ahd, int paused);
+#endif
+static void		ahd_handle_hwerrint(struct ahd_softc *ahd);
+static void		ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat);
+static void		ahd_handle_scsiint(struct ahd_softc *ahd,
+				           u_int intstat);
+
 /************************ Sequencer Execution Control *************************/
 void
 ahd_set_modes(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
@@ -284,9 +296,9 @@
 	ahd->src_mode = src;
 	ahd->dst_mode = dst;
 }
 
-void
+static void
 ahd_update_modes(struct ahd_softc *ahd)
 {
 	ahd_mode_state mode_ptr;
 	ahd_mode src;
@@ -300,9 +312,9 @@
 	ahd_extract_mode_state(ahd, mode_ptr, &src, &dst);
 	ahd_known_modes(ahd, src, dst);
 }
 
-void
+static void
 ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 		 ahd_mode dstmode, const char *file, int line)
 {
 #ifdef AHD_DEBUG
@@ -421,9 +433,9 @@
 		return (sg + 1);
 	}
 }
 
-void
+static void
 ahd_setup_scb_common(struct ahd_softc *ahd, struct scb *scb)
 {
 	/* XXX Handle target mode SCBs. */
 	scb->crc_retry_count = 0;
@@ -442,9 +454,9 @@
 		scb->hscb->shared_data.idata.cdb_plus_saddr.sense_addr =
 		    ahd_htole32(scb->sense_busaddr);
 }
 
-void
+static void
 ahd_setup_data_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	/*
 	 * Copy the first SG into the "current" data ponter area.
@@ -479,18 +491,18 @@
 	 */
 	scb->hscb->sgptr = ahd_htole32(scb->sg_list_busaddr|SG_FULL_RESID);
 }
 
-void
+static void
 ahd_setup_noxfer_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	scb->hscb->sgptr = ahd_htole32(SG_LIST_NULL);
 	scb->hscb->dataptr = 0;
 	scb->hscb->datacnt = 0;
 }
 
 /************************** Memory mapping routines ***************************/
-void *
+static void *
 ahd_sg_bus_to_virt(struct ahd_softc *ahd, struct scb *scb, uint32_t sg_busaddr)
 {
 	dma_addr_t sg_offset;
 
@@ -498,9 +510,9 @@
 	sg_offset = sg_busaddr - (scb->sg_list_busaddr - ahd_sg_size(ahd));
 	return ((uint8_t *)scb->sg_list + sg_offset);
 }
 
-uint32_t
+static uint32_t
 ahd_sg_virt_to_bus(struct ahd_softc *ahd, struct scb *scb, void *sg)
 {
 	dma_addr_t sg_offset;
 
@@ -510,9 +522,9 @@
 
 	return (scb->sg_list_busaddr + sg_offset);
 }
 
-void
+static void
 ahd_sync_scb(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.hscb_dmat,
 			scb->hscb_map->dmamap,
@@ -531,23 +543,25 @@
 			/*offset*/scb->sg_list_busaddr - ahd_sg_size(ahd),
 			/*len*/ahd_sg_size(ahd) * scb->sg_count, op);
 }
 
-void
+static void
 ahd_sync_sense(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.sense_dmat,
 			scb->sense_map->dmamap,
 			/*offset*/scb->sense_busaddr,
 			/*len*/AHD_SENSE_BUFSIZE, op);
 }
 
-uint32_t
+#ifdef AHD_TARGET_MODE
+static uint32_t
 ahd_targetcmd_offset(struct ahd_softc *ahd, u_int index)
 {
 	return (((uint8_t *)&ahd->targetcmds[index])
 	       - (uint8_t *)ahd->qoutfifo);
 }
+#endif
 
 /*********************** Miscelaneous Support Functions ***********************/
 /*
  * Return pointers to the transfer negotiation information
@@ -652,33 +666,37 @@
 	ahd_outb(ahd, SCBPTR, scbptr & 0xFF);
 	ahd_outb(ahd, SCBPTR+1, (scbptr >> 8) & 0xFF);
 }
 
-u_int
+#if 0 /* unused */
+static u_int
 ahd_get_hnscb_qoff(struct ahd_softc *ahd)
 {
 	return (ahd_inw_atomic(ahd, HNSCB_QOFF));
 }
+#endif
 
-void
+static void
 ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outw_atomic(ahd, HNSCB_QOFF, value);
 }
 
-u_int
+#if 0 /* unused */
+static u_int
 ahd_get_hescb_qoff(struct ahd_softc *ahd)
 {
 	return (ahd_inb(ahd, HESCB_QOFF));
 }
+#endif
 
-void
+static void
 ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outb(ahd, HESCB_QOFF, value);
 }
 
-u_int
+static u_int
 ahd_get_snscb_qoff(struct ahd_softc *ahd)
 {
 	u_int oldvalue;
 
@@ -687,37 +705,41 @@
 	ahd_outw(ahd, SNSCB_QOFF, oldvalue);
 	return (oldvalue);
 }
 
-void
+static void
 ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outw(ahd, SNSCB_QOFF, value);
 }
 
-u_int
+#if 0 /* unused */
+static u_int
 ahd_get_sescb_qoff(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	return (ahd_inb(ahd, SESCB_QOFF));
 }
+#endif
 
-void
+static void
 ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outb(ahd, SESCB_QOFF, value);
 }
 
-u_int
+#if 0 /* unused */
+static u_int
 ahd_get_sdscb_qoff(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	return (ahd_inb(ahd, SDSCB_QOFF) | (ahd_inb(ahd, SDSCB_QOFF + 1) << 8));
 }
+#endif
 
-void
+static void
 ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outb(ahd, SDSCB_QOFF, value & 0xFF);
@@ -755,16 +777,16 @@
 	return (ahd_inb_scbram(ahd, offset)
 	      | (ahd_inb_scbram(ahd, offset+1) << 8));
 }
 
-uint32_t
+static uint32_t
 ahd_inl_scbram(struct ahd_softc *ahd, u_int offset)
 {
 	return (ahd_inw_scbram(ahd, offset)
 	      | (ahd_inw_scbram(ahd, offset+2) << 16));
 }
 
-uint64_t
+static uint64_t
 ahd_inq_scbram(struct ahd_softc *ahd, u_int offset)
 {
 	return (ahd_inl_scbram(ahd, offset)
 	      | ((uint64_t)ahd_inl_scbram(ahd, offset+4)) << 32);
@@ -783,9 +805,9 @@
 			     BUS_DMASYNC_POSTREAD|BUS_DMASYNC_POSTWRITE);
 	return (scb);
 }
 
-void
+static void
 ahd_swap_with_next_hscb(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct	 hardware_scb *q_hscb;
 	struct	 map_node *q_hscb_map;
@@ -868,17 +890,17 @@
 	ahd_set_hnscb_qoff(ahd, ahd->qinfifonext);
 }
 
 /************************** Interrupt Processing ******************************/
-void
+static void
 ahd_sync_qoutfifo(struct ahd_softc *ahd, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
 			/*offset*/0,
 			/*len*/AHD_SCB_MAX * sizeof(struct ahd_completion), op);
 }
 
-void
+static void
 ahd_sync_tqinfifo(struct ahd_softc *ahd, int op)
 {
 #ifdef AHD_TARGET_MODE
 	if ((ahd->flags & AHD_TARGETROLE) != 0) {
@@ -896,9 +918,9 @@
  * into our in-core command complete fifos.
  */
 #define AHD_RUN_QOUTFIFO 0x1
 #define AHD_RUN_TQINFIFO 0x2
-u_int
+static u_int
 ahd_check_cmdcmpltqueues(struct ahd_softc *ahd)
 {
 	u_int retval;
 
@@ -1639,9 +1661,9 @@
  * occurred with no errors and no residual.  sg_status is
  * a copy of the first byte (little endian) of the sgptr
  * hscb field.
  */
-void
+static void
 ahd_run_qoutfifo(struct ahd_softc *ahd)
 {
 	struct ahd_completion *completion;
 	struct scb *scb;
@@ -1678,9 +1700,9 @@
 	ahd->flags &= ~AHD_RUNNING_QOUTFIFO;
 }
 
 /************************* Interrupt Handling *********************************/
-void
+static void
 ahd_handle_hwerrint(struct ahd_softc *ahd)
 {
 	/*
 	 * Some catastrophic hardware error has occurred.
@@ -1752,9 +1774,9 @@
 	}
 }
 #endif  /*  AHD_DEBUG  */
 
-void
+static void
 ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 {
 	u_int seqintcode;
 
@@ -2364,9 +2386,9 @@
 	 */
 	ahd_unpause(ahd);
 }
 
-void
+static void
 ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 {
 	struct scb	*scb;
 	u_int		 status0;
@@ -8130,9 +8152,9 @@
 		return (wrap_qinfifonext
 		      + ARRAY_SIZE(ahd->qinfifo) - wrap_qinpos);
 }
 
-void
+static void
 ahd_reset_cmds_pending(struct ahd_softc *ahd)
 {
 	struct		scb *scb;
 	ahd_mode_state	saved_modes;
@@ -9655,9 +9677,9 @@
 	return (last_probe);
 }
 
 int
-ahd_print_register(ahd_reg_parse_entry_t *table, u_int num_entries,
+ahd_print_register(const ahd_reg_parse_entry_t *table, u_int num_entries,
 		   const char *name, u_int address, u_int value,
 		   u_int *cur_column, u_int wrap_point)
 {
 	int	printed;
@@ -10646,9 +10668,9 @@
 		ahd_outb(ahd, SCSIID, scsiid);
 #endif
 }
 
-void
+static void
 ahd_run_tqinfifo(struct ahd_softc *ahd, int paused)
 {
 	struct target_cmd *cmd;
 
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic79xx_inline.h	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_inline.h	Thu Apr 24 07:51:53 2008
@@ -65,12 +65,8 @@
 					    ahd_mode *src, ahd_mode *dst);
 
 void ahd_set_modes(struct ahd_softc *ahd, ahd_mode src,
 		   ahd_mode dst);
-void ahd_update_modes(struct ahd_softc *ahd);
-void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
-		      ahd_mode dstmode, const char *file,
-		      int line);
 ahd_mode_state ahd_save_modes(struct ahd_softc *ahd);
 void ahd_restore_modes(struct ahd_softc *ahd,
 		       ahd_mode_state state);
 int  ahd_is_paused(struct ahd_softc *ahd);
@@ -103,35 +99,14 @@
 /*********************** Scatter Gather List Handling *************************/
 void	*ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
 		      void *sgptr, dma_addr_t addr,
 		      bus_size_t len, int last);
-void	 ahd_setup_scb_common(struct ahd_softc *ahd,
-			      struct scb *scb);
-void	 ahd_setup_data_scb(struct ahd_softc *ahd,
-			    struct scb *scb);
-void	 ahd_setup_noxfer_scb(struct ahd_softc *ahd,
-			      struct scb *scb);
 
 /************************** Memory mapping routines ***************************/
 static __inline size_t	ahd_sg_size(struct ahd_softc *ahd);
 
-void *
-	ahd_sg_bus_to_virt(struct ahd_softc *ahd,
-			   struct scb *scb,
-			   uint32_t sg_busaddr);
-uint32_t
-	ahd_sg_virt_to_bus(struct ahd_softc *ahd,
-			   struct scb *scb,
-			   void *sg);
-void	ahd_sync_scb(struct ahd_softc *ahd,
-		     struct scb *scb, int op);
 void	ahd_sync_sglist(struct ahd_softc *ahd,
 			struct scb *scb, int op);
-void	ahd_sync_sense(struct ahd_softc *ahd,
-		       struct scb *scb, int op);
-uint32_t
-	ahd_targetcmd_offset(struct ahd_softc *ahd,
-			     u_int index);
 
 static __inline size_t
 ahd_sg_size(struct ahd_softc *ahd)
 {
@@ -159,28 +134,12 @@
 void	ahd_outq(struct ahd_softc *ahd, u_int port,
 		 uint64_t value);
 u_int	ahd_get_scbptr(struct ahd_softc *ahd);
 void	ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr);
-u_int	ahd_get_hnscb_qoff(struct ahd_softc *ahd);
-void	ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value);
-u_int	ahd_get_hescb_qoff(struct ahd_softc *ahd);
-void	ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value);
-u_int	ahd_get_snscb_qoff(struct ahd_softc *ahd);
-void	ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value);
-u_int	ahd_get_sescb_qoff(struct ahd_softc *ahd);
-void	ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value);
-u_int	ahd_get_sdscb_qoff(struct ahd_softc *ahd);
-void	ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value);
 u_int	ahd_inb_scbram(struct ahd_softc *ahd, u_int offset);
 u_int	ahd_inw_scbram(struct ahd_softc *ahd, u_int offset);
-uint32_t
-	ahd_inl_scbram(struct ahd_softc *ahd, u_int offset);
-uint64_t
-	ahd_inq_scbram(struct ahd_softc *ahd, u_int offset);
 struct scb *
 	ahd_lookup_scb(struct ahd_softc *ahd, u_int tag);
-void	ahd_swap_with_next_hscb(struct ahd_softc *ahd,
-				struct scb *scb);
 void	ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb);
 
 static __inline uint8_t *
 			ahd_get_sense_buf(struct ahd_softc *ahd,
@@ -211,10 +170,7 @@
 	return (scb->sense_busaddr);
 }
 
 /************************** Interrupt Processing ******************************/
-void	ahd_sync_qoutfifo(struct ahd_softc *ahd, int op);
-void	ahd_sync_tqinfifo(struct ahd_softc *ahd, int op);
-u_int	ahd_check_cmdcmpltqueues(struct ahd_softc *ahd);
 int	ahd_intr(struct ahd_softc *ahd);
 
 #endif  /* _AIC79XX_INLINE_H_ */
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic79xx_osm.c	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_osm.c	Thu Apr 24 07:51:53 2008
@@ -387,9 +387,8 @@
 
 
 /***************************** Low Level I/O **********************************/
 uint8_t ahd_inb(struct ahd_softc * ahd, long port);
-uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
 void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
 void ahd_outw_atomic(struct ahd_softc * ahd,
 				     long port, uint16_t val);
 void ahd_outsb(struct ahd_softc * ahd, long port,
@@ -410,9 +409,10 @@
 	mb();
 	return (x);
 }
 
-uint16_t
+#if 0 /* unused */
+static uint16_t
 ahd_inw_atomic(struct ahd_softc * ahd, long port)
 {
 	uint8_t x;
 
@@ -423,8 +423,9 @@
 	}
 	mb();
 	return (x);
 }
+#endif
 
 void
 ahd_outb(struct ahd_softc * ahd, long port, uint8_t val)
 {
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic79xx_osm.h	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_osm.h	Thu Apr 24 07:51:53 2008
@@ -373,9 +373,8 @@
 void ahd_delay(long);
 
 /***************************** Low Level I/O **********************************/
 uint8_t ahd_inb(struct ahd_softc * ahd, long port);
-uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
 void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
 void ahd_outw_atomic(struct ahd_softc * ahd,
 				     long port, uint16_t val);
 void ahd_outsb(struct ahd_softc * ahd, long port,
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic79xx_pci.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_pci.c	Thu Apr 24 07:51:53 2008
@@ -96,9 +96,9 @@
 static ahd_device_setup_t ahd_aic7901A_setup;
 static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-static struct ahd_pci_identity ahd_pci_ident_table [] =
+static struct ahd_pci_identity ahd_pci_ident_table[] =
 {
 	/* aic7901 based controllers */
 	{
 		ID_AHA_29320A,
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic7xxx.h	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx.h	Thu Apr 24 07:51:53 2008
@@ -735,9 +735,9 @@
 #define		ULTRA_SXFR 0x100	/* Rate Requires Ultra Mode set */
 #define		ST_SXFR	   0x010	/* Rate Single Transition Only */
 #define		DT_SXFR	   0x040	/* Rate Double Transition Only */
 	uint8_t period; /* Period to send to SCSI target */
-	char *rate;
+	const char *rate;
 };
 
 /* Safe and valid period for async negotiations. */
 #define	AHC_ASYNC_XFER_PERIOD 0x45
@@ -1132,12 +1132,8 @@
 #define AHC_EISA_IOSIZE		0x100
 
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
-u_int			ahc_index_busy_tcl(struct ahc_softc *ahc, u_int tcl);
-void			ahc_unbusy_tcl(struct ahc_softc *ahc, u_int tcl);
-void			ahc_busy_tcl(struct ahc_softc *ahc,
-				     u_int tcl, u_int busyid);
 
 /***************************** PCI Front End *********************************/
 struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
 int			 ahc_pci_config(struct ahc_softc *,
@@ -1154,11 +1150,8 @@
 					u_int port);
 
 /************************** SCB and SCB queue management **********************/
 int		ahc_probe_scbs(struct ahc_softc *);
-void		ahc_run_untagged_queues(struct ahc_softc *ahc);
-void		ahc_run_untagged_queue(struct ahc_softc *ahc,
-				       struct scb_tailq *queue);
 void		ahc_qinfifo_requeue_tail(struct ahc_softc *ahc,
 					 struct scb *scb);
 int		ahc_match_scb(struct ahc_softc *ahc, struct scb *scb,
 			      int target, char channel, int lun,
@@ -1177,25 +1170,11 @@
 int			 ahc_resume(struct ahc_softc *ahc);
 #endif
 void			 ahc_set_unit(struct ahc_softc *, int);
 void			 ahc_set_name(struct ahc_softc *, char *);
-void			 ahc_alloc_scbs(struct ahc_softc *ahc);
 void			 ahc_free(struct ahc_softc *ahc);
 int			 ahc_reset(struct ahc_softc *ahc, int reinit);
-void			 ahc_shutdown(void *arg);
 
-/*************************** Interrupt Services *******************************/
-void			ahc_clear_intstat(struct ahc_softc *ahc);
-void			ahc_run_qoutfifo(struct ahc_softc *ahc);
-#ifdef AHC_TARGET_MODE
-void			ahc_run_tqinfifo(struct ahc_softc *ahc, int paused);
-#endif
-void			ahc_handle_brkadrint(struct ahc_softc *ahc);
-void			ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat);
-void			ahc_handle_scsiint(struct ahc_softc *ahc,
-					   u_int intstat);
-void			ahc_clear_critical_section(struct ahc_softc *ahc);
-
 /***************************** Error Recovery *********************************/
 typedef enum {
 	SEARCH_COMPLETE,
 	SEARCH_COUNT,
@@ -1213,38 +1192,21 @@
 int			ahc_search_disc_list(struct ahc_softc *ahc, int target,
 					     char channel, int lun, u_int tag,
 					     int stop_on_first, int remove,
 					     int save_state);
-void			ahc_freeze_devq(struct ahc_softc *ahc, struct scb *scb);
 int			ahc_reset_channel(struct ahc_softc *ahc, char channel,
 					  int initiate_reset);
-int			ahc_abort_scbs(struct ahc_softc *ahc, int target,
-				       char channel, int lun, u_int tag,
-				       role_t role, uint32_t status);
-void			ahc_restart(struct ahc_softc *ahc);
-void			ahc_calc_residual(struct ahc_softc *ahc,
-					  struct scb *scb);
+
 /*************************** Utility Functions ********************************/
-struct ahc_phase_table_entry*
-			ahc_lookup_phase_entry(int phase);
 void			ahc_compile_devinfo(struct ahc_devinfo *devinfo,
 					    u_int our_id, u_int target,
 					    u_int lun, char channel,
 					    role_t role);
 /************************** Transfer Negotiation ******************************/
-struct ahc_syncrate*	ahc_find_syncrate(struct ahc_softc *ahc, u_int *period,
+const struct ahc_syncrate*	ahc_find_syncrate(struct ahc_softc *ahc, u_int *period,
 					  u_int *ppr_options, u_int maxsync);
 u_int			ahc_find_period(struct ahc_softc *ahc,
 					u_int scsirate, u_int maxsync);
-void			ahc_validate_offset(struct ahc_softc *ahc,
-					    struct ahc_initiator_tinfo *tinfo,
-					    struct ahc_syncrate *syncrate,
-					    u_int *offset, int wide,
-					    role_t role);
-void			ahc_validate_width(struct ahc_softc *ahc,
-					   struct ahc_initiator_tinfo *tinfo,
-					   u_int *bus_width,
-					   role_t role);
 /*
  * Negotiation types.  These are used to qualify if we should renegotiate
  * even if our goal and current transport parameters are identical.
  */
@@ -1262,9 +1224,9 @@
 				      struct ahc_devinfo *devinfo,
 				      u_int width, u_int type, int paused);
 void			ahc_set_syncrate(struct ahc_softc *ahc,
 					 struct ahc_devinfo *devinfo,
-					 struct ahc_syncrate *syncrate,
+					 const struct ahc_syncrate *syncrate,
 					 u_int period, u_int offset,
 					 u_int ppr_options,
 					 u_int type, int paused);
 typedef enum {
@@ -1304,13 +1266,12 @@
 #define AHC_SHOW_TQIN		0x0800
 #define AHC_SHOW_MASKED_ERRORS	0x1000
 #define AHC_DEBUG_SEQUENCER	0x2000
 #endif
-void			ahc_print_scb(struct scb *scb);
 void			ahc_print_devinfo(struct ahc_softc *ahc,
 					  struct ahc_devinfo *dev);
 void			ahc_dump_card_state(struct ahc_softc *ahc);
-int			ahc_print_register(ahc_reg_parse_entry_t *table,
+int			ahc_print_register(const ahc_reg_parse_entry_t *table,
 					   u_int num_entries,
 					   const char *name,
 					   u_int address,
 					   u_int value,
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic7xxx_core.c	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_core.c	Thu Apr 24 07:51:53 2008
@@ -50,10 +50,9 @@
 #include <dev/aic7xxx/aicasm/aicasm_insformat.h>
 #endif
 
 /***************************** Lookup Tables **********************************/
-char *ahc_chip_names[] =
-{
+static const char *const ahc_chip_names[] = {
 	"NONE",
 	"aic7770",
 	"aic7850",
 	"aic7855",
@@ -74,12 +73,12 @@
  * Hardware error codes.
  */
 struct ahc_hard_error_entry {
         uint8_t errno;
-	char *errmesg;
+	const char *errmesg;
 };
 
-static struct ahc_hard_error_entry ahc_hard_errors[] = {
+static const struct ahc_hard_error_entry ahc_hard_errors[] = {
 	{ ILLHADDR,	"Illegal Host Access" },
 	{ ILLSADDR,	"Illegal Sequencer Address referrenced" },
 	{ ILLOPCODE,	"Illegal Opcode in sequencer program" },
 	{ SQPARERR,	"Sequencer Parity Error" },
@@ -89,9 +88,9 @@
 	{ CIOPARERR,	"CIOBUS Parity Error" },
 };
 static const u_int num_errors = ARRAY_SIZE(ahc_hard_errors);
 
-static struct ahc_phase_table_entry ahc_phase_table[] =
+static const struct ahc_phase_table_entry ahc_phase_table[] =
 {
 	{ P_DATAOUT,	MSG_NOOP,		"in Data-out phase"	},
 	{ P_DATAIN,	MSG_INITIATOR_DET_ERR,	"in Data-in phase"	},
 	{ P_DATAOUT_DT,	MSG_NOOP,		"in DT Data-out phase"	},
@@ -114,9 +113,9 @@
  * Valid SCSIRATE values.  (p. 3-17)
  * Provides a mapping of tranfer periods in ns to the proper value to
  * stick in the scsixfer reg.
  */
-static struct ahc_syncrate ahc_syncrates[] =
+static const struct ahc_syncrate ahc_syncrates[] =
 {
       /* ultra2    fast/ultra  period     rate */
 	{ 0x42,      0x000,      9,      "80.0" },
 	{ 0x03,      0x000,     10,      "40.0" },
@@ -147,9 +146,9 @@
 #ifdef AHC_TARGET_MODE
 static void		ahc_free_tstate(struct ahc_softc *ahc,
 					u_int scsi_id, char channel, int force);
 #endif
-static struct ahc_syncrate*
+static const struct ahc_syncrate*
 			ahc_devlimited_syncrate(struct ahc_softc *ahc,
 					        struct ahc_initiator_tinfo *,
 						u_int *period,
 						u_int *ppr_options,
@@ -203,11 +202,11 @@
 					       struct scb *scb);
 #endif
 
 static bus_dmamap_callback_t	ahc_dmamap_cb; 
-static void			ahc_build_free_scb_list(struct ahc_softc *ahc);
-static int			ahc_init_scbdata(struct ahc_softc *ahc);
-static void			ahc_fini_scbdata(struct ahc_softc *ahc);
+static void		ahc_build_free_scb_list(struct ahc_softc *ahc);
+static int		ahc_init_scbdata(struct ahc_softc *ahc);
+static void		ahc_fini_scbdata(struct ahc_softc *ahc);
 static void		ahc_qinfifo_requeue(struct ahc_softc *ahc,
 					    struct scb *prev_scb,
 					    struct scb *scb);
 static int		ahc_qinfifo_count(struct ahc_softc *ahc);
@@ -237,8 +236,73 @@
 static int		ahc_handle_target_cmd(struct ahc_softc *ahc,
 					      struct target_cmd *cmd);
 #endif
 
+static u_int		ahc_index_busy_tcl(struct ahc_softc *ahc, u_int tcl);
+static void		ahc_unbusy_tcl(struct ahc_softc *ahc, u_int tcl);
+static void		ahc_busy_tcl(struct ahc_softc *ahc,
+				     u_int tcl, u_int busyid);
+
+/************************** SCB and SCB queue management **********************/
+static void		ahc_run_untagged_queues(struct ahc_softc *ahc);
+static void		ahc_run_untagged_queue(struct ahc_softc *ahc,
+					       struct scb_tailq *queue);
+
+/****************************** Initialization ********************************/
+static void		 ahc_alloc_scbs(struct ahc_softc *ahc);
+static void		 ahc_shutdown(void *arg);
+
+/*************************** Interrupt Services *******************************/
+static void		ahc_clear_intstat(struct ahc_softc *ahc);
+static void		ahc_run_qoutfifo(struct ahc_softc *ahc);
+#ifdef AHC_TARGET_MODE
+static void		ahc_run_tqinfifo(struct ahc_softc *ahc, int paused);
+#endif
+static void		ahc_handle_brkadrint(struct ahc_softc *ahc);
+static void		ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat);
+static void		ahc_handle_scsiint(struct ahc_softc *ahc,
+					   u_int intstat);
+static void		ahc_clear_critical_section(struct ahc_softc *ahc);
+
+/***************************** Error Recovery *********************************/
+static void		ahc_freeze_devq(struct ahc_softc *ahc, struct scb *scb);
+static int		ahc_abort_scbs(struct ahc_softc *ahc, int target,
+				       char channel, int lun, u_int tag,
+				       role_t role, uint32_t status);
+static void		ahc_calc_residual(struct ahc_softc *ahc,
+					  struct scb *scb);
+
+/*********************** Untagged Transaction Routines ************************/
+static inline void	ahc_freeze_untagged_queues(struct ahc_softc *ahc);
+static inline void	ahc_release_untagged_queues(struct ahc_softc *ahc);
+
+/*
+ * Block our completion routine from starting the next untagged
+ * transaction for this target or target lun.
+ */
+static inline void
+ahc_freeze_untagged_queues(struct ahc_softc *ahc)
+{
+	if ((ahc->flags & AHC_SCB_BTT) == 0)
+		ahc->untagged_queue_lock++;
+}
+
+/*
+ * Allow the next untagged transaction for this target or target lun
+ * to be executed.  We use a counting semaphore to allow the lock
+ * to be acquired recursively.  Once the count drops to zero, the
+ * transaction queues will be run.
+ */
+static inline void
+ahc_release_untagged_queues(struct ahc_softc *ahc)
+{
+	if ((ahc->flags & AHC_SCB_BTT) == 0) {
+		ahc->untagged_queue_lock--;
+		if (ahc->untagged_queue_lock == 0)
+			ahc_run_untagged_queues(ahc);
+	}
+}
+
 /************************* Sequencer Execution Control ************************/
 /*
  * Work around any chip bugs related to halting sequencer execution.
  * On Ultra2 controllers, we must clear the CIOBUS stretch signal by
@@ -246,9 +310,9 @@
  * Without this workaround, if the chip is paused, by an interrupt or
  * manual pause while accessing scb ram, accesses to certain registers
  * will hang the system (infinite pci retries).
  */
-void
+static void
 ahc_pause_bug_fix(struct ahc_softc *ahc)
 {
 	if ((ahc->features & AHC_ULTRA2) != 0)
 		(void)ahc_inb(ahc, CCSCBCTL);
@@ -303,9 +367,9 @@
 		ahc_outb(ahc, HCNTRL, ahc->unpause);
 }
 
 /************************** Memory mapping routines ***************************/
-struct ahc_dma_seg *
+static struct ahc_dma_seg *
 ahc_sg_bus_to_virt(struct scb *scb, uint32_t sg_busaddr)
 {
 	int sg_index;
 
@@ -315,9 +379,9 @@
 
 	return (&scb->sg_list[sg_index]);
 }
 
-uint32_t
+static uint32_t
 ahc_sg_virt_to_bus(struct scb *scb, struct ahc_dma_seg *sg)
 {
 	int sg_index;
 
@@ -326,16 +390,16 @@
 
 	return (scb->sg_list_phys + (sg_index * sizeof(*scb->sg_list)));
 }
 
-uint32_t
+static uint32_t
 ahc_hscb_busaddr(struct ahc_softc *ahc, u_int index)
 {
 	return (ahc->scb_data->hscb_busaddr
 		+ (sizeof(struct hardware_scb) * index));
 }
 
-void
+static void
 ahc_sync_scb(struct ahc_softc *ahc, struct scb *scb, int op)
 {
 	ahc_dmamap_sync(ahc, ahc->scb_data->hscb_dmat,
 			ahc->scb_data->hscb_dmamap,
@@ -354,20 +418,22 @@
 				* sizeof(struct ahc_dma_seg),
 			/*len*/sizeof(struct ahc_dma_seg) * scb->sg_count, op);
 }
 
-uint32_t
+#ifdef AHC_TARGET_MODE
+static uint32_t
 ahc_targetcmd_offset(struct ahc_softc *ahc, u_int index)
 {
 	return (((uint8_t *)&ahc->targetcmds[index]) - ahc->qoutfifo);
 }
+#endif
 
 /*********************** Miscelaneous Support Functions ***********************/
 /*
  * Determine whether the sequencer reported a residual
  * for this SCB/transaction.
  */
-void
+static void
 ahc_update_residual(struct ahc_softc *ahc, struct scb *scb)
 {
 	uint32_t sgptr;
 
@@ -503,9 +569,9 @@
 			     BUS_DMASYNC_POSTREAD|BUS_DMASYNC_POSTWRITE);
 	return (scb);
 }
 
-void
+static void
 ahc_swap_with_next_hscb(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct hardware_scb *q_hscb;
 	u_int  saved_tag;
@@ -592,9 +658,9 @@
 	offset = scb - ahc->scb_data->scbarray;
 	return (&ahc->scb_data->sense[offset]);
 }
 
-uint32_t
+static uint32_t
 ahc_get_sense_bufaddr(struct ahc_softc *ahc, struct scb *scb)
 {
 	int offset;
 
@@ -603,16 +669,16 @@
 	      + (offset * sizeof(struct scsi_sense_data)));
 }
 
 /************************** Interrupt Processing ******************************/
-void
+static void
 ahc_sync_qoutfifo(struct ahc_softc *ahc, int op)
 {
 	ahc_dmamap_sync(ahc, ahc->shared_data_dmat, ahc->shared_data_dmamap,
 			/*offset*/0, /*len*/256, op);
 }
 
-void
+static void
 ahc_sync_tqinfifo(struct ahc_softc *ahc, int op)
 {
 #ifdef AHC_TARGET_MODE
 	if ((ahc->flags & AHC_TARGETROLE) != 0) {
@@ -630,9 +696,9 @@
  * into our in-core command complete fifos.
  */
 #define AHC_RUN_QOUTFIFO 0x1
 #define AHC_RUN_TQINFIFO 0x2
-u_int
+static u_int
 ahc_check_cmdcmpltqueues(struct ahc_softc *ahc)
 {
 	u_int retval;
 
@@ -744,9 +810,9 @@
 /************************* Sequencer Execution Control ************************/
 /*
  * Restart the sequencer program from address zero
  */
-void
+static void
 ahc_restart(struct ahc_softc *ahc)
 {
 
 	ahc_pause(ahc);
@@ -805,9 +871,9 @@
 	ahc_unpause(ahc);
 }
 
 /************************* Input/Output Queues ********************************/
-void
+static void
 ahc_run_qoutfifo(struct ahc_softc *ahc)
 {
 	struct scb *scb;
 	u_int  scb_index;
@@ -852,18 +918,18 @@
 		ahc_done(ahc, scb);
 	}
 }
 
-void
+static void
 ahc_run_untagged_queues(struct ahc_softc *ahc)
 {
 	int i;
 
 	for (i = 0; i < 16; i++)
 		ahc_run_untagged_queue(ahc, &ahc->untagged_queues[i]);
 }
 
-void
+static void
 ahc_run_untagged_queue(struct ahc_softc *ahc, struct scb_tailq *queue)
 {
 	struct scb *scb;
 
@@ -877,9 +943,9 @@
 	}
 }
 
 /************************* Interrupt Handling *********************************/
-void
+static void
 ahc_handle_brkadrint(struct ahc_softc *ahc)
 {
 	/*
 	 * We upset the sequencer :-(
@@ -906,9 +972,9 @@
 	/* Disable all interrupt sources by resetting the controller */
 	ahc_shutdown(ahc);
 }
 
-void
+static void
 ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 {
 	struct scb *scb;
 	struct ahc_devinfo devinfo;
@@ -1457,9 +1523,9 @@
 	 */
 	ahc_unpause(ahc);
 }
 
-void
+static void
 ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 {
 	u_int	scb_index;
 	u_int	status0;
@@ -1910,9 +1976,9 @@
 			       targ_info, AHC_NEG_IF_NON_ASYNC);
 }
 
 #define AHC_MAX_STEPS 2000
-void
+static void
 ahc_clear_critical_section(struct ahc_softc *ahc)
 {
 	int	stepping;
 	int	steps;
@@ -2003,9 +2069,9 @@
 
 /*
  * Clear any pending interrupt status.
  */
-void
+static void
 ahc_clear_intstat(struct ahc_softc *ahc)
 {
 	/* Clear any interrupt conditions this may have caused */
 	ahc_outb(ahc, CLRSINT1, CLRSELTIMEO|CLRATNO|CLRSCSIRSTI
@@ -2022,9 +2088,10 @@
 #ifdef AHC_DEBUG
 uint32_t ahc_debug = AHC_DEBUG_OPTS;
 #endif
 
-void
+#if 0 /* unused */
+static void
 ahc_print_scb(struct scb *scb)
 {
 	int i;
 
@@ -2054,8 +2121,9 @@
 			       ahc_le32toh(scb->sg_list[i].len));
 		}
 	}
 }
+#endif
 
 /************************* Transfer Negotiation *******************************/
 /*
  * Allocate per target mode instance (ID we respond to as a target)
@@ -2137,9 +2205,9 @@
  * this function finds the nearest syncrate to the input period limited
  * by the capabilities of the bus connectivity of and sync settings for
  * the target.
  */
-struct ahc_syncrate *
+const struct ahc_syncrate *
 ahc_devlimited_syncrate(struct ahc_softc *ahc,
 			struct ahc_initiator_tinfo *tinfo,
 			u_int *period, u_int *ppr_options, role_t role)
 {
@@ -2192,13 +2260,13 @@
  * Look up the valid period to SCSIRATE conversion in our table.
  * Return the period and offset that should be sent to the target
  * if this was the beginning of an SDTR.
  */
-struct ahc_syncrate *
+const struct ahc_syncrate *
 ahc_find_syncrate(struct ahc_softc *ahc, u_int *period,
 		  u_int *ppr_options, u_int maxsync)
 {
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if ((ahc->features & AHC_DT) == 0)
 		*ppr_options &= ~MSG_EXT_PPR_DT_REQ;
 
@@ -2271,9 +2339,9 @@
  */
 u_int
 ahc_find_period(struct ahc_softc *ahc, u_int scsirate, u_int maxsync)
 {
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if ((ahc->features & AHC_ULTRA2) != 0)
 		scsirate &= SXFR_ULTRA2;
 	else
@@ -2309,12 +2377,12 @@
 /*
  * Truncate the given synchronous offset to a value the
  * current adapter type and syncrate are capable of.
  */
-void
+static void
 ahc_validate_offset(struct ahc_softc *ahc,
 		    struct ahc_initiator_tinfo *tinfo,
-		    struct ahc_syncrate *syncrate,
+		    const struct ahc_syncrate *syncrate,
 		    u_int *offset, int wide, role_t role)
 {
 	u_int maxoffset;
 
@@ -2341,9 +2409,9 @@
 /*
  * Truncate the given transfer width parameter to a value the
  * current adapter type is capable of.
  */
-void
+static void
 ahc_validate_width(struct ahc_softc *ahc, struct ahc_initiator_tinfo *tinfo,
 		   u_int *bus_width, role_t role)
 {
 	switch (*bus_width) {
@@ -2416,9 +2484,9 @@
  * immediately.
  */
 void
 ahc_set_syncrate(struct ahc_softc *ahc, struct ahc_devinfo *devinfo,
-		 struct ahc_syncrate *syncrate, u_int period,
+		 const struct ahc_syncrate *syncrate, u_int period,
 		 u_int offset, u_int ppr_options, u_int type, int paused)
 {
 	struct	ahc_initiator_tinfo *tinfo;
 	struct	ahc_tmode_tstate *tstate;
@@ -2723,13 +2791,13 @@
 			    SCSIID_CHANNEL(ahc, saved_scsiid),
 			    role);
 }
 
-struct ahc_phase_table_entry*
+static const struct ahc_phase_table_entry*
 ahc_lookup_phase_entry(int phase)
 {
-	struct ahc_phase_table_entry *entry;
-	struct ahc_phase_table_entry *last_entry;
+	const struct ahc_phase_table_entry *entry;
+	const struct ahc_phase_table_entry *last_entry;
 
 	/*
 	 * num_phases doesn't include the default entry which
 	 * will be returned if the phase doesn't match.
@@ -2893,9 +2961,9 @@
 	 * we want to renegotiate due to a check condition.
 	 */
 	struct	ahc_initiator_tinfo *tinfo;
 	struct	ahc_tmode_tstate *tstate;
-	struct	ahc_syncrate *rate;
+	const struct ahc_syncrate *rate;
 	int	dowide;
 	int	dosync;
 	int	doppr;
 	u_int	period;
@@ -3559,9 +3627,9 @@
 			break;
 		switch (ahc->msgin_buf[2]) {
 		case MSG_EXT_SDTR:
 		{
-			struct	 ahc_syncrate *syncrate;
+			const struct ahc_syncrate *syncrate;
 			u_int	 period;
 			u_int	 ppr_options;
 			u_int	 offset;
 			u_int	 saved_offset;
@@ -3734,9 +3802,9 @@
 			break;
 		}
 		case MSG_EXT_PPR:
 		{
-			struct	ahc_syncrate *syncrate;
+			const struct ahc_syncrate *syncrate;
 			u_int	period;
 			u_int	offset;
 			u_int	bus_width;
 			u_int	ppr_options;
@@ -4487,9 +4555,9 @@
 #endif
 	return;
 }
 
-void
+static void
 ahc_shutdown(void *arg)
 {
 	struct	ahc_softc *ahc;
 	int	i;
@@ -4891,9 +4959,9 @@
 	if (scb_data->scbarray != NULL)
 		free(scb_data->scbarray, M_DEVBUF);
 }
 
-void
+static void
 ahc_alloc_scbs(struct ahc_softc *ahc)
 {
 	struct scb_data *scb_data;
 	struct scb *next_scb;
@@ -5624,9 +5692,9 @@
 /*
  * Return the untagged transaction id for a given target/channel lun.
  * Optionally, clear the entry.
  */
-u_int
+static u_int
 ahc_index_busy_tcl(struct ahc_softc *ahc, u_int tcl)
 {
 	u_int scbid;
 	u_int target_offset;
@@ -5645,9 +5713,9 @@
 
 	return (scbid);
 }
 
-void
+static void
 ahc_unbusy_tcl(struct ahc_softc *ahc, u_int tcl)
 {
 	u_int target_offset;
 
@@ -5663,9 +5731,9 @@
 		ahc_outb(ahc, BUSY_TARGETS + target_offset, SCB_LIST_NULL);
 	}
 }
 
-void
+static void
 ahc_busy_tcl(struct ahc_softc *ahc, u_int tcl, u_int scbid)
 {
 	u_int target_offset;
 
@@ -5718,9 +5786,9 @@
 
 	return match;
 }
 
-void
+static void
 ahc_freeze_devq(struct ahc_softc *ahc, struct scb *scb)
 {
 	int	target;
 	char	channel;
@@ -6259,9 +6327,9 @@
  * setting their status to the passed in status if the status has not already
  * been modified from CAM_REQ_INPROG.  This routine assumes that the sequencer
  * is paused before it is called.
  */
-int
+static int
 ahc_abort_scbs(struct ahc_softc *ahc, int target, char channel,
 	       int lun, u_int tag, role_t role, uint32_t status)
 {
 	struct	scb *scbp;
@@ -6581,9 +6649,9 @@
 /***************************** Residual Processing ****************************/
 /*
  * Calculate the residual for a just completed SCB.
  */
-void
+static void
 ahc_calc_residual(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct hardware_scb *hscb;
 	struct status_pkt *spkt;
@@ -7048,9 +7116,9 @@
 	}
 }
 
 int
-ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
+ahc_print_register(const ahc_reg_parse_entry_t *table, u_int num_entries,
 		   const char *name, u_int address, u_int value,
 		   u_int *cur_column, u_int wrap_point)
 {
 	int	printed;
@@ -7732,9 +7800,9 @@
 	else
 		ahc_outb(ahc, SCSIID, scsiid);
 }
 
-void
+static void
 ahc_run_tqinfifo(struct ahc_softc *ahc, int paused)
 {
 	struct target_cmd *cmd;
 
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic7xxx_inline.h	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_inline.h	Thu Apr 24 07:51:53 2008
@@ -45,60 +45,15 @@
 #ifndef _AIC7XXX_INLINE_H_
 #define _AIC7XXX_INLINE_H_
 
 /************************* Sequencer Execution Control ************************/
-void ahc_pause_bug_fix(struct ahc_softc *ahc);
 int  ahc_is_paused(struct ahc_softc *ahc);
 void ahc_pause(struct ahc_softc *ahc);
 void ahc_unpause(struct ahc_softc *ahc);
 
-/*********************** Untagged Transaction Routines ************************/
-static __inline void	ahc_freeze_untagged_queues(struct ahc_softc *ahc);
-static __inline void	ahc_release_untagged_queues(struct ahc_softc *ahc);
-
-/*
- * Block our completion routine from starting the next untagged
- * transaction for this target or target lun.
- */
-static __inline void
-ahc_freeze_untagged_queues(struct ahc_softc *ahc)
-{
-	if ((ahc->flags & AHC_SCB_BTT) == 0)
-		ahc->untagged_queue_lock++;
-}
-
-/*
- * Allow the next untagged transaction for this target or target lun
- * to be executed.  We use a counting semaphore to allow the lock
- * to be acquired recursively.  Once the count drops to zero, the
- * transaction queues will be run.
- */
-static __inline void
-ahc_release_untagged_queues(struct ahc_softc *ahc)
-{
-	if ((ahc->flags & AHC_SCB_BTT) == 0) {
-		ahc->untagged_queue_lock--;
-		if (ahc->untagged_queue_lock == 0)
-			ahc_run_untagged_queues(ahc);
-	}
-}
-
 /************************** Memory mapping routines ***************************/
-struct ahc_dma_seg *
-	ahc_sg_bus_to_virt(struct scb *scb,
-			   uint32_t sg_busaddr);
-uint32_t
-	ahc_sg_virt_to_bus(struct scb *scb,
-			   struct ahc_dma_seg *sg);
-uint32_t
-	ahc_hscb_busaddr(struct ahc_softc *ahc, u_int index);
-void	ahc_sync_scb(struct ahc_softc *ahc,
-		     struct scb *scb, int op);
 void	ahc_sync_sglist(struct ahc_softc *ahc,
 			struct scb *scb, int op);
-uint32_t
-	ahc_targetcmd_offset(struct ahc_softc *ahc,
-			     u_int index);
 
 /******************************** Debugging ***********************************/
 static __inline char *ahc_name(struct ahc_softc *ahc);
 
@@ -109,10 +64,8 @@
 }
 
 /*********************** Miscellaneous Support Functions ***********************/
 
-void	ahc_update_residual(struct ahc_softc *ahc,
-			    struct scb *scb);
 struct ahc_initiator_tinfo *
 	ahc_fetch_transinfo(struct ahc_softc *ahc,
 			    char channel, u_int our_id,
 			    u_int remote_id,
@@ -133,21 +86,13 @@
 	ahc_get_scb(struct ahc_softc *ahc);
 void	ahc_free_scb(struct ahc_softc *ahc, struct scb *scb);
 struct scb *
 	ahc_lookup_scb(struct ahc_softc *ahc, u_int tag);
-void	ahc_swap_with_next_hscb(struct ahc_softc *ahc,
-				struct scb *scb);
 void	ahc_queue_scb(struct ahc_softc *ahc, struct scb *scb);
 struct scsi_sense_data *
 	ahc_get_sense_buf(struct ahc_softc *ahc,
 			  struct scb *scb);
-uint32_t
-	ahc_get_sense_bufaddr(struct ahc_softc *ahc,
-			      struct scb *scb);
 
 /************************** Interrupt Processing ******************************/
-void	ahc_sync_qoutfifo(struct ahc_softc *ahc, int op);
-void	ahc_sync_tqinfifo(struct ahc_softc *ahc, int op);
-u_int	ahc_check_cmdcmpltqueues(struct ahc_softc *ahc);
 int	ahc_intr(struct ahc_softc *ahc);
 
 #endif  /* _AIC7XXX_INLINE_H_ */
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic7xxx_osm.c	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_osm.c	Thu Apr 24 07:51:53 2008
@@ -2385,9 +2385,9 @@
 	struct ahc_devinfo devinfo;
 	unsigned int ppr_options = tinfo->goal.ppr_options;
 	unsigned long flags;
 	unsigned long offset = tinfo->goal.offset;
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if (offset == 0)
 		offset = MAX_OFFSET;
 
@@ -2429,9 +2429,9 @@
 	struct ahc_devinfo devinfo;
 	unsigned int ppr_options = 0;
 	unsigned int period = 0;
 	unsigned long flags;
-	struct ahc_syncrate *syncrate = NULL;
+	const struct ahc_syncrate *syncrate = NULL;
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	if (offset != 0) {
@@ -2459,9 +2459,9 @@
 		& ~MSG_EXT_PPR_DT_REQ;
 	unsigned int period = tinfo->goal.period;
 	unsigned int width = tinfo->goal.width;
 	unsigned long flags;
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if (dt && spi_max_width(starget)) {
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
 		if (!width)
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic7xxx_osm.h	Thu Apr 24 07:48:32 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_osm.h	Thu Apr 24 07:51:53 2008
@@ -397,11 +397,8 @@
 	off_t offset;
 	int pos;
 };
 
-void	ahc_format_transinfo(struct info_str *info,
-			     struct ahc_transinfo *tinfo);
-
 /******************************** Locking *************************************/
 /* Lock protecting internal data structures */
 
 static __inline void
--- scsi-misc-2.6-2008_04_15.p1/drivers/scsi/aic7xxx/aic7xxx_proc.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_proc.c	Thu Apr 24 07:51:53 2008
@@ -136,9 +136,9 @@
 	copy_mem_info(info, buf, len);
 	return (len);
 }
 
-void
+static void
 ahc_format_transinfo(struct info_str *info, struct ahc_transinfo *tinfo)
 {
 	u_int speed;
 	u_int freq;

--Boundary-00=_JNUEI4KtM+xC9bt--
