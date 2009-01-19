From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix memory leak in error path
Date: Sun, 18 Jan 2009 23:58:54 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0901182349120.14897@ac-mac.local>
References: <alpine.OSX.1.00.0901182136340.94282@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:35409 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZASH6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 02:58:55 -0500
In-Reply-To: <alpine.OSX.1.00.0901182136340.94282@ac-mac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: hifumi.hisashi@oss.ntt.co.jp, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Here is the updated patch.
Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df6e6a2..cbf377f 100644
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
 
