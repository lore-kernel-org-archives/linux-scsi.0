From: Jamie Lenehan <lenehan@twibble.org>
Subject: [2.6 patch] SCSI dc395x.c: Fix type for irq and io ports
Date: Tue, 16 Nov 2004 07:28:53 +1100
Message-ID: <20041115202853.GA26952@twibble.org>
References: <20041115015609.GG2249@stusta.de> <20041115202231.GA26873@twibble.org> <20041115202633.GA26928@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nynaeve.twibble.org ([202.173.155.194]:3481 "EHLO
	nynaeve.twibble.org") by vger.kernel.org with ESMTP id S261688AbUKOU2z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:28:55 -0500
Content-Disposition: inline
In-Reply-To: <20041115202633.GA26928@twibble.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Store the port and irq in unsigned long and unsigned int's instead of
as u16's and u8's. The later was fine on x86 but not on sparc64.

Signed-off-by: Jamie Lenehan <lenehan@twibble.org>

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-06-30 20:11:42.631830402 +1000
+++ b/drivers/scsi/dc395x.c	2004-06-30 20:11:49.038417547 +1000
@@ -295,8 +295,8 @@
 struct AdapterCtlBlk {
 	struct Scsi_Host *scsi_host;
 
-	u16 io_port_base;
-	u16 io_port_len;
+	unsigned long io_port_base;
+	unsigned long io_port_len;
 
 	struct list_head dcb_list;		/* head of going dcb list */
 	struct DeviceCtlBlk *dcb_run_robin;
@@ -311,7 +311,7 @@
 
 	u8 sel_timeout;
 
-	u8 irq_level;
+	unsigned int irq_level;
 	u8 tag_max_num;
 	u8 acb_flag;
 	u8 gmode2;
@@ -3931,7 +3931,7 @@
  *
  * @io_port: base I/O address
  **/
-static void __init trms1040_wait_30us(u16 io_port)
+static void __init trms1040_wait_30us(unsigned long io_port)
 {
 	/* ScsiPortStallExecution(30); wait 30 us */
 	outb(5, io_port + TRM_S1040_GEN_TIMER);
@@ -3948,7 +3948,7 @@
  * @cmd:	SB + op code (command) to send
  * @addr:	address to send
  **/
-static void __init trms1040_write_cmd(u16 io_port, u8 cmd, u8 addr)
+static void __init trms1040_write_cmd(unsigned long io_port, u8 cmd, u8 addr)
 {
 	int i;
 	u8 send_data;
@@ -3993,7 +3993,7 @@
  * @addr:	offset into EEPROM
  * @byte:	bytes to write
  **/
-static void __init trms1040_set_data(u16 io_port, u8 addr, u8 byte)
+static void __init trms1040_set_data(unsigned long io_port, u8 addr, u8 byte)
 {
 	int i;
 	u8 send_data;
@@ -4047,7 +4047,7 @@
  * @eeprom:	the data to write
  * @io_port:	the base io port
  **/
-static void __init trms1040_write_all(struct NvRamType *eeprom, u16 io_port)
+static void __init trms1040_write_all(struct NvRamType *eeprom, unsigned long io_port)
 {
 	u8 *b_eeprom = (u8 *)eeprom;
 	u8 addr;
@@ -4087,7 +4087,7 @@
  *
  * Returns the the byte read.
  **/
-static u8 __init trms1040_get_data(u16 io_port, u8 addr)
+static u8 __init trms1040_get_data(unsigned long io_port, u8 addr)
 {
 	int i;
 	u8 read_byte;
@@ -4125,7 +4125,7 @@
  * @eeprom:	where to store the data
  * @io_port:	the base io port
  **/
-static void __init trms1040_read_all(struct NvRamType *eeprom, u16 io_port)
+static void __init trms1040_read_all(struct NvRamType *eeprom, unsigned long io_port)
 {
 	u8 *b_eeprom = (u8 *)eeprom;
 	u8 addr;
@@ -4155,7 +4155,7 @@
  * @eeprom:	caller allocated strcuture to read the eeprom data into
  * @io_port:	io port to read from
  **/
-static void __init check_eeprom(struct NvRamType *eeprom, u16 io_port)
+static void __init check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
 {
 	u16 *w_eeprom = (u16 *)eeprom;
 	u16 w_addr;
@@ -4500,11 +4500,11 @@
  * Returns 0 if the initialization succeeds, any other value on
  * failure.
  **/
-static int __init adapter_init(struct AdapterCtlBlk *acb, u32 io_port,
-		u32 io_port_len, u8 irq)
+static int __init adapter_init(struct AdapterCtlBlk *acb,
+	unsigned long io_port, u32 io_port_len, unsigned int irq)
 {
 	if (!request_region(io_port, io_port_len, DC395X_NAME)) {
-		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%x\n", io_port);
+		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%lx\n", io_port);
 		goto failed;
 	}
 	/* store port base to indicate we have registered it */
@@ -4520,7 +4520,7 @@
 	acb->irq_level = irq;
 
 	/* get eeprom configuration information and command line settings etc */
-	check_eeprom(&acb->eeprom, (u16)io_port);
+	check_eeprom(&acb->eeprom, io_port);
  	print_eeprom_settings(&acb->eeprom);
 
 	/* setup adapter control block */	
@@ -4638,8 +4638,8 @@
 	SPRINTF("SCSI Host Nr %i, ", host->host_no);
 	SPRINTF("DC395U/UW/F DC315/U %s\n",
 		(acb->config & HCC_WIDE_CARD) ? "Wide" : "");
-	SPRINTF("io_port_base 0x%04x, ", acb->io_port_base);
-	SPRINTF("irq_level 0x%02x, ", acb->irq_level);
+	SPRINTF("io_port_base 0x%04lx, ", acb->io_port_base);
+	SPRINTF("irq_level 0x%04x, ", acb->irq_level);
 	SPRINTF(" SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
 
 	SPRINTF("MaxID %i, MaxLUN %i, ", host->max_id, host->max_lun);
@@ -4794,9 +4794,9 @@
 {
 	struct Scsi_Host *scsi_host;
 	struct AdapterCtlBlk *acb;
-	unsigned int io_port_base;
+	unsigned long io_port_base;
 	unsigned int io_port_len;
-	u8 irq;
+	unsigned int irq;
 	
 	dprintkdbg(DBG_0, "Init one instance (%s)\n", pci_name(dev));
 	banner_display();
@@ -4809,7 +4809,7 @@
 	io_port_base = pci_resource_start(dev, 0) & PCI_BASE_ADDRESS_IO_MASK;
 	io_port_len = pci_resource_len(dev, 0);
 	irq = dev->irq;
-	dprintkdbg(DBG_0, "IO_PORT=%04x, IRQ=%x\n", io_port_base, dev->irq);
+	dprintkdbg(DBG_0, "IO_PORT=0x%04lx, IRQ=0x%x\n", io_port_base, dev->irq);
 
 	/* allocate scsi host information (includes out adapter) */
 	scsi_host = scsi_host_alloc(&dc395x_driver_template,

-- 
 Jamie Lenehan <lenehan@twibble.org>
