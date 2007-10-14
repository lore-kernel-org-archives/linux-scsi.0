From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 2/3] debloat aic7xxx and aic79xx drivers
Date: Sun, 14 Oct 2007 16:01:08 +0100
Message-ID: <200710141601.08946.vda.linux@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com> <200710141600.10468.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_08iEHQZBvcGY4Du"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:50027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbXJNPBT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 11:01:19 -0400
Received: by ug-out-1314.google.com with SMTP id z38so778697ugc
        for <linux-scsi@vger.kernel.org>; Sun, 14 Oct 2007 08:01:16 -0700 (PDT)
In-Reply-To: <200710141600.10468.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--Boundary-00=_08iEHQZBvcGY4Du
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Adds statics, #ifdefs out huge amount of unused code, adds consts

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_08iEHQZBvcGY4Du
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-aic-2-addstatic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-aic-2-addstatic.patch"

diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx.h linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx.h
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx.h	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx.h	2007-10-14 15:05:07.000000000 +0100
@@ -1307,7 +1307,7 @@ typedef int (ahd_device_setup_t)(struct 
 struct ahd_pci_identity {
 	uint64_t		 full_id;
 	uint64_t		 id_mask;
-	char			*name;
+	const char		*name;
 	ahd_device_setup_t	*setup;
 };
 
@@ -1315,7 +1315,7 @@ struct ahd_pci_identity {
 struct aic7770_identity {
 	uint32_t		 full_id;
 	uint32_t		 id_mask;
-	char			*name;
+	const char		*name;
 	ahd_device_setup_t	*setup;
 };
 extern struct aic7770_identity aic7770_ident_table [];
@@ -1326,7 +1326,6 @@ extern const int ahd_num_aic7770_devs;
 
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
-void			ahd_reset_cmds_pending(struct ahd_softc *ahd);
 
 /***************************** PCI Front End *********************************/
 struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
@@ -1362,16 +1361,6 @@ int			 ahd_write_flexport(struct ahd_sof
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
@@ -1465,7 +1454,7 @@ extern uint32_t ahd_debug;
 void			ahd_print_devinfo(struct ahd_softc *ahd,
 					  struct ahd_devinfo *devinfo);
 void			ahd_dump_card_state(struct ahd_softc *ahd);
-int			ahd_print_register(ahd_reg_parse_entry_t *table,
+int			ahd_print_register(const ahd_reg_parse_entry_t *table,
 					   u_int num_entries,
 					   const char *name,
 					   u_int address,
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_core.c linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_core.c	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_core.c	2007-10-14 15:05:07.000000000 +0100
@@ -266,6 +266,18 @@ static int		ahd_match_scb(struct ahd_sof
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
@@ -285,7 +297,7 @@ ahd_set_modes(struct ahd_softc *ahd, ahd
 	ahd->dst_mode = dst;
 }
 
-void
+static void
 ahd_update_modes(struct ahd_softc *ahd)
 {
 	ahd_mode_state mode_ptr;
@@ -301,7 +313,7 @@ ahd_update_modes(struct ahd_softc *ahd)
 	ahd_known_modes(ahd, src, dst);
 }
 
-void
+static void
 ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 		 ahd_mode dstmode, const char *file, int line)
 {
@@ -422,7 +434,7 @@ ahd_sg_setup(struct ahd_softc *ahd, stru
 	}
 }
 
-void
+static void
 ahd_setup_scb_common(struct ahd_softc *ahd, struct scb *scb)
 {
 	/* XXX Handle target mode SCBs. */
@@ -443,7 +455,7 @@ ahd_setup_scb_common(struct ahd_softc *a
 		    ahd_htole32(scb->sense_busaddr);
 }
 
-void
+static void
 ahd_setup_data_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	/*
@@ -480,7 +492,7 @@ ahd_setup_data_scb(struct ahd_softc *ahd
 	scb->hscb->sgptr = ahd_htole32(scb->sg_list_busaddr|SG_FULL_RESID);
 }
 
-void
+static void
 ahd_setup_noxfer_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	scb->hscb->sgptr = ahd_htole32(SG_LIST_NULL);
@@ -489,7 +501,7 @@ ahd_setup_noxfer_scb(struct ahd_softc *a
 }
 
 /************************** Memory mapping routines ***************************/
-void *
+static void *
 ahd_sg_bus_to_virt(struct ahd_softc *ahd, struct scb *scb, uint32_t sg_busaddr)
 {
 	dma_addr_t sg_offset;
@@ -499,7 +511,7 @@ ahd_sg_bus_to_virt(struct ahd_softc *ahd
 	return ((uint8_t *)scb->sg_list + sg_offset);
 }
 
-uint32_t
+static uint32_t
 ahd_sg_virt_to_bus(struct ahd_softc *ahd, struct scb *scb, void *sg)
 {
 	dma_addr_t sg_offset;
@@ -511,7 +523,7 @@ ahd_sg_virt_to_bus(struct ahd_softc *ahd
 	return (scb->sg_list_busaddr + sg_offset);
 }
 
-void
+static void
 ahd_sync_scb(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.hscb_dmat,
@@ -532,7 +544,7 @@ ahd_sync_sglist(struct ahd_softc *ahd, s
 			/*len*/ahd_sg_size(ahd) * scb->sg_count, op);
 }
 
-void
+static void
 ahd_sync_sense(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.sense_dmat,
@@ -541,12 +553,14 @@ ahd_sync_sense(struct ahd_softc *ahd, st
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
@@ -653,31 +667,35 @@ ahd_set_scbptr(struct ahd_softc *ahd, u_
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
@@ -688,35 +706,39 @@ ahd_get_snscb_qoff(struct ahd_softc *ahd
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
@@ -756,14 +778,14 @@ ahd_inw_scbram(struct ahd_softc *ahd, u_
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
@@ -784,7 +806,7 @@ ahd_lookup_scb(struct ahd_softc *ahd, u_
 	return (scb);
 }
 
-void
+static void
 ahd_swap_with_next_hscb(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct	 hardware_scb *q_hscb;
@@ -869,7 +891,7 @@ ahd_queue_scb(struct ahd_softc *ahd, str
 }
 
 /************************** Interrupt Processing ******************************/
-void
+static void
 ahd_sync_qoutfifo(struct ahd_softc *ahd, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
@@ -877,7 +899,7 @@ ahd_sync_qoutfifo(struct ahd_softc *ahd,
 			/*len*/AHD_SCB_MAX * sizeof(struct ahd_completion), op);
 }
 
-void
+static void
 ahd_sync_tqinfifo(struct ahd_softc *ahd, int op)
 {
 #ifdef AHD_TARGET_MODE
@@ -897,7 +919,7 @@ ahd_sync_tqinfifo(struct ahd_softc *ahd,
  */
 #define AHD_RUN_QOUTFIFO 0x1
 #define AHD_RUN_TQINFIFO 0x2
-u_int
+static u_int
 ahd_check_cmdcmpltqueues(struct ahd_softc *ahd)
 {
 	u_int retval;
@@ -1640,7 +1662,7 @@ clrchn:
  * a copy of the first byte (little endian) of the sgptr
  * hscb field.
  */
-void
+static void
 ahd_run_qoutfifo(struct ahd_softc *ahd)
 {
 	struct ahd_completion *completion;
@@ -1679,7 +1701,7 @@ ahd_run_qoutfifo(struct ahd_softc *ahd)
 }
 
 /************************* Interrupt Handling *********************************/
-void
+static void
 ahd_handle_hwerrint(struct ahd_softc *ahd)
 {
 	/*
@@ -1753,7 +1775,7 @@ ahd_dump_sglist(struct scb *scb)
 }
 #endif  /*  AHD_DEBUG  */
 
-void
+static void
 ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 {
 	u_int seqintcode;
@@ -2365,7 +2387,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 	ahd_unpause(ahd);
 }
 
-void
+static void
 ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 {
 	struct scb	*scb;
@@ -8135,7 +8157,7 @@ ahd_qinfifo_count(struct ahd_softc *ahd)
 		      + ARRAY_SIZE(ahd->qinfifo) - wrap_qinpos);
 }
 
-void
+static void
 ahd_reset_cmds_pending(struct ahd_softc *ahd)
 {
 	struct		scb *scb;
@@ -9660,7 +9682,7 @@ sized:
 }
 
 int
-ahd_print_register(ahd_reg_parse_entry_t *table, u_int num_entries,
+ahd_print_register(const ahd_reg_parse_entry_t *table, u_int num_entries,
 		   const char *name, u_int address, u_int value,
 		   u_int *cur_column, u_int wrap_point)
 {
@@ -10651,7 +10673,7 @@ ahd_update_scsiid(struct ahd_softc *ahd,
 #endif
 }
 
-void
+static void
 ahd_run_tqinfifo(struct ahd_softc *ahd, int paused)
 {
 	struct target_cmd *cmd;
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_inline.h linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_inline.h
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_inline.h	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_inline.h	2007-10-14 15:05:07.000000000 +0100
@@ -66,10 +66,6 @@ static __inline void ahd_extract_mode_st
 
 void ahd_set_modes(struct ahd_softc *ahd, ahd_mode src,
 		   ahd_mode dst);
-void ahd_update_modes(struct ahd_softc *ahd);
-void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
-		      ahd_mode dstmode, const char *file,
-		      int line);
 ahd_mode_state ahd_save_modes(struct ahd_softc *ahd);
 void ahd_restore_modes(struct ahd_softc *ahd,
 		       ahd_mode_state state);
@@ -104,33 +100,12 @@ ahd_extract_mode_state(struct ahd_softc 
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
@@ -160,26 +135,10 @@ void	ahd_outq(struct ahd_softc *ahd, u_i
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
@@ -212,9 +171,6 @@ ahd_get_sense_bufaddr(struct ahd_softc *
 }
 
 /************************** Interrupt Processing ******************************/
-void	ahd_sync_qoutfifo(struct ahd_softc *ahd, int op);
-void	ahd_sync_tqinfifo(struct ahd_softc *ahd, int op);
-u_int	ahd_check_cmdcmpltqueues(struct ahd_softc *ahd);
 int	ahd_intr(struct ahd_softc *ahd);
 
 #endif  /* _AIC79XX_INLINE_H_ */
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_osm.c linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm.c
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_osm.c	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm.c	2007-10-14 15:05:07.000000000 +0100
@@ -388,7 +388,6 @@ ahd_delay(long usec)
 
 /***************************** Low Level I/O **********************************/
 uint8_t ahd_inb(struct ahd_softc * ahd, long port);
-uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
 void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
 void ahd_outw_atomic(struct ahd_softc * ahd,
 				     long port, uint16_t val);
@@ -411,7 +410,8 @@ ahd_inb(struct ahd_softc * ahd, long por
 	return (x);
 }
 
-uint16_t
+#if 0 /* unused */
+static uint16_t
 ahd_inw_atomic(struct ahd_softc * ahd, long port)
 {
 	uint8_t x;
@@ -424,6 +424,7 @@ ahd_inw_atomic(struct ahd_softc * ahd, l
 	mb();
 	return (x);
 }
+#endif
 
 void
 ahd_outb(struct ahd_softc * ahd, long port, uint8_t val)
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_osm.h linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm.h
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_osm.h	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm.h	2007-10-14 15:05:07.000000000 +0100
@@ -374,7 +374,6 @@ void ahd_delay(long);
 
 /***************************** Low Level I/O **********************************/
 uint8_t ahd_inb(struct ahd_softc * ahd, long port);
-uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
 void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
 void ahd_outw_atomic(struct ahd_softc * ahd,
 				     long port, uint16_t val);
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_pci.c linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_pci.c
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_pci.c	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_pci.c	2007-10-14 15:05:07.000000000 +0100
@@ -97,7 +97,7 @@ static ahd_device_setup_t ahd_aic7901A_s
 static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-static struct ahd_pci_identity ahd_pci_ident_table [] =
+static struct ahd_pci_identity ahd_pci_ident_table[] =
 {
 	/* aic7901 based controllers */
 	{
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped	2007-10-14 15:05:07.000000000 +0100
@@ -12,6 +12,8 @@ typedef struct ahd_reg_parse_entry {
 	uint8_t	 mask;
 } ahd_reg_parse_entry_t;
 
+#if 0 /* unused */
+
 #if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_mode_ptr_print;
 #else
@@ -20,13 +22,6 @@ ahd_reg_print_t ahd_mode_ptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_intstat_print;
-#else
-#define ahd_intstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "INTSTAT", 0x01, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqintcode_print;
 #else
 #define ahd_seqintcode_print(regvalue, cur_col, wrap) \
@@ -76,20 +71,6 @@ ahd_reg_print_t ahd_hescb_qoff_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hs_mailbox_print;
-#else
-#define ahd_hs_mailbox_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HS_MAILBOX", 0x0b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintstat_print;
-#else
-#define ahd_seqintstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTSTAT", 0x0c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_clrseqintstat_print;
 #else
 #define ahd_clrseqintstat_print(regvalue, cur_col, wrap) \
@@ -132,20 +113,6 @@ ahd_reg_print_t ahd_qoff_ctlsta_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_intctl_print;
-#else
-#define ahd_intctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "INTCTL", 0x18, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfcntrl_print;
-#else
-#define ahd_dfcntrl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFCNTRL", 0x19, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dscommand0_print;
 #else
 #define ahd_dscommand0_print(regvalue, cur_col, wrap) \
@@ -153,20 +120,6 @@ ahd_reg_print_t ahd_dscommand0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfstatus_print;
-#else
-#define ahd_dfstatus_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFSTATUS", 0x1a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sg_cache_shadow_print;
-#else
-#define ahd_sg_cache_shadow_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SG_CACHE_SHADOW", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_arbctl_print;
 #else
 #define ahd_arbctl_print(regvalue, cur_col, wrap) \
@@ -391,20 +344,6 @@ ahd_reg_print_t ahd_scsbist1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsiseq0_print;
-#else
-#define ahd_scsiseq0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISEQ0", 0x3a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsiseq1_print;
-#else
-#define ahd_scsiseq1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISEQ1", 0x3b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sxfrctl0_print;
 #else
 #define ahd_sxfrctl0_print(regvalue, cur_col, wrap) \
@@ -447,13 +386,6 @@ ahd_reg_print_t ahd_sxfrctl2_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dffstat_print;
-#else
-#define ahd_dffstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFFSTAT", 0x3f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsisigo_print;
 #else
 #define ahd_scsisigo_print(regvalue, cur_col, wrap) \
@@ -468,20 +400,6 @@ ahd_reg_print_t ahd_multargid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsisigi_print;
-#else
-#define ahd_scsisigi_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISIGI", 0x41, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsiphase_print;
-#else
-#define ahd_scsiphase_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIPHASE", 0x42, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsidat0_img_print;
 #else
 #define ahd_scsidat0_img_print(regvalue, cur_col, wrap) \
@@ -496,13 +414,6 @@ ahd_reg_print_t ahd_scsidat_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsibus_print;
-#else
-#define ahd_scsibus_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIBUS", 0x46, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_targidin_print;
 #else
 #define ahd_targidin_print(regvalue, cur_col, wrap) \
@@ -510,13 +421,6 @@ ahd_reg_print_t ahd_targidin_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_selid_print;
-#else
-#define ahd_selid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SELID", 0x49, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_optionmode_print;
 #else
 #define ahd_optionmode_print(regvalue, cur_col, wrap) \
@@ -538,20 +442,6 @@ ahd_reg_print_t ahd_clrsint0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat0_print;
-#else
-#define ahd_sstat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT0", 0x4b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode0_print;
-#else
-#define ahd_simode0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE0", 0x4b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_clrsint1_print;
 #else
 #define ahd_clrsint1_print(regvalue, cur_col, wrap) \
@@ -559,20 +449,6 @@ ahd_reg_print_t ahd_clrsint1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat1_print;
-#else
-#define ahd_sstat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT1", 0x4c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat2_print;
-#else
-#define ahd_sstat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_simode2_print;
 #else
 #define ahd_simode2_print(regvalue, cur_col, wrap) \
@@ -587,13 +463,6 @@ ahd_reg_print_t ahd_clrsint2_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_perrdiag_print;
-#else
-#define ahd_perrdiag_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PERRDIAG", 0x4e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqistate_print;
 #else
 #define ahd_lqistate_print(regvalue, cur_col, wrap) \
@@ -601,13 +470,6 @@ ahd_reg_print_t ahd_lqistate_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_soffcnt_print;
-#else
-#define ahd_soffcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SOFFCNT", 0x4f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqostate_print;
 #else
 #define ahd_lqostate_print(regvalue, cur_col, wrap) \
@@ -615,13 +477,6 @@ ahd_reg_print_t ahd_lqostate_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistat0_print;
-#else
-#define ahd_lqistat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTAT0", 0x50, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_clrlqiint0_print;
 #else
 #define ahd_clrlqiint0_print(regvalue, cur_col, wrap) \
@@ -643,13 +498,6 @@ ahd_reg_print_t ahd_lqimode1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistat1_print;
-#else
-#define ahd_lqistat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTAT1", 0x51, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_clrlqiint1_print;
 #else
 #define ahd_clrlqiint1_print(regvalue, cur_col, wrap) \
@@ -657,20 +505,6 @@ ahd_reg_print_t ahd_clrlqiint1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistat2_print;
-#else
-#define ahd_lqistat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTAT2", 0x52, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat3_print;
-#else
-#define ahd_sstat3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT3", 0x53, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_simode3_print;
 #else
 #define ahd_simode3_print(regvalue, cur_col, wrap) \
@@ -685,13 +519,6 @@ ahd_reg_print_t ahd_clrsint3_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostat0_print;
-#else
-#define ahd_lqostat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTAT0", 0x54, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_clrlqoint0_print;
 #else
 #define ahd_clrlqoint0_print(regvalue, cur_col, wrap) \
@@ -713,13 +540,6 @@ ahd_reg_print_t ahd_lqomode1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostat1_print;
-#else
-#define ahd_lqostat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTAT1", 0x55, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_clrlqoint1_print;
 #else
 #define ahd_clrlqoint1_print(regvalue, cur_col, wrap) \
@@ -727,13 +547,6 @@ ahd_reg_print_t ahd_clrlqoint1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostat2_print;
-#else
-#define ahd_lqostat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTAT2", 0x56, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_os_space_cnt_print;
 #else
 #define ahd_os_space_cnt_print(regvalue, cur_col, wrap) \
@@ -741,13 +554,6 @@ ahd_reg_print_t ahd_os_space_cnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode1_print;
-#else
-#define ahd_simode1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE1", 0x57, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_gsfifo_print;
 #else
 #define ahd_gsfifo_print(regvalue, cur_col, wrap) \
@@ -755,13 +561,6 @@ ahd_reg_print_t ahd_gsfifo_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dffsxfrctl_print;
-#else
-#define ahd_dffsxfrctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFFSXFRCTL", 0x5a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqoscsctl_print;
 #else
 #define ahd_lqoscsctl_print(regvalue, cur_col, wrap) \
@@ -783,13 +582,6 @@ ahd_reg_print_t ahd_clrseqintsrc_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintsrc_print;
-#else
-#define ahd_seqintsrc_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTSRC", 0x5b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_currscb_print;
 #else
 #define ahd_currscb_print(regvalue, cur_col, wrap) \
@@ -797,20 +589,6 @@ ahd_reg_print_t ahd_currscb_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqimode_print;
-#else
-#define ahd_seqimode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mdffstat_print;
-#else
-#define ahd_mdffstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_crccontrol_print;
 #else
 #define ahd_crccontrol_print(regvalue, cur_col, wrap) \
@@ -972,13 +750,6 @@ ahd_reg_print_t ahd_xsig_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seloid_print;
-#else
-#define ahd_seloid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SELOID", 0x6b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_pll400ctl0_print;
 #else
 #define ahd_pll400ctl0_print(regvalue, cur_col, wrap) \
@@ -1448,13 +1219,6 @@ ahd_reg_print_t ahd_reg_isr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sg_state_print;
-#else
-#define ahd_sg_state_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SG_STATE", 0xa6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_msipcistat_print;
 #else
 #define ahd_msipcistat_print(regvalue, cur_col, wrap) \
@@ -1525,20 +1289,6 @@ ahd_reg_print_t ahd_cmc_rambist_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbctl_print;
-#else
-#define ahd_ccscbctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBCTL", 0xad, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccsgctl_print;
-#else
-#define ahd_ccsgctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSGCTL", 0xad, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_ccsgram_print;
 #else
 #define ahd_ccsgram_print(regvalue, cur_col, wrap) \
@@ -1763,14 +1513,7 @@ ahd_reg_print_t ahd_ovlyaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqctl0_print;
-#else
-#define ahd_seqctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQCTL0", 0xd6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqctl1_print;
+ahd_reg_print_t ahd_seqctl1_print;
 #else
 #define ahd_seqctl1_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SEQCTL1", 0xd7, regvalue, cur_col, wrap)
@@ -1784,13 +1527,6 @@ ahd_reg_print_t ahd_flags_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintctl_print;
-#else
-#define ahd_seqintctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTCTL", 0xd9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqram_print;
 #else
 #define ahd_seqram_print(regvalue, cur_col, wrap) \
@@ -2008,27 +1744,6 @@ ahd_reg_print_t ahd_complete_on_qfreeze_
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_qfreeze_count_print;
-#else
-#define ahd_qfreeze_count_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "QFREEZE_COUNT", 0x132, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_kernel_qfreeze_count_print;
-#else
-#define ahd_kernel_qfreeze_count_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT", 0x134, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_saved_mode_print;
-#else
-#define ahd_saved_mode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SAVED_MODE", 0x136, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_msg_out_print;
 #else
 #define ahd_msg_out_print(regvalue, cur_col, wrap) \
@@ -2043,13 +1758,6 @@ ahd_reg_print_t ahd_dmaparams_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seq_flags_print;
-#else
-#define ahd_seq_flags_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQ_FLAGS", 0x139, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_saved_scsiid_print;
 #else
 #define ahd_saved_scsiid_print(regvalue, cur_col, wrap) \
@@ -2064,13 +1772,6 @@ ahd_reg_print_t ahd_saved_lun_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lastphase_print;
-#else
-#define ahd_lastphase_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LASTPHASE", 0x13c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_qoutfifo_entry_valid_tag_print;
 #else
 #define ahd_qoutfifo_entry_valid_tag_print(regvalue, cur_col, wrap) \
@@ -2141,13 +1842,6 @@ ahd_reg_print_t ahd_initiator_tag_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seq_flags2_print;
-#else
-#define ahd_seq_flags2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQ_FLAGS2", 0x14d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_allocfifo_scbptr_print;
 #else
 #define ahd_allocfifo_scbptr_print(regvalue, cur_col, wrap) \
@@ -2204,20 +1898,6 @@ ahd_reg_print_t ahd_cmdsize_table_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mk_message_scb_print;
-#else
-#define ahd_mk_message_scb_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MK_MESSAGE_SCB", 0x160, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mk_message_scsiid_print;
-#else
-#define ahd_mk_message_scsiid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID", 0x162, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_base_print;
 #else
 #define ahd_scb_base_print(regvalue, cur_col, wrap) \
@@ -2281,20 +1961,6 @@ ahd_reg_print_t ahd_scb_tag_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_control_print;
-#else
-#define ahd_scb_control_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_CONTROL", 0x192, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_scsiid_print;
-#else
-#define ahd_scb_scsiid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_SCSIID", 0x193, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_lun_print;
 #else
 #define ahd_scb_lun_print(regvalue, cur_col, wrap) \
@@ -2378,6 +2044,344 @@ ahd_reg_print_t ahd_scb_disconnected_lis
     ahd_print_register(NULL, 0, "SCB_DISCONNECTED_LISTS", 0x1b8, regvalue, cur_col, wrap)
 #endif
 
+#endif /* unused */
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_intstat_print;
+#else
+#define ahd_intstat_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "INTSTAT", 0x01, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_hs_mailbox_print;
+#else
+#define ahd_hs_mailbox_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "HS_MAILBOX", 0x0b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seqintstat_print;
+#else
+#define ahd_seqintstat_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQINTSTAT", 0x0c, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_intctl_print;
+#else
+#define ahd_intctl_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "INTCTL", 0x18, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_dfcntrl_print;
+#else
+#define ahd_dfcntrl_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "DFCNTRL", 0x19, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_dfstatus_print;
+#else
+#define ahd_dfstatus_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "DFSTATUS", 0x1a, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_sg_cache_shadow_print;
+#else
+#define ahd_sg_cache_shadow_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SG_CACHE_SHADOW", 0x1b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scsiseq0_print;
+#else
+#define ahd_scsiseq0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCSISEQ0", 0x3a, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scsiseq1_print;
+#else
+#define ahd_scsiseq1_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCSISEQ1", 0x3b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_dffstat_print;
+#else
+#define ahd_dffstat_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "DFFSTAT", 0x3f, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scsisigi_print;
+#else
+#define ahd_scsisigi_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCSISIGI", 0x41, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scsiphase_print;
+#else
+#define ahd_scsiphase_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCSIPHASE", 0x42, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scsibus_print;
+#else
+#define ahd_scsibus_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCSIBUS", 0x46, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_selid_print;
+#else
+#define ahd_selid_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SELID", 0x49, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_sstat0_print;
+#else
+#define ahd_sstat0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SSTAT0", 0x4b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_simode0_print;
+#else
+#define ahd_simode0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SIMODE0", 0x4b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_sstat1_print;
+#else
+#define ahd_sstat1_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SSTAT1", 0x4c, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_sstat2_print;
+#else
+#define ahd_sstat2_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_perrdiag_print;
+#else
+#define ahd_perrdiag_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "PERRDIAG", 0x4e, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_soffcnt_print;
+#else
+#define ahd_soffcnt_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SOFFCNT", 0x4f, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lqistat0_print;
+#else
+#define ahd_lqistat0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQISTAT0", 0x50, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lqistat1_print;
+#else
+#define ahd_lqistat1_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQISTAT1", 0x51, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lqistat2_print;
+#else
+#define ahd_lqistat2_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQISTAT2", 0x52, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_sstat3_print;
+#else
+#define ahd_sstat3_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SSTAT3", 0x53, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lqostat0_print;
+#else
+#define ahd_lqostat0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQOSTAT0", 0x54, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lqostat1_print;
+#else
+#define ahd_lqostat1_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQOSTAT1", 0x55, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lqostat2_print;
+#else
+#define ahd_lqostat2_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQOSTAT2", 0x56, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_simode1_print;
+#else
+#define ahd_simode1_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SIMODE1", 0x57, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_dffsxfrctl_print;
+#else
+#define ahd_dffsxfrctl_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "DFFSXFRCTL", 0x5a, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seqintsrc_print;
+#else
+#define ahd_seqintsrc_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQINTSRC", 0x5b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seqimode_print;
+#else
+#define ahd_seqimode_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_mdffstat_print;
+#else
+#define ahd_mdffstat_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seloid_print;
+#else
+#define ahd_seloid_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SELOID", 0x6b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_sg_state_print;
+#else
+#define ahd_sg_state_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SG_STATE", 0xa6, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_ccscbctl_print;
+#else
+#define ahd_ccscbctl_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CCSCBCTL", 0xad, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_ccsgctl_print;
+#else
+#define ahd_ccsgctl_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CCSGCTL", 0xad, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seqctl0_print;
+#else
+#define ahd_seqctl0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQCTL0", 0xd6, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seqintctl_print;
+#else
+#define ahd_seqintctl_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQINTCTL", 0xd9, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_qfreeze_count_print;
+#else
+#define ahd_qfreeze_count_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "QFREEZE_COUNT", 0x132, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_kernel_qfreeze_count_print;
+#else
+#define ahd_kernel_qfreeze_count_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT", 0x134, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_saved_mode_print;
+#else
+#define ahd_saved_mode_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SAVED_MODE", 0x136, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seq_flags_print;
+#else
+#define ahd_seq_flags_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQ_FLAGS", 0x139, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_lastphase_print;
+#else
+#define ahd_lastphase_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LASTPHASE", 0x13c, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_seq_flags2_print;
+#else
+#define ahd_seq_flags2_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQ_FLAGS2", 0x14d, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_mk_message_scb_print;
+#else
+#define ahd_mk_message_scb_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "MK_MESSAGE_SCB", 0x160, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_mk_message_scsiid_print;
+#else
+#define ahd_mk_message_scsiid_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID", 0x162, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scb_control_print;
+#else
+#define ahd_scb_control_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCB_CONTROL", 0x192, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahd_reg_print_t ahd_scb_scsiid_print;
+#else
+#define ahd_scb_scsiid_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCB_SCSIID", 0x193, regvalue, cur_col, wrap)
+#endif
+
 
 #define	MODE_PTR        		0x00
 #define		DST_MODE        	0x70
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped	2007-10-14 15:05:07.000000000 +0100
@@ -8,7 +8,9 @@
 
 #include "aic79xx_osm.h"
 
-static ahd_reg_parse_entry_t MODE_PTR_parse_table[] = {
+#if 0 /* unused */
+
+static const ahd_reg_parse_entry_t MODE_PTR_parse_table[] = {
 	{ "SRC_MODE",		0x07, 0x07 },
 	{ "DST_MODE",		0x70, 0x70 }
 };
@@ -20,26 +22,7 @@ ahd_mode_ptr_print(u_int regvalue, u_int
 	    0x00, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
-	{ "SPLTINT",		0x01, 0x01 },
-	{ "CMDCMPLT",		0x02, 0x02 },
-	{ "SEQINT",		0x04, 0x04 },
-	{ "SCSIINT",		0x08, 0x08 },
-	{ "PCIINT",		0x10, 0x10 },
-	{ "SWTMINT",		0x20, 0x20 },
-	{ "BRKADRINT",		0x40, 0x40 },
-	{ "HWERRINT",		0x80, 0x80 },
-	{ "INT_PEND",		0xff, 0xff }
-};
-
-int
-ahd_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(INTSTAT_parse_table, 9, "INTSTAT",
-	    0x01, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQINTCODE_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTCODE_parse_table[] = {
 	{ "NO_SEQINT",		0x00, 0xff },
 	{ "BAD_PHASE",		0x01, 0xff },
 	{ "SEND_REJECT",	0x02, 0xff },
@@ -76,7 +59,7 @@ ahd_seqintcode_print(u_int regvalue, u_i
 	    0x02, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRINT_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRINT_parse_table[] = {
 	{ "CLRSPLTINT",		0x01, 0x01 },
 	{ "CLRCMDINT",		0x02, 0x02 },
 	{ "CLRSEQINT",		0x04, 0x04 },
@@ -94,7 +77,7 @@ ahd_clrint_print(u_int regvalue, u_int *
 	    0x03, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ERROR_parse_table[] = {
+static const ahd_reg_parse_entry_t ERROR_parse_table[] = {
 	{ "DSCTMOUT",		0x02, 0x02 },
 	{ "ILLOPCODE",		0x04, 0x04 },
 	{ "SQPARERR",		0x08, 0x08 },
@@ -111,7 +94,7 @@ ahd_error_print(u_int regvalue, u_int *c
 	    0x04, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRERR_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRERR_parse_table[] = {
 	{ "CLRDSCTMOUT",	0x02, 0x02 },
 	{ "CLRILLOPCODE",	0x04, 0x04 },
 	{ "CLRSQPARERR",	0x08, 0x08 },
@@ -128,7 +111,7 @@ ahd_clrerr_print(u_int regvalue, u_int *
 	    0x04, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t HCNTRL_parse_table[] = {
+static const ahd_reg_parse_entry_t HCNTRL_parse_table[] = {
 	{ "CHIPRST",		0x01, 0x01 },
 	{ "CHIPRSTACK",		0x01, 0x01 },
 	{ "INTEN",		0x02, 0x02 },
@@ -160,34 +143,7 @@ ahd_hescb_qoff_print(u_int regvalue, u_i
 	    0x08, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
-	{ "ENINT_COALESCE",	0x40, 0x40 },
-	{ "HOST_TQINPOS",	0x80, 0x80 }
-};
-
-int
-ahd_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(HS_MAILBOX_parse_table, 2, "HS_MAILBOX",
-	    0x0b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
-	{ "SEQ_SPLTINT",	0x01, 0x01 },
-	{ "SEQ_PCIINT",		0x02, 0x02 },
-	{ "SEQ_SCSIINT",	0x04, 0x04 },
-	{ "SEQ_SEQINT",		0x08, 0x08 },
-	{ "SEQ_SWTMRTO",	0x10, 0x10 }
-};
-
-int
-ahd_seqintstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQINTSTAT_parse_table, 5, "SEQINTSTAT",
-	    0x0c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRSEQINTSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSEQINTSTAT_parse_table[] = {
 	{ "CLRSEQ_SPLTINT",	0x01, 0x01 },
 	{ "CLRSEQ_PCIINT",	0x02, 0x02 },
 	{ "CLRSEQ_SCSIINT",	0x04, 0x04 },
@@ -230,7 +186,7 @@ ahd_sdscb_qoff_print(u_int regvalue, u_i
 	    0x14, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
+static const ahd_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
 	{ "SCB_QSIZE_4",	0x00, 0x0f },
 	{ "SCB_QSIZE_8",	0x01, 0x0f },
 	{ "SCB_QSIZE_16",	0x02, 0x0f },
@@ -258,46 +214,7 @@ ahd_qoff_ctlsta_print(u_int regvalue, u_
 	    0x16, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t INTCTL_parse_table[] = {
-	{ "SPLTINTEN",		0x01, 0x01 },
-	{ "SEQINTEN",		0x02, 0x02 },
-	{ "SCSIINTEN",		0x04, 0x04 },
-	{ "PCIINTEN",		0x08, 0x08 },
-	{ "AUTOCLRCMDINT",	0x10, 0x10 },
-	{ "SWTIMER_START",	0x20, 0x20 },
-	{ "SWTMINTEN",		0x40, 0x40 },
-	{ "SWTMINTMASK",	0x80, 0x80 }
-};
-
-int
-ahd_intctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(INTCTL_parse_table, 8, "INTCTL",
-	    0x18, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
-	{ "DIRECTIONEN",	0x01, 0x01 },
-	{ "FIFOFLUSH",		0x02, 0x02 },
-	{ "FIFOFLUSHACK",	0x02, 0x02 },
-	{ "DIRECTION",		0x04, 0x04 },
-	{ "DIRECTIONACK",	0x04, 0x04 },
-	{ "HDMAEN",		0x08, 0x08 },
-	{ "HDMAENACK",		0x08, 0x08 },
-	{ "SCSIEN",		0x20, 0x20 },
-	{ "SCSIENACK",		0x20, 0x20 },
-	{ "SCSIENWRDIS",	0x40, 0x40 },
-	{ "PRELOADEN",		0x80, 0x80 }
-};
-
-int
-ahd_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DFCNTRL_parse_table, 11, "DFCNTRL",
-	    0x19, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
+static const ahd_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
 	{ "CIOPARCKEN",		0x01, 0x01 },
 	{ "DISABLE_TWATE",	0x02, 0x02 },
 	{ "EXTREQLCK",		0x10, 0x10 },
@@ -313,38 +230,7 @@ ahd_dscommand0_print(u_int regvalue, u_i
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
-	{ "FIFOEMP",		0x01, 0x01 },
-	{ "FIFOFULL",		0x02, 0x02 },
-	{ "DFTHRESH",		0x04, 0x04 },
-	{ "HDONE",		0x08, 0x08 },
-	{ "MREQPEND",		0x10, 0x10 },
-	{ "PKT_PRELOAD_AVAIL",	0x40, 0x40 },
-	{ "PRELOAD_AVAIL",	0x80, 0x80 }
-};
-
-int
-ahd_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DFSTATUS_parse_table, 7, "DFSTATUS",
-	    0x1a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
-	{ "LAST_SEG_DONE",	0x01, 0x01 },
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "ODD_SEG",		0x04, 0x04 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahd_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SG_CACHE_SHADOW_parse_table, 4, "SG_CACHE_SHADOW",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t ARBCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t ARBCTL_parse_table[] = {
 	{ "USE_TIME",		0x07, 0x07 },
 	{ "RETRY_SWEN",		0x08, 0x08 },
 	{ "RESET_HARB",		0x80, 0x80 }
@@ -357,7 +243,7 @@ ahd_arbctl_print(u_int regvalue, u_int *
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
+static const ahd_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "ODD_SEG",		0x04, 0x04 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -489,7 +375,7 @@ ahd_shortthresh_print(u_int regvalue, u_
 	    0x2f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LUNLEN_parse_table[] = {
+static const ahd_reg_parse_entry_t LUNLEN_parse_table[] = {
 	{ "ILUNLEN",		0x0f, 0x0f },
 	{ "TLUNLEN",		0xf0, 0xf0 }
 };
@@ -550,7 +436,7 @@ ahd_cmdrsvd0_print(u_int regvalue, u_int
 	    0x37, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQCTL0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQCTL0_parse_table[] = {
 	{ "LQ0INITGCLT",	0x03, 0x03 },
 	{ "LQ0TARGCLT",		0x0c, 0x0c },
 	{ "LQIINITGCLT",	0x30, 0x30 },
@@ -564,7 +450,7 @@ ahd_lqctl0_print(u_int regvalue, u_int *
 	    0x38, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQCTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQCTL1_parse_table[] = {
 	{ "ABORTPENDING",	0x01, 0x01 },
 	{ "SINGLECMD",		0x02, 0x02 },
 	{ "PCI2PCI",		0x04, 0x04 }
@@ -577,7 +463,7 @@ ahd_lqctl1_print(u_int regvalue, u_int *
 	    0x38, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSBIST0_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSBIST0_parse_table[] = {
 	{ "OSBISTRUN",		0x01, 0x01 },
 	{ "OSBISTDONE",		0x02, 0x02 },
 	{ "OSBISTERR",		0x04, 0x04 },
@@ -593,7 +479,7 @@ ahd_scsbist0_print(u_int regvalue, u_int
 	    0x39, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQCTL2_parse_table[] = {
+static const ahd_reg_parse_entry_t LQCTL2_parse_table[] = {
 	{ "LQOPAUSE",		0x01, 0x01 },
 	{ "LQOTOIDLE",		0x02, 0x02 },
 	{ "LQOCONTINUE",	0x04, 0x04 },
@@ -611,7 +497,7 @@ ahd_lqctl2_print(u_int regvalue, u_int *
 	    0x39, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSBIST1_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSBIST1_parse_table[] = {
 	{ "NTBISTRUN",		0x01, 0x01 },
 	{ "NTBISTDONE",		0x02, 0x02 },
 	{ "NTBISTERR",		0x04, 0x04 }
@@ -624,38 +510,7 @@ ahd_scsbist1_print(u_int regvalue, u_int
 	    0x3a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
-	{ "SCSIRSTO",		0x01, 0x01 },
-	{ "FORCEBUSFREE",	0x10, 0x10 },
-	{ "ENARBO",		0x20, 0x20 },
-	{ "ENSELO",		0x40, 0x40 },
-	{ "TEMODEO",		0x80, 0x80 }
-};
-
-int
-ahd_scsiseq0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSISEQ0_parse_table, 5, "SCSISEQ0",
-	    0x3a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
-	{ "ALTSTIM",		0x01, 0x01 },
-	{ "ENAUTOATNP",		0x02, 0x02 },
-	{ "MANUALP",		0x0c, 0x0c },
-	{ "ENRSELI",		0x10, 0x10 },
-	{ "ENSELI",		0x20, 0x20 },
-	{ "MANUALCTL",		0x40, 0x40 }
-};
-
-int
-ahd_scsiseq1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSISEQ1_parse_table, 6, "SCSISEQ1",
-	    0x3b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SXFRCTL0_parse_table[] = {
+static const ahd_reg_parse_entry_t SXFRCTL0_parse_table[] = {
 	{ "SPIOEN",		0x08, 0x08 },
 	{ "BIOSCANCELEN",	0x10, 0x10 },
 	{ "DFPEXP",		0x40, 0x40 },
@@ -683,7 +538,7 @@ ahd_businitid_print(u_int regvalue, u_in
 	    0x3c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SXFRCTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t SXFRCTL1_parse_table[] = {
 	{ "STPWEN",		0x01, 0x01 },
 	{ "ACTNEGEN",		0x02, 0x02 },
 	{ "ENSTIMER",		0x04, 0x04 },
@@ -707,7 +562,7 @@ ahd_bustargid_print(u_int regvalue, u_in
 	    0x3e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SXFRCTL2_parse_table[] = {
+static const ahd_reg_parse_entry_t SXFRCTL2_parse_table[] = {
 	{ "ASU",		0x07, 0x07 },
 	{ "CMDDMAEN",		0x08, 0x08 },
 	{ "AUTORSTDIS",		0x10, 0x10 }
@@ -720,23 +575,7 @@ ahd_sxfrctl2_print(u_int regvalue, u_int
 	    0x3e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
-	{ "CURRFIFO_0",		0x00, 0x03 },
-	{ "CURRFIFO_1",		0x01, 0x03 },
-	{ "CURRFIFO_NONE",	0x03, 0x03 },
-	{ "FIFO0FREE",		0x10, 0x10 },
-	{ "FIFO1FREE",		0x20, 0x20 },
-	{ "CURRFIFO",		0x03, 0x03 }
-};
-
-int
-ahd_dffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DFFSTAT_parse_table, 6, "DFFSTAT",
-	    0x3f, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSISIGO_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISIGO_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
@@ -770,50 +609,6 @@ ahd_multargid_print(u_int regvalue, u_in
 	    0x40, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
-	{ "P_DATAOUT",		0x00, 0xe0 },
-	{ "P_DATAOUT_DT",	0x20, 0xe0 },
-	{ "P_DATAIN",		0x40, 0xe0 },
-	{ "P_DATAIN_DT",	0x60, 0xe0 },
-	{ "P_COMMAND",		0x80, 0xe0 },
-	{ "P_MESGOUT",		0xa0, 0xe0 },
-	{ "P_STATUS",		0xc0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 },
-	{ "ACKI",		0x01, 0x01 },
-	{ "REQI",		0x02, 0x02 },
-	{ "BSYI",		0x04, 0x04 },
-	{ "SELI",		0x08, 0x08 },
-	{ "ATNI",		0x10, 0x10 },
-	{ "MSGI",		0x20, 0x20 },
-	{ "IOI",		0x40, 0x40 },
-	{ "CDI",		0x80, 0x80 },
-	{ "PHASE_MASK",		0xe0, 0xe0 }
-};
-
-int
-ahd_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
-	    0x41, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
-	{ "DATA_OUT_PHASE",	0x01, 0x03 },
-	{ "DATA_IN_PHASE",	0x02, 0x03 },
-	{ "DATA_PHASE_MASK",	0x03, 0x03 },
-	{ "MSG_OUT_PHASE",	0x04, 0x04 },
-	{ "MSG_IN_PHASE",	0x08, 0x08 },
-	{ "COMMAND_PHASE",	0x10, 0x10 },
-	{ "STATUS_PHASE",	0x20, 0x20 }
-};
-
-int
-ahd_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
-	    0x42, regvalue, cur_col, wrap));
-}
-
 int
 ahd_scsidat0_img_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -828,38 +623,7 @@ ahd_scsidat_print(u_int regvalue, u_int 
 	    0x44, regvalue, cur_col, wrap));
 }
 
-int
-ahd_scsibus_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCSIBUS",
-	    0x46, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t TARGIDIN_parse_table[] = {
-	{ "TARGID",		0x0f, 0x0f },
-	{ "CLKOUT",		0x80, 0x80 }
-};
-
-int
-ahd_targidin_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(TARGIDIN_parse_table, 2, "TARGIDIN",
-	    0x48, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SELID_parse_table[] = {
-	{ "ONEBIT",		0x08, 0x08 },
-	{ "SELID_MASK",		0xf0, 0xf0 }
-};
-
-int
-ahd_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SELID_parse_table, 2, "SELID",
-	    0x49, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OPTIONMODE_parse_table[] = {
+static const ahd_reg_parse_entry_t OPTIONMODE_parse_table[] = {
 	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
 	{ "ENDGFORMCHK",	0x04, 0x04 },
 	{ "BUSFREEREV",		0x10, 0x10 },
@@ -876,7 +640,7 @@ ahd_optionmode_print(u_int regvalue, u_i
 	    0x4a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SBLKCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "SELWIDE",		0x02, 0x02 },
 	{ "ENAB20",		0x04, 0x04 },
 	{ "ENAB40",		0x08, 0x08 },
@@ -891,7 +655,7 @@ ahd_sblkctl_print(u_int regvalue, u_int 
 	    0x4a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSINT0_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSINT0_parse_table[] = {
 	{ "CLRARBDO",		0x01, 0x01 },
 	{ "CLRSPIORDY",		0x02, 0x02 },
 	{ "CLROVERRUN",		0x04, 0x04 },
@@ -908,110 +672,32 @@ ahd_clrsint0_print(u_int regvalue, u_int
 	    0x4b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
-	{ "ARBDO",		0x01, 0x01 },
-	{ "SPIORDY",		0x02, 0x02 },
-	{ "OVERRUN",		0x04, 0x04 },
-	{ "IOERR",		0x08, 0x08 },
-	{ "SELINGO",		0x10, 0x10 },
-	{ "SELDI",		0x20, 0x20 },
-	{ "SELDO",		0x40, 0x40 },
-	{ "TARGET",		0x80, 0x80 }
+static const ahd_reg_parse_entry_t TARGIDIN_parse_table[] = {
+	{ "TARGID",		0x0f, 0x0f },
+	{ "CLKOUT",		0x80, 0x80 }
 };
 
 int
-ahd_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_targidin_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(SSTAT0_parse_table, 8, "SSTAT0",
-	    0x4b, regvalue, cur_col, wrap));
+	return (ahd_print_register(TARGIDIN_parse_table, 2, "TARGIDIN",
+	    0x48, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
-	{ "ENARBDO",		0x01, 0x01 },
-	{ "ENSPIORDY",		0x02, 0x02 },
-	{ "ENOVERRUN",		0x04, 0x04 },
-	{ "ENIOERR",		0x08, 0x08 },
-	{ "ENSELINGO",		0x10, 0x10 },
-	{ "ENSELDI",		0x20, 0x20 },
-	{ "ENSELDO",		0x40, 0x40 }
+static const ahd_reg_parse_entry_t SIMODE2_parse_table[] = {
+	{ "ENDMADONE",		0x01, 0x01 },
+	{ "ENSDONE",		0x02, 0x02 },
+	{ "ENWIDE_RES",		0x04, 0x04 }
 };
 
 int
-ahd_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SIMODE0_parse_table, 7, "SIMODE0",
-	    0x4b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRSINT1_parse_table[] = {
-	{ "CLRREQINIT",		0x01, 0x01 },
-	{ "CLRSTRB2FAST",	0x02, 0x02 },
-	{ "CLRSCSIPERR",	0x04, 0x04 },
-	{ "CLRBUSFREE",		0x08, 0x08 },
-	{ "CLRSCSIRSTI",	0x20, 0x20 },
-	{ "CLRATNO",		0x40, 0x40 },
-	{ "CLRSELTIMEO",	0x80, 0x80 }
-};
-
-int
-ahd_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
-	    0x4c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
-	{ "REQINIT",		0x01, 0x01 },
-	{ "STRB2FAST",		0x02, 0x02 },
-	{ "SCSIPERR",		0x04, 0x04 },
-	{ "BUSFREE",		0x08, 0x08 },
-	{ "PHASEMIS",		0x10, 0x10 },
-	{ "SCSIRSTI",		0x20, 0x20 },
-	{ "ATNTARG",		0x40, 0x40 },
-	{ "SELTO",		0x80, 0x80 }
-};
-
-int
-ahd_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SSTAT1_parse_table, 8, "SSTAT1",
-	    0x4c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
-	{ "BUSFREE_LQO",	0x40, 0xc0 },
-	{ "BUSFREE_DFF0",	0x80, 0xc0 },
-	{ "BUSFREE_DFF1",	0xc0, 0xc0 },
-	{ "DMADONE",		0x01, 0x01 },
-	{ "SDONE",		0x02, 0x02 },
-	{ "WIDE_RES",		0x04, 0x04 },
-	{ "BSYX",		0x08, 0x08 },
-	{ "EXP_ACTIVE",		0x10, 0x10 },
-	{ "NONPACKREQ",		0x20, 0x20 },
-	{ "BUSFREETIME",	0xc0, 0xc0 }
-};
-
-int
-ahd_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SSTAT2_parse_table, 10, "SSTAT2",
-	    0x4d, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SIMODE2_parse_table[] = {
-	{ "ENDMADONE",		0x01, 0x01 },
-	{ "ENSDONE",		0x02, 0x02 },
-	{ "ENWIDE_RES",		0x04, 0x04 }
-};
-
-int
-ahd_simode2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_simode2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(SIMODE2_parse_table, 3, "SIMODE2",
 	    0x4d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSINT2_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSINT2_parse_table[] = {
 	{ "CLRDMADONE",		0x01, 0x01 },
 	{ "CLRSDONE",		0x02, 0x02 },
 	{ "CLRWIDE_RES",	0x04, 0x04 },
@@ -1025,24 +711,6 @@ ahd_clrsint2_print(u_int regvalue, u_int
 	    0x4d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
-	{ "DTERR",		0x01, 0x01 },
-	{ "DGFORMERR",		0x02, 0x02 },
-	{ "CRCERR",		0x04, 0x04 },
-	{ "AIPERR",		0x08, 0x08 },
-	{ "PARITYERR",		0x10, 0x10 },
-	{ "PREVPHASE",		0x20, 0x20 },
-	{ "HIPERR",		0x40, 0x40 },
-	{ "HIZERO",		0x80, 0x80 }
-};
-
-int
-ahd_perrdiag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PERRDIAG_parse_table, 8, "PERRDIAG",
-	    0x4e, regvalue, cur_col, wrap));
-}
-
 int
 ahd_lqistate_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1051,36 +719,13 @@ ahd_lqistate_print(u_int regvalue, u_int
 }
 
 int
-ahd_soffcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SOFFCNT",
-	    0x4f, regvalue, cur_col, wrap));
-}
-
-int
 ahd_lqostate_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "LQOSTATE",
 	    0x4f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
-	{ "LQIATNCMD",		0x01, 0x01 },
-	{ "LQIATNLQ",		0x02, 0x02 },
-	{ "LQIBADLQT",		0x04, 0x04 },
-	{ "LQICRCT2",		0x08, 0x08 },
-	{ "LQICRCT1",		0x10, 0x10 },
-	{ "LQIATNQAS",		0x20, 0x20 }
-};
-
-int
-ahd_lqistat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQISTAT0_parse_table, 6, "LQISTAT0",
-	    0x50, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRLQIINT0_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQIINT0_parse_table[] = {
 	{ "CLRLQIATNCMD",	0x01, 0x01 },
 	{ "CLRLQIATNLQ",	0x02, 0x02 },
 	{ "CLRLQIBADLQT",	0x04, 0x04 },
@@ -1096,7 +741,7 @@ ahd_clrlqiint0_print(u_int regvalue, u_i
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQIMODE0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQIMODE0_parse_table[] = {
 	{ "ENLQIATNCMD",	0x01, 0x01 },
 	{ "ENLQIATNLQ",		0x02, 0x02 },
 	{ "ENLQIBADLQT",	0x04, 0x04 },
@@ -1112,7 +757,7 @@ ahd_lqimode0_print(u_int regvalue, u_int
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQIMODE1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQIMODE1_parse_table[] = {
 	{ "ENLQIOVERI_NLQ",	0x01, 0x01 },
 	{ "ENLQIOVERI_LQ",	0x02, 0x02 },
 	{ "ENLQIBADLQI",	0x04, 0x04 },
@@ -1130,25 +775,7 @@ ahd_lqimode1_print(u_int regvalue, u_int
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
-	{ "LQIOVERI_NLQ",	0x01, 0x01 },
-	{ "LQIOVERI_LQ",	0x02, 0x02 },
-	{ "LQIBADLQI",		0x04, 0x04 },
-	{ "LQICRCI_NLQ",	0x08, 0x08 },
-	{ "LQICRCI_LQ",		0x10, 0x10 },
-	{ "LQIABORT",		0x20, 0x20 },
-	{ "LQIPHASE_NLQ",	0x40, 0x40 },
-	{ "LQIPHASE_LQ",	0x80, 0x80 }
-};
-
-int
-ahd_lqistat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQISTAT1_parse_table, 8, "LQISTAT1",
-	    0x51, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRLQIINT1_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQIINT1_parse_table[] = {
 	{ "CLRLQIOVERI_NLQ",	0x01, 0x01 },
 	{ "CLRLQIOVERI_LQ",	0x02, 0x02 },
 	{ "CLRLQIBADLQI",	0x04, 0x04 },
@@ -1166,37 +793,7 @@ ahd_clrlqiint1_print(u_int regvalue, u_i
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
-	{ "LQIGSAVAIL",		0x01, 0x01 },
-	{ "LQISTOPCMD",		0x02, 0x02 },
-	{ "LQISTOPLQ",		0x04, 0x04 },
-	{ "LQISTOPPKT",		0x08, 0x08 },
-	{ "LQIWAITFIFO",	0x10, 0x10 },
-	{ "LQIWORKONLQ",	0x20, 0x20 },
-	{ "LQIPHASE_OUTPKT",	0x40, 0x40 },
-	{ "PACKETIZED",		0x80, 0x80 }
-};
-
-int
-ahd_lqistat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQISTAT2_parse_table, 8, "LQISTAT2",
-	    0x52, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
-	{ "OSRAMPERR",		0x01, 0x01 },
-	{ "NTRAMPERR",		0x02, 0x02 }
-};
-
-int
-ahd_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SSTAT3_parse_table, 2, "SSTAT3",
-	    0x53, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SIMODE3_parse_table[] = {
+static const ahd_reg_parse_entry_t SIMODE3_parse_table[] = {
 	{ "ENOSRAMPERR",	0x01, 0x01 },
 	{ "ENNTRAMPERR",	0x02, 0x02 }
 };
@@ -1208,7 +805,7 @@ ahd_simode3_print(u_int regvalue, u_int 
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSINT3_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSINT3_parse_table[] = {
 	{ "CLROSRAMPERR",	0x01, 0x01 },
 	{ "CLRNTRAMPERR",	0x02, 0x02 }
 };
@@ -1220,22 +817,7 @@ ahd_clrsint3_print(u_int regvalue, u_int
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
-	{ "LQOTCRC",		0x01, 0x01 },
-	{ "LQOATNPKT",		0x02, 0x02 },
-	{ "LQOATNLQ",		0x04, 0x04 },
-	{ "LQOSTOPT2",		0x08, 0x08 },
-	{ "LQOTARGSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_lqostat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOSTAT0_parse_table, 5, "LQOSTAT0",
-	    0x54, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRLQOINT0_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQOINT0_parse_table[] = {
 	{ "CLRLQOTCRC",		0x01, 0x01 },
 	{ "CLRLQOATNPKT",	0x02, 0x02 },
 	{ "CLRLQOATNLQ",	0x04, 0x04 },
@@ -1250,7 +832,7 @@ ahd_clrlqoint0_print(u_int regvalue, u_i
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOMODE0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOMODE0_parse_table[] = {
 	{ "ENLQOTCRC",		0x01, 0x01 },
 	{ "ENLQOATNPKT",	0x02, 0x02 },
 	{ "ENLQOATNLQ",		0x04, 0x04 },
@@ -1265,7 +847,7 @@ ahd_lqomode0_print(u_int regvalue, u_int
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOMODE1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOMODE1_parse_table[] = {
 	{ "ENLQOPHACHGINPKT",	0x01, 0x01 },
 	{ "ENLQOBUSFREE",	0x02, 0x02 },
 	{ "ENLQOBADQAS",	0x04, 0x04 },
@@ -1280,22 +862,7 @@ ahd_lqomode1_print(u_int regvalue, u_int
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
-	{ "LQOPHACHGINPKT",	0x01, 0x01 },
-	{ "LQOBUSFREE",		0x02, 0x02 },
-	{ "LQOBADQAS",		0x04, 0x04 },
-	{ "LQOSTOPI2",		0x08, 0x08 },
-	{ "LQOINITSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_lqostat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOSTAT1_parse_table, 5, "LQOSTAT1",
-	    0x55, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRLQOINT1_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQOINT1_parse_table[] = {
 	{ "CLRLQOPHACHGINPKT",	0x01, 0x01 },
 	{ "CLRLQOBUSFREE",	0x02, 0x02 },
 	{ "CLRLQOBADQAS",	0x04, 0x04 },
@@ -1310,20 +877,6 @@ ahd_clrlqoint1_print(u_int regvalue, u_i
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
-	{ "LQOSTOP0",		0x01, 0x01 },
-	{ "LQOPHACHGOUTPKT",	0x02, 0x02 },
-	{ "LQOWAITFIFO",	0x10, 0x10 },
-	{ "LQOPKT",		0xe0, 0xe0 }
-};
-
-int
-ahd_lqostat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOSTAT2_parse_table, 4, "LQOSTAT2",
-	    0x56, regvalue, cur_col, wrap));
-}
-
 int
 ahd_os_space_cnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1331,24 +884,6 @@ ahd_os_space_cnt_print(u_int regvalue, u
 	    0x56, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
-	{ "ENREQINIT",		0x01, 0x01 },
-	{ "ENSTRB2FAST",	0x02, 0x02 },
-	{ "ENSCSIPERR",		0x04, 0x04 },
-	{ "ENBUSFREE",		0x08, 0x08 },
-	{ "ENPHASEMIS",		0x10, 0x10 },
-	{ "ENSCSIRST",		0x20, 0x20 },
-	{ "ENATNTARG",		0x40, 0x40 },
-	{ "ENSELTIMO",		0x80, 0x80 }
-};
-
-int
-ahd_simode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SIMODE1_parse_table, 8, "SIMODE1",
-	    0x57, regvalue, cur_col, wrap));
-}
-
 int
 ahd_gsfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1356,21 +891,7 @@ ahd_gsfifo_print(u_int regvalue, u_int *
 	    0x58, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
-	{ "RSTCHN",		0x01, 0x01 },
-	{ "CLRCHN",		0x02, 0x02 },
-	{ "CLRSHCNT",		0x04, 0x04 },
-	{ "DFFBITBUCKET",	0x08, 0x08 }
-};
-
-int
-ahd_dffsxfrctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DFFSXFRCTL_parse_table, 4, "DFFSXFRCTL",
-	    0x5a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQOSCSCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSCSCTL_parse_table[] = {
 	{ "LQONOCHKOVER",	0x01, 0x01 },
 	{ "LQOH2A_VERSION",	0x80, 0x80 }
 };
@@ -1389,7 +910,7 @@ ahd_nextscb_print(u_int regvalue, u_int 
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSEQINTSRC_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSEQINTSRC_parse_table[] = {
 	{ "CLRCFG4TCMD",	0x01, 0x01 },
 	{ "CLRCFG4ICMD",	0x02, 0x02 },
 	{ "CLRCFG4TSTAT",	0x04, 0x04 },
@@ -1406,23 +927,6 @@ ahd_clrseqintsrc_print(u_int regvalue, u
 	    0x5b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
-	{ "CFG4TCMD",		0x01, 0x01 },
-	{ "CFG4ICMD",		0x02, 0x02 },
-	{ "CFG4TSTAT",		0x04, 0x04 },
-	{ "CFG4ISTAT",		0x08, 0x08 },
-	{ "CFG4DATA",		0x10, 0x10 },
-	{ "SAVEPTRS",		0x20, 0x20 },
-	{ "CTXTDONE",		0x40, 0x40 }
-};
-
-int
-ahd_seqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQINTSRC_parse_table, 7, "SEQINTSRC",
-	    0x5b, regvalue, cur_col, wrap));
-}
-
 int
 ahd_currscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1430,49 +934,15 @@ ahd_currscb_print(u_int regvalue, u_int 
 	    0x5c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQIMODE_parse_table[] = {
-	{ "ENCFG4TCMD",		0x01, 0x01 },
-	{ "ENCFG4ICMD",		0x02, 0x02 },
-	{ "ENCFG4TSTAT",	0x04, 0x04 },
-	{ "ENCFG4ISTAT",	0x08, 0x08 },
-	{ "ENCFG4DATA",		0x10, 0x10 },
-	{ "ENSAVEPTRS",		0x20, 0x20 },
-	{ "ENCTXTDONE",		0x40, 0x40 }
+static const ahd_reg_parse_entry_t CRCCONTROL_parse_table[] = {
+	{ "CRCVALCHKEN",	0x40, 0x40 }
 };
 
 int
-ahd_seqimode_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_crccontrol_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(SEQIMODE_parse_table, 7, "SEQIMODE",
-	    0x5c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
-	{ "FIFOFREE",		0x01, 0x01 },
-	{ "DATAINFIFO",		0x02, 0x02 },
-	{ "DLZERO",		0x04, 0x04 },
-	{ "SHVALID",		0x08, 0x08 },
-	{ "LASTSDONE",		0x10, 0x10 },
-	{ "SHCNTMINUS1",	0x20, 0x20 },
-	{ "SHCNTNEGATIVE",	0x40, 0x40 }
-};
-
-int
-ahd_mdffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(MDFFSTAT_parse_table, 7, "MDFFSTAT",
-	    0x5d, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CRCCONTROL_parse_table[] = {
-	{ "CRCVALCHKEN",	0x40, 0x40 }
-};
-
-int
-ahd_crccontrol_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CRCCONTROL_parse_table, 1, "CRCCONTROL",
-	    0x5d, regvalue, cur_col, wrap));
+	return (ahd_print_register(CRCCONTROL_parse_table, 1, "CRCCONTROL",
+	    0x5d, regvalue, cur_col, wrap));
 }
 
 int
@@ -1489,7 +959,7 @@ ahd_lastscb_print(u_int regvalue, u_int 
 	    0x5e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSITEST_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSITEST_parse_table[] = {
 	{ "SEL_TXPLL_DEBUG",	0x04, 0x04 },
 	{ "CNTRTEST",		0x08, 0x08 }
 };
@@ -1501,7 +971,7 @@ ahd_scsitest_print(u_int regvalue, u_int
 	    0x5e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t IOPDNCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t IOPDNCTL_parse_table[] = {
 	{ "PDN_DIFFSENSE",	0x01, 0x01 },
 	{ "PDN_IDIST",		0x04, 0x04 },
 	{ "DISABLE_OE",		0x80, 0x80 }
@@ -1556,7 +1026,7 @@ ahd_negoffset_print(u_int regvalue, u_in
 	    0x62, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t NEGPPROPTS_parse_table[] = {
+static const ahd_reg_parse_entry_t NEGPPROPTS_parse_table[] = {
 	{ "PPROPT_IUT",		0x01, 0x01 },
 	{ "PPROPT_DT",		0x02, 0x02 },
 	{ "PPROPT_QAS",		0x04, 0x04 },
@@ -1570,7 +1040,7 @@ ahd_negppropts_print(u_int regvalue, u_i
 	    0x63, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t NEGCONOPTS_parse_table[] = {
+static const ahd_reg_parse_entry_t NEGCONOPTS_parse_table[] = {
 	{ "WIDEXFER",		0x01, 0x01 },
 	{ "ENAUTOATNO",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
@@ -1601,7 +1071,7 @@ ahd_annexdat_print(u_int regvalue, u_int
 	    0x66, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSCHKN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSCHKN_parse_table[] = {
 	{ "LSTSGCLRDIS",	0x01, 0x01 },
 	{ "SHVALIDSTDIS",	0x02, 0x02 },
 	{ "DFFACTCLR",		0x04, 0x04 },
@@ -1625,7 +1095,7 @@ ahd_iownid_print(u_int regvalue, u_int *
 	    0x67, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLL960CTL0_parse_table[] = {
+static const ahd_reg_parse_entry_t PLL960CTL0_parse_table[] = {
 	{ "PLL_ENFBM",		0x01, 0x01 },
 	{ "PLL_DLPF",		0x02, 0x02 },
 	{ "PLL_ENLPF",		0x04, 0x04 },
@@ -1656,7 +1126,7 @@ ahd_townid_print(u_int regvalue, u_int *
 	    0x69, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLL960CTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t PLL960CTL1_parse_table[] = {
 	{ "PLL_RST",		0x01, 0x01 },
 	{ "PLL_CNTCLR",		0x40, 0x40 },
 	{ "PLL_CNTEN",		0x80, 0x80 }
@@ -1683,14 +1153,7 @@ ahd_xsig_print(u_int regvalue, u_int *cu
 	    0x6a, regvalue, cur_col, wrap));
 }
 
-int
-ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SELOID",
-	    0x6b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t PLL400CTL0_parse_table[] = {
+static const ahd_reg_parse_entry_t PLL400CTL0_parse_table[] = {
 	{ "PLL_ENFBM",		0x01, 0x01 },
 	{ "PLL_DLPF",		0x02, 0x02 },
 	{ "PLL_ENLPF",		0x04, 0x04 },
@@ -1714,7 +1177,7 @@ ahd_fairness_print(u_int regvalue, u_int
 	    0x6c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLL400CTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t PLL400CTL1_parse_table[] = {
 	{ "PLL_RST",		0x01, 0x01 },
 	{ "PLL_CNTCLR",		0x40, 0x40 },
 	{ "PLL_CNTEN",		0x80, 0x80 }
@@ -1748,7 +1211,7 @@ ahd_haddr_print(u_int regvalue, u_int *c
 	    0x70, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLLDELAY_parse_table[] = {
+static const ahd_reg_parse_entry_t PLLDELAY_parse_table[] = {
 	{ "SPLIT_DROP_REQ",	0x80, 0x80 }
 };
 
@@ -1815,7 +1278,7 @@ ahd_sghcnt_print(u_int regvalue, u_int *
 	    0x84, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFF_THRSH_parse_table[] = {
+static const ahd_reg_parse_entry_t DFF_THRSH_parse_table[] = {
 	{ "WR_DFTHRSH_MIN",	0x00, 0x70 },
 	{ "RD_DFTHRSH_MIN",	0x00, 0x07 },
 	{ "RD_DFTHRSH_25",	0x01, 0x07 },
@@ -1850,7 +1313,7 @@ ahd_romaddr_print(u_int regvalue, u_int 
 	    0x8a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ROMCNTRL_parse_table[] = {
+static const ahd_reg_parse_entry_t ROMCNTRL_parse_table[] = {
 	{ "RDY",		0x01, 0x01 },
 	{ "REPEAT",		0x02, 0x02 },
 	{ "ROMSPD",		0x18, 0x18 },
@@ -1871,7 +1334,7 @@ ahd_romdata_print(u_int regvalue, u_int 
 	    0x8e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCRXMSG0_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCRXMSG0_parse_table[] = {
 	{ "CFNUM",		0x07, 0x07 },
 	{ "CDNUM",		0xf8, 0xf8 }
 };
@@ -1883,7 +1346,7 @@ ahd_cmcrxmsg0_print(u_int regvalue, u_in
 	    0x90, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ROENABLE_parse_table[] = {
+static const ahd_reg_parse_entry_t ROENABLE_parse_table[] = {
 	{ "DCH0ROEN",		0x01, 0x01 },
 	{ "DCH1ROEN",		0x02, 0x02 },
 	{ "SGROEN",		0x04, 0x04 },
@@ -1899,7 +1362,7 @@ ahd_roenable_print(u_int regvalue, u_int
 	    0x90, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYRXMSG0_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYRXMSG0_parse_table[] = {
 	{ "CFNUM",		0x07, 0x07 },
 	{ "CDNUM",		0xf8, 0xf8 }
 };
@@ -1911,7 +1374,7 @@ ahd_ovlyrxmsg0_print(u_int regvalue, u_i
 	    0x90, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DCHRXMSG0_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHRXMSG0_parse_table[] = {
 	{ "CFNUM",		0x07, 0x07 },
 	{ "CDNUM",		0xf8, 0xf8 }
 };
@@ -1923,7 +1386,7 @@ ahd_dchrxmsg0_print(u_int regvalue, u_in
 	    0x90, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYRXMSG1_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYRXMSG1_parse_table[] = {
 	{ "CBNUM",		0xff, 0xff }
 };
 
@@ -1934,7 +1397,7 @@ ahd_ovlyrxmsg1_print(u_int regvalue, u_i
 	    0x91, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t NSENABLE_parse_table[] = {
+static const ahd_reg_parse_entry_t NSENABLE_parse_table[] = {
 	{ "DCH0NSEN",		0x01, 0x01 },
 	{ "DCH1NSEN",		0x02, 0x02 },
 	{ "SGNSEN",		0x04, 0x04 },
@@ -1950,7 +1413,7 @@ ahd_nsenable_print(u_int regvalue, u_int
 	    0x91, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCRXMSG1_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCRXMSG1_parse_table[] = {
 	{ "CBNUM",		0xff, 0xff }
 };
 
@@ -1961,7 +1424,7 @@ ahd_cmcrxmsg1_print(u_int regvalue, u_in
 	    0x91, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DCHRXMSG1_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHRXMSG1_parse_table[] = {
 	{ "CBNUM",		0xff, 0xff }
 };
 
@@ -1972,7 +1435,7 @@ ahd_dchrxmsg1_print(u_int regvalue, u_in
 	    0x91, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DCHRXMSG2_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHRXMSG2_parse_table[] = {
 	{ "MINDEX",		0xff, 0xff }
 };
 
@@ -1983,7 +1446,7 @@ ahd_dchrxmsg2_print(u_int regvalue, u_in
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCRXMSG2_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCRXMSG2_parse_table[] = {
 	{ "MINDEX",		0xff, 0xff }
 };
 
@@ -2001,7 +1464,7 @@ ahd_ost_print(u_int regvalue, u_int *cur
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYRXMSG2_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYRXMSG2_parse_table[] = {
 	{ "MINDEX",		0xff, 0xff }
 };
 
@@ -2012,7 +1475,7 @@ ahd_ovlyrxmsg2_print(u_int regvalue, u_i
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DCHRXMSG3_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHRXMSG3_parse_table[] = {
 	{ "MCLASS",		0x0f, 0x0f }
 };
 
@@ -2023,7 +1486,7 @@ ahd_dchrxmsg3_print(u_int regvalue, u_in
 	    0x93, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYRXMSG3_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYRXMSG3_parse_table[] = {
 	{ "MCLASS",		0x0f, 0x0f }
 };
 
@@ -2034,7 +1497,7 @@ ahd_ovlyrxmsg3_print(u_int regvalue, u_i
 	    0x93, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCRXMSG3_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCRXMSG3_parse_table[] = {
 	{ "MCLASS",		0x0f, 0x0f }
 };
 
@@ -2045,7 +1508,7 @@ ahd_cmcrxmsg3_print(u_int regvalue, u_in
 	    0x93, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PCIXCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t PCIXCTL_parse_table[] = {
 	{ "CMPABCDIS",		0x01, 0x01 },
 	{ "TSCSERREN",		0x02, 0x02 },
 	{ "SRSPDPEEN",		0x04, 0x04 },
@@ -2083,7 +1546,7 @@ ahd_cmcseqbcnt_print(u_int regvalue, u_i
 	    0x94, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCSPLTSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCSPLTSTAT0_parse_table[] = {
 	{ "RXSPLTRSP",		0x01, 0x01 },
 	{ "RXSCEMSG",		0x02, 0x02 },
 	{ "RXOVRUN",		0x04, 0x04 },
@@ -2101,7 +1564,7 @@ ahd_cmcspltstat0_print(u_int regvalue, u
 	    0x96, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DCHSPLTSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHSPLTSTAT0_parse_table[] = {
 	{ "RXSPLTRSP",		0x01, 0x01 },
 	{ "RXSCEMSG",		0x02, 0x02 },
 	{ "RXOVRUN",		0x04, 0x04 },
@@ -2119,7 +1582,7 @@ ahd_dchspltstat0_print(u_int regvalue, u
 	    0x96, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYSPLTSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYSPLTSTAT0_parse_table[] = {
 	{ "RXSPLTRSP",		0x01, 0x01 },
 	{ "RXSCEMSG",		0x02, 0x02 },
 	{ "RXOVRUN",		0x04, 0x04 },
@@ -2137,7 +1600,7 @@ ahd_ovlyspltstat0_print(u_int regvalue, 
 	    0x96, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCSPLTSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCSPLTSTAT1_parse_table[] = {
 	{ "RXDATABUCKET",	0x01, 0x01 }
 };
 
@@ -2148,7 +1611,7 @@ ahd_cmcspltstat1_print(u_int regvalue, u
 	    0x97, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYSPLTSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYSPLTSTAT1_parse_table[] = {
 	{ "RXDATABUCKET",	0x01, 0x01 }
 };
 
@@ -2159,7 +1622,7 @@ ahd_ovlyspltstat1_print(u_int regvalue, 
 	    0x97, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DCHSPLTSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHSPLTSTAT1_parse_table[] = {
 	{ "RXDATABUCKET",	0x01, 0x01 }
 };
 
@@ -2170,7 +1633,7 @@ ahd_dchspltstat1_print(u_int regvalue, u
 	    0x97, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGRXMSG0_parse_table[] = {
+static const ahd_reg_parse_entry_t SGRXMSG0_parse_table[] = {
 	{ "CFNUM",		0x07, 0x07 },
 	{ "CDNUM",		0xf8, 0xf8 }
 };
@@ -2182,7 +1645,7 @@ ahd_sgrxmsg0_print(u_int regvalue, u_int
 	    0x98, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTADR0_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTADR0_parse_table[] = {
 	{ "LOWER_ADDR",		0x7f, 0x7f }
 };
 
@@ -2193,7 +1656,7 @@ ahd_slvspltoutadr0_print(u_int regvalue,
 	    0x98, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGRXMSG1_parse_table[] = {
+static const ahd_reg_parse_entry_t SGRXMSG1_parse_table[] = {
 	{ "CBNUM",		0xff, 0xff }
 };
 
@@ -2204,7 +1667,7 @@ ahd_sgrxmsg1_print(u_int regvalue, u_int
 	    0x99, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTADR1_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTADR1_parse_table[] = {
 	{ "REQ_FNUM",		0x07, 0x07 },
 	{ "REQ_DNUM",		0xf8, 0xf8 }
 };
@@ -2216,7 +1679,7 @@ ahd_slvspltoutadr1_print(u_int regvalue,
 	    0x99, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGRXMSG2_parse_table[] = {
+static const ahd_reg_parse_entry_t SGRXMSG2_parse_table[] = {
 	{ "MINDEX",		0xff, 0xff }
 };
 
@@ -2227,7 +1690,7 @@ ahd_sgrxmsg2_print(u_int regvalue, u_int
 	    0x9a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTADR2_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTADR2_parse_table[] = {
 	{ "REQ_BNUM",		0xff, 0xff }
 };
 
@@ -2238,7 +1701,7 @@ ahd_slvspltoutadr2_print(u_int regvalue,
 	    0x9a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGRXMSG3_parse_table[] = {
+static const ahd_reg_parse_entry_t SGRXMSG3_parse_table[] = {
 	{ "MCLASS",		0x0f, 0x0f }
 };
 
@@ -2249,7 +1712,7 @@ ahd_sgrxmsg3_print(u_int regvalue, u_int
 	    0x9b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTADR3_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTADR3_parse_table[] = {
 	{ "RLXORD",		0x10, 0x10 },
 	{ "TAG_NUM",		0x1f, 0x1f }
 };
@@ -2268,7 +1731,7 @@ ahd_sgseqbcnt_print(u_int regvalue, u_in
 	    0x9c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTATTR0_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTATTR0_parse_table[] = {
 	{ "LOWER_BCNT",		0xff, 0xff }
 };
 
@@ -2279,7 +1742,7 @@ ahd_slvspltoutattr0_print(u_int regvalue
 	    0x9c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTATTR1_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTATTR1_parse_table[] = {
 	{ "CMPLT_FNUM",		0x07, 0x07 },
 	{ "CMPLT_DNUM",		0xf8, 0xf8 }
 };
@@ -2291,7 +1754,7 @@ ahd_slvspltoutattr1_print(u_int regvalue
 	    0x9d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SLVSPLTOUTATTR2_parse_table[] = {
+static const ahd_reg_parse_entry_t SLVSPLTOUTATTR2_parse_table[] = {
 	{ "CMPLT_BNUM",		0xff, 0xff }
 };
 
@@ -2302,7 +1765,7 @@ ahd_slvspltoutattr2_print(u_int regvalue
 	    0x9e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGSPLTSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t SGSPLTSTAT0_parse_table[] = {
 	{ "RXSPLTRSP",		0x01, 0x01 },
 	{ "RXSCEMSG",		0x02, 0x02 },
 	{ "RXOVRUN",		0x04, 0x04 },
@@ -2320,7 +1783,7 @@ ahd_sgspltstat0_print(u_int regvalue, u_
 	    0x9e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGSPLTSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t SGSPLTSTAT1_parse_table[] = {
 	{ "RXDATABUCKET",	0x01, 0x01 }
 };
 
@@ -2331,7 +1794,7 @@ ahd_sgspltstat1_print(u_int regvalue, u_
 	    0x9f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SFUNCT_parse_table[] = {
+static const ahd_reg_parse_entry_t SFUNCT_parse_table[] = {
 	{ "TEST_NUM",		0x0f, 0x0f },
 	{ "TEST_GROUP",		0xf0, 0xf0 }
 };
@@ -2343,7 +1806,7 @@ ahd_sfunct_print(u_int regvalue, u_int *
 	    0x9f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DF0PCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t DF0PCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "TWATERR",		0x02, 0x02 },
 	{ "RDPERR",		0x04, 0x04 },
@@ -2368,7 +1831,7 @@ ahd_reg0_print(u_int regvalue, u_int *cu
 	    0xa0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DF1PCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t DF1PCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "TWATERR",		0x02, 0x02 },
 	{ "RDPERR",		0x04, 0x04 },
@@ -2386,7 +1849,7 @@ ahd_df1pcistat_print(u_int regvalue, u_i
 	    0xa1, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGPCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t SGPCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "RDPERR",		0x04, 0x04 },
 	{ "SCAAPERR",		0x08, 0x08 },
@@ -2410,7 +1873,7 @@ ahd_reg1_print(u_int regvalue, u_int *cu
 	    0xa2, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMCPCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t CMCPCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "TWATERR",		0x02, 0x02 },
 	{ "RDPERR",		0x04, 0x04 },
@@ -2428,7 +1891,7 @@ ahd_cmcpcistat_print(u_int regvalue, u_i
 	    0xa3, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYPCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t OVLYPCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "RDPERR",		0x04, 0x04 },
 	{ "SCAAPERR",		0x08, 0x08 },
@@ -2452,20 +1915,7 @@ ahd_reg_isr_print(u_int regvalue, u_int 
 	    0xa4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
-	{ "SEGS_AVAIL",		0x01, 0x01 },
-	{ "LOADING_NEEDED",	0x02, 0x02 },
-	{ "FETCH_INPROG",	0x04, 0x04 }
-};
-
-int
-ahd_sg_state_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SG_STATE_parse_table, 3, "SG_STATE",
-	    0xa6, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t MSIPCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t MSIPCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "TWATERR",		0x02, 0x02 },
 	{ "CLRPENDMSI",		0x08, 0x08 },
@@ -2481,7 +1931,7 @@ ahd_msipcistat_print(u_int regvalue, u_i
 	    0xa6, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t TARGPCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t TARGPCISTAT_parse_table[] = {
 	{ "TWATERR",		0x02, 0x02 },
 	{ "STA",		0x08, 0x08 },
 	{ "SSE",		0x40, 0x40 },
@@ -2516,7 +1966,7 @@ ahd_ccscbacnt_print(u_int regvalue, u_in
 	    0xab, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCBAUTOPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCBAUTOPTR_parse_table[] = {
 	{ "SCBPTR_OFF",		0x07, 0x07 },
 	{ "SCBPTR_ADDR",	0x38, 0x38 },
 	{ "AUSCBPTR_EN",	0x80, 0x80 }
@@ -2550,7 +2000,7 @@ ahd_ccscbaddr_print(u_int regvalue, u_in
 	    0xac, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMC_RAMBIST_parse_table[] = {
+static const ahd_reg_parse_entry_t CMC_RAMBIST_parse_table[] = {
 	{ "CMC_BUFFER_BIST_EN",	0x01, 0x01 },
 	{ "CMC_BUFFER_BIST_FAIL",0x02, 0x02 },
 	{ "SG_BIST_EN",		0x10, 0x10 },
@@ -2566,38 +2016,6 @@ ahd_cmc_rambist_print(u_int regvalue, u_
 	    0xad, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
-	{ "CCSCBRESET",		0x01, 0x01 },
-	{ "CCSCBDIR",		0x04, 0x04 },
-	{ "CCSCBEN",		0x08, 0x08 },
-	{ "CCARREN",		0x10, 0x10 },
-	{ "ARRDONE",		0x40, 0x40 },
-	{ "CCSCBDONE",		0x80, 0x80 }
-};
-
-int
-ahd_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
-	    0xad, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
-	{ "CCSGRESET",		0x01, 0x01 },
-	{ "SG_FETCH_REQ",	0x02, 0x02 },
-	{ "CCSGENACK",		0x08, 0x08 },
-	{ "SG_CACHE_AVAIL",	0x10, 0x10 },
-	{ "CCSGDONE",		0x80, 0x80 },
-	{ "CCSGEN",		0x0c, 0x0c }
-};
-
-int
-ahd_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
-	    0xad, regvalue, cur_col, wrap));
-}
-
 int
 ahd_ccsgram_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -2626,7 +2044,7 @@ ahd_flexcnt_print(u_int regvalue, u_int 
 	    0xb3, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t FLEXDMASTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t FLEXDMASTAT_parse_table[] = {
 	{ "FLEXDMADONE",	0x01, 0x01 },
 	{ "FLEXDMAERR",		0x02, 0x02 }
 };
@@ -2652,7 +2070,7 @@ ahd_brddat_print(u_int regvalue, u_int *
 	    0xb8, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t BRDCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t BRDCTL_parse_table[] = {
 	{ "BRDSTB",		0x01, 0x01 },
 	{ "BRDRW",		0x02, 0x02 },
 	{ "BRDEN",		0x04, 0x04 },
@@ -2682,7 +2100,7 @@ ahd_seedat_print(u_int regvalue, u_int *
 	    0xbc, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEECTL_parse_table[] = {
+static const ahd_reg_parse_entry_t SEECTL_parse_table[] = {
 	{ "SEEOP_ERAL",		0x40, 0x70 },
 	{ "SEEOP_WRITE",	0x50, 0x70 },
 	{ "SEEOP_READ",		0x60, 0x70 },
@@ -2702,7 +2120,7 @@ ahd_seectl_print(u_int regvalue, u_int *
 	    0xbe, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEESTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t SEESTAT_parse_table[] = {
 	{ "SEESTART",		0x01, 0x01 },
 	{ "SEEBUSY",		0x02, 0x02 },
 	{ "SEEARBACK",		0x04, 0x04 },
@@ -2732,7 +2150,7 @@ ahd_dfwaddr_print(u_int regvalue, u_int 
 	    0xc0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSPFLTRCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPFLTRCTL_parse_table[] = {
 	{ "DSPFCNTSEL",		0x0f, 0x0f },
 	{ "EDGESENSE",		0x10, 0x10 },
 	{ "FLTRDISABLE",	0x20, 0x20 }
@@ -2745,7 +2163,7 @@ ahd_dspfltrctl_print(u_int regvalue, u_i
 	    0xc0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSPDATACTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPDATACTL_parse_table[] = {
 	{ "XMITOFFSTDIS",	0x02, 0x02 },
 	{ "RCVROFFSTDIS",	0x04, 0x04 },
 	{ "DESQDIS",		0x10, 0x10 },
@@ -2766,7 +2184,7 @@ ahd_dfraddr_print(u_int regvalue, u_int 
 	    0xc2, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSPREQCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPREQCTL_parse_table[] = {
 	{ "MANREQDLY",		0x3f, 0x3f },
 	{ "MANREQCTL",		0xc0, 0xc0 }
 };
@@ -2778,7 +2196,7 @@ ahd_dspreqctl_print(u_int regvalue, u_in
 	    0xc2, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSPACKCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPACKCTL_parse_table[] = {
 	{ "MANACKDLY",		0x3f, 0x3f },
 	{ "MANACKCTL",		0xc0, 0xc0 }
 };
@@ -2797,7 +2215,7 @@ ahd_dfdat_print(u_int regvalue, u_int *c
 	    0xc4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSPSELECT_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPSELECT_parse_table[] = {
 	{ "DSPSEL",		0x1f, 0x1f },
 	{ "AUTOINCEN",		0x80, 0x80 }
 };
@@ -2809,7 +2227,7 @@ ahd_dspselect_print(u_int regvalue, u_in
 	    0xc4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t WRTBIASCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t WRTBIASCTL_parse_table[] = {
 	{ "XMITMANVAL",		0x3f, 0x3f },
 	{ "AUTOXBCDIS",		0x80, 0x80 }
 };
@@ -2821,7 +2239,7 @@ ahd_wrtbiasctl_print(u_int regvalue, u_i
 	    0xc5, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t RCVRBIOSCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t RCVRBIOSCTL_parse_table[] = {
 	{ "RCVRMANVAL",		0x3f, 0x3f },
 	{ "AUTORBCDIS",		0x80, 0x80 }
 };
@@ -2868,7 +2286,7 @@ ahd_dfbkptr_print(u_int regvalue, u_int 
 	    0xc9, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFDBCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DFDBCTL_parse_table[] = {
 	{ "DFF_RAMBIST_EN",	0x01, 0x01 },
 	{ "DFF_RAMBIST_DONE",	0x02, 0x02 },
 	{ "DFF_RAMBIST_FAIL",	0x04, 0x04 },
@@ -2905,25 +2323,7 @@ ahd_ovlyaddr_print(u_int regvalue, u_int
 	    0xd4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
-	{ "LOADRAM",		0x01, 0x01 },
-	{ "SEQRESET",		0x02, 0x02 },
-	{ "STEP",		0x04, 0x04 },
-	{ "BRKADRINTEN",	0x08, 0x08 },
-	{ "FASTMODE",		0x10, 0x10 },
-	{ "FAILDIS",		0x20, 0x20 },
-	{ "PAUSEDIS",		0x40, 0x40 },
-	{ "PERRORDIS",		0x80, 0x80 }
-};
-
-int
-ahd_seqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
-	    0xd6, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQCTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQCTL1_parse_table[] = {
 	{ "RAMBIST_EN",		0x01, 0x01 },
 	{ "RAMBIST_FAIL",	0x02, 0x02 },
 	{ "RAMBIST_DONE",	0x04, 0x04 },
@@ -2937,7 +2337,7 @@ ahd_seqctl1_print(u_int regvalue, u_int 
 	    0xd7, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t FLAGS_parse_table[] = {
+static const ahd_reg_parse_entry_t FLAGS_parse_table[] = {
 	{ "CARRY",		0x01, 0x01 },
 	{ "ZERO",		0x02, 0x02 }
 };
@@ -2949,23 +2349,6 @@ ahd_flags_print(u_int regvalue, u_int *c
 	    0xd8, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
-	{ "IRET",		0x01, 0x01 },
-	{ "INTMASK1",		0x02, 0x02 },
-	{ "INTMASK2",		0x04, 0x04 },
-	{ "SCS_SEQ_INT1M0",	0x08, 0x08 },
-	{ "SCS_SEQ_INT1M1",	0x10, 0x10 },
-	{ "INT1_CONTEXT",	0x20, 0x20 },
-	{ "INTVEC1DSL",		0x80, 0x80 }
-};
-
-int
-ahd_seqintctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQINTCTL_parse_table, 7, "SEQINTCTL",
-	    0xd9, regvalue, cur_col, wrap));
-}
-
 int
 ahd_seqram_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -3008,7 +2391,7 @@ ahd_brkaddr0_print(u_int regvalue, u_int
 	    0xe6, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t BRKADDR1_parse_table[] = {
+static const ahd_reg_parse_entry_t BRKADDR1_parse_table[] = {
 	{ "BRKDIS",		0x80, 0x80 }
 };
 
@@ -3188,34 +2571,13 @@ ahd_complete_on_qfreeze_head_print(u_int
 }
 
 int
-ahd_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "QFREEZE_COUNT",
-	    0x132, regvalue, cur_col, wrap));
-}
-
-int
-ahd_kernel_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT",
-	    0x134, regvalue, cur_col, wrap));
-}
-
-int
-ahd_saved_mode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SAVED_MODE",
-	    0x136, regvalue, cur_col, wrap));
-}
-
-int
 ahd_msg_out_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "MSG_OUT",
 	    0x137, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
+static const ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -3235,25 +2597,6 @@ ahd_dmaparams_print(u_int regvalue, u_in
 	    0x138, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
-	{ "NO_DISCONNECT",	0x01, 0x01 },
-	{ "SPHASE_PENDING",	0x02, 0x02 },
-	{ "DPHASE_PENDING",	0x04, 0x04 },
-	{ "CMDPHASE_PENDING",	0x08, 0x08 },
-	{ "TARG_CMD_PENDING",	0x10, 0x10 },
-	{ "DPHASE",		0x20, 0x20 },
-	{ "NO_CDB_SENT",	0x40, 0x40 },
-	{ "TARGET_CMD_IS_TAGGED",0x40, 0x40 },
-	{ "NOT_IDENTIFIED",	0x80, 0x80 }
-};
-
-int
-ahd_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
-	    0x139, regvalue, cur_col, wrap));
-}
-
 int
 ahd_saved_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -3268,29 +2611,6 @@ ahd_saved_lun_print(u_int regvalue, u_in
 	    0x13b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
-	{ "P_DATAOUT",		0x00, 0xe0 },
-	{ "P_DATAOUT_DT",	0x20, 0xe0 },
-	{ "P_DATAIN",		0x40, 0xe0 },
-	{ "P_DATAIN_DT",	0x60, 0xe0 },
-	{ "P_COMMAND",		0x80, 0xe0 },
-	{ "P_MESGOUT",		0xa0, 0xe0 },
-	{ "P_STATUS",		0xc0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 },
-	{ "P_BUSFREE",		0x01, 0x01 },
-	{ "MSGI",		0x20, 0x20 },
-	{ "IOI",		0x40, 0x40 },
-	{ "CDI",		0x80, 0x80 },
-	{ "PHASE_MASK",		0xe0, 0xe0 }
-};
-
-int
-ahd_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LASTPHASE_parse_table, 13, "LASTPHASE",
-	    0x13c, regvalue, cur_col, wrap));
-}
-
 int
 ahd_qoutfifo_entry_valid_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -3326,7 +2646,7 @@ ahd_qoutfifo_next_addr_print(u_int regva
 	    0x144, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ARG_1_parse_table[] = {
+static const ahd_reg_parse_entry_t ARG_1_parse_table[] = {
 	{ "CONT_MSG_LOOP_TARG",	0x02, 0x02 },
 	{ "CONT_MSG_LOOP_READ",	0x03, 0x03 },
 	{ "CONT_MSG_LOOP_WRITE",0x04, 0x04 },
@@ -3358,7 +2678,7 @@ ahd_last_msg_print(u_int regvalue, u_int
 	    0x14a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
 	{ "ALTSTIM",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "MANUALP",		0x0c, 0x0c },
@@ -3381,19 +2701,6 @@ ahd_initiator_tag_print(u_int regvalue, 
 	    0x14c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
-	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
-	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
-	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
-};
-
-int
-ahd_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
-	    0x14d, regvalue, cur_col, wrap));
-}
-
 int
 ahd_allocfifo_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -3451,20 +2758,6 @@ ahd_cmdsize_table_print(u_int regvalue, 
 }
 
 int
-ahd_mk_message_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCB",
-	    0x160, regvalue, cur_col, wrap));
-}
-
-int
-ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
-	    0x162, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCB_BASE",
@@ -3478,7 +2771,7 @@ ahd_scb_residual_datacnt_print(u_int reg
 	    0x180, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_OVERRUN_RESID",	0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -3533,36 +2826,7 @@ ahd_scb_tag_print(u_int regvalue, u_int 
 	    0x190, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
-	{ "SCB_TAG_TYPE",	0x03, 0x03 },
-	{ "DISCONNECTED",	0x04, 0x04 },
-	{ "STATUS_RCVD",	0x08, 0x08 },
-	{ "MK_MESSAGE",		0x10, 0x10 },
-	{ "TAG_ENB",		0x20, 0x20 },
-	{ "DISCENB",		0x40, 0x40 },
-	{ "TARGET_SCB",		0x80, 0x80 }
-};
-
-int
-ahd_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
-	    0x192, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
-	{ "OID",		0x0f, 0x0f },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahd_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_SCSIID_parse_table, 2, "SCB_SCSIID",
-	    0x193, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
 	{ "LID",		0xff, 0xff }
 };
 
@@ -3573,7 +2837,7 @@ ahd_scb_lun_print(u_int regvalue, u_int 
 	    0x194, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
 	{ "SCB_XFERLEN_ODD",	0x01, 0x01 }
 };
 
@@ -3584,7 +2848,7 @@ ahd_scb_task_attribute_print(u_int regva
 	    0x195, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
 	{ "SCB_CDB_LEN_PTR",	0x80, 0x80 }
 };
 
@@ -3609,7 +2873,7 @@ ahd_scb_dataptr_print(u_int regvalue, u_
 	    0x198, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
 	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f },
 	{ "SG_LAST_SEG",	0x80, 0x80 }
 };
@@ -3621,7 +2885,7 @@ ahd_scb_datacnt_print(u_int regvalue, u_
 	    0x1a0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_FULL_RESID",	0x02, 0x02 },
 	{ "SG_STATUS_VALID",	0x04, 0x04 }
@@ -3669,3 +2933,741 @@ ahd_scb_disconnected_lists_print(u_int r
 	    0x1b8, regvalue, cur_col, wrap));
 }
 
+static const ahd_reg_parse_entry_t CLRSINT1_parse_table[] = {
+	{ "CLRREQINIT",		0x01, 0x01 },
+	{ "CLRSTRB2FAST",	0x02, 0x02 },
+	{ "CLRSCSIPERR",	0x04, 0x04 },
+	{ "CLRBUSFREE",		0x08, 0x08 },
+	{ "CLRSCSIRSTI",	0x20, 0x20 },
+	{ "CLRATNO",		0x40, 0x40 },
+	{ "CLRSELTIMEO",	0x80, 0x80 }
+};
+
+int
+ahd_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
+	    0x4c, regvalue, cur_col, wrap));
+}
+#endif /* unused */
+
+static const ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
+	{ "SPLTINT",		0x01, 0x01 },
+	{ "CMDCMPLT",		0x02, 0x02 },
+	{ "SEQINT",		0x04, 0x04 },
+	{ "SCSIINT",		0x08, 0x08 },
+	{ "PCIINT",		0x10, 0x10 },
+	{ "SWTMINT",		0x20, 0x20 },
+	{ "BRKADRINT",		0x40, 0x40 },
+	{ "HWERRINT",		0x80, 0x80 },
+	{ "INT_PEND",		0xff, 0xff }
+};
+
+int
+ahd_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(INTSTAT_parse_table, 9, "INTSTAT",
+	    0x01, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
+	{ "ENINT_COALESCE",	0x40, 0x40 },
+	{ "HOST_TQINPOS",	0x80, 0x80 }
+};
+
+int
+ahd_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(HS_MAILBOX_parse_table, 2, "HS_MAILBOX",
+	    0x0b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
+	{ "SEQ_SPLTINT",	0x01, 0x01 },
+	{ "SEQ_PCIINT",		0x02, 0x02 },
+	{ "SEQ_SCSIINT",	0x04, 0x04 },
+	{ "SEQ_SEQINT",		0x08, 0x08 },
+	{ "SEQ_SWTMRTO",	0x10, 0x10 }
+};
+
+int
+ahd_seqintstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQINTSTAT_parse_table, 5, "SEQINTSTAT",
+	    0x0c, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t INTCTL_parse_table[] = {
+	{ "SPLTINTEN",		0x01, 0x01 },
+	{ "SEQINTEN",		0x02, 0x02 },
+	{ "SCSIINTEN",		0x04, 0x04 },
+	{ "PCIINTEN",		0x08, 0x08 },
+	{ "AUTOCLRCMDINT",	0x10, 0x10 },
+	{ "SWTIMER_START",	0x20, 0x20 },
+	{ "SWTMINTEN",		0x40, 0x40 },
+	{ "SWTMINTMASK",	0x80, 0x80 }
+};
+
+int
+ahd_intctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(INTCTL_parse_table, 8, "INTCTL",
+	    0x18, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
+	{ "DIRECTIONEN",	0x01, 0x01 },
+	{ "FIFOFLUSH",		0x02, 0x02 },
+	{ "FIFOFLUSHACK",	0x02, 0x02 },
+	{ "DIRECTION",		0x04, 0x04 },
+	{ "DIRECTIONACK",	0x04, 0x04 },
+	{ "HDMAEN",		0x08, 0x08 },
+	{ "HDMAENACK",		0x08, 0x08 },
+	{ "SCSIEN",		0x20, 0x20 },
+	{ "SCSIENACK",		0x20, 0x20 },
+	{ "SCSIENWRDIS",	0x40, 0x40 },
+	{ "PRELOADEN",		0x80, 0x80 }
+};
+
+int
+ahd_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(DFCNTRL_parse_table, 11, "DFCNTRL",
+	    0x19, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
+	{ "FIFOEMP",		0x01, 0x01 },
+	{ "FIFOFULL",		0x02, 0x02 },
+	{ "DFTHRESH",		0x04, 0x04 },
+	{ "HDONE",		0x08, 0x08 },
+	{ "MREQPEND",		0x10, 0x10 },
+	{ "PKT_PRELOAD_AVAIL",	0x40, 0x40 },
+	{ "PRELOAD_AVAIL",	0x80, 0x80 }
+};
+
+int
+ahd_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(DFSTATUS_parse_table, 7, "DFSTATUS",
+	    0x1a, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
+	{ "LAST_SEG_DONE",	0x01, 0x01 },
+	{ "LAST_SEG",		0x02, 0x02 },
+	{ "ODD_SEG",		0x04, 0x04 },
+	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
+};
+
+int
+ahd_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SG_CACHE_SHADOW_parse_table, 4, "SG_CACHE_SHADOW",
+	    0x1b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
+	{ "SCSIRSTO",		0x01, 0x01 },
+	{ "FORCEBUSFREE",	0x10, 0x10 },
+	{ "ENARBO",		0x20, 0x20 },
+	{ "ENSELO",		0x40, 0x40 },
+	{ "TEMODEO",		0x80, 0x80 }
+};
+
+int
+ahd_scsiseq0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SCSISEQ0_parse_table, 5, "SCSISEQ0",
+	    0x3a, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
+	{ "ALTSTIM",		0x01, 0x01 },
+	{ "ENAUTOATNP",		0x02, 0x02 },
+	{ "MANUALP",		0x0c, 0x0c },
+	{ "ENRSELI",		0x10, 0x10 },
+	{ "ENSELI",		0x20, 0x20 },
+	{ "MANUALCTL",		0x40, 0x40 }
+};
+
+int
+ahd_scsiseq1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SCSISEQ1_parse_table, 6, "SCSISEQ1",
+	    0x3b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
+	{ "CURRFIFO_0",		0x00, 0x03 },
+	{ "CURRFIFO_1",		0x01, 0x03 },
+	{ "CURRFIFO_NONE",	0x03, 0x03 },
+	{ "FIFO0FREE",		0x10, 0x10 },
+	{ "FIFO1FREE",		0x20, 0x20 },
+	{ "CURRFIFO",		0x03, 0x03 }
+};
+
+int
+ahd_dffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(DFFSTAT_parse_table, 6, "DFFSTAT",
+	    0x3f, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
+	{ "P_DATAOUT",		0x00, 0xe0 },
+	{ "P_DATAOUT_DT",	0x20, 0xe0 },
+	{ "P_DATAIN",		0x40, 0xe0 },
+	{ "P_DATAIN_DT",	0x60, 0xe0 },
+	{ "P_COMMAND",		0x80, 0xe0 },
+	{ "P_MESGOUT",		0xa0, 0xe0 },
+	{ "P_STATUS",		0xc0, 0xe0 },
+	{ "P_MESGIN",		0xe0, 0xe0 },
+	{ "ACKI",		0x01, 0x01 },
+	{ "REQI",		0x02, 0x02 },
+	{ "BSYI",		0x04, 0x04 },
+	{ "SELI",		0x08, 0x08 },
+	{ "ATNI",		0x10, 0x10 },
+	{ "MSGI",		0x20, 0x20 },
+	{ "IOI",		0x40, 0x40 },
+	{ "CDI",		0x80, 0x80 },
+	{ "PHASE_MASK",		0xe0, 0xe0 }
+};
+
+int
+ahd_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
+	    0x41, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+	{ "DATA_OUT_PHASE",	0x01, 0x03 },
+	{ "DATA_IN_PHASE",	0x02, 0x03 },
+	{ "DATA_PHASE_MASK",	0x03, 0x03 },
+	{ "MSG_OUT_PHASE",	0x04, 0x04 },
+	{ "MSG_IN_PHASE",	0x08, 0x08 },
+	{ "COMMAND_PHASE",	0x10, 0x10 },
+	{ "STATUS_PHASE",	0x20, 0x20 }
+};
+
+int
+ahd_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
+	    0x42, regvalue, cur_col, wrap));
+}
+
+int
+ahd_scsibus_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "SCSIBUS",
+	    0x46, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SELID_parse_table[] = {
+	{ "ONEBIT",		0x08, 0x08 },
+	{ "SELID_MASK",		0xf0, 0xf0 }
+};
+
+int
+ahd_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SELID_parse_table, 2, "SELID",
+	    0x49, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
+	{ "ARBDO",		0x01, 0x01 },
+	{ "SPIORDY",		0x02, 0x02 },
+	{ "OVERRUN",		0x04, 0x04 },
+	{ "IOERR",		0x08, 0x08 },
+	{ "SELINGO",		0x10, 0x10 },
+	{ "SELDI",		0x20, 0x20 },
+	{ "SELDO",		0x40, 0x40 },
+	{ "TARGET",		0x80, 0x80 }
+};
+
+int
+ahd_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SSTAT0_parse_table, 8, "SSTAT0",
+	    0x4b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
+	{ "ENARBDO",		0x01, 0x01 },
+	{ "ENSPIORDY",		0x02, 0x02 },
+	{ "ENOVERRUN",		0x04, 0x04 },
+	{ "ENIOERR",		0x08, 0x08 },
+	{ "ENSELINGO",		0x10, 0x10 },
+	{ "ENSELDI",		0x20, 0x20 },
+	{ "ENSELDO",		0x40, 0x40 }
+};
+
+int
+ahd_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SIMODE0_parse_table, 7, "SIMODE0",
+	    0x4b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
+	{ "REQINIT",		0x01, 0x01 },
+	{ "STRB2FAST",		0x02, 0x02 },
+	{ "SCSIPERR",		0x04, 0x04 },
+	{ "BUSFREE",		0x08, 0x08 },
+	{ "PHASEMIS",		0x10, 0x10 },
+	{ "SCSIRSTI",		0x20, 0x20 },
+	{ "ATNTARG",		0x40, 0x40 },
+	{ "SELTO",		0x80, 0x80 }
+};
+
+int
+ahd_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SSTAT1_parse_table, 8, "SSTAT1",
+	    0x4c, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
+	{ "BUSFREE_LQO",	0x40, 0xc0 },
+	{ "BUSFREE_DFF0",	0x80, 0xc0 },
+	{ "BUSFREE_DFF1",	0xc0, 0xc0 },
+	{ "DMADONE",		0x01, 0x01 },
+	{ "SDONE",		0x02, 0x02 },
+	{ "WIDE_RES",		0x04, 0x04 },
+	{ "BSYX",		0x08, 0x08 },
+	{ "EXP_ACTIVE",		0x10, 0x10 },
+	{ "NONPACKREQ",		0x20, 0x20 },
+	{ "BUSFREETIME",	0xc0, 0xc0 }
+};
+
+int
+ahd_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SSTAT2_parse_table, 10, "SSTAT2",
+	    0x4d, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
+	{ "DTERR",		0x01, 0x01 },
+	{ "DGFORMERR",		0x02, 0x02 },
+	{ "CRCERR",		0x04, 0x04 },
+	{ "AIPERR",		0x08, 0x08 },
+	{ "PARITYERR",		0x10, 0x10 },
+	{ "PREVPHASE",		0x20, 0x20 },
+	{ "HIPERR",		0x40, 0x40 },
+	{ "HIZERO",		0x80, 0x80 }
+};
+
+int
+ahd_perrdiag_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(PERRDIAG_parse_table, 8, "PERRDIAG",
+	    0x4e, regvalue, cur_col, wrap));
+}
+
+int
+ahd_soffcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "SOFFCNT",
+	    0x4f, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
+	{ "LQIATNCMD",		0x01, 0x01 },
+	{ "LQIATNLQ",		0x02, 0x02 },
+	{ "LQIBADLQT",		0x04, 0x04 },
+	{ "LQICRCT2",		0x08, 0x08 },
+	{ "LQICRCT1",		0x10, 0x10 },
+	{ "LQIATNQAS",		0x20, 0x20 }
+};
+
+int
+ahd_lqistat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LQISTAT0_parse_table, 6, "LQISTAT0",
+	    0x50, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
+	{ "LQIOVERI_NLQ",	0x01, 0x01 },
+	{ "LQIOVERI_LQ",	0x02, 0x02 },
+	{ "LQIBADLQI",		0x04, 0x04 },
+	{ "LQICRCI_NLQ",	0x08, 0x08 },
+	{ "LQICRCI_LQ",		0x10, 0x10 },
+	{ "LQIABORT",		0x20, 0x20 },
+	{ "LQIPHASE_NLQ",	0x40, 0x40 },
+	{ "LQIPHASE_LQ",	0x80, 0x80 }
+};
+
+int
+ahd_lqistat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LQISTAT1_parse_table, 8, "LQISTAT1",
+	    0x51, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
+	{ "LQIGSAVAIL",		0x01, 0x01 },
+	{ "LQISTOPCMD",		0x02, 0x02 },
+	{ "LQISTOPLQ",		0x04, 0x04 },
+	{ "LQISTOPPKT",		0x08, 0x08 },
+	{ "LQIWAITFIFO",	0x10, 0x10 },
+	{ "LQIWORKONLQ",	0x20, 0x20 },
+	{ "LQIPHASE_OUTPKT",	0x40, 0x40 },
+	{ "PACKETIZED",		0x80, 0x80 }
+};
+
+int
+ahd_lqistat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LQISTAT2_parse_table, 8, "LQISTAT2",
+	    0x52, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
+	{ "OSRAMPERR",		0x01, 0x01 },
+	{ "NTRAMPERR",		0x02, 0x02 }
+};
+
+int
+ahd_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SSTAT3_parse_table, 2, "SSTAT3",
+	    0x53, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
+	{ "LQOTCRC",		0x01, 0x01 },
+	{ "LQOATNPKT",		0x02, 0x02 },
+	{ "LQOATNLQ",		0x04, 0x04 },
+	{ "LQOSTOPT2",		0x08, 0x08 },
+	{ "LQOTARGSCBPERR",	0x10, 0x10 }
+};
+
+int
+ahd_lqostat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LQOSTAT0_parse_table, 5, "LQOSTAT0",
+	    0x54, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
+	{ "LQOPHACHGINPKT",	0x01, 0x01 },
+	{ "LQOBUSFREE",		0x02, 0x02 },
+	{ "LQOBADQAS",		0x04, 0x04 },
+	{ "LQOSTOPI2",		0x08, 0x08 },
+	{ "LQOINITSCBPERR",	0x10, 0x10 }
+};
+
+int
+ahd_lqostat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LQOSTAT1_parse_table, 5, "LQOSTAT1",
+	    0x55, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
+	{ "LQOSTOP0",		0x01, 0x01 },
+	{ "LQOPHACHGOUTPKT",	0x02, 0x02 },
+	{ "LQOWAITFIFO",	0x10, 0x10 },
+	{ "LQOPKT",		0xe0, 0xe0 }
+};
+
+int
+ahd_lqostat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LQOSTAT2_parse_table, 4, "LQOSTAT2",
+	    0x56, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
+	{ "ENREQINIT",		0x01, 0x01 },
+	{ "ENSTRB2FAST",	0x02, 0x02 },
+	{ "ENSCSIPERR",		0x04, 0x04 },
+	{ "ENBUSFREE",		0x08, 0x08 },
+	{ "ENPHASEMIS",		0x10, 0x10 },
+	{ "ENSCSIRST",		0x20, 0x20 },
+	{ "ENATNTARG",		0x40, 0x40 },
+	{ "ENSELTIMO",		0x80, 0x80 }
+};
+
+int
+ahd_simode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SIMODE1_parse_table, 8, "SIMODE1",
+	    0x57, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
+	{ "RSTCHN",		0x01, 0x01 },
+	{ "CLRCHN",		0x02, 0x02 },
+	{ "CLRSHCNT",		0x04, 0x04 },
+	{ "DFFBITBUCKET",	0x08, 0x08 }
+};
+
+int
+ahd_dffsxfrctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(DFFSXFRCTL_parse_table, 4, "DFFSXFRCTL",
+	    0x5a, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
+	{ "CFG4TCMD",		0x01, 0x01 },
+	{ "CFG4ICMD",		0x02, 0x02 },
+	{ "CFG4TSTAT",		0x04, 0x04 },
+	{ "CFG4ISTAT",		0x08, 0x08 },
+	{ "CFG4DATA",		0x10, 0x10 },
+	{ "SAVEPTRS",		0x20, 0x20 },
+	{ "CTXTDONE",		0x40, 0x40 }
+};
+
+int
+ahd_seqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQINTSRC_parse_table, 7, "SEQINTSRC",
+	    0x5b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQIMODE_parse_table[] = {
+	{ "ENCFG4TCMD",		0x01, 0x01 },
+	{ "ENCFG4ICMD",		0x02, 0x02 },
+	{ "ENCFG4TSTAT",	0x04, 0x04 },
+	{ "ENCFG4ISTAT",	0x08, 0x08 },
+	{ "ENCFG4DATA",		0x10, 0x10 },
+	{ "ENSAVEPTRS",		0x20, 0x20 },
+	{ "ENCTXTDONE",		0x40, 0x40 }
+};
+
+int
+ahd_seqimode_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQIMODE_parse_table, 7, "SEQIMODE",
+	    0x5c, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
+	{ "FIFOFREE",		0x01, 0x01 },
+	{ "DATAINFIFO",		0x02, 0x02 },
+	{ "DLZERO",		0x04, 0x04 },
+	{ "SHVALID",		0x08, 0x08 },
+	{ "LASTSDONE",		0x10, 0x10 },
+	{ "SHCNTMINUS1",	0x20, 0x20 },
+	{ "SHCNTNEGATIVE",	0x40, 0x40 }
+};
+
+int
+ahd_mdffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(MDFFSTAT_parse_table, 7, "MDFFSTAT",
+	    0x5d, regvalue, cur_col, wrap));
+}
+
+int
+ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "SELOID",
+	    0x6b, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
+	{ "SEGS_AVAIL",		0x01, 0x01 },
+	{ "LOADING_NEEDED",	0x02, 0x02 },
+	{ "FETCH_INPROG",	0x04, 0x04 }
+};
+
+int
+ahd_sg_state_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SG_STATE_parse_table, 3, "SG_STATE",
+	    0xa6, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
+	{ "CCSCBRESET",		0x01, 0x01 },
+	{ "CCSCBDIR",		0x04, 0x04 },
+	{ "CCSCBEN",		0x08, 0x08 },
+	{ "CCARREN",		0x10, 0x10 },
+	{ "ARRDONE",		0x40, 0x40 },
+	{ "CCSCBDONE",		0x80, 0x80 }
+};
+
+int
+ahd_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
+	    0xad, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
+	{ "CCSGRESET",		0x01, 0x01 },
+	{ "SG_FETCH_REQ",	0x02, 0x02 },
+	{ "CCSGENACK",		0x08, 0x08 },
+	{ "SG_CACHE_AVAIL",	0x10, 0x10 },
+	{ "CCSGDONE",		0x80, 0x80 },
+	{ "CCSGEN",		0x0c, 0x0c }
+};
+
+int
+ahd_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
+	    0xad, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
+	{ "LOADRAM",		0x01, 0x01 },
+	{ "SEQRESET",		0x02, 0x02 },
+	{ "STEP",		0x04, 0x04 },
+	{ "BRKADRINTEN",	0x08, 0x08 },
+	{ "FASTMODE",		0x10, 0x10 },
+	{ "FAILDIS",		0x20, 0x20 },
+	{ "PAUSEDIS",		0x40, 0x40 },
+	{ "PERRORDIS",		0x80, 0x80 }
+};
+
+int
+ahd_seqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
+	    0xd6, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
+	{ "IRET",		0x01, 0x01 },
+	{ "INTMASK1",		0x02, 0x02 },
+	{ "INTMASK2",		0x04, 0x04 },
+	{ "SCS_SEQ_INT1M0",	0x08, 0x08 },
+	{ "SCS_SEQ_INT1M1",	0x10, 0x10 },
+	{ "INT1_CONTEXT",	0x20, 0x20 },
+	{ "INTVEC1DSL",		0x80, 0x80 }
+};
+
+int
+ahd_seqintctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQINTCTL_parse_table, 7, "SEQINTCTL",
+	    0xd9, regvalue, cur_col, wrap));
+}
+
+int
+ahd_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "QFREEZE_COUNT",
+	    0x132, regvalue, cur_col, wrap));
+}
+
+int
+ahd_kernel_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT",
+	    0x134, regvalue, cur_col, wrap));
+}
+
+int
+ahd_saved_mode_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "SAVED_MODE",
+	    0x136, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+	{ "NO_DISCONNECT",	0x01, 0x01 },
+	{ "SPHASE_PENDING",	0x02, 0x02 },
+	{ "DPHASE_PENDING",	0x04, 0x04 },
+	{ "CMDPHASE_PENDING",	0x08, 0x08 },
+	{ "TARG_CMD_PENDING",	0x10, 0x10 },
+	{ "DPHASE",		0x20, 0x20 },
+	{ "NO_CDB_SENT",	0x40, 0x40 },
+	{ "TARGET_CMD_IS_TAGGED",0x40, 0x40 },
+	{ "NOT_IDENTIFIED",	0x80, 0x80 }
+};
+
+int
+ahd_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
+	    0x139, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
+	{ "P_DATAOUT",		0x00, 0xe0 },
+	{ "P_DATAOUT_DT",	0x20, 0xe0 },
+	{ "P_DATAIN",		0x40, 0xe0 },
+	{ "P_DATAIN_DT",	0x60, 0xe0 },
+	{ "P_COMMAND",		0x80, 0xe0 },
+	{ "P_MESGOUT",		0xa0, 0xe0 },
+	{ "P_STATUS",		0xc0, 0xe0 },
+	{ "P_MESGIN",		0xe0, 0xe0 },
+	{ "P_BUSFREE",		0x01, 0x01 },
+	{ "MSGI",		0x20, 0x20 },
+	{ "IOI",		0x40, 0x40 },
+	{ "CDI",		0x80, 0x80 },
+	{ "PHASE_MASK",		0xe0, 0xe0 }
+};
+
+int
+ahd_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(LASTPHASE_parse_table, 13, "LASTPHASE",
+	    0x13c, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
+	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
+	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
+};
+
+int
+ahd_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
+	    0x14d, regvalue, cur_col, wrap));
+}
+
+int
+ahd_mk_message_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCB",
+	    0x160, regvalue, cur_col, wrap));
+}
+
+int
+ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
+	    0x162, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+	{ "SCB_TAG_TYPE",	0x03, 0x03 },
+	{ "DISCONNECTED",	0x04, 0x04 },
+	{ "STATUS_RCVD",	0x08, 0x08 },
+	{ "MK_MESSAGE",		0x10, 0x10 },
+	{ "TAG_ENB",		0x20, 0x20 },
+	{ "DISCENB",		0x40, 0x40 },
+	{ "TARGET_SCB",		0x80, 0x80 }
+};
+
+int
+ahd_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
+	    0x192, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+	{ "OID",		0x0f, 0x0f },
+	{ "TID",		0xf0, 0xf0 }
+};
+
+int
+ahd_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(SCB_SCSIID_parse_table, 2, "SCB_SCSIID",
+	    0x193, regvalue, cur_col, wrap));
+}
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	2007-10-14 15:05:07.000000000 +0100
@@ -5,7 +5,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#120 $
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#77 $
  */
-static uint8_t seqprog[] = {
+static const uint8_t seqprog[] = {
 	0xff, 0x02, 0x06, 0x78,
 	0x00, 0xea, 0x6e, 0x59,
 	0x01, 0xea, 0x04, 0x30,
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx.h linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx.h
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx.h	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx.h	2007-10-14 15:05:07.000000000 +0100
@@ -736,7 +736,7 @@ struct ahc_syncrate {
 #define		ST_SXFR	   0x010	/* Rate Single Transition Only */
 #define		DT_SXFR	   0x040	/* Rate Double Transition Only */
 	uint8_t period; /* Period to send to SCSI target */
-	char *rate;
+	const char *rate;
 };
 
 /* Safe and valid period for async negotiations. */
@@ -1143,10 +1143,6 @@ extern const int ahc_num_aic7770_devs;
 
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
-u_int			ahc_index_busy_tcl(struct ahc_softc *ahc, u_int tcl);
-void			ahc_unbusy_tcl(struct ahc_softc *ahc, u_int tcl);
-void			ahc_busy_tcl(struct ahc_softc *ahc,
-				     u_int tcl, u_int busyid);
 
 /***************************** PCI Front End *********************************/
 struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
@@ -1162,9 +1158,6 @@ int			 aic7770_config(struct ahc_softc *
 
 /************************** SCB and SCB queue management **********************/
 int		ahc_probe_scbs(struct ahc_softc *);
-void		ahc_run_untagged_queues(struct ahc_softc *ahc);
-void		ahc_run_untagged_queue(struct ahc_softc *ahc,
-				       struct scb_tailq *queue);
 void		ahc_qinfifo_requeue_tail(struct ahc_softc *ahc,
 					 struct scb *scb);
 int		ahc_match_scb(struct ahc_softc *ahc, struct scb *scb,
@@ -1183,22 +1176,8 @@ int			 ahc_suspend(struct ahc_softc *ahc
 int			 ahc_resume(struct ahc_softc *ahc);
 void			 ahc_set_unit(struct ahc_softc *, int);
 void			 ahc_set_name(struct ahc_softc *, char *);
-void			 ahc_alloc_scbs(struct ahc_softc *ahc);
 void			 ahc_free(struct ahc_softc *ahc);
 int			 ahc_reset(struct ahc_softc *ahc, int reinit);
-void			 ahc_shutdown(void *arg);
-
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
 
 /***************************** Error Recovery *********************************/
 typedef enum {
@@ -1219,36 +1198,19 @@ int			ahc_search_disc_list(struct ahc_so
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
@@ -1268,7 +1230,7 @@ void			ahc_set_width(struct ahc_softc *a
 				      u_int width, u_int type, int paused);
 void			ahc_set_syncrate(struct ahc_softc *ahc,
 					 struct ahc_devinfo *devinfo,
-					 struct ahc_syncrate *syncrate,
+					 const struct ahc_syncrate *syncrate,
 					 u_int period, u_int offset,
 					 u_int ppr_options,
 					 u_int type, int paused);
@@ -1310,11 +1272,10 @@ extern uint32_t ahc_debug;
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
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_core.c linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_core.c
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_core.c	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_core.c	2007-10-14 15:05:07.000000000 +0100
@@ -51,8 +51,7 @@
 #endif
 
 /***************************** Lookup Tables **********************************/
-char *ahc_chip_names[] =
-{
+static const char *const ahc_chip_names[] = {
 	"NONE",
 	"aic7770",
 	"aic7850",
@@ -75,10 +74,10 @@ static const u_int num_chip_names = ARRA
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
@@ -90,7 +89,7 @@ static struct ahc_hard_error_entry ahc_h
 };
 static const u_int num_errors = ARRAY_SIZE(ahc_hard_errors);
 
-static struct ahc_phase_table_entry ahc_phase_table[] =
+static const struct ahc_phase_table_entry ahc_phase_table[] =
 {
 	{ P_DATAOUT,	MSG_NOOP,		"in Data-out phase"	},
 	{ P_DATAIN,	MSG_INITIATOR_DET_ERR,	"in Data-in phase"	},
@@ -115,7 +114,7 @@ static const u_int num_phases = ARRAY_SI
  * Provides a mapping of tranfer periods in ns to the proper value to
  * stick in the scsixfer reg.
  */
-static struct ahc_syncrate ahc_syncrates[] =
+static const struct ahc_syncrate ahc_syncrates[] =
 {
       /* ultra2    fast/ultra  period     rate */
 	{ 0x42,      0x000,      9,      "80.0" },
@@ -148,7 +147,7 @@ static struct ahc_tmode_tstate*
 static void		ahc_free_tstate(struct ahc_softc *ahc,
 					u_int scsi_id, char channel, int force);
 #endif
-static struct ahc_syncrate*
+static const struct ahc_syncrate*
 			ahc_devlimited_syncrate(struct ahc_softc *ahc,
 					        struct ahc_initiator_tinfo *,
 						u_int *period,
@@ -204,9 +203,9 @@ static void		ahc_setup_target_msgin(stru
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
@@ -238,6 +237,71 @@ static int		ahc_handle_target_cmd(struct
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
@@ -247,7 +311,7 @@ static int		ahc_handle_target_cmd(struct
  * manual pause while accessing scb ram, accesses to certain registers
  * will hang the system (infinite pci retries).
  */
-void
+static void
 ahc_pause_bug_fix(struct ahc_softc *ahc)
 {
 	if ((ahc->features & AHC_ULTRA2) != 0)
@@ -304,7 +368,7 @@ ahc_unpause(struct ahc_softc *ahc)
 }
 
 /************************** Memory mapping routines ***************************/
-struct ahc_dma_seg *
+static struct ahc_dma_seg *
 ahc_sg_bus_to_virt(struct scb *scb, uint32_t sg_busaddr)
 {
 	int sg_index;
@@ -316,7 +380,7 @@ ahc_sg_bus_to_virt(struct scb *scb, uint
 	return (&scb->sg_list[sg_index]);
 }
 
-uint32_t
+static uint32_t
 ahc_sg_virt_to_bus(struct scb *scb, struct ahc_dma_seg *sg)
 {
 	int sg_index;
@@ -327,14 +391,14 @@ ahc_sg_virt_to_bus(struct scb *scb, stru
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
@@ -355,18 +419,20 @@ ahc_sync_sglist(struct ahc_softc *ahc, s
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
@@ -504,7 +570,7 @@ ahc_lookup_scb(struct ahc_softc *ahc, u_
 	return (scb);
 }
 
-void
+static void
 ahc_swap_with_next_hscb(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct hardware_scb *q_hscb;
@@ -593,7 +659,7 @@ ahc_get_sense_buf(struct ahc_softc *ahc,
 	return (&ahc->scb_data->sense[offset]);
 }
 
-uint32_t
+static uint32_t
 ahc_get_sense_bufaddr(struct ahc_softc *ahc, struct scb *scb)
 {
 	int offset;
@@ -604,14 +670,14 @@ ahc_get_sense_bufaddr(struct ahc_softc *
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
@@ -631,7 +697,7 @@ ahc_sync_tqinfifo(struct ahc_softc *ahc,
  */
 #define AHC_RUN_QOUTFIFO 0x1
 #define AHC_RUN_TQINFIFO 0x2
-u_int
+static u_int
 ahc_check_cmdcmpltqueues(struct ahc_softc *ahc)
 {
 	u_int retval;
@@ -745,7 +811,7 @@ ahc_intr(struct ahc_softc *ahc)
 /*
  * Restart the sequencer program from address zero
  */
-void
+static void
 ahc_restart(struct ahc_softc *ahc)
 {
 
@@ -806,7 +872,7 @@ ahc_restart(struct ahc_softc *ahc)
 }
 
 /************************* Input/Output Queues ********************************/
-void
+static void
 ahc_run_qoutfifo(struct ahc_softc *ahc)
 {
 	struct scb *scb;
@@ -853,7 +919,7 @@ ahc_run_qoutfifo(struct ahc_softc *ahc)
 	}
 }
 
-void
+static void
 ahc_run_untagged_queues(struct ahc_softc *ahc)
 {
 	int i;
@@ -862,7 +928,7 @@ ahc_run_untagged_queues(struct ahc_softc
 		ahc_run_untagged_queue(ahc, &ahc->untagged_queues[i]);
 }
 
-void
+static void
 ahc_run_untagged_queue(struct ahc_softc *ahc, struct scb_tailq *queue)
 {
 	struct scb *scb;
@@ -878,7 +944,7 @@ ahc_run_untagged_queue(struct ahc_softc 
 }
 
 /************************* Interrupt Handling *********************************/
-void
+static void
 ahc_handle_brkadrint(struct ahc_softc *ahc)
 {
 	/*
@@ -907,7 +973,7 @@ ahc_handle_brkadrint(struct ahc_softc *a
 	ahc_shutdown(ahc);
 }
 
-void
+static void
 ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 {
 	struct scb *scb;
@@ -1457,7 +1523,7 @@ unpause:
 	ahc_unpause(ahc);
 }
 
-void
+static void
 ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 {
 	u_int	scb_index;
@@ -1910,7 +1976,7 @@ ahc_force_renegotiation(struct ahc_softc
 }
 
 #define AHC_MAX_STEPS 2000
-void
+static void
 ahc_clear_critical_section(struct ahc_softc *ahc)
 {
 	int	stepping;
@@ -2003,7 +2069,7 @@ ahc_clear_critical_section(struct ahc_so
 /*
  * Clear any pending interrupt status.
  */
-void
+static void
 ahc_clear_intstat(struct ahc_softc *ahc)
 {
 	/* Clear any interrupt conditions this may have caused */
@@ -2022,7 +2088,8 @@ ahc_clear_intstat(struct ahc_softc *ahc)
 uint32_t ahc_debug = AHC_DEBUG_OPTS;
 #endif
 
-void
+#if 0 /* unused */
+static void
 ahc_print_scb(struct scb *scb)
 {
 	int i;
@@ -2054,6 +2121,7 @@ ahc_print_scb(struct scb *scb)
 		}
 	}
 }
+#endif
 
 /************************* Transfer Negotiation *******************************/
 /*
@@ -2137,7 +2205,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u
  * by the capabilities of the bus connectivity of and sync settings for
  * the target.
  */
-struct ahc_syncrate *
+const struct ahc_syncrate *
 ahc_devlimited_syncrate(struct ahc_softc *ahc,
 			struct ahc_initiator_tinfo *tinfo,
 			u_int *period, u_int *ppr_options, role_t role)
@@ -2192,11 +2260,11 @@ ahc_devlimited_syncrate(struct ahc_softc
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
@@ -2271,7 +2339,7 @@ ahc_find_syncrate(struct ahc_softc *ahc,
 u_int
 ahc_find_period(struct ahc_softc *ahc, u_int scsirate, u_int maxsync)
 {
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if ((ahc->features & AHC_ULTRA2) != 0)
 		scsirate &= SXFR_ULTRA2;
@@ -2309,10 +2377,10 @@ ahc_find_period(struct ahc_softc *ahc, u
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
@@ -2341,7 +2409,7 @@ ahc_validate_offset(struct ahc_softc *ah
  * Truncate the given transfer width parameter to a value the
  * current adapter type is capable of.
  */
-void
+static void
 ahc_validate_width(struct ahc_softc *ahc, struct ahc_initiator_tinfo *tinfo,
 		   u_int *bus_width, role_t role)
 {
@@ -2416,7 +2484,7 @@ ahc_update_neg_request(struct ahc_softc 
  */
 void
 ahc_set_syncrate(struct ahc_softc *ahc, struct ahc_devinfo *devinfo,
-		 struct ahc_syncrate *syncrate, u_int period,
+		 const struct ahc_syncrate *syncrate, u_int period,
 		 u_int offset, u_int ppr_options, u_int type, int paused)
 {
 	struct	ahc_initiator_tinfo *tinfo;
@@ -2723,11 +2791,11 @@ ahc_fetch_devinfo(struct ahc_softc *ahc,
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
@@ -2893,7 +2961,7 @@ ahc_build_transfer_msg(struct ahc_softc 
 	 */
 	struct	ahc_initiator_tinfo *tinfo;
 	struct	ahc_tmode_tstate *tstate;
-	struct	ahc_syncrate *rate;
+	const struct ahc_syncrate *rate;
 	int	dowide;
 	int	dosync;
 	int	doppr;
@@ -3559,7 +3627,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 		switch (ahc->msgin_buf[2]) {
 		case MSG_EXT_SDTR:
 		{
-			struct	 ahc_syncrate *syncrate;
+			const struct ahc_syncrate *syncrate;
 			u_int	 period;
 			u_int	 ppr_options;
 			u_int	 offset;
@@ -3734,7 +3802,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 		}
 		case MSG_EXT_PPR:
 		{
-			struct	ahc_syncrate *syncrate;
+			const struct ahc_syncrate *syncrate;
 			u_int	period;
 			u_int	offset;
 			u_int	bus_width;
@@ -4487,7 +4555,7 @@ ahc_free(struct ahc_softc *ahc)
 	return;
 }
 
-void
+static void
 ahc_shutdown(void *arg)
 {
 	struct	ahc_softc *ahc;
@@ -4891,7 +4959,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 		free(scb_data->scbarray, M_DEVBUF);
 }
 
-void
+static void
 ahc_alloc_scbs(struct ahc_softc *ahc)
 {
 	struct scb_data *scb_data;
@@ -5623,7 +5691,7 @@ ahc_resume(struct ahc_softc *ahc)
  * Return the untagged transaction id for a given target/channel lun.
  * Optionally, clear the entry.
  */
-u_int
+static u_int
 ahc_index_busy_tcl(struct ahc_softc *ahc, u_int tcl)
 {
 	u_int scbid;
@@ -5644,7 +5712,7 @@ ahc_index_busy_tcl(struct ahc_softc *ahc
 	return (scbid);
 }
 
-void
+static void
 ahc_unbusy_tcl(struct ahc_softc *ahc, u_int tcl)
 {
 	u_int target_offset;
@@ -5662,7 +5730,7 @@ ahc_unbusy_tcl(struct ahc_softc *ahc, u_
 	}
 }
 
-void
+static void
 ahc_busy_tcl(struct ahc_softc *ahc, u_int tcl, u_int scbid)
 {
 	u_int target_offset;
@@ -5717,7 +5785,7 @@ ahc_match_scb(struct ahc_softc *ahc, str
 	return match;
 }
 
-void
+static void
 ahc_freeze_devq(struct ahc_softc *ahc, struct scb *scb)
 {
 	int	target;
@@ -6258,7 +6326,7 @@ ahc_rem_wscb(struct ahc_softc *ahc, u_in
  * been modified from CAM_REQ_INPROG.  This routine assumes that the sequencer
  * is paused before it is called.
  */
-int
+static int
 ahc_abort_scbs(struct ahc_softc *ahc, int target, char channel,
 	       int lun, u_int tag, role_t role, uint32_t status)
 {
@@ -6580,7 +6648,7 @@ ahc_reset_channel(struct ahc_softc *ahc,
 /*
  * Calculate the residual for a just completed SCB.
  */
-void
+static void
 ahc_calc_residual(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct hardware_scb *hscb;
@@ -7047,7 +7115,7 @@ ahc_download_instr(struct ahc_softc *ahc
 }
 
 int
-ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
+ahc_print_register(const ahc_reg_parse_entry_t *table, u_int num_entries,
 		   const char *name, u_int address, u_int value,
 		   u_int *cur_column, u_int wrap_point)
 {
@@ -7731,7 +7799,7 @@ ahc_update_scsiid(struct ahc_softc *ahc,
 		ahc_outb(ahc, SCSIID, scsiid);
 }
 
-void
+static void
 ahc_run_tqinfifo(struct ahc_softc *ahc, int paused)
 {
 	struct target_cmd *cmd;
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_inline.h linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_inline.h
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_inline.h	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_inline.h	2007-10-14 15:05:07.000000000 +0100
@@ -46,58 +46,13 @@
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
@@ -109,8 +64,6 @@ ahc_name(struct ahc_softc *ahc)
 }
 
 /*********************** Miscelaneous Support Functions ***********************/
-void	ahc_update_residual(struct ahc_softc *ahc,
-			    struct scb *scb);
 struct ahc_initiator_tinfo *
 	ahc_fetch_transinfo(struct ahc_softc *ahc,
 			    char channel, u_int our_id,
@@ -133,20 +86,12 @@ struct scb*
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
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_osm.c linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_osm.c	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm.c	2007-10-14 15:05:07.000000000 +0100
@@ -2379,7 +2379,7 @@ static void ahc_linux_set_period(struct 
 	unsigned int ppr_options = tinfo->goal.ppr_options;
 	unsigned long flags;
 	unsigned long offset = tinfo->goal.offset;
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if (offset == 0)
 		offset = MAX_OFFSET;
@@ -2423,7 +2423,7 @@ static void ahc_linux_set_offset(struct 
 	unsigned int ppr_options = 0;
 	unsigned int period = 0;
 	unsigned long flags;
-	struct ahc_syncrate *syncrate = NULL;
+	const struct ahc_syncrate *syncrate = NULL;
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
@@ -2453,7 +2453,7 @@ static void ahc_linux_set_dt(struct scsi
 	unsigned int period = tinfo->goal.period;
 	unsigned int width = tinfo->goal.width;
 	unsigned long flags;
-	struct ahc_syncrate *syncrate;
+	const struct ahc_syncrate *syncrate;
 
 	if (dt && spi_max_width(starget)) {
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_osm.h linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm.h
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_osm.h	2007-10-14 15:02:44.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm.h	2007-10-14 15:05:08.000000000 +0100
@@ -398,9 +398,6 @@ struct info_str {
 	int pos;
 };
 
-void	ahc_format_transinfo(struct info_str *info,
-			     struct ahc_transinfo *tinfo);
-
 /******************************** Locking *************************************/
 /* Lock protecting internal data structures */
 
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_proc.c linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_proc.c
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_proc.c	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_proc.c	2007-10-14 15:05:08.000000000 +0100
@@ -137,7 +137,7 @@ copy_info(struct info_str *info, char *f
 	return (len);
 }
 
-void
+static void
 ahc_format_transinfo(struct info_str *info, struct ahc_transinfo *tinfo)
 {
 	u_int speed;
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped	2007-10-14 15:05:08.000000000 +0100
@@ -12,19 +12,7 @@ typedef struct ahc_reg_parse_entry {
 	uint8_t	 mask;
 } ahc_reg_parse_entry_t;
 
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiseq_print;
-#else
-#define ahc_scsiseq_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISEQ", 0x00, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sxfrctl0_print;
-#else
-#define ahc_sxfrctl0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SXFRCTL0", 0x01, regvalue, cur_col, wrap)
-#endif
+#if 0 /* unused */
 
 #if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sxfrctl1_print;
@@ -41,20 +29,6 @@ ahc_reg_print_t ahc_scsisigo_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsisigi_print;
-#else
-#define ahc_scsisigi_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISIGI", 0x03, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsirate_print;
-#else
-#define ahc_scsirate_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIRATE", 0x04, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsiid_print;
 #else
 #define ahc_scsiid_print(regvalue, cur_col, wrap) \
@@ -104,13 +78,6 @@ ahc_reg_print_t ahc_clrsint0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat0_print;
-#else
-#define ahc_sstat0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT0", 0x0b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_clrsint1_print;
 #else
 #define ahc_clrsint1_print(regvalue, cur_col, wrap) \
@@ -118,27 +85,6 @@ ahc_reg_print_t ahc_clrsint1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat1_print;
-#else
-#define ahc_sstat1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT1", 0x0c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat2_print;
-#else
-#define ahc_sstat2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT2", 0x0d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat3_print;
-#else
-#define ahc_sstat3_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT3", 0x0e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsiid_ultra2_print;
 #else
 #define ahc_scsiid_ultra2_print(regvalue, cur_col, wrap) \
@@ -146,27 +92,6 @@ ahc_reg_print_t ahc_scsiid_ultra2_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_simode0_print;
-#else
-#define ahc_simode0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SIMODE0", 0x10, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_simode1_print;
-#else
-#define ahc_simode1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SIMODE1", 0x11, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsibusl_print;
-#else
-#define ahc_scsibusl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIBUSL", 0x12, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsibush_print;
 #else
 #define ahc_scsibush_print(regvalue, cur_col, wrap) \
@@ -237,13 +162,6 @@ ahc_reg_print_t ahc_seectl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sblkctl_print;
-#else
-#define ahc_sblkctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SBLKCTL", 0x1f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_busy_targets_print;
 #else
 #define ahc_busy_targets_print(regvalue, cur_col, wrap) \
@@ -300,13 +218,6 @@ ahc_reg_print_t ahc_dmaparams_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seq_flags_print;
-#else
-#define ahc_seq_flags_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQ_FLAGS", 0x3c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_saved_scsiid_print;
 #else
 #define ahc_saved_scsiid_print(regvalue, cur_col, wrap) \
@@ -321,13 +232,6 @@ ahc_reg_print_t ahc_saved_lun_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_lastphase_print;
-#else
-#define ahc_lastphase_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "LASTPHASE", 0x3f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_waiting_scbh_print;
 #else
 #define ahc_waiting_scbh_print(regvalue, cur_col, wrap) \
@@ -475,13 +379,6 @@ ahc_reg_print_t ahc_ha_274_biosctrl_prin
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqctl_print;
-#else
-#define ahc_seqctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQCTL", 0x60, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_seqram_print;
 #else
 #define ahc_seqram_print(regvalue, cur_col, wrap) \
@@ -685,27 +582,6 @@ ahc_reg_print_t ahc_clrint_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_error_print;
-#else
-#define ahc_error_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ERROR", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfcntrl_print;
-#else
-#define ahc_dfcntrl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFCNTRL", 0x93, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfstatus_print;
-#else
-#define ahc_dfstatus_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFSTATUS", 0x94, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_dfwaddr_print;
 #else
 #define ahc_dfwaddr_print(regvalue, cur_col, wrap) \
@@ -769,13 +645,6 @@ ahc_reg_print_t ahc_qoutcnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiphase_print;
-#else
-#define ahc_scsiphase_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIPHASE", 0x9e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sfunct_print;
 #else
 #define ahc_sfunct_print(regvalue, cur_col, wrap) \
@@ -853,34 +722,6 @@ ahc_reg_print_t ahc_scb_sgptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_control_print;
-#else
-#define ahc_scb_control_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_CONTROL", 0xb8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_scsiid_print;
-#else
-#define ahc_scb_scsiid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_SCSIID", 0xb9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_lun_print;
-#else
-#define ahc_scb_lun_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_LUN", 0xba, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_tag_print;
-#else
-#define ahc_scb_tag_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_TAG", 0xbb, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scb_cdb_len_print;
 #else
 #define ahc_scb_cdb_len_print(regvalue, cur_col, wrap) \
@@ -1062,6 +903,169 @@ ahc_reg_print_t ahc_sg_cache_pre_print;
     ahc_print_register(NULL, 0, "SG_CACHE_PRE", 0xfc, regvalue, cur_col, wrap)
 #endif
 
+#endif /* unused */
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scsiseq_print;
+#else
+#define ahc_scsiseq_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCSISEQ", 0x00, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_sxfrctl0_print;
+#else
+#define ahc_sxfrctl0_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SXFRCTL0", 0x01, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scsisigi_print;
+#else
+#define ahc_scsisigi_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCSISIGI", 0x03, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scsirate_print;
+#else
+#define ahc_scsirate_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCSIRATE", 0x04, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_sstat0_print;
+#else
+#define ahc_sstat0_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SSTAT0", 0x0b, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_sstat1_print;
+#else
+#define ahc_sstat1_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SSTAT1", 0x0c, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_sstat2_print;
+#else
+#define ahc_sstat2_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SSTAT2", 0x0d, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_sstat3_print;
+#else
+#define ahc_sstat3_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SSTAT3", 0x0e, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_simode0_print;
+#else
+#define ahc_simode0_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SIMODE0", 0x10, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_simode1_print;
+#else
+#define ahc_simode1_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SIMODE1", 0x11, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scsibusl_print;
+#else
+#define ahc_scsibusl_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCSIBUSL", 0x12, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_sblkctl_print;
+#else
+#define ahc_sblkctl_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SBLKCTL", 0x1f, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_seq_flags_print;
+#else
+#define ahc_seq_flags_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SEQ_FLAGS", 0x3c, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_lastphase_print;
+#else
+#define ahc_lastphase_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "LASTPHASE", 0x3f, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_seqctl_print;
+#else
+#define ahc_seqctl_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SEQCTL", 0x60, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_error_print;
+#else
+#define ahc_error_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "ERROR", 0x92, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_dfcntrl_print;
+#else
+#define ahc_dfcntrl_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "DFCNTRL", 0x93, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_dfstatus_print;
+#else
+#define ahc_dfstatus_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "DFSTATUS", 0x94, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scsiphase_print;
+#else
+#define ahc_scsiphase_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCSIPHASE", 0x9e, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scb_control_print;
+#else
+#define ahc_scb_control_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCB_CONTROL", 0xb8, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scb_scsiid_print;
+#else
+#define ahc_scb_scsiid_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCB_SCSIID", 0xb9, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scb_lun_print;
+#else
+#define ahc_scb_lun_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCB_LUN", 0xba, regvalue, cur_col, wrap)
+#endif
+
+#if AIC_DEBUG_REGISTERS
+ahc_reg_print_t ahc_scb_tag_print;
+#else
+#define ahc_scb_tag_print(regvalue, cur_col, wrap) \
+    ahc_print_register(NULL, 0, "SCB_TAG", 0xbb, regvalue, cur_col, wrap)
+#endif
+
 
 #define	SCSISEQ         		0x00
 #define		TEMODE          	0x80
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped	2007-10-14 15:05:08.000000000 +0100
@@ -8,42 +8,8 @@
 
 #include "aic7xxx_osm.h"
 
-static ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
-	{ "SCSIRSTO",		0x01, 0x01 },
-	{ "ENAUTOATNP",		0x02, 0x02 },
-	{ "ENAUTOATNI",		0x04, 0x04 },
-	{ "ENAUTOATNO",		0x08, 0x08 },
-	{ "ENRSELI",		0x10, 0x10 },
-	{ "ENSELI",		0x20, 0x20 },
-	{ "ENSELO",		0x40, 0x40 },
-	{ "TEMODE",		0x80, 0x80 }
-};
-
-int
-ahc_scsiseq_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSISEQ_parse_table, 8, "SCSISEQ",
-	    0x00, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
-	{ "CLRCHN",		0x02, 0x02 },
-	{ "SCAMEN",		0x04, 0x04 },
-	{ "SPIOEN",		0x08, 0x08 },
-	{ "CLRSTCNT",		0x10, 0x10 },
-	{ "FAST20",		0x20, 0x20 },
-	{ "DFPEXP",		0x40, 0x40 },
-	{ "DFON",		0x80, 0x80 }
-};
-
-int
-ahc_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SXFRCTL0_parse_table, 7, "SXFRCTL0",
-	    0x01, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SXFRCTL1_parse_table[] = {
+#if 0 /* unused */
+static const ahc_reg_parse_entry_t SXFRCTL1_parse_table[] = {
 	{ "STPWEN",		0x01, 0x01 },
 	{ "ACTNEGEN",		0x02, 0x02 },
 	{ "ENSTIMER",		0x04, 0x04 },
@@ -60,7 +26,7 @@ ahc_sxfrctl1_print(u_int regvalue, u_int
 	    0x02, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISIGO_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISIGO_parse_table[] = {
 	{ "ACKO",		0x01, 0x01 },
 	{ "REQO",		0x02, 0x02 },
 	{ "BSYO",		0x04, 0x04 },
@@ -85,50 +51,7 @@ ahc_scsisigo_print(u_int regvalue, u_int
 	    0x03, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
-	{ "ACKI",		0x01, 0x01 },
-	{ "REQI",		0x02, 0x02 },
-	{ "BSYI",		0x04, 0x04 },
-	{ "SELI",		0x08, 0x08 },
-	{ "ATNI",		0x10, 0x10 },
-	{ "MSGI",		0x20, 0x20 },
-	{ "IOI",		0x40, 0x40 },
-	{ "CDI",		0x80, 0x80 },
-	{ "P_DATAOUT",		0x00, 0x00 },
-	{ "P_DATAOUT_DT",	0x20, 0x20 },
-	{ "P_DATAIN",		0x40, 0x40 },
-	{ "P_DATAIN_DT",	0x60, 0x60 },
-	{ "P_COMMAND",		0x80, 0x80 },
-	{ "P_MESGOUT",		0xa0, 0xa0 },
-	{ "P_STATUS",		0xc0, 0xc0 },
-	{ "PHASE_MASK",		0xe0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 }
-};
-
-int
-ahc_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
-	    0x03, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
-	{ "SINGLE_EDGE",	0x10, 0x10 },
-	{ "ENABLE_CRC",		0x40, 0x40 },
-	{ "WIDEXFER",		0x80, 0x80 },
-	{ "SXFR_ULTRA2",	0x0f, 0x0f },
-	{ "SOFS",		0x0f, 0x0f },
-	{ "SXFR",		0x70, 0x70 }
-};
-
-int
-ahc_scsirate_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIRATE_parse_table, 6, "SCSIRATE",
-	    0x04, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCSIID_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIID_parse_table[] = {
 	{ "TWIN_CHNLB",		0x80, 0x80 },
 	{ "OID",		0x0f, 0x0f },
 	{ "TWIN_TID",		0x70, 0x70 },
@@ -164,7 +87,7 @@ ahc_stcnt_print(u_int regvalue, u_int *c
 	    0x08, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t OPTIONMODE_parse_table[] = {
+static const ahc_reg_parse_entry_t OPTIONMODE_parse_table[] = {
 	{ "DIS_MSGIN_DUALEDGE",	0x01, 0x01 },
 	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
 	{ "SCSIDATL_IMGEN",	0x04, 0x04 },
@@ -190,7 +113,7 @@ ahc_targcrccnt_print(u_int regvalue, u_i
 	    0x0a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CLRSINT0_parse_table[] = {
+static const ahc_reg_parse_entry_t CLRSINT0_parse_table[] = {
 	{ "CLRSPIORDY",		0x02, 0x02 },
 	{ "CLRSWRAP",		0x08, 0x08 },
 	{ "CLRIOERR",		0x08, 0x08 },
@@ -206,26 +129,7 @@ ahc_clrsint0_print(u_int regvalue, u_int
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
-	{ "DMADONE",		0x01, 0x01 },
-	{ "SPIORDY",		0x02, 0x02 },
-	{ "SDONE",		0x04, 0x04 },
-	{ "SWRAP",		0x08, 0x08 },
-	{ "IOERR",		0x08, 0x08 },
-	{ "SELINGO",		0x10, 0x10 },
-	{ "SELDI",		0x20, 0x20 },
-	{ "SELDO",		0x40, 0x40 },
-	{ "TARGET",		0x80, 0x80 }
-};
-
-int
-ahc_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SSTAT0_parse_table, 9, "SSTAT0",
-	    0x0b, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t CLRSINT1_parse_table[] = {
+static const ahc_reg_parse_entry_t CLRSINT1_parse_table[] = {
 	{ "CLRREQINIT",		0x01, 0x01 },
 	{ "CLRPHASECHG",	0x02, 0x02 },
 	{ "CLRSCSIPERR",	0x04, 0x04 },
@@ -242,56 +146,7 @@ ahc_clrsint1_print(u_int regvalue, u_int
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
-	{ "REQINIT",		0x01, 0x01 },
-	{ "PHASECHG",		0x02, 0x02 },
-	{ "SCSIPERR",		0x04, 0x04 },
-	{ "BUSFREE",		0x08, 0x08 },
-	{ "PHASEMIS",		0x10, 0x10 },
-	{ "SCSIRSTI",		0x20, 0x20 },
-	{ "ATNTARG",		0x40, 0x40 },
-	{ "SELTO",		0x80, 0x80 }
-};
-
-int
-ahc_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SSTAT1_parse_table, 8, "SSTAT1",
-	    0x0c, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
-	{ "DUAL_EDGE_ERR",	0x01, 0x01 },
-	{ "CRCREQERR",		0x02, 0x02 },
-	{ "CRCENDERR",		0x04, 0x04 },
-	{ "CRCVALERR",		0x08, 0x08 },
-	{ "EXP_ACTIVE",		0x10, 0x10 },
-	{ "SHVALID",		0x40, 0x40 },
-	{ "OVERRUN",		0x80, 0x80 },
-	{ "SFCNT",		0x1f, 0x1f }
-};
-
-int
-ahc_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SSTAT2_parse_table, 8, "SSTAT2",
-	    0x0d, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
-	{ "OFFCNT",		0x0f, 0x0f },
-	{ "U2OFFCNT",		0x7f, 0x7f },
-	{ "SCSICNT",		0xf0, 0xf0 }
-};
-
-int
-ahc_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SSTAT3_parse_table, 3, "SSTAT3",
-	    0x0e, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCSIID_ULTRA2_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIID_ULTRA2_parse_table[] = {
 	{ "OID",		0x0f, 0x0f },
 	{ "TID",		0xf0, 0xf0 }
 };
@@ -303,49 +158,6 @@ ahc_scsiid_ultra2_print(u_int regvalue, 
 	    0x0f, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
-	{ "ENDMADONE",		0x01, 0x01 },
-	{ "ENSPIORDY",		0x02, 0x02 },
-	{ "ENSDONE",		0x04, 0x04 },
-	{ "ENSWRAP",		0x08, 0x08 },
-	{ "ENIOERR",		0x08, 0x08 },
-	{ "ENSELINGO",		0x10, 0x10 },
-	{ "ENSELDI",		0x20, 0x20 },
-	{ "ENSELDO",		0x40, 0x40 }
-};
-
-int
-ahc_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SIMODE0_parse_table, 8, "SIMODE0",
-	    0x10, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
-	{ "ENREQINIT",		0x01, 0x01 },
-	{ "ENPHASECHG",		0x02, 0x02 },
-	{ "ENSCSIPERR",		0x04, 0x04 },
-	{ "ENBUSFREE",		0x08, 0x08 },
-	{ "ENPHASEMIS",		0x10, 0x10 },
-	{ "ENSCSIRST",		0x20, 0x20 },
-	{ "ENATNTARG",		0x40, 0x40 },
-	{ "ENSELTIMO",		0x80, 0x80 }
-};
-
-int
-ahc_simode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SIMODE1_parse_table, 8, "SIMODE1",
-	    0x11, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scsibusl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCSIBUSL",
-	    0x12, regvalue, cur_col, wrap));
-}
-
 int
 ahc_scsibush_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -353,7 +165,7 @@ ahc_scsibush_print(u_int regvalue, u_int
 	    0x13, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SXFRCTL2_parse_table[] = {
+static const ahc_reg_parse_entry_t SXFRCTL2_parse_table[] = {
 	{ "CMDDMAEN",		0x08, 0x08 },
 	{ "AUTORSTDIS",		0x10, 0x10 },
 	{ "ASYNC_SETUP",	0x07, 0x07 }
@@ -373,7 +185,7 @@ ahc_shaddr_print(u_int regvalue, u_int *
 	    0x14, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SELTIMER_parse_table[] = {
+static const ahc_reg_parse_entry_t SELTIMER_parse_table[] = {
 	{ "STAGE1",		0x01, 0x01 },
 	{ "STAGE2",		0x02, 0x02 },
 	{ "STAGE3",		0x04, 0x04 },
@@ -389,7 +201,7 @@ ahc_seltimer_print(u_int regvalue, u_int
 	    0x18, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SELID_parse_table[] = {
+static const ahc_reg_parse_entry_t SELID_parse_table[] = {
 	{ "ONEBIT",		0x08, 0x08 },
 	{ "SELID_MASK",		0xf0, 0xf0 }
 };
@@ -401,7 +213,7 @@ ahc_selid_print(u_int regvalue, u_int *c
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCAMCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SCAMCTL_parse_table[] = {
 	{ "DFLTTID",		0x10, 0x10 },
 	{ "ALTSTIM",		0x20, 0x20 },
 	{ "CLRSCAMSELID",	0x40, 0x40 },
@@ -423,7 +235,7 @@ ahc_targid_print(u_int regvalue, u_int *
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SPIOCAP_parse_table[] = {
+static const ahc_reg_parse_entry_t SPIOCAP_parse_table[] = {
 	{ "SSPIOCPS",		0x01, 0x01 },
 	{ "ROM",		0x02, 0x02 },
 	{ "EEPROM",		0x04, 0x04 },
@@ -441,7 +253,7 @@ ahc_spiocap_print(u_int regvalue, u_int 
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BRDCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t BRDCTL_parse_table[] = {
 	{ "BRDCTL0",		0x01, 0x01 },
 	{ "BRDSTB_ULTRA2",	0x01, 0x01 },
 	{ "BRDCTL1",		0x02, 0x02 },
@@ -464,7 +276,7 @@ ahc_brdctl_print(u_int regvalue, u_int *
 	    0x1d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEECTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SEECTL_parse_table[] = {
 	{ "SEEDI",		0x01, 0x01 },
 	{ "SEEDO",		0x02, 0x02 },
 	{ "SEECK",		0x04, 0x04 },
@@ -482,24 +294,6 @@ ahc_seectl_print(u_int regvalue, u_int *
 	    0x1e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
-	{ "XCVR",		0x01, 0x01 },
-	{ "SELWIDE",		0x02, 0x02 },
-	{ "ENAB20",		0x04, 0x04 },
-	{ "SELBUSB",		0x08, 0x08 },
-	{ "ENAB40",		0x08, 0x08 },
-	{ "AUTOFLUSHDIS",	0x20, 0x20 },
-	{ "DIAGLEDON",		0x40, 0x40 },
-	{ "DIAGLEDEN",		0x80, 0x80 }
-};
-
-int
-ahc_sblkctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SBLKCTL_parse_table, 8, "SBLKCTL",
-	    0x1f, regvalue, cur_col, wrap));
-}
-
 int
 ahc_busy_targets_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -549,7 +343,7 @@ ahc_msg_out_print(u_int regvalue, u_int 
 	    0x3a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
+static const ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -569,25 +363,6 @@ ahc_dmaparams_print(u_int regvalue, u_in
 	    0x3b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
-	{ "NO_DISCONNECT",	0x01, 0x01 },
-	{ "SPHASE_PENDING",	0x02, 0x02 },
-	{ "DPHASE_PENDING",	0x04, 0x04 },
-	{ "CMDPHASE_PENDING",	0x08, 0x08 },
-	{ "TARG_CMD_PENDING",	0x10, 0x10 },
-	{ "DPHASE",		0x20, 0x20 },
-	{ "NO_CDB_SENT",	0x40, 0x40 },
-	{ "TARGET_CMD_IS_TAGGED",0x40, 0x40 },
-	{ "NOT_IDENTIFIED",	0x80, 0x80 }
-};
-
-int
-ahc_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
-	    0x3c, regvalue, cur_col, wrap));
-}
-
 int
 ahc_saved_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -602,27 +377,6 @@ ahc_saved_lun_print(u_int regvalue, u_in
 	    0x3e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
-	{ "MSGI",		0x20, 0x20 },
-	{ "IOI",		0x40, 0x40 },
-	{ "CDI",		0x80, 0x80 },
-	{ "P_DATAOUT",		0x00, 0x00 },
-	{ "P_BUSFREE",		0x01, 0x01 },
-	{ "P_DATAIN",		0x40, 0x40 },
-	{ "P_COMMAND",		0x80, 0x80 },
-	{ "P_MESGOUT",		0xa0, 0xa0 },
-	{ "P_STATUS",		0xc0, 0xc0 },
-	{ "PHASE_MASK",		0xe0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 }
-};
-
-int
-ahc_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(LASTPHASE_parse_table, 11, "LASTPHASE",
-	    0x3f, regvalue, cur_col, wrap));
-}
-
 int
 ahc_waiting_scbh_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -700,7 +454,7 @@ ahc_tqinpos_print(u_int regvalue, u_int 
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t ARG_1_parse_table[] = {
+static const ahc_reg_parse_entry_t ARG_1_parse_table[] = {
 	{ "CONT_TARG_SESSION",	0x02, 0x02 },
 	{ "CONT_MSG_LOOP",	0x04, 0x04 },
 	{ "EXIT_MSG_LOOP",	0x08, 0x08 },
@@ -731,7 +485,7 @@ ahc_last_msg_print(u_int regvalue, u_int
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
 	{ "ENAUTOATNO",		0x08, 0x08 },
@@ -747,7 +501,7 @@ ahc_scsiseq_template_print(u_int regvalu
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
+static const ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
 	{ "HA_274_EXTENDED_TRANS",0x01, 0x01 }
 };
 
@@ -758,7 +512,7 @@ ahc_ha_274_biosglobal_print(u_int regval
 	    0x56, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
 	{ "SCB_DMA",		0x01, 0x01 },
 	{ "TARGET_MSG_PENDING",	0x02, 0x02 }
 };
@@ -770,7 +524,7 @@ ahc_seq_flags2_print(u_int regvalue, u_i
 	    0x57, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
 	{ "ENSPCHK",		0x20, 0x20 },
 	{ "RESET_SCSI",		0x40, 0x40 },
 	{ "TERM_ENB",		0x80, 0x80 },
@@ -785,7 +539,7 @@ ahc_scsiconf_print(u_int regvalue, u_int
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t INTDEF_parse_table[] = {
+static const ahc_reg_parse_entry_t INTDEF_parse_table[] = {
 	{ "EDGE_TRIG",		0x80, 0x80 },
 	{ "VECTOR",		0x0f, 0x0f }
 };
@@ -804,7 +558,7 @@ ahc_hostconf_print(u_int regvalue, u_int
 	    0x5d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
 	{ "CHANNEL_B_PRIMARY",	0x08, 0x08 },
 	{ "BIOSMODE",		0x30, 0x30 },
 	{ "BIOSDISABLED",	0x30, 0x30 }
@@ -817,24 +571,6 @@ ahc_ha_274_biosctrl_print(u_int regvalue
 	    0x5f, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
-	{ "LOADRAM",		0x01, 0x01 },
-	{ "SEQRESET",		0x02, 0x02 },
-	{ "STEP",		0x04, 0x04 },
-	{ "BRKADRINTEN",	0x08, 0x08 },
-	{ "FASTMODE",		0x10, 0x10 },
-	{ "FAILDIS",		0x20, 0x20 },
-	{ "PAUSEDIS",		0x40, 0x40 },
-	{ "PERRORDIS",		0x80, 0x80 }
-};
-
-int
-ahc_seqctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEQCTL_parse_table, 8, "SEQCTL",
-	    0x60, regvalue, cur_col, wrap));
-}
-
 int
 ahc_seqram_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -849,7 +585,7 @@ ahc_seqaddr0_print(u_int regvalue, u_int
 	    0x62, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQADDR1_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQADDR1_parse_table[] = {
 	{ "SEQADDR1_MASK",	0x01, 0x01 }
 };
 
@@ -902,7 +638,7 @@ ahc_none_print(u_int regvalue, u_int *cu
 	    0x6a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t FLAGS_parse_table[] = {
+static const ahc_reg_parse_entry_t FLAGS_parse_table[] = {
 	{ "CARRY",		0x01, 0x01 },
 	{ "ZERO",		0x02, 0x02 }
 };
@@ -956,7 +692,7 @@ ahc_sram_base_print(u_int regvalue, u_in
 	    0x70, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t BCTL_parse_table[] = {
 	{ "ENABLE",		0x01, 0x01 },
 	{ "ACE",		0x08, 0x08 }
 };
@@ -968,7 +704,7 @@ ahc_bctl_print(u_int regvalue, u_int *cu
 	    0x84, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
+static const ahc_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
 	{ "CIOPARCKEN",		0x01, 0x01 },
 	{ "USCBSIZE32",		0x02, 0x02 },
 	{ "RAMPS",		0x04, 0x04 },
@@ -986,7 +722,7 @@ ahc_dscommand0_print(u_int regvalue, u_i
 	    0x84, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BUSTIME_parse_table[] = {
+static const ahc_reg_parse_entry_t BUSTIME_parse_table[] = {
 	{ "BON",		0x0f, 0x0f },
 	{ "BOFF",		0xf0, 0xf0 }
 };
@@ -998,7 +734,7 @@ ahc_bustime_print(u_int regvalue, u_int 
 	    0x85, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DSCOMMAND1_parse_table[] = {
+static const ahc_reg_parse_entry_t DSCOMMAND1_parse_table[] = {
 	{ "HADDLDSEL0",		0x01, 0x01 },
 	{ "HADDLDSEL1",		0x02, 0x02 },
 	{ "DSLATT",		0xfc, 0xfc }
@@ -1011,7 +747,7 @@ ahc_dscommand1_print(u_int regvalue, u_i
 	    0x85, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BUSSPD_parse_table[] = {
+static const ahc_reg_parse_entry_t BUSSPD_parse_table[] = {
 	{ "STBON",		0x07, 0x07 },
 	{ "STBOFF",		0x38, 0x38 },
 	{ "DFTHRSH_75",		0x80, 0x80 },
@@ -1026,7 +762,7 @@ ahc_busspd_print(u_int regvalue, u_int *
 	    0x86, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
+static const ahc_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
 	{ "SEQ_MAILBOX",	0x0f, 0x0f },
 	{ "HOST_TQINPOS",	0x80, 0x80 },
 	{ "HOST_MAILBOX",	0xf0, 0xf0 }
@@ -1039,7 +775,7 @@ ahc_hs_mailbox_print(u_int regvalue, u_i
 	    0x86, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DSPCISTATUS_parse_table[] = {
+static const ahc_reg_parse_entry_t DSPCISTATUS_parse_table[] = {
 	{ "DFTHRSH_100",	0xc0, 0xc0 }
 };
 
@@ -1050,7 +786,7 @@ ahc_dspcistatus_print(u_int regvalue, u_
 	    0x86, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HCNTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t HCNTRL_parse_table[] = {
 	{ "CHIPRST",		0x01, 0x01 },
 	{ "CHIPRSTACK",		0x01, 0x01 },
 	{ "INTEN",		0x02, 0x02 },
@@ -1088,7 +824,7 @@ ahc_scbptr_print(u_int regvalue, u_int *
 	    0x90, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t INTSTAT_parse_table[] = {
+static const ahc_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "SEQINT",		0x01, 0x01 },
 	{ "CMDCMPLT",		0x02, 0x02 },
 	{ "SCSIINT",		0x04, 0x04 },
@@ -1119,7 +855,7 @@ ahc_intstat_print(u_int regvalue, u_int 
 	    0x91, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CLRINT_parse_table[] = {
+static const ahc_reg_parse_entry_t CLRINT_parse_table[] = {
 	{ "CLRSEQINT",		0x01, 0x01 },
 	{ "CLRCMDINT",		0x02, 0x02 },
 	{ "CLRSCSIINT",		0x04, 0x04 },
@@ -1134,62 +870,6 @@ ahc_clrint_print(u_int regvalue, u_int *
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t ERROR_parse_table[] = {
-	{ "ILLHADDR",		0x01, 0x01 },
-	{ "ILLSADDR",		0x02, 0x02 },
-	{ "ILLOPCODE",		0x04, 0x04 },
-	{ "SQPARERR",		0x08, 0x08 },
-	{ "DPARERR",		0x10, 0x10 },
-	{ "MPARERR",		0x20, 0x20 },
-	{ "PCIERRSTAT",		0x40, 0x40 },
-	{ "CIOPARERR",		0x80, 0x80 }
-};
-
-int
-ahc_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(ERROR_parse_table, 8, "ERROR",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
-	{ "FIFORESET",		0x01, 0x01 },
-	{ "FIFOFLUSH",		0x02, 0x02 },
-	{ "DIRECTION",		0x04, 0x04 },
-	{ "HDMAEN",		0x08, 0x08 },
-	{ "HDMAENACK",		0x08, 0x08 },
-	{ "SDMAEN",		0x10, 0x10 },
-	{ "SDMAENACK",		0x10, 0x10 },
-	{ "SCSIEN",		0x20, 0x20 },
-	{ "WIDEODD",		0x40, 0x40 },
-	{ "PRELOADEN",		0x80, 0x80 }
-};
-
-int
-ahc_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
-	    0x93, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
-	{ "FIFOEMP",		0x01, 0x01 },
-	{ "FIFOFULL",		0x02, 0x02 },
-	{ "DFTHRESH",		0x04, 0x04 },
-	{ "HDONE",		0x08, 0x08 },
-	{ "MREQPEND",		0x10, 0x10 },
-	{ "FIFOQWDEMP",		0x20, 0x20 },
-	{ "DFCACHETH",		0x40, 0x40 },
-	{ "PRELOAD_AVAIL",	0x80, 0x80 }
-};
-
-int
-ahc_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
-	    0x94, regvalue, cur_col, wrap));
-}
-
 int
 ahc_dfwaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1211,7 +891,7 @@ ahc_dfdat_print(u_int regvalue, u_int *c
 	    0x99, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCBCNT_parse_table[] = {
+static const ahc_reg_parse_entry_t SCBCNT_parse_table[] = {
 	{ "SCBAUTO",		0x80, 0x80 },
 	{ "SCBCNT_MASK",	0x1f, 0x1f }
 };
@@ -1244,7 +924,7 @@ ahc_qoutfifo_print(u_int regvalue, u_int
 	    0x9d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CRCCONTROL1_parse_table[] = {
+static const ahc_reg_parse_entry_t CRCCONTROL1_parse_table[] = {
 	{ "TARGCRCCNTEN",	0x04, 0x04 },
 	{ "TARGCRCENDEN",	0x08, 0x08 },
 	{ "CRCREQCHKEN",	0x10, 0x10 },
@@ -1267,24 +947,7 @@ ahc_qoutcnt_print(u_int regvalue, u_int 
 	    0x9e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
-	{ "DATA_OUT_PHASE",	0x01, 0x01 },
-	{ "DATA_IN_PHASE",	0x02, 0x02 },
-	{ "MSG_OUT_PHASE",	0x04, 0x04 },
-	{ "MSG_IN_PHASE",	0x08, 0x08 },
-	{ "COMMAND_PHASE",	0x10, 0x10 },
-	{ "STATUS_PHASE",	0x20, 0x20 },
-	{ "DATA_PHASE_MASK",	0x03, 0x03 }
-};
-
-int
-ahc_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
-	    0x9e, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SFUNCT_parse_table[] = {
+static const ahc_reg_parse_entry_t SFUNCT_parse_table[] = {
 	{ "ALT_MODE",		0x80, 0x80 }
 };
 
@@ -1351,7 +1014,7 @@ ahc_scb_dataptr_print(u_int regvalue, u_
 	    0xac, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
 	{ "SG_LAST_SEG",	0x80, 0x80 },
 	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f }
 };
@@ -1363,7 +1026,7 @@ ahc_scb_datacnt_print(u_int regvalue, u_
 	    0xb0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_FULL_RESID",	0x02, 0x02 },
 	{ "SG_RESID_VALID",	0x04, 0x04 }
@@ -1376,57 +1039,6 @@ ahc_scb_sgptr_print(u_int regvalue, u_in
 	    0xb4, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
-	{ "DISCONNECTED",	0x04, 0x04 },
-	{ "ULTRAENB",		0x08, 0x08 },
-	{ "MK_MESSAGE",		0x10, 0x10 },
-	{ "TAG_ENB",		0x20, 0x20 },
-	{ "DISCENB",		0x40, 0x40 },
-	{ "TARGET_SCB",		0x80, 0x80 },
-	{ "STATUS_RCVD",	0x80, 0x80 },
-	{ "SCB_TAG_TYPE",	0x03, 0x03 }
-};
-
-int
-ahc_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCB_CONTROL_parse_table, 8, "SCB_CONTROL",
-	    0xb8, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
-	{ "TWIN_CHNLB",		0x80, 0x80 },
-	{ "OID",		0x0f, 0x0f },
-	{ "TWIN_TID",		0x70, 0x70 },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahc_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCB_SCSIID_parse_table, 4, "SCB_SCSIID",
-	    0xb9, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
-	{ "SCB_XFERLEN_ODD",	0x80, 0x80 },
-	{ "LID",		0x3f, 0x3f }
-};
-
-int
-ahc_scb_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCB_LUN_parse_table, 2, "SCB_LUN",
-	    0xba, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_TAG",
-	    0xbb, regvalue, cur_col, wrap));
-}
-
 int
 ahc_scb_cdb_len_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1462,7 +1074,7 @@ ahc_scb_64_spare_print(u_int regvalue, u
 	    0xc0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEECTL_2840_parse_table[] = {
+static const ahc_reg_parse_entry_t SEECTL_2840_parse_table[] = {
 	{ "DO_2840",		0x01, 0x01 },
 	{ "CK_2840",		0x02, 0x02 },
 	{ "CS_2840",		0x04, 0x04 }
@@ -1475,7 +1087,7 @@ ahc_seectl_2840_print(u_int regvalue, u_
 	    0xc0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t STATUS_2840_parse_table[] = {
+static const ahc_reg_parse_entry_t STATUS_2840_parse_table[] = {
 	{ "DI_2840",		0x01, 0x01 },
 	{ "EEPROM_TF",		0x80, 0x80 },
 	{ "ADSEL",		0x1e, 0x1e },
@@ -1524,7 +1136,7 @@ ahc_ccsgaddr_print(u_int regvalue, u_int
 	    0xea, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CCSGCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t CCSGCTL_parse_table[] = {
 	{ "CCSGRESET",		0x01, 0x01 },
 	{ "SG_FETCH_NEEDED",	0x02, 0x02 },
 	{ "CCSGEN",		0x08, 0x08 },
@@ -1552,7 +1164,7 @@ ahc_ccscbaddr_print(u_int regvalue, u_in
 	    0xed, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CCSCBCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t CCSCBCTL_parse_table[] = {
 	{ "CCSCBRESET",		0x01, 0x01 },
 	{ "CCSCBDIR",		0x04, 0x04 },
 	{ "CCSCBEN",		0x08, 0x08 },
@@ -1610,7 +1222,7 @@ ahc_sdscb_qoff_print(u_int regvalue, u_i
 	    0xf8, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
+static const ahc_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
 	{ "SDSCB_ROLLOVER",	0x10, 0x10 },
 	{ "SNSCB_ROLLOVER",	0x20, 0x20 },
 	{ "SCB_AVAIL",		0x40, 0x40 },
@@ -1625,7 +1237,7 @@ ahc_qoff_ctlsta_print(u_int regvalue, u_
 	    0xfa, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DFF_THRSH_parse_table[] = {
+static const ahc_reg_parse_entry_t DFF_THRSH_parse_table[] = {
 	{ "RD_DFTHRSH_MIN",	0x00, 0x00 },
 	{ "WR_DFTHRSH_MIN",	0x00, 0x00 },
 	{ "RD_DFTHRSH_25",	0x01, 0x01 },
@@ -1653,7 +1265,7 @@ ahc_dff_thrsh_print(u_int regvalue, u_in
 	    0xfb, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
+static const ahc_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -1666,7 +1278,7 @@ ahc_sg_cache_shadow_print(u_int regvalue
 	    0xfc, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
+static const ahc_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -1678,4 +1290,395 @@ ahc_sg_cache_pre_print(u_int regvalue, u
 	return (ahc_print_register(SG_CACHE_PRE_parse_table, 3, "SG_CACHE_PRE",
 	    0xfc, regvalue, cur_col, wrap));
 }
+#endif /* unused */
+
+
+static const ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
+	{ "SCSIRSTO",		0x01, 0x01 },
+	{ "ENAUTOATNP",		0x02, 0x02 },
+	{ "ENAUTOATNI",		0x04, 0x04 },
+	{ "ENAUTOATNO",		0x08, 0x08 },
+	{ "ENRSELI",		0x10, 0x10 },
+	{ "ENSELI",		0x20, 0x20 },
+	{ "ENSELO",		0x40, 0x40 },
+	{ "TEMODE",		0x80, 0x80 }
+};
+
+int
+ahc_scsiseq_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCSISEQ_parse_table, 8, "SCSISEQ",
+	    0x00, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
+	{ "CLRCHN",		0x02, 0x02 },
+	{ "SCAMEN",		0x04, 0x04 },
+	{ "SPIOEN",		0x08, 0x08 },
+	{ "CLRSTCNT",		0x10, 0x10 },
+	{ "FAST20",		0x20, 0x20 },
+	{ "DFPEXP",		0x40, 0x40 },
+	{ "DFON",		0x80, 0x80 }
+};
+
+int
+ahc_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SXFRCTL0_parse_table, 7, "SXFRCTL0",
+	    0x01, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
+	{ "ACKI",		0x01, 0x01 },
+	{ "REQI",		0x02, 0x02 },
+	{ "BSYI",		0x04, 0x04 },
+	{ "SELI",		0x08, 0x08 },
+	{ "ATNI",		0x10, 0x10 },
+	{ "MSGI",		0x20, 0x20 },
+	{ "IOI",		0x40, 0x40 },
+	{ "CDI",		0x80, 0x80 },
+	{ "P_DATAOUT",		0x00, 0x00 },
+	{ "P_DATAOUT_DT",	0x20, 0x20 },
+	{ "P_DATAIN",		0x40, 0x40 },
+	{ "P_DATAIN_DT",	0x60, 0x60 },
+	{ "P_COMMAND",		0x80, 0x80 },
+	{ "P_MESGOUT",		0xa0, 0xa0 },
+	{ "P_STATUS",		0xc0, 0xc0 },
+	{ "PHASE_MASK",		0xe0, 0xe0 },
+	{ "P_MESGIN",		0xe0, 0xe0 }
+};
+
+int
+ahc_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
+	    0x03, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
+	{ "SINGLE_EDGE",	0x10, 0x10 },
+	{ "ENABLE_CRC",		0x40, 0x40 },
+	{ "WIDEXFER",		0x80, 0x80 },
+	{ "SXFR_ULTRA2",	0x0f, 0x0f },
+	{ "SOFS",		0x0f, 0x0f },
+	{ "SXFR",		0x70, 0x70 }
+};
+
+int
+ahc_scsirate_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCSIRATE_parse_table, 6, "SCSIRATE",
+	    0x04, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
+	{ "DMADONE",		0x01, 0x01 },
+	{ "SPIORDY",		0x02, 0x02 },
+	{ "SDONE",		0x04, 0x04 },
+	{ "SWRAP",		0x08, 0x08 },
+	{ "IOERR",		0x08, 0x08 },
+	{ "SELINGO",		0x10, 0x10 },
+	{ "SELDI",		0x20, 0x20 },
+	{ "SELDO",		0x40, 0x40 },
+	{ "TARGET",		0x80, 0x80 }
+};
+
+int
+ahc_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SSTAT0_parse_table, 9, "SSTAT0",
+	    0x0b, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
+	{ "REQINIT",		0x01, 0x01 },
+	{ "PHASECHG",		0x02, 0x02 },
+	{ "SCSIPERR",		0x04, 0x04 },
+	{ "BUSFREE",		0x08, 0x08 },
+	{ "PHASEMIS",		0x10, 0x10 },
+	{ "SCSIRSTI",		0x20, 0x20 },
+	{ "ATNTARG",		0x40, 0x40 },
+	{ "SELTO",		0x80, 0x80 }
+};
+
+int
+ahc_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SSTAT1_parse_table, 8, "SSTAT1",
+	    0x0c, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
+	{ "DUAL_EDGE_ERR",	0x01, 0x01 },
+	{ "CRCREQERR",		0x02, 0x02 },
+	{ "CRCENDERR",		0x04, 0x04 },
+	{ "CRCVALERR",		0x08, 0x08 },
+	{ "EXP_ACTIVE",		0x10, 0x10 },
+	{ "SHVALID",		0x40, 0x40 },
+	{ "OVERRUN",		0x80, 0x80 },
+	{ "SFCNT",		0x1f, 0x1f }
+};
+
+int
+ahc_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SSTAT2_parse_table, 8, "SSTAT2",
+	    0x0d, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
+	{ "OFFCNT",		0x0f, 0x0f },
+	{ "U2OFFCNT",		0x7f, 0x7f },
+	{ "SCSICNT",		0xf0, 0xf0 }
+};
+
+int
+ahc_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SSTAT3_parse_table, 3, "SSTAT3",
+	    0x0e, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
+	{ "ENDMADONE",		0x01, 0x01 },
+	{ "ENSPIORDY",		0x02, 0x02 },
+	{ "ENSDONE",		0x04, 0x04 },
+	{ "ENSWRAP",		0x08, 0x08 },
+	{ "ENIOERR",		0x08, 0x08 },
+	{ "ENSELINGO",		0x10, 0x10 },
+	{ "ENSELDI",		0x20, 0x20 },
+	{ "ENSELDO",		0x40, 0x40 }
+};
+
+int
+ahc_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SIMODE0_parse_table, 8, "SIMODE0",
+	    0x10, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
+	{ "ENREQINIT",		0x01, 0x01 },
+	{ "ENPHASECHG",		0x02, 0x02 },
+	{ "ENSCSIPERR",		0x04, 0x04 },
+	{ "ENBUSFREE",		0x08, 0x08 },
+	{ "ENPHASEMIS",		0x10, 0x10 },
+	{ "ENSCSIRST",		0x20, 0x20 },
+	{ "ENATNTARG",		0x40, 0x40 },
+	{ "ENSELTIMO",		0x80, 0x80 }
+};
+
+int
+ahc_simode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SIMODE1_parse_table, 8, "SIMODE1",
+	    0x11, regvalue, cur_col, wrap));
+}
+
+int
+ahc_scsibusl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(NULL, 0, "SCSIBUSL",
+	    0x12, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
+	{ "XCVR",		0x01, 0x01 },
+	{ "SELWIDE",		0x02, 0x02 },
+	{ "ENAB20",		0x04, 0x04 },
+	{ "SELBUSB",		0x08, 0x08 },
+	{ "ENAB40",		0x08, 0x08 },
+	{ "AUTOFLUSHDIS",	0x20, 0x20 },
+	{ "DIAGLEDON",		0x40, 0x40 },
+	{ "DIAGLEDEN",		0x80, 0x80 }
+};
+
+int
+ahc_sblkctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SBLKCTL_parse_table, 8, "SBLKCTL",
+	    0x1f, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+	{ "NO_DISCONNECT",	0x01, 0x01 },
+	{ "SPHASE_PENDING",	0x02, 0x02 },
+	{ "DPHASE_PENDING",	0x04, 0x04 },
+	{ "CMDPHASE_PENDING",	0x08, 0x08 },
+	{ "TARG_CMD_PENDING",	0x10, 0x10 },
+	{ "DPHASE",		0x20, 0x20 },
+	{ "NO_CDB_SENT",	0x40, 0x40 },
+	{ "TARGET_CMD_IS_TAGGED",0x40, 0x40 },
+	{ "NOT_IDENTIFIED",	0x80, 0x80 }
+};
+
+int
+ahc_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
+	    0x3c, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
+	{ "MSGI",		0x20, 0x20 },
+	{ "IOI",		0x40, 0x40 },
+	{ "CDI",		0x80, 0x80 },
+	{ "P_DATAOUT",		0x00, 0x00 },
+	{ "P_BUSFREE",		0x01, 0x01 },
+	{ "P_DATAIN",		0x40, 0x40 },
+	{ "P_COMMAND",		0x80, 0x80 },
+	{ "P_MESGOUT",		0xa0, 0xa0 },
+	{ "P_STATUS",		0xc0, 0xc0 },
+	{ "PHASE_MASK",		0xe0, 0xe0 },
+	{ "P_MESGIN",		0xe0, 0xe0 }
+};
+
+int
+ahc_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(LASTPHASE_parse_table, 11, "LASTPHASE",
+	    0x3f, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
+	{ "LOADRAM",		0x01, 0x01 },
+	{ "SEQRESET",		0x02, 0x02 },
+	{ "STEP",		0x04, 0x04 },
+	{ "BRKADRINTEN",	0x08, 0x08 },
+	{ "FASTMODE",		0x10, 0x10 },
+	{ "FAILDIS",		0x20, 0x20 },
+	{ "PAUSEDIS",		0x40, 0x40 },
+	{ "PERRORDIS",		0x80, 0x80 }
+};
+
+int
+ahc_seqctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SEQCTL_parse_table, 8, "SEQCTL",
+	    0x60, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
+	{ "ILLHADDR",		0x01, 0x01 },
+	{ "ILLSADDR",		0x02, 0x02 },
+	{ "ILLOPCODE",		0x04, 0x04 },
+	{ "SQPARERR",		0x08, 0x08 },
+	{ "DPARERR",		0x10, 0x10 },
+	{ "MPARERR",		0x20, 0x20 },
+	{ "PCIERRSTAT",		0x40, 0x40 },
+	{ "CIOPARERR",		0x80, 0x80 }
+};
+
+int
+ahc_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(ERROR_parse_table, 8, "ERROR",
+	    0x92, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
+	{ "FIFORESET",		0x01, 0x01 },
+	{ "FIFOFLUSH",		0x02, 0x02 },
+	{ "DIRECTION",		0x04, 0x04 },
+	{ "HDMAEN",		0x08, 0x08 },
+	{ "HDMAENACK",		0x08, 0x08 },
+	{ "SDMAEN",		0x10, 0x10 },
+	{ "SDMAENACK",		0x10, 0x10 },
+	{ "SCSIEN",		0x20, 0x20 },
+	{ "WIDEODD",		0x40, 0x40 },
+	{ "PRELOADEN",		0x80, 0x80 }
+};
+
+int
+ahc_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
+	    0x93, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
+	{ "FIFOEMP",		0x01, 0x01 },
+	{ "FIFOFULL",		0x02, 0x02 },
+	{ "DFTHRESH",		0x04, 0x04 },
+	{ "HDONE",		0x08, 0x08 },
+	{ "MREQPEND",		0x10, 0x10 },
+	{ "FIFOQWDEMP",		0x20, 0x20 },
+	{ "DFCACHETH",		0x40, 0x40 },
+	{ "PRELOAD_AVAIL",	0x80, 0x80 }
+};
+
+int
+ahc_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
+	    0x94, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+	{ "DATA_OUT_PHASE",	0x01, 0x01 },
+	{ "DATA_IN_PHASE",	0x02, 0x02 },
+	{ "MSG_OUT_PHASE",	0x04, 0x04 },
+	{ "MSG_IN_PHASE",	0x08, 0x08 },
+	{ "COMMAND_PHASE",	0x10, 0x10 },
+	{ "STATUS_PHASE",	0x20, 0x20 },
+	{ "DATA_PHASE_MASK",	0x03, 0x03 }
+};
+
+int
+ahc_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
+	    0x9e, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+	{ "DISCONNECTED",	0x04, 0x04 },
+	{ "ULTRAENB",		0x08, 0x08 },
+	{ "MK_MESSAGE",		0x10, 0x10 },
+	{ "TAG_ENB",		0x20, 0x20 },
+	{ "DISCENB",		0x40, 0x40 },
+	{ "TARGET_SCB",		0x80, 0x80 },
+	{ "STATUS_RCVD",	0x80, 0x80 },
+	{ "SCB_TAG_TYPE",	0x03, 0x03 }
+};
+
+int
+ahc_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCB_CONTROL_parse_table, 8, "SCB_CONTROL",
+	    0xb8, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+	{ "TWIN_CHNLB",		0x80, 0x80 },
+	{ "OID",		0x0f, 0x0f },
+	{ "TWIN_TID",		0x70, 0x70 },
+	{ "TID",		0xf0, 0xf0 }
+};
+
+int
+ahc_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCB_SCSIID_parse_table, 4, "SCB_SCSIID",
+	    0xb9, regvalue, cur_col, wrap));
+}
+
+static const ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
+	{ "SCB_XFERLEN_ODD",	0x80, 0x80 },
+	{ "LID",		0x3f, 0x3f }
+};
+
+int
+ahc_scb_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(SCB_LUN_parse_table, 2, "SCB_LUN",
+	    0xba, regvalue, cur_col, wrap));
+}
+
+int
+ahc_scb_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahc_print_register(NULL, 0, "SCB_TAG",
+	    0xbb, regvalue, cur_col, wrap));
+}
 
diff -urpN linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
--- linux-2.6.23-aic-1-debloat/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	2007-10-14 15:05:08.000000000 +0100
@@ -5,7 +5,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
  */
-static uint8_t seqprog[] = {
+static const uint8_t seqprog[] = {
 	0xb2, 0x00, 0x00, 0x08,
 	0xf7, 0x11, 0x22, 0x08,
 	0x00, 0x65, 0xee, 0x59,

--Boundary-00=_08iEHQZBvcGY4Du--
