From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove flush_cache_all() from qla1280
Date: Thu, 5 Feb 2004 13:40:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205124044.GA17988@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:34726 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265178AbUBEMkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 07:40:47 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

It's not needed with the new DMA API and isn't exported to modules on
some architectures.  (See davem's qla2xxx patch for reference)


--- 1.54/drivers/scsi/qla1280.c	Mon Jan 19 04:50:29 2004
+++ edited/drivers/scsi/qla1280.c	Wed Feb  4 04:22:53 2004
@@ -348,7 +348,6 @@
 #include <asm/system.h>
 
 #if LINUX_VERSION_CODE >= 0x020545
-#include <asm/cacheflush.h>	/* for flush_cache_all() */
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -2122,8 +2121,6 @@
 		for(i = 0; i < cnt; i++)
 			((uint16_t *)ha->request_ring)[i] =
 				cpu_to_le16(risc_code_address[i]);
-
-		flush_cache_all();
 
 		mb[0] = MBC_LOAD_RAM;
 		mb[1] = risc_address;
