From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix memory leak in error path
Date: Sun, 18 Jan 2009 22:16:57 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0901182136340.94282@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:31291 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbZASGQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 01:16:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hifumi.hisashi@oss.ntt.co.jp, James.Bottomley@HansenPartnership.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

The following patch fixes memory leak in the error path of scsi host allocation 
failure.
Please review and apply.

Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df6e6a2..2cf1491 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1888,6 +1888,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		    "[ERROR] Failed to allocate memory for scsi_host\n");
 
 		ret = -ENOMEM;
+		qla2x00_mem_free(ha);
+		qla2x00_free_queues(ha);
 		goto probe_hw_failed;
 	}
 
