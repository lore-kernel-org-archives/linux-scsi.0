From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2.4 2/2] cpqfc: Reduce stack usage of 2 functions
Date: Mon, 2 Jan 2006 13:05:37 +0100
Message-ID: <200601021305.38412@bilbo.math.uni-mannheim.de>
References: <200601021244.40636@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:43167 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750844AbWABMGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2006 07:06:52 -0500
Received: from mp-pc92.informatik.uni-mannheim.de ([::ffff:134.155.64.118]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 02 Jan 2006 13:06:52 +0100
In-Reply-To: <200601021244.40636@bilbo.math.uni-mannheim.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>

There are 2 function that do a lookup to the queue and buffer the result. 
They only care about the first few bytes (to be exactly: 38*sizeof(u32)), 
but they always pass a buffer of 2kB, which is located on the stack.

This patch reduces this buffer to the really needed size and changes it's 
type to the correct target type. The rest of the queue is still looked up 
but the result is ignored (as it would anyway).

There are also some small cleanups for the other arguments of 
CpqTsGetSFQEntry(), which is the lookup function.

From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

diff -aup a/drivers/scsi/cpqfcTScontrol.c b/drivers/scsi/cpqfcTScontrol.c
--- a/drivers/scsi/cpqfcTScontrol.c	2005-12-29 18:11:54.000000000 +0100
+++ b/drivers/scsi/cpqfcTScontrol.c	2005-12-29 17:05:44.000000000 +0100
@@ -50,7 +50,8 @@
 //#define IMQ_DEBUG 1
 
 static void fcParseLinkStatusCounters(TACHYON * fcChip);
-static void CpqTsGetSFQEntry(TACHYON * fcChip, u16 pi, u32 * buffr, u8 UpdateChip);
+static void CpqTsGetSFQEntry(PTACHYON fcChip, u32 producerNdx, TachFCHDR_GCMND *fchs,
+			     int UpdateChip);
 
 static void cpqfc_free_dma_consistent(CPQFCHBA * cpqfcHBAdata)
 {
@@ -540,16 +541,13 @@ static int PeekIMQEntry(PTACHYON fcChip,
 				// If we find it, check the incoming frame payload (1st word)
 				// for LILP frame
 				if ((fcChip->IMQ->QEntry[CI].type & 0x1FF) == 0x104) {
-					TachFCHDR_GCMND *fchs;
-					u32 ulFibreFrame[2048 / 4];	// max DWORDS in incoming FC Frame
-					u16 SFQpi = (u16) (fcChip->IMQ->QEntry[CI].word[0] & 0x0fffL);
+					TachFCHDR_GCMND fchs;
+					u32 SFQpi = (u32) (fcChip->IMQ->QEntry[CI].word[0] & 0x0fffL);
 
 					CpqTsGetSFQEntry(fcChip, SFQpi,	// SFQ producer ndx         
-							 ulFibreFrame,	// contiguous dest. buffer
-							 FALSE);	// DON'T update chip--this is a "lookahead"
+							 &fchs, 0);	// DON'T update chip, this is a "lookahead"
 
-					fchs = (TachFCHDR_GCMND *) & ulFibreFrame;
-					if (fchs->pl[0] == ELS_LILP_FRAME) {
+					if (fchs.pl[0] == ELS_LILP_FRAME) {
 						return 1;	// found the LILP frame!
 					} else {
 						// keep looking...
@@ -645,8 +643,7 @@ int CpqTsProcessIMQEntry(void *host)
 	u16 i, RPCset, DPCset;
 	u32 x_ID;
 	u32 ulBuff, dwStatus;
-	u32 ulFibreFrame[2048 / 4];	// max number of DWORDS in incoming Fibre Frame
-	TachFCHDR_GCMND *fchs = (TachFCHDR_GCMND *) ulFibreFrame;	// cast to examine IB frame
+	TachFCHDR_GCMND fchs;
 	u8 ucInboundMessageType;	// Inbound CM, dword 3 "type" field
 
 	ENTER("ProcessIMQEntry");
@@ -857,8 +854,8 @@ int CpqTsProcessIMQEntry(void *host)
 
 			// clears SFQ entry from Tachyon buffer; copies to contiguous ulBuff
 			CpqTsGetSFQEntry(fcChip,	// i.e. this Device Object
-					 (u16) fcChip->SFQ->producerIndex,	// SFQ producer ndx         
-					 ulFibreFrame, TRUE);	// contiguous destination buffer, update chip
+					 fcChip->SFQ->producerIndex,	// SFQ producer ndx
+					 &fchs, 1);	// contiguous destination buffer, update chip
 
 			// analyze the incoming frame outside the INT handler...
 			// (i.e., Worker)
@@ -866,14 +863,14 @@ int CpqTsProcessIMQEntry(void *host)
 			if (ucInboundMessageType == 1) {
 				// don't fill up our Q with garbage - only accept FCP-CMND  
 				// or XRDY frames
-				if ((fchs->d_id & 0xFF000000) == 0x06000000)	// CMND
+				if ((fchs.d_id & 0xFF000000) == 0x06000000)	// CMND
 				{
 					// someone sent us a SCSI command
 
 //          fcPutScsiQue( cpqfcHBAdata, 
 //                        SFQ_UNASSISTED_FCP, ulFibreFrame); 
-				} else if (((fchs->d_id & 0xFF000000) == 0x07000000) ||	// RSP (status)
-					   (fchs->d_id & 0xFF000000) == 0x05000000)	// XRDY  
+				} else if (((fchs.d_id & 0xFF000000) == 0x07000000) ||	// RSP (status)
+					   (fchs.d_id & 0xFF000000) == 0x05000000)	// XRDY  
 				{
 					u32 x_ID;
 					// Unfortunately, ABTS requires a Freeze on the chip so
@@ -891,8 +888,8 @@ int CpqTsProcessIMQEntry(void *host)
 					// Do we have an open exchange that matches this s_id
 					// and ox_id?
 					for (x_ID = 0; x_ID < TACH_SEST_LEN; x_ID++) {
-						if ((fchs->s_id & 0xFFFFFF) == (Exchanges->fcExchange[x_ID].fchs.d_id & 0xFFFFFF)
-						    && (fchs->ox_rx_id & 0xFFFF0000) == (Exchanges->fcExchange[x_ID].fchs.ox_rx_id & 0xFFFF0000)) {
+						if ((fchs.s_id & 0xFFFFFF) == (Exchanges->fcExchange[x_ID].fchs.d_id & 0xFFFFFF)
+						    && (fchs.ox_rx_id & 0xFFFF0000) == (Exchanges->fcExchange[x_ID].fchs.ox_rx_id & 0xFFFF0000)) {
 							//          printk(" #R/X frame x_ID %08X# ", fchs->ox_rx_id );
 							// simulate the anticipated error - since the
 							// SEST was frozen, frames were lost...
@@ -909,7 +906,7 @@ int CpqTsProcessIMQEntry(void *host)
 
 			else if (ucInboundMessageType == 3) {
 				// FC Link Service frames (e.g. PLOGI, ACC) come in here.  
-				cpqfcTSPutLinkQue(cpqfcHBAdata, SFQ_UNKNOWN, fchs, 0);
+				cpqfcTSPutLinkQue(cpqfcHBAdata, SFQ_UNKNOWN, &fchs, 0);
 
 			}
 
@@ -1277,7 +1274,7 @@ int CpqTsProcessIMQEntry(void *host)
 //        printk("skipping LINKACTIVE post\n");
 
 					} else
-						cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, fchs, 0);
+						cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, &fchs, 0);
 				}
 
 
@@ -1410,7 +1407,7 @@ int CpqTsProcessIMQEntry(void *host)
 					// to analyze data transfer (successful?), then send a response 
 					// frame for this exchange
 
-					ulFibreFrame[0] = x_ID;	// copy for later reference
+					fchs.reserved = x_ID;	// copy for later reference
 
 					// if this was a TWE, we have to send satus response
 					if (Exchanges->fcExchange[x_ID].type == SCSI_TWE) {
@@ -1716,8 +1713,8 @@ int CpqTsDestroyTachLiteQues(void *pHBA,
 //   length from the completion message.  The caller passes a buffer large
 //   enough for the complete message (max 2k).
 
-static void CpqTsGetSFQEntry(PTACHYON fcChip, u16 producerNdx, u32 * ulDestPtr,	// contiguous destination buffer
-			     u8 UpdateChip)
+static void CpqTsGetSFQEntry(PTACHYON fcChip, u32 producerNdx, TachFCHDR_GCMND *fchs,
+			     int UpdateChip)
 {
 	u32 total_bytes = 0;
 	u32 consumerIndex = fcChip->SFQ->consumerIndex;
@@ -1727,17 +1724,14 @@ static void CpqTsGetSFQEntry(PTACHYON fc
 	// equal indexes means SFS is copied
 
 	while (producerNdx != consumerIndex) {	// need to process message
-		total_bytes += 64;	// maintain count to prevent writing past buffer
-		// don't allow copies over Fibre Channel defined length!
-		if (total_bytes <= 2048) {
-			memcpy(ulDestPtr, &fcChip->SFQ->QEntry[consumerIndex], 64);	// each SFQ entry is 64 bytes
-			ulDestPtr += 16;	// advance pointer to next 64 byte block
+		if (total_bytes <= sizeof(*fchs)) {
+			memcpy(((void *)fchs) + total_bytes,
+				 &fcChip->SFQ->QEntry[consumerIndex],
+				 min(64, (int)(sizeof(*fchs) - total_bytes)));	// each SFQ entry is 64 bytes
 		}
-		// Tachyon is producing,
-		// and we are consuming
+		total_bytes += 64;
 
-		if (++consumerIndex >= SFQ_LEN)	// check for rollover
-			consumerIndex = 0L;	// reset it
+		consumerIndex = (consumerIndex + 1) % SFQ_LEN;
 	}
 
 	// if specified, update the Tachlite chip ConsumerIndex...
