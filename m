Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E19934A3D9;
	Mon, 13 Jul 2026 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964085; cv=none; b=EizN/hEBvL1EGb8XTex2a17/sl/sUTj5sAqkr7O1+TttSs5I9baFVhAiJ+19S/vZjC6LtbHuqNP/lwTokcPTXw03epnx5XAO+FcsukRGa2c7FS+MRxbgxWQhQYSPwr1YOlBoLunYhsnL4RAywovg9QBuOfLj5etmoqvIiQrlQrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964085; c=relaxed/simple;
	bh=ipPVSrltL68WFAxL16SWSPWjN1lbX2e11+Sw/JBdxLs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qPbV6aKafwBXLH51Jh+WVayQ8L+KZHgC7hF0B6Jg+XOStnnpt6bIkEzEHg14JblwDtYIpj7V+Fi4fBII2JxIqnFRiemGIMGr98Q9vG7iHRbpHjpjASzYUvOt2VPiUNkOia89Z7dydyt7TGINE3dNcwbLSYGOLW3cYatJhXMpMQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZoJ3z/bC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZoJ3z/bC"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DF8KGE1860768;
	Mon, 13 Jul 2026 17:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=kZLHk+yRD01rKmLNo4uun6oXhpnOlpS+dLO
	rJpBhfCs=; b=ZoJ3z/bC6DDnwgSosju6G2CuZvWq5lhZstG2DCWkjr8LfFpG0Mq
	jJm1CidGt89uv/jIrjFZU+rKSvjux26Kz5R4/xMP53s8R9sB7njkG12OBYXmLjUy
	VoSDTbMK4nHCsM29oLMVVaC3zNNDJUl9itf34p+kVzh8GnXhD+phl0/dCMKO2M1g
	5XuZbp7Ozc274PY1FmDfLvZuUZ3HvaxuYufhObtYjsBD+HmFhqwD30pRskaAaFhr
	Uksb00RWq0BgpOT+4Vof9EC/UCisrvT6f3cLfA7wl6Gw7PYQSiEDa0ccQbevwcq+
	9jcV6DkDmLnP6HWwppDlfQ09ThUhU/lXgJA==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcuj02fm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 17:34:40 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DHYbA6027447;
	Mon, 13 Jul 2026 17:34:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 4fbewj8a81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 17:34:37 +0000 (GMT)
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66DHYbhk027442;
	Mon, 13 Jul 2026 17:34:37 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 66DHYagW027441
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 17:34:37 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id 3008E629; Mon, 13 Jul 2026 23:04:36 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V1] scsi: ufs: ufs-qcom: Enable only lane clocks in lane clock APIs
Date: Mon, 13 Jul 2026 23:04:34 +0530
Message-Id: <20260713173434.883386-1-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE4MiBTYWx0ZWRfXzGwIh2VFx9I7
 ajE5tX1yr+aunAeGpHf16ce0huJ79bRw8kyVFlbeqvDx6jomruD+ZrGuu65vcKXvWcCr1XrgewT
 fBWhGd2Vrlal1gDQji4UYWjLdEfxu80=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE4MiBTYWx0ZWRfX5u5QhxonDYqK
 4DSlYo3rLfLfLFEhL5k9WGFCdtZbnBNiWx950BQrRSHtQ73udH5/RzJCXFpTKGARpfoCcjzFtua
 s+IKnpYpIZIzib2O+zE3d3LuFkTZoA2FnfoojFtCZ8dJftpwb64B5nR4S+zh6CaQqEMHcanFaIU
 lx9v+L3vV+xlvH6m1UWenFVp9hxMQcyhZHAX5idwnFUrqCYsvHvxKQpHVPx/uPuRyLIcgxYpfdx
 wWZB07SL6OVSbP5JwJpkFDAWr8HnzzzDwToucyU7+D3Niokyon2sLl5K7Sfsq/SFpX5A9HHY/oL
 qqU8dgPo6fZGkhv1qMlA85U0h3Imv9+OJHNd3muYet18fdBLta0dYE2X3dBj7De+zODWa6KXeom
 7pxwFPQcQ2hjg1eP9og6xYG1m54Ep7Ui7YPhb+n4H2h7ZQvERiBHwMt4YgYIxuOvNJlWJ46nQiJ
 CnvBxgyA+d0pEnXClxw==
X-Proofpoint-ORIG-GUID: atXVeSU5mKjyM9WvbcACD0R50HsY1O6C
X-Authority-Analysis: v=2.4 cv=DbcnbPtW c=1 sm=1 tr=0 ts=6a5521b0 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=JbtLcMotAyZ5laay-40A:9
X-Proofpoint-GUID: atXVeSU5mKjyM9WvbcACD0R50HsY1O6C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_04,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130182

ufs_qcom_enable_lane_clks() and ufs_qcom_disable_lane_clks() currently
use clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() on the
entire host->clks array obtained from devm_clk_bulk_get_all(). This
array contains all device clocks, not just lane symbol clocks.

Since the UFS core framework already manages the non-lane clocks via
the setup_clocks callback, the bulk enable/disable in the lane clock
APIs resulted in duplicate reference count increments on those shared
clocks. The extra enable counts were never balanced by a corresponding
disable from the framework's clock gating path, preventing the clock
reference counts from reaching zero and ultimately blocking CXO
shutdown during low-power states.

Fix this by restricting the lane clock APIs to only prepare/enable
and disable/unprepare the three lane symbol clocks (tx_lane0_sync_clk,
rx_lane0_sync_clk, rx_lane1_sync_clk), leaving the handling of all
other clocks to the UFS core framewore.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 41 ++++++++++++++++++++++++++++++++-----
 drivers/ufs/host/ufs-qcom.h |  3 +++
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 291c43448764..7ec1626704c6 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -347,7 +347,9 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 	if (!host->is_lane_clks_enabled)
 		return;

-	clk_bulk_disable_unprepare(host->num_clks, host->clks);
+	clk_disable_unprepare(host->rx_lane1_sync_clk);
+	clk_disable_unprepare(host->rx_lane0_sync_clk);
+	clk_disable_unprepare(host->tx_lane0_sync_clk);

 	host->is_lane_clks_enabled = false;
 }
@@ -356,18 +358,35 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 {
 	int err;

-	err = clk_bulk_prepare_enable(host->num_clks, host->clks);
+	if (host->is_lane_clks_enabled)
+		return 0;
+
+	err = clk_prepare_enable(host->tx_lane0_sync_clk);
 	if (err)
-		return err;
+		goto out;

-	host->is_lane_clks_enabled = true;
+	err = clk_prepare_enable(host->rx_lane0_sync_clk);
+	if (err)
+		goto out_disable_tx_lane0;
+
+	err = clk_prepare_enable(host->rx_lane1_sync_clk);
+	if (err)
+		goto out_disable_rx_lane0;

+	host->is_lane_clks_enabled = true;
 	return 0;
+
+out_disable_rx_lane0:
+	clk_disable_unprepare(host->rx_lane0_sync_clk);
+out_disable_tx_lane0:
+	clk_disable_unprepare(host->tx_lane0_sync_clk);
+out:
+	return err;
 }

 static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 {
-	int err;
+	int err, i;
 	struct device *dev = host->hba->dev;

 	if (has_acpi_companion(dev))
@@ -379,6 +398,18 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)

 	host->num_clks = err;

+	for (i = 0; i < host->num_clks; i++) {
+		if (!host->clks[i].id)
+			continue;
+		if (!strcmp(host->clks[i].id, "tx_lane0_sync_clk"))
+			host->tx_lane0_sync_clk = host->clks[i].clk;
+		else if (!strcmp(host->clks[i].id, "rx_lane0_sync_clk"))
+			host->rx_lane0_sync_clk = host->clks[i].clk;
+		else if (!strcmp(host->clks[i].id, "rx_lane1_sync_clk"))
+			if (host->hba->lanes_per_direction > 1)
+				host->rx_lane1_sync_clk = host->clks[i].clk;
+	}
+
 	return 0;
 }

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e20b3ca50577..2fcc3bc1133d 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -331,6 +331,9 @@ struct ufs_qcom_host {
 	struct ufs_hba *hba;
 	struct ufs_pa_layer_attr dev_req_params;
 	struct clk_bulk_data *clks;
+	struct clk *tx_lane0_sync_clk;
+	struct clk *rx_lane0_sync_clk;
+	struct clk *rx_lane1_sync_clk;
 	u32 num_clks;
 	bool is_lane_clks_enabled;

--
2.34.1

