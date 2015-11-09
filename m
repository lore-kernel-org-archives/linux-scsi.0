From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 15/32] scsi: hisi_sas: add phy and port init
Date: Tue, 10 Nov 2015 00:32:20 +0800
Message-ID: <1447086757-147706-16-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 17 +++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5ac5a82..e04fd67 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -43,12 +43,29 @@ enum dev_status {
 	HISI_SAS_DEV_EH,
 };
 struct hisi_sas_phy {
+	struct hisi_hba	*hisi_hba;
+	struct hisi_sas_port	*port;
 	struct asd_sas_phy	sas_phy;
+	struct sas_identify	identify;
+	struct timer_list	timer;
+	u64		port_id; /* from hw */
 	u64		dev_sas_addr;
+	u64		phy_type;
+	u64		frame_rcvd_size;
+	u8		frame_rcvd[32];
+	u8		phy_attached;
+	u8		reserved[3];
+	u64		phy_event;
+	int		eye_diag_done;
+	enum sas_linkrate	minimum_linkrate;
+	enum sas_linkrate	maximum_linkrate;
 };
 
 struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
+	u8	port_attached;
+	u8	id; /* from hw */
+	struct list_head	list;
 };
 
 struct hisi_sas_cq {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c6ce26a..6892cdf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -27,6 +27,30 @@ static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
 
+
+static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	phy->hisi_hba = hisi_hba;
+	phy->port = NULL;
+	init_timer(&phy->timer);
+	sas_phy->enabled = (phy_no < hisi_hba->n_phy) ? 1 : 0;
+	sas_phy->class = SAS;
+	sas_phy->iproto = SAS_PROTOCOL_ALL;
+	sas_phy->tproto = 0;
+	sas_phy->type = PHY_TYPE_PHYSICAL;
+	sas_phy->role = PHY_ROLE_INITIATOR;
+	sas_phy->oob_mode = OOB_NOT_CONNECTED;
+	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
+	sas_phy->id = phy_no;
+	sas_phy->sas_addr = &hisi_hba->sas_addr[0];
+	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
+	sas_phy->ha = (struct sas_ha_struct *)hisi_hba->shost->hostdata;
+	sas_phy->lldd_phy = phy;
+}
+
 static struct scsi_transport_template *hisi_sas_stt;
 
 static struct scsi_host_template hisi_sas_sht = {
@@ -57,6 +81,13 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	struct platform_device *pdev = hisi_hba->pdev;
 	struct device *dev = &pdev->dev;
 
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_init(hisi_hba, i);
+		hisi_hba->port[i].port_attached = 0;
+		hisi_hba->port[i].id = -1;
+		INIT_LIST_HEAD(&hisi_hba->port[i].list);
+	}
+
 	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
 		hisi_hba->devices[i].dev_type = SAS_PHY_UNUSED;
 		hisi_hba->devices[i].device_id = i;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
