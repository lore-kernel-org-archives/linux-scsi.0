From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 13/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:06:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415961BC.1000907@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:62154 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267746AbUI1NGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:06:13 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD6CW02905
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:06:12 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD6Bm31138
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:06:11 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2396-2437)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#14 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c ====
--- /tmp/tmp.26602.0	2004-09-27 13:12:54.008209328 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c	2003-10-21 16:28:58.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#14 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#15 $
   */

  #include "aic7xxx_osm.h"
@@ -267,12 +267,14 @@
  	if (ahc != NULL) {
  		u_long s;

+		TAILQ_REMOVE(&ahc_tailq, ahc, links);
+		ahc_list_unlock(&l);
  		ahc_lock(ahc, &s);
  		ahc_intr_enable(ahc, FALSE);
  		ahc_unlock(ahc, &s);
  		ahc_free(ahc);
-	}
-	ahc_list_unlock(&l);
+	} else
+		ahc_list_unlock(&l);

  	return (0);
  }
==== //depot/aic7xxx/aic7xxx/aic79xx.seq#104 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq ====
--- /tmp/tmp.26602.1	2004-09-27 13:12:54.539128616 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq	2003-10-22 16:44:45.000000000 -0400
@@ -40,7 +40,7 @@
   * $FreeBSD$
   */

-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#104 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#105 $"
  PATCH_ARG_LIST = "struct ahd_softc *ahd"
  PREFIX = "ahd_"

@@ -1701,7 +1701,7 @@
  		test	DFCNTRL, DIRECTION jz interrupt_return;
  		and	DFCNTRL, ~SCSIEN;
  snapshot_wait_data_valid:
-		test	SEQINTSRC, (CTXTDONE|SAVEPTRS) jnz snapshot_data_valid;
+		test	SEQINTSRC, (CTXTDONE|SAVEPTRS) jnz interrupt_return;
  		test	SSTAT1, REQINIT	jz snapshot_wait_data_valid;
  snapshot_data_valid:
  		or	DFCNTRL, SCSIEN;
==== //depot/aic7xxx/aic7xxx/aic79xx.c#217 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.26602.2	2004-09-27 13:12:56.345853952 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2003-10-21 17:17:19.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#217 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#219 $
   *
   * $FreeBSD$
   */
@@ -5176,24 +5176,24 @@
  {
  	struct ahd_softc *list_ahd;

-#if AHD_PCI_CONFIG > 0
+#if AIC_PCI_CONFIG > 0
  	/*
  	 * Second Function PCI devices need to inherit some
  	 * settings from function 0.
  	 */
  	if ((ahd->features & AHD_MULTI_FUNC) != 0) {
  		TAILQ_FOREACH(list_ahd, &ahd_tailq, links) {
-			ahd_dev_softc_t list_pci;
-			ahd_dev_softc_t pci;
+			aic_dev_softc_t list_pci;
+			aic_dev_softc_t pci;

  			list_pci = list_ahd->dev_softc;
  			pci = ahd->dev_softc;
-			if (ahd_get_pci_slot(list_pci) == ahd_get_pci_slot(pci)
-			 && ahd_get_pci_bus(list_pci) == ahd_get_pci_bus(pci)) {
+			if (aic_get_pci_slot(list_pci) == aic_get_pci_slot(pci)
+			 && aic_get_pci_bus(list_pci) == aic_get_pci_bus(pci)) {
  				struct ahd_softc *master;
  				struct ahd_softc *slave;

-				if (ahd_get_pci_function(list_pci) == 0) {
+				if (aic_get_pci_function(list_pci) == 0) {
  					master = list_ahd;
  					slave = ahd;
  				} else {
@@ -5263,7 +5263,6 @@
  	default:
  	case 5:
  		ahd_shutdown(ahd);
-		TAILQ_REMOVE(&ahd_tailq, ahd, links);
  		/* FALLTHROUGH */
  	case 4:
  		aic_dmamap_unload(ahd, ahd->shared_data_dmat,
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#182 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.26602.3	2004-09-27 13:12:57.160730072 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-10-28 15:06:33.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#182 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#188 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -719,7 +719,7 @@
   * number of segments needed for the current transfer.  Since the code that
   * sizes the SCSI malloc pool does not take into consideration fragmentation
   * of the pool, executing transactions numbering just a fraction of our
- * concurrent transaction limit with SG list lengths aproaching AHC_NSEG will
+ * concurrent transaction limit with SG list lengths aproaching AHD_NSEG will
   * quickly depleat the SCSI malloc pool of usable space.  Unfortunately, the
   * mid-layer does not properly handle this scsi malloc failures for the S/G
   * array and the result can be a lockup of the I/O subsystem.  We try to size
@@ -1019,7 +1019,6 @@
  	struct ahd_softc *ahd;
  	u_long l;

-	ahd_list_lock(&l);
  	if (host != NULL) {

  		/*
@@ -1027,17 +1026,20 @@
  		 * the free directly, but check our
  		 * list for extra sanity.
  		 */
+		ahd_list_lock(&l);
  		ahd = ahd_find_softc(*(struct ahd_softc **)host->hostdata);
  		if (ahd != NULL) {
  			u_long s;

+			TAILQ_REMOVE(&ahd_tailq, ahd, links);
+			ahd_list_unlock(&l);
  			ahd_lock(ahd, &s);
  			ahd_intr_enable(ahd, FALSE);
  			ahd_unlock(ahd, &s);
  			ahd_free(ahd);
-		}
+		} else
+			ahd_list_unlock(&l);
  	}
-	ahd_list_unlock(&l);
  	return (0);
  }
  #endif
@@ -1854,19 +1856,19 @@

  	/* Still equal.  Sort by bus/slot/func. */
  	if (aic79xx_reverse_scan != 0)
-		value = ahd_get_pci_bus(lahd->dev_softc)
-		      - ahd_get_pci_bus(rahd->dev_softc);
+		value = aic_get_pci_bus(lahd->dev_softc)
+		      - aic_get_pci_bus(rahd->dev_softc);
  	else
-		value = ahd_get_pci_bus(rahd->dev_softc)
-		      - ahd_get_pci_bus(lahd->dev_softc);
+		value = aic_get_pci_bus(rahd->dev_softc)
+		      - aic_get_pci_bus(lahd->dev_softc);
  	if (value != 0)
  		return (value);
  	if (aic79xx_reverse_scan != 0)
-		value = ahd_get_pci_slot(lahd->dev_softc)
-		      - ahd_get_pci_slot(rahd->dev_softc);
+		value = aic_get_pci_slot(lahd->dev_softc)
+		      - aic_get_pci_slot(rahd->dev_softc);
  	else
-		value = ahd_get_pci_slot(rahd->dev_softc)
-		      - ahd_get_pci_slot(lahd->dev_softc);
+		value = aic_get_pci_slot(rahd->dev_softc)
+		      - aic_get_pci_slot(lahd->dev_softc);
  	if (value != 0)
  		return (value);

@@ -2054,8 +2056,12 @@
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
  	scsi_assign_lock(host, &ahd->platform_data->spin_lock);
  #elif AHD_SCSI_HAS_HOST_LOCK != 0
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,21)
+	host->host_lock = &ahd->platform_data->spin_lock;
+#else
  	host->lock = &ahd->platform_data->spin_lock;
  #endif
+#endif
  	ahd->platform_data->host = host;
  	host->can_queue = AHD_MAX_QUEUE;
  	host->cmd_per_lun = 2;
@@ -2202,17 +2208,6 @@
  		ahd_update_neg_request(ahd, &devinfo, tstate,
  				       tinfo, AHD_NEG_ALWAYS);
  	}
-	/* Give the bus some time to recover */
-	if ((ahd->flags & AHD_RESET_BUS_A) != 0) {
-		aic_freeze_simq(ahd);
-		init_timer(&ahd->platform_data->reset_timer);
-		ahd->platform_data->reset_timer.data = (u_long)ahd;
-		ahd->platform_data->reset_timer.expires =
-		    jiffies + (AIC79XX_RESET_DELAY * HZ)/1000;
-		ahd->platform_data->reset_timer.function =
-		    (aic_linux_callback_t *)aic_release_simq;
-		add_timer(&ahd->platform_data->reset_timer);
-	}
  }

  int
@@ -2229,6 +2224,10 @@
  	ahd->platform_data->hw_dma_mask = 0xFFFFFFFF;
  	ahd_lockinit(ahd);
  	ahd_done_lockinit(ahd);
+	init_timer(&ahd->platform_data->bus_settle_timer);
+	ahd->platform_data->bus_settle_timer.data = (u_long)ahd;
+	ahd->platform_data->bus_settle_timer.function =
+	    (aic_linux_callback_t *)aic_bus_settle_complete;
  	init_timer(&ahd->platform_data->completeq_timer);
  	ahd->platform_data->completeq_timer.data = (u_long)ahd;
  	ahd->platform_data->completeq_timer.function =
@@ -3196,7 +3195,17 @@
  			}
  #endif
  			if (echo_size == 0) {
-				AHD_SET_DV_STATE(ahd, targ, AIC_DV_STATE_EXIT);
+				/*
+				 * Fall back to basic DV.
+				 */
+				if (bootverbose) {
+					ahd_print_devinfo(ahd, devinfo);
+					printf("Echo Buffer unavailable.  "
+					       "Performing basic DV.\n");
+				}
+				targ->flags &= ~AIC_ENHANCED_DV;
+				targ->flags |= AIC_BASIC_DV;
+				AHD_SET_DV_STATE(ahd, targ, AIC_DV_STATE_TUR);
  				break;
  			}

@@ -3778,17 +3787,6 @@
  		aic_set_transaction_status(scb, CAM_CMD_TIMEOUT);
  	ahd_reset_channel(ahd, cmd->device->channel + 'A', /*initiate*/TRUE);

-	/*
-	 * Add a minimal bus settle delay for devices that are slow to
-	 * respond after bus resets.
-	 */
-	aic_freeze_simq(ahd);
-	init_timer(&ahd->platform_data->reset_timer);
-	ahd->platform_data->reset_timer.data = (u_long)ahd;
-	ahd->platform_data->reset_timer.expires = jiffies + HZ / 2;
-	ahd->platform_data->reset_timer.function =
-	    (aic_linux_callback_t *)aic_release_simq;
-	add_timer(&ahd->platform_data->reset_timer);
  	if (aic_linux_next_device_to_run(ahd) != NULL)
  		aic_schedule_runq(ahd);
  	ahd_linux_run_complete_queue(ahd);
@@ -4401,6 +4399,20 @@
  					      channel - 'A');
  		}
  #endif
+		/*
+		 * Add a minimal bus settle delay for devices that are slow to
+		 * respond after bus resets.
+		 */
+		if ((ahd->platform_data->flags & AIC_BUS_SETTLE_TIMER) == 0) {
+			aic_freeze_simq(ahd);
+			ahd->platform_data->flags |= AIC_BUS_SETTLE_TIMER;
+			ahd->platform_data->bus_settle_timer.expires =
+			    jiffies + (AIC79XX_RESET_DELAY * HZ)/1000;
+			add_timer(&ahd->platform_data->bus_settle_timer);
+		} else {
+			mod_timer(&ahd->platform_data->bus_settle_timer,
+				  jiffies + (AIC79XX_RESET_DELAY * HZ)/1000);
+		}
                  break;
          default:
                  panic("ahd_send_async: Unexpected async event");
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#147 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.26602.4	2004-09-27 13:12:57.247716848 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-10-21 15:48:41.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#147 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#149 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
@@ -96,11 +96,6 @@
  /* No debugging code. */
  #endif

-/************************* Forward Declarations *******************************/
-struct ahd_softc;
-typedef struct pci_dev *ahd_dev_softc_t;
-typedef Scsi_Cmnd      *ahd_io_ctx_t;
-
  /************************* Configuration Data *********************************/
  extern uint32_t aic79xx_allow_memio;
  extern int aic79xx_detect_complete;
@@ -132,7 +127,7 @@
  #define AHD_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.2"
+#define AIC79XX_DRIVER_VERSION "2.0.3"

  /********************* Definitions Required by the Core ***********************/
  /*
@@ -168,29 +163,6 @@
  void			ahd_set_recoveryscb(struct ahd_softc *ahd,
  					    struct scb *scb);

-/************************** OS Utility Wrappers *******************************/
-#define printf printk
-#define M_NOWAIT GFP_ATOMIC
-#define M_WAITOK 0
-#define malloc(size, type, flags) kmalloc(size, flags)
-#define free(ptr, type) kfree(ptr)
-
-static __inline void ahd_delay(long);
-static __inline void
-ahd_delay(long usec)
-{
-	/*
-	 * udelay on Linux can have problems for
-	 * multi-millisecond waits.  Wait at most
-	 * 1024us per call.
-	 */
-	while (usec > 0) {
-		udelay(usec % 1024);
-		usec -= 1024;
-	}
-}
-
-
  /***************************** Low Level I/O **********************************/
  static __inline uint8_t ahd_inb(struct ahd_softc * ahd, long port);
  static __inline uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
@@ -201,6 +173,7 @@
  			       uint8_t *, int count);
  static __inline void ahd_insb(struct ahd_softc * ahd, long port,
  			       uint8_t *, int count);
+static __inline void ahd_flush_device_writes(struct ahd_softc *);

  static __inline uint8_t
  ahd_inb(struct ahd_softc * ahd, long port)
@@ -280,6 +253,13 @@
  		*array++ = ahd_inb(ahd, port);
  }

+static __inline void
+ahd_flush_device_writes(struct ahd_softc *ahd)
+{
+	/* XXX Is this sufficient for all architectures??? */
+	ahd_inb(ahd, INTSTAT);
+}
+
  /**************************** Initialization **********************************/
  int		ahd_linux_register_host(struct ahd_softc *,
  					Scsi_Host_Template *);
@@ -418,110 +398,6 @@
  int			 ahd_pci_map_registers(struct ahd_softc *ahd);
  int			 ahd_pci_map_int(struct ahd_softc *ahd);

-static __inline uint32_t ahd_pci_read_config(ahd_dev_softc_t pci,
-					     int reg, int width);
-
-static __inline uint32_t
-ahd_pci_read_config(ahd_dev_softc_t pci, int reg, int width)
-{
-	switch (width) {
-	case 1:
-	{
-		uint8_t retval;
-
-		pci_read_config_byte(pci, reg, &retval);
-		return (retval);
-	}
-	case 2:
-	{
-		uint16_t retval;
-		pci_read_config_word(pci, reg, &retval);
-		return (retval);
-	}
-	case 4:
-	{
-		uint32_t retval;
-		pci_read_config_dword(pci, reg, &retval);
-		return (retval);
-	}
-	default:
-		panic("ahd_pci_read_config: Read size too big");
-		/* NOTREACHED */
-		return (0);
-	}
-}
-
-static __inline void ahd_pci_write_config(ahd_dev_softc_t pci,
-					  int reg, uint32_t value,
-					  int width);
-
-static __inline void
-ahd_pci_write_config(ahd_dev_softc_t pci, int reg, uint32_t value, int width)
-{
-	switch (width) {
-	case 1:
-		pci_write_config_byte(pci, reg, value);
-		break;
-	case 2:
-		pci_write_config_word(pci, reg, value);
-		break;
-	case 4:
-		pci_write_config_dword(pci, reg, value);
-		break;
-	default:
-		panic("ahd_pci_write_config: Write size too big");
-		/* NOTREACHED */
-	}
-}
-
-static __inline int ahd_get_pci_function(ahd_dev_softc_t);
-static __inline int
-ahd_get_pci_function(ahd_dev_softc_t pci)
-{
-	return (PCI_FUNC(pci->devfn));
-}
-
-static __inline int ahd_get_pci_slot(ahd_dev_softc_t);
-static __inline int
-ahd_get_pci_slot(ahd_dev_softc_t pci)
-{
-	return (PCI_SLOT(pci->devfn));
-}
-
-static __inline int ahd_get_pci_bus(ahd_dev_softc_t);
-static __inline int
-ahd_get_pci_bus(ahd_dev_softc_t pci)
-{
-	return (pci->bus->number);
-}
-
-static __inline void ahd_flush_device_writes(struct ahd_softc *);
-static __inline void
-ahd_flush_device_writes(struct ahd_softc *ahd)
-{
-	/* XXX Is this sufficient for all architectures??? */
-	ahd_inb(ahd, INTSTAT);
-}
-
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,3,0)
-#define pci_map_sg(pdev, sg_list, nseg, direction) (nseg)
-#define pci_unmap_sg(pdev, sg_list, nseg, direction)
-#define sg_dma_address(sg) (VIRT_TO_BUS((sg)->address))
-#define sg_dma_len(sg) ((sg)->length)
-#define pci_map_single(pdev, buffer, bufflen, direction) \
-	(VIRT_TO_BUS(buffer))
-#define pci_unmap_single(pdev, buffer, buflen, direction)
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,3)
-#define ahd_pci_set_dma_mask pci_set_dma_mask
-#else
-/*
- * Always "return" 0 for success.
- */
-#define ahd_pci_set_dma_mask(dev_softc, mask)	\
-	(((dev_softc)->dma_mask = mask) && 0)
-#endif
  /**************************** Proc FS Support *********************************/
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  int	ahd_linux_proc_info(char *, char **, off_t, int, int, int);
@@ -552,9 +428,9 @@
  void	ahd_platform_dump_card_state(struct ahd_softc *ahd);

  #ifdef CONFIG_PCI
-#define AHD_PCI_CONFIG 1
+#define AIC_PCI_CONFIG 1
  #else
-#define AHD_PCI_CONFIG 0
+#define AIC_PCI_CONFIG 0
  #endif
  #define bootverbose aic79xx_verbose
  extern uint32_t aic79xx_verbose;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#26 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c ====
--- /tmp/tmp.26602.5	2004-09-27 13:12:57.315706512 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2003-10-21 16:30:24.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#26 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#28 $
   */

  #include "aic79xx_osm.h"
@@ -98,12 +98,14 @@
  	if (ahd != NULL) {
  		u_long s;

+		TAILQ_REMOVE(&ahd_tailq, ahd, links);
+		ahd_list_unlock(&l);
  		ahd_lock(ahd, &s);
  		ahd_intr_enable(ahd, FALSE);
  		ahd_unlock(ahd, &s);
  		ahd_free(ahd);
-	}
-	ahd_list_unlock(&l);
+	} else
+		ahd_list_unlock(&l);
  }
  #endif /* !LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) */

@@ -112,7 +114,7 @@
  {
  	char		 buf[80];
  	struct		 ahd_softc *ahd;
-	ahd_dev_softc_t	 pci;
+	aic_dev_softc_t	 pci;
  	struct		 ahd_pci_identity *entry;
  	char		*name;
  	int		 error;
@@ -144,9 +146,9 @@
  	 * common detect routine.
  	 */
  	sprintf(buf, "ahd_pci:%d:%d:%d",
-		ahd_get_pci_bus(pci),
-		ahd_get_pci_slot(pci),
-		ahd_get_pci_function(pci));
+		aic_get_pci_bus(pci),
+		aic_get_pci_slot(pci),
+		aic_get_pci_function(pci));
  	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
  	if (name == NULL)
  		return (-ENOMEM);
@@ -170,16 +172,16 @@
  		mask_64bit = (bus_addr_t)0xFFFFFFFFFFFFFFFFULL;
  		mask_39bit = (bus_addr_t)0x7FFFFFFFFFULL;
  		if (memsize >= 0x8000000000ULL
-	 	 && ahd_pci_set_dma_mask(pdev, mask_64bit) == 0) {
+	 	 && aic_pci_set_dma_mask(pdev, mask_64bit) == 0) {
  			ahd->flags |= AHD_64BIT_ADDRESSING;
  			ahd->platform_data->hw_dma_mask = mask_64bit;
  		} else if (memsize > 0x80000000
-			&& ahd_pci_set_dma_mask(pdev, mask_39bit) == 0) {
+			&& aic_pci_set_dma_mask(pdev, mask_39bit) == 0) {
  			ahd->flags |= AHD_39BIT_ADDRESSING;
  			ahd->platform_data->hw_dma_mask = mask_39bit;
  		}
  	} else {
-		ahd_pci_set_dma_mask(pdev, 0xFFFFFFFF);
+		aic_pci_set_dma_mask(pdev, 0xFFFFFFFF);
  		ahd->platform_data->hw_dma_mask = 0xFFFFFFFF;
  	}
  #endif
@@ -222,7 +224,7 @@
  	pdev = NULL;
  	class = PCI_CLASS_STORAGE_SCSI << 8;
  	while ((pdev = pci_find_class(class, pdev)) != NULL) {
-		ahd_dev_softc_t pci;
+		aic_dev_softc_t pci;
  		int error;

  		pci = pdev;
@@ -253,8 +255,8 @@
  	 */
  	*base2 = pci_resource_start(ahd->dev_softc, 3);
  #else
-	*base = ahd_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR0, 4);
-	*base2 = ahd_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR1, 4);
+	*base = aic_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR0, 4);
+	*base2 = aic_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR1, 4);
  	*base &= PCI_BASE_ADDRESS_IO_MASK;
  	*base2 &= PCI_BASE_ADDRESS_IO_MASK;
  #endif
@@ -299,7 +301,7 @@
  	base_page = start & PAGE_MASK;
  	base_offset = start - base_page;
  #else
-	start = ahd_pci_read_config(ahd->dev_softc, PCIR_MAPS+4, 4);
+	start = aic_pci_read_config(ahd->dev_softc, PCIR_MAPS+4, 4);
  	base_offset = start & PCI_BASE_ADDRESS_MEM_MASK;
  	base_page = base_offset & PAGE_MASK;
  	base_offset -= base_page;
@@ -336,7 +338,7 @@
  	/*
  	 * If its allowed, we prefer memory mapped access.
  	 */
-	command = ahd_pci_read_config(ahd->dev_softc, PCIR_COMMAND, 4);
+	command = aic_pci_read_config(ahd->dev_softc, PCIR_COMMAND, 4);
  	command &= ~(PCIM_CMD_PORTEN|PCIM_CMD_MEMEN);
  	base = 0;
  	maddr = NULL;
@@ -347,16 +349,16 @@
  		ahd->bshs[0].maddr = maddr;
  		ahd->tags[1] = BUS_SPACE_MEMIO;
  		ahd->bshs[1].maddr = maddr + 0x100;
-		ahd_pci_write_config(ahd->dev_softc, PCIR_COMMAND,
+		aic_pci_write_config(ahd->dev_softc, PCIR_COMMAND,
  				     command | PCIM_CMD_MEMEN, 4);

  		if (ahd_pci_test_register_access(ahd) != 0) {

  			printf("aic79xx: PCI Device %d:%d:%d "
  			       "failed memory mapped test.  Using PIO.\n",
-			       ahd_get_pci_bus(ahd->dev_softc),
-			       ahd_get_pci_slot(ahd->dev_softc),
-			       ahd_get_pci_function(ahd->dev_softc));
+			       aic_get_pci_bus(ahd->dev_softc),
+			       aic_get_pci_slot(ahd->dev_softc),
+			       aic_get_pci_function(ahd->dev_softc));
  			iounmap((void *)((u_long)maddr & PAGE_MASK));
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  			release_mem_region(ahd->platform_data->mem_busaddr,
@@ -369,9 +371,9 @@
  	} else if (bootverbose) {
  		printf("aic79xx: PCI%d:%d:%d MEM region 0x%lx "
  		       "unavailable. Cannot memory map device.\n",
-		       ahd_get_pci_bus(ahd->dev_softc),
-		       ahd_get_pci_slot(ahd->dev_softc),
-		       ahd_get_pci_function(ahd->dev_softc),
+		       aic_get_pci_bus(ahd->dev_softc),
+		       aic_get_pci_slot(ahd->dev_softc),
+		       aic_get_pci_function(ahd->dev_softc),
  		       base);
  	}

@@ -388,13 +390,13 @@
  		} else {
  			printf("aic79xx: PCI%d:%d:%d IO regions 0x%lx and 0x%lx"
  			       "unavailable. Cannot map device.\n",
-			       ahd_get_pci_bus(ahd->dev_softc),
-			       ahd_get_pci_slot(ahd->dev_softc),
-			       ahd_get_pci_function(ahd->dev_softc),
+			       aic_get_pci_bus(ahd->dev_softc),
+			       aic_get_pci_slot(ahd->dev_softc),
+			       aic_get_pci_function(ahd->dev_softc),
  			       base, base2);
  		}
  	}
-	ahd_pci_write_config(ahd->dev_softc, PCIR_COMMAND, command, 4);
+	aic_pci_write_config(ahd->dev_softc, PCIR_COMMAND, command, 4);
  	return (error);
  }

==== //depot/aic7xxx/aic7xxx/aic79xx_pci.c#81 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c ====
--- /tmp/tmp.26602.6	2004-09-27 13:12:57.475682192 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2003-10-31 17:54:03.000000000 -0500
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#81 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#83 $
   *
   * $FreeBSD$
   */
@@ -75,13 +75,13 @@
  #define ID_AHA_29320ALP			0x8017900500449005ull

  #define ID_AIC7901A			0x801E9005FFFF9005ull
-#define ID_AHA_29320			0x8012900500429005ull
-#define ID_AHA_29320B			0x8013900500439005ull
  #define ID_AHA_29320LP			0x8014900500449005ull

  #define ID_AIC7902			0x801F9005FFFF9005ull
  #define ID_AIC7902_B			0x801D9005FFFF9005ull
  #define ID_AHA_39320			0x8010900500409005ull
+#define ID_AHA_29320			0x8012900500429005ull
+#define ID_AHA_29320B			0x8013900500439005ull
  #define ID_AHA_39320_B			0x8015900500409005ull
  #define ID_AHA_39320A			0x8016900500409005ull
  #define ID_AHA_39320D			0x8011900500419005ull
@@ -136,24 +136,24 @@
  	},
  	/* aic7901A based controllers */
  	{
-		ID_AHA_29320,
+		ID_AHA_29320LP,
  		ID_ALL_MASK,
-		"Adaptec 29320 Ultra320 SCSI adapter",
+		"Adaptec 29320LP Ultra320 SCSI adapter",
  		ahd_aic7901A_setup
  	},
+	/* aic7902 based controllers */	
  	{
-		ID_AHA_29320B,
+		ID_AHA_29320,
  		ID_ALL_MASK,
-		"Adaptec 29320B Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
+		"Adaptec 29320 Ultra320 SCSI adapter",
+		ahd_aic7902_setup
  	},
  	{
-		ID_AHA_29320LP,
+		ID_AHA_29320B,
  		ID_ALL_MASK,
-		"Adaptec 29320LP Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
+		"Adaptec 29320B Ultra320 SCSI adapter",
+		ahd_aic7902_setup
  	},
-	/* aic7902 based controllers */	
  	{
  		ID_AHA_39320,
  		ID_ALL_MASK,
@@ -196,18 +196,6 @@
  		"Adaptec (HP OEM) 39320D Ultra320 SCSI adapter",
  		ahd_aic7902_setup
  	},
-	{
-		ID_AHA_29320,
-		ID_ALL_MASK,
-		"Adaptec 29320 Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_29320B,
-		ID_ALL_MASK,
-		"Adaptec 29320B Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
  	/* Generic chip probes for devices we don't know 'exactly' */
  	{
  		ID_AIC7901 & ID_DEV_VENDOR_MASK,
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_reg.h#75 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped ====
--- /tmp/tmp.26602.7	2004-09-27 13:12:58.014600264 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped	2003-10-24 13:37:10.000000000 -0400
@@ -2,7 +2,7 @@
   * DO NOT EDIT - This file is automatically generated
   *		 from the following source files:
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#104 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#105 $
   * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#70 $
   */
  typedef int (ahd_reg_print_t)(u_int, u_int *, u_int);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_reg_print.c#56 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped ====
--- /tmp/tmp.26602.8	2004-09-27 13:12:58.508525176 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped	2003-10-24 13:37:10.000000000 -0400
@@ -2,7 +2,7 @@
   * DO NOT EDIT - This file is automatically generated
   *		 from the following source files:
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#104 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#105 $
   * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#70 $
   */

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_seq.h#76 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped ====
--- /tmp/tmp.26602.9	2004-09-27 13:12:58.663501616 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	2003-10-24 13:37:10.000000000 -0400
@@ -2,7 +2,7 @@
   * DO NOT EDIT - This file is automatically generated
   *		 from the following source files:
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#104 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#105 $
   * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#70 $
   */
  static uint8_t seqprog[] = {
@@ -631,7 +631,7 @@
  	0x11, 0x00, 0x00, 0x10,
  	0x04, 0x19, 0x08, 0x7d,
  	0xdf, 0x19, 0x32, 0x08,
-	0x60, 0x5b, 0xe6, 0x6c,
+	0x60, 0x5b, 0x08, 0x6d,
  	0x01, 0x4c, 0xe2, 0x7c,
  	0x20, 0x19, 0x32, 0x00,
  	0x01, 0xd9, 0xb2, 0x05,
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#142 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.26602.10	2004-09-27 13:13:00.070287752 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2003-10-27 15:26:05.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#142 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#144 $
   *
   * $FreeBSD$
   */
@@ -3974,7 +3974,6 @@
  	default:
  	case 5:
  		ahc_shutdown(ahc);
-		TAILQ_REMOVE(&ahc_tailq, ahc, links);
  		/* FALLTHROUGH */
  	case 4:
  		aic_dmamap_unload(ahc, ahc->shared_data_dmat,
@@ -4083,14 +4082,6 @@
  	 * to disturb the integrity of the bus.
  	 */
  	ahc_pause(ahc);
-	if ((ahc_inb(ahc, HCNTRL) & CHIPRST) != 0) {
-		/*
-		 * The chip has not been initialized since
-		 * PCI/EISA/VLB bus reset.  Don't trust
-		 * "left over BIOS data".
-		 */
-		ahc->flags |= AHC_NO_BIOS_INIT;
-	}
  	sxfrctl1_b = 0;
  	if ((ahc->chip & AHC_CHIPID_MASK) == AHC_AIC7770) {
  		u_int sblkctl;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#246 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.26602.11	2004-09-27 13:13:01.050138792 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-10-28 02:06:07.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#246 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#251 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -1025,7 +1025,6 @@
  	struct ahc_softc *ahc;
  	u_long l;

-	ahc_list_lock(&l);
  	if (host != NULL) {

  		/*
@@ -1033,17 +1032,20 @@
  		 * the free directly, but check our
  		 * list for extra sanity.
  		 */
+		ahc_list_lock(&l);
  		ahc = ahc_find_softc(*(struct ahc_softc **)host->hostdata);
  		if (ahc != NULL) {
  			u_long s;

+			TAILQ_REMOVE(&ahc_tailq, ahc, links);
+			ahc_list_unlock(&l);
  			ahc_lock(ahc, &s);
  			ahc_intr_enable(ahc, FALSE);
  			ahc_unlock(ahc, &s);
  			ahc_free(ahc);
-		}
+		} else
+			ahc_list_unlock(&l);
  	}
-	ahc_list_unlock(&l);
  	return (0);
  }
  #endif
@@ -1512,19 +1514,19 @@
  		char primary_channel;

  		if (aic7xxx_reverse_scan != 0)
-			value = ahc_get_pci_bus(lahc->dev_softc)
-			      - ahc_get_pci_bus(rahc->dev_softc);
+			value = aic_get_pci_bus(lahc->dev_softc)
+			      - aic_get_pci_bus(rahc->dev_softc);
  		else
-			value = ahc_get_pci_bus(rahc->dev_softc)
-			      - ahc_get_pci_bus(lahc->dev_softc);
+			value = aic_get_pci_bus(rahc->dev_softc)
+			      - aic_get_pci_bus(lahc->dev_softc);
  		if (value != 0)
  			break;
  		if (aic7xxx_reverse_scan != 0)
-			value = ahc_get_pci_slot(lahc->dev_softc)
-			      - ahc_get_pci_slot(rahc->dev_softc);
+			value = aic_get_pci_slot(lahc->dev_softc)
+			      - aic_get_pci_slot(rahc->dev_softc);
  		else
-			value = ahc_get_pci_slot(rahc->dev_softc)
-			      - ahc_get_pci_slot(lahc->dev_softc);
+			value = aic_get_pci_slot(rahc->dev_softc)
+			      - aic_get_pci_slot(lahc->dev_softc);
  		if (value != 0)
  			break;
  		/*
@@ -1695,8 +1697,12 @@
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
  	scsi_assign_lock(host, &ahc->platform_data->spin_lock);
  #elif AHC_SCSI_HAS_HOST_LOCK != 0
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,21)
+	host->host_lock = &ahc->platform_data->spin_lock;
+#else
  	host->lock = &ahc->platform_data->spin_lock;
  #endif
+#endif
  	ahc->platform_data->host = host;
  	host->can_queue = AHC_MAX_QUEUE;
  	host->cmd_per_lun = 2;
@@ -1876,17 +1882,6 @@
  		ahc_update_neg_request(ahc, &devinfo, tstate,
  				       tinfo, AHC_NEG_ALWAYS);
  	}
-	/* Give the bus some time to recover */
-	if ((ahc->flags & (AHC_RESET_BUS_A|AHC_RESET_BUS_B)) != 0) {
-		aic_freeze_simq(ahc);
-		init_timer(&ahc->platform_data->reset_timer);
-		ahc->platform_data->reset_timer.data = (u_long)ahc;
-		ahc->platform_data->reset_timer.expires =
-		    jiffies + (AIC7XXX_RESET_DELAY * HZ)/1000;
-		ahc->platform_data->reset_timer.function =
-		    (aic_linux_callback_t *)aic_release_simq;
-		add_timer(&ahc->platform_data->reset_timer);
-	}
  }

  int
@@ -1904,6 +1899,10 @@
  	ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
  	ahc_lockinit(ahc);
  	ahc_done_lockinit(ahc);
+	init_timer(&ahc->platform_data->bus_settle_timer);
+	ahc->platform_data->bus_settle_timer.data = (u_long)ahc;
+	ahc->platform_data->bus_settle_timer.function =
+	    (aic_linux_callback_t *)aic_bus_settle_complete;
  	init_timer(&ahc->platform_data->completeq_timer);
  	ahc->platform_data->completeq_timer.data = (u_long)ahc;
  	ahc->platform_data->completeq_timer.function =
@@ -2864,7 +2863,17 @@
  			}
  #endif
  			if (echo_size == 0) {
-				AHC_SET_DV_STATE(ahc, targ, AIC_DV_STATE_EXIT);
+				/*
+				 * Fall back to basic DV.
+				 */
+				if (bootverbose) {
+					ahc_print_devinfo(ahc, devinfo);
+					printf("Echo Buffer unavailable.  "
+					       "Performing basic DV.\n");
+				}
+				targ->flags &= ~AIC_ENHANCED_DV;
+				targ->flags |= AIC_BASIC_DV;
+				AHC_SET_DV_STATE(ahc, targ, AIC_DV_STATE_TUR);
  				break;
  			}

@@ -3441,19 +3450,9 @@
  		aic_set_transaction_status(scb, CAM_CMD_TIMEOUT);
  	ahc_reset_channel(ahc, cmd->device->channel + 'A', /*initiate*/TRUE);

-	/*
-	 * Add a minimal bus settle delay for devices that are slow to
-	 * respond after bus resets.
-	 */
-	aic_freeze_simq(ahc);
-	init_timer(&ahc->platform_data->reset_timer);
-	ahc->platform_data->reset_timer.data = (u_long)ahc;
-	ahc->platform_data->reset_timer.expires = jiffies + HZ / 2;
-	ahc->platform_data->reset_timer.function =
-	    (aic_linux_callback_t *)aic_release_simq;
-	add_timer(&ahc->platform_data->reset_timer);
  	if (aic_linux_next_device_to_run(ahc) != NULL)
  		aic_schedule_runq(ahc);
+
  	ahc_linux_run_complete_queue(ahc);
  	ahc_unlock(ahc, &flags);
  }
@@ -4094,6 +4093,20 @@
  					      channel - 'A');
  		}
  #endif
+		/*
+		 * Add a minimal bus settle delay for devices that are slow to
+		 * respond after bus resets.
+		 */
+		if ((ahc->platform_data->flags & AIC_BUS_SETTLE_TIMER) == 0) {
+			aic_freeze_simq(ahc);
+			ahc->platform_data->flags |= AIC_BUS_SETTLE_TIMER;
+			ahc->platform_data->bus_settle_timer.expires =
+			    jiffies + (AIC7XXX_RESET_DELAY * HZ)/1000;
+			add_timer(&ahc->platform_data->bus_settle_timer);
+		} else {
+			mod_timer(&ahc->platform_data->bus_settle_timer,
+				  jiffies + (AIC7XXX_RESET_DELAY * HZ)/1000);
+		}
                  break;
          default:
                  panic("ahc_send_async: Unexpected async event");
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#159 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.26602.12	2004-09-27 13:13:01.127127088 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-10-27 20:53:51.000000000 -0500
@@ -53,7 +53,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#159 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#162 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
@@ -111,11 +111,6 @@
  /* No debugging code. */
  #endif

-/************************* Forward Declarations *******************************/
-struct ahc_softc;
-typedef struct pci_dev *ahc_dev_softc_t;
-typedef Scsi_Cmnd      *ahc_io_ctx_t;
-
  /************************* Configuration Data *********************************/
  extern u_int aic7xxx_no_probe;
  extern u_int aic7xxx_allow_memio;
@@ -148,7 +143,7 @@
  #define AHC_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC7XXX_DRIVER_VERSION "6.3.0"
+#define AIC7XXX_DRIVER_VERSION "6.3.2"

  /********************* Definitions Required by the Core ***********************/
  /*
@@ -184,29 +179,6 @@
  void			ahc_set_recoveryscb(struct ahc_softc *ahc,
  					    struct scb *scb);

-/************************** OS Utility Wrappers *******************************/
-#define printf printk
-#define M_NOWAIT GFP_ATOMIC
-#define M_WAITOK 0
-#define malloc(size, type, flags) kmalloc(size, flags)
-#define free(ptr, type) kfree(ptr)
-
-static __inline void ahc_delay(long);
-static __inline void
-ahc_delay(long usec)
-{
-	/*
-	 * udelay on Linux can have problems for
-	 * multi-millisecond waits.  Wait at most
-	 * 1024us per call.
-	 */
-	while (usec > 0) {
-		udelay(usec % 1024);
-		usec -= 1024;
-	}
-}
-
-
  /***************************** Low Level I/O **********************************/
  static __inline uint8_t ahc_inb(struct ahc_softc * ahc, long port);
  static __inline void ahc_outb(struct ahc_softc * ahc, long port, uint8_t val);
@@ -214,6 +186,7 @@
  			       uint8_t *, int count);
  static __inline void ahc_insb(struct ahc_softc * ahc, long port,
  			       uint8_t *, int count);
+static __inline void ahc_flush_device_writes(struct ahc_softc *);

  static __inline uint8_t
  ahc_inb(struct ahc_softc * ahc, long port)
@@ -268,6 +241,13 @@
  		*array++ = ahc_inb(ahc, port);
  }

+static __inline void
+ahc_flush_device_writes(struct ahc_softc *ahc)
+{
+	/* XXX Is this sufficient for all architectures??? */
+	ahc_inb(ahc, INTSTAT);
+}
+
  /**************************** Initialization **********************************/
  int		ahc_linux_register_host(struct ahc_softc *,
  					Scsi_Host_Template *);
@@ -422,112 +402,8 @@
  void			 ahc_linux_pci_exit(void);
  int			 ahc_pci_map_registers(struct ahc_softc *ahc);
  int			 ahc_pci_map_int(struct ahc_softc *ahc);
+#endif

-static __inline uint32_t ahc_pci_read_config(ahc_dev_softc_t pci,
-					     int reg, int width);
-
-static __inline uint32_t
-ahc_pci_read_config(ahc_dev_softc_t pci, int reg, int width)
-{
-	switch (width) {
-	case 1:
-	{
-		uint8_t retval;
-
-		pci_read_config_byte(pci, reg, &retval);
-		return (retval);
-	}
-	case 2:
-	{
-		uint16_t retval;
-		pci_read_config_word(pci, reg, &retval);
-		return (retval);
-	}
-	case 4:
-	{
-		uint32_t retval;
-		pci_read_config_dword(pci, reg, &retval);
-		return (retval);
-	}
-	default:
-		panic("ahc_pci_read_config: Read size too big");
-		/* NOTREACHED */
-		return (0);
-	}
-}
-
-static __inline void ahc_pci_write_config(ahc_dev_softc_t pci,
-					  int reg, uint32_t value,
-					  int width);
-
-static __inline void
-ahc_pci_write_config(ahc_dev_softc_t pci, int reg, uint32_t value, int width)
-{
-	switch (width) {
-	case 1:
-		pci_write_config_byte(pci, reg, value);
-		break;
-	case 2:
-		pci_write_config_word(pci, reg, value);
-		break;
-	case 4:
-		pci_write_config_dword(pci, reg, value);
-		break;
-	default:
-		panic("ahc_pci_write_config: Write size too big");
-		/* NOTREACHED */
-	}
-}
-
-static __inline int ahc_get_pci_function(ahc_dev_softc_t);
-static __inline int
-ahc_get_pci_function(ahc_dev_softc_t pci)
-{
-	return (PCI_FUNC(pci->devfn));
-}
-
-static __inline int ahc_get_pci_slot(ahc_dev_softc_t);
-static __inline int
-ahc_get_pci_slot(ahc_dev_softc_t pci)
-{
-	return (PCI_SLOT(pci->devfn));
-}
-
-static __inline int ahc_get_pci_bus(ahc_dev_softc_t);
-static __inline int
-ahc_get_pci_bus(ahc_dev_softc_t pci)
-{
-	return (pci->bus->number);
-}
-#endif
-
-static __inline void ahc_flush_device_writes(struct ahc_softc *);
-static __inline void
-ahc_flush_device_writes(struct ahc_softc *ahc)
-{
-	/* XXX Is this sufficient for all architectures??? */
-	ahc_inb(ahc, INTSTAT);
-}
-
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,3,0)
-#define pci_map_sg(pdev, sg_list, nseg, direction) (nseg)
-#define pci_unmap_sg(pdev, sg_list, nseg, direction)
-#define sg_dma_address(sg) (VIRT_TO_BUS((sg)->address))
-#define sg_dma_len(sg) ((sg)->length)
-#define pci_map_single(pdev, buffer, bufflen, direction) \
-	(VIRT_TO_BUS(buffer))
-#define pci_unmap_single(pdev, buffer, buflen, direction)
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,3)
-#define ahc_pci_set_dma_mask pci_set_dma_mask
-#else
-/*
- * Always "return" 0 for success.
- */
-#define ahc_pci_set_dma_mask(dev_softc, mask)  			\
-	(((dev_softc)->dma_mask = mask) && 0)
-#endif
  /**************************** Proc FS Support *********************************/
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  int	ahc_linux_proc_info(char *, char **, off_t, int, int, int);
@@ -562,9 +438,9 @@
  void	ahc_platform_dump_card_state(struct ahc_softc *ahc);

  #ifdef CONFIG_PCI
-#define AHC_PCI_CONFIG 1
+#define AIC_PCI_CONFIG 1
  #else
-#define AHC_PCI_CONFIG 0
+#define AIC_PCI_CONFIG 0
  #endif
  #define bootverbose aic7xxx_verbose
  extern u_int aic7xxx_verbose;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#48 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c ====
--- /tmp/tmp.26602.13	2004-09-27 13:13:01.185118272 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2003-10-27 15:45:13.000000000 -0500
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#48 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#51 $
   */

  #include "aic7xxx_osm.h"
@@ -101,12 +101,14 @@
  	if (ahc != NULL) {
  		u_long s;

+		TAILQ_REMOVE(&ahc_tailq, ahc, links);
+		ahc_list_unlock(&l);
  		ahc_lock(ahc, &s);
  		ahc_intr_enable(ahc, FALSE);
  		ahc_unlock(ahc, &s);
  		ahc_free(ahc);
-	}
-	ahc_list_unlock(&l);
+	} else
+		ahc_list_unlock(&l);
  }
  #endif /* !LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) */

@@ -116,7 +118,7 @@
  	char		 buf[80];
  	bus_addr_t	 mask_39bit;
  	struct		 ahc_softc *ahc;
-	ahc_dev_softc_t	 pci;
+	aic_dev_softc_t	 pci;
  	struct		 ahc_pci_identity *entry;
  	char		*name;
  	int		 error;
@@ -148,9 +150,9 @@
  	 * common detect routine.
  	 */
  	sprintf(buf, "ahc_pci:%d:%d:%d",
-		ahc_get_pci_bus(pci),
-		ahc_get_pci_slot(pci),
-		ahc_get_pci_function(pci));
+		aic_get_pci_bus(pci),
+		aic_get_pci_slot(pci),
+		aic_get_pci_function(pci));
  	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
  	if (name == NULL)
  		return (-ENOMEM);
@@ -168,11 +170,11 @@
  	mask_39bit = (bus_addr_t)0x7FFFFFFFFFULL;
  	if (sizeof(bus_addr_t) > 4
  	 && ahc_linux_get_memsize() > 0x80000000
-	 && ahc_pci_set_dma_mask(pdev, mask_39bit) == 0) {
+	 && aic_pci_set_dma_mask(pdev, mask_39bit) == 0) {
  		ahc->flags |= AHC_39BIT_ADDRESSING;
  		ahc->platform_data->hw_dma_mask = mask_39bit;
  	} else {
-		ahc_pci_set_dma_mask(pdev, 0xFFFFFFFF);
+		aic_pci_set_dma_mask(pdev, 0xFFFFFFFF);
  		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
  	}
  #endif
@@ -215,7 +217,7 @@
  	pdev = NULL;
  	class = PCI_CLASS_STORAGE_SCSI << 8;
  	while ((pdev = pci_find_class(class, pdev)) != NULL) {
-		ahc_dev_softc_t pci;
+		aic_dev_softc_t pci;
  		int error;

  		pci = pdev;
@@ -242,7 +244,7 @@
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
  	*base = pci_resource_start(ahc->dev_softc, 0);
  #else
-	*base = ahc_pci_read_config(ahc->dev_softc, PCIR_MAPS, 4);
+	*base = aic_pci_read_config(ahc->dev_softc, PCIR_MAPS, 4);
  	*base &= PCI_BASE_ADDRESS_IO_MASK;
  #endif
  	if (*base == 0)
@@ -274,7 +276,7 @@
  	base_page = start & PAGE_MASK;
  	base_offset = start - base_page;
  #else
-	start = ahc_pci_read_config(ahc->dev_softc, PCIR_MAPS+4, 4);
+	start = aic_pci_read_config(ahc->dev_softc, PCIR_MAPS+4, 4);
  	base_offset = start & PCI_BASE_ADDRESS_MEM_MASK;
  	base_page = base_offset & PAGE_MASK;
  	base_offset -= base_page;
@@ -311,7 +313,7 @@
  	/*
  	 * If its allowed, we prefer memory mapped access.
  	 */
-	command = ahc_pci_read_config(ahc->dev_softc, PCIR_COMMAND, 4);
+	command = aic_pci_read_config(ahc->dev_softc, PCIR_COMMAND, 4);
  	command &= ~(PCIM_CMD_PORTEN|PCIM_CMD_MEMEN);
  	base = 0;
  	maddr = NULL;
@@ -320,7 +322,7 @@
  		ahc->platform_data->mem_busaddr = base;
  		ahc->tag = BUS_SPACE_MEMIO;
  		ahc->bsh.maddr = maddr;
-		ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND,
+		aic_pci_write_config(ahc->dev_softc, PCIR_COMMAND,
  				     command | PCIM_CMD_MEMEN, 4);

  		/*
@@ -331,9 +333,9 @@

  			printf("aic7xxx: PCI Device %d:%d:%d "
  			       "failed memory mapped test.  Using PIO.\n",
-			       ahc_get_pci_bus(ahc->dev_softc),
-			       ahc_get_pci_slot(ahc->dev_softc),
-			       ahc_get_pci_function(ahc->dev_softc));
+			       aic_get_pci_bus(ahc->dev_softc),
+			       aic_get_pci_slot(ahc->dev_softc),
+			       aic_get_pci_function(ahc->dev_softc));
  			iounmap((void *)((u_long)maddr & PAGE_MASK));
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  			release_mem_region(ahc->platform_data->mem_busaddr,
@@ -346,9 +348,9 @@
  	} else {
  		printf("aic7xxx: PCI%d:%d:%d MEM region 0x%lx "
  		       "unavailable. Cannot memory map device.\n",
-		       ahc_get_pci_bus(ahc->dev_softc),
-		       ahc_get_pci_slot(ahc->dev_softc),
-		       ahc_get_pci_function(ahc->dev_softc),
+		       aic_get_pci_bus(ahc->dev_softc),
+		       aic_get_pci_slot(ahc->dev_softc),
+		       aic_get_pci_function(ahc->dev_softc),
  		       base);
  	}

@@ -358,20 +360,20 @@
  	if (maddr == NULL) {

  		error = ahc_linux_pci_reserve_io_region(ahc, &base);
-		if (error == 0) {
+		if (error == 0 && ahc_pci_test_register_access(ahc) == 0) {
  			ahc->tag = BUS_SPACE_PIO;
  			ahc->bsh.ioport = base;
  			command |= PCIM_CMD_PORTEN;
  		} else {
  			printf("aic7xxx: PCI%d:%d:%d IO region 0x%lx[0..255] "
  			       "unavailable. Cannot map device.\n",
-			       ahc_get_pci_bus(ahc->dev_softc),
-			       ahc_get_pci_slot(ahc->dev_softc),
-			       ahc_get_pci_function(ahc->dev_softc),
+			       aic_get_pci_bus(ahc->dev_softc),
+			       aic_get_pci_slot(ahc->dev_softc),
+			       aic_get_pci_function(ahc->dev_softc),
  			       base);
  		}
  	}
-	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND, command, 4);
+	aic_pci_write_config(ahc->dev_softc, PCIR_COMMAND, command, 4);
  	return (error);
  }

==== //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#73 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c ====
--- /tmp/tmp.26602.14	2004-09-27 13:13:01.720036952 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c	2003-10-27 20:25:22.000000000 -0500
@@ -39,7 +39,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#73 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#75 $
   *
   * $FreeBSD$
   */
@@ -1276,9 +1276,19 @@
  	 * use for this test.
  	 */
  	hcntrl = ahc_inb(ahc, HCNTRL);
+
  	if (hcntrl == 0xFF)
  		goto fail;

+	if ((hcntrl & CHIPRST) != 0) {
+		/*
+		 * The chip has not been initialized since
+		 * PCI/EISA/VLB bus reset.  Don't trust
+		 * "left over BIOS data".
+		 */
+		ahc->flags |= AHC_NO_BIOS_INIT;
+	}
+
  	/*
  	 * Next create a situation where write combining
  	 * or read prefetching could be initiated by the
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_proc.c#31 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_proc.c ====
--- /tmp/tmp.26602.15	2004-09-27 13:13:01.823021296 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_proc.c	2003-10-20 18:42:30.000000000 -0400
@@ -37,7 +37,7 @@
   * String handling code courtesy of Gerard Roudier's <groudier@club-internet.fr>
   * sym driver.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_proc.c#31 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_proc.c#32 $
   */
  #include "aic7xxx_osm.h"
  #include "aic7xxx_inline.h"
@@ -216,7 +216,7 @@
  	}

  	sd.sd_ahc = ahc;
-#if AHC_PCI_CONFIG > 0
+#if AIC_PCI_CONFIG > 0
  	if ((ahc->chip & AHC_PCI) != 0) {
  		sd.sd_control_offset = SEECTL;
  		sd.sd_status_offset = SEECTL;
@@ -272,7 +272,7 @@
  				  sizeof(struct seeprom_config)/2);
  		ahc_read_seeprom(&sd, (uint16_t *)ahc->seep_config,
  				 start_addr, sizeof(struct seeprom_config)/2);
-#if AHC_PCI_CONFIG > 0
+#if AIC_PCI_CONFIG > 0
  		if ((ahc->chip & AHC_VL) == 0)
  			ahc_release_seeprom(&sd);
  #endif
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.c#13 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c ====
--- /tmp/tmp.26602.16	2004-09-27 13:13:02.096979648 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c	2003-10-27 14:44:01.000000000 -0500
@@ -1643,6 +1643,27 @@
  }

  void
+aic_bus_settle_complete(u_long data)
+{
+	struct aic_softc *aic;
+	u_long s;
+
+	aic = (struct aic_softc *)data;
+	/*
+	 * Guard against our bottom half scheduling another
+	 * bus settle delay just as our timer runs.  If this
+	 * occurs, do nothing.  The newly scheduled timer will
+	 * take care of things.
+	 */
+	aic_lock(aic, &s);
+	if (timer_pending(&aic->platform_data->bus_settle_timer) == 0) {
+		aic->platform_data->flags &= ~AIC_BUS_SETTLE_TIMER;
+		aic_release_simq_locked(aic);
+	}
+	aic_unlock(aic, &s);
+}
+
+void
  aic_freeze_simq(struct aic_softc *aic)
  {
  	aic->platform_data->qfrozen++;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.h#17 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h ====
--- /tmp/tmp.26602.17	2004-09-27 13:13:02.515915960 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h	2003-10-27 14:49:44.000000000 -0500
@@ -111,12 +111,13 @@
  #define	aic_lock			AIC_LIB_ENTRY(_lock)
  #define	aic_unlock			AIC_LIB_ENTRY(_unlock)
  #define	aic_dump_card_state		AIC_LIB_ENTRY(_dump_card_state)
-#define	aic_pci_set_dma_mask		AIC_LIB_ENTRY(_pci_set_dma_mask)
  #define	aic_linux_dv_complete		AIC_LIB_ENTRY(_linux_dv_complete)
  #define	aic_linux_run_device_queue	AIC_LIB_ENTRY(_linux_run_device_queue)
  #define	aic_linux_dv_timeout		AIC_LIB_ENTRY(_linux_dv_timeout)
  #define	aic_linux_midlayer_timeout	AIC_LIB_ENTRY(_linux_midlayer_timeout)
  #define	aic_freeze_simq			AIC_LIB_ENTRY(_freeze_simq)
+#define	aic_bus_settle_complete		AIC_LIB_ENTRY(_bus_settle_complete)
+#define	aic_release_simq		AIC_LIB_ENTRY(_release_simq)
  #define	aic_release_simq		AIC_LIB_ENTRY(_release_simq)
  #define	aic_release_simq_locked		AIC_LIB_ENTRY(_release_simq_locked)
  #define	aic_dma_tag_create		AIC_LIB_ENTRY(_dma_tag_create)
@@ -150,6 +151,11 @@
  #define	AIC_NUM_TARGETS			AIC_CONST_ENTRY(_NUM_TARGETS)
  #define	AIC_RESOURCE_SHORTAGE		AIC_CONST_ENTRY(_RESOURCE_SHORTAGE)

+/*************************** Forward Declarations *****************************/
+struct aic_softc;
+typedef struct pci_dev *aic_dev_softc_t;
+typedef Scsi_Cmnd      *aic_io_ctx_t;
+
  /*************************** Timer DataStructures *****************************/
  typedef struct timer_list aic_timer_t;

@@ -252,6 +258,28 @@
   */
  #define aic_dmamap_sync(aic, dma_tag, dmamap, offset, len, op)

+/************************** OS Utility Wrappers *******************************/
+#define printf printk
+#define M_NOWAIT GFP_ATOMIC
+#define M_WAITOK 0
+#define malloc(size, type, flags) kmalloc(size, flags)
+#define free(ptr, type) kfree(ptr)
+
+static __inline void aic_delay(long);
+static __inline void
+aic_delay(long usec)
+{
+	/*
+	 * udelay on Linux can have problems for
+	 * multi-millisecond waits.  Wait at most
+	 * 1024us per call.
+	 */
+	while (usec > 0) {
+		udelay(usec % 1024);
+		usec -= 1024;
+	}
+}
+
  /********************************** Misc Macros *******************************/
  #define	roundup(x, y)   ((((x)+((y)-1))/(y))*(y))
  #define	powerof2(x)	((((x)-1)&(x))==0)
@@ -509,7 +537,8 @@
  	AIC_DV_WAIT_SIMQ_RELEASE = 0x02,
  	AIC_DV_ACTIVE		 = 0x04,
  	AIC_DV_SHUTDOWN		 = 0x08,
-	AIC_RUN_CMPLT_Q_TIMER	 = 0x10
+	AIC_RUN_CMPLT_Q_TIMER	 = 0x10,
+	AIC_BUS_SETTLE_TIMER	 = 0x20
  } aic_linux_softc_flags;

  TAILQ_HEAD(aic_completeq, aic_cmd);
@@ -531,7 +560,7 @@
  	pid_t			 dv_pid;
  	pid_t			 recovery_pid;
  	struct timer_list	 completeq_timer;
-	struct timer_list	 reset_timer;
+	struct timer_list	 bus_settle_timer;
  	struct timer_list	 stats_timer;
  	struct semaphore	 eh_sem;
  	struct semaphore	 dv_sem;
@@ -1657,6 +1686,102 @@
  #define PCIXM_STATUS_MAXCRDS	0x1C00	/* Maximum Cumulative Read Size */
  #define PCIXM_STATUS_RCVDSCEM	0x2000	/* Received a Split Comp w/Error msg */

+/******************************* PCI Routines *********************************/
+static __inline uint32_t aic_pci_read_config(aic_dev_softc_t pci,
+					     int reg, int width);
+static __inline void aic_pci_write_config(aic_dev_softc_t pci,
+					  int reg, uint32_t value,
+					  int width);
+static __inline int aic_get_pci_function(aic_dev_softc_t);
+static __inline int aic_get_pci_slot(aic_dev_softc_t);
+static __inline int aic_get_pci_bus(aic_dev_softc_t);
+
+static __inline uint32_t
+aic_pci_read_config(aic_dev_softc_t pci, int reg, int width)
+{
+	switch (width) {
+	case 1:
+	{
+		uint8_t retval;
+
+		pci_read_config_byte(pci, reg, &retval);
+		return (retval);
+	}
+	case 2:
+	{
+		uint16_t retval;
+		pci_read_config_word(pci, reg, &retval);
+		return (retval);
+	}
+	case 4:
+	{
+		uint32_t retval;
+		pci_read_config_dword(pci, reg, &retval);
+		return (retval);
+	}
+	default:
+		panic("aic_pci_read_config: Read size too big");
+		/* NOTREACHED */
+		return (0);
+	}
+}
+
+static __inline void
+aic_pci_write_config(aic_dev_softc_t pci, int reg, uint32_t value, int width)
+{
+	switch (width) {
+	case 1:
+		pci_write_config_byte(pci, reg, value);
+		break;
+	case 2:
+		pci_write_config_word(pci, reg, value);
+		break;
+	case 4:
+		pci_write_config_dword(pci, reg, value);
+		break;
+	default:
+		panic("aic_pci_write_config: Write size too big");
+		/* NOTREACHED */
+	}
+}
+
+static __inline int
+aic_get_pci_function(aic_dev_softc_t pci)
+{
+	return (PCI_FUNC(pci->devfn));
+}
+
+static __inline int
+aic_get_pci_slot(aic_dev_softc_t pci)
+{
+	return (PCI_SLOT(pci->devfn));
+}
+
+static __inline int
+aic_get_pci_bus(aic_dev_softc_t pci)
+{
+	return (pci->bus->number);
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,3,0)
+#define pci_map_sg(pdev, sg_list, nseg, direction) (nseg)
+#define pci_unmap_sg(pdev, sg_list, nseg, direction)
+#define sg_dma_address(sg) (VIRT_TO_BUS((sg)->address))
+#define sg_dma_len(sg) ((sg)->length)
+#define pci_map_single(pdev, buffer, bufflen, direction) \
+	(VIRT_TO_BUS(buffer))
+#define pci_unmap_single(pdev, buffer, buflen, direction)
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,3)
+#define aic_pci_set_dma_mask pci_set_dma_mask
+#else
+/*
+ * Always "return" 0 for success.
+ */
+#define aic_pci_set_dma_mask(dev_softc, mask)	\
+	(((dev_softc)->dma_mask = mask) && 0)
+#endif
  /************************* Large Disk Handling ********************************/
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  static __inline int aic_sector_div(u_long capacity, int heads, int sectors);
@@ -1828,9 +1953,6 @@
  	return (rv);
  }

-/*************************** Forward Declarations *****************************/
-struct aic_softc;
-
  /******************************* PCI Funcitons ********************************/
  void aic_power_state_change(struct aic_softc *aic, aic_power_state new_state);

@@ -1839,6 +1961,7 @@
  void		     aic_unblock_tasklet(unsigned long data);
  void		     aic_linux_run_device_queue(struct aic_softc*,
  						struct aic_linux_device*);
+void		     aic_bus_settle_complete(u_long data);
  void		     aic_freeze_simq(struct aic_softc *aic);
  void		     aic_release_simq(struct aic_softc *aic);
  void		     aic_release_simq_locked(struct aic_softc *aic);


