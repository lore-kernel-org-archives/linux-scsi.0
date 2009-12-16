From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/5] qla2xxx: Added to EEH support.
Date: Tue, 15 Dec 2009 21:29:47 -0800
Message-ID: <1260941388-548-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57216 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751880AbZLPF3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 00:29:52 -0500
In-Reply-To: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Duane Grigsby <duane.grigsby@qlogic.com>

From: Duane Grigsby <duane.grigsby@qlogic.com>

Added fundamental reset and pci save state.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1ab3582..209f50e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1817,6 +1817,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
+
+	/* Set EEH reset type to fundamental if required by hba */
+	if ( IS_QLA24XX(ha) || IS_QLA25XX(ha) || IS_QLA81XX(ha)) {
+		pdev->needs_freset = 1;
+		pci_save_state(pdev);
+	}
+
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
-- 
1.6.2.rc1.30.gd43c

