From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/3] g_NCR5380: Kill compiler warning if builtin
Date: Sat, 3 Jan 2015 23:00:16 +0100
Message-ID: <9c3dc4446b2f8020167f2068712b9ab9a32f7777.1425880089.git.fthain@telegraphics.com.au>
References: <cover.1425880089.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44152 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbbCIICO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2015 04:02:14 -0400
In-Reply-To: <cover.1425880089.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

If CONFIG_SCSI_GENERIC_NCR5380=y:

drivers/scsi/g_NCR5380.c:727: warning: 'id_table' defined but not used

In the non-modular case, MODULE_DEVICE_TABLE() expands to nothing, and
id_table is not referenced.

Correct the existing #ifdef to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index f35792f..74ec2f5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -723,7 +723,7 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 MODULE_LICENSE("GPL");
 
-#ifndef SCSI_G_NCR5380_MEM
+#if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
 static struct isapnp_device_id id_table[] = {
 	{
 	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-- 
2.0.5

