From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] endianness bug in sas_ata
Date: Wed, 16 Apr 2008 23:27:45 +0100
Message-ID: <20080416222745.GE27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYDPW1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2008 18:27:46 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.68 #1 (Red Hat Linux))
	id 1JmG6T-0004Ic-Ih
	for linux-scsi@vger.kernel.org; Wed, 16 Apr 2008 23:27:45 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index b0e5ac3..06ad2fa 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -698,7 +698,7 @@ static int sas_discover_sata_dev(struct domain_device *dev)
 		/* incomplete response */
 		SAS_DPRINTK("sending SET FEATURE/PUP_STBY_SPIN_UP to "
 			    "dev %llx\n", SAS_ADDR(dev->sas_addr));
-		if (!le16_to_cpu(identify_x[83] & (1<<6)))
+		if (!(identify_x[83] & cpu_to_le16(1<<6)))
 			goto cont1;
 		res = sas_issue_ata_cmd(dev, ATA_SET_FEATURES,
 					ATA_FEATURE_PUP_STBY_SPIN_UP,
