From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove obsolete API usage from dpt_i2o
Date: Mon, 31 May 2004 17:12:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531151253.GA18934@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:46511 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264665AbUEaPM4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 11:12:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.39/drivers/scsi/dpt_i2o.c	2004-05-24 17:16:20 +02:00
+++ edited/drivers/scsi/dpt_i2o.c	2004-05-31 15:35:50 +02:00
@@ -68,8 +68,11 @@
 #include <asm/pgtable.h>
 #include <asm/io.h>		/* for virt_to_bus, etc. */
 
-#include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 #include "dpt/dptsig.h"
 #include "dpti.h"
@@ -173,7 +176,7 @@
 };
 MODULE_DEVICE_TABLE(pci,dptids);
 
-static int adpt_detect(Scsi_Host_Template* sht)
+static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
@@ -362,7 +365,7 @@
 }
 
 
-static int adpt_slave_configure(Scsi_Device * device)
+static int adpt_slave_configure(struct scsi_device * device)
 {
 	struct Scsi_Host *host = device->host;
 	adpt_hba* pHba;
@@ -378,7 +381,7 @@
 	return 0;
 }
 
-static int adpt_queue(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 {
 	adpt_hba* pHba = NULL;
 	struct adpt_device* pDev = NULL;	/* dpt per device information */
@@ -643,7 +646,7 @@
  *===========================================================================
  */
 
-static int adpt_abort(Scsi_Cmnd * cmd)
+static int adpt_abort(struct scsi_cmnd * cmd)
 {
 	adpt_hba* pHba = NULL;	/* host bus adapter structure */
 	struct adpt_device* dptdevice;	/* dpt per device information */
@@ -683,7 +686,7 @@
 // This is the same for BLK and SCSI devices
 // NOTE this is wrong in the i2o.h definitions
 // This is not currently supported by our adapter but we issue it anyway
-static int adpt_device_reset(Scsi_Cmnd* cmd)
+static int adpt_device_reset(struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
 	u32 msg[4];
@@ -723,7 +726,7 @@
 
 #define I2O_HBA_BUS_RESET 0x87
 // This version of bus reset is called by the eh_error handler
-static int adpt_bus_reset(Scsi_Cmnd* cmd)
+static int adpt_bus_reset(struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
 	u32 msg[4];
@@ -745,7 +748,7 @@
 }
 
 // This version of reset is called by the eh_error_handler
-static int adpt_reset(Scsi_Cmnd* cmd)
+static int adpt_reset(struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
 	int rcode;
@@ -860,7 +863,7 @@
 #endif
 
 
-static int adpt_install_hba(Scsi_Host_Template* sht, struct pci_dev* pDev) 
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) 
 {
 
 	adpt_hba* pHba = NULL;
@@ -1997,7 +2000,7 @@
 
 static irqreturn_t adpt_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
-	Scsi_Cmnd* cmd;
+	struct scsi_cmnd* cmd;
 	adpt_hba* pHba = dev_id;
 	u32 m;
 	ulong reply;
@@ -2059,14 +2062,14 @@
 				status = I2O_POST_WAIT_OK;
 			}
 			if(!(context & 0x40000000)) {
-				cmd = (Scsi_Cmnd*) readl(reply+12); 
+				cmd = (struct scsi_cmnd*) readl(reply+12); 
 				if(cmd != NULL) {
 					printk(KERN_WARNING"%s: Apparent SCSI cmd in Post Wait Context - cmd=%p context=%x\n", pHba->name, cmd, context);
 				}
 			}
 			adpt_i2o_post_wait_complete(context, status);
 		} else { // SCSI message
-			cmd = (Scsi_Cmnd*) readl(reply+12); 
+			cmd = (struct scsi_cmnd*) readl(reply+12); 
 			if(cmd != NULL){
 				if(cmd->serial_number != 0) { // If not timedout
 					adpt_i2o_to_scsi(reply, cmd);
@@ -2083,7 +2086,7 @@
 	return IRQ_RETVAL(handled);
 }
 
-static s32 adpt_scsi_to_i2o(adpt_hba* pHba, Scsi_Cmnd* cmd, struct adpt_device* d)
+static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* d)
 {
 	int i;
 	u32 msg[MAX_MESSAGE_SIZE];
@@ -2108,16 +2111,16 @@
 		 * cmd->cmnd[0] is an unsigned char
 		 */
 		switch(cmd->sc_data_direction){
-		case SCSI_DATA_READ:
+		case DMA_FROM_DEVICE:
 			scsidir  =0x40000000;	// DATA IN  (iop<--dev)
 			break;
-		case SCSI_DATA_WRITE:
+		case DMA_TO_DEVICE:
 			direction=0x04000000;	// SGL OUT
 			scsidir  =0x80000000;	// DATA OUT (iop-->dev)
 			break;
-		case SCSI_DATA_NONE:
+		case DMA_NONE:
 			break;
-		case SCSI_DATA_UNKNOWN:
+		case DMA_BIDIRECTIONAL:
 			scsidir  =0x40000000;	// DATA IN  (iop<--dev)
 			// Assume In - and continue;
 			break;
@@ -2156,7 +2159,7 @@
 	if(cmd->use_sg) {
 		struct scatterlist *sg = (struct scatterlist *)cmd->request_buffer;
 		int sg_count = pci_map_sg(pHba->pDev, sg, cmd->use_sg,
-                        scsi_to_pci_dma_dir(cmd->sc_data_direction));
+				cmd->sc_data_direction);
 
 
 		len = 0;
@@ -2184,7 +2187,7 @@
 			*mptr++ = pci_map_single(pHba->pDev,
 				cmd->request_buffer,
 				cmd->request_bufflen,
-				scsi_to_pci_dma_dir(cmd->sc_data_direction));
+				cmd->sc_data_direction);
 		}
 	}
 	
@@ -2200,7 +2203,7 @@
 }
 
 
-static s32 adpt_scsi_register(adpt_hba* pHba,Scsi_Host_Template * sht)
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
 {
 	struct Scsi_Host *host = NULL;
 
@@ -2231,7 +2234,7 @@
 }
 
 
-static s32 adpt_i2o_to_scsi(ulong reply, Scsi_Cmnd* cmd)
+static s32 adpt_i2o_to_scsi(ulong reply, struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
 	u32 hba_status;
@@ -2533,8 +2536,8 @@
 
 static void adpt_fail_posted_scbs(adpt_hba* pHba)
 {
-	Scsi_Cmnd* 	cmd = NULL;
-	Scsi_Device* 	d = NULL;
+	struct scsi_cmnd* 	cmd = NULL;
+	struct scsi_device* 	d = NULL;
 
 	shost_for_each_device(d, pHba->host) {
 		unsigned long flags;
@@ -3358,7 +3361,7 @@
 
 #endif
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
--- 1.11/drivers/scsi/dpti.h	2004-04-27 10:58:25 +02:00
+++ edited/drivers/scsi/dpti.h	2004-05-31 15:34:32 +02:00
@@ -37,19 +37,19 @@
  * SCSI interface function Prototypes
  */
 
-static int adpt_detect(Scsi_Host_Template * sht);
-static int adpt_queue(Scsi_Cmnd * cmd, void (*cmdcomplete) (Scsi_Cmnd *));
-static int adpt_abort(Scsi_Cmnd * cmd);
-static int adpt_reset(Scsi_Cmnd* cmd);
+static int adpt_detect(struct scsi_host_template * sht);
+static int adpt_queue(struct scsi_cmnd * cmd, void (*cmdcomplete) (struct scsi_cmnd *));
+static int adpt_abort(struct scsi_cmnd * cmd);
+static int adpt_reset(struct scsi_cmnd* cmd);
 static int adpt_release(struct Scsi_Host *host);
-static int adpt_slave_configure(Scsi_Device *);
+static int adpt_slave_configure(struct scsi_device *);
 
 static const char *adpt_info(struct Scsi_Host *pSHost);
 static int adpt_bios_param(struct scsi_device * sdev, struct block_device *dev,
 		sector_t, int geom[]);
 
-static int adpt_bus_reset(Scsi_Cmnd* cmd);
-static int adpt_device_reset(Scsi_Cmnd* cmd);
+static int adpt_bus_reset(struct scsi_cmnd* cmd);
+static int adpt_device_reset(struct scsi_cmnd* cmd);
 
 
 /*
@@ -198,7 +198,7 @@
 	u8	state;
 	u16	tid;
 	struct i2o_device* pI2o_dev;
-	Scsi_Device *pScsi_dev;
+	struct scsi_device *pScsi_dev;
 };
 
 struct adpt_channel {
@@ -296,9 +296,9 @@
 static s32 adpt_i2o_status_get(adpt_hba* pHba);
 static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba);
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
-static s32 adpt_scsi_to_i2o(adpt_hba* pHba, Scsi_Cmnd* cmd, struct adpt_device* dptdevice);
-static s32 adpt_i2o_to_scsi(ulong reply, Scsi_Cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba,Scsi_Host_Template * sht);
+static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
+static s32 adpt_i2o_to_scsi(ulong reply, struct scsi_cmnd* cmd);
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);
@@ -308,7 +308,7 @@
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun);
-static int adpt_install_hba(Scsi_Host_Template* sht, struct pci_dev* pDev) ;
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
