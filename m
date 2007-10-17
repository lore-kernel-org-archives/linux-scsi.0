From: Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH] kill warnings in mptbase.h on parisc64
Date: Wed, 17 Oct 2007 12:25:00 -0400
Message-ID: <20071017162500.GB17874@fattire.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:36691 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXJQQZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 12:25:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org

Verified all the arches necessary select the CONFIG_64BIT symbol. This
also kills the warning (since it was using the 32-bit case) on parisc64
and mips64.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

---
Index: linux-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.h	2007-10-12 00:17:22.000000000 -0700
+++ linux-2.6/drivers/message/fusion/mptbase.h	2007-10-12 00:28:45.000000000 -0700
@@ -890,7 +890,7 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */
 
-#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__) || defined(__powerpc__)
+#ifdef CONFIG_64BIT
 #define CAST_U32_TO_PTR(x)	((void *)(u64)x)
 #define CAST_PTR_TO_U32(x)	((u32)(u64)x)
 #else
