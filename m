From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [janitor] (5/5) pcmcia/nsp: use kernel.h min/max/ARRAY_SIZE
Date: Tue, 27 Apr 2004 11:07:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427110709.1bc71988.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:61417 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264278AbUD0SOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 14:14:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, yokota@netlab.is.tsukuba.ac.jp


From: Michael Veeck <michael.veeck@gmx.net>
Subject: [Kernel-janitors] [PATCH] drivers/scsi/pcmcia MIN/MAX/NUMBER removal


Patch (against 2.6.6-rc1) removes unnecessary min/max/number macros and 
changes calls to use kernel.h macros instead.


 drivers/scsi/pcmcia/nsp_cs.c |   12 ++++++------
 drivers/scsi/pcmcia/nsp_cs.h |    2 --
 2 files changed, 6 insertions(+), 8 deletions(-)


Index: linux-266-rc2-kj1/drivers/scsi/pcmcia/nsp_cs.c
===================================================================
--- linux-266-rc2-kj1.orig/drivers/scsi/pcmcia/nsp_cs.c	2004-04-03 19:38:22.000000000 -0800
+++ linux-266-rc2-kj1/drivers/scsi/pcmcia/nsp_cs.c	2004-04-22 22:34:49.000000000 -0700
@@ -315,7 +315,7 @@ static void nsphw_init_sync(nsp_hw_data 
 	int i;
 
 	/* setup sync data */
-	for ( i = 0; i < NUMBER(data->Sync); i++ ) {
+	for ( i = 0; i < ARRAY_SIZE(data->Sync); i++ ) {
 		data->Sync[i] = tmp_sync;
 	}
 }
@@ -600,7 +600,7 @@ static int nsp_xfer(Scsi_Cmnd *SCpnt, in
 	unsigned int  base = SCpnt->device->host->io_port;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	char	     *buf  = data->MsgBuffer;
-	int	      len  = MIN(MSGBUF_SIZE, data->MsgLen);
+	int	      len  = min(MSGBUF_SIZE, data->MsgLen);
 	int	      ptr;
 	int	      ret;
 
@@ -774,7 +774,7 @@ static void nsp_pio_read(Scsi_Cmnd *SCpn
 			continue;
 		}
 
-		res = MIN(res, SCpnt->SCp.this_residual);
+		res = min(res, SCpnt->SCp.this_residual);
 
 		switch (data->TransferMode) {
 		case MODE_IO32:
@@ -868,7 +868,7 @@ static void nsp_pio_write(Scsi_Cmnd *SCp
 			continue;
 		}
 
-		res = MIN(SCpnt->SCp.this_residual, WFIFO_CRIT);
+		res = min(SCpnt->SCp.this_residual, WFIFO_CRIT);
 
 		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this=0x%x res=0x%x", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, res);
 		switch (data->TransferMode) {
@@ -1490,7 +1490,7 @@ nsp_proc_info(
 	spin_unlock_irqrestore(&(data->Lock), flags);
 
 	SPRINTF("SDTR status\n");
-	for(id = 0; id < NUMBER(data->Sync); id++) {
+	for(id = 0; id < ARRAY_SIZE(data->Sync); id++) {
 
 		SPRINTF("id %d: ", id);
 
@@ -1534,7 +1534,7 @@ nsp_proc_info(
         }
 
 
-	thislength = MIN(thislength, length);
+	thislength = min(thislength, length);
 	*start = buffer + offset;
 
 	return thislength;
Index: linux-266-rc2-kj1/drivers/scsi/pcmcia/nsp_cs.h
===================================================================
--- linux-266-rc2-kj1.orig/drivers/scsi/pcmcia/nsp_cs.h	2004-04-03 19:36:57.000000000 -0800
+++ linux-266-rc2-kj1/drivers/scsi/pcmcia/nsp_cs.h	2004-04-22 22:34:49.000000000 -0700
@@ -26,9 +26,7 @@
 /************************************
  * Some useful macros...
  */
-#define NUMBER(arr) ((int) (sizeof(arr) / sizeof(arr[0]))) /* from XtNumber() in /usr/X11R6/include/X11/Intrinsic.h */
 #define BIT(x)      (1L << (x))
-#define MIN(a,b)    ((a) > (b) ? (b) : (a))
 
 /* SCSI initiator must be ID 7 */
 #define NSP_INITIATOR_ID  7


--
