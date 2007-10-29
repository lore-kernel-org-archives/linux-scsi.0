From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] advansys: fix section mismatch warning
Date: Mon, 29 Oct 2007 11:20:31 -0700
Message-ID: <20071029112031.ee3f9692.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:26959 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbXJ2SWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 14:22:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: matthew@wil.cx, jejb <james.bottomley@steeleye.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.exit.text+0x152a): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'advansys_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/advansys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2624-rc1g4-v1.orig/drivers/scsi/advansys.c
+++ linux-2624-rc1g4-v1/drivers/scsi/advansys.c
@@ -13906,7 +13906,7 @@ static int advansys_release(struct Scsi_
 
 #define ASC_IOADR_TABLE_MAX_IX  11
 
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
+static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
 	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
 	0x0210, 0x0230, 0x0250, 0x0330
 };
