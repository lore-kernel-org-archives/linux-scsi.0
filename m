From: Olaf Kirch <okir@lst.de>
Subject: [PATCH] fill in scsi_host_template module owner
Date: Mon, 30 Apr 2007 16:53:55 +0200
Message-ID: <200704301653.56687.okir@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48017 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423339AbXD3OyL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 10:54:11 -0400
Received: from [192.168.5.32] (p54A7CDEC.dip.t-dialin.net [84.167.205.236])
	(authenticated bits=0)
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3UEs5LD028274
	(version=TLSv1/SSLv3 cipher=EXP1024-RC4-SHA bits=56 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Apr 2007 16:54:06 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I recently ran into an oops that happens because you
can shut down all of iSCSI even though you still have
iSCSI targets mounted. It turned out that iscsi's
scsi_host_template missed a THIS_MODULE, so
reference counting wasn't done properly. Brief
inspection showed that this seems to be a rather
wide-spread problem. Here's a patch to address this.

Olaf

----------------------------------
Summary: fill in scsi_host_template module owner

Many of the SCSI drivers do not set the module owner field in
scsi_host_template.  This can lead to oopses when the module is unloaded
while a disk attached to the controller is still mounted (this can be
reproduced fairly easily with iscsi_tcp, for instance, but I assume the
same is true for other controllers).

Signed-off-by: olaf.kirch@oracle.com
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/a100u2w.c                   |    1 +
 drivers/scsi/a2091.c                     |    1 +
 drivers/scsi/a3000.c                     |    1 +
 drivers/scsi/advansys.c                  |    1 +
 drivers/scsi/aha1542.c                   |    1 +
 drivers/scsi/aic7xxx_old.c               |    1 +
 drivers/scsi/amiga7xx.c                  |    1 +
 drivers/scsi/atari_scsi.c                |    1 +
 drivers/scsi/blz1230.c                   |    1 +
 drivers/scsi/blz2060.c                   |    1 +
 drivers/scsi/bvme6000.c                  |    1 +
 drivers/scsi/cyberstorm.c                |    1 +
 drivers/scsi/cyberstormII.c              |    1 +
 drivers/scsi/dmx3191d.c                  |    1 +
 drivers/scsi/dpt_i2o.c                   |    1 +
 drivers/scsi/dtc.c                       |    1 +
 drivers/scsi/eata.c                      |    1 +
 drivers/scsi/eata_pio.c                  |    1 +
 drivers/scsi/fastlane.c                  |    1 +
 drivers/scsi/fcal.c                      |    1 +
 drivers/scsi/fd_mcs.c                    |    1 +
 drivers/scsi/g_NCR5380.c                 |    1 +
 drivers/scsi/gdth.c                      |    1 +
 drivers/scsi/gvp11.c                     |    1 +
 drivers/scsi/ibmmca.c                    |    1 +
 drivers/scsi/in2000.c                    |    1 +
 drivers/scsi/initio.c                    |    1 +
 drivers/scsi/ips.c                       |    1 +
 drivers/scsi/iscsi_tcp.c                 |    1 +
 drivers/scsi/jazz_esp.c                  |    1 +
 drivers/scsi/mac53c94.c                  |    1 +
 drivers/scsi/mac_esp.c                   |    1 +
 drivers/scsi/mac_scsi.c                  |    1 +
 drivers/scsi/mca_53c9x.c                 |    1 +
 drivers/scsi/mesh.c                      |    1 +
 drivers/scsi/mvme147.c                   |    1 +
 drivers/scsi/mvme16x.c                   |    1 +
 drivers/scsi/nsp32.c                     |    1 +
 drivers/scsi/oktagon_esp.c               |    1 +
 drivers/scsi/pas16.c                     |    1 +
 drivers/scsi/pluto.c                     |    1 +
 drivers/scsi/psi240i.c                   |    1 +
 drivers/scsi/seagate.c                   |    1 +
 drivers/scsi/sgiwd93.c                   |    1 +
 drivers/scsi/sun3_scsi.c                 |    1 +
 drivers/scsi/sun3_scsi_vme.c             |    1 +
 drivers/scsi/sun3x_esp.c                 |    1 +
 drivers/scsi/sym53c416.c                 |    1 +
 drivers/scsi/t128.c                      |    1 +
 drivers/scsi/u14-34f.c                   |    1 +
 drivers/scsi/ultrastor.c                 |    1 +
 drivers/scsi/wd7000.c                    |    1 +
 53 files changed, 53 insertions(+)

Index: linux-2.6/drivers/scsi/a100u2w.c
===================================================================
--- linux-2.6.orig/drivers/scsi/a100u2w.c
+++ linux-2.6/drivers/scsi/a100u2w.c
@@ -1027,6 +1027,7 @@ static irqreturn_t inia100_intr(int irqn
 }
 
 static struct scsi_host_template inia100_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "inia100",
 	.name			= inia100_REVID,
 	.queuecommand		= inia100_queue,
Index: linux-2.6/drivers/scsi/a2091.c
===================================================================
--- linux-2.6.orig/drivers/scsi/a2091.c
+++ linux-2.6/drivers/scsi/a2091.c
@@ -233,6 +233,7 @@ static int a2091_bus_reset(struct scsi_c
 #define HOSTS_C
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "A2901",
 	.name			= "Commodore A2091/A590 SCSI",
 	.detect			= a2091_detect,
Index: linux-2.6/drivers/scsi/a3000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/a3000.c
+++ linux-2.6/drivers/scsi/a3000.c
@@ -221,6 +221,7 @@ static int a3000_bus_reset(struct scsi_c
 #define HOSTS_C
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "A3000",
 	.name			= "Amiga 3000 built-in SCSI",
 	.detect			= a3000_detect,
Index: linux-2.6/drivers/scsi/advansys.c
===================================================================
--- linux-2.6.orig/drivers/scsi/advansys.c
+++ linux-2.6/drivers/scsi/advansys.c
@@ -5955,6 +5955,7 @@ advansys_setup(char *str, int *ints)
  */
 
 static struct scsi_host_template driver_template = {
+    .module			= THIS_MODULE,
     .proc_name                  = "advansys",
 #ifdef CONFIG_PROC_FS
     .proc_info                  = advansys_proc_info,
Index: linux-2.6/drivers/scsi/aha1542.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aha1542.c
+++ linux-2.6/drivers/scsi/aha1542.c
@@ -1784,6 +1784,7 @@ MODULE_LICENSE("GPL");
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",
 	.detect			= aha1542_detect,
Index: linux-2.6/drivers/scsi/aic7xxx_old.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx_old.c
+++ linux-2.6/drivers/scsi/aic7xxx_old.c
@@ -11154,6 +11154,7 @@ MODULE_VERSION(AIC7XXX_H_VERSION);
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_info		= aic7xxx_proc_info,
 	.detect			= aic7xxx_detect,
 	.release		= aic7xxx_release,
Index: linux-2.6/drivers/scsi/amiga7xx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/amiga7xx.c
+++ linux-2.6/drivers/scsi/amiga7xx.c
@@ -121,6 +121,7 @@ static int amiga7xx_release(struct Scsi_
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "Amiga NCR53c710 SCSI",
 	.detect			= amiga7xx_detect,
 	.release		= amiga7xx_release,
Index: linux-2.6/drivers/scsi/atari_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/atari_scsi.c
+++ linux-2.6/drivers/scsi/atari_scsi.c
@@ -1140,6 +1140,7 @@ static void atari_scsi_falcon_reg_write(
 #include "atari_NCR5380.c"
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_info		= atari_scsi_proc_info,
 	.name			= "Atari native SCSI",
 	.detect			= atari_scsi_detect,
Index: linux-2.6/drivers/scsi/blz1230.c
===================================================================
--- linux-2.6.orig/drivers/scsi/blz1230.c
+++ linux-2.6/drivers/scsi/blz1230.c
@@ -330,6 +330,7 @@ int blz1230_esp_release(struct Scsi_Host
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "esp-blz1230",
 	.proc_info		= esp_proc_info,
 	.name			= "Blizzard1230 SCSI IV",
Index: linux-2.6/drivers/scsi/blz2060.c
===================================================================
--- linux-2.6.orig/drivers/scsi/blz2060.c
+++ linux-2.6/drivers/scsi/blz2060.c
@@ -283,6 +283,7 @@ int blz2060_esp_release(struct Scsi_Host
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "esp-blz2060",
 	.proc_info		= esp_proc_info,
 	.name			= "Blizzard2060 SCSI",
Index: linux-2.6/drivers/scsi/bvme6000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/bvme6000.c
+++ linux-2.6/drivers/scsi/bvme6000.c
@@ -59,6 +59,7 @@ static int bvme6000_scsi_release(struct 
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "BVME6000 NCR53c710 SCSI",
 	.detect			= bvme6000_scsi_detect,
 	.release		= bvme6000_scsi_release,
Index: linux-2.6/drivers/scsi/cyberstorm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/cyberstorm.c
+++ linux-2.6/drivers/scsi/cyberstorm.c
@@ -354,6 +354,7 @@ int cyber_esp_release(struct Scsi_Host *
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "esp-cyberstorm",
 	.proc_info		= esp_proc_info,
 	.name			= "CyberStorm SCSI",
Index: linux-2.6/drivers/scsi/cyberstormII.c
===================================================================
--- linux-2.6.orig/drivers/scsi/cyberstormII.c
+++ linux-2.6/drivers/scsi/cyberstormII.c
@@ -291,6 +291,7 @@ int cyberII_esp_release(struct Scsi_Host
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "esp-cyberstormII",
 	.proc_info		= esp_proc_info,
 	.name			= "CyberStorm Mk II SCSI",
Index: linux-2.6/drivers/scsi/dmx3191d.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dmx3191d.c
+++ linux-2.6/drivers/scsi/dmx3191d.c
@@ -56,6 +56,7 @@
 
 
 static struct scsi_host_template dmx3191d_driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= DMX3191D_DRIVER_NAME,
 	.name			= "Domex DMX3191D",
 	.queuecommand		= NCR5380_queue_command,
Index: linux-2.6/drivers/scsi/dpt_i2o.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dpt_i2o.c
+++ linux-2.6/drivers/scsi/dpt_i2o.c
@@ -3345,6 +3345,7 @@ static static void adpt_delay(int millis
 #endif
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
Index: linux-2.6/drivers/scsi/dtc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dtc.c
+++ linux-2.6/drivers/scsi/dtc.c
@@ -471,6 +471,7 @@ static int dtc_release(struct Scsi_Host 
 }
 
 static struct scsi_host_template driver_template = {
+	.module				= THIS_MODULE,
 	.name				= "DTC 3180/3280 ",
 	.detect				= dtc_detect,
 	.release			= dtc_release,
Index: linux-2.6/drivers/scsi/eata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata.c
+++ linux-2.6/drivers/scsi/eata.c
@@ -513,6 +513,7 @@ static int eata2x_bios_param(struct scsi
 static int eata2x_slave_configure(struct scsi_device *);
 
 static struct scsi_host_template driver_template = {
+	.module = THIS_MODULE,
 	.name = "EATA/DMA 2.0x rev. 8.10.00 ",
 	.detect = eata2x_detect,
 	.release = eata2x_release,
Index: linux-2.6/drivers/scsi/eata_pio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata_pio.c
+++ linux-2.6/drivers/scsi/eata_pio.c
@@ -998,6 +998,7 @@ static int eata_pio_detect(struct scsi_h
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "eata_pio",
 	.name              	= "EATA (Extended Attachment) PIO driver",
 	.proc_info         	= eata_pio_proc_info,
Index: linux-2.6/drivers/scsi/fastlane.c
===================================================================
--- linux-2.6.orig/drivers/scsi/fastlane.c
+++ linux-2.6/drivers/scsi/fastlane.c
@@ -399,6 +399,7 @@ int fastlane_esp_release(struct Scsi_Hos
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "esp-fastlane",
 	.proc_info		= esp_proc_info,
 	.name			= "Fastlane SCSI",
Index: linux-2.6/drivers/scsi/fcal.c
===================================================================
--- linux-2.6.orig/drivers/scsi/fcal.c
+++ linux-2.6/drivers/scsi/fcal.c
@@ -296,6 +296,7 @@ static int fcal_encode_addr(Scsi_Cmnd *S
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "Fibre Channel Arbitrated Loop",
 	.detect			= fcal_detect,
 	.release		= fcal_release,	
Index: linux-2.6/drivers/scsi/fd_mcs.c
===================================================================
--- linux-2.6.orig/drivers/scsi/fd_mcs.c
+++ linux-2.6/drivers/scsi/fd_mcs.c
@@ -1346,6 +1346,7 @@ static int fd_mcs_biosparam(struct scsi_
 }
 
 static struct scsi_host_template driver_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "fd_mcs",
 	.proc_info			= fd_mcs_proc_info,
 	.detect				= fd_mcs_detect,
Index: linux-2.6/drivers/scsi/g_NCR5380.c
===================================================================
--- linux-2.6.orig/drivers/scsi/g_NCR5380.c
+++ linux-2.6/drivers/scsi/g_NCR5380.c
@@ -910,6 +910,7 @@ static int generic_NCR5380_proc_info(str
 #undef ANDP
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_info      	= generic_NCR5380_proc_info,
 	.name           	= "Generic NCR5380/NCR53C400 Scsi Driver",
 	.detect         	= generic_NCR5380_detect,
Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c
+++ linux-2.6/drivers/scsi/gdth.c
@@ -5647,6 +5647,7 @@ static struct scsi_host_template driver_
 #else
 static Scsi_Host_Template driver_template = {
 #endif
+	.module			= THIS_MODULE,
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
Index: linux-2.6/drivers/scsi/gvp11.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gvp11.c
+++ linux-2.6/drivers/scsi/gvp11.c
@@ -361,6 +361,7 @@ static int gvp11_bus_reset(struct scsi_c
 #include "gvp11.h"
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "GVP11",
 	.name			= "GVP Series II SCSI",
 	.detect			= gvp11_detect,
Index: linux-2.6/drivers/scsi/ibmmca.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ibmmca.c
+++ linux-2.6/drivers/scsi/ibmmca.c
@@ -2489,6 +2489,7 @@ static int option_setup(char *str)
 __setup("ibmmcascsi=", option_setup);
 
 static struct scsi_host_template driver_template = {
+	  .module	  = THIS_MODULE,
           .proc_name      = "ibmmca",
 	  .proc_info	  = ibmmca_proc_info,
           .name           = "IBM SCSI-Subsystem",
Index: linux-2.6/drivers/scsi/in2000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/in2000.c
+++ linux-2.6/drivers/scsi/in2000.c
@@ -2318,6 +2318,7 @@ MODULE_LICENSE("GPL");
 
 
 static struct scsi_host_template driver_template = {
+	.module				= THIS_MODULE,
 	.proc_name       		= "in2000",
 	.proc_info       		= in2000_proc_info,
 	.name            		= "Always IN2000",
Index: linux-2.6/drivers/scsi/initio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/initio.c
+++ linux-2.6/drivers/scsi/initio.c
@@ -3155,6 +3155,7 @@ static int i91u_release(struct Scsi_Host
 MODULE_LICENSE("Dual BSD/GPL");
 
 static struct scsi_host_template driver_template = {
+	.module		= THIS_MODULE,
 	.proc_name	= "INI9100U",
 	.name		= i91u_REVID,
 	.detect		= i91u_detect,
Index: linux-2.6/drivers/scsi/ips.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ips.c
+++ linux-2.6/drivers/scsi/ips.c
@@ -374,6 +374,7 @@ static dma_addr_t ips_flashbusaddr;
 static long ips_FlashDataInUse;		/* CD Boot - Flash Data In Use Flag */
 static uint32_t MaxLiteCmds = 32;	/* Max Active Cmds for a Lite Adapter */
 static struct scsi_host_template ips_driver_template = {
+	.module			= THIS_MODULE,
 	.detect			= ips_detect,
 	.release		= ips_release,
 	.info			= ips_info,
Index: linux-2.6/drivers/scsi/iscsi_tcp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/iscsi_tcp.c
+++ linux-2.6/drivers/scsi/iscsi_tcp.c
@@ -2133,6 +2133,7 @@ static void iscsi_tcp_session_destroy(st
 }
 
 static struct scsi_host_template iscsi_sht = {
+	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
Index: linux-2.6/drivers/scsi/jazz_esp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/jazz_esp.c
+++ linux-2.6/drivers/scsi/jazz_esp.c
@@ -287,6 +287,7 @@ static void dma_led_on(struct NCR_ESP *e
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "jazz_esp",
 	.proc_info		= esp_proc_info,
 	.name			= "ESP 100/100a/200",
Index: linux-2.6/drivers/scsi/mac53c94.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mac53c94.c
+++ linux-2.6/drivers/scsi/mac53c94.c
@@ -413,6 +413,7 @@ static void set_dma_cmds(struct fsc_stat
 }
 
 static struct scsi_host_template mac53c94_template = {
+	.module		= THIS_MODULE,
 	.proc_name	= "53c94",
 	.name		= "53C94",
 	.queuecommand	= mac53c94_queue,
Index: linux-2.6/drivers/scsi/mac_esp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mac_esp.c
+++ linux-2.6/drivers/scsi/mac_esp.c
@@ -728,6 +728,7 @@ static void dma_setup_quick(struct NCR_E
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "mac_esp",
 	.name			= "Mac 53C9x SCSI",
 	.detect			= mac_esp_detect,
Index: linux-2.6/drivers/scsi/mac_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mac_scsi.c
+++ linux-2.6/drivers/scsi/mac_scsi.c
@@ -578,6 +578,7 @@ static int macscsi_pwrite (struct Scsi_H
 #include "NCR5380.c"
 
 static struct scsi_host_template driver_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "Mac5380",
 	.proc_info			= macscsi_proc_info,
 	.name				= "Macintosh NCR5380 SCSI",
Index: linux-2.6/drivers/scsi/mca_53c9x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mca_53c9x.c
+++ linux-2.6/drivers/scsi/mca_53c9x.c
@@ -445,6 +445,7 @@ static void dma_led_off(struct NCR_ESP *
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "mca_53c9x",
 	.name			= "NCR 53c9x SCSI",
 	.detect			= mca_esp_detect,
Index: linux-2.6/drivers/scsi/mesh.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mesh.c
+++ linux-2.6/drivers/scsi/mesh.c
@@ -1841,6 +1841,7 @@ static int mesh_shutdown(struct macio_de
 }
 
 static struct scsi_host_template mesh_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "mesh",
 	.name				= "MESH",
 	.queuecommand			= mesh_queue,
Index: linux-2.6/drivers/scsi/mvme147.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mvme147.c
+++ linux-2.6/drivers/scsi/mvme147.c
@@ -130,6 +130,7 @@ static int mvme147_bus_reset(struct scsi
 #include "mvme147.h"
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
 	.detect			= mvme147_detect,
Index: linux-2.6/drivers/scsi/mvme16x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mvme16x.c
+++ linux-2.6/drivers/scsi/mvme16x.c
@@ -61,6 +61,7 @@ static int mvme16x_scsi_release(struct S
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "MVME16x NCR53c710 SCSI",
 	.detect			= mvme16x_scsi_detect,
 	.release		= mvme16x_scsi_release,
Index: linux-2.6/drivers/scsi/nsp32.c
===================================================================
--- linux-2.6.orig/drivers/scsi/nsp32.c
+++ linux-2.6/drivers/scsi/nsp32.c
@@ -282,6 +282,7 @@ static void nsp32_dmessage(const char *,
  * max_sectors is currently limited up to 128.
  */
 static struct scsi_host_template nsp32_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
 	.proc_info			= nsp32_proc_info,
Index: linux-2.6/drivers/scsi/oktagon_esp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/oktagon_esp.c
+++ linux-2.6/drivers/scsi/oktagon_esp.c
@@ -585,6 +585,7 @@ int oktagon_esp_release(struct Scsi_Host
 
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "esp-oktagon",
 	.proc_info		= &esp_proc_info,
 	.name			= "BSC Oktagon SCSI",
Index: linux-2.6/drivers/scsi/pas16.c
===================================================================
--- linux-2.6.orig/drivers/scsi/pas16.c
+++ linux-2.6/drivers/scsi/pas16.c
@@ -615,6 +615,7 @@ static int pas16_release(struct Scsi_Hos
 }
 
 static struct scsi_host_template driver_template = {
+	.module		= THIS_MODULE,
 	.name           = "Pro Audio Spectrum-16 SCSI",
 	.detect         = pas16_detect,
 	.release        = pas16_release,
Index: linux-2.6/drivers/scsi/pluto.c
===================================================================
--- linux-2.6.orig/drivers/scsi/pluto.c
+++ linux-2.6/drivers/scsi/pluto.c
@@ -340,6 +340,7 @@ static int pluto_encode_addr(Scsi_Cmnd *
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "Sparc Storage Array 100/200",
 	.detect			= pluto_detect,
 	.release		= pluto_release,
Index: linux-2.6/drivers/scsi/psi240i.c
===================================================================
--- linux-2.6.orig/drivers/scsi/psi240i.c
+++ linux-2.6/drivers/scsi/psi240i.c
@@ -674,6 +674,7 @@ static int Psi240i_BiosParam (struct scs
 MODULE_LICENSE("GPL");
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "psi240i", 
 	.name			= "PSI-240I EIDE Disk Controller",
 	.detect			= Psi240i_Detect,
Index: linux-2.6/drivers/scsi/seagate.c
===================================================================
--- linux-2.6.orig/drivers/scsi/seagate.c
+++ linux-2.6/drivers/scsi/seagate.c
@@ -1652,6 +1652,7 @@ static int seagate_st0x_release(struct S
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.detect         	= seagate_st0x_detect,
 	.release        	= seagate_st0x_release,
 	.info           	= seagate_st0x_info,
Index: linux-2.6/drivers/scsi/sgiwd93.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sgiwd93.c
+++ linux-2.6/drivers/scsi/sgiwd93.c
@@ -326,6 +326,7 @@ static int sgiwd93_bus_reset(struct scsi
  * on 64-bit systems with memory outside the compat address spaces.
  */
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "SGIWD93",
 	.name			= "SGI WD93",
 	.detect			= sgiwd93_detect,
Index: linux-2.6/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sun3_scsi.c
+++ linux-2.6/drivers/scsi/sun3_scsi.c
@@ -622,6 +622,7 @@ static int sun3scsi_dma_finish(int write
 #include "sun3_NCR5380.c"
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= SUN3_SCSI_NAME,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
Index: linux-2.6/drivers/scsi/sun3_scsi_vme.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sun3_scsi_vme.c
+++ linux-2.6/drivers/scsi/sun3_scsi_vme.c
@@ -565,6 +565,7 @@ static int sun3scsi_dma_finish(int write
 #include "sun3_NCR5380.c"
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= SUN3_SCSI_NAME,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
Index: linux-2.6/drivers/scsi/sun3x_esp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sun3x_esp.c
+++ linux-2.6/drivers/scsi/sun3x_esp.c
@@ -368,6 +368,7 @@ static int sun3x_esp_release(struct Scsi
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "sun3x_esp",
 	.proc_info		= &esp_proc_info,
 	.name			= "Sun ESP 100/100a/200",
Index: linux-2.6/drivers/scsi/sym53c416.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sym53c416.c
+++ linux-2.6/drivers/scsi/sym53c416.c
@@ -848,6 +848,7 @@ module_param_array(sym53c416_3, uint, NU
 #endif
 
 static struct scsi_host_template driver_template = {
+	.module =		THIS_MODULE,
 	.proc_name =		"sym53c416",
 	.name =			"Symbios Logic 53c416",
 	.detect =		sym53c416_detect,
Index: linux-2.6/drivers/scsi/t128.c
===================================================================
--- linux-2.6.orig/drivers/scsi/t128.c
+++ linux-2.6/drivers/scsi/t128.c
@@ -430,6 +430,7 @@ MODULE_LICENSE("GPL");
 #include "NCR5380.c"
 
 static struct scsi_host_template driver_template = {
+	.module		= THIS_MODULE,
 	.name           = "Trantor T128/T128F/T228",
 	.detect         = t128_detect,
 	.release        = t128_release,
Index: linux-2.6/drivers/scsi/u14-34f.c
===================================================================
--- linux-2.6.orig/drivers/scsi/u14-34f.c
+++ linux-2.6/drivers/scsi/u14-34f.c
@@ -440,6 +440,7 @@ static int u14_34f_bios_param(struct scs
 static int u14_34f_slave_configure(struct scsi_device *);
 
 static struct scsi_host_template driver_template = {
+		.module			 = THIS_MODULE,
                 .name                    = "UltraStor 14F/34F rev. 8.10.00 ",
                 .detect                  = u14_34f_detect,
                 .release                 = u14_34f_release,
Index: linux-2.6/drivers/scsi/ultrastor.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ultrastor.c
+++ linux-2.6/drivers/scsi/ultrastor.c
@@ -1185,6 +1185,7 @@ static irqreturn_t do_ultrastor_interrup
 MODULE_LICENSE("GPL");
 
 static struct scsi_host_template driver_template = {
+	.module		   = THIS_MODULE,
 	.name              = "UltraStor 14F/24F/34F",
 	.detect            = ultrastor_detect,
 	.release	   = ultrastor_release,
Index: linux-2.6/drivers/scsi/wd7000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/wd7000.c
+++ linux-2.6/drivers/scsi/wd7000.c
@@ -1655,6 +1655,7 @@ MODULE_DESCRIPTION("Driver for the WD700
 MODULE_LICENSE("GPL");
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "wd7000",
 	.proc_info		= wd7000_proc_info,
 	.name			= "Western Digital WD-7000",
Index: linux-2.6/drivers/infiniband/ulp/iser/iscsi_iser.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -543,6 +543,7 @@ iscsi_iser_ep_disconnect(__u64 ep_handle
 }
 
 static struct scsi_host_template iscsi_iser_sht = {
+	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
 	.queuecommand           = iscsi_queuecommand,
 	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,

-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
