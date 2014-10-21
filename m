From: Joe Perches <joe@perches.com>
Subject: [PATCH] ips: Remove unnecessary METHOD_TRACE
Date: Tue, 21 Oct 2014 15:22:29 -0700
Message-ID: <541a189de7129618e0a3a80e6f3a09ba68a855f9.1413930012.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

METHOD_TRACE is a poorman's function tracer.
Use the actual function tracer instead (ftrace)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/ips.c | 177 -----------------------------------------------------
 1 file changed, 177 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index e5afc38..a483244 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -153,8 +153,6 @@
  *                        NOTE: only works when IPS_DEBUG compile directive is used.
  *       1              - Normal debug messages
  *       2              - Verbose debug messages
- *       11             - Method trace (non interrupt)
- *       12             - Method trace (includes interrupt)
  *
  * noi2o                - Don't use I2O Queues (ServeRAID 4 only)
  * nommap               - Don't use memory mapped I/O
@@ -216,11 +214,9 @@ module_param(ips, charp, 0);
                          scb->scsi_cmd->sc_data_direction)
 
 #ifdef IPS_DEBUG
-#define METHOD_TRACE(s, i)    if (ips_debug >= (i+10)) printk(KERN_NOTICE s "\n");
 #define DEBUG(i, s)           if (ips_debug >= i) printk(KERN_NOTICE s "\n");
 #define DEBUG_VAR(i, s, v...) if (ips_debug >= i) printk(KERN_NOTICE s "\n", v);
 #else
-#define METHOD_TRACE(s, i)
 #define DEBUG(i, s)
 #define DEBUG_VAR(i, s, v...)
 #endif
@@ -563,8 +559,6 @@ ips_detect(struct scsi_host_template * SHT)
 {
 	int i;
 
-	METHOD_TRACE("ips_detect", 1);
-
 #ifdef MODULE
 	if (ips)
 		ips_setup(ips);
@@ -654,8 +648,6 @@ ips_release(struct Scsi_Host *sh)
 	ips_ha_t *ha;
 	int i;
 
-	METHOD_TRACE("ips_release", 1);
-
 	scsi_remove_host(sh);
 
 	for (i = 0; i < IPS_MAX_ADAPTERS && ips_sh[i] != sh; i++) ;
@@ -788,8 +780,6 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 	int ret;
 	struct Scsi_Host *host;
 
-	METHOD_TRACE("ips_eh_abort", 1);
-
 	if (!SC)
 		return (FAILED);
 
@@ -846,8 +836,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	ips_scb_t *scb;
 	ips_copp_wait_item_t *item;
 
-	METHOD_TRACE("ips_eh_reset", 1);
-
 #ifdef NO_IPS_RESET
 	return (FAILED);
 #else
@@ -1052,8 +1040,6 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 	ips_ha_t *ha;
 	ips_passthru_t *pt;
 
-	METHOD_TRACE("ips_queue", 1);
-
 	ha = (ips_ha_t *) SC->device->host->hostdata;
 
 	if (!ha)
@@ -1157,8 +1143,6 @@ static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 	int sectors;
 	int cylinders;
 
-	METHOD_TRACE("ips_biosparam", 1);
-
 	if (!ha)
 		/* ?!?! host adater info invalid */
 		return (0);
@@ -1234,8 +1218,6 @@ do_ipsintr(int irq, void *dev_id)
 	struct Scsi_Host *host;
 	int irqstatus;
 
-	METHOD_TRACE("do_ipsintr", 2);
-
 	ha = (ips_ha_t *) dev_id;
 	if (!ha)
 		return IRQ_NONE;
@@ -1281,8 +1263,6 @@ ips_intr_copperhead(ips_ha_t * ha)
 	IPS_STATUS cstatus;
 	int intrstatus;
 
-	METHOD_TRACE("ips_intr", 2);
-
 	if (!ha)
 		return 0;
 
@@ -1345,8 +1325,6 @@ ips_intr_morpheus(ips_ha_t * ha)
 	IPS_STATUS cstatus;
 	int intrstatus;
 
-	METHOD_TRACE("ips_intr_morpheus", 2);
-
 	if (!ha)
 		return 0;
 
@@ -1412,8 +1390,6 @@ ips_info(struct Scsi_Host *SH)
 	char *bp;
 	ips_ha_t *ha;
 
-	METHOD_TRACE("ips_info", 1);
-
 	ha = IPS_HA(SH);
 
 	if (!ha)
@@ -1495,8 +1471,6 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
 {
 	unsigned long flags;
 
-	METHOD_TRACE("ips_is_passthru", 1);
-
 	if (!SC)
 		return (0);
 
@@ -1572,8 +1546,6 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 	int i, ret;
         struct scatterlist *sg = scsi_sglist(SC);
 
-	METHOD_TRACE("ips_make_passthru", 1);
-
         scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
 		length += sg->length;
 
@@ -1911,8 +1883,6 @@ ips_usrcmd(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 	IPS_SG_LIST sg_list;
 	uint32_t cmd_busaddr;
 
-	METHOD_TRACE("ips_usrcmd", 1);
-
 	if ((!scb) || (!pt) || (!ha))
 		return (0);
 
@@ -1998,8 +1968,6 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 {
 	ips_passthru_t *pt;
 
-	METHOD_TRACE("ips_cleanup_passthru", 1);
-
 	if ((!scb) || (!scb->scsi_cmd) || (!scsi_sglist(scb->scsi_cmd))) {
 		DEBUG_VAR(1, "(%s%d) couldn't cleanup after passthru",
 			  ips_name, ha->host_num);
@@ -2036,8 +2004,6 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 static int
 ips_host_info(ips_ha_t *ha, struct seq_file *m)
 {
-	METHOD_TRACE("ips_host_info", 1);
-
 	seq_printf(m, "\nIBM ServeRAID General Information:\n\n");
 
 	if ((le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) &&
@@ -2155,8 +2121,6 @@ ips_host_info(ips_ha_t *ha, struct seq_file *m)
 static void
 ips_identify_controller(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_identify_controller", 1);
-
 	switch (ha->pcidev->device) {
 	case IPS_DEVICEID_COPPERHEAD:
 		if (ha->pcidev->revision <= IPS_REVID_SERVERAID) {
@@ -2250,8 +2214,6 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 	    { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C',
      'D', 'E', 'F' };
 
-	METHOD_TRACE("ips_get_bios_version", 1);
-
 	major = 0;
 	minor = 0;
 
@@ -2406,8 +2368,6 @@ ips_hainit(ips_ha_t * ha)
 	int i;
 	struct timeval tv;
 
-	METHOD_TRACE("ips_hainit", 1);
-
 	if (!ha)
 		return (0);
 
@@ -2546,8 +2506,6 @@ ips_next(ips_ha_t * ha, int intr)
 	ips_copp_wait_item_t *item;
 	int ret;
 	struct Scsi_Host *host;
-	METHOD_TRACE("ips_next", 1);
-
 	if (!ha)
 		return;
 	host = ips_sh[ha->host_num];
@@ -2773,8 +2731,6 @@ ips_next(ips_ha_t * ha, int intr)
 static void
 ips_putq_scb_head(ips_scb_queue_t * queue, ips_scb_t * item)
 {
-	METHOD_TRACE("ips_putq_scb_head", 1);
-
 	if (!item)
 		return;
 
@@ -2803,8 +2759,6 @@ ips_removeq_scb_head(ips_scb_queue_t * queue)
 {
 	ips_scb_t *item;
 
-	METHOD_TRACE("ips_removeq_scb_head", 1);
-
 	item = queue->head;
 
 	if (!item) {
@@ -2838,8 +2792,6 @@ ips_removeq_scb(ips_scb_queue_t * queue, ips_scb_t * item)
 {
 	ips_scb_t *p;
 
-	METHOD_TRACE("ips_removeq_scb", 1);
-
 	if (!item)
 		return (NULL);
 
@@ -2881,8 +2833,6 @@ ips_removeq_scb(ips_scb_queue_t * queue, ips_scb_t * item)
 /****************************************************************************/
 static void ips_putq_wait_tail(ips_wait_queue_t *queue, struct scsi_cmnd *item)
 {
-	METHOD_TRACE("ips_putq_wait_tail", 1);
-
 	if (!item)
 		return;
 
@@ -2914,8 +2864,6 @@ static struct scsi_cmnd *ips_removeq_wait_head(ips_wait_queue_t *queue)
 {
 	struct scsi_cmnd *item;
 
-	METHOD_TRACE("ips_removeq_wait_head", 1);
-
 	item = queue->head;
 
 	if (!item) {
@@ -2949,8 +2897,6 @@ static struct scsi_cmnd *ips_removeq_wait(ips_wait_queue_t *queue,
 {
 	struct scsi_cmnd *p;
 
-	METHOD_TRACE("ips_removeq_wait", 1);
-
 	if (!item)
 		return (NULL);
 
@@ -2993,8 +2939,6 @@ static struct scsi_cmnd *ips_removeq_wait(ips_wait_queue_t *queue,
 static void
 ips_putq_copp_tail(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
 {
-	METHOD_TRACE("ips_putq_copp_tail", 1);
-
 	if (!item)
 		return;
 
@@ -3027,8 +2971,6 @@ ips_removeq_copp_head(ips_copp_queue_t * queue)
 {
 	ips_copp_wait_item_t *item;
 
-	METHOD_TRACE("ips_removeq_copp_head", 1);
-
 	item = queue->head;
 
 	if (!item) {
@@ -3062,8 +3004,6 @@ ips_removeq_copp(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
 {
 	ips_copp_wait_item_t *p;
 
-	METHOD_TRACE("ips_removeq_copp", 1);
-
 	if (!item)
 		return (NULL);
 
@@ -3104,8 +3044,6 @@ ips_removeq_copp(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
 static void
 ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
 {
-	METHOD_TRACE("ipsintr_blocking", 2);
-
 	ips_freescb(ha, scb);
 	if ((ha->waitflag == TRUE) && (ha->cmd_in_progress == scb->cdb[0])) {
 		ha->waitflag = FALSE;
@@ -3126,8 +3064,6 @@ ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
 static void
 ipsintr_done(ips_ha_t * ha, ips_scb_t * scb)
 {
-	METHOD_TRACE("ipsintr_done", 2);
-
 	if (!scb) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Spurious interrupt; scb NULL.\n");
@@ -3160,8 +3096,6 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 {
 	int ret;
 
-	METHOD_TRACE("ips_done", 1);
-
 	if (!scb)
 		return;
 
@@ -3270,8 +3204,6 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
 	IPS_SCSI_INQ_DATA inquiryData;
 
-	METHOD_TRACE("ips_map_status", 1);
-
 	if (scb->bus) {
 		DEBUG_VAR(2,
 			  "(%s%d) Physical device error (%d %d %d): %x %x, Sense Key: %x, ASC: %x, ASCQ: %x",
@@ -3403,8 +3335,6 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 {
 	int ret;
 
-	METHOD_TRACE("ips_send_wait", 1);
-
 	if (intr != IPS_FFDC) {	/* Won't be Waiting if this is a Time Stamp */
 		ha->waitflag = TRUE;
 		ha->cmd_in_progress = scb->cdb[0];
@@ -3473,8 +3403,6 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
 	int TimeOut;
 
-	METHOD_TRACE("ips_send_cmd", 1);
-
 	ret = IPS_SUCCESS;
 
 	if (!scb->scsi_cmd) {
@@ -3856,8 +3784,6 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 	int errcode;
 	IPS_SCSI_INQ_DATA inquiryData;
 
-	METHOD_TRACE("ips_chkstatus", 1);
-
 	scb = &ha->scbs[pstatus->fields.command_id];
 	scb->basic_status = basic_status =
 	    pstatus->fields.basic_status & IPS_BASIC_STATUS_MASK;
@@ -4007,8 +3933,6 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 static int
 ips_online(ips_ha_t * ha, ips_scb_t * scb)
 {
-	METHOD_TRACE("ips_online", 1);
-
 	if (scb->target_id >= IPS_MAX_LD)
 		return (0);
 
@@ -4044,8 +3968,6 @@ ips_inquiry(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SCSI_INQ_DATA inquiry;
 
-	METHOD_TRACE("ips_inquiry", 1);
-
 	memset(&inquiry, 0, sizeof (IPS_SCSI_INQ_DATA));
 
 	inquiry.DeviceType = IPS_SCSI_INQ_TYPE_DASD;
@@ -4079,8 +4001,6 @@ ips_rdcap(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SCSI_CAPACITY cap;
 
-	METHOD_TRACE("ips_rdcap", 1);
-
 	if (scsi_bufflen(scb->scsi_cmd) < 8)
 		return (0);
 
@@ -4112,8 +4032,6 @@ ips_msense(ips_ha_t * ha, ips_scb_t * scb)
 	uint32_t cylinders;
 	IPS_SCSI_MODE_PAGE_DATA mdata;
 
-	METHOD_TRACE("ips_msense", 1);
-
 	if (le32_to_cpu(ha->enq->ulDriveSize[scb->target_id]) > 0x400000 &&
 	    (ha->enq->ucMiscFlag & 0x8) == 0) {
 		heads = IPS_NORM_HEADS;
@@ -4200,8 +4118,6 @@ ips_reqsen(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SCSI_REQSEN reqsen;
 
-	METHOD_TRACE("ips_reqsen", 1);
-
 	memset(&reqsen, 0, sizeof (IPS_SCSI_REQSEN));
 
 	reqsen.ResponseCode =
@@ -4228,8 +4144,6 @@ static void
 ips_free(ips_ha_t * ha)
 {
 
-	METHOD_TRACE("ips_free", 1);
-
 	if (ha) {
 		if (ha->enq) {
 			pci_free_consistent(ha->pcidev, sizeof(IPS_ENQ),
@@ -4324,8 +4238,6 @@ ips_allocatescbs(ips_ha_t * ha)
 	int i;
 	dma_addr_t command_dma, sg_dma;
 
-	METHOD_TRACE("ips_allocatescbs", 1);
-
 	/* Allocate memory for the SCBs */
 	ha->scbs =
 	    pci_alloc_consistent(ha->pcidev, ha->max_cmds * sizeof (ips_scb_t),
@@ -4386,8 +4298,6 @@ ips_init_scb(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SG_LIST sg_list;
 	uint32_t cmd_busaddr, sg_busaddr;
-	METHOD_TRACE("ips_init_scb", 1);
-
 	if (scb == NULL)
 		return;
 
@@ -4431,8 +4341,6 @@ ips_getscb(ips_ha_t * ha)
 {
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_getscb", 1);
-
 	if ((scb = ha->scb_freelist) == NULL) {
 
 		return (NULL);
@@ -4461,8 +4369,6 @@ ips_getscb(ips_ha_t * ha)
 static void
 ips_freescb(ips_ha_t * ha, ips_scb_t * scb)
 {
-
-	METHOD_TRACE("ips_freescb", 1);
 	if (scb->flags & IPS_SCB_MAP_SG)
                 scsi_dma_unmap(scb->scsi_cmd);
 	else if (scb->flags & IPS_SCB_MAP_SINGLE)
@@ -4491,8 +4397,6 @@ ips_isinit_copperhead(ips_ha_t * ha)
 	uint8_t scpr;
 	uint8_t isr;
 
-	METHOD_TRACE("ips_isinit_copperhead", 1);
-
 	isr = inb(ha->io_addr + IPS_REG_HISR);
 	scpr = inb(ha->io_addr + IPS_REG_SCPR);
 
@@ -4517,8 +4421,6 @@ ips_isinit_copperhead_memio(ips_ha_t * ha)
 	uint8_t isr = 0;
 	uint8_t scpr;
 
-	METHOD_TRACE("ips_is_init_copperhead_memio", 1);
-
 	isr = readb(ha->mem_ptr + IPS_REG_HISR);
 	scpr = readb(ha->mem_ptr + IPS_REG_SCPR);
 
@@ -4543,8 +4445,6 @@ ips_isinit_morpheus(ips_ha_t * ha)
 	uint32_t post;
 	uint32_t bits;
 
-	METHOD_TRACE("ips_is_init_morpheus", 1);
-
 	if (ips_isintr_morpheus(ha))
 	    ips_flush_and_reset(ha);
 
@@ -4658,8 +4558,6 @@ ips_poll_for_flush_complete(ips_ha_t * ha)
 static void
 ips_enable_int_copperhead(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_enable_int_copperhead", 1);
-
 	outb(ha->io_addr + IPS_REG_HISR, IPS_BIT_EI);
 	inb(ha->io_addr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
 }
@@ -4675,8 +4573,6 @@ ips_enable_int_copperhead(ips_ha_t * ha)
 static void
 ips_enable_int_copperhead_memio(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_enable_int_copperhead_memio", 1);
-
 	writeb(IPS_BIT_EI, ha->mem_ptr + IPS_REG_HISR);
 	readb(ha->mem_ptr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
 }
@@ -4694,8 +4590,6 @@ ips_enable_int_morpheus(ips_ha_t * ha)
 {
 	uint32_t Oimr;
 
-	METHOD_TRACE("ips_enable_int_morpheus", 1);
-
 	Oimr = readl(ha->mem_ptr + IPS_REG_I960_OIMR);
 	Oimr &= ~0x08;
 	writel(Oimr, ha->mem_ptr + IPS_REG_I960_OIMR);
@@ -4720,8 +4614,6 @@ ips_init_copperhead(ips_ha_t * ha)
 	uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
 	int i, j;
 
-	METHOD_TRACE("ips_init_copperhead", 1);
-
 	for (i = 0; i < IPS_MAX_POST_BYTES; i++) {
 		for (j = 0; j < 45; j++) {
 			Isr = inb(ha->io_addr + IPS_REG_HISR);
@@ -4814,8 +4706,6 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 	uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
 	int i, j;
 
-	METHOD_TRACE("ips_init_copperhead_memio", 1);
-
 	for (i = 0; i < IPS_MAX_POST_BYTES; i++) {
 		for (j = 0; j < 45; j++) {
 			Isr = readb(ha->mem_ptr + IPS_REG_HISR);
@@ -4909,8 +4799,6 @@ ips_init_morpheus(ips_ha_t * ha)
 	uint32_t Oimr;
 	int i;
 
-	METHOD_TRACE("ips_init_morpheus", 1);
-
 	/* Wait up to 45 secs for Post */
 	for (i = 0; i < 45; i++) {
 		Isr = readl(ha->mem_ptr + IPS_REG_I2O_HIR);
@@ -5022,8 +4910,6 @@ ips_reset_copperhead(ips_ha_t * ha)
 {
 	int reset_counter;
 
-	METHOD_TRACE("ips_reset_copperhead", 1);
-
 	DEBUG_VAR(1, "(%s%d) ips_reset_copperhead: io addr: %x, irq: %d",
 		  ips_name, ha->host_num, ha->io_addr, ha->pcidev->irq);
 
@@ -5067,8 +4953,6 @@ ips_reset_copperhead_memio(ips_ha_t * ha)
 {
 	int reset_counter;
 
-	METHOD_TRACE("ips_reset_copperhead_memio", 1);
-
 	DEBUG_VAR(1, "(%s%d) ips_reset_copperhead_memio: mem addr: %x, irq: %d",
 		  ips_name, ha->host_num, ha->mem_addr, ha->pcidev->irq);
 
@@ -5113,8 +4997,6 @@ ips_reset_morpheus(ips_ha_t * ha)
 	int reset_counter;
 	uint8_t junk;
 
-	METHOD_TRACE("ips_reset_morpheus", 1);
-
 	DEBUG_VAR(1, "(%s%d) ips_reset_morpheus: mem addr: %x, irq: %d",
 		  ips_name, ha->host_num, ha->mem_addr, ha->pcidev->irq);
 
@@ -5156,8 +5038,6 @@ ips_statinit(ips_ha_t * ha)
 {
 	uint32_t phys_status_start;
 
-	METHOD_TRACE("ips_statinit", 1);
-
 	ha->adapt->p_status_start = ha->adapt->status;
 	ha->adapt->p_status_end = ha->adapt->status + IPS_MAX_CMDS;
 	ha->adapt->p_status_tail = ha->adapt->status;
@@ -5187,8 +5067,6 @@ ips_statinit_memio(ips_ha_t * ha)
 {
 	uint32_t phys_status_start;
 
-	METHOD_TRACE("ips_statinit_memio", 1);
-
 	ha->adapt->p_status_start = ha->adapt->status;
 	ha->adapt->p_status_end = ha->adapt->status + IPS_MAX_CMDS;
 	ha->adapt->p_status_tail = ha->adapt->status;
@@ -5215,8 +5093,6 @@ ips_statinit_memio(ips_ha_t * ha)
 static uint32_t
 ips_statupd_copperhead(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_statupd_copperhead", 1);
-
 	if (ha->adapt->p_status_tail != ha->adapt->p_status_end) {
 		ha->adapt->p_status_tail++;
 		ha->adapt->hw_status_tail += sizeof (IPS_STATUS);
@@ -5243,8 +5119,6 @@ ips_statupd_copperhead(ips_ha_t * ha)
 static uint32_t
 ips_statupd_copperhead_memio(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_statupd_copperhead_memio", 1);
-
 	if (ha->adapt->p_status_tail != ha->adapt->p_status_end) {
 		ha->adapt->p_status_tail++;
 		ha->adapt->hw_status_tail += sizeof (IPS_STATUS);
@@ -5272,8 +5146,6 @@ ips_statupd_morpheus(ips_ha_t * ha)
 {
 	uint32_t val;
 
-	METHOD_TRACE("ips_statupd_morpheus", 1);
-
 	val = readl(ha->mem_ptr + IPS_REG_I2O_OUTMSGQ);
 
 	return (val);
@@ -5294,8 +5166,6 @@ ips_issue_copperhead(ips_ha_t * ha, ips_scb_t * scb)
 	uint32_t TimeOut;
 	uint32_t val;
 
-	METHOD_TRACE("ips_issue_copperhead", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5348,8 +5218,6 @@ ips_issue_copperhead_memio(ips_ha_t * ha, ips_scb_t * scb)
 	uint32_t TimeOut;
 	uint32_t val;
 
-	METHOD_TRACE("ips_issue_copperhead_memio", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5399,8 +5267,6 @@ static int
 ips_issue_i2o(ips_ha_t * ha, ips_scb_t * scb)
 {
 
-	METHOD_TRACE("ips_issue_i2o", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5431,8 +5297,6 @@ static int
 ips_issue_i2o_memio(ips_ha_t * ha, ips_scb_t * scb)
 {
 
-	METHOD_TRACE("ips_issue_i2o_memio", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5464,8 +5328,6 @@ ips_isintr_copperhead(ips_ha_t * ha)
 {
 	uint8_t Isr;
 
-	METHOD_TRACE("ips_isintr_copperhead", 2);
-
 	Isr = inb(ha->io_addr + IPS_REG_HISR);
 
 	if (Isr == 0xFF)
@@ -5497,8 +5359,6 @@ ips_isintr_copperhead_memio(ips_ha_t * ha)
 {
 	uint8_t Isr;
 
-	METHOD_TRACE("ips_isintr_memio", 2);
-
 	Isr = readb(ha->mem_ptr + IPS_REG_HISR);
 
 	if (Isr == 0xFF)
@@ -5530,8 +5390,6 @@ ips_isintr_morpheus(ips_ha_t * ha)
 {
 	uint32_t Isr;
 
-	METHOD_TRACE("ips_isintr_morpheus", 2);
-
 	Isr = readl(ha->mem_ptr + IPS_REG_I2O_HIR);
 
 	if (Isr & IPS_BIT_I2O_OPQI)
@@ -5555,8 +5413,6 @@ ips_wait(ips_ha_t * ha, int time, int intr)
 	int ret;
 	int done;
 
-	METHOD_TRACE("ips_wait", 1);
-
 	ret = IPS_FAILURE;
 	done = FALSE;
 
@@ -5610,8 +5466,6 @@ ips_wait(ips_ha_t * ha, int time, int intr)
 static int
 ips_write_driver_status(ips_ha_t * ha, int intr)
 {
-	METHOD_TRACE("ips_write_driver_status", 1);
-
 	if (!ips_readwrite_page5(ha, FALSE, intr)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "unable to read NVRAM page 5.\n");
@@ -5678,8 +5532,6 @@ ips_read_adapter_status(ips_ha_t * ha, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_read_adapter_status", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5721,8 +5573,6 @@ ips_read_subsystem_parameters(ips_ha_t * ha, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_read_subsystem_parameters", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5766,8 +5616,6 @@ ips_read_config(ips_ha_t * ha, int intr)
 	int i;
 	int ret;
 
-	METHOD_TRACE("ips_read_config", 1);
-
 	/* set defaults for initiator IDs */
 	for (i = 0; i < 4; i++)
 		ha->conf->init_id[i] = 7;
@@ -5823,8 +5671,6 @@ ips_readwrite_page5(ips_ha_t * ha, int write, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_readwrite_page5", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5873,8 +5719,6 @@ ips_clear_adapter(ips_ha_t * ha, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_clear_adapter", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5935,8 +5779,6 @@ ips_ffdc_reset(ips_ha_t * ha, int intr)
 {
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_ffdc_reset", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5969,8 +5811,6 @@ ips_ffdc_time(ips_ha_t * ha)
 {
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_ffdc_time", 1);
-
 	DEBUG_VAR(1, "(%s%d) Sending time update.", ips_name, ha->host_num);
 
 	scb = &ha->scbs[ha->max_cmds - 1];
@@ -6022,8 +5862,6 @@ ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time_t current_time)
 	{31, 31}
 	};
 
-	METHOD_TRACE("ips_fix_ffdc_time", 1);
-
 	days = current_time / IPS_SECS_DAY;
 	rem = current_time % IPS_SECS_DAY;
 
@@ -6073,8 +5911,6 @@ ips_erase_bios(ips_ha_t * ha)
 	int timeout;
 	uint8_t status = 0;
 
-	METHOD_TRACE("ips_erase_bios", 1);
-
 	status = 0;
 
 	/* Clear the status register */
@@ -6185,8 +6021,6 @@ ips_erase_bios_memio(ips_ha_t * ha)
 	int timeout;
 	uint8_t status;
 
-	METHOD_TRACE("ips_erase_bios_memio", 1);
-
 	status = 0;
 
 	/* Clear the status register */
@@ -6299,8 +6133,6 @@ ips_program_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	int timeout;
 	uint8_t status = 0;
 
-	METHOD_TRACE("ips_program_bios", 1);
-
 	status = 0;
 
 	for (i = 0; i < buffersize; i++) {
@@ -6390,8 +6222,6 @@ ips_program_bios_memio(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	int timeout;
 	uint8_t status = 0;
 
-	METHOD_TRACE("ips_program_bios_memio", 1);
-
 	status = 0;
 
 	for (i = 0; i < buffersize; i++) {
@@ -6480,8 +6310,6 @@ ips_verify_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	uint8_t checksum;
 	int i;
 
-	METHOD_TRACE("ips_verify_bios", 1);
-
 	/* test 1st byte */
 	outl(0, ha->io_addr + IPS_REG_FLAP);
 	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
@@ -6529,8 +6357,6 @@ ips_verify_bios_memio(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	uint8_t checksum;
 	int i;
 
-	METHOD_TRACE("ips_verify_bios_memio", 1);
-
 	/* test 1st byte */
 	writel(0, ha->mem_ptr + IPS_REG_FLAP);
 	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
@@ -6833,7 +6659,6 @@ ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent)
 	int index = -1;
 	int rc;
 
-	METHOD_TRACE("ips_insert_device", 1);
 	rc = pci_enable_device(pci_dev);
 	if (rc)
 		return rc;
@@ -6898,7 +6723,6 @@ ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr)
 	char __iomem *mem_ptr;
 	uint32_t IsDead;
 
-	METHOD_TRACE("ips_init_phase1", 1);
 	index = IPS_MAX_ADAPTERS;
 	for (j = 0; j < IPS_MAX_ADAPTERS; j++) {
 		if (ips_ha[j] == NULL) {
@@ -7107,7 +6931,6 @@ ips_init_phase2(int index)
 
 	ha = ips_ha[index];
 
-	METHOD_TRACE("ips_init_phase2", 1);
 	if (!ha->active) {
 		ips_ha[index] = NULL;
 		return -1;
-- 
2.1.0
