From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH mm/next] libfc: uses/select CRC32
Date: Mon, 05 Jan 2009 16:05:35 -0800
Message-ID: <4962A04F.5020404@oracle.com>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:46838 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZAFAF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 19:05:59 -0500
In-Reply-To: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, jejb <James.Bottomley@steeleye.com>, scsi <linux-scsi@vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

libfc uses crc32 functions, so cause it to be built
via select:

drivers/built-in.o: In function `fc_frame_crc_check':
(.text+0x75dae): undefined reference to `crc32_le'
drivers/built-in.o: In function `fc_fcp_recv':
fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0105-1250.orig/drivers/scsi/Kconfig
+++ mmotm-2009-0105-1250/drivers/scsi/Kconfig
@@ -609,6 +609,7 @@ config SCSI_FLASHPOINT
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
+	select CRC32
 	---help---
 	  Fibre Channel library module
 
