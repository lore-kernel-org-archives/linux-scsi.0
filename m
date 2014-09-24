From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 31/35] qla2xxx: Disable PCI device in shutdown handler.
Date: Wed, 24 Sep 2014 03:08:34 -0400
Message-ID: <1411542518-2477-32-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:1679 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbaIXHmw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:52 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Disable the PCI device during shutdown to prevent any races with
other PCI code such as the AER handling code.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 08c8e9c..70445bc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3037,6 +3037,9 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	qla2x00_free_irqs(vha);
 
 	qla2x00_free_fw_dump(ha);
+
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
 }
 
 /* Deletes all the virtual ports for a given ha */
-- 
1.7.7

