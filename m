From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/aic94xx/: cleanups
Date: Mon, 5 Nov 2007 18:07:29 +0100
Message-ID: <20071105170729.GO12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59518 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757616AbXKERHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 12:07:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch contains the following cleanups:
- static functions in .c files shouldn't be marked inline
- make needlessly global code static
- #if 0 unused code

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/aic94xx/aic94xx_dev.c  |    8 +++---
 drivers/scsi/aic94xx/aic94xx_dump.c |   10 +++++++-
 drivers/scsi/aic94xx/aic94xx_dump.h |    9 -------
 drivers/scsi/aic94xx/aic94xx_hwi.c  |   24 ++++++++++----------
 drivers/scsi/aic94xx/aic94xx_hwi.h  |    2 -
 drivers/scsi/aic94xx/aic94xx_init.c |    8 +++---
 drivers/scsi/aic94xx/aic94xx_reg.c  |   33 +++++++++++++---------------
 drivers/scsi/aic94xx/aic94xx_scb.c  |   33 +++++++++++++++-------------
 drivers/scsi/aic94xx/aic94xx_sds.c  |    4 +--
 drivers/scsi/aic94xx/aic94xx_seq.c  |   12 +++++-----
 drivers/scsi/aic94xx/aic94xx_seq.h  |    4 ---
 drivers/scsi/aic94xx/aic94xx_task.c |   12 +++++-----
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    4 +--
 13 files changed, 80 insertions(+), 83 deletions(-)

7e734a8fb18107e68dd29d3b665c15ceb440a323 
diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
index 3dce618..b5aa4b1 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
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
@@ -79,7 +79,7 @@ static inline void asd_free_ddb(struct asd_ha_struct *asd_ha, int ddb)
 	CLEAR_DDB(ddb, asd_ha);
 }
 
-static inline void asd_set_ddb_type(struct domain_device *dev)
+static void asd_set_ddb_type(struct domain_device *dev)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 	int ddb = (int) (unsigned long) dev->lldd_dev;
@@ -109,7 +109,7 @@ static int asd_init_sata_tag_ddb(struct domain_device *dev)
 	return 0;
 }
 
-static inline int asd_init_sata(struct domain_device *dev)
+static int asd_init_sata(struct domain_device *dev)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 	int ddb = (int) (unsigned long) dev->lldd_dev;
diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 6bd8e30..9d637e2 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -738,6 +738,8 @@ static void asd_dump_lseq_state(struct asd_ha_struct *asd_ha, int lseq)
 	PRINT_LMIP_dword(asd_ha, lseq, DEV_PRES_TIMER_TERM_TS);
 }
 
+#if 0
+
 /**
  * asd_dump_ddb_site -- dump a CSEQ DDB site
  * @asd_ha: pointer to host adapter structure
@@ -880,6 +882,8 @@ void asd_dump_scb_sites(struct asd_ha_struct *asd_ha)
 	}
 }
 
+#endif  /*  0  */
+
 /**
  * ads_dump_seq_state -- dump CSEQ and LSEQ states
  * @asd_ha: pointer to host adapter structure
@@ -922,7 +926,9 @@ void asd_dump_frame_rcvd(struct asd_phy *phy,
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 }
 
-static inline void asd_dump_scb(struct asd_ascb *ascb, int ind)
+#if 0
+
+static void asd_dump_scb(struct asd_ascb *ascb, int ind)
 {
 	asd_printk("scb%d: vaddr: 0x%p, dma_handle: 0x%llx, next: 0x%llx, "
 		   "index:%d, opcode:0x%02x\n",
@@ -956,4 +962,6 @@ void asd_dump_scb_list(struct asd_ascb *ascb, int num)
 	}
 }
 
+#endif  /*  0  */
+
 #endif /* ASD_DEBUG */
diff --git a/drivers/scsi/aic94xx/aic94xx_dump.h b/drivers/scsi/aic94xx/aic94xx_dump.h
index 0c388e7..191a753 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.h
+++ b/drivers/scsi/aic94xx/aic94xx_dump.h
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
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 0cd7eed..e163cba 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -251,7 +251,7 @@ static int asd_init_scbs(struct asd_ha_struct *asd_ha)
 	return 0;
 }
 
-static inline void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
+static void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
 {
 	asd_ha->hw_prof.max_scbs = asd_get_cmdctx_size(asd_ha)/ASD_SCB_SIZE;
 	asd_ha->hw_prof.max_ddbs = asd_get_devctx_size(asd_ha)/ASD_DDB_SIZE;
@@ -773,7 +773,7 @@ static void asd_dl_tasklet_handler(unsigned long data)
  * asd_process_donelist_isr -- schedule processing of done list entries
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_process_donelist_isr(struct asd_ha_struct *asd_ha)
+static void asd_process_donelist_isr(struct asd_ha_struct *asd_ha)
 {
 	tasklet_schedule(&asd_ha->seq.dl_tasklet);
 }
@@ -782,7 +782,7 @@ static inline void asd_process_donelist_isr(struct asd_ha_struct *asd_ha)
  * asd_com_sas_isr -- process device communication interrupt (COMINT)
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_com_sas_isr(struct asd_ha_struct *asd_ha)
+static void asd_com_sas_isr(struct asd_ha_struct *asd_ha)
 {
 	u32 comstat = asd_read_reg_dword(asd_ha, COMSTAT);
 
@@ -821,7 +821,7 @@ static inline void asd_com_sas_isr(struct asd_ha_struct *asd_ha)
 	asd_chip_reset(asd_ha);
 }
 
-static inline void asd_arp2_err(struct asd_ha_struct *asd_ha, u32 dchstatus)
+static void asd_arp2_err(struct asd_ha_struct *asd_ha, u32 dchstatus)
 {
 	static const char *halt_code[256] = {
 		"UNEXPECTED_INTERRUPT0",
@@ -908,7 +908,7 @@ static inline void asd_arp2_err(struct asd_ha_struct *asd_ha, u32 dchstatus)
  * asd_dch_sas_isr -- process device channel interrupt (DEVINT)
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_dch_sas_isr(struct asd_ha_struct *asd_ha)
+static void asd_dch_sas_isr(struct asd_ha_struct *asd_ha)
 {
 	u32 dchstatus = asd_read_reg_dword(asd_ha, DCHSTATUS);
 
@@ -923,7 +923,7 @@ static inline void asd_dch_sas_isr(struct asd_ha_struct *asd_ha)
  * ads_rbi_exsi_isr -- process external system interface interrupt (INITERR)
  * @asd_ha: pointer to host adapter structure
  */
-static inline void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
+static void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
 {
 	u32 stat0r = asd_read_reg_dword(asd_ha, ASISTAT0R);
 
@@ -971,7 +971,7 @@ static inline void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
  *
  * Asserted on PCIX errors: target abort, etc.
  */
-static inline void asd_hst_pcix_isr(struct asd_ha_struct *asd_ha)
+static void asd_hst_pcix_isr(struct asd_ha_struct *asd_ha)
 {
 	u16 status;
 	u32 pcix_status;
@@ -1044,8 +1044,8 @@ irqreturn_t asd_hw_isr(int irq, void *dev_id)
 
 /* ---------- SCB handling ---------- */
 
-static inline struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,
-					      gfp_t gfp_flags)
+static struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,
+				       gfp_t gfp_flags)
 {
 	extern struct kmem_cache *asd_ascb_cache;
 	struct asd_seq_data *seq = &asd_ha->seq;
@@ -1144,8 +1144,8 @@ struct asd_ascb *asd_ascb_alloc_list(struct asd_ha_struct
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
@@ -1171,7 +1171,7 @@ static inline void asd_swap_head_scb(struct asd_ha_struct *asd_ha,
  * intended to be called from asd_post_ascb_list(), just prior to
  * posting the SCBs to the sequencer.
  */
-static inline void asd_start_scb_timers(struct list_head *list)
+static void asd_start_scb_timers(struct list_head *list)
 {
 	struct asd_ascb *ascb;
 	list_for_each_entry(ascb, list, list) {
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 491e5d8..cd5b671 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -389,8 +389,6 @@ void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc);
 void asd_control_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
 void asd_turn_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
 int  asd_enable_phys(struct asd_ha_struct *asd_ha, const u8 phy_mask);
-void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
-				      u8 subfunc);
 
 void asd_ascb_timedout(unsigned long data);
 int  asd_chip_hardrst(struct asd_ha_struct *asd_ha);
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index b70d6e7..3d81532 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -364,7 +364,7 @@ static struct asd_pcidev_struct {
 	},
 };
 
-static inline int asd_create_ha_caches(struct asd_ha_struct *asd_ha)
+static int asd_create_ha_caches(struct asd_ha_struct *asd_ha)
 {
 	asd_ha->scb_pool = dma_pool_create(ASD_DRIVER_NAME "_scb_pool",
 					   &asd_ha->pcidev->dev,
@@ -382,7 +382,7 @@ static inline int asd_create_ha_caches(struct asd_ha_struct *asd_ha)
  * asd_free_edbs -- free empty data buffers
  * asd_ha: pointer to host adapter structure
  */
-static inline void asd_free_edbs(struct asd_ha_struct *asd_ha)
+static void asd_free_edbs(struct asd_ha_struct *asd_ha)
 {
 	struct asd_seq_data *seq = &asd_ha->seq;
 	int i;
@@ -393,7 +393,7 @@ static inline void asd_free_edbs(struct asd_ha_struct *asd_ha)
 	seq->edb_arr = NULL;
 }
 
-static inline void asd_free_escbs(struct asd_ha_struct *asd_ha)
+static void asd_free_escbs(struct asd_ha_struct *asd_ha)
 {
 	struct asd_seq_data *seq = &asd_ha->seq;
 	int i;
@@ -408,7 +408,7 @@ static inline void asd_free_escbs(struct asd_ha_struct *asd_ha)
 	seq->escb_arr = NULL;
 }
 
-static inline void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
+static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 {
 	int i;
 
diff --git a/drivers/scsi/aic94xx/aic94xx_reg.c b/drivers/scsi/aic94xx/aic94xx_reg.c
index f210dac..6f36b39 100644
--- a/drivers/scsi/aic94xx/aic94xx_reg.c
+++ b/drivers/scsi/aic94xx/aic94xx_reg.c
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
@@ -43,8 +43,8 @@ static inline void asd_write_byte(struct asd_ha_struct *asd_ha,
 	wmb();
 }
 
-static inline void asd_write_word(struct asd_ha_struct *asd_ha,
-				  unsigned long offs, u16 val)
+static void asd_write_word(struct asd_ha_struct *asd_ha,
+			   unsigned long offs, u16 val)
 {
 	if (unlikely(asd_ha->iospace))
 		outw(val,
@@ -54,8 +54,8 @@ static inline void asd_write_word(struct asd_ha_struct *asd_ha,
 	wmb();
 }
 
-static inline void asd_write_dword(struct asd_ha_struct *asd_ha,
-				   unsigned long offs, u32 val)
+static void asd_write_dword(struct asd_ha_struct *asd_ha,
+			    unsigned long offs, u32 val)
 {
 	if (unlikely(asd_ha->iospace))
 		outl(val,
@@ -67,8 +67,7 @@ static inline void asd_write_dword(struct asd_ha_struct *asd_ha,
 
 /* Reading from device address space.
  */
-static inline u8 asd_read_byte(struct asd_ha_struct *asd_ha,
-			       unsigned long offs)
+static u8 asd_read_byte(struct asd_ha_struct *asd_ha, unsigned long offs)
 {
 	u8 val;
 	if (unlikely(asd_ha->iospace))
@@ -80,8 +79,8 @@ static inline u8 asd_read_byte(struct asd_ha_struct *asd_ha,
 	return val;
 }
 
-static inline u16 asd_read_word(struct asd_ha_struct *asd_ha,
-				unsigned long offs)
+static u16 asd_read_word(struct asd_ha_struct *asd_ha,
+			 unsigned long offs)
 {
 	u16 val;
 	if (unlikely(asd_ha->iospace))
@@ -93,8 +92,8 @@ static inline u16 asd_read_word(struct asd_ha_struct *asd_ha,
 	return val;
 }
 
-static inline u32 asd_read_dword(struct asd_ha_struct *asd_ha,
-				 unsigned long offs)
+static u32 asd_read_dword(struct asd_ha_struct *asd_ha,
+			  unsigned long offs)
 {
 	u32 val;
 	if (unlikely(asd_ha->iospace))
@@ -125,8 +124,8 @@ static inline u32 asd_mem_offs_swb(void)
  * of the sliding window.
  */
 #define ASD_READ_SW(ww, type, ord)                                     \
-static inline type asd_read_##ww##_##ord (struct asd_ha_struct *asd_ha,\
-					  u32 reg)                     \
+static type asd_read_##ww##_##ord (struct asd_ha_struct *asd_ha,       \
+				   u32 reg)			       \
 {                                                                      \
 	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];    \
 	u32 map_offs=(reg - io_handle-> ww##_base )+asd_mem_offs_##ww ();\
@@ -134,8 +133,8 @@ static inline type asd_read_##ww##_##ord (struct asd_ha_struct *asd_ha,\
 }
 
 #define ASD_WRITE_SW(ww, type, ord)                                    \
-static inline void asd_write_##ww##_##ord (struct asd_ha_struct *asd_ha,\
-				  u32 reg, type val)                   \
+static void asd_write_##ww##_##ord (struct asd_ha_struct *asd_ha,      \
+				    u32 reg, type val)		       \
 {                                                                      \
 	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];    \
 	u32 map_offs=(reg - io_handle-> ww##_base )+asd_mem_offs_##ww ();\
@@ -186,7 +185,7 @@ ASD_WRITE_SW(swc, u32, dword);
  * @asd_ha: pointer to host adapter structure
  * @reg: register desired to be within range of the new window
  */
-static inline void asd_move_swb(struct asd_ha_struct *asd_ha, u32 reg)
+static void asd_move_swb(struct asd_ha_struct *asd_ha, u32 reg)
 {
 	u32 base = reg & ~(MBAR0_SWB_SIZE-1);
 	pci_write_config_dword(asd_ha->pcidev, PCI_CONF_MBAR0_SWB, base);
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index db6ab1a..1b967b5 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -50,7 +50,7 @@
 			   | CURRENT_SPINUP_HOLD | CURRENT_GTO_TIMEOUT \
 			   | CURRENT_OOB_ERROR)
 
-static inline void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
+static void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
 {
 	struct sas_phy *sas_phy = phy->sas_phy.phy;
 
@@ -81,7 +81,7 @@ static inline void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
 		phy->sas_phy.oob_mode = SATA_OOB_MODE;
 }
 
-static inline void asd_phy_event_tasklet(struct asd_ascb *ascb,
+static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 					 struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
@@ -125,8 +125,7 @@ static inline void asd_phy_event_tasklet(struct asd_ascb *ascb,
 }
 
 /* If phys are enabled sparsely, this will do the right thing. */
-static inline unsigned ord_phy(struct asd_ha_struct *asd_ha,
-			       struct asd_phy *phy)
+static unsigned ord_phy(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 {
 	u8 enabled_mask = asd_ha->hw_prof.enabled_phys;
 	int i, k = 0;
@@ -151,7 +150,7 @@ static inline unsigned ord_phy(struct asd_ha_struct *asd_ha,
  * LOCKING: the frame_rcvd_lock needs to be held since this parses the frame
  * buffer.
  */
-static inline void asd_get_attached_sas_addr(struct asd_phy *phy, u8 *sas_addr)
+static void asd_get_attached_sas_addr(struct asd_phy *phy, u8 *sas_addr)
 {
 	if (phy->sas_phy.frame_rcvd[0] == 0x34
 	    && phy->sas_phy.oob_mode == SATA_OOB_MODE) {
@@ -232,9 +231,9 @@ static void asd_deform_port(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
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
@@ -255,9 +254,9 @@ static inline void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
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
@@ -709,7 +708,7 @@ out:
 	asd_ascb_free(ascb);
 }
 
-static inline void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
+static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 {
 	/* disable all speeds, then enable defaults */
 	*speed_mask = SAS_SPEED_60_DIS | SAS_SPEED_30_DIS | SAS_SPEED_15_DIS
@@ -814,6 +813,8 @@ void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc)
 
 /* ---------- INITIATE LINK ADM TASK ---------- */
 
+#if 0
+
 static void link_adm_tasklet_complete(struct asd_ascb *ascb,
 				      struct done_list_struct *dl)
 {
@@ -846,6 +847,8 @@ void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
 	ascb->tasklet_complete = link_adm_tasklet_complete;
 }
 
+#endif  /*  0  */
+
 /* ---------- SCB timer ---------- */
 
 /**
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 5b0932f..62cda27 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -589,8 +589,8 @@ static int asd_reset_flash(struct asd_ha_struct *asd_ha)
 	return err;
 }
 
-static inline int asd_read_flash_seg(struct asd_ha_struct *asd_ha,
-				     void *buffer, u32 offs, int size)
+static int asd_read_flash_seg(struct asd_ha_struct *asd_ha,
+			      void *buffer, u32 offs, int size)
 {
 	asd_read_reg_string(asd_ha, buffer, asd_ha->hw_prof.flash.bar+offs,
 			    size);
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index c750fbf..143d504 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -60,7 +60,7 @@ static u16 last_scb_site_no;
  *
  * Return 0 on success, negative on failure.
  */
-int asd_pause_cseq(struct asd_ha_struct *asd_ha)
+static int asd_pause_cseq(struct asd_ha_struct *asd_ha)
 {
 	int	count = PAUSE_TRIES;
 	u32	arp2ctl;
@@ -87,7 +87,7 @@ int asd_pause_cseq(struct asd_ha_struct *asd_ha)
  *
  * Return 0 on success, negative on error.
  */
-int asd_unpause_cseq(struct asd_ha_struct *asd_ha)
+static int asd_unpause_cseq(struct asd_ha_struct *asd_ha)
 {
 	u32	arp2ctl;
 	int	count = PAUSE_TRIES;
@@ -115,7 +115,7 @@ int asd_unpause_cseq(struct asd_ha_struct *asd_ha)
  *
  * Return 0 on success, negative on error.
  */
-static inline int asd_seq_pause_lseq(struct asd_ha_struct *asd_ha, int lseq)
+static int asd_seq_pause_lseq(struct asd_ha_struct *asd_ha, int lseq)
 {
 	u32    arp2ctl;
 	int    count = PAUSE_TRIES;
@@ -143,7 +143,7 @@ static inline int asd_seq_pause_lseq(struct asd_ha_struct *asd_ha, int lseq)
  *
  * Return 0 on success, negative on failure.
  */
-int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
+static int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
 {
 	int lseq;
 	int err = 0;
@@ -164,7 +164,7 @@ int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
  *
  * Return 0 on success, negative on error.
  */
-static inline int asd_seq_unpause_lseq(struct asd_ha_struct *asd_ha, int lseq)
+static int asd_seq_unpause_lseq(struct asd_ha_struct *asd_ha, int lseq)
 {
 	u32 arp2ctl;
 	int count = PAUSE_TRIES;
@@ -186,6 +186,7 @@ static inline int asd_seq_unpause_lseq(struct asd_ha_struct *asd_ha, int lseq)
 }
 
 
+#if 0
 /**
  * asd_unpause_lseq - unpause the link sequencer(s)
  * @asd_ha: pointer to host adapter structure
@@ -206,6 +207,7 @@ int asd_unpause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask)
 
 	return err;
 }
+#endif  /*  0  */
 
 /* ---------- Downloading CSEQ/LSEQ microcode ---------- */
 
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.h b/drivers/scsi/aic94xx/aic94xx_seq.h
index 2ea6a0d..ad787c5 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.h
+++ b/drivers/scsi/aic94xx/aic94xx_seq.h
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
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index ee0a98b..e35b731 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -33,7 +33,7 @@ static void asd_unbuild_ata_ascb(struct asd_ascb *a);
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
@@ -541,7 +541,7 @@ static void asd_unbuild_ssp_ascb(struct asd_ascb *a)
 
 /* ---------- Execute Task ---------- */
 
-static inline int asd_can_queue(struct asd_ha_struct *asd_ha, int num)
+static int asd_can_queue(struct asd_ha_struct *asd_ha, int num)
 {
 	int res = 0;
 	unsigned long flags;
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index c0d0b7d..c3fe7ca 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -53,7 +53,7 @@ static int asd_enqueue_internal(struct asd_ascb *ascb,
 	return res;
 }
 
-static inline void asd_timedout_common(unsigned long data)
+static void asd_timedout_common(unsigned long data)
 {
 	struct asd_ascb *ascb = (void *) data;
 	struct asd_seq_data *seq = &ascb->ha->seq;
@@ -287,7 +287,7 @@ static void asd_tmf_tasklet_complete(struct asd_ascb *ascb,
 	complete(&ascb->completion);
 }
 
-static inline int asd_clear_nexus(struct sas_task *task)
+static int asd_clear_nexus(struct sas_task *task)
 {
 	int res = TMF_RESP_FUNC_FAILED;
 	int leftover;

