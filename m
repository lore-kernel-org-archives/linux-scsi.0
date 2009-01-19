From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] qla2xxx: Fix memory leak in error path
Date: Mon, 19 Jan 2009 16:05:58 +0900
Message-ID: <6.0.0.20.2.20090119153604.06f467e8@172.19.0.2>
References: <alpine.OSX.1.00.0901182136340.94282@ac-mac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50843 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZASHIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 02:08:45 -0500
In-Reply-To: <alpine.OSX.1.00.0901182136340.94282@ac-mac.local>
References: <alpine.OSX.1.00.0901182136340.94282@ac-mac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org


At 15:16 09/01/19, Anirban Chakraborty wrote:
>The following patch fixes memory leak in the error path of scsi host allocation 
>failure.
>Please review and apply.
>
>Thanks,
>Anirban
>
>Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
>
>diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>index df6e6a2..2cf1491 100644
>--- a/drivers/scsi/qla2xxx/qla_os.c
>+++ b/drivers/scsi/qla2xxx/qla_os.c
>@@ -1888,6 +1888,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct 
>pci_device_id *id)
> 		    "[ERROR] Failed to allocate memory for scsi_host\n");
> 
> 		ret = -ENOMEM;
>+		qla2x00_mem_free(ha);
>+		qla2x00_free_queues(ha);
> 		goto probe_hw_failed;
> 	}
> 

This patch is not sufficient, because req and rsp are not freed and
at this point ha->req_q_map and ha->rsp_q_map are not allocated yet,
so qla2x00_free_queues is not needed.

Following is my patch.
Comments?

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc2.org/drivers/scsi/qla2xxx/qla_os.c linux-2.6.29-rc2.qla2x/drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.29-rc2.org/drivers/scsi/qla2xxx/qla_os.c	2009-01-19 11:46:19.000000000 +0900
+++ linux-2.6.29-rc2.qla2x/drivers/scsi/qla2xxx/qla_os.c	2009-01-19 16:00:42.000000000 +0900
@@ -1888,6 +1888,8 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 		    "[ERROR] Failed to allocate memory for scsi_host\n");
 
 		ret = -ENOMEM;
+		qla2x00_mem_free(ha);
+		qla2x00_free_que(ha, req, rsp);
 		goto probe_hw_failed;
 	}
 
@@ -1916,14 +1918,18 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
-	if (ret)
+	if (ret) {
+		qla2x00_free_que(ha, req, rsp);
 		goto probe_failed;
+	}
 
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		"[ERROR] Failed to allocate memory for queue"
 		" pointers\n");
+
+		qla2x00_free_que(ha, req, rsp);
 		goto probe_failed;
 	}
 	ha->rsp_q_map[0] = rsp;


