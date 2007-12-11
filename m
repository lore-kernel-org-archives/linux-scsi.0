From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] drivers/scsi/advansys.c section fix
Date: Tue, 11 Dec 2007 23:23:53 +0100
Message-ID: <20071211222353.GZ14204@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38550 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757306AbXLKWXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 17:23:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:

<--  snip  -->

...
WARNING: vmlinux.o(.exit.text+0xcf8a): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'exit_this_scsi_driver')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e81cac11f9efe882a89708c298fa6268375b0221 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9dd3952..38a1ee2 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -13906,7 +13906,7 @@ static int advansys_release(struct Scsi_Host *shost)
 
 #define ASC_IOADR_TABLE_MAX_IX  11
 
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
+static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
 	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
 	0x0210, 0x0230, 0x0250, 0x0330
 };

