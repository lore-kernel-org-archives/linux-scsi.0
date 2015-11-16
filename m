From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 12/32] scsi: hisi_sas: set dev DMA mask
Date: Mon, 16 Nov 2015 21:05:58 +0800
Message-ID: <1447679178-220222-13-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8cd1b55..d7d9516 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -311,6 +311,14 @@ int hisi_sas_probe(struct platform_device *pdev,
 	sha = SHOST_TO_SAS_HA(shost);
 	hisi_hba = shost_priv(shost);
 	platform_set_drvdata(pdev, sha);
+
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
+	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
+		dev_err(dev, "No usable DMA addressing method\n");
+		rc = -EIO;
+		goto err_out_ha;
+	}
+
 	phy_nr = port_nr = hisi_hba->n_phy;
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
