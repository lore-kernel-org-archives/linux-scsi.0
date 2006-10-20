From: akpm@osdl.org
Subject: [patch 24/45] scsi: convert ninja driver to struct scsi_cmnd
Date: Fri, 20 Oct 2006 14:48:23 -0700
Message-ID: <200610202148.k9KLmN4s004139@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1415 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992804AbWJTVtB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:49:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de, linux@dominikbrodowski.net

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Changes the obsolete typedefd Scsi_Cmnd to struct scsi_cmnd in
the ninja scsi pcmcia driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/pcmcia/nsp_cs.c      |   42 +++++++++++++------------
 drivers/scsi/pcmcia/nsp_cs.h      |   46 +++++++++++++++-------------
 drivers/scsi/pcmcia/nsp_debug.c   |    4 +-
 drivers/scsi/pcmcia/nsp_message.c |    4 +-
 4 files changed, 51 insertions(+), 45 deletions(-)

diff -puN drivers/scsi/pcmcia/nsp_cs.c~scsi-convert-ninja-driver-to-struct-scsi_cmnd drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~scsi-convert-ninja-driver-to-struct-scsi_cmnd
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -183,7 +183,7 @@ static void nsp_cs_dmessage(const char *
  * Clenaup parameters and call done() functions.
  * You must be set SCpnt->result before call this function.
  */
-static void nsp_scsi_done(Scsi_Cmnd *SCpnt)
+static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
@@ -192,7 +192,8 @@ static void nsp_scsi_done(Scsi_Cmnd *SCp
 	SCpnt->scsi_done(SCpnt);
 }
 
-static int nsp_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
+			    void (*done)(struct scsi_cmnd *))
 {
 #ifdef NSP_DEBUG
 	/*unsigned int host_id = SCpnt->device->host->this_id;*/
@@ -365,7 +366,7 @@ static int nsphw_init(nsp_hw_data *data)
 /*
  * Start selection phase
  */
-static int nsphw_start_selection(Scsi_Cmnd *SCpnt)
+static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  host_id	 = SCpnt->device->host->this_id;
 	unsigned int  base	 = SCpnt->device->host->io_port;
@@ -446,7 +447,7 @@ static struct nsp_sync_table nsp_sync_ta
 /*
  * setup synchronous data transfer mode
  */
-static int nsp_analyze_sdtr(Scsi_Cmnd *SCpnt)
+static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
 {
 	unsigned char	       target = scmd_id(SCpnt);
 //	unsigned char	       lun    = SCpnt->device->lun;
@@ -504,7 +505,7 @@ static int nsp_analyze_sdtr(Scsi_Cmnd *S
 /*
  * start ninja hardware timer
  */
-static void nsp_start_timer(Scsi_Cmnd *SCpnt, int time)
+static void nsp_start_timer(struct scsi_cmnd *SCpnt, int time)
 {
 	unsigned int base = SCpnt->device->host->io_port;
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
@@ -517,7 +518,8 @@ static void nsp_start_timer(Scsi_Cmnd *S
 /*
  * wait for bus phase change
  */
-static int nsp_negate_signal(Scsi_Cmnd *SCpnt, unsigned char mask, char *str)
+static int nsp_negate_signal(struct scsi_cmnd *SCpnt, unsigned char mask,
+			     char *str)
 {
 	unsigned int  base = SCpnt->device->host->io_port;
 	unsigned char reg;
@@ -544,9 +546,9 @@ static int nsp_negate_signal(Scsi_Cmnd *
 /*
  * expect Ninja Irq
  */
-static int nsp_expect_signal(Scsi_Cmnd	   *SCpnt,
-			     unsigned char  current_phase,
-			     unsigned char  mask)
+static int nsp_expect_signal(struct scsi_cmnd *SCpnt,
+			     unsigned char current_phase,
+			     unsigned char mask)
 {
 	unsigned int  base	 = SCpnt->device->host->io_port;
 	int	      time_out;
@@ -579,7 +581,7 @@ static int nsp_expect_signal(Scsi_Cmnd	 
 /*
  * transfer SCSI message
  */
-static int nsp_xfer(Scsi_Cmnd *SCpnt, int phase)
+static int nsp_xfer(struct scsi_cmnd *SCpnt, int phase)
 {
 	unsigned int  base = SCpnt->device->host->io_port;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
@@ -619,7 +621,7 @@ static int nsp_xfer(Scsi_Cmnd *SCpnt, in
 /*
  * get extra SCSI data from fifo
  */
-static int nsp_dataphase_bypass(Scsi_Cmnd *SCpnt)
+static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int count;
@@ -651,7 +653,7 @@ static int nsp_dataphase_bypass(Scsi_Cmn
 /*
  * accept reselection
  */
-static int nsp_reselected(Scsi_Cmnd *SCpnt)
+static int nsp_reselected(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  base    = SCpnt->device->host->io_port;
 	unsigned int  host_id = SCpnt->device->host->this_id;
@@ -690,7 +692,7 @@ static int nsp_reselected(Scsi_Cmnd *SCp
 /*
  * count how many data transferd
  */
-static int nsp_fifo_count(Scsi_Cmnd *SCpnt)
+static int nsp_fifo_count(struct scsi_cmnd *SCpnt)
 {
 	unsigned int base = SCpnt->device->host->io_port;
 	unsigned int count;
@@ -717,7 +719,7 @@ static int nsp_fifo_count(Scsi_Cmnd *SCp
 /*
  * read data in DATA IN phase
  */
-static void nsp_pio_read(Scsi_Cmnd *SCpnt)
+static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  base      = SCpnt->device->host->io_port;
 	unsigned long mmio_base = SCpnt->device->host->base;
@@ -812,7 +814,7 @@ static void nsp_pio_read(Scsi_Cmnd *SCpn
 /*
  * write data in DATA OUT phase
  */
-static void nsp_pio_write(Scsi_Cmnd *SCpnt)
+static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  base      = SCpnt->device->host->io_port;
 	unsigned long mmio_base = SCpnt->device->host->base;
@@ -905,7 +907,7 @@ static void nsp_pio_write(Scsi_Cmnd *SCp
 /*
  * setup synchronous/asynchronous data transfer mode
  */
-static int nsp_nexus(Scsi_Cmnd *SCpnt)
+static int nsp_nexus(struct scsi_cmnd *SCpnt)
 {
 	unsigned int   base   = SCpnt->device->host->io_port;
 	unsigned char  target = scmd_id(SCpnt);
@@ -952,7 +954,7 @@ static irqreturn_t nspintr(int irq, void
 {
 	unsigned int   base;
 	unsigned char  irq_status, irq_phase, phase;
-	Scsi_Cmnd     *tmpSC;
+	struct scsi_cmnd *tmpSC;
 	unsigned char  target, lun;
 	unsigned int  *sync_neg;
 	int            i, tmp;
@@ -1530,7 +1532,7 @@ nsp_proc_info(
 /*---------------------------------------------------------------*/
 
 /*
-static int nsp_eh_abort(Scsi_Cmnd *SCpnt)
+static int nsp_eh_abort(struct scsi_cmnd *SCpnt)
 {
 	nsp_dbg(NSP_DEBUG_BUSRESET, "SCpnt=0x%p", SCpnt);
 
@@ -1558,7 +1560,7 @@ static int nsp_bus_reset(nsp_hw_data *da
 	return SUCCESS;
 }
 
-static int nsp_eh_bus_reset(Scsi_Cmnd *SCpnt)
+static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
@@ -1567,7 +1569,7 @@ static int nsp_eh_bus_reset(Scsi_Cmnd *S
 	return nsp_bus_reset(data);
 }
 
-static int nsp_eh_host_reset(Scsi_Cmnd *SCpnt)
+static int nsp_eh_host_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
diff -puN drivers/scsi/pcmcia/nsp_cs.h~scsi-convert-ninja-driver-to-struct-scsi_cmnd drivers/scsi/pcmcia/nsp_cs.h
--- a/drivers/scsi/pcmcia/nsp_cs.h~scsi-convert-ninja-driver-to-struct-scsi_cmnd
+++ a/drivers/scsi/pcmcia/nsp_cs.h
@@ -266,7 +266,7 @@ typedef struct _nsp_hw_data {
 
 	int           TimerCount;
 	int           SelectionTimeOut;
-	Scsi_Cmnd    *CurrentSC;
+	struct scsi_cmnd *CurrentSC;
 	//int           CurrnetTarget;
 
 	int           FifoCount;
@@ -309,30 +309,34 @@ static        int        nsp_proc_info  
 					 off_t   offset,
 					 int     length,
 					 int     inout);
-static        int        nsp_queuecommand(Scsi_Cmnd *SCpnt, void (* done)(Scsi_Cmnd *SCpnt));
+static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
+			    void (* done)(struct scsi_cmnd *SCpnt));
 
 /* Error handler */
-/*static int nsp_eh_abort       (Scsi_Cmnd *SCpnt);*/
-/*static int nsp_eh_device_reset(Scsi_Cmnd *SCpnt);*/
-static int nsp_eh_bus_reset    (Scsi_Cmnd *SCpnt);
-static int nsp_eh_host_reset   (Scsi_Cmnd *SCpnt);
+/*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
+/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
+static int nsp_eh_bus_reset    (struct scsi_cmnd *SCpnt);
+static int nsp_eh_host_reset   (struct scsi_cmnd *SCpnt);
 static int nsp_bus_reset       (nsp_hw_data *data);
 
 /* */
 static int  nsphw_init           (nsp_hw_data *data);
-static int  nsphw_start_selection(Scsi_Cmnd *SCpnt);
-static void nsp_start_timer      (Scsi_Cmnd *SCpnt, int time);
-static int  nsp_fifo_count       (Scsi_Cmnd *SCpnt);
-static void nsp_pio_read         (Scsi_Cmnd *SCpnt);
-static void nsp_pio_write        (Scsi_Cmnd *SCpnt);
-static int  nsp_nexus            (Scsi_Cmnd *SCpnt);
-static void nsp_scsi_done        (Scsi_Cmnd *SCpnt);
-static int  nsp_analyze_sdtr     (Scsi_Cmnd *SCpnt);
-static int  nsp_negate_signal    (Scsi_Cmnd *SCpnt, unsigned char mask, char *str);
-static int  nsp_expect_signal    (Scsi_Cmnd *SCpnt, unsigned char current_phase, unsigned char  mask);
-static int  nsp_xfer             (Scsi_Cmnd *SCpnt, int phase);
-static int  nsp_dataphase_bypass (Scsi_Cmnd *SCpnt);
-static int  nsp_reselected       (Scsi_Cmnd *SCpnt);
+static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
+static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
+static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
+static void nsp_pio_read         (struct scsi_cmnd *SCpnt);
+static void nsp_pio_write        (struct scsi_cmnd *SCpnt);
+static int  nsp_nexus            (struct scsi_cmnd *SCpnt);
+static void nsp_scsi_done        (struct scsi_cmnd *SCpnt);
+static int  nsp_analyze_sdtr     (struct scsi_cmnd *SCpnt);
+static int  nsp_negate_signal    (struct scsi_cmnd *SCpnt,
+				  unsigned char mask, char *str);
+static int  nsp_expect_signal    (struct scsi_cmnd *SCpnt,
+				  unsigned char current_phase,
+				  unsigned char  mask);
+static int  nsp_xfer             (struct scsi_cmnd *SCpnt, int phase);
+static int  nsp_dataphase_bypass (struct scsi_cmnd *SCpnt);
+static int  nsp_reselected       (struct scsi_cmnd *SCpnt);
 static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 
 /* Interrupt handler */
@@ -344,8 +348,8 @@ static void __exit nsp_cs_exit(void);
 
 /* Debug */
 #ifdef NSP_DEBUG
-static void show_command (Scsi_Cmnd *SCpnt);
-static void show_phase   (Scsi_Cmnd *SCpnt);
+static void show_command (struct scsi_cmnd *SCpnt);
+static void show_phase   (struct scsi_cmnd *SCpnt);
 static void show_busphase(unsigned char stat);
 static void show_message (nsp_hw_data *data);
 #else
diff -puN drivers/scsi/pcmcia/nsp_debug.c~scsi-convert-ninja-driver-to-struct-scsi_cmnd drivers/scsi/pcmcia/nsp_debug.c
--- a/drivers/scsi/pcmcia/nsp_debug.c~scsi-convert-ninja-driver-to-struct-scsi_cmnd
+++ a/drivers/scsi/pcmcia/nsp_debug.c
@@ -138,12 +138,12 @@ static void print_commandk (unsigned cha
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }
 
-static void show_phase(Scsi_Cmnd *SCpnt)
+static void show_phase(struct scsi_cmnd *SCpnt)
 {
 	int i = SCpnt->SCp.phase;
 
diff -puN drivers/scsi/pcmcia/nsp_message.c~scsi-convert-ninja-driver-to-struct-scsi_cmnd drivers/scsi/pcmcia/nsp_message.c
--- a/drivers/scsi/pcmcia/nsp_message.c~scsi-convert-ninja-driver-to-struct-scsi_cmnd
+++ a/drivers/scsi/pcmcia/nsp_message.c
@@ -8,7 +8,7 @@
 
 /* $Id: nsp_message.c,v 1.6 2003/07/26 14:21:09 elca Exp $ */
 
-static void nsp_message_in(Scsi_Cmnd *SCpnt)
+static void nsp_message_in(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  base = SCpnt->device->host->io_port;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
@@ -50,7 +50,7 @@ static void nsp_message_in(Scsi_Cmnd *SC
 
 }
 
-static void nsp_message_out(Scsi_Cmnd *SCpnt)
+static void nsp_message_out(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	int ret = 1;
_
