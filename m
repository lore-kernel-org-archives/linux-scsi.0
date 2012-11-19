From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 472/493] drivers/message/fusion: remove use of __devexit
Date: Mon, 19 Nov 2012 13:27:01 -0500
Message-ID: <1353349642-3677-472-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41515 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab2KSSfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:35:16 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: DL-MPTFusionLinux@lsi.com 
Cc: linux-scsi@vger.kernel.org 
---
 drivers/message/fusion/mptfc.c  | 4 ++--
 drivers/message/fusion/mptsas.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 343e9e8..5456c35 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -100,7 +100,7 @@ static int mptfc_slave_alloc(struct scsi_device *sdev);
 static int mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt);
 static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
-static void __devexit mptfc_remove(struct pci_dev *pdev);
+static void mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
@@ -1496,7 +1496,7 @@ mptfc_init(void)
  *	@pdev: Pointer to pci_dev structure
  *
  */
-static void __devexit
+static void
 mptfc_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER		*ioc = pci_get_drvdata(pdev);
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index ec75697..fa43c39 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5332,7 +5332,7 @@ mptsas_shutdown(struct pci_dev *pdev)
 	mptsas_cleanup_fw_event_q(ioc);
 }
 
-static void __devexit mptsas_remove(struct pci_dev *pdev)
+static void mptsas_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	struct mptsas_portinfo *p, *n;
-- 
1.8.0

