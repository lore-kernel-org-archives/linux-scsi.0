From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH RESEND] scsi: qla4xxx: drop duplicate init_completion
Date: Mon, 16 Mar 2015 11:07:58 -0400
Message-ID: <1426518478-7813-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

The double call to init_completion(&ha->disable_acb_comp); is unnecessary.
Checking drivers/scsi/qla4xxx/ql4_def.h it seems that struct scsi_qla_host
only is defining these four struct completions - thus this seems to be a
typo only. Thus the duplicate call is simply dropped.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Originally posted as http://lkml.org/lkml/2014/12/23/355

Patch was only compile-tested with x86_64_defconfig + CONFIG_SCSI_LOWLEVEL=y,
CONFIG_SCSI_QLA_ISCSI=m

Patch is against 4.0-rc3 (localversion-next is -next-20150316

 drivers/scsi/qla4xxx/ql4_os.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..2723bd9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8669,7 +8669,6 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	mutex_init(&ha->mbox_sem);
 	mutex_init(&ha->chap_sem);
 	init_completion(&ha->mbx_intr_comp);
-	init_completion(&ha->disable_acb_comp);
 	init_completion(&ha->idc_comp);
 	init_completion(&ha->link_up_comp);
 	init_completion(&ha->disable_acb_comp);
-- 
1.7.10.4
