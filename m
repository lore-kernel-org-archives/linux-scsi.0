From: Andrew Morton <akpm@osdl.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Fri, 11 Mar 2005 14:31:29 -0800
Message-ID: <20050311143129.3d9aadf6.akpm@osdl.org>
References: <000001c524bc$d3c546a0$0b02a8c0@kw.de>
	<000c01c52626$32bae8d0$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:21192 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261756AbVCKWbm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 17:31:42 -0500
In-Reply-To: <000c01c52626$32bae8d0$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: e0815w@onlinehome.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, hch@infradead.org, arjan@infradead.org

"erich" <erich@areca.com.tw> wrote:
>
> I had modify "arcmsr" as your mention and ran it at 2.6.11 kernel.
> It looks more clean and safety in pccb memory allocation.

Oh dear.  Adrian wrote a patch which cleans up a lot of things in this
driver but you don't seem to have applied it, and none of it works any
more.

Please integrate these changes into this driver:


From: Adrian Bunk <bunk@stusta.de>

- make needlessly global functions static
- move arcmsr_scsi_host_template from arcmsr.h to arcmsr.c
  (code doesn't belong into header files)

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/scsi/arcmsr/arcmsr.c |  110 +++++++++++++++++++++++------------
 25-akpm/drivers/scsi/arcmsr/arcmsr.h |   34 ----------
 2 files changed, 73 insertions(+), 71 deletions(-)

diff -puN drivers/scsi/arcmsr/arcmsr.c~drivers-scsi-arcmsr-arcmsrc-cleanups drivers/scsi/arcmsr/arcmsr.c
--- 25/drivers/scsi/arcmsr/arcmsr.c~drivers-scsi-arcmsr-arcmsrc-cleanups	2005-02-28 15:42:00.000000000 -0800
+++ 25-akpm/drivers/scsi/arcmsr/arcmsr.c	2005-02-28 15:42:00.000000000 -0800
@@ -121,15 +121,26 @@ static int arcmsr_fops_open(struct inode
 static int arcmsr_halt_notify(struct notifier_block *nb, unsigned long event,
 			      void *buf);
 static void arcmsr_free_pci_pool(PACB pACB);
-void arcmsr_pcidev_disattach(PACB pACB);
-BOOLEAN arcmsr_wait_msgint_ready(PACB pACB);
-void arcmsr_iop_init(PACB pACB);
-int arcmsr_iop_ioctlcmd(PACB pACB, int ioctl_cmd, void *arg);
-int arcmsr_initialize(PACB pACB, struct pci_dev *pPCI_DEV);
+static void arcmsr_pcidev_disattach(PACB pACB);
+static void arcmsr_iop_init(PACB pACB);
+static int arcmsr_iop_ioctlcmd(PACB pACB, int ioctl_cmd, void *arg);
+static int arcmsr_initialize(PACB pACB, struct pci_dev *pPCI_DEV);
 static irqreturn_t arcmsr_HwInterrupt(PACB pACB);
 static int arcmsr_device_probe(struct pci_dev *pPCI_DEV,
 			       const struct pci_device_id *id);
 static void arcmsr_device_remove(struct pci_dev *pPCI_DEV);
+static int arcmsr_bios_param(struct scsi_device *sdev,
+			     struct block_device *bdev,
+			     sector_t capacity, int *geom);
+static int arcmsr_bus_reset(Scsi_Cmnd * cmd);
+static int arcmsr_cmd_abort(Scsi_Cmnd * cmd);
+static const char *arcmsr_info(struct Scsi_Host *host);
+static int arcmsr_ioctl(Scsi_Device * dev, int ioctl_cmd, void *arg);
+static int arcmsr_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+			    off_t offset, int length, int inout);
+static int arcmsr_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
+static int arcmsr_release(struct Scsi_Host *host);
+
 /*
 **********************************************************************************
 **
@@ -169,13 +180,37 @@ static struct pci_device_id arcmsr_devic
 };
 
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
-struct pci_driver arcmsr_pci_driver = {
+static struct pci_driver arcmsr_pci_driver = {
 	.name = "arcmsr",
 	.id_table = arcmsr_device_id_table,
 	.probe = arcmsr_device_probe,
 	.remove = arcmsr_device_remove,
 };
 
+static Scsi_Host_Template arcmsr_scsi_host_template = {
+	.module = THIS_MODULE,
+	.proc_name = "arcmsr",
+	.proc_info = arcmsr_proc_info,
+	.name = "ARCMSR ARECA SATA RAID HOST Adapter" ARCMSR_DRIVER_VERSION,	/* *name */
+	.release = arcmsr_release,
+	.info = arcmsr_info,
+	.ioctl = arcmsr_ioctl,
+	.queuecommand = arcmsr_queue_command,
+	.eh_strategy_handler = NULL,
+	.eh_abort_handler = arcmsr_cmd_abort,
+	.eh_device_reset_handler = NULL,
+	.eh_bus_reset_handler = arcmsr_bus_reset,
+	.eh_host_reset_handler = NULL,
+	.bios_param = arcmsr_bios_param,
+	.can_queue = ARCMSR_MAX_OUTSTANDING_CMD,
+	.this_id = ARCMSR_SCSI_INITIATOR_ID,
+	.sg_tablesize = ARCMSR_MAX_SG_ENTRIES,
+	.max_sectors = ARCMSR_MAX_XFER_SECTORS,
+	.cmd_per_lun = ARCMSR_MAX_CMD_PERLUN,
+	.unchecked_isa_dma = 0,
+	.use_clustering = DISABLE_CLUSTERING,
+};
+
 /*
 *********************************************************************
 *********************************************************************
@@ -213,8 +248,9 @@ static irqreturn_t arcmsr_doInterrupt(in
 *********************************************************************
 *********************************************************************
 */
-int arcmsr_bios_param(struct scsi_device *sdev, struct block_device *bdev,
-		      sector_t capacity, int *geom)
+static int arcmsr_bios_param(struct scsi_device *sdev,
+			     struct block_device *bdev,
+			     sector_t capacity, int *geom)
 {
 	int heads, sectors, cylinders, total_capacity;
 
@@ -409,7 +445,7 @@ module_exit(arcmsr_module_exit);
 **
 **********************************************************************
 */
-void arcmsr_pci_unmap_dma(PCCB pCCB)
+static void arcmsr_pci_unmap_dma(PCCB pCCB)
 {
 	PACB pACB = pCCB->pACB;
 	Scsi_Cmnd *pcmd = pCCB->pcmd;
@@ -528,7 +564,7 @@ static int arcmsr_fops_ioctl(struct inod
 **
 **********************************************************************
 */
-void arcmsr_cmd_done(Scsi_Cmnd * pcmd)
+static void arcmsr_cmd_done(Scsi_Cmnd * pcmd)
 {
 	pcmd->scsi_done(pcmd);
 	return;
@@ -540,7 +576,7 @@ void arcmsr_cmd_done(Scsi_Cmnd * pcmd)
 **
 ************************************************************************
 */
-void arcmsr_flush_adapter_cache(PACB pACB)
+static void arcmsr_flush_adapter_cache(PACB pACB)
 {
 #if ARCMSR_DEBUG0
 	printk("arcmsr_flush_adapter_cache..............\n");
@@ -557,7 +593,7 @@ void arcmsr_flush_adapter_cache(PACB pAC
 **
 **********************************************************************
 */
-void arcmsr_ccb_complete(PCCB pCCB)
+static void arcmsr_ccb_complete(PCCB pCCB)
 {
 	unsigned long flag;
 	PACB pACB = pCCB->pACB;
@@ -586,7 +622,7 @@ void arcmsr_ccb_complete(PCCB pCCB)
 **       if scsi error do auto request sense
 **********************************************************************
 */
-void arcmsr_report_SenseInfoBuffer(PCCB pCCB)
+static void arcmsr_report_SenseInfoBuffer(PCCB pCCB)
 {
 	Scsi_Cmnd *pcmd = pCCB->pcmd;
 	PSENSE_DATA psenseBuffer = (PSENSE_DATA) pcmd->sense_buffer;
@@ -611,7 +647,7 @@ void arcmsr_report_SenseInfoBuffer(PCCB 
 ** to insert pCCB into tail of pACB wait exec ccbQ
 *********************************************************************
 */
-void arcmsr_queue_wait2go_ccb(PACB pACB, PCCB pCCB)
+static void arcmsr_queue_wait2go_ccb(PACB pACB, PCCB pCCB)
 {
 	unsigned long flag;
 	int i = 0;
@@ -639,7 +675,7 @@ void arcmsr_queue_wait2go_ccb(PACB pACB,
 **
 *********************************************************************
 */
-void arcmsr_abort_allcmd(PACB pACB)
+static void arcmsr_abort_allcmd(PACB pACB)
 {
 	CHIP_REG_WRITE32(&pACB->pmu->inbound_msgaddr0,
 			 ARCMSR_INBOUND_MESG0_ABORT_CMD);
@@ -653,7 +689,7 @@ void arcmsr_abort_allcmd(PACB pACB)
 **
 **********************************************************************
 */
-BOOLEAN arcmsr_wait_msgint_ready(PACB pACB)
+static BOOLEAN arcmsr_wait_msgint_ready(PACB pACB)
 {
 	uint32_t Index;
 	uint8_t Retries = 0x00;
@@ -678,7 +714,7 @@ BOOLEAN arcmsr_wait_msgint_ready(PACB pA
 **        Return Value: Nothing.
 ****************************************************************************
 */
-void arcmsr_iop_reset(PACB pACB)
+static void arcmsr_iop_reset(PACB pACB)
 {
 	PCCB pCCB;
 	uint32_t intmask_org, mask;
@@ -760,7 +796,7 @@ void arcmsr_iop_reset(PACB pACB)
 ** PAGE_SIZE=4096 or 8192,PAGE_SHIFT=12
 **********************************************************************
 */
-void arcmsr_build_ccb(PACB pACB, PCCB pCCB, Scsi_Cmnd * pcmd)
+static void arcmsr_build_ccb(PACB pACB, PCCB pCCB, Scsi_Cmnd * pcmd)
 {
 	PARCMSR_CDB pARCMSR_CDB = (PARCMSR_CDB) & pCCB->arcmsr_cdb;
 	int8_t *psge = (int8_t *) & pARCMSR_CDB->u;
@@ -931,7 +967,7 @@ static void arcmsr_post_ccb(PACB pACB, P
 **
 **************************************************************************
 */
-void arcmsr_post_wait2go_ccb(PACB pACB)
+static void arcmsr_post_wait2go_ccb(PACB pACB)
 {
 	unsigned long flag;
 	PCCB pCCB;
@@ -965,7 +1001,7 @@ void arcmsr_post_wait2go_ccb(PACB pACB)
 **     Output:
 **********************************************************************
 */
-void arcmsr_post_Qbuffer(PACB pACB)
+static void arcmsr_post_Qbuffer(PACB pACB)
 {
 	uint8_t *pQbuffer;
 	PQBUFFER pwbuffer = (PQBUFFER) & pACB->pmu->ioctl_wbuffer;
@@ -996,7 +1032,7 @@ void arcmsr_post_Qbuffer(PACB pACB)
 **
 ************************************************************************
 */
-void arcmsr_stop_adapter_bgrb(PACB pACB)
+static void arcmsr_stop_adapter_bgrb(PACB pACB)
 {
 #if ARCMSR_DEBUG0
 	printk("arcmsr_stop_adapter_bgrb..............\n");
@@ -1271,7 +1307,7 @@ static irqreturn_t arcmsr_HwInterrupt(PA
 **
 ************************************************************************
 */
-int arcmsr_iop_ioctlcmd(PACB pACB, int ioctl_cmd, void *arg)
+static int arcmsr_iop_ioctlcmd(PACB pACB, int ioctl_cmd, void *arg)
 {
 	CMD_IOCTL_FIELD cmdioctlfld;
 	PCMD_IOCTL_FIELD pcmdioctlfld = &cmdioctlfld;
@@ -1617,7 +1653,7 @@ int arcmsr_iop_ioctlcmd(PACB pACB, int i
 **
 ************************************************************************
 */
-int arcmsr_ioctl(Scsi_Device * dev, int ioctl_cmd, void *arg)
+static int arcmsr_ioctl(Scsi_Device * dev, int ioctl_cmd, void *arg)
 {
 	PACB pACB;
 	int32_t match = 0x55AA, i;
@@ -1649,7 +1685,7 @@ int arcmsr_ioctl(Scsi_Device * dev, int 
 **
 **************************************************************************
 */
-PCCB arcmsr_get_freeccb(PACB pACB)
+static PCCB arcmsr_get_freeccb(PACB pACB)
 {
 	PCCB pCCB;
 	unsigned long flag;
@@ -1821,7 +1857,7 @@ PCCB arcmsr_get_freeccb(PACB pACB)
 **} Scsi_Pointer;
 ***********************************************************************
 */
-int arcmsr_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int arcmsr_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 {
 	struct Scsi_Host *host = cmd->device->host;
 	PACB pACB = (PACB) host->hostdata;
@@ -1872,7 +1908,7 @@ int arcmsr_queue_command(Scsi_Cmnd * cmd
 **
 **********************************************************************
 */
-void arcmsr_start_adapter_bgrb(PACB pACB)
+static void arcmsr_start_adapter_bgrb(PACB pACB)
 {
 #if ARCMSR_DEBUG0
 	printk
@@ -1892,7 +1928,7 @@ void arcmsr_start_adapter_bgrb(PACB pACB
 **
 **********************************************************************
 */
-void arcmsr_iop_init(PACB pACB)
+static void arcmsr_iop_init(PACB pACB)
 {
 	uint32_t intmask_org, mask, outbound_doorbell, firmware_state = 0;
 
@@ -1932,7 +1968,7 @@ void arcmsr_iop_init(PACB pACB)
 **
 ****************************************************************************
 */
-int arcmsr_bus_reset(Scsi_Cmnd * cmd)
+static int arcmsr_bus_reset(Scsi_Cmnd * cmd)
 {
 	PACB pACB;
 
@@ -1949,7 +1985,7 @@ int arcmsr_bus_reset(Scsi_Cmnd * cmd)
 **
 *****************************************************************************************
 */
-int arcmsr_seek_cmd2abort(Scsi_Cmnd * pabortcmd)
+static int arcmsr_seek_cmd2abort(Scsi_Cmnd * pabortcmd)
 {
 	PACB pACB = (PACB) pabortcmd->device->host->hostdata;
 	PCCB pCCB;
@@ -2048,7 +2084,7 @@ int arcmsr_seek_cmd2abort(Scsi_Cmnd * pa
 **
 *****************************************************************************************
 */
-int arcmsr_cmd_abort(Scsi_Cmnd * cmd)
+static int arcmsr_cmd_abort(Scsi_Cmnd * cmd)
 {
 	int error;
 
@@ -2112,7 +2148,7 @@ int arcmsr_cmd_abort(Scsi_Cmnd * cmd)
 **
 *********************************************************************
 */
-const char *arcmsr_info(struct Scsi_Host *host)
+static const char *arcmsr_info(struct Scsi_Host *host)
 {
 	static char buf[256];
 	PACB pACB;
@@ -2212,7 +2248,7 @@ const char *arcmsr_info(struct Scsi_Host
 **}
 ************************************************************************
 */
-int arcmsr_initialize(PACB pACB, struct pci_dev *pPCI_DEV)
+static int arcmsr_initialize(PACB pACB, struct pci_dev *pPCI_DEV)
 {
 	uint32_t intmask_org, page_base, page_offset, mem_base_start;
 	dma_addr_t dma_addr;
@@ -2339,7 +2375,7 @@ int arcmsr_initialize(PACB pACB, struct 
 *********************************************************************
 *********************************************************************
 */
-int arcmsr_set_info(char *buffer, int length)
+static int arcmsr_set_info(char *buffer, int length)
 {
 #if ARCMSR_DEBUG0
 	printk("arcmsr_set_info.............\n");
@@ -2352,7 +2388,7 @@ int arcmsr_set_info(char *buffer, int le
 **
 *********************************************************************
 */
-void arcmsr_pcidev_disattach(PACB pACB)
+static void arcmsr_pcidev_disattach(PACB pACB)
 {
 	PCCB pCCB;
 	uint32_t intmask_org, mask;
@@ -2489,8 +2525,8 @@ static int arcmsr_halt_notify(struct not
 if(YN) SPRINTF(" Yes ");\
 else SPRINTF(" No ")
 
-int arcmsr_proc_info(struct Scsi_Host *host, char *buffer, char **start,
-		     off_t offset, int length, int inout)
+static int arcmsr_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+			    off_t offset, int length, int inout)
 {
 	uint8_t i;
 	char *pos = buffer;
@@ -2528,7 +2564,7 @@ int arcmsr_proc_info(struct Scsi_Host *h
 **
 ************************************************************************
 */
-int arcmsr_release(struct Scsi_Host *host)
+static int arcmsr_release(struct Scsi_Host *host)
 {
 	PACB pACB;
 	uint8_t match = 0xff, i;
diff -puN drivers/scsi/arcmsr/arcmsr.h~drivers-scsi-arcmsr-arcmsrc-cleanups drivers/scsi/arcmsr/arcmsr.h
--- 25/drivers/scsi/arcmsr/arcmsr.h~drivers-scsi-arcmsr-arcmsrc-cleanups	2005-02-28 15:42:00.000000000 -0800
+++ 25-akpm/drivers/scsi/arcmsr/arcmsr.h	2005-02-28 15:42:00.000000000 -0800
@@ -4802,38 +4802,4 @@ typedef struct _SENSE_DATA {
 **        (E) Checksum : checksum of length and status or data byte
 **************************************************************************
 */
-extern int arcmsr_proc_info(struct Scsi_Host *host, char *buffer, char **start,
-			    off_t offset, int length, int inout);
-extern int arcmsr_bios_param(struct scsi_device *sdev,
-			     struct block_device *bdev, sector_t capacity,
-			     int *info);
-extern int arcmsr_release(struct Scsi_Host *);
-extern int arcmsr_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
-extern int arcmsr_cmd_abort(Scsi_Cmnd *);
-extern int arcmsr_bus_reset(Scsi_Cmnd *);
-extern int arcmsr_ioctl(Scsi_Device * dev, int ioctl_cmd, void *arg);
-extern const char *arcmsr_info(struct Scsi_Host *);
 
-static Scsi_Host_Template arcmsr_scsi_host_template = {
-	.module = THIS_MODULE,
-	.proc_name = "arcmsr",
-	.proc_info = arcmsr_proc_info,
-	.name = "ARCMSR ARECA SATA RAID HOST Adapter" ARCMSR_DRIVER_VERSION,	/* *name */
-	.release = arcmsr_release,
-	.info = arcmsr_info,
-	.ioctl = arcmsr_ioctl,
-	.queuecommand = arcmsr_queue_command,
-	.eh_strategy_handler = NULL,
-	.eh_abort_handler = arcmsr_cmd_abort,
-	.eh_device_reset_handler = NULL,
-	.eh_bus_reset_handler = arcmsr_bus_reset,
-	.eh_host_reset_handler = NULL,
-	.bios_param = arcmsr_bios_param,
-	.can_queue = ARCMSR_MAX_OUTSTANDING_CMD,
-	.this_id = ARCMSR_SCSI_INITIATOR_ID,
-	.sg_tablesize = ARCMSR_MAX_SG_ENTRIES,
-	.max_sectors = ARCMSR_MAX_XFER_SECTORS,
-	.cmd_per_lun = ARCMSR_MAX_CMD_PERLUN,
-	.unchecked_isa_dma = 0,
-	.use_clustering = DISABLE_CLUSTERING,
-};
_

