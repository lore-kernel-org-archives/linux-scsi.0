From: giridhar.malavali@qlogic.com
Subject: [PATCH 03/16] qla2xxx: Clear error status after uncorrectable non-fatal errors.
Date: Tue,  4 May 2010 15:01:23 -0700
Message-ID: <1273010496-43045-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47140 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754380Ab0EDWBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:38 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Currently error status is cleared only after the uncorrectable fatal errors
in the qla2xxx_pci_slot_reset. This fix is added to clear the error status in
qla2xxx_pci_resume. This way for both fatal and non-fatal errors the error
status gets cleared properly.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=572258

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b1adeb7..f2102db 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3697,7 +3697,6 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		ret =  PCI_ERS_RESULT_RECOVERED;
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
-	pci_cleanup_aer_uncorrect_error_status(pdev);
 
 	DEBUG17(qla_printk(KERN_WARNING, ha,
 	    "slot_reset-return:ret=%x\n", ret));
@@ -3721,6 +3720,8 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 		    "from slot/link_reset");
 	}
 
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+
 	ha->flags.eeh_busy = 0;
 }
 
-- 
1.6.2.rc1.30.gd43c

