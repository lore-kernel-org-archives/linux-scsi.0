From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] qla2xxx: Restrict max_lun to 16-bit for older HBAs
Date: Sat, 31 May 2014 11:01:15 +0200
Message-ID: <1401526878-119472-4-git-send-email-hare@suse.de>
References: <1401526878-119472-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaEaJBX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 May 2014 05:01:23 -0400
In-Reply-To: <1401526878-119472-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Older HBAs are only capable of supporting 16-bit LUNs,
so we need to make sure to adjust max_lun accordingly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Ewan Milne <emilne@redhat.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 19e99cc..264d97e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2656,7 +2656,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
-	host->max_lun = ql2xmaxlun;
+	/* Older HBAs support only 16-bit LUNs */
+	if (!IS_QLAFX00(ha) && !IS_FWI2_CAPABLE(ha) &&
+	    ql2xmaxlun > 0xffff)
+		host->max_lun = 0xffff;
+	else
+		host->max_lun = ql2xmaxlun;
 	host->transportt = qla2xxx_transport_template;
 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
 
-- 
1.7.12.4

