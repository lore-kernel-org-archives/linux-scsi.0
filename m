From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Fix 64bit warnings in BusLogic driver
Date: Tue, 7 Oct 2003 19:30:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007173044.GA1567@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:17412 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262544AbTJGRar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 13:30:47 -0400
Received: from fred.muc.de (Purzil_Crofe@localhost.localdomain [127.0.0.1])
	by zero.aec.at (8.11.6/8.11.2) with ESMTP id h97HUeS22466
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 19:30:41 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


During a make allyesconfig on x86-64 I noticed several integer/pointer
mismatch warnings in the bus logic driver.

This cleans them up.

-Andi

diff -u linux-2.5-cleanup/drivers/scsi/BusLogic.c-o linux-2.5-cleanup/drivers/scsi/BusLogic.c
--- linux-2.5-cleanup/drivers/scsi/BusLogic.c-o	2003-09-28 06:33:44.000000000 +0200
+++ linux-2.5-cleanup/drivers/scsi/BusLogic.c	2003-12-02 16:51:52.119244784 +0100
@@ -3538,8 +3538,8 @@
       CCB->DataLength = Count * sizeof(BusLogic_ScatterGatherSegment_T);
       if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
 	CCB->DataPointer = (unsigned int)CCB->DMA_Handle +
-			    ((unsigned int)&CCB->ScatterGatherList - 
-			     (unsigned int)CCB);
+			    ((unsigned long)&CCB->ScatterGatherList - 
+			     (unsigned long)CCB);
       else CCB->DataPointer = Virtual_to_32Bit_Virtual(CCB->ScatterGatherList);
       for (Segment = 0; Segment < Count; Segment++)
 	{


