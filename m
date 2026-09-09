Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF513559E1;
	Wed,  9 Sep 2026 05:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788932401; cv=none; b=pA+G+/XqSAiAi8T+UYOBCildsy5/zsk/Mxt173Ynp4MuHe5e9W/f+GKfpbZZ8N4oW1tmCg24xs3NoUrxwZPOLL8q8t5ejM9WTvniceUBoMOCxuHdV6zgz/ArUSTN/qeY+Vg7/ygfdw5gBtEY22pPM0D+TodmTarQuZIDeGY2Ei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788932401; c=relaxed/simple;
	bh=eRLd7zKH3n/0gihUIl6MAKmNV6UvRpIkCOx3gB849HY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KK473di//rQ42WbDFjfAl5G2YjyQcduCo3onfDJKg7EkmtamKIJd2gWJMfwtn5Ax1GITdLjtVAgpt/mhC95UPYBA7BUESSh9vW8LzMpLmVzbT/UJ+BzU+bGOMwP9U5w1nuV1szdrnv1wGMKUcz5StRbz7+jkkJodRG/nlf2LxgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OLzBjy5n; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OLzBjy5n"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Mg5fR1274431;
	Wed, 9 Sep 2026 05:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=nhfm6uEPdDFtO1sNsFI94jWt8J36TIrUt0n
	9IMng61g=; b=OLzBjy5n7zZYtnOeVJPM/3ATkuuDaVLWgVmrXWgG7X8RlG7Ckvx
	Z1fD6eff/qFQZMqqRA8xcMmxwG2C6DwjKsoa81Lz+AAUypB8bKri7EprGl7Q1z9X
	1SRMcOc6tDPXVCbwrXqN19Ukt6RJc8el/aXSdt+8zn68V4yig9z0M/h/T8EMaVCT
	FRp8D6PO8GLsdSWIZZ3m4137Idp7u73J4xBhDfhl9bbXS4DquQCA7xuo/N1y/cKy
	DiHMchc7qnmtKPLj9qqpCCZhvJpmBEnMzFHRkvIxc4tlUaH2gEtSsPowAgRQIfsy
	l13omCjgAv/UIljJEwoVA0eyYaAsfDflXsA==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjqdw2ehd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 05:39:54 +0000 (GMT)
Received: from pps.filterd (apblrppmta01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTP id 6895dpjx3082257;
	Wed, 9 Sep 2026 05:39:51 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 6895dowQ3082250
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 05:39:50 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id EC673649; Wed,  9 Sep 2026 11:09:49 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        konrad.dybcio@linaro.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V2] scsi: ufs: ufs-qcom: Enable only lane clocks in lane clock APIs
Date: Wed,  9 Sep 2026 11:09:44 +0530
Message-Id: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Reinject: loops=2 maxloops=12
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-ORIG-GUID: e0ncjI8vWPUcQBEVlG6NPu6Zo74Pn_Xx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDA2MSBTYWx0ZWRfX/XHcsTk/WTur
 6IgwAaaUqQDOQr76FvgWNKiBDmut0gN7/XiU9DZ5wF1sB2H/f/e6jHUROQHU1VUBHNKuSx9pju9
 KJ69R5O6fB2DoNwabU+wyBWromXoIe8=
X-Proofpoint-GUID: e0ncjI8vWPUcQBEVlG6NPu6Zo74Pn_Xx
X-Authority-Analysis: v=2.4 cv=Bo2tB4X5 c=1 sm=1 tr=0 ts=6aa0f12a cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8 a=kaQ9LzzmEayfo5emOsQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDA2MSBTYWx0ZWRfX1E7uJfvgGWJh
 dn6QvkjyAXUazlZGnWUXjjTzaVaQp2/fFzTC+gY1hsiG3RhcIiBaVylOFYOOy7E8TpyEIPtjzM6
 CTxhusFtmmrkNM17MzLGXg3RC5KCAT9T9lsfX1U/bIbY8BDsT7wcnlGYiFgnC+Yn4s/gvz7+eYv
 jhkwm+MqPb0WNibl58BzJVlvCe09/c7ANUwQQkT4+5CKNZvL9ZiEI1PwrJFJfxKXCSyoXhrYKiL
 sMX/cQ6j7P5TCFgCvppU4JYJlBgD1DW3R8v/6aB1TcRUPdGOVs/pbDnHO1Vf9rtoc83hFyLtjoy
 bAeHF1tSmXgwzkqupObzOfQbVjqS3X2GyyRoHSH0CGpt0yuKPS9A4AePE3qj4qju/pNbTwXEP8m
 uz9VVxjnoE9l4dsxx/AOG+h0iuwibVM6c5CuiIAFTtGb1kQM22slKu4BKK7TeSU2/QLphQE0B0X
 CXG0QRzxIQ6lKawaOWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090061

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
other clocks to the UFS core framework. The lane clocks are now
acquired individually via devm_clk_get() instead of being looked up
in the bulk clock array.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
Changes from v1:
1. As per konrad's comment, used devm_clk_get instead of to get
   lane clock handle instead of using bulk call API.
---
 drivers/ufs/host/ufs-qcom.c | 47 ++++++++++++++++++++++++++++++-------
 drivers/ufs/host/ufs-qcom.h |  5 ++--
 2 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index aa2ac2cd2b69..50f34d1c5fdb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -348,7 +348,9 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 	if (!host->is_lane_clks_enabled)
 		return;

-	clk_bulk_disable_unprepare(host->num_clks, host->clks);
+	clk_disable_unprepare(host->rx_lane1_sync_clk);
+	clk_disable_unprepare(host->rx_lane0_sync_clk);
+	clk_disable_unprepare(host->tx_lane0_sync_clk);

 	host->is_lane_clks_enabled = false;
 }
@@ -357,28 +359,57 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
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
+
+	err = clk_prepare_enable(host->rx_lane0_sync_clk);
+	if (err)
+		goto out_disable_tx_lane0;
+
+	err = clk_prepare_enable(host->rx_lane1_sync_clk);
+	if (err)
+		goto out_disable_rx_lane0;

 	host->is_lane_clks_enabled = true;

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
 	struct device *dev = host->hba->dev;

 	if (has_acpi_companion(dev))
 		return 0;

-	err = devm_clk_bulk_get_all(dev, &host->clks);
-	if (err <= 0)
-		return err;
+	host->tx_lane0_sync_clk = devm_clk_get(dev, "tx_lane0_sync_clk");
+	if (IS_ERR(host->tx_lane0_sync_clk))
+		return dev_err_probe(dev, PTR_ERR(host->tx_lane0_sync_clk),
+				     "failed to get tx_lane0_sync_clk\n");
+
+	host->rx_lane0_sync_clk = devm_clk_get(dev, "rx_lane0_sync_clk");
+	if (IS_ERR(host->rx_lane0_sync_clk))
+		return dev_err_probe(dev, PTR_ERR(host->rx_lane0_sync_clk),
+				     "failed to get rx_lane0_sync_clk\n");

-	host->num_clks = err;
+	/* In case of single lane per direction, don't read lane1 clocks */
+	if (host->hba->lanes_per_direction > 1) {
+		host->rx_lane1_sync_clk = devm_clk_get(dev, "rx_lane1_sync_clk");
+		if (IS_ERR(host->rx_lane1_sync_clk))
+			return dev_err_probe(dev, PTR_ERR(host->rx_lane1_sync_clk),
+					     "failed to get rx_lane1_sync_clk\n");
+	}

 	return 0;
 }
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e20b3ca50577..37f6e88b0adf 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -330,8 +330,9 @@ struct ufs_qcom_host {
 	struct phy *generic_phy;
 	struct ufs_hba *hba;
 	struct ufs_pa_layer_attr dev_req_params;
-	struct clk_bulk_data *clks;
-	u32 num_clks;
+	struct clk *tx_lane0_sync_clk;
+	struct clk *rx_lane0_sync_clk;
+	struct clk *rx_lane1_sync_clk;
 	bool is_lane_clks_enabled;

 	struct icc_path *icc_ddr;
--
2.34.1

