From: akpm@linux-foundation.org
Subject: [patch 04/17] scsi/aic94xx/: cleanups
Date: Fri, 28 Mar 2008 14:48:34 -0700
Message-ID: <200803282148.m2SLmYFA012225@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbYC1Vy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:54:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org, James.Bottomley@steeleye.com, djwong@us.ibm.com

From: Adrian Bunk <bunk@kernel.org>

- static functions in .c files shouldn't be marked inline
- make needlessly global code static
- remove the unused aic94xx_seq.c:asd_unpause_lseq()
- #if 0 other unused code

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_dev.c  |    8 +--
 drivers/scsi/aic94xx/aic94xx_dump.c |   10 ++++
 drivers/scsi/aic94xx/aic94xx_dump.h |    9 ----
 drivers/scsi/aic94xx/aic94xx_hwi.c  |   24 +++++-----
 drivers/scsi/aic94xx/aic94xx_hwi.h  |    2 
 drivers/scsi/aic94xx/aic94xx_init.c |    8 +--
 drivers/scsi/aic94xx/aic94xx_reg.c  |   57 ++++++++++++--------------
 drivers/scsi/aic94xx/aic94xx_scb.c  |   33 ++++++++-------
 drivers/scsi/aic94xx/aic94xx_sds.c  |    4 -
 drivers/scsi/aic94xx/aic94xx_seq.c  |   31 ++------------
 drivers/scsi/aic94xx/aic94xx_seq.h  |    4 -
 drivers/scsi/aic94xx/aic94xx_task.c |   12 ++---
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    2 
 13 files changed, 89 insertions(+), 115 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_dev.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_dev.c
--- a/drivers/scsi/aic94xx/aic94xx_dev.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -35,7 +35,7 @@
 #define SET_DDB(_ddb, _ha) set_bit(_ddb, (_ha)->hw_prof.ddb_bitmap)
 #define CLEAR_DDB(_ddb, _ha) clear_bit(_ddb, (_ha)->hw_prof.ddb_bitmap)
 
-static inline int asd_get_ddb(struct asd_ha_struct *asd_ha)
+static int asd_get_ddb(struct asd_ha_struct *asd_ha)
 {
 	int ddb, i;
 
@@ -71,7 +71,7 @@ out:
 #define NCQ_DATA_SCB_PTR offsetof(struct asd_ddb_stp_sata_target_port, ncq_data_scb_ptr)
 #define ITNL_TIMEOUT    offsetof(struct asd_ddb_ssp_smp_target_port, itnl_timeout)
 
-static inline void asd_free_ddb(struct asd_ha_struct *asd_ha, int ddb)
+static void asd_free_ddb(struct asd_ha_struct *asd_ha, int ddb)
 {
 	if (!ddb || ddb >= 0xFFFF)
 		return;
@@ -79,7 +79,7 @@ static inline void asd_free_ddb(struct a
 	CLEAR_DDB(ddb, asd_ha);
 }
 
-static inline void asd_set_ddb_type(struct domain_device *dev)
+static void asd_set_ddb_type(struct domain_device *dev)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 	int ddb = (int) (unsigned long) dev->lldd_dev;
@@ -109,7 +109,7 @@ static int asd_init_sata_tag_ddb(struct 
 	return 0;
 }
 
-static inline int asd_init_sata(struct domain_device *dev)
+static int asd_init_sata(struct domain_device *dev)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 	int ddb = (int) (unsigned long) dev->lldd_dev;
diff -puN drivers/scsi/aic94xx/aic94xx_dump.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_dump.c
--- a/drivers/scsi/aic94xx/aic94xx_dump.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -738,6 +738,8 @@ static void asd_dump_lseq_state(struct a
 	PRINT_LMIP_dword(asd_ha, lseq, DEV_PRES_TIMER_TERM_TS);
 }
 
+#if 0
+
 /**
  * asd_dump_ddb_site -- dump a CSEQ DDB site
  * @asd_ha: pointer to host adapter structure
@@ -880,6 +882,8 @@ void asd_dump_scb_sites(struct asd_ha_st
 	}
 }
 
+#endif  /*  0  */
+
 /**
  * ads_dump_seq_state -- dump CSEQ and LSEQ states
  * @asd_ha: pointer to host adapter structure
@@ -922,7 +926,9 @@ void asd_dump_frame_rcvd(struct asd_phy 
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 }
 
-static inline void asd_dump_scb(struct asd_ascb *ascb, int ind)
+#if 0
+
+static void asd_dump_scb(struct asd_ascb *ascb, int ind)
 {
 	asd_printk("scb%d: vaddr: 0x%p, dma_handle: 0x%llx, next: 0x%llx, "
 		   "index:%d, opcode:0x%02x\n",
@@ -956,4 +962,6 @@ void asd_dump_scb_list(struct asd_ascb *
 	}
 }
 
+#endif  /*  0  */
+
 #endif /* ASD_DEBUG */
diff -puN drivers/scsi/aic94xx/aic94xx_dump.h~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_dump.h
--- a/drivers/scsi/aic94xx/aic94xx_dump.h~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_dump.h
@@ -29,24 +29,15 @@
 
 #ifdef ASD_DEBUG
 
-void asd_dump_ddb_0(struct asd_ha_struct *asd_ha);
-void asd_dump_target_ddb(struct asd_ha_struct *asd_ha, u16 site_no);
-void asd_dump_scb_sites(struct asd_ha_struct *asd_ha);
 void asd_dump_seq_state(struct asd_ha_struct *asd_ha, u8 lseq_mask);
 void asd_dump_frame_rcvd(struct asd_phy *phy,
 			 struct done_list_struct *dl);
-void asd_dump_scb_list(struct asd_ascb *ascb, int num);
 #else /* ASD_DEBUG */
 
-static inline void asd_dump_ddb_0(struct asd_ha_struct *asd_ha) { }
-static inline void asd_dump_target_ddb(struct asd_ha_struct *asd_ha,
-				     u16 site_no) { }
-static inline void asd_dump_scb_sites(struct asd_ha_struct *asd_ha) { }
 static inline void asd_dump_seq_state(struct asd_ha_struct *asd_ha,
 				      u8 lseq_mask) { }
 static inline void asd_dump_frame_rcvd(struct asd_phy *phy,
 				       struct done_list_struct *dl) { }
-static inline void asd_dump_scb_list(struct asd_ascb *ascb, int num) { }
 #endif /* ASD_DEBUG */
 
 #endif /* _AIC94XX_DUMP_H_ */
diff -puN drivers/scsi/aic94xx/aic94xx_hwi.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_hwi.c
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -250,7 +250,7 @@ static int asd_init_scbs(struct asd_ha_s
 	return 0;
 }
 
-static inline void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
+static void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
 {
 	asd_ha->hw_prof.max_scbs = asd_get_cmdctx_size(asd_ha)/ASD_SCB_SIZE;
 	asd_ha->hw_prof.max_ddbs = asd_get_devctx_size(asd_ha)/ASD_DDB_SIZE;
@@ -771,7 +771,7 @@ static void asd_dl_tasklet_handler(unsig
  * asd_process_donelist_isr -- schedule processing of done list entries
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_process_donelist_isr(struct asd_ha_struct *asd_ha)
+static void asd_process_donelist_isr(struct asd_ha_struct *asd_ha)
 {
 	tasklet_schedule(&asd_ha->seq.dl_tasklet);
 }
@@ -780,7 +780,7 @@ static inline void asd_process_donelist_
  * asd_com_sas_isr -- process device communication interrupt (COMINT)
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_com_sas_isr(struct asd_ha_struct *asd_ha)
+static void asd_com_sas_isr(struct asd_ha_struct *asd_ha)
 {
 	u32 comstat = asd_read_reg_dword(asd_ha, COMSTAT);
 
@@ -819,7 +819,7 @@ static inline void asd_com_sas_isr(struc
 	asd_chip_reset(asd_ha);
 }
 
-static inline void asd_arp2_err(struct asd_ha_struct *asd_ha, u32 dchstatus)
+static void asd_arp2_err(struct asd_ha_struct *asd_ha, u32 dchstatus)
 {
 	static const char *halt_code[256] = {
 		"UNEXPECTED_INTERRUPT0",
@@ -906,7 +906,7 @@ static inline void asd_arp2_err(struct a
  * asd_dch_sas_isr -- process device channel interrupt (DEVINT)
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_dch_sas_isr(struct asd_ha_struct *asd_ha)
+static void asd_dch_sas_isr(struct asd_ha_struct *asd_ha)
 {
 	u32 dchstatus = asd_read_reg_dword(asd_ha, DCHSTATUS);
 
@@ -921,7 +921,7 @@ static inline void asd_dch_sas_isr(struc
  * ads_rbi_exsi_isr -- process external system interface interrupt (INITERR)
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
+static void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
 {
 	u32 stat0r = asd_read_reg_dword(asd_ha, ASISTAT0R);
 
@@ -969,7 +969,7 @@ static inline void asd_rbi_exsi_isr(stru
  *
  * Asserted on PCIX errors: target abort, etc.
  */
-static inline void asd_hst_pcix_isr(struct asd_ha_struct *asd_ha)
+static void asd_hst_pcix_isr(struct asd_ha_struct *asd_ha)
 {
 	u16 status;
 	u32 pcix_status;
@@ -1042,8 +1042,8 @@ irqreturn_t asd_hw_isr(int irq, void *de
 
 /* ---------- SCB handling ---------- */
 
-static inline struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,
-					      gfp_t gfp_flags)
+static struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,
+				       gfp_t gfp_flags)
 {
 	extern struct kmem_cache *asd_ascb_cache;
 	struct asd_seq_data *seq = &asd_ha->seq;
@@ -1142,8 +1142,8 @@ struct asd_ascb *asd_ascb_alloc_list(str
  *
  * LOCKING: called with the pending list lock held.
  */
-static inline void asd_swap_head_scb(struct asd_ha_struct *asd_ha,
-				     struct asd_ascb *ascb)
+static void asd_swap_head_scb(struct asd_ha_struct *asd_ha,
+			      struct asd_ascb *ascb)
 {
 	struct asd_seq_data *seq = &asd_ha->seq;
 	struct asd_ascb *last = list_entry(ascb->list.prev,
@@ -1169,7 +1169,7 @@ static inline void asd_swap_head_scb(str
  * intended to be called from asd_post_ascb_list(), just prior to
  * posting the SCBs to the sequencer.
  */
-static inline void asd_start_scb_timers(struct list_head *list)
+static void asd_start_scb_timers(struct list_head *list)
 {
 	struct asd_ascb *ascb;
 	list_for_each_entry(ascb, list, list) {
diff -puN drivers/scsi/aic94xx/aic94xx_hwi.h~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_hwi.h
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -391,8 +391,6 @@ void asd_build_control_phy(struct asd_as
 void asd_control_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
 void asd_turn_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
 int  asd_enable_phys(struct asd_ha_struct *asd_ha, const u8 phy_mask);
-void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
-				      u8 subfunc);
 
 void asd_ascb_timedout(unsigned long data);
 int  asd_chip_hardrst(struct asd_ha_struct *asd_ha);
diff -puN drivers/scsi/aic94xx/aic94xx_init.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -545,7 +545,7 @@ static struct asd_pcidev_struct {
 	},
 };
 
-static inline int asd_create_ha_caches(struct asd_ha_struct *asd_ha)
+static int asd_create_ha_caches(struct asd_ha_struct *asd_ha)
 {
 	asd_ha->scb_pool = dma_pool_create(ASD_DRIVER_NAME "_scb_pool",
 					   &asd_ha->pcidev->dev,
@@ -563,7 +563,7 @@ static inline int asd_create_ha_caches(s
  * asd_free_edbs -- free empty data buffers
  * asd_ha: pointer to host adapter structure
  */
-static inline void asd_free_edbs(struct asd_ha_struct *asd_ha)
+static void asd_free_edbs(struct asd_ha_struct *asd_ha)
 {
 	struct asd_seq_data *seq = &asd_ha->seq;
 	int i;
@@ -574,7 +574,7 @@ static inline void asd_free_edbs(struct 
 	seq->edb_arr = NULL;
 }
 
-static inline void asd_free_escbs(struct asd_ha_struct *asd_ha)
+static void asd_free_escbs(struct asd_ha_struct *asd_ha)
 {
 	struct asd_seq_data *seq = &asd_ha->seq;
 	int i;
@@ -589,7 +589,7 @@ static inline void asd_free_escbs(struct
 	seq->escb_arr = NULL;
 }
 
-static inline void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
+static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 {
 	int i;
 
diff -puN drivers/scsi/aic94xx/aic94xx_reg.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_reg.c
--- a/drivers/scsi/aic94xx/aic94xx_reg.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_reg.c
@@ -32,8 +32,8 @@
  * Offset comes before value to remind that the operation of
  * this function is *offs = val.
  */
-static inline void asd_write_byte(struct asd_ha_struct *asd_ha,
-				  unsigned long offs, u8 val)
+static void asd_write_byte(struct asd_ha_struct *asd_ha,
+			   unsigned long offs, u8 val)
 {
 	if (unlikely(asd_ha->iospace))
 		outb(val,
@@ -43,8 +43,8 @@ static inline void asd_write_byte(struct
 	wmb();
 }
 
-static inline void asd_write_word(struct asd_ha_struct *asd_ha,
-				  unsigned long offs, u16 val)
+static void asd_write_word(struct asd_ha_struct *asd_ha,
+			   unsigned long offs, u16 val)
 {
 	if (unlikely(asd_ha->iospace))
 		outw(val,
@@ -54,8 +54,8 @@ static inline void asd_write_word(struct
 	wmb();
 }
 
-static inline void asd_write_dword(struct asd_ha_struct *asd_ha,
-				   unsigned long offs, u32 val)
+static void asd_write_dword(struct asd_ha_struct *asd_ha,
+			    unsigned long offs, u32 val)
 {
 	if (unlikely(asd_ha->iospace))
 		outl(val,
@@ -67,8 +67,7 @@ static inline void asd_write_dword(struc
 
 /* Reading from device address space.
  */
-static inline u8 asd_read_byte(struct asd_ha_struct *asd_ha,
-			       unsigned long offs)
+static u8 asd_read_byte(struct asd_ha_struct *asd_ha, unsigned long offs)
 {
 	u8 val;
 	if (unlikely(asd_ha->iospace))
@@ -80,8 +79,8 @@ static inline u8 asd_read_byte(struct as
 	return val;
 }
 
-static inline u16 asd_read_word(struct asd_ha_struct *asd_ha,
-				unsigned long offs)
+static u16 asd_read_word(struct asd_ha_struct *asd_ha,
+			 unsigned long offs)
 {
 	u16 val;
 	if (unlikely(asd_ha->iospace))
@@ -93,8 +92,8 @@ static inline u16 asd_read_word(struct a
 	return val;
 }
 
-static inline u32 asd_read_dword(struct asd_ha_struct *asd_ha,
-				 unsigned long offs)
+static u32 asd_read_dword(struct asd_ha_struct *asd_ha,
+			  unsigned long offs)
 {
 	u32 val;
 	if (unlikely(asd_ha->iospace))
@@ -124,22 +123,22 @@ static inline u32 asd_mem_offs_swb(void)
 /* We know that the register wanted is in the range
  * of the sliding window.
  */
-#define ASD_READ_SW(ww, type, ord)                                     \
-static inline type asd_read_##ww##_##ord (struct asd_ha_struct *asd_ha,\
-					  u32 reg)                     \
-{                                                                      \
-	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];    \
-	u32 map_offs=(reg - io_handle-> ww##_base )+asd_mem_offs_##ww ();\
-	return asd_read_##ord (asd_ha, (unsigned long) map_offs);      \
-}
-
-#define ASD_WRITE_SW(ww, type, ord)                                    \
-static inline void asd_write_##ww##_##ord (struct asd_ha_struct *asd_ha,\
-				  u32 reg, type val)                   \
-{                                                                      \
-	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];    \
-	u32 map_offs=(reg - io_handle-> ww##_base )+asd_mem_offs_##ww ();\
-	asd_write_##ord (asd_ha, (unsigned long) map_offs, val);       \
+#define ASD_READ_SW(ww, type, ord)					\
+static type asd_read_##ww##_##ord(struct asd_ha_struct *asd_ha,		\
+				   u32 reg)				\
+{									\
+	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];	\
+	u32 map_offs = (reg - io_handle->ww##_base) + asd_mem_offs_##ww();\
+	return asd_read_##ord(asd_ha, (unsigned long)map_offs);	\
+}
+
+#define ASD_WRITE_SW(ww, type, ord)					\
+static void asd_write_##ww##_##ord(struct asd_ha_struct *asd_ha,	\
+				    u32 reg, type val)			\
+{									\
+	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];	\
+	u32 map_offs = (reg - io_handle->ww##_base) + asd_mem_offs_##ww();\
+	asd_write_##ord(asd_ha, (unsigned long)map_offs, val);		\
 }
 
 ASD_READ_SW(swa, u8,  byte);
@@ -186,7 +185,7 @@ ASD_WRITE_SW(swc, u32, dword);
  * @asd_ha: pointer to host adapter structure
  * @reg: register desired to be within range of the new window
  */
-static inline void asd_move_swb(struct asd_ha_struct *asd_ha, u32 reg)
+static void asd_move_swb(struct asd_ha_struct *asd_ha, u32 reg)
 {
 	u32 base = reg & ~(MBAR0_SWB_SIZE-1);
 	pci_write_config_dword(asd_ha->pcidev, PCI_CONF_MBAR0_SWB, base);
diff -puN drivers/scsi/aic94xx/aic94xx_scb.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_scb.c
--- a/drivers/scsi/aic94xx/aic94xx_scb.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -50,7 +50,7 @@
 			   | CURRENT_SPINUP_HOLD | CURRENT_GTO_TIMEOUT \
 			   | CURRENT_OOB_ERROR)
 
-static inline void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
+static void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
 {
 	struct sas_phy *sas_phy = phy->sas_phy.phy;
 
@@ -81,7 +81,7 @@ static inline void get_lrate_mode(struct
 		phy->sas_phy.oob_mode = SATA_OOB_MODE;
 }
 
-static inline void asd_phy_event_tasklet(struct asd_ascb *ascb,
+static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 					 struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
@@ -125,8 +125,7 @@ static inline void asd_phy_event_tasklet
 }
 
 /* If phys are enabled sparsely, this will do the right thing. */
-static inline unsigned ord_phy(struct asd_ha_struct *asd_ha,
-			       struct asd_phy *phy)
+static unsigned ord_phy(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 {
 	u8 enabled_mask = asd_ha->hw_prof.enabled_phys;
 	int i, k = 0;
@@ -151,7 +150,7 @@ static inline unsigned ord_phy(struct as
  * LOCKING: the frame_rcvd_lock needs to be held since this parses the frame
  * buffer.
  */
-static inline void asd_get_attached_sas_addr(struct asd_phy *phy, u8 *sas_addr)
+static void asd_get_attached_sas_addr(struct asd_phy *phy, u8 *sas_addr)
 {
 	if (phy->sas_phy.frame_rcvd[0] == 0x34
 	    && phy->sas_phy.oob_mode == SATA_OOB_MODE) {
@@ -232,9 +231,9 @@ static void asd_deform_port(struct asd_h
 	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
 }
 
-static inline void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
-					   struct done_list_struct *dl,
-					   int edb_id, int phy_id)
+static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
+				    struct done_list_struct *dl,
+				    int edb_id, int phy_id)
 {
 	unsigned long flags;
 	int edb_el = edb_id + ascb->edb_index;
@@ -255,9 +254,9 @@ static inline void asd_bytes_dmaed_taskl
 	sas_ha->notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED);
 }
 
-static inline void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
-					      struct done_list_struct *dl,
-					      int phy_id)
+static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
+				       struct done_list_struct *dl,
+				       int phy_id)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
@@ -308,9 +307,9 @@ out:
 	;
 }
 
-static inline void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
-					      struct done_list_struct *dl,
-					      int phy_id)
+static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
+				       struct done_list_struct *dl,
+				       int phy_id)
 {
 	unsigned long flags;
 	struct sas_ha_struct *sas_ha = &ascb->ha->sas_ha;
@@ -715,7 +714,7 @@ out:
 	asd_ascb_free(ascb);
 }
 
-static inline void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
+static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 {
 	/* disable all speeds, then enable defaults */
 	*speed_mask = SAS_SPEED_60_DIS | SAS_SPEED_30_DIS | SAS_SPEED_15_DIS
@@ -820,6 +819,8 @@ void asd_build_control_phy(struct asd_as
 
 /* ---------- INITIATE LINK ADM TASK ---------- */
 
+#if 0
+
 static void link_adm_tasklet_complete(struct asd_ascb *ascb,
 				      struct done_list_struct *dl)
 {
@@ -852,6 +853,8 @@ void asd_build_initiate_link_adm_task(st
 	ascb->tasklet_complete = link_adm_tasklet_complete;
 }
 
+#endif  /*  0  */
+
 /* ---------- SCB timer ---------- */
 
 /**
diff -puN drivers/scsi/aic94xx/aic94xx_sds.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_sds.c
--- a/drivers/scsi/aic94xx/aic94xx_sds.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -590,8 +590,8 @@ static int asd_reset_flash(struct asd_ha
 	return err;
 }
 
-static inline int asd_read_flash_seg(struct asd_ha_struct *asd_ha,
-				     void *buffer, u32 offs, int size)
+static int asd_read_flash_seg(struct asd_ha_struct *asd_ha,
+			      void *buffer, u32 offs, int size)
 {
 	asd_read_reg_string(asd_ha, buffer, asd_ha->hw_prof.flash.bar+offs,
 			    size);
diff -puN drivers/scsi/aic94xx/aic94xx_seq.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_seq.c
--- a/drivers/scsi/aic94xx/aic94xx_seq.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -60,7 +60,7 @@ static u16 last_scb_site_no;
  *
  * Return 0 on success, negative on failure.
  */
-int asd_pause_cseq(struct asd_ha_struct *asd_ha)
+static int asd_pause_cseq(struct asd_ha_struct *asd_ha)
 {
 	int	count = PAUSE_TRIES;
 	u32	arp2ctl;
@@ -87,7 +87,7 @@ int asd_pause_cseq(struct asd_ha_struct 
  *
  * Return 0 on success, negative on error.
  */
-int asd_unpause_cseq(struct asd_ha_struct *asd_ha)
+static int asd_unpause_cseq(struct asd_ha_struct *asd_ha)
 {
 	u32	arp2ctl;
 	int	count = PAUSE_TRIES;
@@ -115,7 +115,7 @@ int asd_unpause_cseq(struct asd_ha_struc
  *
  * Return 0 on success, negative on error.
  */
-static inline int asd_seq_pause_lseq(struct asd_ha_struct *asd_ha, int lseq)
+static int asd_seq_pause_lseq(struct asd_ha_struct *asd_ha, int lseq)
 {
 	u32    arp2ctl;
 	int    count = PAUSE_TRIES;
@@ -143,7 +143,7 @@ static inline int asd_seq_pause_lseq(str
  *
  * Return 0 on success, negative on failure.
  */
-int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
+static int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
 {
 	int lseq;
 	int err = 0;
@@ -164,7 +164,7 @@ int asd_pause_lseq(struct asd_ha_struct 
  *
  * Return 0 on success, negative on error.
  */
-static inline int asd_seq_unpause_lseq(struct asd_ha_struct *asd_ha, int lseq)
+static int asd_seq_unpause_lseq(struct asd_ha_struct *asd_ha, int lseq)
 {
 	u32 arp2ctl;
 	int count = PAUSE_TRIES;
@@ -186,27 +186,6 @@ static inline int asd_seq_unpause_lseq(s
 }
 
 
-/**
- * asd_unpause_lseq - unpause the link sequencer(s)
- * @asd_ha: pointer to host adapter structure
- * @lseq_mask: mask of link sequencers of interest
- *
- * Return 0 on success, negative on failure.
- */
-int asd_unpause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
-{
-	int lseq;
-	int err = 0;
-
-	for_each_sequencer(lseq_mask, lseq_mask, lseq) {
-		err = asd_seq_unpause_lseq(asd_ha, lseq);
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
 /* ---------- Downloading CSEQ/LSEQ microcode ---------- */
 
 static int asd_verify_cseq(struct asd_ha_struct *asd_ha, const u8 *_prog,
diff -puN drivers/scsi/aic94xx/aic94xx_seq.h~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_seq.h
--- a/drivers/scsi/aic94xx/aic94xx_seq.h~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_seq.h
@@ -58,10 +58,6 @@ struct sequencer_file_header {
 } __attribute__((packed));
 
 #ifdef __KERNEL__
-int asd_pause_cseq(struct asd_ha_struct *asd_ha);
-int asd_unpause_cseq(struct asd_ha_struct *asd_ha);
-int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask);
-int asd_unpause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask);
 int asd_init_seqs(struct asd_ha_struct *asd_ha);
 int asd_start_seqs(struct asd_ha_struct *asd_ha);
 int asd_release_firmware(void);
diff -puN drivers/scsi/aic94xx/aic94xx_task.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_task.c
--- a/drivers/scsi/aic94xx/aic94xx_task.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_task.c
@@ -33,7 +33,7 @@ static void asd_unbuild_ata_ascb(struct 
 static void asd_unbuild_smp_ascb(struct asd_ascb *a);
 static void asd_unbuild_ssp_ascb(struct asd_ascb *a);
 
-static inline void asd_can_dequeue(struct asd_ha_struct *asd_ha, int num)
+static void asd_can_dequeue(struct asd_ha_struct *asd_ha, int num)
 {
 	unsigned long flags;
 
@@ -51,9 +51,9 @@ static const u8 data_dir_flags[] = {
 	[PCI_DMA_NONE]          = DATA_DIR_NONE, /* NO TRANSFER */
 };
 
-static inline int asd_map_scatterlist(struct sas_task *task,
-				      struct sg_el *sg_arr,
-				      gfp_t gfp_flags)
+static int asd_map_scatterlist(struct sas_task *task,
+			       struct sg_el *sg_arr,
+			       gfp_t gfp_flags)
 {
 	struct asd_ascb *ascb = task->lldd_task;
 	struct asd_ha_struct *asd_ha = ascb->ha;
@@ -131,7 +131,7 @@ err_unmap:
 	return res;
 }
 
-static inline void asd_unmap_scatterlist(struct asd_ascb *ascb)
+static void asd_unmap_scatterlist(struct asd_ascb *ascb)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_task *task = ascb->uldd_task;
@@ -527,7 +527,7 @@ static void asd_unbuild_ssp_ascb(struct 
 
 /* ---------- Execute Task ---------- */
 
-static inline int asd_can_queue(struct asd_ha_struct *asd_ha, int num)
+static int asd_can_queue(struct asd_ha_struct *asd_ha, int num)
 {
 	int res = 0;
 	unsigned long flags;
diff -puN drivers/scsi/aic94xx/aic94xx_tmf.c~scsi-aic94xx-cleanups drivers/scsi/aic94xx/aic94xx_tmf.c
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c~scsi-aic94xx-cleanups
+++ a/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -336,7 +336,7 @@ static void asd_tmf_tasklet_complete(str
 	asd_ascb_free(ascb);
 }
 
-static inline int asd_clear_nexus(struct sas_task *task)
+static int asd_clear_nexus(struct sas_task *task)
 {
 	int res = TMF_RESP_FUNC_FAILED;
 	int leftover;
_
