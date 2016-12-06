From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: support deferred probe for v2 hw
Date: Tue, 6 Dec 2016 20:44:07 +0800
Message-ID: <1481028247-196779-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:28186 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbcLFMSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 07:18:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

In the hip06 and hip07 SoCs, the interrupt lines from the
SAS controllers are connected to mbigen hw module [1].
The mbigen module is probed with module_init, and, as such,
is not guaranteed to probe before the SAS driver. So we need
to support deferred probe.

We check for probe deferral in the hw layer probe, so we not
probe into the main layer and allocate shost, memories, etc.,
to later learn that we need to defer the probe.

[1] ./Documentation/devicetree/bindings/interrupt-controller/hisilicon,mbigen-v2.txt

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index c0e7bf2..a179592 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2971,6 +2971,18 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 
 static int hisi_sas_v2_probe(struct platform_device *pdev)
 {
+	/*
+	 * Check if we should defer the probe before we probe the
+	 * upper layer, as it's hard to defer later on.
+	 */
+	int ret = platform_get_irq(pdev, 0);
+
+	if (ret < 0) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "cannot obtain irq\n");
+		return ret;
+	}
+
 	return hisi_sas_probe(pdev, &hisi_sas_v2_hw);
 }
 
-- 
1.9.1

