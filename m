From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 13/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:14:21 +0900 (JST)
Message-ID: <20050222.161421.21865168.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:55566 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262235AbVBVHOX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:14:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/pcmcia/nsp_message.c	2004-10-19 06:53:46.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/pcmcia/nsp_message.c	2004-08-15 09:23:57.000000000 +0900
@@ -1,19 +1,129 @@
 /*==========================================================================
   NinjaSCSI-3 message handler
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota<at>netlab.is.tsukuba.ac.jp>
 
    This software may be used and distributed according to the terms of
    the GNU General Public License.
  */
 
-/* $Id: nsp_message.c,v 1.6 2003/07/26 14:21:09 elca Exp $ */
+/* $Id: nsp_message.c,v 1.12 2004/08/15 00:23:57 elca Exp $ */
 
-static void nsp_message_in(Scsi_Cmnd *SCpnt)
+
+/*
+ * IDENTIFY Message
+ */
+static void nsp_build_identify(const Scsi_Cmnd *SCpnt)
+{
+	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int          pos  = data->MsgOutLen;
+
+	data->MsgOutBuffer[pos] = IDENTIFY(TRUE, SCpnt->device->lun); pos++;
+	data->MsgOutLen = pos;
+}
+
+/*
+ * SDTR Message Routine
+ */
+static void nsp_build_sdtr(const Scsi_Cmnd *SCpnt,
+				  unsigned char period,
+				  unsigned char offset)
+{
+	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int          pos  = data->MsgOutLen;
+
+	data->MsgOutBuffer[pos] = EXTENDED_MESSAGE;  pos++;
+	data->MsgOutBuffer[pos] = EXTENDED_SDTR_LEN; pos++;
+	data->MsgOutBuffer[pos] = EXTENDED_SDTR;     pos++;
+	data->MsgOutBuffer[pos] = period;            pos++;
+	data->MsgOutBuffer[pos] = offset;            pos++;
+
+	data->MsgOutLen = pos;
+}
+
+/*
+ * No Operation Message
+ */
+static void nsp_build_nop(const Scsi_Cmnd *SCpnt)
 {
-	unsigned int  base = SCpnt->device->host->io_port;
+	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int          pos  = data->MsgOutLen;
+
+	if (pos != 0) {
+		nsp_msg(KERN_WARNING,
+			"Some messages are already contained!");
+		return;
+	}
+
+	data->MsgOutBuffer[pos] = NOP; pos++;
+	data->MsgOutLen = pos;
+}
+
+
+/*
+ * transfer SCSI message
+ */
+static int nsp_xfer(const Scsi_Cmnd *SCpnt, int phase)
+{
+	const unsigned int base = SCpnt->device->host->io_port;
+	nsp_hw_data   *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	unsigned char *buf;
+	int	       ptr, ret;
+	size_t         len;
+
+	//nsp_dbg(NSP_DEBUG_DATA_IO, "in");
+
+	if (phase & BUSMON_IO) {
+		len = min(sizeof(data->MsgInBuffer), data->MsgInLen);
+		buf = data->MsgInBuffer;
+	} else {
+		len = min(sizeof(data->MsgOutBuffer), data->MsgOutLen);
+		buf = data->MsgOutBuffer;
+	}
+
+	for (ptr = 0; len > 0; len--, ptr++) {
+		int sig;
+
+		sig = nsp_expect_signal(SCpnt, phase, BUSMON_REQ);
+		if (sig <= 0) {
+			nsp_msg(KERN_DEBUG, "xfer quit");
+			ret = 0;
+			goto out;
+		}
+
+		/* if last byte, negate ATN */
+		if (len == 1 && SCpnt->SCp.phase == PH_MSG_OUT) {
+			nsp_index_write(base, SCSIBUSCTRL, AUTODIRECTION | ACKENB);
+		}
+
+		/* read & write message */
+		if (phase & BUSMON_IO) {
+			nsp_dbg(NSP_DEBUG_DATA_IO, "read msg");
+			buf[ptr] = nsp_index_read(base, SCSIDATAWITHACK);
+		} else {
+			nsp_dbg(NSP_DEBUG_DATA_IO, "write msg");
+			nsp_index_write(base, SCSIDATAWITHACK, buf[ptr]);
+		}
+		nsp_negate_signal(SCpnt, BUSMON_ACK, "xfer<ack>");
+
+	}
+	ret = 1;
+
+ out:
+	if (phase & BUSMON_IO) {
+		data->MsgInLen = len;
+	} else {
+		data->MsgOutLen = len;
+	}
+
+	return ret;
+}
+
+static void nsp_message_in(const Scsi_Cmnd *SCpnt)
+{
+	const unsigned int base = SCpnt->device->host->io_port;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	unsigned char data_reg, control_reg;
-	int           ret, len;
+	int           sig = 1;
+	size_t        len = 0;
 
 	/*
 	 * XXX: NSP QUIRK
@@ -21,11 +131,11 @@
 	 * therefore we should poll the scsi phase here to catch 
 	 * the next "msg in" if exists (no scsi phase changes).
 	 */
-	ret = 16;
-	len = 0;
 
 	nsp_dbg(NSP_DEBUG_MSGINOCCUR, "msgin loop");
 	do {
+		unsigned char data_reg, control_reg;
+
 		/* read data */
 		data_reg = nsp_index_read(base, SCSIDATAIN);
 
@@ -35,7 +145,7 @@
 		nsp_index_write(base, SCSIBUSCTRL, control_reg);
 		nsp_negate_signal(SCpnt, BUSMON_REQ, "msgin<REQ>");
 
-		data->MsgBuffer[len] = data_reg; len++;
+		data->MsgInBuffer[len] = data_reg; len++;
 
 		/* deassert ACK */
 		control_reg =  nsp_index_read(base, SCSIBUSCTRL);
@@ -43,18 +153,17 @@
 		nsp_index_write(base, SCSIBUSCTRL, control_reg);
 
 		/* catch a next signal */
-		ret = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_IN, BUSMON_REQ);
-	} while (ret > 0 && MSGBUF_SIZE > len);
-
-	data->MsgLen = len;
+		sig = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_IN, BUSMON_REQ);
+	} while (sig > 0 && sizeof(data->MsgInBuffer) > len);
 
+	data->MsgInLen = len;
 }
 
-static void nsp_message_out(Scsi_Cmnd *SCpnt)
+static void nsp_message_out(const Scsi_Cmnd *SCpnt)
 {
-	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	int ret = 1;
-	int len = data->MsgLen;
+	const nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int sig = 1;
+	int tmp;
 
 	/*
 	 * XXX: NSP QUIRK
@@ -63,15 +172,21 @@
 	 * the next "msg out" if exists (no scsi phase changes).
 	 */
 
+	if (data->MsgOutLen == 0) {
+		nsp_build_nop(SCpnt);
+	}
+
 	nsp_dbg(NSP_DEBUG_MSGOUTOCCUR, "msgout loop");
 	do {
-		if (nsp_xfer(SCpnt, BUSPHASE_MESSAGE_OUT)) {
-			nsp_msg(KERN_DEBUG, "msgout: xfer short");
+		tmp = nsp_xfer(SCpnt, BUSPHASE_MESSAGE_OUT);
+
+		if (tmp == 0) {
+			nsp_msg(KERN_DEBUG, "msgout: xfer short, tmp=%d, len=%d", tmp, data->MsgOutLen);
 		}
 
 		/* catch a next signal */
-		ret = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_OUT, BUSMON_REQ);
-	} while (ret > 0 && len-- > 0);
+		sig = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_OUT, BUSMON_REQ);
+	} while (sig > 0 && data->MsgOutLen > 0);
 
 }
 
