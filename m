Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2872E30CD80
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776401793; cv=none; b=KO1WDSmoGFH18OMOPHuXEt+pD1HPOVKceVJRcxOoPBZawv11OYt8Tl7wJdtsBDtXzddpv4DYlIUELPa4vIrAgvG4tKzifJWQs928CKGdJWudQknXCFDoFqLASzas0w9ensM2AVuIJvk/8FwpM6sEVfH+tzPNhv32EaE8B8oiZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776401793; c=relaxed/simple;
	bh=93ZtNV79vuouAa8eL2edT1/Lmp8ZOeyQQhyPpBYjjwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iVsNbco7Pd9SlOz+/qzwDmsvCRu6l0Jvx1dvYC0u8UgfhPRgdmZflpcS1iubEFxVNijXPI00i1AzJsE2Jvw8oP+Pduz+50hrTh7Aiq/1m5NNFXKtnmSnguJVesEzmYmdML6eQVJWXxDLkQw7wlMIVtBrtuPRHfWXvG47uciw+IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LYKquZT6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IRTg6+dN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LYKquZT6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IRTg6+dN"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H0fSB31092079
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9koPVHXl3Cu
	mpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=; b=LYKquZT6DgRnbyReSSpS9zk9Avr
	4sIoljkK9dd0bGDBiP14IWfPXR4Igk0FB1+i1WHBnNLBG3VvDR8WzdLI5Ujv+KoQ
	RrOG0aCU8VkdMZfeTTrulS6IzZkAvbmQ2i89GueUxq/OjJCxfJB/7IhtiwqPTrN8
	yxTd8kEnoUVoD0erkFLv1fWM3qr5RieJPAV4r2PMHZQz7IbtI+M489d/kEKg/xJ6
	0/M5wqn5zb0sSj0ITXER+upZyS9LllFHipXr9BVBLXBSeznWwNxOxJG27VKRFPLV
	CWCqS7+QuOHHAQtM/FsESKcEaW6TRQV05jUSJhHIBAyM7pGv70JrUCe/2kg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dk227tfuu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:30 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2ed279eedso2209575ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 21:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776401790; x=1777006590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9koPVHXl3CumpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=;
        b=IRTg6+dNtgaE1yg7GMK7Z9Prt1ZnUi61uAqaYJy7RtLhlfQTmtfbwkcNxlEjS0x85p
         PEQvT7nTrCDrSBFq3bu5/X+sb0j4chR6ZeIgBtt2T2y08HNQ6rheSu7DSc6ogREe8F+4
         6YUA2eeTraTWxDsiT3LDF+SW5HJWRA4gn2k9Ud3CWwdzH3LcPwLLa/hT4arGGoYrc1Pt
         odPbkS+1w1qVG/tqYUQfltJF61RuwacGN26bB2gKbQxHXn6IIX9qpL8OfnUP6oZKya5O
         B9fBr4NrbcxVcHR6xIIkxIzr1+CXesC+yPMWwl2PSgfPJN/4cjFLH3x64UmYkS9C/r9x
         hEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776401790; x=1777006590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9koPVHXl3CumpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=;
        b=ivh5FdgAxBAiHlrLnsq11pqD9PJ0RaRJcbntiC/x4pj17jxu9NN1YlkJdMEhZE7sih
         s73Vl7GKPHHn1BIk0zzh0z4KD6U1Q4TAc29mrUygDFywhXG0/OuTR6eWJR2RcXm28cqz
         58PnvnqI8qA+jVpsiYv/OYFj01xTSqg81veXC0O+LYgPxg6XqU0XDdMrxc2wvWTCa6r/
         6n8TUPOfPq8EXSlAo58EE+DzcgWDWXY8ZWAxBu/pmS3lIIQmL47blGpxYnmbYD3z04K9
         rLRzh/4oIcv/gGOjVSrOdCsGQypNipYdnmzPKla5mJelVSZ4J/UuBgDMgXpf5SXLle7j
         VsiA==
X-Forwarded-Encrypted: i=1; AFNElJ/bn058IVv1NAe04apCkdqiyHMILroe/uTnjFsJku4VHe+YXnbbgyQBC3TnEQx4PuUWxUjTJV/MhJhy@vger.kernel.org
X-Gm-Message-State: AOJu0YxOVWZiigcODcpr4FT20dFz+gHksjo+JgQONxX7QNVbrxAPaVLF
	67yKZDpkdp2knism32i8xxOQSzTF+ueqEoSNw9hFAL4yMascFtrBcvS5wJXW0tQ0d/pNuwL1k0M
	z5rwD5izqhZSSgdtp9gDYRsrbDu34JGIveOWEhS2NzeOLy3dL7pw5M6egc5G5GGIi9L5bqQbh
X-Gm-Gg: AeBDieuJMrNhjnO7WANqhPTNtbH9wnoIovNdfVIJejaL+TwFkxmnBgyLD+XfPo7SpYI
	36oIrTpuVTycCu9mS0SAS+saIPOlOsjiWqGqcspGLKt079y2e2ZIyCZ6isRkpDrmLUc7G2SeNKH
	cMnGa20fjHGUduX/LS9OODKq/XfeO2v/xCqxkObHFUQqXAAND6T8S0OY03uYQtAw779WYQfsYj/
	8XUt4MGAhFA2ginmAugDAubKdcDdnFuZQg6zk/36Dwd48g1ssJLUxKAlb7TbQ3M2tVgTKCt0xkG
	Thdeb1Boi3NZ4DAl9uMnsnukLe/WQxdIVmJghRq/+g1ekXfAbDppGP7/kBax5HeznUmsnYoLPzv
	TA+jCptXcGr+xNqNoRrJukln2pAjiBZhIbpLiazOkATfVJA3qtro0Iz2ILcN9G6ZY
X-Received: by 2002:a17:903:11ce:b0:2b4:5ff5:e51f with SMTP id d9443c01a7336-2b5f9f51dfemr15020055ad.36.1776401789764;
        Thu, 16 Apr 2026 21:56:29 -0700 (PDT)
X-Received: by 2002:a17:903:11ce:b0:2b4:5ff5:e51f with SMTP id d9443c01a7336-2b5f9f51dfemr15019765ad.36.1776401789186;
        Thu, 16 Apr 2026 21:56:29 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3a8sm5702115ad.12.2026.04.16.21.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 21:56:28 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        nitin.rawat@oss.qualcomm.com, shawn.lin@rock-chips.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v4 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request support
Date: Fri, 17 Apr 2026 10:26:02 +0530
Message-Id: <20260417045602.3042928-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260417045602.3042928-1-palash.kambar@oss.qualcomm.com>
References: <20260417045602.3042928-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDA0NiBTYWx0ZWRfX8b+QZc/1LaOo
 IwGSigtS8N4+jS/C8lS4OT/2VA+XOxpGhOG3QesWJ4JhxCihGsNFealnm64AgL2awEU6iNQnk4P
 +f5sjur9rFHmVGPSxak177Fv43wV135lJrwZCy3AntH48g5zRONov5mO5sTQsrI+DJo9HZXeyCJ
 da8Q8zx6iGLJ6C0fKFeqeLoovRIhnQzRmNUbTavUk0A/wX4hEgxCNVSkRtPgv2ed44Mpc9vQ1pK
 OtXkXN+15UOQgKDvSX9b2N2Jz+SqK3lQ29+lqEvL1St0I23lf8RtQ/qKnhTcsAgIQMWhLjbSscv
 ZISi3aP+Du3xsiXNVR83JvS5nXLDND4TCAaHt8L3xC5SLzmrZwUWrmzhumzGdxRX3ykzO9yiuVx
 AGu1F8eOmyZr/nLZQvxj3dmweGHdGWh6HDDVrA6peY/tRe07p6Zfklpya97sxqgn0mxSA8XiAMx
 z2K5WSEfLFy8kdPo7UQ==
X-Proofpoint-ORIG-GUID: eOmm1QuN9EWCneguELj0QL3QB_ylDgbR
X-Proofpoint-GUID: eOmm1QuN9EWCneguELj0QL3QB_ylDgbR
X-Authority-Analysis: v=2.4 cv=Iuoutr/g c=1 sm=1 tr=0 ts=69e1bd7e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=gce-7N_bzMkFAa6Kq10A:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170046

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

