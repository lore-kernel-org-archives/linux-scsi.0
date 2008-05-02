From: akpm@linux-foundation.org
Subject: [patch 4/7] scsi: replace __inline with inline
Date: Fri, 02 May 2008 13:44:54 -0700
Message-ID: <200805022044.m42KitfY013968@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936698AbYEBUpR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 16:45:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com, jgarzik@redhat.com

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c   |   12 +-
 drivers/scsi/aic7xxx/aic79xx_inline.h |   32 +++----
 drivers/scsi/aic7xxx/aic79xx_osm.h    |  102 +++++++++++------------
 drivers/scsi/aic7xxx/aic79xx_pci.c    |    2 
 drivers/scsi/aic7xxx/aic7xxx_inline.h |    5 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h    |  104 ++++++++++++------------
 drivers/scsi/aic7xxx/aic7xxx_pci.c    |    2 
 drivers/scsi/aic7xxx/aiclib.h         |    4 
 drivers/scsi/sym53c8xx_2/sym_glue.h   |    6 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |    2 
 drivers/scsi/sym53c8xx_2/sym_hipd.h   |    6 -
 drivers/scsi/sym53c8xx_2/sym_malloc.c |    2 
 drivers/scsi/sym53c8xx_2/sym_misc.h   |   18 ++--
 13 files changed, 146 insertions(+), 151 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1034,7 +1034,7 @@ ahd_intr(struct ahd_softc *ahd)
 }
 
 /******************************** Private Inlines *****************************/
-static __inline void
+static inline void
 ahd_assert_atn(struct ahd_softc *ahd)
 {
 	ahd_outb(ahd, SCSISIGO, ATNO);
@@ -1069,7 +1069,7 @@ ahd_currently_packetized(struct ahd_soft
 	return (packetized);
 }
 
-static __inline int
+static inline int
 ahd_set_active_fifo(struct ahd_softc *ahd)
 {
 	u_int active_fifo;
@@ -1086,7 +1086,7 @@ ahd_set_active_fifo(struct ahd_softc *ah
 	}
 }
 
-static __inline void
+static inline void
 ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
 {
 	ahd_busy_tcl(ahd, tcl, SCB_LIST_NULL);
@@ -1096,7 +1096,7 @@ ahd_unbusy_tcl(struct ahd_softc *ahd, u_
  * Determine whether the sequencer reported a residual
  * for this SCB/transaction.
  */
-static __inline void
+static inline void
 ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -1106,7 +1106,7 @@ ahd_update_residual(struct ahd_softc *ah
 		ahd_calc_residual(ahd, scb);
 }
 
-static __inline void
+static inline void
 ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -7992,7 +7992,7 @@ ahd_resume(struct ahd_softc *ahd)
  * scbid that should be restored once manipualtion
  * of the TCL entry is complete.
  */
-static __inline u_int
+static inline u_int
 ahd_index_busy_tcl(struct ahd_softc *ahd, u_int *saved_scbid, u_int tcl)
 {
 	/*
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_inline.h
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -46,21 +46,20 @@
 #define _AIC79XX_INLINE_H_
 
 /******************************** Debugging ***********************************/
-static __inline char *ahd_name(struct ahd_softc *ahd);
+static inline char *ahd_name(struct ahd_softc *ahd);
 
-static __inline char *
-ahd_name(struct ahd_softc *ahd)
+static inline char *ahd_name(struct ahd_softc *ahd)
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
 
@@ -73,7 +72,7 @@ int  ahd_is_paused(struct ahd_softc *ahd
 void ahd_pause(struct ahd_softc *ahd);
 void ahd_unpause(struct ahd_softc *ahd);
 
-static __inline void
+static inline void
 ahd_known_modes(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
 	ahd->src_mode = src;
@@ -82,13 +81,13 @@ ahd_known_modes(struct ahd_softc *ahd, a
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
@@ -102,13 +101,12 @@ void	*ahd_sg_setup(struct ahd_softc *ahd
 		      bus_size_t len, int last);
 
 /************************** Memory mapping routines ***************************/
-static __inline size_t	ahd_sg_size(struct ahd_softc *ahd);
+static inline size_t	ahd_sg_size(struct ahd_softc *ahd);
 
 void	ahd_sync_sglist(struct ahd_softc *ahd,
 			struct scb *scb, int op);
 
-static __inline size_t
-ahd_sg_size(struct ahd_softc *ahd)
+static inline size_t ahd_sg_size(struct ahd_softc *ahd)
 {
 	if ((ahd->flags & AHD_64BIT_ADDRESSING) != 0)
 		return (sizeof(struct ahd_dma64_seg));
@@ -141,11 +139,9 @@ struct scb *
 	ahd_lookup_scb(struct ahd_softc *ahd, u_int tag);
 void	ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb);
 
-static __inline uint8_t *
-			ahd_get_sense_buf(struct ahd_softc *ahd,
+static inline uint8_t *ahd_get_sense_buf(struct ahd_softc *ahd,
 					  struct scb *scb);
-static __inline uint32_t
-			ahd_get_sense_bufaddr(struct ahd_softc *ahd,
+static inline uint32_t ahd_get_sense_bufaddr(struct ahd_softc *ahd,
 					      struct scb *scb);
 
 #if 0 /* unused */
@@ -158,13 +154,13 @@ do {								\
 
 #endif
 
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
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -395,19 +395,19 @@ struct info_str {
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
@@ -490,29 +490,29 @@ void			 ahd_pci_write_config(ahd_dev_sof
 					  int reg, uint32_t value,
 					  int width);
 
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
@@ -524,81 +524,81 @@ int	ahd_linux_proc_info(struct Scsi_Host
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
@@ -607,43 +607,43 @@ void ahd_set_transaction_tag(struct scb 
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
 	scsi_set_resid(scb->io_ctx, resid);
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
 	return scsi_get_resid(scb->io_ctx);
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
@@ -654,20 +654,20 @@ int ahd_perform_autosense(struct scb *sc
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
@@ -678,7 +678,7 @@ void	ahd_platform_free(struct ahd_softc 
 void	ahd_platform_init(struct ahd_softc *ahd);
 void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 
-static __inline void
+static inline void
 ahd_freeze_scb(struct scb *scb)
 {
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -51,7 +51,7 @@
 
 #include "aic79xx_pci.h"
 
-static __inline uint64_t
+static inline uint64_t
 ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
 {
 	uint64_t id;
diff -puN drivers/scsi/aic7xxx/aic7xxx_inline.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_inline.h
--- a/drivers/scsi/aic7xxx/aic7xxx_inline.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_inline.h
@@ -55,10 +55,9 @@ void	ahc_sync_sglist(struct ahc_softc *a
 			struct scb *scb, int op);
 
 /******************************** Debugging ***********************************/
-static __inline char *ahc_name(struct ahc_softc *ahc);
+static inline char *ahc_name(struct ahc_softc *ahc);
 
-static __inline char *
-ahc_name(struct ahc_softc *ahc)
+static inline char *ahc_name(struct ahc_softc *ahc)
 {
 	return (ahc->name);
 }
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -230,7 +230,7 @@ int	ahc_dmamap_unload(struct ahc_softc *
 #include "aic7xxx.h"
 
 /***************************** Timer Facilities *******************************/
-static __inline void
+static inline void
 ahc_scb_timer_reset(struct scb *scb, u_int usec)
 {
 }
@@ -401,19 +401,19 @@ struct info_str {
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
@@ -493,22 +493,22 @@ void			 ahc_pci_write_config(ahc_dev_sof
 					      int reg, uint32_t value,
 					      int width);
 
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
@@ -521,8 +521,8 @@ static inline void ahc_linux_pci_exit(vo
 }
 #endif
 
-static __inline void ahc_flush_device_writes(struct ahc_softc *);
-static __inline void
+static inline void ahc_flush_device_writes(struct ahc_softc *);
+static inline void
 ahc_flush_device_writes(struct ahc_softc *ahc)
 {
 	/* XXX Is this sufficient for all architectures??? */
@@ -535,81 +535,81 @@ int	ahc_linux_proc_info(struct Scsi_Host
 
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
@@ -618,43 +618,43 @@ void ahc_set_transaction_tag(struct scb 
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
 	scsi_set_resid(scb->io_ctx, resid);
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
 	return scsi_get_resid(scb->io_ctx);
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
@@ -665,20 +665,20 @@ int ahc_perform_autosense(struct scb *sc
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
@@ -687,7 +687,7 @@ int	ahc_platform_alloc(struct ahc_softc 
 void	ahc_platform_free(struct ahc_softc *ahc);
 void	ahc_platform_freeze_devq(struct ahc_softc *ahc, struct scb *scb);
 
-static __inline void
+static inline void
 ahc_freeze_scb(struct scb *scb)
 {
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -54,7 +54,7 @@
 
 #include "aic7xxx_pci.h"
 
-static __inline uint64_t
+static inline uint64_t
 ahc_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
 {
 	uint64_t id;
diff -puN drivers/scsi/aic7xxx/aiclib.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aiclib.h
--- a/drivers/scsi/aic7xxx/aiclib.h~scsi-replace-__inline-with-inline
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
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.h~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_glue.h
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -234,7 +234,7 @@ static inline struct sym_hcb * sym_get_h
 /*
  *  Set the status field of a CAM CCB.
  */
-static __inline void 
+static inline void
 sym_set_cam_status(struct scsi_cmnd *cmd, int status)
 {
 	cmd->result &= ~(0xff  << 16);
@@ -244,7 +244,7 @@ sym_set_cam_status(struct scsi_cmnd *cmd
 /*
  *  Get the status field of a CAM CCB.
  */
-static __inline int 
+static inline int
 sym_get_cam_status(struct scsi_cmnd *cmd)
 {
 	return host_byte(cmd->result);
@@ -253,7 +253,7 @@ sym_get_cam_status(struct scsi_cmnd *cmd
 /*
  *  Build CAM result for a successful IO and for a failed IO.
  */
-static __inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd *cmd, int resid)
+static inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd *cmd, int resid)
 {
 	scsi_set_resid(cmd, resid);
 	cmd->result = (((DID_OK) << 16) + ((cp->ssss_status) & 0x7f));
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -602,7 +602,7 @@ sym_getsync(struct sym_hcb *np, u_char d
 /*
  *  Set initial io register bits from burst code.
  */
-static __inline void sym_init_burst(struct sym_hcb *np, u_char bc)
+static inline void sym_init_burst(struct sym_hcb *np, u_char bc)
 {
 	np->rv_ctest4	&= ~0x80;
 	np->rv_dmode	&= ~(0x3 << 6);
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.h~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_hipd.h
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1092,7 +1092,7 @@ do {									\
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
 #define DMA_DAC_MASK	DMA_64BIT_MASK
 int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s);
-static __inline void 
+static inline void
 sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
 {
 	u32 h = (badd>>32);
@@ -1197,7 +1197,7 @@ dma_addr_t __vtobus(m_pool_ident_t dev_d
 
 #define sym_m_pool_match(mp_id1, mp_id2)	(mp_id1 == mp_id2)
 
-static __inline void *sym_m_get_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
+static inline void *sym_m_get_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
 {
 	void *vaddr = NULL;
 	dma_addr_t baddr = 0;
@@ -1211,7 +1211,7 @@ static __inline void *sym_m_get_dma_mem_
 	return vaddr;
 }
 
-static __inline void sym_m_free_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
+static inline void sym_m_free_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
 {
 	dma_free_coherent(mp->dev_dmat, SYM_MEM_CLUSTER_SIZE, vbp->vaddr,
 			vbp->baddr);
diff -puN drivers/scsi/sym53c8xx_2/sym_malloc.c~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_malloc.c
--- a/drivers/scsi/sym53c8xx_2/sym_malloc.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_malloc.c
@@ -262,7 +262,7 @@ static void ___free_dma_mem_cluster(m_po
 #endif
 
 /* Fetch the memory pool for a given pool id (i.e. DMA constraints) */
-static __inline m_pool_p ___get_dma_pool(m_pool_ident_t dev_dmat)
+static inline m_pool_p ___get_dma_pool(m_pool_ident_t dev_dmat)
 {
 	m_pool_p mp;
 	for (mp = mp0.next;
diff -puN drivers/scsi/sym53c8xx_2/sym_misc.h~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_misc.h
--- a/drivers/scsi/sym53c8xx_2/sym_misc.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_misc.h
@@ -52,17 +52,17 @@ typedef struct sym_quehead {
 	(ptr)->flink = (ptr); (ptr)->blink = (ptr); \
 } while (0)
 
-static __inline struct sym_quehead *sym_que_first(struct sym_quehead *head)
+static inline struct sym_quehead *sym_que_first(struct sym_quehead *head)
 {
 	return (head->flink == head) ? 0 : head->flink;
 }
 
-static __inline struct sym_quehead *sym_que_last(struct sym_quehead *head)
+static inline struct sym_quehead *sym_que_last(struct sym_quehead *head)
 {
 	return (head->blink == head) ? 0 : head->blink;
 }
 
-static __inline void __sym_que_add(struct sym_quehead * new,
+static inline void __sym_que_add(struct sym_quehead * new,
 	struct sym_quehead * blink,
 	struct sym_quehead * flink)
 {
@@ -72,19 +72,19 @@ static __inline void __sym_que_add(struc
 	blink->flink	= new;
 }
 
-static __inline void __sym_que_del(struct sym_quehead * blink,
+static inline void __sym_que_del(struct sym_quehead * blink,
 	struct sym_quehead * flink)
 {
 	flink->blink = blink;
 	blink->flink = flink;
 }
 
-static __inline int sym_que_empty(struct sym_quehead *head)
+static inline int sym_que_empty(struct sym_quehead *head)
 {
 	return head->flink == head;
 }
 
-static __inline void sym_que_splice(struct sym_quehead *list,
+static inline void sym_que_splice(struct sym_quehead *list,
 	struct sym_quehead *head)
 {
 	struct sym_quehead *first = list->flink;
@@ -101,7 +101,7 @@ static __inline void sym_que_splice(stru
 	}
 }
 
-static __inline void sym_que_move(struct sym_quehead *orig,
+static inline void sym_que_move(struct sym_quehead *orig,
 	struct sym_quehead *dest)
 {
 	struct sym_quehead *first, *last;
@@ -131,7 +131,7 @@ static __inline void sym_que_move(struct
 
 #define sym_insque_head(new, head)	__sym_que_add(new, head, (head)->flink)
 
-static __inline struct sym_quehead *sym_remque_head(struct sym_quehead *head)
+static inline struct sym_quehead *sym_remque_head(struct sym_quehead *head)
 {
 	struct sym_quehead *elem = head->flink;
 
@@ -144,7 +144,7 @@ static __inline struct sym_quehead *sym_
 
 #define sym_insque_tail(new, head)	__sym_que_add(new, (head)->blink, head)
 
-static __inline struct sym_quehead *sym_remque_tail(struct sym_quehead *head)
+static inline struct sym_quehead *sym_remque_tail(struct sym_quehead *head)
 {
 	struct sym_quehead *elem = head->blink;
 
_
