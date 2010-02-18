From: giridhar.malavali@qlogic.com
Subject: [PATCH 7/8] qla2xxx: EEH: Restore PCI saved state during pci slot reset.
Date: Thu, 18 Feb 2010 10:07:29 -0800
Message-ID: <1266516450-472-8-git-send-email-giridhar.malavali@qlogic.com>
References: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54311 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753137Ab0BRSHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 13:07:40 -0500
In-Reply-To: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Richard Lary <rlary@us.ibm.com>, stable@kernel.org

From: Richard Lary <rlary@us.ibm.com>

Cc: stable@kernel.org
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dacc674..bfb2a8c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3362,6 +3362,11 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 
 	pci_restore_state(pdev);
 
+	/* pci_restore_state() clears the saved_state flag of the device
+	 * save restored state which resets saved_state flag
+	 */
+	pci_save_state(pdev);
+
 	if (ha->mem_only)
 		rc = pci_enable_device_mem(pdev);
 	else
-- 
1.6.2.rc1.30.gd43c

