From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi/pcmcia compile fix
Date: Sun, 16 Feb 2003 18:25:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217022553.GA5334@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e31.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1H2O8MP007932
	for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2003 21:24:08 -0500
Received: from hmsbounty (sig-9-65-17-206.mts.ibm.com [9.65.17.206])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1H2O7sH104788
	for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2003 19:24:07 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a compile fix for bug:
http://bugme.osdl.org/show_bug.cgi?id=360

This patch is against scsi-misc-2.5.

Testing: Compile only

-andmike
--
Michael Anderson
andmike@us.ibm.com

 aha152x_stub.c |    2 +-
 nsp_cs.c       |   40 ++++++++++++++++++++--------------------
 nsp_message.c  |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)
------

===== drivers/scsi/pcmcia/aha152x_stub.c 1.11 vs edited =====
--- 1.11/drivers/scsi/pcmcia/aha152x_stub.c	Mon Feb  3 23:47:00 2003
+++ edited/drivers/scsi/pcmcia/aha152x_stub.c	Sun Feb 16 13:23:48 2003
@@ -408,7 +408,7 @@
 	if (link->state & DEV_CONFIG) {
 	    Scsi_Cmnd tmp;
 	    CardServices(RequestConfiguration, link->handle, &link->conf);
-	    tmp.host = info->host;
+	    tmp.device->host = info->host;
 	    aha152x_host_reset(&tmp);
 	}
 	break;
===== drivers/scsi/pcmcia/nsp_cs.c 1.15 vs edited =====
--- 1.15/drivers/scsi/pcmcia/nsp_cs.c	Fri Jan  3 05:17:04 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.c	Sun Feb 16 13:30:27 2003
@@ -325,9 +325,9 @@
 static unsigned int nsphw_start_selection(Scsi_Cmnd   *SCpnt,
 					  nsp_hw_data *data)
 {
-	unsigned int  host_id	 = SCpnt->host->this_id;
-	unsigned int  base	 = SCpnt->host->io_port;
-	unsigned char target	 = SCpnt->target;
+	unsigned int  host_id	 = SCpnt->device->host->this_id;
+	unsigned int  base	 = SCpnt->device->host->io_port;
+	unsigned char target	 = SCpnt->device->id;
 	int	      time_out;
 	unsigned char phase, arbit;
 
@@ -405,7 +405,7 @@
  */
 static int nsp_msg(Scsi_Cmnd *SCpnt, nsp_hw_data *data)
 {
-	unsigned char	       target = SCpnt->target;
+	unsigned char	       target = SCpnt->device->id;
 //	unsigned char	       lun    = SCpnt->lun;
 	sync_data	      *sync   = &(data->Sync[target]);
 	struct nsp_sync_table *sync_table;
@@ -462,7 +462,7 @@
  */
 static void nsp_start_timer(Scsi_Cmnd *SCpnt, nsp_hw_data *data, int time)
 {
-	unsigned int base = SCpnt->host->io_port;
+	unsigned int base = SCpnt->device->host->io_port;
 
 	//DEBUG(0, "%s: in SCpnt=0x%p, time=%d\n", __FUNCTION__, SCpnt, time);
 	data->TimerCount = time;
@@ -474,7 +474,7 @@
  */
 static int nsp_negate_signal(Scsi_Cmnd *SCpnt, unsigned char mask, char *str)
 {
-	unsigned int  base = SCpnt->host->io_port;
+	unsigned int  base = SCpnt->device->host->io_port;
 	unsigned char reg;
 	int	      time_out;
 
@@ -503,7 +503,7 @@
 			     unsigned char  current_phase,
 			     unsigned char  mask)
 {
-	unsigned int  base	 = SCpnt->host->io_port;
+	unsigned int  base	 = SCpnt->device->host->io_port;
 	int	      time_out;
 	unsigned char phase, i_src;
 
@@ -536,7 +536,7 @@
  */
 static int nsp_xfer(Scsi_Cmnd *SCpnt, nsp_hw_data *data, int phase)
 {
-	unsigned int  base = SCpnt->host->io_port;
+	unsigned int  base = SCpnt->device->host->io_port;
 	char	     *buf  = data->MsgBuffer;
 	int	      len  = MIN(MSGBUF_SIZE, data->MsgLen);
 	int	      ptr;
@@ -606,7 +606,7 @@
  */
 static int nsp_reselected(Scsi_Cmnd *SCpnt, nsp_hw_data *data)
 {
-	unsigned int  base = SCpnt->host->io_port;
+	unsigned int  base = SCpnt->device->host->io_port;
 	unsigned char reg;
 
 	//DEBUG(0, "%s:\n", __FUNCTION__);
@@ -626,7 +626,7 @@
  */
 static int nsp_fifo_count(Scsi_Cmnd *SCpnt)
 {
-	unsigned int base = SCpnt->host->io_port;
+	unsigned int base = SCpnt->device->host->io_port;
 	unsigned int count;
 	unsigned int l, m, h, dummy;
 
@@ -653,8 +653,8 @@
  */
 static void nsp_pio_read(Scsi_Cmnd *SCpnt, nsp_hw_data *data)
 {
-	unsigned int  base      = SCpnt->host->io_port;
-	unsigned long mmio_base = SCpnt->host->base;
+	unsigned int  base      = SCpnt->device->host->io_port;
+	unsigned long mmio_base = SCpnt->device->host->base;
 	long	      time_out;
 	int	      ocount, res;
 	unsigned char stat, fifo_stat;
@@ -746,8 +746,8 @@
  */
 static void nsp_pio_write(Scsi_Cmnd *SCpnt, nsp_hw_data *data)
 {
-	unsigned int  base     = SCpnt->host->io_port;
-	unsigned long mmio_base = SCpnt->host->base;
+	unsigned int  base     = SCpnt->device->host->io_port;
+	unsigned long mmio_base = SCpnt->device->host->base;
 	int	      time_out;
 	int           ocount, res;
 	unsigned char stat;
@@ -838,8 +838,8 @@
  */
 static int nsp_nexus(Scsi_Cmnd *SCpnt, nsp_hw_data *data)
 {
-	unsigned int   base   = SCpnt->host->io_port;
-	unsigned char  target = SCpnt->target;
+	unsigned int   base   = SCpnt->device->host->io_port;
+	unsigned char  target = SCpnt->device->id;
 //	unsigned char  lun    = SCpnt->lun;
 	sync_data     *sync   = &(data->Sync[target]);
 
@@ -944,8 +944,8 @@
 		return;
 	} else {
 		tmpSC    = data->CurrentSC;
-		target   = tmpSC->target;
-		lun      = tmpSC->lun;
+		target   = tmpSC->device->id;
+		lun      = tmpSC->device->lun;
 		sync_neg = &(data->Sync[target].SyncNegotiation);
 	}
 
@@ -1425,7 +1425,7 @@
 static int nsp_eh_bus_reset(Scsi_Cmnd *SCpnt)
 {
 	nsp_hw_data *data = &nsp_data;
-	unsigned int base = SCpnt->host->io_port;
+	unsigned int base = SCpnt->device->host->io_port;
 	int	     i;
 
 	DEBUG(0, "%s: SCpnt=0x%p base=0x%x\n", __FUNCTION__, SCpnt, base);
@@ -1960,7 +1960,7 @@
 		}
 		info->stop = 0;
 
-		tmp.host = info->host;
+		tmp.device->host = info->host;
 		nsp_eh_host_reset(&tmp);
 		nsp_eh_bus_reset(&tmp);
 
===== drivers/scsi/pcmcia/nsp_message.c 1.5 vs edited =====
--- 1.5/drivers/scsi/pcmcia/nsp_message.c	Tue Nov  5 15:47:26 2002
+++ edited/drivers/scsi/pcmcia/nsp_message.c	Sun Feb 16 13:31:58 2003
@@ -10,7 +10,7 @@
 
 static void nsp_message_in(Scsi_Cmnd *SCpnt, nsp_hw_data *data)
 {
-	unsigned int  base = SCpnt->host->io_port;
+	unsigned int  base = SCpnt->device->host->io_port;
 	unsigned char data_reg, control_reg;
 	int           ret, len;
 
