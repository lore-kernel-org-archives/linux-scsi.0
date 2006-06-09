From: akpm@osdl.org
Subject: [patch 13/31] drivers/scsi/aic7xxx/: possible cleanups
Date: Thu, 08 Jun 2006 22:23:44 -0700
Message-ID: <200606090523.k595NiXs032284@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19423 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965210AbWFIF1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:27:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

- make needlessly global functions static

- #if 0 the following unused global functions:
  - aic7xxx_core.c: ahc_inq()
  - aic7xxx_core.c: ahc_outq()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx.h        |    6 ----
 drivers/scsi/aic7xxx/aic79xx_core.c   |   32 +++++++++++++++---------
 drivers/scsi/aic7xxx/aic79xx_inline.h |    5 ---
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    6 +++-
 drivers/scsi/aic7xxx/aic79xx_osm.h    |    6 ----
 drivers/scsi/aic7xxx/aic7xxx.h        |    6 ----
 drivers/scsi/aic7xxx/aic7xxx_core.c   |   26 ++++++++++++++-----
 drivers/scsi/aic7xxx/aic7xxx_inline.h |    2 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h    |    4 ---
 9 files changed, 43 insertions(+), 50 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic79xx_core.c
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-06-01 20:41:50.000000000 -0700
@@ -50,6 +50,12 @@
 #include <dev/aic7xxx/aicasm/aicasm_insformat.h>
 #endif
 
+static void ahd_handle_hwerrint(struct ahd_softc *ahd);
+static void ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat);
+static void ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat);
+static void ahd_reset_cmds_pending(struct ahd_softc *ahd);
+static void ahd_run_qoutfifo(struct ahd_softc *ahd);
+
 /***************************** Timer Facilities *******************************/
 #define ahd_timer_init init_timer
 #define ahd_timer_stop del_timer_sync
@@ -118,7 +124,7 @@ ahd_outw_atomic(struct ahd_softc * ahd, 
 	mb();
 }
 
-void
+static void
 ahd_outsb(struct ahd_softc * ahd, long port, uint8_t *array, int count)
 {
 	int i;
@@ -132,7 +138,8 @@ ahd_outsb(struct ahd_softc * ahd, long p
 		ahd_outb(ahd, port, *array++);
 }
 
-void
+#ifdef AHD_DUMP_SEQ
+static void
 ahd_insb(struct ahd_softc * ahd, long port, uint8_t *array, int count)
 {
 	int i;
@@ -145,6 +152,7 @@ ahd_insb(struct ahd_softc * ahd, long po
 	for (i = 0; i < count; i++)
 		*array++ = ahd_inb(ahd, port);
 }
+#endif  /*  AHD_DUMP_SEQ  */
 
 /************************ Sequencer Execution Control *************************/
 void
@@ -165,7 +173,7 @@ ahd_set_modes(struct ahd_softc *ahd, ahd
 	ahd->dst_mode = dst;
 }
 
-void
+static void
 ahd_update_modes(struct ahd_softc *ahd)
 {
 	ahd_mode_state mode_ptr;
@@ -355,7 +363,7 @@ ahd_outl(struct ahd_softc *ahd, u_int po
 	ahd_outb(ahd, port+3, ((value) >> 24) & 0xFF);
 }
 
-uint64_t
+static uint64_t
 ahd_inq(struct ahd_softc *ahd, u_int port)
 {
 	return ((ahd_inb(ahd, port))
@@ -368,7 +376,7 @@ ahd_inq(struct ahd_softc *ahd, u_int por
 	      | (((uint64_t)ahd_inb(ahd, port+7)) << 56));
 }
 
-void
+static void
 ahd_outq(struct ahd_softc *ahd, u_int port, uint64_t value)
 {
 	ahd_outb(ahd, port, value & 0xFF);
@@ -413,14 +421,14 @@ ahd_inw_scbram(struct ahd_softc *ahd, u_
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
@@ -1491,7 +1499,7 @@ clrchn:
  * a copy of the first byte (little endian) of the sgptr
  * hscb field.
  */
-void
+static void
 ahd_run_qoutfifo(struct ahd_softc *ahd)
 {
 	struct ahd_completion *completion;
@@ -1530,7 +1538,7 @@ ahd_run_qoutfifo(struct ahd_softc *ahd)
 }
 
 /************************* Interrupt Handling *********************************/
-void
+static void
 ahd_handle_hwerrint(struct ahd_softc *ahd)
 {
 	/*
@@ -1604,7 +1612,7 @@ ahd_dump_sglist(struct scb *scb)
 }
 #endif  /*  AHD_DEBUG  */
 
-void
+static void
 ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 {
 	u_int seqintcode;
@@ -2193,7 +2201,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 	ahd_unpause(ahd);
 }
 
-void
+static void
 ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 {
 	struct scb	*scb;
@@ -7925,7 +7933,7 @@ ahd_qinfifo_count(struct ahd_softc *ahd)
 		      + NUM_ELEMENTS(ahd->qinfifo) - wrap_qinpos);
 }
 
-void
+static void
 ahd_reset_cmds_pending(struct ahd_softc *ahd)
 {
 	struct		scb *scb;
diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic79xx.h
--- devel/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx.h	2006-06-01 20:41:50.000000000 -0700
@@ -1336,7 +1336,6 @@ extern const int ahd_num_aic7770_devs;
 
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
-void			ahd_reset_cmds_pending(struct ahd_softc *ahd);
 
 /***************************** PCI Front End *********************************/
 struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
@@ -1373,14 +1372,9 @@ int			 ahd_read_flexport(struct ahd_soft
 					   uint8_t *value);
 
 /*************************** Interrupt Services *******************************/
-void			ahd_run_qoutfifo(struct ahd_softc *ahd);
 #ifdef AHD_TARGET_MODE
 void			ahd_run_tqinfifo(struct ahd_softc *ahd, int paused);
 #endif
-void			ahd_handle_hwerrint(struct ahd_softc *ahd);
-void			ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat);
-void			ahd_handle_scsiint(struct ahd_softc *ahd,
-					   u_int intstat);
 
 /***************************** Error Recovery *********************************/
 typedef enum {
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic79xx_inline.h
--- devel/drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_inline.h	2006-06-01 20:41:50.000000000 -0700
@@ -65,7 +65,6 @@ static inline void ahd_extract_mode_stat
 					    ahd_mode *src, ahd_mode *dst);
 void ahd_set_modes(struct ahd_softc *ahd, ahd_mode src,
 				   ahd_mode dst);
-void ahd_update_modes(struct ahd_softc *ahd);
 static inline void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 				      ahd_mode dstmode, const char *file,
 				      int line);
@@ -257,8 +256,6 @@ uint16_t ahd_inw(struct ahd_softc *ahd, 
 void	ahd_outw(struct ahd_softc *ahd, u_int port, u_int value);
 uint32_t ahd_inl(struct ahd_softc *ahd, u_int port);
 void	ahd_outl(struct ahd_softc *ahd, u_int port, uint32_t value);
-uint64_t ahd_inq(struct ahd_softc *ahd, u_int port);
-void	ahd_outq(struct ahd_softc *ahd, u_int port, uint64_t value);
 static inline u_int	ahd_get_scbptr(struct ahd_softc *ahd);
 static inline void	ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr);
 static inline u_int	ahd_get_hnscb_qoff(struct ahd_softc *ahd);
@@ -273,8 +270,6 @@ static inline u_int	ahd_get_sdscb_qoff(s
 static inline void	ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value);
 u_int	ahd_inb_scbram(struct ahd_softc *ahd, u_int offset);
 u_int	ahd_inw_scbram(struct ahd_softc *ahd, u_int offset);
-uint32_t ahd_inl_scbram(struct ahd_softc *ahd, u_int offset);
-uint64_t ahd_inq_scbram(struct ahd_softc *ahd, u_int offset);
 struct scb *ahd_lookup_scb(struct ahd_softc *ahd, u_int tag);
 void	ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb);
 static inline uint8_t *
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic79xx_osm.c
--- devel/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-06-01 20:41:50.000000000 -0700
@@ -383,6 +383,8 @@ static int ahd_linux_run_command(struct 
 				 struct scsi_cmnd *);
 static void ahd_linux_setup_tag_info_global(char *p);
 static int  aic79xx_setup(char *c);
+static void ahd_freeze_simq(struct ahd_softc *ahd);
+static void ahd_release_simq(struct ahd_softc *ahd);
 
 static int ahd_linux_unit;
 
@@ -2081,13 +2083,13 @@ ahd_linux_queue_cmd_complete(struct ahd_
 	cmd->scsi_done(cmd);
 }
 
-void
+static void
 ahd_freeze_simq(struct ahd_softc *ahd)
 {
 	scsi_block_requests(ahd->platform_data->host);
 }
 
-void
+static void
 ahd_release_simq(struct ahd_softc *ahd)
 {
 	scsi_unblock_requests(ahd->platform_data->host);
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic79xx_osm.h
--- devel/drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm.h	2006-06-01 20:41:50.000000000 -0700
@@ -387,10 +387,6 @@ uint16_t ahd_inw_atomic(struct ahd_softc
 void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
 void ahd_outw_atomic(struct ahd_softc * ahd,
 				     long port, uint16_t val);
-void ahd_outsb(struct ahd_softc * ahd, long port,
-			       uint8_t *, int count);
-void ahd_insb(struct ahd_softc * ahd, long port,
-			       uint8_t *, int count);
 
 /**************************** Initialization **********************************/
 int		ahd_linux_register_host(struct ahd_softc *,
@@ -740,8 +736,6 @@ int	ahd_platform_alloc(struct ahd_softc 
 void	ahd_platform_free(struct ahd_softc *ahd);
 void	ahd_platform_init(struct ahd_softc *ahd);
 void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
-void	ahd_freeze_simq(struct ahd_softc *ahd);
-void	ahd_release_simq(struct ahd_softc *ahd);
 
 static inline void
 ahd_freeze_scb(struct scb *scb)
diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic7xxx_core.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_core.c	2006-06-01 20:41:50.000000000 -0700
@@ -50,6 +50,12 @@
 #include <dev/aic7xxx/aicasm/aicasm_insformat.h>
 #endif
 
+static void ahc_alloc_scbs(struct ahc_softc *ahc);
+static void ahc_handle_brkadrint(struct ahc_softc *ahc);
+static void ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat);
+static void ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat);
+static void ahc_run_qoutfifo(struct ahc_softc *ahc);
+
 /***************************** Low Level I/O **********************************/
 uint8_t
 ahc_inb(struct ahc_softc * ahc, long port)
@@ -76,7 +82,7 @@ ahc_outb(struct ahc_softc * ahc, long po
 	mb();
 }
 
-void
+static void
 ahc_outsb(struct ahc_softc * ahc, long port, uint8_t *array, int count)
 {
 	int i;
@@ -90,7 +96,8 @@ ahc_outsb(struct ahc_softc * ahc, long p
 		ahc_outb(ahc, port, *array++);
 }
 
-void
+#ifdef AHC_DUMP_SEQ
+static void
 ahc_insb(struct ahc_softc * ahc, long port, uint8_t *array, int count)
 {
 	int i;
@@ -103,6 +110,7 @@ ahc_insb(struct ahc_softc * ahc, long po
 	for (i = 0; i < count; i++)
 		*array++ = ahc_inb(ahc, port);
 }
+#endif  /*  AHC_DUMP_SEQ  */
 
 /*********************** Miscelaneous Support Functions ***********************/
 uint16_t
@@ -136,6 +144,8 @@ ahc_outl(struct ahc_softc *ahc, u_int po
 	ahc_outb(ahc, port+3, ((value) >> 24) & 0xFF);
 }
 
+#if 0
+
 uint64_t
 ahc_inq(struct ahc_softc *ahc, u_int port)
 {
@@ -162,6 +172,8 @@ ahc_outq(struct ahc_softc *ahc, u_int po
 	ahc_outb(ahc, port+7, (value >> 56) & 0xFF);
 }
 
+#endif  /*  0  */
+
 /*
  * Get a free scb. If there are none, see if we can allocate a new SCB.
  */
@@ -661,7 +673,7 @@ ahc_restart(struct ahc_softc *ahc)
 }
 
 /************************* Input/Output Queues ********************************/
-void
+static void
 ahc_run_qoutfifo(struct ahc_softc *ahc)
 {
 	struct scb *scb;
@@ -733,7 +745,7 @@ ahc_run_untagged_queue(struct ahc_softc 
 }
 
 /************************* Interrupt Handling *********************************/
-void
+static void
 ahc_handle_brkadrint(struct ahc_softc *ahc)
 {
 	/*
@@ -762,7 +774,7 @@ ahc_handle_brkadrint(struct ahc_softc *a
 	ahc_shutdown(ahc);
 }
 
-void
+static void
 ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 {
 	struct scb *scb;
@@ -1312,7 +1324,7 @@ unpause:
 	ahc_unpause(ahc);
 }
 
-void
+static void
 ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 {
 	u_int	scb_index;
@@ -4724,7 +4736,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 		free(scb_data->scbarray, M_DEVBUF);
 }
 
-void
+static void
 ahc_alloc_scbs(struct ahc_softc *ahc)
 {
 	struct scb_data *scb_data;
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic7xxx.h
--- devel/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx.h	2006-06-01 20:41:50.000000000 -0700
@@ -1192,21 +1192,15 @@ int			 ahc_suspend(struct ahc_softc *ahc
 int			 ahc_resume(struct ahc_softc *ahc);
 void			 ahc_set_unit(struct ahc_softc *, int);
 void			 ahc_set_name(struct ahc_softc *, char *);
-void			 ahc_alloc_scbs(struct ahc_softc *ahc);
 void			 ahc_free(struct ahc_softc *ahc);
 int			 ahc_reset(struct ahc_softc *ahc, int reinit);
 void			 ahc_shutdown(void *arg);
 
 /*************************** Interrupt Services *******************************/
 void			ahc_clear_intstat(struct ahc_softc *ahc);
-void			ahc_run_qoutfifo(struct ahc_softc *ahc);
 #ifdef AHC_TARGET_MODE
 void			ahc_run_tqinfifo(struct ahc_softc *ahc, int paused);
 #endif
-void			ahc_handle_brkadrint(struct ahc_softc *ahc);
-void			ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat);
-void			ahc_handle_scsiint(struct ahc_softc *ahc,
-					   u_int intstat);
 void			ahc_clear_critical_section(struct ahc_softc *ahc);
 
 /***************************** Error Recovery *********************************/
diff -puN drivers/scsi/aic7xxx/aic7xxx_inline.h~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic7xxx_inline.h
--- devel/drivers/scsi/aic7xxx/aic7xxx_inline.h~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_inline.h	2006-06-01 20:41:50.000000000 -0700
@@ -242,8 +242,6 @@ uint16_t ahc_inw(struct ahc_softc *ahc, 
 void	ahc_outw(struct ahc_softc *ahc, u_int port, u_int value);
 uint32_t ahc_inl(struct ahc_softc *ahc, u_int port);
 void	ahc_outl(struct ahc_softc *ahc, u_int port, uint32_t value);
-uint64_t ahc_inq(struct ahc_softc *ahc, u_int port);
-void	ahc_outq(struct ahc_softc *ahc, u_int port, uint64_t value);
 struct scb*
 	ahc_get_scb(struct ahc_softc *ahc);
 void	ahc_free_scb(struct ahc_softc *ahc, struct scb *scb);
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~drivers-scsi-aic7xxx-possible-cleanups-2 drivers/scsi/aic7xxx/aic7xxx_osm.h
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm.h~drivers-scsi-aic7xxx-possible-cleanups-2	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-06-01 20:41:50.000000000 -0700
@@ -392,10 +392,6 @@ static inline void ahc_delay(int usec)
 /***************************** Low Level I/O **********************************/
 uint8_t ahc_inb(struct ahc_softc * ahc, long port);
 void ahc_outb(struct ahc_softc * ahc, long port, uint8_t val);
-void ahc_outsb(struct ahc_softc * ahc, long port,
-	       uint8_t *, int count);
-void ahc_insb(struct ahc_softc * ahc, long port,
-	       uint8_t *, int count);
 
 /**************************** Initialization **********************************/
 int		ahc_linux_register_host(struct ahc_softc *,
_
