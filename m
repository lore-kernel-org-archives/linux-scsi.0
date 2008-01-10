From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] advansys: section mismatch warning
Date: Thu, 10 Jan 2008 14:32:51 -0800
Message-ID: <20080110143251.eef8d398.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:63303 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbYAJWd1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:33:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>, matthew@wil.cx

From: Randy Dunlap <randy.dunlap@oracle.com>

WARNING: vmlinux.o(.exit.text+0xc5b5): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'advansys_eisa_remove')

_asc_def_iop_base is used in both init and exit code, so it cannot be
marked as __devinitdata.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/advansys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7-git1.orig/drivers/scsi/advansys.c
+++ linux-2.6.24-rc7-git1/drivers/scsi/advansys.c
@@ -13906,7 +13906,7 @@ static int advansys_release(struct Scsi_
 
 #define ASC_IOADR_TABLE_MAX_IX  11
 
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
+static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
 	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
 	0x0210, 0x0230, 0x0250, 0x0330
 };
