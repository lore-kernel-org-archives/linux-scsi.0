From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 05/14] qla2xxx: Stop unconditional completion of mailbox commands issued in interrupt mode during firmware hang.
Date: Fri, 18 Nov 2011 09:02:13 -0800
Message-ID: <1321635742-16426-6-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:47087 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758189Ab1KRRP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:28 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    5 ++++-
 drivers/scsi/qla2xxx/qla_os.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 94bded5..d2005c3 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -4075,7 +4075,10 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 				ha->flags.isp82xx_fw_hung = 1;
 				if (ha->flags.mbox_busy) {
 					ha->flags.mbox_int = 1;
-					complete(&ha->mbx_intr_comp);
+					if (test_bit(MBX_INTR_WAIT,
+					    &ha->mbx_cmd_flags)) {
+						complete(&ha->mbx_intr_comp);
+					}
 				}
 				break;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 01c8700..abec1dd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4014,7 +4014,10 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 				ql_dbg(ql_dbg_aer, vha, 0x9001,
 				    "Due to pci channel io frozen, doing premature "
 				    "completion of mbx command.\n");
-				complete(&ha->mbx_intr_comp);
+				if (test_bit(MBX_INTR_WAIT,
+				    &ha->mbx_cmd_flags)) {
+					complete(&ha->mbx_intr_comp);
+				}
 			}
 		}
 		qla2x00_free_irqs(vha);
-- 
1.6.0.2


