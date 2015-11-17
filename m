From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 15/32] scsi: hisi_sas: add phy and port init
Date: Wed, 18 Nov 2015 00:50:42 +0800
Message-ID: <1447779059-136143-16-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 15 +++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5ac5a82..3a2400e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -43,12 +43,27 @@ enum dev_status {
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
index 21111d4..bc41ce4 100644
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
