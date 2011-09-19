From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] mptfusion : Added check for SILI bit in READ_16 CDB for
 DATA UNDERRUN ERRATA
Date: Mon, 19 Sep 2011 10:27:20 +0530
Message-ID: <201109191101.p8JB1en4002941@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52027 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755087Ab1ISLBn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2011 07:01:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

When READ_16 command is issued, the setting of SILI Bit in CDB is confirmed and if SILI bit is off, the processing of relavent Errata is executed.

Added code for checking SILI bit for READ_16 as described in "SSC-4".

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ced6e4d..0c3ced7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -830,7 +830,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 					if ((pScsiReq->CDB[0] == READ_6  && ((pScsiReq->CDB[1] & 0x02) == 0)) ||
 					    pScsiReq->CDB[0] == READ_10 ||
 					    pScsiReq->CDB[0] == READ_12 ||
-					    pScsiReq->CDB[0] == READ_16 ||
+						(pScsiReq->CDB[0] == READ_16 &&
+						((pScsiReq->CDB[1] & 0x02) == 0)) ||
 					    pScsiReq->CDB[0] == VERIFY  ||
 					    pScsiReq->CDB[0] == VERIFY_16) {
 						if (scsi_bufflen(sc) !=
