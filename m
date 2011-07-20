From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mptfusion : Added check for SILI bit in READ_6 CDB for DATA
 UNDERRUN ERRATA
Date: Wed, 20 Jul 2011 21:28:03 +0530
Message-ID: <20110720155754.GA20840@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:44965 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846Ab1GTPgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 11:36:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com

When READ_6 command is issued, the setting of SILI Bit in CDB is confirmed and
if SILI bit is off, the processing of relavent Errata is executed.

Earlier we did not have check for SILI bit in READ_6 CDB.
As described in "ssc-r22", Now Driver is checking SILI bit for READ_6.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a1d4ee6..ce61a57 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -827,7 +827,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				 * DID_SOFT_ERROR is set.
 				 */
 				if (ioc->bus_type == SPI) {
-					if (pScsiReq->CDB[0] == READ_6  ||
+					if ((pScsiReq->CDB[0] == READ_6  && ((pScsiReq->CDB[1] & 0x02) == 0)) ||
 					    pScsiReq->CDB[0] == READ_10 ||
 					    pScsiReq->CDB[0] == READ_12 ||
 					    pScsiReq->CDB[0] == READ_16 ||
