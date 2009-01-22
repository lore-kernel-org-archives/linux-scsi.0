From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/12] qla2xxx: Fix memory leak in error path
Date: Thu, 22 Jan 2009 09:45:28 -0800
Message-ID: <1232646339-32503-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbZAVRpm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:42 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Reviewed-by:  Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cf32653..185ea8b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1888,6 +1888,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		    "[ERROR] Failed to allocate memory for scsi_host\n");
 
 		ret = -ENOMEM;
+		qla2x00_mem_free(ha);
+		qla2x00_free_que(ha, req, rsp);
 		goto probe_hw_failed;
 	}
 
@@ -1917,14 +1919,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
-		goto probe_failed;
-
+		goto probe_init_failed;
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		"[ERROR] Failed to allocate memory for queue"
 		" pointers\n");
-		goto probe_failed;
+		goto probe_init_failed;
 	}
 	ha->rsp_q_map[0] = rsp;
 	ha->req_q_map[0] = req;
@@ -1997,6 +1998,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+probe_init_failed:
+	qla2x00_free_que(ha, req, rsp);
+	ha->max_queues = 0;
+
 probe_failed:
 	qla2x00_free_device(base_vha);
 
-- 
1.6.1.48.ge9b8

