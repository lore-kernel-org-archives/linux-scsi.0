From: "Randy.Dunlap" <randy.dunlap@verizon.net>
Subject: [PATCH] dc395x: fix section references
Date: Sun, 27 Feb 2005 20:28:56 -0800
Message-ID: <20050227202856.0a4fc418.randy.dunlap@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from vms048pub.verizon.net ([206.46.252.48]:29926 "EHLO
	vms048pub.verizon.net") by vger.kernel.org with ESMTP
	id S261553AbVB1EkG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Feb 2005 23:40:06 -0500
Received: from midway.verizon.net ([4.5.49.23])
 by vms048.mailsrvcs.net (Sun Java System Messaging Server 6.2 HotFix 0.04
 (built Dec 24 2004)) with ESMTPA id <0ICL0039EUAMWAV0@vms048.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Sun, 27 Feb 2005 22:40:00 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, torvalds <torvalds@osdl.org>, akpm <akpm@osdl.org>
Cc: oliver@neukum.name, aliakc@web.de, lenehan@twibble.org, jejb <james.bottomley@steeleye.com>


dc395x scsi driver makes many references to __init functions &
__initdata that should be __devinit & __devinitdata.

Error: ./drivers/scsi/dc395x.o .text refers to 00000000000021ef R_X86_64_PC32     .init.text+0x00000000000000b4
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000220e R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000222e R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000022f4 R_X86_64_PC32     .init.text+0x0000000000000177
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002301 R_X86_64_32S      .init.data
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002307 R_X86_64_32S      .init.data+0x0000000000000004
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000230f R_X86_64_32S      .init.data+0x0000000000000008
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002317 R_X86_64_32S      .init.data+0x000000000000000c
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000231d R_X86_64_32S      .init.data
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000232d R_X86_64_PC32     .init.text+0xfffffffffffffffc
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000237a R_X86_64_PC32     .init.text+0x00000000000000b4
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000238c R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000023ac R_X86_64_PC32     .init.text+0x00000000000000b4
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000023d6 R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000023e6 R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000023fe R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000240b R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002418 R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000242f R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 000000000000243f R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002469 R_X86_64_PC32     .init.text+0x00000000000000b4
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002476 R_X86_64_PC32     .init.text+0x000000000000009c
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002489 R_X86_64_PC32     .init.data+0x0000000000000060
Error: ./drivers/scsi/dc395x.o .text refers to 0000000000002494 R_X86_64_PC32     .init.text+0x0000000000000177
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000024a3 R_X86_64_32S      .init.data+0x0000000000000078
Error: ./drivers/scsi/dc395x.o .text refers to 00000000000024ac R_X86_64_PC32     .init.text+0xfffffffffffffffc

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/dc395x.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff -Naurp ./drivers/scsi/dc395x.c~dc395x_sections ./drivers/scsi/dc395x.c
--- ./drivers/scsi/dc395x.c~dc395x_sections	2004-12-24 13:34:00.000000000 -0800
+++ ./drivers/scsi/dc395x.c	2005-02-27 20:30:11.539816904 -0800
@@ -488,7 +488,7 @@ struct ParameterData {
 	int def;		/* default value */
 	int safe;		/* safe value */
 };
-static struct ParameterData __initdata cfg_data[] = {
+static struct ParameterData __devinitdata cfg_data[] = {
 	{ /* adapter id */
 		CFG_PARAM_UNSET,
 		0,
@@ -573,7 +573,7 @@ MODULE_PARM_DESC(reset_delay, "Reset del
  * set_safe_settings - if the use_safe_settings option is set then
  * set all values to the safe and slow values.
  **/
-static void __init set_safe_settings(void)
+static void __devinit set_safe_settings(void)
 {
 	if (use_safe_settings)
 	{
@@ -592,7 +592,7 @@ static void __init set_safe_settings(voi
  * fix_settings - reset any boot parameters which are out of range
  * back to the default values.
  **/
-static void __init fix_settings(void)
+static void __devinit fix_settings(void)
 {
 	int i;
 
@@ -619,7 +619,7 @@ static void __init fix_settings(void)
  * Mapping from the eeprom delay index value (index into this array)
  * to the the number of actual seconds that the delay should be for.
  */
-static char __initdata eeprom_index_to_delay_map[] = 
+static char __devinitdata eeprom_index_to_delay_map[] = 
 	{ 1, 3, 5, 10, 16, 30, 60, 120 };
 
 
@@ -629,7 +629,7 @@ static char __initdata eeprom_index_to_d
  *
  * @eeprom: The eeprom structure in which we find the delay index to map.
  **/
-static void __init eeprom_index_to_delay(struct NvRamType *eeprom)
+static void __devinit eeprom_index_to_delay(struct NvRamType *eeprom)
 {
 	eeprom->delay_time = eeprom_index_to_delay_map[eeprom->delay_time];
 }
@@ -642,7 +642,7 @@ static void __init eeprom_index_to_delay
  *
  * @delay: The delay, in seconds, to find the eeprom index for.
  **/
-static int __init delay_to_eeprom_index(int delay)
+static int __devinit delay_to_eeprom_index(int delay)
 {
 	u8 idx = 0;
 	while (idx < 7 && eeprom_index_to_delay_map[idx] < delay)
@@ -658,7 +658,7 @@ static int __init delay_to_eeprom_index(
  *
  * @eeprom: The eeprom data to override with command line options.
  **/
-static void __init eeprom_override(struct NvRamType *eeprom)
+static void __devinit eeprom_override(struct NvRamType *eeprom)
 {
 	u8 id;
 
@@ -3931,7 +3931,7 @@ static void dc395x_slave_destroy(struct 
  *
  * @io_port: base I/O address
  **/
-static void __init trms1040_wait_30us(unsigned long io_port)
+static void __devinit trms1040_wait_30us(unsigned long io_port)
 {
 	/* ScsiPortStallExecution(30); wait 30 us */
 	outb(5, io_port + TRM_S1040_GEN_TIMER);
@@ -3948,7 +3948,7 @@ static void __init trms1040_wait_30us(un
  * @cmd:	SB + op code (command) to send
  * @addr:	address to send
  **/
-static void __init trms1040_write_cmd(unsigned long io_port, u8 cmd, u8 addr)
+static void __devinit trms1040_write_cmd(unsigned long io_port, u8 cmd, u8 addr)
 {
 	int i;
 	u8 send_data;
@@ -3993,7 +3993,7 @@ static void __init trms1040_write_cmd(un
  * @addr:	offset into EEPROM
  * @byte:	bytes to write
  **/
-static void __init trms1040_set_data(unsigned long io_port, u8 addr, u8 byte)
+static void __devinit trms1040_set_data(unsigned long io_port, u8 addr, u8 byte)
 {
 	int i;
 	u8 send_data;
@@ -4047,7 +4047,7 @@ static void __init trms1040_set_data(uns
  * @eeprom:	the data to write
  * @io_port:	the base io port
  **/
-static void __init trms1040_write_all(struct NvRamType *eeprom, unsigned long io_port)
+static void __devinit trms1040_write_all(struct NvRamType *eeprom, unsigned long io_port)
 {
 	u8 *b_eeprom = (u8 *)eeprom;
 	u8 addr;
@@ -4087,7 +4087,7 @@ static void __init trms1040_write_all(st
  *
  * Returns the the byte read.
  **/
-static u8 __init trms1040_get_data(unsigned long io_port, u8 addr)
+static u8 __devinit trms1040_get_data(unsigned long io_port, u8 addr)
 {
 	int i;
 	u8 read_byte;
@@ -4125,7 +4125,7 @@ static u8 __init trms1040_get_data(unsig
  * @eeprom:	where to store the data
  * @io_port:	the base io port
  **/
-static void __init trms1040_read_all(struct NvRamType *eeprom, unsigned long io_port)
+static void __devinit trms1040_read_all(struct NvRamType *eeprom, unsigned long io_port)
 {
 	u8 *b_eeprom = (u8 *)eeprom;
 	u8 addr;
@@ -4155,7 +4155,7 @@ static void __init trms1040_read_all(str
  * @eeprom:	caller allocated strcuture to read the eeprom data into
  * @io_port:	io port to read from
  **/
-static void __init check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
+static void __devinit check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
 {
 	u16 *w_eeprom = (u16 *)eeprom;
 	u16 w_addr;
@@ -4225,7 +4225,7 @@ static void __init check_eeprom(struct N
  *
  * @eeprom: The eeprom data strucutre to show details for.
  **/
-static void __init print_eeprom_settings(struct NvRamType *eeprom)
+static void __devinit print_eeprom_settings(struct NvRamType *eeprom)
 {
 	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), dev_mode=0x%02x\n",
 		eeprom->scsi_id,
@@ -4254,7 +4254,7 @@ static void adapter_sg_tables_free(struc
 /*
  * Allocate SG tables; as we have to pci_map them, an SG list (struct SGentry*)
  * should never cross a page boundary */
-static int __init adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
+static int __devinit adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
 {
 	const unsigned mem_needed = (DC395x_MAX_SRB_CNT+1)
 	                            *SEGMENTX_LEN;
@@ -4300,7 +4300,7 @@ static int __init adapter_sg_tables_allo
  *
  * @acb: The adapter to print the information for.
  **/
-static void __init adapter_print_config(struct AdapterCtlBlk *acb)
+static void __devinit adapter_print_config(struct AdapterCtlBlk *acb)
 {
 	u8 bval;
 
@@ -4344,7 +4344,7 @@ static void __init adapter_print_config(
  *
  * @acb: The adapter to initialize.
  **/
-static void __init adapter_init_params(struct AdapterCtlBlk *acb)
+static void __devinit adapter_init_params(struct AdapterCtlBlk *acb)
 {
 	struct NvRamType *eeprom = &acb->eeprom;
 	int i;
@@ -4406,7 +4406,7 @@ static void __init adapter_init_params(s
  *
  * @host: The scsi host instance to fill in the values for.
  **/
-static void __init adapter_init_scsi_host(struct Scsi_Host *host)
+static void __devinit adapter_init_scsi_host(struct Scsi_Host *host)
 {
         struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
 	struct NvRamType *eeprom = &acb->eeprom;
@@ -4447,7 +4447,7 @@ static void __init adapter_init_scsi_hos
  *
  * @acb: The adapter which we are to init.
  **/
-static void __init adapter_init_chip(struct AdapterCtlBlk *acb)
+static void __devinit adapter_init_chip(struct AdapterCtlBlk *acb)
 {
         struct NvRamType *eeprom = &acb->eeprom;
         
@@ -4500,7 +4500,7 @@ static void __init adapter_init_chip(str
  * Returns 0 if the initialization succeeds, any other value on
  * failure.
  **/
-static int __init adapter_init(struct AdapterCtlBlk *acb,
+static int __devinit adapter_init(struct AdapterCtlBlk *acb,
 	unsigned long io_port, u32 io_port_len, unsigned int irq)
 {
 	if (!request_region(io_port, io_port_len, DC395X_NAME)) {

---
