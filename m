From: <nagalakshmi.nandigama@lsi.com>
Subject: [RESEND PATCH] mptsas: Fixed code to check whether the LU type is SSC or not for SILI bit in READ_6 and READ_16 CDB
Date: Tue, 6 Mar 2012 12:16:07 +0530
Message-ID: <201203060645.q266jR8Y026994@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48442 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab2CFGr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 01:47:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jejb@kernel.org

This SILI bit (suppress incorrect length indicator) is defined only for SSC
READ(6) and READ(16) commands. For other device types bit is part of LBA
field. In the current implementation, it is not checked whether the logical
unit is a SSC device.


Added code for checking the LU type is SSC for SILI bit in READ_6 and READ_16 CDB 

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
CC: stable@vger.kernel.org
---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0c3ced7..266bb14 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -827,13 +827,16 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				 * DID_SOFT_ERROR is set.
 				 */
 				if (ioc->bus_type == SPI) {
-					if ((pScsiReq->CDB[0] == READ_6  && ((pScsiReq->CDB[1] & 0x02) == 0)) ||
-					    pScsiReq->CDB[0] == READ_10 ||
-					    pScsiReq->CDB[0] == READ_12 ||
-						(pScsiReq->CDB[0] == READ_16 &&
-						((pScsiReq->CDB[1] & 0x02) == 0)) ||
-					    pScsiReq->CDB[0] == VERIFY  ||
-					    pScsiReq->CDB[0] == VERIFY_16) {
+					if ((pScsiReq->CDB[0] == READ_6  &&
+					((pScsiReq->CDB[1] & 0x02) == 0) &&
+					(sc->device->type == TYPE_TAPE)) ||
+					pScsiReq->CDB[0] == READ_10 ||
+					pScsiReq->CDB[0] == READ_12 ||
+					(pScsiReq->CDB[0] == READ_16 &&
+					((pScsiReq->CDB[1] & 0x02) == 0) &&
+					(sc->device->type == TYPE_TAPE)) ||
+					 pScsiReq->CDB[0] == VERIFY  ||
+					 pScsiReq->CDB[0] == VERIFY_16) {
 						if (scsi_bufflen(sc) !=
 							xfer_cnt) {
 							sc->result =
