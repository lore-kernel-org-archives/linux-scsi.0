From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Wait to do async scan until scsi host is initialized
Date: Fri, 15 Jul 2016 14:48:03 -0500
Message-ID: <20160715194804.89BFD2803D@b01ledav001.gho.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42181 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbcGOTsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 15:48:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6FJiLTP073060
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2016 15:48:14 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
	by mx0a-001b2d01.pphosted.com with ESMTP id 246kckaye0-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2016 15:48:13 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 15 Jul 2016 15:48:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


When performing an async scan, make sure the kthread doing scanning
doesn't start before the scsi host is fully initialized.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    9 +++++++++
 drivers/scsi/ipr.h |    1 +
 2 files changed, 10 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_async_scan_fixup drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_async_scan_fixup	2016-07-15 14:47:13.412003811 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-07-15 14:47:13.422003757 -0500
@@ -3288,6 +3288,11 @@ static void ipr_worker_thread(struct wor
 		return;
 	}
 
+	if (!ioa_cfg->scan_enabled) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return;
+	}
+
 restart:
 	do {
 		did_work = 0;
@@ -10362,6 +10367,7 @@ static void ipr_remove(struct pci_dev *p
 static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
+	unsigned long flags;
 	int rc, i;
 
 	rc = ipr_probe_ioa(pdev, dev_id);
@@ -10414,7 +10420,10 @@ static int ipr_probe(struct pci_dev *pde
 		}
 	}
 
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	ioa_cfg->scan_enabled = 1;
 	schedule_work(&ioa_cfg->work_q);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 	return 0;
 }
 
diff -puN drivers/scsi/ipr.h~ipr_async_scan_fixup drivers/scsi/ipr.h
--- linux-2.6.git/drivers/scsi/ipr.h~ipr_async_scan_fixup	2016-07-15 14:47:13.415003795 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.h	2016-07-15 14:47:13.424003746 -0500
@@ -1478,6 +1478,7 @@ struct ipr_ioa_cfg {
 	u8 in_ioa_bringdown:1;
 	u8 ioa_unit_checked:1;
 	u8 dump_taken:1;
+	u8 scan_enabled:1;
 	u8 scan_done:1;
 	u8 needs_hard_reset:1;
 	u8 dual_raid:1;
_

