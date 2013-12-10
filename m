From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] qla2xxx: Restrict max_luns to 16-bit for older HBAs
Date: Tue, 10 Dec 2013 12:05:13 +0100
Message-ID: <1386673515-87133-4-git-send-email-hare@suse.de>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3LJLFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 06:05:21 -0500
In-Reply-To: <1386673515-87133-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chad Dupuis <chad.dupuis@qlogic.com>

Older HBAs are only capable of supporting 16-bit LUNs,
so we need to make sure to adjust the 'ql2xmaxlun'
parameter accordingly.

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 89a5300..a088e5b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2600,6 +2600,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
+	if (!IS_QLAFX00(ha) && !IS_FWI2_CAPABLE(ha)) {
+		/* HW supports only 16-bit LUNs */
+		if (ql2xmaxlun > 0xffff)
+			ql2xmaxlun = 0xffff;
+	}
 	host->max_lun = ql2xmaxlun;
 	host->transportt = qla2xxx_transport_template;
 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
-- 
1.7.12.4

