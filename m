From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [1/5] - formatting cleanups
Date: Tue, 9 Mar 2004 15:23:00 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309042300.GA12274@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:45508 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261516AbUCIEXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 23:23:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Formatting cleanups.
- Remove lots of comments that were out-of-date, wrong, or now
  described things that had been simplified that much that the
  comments were no longer needed.
- Move the "static" definition from a line before functions onto the
  same line as the function itself.
- Remove "return;" from the end of void functions.
- Remove braces from around single instructions.
- Merge the declaration and assignment to variables in places where
  the followed each other.
- Remove braces from around single statement that obviously didn't
  need them.
- Remove unused code and variables.
- Fix debug statement in disconnect to not deref potentially null
  ptr.
- Change a lot of short comments that take up three lines down to one
  line.

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-09-29 12:28:31.487001753 +1000
+++ b/drivers/scsi/dc395x.c	2003-09-28 23:43:24.495057145 +1000
@@ -87,7 +87,6 @@
 #define DBG_SGPARANOIA	0x0020
 #define DBG_FIFO	0x0040
 #define DBG_PIO		0x0080
-#define DBG_RECURSION	0x0100		/* check for excessive recursion */
 #define DBG_MALLOC	0x0200		/* report on memory allocations */
 #define DBG_TRACE	0x0400
 #define DBG_TRACEALL	0x0800
@@ -139,16 +138,6 @@
 
 
 /*
- * The recursion debugging just counts entries into the driver and
- * prints out a messge if it exceeds a certain limit. This variable
- * hold the count.
- */
-#if debug_enabled(DBG_RECURSION)
-static int dbg_in_driver = 0;
-#endif
-
-
-/*
  * Memory allocation debugging
  * Just reports when memory is allocated and/or released.
  */
@@ -182,7 +171,6 @@
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 # define DEBUGTRACEBUFSZ 512
 static char tracebuf[64];
-static char traceoverflow[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 # define TRACEPRINTF(x...) \
 	do { \
 		int ln = sprintf(tracebuf, x); \
@@ -212,24 +200,13 @@
 #endif
 
 
-
 #define DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
 #define DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
 
-#define DC395x_ACB_INITLOCK(acb)		spin_lock_init(&acb->smp_lock)
-#define DC395x_ACB_LOCK(acb,acb_flags)		if (!acb->lock_level_count[cpuid]) { spin_lock_irqsave(&acb->smp_lock,acb_flags); acb->lock_level_count[cpuid]++; } else { acb->lock_level_count[cpuid]++; }
-#define DC395x_ACB_UNLOCK(acb,acb_flags)	if (--acb->lock_level_count[cpuid] == 0) { spin_unlock_irqrestore(&acb->smp_lock,acb_flags); }
-
-#define DC395x_SMP_IO_LOCK(dev,irq_flags)	spin_lock_irqsave(((struct Scsi_Host*)dev)->host_lock,irq_flags)
-#define DC395x_SMP_IO_UNLOCK(dev,irq_flags)	spin_unlock_irqrestore(((struct Scsi_Host*)dev)->host_lock,irq_flags)
-
-
 #define DC395x_read8(acb,address)		(u8)(inb(acb->io_port_base + (address)))
-#define DC395x_read8_(address, base)		(u8)(inb((USHORT)(base) + (address)))
 #define DC395x_read16(acb,address)		(u16)(inw(acb->io_port_base + (address)))
 #define DC395x_read32(acb,address)		(u32)(inl(acb->io_port_base + (address)))
 #define DC395x_write8(acb,address,value)	outb((value), acb->io_port_base + (address))
-#define DC395x_write8_(address,value,base)	outb((value), (USHORT)(base) + (address))
 #define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
 #define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
 
@@ -254,20 +231,15 @@
 #define SET_RES_DID(who,did) { who &= ~RES_DID; who |= (int)(did) << 16; }
 #define SET_RES_DRV(who,drv) { who &= ~RES_DRV; who |= (int)(drv) << 24; }
 
-/*
-**************************************************************************
-*/
 #define TAG_NONE 255
 
+
 struct SGentry {
 	u32 address;		/* bus! address */
 	u32 length;
 };
 
-
-/*
- * The SEEPROM structure for TRM_S1040 
- */
+/* The SEEPROM structure for TRM_S1040 */
 struct NVRamTarget {
 	u8 cfg0;		/* Target configuration byte 0  */
 	u8 period;		/* Target period                */
@@ -275,7 +247,6 @@
 	u8 cfg3;		/* Target configuration byte 3  */
 };
 
-
 struct NvRamType {
 	u8 sub_vendor_id[2];	/* 0,1  Sub Vendor ID   */
 	u8 sub_sys_id[2];	/* 2,3  Sub System ID   */
@@ -302,10 +273,6 @@
 	u16 cksum;		/* 126,127 */
 };
 
-
-/*-----------------------------------------------------------------------
-  SCSI Request Block
-  -----------------------------------------------------------------------*/
 struct ScsiReqBlk {
 	struct list_head list;		/* next/prev ptrs for srb lists */
 	struct DeviceCtlBlk *dcb;
@@ -346,10 +313,6 @@
 #endif
 };
 
-
-/*-----------------------------------------------------------------------
-  Device Control Block
-  -----------------------------------------------------------------------*/
 struct DeviceCtlBlk {
 	struct list_head list;		/* next/prev ptrs for the dcb list */
 	struct AdapterCtlBlk *acb;
@@ -377,9 +340,6 @@
 	u8 init_tcq_flag;
 };
 
-/*-----------------------------------------------------------------------
-  Adapter Control Block
-  -----------------------------------------------------------------------*/
 struct AdapterCtlBlk {
 	struct Scsi_Host *scsi_host;
 
@@ -423,80 +383,63 @@
 };
 
 
-
-
 /*---------------------------------------------------------------------------
                             Forward declarations
  ---------------------------------------------------------------------------*/
-static void data_out_phase0(struct AdapterCtlBlk *acb,
-			    struct ScsiReqBlk *srb,
-			    u16 * pscsi_status);
-static void data_in_phase0(struct AdapterCtlBlk *acb,
-			   struct ScsiReqBlk *srb,
-			   u16 * pscsi_status);
-static void command_phase0(struct AdapterCtlBlk *acb,
-			   struct ScsiReqBlk *srb,
-			   u16 * pscsi_status);
-static void status_phase0(struct AdapterCtlBlk *acb,
-			  struct ScsiReqBlk *srb,
-			  u16 * pscsi_status);
-static void msgout_phase0(struct AdapterCtlBlk *acb,
-			  struct ScsiReqBlk *srb,
-			  u16 * pscsi_status);
-static void msgin_phase0(struct AdapterCtlBlk *acb,
-			 struct ScsiReqBlk *srb,
-			 u16 * pscsi_status);
-static void data_out_phase1(struct AdapterCtlBlk *acb,
-			    struct ScsiReqBlk *srb,
-			    u16 * pscsi_status);
-static void data_in_phase1(struct AdapterCtlBlk *acb,
-			   struct ScsiReqBlk *srb,
-			   u16 * pscsi_status);
-static void command_phase1(struct AdapterCtlBlk *acb,
-			   struct ScsiReqBlk *srb,
-			   u16 * pscsi_status);
-static void status_phase1(struct AdapterCtlBlk *acb,
-			  struct ScsiReqBlk *srb,
-			  u16 * pscsi_status);
-static void msgout_phase1(struct AdapterCtlBlk *acb,
-			  struct ScsiReqBlk *srb,
-			  u16 * pscsi_status);
-static void msgin_phase1(struct AdapterCtlBlk *acb,
-			 struct ScsiReqBlk *srb,
-			 u16 * pscsi_status);
+static void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void command_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
+static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status);
 static void nop0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		 u16 * pscsi_status);
-static void nop1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		 u16 * pscsi_status);
+		u16 *pscsi_status);
+static void nop1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb, 
+		u16 *pscsi_status);
 static void set_basic_config(struct AdapterCtlBlk *acb);
 static void cleanup_after_transfer(struct AdapterCtlBlk *acb,
-				   struct ScsiReqBlk *srb);
+		struct ScsiReqBlk *srb);
 static void reset_scsi_bus(struct AdapterCtlBlk *acb);
 static void data_io_transfer(struct AdapterCtlBlk *acb,
-			     struct ScsiReqBlk *srb, u16 io_dir);
+		struct ScsiReqBlk *srb, u16 io_dir);
 static void disconnect(struct AdapterCtlBlk *acb);
 static void reselect(struct AdapterCtlBlk *acb);
 static u8 start_scsi(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
-		     struct ScsiReqBlk *srb);
+		struct ScsiReqBlk *srb);
 static void build_srb(Scsi_Cmnd * cmd, struct DeviceCtlBlk *dcb,
-		      struct ScsiReqBlk *srb);
+		struct ScsiReqBlk *srb);
 static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_code,
-			   Scsi_Cmnd * cmd, u8 force);
+		Scsi_Cmnd *cmd, u8 force);
 static void scsi_reset_detect(struct AdapterCtlBlk *acb);
-static void pci_unmap_srb(struct AdapterCtlBlk *acb,
-			  struct ScsiReqBlk *srb);
+static void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb);
 static void pci_unmap_srb_sense(struct AdapterCtlBlk *acb,
-				struct ScsiReqBlk *srb);
+		struct ScsiReqBlk *srb);
 static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
-				       struct ScsiReqBlk *srb);
-static void srb_done(struct AdapterCtlBlk *acb,
-		     struct DeviceCtlBlk *dcb,
-		     struct ScsiReqBlk *srb);
-static void request_sense(struct AdapterCtlBlk *acb,
-			  struct DeviceCtlBlk *dcb,
-			  struct ScsiReqBlk *srb);
+		struct ScsiReqBlk *srb);
+static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb);
+static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb);
 static inline void set_xfer_rate(struct AdapterCtlBlk *acb,
-				 struct DeviceCtlBlk *dcb);
+		struct DeviceCtlBlk *dcb);
 static void waiting_timeout(unsigned long ptr);
 
 
@@ -506,9 +449,6 @@
 static u16 current_sync_offset = 0;
 static char monitor_next_irq = 0;
 
-/* 
- * dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- */
 static void *dc395x_scsi_phase0[] = {
 	data_out_phase0,/* phase:0 */
 	data_in_phase0,	/* phase:1 */
@@ -520,9 +460,6 @@
 	msgin_phase0,	/* phase:7 */
 };
 
-/*
- * dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- */
 static void *dc395x_scsi_phase1[] = {
 	data_out_phase1,/* phase:0 */
 	data_in_phase1,	/* phase:1 */
@@ -558,8 +495,6 @@
 /* real period:48ns,76ns,100ns,124ns,148ns,176ns,200ns,248ns */
 static u8 clock_period[] = { 12, 18, 25, 31, 37, 43, 50, 62 };
 static u16 clock_speed[] = { 200, 133, 100, 80, 67, 58, 50, 40 };
-/* real period:48ns,72ns,100ns,124ns,148ns,172ns,200ns,248ns */
-
 
 
 /*---------------------------------------------------------------------------
@@ -655,8 +590,9 @@
 
 
 /*
- * Safe settings. If set to zero the the BIOS/default values with command line
- * overrides will be used. If set to 1 then safe and slow settings will be used.
+ * Safe settings. If set to zero the the BIOS/default values with
+ * command line overrides will be used. If set to 1 then safe and
+ * slow settings will be used.
  */
 static int use_safe_settings = 0;
 module_param_named(safe, use_safe_settings, bool, 0);
@@ -686,8 +622,7 @@
  * set_safe_settings - if the use_safe_settings option is set then
  * set all values to the safe and slow values.
  **/
-static
-void __init set_safe_settings(void)
+static void __init set_safe_settings(void)
 {
 	if (use_safe_settings)
 	{
@@ -706,8 +641,7 @@
  * fix_settings - reset any boot parameters which are out of range
  * back to the default values.
  **/
-static
-void __init fix_settings(void)
+static void __init fix_settings(void)
 {
 	int i;
 
@@ -720,11 +654,9 @@
 		    cfg_data[CFG_RESET_DELAY].value);
 	for (i = 0; i < CFG_NUM; i++)
 	{
-		if (cfg_data[i].value < cfg_data[i].min ||
-			cfg_data[i].value > cfg_data[i].max)
-		{
+		if (cfg_data[i].value < cfg_data[i].min
+		    || cfg_data[i].value > cfg_data[i].max)
 			cfg_data[i].value = cfg_data[i].def;
-		}
 	}
 }
 
@@ -734,8 +666,8 @@
  * Mapping from the eeprom delay index value (index into this array)
  * to the the number of actual seconds that the delay should be for.
  */
-static
-char __initdata eeprom_index_to_delay_map[] = { 1, 3, 5, 10, 16, 30, 60, 120 };
+static char __initdata eeprom_index_to_delay_map[] = 
+	{ 1, 3, 5, 10, 16, 30, 60, 120 };
 
 
 /**
@@ -744,25 +676,24 @@
  *
  * @eeprom: The eeprom structure in which we find the delay index to map.
  **/
-static
-void __init eeprom_index_to_delay(struct NvRamType *eeprom)
+static void __init eeprom_index_to_delay(struct NvRamType *eeprom)
 {
 	eeprom->delay_time = eeprom_index_to_delay_map[eeprom->delay_time];
 }
 
 
 /**
- * delay_to_eeprom_index - Take a delay in seconds and return the closest
- * eeprom index which will delay for at least that amount of seconds.
+ * delay_to_eeprom_index - Take a delay in seconds and return the
+ * closest eeprom index which will delay for at least that amount of
+ * seconds.
  *
  * @delay: The delay, in seconds, to find the eeprom index for.
  **/
 static int __init delay_to_eeprom_index(int delay)
 {
 	u8 idx = 0;
-	while (idx < 7 && eeprom_index_to_delay_map[idx] < delay) {
+	while (idx < 7 && eeprom_index_to_delay_map[idx] < delay)
 		idx++;
-	}
 	return idx;
 }
 
@@ -774,38 +705,34 @@
  *
  * @eeprom: The eeprom data to override with command line options.
  **/
-static
-void __init eeprom_override(struct NvRamType *eeprom)
+static void __init eeprom_override(struct NvRamType *eeprom)
 {
 	u8 id;
 
 	/* Adapter Settings */
-	if (cfg_data[CFG_ADAPTER_ID].value != CFG_PARAM_UNSET) {
-		eeprom->scsi_id =
-		    (u8)cfg_data[CFG_ADAPTER_ID].value;
-	}
-	if (cfg_data[CFG_ADAPTER_MODE].value != CFG_PARAM_UNSET) {
-		eeprom->channel_cfg =
-		    (u8)cfg_data[CFG_ADAPTER_MODE].value;
-	}
-	if (cfg_data[CFG_RESET_DELAY].value != CFG_PARAM_UNSET) {
-		eeprom->delay_time =
-		    delay_to_eeprom_index(cfg_data[CFG_RESET_DELAY].value);
-	}
-	if (cfg_data[CFG_TAGS].value != CFG_PARAM_UNSET) {
+	if (cfg_data[CFG_ADAPTER_ID].value != CFG_PARAM_UNSET)
+		eeprom->scsi_id = (u8)cfg_data[CFG_ADAPTER_ID].value;
+
+	if (cfg_data[CFG_ADAPTER_MODE].value != CFG_PARAM_UNSET)
+		eeprom->channel_cfg = (u8)cfg_data[CFG_ADAPTER_MODE].value;
+
+	if (cfg_data[CFG_RESET_DELAY].value != CFG_PARAM_UNSET)
+		eeprom->delay_time = delay_to_eeprom_index(
+					cfg_data[CFG_RESET_DELAY].value);
+
+	if (cfg_data[CFG_TAGS].value != CFG_PARAM_UNSET)
 		eeprom->max_tag = (u8)cfg_data[CFG_TAGS].value;
-	}
 
 	/* Device Settings */
 	for (id = 0; id < DC395x_MAX_SCSI_ID; id++) {
-		if (cfg_data[CFG_DEV_MODE].value != CFG_PARAM_UNSET) {
+		if (cfg_data[CFG_DEV_MODE].value != CFG_PARAM_UNSET)
 			eeprom->target[id].cfg0 =
-			    (u8)cfg_data[CFG_DEV_MODE].value;
-		}
-		if (cfg_data[CFG_MAX_SPEED].value != CFG_PARAM_UNSET) {
+				(u8)cfg_data[CFG_DEV_MODE].value;
+
+		if (cfg_data[CFG_MAX_SPEED].value != CFG_PARAM_UNSET)
 			eeprom->target[id].period =
-			    (u8)cfg_data[CFG_MAX_SPEED].value;
-		}
+				(u8)cfg_data[CFG_MAX_SPEED].value;
+
 	}
 }
 
@@ -813,14 +740,7 @@
 /*---------------------------------------------------------------------------
  ---------------------------------------------------------------------------*/
 
-/**
- * list_size - Returns the size (in number of entries) of the
- * supplied list.
- *
- * @head: The pointer to the head of the list to count the items in.
- **/
-static
-unsigned int list_size(struct list_head *head)
+static unsigned int list_size(struct list_head *head)
 {
 	unsigned int count = 0;
 	struct list_head *pos;
@@ -830,18 +750,7 @@
 }                                                                                        
 
 
-/**
- * dcb_get_next - Given a dcb return the next dcb in the list of
- * dcb's, wrapping back to the start of the dcb list if required.
- * Returns the supplied dcb if there is only one dcb in the list.
- *
- * @head: The pointer to the head of the list to count the items in.
- * @pos: The pointer the dcb for which we are searching for the
- *       following dcb.
- **/
-static
-struct DeviceCtlBlk *dcb_get_next(
-		struct list_head *head,
+static struct DeviceCtlBlk *dcb_get_next(struct list_head *head,
 		struct DeviceCtlBlk *pos)
 {
 	int use_next = 0;
@@ -870,22 +779,7 @@
 }
 
 
-/*
- * Queueing philosphy:
- * There are a couple of lists:
- * - Waiting: Contains a list of SRBs not yet sent (per DCB)
- * - Free: List of free SRB slots
- * 
- * If there are no waiting commands for the DCB, the new one is sent to the bus
- * otherwise the oldest one is taken from the Waiting list and the new one is 
- * queued to the Waiting List
- * 
- * Lists are managed using two pointers and eventually a counter
- */
-
-/* Nomen est omen ... */
-static inline
-void free_tag(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
+static void free_tag(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
 	if (srb->tag_number < 255) {
 		dcb->tag_mask &= ~(1 << srb->tag_number);	/* free tag mask */
@@ -895,9 +789,8 @@
 
 
 /* Find cmd in SRB list */
-inline static
-struct ScsiReqBlk *find_cmd(Scsi_Cmnd *cmd,
-			    struct list_head *head)
+inline static struct ScsiReqBlk *find_cmd(Scsi_Cmnd *cmd, 
+		struct list_head *head)
 {
 	struct ScsiReqBlk *i;
 	list_for_each_entry(i, head, list)
@@ -907,12 +800,7 @@
 }
 
 
-/*
- * srb_get_free - Return a free srb from the list of free SRBs that
- * is stored with the acb.
- */
-static
-struct ScsiReqBlk *srb_get_free(struct AdapterCtlBlk *acb)
+static struct ScsiReqBlk *srb_get_free(struct AdapterCtlBlk *acb)
 {
 	struct list_head *head = &acb->srb_free_list;
 	struct ScsiReqBlk *srb;
@@ -929,62 +817,37 @@
 }
 
 
-/*
- * srb_free_insert - Insert an srb to the head of the free list
- * stored in the acb.
- */
-static
-void srb_free_insert(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+static void srb_free_insert(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_free_insert: put srb %p\n", srb);
         list_add_tail(&srb->list, &acb->srb_free_list);
 }
 
 
-/*
- * srb_waiting_insert - Insert an srb to the head of the wiating list
- * stored in the dcb.
- */
-static
-void srb_waiting_insert(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
+static void srb_waiting_insert(struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_insert: srb %p cmd %li\n", srb, srb->cmd->pid);
         list_add(&srb->list, &dcb->srb_waiting_list);
 }
 
 
-/*
- * srb_waiting_append - Append an srb to the tail of the waiting list
- * stored in the dcb.
- */
-static inline
-void srb_waiting_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
+static void srb_waiting_append(struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_append: srb %p cmd %li\n", srb, srb->cmd->pid);
         list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
 
-/*
- * srb_going_append - Append an srb to the tail of the going list
- * stored in the dcb.
- */
-static inline
-void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
+static void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_going_append: srb %p\n", srb);
         list_add_tail(&srb->list, &dcb->srb_going_list);
 }
 
 
-
-/*
- * srb_going_remove - Remove an srb from the going list stored in the
- * dcb.
- */
-static
-void srb_going_remove(struct DeviceCtlBlk *dcb,
-		      struct ScsiReqBlk *srb)
+static void srb_going_remove(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
@@ -998,13 +861,8 @@
 }
 
 
-/*
- * srb_waiting_remove - Remove an srb from the waiting list stored in the
- * dcb.
- */
-static
-void srb_waiting_remove(struct DeviceCtlBlk *dcb,
-			struct ScsiReqBlk *srb)
+static void srb_waiting_remove(struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
@@ -1018,37 +876,25 @@
 }
 
 
-/*
- * srb_going_to_waiting_move - Remove an srb from the going list in
- * the dcb and insert it at the head of the waiting list in the dcb.
- */
-static
-void srb_going_to_waiting_move(struct DeviceCtlBlk *dcb,
-			       struct ScsiReqBlk *srb)
+static void srb_going_to_waiting_move(struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_going_waiting_move: srb %p, pid = %li\n", srb, srb->cmd->pid);
+	dprintkdbg(DBG_0, "srb_going_to_waiting_move: srb %p, pid = %li\n", srb, srb->cmd->pid);
 	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
 
-/*
- * srb_waiting_to_going_move - Remove an srb from the waiting list in
- * the dcb and insert it at the head of the going list in the dcb.
- */
-static
-void srb_waiting_to_going_move(struct DeviceCtlBlk *dcb,
-			       struct ScsiReqBlk *srb)
+static void srb_waiting_to_going_move(struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
-	/* Remove from waiting list */
-	dprintkdbg(DBG_0, "srb_waiting_to_going: srb %p\n", srb);
+	dprintkdbg(DBG_0, "srb_waiting_to_going_move: srb %p\n", srb);
 	TRACEPRINTF("WtG *");
 	list_move(&srb->list, &dcb->srb_going_list);
 }
 
 
 /* Sets the timer to wake us up */
-static
-void waiting_set_timer(struct AdapterCtlBlk *acb, unsigned long to)
+static void waiting_set_timer(struct AdapterCtlBlk *acb, unsigned long to)
 {
 	if (timer_pending(&acb->waiting_timer))
 		return;
@@ -1065,8 +911,7 @@
 
 
 /* Send the next command from the waiting list to the bus */
-static
-void waiting_process_next(struct AdapterCtlBlk *acb)
+static void waiting_process_next(struct AdapterCtlBlk *acb)
 {
 	struct DeviceCtlBlk *start = NULL;
 	struct DeviceCtlBlk *pos;
@@ -1074,7 +919,7 @@
 	struct ScsiReqBlk *srb;
 	struct list_head *dcb_list_head = &acb->dcb_list;
 
-	if ((acb->active_dcb)
+	if (acb->active_dcb
 	    || (acb->acb_flag & (RESET_DETECT + RESET_DONE + RESET_DEV)))
 		return;
 
@@ -1135,7 +980,7 @@
 static void waiting_timeout(unsigned long ptr)
 {
 	unsigned long flags;
-	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *) ptr;
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)ptr;
 	dprintkdbg(DBG_KG, "Debug: Waiting queue woken up by timer.\n");
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 	waiting_process_next(acb);
@@ -1144,28 +989,17 @@
 
 
 /* Get the DCB for a given ID/LUN combination */
-static inline
-struct DeviceCtlBlk *find_dcb(struct AdapterCtlBlk *acb, u8 id, u8 lun)
+static struct DeviceCtlBlk *find_dcb(struct AdapterCtlBlk *acb, u8 id, u8 lun)
 {
 	return acb->children[id][lun];
 }
 
 
-/***********************************************************************
- * Function: static void send_srb (struct AdapterCtlBlk* acb, struct ScsiReqBlk* srb)
- *
- * Purpose: Send SCSI Request Block (srb) to adapter (acb)
- *
- *            dc395x_queue_command
- *            waiting_process_next
- *
- ***********************************************************************/
-static
-void send_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+/* Send SCSI Request Block (srb) to adapter (acb) */
+static void send_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
-	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *dcb = srb->dcb;
 
-	dcb = srb->dcb;
 	if (dcb->max_command <= list_size(&dcb->srb_going_list) ||
 	    acb->active_dcb ||
 	    (acb->acb_flag & (RESET_DETECT + RESET_DONE + RESET_DEV))) {
@@ -1174,27 +1008,18 @@
 		return;
 	}
 
-	if (!start_scsi(acb, dcb, srb)) {
+	if (!start_scsi(acb, dcb, srb))
 		srb_going_append(dcb, srb);
-	} else {
+	else {
 		srb_waiting_insert(dcb, srb);
 		waiting_set_timer(acb, HZ / 50);
 	}
 }
 
 
-/*
- *********************************************************************
- *
- * Function: static void build_srb (Scsi_Cmd *cmd, struct DeviceCtlBlk* dcb, struct ScsiReqBlk* srb)
- *
- *  Purpose: Prepare SRB for being sent to Device DCB w/ command *cmd
- *
- *********************************************************************
- */
-static
-void build_srb(Scsi_Cmnd * cmd, struct DeviceCtlBlk *dcb,
-	       struct ScsiReqBlk *srb)
+/* Prepare SRB for being sent to Device DCB w/ command *cmd */
+static void build_srb(Scsi_Cmnd *cmd, struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
 	int i, max;
 	struct SGentry *sgp;
@@ -1202,11 +1027,9 @@
 	u32 request_size;
 	int dir;
 
-	dprintkdbg(DBG_0, "build_srb..............\n");
-	/*memset (srb, 0, sizeof (struct ScsiReqBlk)); */
+	dprintkdbg(DBG_0, "build_srb...\n");
 	srb->dcb = dcb;
 	srb->cmd = cmd;
-	/* Find out about direction */
 	dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 
 	if (cmd->use_sg && dir != PCI_DMA_NONE) {
@@ -1215,7 +1038,7 @@
 		 * will probably go wrong. */
 		max = srb->sg_count =
 		    pci_map_sg(dcb->acb->dev,
-			       (struct scatterlist *) cmd->request_buffer,
+			       (struct scatterlist *)cmd->request_buffer,
 			       cmd->use_sg, dir);
 		sgp = srb->segment_x;
 		request_size = cmd->request_bufflen;
@@ -1226,7 +1049,7 @@
 		dprintkdbg(DBG_SGPARANOIA, 
 		       "Mapped %i Segments to %i\n", cmd->use_sg,
 		       srb->sg_count);
-		sl = (struct scatterlist *) cmd->request_buffer;
+		sl = (struct scatterlist *)cmd->request_buffer;
 
 		srb->virt_addr = page_address(sl->page);
 		for (i = 0; i < max; i++) {
@@ -1326,7 +1149,6 @@
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
 	srb->end_message = 0;
-	return;
 }
 
 
@@ -1350,8 +1172,7 @@
  *        and is expected to be held on return.
  *
  **/
-static int
-dc395x_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+static int dc395x_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
@@ -1364,14 +1185,6 @@
 		   cmd->device->lun,
 		   cmd->pid);
 
-#if debug_enabled(DBG_RECURSION)
-	if (dbg_in_driver++ > NORM_REC_LVL) {
-		dprintkl(KERN_DEBUG,
-			"%i queue_command () recursion? (pid=%li)\n",
-			dbg_in_driver, cmd->pid);
-	}
-#endif
-
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
 
@@ -1403,7 +1216,6 @@
 	cmd->scsi_done = done;
 	cmd->result = 0;
 
-	/* get a free SRB */
 	srb = srb_get_free(acb);
 	if (!srb)
 	{
@@ -1415,7 +1227,6 @@
 		return 1;
 	}
 
-	/* build srb for the command */
 	build_srb(cmd, dcb, srb);
 
 	if (!list_empty(&dcb->srb_waiting_list)) {
@@ -1427,10 +1238,6 @@
 		send_srb(acb, srb);
 	}
 	dprintkdbg(DBG_1, "... command (pid %li) queued successfully.\n", cmd->pid);
-
-#if debug_enabled(DBG_RECURSION)
-	dbg_in_driver--
-#endif
 	return 0;
 
 complete:
@@ -1440,28 +1247,16 @@
 	 * done when the commad is for things like non existent
 	 * devices.
 	 */
-#if debug_enabled(DBG_RECURSION)
-		dbg_in_driver--
-#endif
 	done(cmd);
 	return 0;
 }
 
 
-
-
 /*
- *********************************************************************
- *
- * Function   : dc395x_bios_param
- * Description: Return the disk geometry for the given SCSI device.
- *********************************************************************
+ * Return the disk geometry for the given SCSI device.
  */
-static
-int dc395x_bios_param(struct scsi_device *sdev,
-		      struct block_device *bdev,
-		      sector_t capacity,
-		      int *info)
+static int dc395x_bios_param(struct scsi_device *sdev,
+		struct block_device *bdev, sector_t capacity, int *info)
 {
 #ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
 	int heads, sectors, cylinders;
@@ -1469,7 +1264,7 @@
 	int size = capacity;
 
 	dprintkdbg(DBG_0, "dc395x_bios_param..............\n");
-	acb = (struct AdapterCtlBlk *) sdev->host->hostdata;
+	acb = (struct AdapterCtlBlk *)sdev->host->hostdata;
 	heads = 64;
 	sectors = 32;
 	cylinders = size / (heads * sectors);
@@ -1489,12 +1284,8 @@
 }
 
 
-/*
- * DC395x register dump
- */
-static
-void dump_register_info(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
-			struct ScsiReqBlk *srb)
+static void dump_register_info(struct AdapterCtlBlk *acb,
+		struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
 	u16 pstat;
 	struct pci_dev *dev = acb->dev;
@@ -1504,7 +1295,7 @@
 	if (!srb && dcb)
 		srb = dcb->active_srb;
 	if (srb) {
-		if (!(srb->cmd))
+		if (!srb->cmd)
 			dprintkl(KERN_INFO, "dump: SRB %p: cmd %p OOOPS!\n", srb,
 			       srb->cmd);
 		else
@@ -1560,8 +1351,6 @@
 	       DC395x_read8(acb, TRM_S1040_GEN_STATUS),
 	       DC395x_read8(acb, TRM_S1040_GEN_TIMER));
 	dprintkl(KERN_INFO, "dump: PCI Status %04x\n", pstat);
-
-
 }
 
 
@@ -1585,13 +1374,6 @@
 }
 
 
-/*
- ********************************************************************
- *
- *		DC395x_reset      scsi_reset_detect
- *
- ********************************************************************
- */
 static void reset_dev_param(struct AdapterCtlBlk *acb)
 {
 	struct DeviceCtlBlk *dcb;
@@ -1616,22 +1398,16 @@
 
 
 /*
- *********************************************************************
- * Function : int dc395x_eh_bus_reset(Scsi_Cmnd *cmd)
- * Purpose  : perform a hard reset on the SCSI bus
- * Inputs   : cmd - some command for this host (for fetching hooks)
- * Returns  : SUCCESS (0x2002) on success, else FAILED (0x2003).
- *********************************************************************
+ * perform a hard reset on the SCSI bus
+ * @cmd - some command for this host (for fetching hooks)
+ * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
  */
 static int dc395x_eh_bus_reset(Scsi_Cmnd * cmd)
 {
 	struct AdapterCtlBlk *acb;
-	/*u32         acb_flags=0; */
 
 	dprintkl(KERN_INFO, "reset requested!\n");
-	acb = (struct AdapterCtlBlk *) cmd->device->host->hostdata;
-	/* mid level guarantees no recursion */
-	/*DC395x_ACB_LOCK(acb,acb_flags); */
+	acb = (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1664,33 +1440,27 @@
 
 	reset_dev_param(acb);
 	doing_srb_done(acb, DID_RESET, cmd, 0);
-
 	acb->active_dcb = NULL;
-
 	acb->acb_flag = 0;	/* RESET_DETECT, RESET_DONE ,RESET_DEV */
 	waiting_process_next(acb);
 
-	/*DC395x_ACB_LOCK(acb,acb_flags); */
 	return SUCCESS;
 }
 
 
 /*
- *********************************************************************
- * Function : int dc395x_eh_abort(Scsi_Cmnd *cmd)
- * Purpose  : abort an errant SCSI command
- * Inputs   : cmd - command to be aborted
- * Returns  : SUCCESS (0x2002) on success, else FAILED (0x2003).
- *********************************************************************
+ * abort an errant SCSI command
+ * @cmd - command to be aborted
+ * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
  */
-static int dc395x_eh_abort(Scsi_Cmnd * cmd)
+static int dc395x_eh_abort(Scsi_Cmnd *cmd)
 {
 	/*
 	 * Look into our command queues: If it has not been sent already,
 	 * we remove it and return success. Otherwise fail.
 	 */
 	struct AdapterCtlBlk *acb =
-	    (struct AdapterCtlBlk *) cmd->device->host->hostdata;
+	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
 
@@ -1729,8 +1499,7 @@
 
 
 /* SDTR */
-static
-void build_sdtr(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+static void build_sdtr(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
 	u8 *ptr = srb->msgout_buf + srb->msg_count;
@@ -1758,15 +1527,12 @@
 }
 
 
-/* SDTR */
-static
-void build_wdtr(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+/* WDTR */
+static void build_wdtr(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	u8 wide =
-	    ((dcb->dev_mode & NTC_DO_WIDE_NEGO) & (acb->
-						   config & HCC_WIDE_CARD))
-	    ? 1 : 0;
+	u8 wide = ((dcb->dev_mode & NTC_DO_WIDE_NEGO) &
+		   (acb->config & HCC_WIDE_CARD)) ? 1 : 0;
 	u8 *ptr = srb->msgout_buf + srb->msg_count;
 	if (srb->msg_count > 1) {
 		dprintkl(KERN_INFO,
@@ -1809,7 +1575,7 @@
 void selection_timeout_missed(unsigned long ptr)
 {
 	unsigned long flags;
-	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *) ptr;
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)ptr;
 	struct ScsiReqBlk *srb;
 	dprintkl(KERN_DEBUG, "Chip forgot to produce SelTO IRQ!\n");
 	if (!acb->active_dcb || !acb->active_dcb->active_srb) {
@@ -1825,14 +1591,8 @@
 #endif
 
 
-/*
- * scsiio
- *		DC395x_DoWaitingSRB    srb_done 
- *		send_srb         request_sense
- */
-static
-u8 start_scsi(struct AdapterCtlBlk * acb, struct DeviceCtlBlk * dcb,
-	      struct ScsiReqBlk * srb)
+static u8 start_scsi(struct AdapterCtlBlk * acb, struct DeviceCtlBlk * dcb,
+		struct ScsiReqBlk * srb)
 {
 	u16 s_stat2, return_code;
 	u8 s_stat, scsicommand, i, identify_message;
@@ -1939,9 +1699,7 @@
 		}
 		srb->msg_count = 0;
 	}
-	/* 
-	 ** Send identify message   
-	 */
+	/* Send identify message */
 	DC395x_write8(acb, TRM_S1040_SCSI_FIFO, identify_message);
 
 	scsicommand = SCMD_SEL_ATN;
@@ -1967,9 +1725,7 @@
 				       DO_HWRESELECT);
 			return 1;
 		}
-		/* 
-		 ** Send Tag id
-		 */
+		/* Send Tag id */
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_SIMPLE_QTAG);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, tag_number);
 		dcb->tag_mask |= tag_mask;
@@ -1981,9 +1737,7 @@
 	}
 #endif
 /*polling:*/
-	/*
-	 *          Send CDB ..command block .........                     
-	 */
+	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, 
 	       "StartSCSI (pid %li) %02x (%i-%i): Tag %i\n",
 	       srb->cmd->pid, srb->cmd->cmnd[0],
@@ -1998,7 +1752,7 @@
 			      sizeof(srb->cmd->sense_buffer));
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
 	} else {
-		ptr = (u8 *) srb->cmd->cmnd;
+		ptr = (u8 *)srb->cmd->cmnd;
 		for (i = 0; i < srb->cmd->cmd_len; i++)
 			DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
 	}
@@ -2013,8 +1767,8 @@
 		 */
 		dprintkdbg(DBG_0, "Debug: StartSCSI failed (busy) for pid %li(%02i-%i)!\n",
 			srb->cmd->pid, dcb->target_id, dcb->target_lun);
-		/*clear_fifo (acb, "Start2"); */
-		/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALATCH); */
+		/*clear_fifo(acb, "Start2"); */
+		/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALATCH); */
 		srb->state = SRB_READY;
 		free_tag(dcb, srb);
 		srb->msg_count = 0;
@@ -2032,9 +1786,7 @@
 		/* it's important for atn stop */
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 			       DO_DATALATCH | DO_HWRESELECT);
-		/*
-		 ** SCSI command
-		 */
+		/* SCSI command */
 		TRACEPRINTF("%02x *", scsicommand);
 		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, scsicommand);
 	}
@@ -2042,13 +1794,6 @@
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		init_adapter
- ********************************************************************
- */
-
 /**
  * dc395x_handle_interrupt - Handle an interrupt that has been confirmed to
  *                           have been triggered for this card.
@@ -2056,15 +1801,16 @@
  * @acb:	 a pointer to the adpter control block
  * @scsi_status: the status return when we checked the card
  **/
-static void dc395x_handle_interrupt(struct AdapterCtlBlk *acb, u16 scsi_status)
+static void dc395x_handle_interrupt(struct AdapterCtlBlk *acb,
+		u16 scsi_status)
 {
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
 	u16 phase;
 	u8 scsi_intstatus;
 	unsigned long flags;
-	void (*dc395x_statev) (struct AdapterCtlBlk *, struct ScsiReqBlk *,
-			       u16 *);
+	void (*dc395x_statev)(struct AdapterCtlBlk *, struct ScsiReqBlk *, 
+			      u16 *);
 
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
@@ -2081,7 +1827,6 @@
 		monitor_next_irq--;
 	}
 #endif
-	/*DC395x_ACB_LOCK(acb,acb_flags); */
 	if (debug_enabled(DBG_KG)) {
 		if (scsi_intstatus & INT_SELTIMEOUT)
 		dprintkdbg(DBG_KG, "Sel Timeout IRQ\n");
@@ -2120,12 +1865,10 @@
 			dprintkdbg(DBG_0, "MsgOut Abort Device.....\n");
 			enable_msgout_abort(acb, srb);
 		}
-		/*
-		 ************************************************************
-		 * software sequential machine
-		 ************************************************************
-		 */
-		phase = (u16) srb->scsi_phase;
+
+		/* software sequential machine */
+		phase = (u16)srb->scsi_phase;
+
 		/* 
 		 * 62037 or 62137
 		 * call  dc395x_scsi_phase0[]... "phase entry"
@@ -2139,22 +1882,20 @@
 		/* nop0,		phase:5 PH_BUS_FREE .. initial phase */
 		/* msgout_phase0,	phase:6 */
 		/* msgin_phase0,	phase:7 */
-		dc395x_statev = (void *) dc395x_scsi_phase0[phase];
+		dc395x_statev = dc395x_scsi_phase0[phase];
 		dc395x_statev(acb, srb, &scsi_status);
+
 		/* 
-		 *$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
-		 *
-		 *        if there were any exception occured
-		 *        scsi_status will be modify to bus free phase
-		 * new scsi_status transfer out from ... previous dc395x_statev
-		 *
-		 *$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
+		 * if there were any exception occured scsi_status
+		 * will be modify to bus free phase new scsi_status
+		 * transfer out from ... previous dc395x_statev
 		 */
 		srb->scsi_phase = scsi_status & PHASEMASK;
-		phase = (u16) scsi_status & PHASEMASK;
+		phase = (u16)scsi_status & PHASEMASK;
+
 		/* 
-		 * call  dc395x_scsi_phase1[]... "phase entry"
-		 * handle every phase do transfer
+		 * call  dc395x_scsi_phase1[]... "phase entry" handle
+		 * every phase to do transfer
 		 */
 		/* data_out_phase1,	phase:0 */
 		/* data_in_phase1,	phase:1 */
@@ -2164,29 +1905,23 @@
 		/* nop1,		phase:5 PH_BUS_FREE .. initial phase */
 		/* msgout_phase1,	phase:6 */
 		/* msgin_phase1,	phase:7 */
-		dc395x_statev = (void *) dc395x_scsi_phase1[phase];
+		dc395x_statev = dc395x_scsi_phase1[phase];
 		dc395x_statev(acb, srb, &scsi_status);
 	}
       out_unlock:
 	DC395x_UNLOCK_IO(acb->scsi_host, flags);
-	return;
 }
 
 
-static
-irqreturn_t dc395x_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t dc395x_interrupt(int irq, void *dev_id,
+		struct pt_regs *regs)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)dev_id;
 	u16 scsi_status;
 	u8 dma_status;
 	irqreturn_t handled = IRQ_NONE;
 
-	dprintkdbg(DBG_0, "dc395x_interrupt..............\n");
-#if debug_enabled(DBG_RECURSION)
-        if (dbg_in_driver++ > NORM_REC_LVL) {
-		dprintkl(KERN_DEBUG, "%i interrupt recursion?\n", dbg_in_driver);
-	}
-#endif
+	dprintkdbg(DBG_0, "dc395x_interrupt...\n");
 
 	/*
 	 * Check for pending interupt
@@ -2216,54 +1951,31 @@
 		handled = IRQ_HANDLED;
 	}
 
-#if debug_enabled(DBG_RECURSION)
-	dbg_in_driver--
-#endif
 	return handled;
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	msgout_phase0: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *			           if phase =6
- ********************************************************************
- */
-static
-void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		    u16 * pscsi_status)
+static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgout_phase0.....\n");
-	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT)) {
+	dprintkdbg(DBG_0, "msgout_phase0...\n");
+	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
-	}
+
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	srb->state &= ~SRB_MSGOUT;
 	TRACEPRINTF("MOP0 *");
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	msgout_phase1: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *					if phase =6	    
- ********************************************************************
- */
-static
-void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		    u16 * pscsi_status)
+static void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	u16 i;
 	u8 *ptr;
-	struct DeviceCtlBlk *dcb;
 
-	dprintkdbg(DBG_0, "msgout_phase1..............\n");
+	dprintkdbg(DBG_0, "msgout_phase1...\n");
 	TRACEPRINTF("MOP1*");
-	dcb = acb->active_dcb;
 	clear_fifo(acb, "MOP1");
 	if (!(srb->state & SRB_MSGOUT)) {
 		srb->state |= SRB_MSGOUT;
@@ -2279,72 +1991,49 @@
 		TRACEOUT(" %s\n", srb->debugtrace);
 		return;
 	}
-	ptr = (u8 *) srb->msgout_buf;
+	ptr = (u8 *)srb->msgout_buf;
 	TRACEPRINTF("(*");
-	/*dprintkl(KERN_DEBUG, "Send msg: "); print_msg (ptr, srb->msg_count); */
-	/*dprintkl(KERN_DEBUG, "MsgOut: "); */
 	for (i = 0; i < srb->msg_count; i++) {
 		TRACEPRINTF("%02x *", *ptr);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
 	}
 	TRACEPRINTF(")*");
 	srb->msg_count = 0;
-	/*printk("\n"); */
 	if (/*(dcb->flag & ABORT_DEV_) && */
 	    (srb->msgout_buf[0] == MSG_ABORT))
 		srb->state = SRB_ABORT_SENT;
 
 	/*1.25 */
 	/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_DATALATCH); *//* it's important for atn stop */
-	/*
-	 ** SCSI command 
-	 */
+	/* SCSI command */
 	/*TRACEPRINTF (".*"); */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	command_phase0: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *				if phase =2 
- ********************************************************************
- */
-static
-void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		    u16 * pscsi_status)
+static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	TRACEPRINTF("COP0 *");
 	/*1.25 */
-	/*clear_fifo (acb, COP0); */
+	/*clear_fifo(acb, COP0); */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	command_phase1: one of dc395x_scsi_phase1[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- *				if phase =2    	 
- ********************************************************************
- */
-static
-void command_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		    u16 * pscsi_status)
+static void command_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	struct DeviceCtlBlk *dcb;
 	u8 *ptr;
 	u16 i;
 
-	dprintkdbg(DBG_0, "command_phase1..............\n");
+	dprintkdbg(DBG_0, "command_phase1...\n");
 	TRACEPRINTF("COP1*");
 	clear_fifo(acb, "COP1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
 	if (!(srb->flag & AUTO_REQSENSE)) {
-		ptr = (u8 *) srb->cmd->cmnd;
+		ptr = (u8 *)srb->cmd->cmnd;
 		for (i = 0; i < srb->cmd->cmd_len; i++) {
 			DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr);
 			ptr++;
@@ -2399,7 +2088,7 @@
 	struct scatterlist *sg;
 	int segment = cmd->use_sg;
 
-	dprintkdbg(DBG_KG, "Update SG: Total %i, Left %i\n",
+	dprintkdbg(DBG_KG, "Update SG: Total %i, Left %i\n", 
 	       srb->total_xfer_length, left);
 	check_sg_list(srb);
 	psge = srb->segment_x + srb->sg_index;
@@ -2440,11 +2129,11 @@
 		return;
 	}
 	/* We have to walk the scatterlist to find it */
-	sg = (struct scatterlist *) cmd->request_buffer;
+	sg = (struct scatterlist *)cmd->request_buffer;
 	while (segment--) {
 		/*printk("(%08x)%p ", BUS_ADDR(*sg), PAGE_ADDRESS(sg)); */
 		unsigned long mask =
-		    ~((unsigned long) sg->length - 1) & PAGE_MASK;
+		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
 		if ((BUS_ADDR(*sg) & mask) == (psge->address & mask)) {
 			srb->virt_addr = (PAGE_ADDRESS(sg)
 					   + psge->address -
@@ -2467,27 +2156,22 @@
  * Should probably also be called from other places
  * Best might be to call it in DataXXPhase0, if new phase will differ 
  */
-static
-void cleanup_after_transfer(struct AdapterCtlBlk *acb,
-			    struct ScsiReqBlk *srb)
+static void cleanup_after_transfer(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb)
 {
 	TRACEPRINTF(" Cln*");
 	/*DC395x_write8 (TRM_S1040_DMA_STATUS, FORCEDMACOMP); */
 	if (DC395x_read16(acb, TRM_S1040_DMA_COMMAND) & 0x0001) {	/* read */
 		if (!(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x40))
 			clear_fifo(acb, "ClnIn");
-
 		if (!(DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT) & 0x80))
 			DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
 	} else {		/* write */
 		if (!(DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT) & 0x80))
 			DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
-
 		if (!(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x40))
 			clear_fifo(acb, "ClnOut");
-
 	}
-	/*1.25 */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
 
@@ -2497,26 +2181,17 @@
  * Seems to be needed for unknown reasons; could be a hardware bug :-(
  */
 #define DC395x_LASTPIO 4
-/*
- ********************************************************************
- * scsiio
- *	data_out_phase0: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *				if phase =0 
- ********************************************************************
- */
-static
-void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		     u16 * pscsi_status)
+
+
+static void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-	u16 scsi_status;
-	u32 d_left_counter = 0;
 	struct DeviceCtlBlk *dcb = srb->dcb;
+	u16 scsi_status = *pscsi_status;
+	u32 d_left_counter = 0;
 
-	dprintkdbg(DBG_0, "data_out_phase0.....\n");
+	dprintkdbg(DBG_0, "data_out_phase0...\n");
 	TRACEPRINTF("DOP0*");
-	dcb = srb->dcb;
-	scsi_status = *pscsi_status;
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2554,8 +2229,8 @@
 			 * if there was some data left in SCSI FIFO
 			 */
 			d_left_counter =
-			    (u32) (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) &
-				   0x1F);
+			    (u32)(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) &
+				  0x1F);
 			if (dcb->sync_period & WIDE_SYNC)
 				d_left_counter <<= 1;
 
@@ -2595,7 +2270,7 @@
 		TRACEPRINTF("%06x *", d_left_counter);
 
 		/* Is this a good idea? */
-		/*clear_fifo (acb, "DOP1"); */
+		/*clear_fifo(acb, "DOP1"); */
 		/* KG: What is this supposed to be useful for? WIDE padding stuff? */
 		if (d_left_counter == 1 && dcb->sync_period & WIDE_SYNC
 		    && srb->cmd->request_bufflen % 2) {
@@ -2613,8 +2288,8 @@
 		 * KG: This is nonsense: We have been WRITING data to the bus
 		 * If the SCSI engine has no bytes left, how should the DMA engine?
 		 */
-		if ((d_left_counter ==
-		     0) /*|| (scsi_status & SCSIXFERCNT_2_ZERO) ) */ ) {
+		if (d_left_counter == 0
+		    /*|| (scsi_status & SCSIXFERCNT_2_ZERO)*/) {
 			/*
 			 * int ctr = 6000000; u8 TempDMAstatus;
 			 * do
@@ -2661,8 +2336,8 @@
 			srb->cmd->pid,
 			DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f);
 #endif
-	/*clear_fifo (acb, "DOP0"); */
-	/*DC395x_write8 (TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
+	/*clear_fifo(acb, "DOP0"); */
+	/*DC395x_write8(TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
 #if 1
 	if ((*pscsi_status & PHASEMASK) != PH_DATA_OUT) {
 		/*dprintkl(KERN_DEBUG, "Debug: Clean up after Data Out ...\n"); */
@@ -2673,52 +2348,28 @@
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	data_out_phase1: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *				if phase =0    
- *		62037
- ********************************************************************
- */
-static
-void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		     u16 * pscsi_status)
+static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-
-	dprintkdbg(DBG_0, "data_out_phase1.....\n");
+	dprintkdbg(DBG_0, "data_out_phase1...\n");
 	/*1.25 */
 	TRACEPRINTF("DOP1*");
 	clear_fifo(acb, "DOP1");
-	/*
-	 ** do prepare befor transfer when data out phase
-	 */
+	/* do prepare befor transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
 	TRACEPRINTF(".*");
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	data_in_phase0: one of dc395x_scsi_phase1[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- *				if phase =1  
- ********************************************************************
- */
-static
-void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		    u16 * pscsi_status)
+
+static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-	u16 scsi_status;
+	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
-	/*struct DeviceCtlBlk*   dcb = srb->dcb; */
-	/*u8 bval; */
 
-	dprintkdbg(DBG_0, "data_in_phase0..............\n");
+	dprintkdbg(DBG_0, "data_in_phase0...\n");
 	TRACEPRINTF("DIP0*");
-	scsi_status = *pscsi_status;
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2859,8 +2510,8 @@
 			 * if there was some data left in SCSI FIFO
 			 */
 			d_left_counter =
-			    (u32) (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) &
-				   0x1F);
+			    (u32)(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) &
+				  0x1F);
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				d_left_counter <<= 1;
 			/*
@@ -2882,7 +2533,7 @@
 #endif
 
 		/* KG: This should not be needed any more! */
-		if ((d_left_counter == 0)
+		if (d_left_counter == 0
 		    || (scsi_status & SCSIXFERCNT_2_ZERO)) {
 #if 0
 			int ctr = 6000000;
@@ -2929,7 +2580,7 @@
 		       "DIP0(%li): %i bytes in SCSI FIFO (stat %04x) (left %08x)!!\n",
 		       srb->cmd->pid, bval & 0x1f, scsi_status,
 		       d_left_counter);
-		if ((d_left_counter == 0)
+		if (d_left_counter == 0
 		    || (scsi_status & SCSIXFERCNT_2_ZERO)) {
 			dprintkl(KERN_DEBUG, "Clear FIFO!\n");
 			clear_fifo(acb, "DIP0");
@@ -2937,52 +2588,32 @@
 	}
 #endif
 	/*DC395x_write8 (TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
-
-	/*clear_fifo (acb, "DIP0"); */
-	/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
+	/*clear_fifo(acb, "DIP0"); */
+	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
 	TRACEPRINTF(".*");
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	data_in_phase1: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *				if phase =1 
- ********************************************************************
- */
-static
-void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		    u16 * pscsi_status)
+static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_in_phase1.....\n");
+	dprintkdbg(DBG_0, "data_in_phase1...\n");
 	/* FIFO should be cleared, if previous phase was not DataPhase */
-	/*clear_fifo (acb, "DIP1"); */
+	/*clear_fifo(acb, "DIP1"); */
 	/* Allow data in! */
-	/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
+	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
 	TRACEPRINTF("DIP1:*");
-	/*
-	 ** do prepare before transfer when data in phase
-	 */
+	/* do prepare before transfer when data in phase */
 	data_io_transfer(acb, srb, XFERDATAIN);
 	TRACEPRINTF(".*");
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		data_out_phase1
- *		data_in_phase1
- ********************************************************************
- */
-static
-void data_io_transfer(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		      u16 io_dir)
+static void data_io_transfer(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb, u16 io_dir)
 {
+	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 bval;
-	struct DeviceCtlBlk *dcb;
 
 	dprintkdbg(DBG_0, "DataIO_transfer %c (pid %li): len = %i, SG: %i/%i\n",
 	       ((io_dir & DMACMD_DIR) ? 'r' : 'w'), srb->cmd->pid,
@@ -2990,10 +2621,8 @@
 	       srb->sg_count);
 	TRACEPRINTF("%05x(%i/%i)*", srb->total_xfer_length,
 		    srb->sg_index, srb->sg_count);
-	dcb = srb->dcb;
-	if (srb == acb->tmp_srb) {
+	if (srb == acb->tmp_srb)
 		dprintkl(KERN_ERR, "Using tmp_srb in DataPhase!\n");
-	}
 	if (srb->sg_index < srb->sg_count) {
 		if (srb->total_xfer_length > DC395x_LASTPIO) {
 			u8 dma_status = DC395x_read8(acb, TRM_S1040_DMA_STATUS);
@@ -3007,7 +2636,7 @@
 				DC395x_write8(acb, TRM_S1040_DMA_CONTROL,
 					      CLRXFIFO);
 			}
-			/*clear_fifo (acb, "IO"); */
+			/* clear_fifo(acb, "IO"); */
 			/* 
 			 * load what physical address of Scatter/Gather list table want to be
 			 * transfer 
@@ -3051,7 +2680,7 @@
 		}
 #if DC395x_LASTPIO
 		else if (srb->total_xfer_length > 0) {	/* The last four bytes: Do PIO */
-			/*clear_fifo (acb, "IO"); */
+			/* clear_fifo(acb, "IO"); */
 			/* 
 			 * load what physical address of Scatter/Gather list table want to be
 			 * transfer 
@@ -3111,7 +2740,6 @@
 		}
 #endif				/* DC395x_LASTPIO */
 		else {		/* xfer pad */
-
 			u8 data = 0, data2 = 0;
 			if (srb->sg_count) {
 				srb->adapter_status = H_OVER_UNDER_RUN;
@@ -3159,31 +2787,18 @@
 			}
 			srb->state |= SRB_XFERPAD;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-			/*
-			 * SCSI command 
-			 */
+			/* SCSI command */
 			bval =
 			    (io_dir & DMACMD_DIR) ? SCMD_FIFO_IN :
 			    SCMD_FIFO_OUT;
 			DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, bval);
 		}
 	}
-	/*monitor_next_irq = 2; */
-	/*printk(" done\n"); */
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	status_phase0: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *				if phase =3  
- ********************************************************************
- */
-static
-void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		   u16 * pscsi_status)
+static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "StatusPhase0 (pid %li)\n", srb->cmd->pid);
 	TRACEPRINTF("STP0 *");
@@ -3192,26 +2807,15 @@
 	srb->state = SRB_COMPLETED;
 	*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 	/*1.25 */
-	/*clear_fifo (acb, "STP0"); */
+	/*clear_fifo(acb, "STP0"); */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-	/*
-	 ** SCSI command 
-	 */
+	/* SCSI command */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_MSGACCEPT);
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	status_phase1: one of dc395x_scsi_phase1[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- *				if phase =3 
- ********************************************************************
- */
-static
-void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		   u16 * pscsi_status)
+static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "StatusPhase1 (pid=%li)\n", srb->cmd->pid);
 	TRACEPRINTF("STP1 *");
@@ -3220,13 +2824,10 @@
 
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-	/*
-	 * SCSI command 
-	 */
+	/* SCSI command */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
 }
 
-/* Message handling */
 
 #if 0
 /* Print received message */
@@ -3240,6 +2841,7 @@
 }
 #endif
 
+
 /* Check if the message is complete */
 static inline u8 msgin_completed(u8 * msgbuf, u32 len)
 {
@@ -3260,8 +2862,8 @@
 
 
 /* reject_msg */
-static inline
-void msgin_reject(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+static inline void msgin_reject(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb)
 {
 	srb->msgout_buf[0] = MESSAGE_REJECT;
 	srb->msg_count = 1;
@@ -3276,9 +2878,8 @@
 
 
 /* abort command */
-static inline
-void enable_msgout_abort(struct AdapterCtlBlk *acb,
-			 struct ScsiReqBlk *srb)
+static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb)
 {
 	srb->msgout_buf[0] = ABORT;
 	srb->msg_count = 1;
@@ -3293,14 +2894,11 @@
 }
 
 
-static
-struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
-			      struct DeviceCtlBlk *dcb,
-			      u8 tag)
+static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
+		struct DeviceCtlBlk *dcb, u8 tag)
 {
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
-	        
 
 	dprintkdbg(DBG_0, "QTag Msg (SRB %p): %i\n", srb, tag);
 	if (!(dcb->tag_mask & (1 << tag)))
@@ -3363,9 +2961,8 @@
 }
 
 
-/* Reprogram registers */
-static inline void
-reprogram_regs(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+static inline void reprogram_regs(struct AdapterCtlBlk *acb,
+		struct DeviceCtlBlk *dcb)
 {
 	DC395x_write8(acb, TRM_S1040_SCSI_TARGETID, dcb->target_id);
 	DC395x_write8(acb, TRM_S1040_SCSI_SYNC, dcb->sync_period);
@@ -3375,10 +2972,10 @@
 
 
 /* set async transfer mode */
-static
-void msgin_set_async(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+static void msgin_set_async(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
 	struct DeviceCtlBlk *dcb = srb->dcb;
+
 	dprintkl(KERN_DEBUG, "Target %02i: No sync transfers\n", dcb->target_id);
 	TRACEPRINTF("!S *");
 	dcb->sync_mode &= ~(SYNC_NEGO_ENABLE);
@@ -3398,14 +2995,11 @@
 
 
 /* set sync transfer mode */
-static
-void msgin_set_sync(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+static void msgin_set_sync(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
+	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 bval;
 	int fact;
-	struct DeviceCtlBlk *dcb = srb->dcb;
-	/*u8 oldsyncperiod = dcb->sync_period; */
-	/*u8 oldsyncoffset = dcb->sync_offset; */
 
 	dprintkdbg(DBG_1, "Target %02i: Sync: %ins (%02i.%01i MHz) Offset %i\n",
 	       dcb->target_id, srb->msgin_buf[3] << 2,
@@ -3475,11 +3069,11 @@
 }
 
 
-static inline
-void msgin_set_nowide(struct AdapterCtlBlk *acb,
-		      struct ScsiReqBlk *srb)
+static inline void msgin_set_nowide(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb)
 {
 	struct DeviceCtlBlk *dcb = srb->dcb;
+
 	dprintkdbg(DBG_KG, "WDTR got rejected from target %02i\n",
 	       dcb->target_id);
 	TRACEPRINTF("!W *");
@@ -3496,12 +3090,12 @@
 	}
 }
 
-static
-void msgin_set_wide(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+static void msgin_set_wide(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 wide = (dcb->dev_mode & NTC_DO_WIDE_NEGO
 		   && acb->config & HCC_WIDE_CARD) ? 1 : 0;
+
 	if (srb->msgin_buf[3] > wide)
 		srb->msgin_buf[3] = wide;
 	/* Completed */
@@ -3537,12 +3131,6 @@
 
 
 /*
- ********************************************************************
- * scsiio
- *	msgin_phase0: one of dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *				if phase =7   
- *
  * extended message codes:
  *
  *	code	description
@@ -3553,24 +3141,18 @@
  *	03h	WIDE DATA TRANSFER REQUEST
  *   04h - 7Fh	Reserved
  *   80h - FFh	Vendor specific
- *  
- ********************************************************************
  */
-static
-void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		  u16 * pscsi_status)
+static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *dcb = acb->active_dcb;
 
-	dprintkdbg(DBG_0, "msgin_phase0..............\n");
+	dprintkdbg(DBG_0, "msgin_phase0...\n");
 	TRACEPRINTF("MIP0*");
-	dcb = acb->active_dcb;
 
 	srb->msgin_buf[acb->msg_len++] = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	if (msgin_completed(srb->msgin_buf, acb->msg_len)) {
 		TRACEPRINTF("(%02x)*", srb->msgin_buf[0]);
-		/*dprintkl(KERN_INFO, "MsgIn:"); */
-		/*print_msg (srb->msgin_buf, acb->msg_len); */
 
 		/* Now eval the msg */
 		switch (srb->msgin_buf[0]) {
@@ -3613,7 +3195,9 @@
 				break;
 			}
 			/* WDTR */
-			if (srb->msgin_buf[1] == 2 && srb->msgin_buf[2] == EXTENDED_WDTR && srb->msgin_buf[3] <= 2) {	/* sanity check ... */
+			if (srb->msgin_buf[1] == 2
+			    && srb->msgin_buf[2] == EXTENDED_WDTR
+			    && srb->msgin_buf[3] <= 2) { /* sanity check ... */
 				msgin_set_wide(acb, srb);
 				break;
 			}
@@ -3688,19 +3272,10 @@
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	msgin_phase1: one of dc395x_scsi_phase1[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- *				if phase =7	   
- ********************************************************************
- */
-static
-void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-		  u16 * pscsi_status)
+static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgin_phase1..............\n");
+	dprintkdbg(DBG_0, "msgin_phase1...\n");
 	TRACEPRINTF("MIP1 *");
 	clear_fifo(acb, "MIP1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
@@ -3709,61 +3284,30 @@
 		srb->state |= SRB_MSGIN;
 	}
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-	/*
-	 * SCSI command 
-	 */
+	/* SCSI command */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_IN);
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	nop0: one of dc395x_scsi_phase1[] ,dc395x_scsi_phase0[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *	 dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- *				if phase =4 ..PH_BUS_FREE
- ********************************************************************
- */
-static
-void nop0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-	  u16 * pscsi_status)
+static void nop0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	/*TRACEPRINTF("NOP0 *"); */
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *	nop1: one of dc395x_scsi_phase0[] ,dc395x_scsi_phase1[] vectors
- *	 dc395x_statev = (void *)dc395x_scsi_phase0[phase]
- *	 dc395x_statev = (void *)dc395x_scsi_phase1[phase]
- *				if phase =5
- ********************************************************************
- */
-static
-void nop1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
-	  u16 * pscsi_status)
+static void nop1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
+		u16 *pscsi_status)
 {
 	/*TRACEPRINTF("NOP1 *"); */
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		msgin_phase0
- ********************************************************************
- */
-static
-void set_xfer_rate(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+static void set_xfer_rate(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
 {
 	struct DeviceCtlBlk *i;
 
-	/*
-	 * set all lun device's  period , offset
-	 */
+	/* set all lun device's  period, offset */
 	if (dcb->identify_msg & 0x07)
 		return;
 
@@ -3782,19 +3326,11 @@
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		dc395x_interrupt
- ********************************************************************
- */
 static void disconnect(struct AdapterCtlBlk *acb)
 {
-	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *dcb = acb->active_dcb;
 	struct ScsiReqBlk *srb;
 
-	dprintkdbg(DBG_0, "Disconnect (pid=%li)\n", acb->active_dcb->active_srb->cmd->pid);
-	dcb = acb->active_dcb;
 	if (!dcb) {
 		dprintkl(KERN_ERR, "Disc: Exception Disconnect dcb=NULL !!\n ");
 		udelay(500);
@@ -3808,6 +3344,7 @@
 	}
 	srb = dcb->active_srb;
 	acb->active_dcb = NULL;
+	dprintkdbg(DBG_0, "Disconnect (pid=%li)\n", srb->cmd->pid);
 	TRACEPRINTF("DISC *");
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
@@ -3819,7 +3356,6 @@
 		srb->state = 0;
 		waiting_process_next(acb);
 	} else if (srb->state & SRB_ABORT_SENT) {
-		/*Scsi_Cmnd* cmd = srb->cmd; */
 		dcb->flag &= ~ABORT_DEV_;
 		acb->scsi_host->last_reset = jiffies + HZ / 2 + 1;
 		dprintkl(KERN_ERR, "Disc: SRB_ABORT_SENT!\n");
@@ -3893,31 +3429,23 @@
 			srb_done(acb, dcb, srb);
 		}
 	}
-	return;
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		reselect
- ********************************************************************
- */
 static void reselect(struct AdapterCtlBlk *acb)
 {
-	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *dcb = acb->active_dcb;
 	struct ScsiReqBlk *srb = NULL;
 	u16 rsel_tar_lun_id;
 	u8 id, lun;
 	u8 arblostflag = 0;
 
-	dprintkdbg(DBG_0, "reselect..............\n");
+	dprintkdbg(DBG_0, "reselect...\n");
 
 	clear_fifo(acb, "Resel");
 	/*DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALATCH); */
 	/* Read Reselected Target ID and LUN */
 	rsel_tar_lun_id = DC395x_read16(acb, TRM_S1040_SCSI_TARGETID);
-	dcb = acb->active_dcb;
 	if (dcb) {		/* Arbitration lost but Reselection win */
 		srb = dcb->active_srb;
 		if (!srb) {
@@ -3926,7 +3454,7 @@
 			return;
 		}
 		/* Why the if ? */
-		if (!(acb->scan_devices)) {
+		if (!acb->scan_devices) {
 			dprintkdbg(DBG_KG,
 			       "Arb lost but Resel win pid %li (%02i-%i) Rsel %04x Stat %04x\n",
 			       srb->cmd->pid, dcb->target_id,
@@ -3965,7 +3493,7 @@
 		dprintkl(KERN_DEBUG, "Reselection in spite of forbidden disconnection? (%02i-%i)\n",
 		       dcb->target_id, dcb->target_lun);
 
-	if ((dcb->sync_mode & EN_TAG_QUEUEING) /*&& !arblostflag */ ) {
+	if (dcb->sync_mode & EN_TAG_QUEUEING /*&& !arblostflag */) {
 		struct ScsiReqBlk *oldSRB = srb;
 		srb = acb->tmp_srb;
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
@@ -4003,11 +3531,8 @@
 		/*if (arblostflag) TRACEOUT (" %s\n", srb->debugtrace); */
 	}
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
-	/* 
-	 ***********************************************
-	 ** Program HA ID, target ID, period and offset
-	 ***********************************************
-	 */
+
+	/* Program HA ID, target ID, period and offset */
 	DC395x_write8(acb, TRM_S1040_SCSI_HOSTID, acb->scsi_host->this_id);	/* host   ID */
 	DC395x_write8(acb, TRM_S1040_SCSI_TARGETID, dcb->target_id);		/* target ID */
 	DC395x_write8(acb, TRM_S1040_SCSI_OFFSET, dcb->sync_offset);		/* offset    */
@@ -4018,10 +3543,6 @@
 }
 
 
-
-
-
-
 static inline u8 tagq_blacklist(char *name)
 {
 #ifndef DC395x_NO_TAGQ
@@ -4038,8 +3559,7 @@
 }
 
 
-static
-void disc_tagq_set(struct DeviceCtlBlk *dcb, struct ScsiInqData *ptr)
+static void disc_tagq_set(struct DeviceCtlBlk *dcb, struct ScsiInqData *ptr)
 {
 	/* Check for SCSI format (ANSI and Response data format) */
 	if ((ptr->Vers & 0x07) >= 2 || (ptr->RDF & 0x0F) == 2) {
@@ -4048,7 +3568,7 @@
 		    /*(dcb->dev_mode & NTC_DO_DISCONNECT) */
 		    /* ((dcb->dev_type == TYPE_DISK) 
 		       || (dcb->dev_type == TYPE_MOD)) && */
-		    !tagq_blacklist(((char *) ptr) + 8)) {
+		    !tagq_blacklist(((char *)ptr) + 8)) {
 			if (dcb->max_command == 1)
 				dcb->max_command =
 				    dcb->acb->tag_max_num;
@@ -4060,9 +3580,8 @@
 }
 
 
-static
-void add_dev(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
-	     struct ScsiInqData *ptr)
+static void add_dev(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+		struct ScsiInqData *ptr)
 {
 	u8 bval1 = ptr->DevType & SCSI_DEVTYPE;
 	dcb->dev_type = bval1;
@@ -4071,17 +3590,11 @@
 }
 
 
-/* 
- ********************************************************************
- * unmap mapped pci regions from SRB
- ********************************************************************
- */
-static
-void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+/* unmap mapped pci regions from SRB */
+static void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
-	int dir;
 	Scsi_Cmnd *cmd = srb->cmd;
-	dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	int dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 	if (cmd->use_sg && dir != PCI_DMA_NONE) {
 		/* unmap DC395x SG list */
 		dprintkdbg(DBG_SGPARANOIA,
@@ -4096,7 +3609,7 @@
 		       cmd->use_sg, cmd->request_buffer);
 		/* unmap the sg segments */
 		pci_unmap_sg(acb->dev,
-			     (struct scatterlist *) cmd->request_buffer,
+			     (struct scatterlist *)cmd->request_buffer,
 			     cmd->use_sg, dir);
 	} else if (cmd->request_buffer && dir != PCI_DMA_NONE) {
 		dprintkdbg(DBG_SGPARANOIA, "Unmap buffer at %08x (%05x)\n",
@@ -4107,13 +3620,9 @@
 }
 
 
-/* 
- ********************************************************************
- * unmap mapped pci sense buffer from SRB
- ********************************************************************
- */
-static
-void pci_unmap_srb_sense(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+/* unmap mapped pci sense buffer from SRB */
+static void pci_unmap_srb_sense(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb)
 {
 	if (!(srb->flag & AUTO_REQSENSE))
 		return;
@@ -4133,31 +3642,24 @@
 
 
 /*
- ********************************************************************
- * scsiio
- *		disconnect
- *	Complete execution of a SCSI command
- *	Signal completion to the generic SCSI driver  
- ********************************************************************
+ * Complete execution of a SCSI command
+ * Signal completion to the generic SCSI driver  
  */
-static
-void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
-	      struct ScsiReqBlk *srb)
+static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
 	u8 tempcnt, status;
-	Scsi_Cmnd *cmd;
+	Scsi_Cmnd *cmd = srb->cmd;
 	struct ScsiInqData *ptr;
-	/*u32              drv_flags=0; */
 	int dir;
 
-	cmd = srb->cmd;
 	TRACEPRINTF("DONE *");
 
 	dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
-	ptr = (struct ScsiInqData *) (cmd->request_buffer);
+	ptr = (struct ScsiInqData *)(cmd->request_buffer);
 	if (cmd->use_sg)
 		ptr =
-		    (struct ScsiInqData *) CPU_ADDR(*(struct scatterlist *)
+		    (struct ScsiInqData *)CPU_ADDR(*(struct scatterlist *)
 						    ptr);
 	dprintkdbg(DBG_SGPARANOIA, 
 	       "SRBdone SG=%i (%i/%i), req_buf = %p, adr = %p\n",
@@ -4214,13 +3716,13 @@
 				     "Sense=%02x, ASC=%02x, ASCQ=%02x (%08x %08x) ",
 				     cmd->sense_buffer[2], cmd->sense_buffer[12],
 				     cmd->sense_buffer[13],
-				     *((unsigned int *) (cmd->sense_buffer + 3)),
-				     *((unsigned int *) (cmd->sense_buffer + 8)));
+				     *((unsigned int *)(cmd->sense_buffer + 3)),
+				     *((unsigned int *)(cmd->sense_buffer + 8)));
 			else
 				dprintkl(KERN_DEBUG,
 				     "Sense=%02x, No ASC/ASCQ (%08x) ",
 				     cmd->sense_buffer[2],
-				     *((unsigned int *) (cmd->sense_buffer + 3)));
+				     *((unsigned int *)(cmd->sense_buffer + 3)));
 		}
 
 		if (status == (CHECK_CONDITION << 1)) {
@@ -4229,8 +3731,8 @@
 		}
 		dprintkdbg(DBG_0, "AUTO_REQSENSE2..............\n");
 
-		if ((srb->total_xfer_length)
-		    && (srb->total_xfer_length >= cmd->underflow))
+		if (srb->total_xfer_length
+		    && srb->total_xfer_length >= cmd->underflow)
 			cmd->result =
 			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
 				       srb->end_message, CHECK_CONDITION);
@@ -4299,7 +3801,7 @@
 	if (dir != PCI_DMA_NONE) {
 		if (cmd->use_sg)
 			pci_dma_sync_sg(acb->dev,
-					(struct scatterlist *) cmd->
+					(struct scatterlist *)cmd->
 					request_buffer, cmd->use_sg, dir);
 		else if (cmd->request_buffer)
 			pci_dma_sync_single(acb->dev,
@@ -4360,20 +3862,12 @@
 	TRACEOUTALL(KERN_INFO " %s\n", srb->debugtrace);
 
 	waiting_process_next(acb);
-	return;
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		DC395x_reset
- * abort all cmds in our queues
- ********************************************************************
- */
-static
-void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
-		    Scsi_Cmnd * cmd, u8 force)
+/* abort all cmds in our queues */
+static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
+		Scsi_Cmnd *cmd, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
 
@@ -4459,30 +3953,17 @@
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		DC395x_shutdown   DC395x_reset
- ********************************************************************
- */
 static void reset_scsi_bus(struct AdapterCtlBlk *acb)
 {
-	/*u32  drv_flags=0; */
-
-	dprintkdbg(DBG_0, "reset_scsi_bus..............\n");
-
-	/*DC395x_DRV_LOCK(drv_flags); */
+	dprintkdbg(DBG_0, "reset_scsi_bus...\n");
 	acb->acb_flag |= RESET_DEV;	/* RESET_DETECT, RESET_DONE, RESET_DEV */
-
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_RSTSCSI);
-	while (!(DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS) & INT_SCSIRESET));
 
-	/*DC395x_DRV_UNLOCK(drv_flags); */
-	return;
+	while (!(DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS) & INT_SCSIRESET))
+		/* nothing */;
 }
 
 
-/* Set basic config */
 static void set_basic_config(struct AdapterCtlBlk *acb)
 {
 	u8 bval;
@@ -4520,12 +4001,6 @@
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		dc395x_interrupt
- ********************************************************************
- */
 static void scsi_reset_detect(struct AdapterCtlBlk *acb)
 {
 	dprintkl(KERN_INFO, "scsi_reset_detect\n");
@@ -4558,24 +4033,14 @@
 		acb->acb_flag = 0;
 		waiting_process_next(acb);
 	}
-
-	return;
 }
 
 
-/*
- ********************************************************************
- * scsiio
- *		srb_done
- ********************************************************************
- */
-static
-void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
-		   struct ScsiReqBlk *srb)
+static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
+		struct ScsiReqBlk *srb)
 {
-	Scsi_Cmnd *cmd;
+	Scsi_Cmnd *cmd = srb->cmd;
 
-	cmd = srb->cmd;
 	dprintkdbg(DBG_KG,
 	       "request_sense for pid %li, target %02i-%i\n",
 	       cmd->pid, cmd->device->id, cmd->device->lun);
@@ -4618,9 +4083,6 @@
 }
 
 
-
-
-
 /**
  * device_alloc - Allocate a new device instance. This create the
  * devices instance and sets up all the data items. The adapter
@@ -4634,8 +4096,8 @@
  *
  * Return the new device if succesfull or NULL on failure.
  **/
-static
-struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb, u8 target, u8 lun)
+static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
+		u8 target, u8 lun)
 {
 	struct NvRamType *eeprom = &acb->eeprom;
 	u8 period_index = eeprom->target[target].period & 0x07;
@@ -4643,9 +4105,8 @@
 
 	dcb = dc395x_kmalloc(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
 	dprintkdbg(DBG_0, "device_alloc: device %p\n", dcb);
-	if (!dcb) {
+	if (!dcb)
 		return NULL;
-	}
 	dcb->acb = NULL;
 	INIT_LIST_HEAD(&dcb->srb_going_list);
 	INIT_LIST_HEAD(&dcb->srb_waiting_list);
@@ -4704,8 +4165,8 @@
  * @acb: The adapter device to be updated
  * @dcb: A newly created and intialised device instance to add.
  **/
-static
-void adapter_add_device(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+static void adapter_add_device(struct AdapterCtlBlk *acb,
+		struct DeviceCtlBlk *dcb)
 {
 	/* backpointer to adapter */
 	dcb->acb = acb;
@@ -4732,8 +4193,8 @@
  * @acb: The adapter device to be updated
  * @dcb: A device that has previously been added to the adapter.
  **/
-static
-void adapter_remove_device(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+static void adapter_remove_device(struct AdapterCtlBlk *acb,
+		struct DeviceCtlBlk *dcb)
 {
 	struct DeviceCtlBlk *i;
 	struct DeviceCtlBlk *tmp;
@@ -4767,8 +4228,8 @@
  * @acb: The adapter device to be updated
  * @dcb: A device that has previously been added to the adapter.
  */
-static
-void adapter_remove_and_free_device(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+static void adapter_remove_and_free_device(struct AdapterCtlBlk *acb,
+		struct DeviceCtlBlk *dcb)
 {
 	if (list_size(&dcb->srb_going_list) > 1) {
 		dprintkdbg(DBG_DCB, "adapter_remove_and_free_device: "
@@ -4787,8 +4248,7 @@
  *
  * @acb: The adapter from which all devices should be removed.
  **/
-static
-void adapter_remove_and_free_all_devices(struct AdapterCtlBlk* acb)
+static void adapter_remove_and_free_all_devices(struct AdapterCtlBlk* acb)
 {
 	struct DeviceCtlBlk *dcb;
 	struct DeviceCtlBlk *tmp;
@@ -4807,8 +4267,7 @@
  *
  * @scsi_device: The new scsi device that we need to handle.
  **/
-static
-int dc395x_slave_alloc(struct scsi_device *scsi_device)
+static int dc395x_slave_alloc(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
@@ -4828,8 +4287,7 @@
  *
  * @scsi_device: The new scsi device that we need to handle.
  **/
-static
-void dc395x_slave_destroy(struct scsi_device *scsi_device)
+static void dc395x_slave_destroy(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
@@ -4847,14 +4305,12 @@
  *
  * @io_port: base I/O address
  **/
-static
-void __init trms1040_wait_30us(u16 io_port)
+static void __init trms1040_wait_30us(u16 io_port)
 {
 	/* ScsiPortStallExecution(30); wait 30 us */
 	outb(5, io_port + TRM_S1040_GEN_TIMER);
 	while (!(inb(io_port + TRM_S1040_GEN_STATUS) & GTIMEOUT))
 		/* nothing */ ;
-	return;
 }
 
 
@@ -4866,8 +4322,7 @@
  * @cmd:	SB + op code (command) to send
  * @addr:	address to send
  **/
-static
-void __init trms1040_write_cmd(u16 io_port, u8 cmd, u8 addr)
+static void __init trms1040_write_cmd(u16 io_port, u8 cmd, u8 addr)
 {
 	int i;
 	u8 send_data;
@@ -4912,8 +4367,7 @@
  * @addr:	offset into EEPROM
  * @byte:	bytes to write
  **/
-static
-void __init trms1040_set_data(u16 io_port, u8 addr, u8 byte)
+static void __init trms1040_set_data(u16 io_port, u8 addr, u8 byte)
 {
 	int i;
 	u8 send_data;
@@ -4967,10 +4421,9 @@
  * @eeprom:	the data to write
  * @io_port:	the base io port
  **/
-static
-void __init trms1040_write_all(struct NvRamType *eeprom, u16 io_port)
+static void __init trms1040_write_all(struct NvRamType *eeprom, u16 io_port)
 {
-	u8 *b_eeprom = (u8 *) eeprom;
+	u8 *b_eeprom = (u8 *)eeprom;
 	u8 addr;
 
 	/* Enable SEEPROM */
@@ -4983,9 +4436,8 @@
 	trms1040_wait_30us(io_port);
 
 	/* write */
-	for (addr = 0; addr < 128; addr++, b_eeprom++) {
+	for (addr = 0; addr < 128; addr++, b_eeprom++)
 		trms1040_set_data(io_port, addr, *b_eeprom);
-	}
 
 	/* write disable */
 	trms1040_write_cmd(io_port, 0x04, 0x00);
@@ -5009,8 +4461,7 @@
  *
  * Returns the the byte read.
  **/
-static
-u8 __init trms1040_get_data(u16 io_port, u8 addr)
+static u8 __init trms1040_get_data(u16 io_port, u8 addr)
 {
 	int i;
 	u8 read_byte;
@@ -5048,10 +4499,9 @@
  * @eeprom:	where to store the data
  * @io_port:	the base io port
  **/
-static
-void __init trms1040_read_all(struct NvRamType *eeprom, u16 io_port)
+static void __init trms1040_read_all(struct NvRamType *eeprom, u16 io_port)
 {
-	u8 *b_eeprom = (u8 *) eeprom;
+	u8 *b_eeprom = (u8 *)eeprom;
 	u8 addr;
 
 	/* Enable SEEPROM */
@@ -5059,9 +4509,8 @@
 	     io_port + TRM_S1040_GEN_CONTROL);
 
 	/* read details */
-	for (addr = 0; addr < 128; addr++, b_eeprom++) {
+	for (addr = 0; addr < 128; addr++, b_eeprom++)
 		*b_eeprom = trms1040_get_data(io_port, addr);
-	}
 
 	/* Disable SEEPROM */
 	outb((inb(io_port + TRM_S1040_GEN_CONTROL) & ~EN_EEPROM),
@@ -5080,10 +4529,9 @@
  * @eeprom:	caller allocated strcuture to read the eeprom data into
  * @io_port:	io port to read from
  **/
-static
-void __init check_eeprom(struct NvRamType *eeprom, u16 io_port)
+static void __init check_eeprom(struct NvRamType *eeprom, u16 io_port)
 {
-	u16 *w_eeprom = (u16 *) eeprom;
+	u16 *w_eeprom = (u16 *)eeprom;
 	u16 w_addr;
 	u16 cksum;
 	u32 d_addr;
@@ -5092,7 +4540,7 @@
 	trms1040_read_all(eeprom, io_port);	/* read eeprom */
 
 	cksum = 0;
-	for (w_addr = 0, w_eeprom = (u16 *) eeprom; w_addr < 64;
+	for (w_addr = 0, w_eeprom = (u16 *)eeprom; w_addr < 64;
 	     w_addr++, w_eeprom++)
 		cksum += *w_eeprom;
 	if (cksum != 0x1234) {
@@ -5102,20 +4550,20 @@
 		 */
 		dprintkl(KERN_WARNING,
 		       "EEProm checksum error: using default values and options.\n");
-		eeprom->sub_vendor_id[0] = (u8) PCI_VENDOR_ID_TEKRAM;
-		eeprom->sub_vendor_id[1] = (u8) (PCI_VENDOR_ID_TEKRAM >> 8);
-		eeprom->sub_sys_id[0] = (u8) PCI_DEVICE_ID_TEKRAM_TRMS1040;
+		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
+		eeprom->sub_vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
+		eeprom->sub_sys_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
 		eeprom->sub_sys_id[1] =
-		    (u8) (PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
+		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
 		eeprom->sub_class = 0x00;
-		eeprom->vendor_id[0] = (u8) PCI_VENDOR_ID_TEKRAM;
-		eeprom->vendor_id[1] = (u8) (PCI_VENDOR_ID_TEKRAM >> 8);
-		eeprom->device_id[0] = (u8) PCI_DEVICE_ID_TEKRAM_TRMS1040;
+		eeprom->vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
+		eeprom->vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
+		eeprom->device_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
 		eeprom->device_id[1] =
-		    (u8) (PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
+		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
 		eeprom->reserved = 0x00;
 
-		for (d_addr = 0, d_eeprom = (u32 *) eeprom->target;
+		for (d_addr = 0, d_eeprom = (u32 *)eeprom->target;
 		     d_addr < 16; d_addr++, d_eeprom++)
 			*d_eeprom = 0x00000077;	/* cfg3,cfg2,period,cfg0 */
 
@@ -5130,7 +4578,7 @@
 		eeprom_override(eeprom);
 
 		eeprom->cksum = 0x00;
-		for (w_addr = 0, cksum = 0, w_eeprom = (u16 *) eeprom;
+		for (w_addr = 0, cksum = 0, w_eeprom = (u16 *)eeprom;
 		     w_addr < 63; w_addr++, w_eeprom++)
 			cksum += *w_eeprom;
 
@@ -5145,16 +4593,13 @@
 }
 
 
-
-
 /**
  * print_eeprom_settings - output the eeprom settings
  * to the kernel log so people can see what they were.
  *
  * @eeprom: The eeprom data strucutre to show details for.
  **/
-static
-void __init print_eeprom_settings(struct NvRamType *eeprom)
+static void __init print_eeprom_settings(struct NvRamType *eeprom)
 {
 	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), dev_mode=0x%02x\n",
 	       eeprom->scsi_id,
@@ -5170,13 +4615,11 @@
 }
 
 
-
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 /*
  * Memory for trace buffers
  */
-static
-void free_tracebufs(struct AdapterCtlBlk *acb)
+static void free_tracebufs(struct AdapterCtlBlk *acb)
 {
 	int i;
 	const unsigned bufs_per_page = PAGE_SIZE / DEBUGTRACEBUFSZ;
@@ -5187,8 +4630,7 @@
 }
 
 
-static
-int alloc_tracebufs(struct AdapterCtlBlk *acb)
+static int alloc_tracebufs(struct AdapterCtlBlk *acb)
 {
 	const unsigned mem_needed =
 	    (DC395x_MAX_SRB_CNT + 1) * DEBUGTRACEBUFSZ;
@@ -5226,9 +4668,9 @@
 static int alloc_tracebufs(struct AdapterCtlBlk *acb) { return 0; }
 #endif
 
+
 /* Free SG tables */
-static
-void adapter_sg_tables_free(struct AdapterCtlBlk *acb)
+static void adapter_sg_tables_free(struct AdapterCtlBlk *acb)
 {
 	int i;
 	const unsigned srbs_per_page = PAGE_SIZE/(DC395x_MAX_SG_LISTENTRY
@@ -5243,8 +4685,7 @@
 /*
  * Allocate SG tables; as we have to pci_map them, an SG list (struct SGentry*)
  * should never cross a page boundary */
-static
-int __init adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
+static int __init adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
 {
 	const unsigned mem_needed = (DC395x_MAX_SRB_CNT+1)
 	                            *DC395x_MAX_SG_LISTENTRY
@@ -5292,8 +4733,7 @@
  *
  * @acb: The adapter to print the information for.
  **/
-static
-void __init adapter_print_config(struct AdapterCtlBlk *acb)
+static void __init adapter_print_config(struct AdapterCtlBlk *acb)
 {
 	u8 bval;
 
@@ -5337,8 +4777,7 @@
  *
  * @acb: The adapter to initialize.
  **/
-static
-void __init adapter_init_params(struct AdapterCtlBlk *acb)
+static void __init adapter_init_params(struct AdapterCtlBlk *acb)
 {
 	struct NvRamType *eeprom = &acb->eeprom;
 	int i;
@@ -5400,8 +4839,7 @@
  *
  * @host: The scsi host instance to fill in the values for.
  **/
-static
-void __init adapter_init_scsi_host(struct Scsi_Host *host)
+static void __init adapter_init_scsi_host(struct Scsi_Host *host)
 {
         struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
 	struct NvRamType *eeprom = &acb->eeprom;
@@ -5495,8 +4933,8 @@
  * Returns 0 if the initialization succeeds, any other value on
  * failure.
  **/
-static
-int __init adapter_init(struct AdapterCtlBlk *acb, u32 io_port, u32 io_port_len, u8 irq)
+static int __init adapter_init(struct AdapterCtlBlk *acb, u32 io_port,
+		u32 io_port_len, u8 irq)
 {
 	if (!request_region(io_port, io_port_len, DC395X_NAME)) {
 		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%x\n", io_port);
@@ -5562,8 +5000,7 @@
  *
  * @acb: The adapter which we are to shutdown.
  **/
-static
-void adapter_uninit_chip(struct AdapterCtlBlk *acb)
+static void adapter_uninit_chip(struct AdapterCtlBlk *acb)
 {
 	/* disable interrupts */
 	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0);
@@ -5586,8 +5023,7 @@
  *
  * @acb: The adapter which we are to un-initialize.
  **/
-static
-void adapter_uninit(struct AdapterCtlBlk *acb)
+static void adapter_uninit(struct AdapterCtlBlk *acb)
 {
 	unsigned long flags;
 	DC395x_LOCK_IO(acb->scsi_host, flags);
@@ -5612,27 +5048,6 @@
 }
 
 
-/*
- ******************************************************************
- * Function: dc395x_proc_info(char* buffer, char **start,
- *			 off_t offset, int length, int hostno, int inout)
- *  Purpose: return SCSI Adapter/Device Info
- *    Input:
- *          buffer: Pointer to a buffer where to write info
- *		 start :
- *		 offset:
- *		 hostno: Host adapter index
- *		 inout : Read (=0) or set(!=0) info
- *   Output:
- *          buffer: contains info length 
- *		         
- *    return value: length of info in buffer
- *
- ******************************************************************
- */
-
-/* KG: dc395x_proc_info taken from driver aha152x.c */
-
 #undef SPRINTF
 #define SPRINTF(args...) pos += sprintf(pos, args)
 
@@ -5641,9 +5056,8 @@
  if (YN) SPRINTF(" Yes ");\
  else SPRINTF(" No  ")
 
-static
-int dc395x_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,
-		     int inout)
+static int dc395x_proc_info(struct Scsi_Host *host, char *buffer,
+		char **start, off_t offset, int length, int inout)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
 	int spd, spd1;
@@ -5770,11 +5184,6 @@
 }
 
 
-
-
-/*
- * SCSI host template
- */
 static Scsi_Host_Template dc395x_driver_template = {
 	.module                 = THIS_MODULE,
 	.proc_name              = DC395X_NAME,
@@ -5799,8 +5208,7 @@
  * banner_display - Display banner on first instance of driver
  * initialized.
  **/
-static
-void banner_display(void)
+static void banner_display(void)
 {
 	static int banner_done = 0;
 	if (!banner_done)
@@ -5824,9 +5232,8 @@
  *
  * Returns 0 on success, or an error code (-ve) on failure.
  **/
-static
-int __devinit dc395x_init_one(struct pci_dev *dev,
-			      const struct pci_device_id *id)
+static int __devinit dc395x_init_one(struct pci_dev *dev,
+		const struct pci_device_id *id)
 {
 	struct Scsi_Host *scsi_host;
 	struct AdapterCtlBlk *acb;
@@ -5900,10 +5307,6 @@
 }
 
 
-/*
- * Table which identifies the PCI devices which
- * are handled by this device driver.
- */
 static struct pci_device_id dc395x_pci_table[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_TEKRAM,
@@ -5916,10 +5319,6 @@
 MODULE_DEVICE_TABLE(pci, dc395x_pci_table);
 
 
-/*
- * PCI driver operations.
- * Tells the PCI sub system what can be done with the card.
- */
 static struct pci_driver dc395x_driver = {
 	.name           = DC395X_NAME,
 	.id_table       = dc395x_pci_table,
@@ -5933,8 +5332,7 @@
  *
  * Used by both module and built-in driver to initialise this driver.
  **/
-static
-int __init dc395x_module_init(void)
+static int __init dc395x_module_init(void)
 {
 	return pci_module_init(&dc395x_driver);
 }
@@ -5943,8 +5341,7 @@
 /**
  * dc395x_module_exit - Module cleanup function.
  **/
-static
-void __exit dc395x_module_exit(void)
+static void __exit dc395x_module_exit(void)
 {
 	pci_unregister_driver(&dc395x_driver);
 }

-- 
 Jamie Lenehan <lenehan@twibble.org>
