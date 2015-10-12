From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Mon, 12 Oct 2015 23:20:21 +0800
Message-ID: <1444663237-238302-10-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This SAS ID is chosen as Huawei IEEE id: 001882

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_init.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 44fc524..c295c39 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -283,6 +283,19 @@ err_out:
 	return NULL;
 }
 
+static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
+{
+	u8 i;
+
+	/* Huawei IEEE id (001882) */
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		hisi_hba->phy[i].dev_sas_addr =
+			cpu_to_be64(0x5001882016072015ULL);
+
+	memcpy(hisi_hba->sas_addr, &hisi_hba->phy[0].dev_sas_addr,
+	       SAS_ADDR_SIZE);
+}
+
 static int hisi_sas_probe(struct platform_device *pdev)
 {
 	struct Scsi_Host *shost;
@@ -339,6 +352,8 @@ static int hisi_sas_probe(struct platform_device *pdev)
 		sha->sas_phy[i] = &hisi_hba->phy[i].sas_phy;
 		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
 	}
+
+	hisi_sas_init_add(hisi_hba);
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
