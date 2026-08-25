Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4FA48383B;
	Tue, 25 Aug 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669544; cv=none; b=l+PMLbjOKYQTwekM5Ts1sEMpUISLKnLRx5UMlICfJZhmPh5/TraRMquaTMcIoGXB35avemgL/DIMQ+f0PWd8pQX3lNDjKWi2EaeKRp3HK1Du5HQZc3LNW8OhRtYJh5c8QZgQYcVzJ+10ObZXZvx3+HrgRnT2RFN3XZ4aOjx+p6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669544; c=relaxed/simple;
	bh=2bl2PMElOywA631gBipPfp+qpZ6o9DDcnGbKY6RRhV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pKZwDyWaEuTH738UPu4iZCO5iB+p9gGcCLEka5j2hNdGWDBy6SvTKbNIWxxWC53lW6IJtt6Scq1s8qVskJ6m4Cpqq7ZvbRhyci5OOwqkgDee4D93CtwydRTDkWvqgyIkYqFNm/3/jFjnC9vxEVCU741Pg/CGM5bW3M+AbajZhLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VuAl7BCE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VuAl7BCE"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PEUchg2023585;
	Tue, 25 Aug 2026 14:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uXZpmHePpQu
	PO4WCaJKivAoyDwAJFgQF4WYY53v05Vk=; b=VuAl7BCEemsPbU0e/dmhK4iBu0N
	wCbdYXGHbShmM9dIdmF86ppzHHd39xtxxGXWRYFqsfN2RikN8jlCNtKdgSWa5hsk
	KvkKfKZKmGnzZUicfltro/H+WaMu3zHYaczivLNE5ouVl7vxSjLhnclyPVY1JlQF
	dj1JauF42lp+foszAhZICk+0WcpfuopP3QQpYgioRjjWzZWZRTBXalBCFsvnVKcn
	rLKdgcA1j4+3wZAbsdw+c3ZD266VeWv3NysWeDxmsO5qBn0aNA48JOXES7HhfLTS
	S0mV0bhiTsLEcEATzk/L6yPHO7ywp6Y4iFzpoVibTNNMCCGolnxHHOpeQ6A==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g8y5jkcab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:10 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 67PEq6Cf006114;
	Tue, 25 Aug 2026 14:52:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 4g74uk1834-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:07 +0000 (GMT)
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67PEq7tS006125;
	Tue, 25 Aug 2026 14:52:07 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 67PEq6Le006124
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:07 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id 63C1664A; Tue, 25 Aug 2026 20:22:06 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, konrad.dybcio@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V2 1/2] ufs: ufs-qcom: Restore HS/LS link startup mode for Qualcomm UFS controller v6.2+
Date: Tue, 25 Aug 2026 20:22:02 +0530
Message-Id: <20260825145203.265579-2-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
References: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=O5QJeh9W c=1 sm=1 tr=0 ts=6a8dac1a cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8 a=dRvyu5y73qj8B1pFkUQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDEyNiBTYWx0ZWRfX6p4EG8kn0PIJ
 D6u0BXhC9QHZYMaUKM+UnWJuKq5G6x8NLqEwcKhNoT4B1NnSgAqQmEIAQo9ZmAPLna/tjLIBHwR
 oc6e6iIJ+hb+vA8MVRkS+t+Ps8tOXwRCkAn3QIm6U0rdXOD63lBwfPXZQn7QwiS5fTWc8LeubZf
 TaM0hmtSiBTG9NWdT+VqWZAXYkmdbiyQGT1CEj5P9i6GTTYzlc9IpgHF25cHdf9RqTJnaOLKTt/
 4B9wscng7Ycz9nRGiEc2X90e1Kpbm8OLCEDSaGqvzdeThmrxLujisc2DnZQn29HzU8cuzwvPOc6
 NKvUFljRJgZrURtL98B5KBOtKn8KGL6egMhDwZttqqC7Mw7j6dQpOKHYzArJSY7HCn2hNCtJT8R
 gJ09PtKwVqH6NEGMN+RIU+rtVrU1s32bnsnwMUvpLJDkutM161SrD9+P/3w8lgA6OwOPQ1Zp4fC
 8AjzrP1tsIEsyPbd8EQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDEyNiBTYWx0ZWRfX5hvXEsJNIweT
 dzMAENganiCbC/6szohMtV7IuD1YrAMZI2IVZfnd96jVdJBWwoDCV3H+Fv95AZmAhL1I9xu7Ezl
 9m4M9DFcASLT6KTKfn3evjqbC1bEu4E=
X-Proofpoint-GUID: 1jJ-4kq70FKlV4ADtBFscWHQAo-NEn8E
X-Proofpoint-ORIG-GUID: 1jJ-4kq70FKlV4ADtBFscWHQAo-NEn8E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_04,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250126

The link startup mode (HS LSS - high-speed link startup, or LS LSS -
low-speed link startup) is decided in the boot stage based on the
bootconfig GPIO. This selection is carried forward through the secondary
stage bootloaders and finally to HLOS via the spare configuration
register (REG_UFS_DEBUG_SPARE_CFG).

On Qualcomm UFS controller v6.2 and later, bit 31 in the spare
configuration register indicates the high-speed link startup mode
selection, as per the Hardware Programming Guide (HPG).

The spare register value is read during host driver initialization but
gets cleared after UFS reset. Preserve the spare register value during
initialization and restore it during link startup to maintain the
bootloader-configured link startup mode.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 15 ++++++++++++---
 drivers/ufs/host/ufs-qcom.h |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 291c43448764..35bb9ab5fa2c 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -715,6 +715,7 @@ static void ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
 static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status)
 {
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	int err = 0;

 	switch (status) {
@@ -737,6 +738,14 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 		 */
 		err = ufshcd_disable_host_tx_lcc(hba);

+		/*
+		 * Restore HS/LS link startup mode set by bootloader
+		 * after UFS reset clears REG_UFS_DEBUG_SPARE_CFG.
+		 */
+		if (host->hw_ver.major > 0x6 ||
+		    (host->hw_ver.major == 0x6 && host->hw_ver.minor >= 0x2))
+			ufshcd_writel(hba, host->boot_spare_cfg,
+				      REG_UFS_DEBUG_SPARE_CFG);
 		break;
 	case POST_CHANGE:
 		ufs_qcom_link_startup_post_change(hba);
@@ -1325,7 +1334,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
 {
 	struct ufs_host_params *host_params = &host->host_params;
-	u32 val, dev_major;
+	u32 dev_major;

 	/*
 	 * Default to powering up the PHY to the max gear possible, which is
@@ -1344,8 +1353,8 @@ static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
 		 */
 		host->phy_gear = UFS_HS_G2;
 	} else if (host->hw_ver.major >= 0x5) {
-		val = ufshcd_readl(host->hba, REG_UFS_DEBUG_SPARE_CFG);
-		dev_major = FIELD_GET(UFS_DEV_VER_MAJOR_MASK, val);
+		host->boot_spare_cfg = ufshcd_readl(host->hba, REG_UFS_DEBUG_SPARE_CFG);
+		dev_major = FIELD_GET(UFS_DEV_VER_MAJOR_MASK, host->boot_spare_cfg);

 		/*
 		 * Since the UFS device version is populated, let's remove the
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e20b3ca50577..a5ad5ce44a19 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -361,6 +361,7 @@ struct ufs_qcom_host {
 	bool esi_enabled;

 	u32 saved_tx_eq_g1_setting;
+	u32 boot_spare_cfg;
 };

 struct ufs_qcom_drvdata {
--
2.34.1

