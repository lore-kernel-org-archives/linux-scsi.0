From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 31/35] qla2xxx: Disable PCI device in shutdown handler.
Date: Thu, 25 Sep 2014 05:17:02 -0400
Message-ID: <1411636626-7566-32-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:53235 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbaIYJvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:22 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
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
index daabf8c..2c3c6af 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3032,6 +3032,9 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	qla2x00_free_irqs(vha);
 
 	qla2x00_free_fw_dump(ha);
+
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
 }
 
 /* Deletes all the virtual ports for a given ha */
-- 
1.7.7

