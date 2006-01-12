From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] [Resend] aic79xx: Use struct map_node
Date: Thu, 12 Jan 2006 12:05:46 +0100
Message-ID: <43C6380A.7090709@suse.de>
References: <ISX88H$7860D422B0F4A207532BB4F4448FF0FD@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090904010203080408000707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:9180 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932169AbWALLFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 06:05:48 -0500
In-Reply-To: <ISX88H$7860D422B0F4A207532BB4F4448FF0FD@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>

This is a multi-part message in MIME format.
--------------090904010203080408000707
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Use struct map_node instead of separate variables.



--------------090904010203080408000707
Content-Type: text/plain;
 name="0002-aic79xx-Use-struct-map_node.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-aic79xx-Use-struct-map_node.txt"

[PATCH 2/4] aic79xx: Use struct map_node

Use struct map_node instead of seperate variables.
---

 drivers/scsi/aic7xxx/aic79xx.h        |   27 +++++++++++++++++---------
 drivers/scsi/aic7xxx/aic79xx_core.c   |   30 +++++++++++++++++------------
 drivers/scsi/aic7xxx/aic79xx_inline.h |   34 +++++++++++++++++++++++----------
 3 files changed, 58 insertions(+), 33 deletions(-)

f2a459e65612c408af93219bac181b0b447091ca
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#95 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#108 $
  *
  * $FreeBSD$
  */
@@ -1062,6 +1062,7 @@ struct ahd_softc {
 	struct scb_data		  scb_data;
 
 	struct hardware_scb	 *next_queued_hscb;
+	struct map_node		 *next_queued_hscb_map;
 
 	/*
 	 * SCBs that have been sent to the controller
@@ -1140,10 +1141,6 @@ struct ahd_softc {
 	ahd_flag		  flags;
 	struct seeprom_config	 *seep_config;
 
-	/* Values to store in the SEQCTL register for pause and unpause */
-	uint8_t			  unpause;
-	uint8_t			  pause;
-
 	/* Command Queues */
 	uint16_t		  qoutfifonext;
 	uint16_t		  qoutfifonext_valid_tag;
@@ -1151,6 +1148,17 @@ struct ahd_softc {
 	uint16_t		  qinfifo[AHD_SCB_MAX];
 	uint16_t		 *qoutfifo;
 
+	/*
+	 * Our qfreeze count.  The sequencer compares
+	 * this value with its own counter to determine
+	 * whether to allow selections to occur.
+	 */
+	uint16_t		  qfreeze_cnt;
+
+	/* Values to store in the SEQCTL register for pause and unpause */
+	uint8_t			  unpause;
+	uint8_t			  pause;
+
 	/* Critical Section Data */
 	struct cs		 *critical_sections;
 	u_int			  num_critical_sections;
@@ -1197,8 +1205,7 @@ struct ahd_softc {
 	 */
 	bus_dma_tag_t		  parent_dmat;
 	bus_dma_tag_t		  shared_data_dmat;
-	bus_dmamap_t		  shared_data_dmamap;
-	dma_addr_t		  shared_data_busaddr;
+	struct map_node		  shared_data_map;
 
 	/* Information saved through suspend/resume cycles */
 	struct ahd_suspend_state  suspend_state;
@@ -1296,9 +1303,9 @@ struct ahd_devinfo {
 };
 
 /****************************** PCI Structures ********************************/
-#define AHD_PCI_IOADDR0	PCIR_MAPS	/* I/O BAR*/
-#define AHD_PCI_MEMADDR	(PCIR_MAPS + 4)	/* Memory BAR */
-#define AHD_PCI_IOADDR1	(PCIR_MAPS + 12)/* Second I/O BAR */
+#define AHD_PCI_IOADDR0	PCIR_BAR(0)	/* I/O BAR*/
+#define AHD_PCI_MEMADDR	PCIR_BAR(1)	/* Memory BAR */
+#define AHD_PCI_IOADDR1	PCIR_BAR(3)	/* Second I/O BAR */
 
 typedef int (ahd_device_setup_t)(struct ahd_softc *);
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -5203,13 +5203,13 @@ ahd_free(struct ahd_softc *ahd)
 		/* FALLTHROUGH */
 	case 4:
 		ahd_dmamap_unload(ahd, ahd->shared_data_dmat,
-				  ahd->shared_data_dmamap);
+				  ahd->shared_data_map.dmamap);
 		/* FALLTHROUGH */
 	case 3:
 		ahd_dmamem_free(ahd, ahd->shared_data_dmat, ahd->qoutfifo,
-				ahd->shared_data_dmamap);
+				ahd->shared_data_map.dmamap);
 		ahd_dmamap_destroy(ahd, ahd->shared_data_dmat,
-				   ahd->shared_data_dmamap);
+				   ahd->shared_data_map.dmamap);
 		/* FALLTHROUGH */
 	case 2:
 		ahd_dma_tag_destroy(ahd, ahd->shared_data_dmat);
@@ -6088,7 +6088,6 @@ static const char *termstat_strings[] = 
 int
 ahd_init(struct ahd_softc *ahd)
 {
-	uint8_t		*base_vaddr;
 	uint8_t		*next_vaddr;
 	dma_addr_t	 next_baddr;
 	size_t		 driver_data_size;
@@ -6178,20 +6177,23 @@ ahd_init(struct ahd_softc *ahd)
 
 	/* Allocation of driver data */
 	if (ahd_dmamem_alloc(ahd, ahd->shared_data_dmat,
-			     (void **)&base_vaddr,
-			     BUS_DMA_NOWAIT, &ahd->shared_data_dmamap) != 0) {
+			     (void **)&ahd->shared_data_map.vaddr,
+			     BUS_DMA_NOWAIT,
+			     &ahd->shared_data_map.dmamap) != 0) {
 		return (ENOMEM);
 	}
 
 	ahd->init_level++;
 
 	/* And permanently map it in */
-	ahd_dmamap_load(ahd, ahd->shared_data_dmat, ahd->shared_data_dmamap,
-			base_vaddr, driver_data_size, ahd_dmamap_cb,
-			&ahd->shared_data_busaddr, /*flags*/0);
-	ahd->qoutfifo = (uint16_t *)base_vaddr;
+	ahd_dmamap_load(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
+			ahd->shared_data_map.vaddr, driver_data_size,
+			ahd_dmamap_cb, &ahd->shared_data_map.physaddr,
+			/*flags*/0);
+	ahd->qoutfifo = (uint16_t *)ahd->shared_data_map.vaddr;
 	next_vaddr = (uint8_t *)&ahd->qoutfifo[AHD_QOUT_SIZE];
-	next_baddr = ahd->shared_data_busaddr + AHD_QOUT_SIZE*sizeof(uint16_t);
+	next_baddr = ahd->shared_data_map.physaddr
+		   + AHD_QOUT_SIZE*sizeof(uint16_t);
 	if ((ahd->features & AHD_TARGETMODE) != 0) {
 		ahd->targetcmds = (struct target_cmd *)next_vaddr;
 		next_vaddr += AHD_TMODE_CMDS * sizeof(struct target_cmd);
@@ -6212,6 +6214,7 @@ ahd_init(struct ahd_softc *ahd)
 	 * specially from the DMA safe memory chunk used for the QOUTFIFO.
 	 */
 	ahd->next_queued_hscb = (struct hardware_scb *)next_vaddr;
+	ahd->next_queued_hscb_map = &ahd->shared_data_map;
 	ahd->next_queued_hscb->hscb_busaddr = ahd_htole32(next_baddr);
 
 	ahd->init_level++;
@@ -6557,12 +6560,13 @@ ahd_chip_init(struct ahd_softc *ahd)
 	/*
 	 * The Freeze Count is 0.
 	 */
+	ahd->qfreeze_cnt = 0;
 	ahd_outw(ahd, QFREEZE_COUNT, 0);
 
 	/*
 	 * Tell the sequencer where it can find our arrays in memory.
 	 */
-	busaddr = ahd->shared_data_busaddr;
+	busaddr = ahd->shared_data_map.physaddr;
 	ahd_outb(ahd, SHARED_DATA_ADDR, busaddr & 0xFF);
 	ahd_outb(ahd, SHARED_DATA_ADDR + 1, (busaddr >> 8) & 0xFF);
 	ahd_outb(ahd, SHARED_DATA_ADDR + 2, (busaddr >> 16) & 0xFF);
@@ -9651,7 +9655,7 @@ ahd_run_tqinfifo(struct ahd_softc *ahd, 
 
 		cmd->cmd_valid = 0;
 		ahd_dmamap_sync(ahd, ahd->shared_data_dmat,
-				ahd->shared_data_dmamap,
+				ahd->shared_data_map.dmamap,
 				ahd_targetcmd_offset(ahd, ahd->tqinfifonext),
 				sizeof(struct target_cmd),
 				BUS_DMASYNC_PREREAD);
diff --git a/drivers/scsi/aic7xxx/aic79xx_inline.h b/drivers/scsi/aic7xxx/aic79xx_inline.h
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h
+++ b/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#51 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#58 $
  *
  * $FreeBSD$
  */
@@ -522,12 +522,21 @@ do {								\
 static __inline uint16_t
 ahd_inw(struct ahd_softc *ahd, u_int port)
 {
+	/*
+	 * Read high byte first as some registers increment
+	 * or have other side effects when the low byte is
+	 * read.
+	 */
 	return ((ahd_inb(ahd, port+1) << 8) | ahd_inb(ahd, port));
 }
 
 static __inline void
 ahd_outw(struct ahd_softc *ahd, u_int port, u_int value)
 {
+	/*
+	 * Write low byte first to accomodate registers
+	 * such as PRGMCNT where the order maters.
+	 */
 	ahd_outb(ahd, port, value & 0xFF);
 	ahd_outb(ahd, port+1, (value >> 8) & 0xFF);
 }
@@ -684,7 +693,7 @@ ahd_inb_scbram(struct ahd_softc *ahd, u_
 	 * Razor #528
 	 */
 	value = ahd_inb(ahd, offset);
-	if ((ahd->flags & AHD_PCIX_SCBRAM_RD_BUG) != 0)
+	if ((ahd->bugs & AHD_PCIX_SCBRAM_RD_BUG) != 0)
 		ahd_inb(ahd, MODE_PTR);
 	return (value);
 }
@@ -727,7 +736,8 @@ ahd_lookup_scb(struct ahd_softc *ahd, u_
 static __inline void
 ahd_swap_with_next_hscb(struct ahd_softc *ahd, struct scb *scb)
 {
-	struct hardware_scb *q_hscb;
+	struct	 hardware_scb *q_hscb;
+	struct	 map_node *q_hscb_map;
 	uint32_t saved_hscb_busaddr;
 
 	/*
@@ -743,6 +753,7 @@ ahd_swap_with_next_hscb(struct ahd_softc
 	 * locate the correct SCB by SCB_TAG.
 	 */
 	q_hscb = ahd->next_queued_hscb;
+	q_hscb_map = ahd->next_queued_hscb_map;
 	saved_hscb_busaddr = q_hscb->hscb_busaddr;
 	memcpy(q_hscb, scb->hscb, sizeof(*scb->hscb));
 	q_hscb->hscb_busaddr = saved_hscb_busaddr;
@@ -750,7 +761,9 @@ ahd_swap_with_next_hscb(struct ahd_softc
 
 	/* Now swap HSCB pointers. */
 	ahd->next_queued_hscb = scb->hscb;
+	ahd->next_queued_hscb_map = scb->hscb_map;
 	scb->hscb = q_hscb;
+	scb->hscb_map = q_hscb_map;
 
 	/* Now define the mapping from tag to SCB in the scbindex */
 	ahd->scb_data.scbindex[SCB_GET_TAG(scb)] = scb;
@@ -824,8 +837,9 @@ static __inline int	ahd_intr(struct ahd_
 static __inline void
 ahd_sync_qoutfifo(struct ahd_softc *ahd, int op)
 {
-	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_dmamap,
-			/*offset*/0, /*len*/AHC_SCB_MAX * sizeof(uint16_t), op);
+	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
+			/*offset*/0,
+			/*len*/AHD_SCB_MAX * sizeof(uint16_t), op);
 }
 
 static __inline void
@@ -834,7 +848,7 @@ ahd_sync_tqinfifo(struct ahd_softc *ahd,
 #ifdef AHD_TARGET_MODE
 	if ((ahd->flags & AHD_TARGETROLE) != 0) {
 		ahd_dmamap_sync(ahd, ahd->shared_data_dmat,
-				ahd->shared_data_dmamap,
+				ahd->shared_data_map.dmamap,
 				ahd_targetcmd_offset(ahd, 0),
 				sizeof(struct target_cmd) * AHD_TMODE_CMDS,
 				op);
@@ -854,9 +868,9 @@ ahd_check_cmdcmpltqueues(struct ahd_soft
 	u_int retval;
 
 	retval = 0;
-	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_dmamap,
-			/*offset*/ahd->qoutfifonext, /*len*/2,
-			BUS_DMASYNC_POSTREAD);
+	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
+			/*offset*/ahd->qoutfifonext * sizeof(*ahd->qoutfifo),
+			/*len*/sizeof(*ahd->qoutfifo), BUS_DMASYNC_POSTREAD);
 	if ((ahd->qoutfifo[ahd->qoutfifonext]
 	     & QOUTFIFO_ENTRY_VALID_LE) == ahd->qoutfifonext_valid_tag)
 		retval |= AHD_RUN_QOUTFIFO;
@@ -864,7 +878,7 @@ ahd_check_cmdcmpltqueues(struct ahd_soft
 	if ((ahd->flags & AHD_TARGETROLE) != 0
 	 && (ahd->flags & AHD_TQINFIFO_BLOCKED) == 0) {
 		ahd_dmamap_sync(ahd, ahd->shared_data_dmat,
-				ahd->shared_data_dmamap,
+				ahd->shared_data_map.dmamap,
 				ahd_targetcmd_offset(ahd, ahd->tqinfifofnext),
 				/*len*/sizeof(struct target_cmd),
 				BUS_DMASYNC_POSTREAD);

--------------090904010203080408000707--
