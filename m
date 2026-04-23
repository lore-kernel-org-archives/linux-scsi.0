Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CF739A06C
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939643; cv=none; b=cvBbJkmur2iae7O3OcTuNMJdbAKDTxLWqzDcKCkQNA1HbFvhw5kTGeYXEK/oS4e4rtZDbQtDf1MK4lsM/YbaND3KGQiQo9sesmB53mKaEquWN+8c7hFMKbluo57jolGWx2c8FISZm9JyY/Sj3mOlI6kV94nkDgj3+QPCF5JipI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939643; c=relaxed/simple;
	bh=CQVFJ4wMQF0hgf5u2ec7VO1+/3jUN5TRf8lbubOO8vE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jjkwANQTmAP79/+3CkYrrb4iT8tDGvNQ2YBibbu2rI2WSXlt2P7gIGz1KKBnDS0E2hFwtV5QWyPyIHNo23WFPA7GFs7LVdcnIvVDRcxshholzVQs7t1ePqX1lhs0S1tiDUR8GbWCDCEdBTiE9r3jTKXFiWiwqtxM0qUHfSl+Z2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cSH2+rP8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bIsWI9UH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cSH2+rP8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bIsWI9UH"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8uEdj3044047
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=K2aCxihMjpa
	uQgN1WTh46/Nuz1bB7Gm7H4WECMbk68w=; b=cSH2+rP8CtzI+Nu2o7nGcTYa5W4
	YLRhl9mtZ39Q6SONJq4hZPaj3obAxR1Rv8yNahrFulx0V59fBfGu6709kmwicPc7
	NSBMWVx1Ikeu5yzO7IUw18yrXQgHeMzScLXua+K1w250mYFBW36VfCrgxkRl0bkm
	kN+QzZSkAYZZO0lzlnuHITWal2n8g3o742EToQhs9ii5zIqE8XCGtfa25ifhLeEd
	wgHkPEpjIsseOHVWGRhLExZkCK19y+ru23uJtheMivuIseWcsKRksqGPVLB7RcYl
	3PGJIKiM/5BdT9JZDG6m8Uouc8l4vUtxPKfzZDTGz1AQ9p3Fyw9DOpYkdWg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq1jh3cwn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:20:40 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3568090851aso15745368a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 03:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776939640; x=1777544440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2aCxihMjpauQgN1WTh46/Nuz1bB7Gm7H4WECMbk68w=;
        b=bIsWI9UHknfM2IOfKRbsYXL770SpH1MBKMqasnZ7Qtj+lDvgc27COWzhAMNJmJ8vgP
         5f/vJ3FRTFcQ72DjqWvWmfyulcuQ45FzXMIlLTt9RgKIZan396ypysk4G06+7zGbPLOX
         sdPIXmpZwajI8ywx24YQvDUm+7wE9VD+6rzV4y3EOQrCrzlF3tgCstmlE1leOC2yq295
         lycRCoECMyQb0Cl0qbYdACuXdA7ssRkCVdepnB1T2iMTCZikeMFbt+/HPZiO85G93Xct
         kkWduq+GysKc7SCYJBsSIu2KUSPqnJKqXY+rGmyxKidnk8QcX7Qv2gYWOsW9wlmbTmpe
         Pqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939640; x=1777544440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K2aCxihMjpauQgN1WTh46/Nuz1bB7Gm7H4WECMbk68w=;
        b=Y/B3h8zh4uSQdMy8qn6GnGCs1pnlwQfbiE0b9vLIqoNqENKP/cTmgufEMc77b6Vvkh
         OyqYxasFYb1/XP3BuxU/3prIIBoIFfh16ea33VlZXMonZBaO4P0lW4bPsyeBONRtIm0k
         BRzlkMAnroA3K0m/VPXWKFj7JZO3c+vO9B2llU+ISc87/FxjxxEXcbOZFkRyCfxOD0sJ
         +lg7elC3YCsVchG07Y2x8q2r0QeU9Cipzw2L1tQZ/RUi4nCd3pITC5GE9kfbnjpjOGAI
         rsx79Eve15nIjdi+VvD2OOeIi68/QDV2D3qGNvbJ76RTncNYW7dwc/eU+SsNOk7Yx1+N
         xlfw==
X-Forwarded-Encrypted: i=1; AFNElJ/Pz0aNOI1caeuCTje5p2zO357JfY7CSxGbzUReMstDgb3NLhLRhet9tgDxWqQ2XJ9vi2DiBSzBcBrV@vger.kernel.org
X-Gm-Message-State: AOJu0YzSk9vbSBjlGxNEATFFhj+ofC43Z24YpumaQ9Z5nFf/pxP9DYA2
	hRUULyrGdLFCoRn7NLVyT0BvWTdmPBPgiAqMxnBl72P2ipSeDVvVtpD+22TbCmjGqj9/p6XI0N4
	paiMaBBgXNk6wCh+7K5w9NXuUN7K965cjqpteHp32iLsWANr7U3AOWeQrFv3dLcUr
X-Gm-Gg: AeBDievYIdnBhFD1m3qL1I5MbjHGi8Y3+UMYxWZ+w8/txf/apjBUHGVRfQ72ge6NdlY
	fd2wj4QrCXMI+lWEzDhrTFSVNDc6zwuv5JPvnK3jDKkY412is+yM0YydBDQfbl4oYH3zY5s2fNe
	lM3WfxHpnasX15JtYbe668AVZPm92QsanD6lUJNCVqdj5cNSjqryr/QckV7lslNcinaWZwMKqDg
	mXoVSmboSFP6CKkgvPQdzovIaa7FOO68UzFYtn/CYXVq2N39M19aOEiBzTXm3cmKQi7TCPPFGsY
	p9vcIuRkmZR5O3Rq29/wnlZuH6OPSqLsEzshbDYvknTRcOmJPKV+HkzKKBovRX5jV1Z1j0c2sWC
	Zks9v376CDMhTeICdmOTHkuPz82cOEllR5lRnZHhEkBfRl52tYmdAG+M0GFbfwumo
X-Received: by 2002:a17:90b:5203:b0:35f:b9ea:8f9f with SMTP id 98e67ed59e1d1-36140464842mr23785780a91.16.1776939639931;
        Thu, 23 Apr 2026 03:20:39 -0700 (PDT)
X-Received: by 2002:a17:90b:5203:b0:35f:b9ea:8f9f with SMTP id 98e67ed59e1d1-36140464842mr23785738a91.16.1776939639432;
        Thu, 23 Apr 2026 03:20:39 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f92183sm13944461a12.3.2026.04.23.03.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:20:38 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V7 1/2] ufs: core: Configure only active lanes during link
Date: Thu, 23 Apr 2026 15:50:22 +0530
Message-Id: <20260423102023.3779489-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260423102023.3779489-1-palash.kambar@oss.qualcomm.com>
References: <20260423102023.3779489-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEwMiBTYWx0ZWRfX+Su0NJU+XKDv
 2JD5nRE2XVRHKFed7fVWhPZHVfaZ7/yLHv6wYv8dRPZj8tKycmC5izgOYjW57rKq1SfeW7+dka2
 I2mteHQ3cnjGLU57/hnTxAsj3qpwYL2NFDPDuHyDtG2YMz6wgFAaDTEHLqhz0AwHrwZNrbiAuD+
 xSoZT8KdViyVCTrv49F4U9zmHpstrC6g4S/pwX/pvB/q3/EOWBD3YQ0u3FsJJMSCFFB7Y3dWoXG
 HizQ3P6kJza7LDYMIQ5uDWgCnysjGFv/pANIk6D7EBBEgjcXdVsnGo5A+oY22+VXnZJmAhbUbU4
 cGMFgQSXKwmF0ZELXNDx+T0z7mqQimNqVBtx5BY72GWTorREZQcEjjYKqMcpI50EWGyEkEOHgS2
 C5Xj9RZ2hG4xDl8E5lSd8602A9zce6gqCukeY1SIj3NyqcYHK1Cc7UiCDLHZetBhsFXge594Uek
 vgU+LkeB08MpmC+/cTw==
X-Authority-Analysis: v=2.4 cv=OeyoyBTY c=1 sm=1 tr=0 ts=69e9f279 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=N54-gffFAAAA:8 a=s8YR1HE3AAAA:8 a=VwQbUJbxAAAA:8 a=Z8YMyZzXpU5RQDwMThsA:9
 a=iS9zxrgQBfv6-_F4QbHw:22 a=jGH_LyMDp9YhSvY-UuyI:22
X-Proofpoint-GUID: x1ybUQ4IhWJfHmJacQMZFk4BdG4trp4c
X-Proofpoint-ORIG-GUID: x1ybUQ4IhWJfHmJacQMZFk4BdG4trp4c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230102

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

The number of connected lanes detected during UFS link startup can be
fewer than the lanes specified in the device tree. The current driver
logic attempts to configure all lanes defined in the device tree,
regardless of their actual availability. This mismatch may cause
failures during power mode changes.

Hence, Add a check during link startup to ensure that only the lanes
actually discovered are considered valid. If a mismatch is detected,
fail the initialization early, preventing the driver from entering
an unsupported configuration that could cause power mode transition
failures.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 31950fc51a4c..81a71616230a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5035,6 +5035,35 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 }
 EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
 
+static int ufshcd_validate_link_params(struct ufs_hba *hba)
+{
+	int ret, val;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			     &val);
+	if (ret)
+		return ret;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		return -ENOLINK;
+	}
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			     &val);
+	if (ret)
+		return ret;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		return -ENOLINK;
+	}
+
+	return 0;
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -5108,6 +5137,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	}
 
+	ret = ufshcd_validate_link_params(hba);
+	if (ret)
+		goto out;
+
 	/* Include any host controller configuration via UIC commands */
 	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
 	if (ret)
-- 
2.34.1

