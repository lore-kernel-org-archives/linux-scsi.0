From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] megaraid_sas: missing curly braces in
 megasas_detach_one()
Date: Sat, 7 Nov 2015 19:17:09 +0300
Message-ID: <20151107161709.GB30686@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbbKGQRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2015 11:17:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The indenting indicates that there are supposed to be some curly braces
here.  Presumably it means we free something unintentionally leading to
a use after free.

Fixes: 3761cb4cf65e ('megaraid_sas: JBOD sequence number support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 829e9e9..91e200d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5932,7 +5932,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 						  fusion->max_map_sz,
 						  fusion->ld_map[i],
 						  fusion->ld_map_phys[i]);
-			if (fusion->ld_drv_map[i])
+			if (fusion->ld_drv_map[i]) {
 				free_pages((ulong)fusion->ld_drv_map[i],
 					fusion->drv_map_pages);
 				if (fusion->pd_seq_sync)
@@ -5940,6 +5940,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 						pd_seq_map_sz,
 						fusion->pd_seq_sync[i],
 						fusion->pd_seq_phys[i]);
+			}
 		}
 		free_pages((ulong)instance->ctrl_context,
 			instance->ctrl_context_pages);
