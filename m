From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH bug fix] Work around aacraid FW problem
Date: Wed, 22 Oct 2003 12:53:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066852437.1499.19.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:17572 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263415AbTJVTx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 15:53:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

I think that this qualifies as a bug fix.

If you have a 4gig or greater system, some versions of aacraid firmware
have problems if you set HostPhysMemPages >= 0x100000.  This can
potentially cause data corruption.  If you have 4gig or greater memory,
this patch sets the HostPhysMemPages to something that the firmware can
deal with.


===== drivers/scsi/aacraid/aacraid.h 1.8 vs edited =====
--- 1.8/drivers/scsi/aacraid/aacraid.h	Thu Aug 21 00:06:52 2003
+++ edited/drivers/scsi/aacraid/aacraid.h	Wed Oct 22 09:52:43 2003
@@ -14,6 +14,8 @@
 #define AAC_MAX_TARGET (MAXIMUM_NUM_CONTAINERS+1)
 #define AAC_MAX_LUN	(8)
 
+#define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
+
 /*
  * These macros convert from physical channels to virtual channels
  */
===== drivers/scsi/aacraid/comminit.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/comminit.c	Fri May  2 12:30:22 2003
+++ edited/drivers/scsi/aacraid/comminit.c	Wed Oct 22 09:54:35 2003
@@ -92,7 +92,21 @@
 	init->AdapterFibsPhysicalAddress = cpu_to_le32((u32)phys);
 	init->AdapterFibsSize = cpu_to_le32(fibsize);
 	init->AdapterFibAlign = cpu_to_le32(sizeof(struct hw_fib));
-	init->HostPhysMemPages = cpu_to_le32(num_physpages);		// number of 4k pages of host physical memory
+	/* 
+	 * number of 4k pages of host physical memory. The aacraid fw needs
+	 * this number to be less than 4gb worth of pages. num_physpages is in
+	 * system page units. New firmware doesn't have any issues with the
+	 * mapping system, but older Firmware did, and had *troubles* dealing
+	 * with the math overloading past 32 bits, thus we must limit this
+	 * field.
+	 */
+	if ((num_physpages << (PAGE_SHIFT - 12)) <= AAC_MAX_HOSTPHYSMEMPAGES) {
+		init->HostPhysMemPages = 
+			cpu_to_le32(num_physpages << (PAGE_SHIFT-12));
+	} else {
+		init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
+	}
+
 
 	/*
 	 * Increment the base address by the amount already used

-- 
Mark Haverkamp <markh@osdl.org>

