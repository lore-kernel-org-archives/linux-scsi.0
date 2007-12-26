From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/3] drivers/scsi: Use offsetof
Date: Wed, 26 Dec 2007 17:15:08 +0100 (MET)
Message-ID: <Pine.LNX.4.58.0712261714270.1185@pc-041.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:33753 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbXLZQRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2007 11:17:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the patch cc154ac64aa8d3396b187f64cef01ce67f433324, Al Viro observed
that the proper way to compute the distance between two structure fields is
to use offsetof() or a cast to a pointer to character.  The same change can
be applied to a few more files.

The change was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r3 disable ptr_to_array@
type T;
T *s;
type T1, T2;
identifier fld1;
@@

(
  (char *)&s->fld1 - (char *)s
|
  (uint8_t *)&s->fld1 - (uint8_t *)s
|
  (u8 *)&s->fld1 - (u8 *)s
|
- (T1)&s->fld1 - (T2)s
+ offsetof(T,fld1)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c	2007-10-22 11:25:20.000000000 +0200
+++ b/drivers/scsi/BusLogic.c	2007-12-26 16:33:42.000000000 +0100
@@ -2856,7 +2856,10 @@ static int BusLogic_QueueCommand(struct
 		CCB->Opcode = BusLogic_InitiatorCCB_ScatterGather;
 		CCB->DataLength = Count * sizeof(struct BusLogic_ScatterGatherSegment);
 		if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
-			CCB->DataPointer = (unsigned int) CCB->DMA_Handle + ((unsigned long) &CCB->ScatterGatherList - (unsigned long) CCB);
+			CCB->DataPointer =
+				(unsigned int) CCB->DMA_Handle +
+				offsetof(struct BusLogic_CCB,
+					 ScatterGatherList);
 		else
 			CCB->DataPointer = Virtual_to_32Bit_Virtual(CCB->ScatterGatherList);
