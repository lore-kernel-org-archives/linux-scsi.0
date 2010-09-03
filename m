From: madhu.iyengar@qlogic.com
Subject: [PATCH 10/10] qla2xxx: AER Support-Return recovered from mmio_enable function for 82XX.
Date: Fri,  3 Sep 2010 15:20:57 -0700
Message-ID: <1283552457-4497-11-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39336 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753596Ab0ICW06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:58 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Return recovered from pci_mmio_enabled function if it is 82XX.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c8ef4ee..c5efeb0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3830,6 +3830,9 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 
+	if (IS_QLA82XX(ha))
+		return PCI_ERS_RESULT_RECOVERED;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)){
 		stat = RD_REG_DWORD(&reg->hccr);
-- 
1.6.0.2

