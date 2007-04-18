From: Johann Lombardi <johann.lombardi@bull.net>
Subject: [RFC] scsi: allow to increase the maximum number of sg entries
Date: Wed, 18 Apr 2007 10:21:14 +0200
Message-ID: <20070418082114.GE13565@lombardij>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59028 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXDRIVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 04:21:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 177B919D94B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2007 10:21:46 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 32214-03 for <linux-scsi@vger.kernel.org>;
 Wed, 18 Apr 2007 10:21:41 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id E524919D90C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2007 10:21:40 +0200 (CEST)
Received: from johann by lombardij with local (Exim 3.36 #1 (Debian))
	id 1He5Pf-0005vn-00
	for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2007 10:21:15 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We have observed noticeable performance improvement by using large single
command data transfers (up to 4MB) with some storage subsystems such as DDN's.
The patch below adds a new config option (CONFIG_SCSI_LARGE_SG) which allows to
increase SCSI_MAX_PHYS_SEGMENTS. When enabled, we should get 4MB transfers even
if the buffers are completely fragmented in physical memory.
Thanks in advance for any comments.

Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>
--

Index: linux-2.6.20/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.20.orig/drivers/scsi/Kconfig	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/scsi/Kconfig	2007-02-26 10:25:54.000000000 +0100
@@ -240,6 +240,15 @@ config SCSI_SCAN_ASYNC
 	  You can override this choice by specifying scsi_mod.scan="sync"
 	  or "async" on the kernel's command line.
 
+config SCSI_LARGE_SG
+	bool "Support for large SCSI scatter/gather list"
+	depends on SCSI
+	help
+	  This option increases the scatter/gather list maximum length to
+	  allow larger single command data transfers.
+
+	  If unsure, say N.
+
 menu "SCSI Transports"
 	depends on SCSI
 
Index: linux-2.6.20/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.20.orig/drivers/scsi/scsi_lib.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/scsi/scsi_lib.c	2007-02-26 10:20:04.000000000 +0100
@@ -56,11 +56,17 @@ static struct scsi_host_sg_pool scsi_sg_
 #if (SCSI_MAX_PHYS_SEGMENTS > 128)
 	SP(256),
 #if (SCSI_MAX_PHYS_SEGMENTS > 256)
+	SP(512),
+#if (SCSI_MAX_PHYS_SEGMENTS > 512)
+	SP(1024),
+#if (SCSI_MAX_PHYS_SEGMENTS > 1024)
 #error SCSI_MAX_PHYS_SEGMENTS is too large
 #endif
 #endif
 #endif
 #endif
+#endif
+#endif
 }; 	
 #undef SP
 
@@ -731,6 +737,16 @@ struct scatterlist *scsi_alloc_sgtable(s
 	case 129 ... 256:
 		cmd->sglist_len = 5;
 		break;
+#if (SCSI_MAX_PHYS_SEGMENTS  > 256)
+	case 257 ... 512:
+		cmd->sglist_len = 6;
+		break;
+#if (SCSI_MAX_PHYS_SEGMENTS  > 512)
+	case 513 ... 1024:
+		cmd->sglist_len = 7;
+		break;
+#endif
+#endif
 #endif
 #endif
 #endif
Index: linux-2.6.20/include/scsi/scsi.h
===================================================================
--- linux-2.6.20.orig/include/scsi/scsi.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/include/scsi/scsi.h	2007-02-26 10:27:26.000000000 +0100
@@ -12,10 +12,14 @@
 
 /*
  *	The maximum sg list length SCSI can cope with
- *	(currently must be a power of 2 between 32 and 256)
+ *	(currently must be a power of 2 between 32 and 1024)
  */
-#define SCSI_MAX_PHYS_SEGMENTS	MAX_PHYS_SEGMENTS
 
+#ifdef CONFIG_SCSI_LARGE_SG
+#define SCSI_MAX_PHYS_SEGMENTS 1024
+#else
+#define SCSI_MAX_PHYS_SEGMENTS MAX_PHYS_SEGMENTS
+#endif
 
 /*
  *	SCSI command lengths
