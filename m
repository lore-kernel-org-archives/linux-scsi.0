From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 17/18] qla2xxx: Move initialization of some variables before iospace_config.
Date: Fri, 18 Nov 2011 09:03:21 -0800
Message-ID: <1321635802-16491-18-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:7696 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758242Ab1KRRQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:45 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Some variables need to be initialized before we config PCI I/O config space
or else strange firmware initialization errors may occur.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d713bc3..4ed1e4a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2027,6 +2027,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		pdev->needs_freset = 1;
 	}
 
+	ha->prev_topology = 0;
+	ha->init_cb_size = sizeof(init_cb_t);
+	ha->link_data_rate = PORT_SPEED_UNKNOWN;
+	ha->optrom_size = OPTROM_SIZE_2300;
+
 	/* Assign ISP specific operations. */
 	max_id = MAX_TARGETS_2200;
 	if (IS_QLA2100(ha)) {
@@ -2143,11 +2148,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ql_log_pci(ql_log_info, pdev, 0x001d,
 	    "Found an ISP%04X irq %d iobase 0x%p.\n",
 	    pdev->device, pdev->irq, ha->iobase);
-	ha->prev_topology = 0;
-	ha->init_cb_size = sizeof(init_cb_t);
-	ha->link_data_rate = PORT_SPEED_UNKNOWN;
-	ha->optrom_size = OPTROM_SIZE_2300;
-
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
-- 
1.6.0.2


