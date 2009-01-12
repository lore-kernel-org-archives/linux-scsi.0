From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] libfc: needs CRC32
Date: Mon, 12 Jan 2009 10:50:58 -0800
Message-ID: <496B9112.8070908@oracle.com>
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:19453 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZALSvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 13:51:22 -0500
In-Reply-To: <20090112154539.4857f533.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>

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

--- linux-next-20090112.orig/drivers/scsi/Kconfig
+++ linux-next-20090112/drivers/scsi/Kconfig
@@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
+	select CRC32
 	---help---
 	  Fibre Channel library module
 

-- 
~Randy
