From: akpm@osdl.org
Subject: [patch 06/24] aic7xxx: s/__inline/inline
Date: Mon, 14 Aug 2006 23:09:21 -0700
Message-ID: <200608150609.k7F69LLo013214@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63127 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965204AbWHOGPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:15:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, vda@ilport.com.ua

From: Denis Vlasenko <vda@ilport.com.ua>

Global s/__inline/inline/ in aic7xxx driver

Signed-off-by: Denis Vlasenko <vda@ilport.com.ua>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c   |   10 -
 drivers/scsi/aic7xxx/aic79xx_inline.h |  128 ++++++++++++------------
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    4 
 drivers/scsi/aic7xxx/aic79xx_osm.h    |  110 ++++++++++----------
 drivers/scsi/aic7xxx/aic79xx_pci.c    |    2 
 drivers/scsi/aic7xxx/aic7xxx_inline.h |   76 +++++++-------
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    4 
 drivers/scsi/aic7xxx/aic7xxx_osm.h    |  112 ++++++++++-----------
 drivers/scsi/aic7xxx/aic7xxx_pci.c    |    2 
 drivers/scsi/aic7xxx/aiclib.h         |    4 
 10 files changed, 226 insertions(+), 226 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -863,7 +863,7 @@ static int		ahd_match_scb(struct ahd_sof
 
 /******************************** Private Inlines *****************************/
 
-static __inline void
+static inline void
 ahd_assert_atn(struct ahd_softc *ahd)
 {
 	ahd_outb(ahd, SCSISIGO, ATNO);
@@ -875,7 +875,7 @@ ahd_assert_atn(struct ahd_softc *ahd)
  * are currently in a packetized transfer.  We could
  * just as easily be sending or receiving a message.
  */
-static __inline int
+static inline int
 ahd_currently_packetized(struct ahd_softc *ahd)
 {
 	ahd_mode_state	 saved_modes;
@@ -915,7 +915,7 @@ ahd_set_active_fifo(struct ahd_softc *ah
 	}
 }
 
-static __inline void
+static inline void
 ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
 {
 	ahd_busy_tcl(ahd, tcl, SCB_LIST_NULL);
@@ -925,7 +925,7 @@ ahd_unbusy_tcl(struct ahd_softc *ahd, u_
  * Determine whether the sequencer reported a residual
  * for this SCB/transaction.
  */
-static __inline void
+static inline void
 ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -935,7 +935,7 @@ ahd_update_residual(struct ahd_softc *ah
 		ahd_calc_residual(ahd, scb);
 }
 
-static __inline void
+static inline void
 ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	uint32_t sgptr;
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic79xx_inline.h
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -46,37 +46,37 @@
 #define _AIC79XX_INLINE_H_
 
 /******************************** Debugging ***********************************/
-static __inline char *ahd_name(struct ahd_softc *ahd);
+static inline char *ahd_name(struct ahd_softc *ahd);
 
-static __inline char *
+static inline char *
 ahd_name(struct ahd_softc *ahd)
 {
 	return (ahd->name);
 }
 
 /************************ Sequencer Execution Control *************************/
-static __inline void ahd_known_modes(struct ahd_softc *ahd,
+static inline void ahd_known_modes(struct ahd_softc *ahd,
 				     ahd_mode src, ahd_mode dst);
-static __inline ahd_mode_state ahd_build_mode_state(struct ahd_softc *ahd,
+static inline ahd_mode_state ahd_build_mode_state(struct ahd_softc *ahd,
 						    ahd_mode src,
 						    ahd_mode dst);
-static __inline void ahd_extract_mode_state(struct ahd_softc *ahd,
+static inline void ahd_extract_mode_state(struct ahd_softc *ahd,
 					    ahd_mode_state state,
 					    ahd_mode *src, ahd_mode *dst);
 void ahd_set_modes(struct ahd_softc *ahd, ahd_mode src,
 				   ahd_mode dst);
 void ahd_update_modes(struct ahd_softc *ahd);
-static __inline void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
+static inline void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 				      ahd_mode dstmode, const char *file,
 				      int line);
 ahd_mode_state ahd_save_modes(struct ahd_softc *ahd);
 void ahd_restore_modes(struct ahd_softc *ahd,
 				       ahd_mode_state state);
-static __inline int  ahd_is_paused(struct ahd_softc *ahd);
-static __inline void ahd_pause(struct ahd_softc *ahd);
+static inline int  ahd_is_paused(struct ahd_softc *ahd);
+static inline void ahd_pause(struct ahd_softc *ahd);
 void ahd_unpause(struct ahd_softc *ahd);
 
-static __inline void
+static inline void
 ahd_known_modes(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
 	ahd->src_mode = src;
@@ -85,13 +85,13 @@ ahd_known_modes(struct ahd_softc *ahd, a
 	ahd->saved_dst_mode = dst;
 }
 
-static __inline ahd_mode_state
+static inline ahd_mode_state
 ahd_build_mode_state(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
 	return ((src << SRC_MODE_SHIFT) | (dst << DST_MODE_SHIFT));
 }
 
-static __inline void
+static inline void
 ahd_extract_mode_state(struct ahd_softc *ahd, ahd_mode_state state,
 		       ahd_mode *src, ahd_mode *dst)
 {
@@ -99,7 +99,7 @@ ahd_extract_mode_state(struct ahd_softc 
 	*dst = (state & DST_MODE) >> DST_MODE_SHIFT;
 }
 
-static __inline void
+static inline void
 ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 		 ahd_mode dstmode, const char *file, int line)
 {
@@ -119,7 +119,7 @@ ahd_assert_modes(struct ahd_softc *ahd, 
  * Determine whether the sequencer has halted code execution.
  * Returns non-zero status if the sequencer is stopped.
  */
-static __inline int
+static inline int
 ahd_is_paused(struct ahd_softc *ahd)
 {
 	return ((ahd_inb(ahd, HCNTRL) & PAUSE) != 0);
@@ -132,7 +132,7 @@ ahd_is_paused(struct ahd_softc *ahd)
  * cleared in the SEQCTL register.  The sequencer may use PAUSEDIS
  * for critical sections.
  */
-static __inline void
+static inline void
 ahd_pause(struct ahd_softc *ahd)
 {
 	ahd_outb(ahd, HCNTRL, ahd->pause);
@@ -149,10 +149,10 @@ ahd_pause(struct ahd_softc *ahd)
 void	*ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
 				      void *sgptr, dma_addr_t addr,
 				      bus_size_t len, int last);
-static __inline void	 ahd_setup_noxfer_scb(struct ahd_softc *ahd,
+static inline void	 ahd_setup_noxfer_scb(struct ahd_softc *ahd,
 					      struct scb *scb);
 
-static __inline void
+static inline void
 ahd_setup_noxfer_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	scb->hscb->sgptr = ahd_htole32(SG_LIST_NULL);
@@ -161,26 +161,26 @@ ahd_setup_noxfer_scb(struct ahd_softc *a
 }
 
 /************************** Memory mapping routines ***************************/
-static __inline size_t	ahd_sg_size(struct ahd_softc *ahd);
-static __inline void *
+static inline size_t	ahd_sg_size(struct ahd_softc *ahd);
+static inline void *
 			ahd_sg_bus_to_virt(struct ahd_softc *ahd,
 					   struct scb *scb,
 					   uint32_t sg_busaddr);
-static __inline uint32_t
+static inline uint32_t
 			ahd_sg_virt_to_bus(struct ahd_softc *ahd,
 					   struct scb *scb,
 					   void *sg);
-static __inline void	ahd_sync_scb(struct ahd_softc *ahd,
+static inline void	ahd_sync_scb(struct ahd_softc *ahd,
 				     struct scb *scb, int op);
-static __inline void	ahd_sync_sglist(struct ahd_softc *ahd,
+static inline void	ahd_sync_sglist(struct ahd_softc *ahd,
 					struct scb *scb, int op);
-static __inline void	ahd_sync_sense(struct ahd_softc *ahd,
+static inline void	ahd_sync_sense(struct ahd_softc *ahd,
 				       struct scb *scb, int op);
-static __inline uint32_t
+static inline uint32_t
 			ahd_targetcmd_offset(struct ahd_softc *ahd,
 					     u_int index);
 
-static __inline size_t
+static inline size_t
 ahd_sg_size(struct ahd_softc *ahd)
 {
 	if ((ahd->flags & AHD_64BIT_ADDRESSING) != 0)
@@ -188,7 +188,7 @@ ahd_sg_size(struct ahd_softc *ahd)
 	return (sizeof(struct ahd_dma_seg));
 }
 
-static __inline void *
+static inline void *
 ahd_sg_bus_to_virt(struct ahd_softc *ahd, struct scb *scb, uint32_t sg_busaddr)
 {
 	dma_addr_t sg_offset;
@@ -198,7 +198,7 @@ ahd_sg_bus_to_virt(struct ahd_softc *ahd
 	return ((uint8_t *)scb->sg_list + sg_offset);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_sg_virt_to_bus(struct ahd_softc *ahd, struct scb *scb, void *sg)
 {
 	dma_addr_t sg_offset;
@@ -210,7 +210,7 @@ ahd_sg_virt_to_bus(struct ahd_softc *ahd
 	return (scb->sg_list_busaddr + sg_offset);
 }
 
-static __inline void
+static inline void
 ahd_sync_scb(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.hscb_dmat,
@@ -219,7 +219,7 @@ ahd_sync_scb(struct ahd_softc *ahd, stru
 			/*len*/sizeof(*scb->hscb), op);
 }
 
-static __inline void
+static inline void
 ahd_sync_sglist(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	if (scb->sg_count == 0)
@@ -231,7 +231,7 @@ ahd_sync_sglist(struct ahd_softc *ahd, s
 			/*len*/ahd_sg_size(ahd) * scb->sg_count, op);
 }
 
-static __inline void
+static inline void
 ahd_sync_sense(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.sense_dmat,
@@ -240,7 +240,7 @@ ahd_sync_sense(struct ahd_softc *ahd, st
 			/*len*/AHD_SENSE_BUFSIZE, op);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_targetcmd_offset(struct ahd_softc *ahd, u_int index)
 {
 	return (((uint8_t *)&ahd->targetcmds[index])
@@ -248,7 +248,7 @@ ahd_targetcmd_offset(struct ahd_softc *a
 }
 
 /*********************** Miscelaneous Support Functions ***********************/
-static __inline struct ahd_initiator_tinfo *
+static inline struct ahd_initiator_tinfo *
 			ahd_fetch_transinfo(struct ahd_softc *ahd,
 					    char channel, u_int our_id,
 					    u_int remote_id,
@@ -259,28 +259,28 @@ uint32_t ahd_inl(struct ahd_softc *ahd, 
 void	ahd_outl(struct ahd_softc *ahd, u_int port, uint32_t value);
 uint64_t ahd_inq(struct ahd_softc *ahd, u_int port);
 void	ahd_outq(struct ahd_softc *ahd, u_int port, uint64_t value);
-static __inline u_int	ahd_get_scbptr(struct ahd_softc *ahd);
-static __inline void	ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr);
-static __inline u_int	ahd_get_hnscb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_hescb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_snscb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_sescb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_sdscb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_scbptr(struct ahd_softc *ahd);
+static inline void	ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr);
+static inline u_int	ahd_get_hnscb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_hescb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_snscb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_sescb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_sdscb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value);
 u_int	ahd_inb_scbram(struct ahd_softc *ahd, u_int offset);
 u_int	ahd_inw_scbram(struct ahd_softc *ahd, u_int offset);
 uint32_t ahd_inl_scbram(struct ahd_softc *ahd, u_int offset);
 uint64_t ahd_inq_scbram(struct ahd_softc *ahd, u_int offset);
 struct scb *ahd_lookup_scb(struct ahd_softc *ahd, u_int tag);
 void	ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb);
-static __inline uint8_t *
+static inline uint8_t *
 			ahd_get_sense_buf(struct ahd_softc *ahd,
 					  struct scb *scb);
-static __inline uint32_t
+static inline uint32_t
 			ahd_get_sense_bufaddr(struct ahd_softc *ahd,
 					      struct scb *scb);
 
@@ -288,7 +288,7 @@ static __inline uint32_t
  * Return pointers to the transfer negotiation information
  * for the specified our_id/remote_id pair.
  */
-static __inline struct ahd_initiator_tinfo *
+static inline struct ahd_initiator_tinfo *
 ahd_fetch_transinfo(struct ahd_softc *ahd, char channel, u_int our_id,
 		    u_int remote_id, struct ahd_tmode_tstate **tstate)
 {
@@ -310,7 +310,7 @@ do {								\
 	dst->hscb->lun = src->hscb->lun;			\
 } while (0)
 
-static __inline u_int
+static inline u_int
 ahd_get_scbptr(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, ~(AHD_MODE_UNKNOWN_MSK|AHD_MODE_CFG_MSK),
@@ -318,7 +318,7 @@ ahd_get_scbptr(struct ahd_softc *ahd)
 	return (ahd_inb(ahd, SCBPTR) | (ahd_inb(ahd, SCBPTR + 1) << 8));
 }
 
-static __inline void
+static inline void
 ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr)
 {
 	AHD_ASSERT_MODES(ahd, ~(AHD_MODE_UNKNOWN_MSK|AHD_MODE_CFG_MSK),
@@ -327,31 +327,31 @@ ahd_set_scbptr(struct ahd_softc *ahd, u_
 	ahd_outb(ahd, SCBPTR+1, (scbptr >> 8) & 0xFF);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_hnscb_qoff(struct ahd_softc *ahd)
 {
 	return (ahd_inw_atomic(ahd, HNSCB_QOFF));
 }
 
-static __inline void
+static inline void
 ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outw_atomic(ahd, HNSCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_hescb_qoff(struct ahd_softc *ahd)
 {
 	return (ahd_inb(ahd, HESCB_QOFF));
 }
 
-static __inline void
+static inline void
 ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outb(ahd, HESCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_snscb_qoff(struct ahd_softc *ahd)
 {
 	u_int oldvalue;
@@ -362,35 +362,35 @@ ahd_get_snscb_qoff(struct ahd_softc *ahd
 	return (oldvalue);
 }
 
-static __inline void
+static inline void
 ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outw(ahd, SNSCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_sescb_qoff(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	return (ahd_inb(ahd, SESCB_QOFF));
 }
 
-static __inline void
+static inline void
 ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outb(ahd, SESCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_sdscb_qoff(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	return (ahd_inb(ahd, SDSCB_QOFF) | (ahd_inb(ahd, SDSCB_QOFF + 1) << 8));
 }
 
-static __inline void
+static inline void
 ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
@@ -398,24 +398,24 @@ ahd_set_sdscb_qoff(struct ahd_softc *ahd
 	ahd_outb(ahd, SDSCB_QOFF+1, (value >> 8) & 0xFF);
 }
 
-static __inline uint8_t *
+static inline uint8_t *
 ahd_get_sense_buf(struct ahd_softc *ahd, struct scb *scb)
 {
 	return (scb->sense_data);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_get_sense_bufaddr(struct ahd_softc *ahd, struct scb *scb)
 {
 	return (scb->sense_busaddr);
 }
 
 /************************** Interrupt Processing ******************************/
-static __inline void	ahd_sync_qoutfifo(struct ahd_softc *ahd, int op);
-static __inline void	ahd_sync_tqinfifo(struct ahd_softc *ahd, int op);
+static inline void	ahd_sync_qoutfifo(struct ahd_softc *ahd, int op);
+static inline void	ahd_sync_tqinfifo(struct ahd_softc *ahd, int op);
 int	ahd_intr(struct ahd_softc *ahd);
 
-static __inline void
+static inline void
 ahd_sync_qoutfifo(struct ahd_softc *ahd, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
@@ -423,7 +423,7 @@ ahd_sync_qoutfifo(struct ahd_softc *ahd,
 			/*len*/AHD_SCB_MAX * sizeof(struct ahd_completion), op);
 }
 
-static __inline void
+static inline void
 ahd_sync_tqinfifo(struct ahd_softc *ahd, int op)
 {
 #ifdef AHD_TARGET_MODE
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -368,9 +368,9 @@ static int ahd_linux_unit;
 
 
 /****************************** Inlines ***************************************/
-static __inline void ahd_linux_unmap_scb(struct ahd_softc*, struct scb*);
+static inline void ahd_linux_unmap_scb(struct ahd_softc*, struct scb*);
 
-static __inline void
+static inline void
 ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct scsi_cmnd *cmd;
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -398,19 +398,19 @@ struct info_str {
 };
 
 /******************************** Locking *************************************/
-static __inline void
+static inline void
 ahd_lockinit(struct ahd_softc *ahd)
 {
 	spin_lock_init(&ahd->platform_data->spin_lock);
 }
 
-static __inline void
+static inline void
 ahd_lock(struct ahd_softc *ahd, unsigned long *flags)
 {
 	spin_lock_irqsave(&ahd->platform_data->spin_lock, *flags);
 }
 
-static __inline void
+static inline void
 ahd_unlock(struct ahd_softc *ahd, unsigned long *flags)
 {
 	spin_unlock_irqrestore(&ahd->platform_data->spin_lock, *flags);
@@ -488,10 +488,10 @@ int			 ahd_pci_map_registers(struct ahd_
 int			 ahd_pci_map_int(struct ahd_softc *ahd);
 
 void ahd_BUG_bad_pci_rw_size(void);
-static __inline uint32_t ahd_pci_read_config(ahd_dev_softc_t pci,
+static inline uint32_t ahd_pci_read_config(ahd_dev_softc_t pci,
 					     int reg, int width);
 
-static __inline uint32_t
+static inline uint32_t
 ahd_pci_read_config(ahd_dev_softc_t pci, int reg, int width)
 {
 	switch (width) {
@@ -521,11 +521,11 @@ ahd_pci_read_config(ahd_dev_softc_t pci,
 	}
 }
 
-static __inline void ahd_pci_write_config(ahd_dev_softc_t pci,
+static inline void ahd_pci_write_config(ahd_dev_softc_t pci,
 					  int reg, uint32_t value,
 					  int width);
 
-static __inline void
+static inline void
 ahd_pci_write_config(ahd_dev_softc_t pci, int reg, uint32_t value, int width)
 {
 	switch (width) {
@@ -544,29 +544,29 @@ ahd_pci_write_config(ahd_dev_softc_t pci
 	}
 }
 
-static __inline int ahd_get_pci_function(ahd_dev_softc_t);
-static __inline int
+static inline int ahd_get_pci_function(ahd_dev_softc_t);
+static inline int
 ahd_get_pci_function(ahd_dev_softc_t pci)
 {
 	return (PCI_FUNC(pci->devfn));
 }
 
-static __inline int ahd_get_pci_slot(ahd_dev_softc_t);
-static __inline int
+static inline int ahd_get_pci_slot(ahd_dev_softc_t);
+static inline int
 ahd_get_pci_slot(ahd_dev_softc_t pci)
 {
 	return (PCI_SLOT(pci->devfn));
 }
 
-static __inline int ahd_get_pci_bus(ahd_dev_softc_t);
-static __inline int
+static inline int ahd_get_pci_bus(ahd_dev_softc_t);
+static inline int
 ahd_get_pci_bus(ahd_dev_softc_t pci)
 {
 	return (pci->bus->number);
 }
 
-static __inline void ahd_flush_device_writes(struct ahd_softc *);
-static __inline void
+static inline void ahd_flush_device_writes(struct ahd_softc *);
+static inline void
 ahd_flush_device_writes(struct ahd_softc *ahd)
 {
 	/* XXX Is this sufficient for all architectures??? */
@@ -578,81 +578,81 @@ int	ahd_linux_proc_info(struct Scsi_Host
 			    off_t, int, int);
 
 /*********************** Transaction Access Wrappers **************************/
-static __inline void ahd_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahd_set_transaction_status(struct scb *, uint32_t);
-static __inline void ahd_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahd_set_scsi_status(struct scb *, uint32_t);
-static __inline uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahd_get_transaction_status(struct scb *);
-static __inline uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahd_get_scsi_status(struct scb *);
-static __inline void ahd_set_transaction_tag(struct scb *, int, u_int);
-static __inline u_long ahd_get_transfer_length(struct scb *);
-static __inline int ahd_get_transfer_dir(struct scb *);
-static __inline void ahd_set_residual(struct scb *, u_long);
-static __inline void ahd_set_sense_residual(struct scb *scb, u_long resid);
-static __inline u_long ahd_get_residual(struct scb *);
-static __inline u_long ahd_get_sense_residual(struct scb *);
-static __inline int ahd_perform_autosense(struct scb *);
-static __inline uint32_t ahd_get_sense_bufsize(struct ahd_softc *,
+static inline void ahd_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
+static inline void ahd_set_transaction_status(struct scb *, uint32_t);
+static inline void ahd_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
+static inline void ahd_set_scsi_status(struct scb *, uint32_t);
+static inline uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahd_get_transaction_status(struct scb *);
+static inline uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahd_get_scsi_status(struct scb *);
+static inline void ahd_set_transaction_tag(struct scb *, int, u_int);
+static inline u_long ahd_get_transfer_length(struct scb *);
+static inline int ahd_get_transfer_dir(struct scb *);
+static inline void ahd_set_residual(struct scb *, u_long);
+static inline void ahd_set_sense_residual(struct scb *scb, u_long resid);
+static inline u_long ahd_get_residual(struct scb *);
+static inline u_long ahd_get_sense_residual(struct scb *);
+static inline int ahd_perform_autosense(struct scb *);
+static inline uint32_t ahd_get_sense_bufsize(struct ahd_softc *,
 					       struct scb *);
-static __inline void ahd_notify_xfer_settings_change(struct ahd_softc *,
+static inline void ahd_notify_xfer_settings_change(struct ahd_softc *,
 						     struct ahd_devinfo *);
-static __inline void ahd_platform_scb_free(struct ahd_softc *ahd,
+static inline void ahd_platform_scb_free(struct ahd_softc *ahd,
 					   struct scb *scb);
-static __inline void ahd_freeze_scb(struct scb *scb);
+static inline void ahd_freeze_scb(struct scb *scb);
 
-static __inline
+static inline
 void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
 	cmd->result &= ~(CAM_STATUS_MASK << 16);
 	cmd->result |= status << 16;
 }
 
-static __inline
+static inline
 void ahd_set_transaction_status(struct scb *scb, uint32_t status)
 {
 	ahd_cmd_set_transaction_status(scb->io_ctx,status);
 }
 
-static __inline
+static inline
 void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
 	cmd->result &= ~0xFFFF;
 	cmd->result |= status;
 }
 
-static __inline
+static inline
 void ahd_set_scsi_status(struct scb *scb, uint32_t status)
 {
 	ahd_cmd_set_scsi_status(scb->io_ctx, status);
 }
 
-static __inline
+static inline
 uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
 	return ((cmd->result >> 16) & CAM_STATUS_MASK);
 }
 
-static __inline
+static inline
 uint32_t ahd_get_transaction_status(struct scb *scb)
 {
 	return (ahd_cmd_get_transaction_status(scb->io_ctx));
 }
 
-static __inline
+static inline
 uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
 	return (cmd->result & 0xFFFF);
 }
 
-static __inline
+static inline
 uint32_t ahd_get_scsi_status(struct scb *scb)
 {
 	return (ahd_cmd_get_scsi_status(scb->io_ctx));
 }
 
-static __inline
+static inline
 void ahd_set_transaction_tag(struct scb *scb, int enabled, u_int type)
 {
 	/*
@@ -661,43 +661,43 @@ void ahd_set_transaction_tag(struct scb 
 	 */
 }
 
-static __inline
+static inline
 u_long ahd_get_transfer_length(struct scb *scb)
 {
 	return (scb->platform_data->xfer_len);
 }
 
-static __inline
+static inline
 int ahd_get_transfer_dir(struct scb *scb)
 {
 	return (scb->io_ctx->sc_data_direction);
 }
 
-static __inline
+static inline
 void ahd_set_residual(struct scb *scb, u_long resid)
 {
 	scb->io_ctx->resid = resid;
 }
 
-static __inline
+static inline
 void ahd_set_sense_residual(struct scb *scb, u_long resid)
 {
 	scb->platform_data->sense_resid = resid;
 }
 
-static __inline
+static inline
 u_long ahd_get_residual(struct scb *scb)
 {
 	return (scb->io_ctx->resid);
 }
 
-static __inline
+static inline
 u_long ahd_get_sense_residual(struct scb *scb)
 {
 	return (scb->platform_data->sense_resid);
 }
 
-static __inline
+static inline
 int ahd_perform_autosense(struct scb *scb)
 {
 	/*
@@ -708,20 +708,20 @@ int ahd_perform_autosense(struct scb *sc
 	return (1);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_get_sense_bufsize(struct ahd_softc *ahd, struct scb *scb)
 {
 	return (sizeof(struct scsi_sense_data));
 }
 
-static __inline void
+static inline void
 ahd_notify_xfer_settings_change(struct ahd_softc *ahd,
 				struct ahd_devinfo *devinfo)
 {
 	/* Nothing to do here for linux */
 }
 
-static __inline void
+static inline void
 ahd_platform_scb_free(struct ahd_softc *ahd, struct scb *scb)
 {
 	ahd->flags &= ~AHD_RESOURCE_SHORTAGE;
@@ -734,7 +734,7 @@ void	ahd_platform_freeze_devq(struct ahd
 void	ahd_freeze_simq(struct ahd_softc *ahd);
 void	ahd_release_simq(struct ahd_softc *ahd);
 
-static __inline void
+static inline void
 ahd_freeze_scb(struct scb *scb)
 {
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -51,7 +51,7 @@
 
 #include "aic79xx_pci.h"
 
-static __inline uint64_t
+static inline uint64_t
 ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
 {
 	uint64_t id;
diff -puN drivers/scsi/aic7xxx/aic7xxx_inline.h~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic7xxx_inline.h
--- a/drivers/scsi/aic7xxx/aic7xxx_inline.h~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_inline.h
@@ -46,10 +46,10 @@
 #define _AIC7XXX_INLINE_H_
 
 /************************* Sequencer Execution Control ************************/
-static __inline void ahc_pause_bug_fix(struct ahc_softc *ahc);
-static __inline int  ahc_is_paused(struct ahc_softc *ahc);
-static __inline void ahc_pause(struct ahc_softc *ahc);
-static __inline void ahc_unpause(struct ahc_softc *ahc);
+static inline void ahc_pause_bug_fix(struct ahc_softc *ahc);
+static inline int  ahc_is_paused(struct ahc_softc *ahc);
+static inline void ahc_pause(struct ahc_softc *ahc);
+static inline void ahc_unpause(struct ahc_softc *ahc);
 
 /*
  * Work around any chip bugs related to halting sequencer execution.
@@ -59,7 +59,7 @@ static __inline void ahc_unpause(struct 
  * manual pause while accessing scb ram, accesses to certain registers
  * will hang the system (infinite pci retries).
  */
-static __inline void
+static inline void
 ahc_pause_bug_fix(struct ahc_softc *ahc)
 {
 	if ((ahc->features & AHC_ULTRA2) != 0)
@@ -70,7 +70,7 @@ ahc_pause_bug_fix(struct ahc_softc *ahc)
  * Determine whether the sequencer has halted code execution.
  * Returns non-zero status if the sequencer is stopped.
  */
-static __inline int
+static inline int
 ahc_is_paused(struct ahc_softc *ahc)
 {
 	return ((ahc_inb(ahc, HCNTRL) & PAUSE) != 0);
@@ -83,7 +83,7 @@ ahc_is_paused(struct ahc_softc *ahc)
  * cleared in the SEQCTL register.  The sequencer may use PAUSEDIS
  * for critical sections.
  */
-static __inline void
+static inline void
 ahc_pause(struct ahc_softc *ahc)
 {
 	ahc_outb(ahc, HCNTRL, ahc->pause);
@@ -108,7 +108,7 @@ ahc_pause(struct ahc_softc *ahc)
  * into our interrupt handler and dealing with this new
  * condition.
  */
-static __inline void
+static inline void
 ahc_unpause(struct ahc_softc *ahc)
 {
 	if ((ahc_inb(ahc, INTSTAT) & (SCSIINT | SEQINT | BRKADRINT)) == 0)
@@ -116,14 +116,14 @@ ahc_unpause(struct ahc_softc *ahc)
 }
 
 /*********************** Untagged Transaction Routines ************************/
-static __inline void	ahc_freeze_untagged_queues(struct ahc_softc *ahc);
-static __inline void	ahc_release_untagged_queues(struct ahc_softc *ahc);
+static inline void	ahc_freeze_untagged_queues(struct ahc_softc *ahc);
+static inline void	ahc_release_untagged_queues(struct ahc_softc *ahc);
 
 /*
  * Block our completion routine from starting the next untagged
  * transaction for this target or target lun.
  */
-static __inline void
+static inline void
 ahc_freeze_untagged_queues(struct ahc_softc *ahc)
 {
 	if ((ahc->flags & AHC_SCB_BTT) == 0)
@@ -136,7 +136,7 @@ ahc_freeze_untagged_queues(struct ahc_so
  * to be acquired recursively.  Once the count drops to zero, the
  * transaction queues will be run.
  */
-static __inline void
+static inline void
 ahc_release_untagged_queues(struct ahc_softc *ahc)
 {
 	if ((ahc->flags & AHC_SCB_BTT) == 0) {
@@ -147,23 +147,23 @@ ahc_release_untagged_queues(struct ahc_s
 }
 
 /************************** Memory mapping routines ***************************/
-static __inline struct ahc_dma_seg *
+static inline struct ahc_dma_seg *
 			ahc_sg_bus_to_virt(struct scb *scb,
 					   uint32_t sg_busaddr);
-static __inline uint32_t
+static inline uint32_t
 			ahc_sg_virt_to_bus(struct scb *scb,
 					   struct ahc_dma_seg *sg);
-static __inline uint32_t
+static inline uint32_t
 			ahc_hscb_busaddr(struct ahc_softc *ahc, u_int index);
-static __inline void	ahc_sync_scb(struct ahc_softc *ahc,
+static inline void	ahc_sync_scb(struct ahc_softc *ahc,
 				     struct scb *scb, int op);
-static __inline void	ahc_sync_sglist(struct ahc_softc *ahc,
+static inline void	ahc_sync_sglist(struct ahc_softc *ahc,
 					struct scb *scb, int op);
-static __inline uint32_t
+static inline uint32_t
 			ahc_targetcmd_offset(struct ahc_softc *ahc,
 					     u_int index);
 
-static __inline struct ahc_dma_seg *
+static inline struct ahc_dma_seg *
 ahc_sg_bus_to_virt(struct scb *scb, uint32_t sg_busaddr)
 {
 	int sg_index;
@@ -175,7 +175,7 @@ ahc_sg_bus_to_virt(struct scb *scb, uint
 	return (&scb->sg_list[sg_index]);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_sg_virt_to_bus(struct scb *scb, struct ahc_dma_seg *sg)
 {
 	int sg_index;
@@ -186,14 +186,14 @@ ahc_sg_virt_to_bus(struct scb *scb, stru
 	return (scb->sg_list_phys + (sg_index * sizeof(*scb->sg_list)));
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_hscb_busaddr(struct ahc_softc *ahc, u_int index)
 {
 	return (ahc->scb_data->hscb_busaddr
 		+ (sizeof(struct hardware_scb) * index));
 }
 
-static __inline void
+static inline void
 ahc_sync_scb(struct ahc_softc *ahc, struct scb *scb, int op)
 {
 	ahc_dmamap_sync(ahc, ahc->scb_data->hscb_dmat,
@@ -202,7 +202,7 @@ ahc_sync_scb(struct ahc_softc *ahc, stru
 			/*len*/sizeof(*scb->hscb), op);
 }
 
-static __inline void
+static inline void
 ahc_sync_sglist(struct ahc_softc *ahc, struct scb *scb, int op)
 {
 	if (scb->sg_count == 0)
@@ -214,16 +214,16 @@ ahc_sync_sglist(struct ahc_softc *ahc, s
 			/*len*/sizeof(struct ahc_dma_seg) * scb->sg_count, op);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_targetcmd_offset(struct ahc_softc *ahc, u_int index)
 {
 	return (((uint8_t *)&ahc->targetcmds[index]) - ahc->qoutfifo);
 }
 
 /******************************** Debugging ***********************************/
-static __inline char *ahc_name(struct ahc_softc *ahc);
+static inline char *ahc_name(struct ahc_softc *ahc);
 
-static __inline char *
+static inline char *
 ahc_name(struct ahc_softc *ahc)
 {
 	return (ahc->name);
@@ -231,9 +231,9 @@ ahc_name(struct ahc_softc *ahc)
 
 /*********************** Miscelaneous Support Functions ***********************/
 
-static __inline void	ahc_update_residual(struct ahc_softc *ahc,
+static inline void	ahc_update_residual(struct ahc_softc *ahc,
 					    struct scb *scb);
-static __inline struct ahc_initiator_tinfo *
+static inline struct ahc_initiator_tinfo *
 			ahc_fetch_transinfo(struct ahc_softc *ahc,
 					    char channel, u_int our_id,
 					    u_int remote_id,
@@ -250,10 +250,10 @@ void	ahc_free_scb(struct ahc_softc *ahc,
 struct scb *
 	ahc_lookup_scb(struct ahc_softc *ahc, u_int tag);
 void	ahc_queue_scb(struct ahc_softc *ahc, struct scb *scb);
-static __inline struct scsi_sense_data *
+static inline struct scsi_sense_data *
 			ahc_get_sense_buf(struct ahc_softc *ahc,
 					  struct scb *scb);
-static __inline uint32_t
+static inline uint32_t
 			ahc_get_sense_bufaddr(struct ahc_softc *ahc,
 					      struct scb *scb);
 
@@ -261,7 +261,7 @@ static __inline uint32_t
  * Determine whether the sequencer reported a residual
  * for this SCB/transaction.
  */
-static __inline void
+static inline void
 ahc_update_residual(struct ahc_softc *ahc, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -275,7 +275,7 @@ ahc_update_residual(struct ahc_softc *ah
  * Return pointers to the transfer negotiation information
  * for the specified our_id/remote_id pair.
  */
-static __inline struct ahc_initiator_tinfo *
+static inline struct ahc_initiator_tinfo *
 ahc_fetch_transinfo(struct ahc_softc *ahc, char channel, u_int our_id,
 		    u_int remote_id, struct ahc_tmode_tstate **tstate)
 {
@@ -291,7 +291,7 @@ ahc_fetch_transinfo(struct ahc_softc *ah
 	return (&(*tstate)->transinfo[remote_id]);
 }
 
-static __inline struct scsi_sense_data *
+static inline struct scsi_sense_data *
 ahc_get_sense_buf(struct ahc_softc *ahc, struct scb *scb)
 {
 	int offset;
@@ -300,7 +300,7 @@ ahc_get_sense_buf(struct ahc_softc *ahc,
 	return (&ahc->scb_data->sense[offset]);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_get_sense_bufaddr(struct ahc_softc *ahc, struct scb *scb)
 {
 	int offset;
@@ -311,18 +311,18 @@ ahc_get_sense_bufaddr(struct ahc_softc *
 }
 
 /************************** Interrupt Processing ******************************/
-static __inline void	ahc_sync_qoutfifo(struct ahc_softc *ahc, int op);
-static __inline void	ahc_sync_tqinfifo(struct ahc_softc *ahc, int op);
+static inline void	ahc_sync_qoutfifo(struct ahc_softc *ahc, int op);
+static inline void	ahc_sync_tqinfifo(struct ahc_softc *ahc, int op);
 int	ahc_intr(struct ahc_softc *ahc);
 
-static __inline void
+static inline void
 ahc_sync_qoutfifo(struct ahc_softc *ahc, int op)
 {
 	ahc_dmamap_sync(ahc, ahc->shared_data_dmat, ahc->shared_data_dmamap,
 			/*offset*/0, /*len*/256, op);
 }
 
-static __inline void
+static inline void
 ahc_sync_tqinfifo(struct ahc_softc *ahc, int op)
 {
 #ifdef AHC_TARGET_MODE
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -389,13 +389,13 @@ static int ahc_linux_unit;
 
 
 /********************************* Inlines ************************************/
-static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
+static inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
 
 static int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
 		 		      struct ahc_dma_seg *sg,
 				      dma_addr_t addr, bus_size_t len);
 
-static __inline void
+static inline void
 ahc_linux_unmap_scb(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct scsi_cmnd *cmd;
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -231,7 +231,7 @@ int	ahc_dmamap_unload(struct ahc_softc *
 #include "aic7xxx.h"
 
 /***************************** Timer Facilities *******************************/
-static __inline void
+static inline void
 ahc_scb_timer_reset(struct scb *scb, u_int usec)
 {
 }
@@ -414,19 +414,19 @@ void	ahc_format_transinfo(struct info_st
 /******************************** Locking *************************************/
 /* Lock protecting internal data structures */
 
-static __inline void
+static inline void
 ahc_lockinit(struct ahc_softc *ahc)
 {
 	spin_lock_init(&ahc->platform_data->spin_lock);
 }
 
-static __inline void
+static inline void
 ahc_lock(struct ahc_softc *ahc, unsigned long *flags)
 {
 	spin_lock_irqsave(&ahc->platform_data->spin_lock, *flags);
 }
 
-static __inline void
+static inline void
 ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
 {
 	spin_unlock_irqrestore(&ahc->platform_data->spin_lock, *flags);
@@ -500,10 +500,10 @@ int			 ahc_pci_map_registers(struct ahc_
 int			 ahc_pci_map_int(struct ahc_softc *ahc);
 
 void ahc_BUG_bad_pci_rw_size(void);
-static __inline uint32_t ahc_pci_read_config(ahc_dev_softc_t pci,
+static inline uint32_t ahc_pci_read_config(ahc_dev_softc_t pci,
 					     int reg, int width);
 
-static __inline uint32_t
+static inline uint32_t
 ahc_pci_read_config(ahc_dev_softc_t pci, int reg, int width)
 {
 	switch (width) {
@@ -533,11 +533,11 @@ ahc_pci_read_config(ahc_dev_softc_t pci,
 	}
 }
 
-static __inline void ahc_pci_write_config(ahc_dev_softc_t pci,
+static inline void ahc_pci_write_config(ahc_dev_softc_t pci,
 					  int reg, uint32_t value,
 					  int width);
 
-static __inline void
+static inline void
 ahc_pci_write_config(ahc_dev_softc_t pci, int reg, uint32_t value, int width)
 {
 	switch (width) {
@@ -556,22 +556,22 @@ ahc_pci_write_config(ahc_dev_softc_t pci
 	}
 }
 
-static __inline int ahc_get_pci_function(ahc_dev_softc_t);
-static __inline int
+static inline int ahc_get_pci_function(ahc_dev_softc_t);
+static inline int
 ahc_get_pci_function(ahc_dev_softc_t pci)
 {
 	return (PCI_FUNC(pci->devfn));
 }
 
-static __inline int ahc_get_pci_slot(ahc_dev_softc_t);
-static __inline int
+static inline int ahc_get_pci_slot(ahc_dev_softc_t);
+static inline int
 ahc_get_pci_slot(ahc_dev_softc_t pci)
 {
 	return (PCI_SLOT(pci->devfn));
 }
 
-static __inline int ahc_get_pci_bus(ahc_dev_softc_t);
-static __inline int
+static inline int ahc_get_pci_bus(ahc_dev_softc_t);
+static inline int
 ahc_get_pci_bus(ahc_dev_softc_t pci)
 {
 	return (pci->bus->number);
@@ -584,8 +584,8 @@ static inline void ahc_linux_pci_exit(vo
 }
 #endif
 
-static __inline void ahc_flush_device_writes(struct ahc_softc *);
-static __inline void
+static inline void ahc_flush_device_writes(struct ahc_softc *);
+static inline void
 ahc_flush_device_writes(struct ahc_softc *ahc)
 {
 	/* XXX Is this sufficient for all architectures??? */
@@ -598,81 +598,81 @@ int	ahc_linux_proc_info(struct Scsi_Host
 
 /*************************** Domain Validation ********************************/
 /*********************** Transaction Access Wrappers *************************/
-static __inline void ahc_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahc_set_transaction_status(struct scb *, uint32_t);
-static __inline void ahc_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahc_set_scsi_status(struct scb *, uint32_t);
-static __inline uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahc_get_transaction_status(struct scb *);
-static __inline uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahc_get_scsi_status(struct scb *);
-static __inline void ahc_set_transaction_tag(struct scb *, int, u_int);
-static __inline u_long ahc_get_transfer_length(struct scb *);
-static __inline int ahc_get_transfer_dir(struct scb *);
-static __inline void ahc_set_residual(struct scb *, u_long);
-static __inline void ahc_set_sense_residual(struct scb *scb, u_long resid);
-static __inline u_long ahc_get_residual(struct scb *);
-static __inline u_long ahc_get_sense_residual(struct scb *);
-static __inline int ahc_perform_autosense(struct scb *);
-static __inline uint32_t ahc_get_sense_bufsize(struct ahc_softc *,
+static inline void ahc_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
+static inline void ahc_set_transaction_status(struct scb *, uint32_t);
+static inline void ahc_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
+static inline void ahc_set_scsi_status(struct scb *, uint32_t);
+static inline uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahc_get_transaction_status(struct scb *);
+static inline uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahc_get_scsi_status(struct scb *);
+static inline void ahc_set_transaction_tag(struct scb *, int, u_int);
+static inline u_long ahc_get_transfer_length(struct scb *);
+static inline int ahc_get_transfer_dir(struct scb *);
+static inline void ahc_set_residual(struct scb *, u_long);
+static inline void ahc_set_sense_residual(struct scb *scb, u_long resid);
+static inline u_long ahc_get_residual(struct scb *);
+static inline u_long ahc_get_sense_residual(struct scb *);
+static inline int ahc_perform_autosense(struct scb *);
+static inline uint32_t ahc_get_sense_bufsize(struct ahc_softc *,
 					       struct scb *);
-static __inline void ahc_notify_xfer_settings_change(struct ahc_softc *,
+static inline void ahc_notify_xfer_settings_change(struct ahc_softc *,
 						     struct ahc_devinfo *);
-static __inline void ahc_platform_scb_free(struct ahc_softc *ahc,
+static inline void ahc_platform_scb_free(struct ahc_softc *ahc,
 					   struct scb *scb);
-static __inline void ahc_freeze_scb(struct scb *scb);
+static inline void ahc_freeze_scb(struct scb *scb);
 
-static __inline
+static inline
 void ahc_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
 	cmd->result &= ~(CAM_STATUS_MASK << 16);
 	cmd->result |= status << 16;
 }
 
-static __inline
+static inline
 void ahc_set_transaction_status(struct scb *scb, uint32_t status)
 {
 	ahc_cmd_set_transaction_status(scb->io_ctx,status);
 }
 
-static __inline
+static inline
 void ahc_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
 	cmd->result &= ~0xFFFF;
 	cmd->result |= status;
 }
 
-static __inline
+static inline
 void ahc_set_scsi_status(struct scb *scb, uint32_t status)
 {
 	ahc_cmd_set_scsi_status(scb->io_ctx, status);
 }
 
-static __inline
+static inline
 uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
 	return ((cmd->result >> 16) & CAM_STATUS_MASK);
 }
 
-static __inline
+static inline
 uint32_t ahc_get_transaction_status(struct scb *scb)
 {
 	return (ahc_cmd_get_transaction_status(scb->io_ctx));
 }
 
-static __inline
+static inline
 uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
 	return (cmd->result & 0xFFFF);
 }
 
-static __inline
+static inline
 uint32_t ahc_get_scsi_status(struct scb *scb)
 {
 	return (ahc_cmd_get_scsi_status(scb->io_ctx));
 }
 
-static __inline
+static inline
 void ahc_set_transaction_tag(struct scb *scb, int enabled, u_int type)
 {
 	/*
@@ -681,43 +681,43 @@ void ahc_set_transaction_tag(struct scb 
 	 */
 }
 
-static __inline
+static inline
 u_long ahc_get_transfer_length(struct scb *scb)
 {
 	return (scb->platform_data->xfer_len);
 }
 
-static __inline
+static inline
 int ahc_get_transfer_dir(struct scb *scb)
 {
 	return (scb->io_ctx->sc_data_direction);
 }
 
-static __inline
+static inline
 void ahc_set_residual(struct scb *scb, u_long resid)
 {
 	scb->io_ctx->resid = resid;
 }
 
-static __inline
+static inline
 void ahc_set_sense_residual(struct scb *scb, u_long resid)
 {
 	scb->platform_data->sense_resid = resid;
 }
 
-static __inline
+static inline
 u_long ahc_get_residual(struct scb *scb)
 {
 	return (scb->io_ctx->resid);
 }
 
-static __inline
+static inline
 u_long ahc_get_sense_residual(struct scb *scb)
 {
 	return (scb->platform_data->sense_resid);
 }
 
-static __inline
+static inline
 int ahc_perform_autosense(struct scb *scb)
 {
 	/*
@@ -728,20 +728,20 @@ int ahc_perform_autosense(struct scb *sc
 	return (1);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_get_sense_bufsize(struct ahc_softc *ahc, struct scb *scb)
 {
 	return (sizeof(struct scsi_sense_data));
 }
 
-static __inline void
+static inline void
 ahc_notify_xfer_settings_change(struct ahc_softc *ahc,
 				struct ahc_devinfo *devinfo)
 {
 	/* Nothing to do here for linux */
 }
 
-static __inline void
+static inline void
 ahc_platform_scb_free(struct ahc_softc *ahc, struct scb *scb)
 {
 }
@@ -750,7 +750,7 @@ int	ahc_platform_alloc(struct ahc_softc 
 void	ahc_platform_free(struct ahc_softc *ahc);
 void	ahc_platform_freeze_devq(struct ahc_softc *ahc, struct scb *scb);
 
-static __inline void
+static inline void
 ahc_freeze_scb(struct scb *scb)
 {
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -54,7 +54,7 @@
 
 #include "aic7xxx_pci.h"
 
-static __inline uint64_t
+static inline uint64_t
 ahc_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
 {
 	uint64_t id;
diff -puN drivers/scsi/aic7xxx/aiclib.h~aic7xxx-s-__inline-inline drivers/scsi/aic7xxx/aiclib.h
--- a/drivers/scsi/aic7xxx/aiclib.h~aic7xxx-s-__inline-inline
+++ a/drivers/scsi/aic7xxx/aiclib.h
@@ -133,7 +133,7 @@ struct scsi_sense_data
 #define SCSI_STATUS_TASK_ABORTED	0x40
 
 /************************* Large Disk Handling ********************************/
-static __inline int
+static inline int
 aic_sector_div(sector_t capacity, int heads, int sectors)
 {
 	/* ugly, ugly sector_div calling convention.. */
@@ -141,7 +141,7 @@ aic_sector_div(sector_t capacity, int he
 	return (int)capacity;
 }
 
-static __inline uint32_t
+static inline uint32_t
 scsi_4btoul(uint8_t *bytes)
 {
 	uint32_t rv;
_
