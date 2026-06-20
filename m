Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868511FA859;
	Sat, 20 Jun 2026 08:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781942652; cv=none; b=UUorMKMqMBk9RacfHCpJI9DcqWCl53xYh8271QYbps/EokAMGi+mSz0DK27KI46ONicMkPG2SiAdEyBlT5hOy9RBYm0Mfrp2ysrNhEXrs0sT024lkZCXSJyA0G6ndPC9dMhxYeo/T8BiTS6wkV0Hkfg6K4nV+Cfrl+OleMcI1EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781942652; c=relaxed/simple;
	bh=3z1ZGpe5Zg1cy0lpZzFR7LAsYffXCfoRoB82onCy2bw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Es+CQ71GWpchjerMl7gspagVqI1gr/XmpjPk+hpP9MAKbqtaLNQtusWpjKHPhEeAImyc2SeMweA/8zemH1x2AarD6vk6l/omR0wLXpGEwFBVijftG4SCW0b3WIRBWt3xyoSgCyKI6zlmBZbNnHnFjUpUaZ5qDbJpbxxzma8mIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LXcWT+Uo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LXcWT+Uo"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K4dgnh2152420;
	Sat, 20 Jun 2026 08:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7unrjdUYWRA
	1bYtNbcWwdUQXHeNnXNhCggjSl5BOuOQ=; b=LXcWT+UofdENsmQ+74pif4COFOx
	l+W4XV5SZ6dQ/Z2pUdAVAJn/nTLwZHKwq7wpTHaTfdHtiY3wEcGuBxDmhFjz62Z+
	iIx3Cqgl4csoGYJTli3O4vT1yDoMnIz94ng7kMmwTqPuzC/zDg3PL2FNjuW2fJ0j
	wM8cjUb/qP0d233HVUupA7jxEKANO0RM8SgVmlam20uoBFeLL7O1JiZlEyamjSuS
	AXGY/j4I+yTIi5+klrfXLzhiTExITWX+ZZL3ljXJTO/lgSFUrGoEcfbOZ7ip/sYk
	tJMItwiMI8wBK0x5rXwOSWagO4C3OgUFc2ec+Mu1E+qsfKbQCnqVcldvvng==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ewm1k0b1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 Jun 2026 08:03:42 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65K83fh1024761;
	Sat, 20 Jun 2026 08:03:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4ewkxj15yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 Jun 2026 08:03:41 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65K83fDv024755;
	Sat, 20 Jun 2026 08:03:41 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 65K83fdO024753
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 Jun 2026 08:03:41 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 6A724644; Sat, 20 Jun 2026 01:03:41 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX EQTR
Date: Sat, 20 Jun 2026 01:03:21 -0700
Message-Id: <20260620080322.3765210-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: y6uRc644oX3YkNW8ZgP-rPGj04kBLBvy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDA3NyBTYWx0ZWRfX1A5aRGKjZbs/
 VB6e5Og9pqfGjCBAQkFOZLOhn3zHl6eyjxvF4KjnLAUyagMjbKNWjVeWTBZDTG4S2l3DBpAkXl5
 8nhqHcGvl5Hh7RxyIPngbii7HCQ710s=
X-Authority-Analysis: v=2.4 cv=T6S8ifKQ c=1 sm=1 tr=0 ts=6a36495e cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8 a=MY0Nf5o17odUSmN9C4UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDA3NyBTYWx0ZWRfX18tZQp5Do4Dl
 rU+qcmjRA7mmPa3eDg/NGm3zM3emHqn6u4nOlOWBUHLkfoD0oRPVa+9TuoXdcIKnUjXMGObhKXN
 a/Axn/+dyzpbKJ8JKROXChMuqxq1r0Enht/ECZ1cSzEN84DOIrfWqlggREJYxmA4tdzjpcKWFZ9
 3v19mB3UnIvWglxEt9S7RPffuBM7v27C5PB+HZ/qTofB4hVw0QZ4EvgOGcj2s/y4GlrMvLa1dDB
 qjbk2ythq1oNHlV+j7IZPQ/2IA7OByFGCL1VWT7D4UVwFyPLeAO/nRar0gji69NhBOrI9bbriVF
 s7MC7cW2ELJM35qFznEb3EZdNwdBVoxgLO1wBNfw/4Giqel+mGgmh/x3WsBCjGDkBavU4JMdCI2
 HoioNX9nVz77VblwGUroLo0Hu0bxPhv+85oFEnM8iayWFjw5UYlOLeMye4r8D4SK69b0gRMmZG1
 R8ax0V2LqXwW9yt1xKw==
X-Proofpoint-ORIG-GUID: y6uRc644oX3YkNW8ZgP-rPGj04kBLBvy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-20_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606200077

ufshcd_get_rx_fom() aborted TX EQTR when a per-lane RX_FOM DME read failed.
That makes the whole training flow fragile even though these reads can be
treated as best effort.

Keep TX EQTR running by logging RX_FOM read failures and continuing.
Make failed lanes deterministic by initializing each lane FOM to 0 before
reading and only updating it when the DME read succeeds. This avoids
propagating stale or uninitialized values into EQTR evaluation.

Also update the kerneldoc return description to match behavior: RX_FOM
DME read failures are logged for debug visibility, while get_rx_fom()
vops failures are still propagated to the caller.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 9dca0cd344b8..23a12e221d31 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -482,7 +482,9 @@ static void ufshcd_evaluate_tx_eqtr_fom(struct ufs_hba *hba,
  * @h_iter: host TX EQTR iterator data structure
  * @d_iter: device TX EQTR iterator data structure
  *
- * Returns 0 on success, negative error code otherwise
+ * Returns 0 on success, negative error code if get_rx_fom vops fails.
+ * RX_FOM DME get failures are debug-logged and treated as 0 FOM for
+ * that lane.
  */
 static int ufshcd_get_rx_fom(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode,
@@ -494,22 +496,30 @@ static int ufshcd_get_rx_fom(struct ufs_hba *hba,
 
 	/* Get FOM of host's TX lanes from device's RX_FOM. */
 	for (lane = 0; lane < pwr_mode->lane_tx; lane++) {
+		h_iter->fom[lane] = 0;
 		ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
 					  UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
 					  &fom);
-		if (ret)
-			return ret;
+		if (ret) {
+			dev_dbg(hba->dev, "Failed to get FOM for Host TX Lane %d: %d\n",
+				lane, ret);
+			continue;
+		}
 
 		h_iter->fom[lane] = (u8)fom;
 	}
 
 	/* Get FOM of device's TX lanes from host's RX_FOM. */
 	for (lane = 0; lane < pwr_mode->lane_rx; lane++) {
+		d_iter->fom[lane] = 0;
 		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
 				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
 				     &fom);
-		if (ret)
-			return ret;
+		if (ret) {
+			dev_dbg(hba->dev, "Failed to get FOM for Device TX Lane %d: %d\n",
+				lane, ret);
+			continue;
+		}
 
 		d_iter->fom[lane] = (u8)fom;
 	}
-- 
2.34.1

