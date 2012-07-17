From: <sreekanth.reddy@lsi.com>
Subject: [PATCH 05/09] [SCSI] mpt2sas : Fix for max_sectors warning message
 is stating the incorrect range
Date: Tue, 17 Jul 2012 15:56:09 +0530
Message-ID: <20120717102609.GA7349@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46043 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754735Ab2GQKZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 06:25:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: jejb@kernel.org

When specifying the command line option "max_sectors" less than 64, then warning
message should provide correct upper boundary value 32767 instead of 8192.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0f4f971..4a09ace 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8055,8 +8055,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
 			shost->max_sectors = 64;
-			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
-			    "for max_sectors, range is 64 to 8192. Assigning "
+			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "\
+			    "for max_sectors, range is 64 to 32767. Assigning "\
 			    "value of 64.\n", ioc->name, max_sectors);
 		} else if (max_sectors > 32767) {
 			shost->max_sectors = 32767;
