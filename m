Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DE3A1A43
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776858604; cv=none; b=QgSfgqfPoEQFI6hKVI0HRQFTE+yG9OEu0JqL9xi7/mjtJcRyvxg7v9zHCe6j9jLNOtvawSXiyYnzu79iJXlBenQPjaWlh5CK/7nDn5vSwwEdkyEFQPJuOeq3SrptsIoWg8nh5s8lBJkP/0Vv3VxU2lREnDR6ipGREY4OxB8S/6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776858604; c=relaxed/simple;
	bh=93ZtNV79vuouAa8eL2edT1/Lmp8ZOeyQQhyPpBYjjwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JBau/o/CxTF2uK/On4OOdiNYnJOKEnugyEOKUflQrJPRJEGrsrAoEe5i9Fs3JRAyYfiJgBM2x02jjbtuGyOpJOlaREMCmZDaz9yWjWy5ik9FuQbgQ8NiugQGHHGMyprj+7/bWaxn10imPLJUnbJ3LFWZPV0eaNJyXFdRvCQqYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e5oqQTvP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DXODdqxb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e5oqQTvP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DXODdqxb"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MARsgo3377462
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9koPVHXl3Cu
	mpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=; b=e5oqQTvPFLcTI/mhg3CPLHqlBNV
	LplqfeDS4XuKJNeg7SP/ndEqo4PbJIUdSnhW764QCT9WzPBKRyUsAdxxpxVaz5BJ
	97UhPOmt3BxYSdMPIZNC/gcZRhKvmLNqjq1RdBS6K8EH6ZDnnAKWysP3fmX6vOW8
	AgmnjDfA1VR5UIgJnpvxZF5bLauee3AH8DQSx2/chRJpHucpvDlbBT+hf6QhU4AQ
	OeGuBBGV7noj6aUbRxEjnirCPwVo3rmDl0V2fYMK9zt+otpSK6WWtUTYK2rNm9uQ
	TqSuVccYEwxz7Z8qbyEURLU4tNZN74at868lDXT5bj81KRDzbBAhs6Yns6w==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dpeng38r7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:50:01 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b249975139so99545045ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 04:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776858600; x=1777463400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9koPVHXl3CumpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=;
        b=DXODdqxbmzEScpyUkj0UYlGYL3LvAN+ngSXDRy9QmrPSXFmWEnz5hBaS4NYY4Fq8qz
         hsvPNctzCUSWFcXlsBIxN5zTTdL18fIfo+4AhvpkXzx+EJ2KfGnLuT302YJDHdtSZuDZ
         l2Cp+RE3sVtkRvENJ1+9oF+FaWQPWTJU2UTlm+mBcdjLszGtUCUTwkfN0X5wJEXNylsF
         NyMzj3bMfxQCJ5xUq06VItlZB0Y1YhdU0XK0Y+MhI38pLGT1p3hAK+IrCZEFSVOplj4q
         MMau4TZnc9Up4D+18Q841jfumtCtilw3Fk+Bupq7s+vhPxjXve7ePlqpy3H3nAwmxS1R
         7BZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776858600; x=1777463400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9koPVHXl3CumpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=;
        b=hrtVr3X8xA9XKICoujVbdQXYQVWnWyEVi1V/qIkHLK64D9RP8NkkMHRGkHLS+j1KXn
         vTzgnqRgn9VOg2PGeyoh9TXuLv4R1j3RboKWeLSdsTVdM4A1fbnfosnVU27foZuf08uE
         CpYOWKIu+qJsqSGWXNnLy1oYF2zoX3ANqrBV6kUpSNyEQHIy1YE+oQsIP8NSUqgJ+0Lj
         WjgFYf4LxbqXebLa+OlyRj/tKJQlmpGRb8m2G31y94UzREWiP/YxbGI8+kqQAL0c66UX
         2KPP0z//kaXc8BU6MuEp4HOesjI1jAFQDv4dxStxoNeHkiqzvGse8AXZX8N4P2TQ+aWZ
         IopA==
X-Forwarded-Encrypted: i=1; AFNElJ//phiJT6sfuFtZzzDn45CiIEdsfEG0k9L0IrV+veO0689wfuwdB5Q7UdyENkl/Q6hQ7il6LjjVD+rv@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8pHUq9dtfxMdPt7uXuZQqE6Y+Z7NQrbp6r6F564PWSAlWLx1B
	wz5GU/iJVOpAG11tb5KLFGLLgY8ZelK7rHVsNr+urS3re4LwSX82VkOa5dWIMj+fWf5TYoGH6eN
	HJk2mCfS/1j/s1e3PdRJ6VEGulrArl2cs+3KlW66OgpJYJk8VhNoR21u7AFP6nFFMsjAOHG6M
X-Gm-Gg: AeBDies+8VyE1IutQR6/Ak9zPNbXAqhzWgkw4BgTCSTnK7ogN4Y0+gYVQcbrQK/+Yuo
	ygLBSeVuRBjyOYgxbdpjybkqIIXz3i7PSKryevbSmax1gF95/bpxQqkzw7QmodSVB2MnZHgZmn3
	AccFQ/tkx7FUYzCcEJQT1LbggYBe4ZkgdCIGpSSU39vP/fO8d0QZr/QOgaUVdJh1P3sJHtvW36j
	kZ4WA67JF3zmmmZ2re5/TEuyBNGjTAhBL90dDVkiCnek+Im+0rC/D9KO2E0JcfeQI7AG23K3GYu
	bAI/pBUPbslm+DrhP6BBjvEErzkW6QpFgIg9yf0XaYglXw2Q4P8wT6otSevjsvlqKMM9+yk9QLc
	sQujtyg7hXHiS0TOZCmy/CJC59LCOHWvwv61pC8yRzaD7Iv4qoii48QkIVDZmj53u
X-Received: by 2002:a17:903:1cb:b0:2b4:5dad:2523 with SMTP id d9443c01a7336-2b5fa003d32mr238398265ad.35.1776858600070;
        Wed, 22 Apr 2026 04:50:00 -0700 (PDT)
X-Received: by 2002:a17:903:1cb:b0:2b4:5dad:2523 with SMTP id d9443c01a7336-2b5fa003d32mr238397925ad.35.1776858599606;
        Wed, 22 Apr 2026 04:49:59 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa34ea7sm163047125ad.34.2026.04.22.04.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 04:49:58 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
        bvanassche@acm.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V5 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request support
Date: Wed, 22 Apr 2026 17:19:39 +0530
Message-Id: <20260422114939.2901925-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260422114939.2901925-1-palash.kambar@oss.qualcomm.com>
References: <20260422114939.2901925-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=CNUamxrD c=1 sm=1 tr=0 ts=69e8b5ea cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=gce-7N_bzMkFAa6Kq10A:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: YKvw0CV60U9QJxpP6nKVlmXHao8VGh2c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMyBTYWx0ZWRfX65jvUOTDUCEB
 uI69iU+TBykF6FBqeJZt8rPpwfH4vm9pBH6JQxpssBcWSoCtROrezcJBaBRAFi7R65C3ZIopwZO
 AG0dOntZpMHvvhpQGyb3YyOqpNdRdczgJysFzRPWakMVCdHmtlnQJ4qGwvx4/euYQJtALSQ6SyR
 7vhdRKqiSGpIxKv+x7SWu7+RfDIG5iUlKYI1wp6h/o5I4I/Z7AuHDJACdoAM2tHYrQU26P/nUff
 COpA17n7cUImmI0f73UaAKp2sDhZrXKxfWWiMkFceFDOlZvtDsdiOEThRdAcDDvmgdZ4v+LCVih
 RJaI0KFlfjYcrovFG+kiBb/gUkZjJ5g4Nc5xcrfPdW4/vT/TD4PM2qMjCTBZucY4EDnl9mQnHvd
 fzALzHlPjcXZXUfHqiKBQGIc3YdbM51ysGwPYhrq/RcnM1whq921DfBZspSTFoU4Q0qnSvfhfJq
 T1mN8pTJZh4lO8KgWVA==
X-Proofpoint-ORIG-GUID: YKvw0CV60U9QJxpP6nKVlmXHao8VGh2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220113

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

On platforms that support Auto Hibern8 (AH8), the UFS controller can
autonomously de-assert clk_req signals to the Global Clock Controller
when entering the Hibern8 state. This allows Global Clock Controller
(GCC) to gate unused clocks, improving power efficiency.

Enable the Clock Request feature by setting the UFS_HW_CLK_CTRL_EN
bit in the UFS_AH8_CFG register, as recommended in the Hardware
Programming Guidelines.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ebee0cc5313..ed4c531e1fb2 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -683,6 +683,13 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up, unsign
 	return 0;
 }
 
+static void ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
+{
+	if (ufshcd_is_auto_hibern8_supported(hba))
+		ufshcd_rmwl(hba, UFS_HW_CLK_CTRL_EN, UFS_HW_CLK_CTRL_EN,
+			    UFS_AH8_CFG);
+}
+
 static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status)
 {
@@ -708,6 +715,9 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 		 */
 		err = ufshcd_disable_host_tx_lcc(hba);
 
+		break;
+	case POST_CHANGE:
+		ufs_qcom_link_startup_post_change(hba);
 		break;
 	default:
 		break;
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 380d02333d38..f19def37c86f 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -228,6 +228,17 @@ enum {
  */
 #define NUM_TX_R1W1 13
 
+/* bit definitions for UFS_AH8_CFG register */
+#define CC_UFS_SYS_CLK_REQ_EN          BIT(2)
+#define CC_UFS_ICE_CORE_CLK_REQ_EN     BIT(3)
+#define CC_UFS_UNIPRO_CORE_CLK_REQ_EN  BIT(4)
+#define CC_UFS_AUXCLK_REQ_EN           BIT(5)
+
+#define UFS_HW_CLK_CTRL_EN	(CC_UFS_SYS_CLK_REQ_EN |\
+				CC_UFS_ICE_CORE_CLK_REQ_EN |\
+				CC_UFS_UNIPRO_CORE_CLK_REQ_EN |\
+				CC_UFS_AUXCLK_REQ_EN)
+
 static inline void
 ufs_qcom_get_controller_revision(struct ufs_hba *hba,
 				 u8 *major, u16 *minor, u16 *step)
-- 
2.34.1

