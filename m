From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/2] mptsas : Errata 1030 for parallel scsi
Date: Wed, 7 Oct 2009 11:27:40 +0530
Message-ID: <20091007055734.GC24815@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:49318 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbZJGGWR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2009 02:22:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


This patch is Errata for 1030 card.
Errata:
Certain conditions on the scsi bus may casue the 53C1030 to incorrectly signal
a SCSI_DATA_UNDERRUN to the host.

Workaround 1:
For an Errata on LSI53C1030 When the length of request data
and transfer data are different with result of command (READ or VERIFY),
DID_SOFT_ERROR is set.

Workaround 2:
For potential trouble on LSI53C1030. It is checked whether the length of
request data is equal to the length of transfer and residual.
MEDIUM_ERROR is set by incorrect data.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index c295786..4f22744 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -792,11 +792,36 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			 *  precedence!
 			 */
 			sc->result = (DID_OK << 16) | scsi_status;
-			if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
-				/* Have already saved the status and sense data
+			if (!(scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)) {
+
+				/*
+				 * For an Errata on LSI53C1030
+				 * When the length of request data
+				 * and transfer data are different
+				 * with result of command (READ or VERIFY),
+				 * DID_SOFT_ERROR is set.
 				 */
-				;
-			} else {
+				if (ioc->bus_type == SPI) {
+					if (pScsiReq->CDB[0] == READ_6  ||
+					    pScsiReq->CDB[0] == READ_10 ||
+					    pScsiReq->CDB[0] == READ_12 ||
+					    pScsiReq->CDB[0] == READ_16 ||
+					    pScsiReq->CDB[0] == VERIFY  ||
+					    pScsiReq->CDB[0] == VERIFY_16) {
+						if (scsi_bufflen(sc) !=
+							xfer_cnt) {
+							sc->result =
+							DID_SOFT_ERROR << 16;
+						    printk(KERN_WARNING "Errata"
+						    "on LSI53C1030 occurred."
+						    "sc->req_bufflen=0x%02x,"
+						    "xfer_cnt=0x%02x\n",
+						    scsi_bufflen(sc),
+						    xfer_cnt);
+						}
+					}
+				}
+
 				if (xfer_cnt < sc->underflow) {
 					if (scsi_status == SAM_STAT_BUSY)
 						sc->result = SAM_STAT_BUSY;
@@ -835,7 +860,58 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			sc->result = (DID_OK << 16) | scsi_status;
 			if (scsi_state == 0) {
 				;
-			} else if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
+			} else if (scsi_state &
+			    MPI_SCSI_STATE_AUTOSENSE_VALID) {
+
+				/*
+				 * For potential trouble on LSI53C1030.
+				 * (date:2007.xx.)
+				 * It is checked whether the length of
+				 * request data is equal to
+				 * the length of transfer and residual.
+				 * MEDIUM_ERROR is set by incorrect data.
+				 */
+				if ((ioc->bus_type == SPI) &&
+					(sc->sense_buffer[2] & 0x20)) {
+					u32	 difftransfer;
+					difftransfer =
+					sc->sense_buffer[3] << 24 |
+					sc->sense_buffer[4] << 16 |
+					sc->sense_buffer[5] << 8 |
+					sc->sense_buffer[6];
+					if (((sc->sense_buffer[3] & 0x80) ==
+						0x80) && (scsi_bufflen(sc)
+						!= xfer_cnt)) {
+						sc->sense_buffer[2] =
+						    MEDIUM_ERROR;
+						sc->sense_buffer[12] = 0xff;
+						sc->sense_buffer[13] = 0xff;
+						printk(KERN_WARNING"Errata"
+						"on LSI53C1030 occurred."
+						"sc->req_bufflen=0x%02x,"
+						"xfer_cnt=0x%02x\n" ,
+						scsi_bufflen(sc),
+						xfer_cnt);
+					}
+					if (((sc->sense_buffer[3] & 0x80)
+						!= 0x80) &&
+						(scsi_bufflen(sc) !=
+						xfer_cnt + difftransfer)) {
+						sc->sense_buffer[2] =
+							MEDIUM_ERROR;
+						sc->sense_buffer[12] = 0xff;
+						sc->sense_buffer[13] = 0xff;
+						printk(KERN_WARNING
+						"Errata on LSI53C1030 occurred"
+						"sc->req_bufflen=0x%02x,"
+						" xfer_cnt=0x%02x,"
+						"difftransfer=0x%02x\n",
+						scsi_bufflen(sc),
+						xfer_cnt,
+						difftransfer);
+					}
+				}
+
 				/*
 				 * If running against circa 200003dd 909 MPT f/w,
 				 * may get this (AUTOSENSE_VALID) for actual TASK_SET_FULL
