Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A153C13FA
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776159122; cv=none; b=u4wMSajH5jPkhUaBHnPJadUiYwkhpLuPVHN4jCuK+2616FRTedVJaDPye2hpXur495gHAvaLrHjpHikYoBfcq+vt2hqg2KaUROCoIXgbKYfKGkD49EC64h8FREJprd9UF04ITCPwu5kIrSh/KPErNrIdnLSeo6qwQutFo9lVgFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776159122; c=relaxed/simple;
	bh=93ZtNV79vuouAa8eL2edT1/Lmp8ZOeyQQhyPpBYjjwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M7p6WPnrRTzN0gTKkaJqwyUs5+kbOWyjx+j+dl8lWfuXptQJLkvVYZ+dvCM/DW+SMaSrR6dNRzEeJ/qXFCoupcWjiRrVJwJikQr/btJ23U6HPKtmv5/CwrtwUTie0THeUYdoozzI93yOLdOhAFc7d3SMeq53STF+W7TPCEh6SYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NCWU3kSV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I4qB78Py; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NCWU3kSV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I4qB78Py"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E6melh3157820
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9koPVHXl3Cu
	mpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=; b=NCWU3kSV2Fi4p8qSK7XreOSVhlT
	iPrxydAJE1efW36AqNdu+oOfptY8S8pb28DSgkQBC3bDuSOmP768+zhHZsPqmjJ5
	LAq5TXgTmVqStIsxJ7RYMT3aeyXaDiRDhxJZKJPBa1iU0Z8poEKQPsu22+Do2sA8
	6hXhfK8geHwTP/HE0kVhToF82gec/OrskSDMp1+/4dTnAMyPPtGQshDUJIFJBeL7
	9OD0slzUg1jZc3Tf46MXJZ/JWFkUNPl6eUAQux7KJQAwc/il38GlCLCV5cHdkjKt
	aIRgoHGinWZugBzuDPRB02qWTAkc4bVGg0q1Z0ah6lZCRQY6EHoZr0c+ibA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dh86ba2ne-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:59 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82f37744f01so2696990b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 02:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776159119; x=1776763919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9koPVHXl3CumpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=;
        b=I4qB78PyTeQwWRnifrRRiYI/U4ffeRXBs0zGX9mxwGo2G/kyCmOqoE5ma6mtSkc/va
         TwFd6C+T7+yqIf2YBVaQkio9Ruvr6zfXxvgHHB6fjfyA5A5mjVl0gRtirTGSu71pEFnj
         Z5hH/LMM/yiyeIO6/y+bU0mO15a2RIsLmGYgCu9+1hsI+/3XwMvKvl/gXXs41bPh8j94
         1Ym+CWlqqUb8jXP2q+Q1b8C1/0vsE/dtajzVL7aN9fcmxcEmFGgy7rpt8FRfOTgj1Ho9
         5dn44ZTNm/u2EDO9NG9iU7zDuFEPPtjIpcgwKiw5Cepvirfrv5uQYmaYLrRspox13eqh
         9yCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776159119; x=1776763919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9koPVHXl3CumpziFxyBQPxdRYBEiMaz/dETZ0RnYqIU=;
        b=G7NvDSQtfUox77usBoRDdGHjezKdw6cqL1ZaqtnhC7w1d3Ty46AwoqQ8RH22bluuCL
         n03LtMWqcEGm8+Y4V/WnSqQcwyxE3S6AAUjNQ4AXtQxCS4kkebhJ+T4yb1LnJ8UzgkIF
         xWz8Ya0+Plq6+ybV3/vlAJRm7kt3P+dIK+855TgRjNBHizm5EGqD/yF4i5uQbrbWnh7Z
         KY3iKgK64l0tKMqRcmCz/Kft8h/gfxvafSa0cU1n08gAEsDE6kHEsV0nCI7k+scrXtGw
         X6BCPWO+9QryMSfEGowVhOniShmafyQkfCSYX0WtoY5Gz/6BYmqz+ey4EQTzvKw2fPDB
         lvoA==
X-Forwarded-Encrypted: i=1; AFNElJ+qTmjkCplkWfquUlPn6V5zdKB+hws19PRA5kI/69Zy8loBYxq4BlDRq180fzuDfCBuftMLhjGb1qcO@vger.kernel.org
X-Gm-Message-State: AOJu0YxaGWY/WZVd1NDjo06VNuw+opzCs4Y/6QhJ+kJmVXGHz8cP29Ep
	zIVq0n8c4Wf9OmU7Z4/wHMzFiitZJUPFInlsMvsQ6TwD+v4fBNRY1qENmLKbdqhFQkCuxp0upxi
	SbOVOXVethL6SY5253RRj5Jf37R5uiKmdWobuhuCnA0ki1G5Wyq71H2Zr3pJ3BtYZ
X-Gm-Gg: AeBDievMA0CpitQnNoUonmGrYKkW/vlDBp4KPOLMbdDKajOl/PFy0qgTAjqa2SIPMZx
	HMPiWHVW8smZvYS0ElU1skaVLEyDviDlL12xSNNn1VnRZmVOsT19m+LqR63Hg6mOva2i+tCHLxC
	X/ZYX7K6GO4j2vCrgCLzbDlnm/rJX/dpvxyXvYuuaYf3enqMTZAmWwgHLxT9nuLio1wD5+p/gsT
	l4CvqLNNA5rpc/s73zeVi/bxk1HbFJfrqR/3U686Tu00nnDPWrl7oBq6cc+95rA5ZjiV8gJfFhL
	puypMH9u/xHFtN5WJb/pwV7TgxOZULiJquINaJ0Ja9pYFduUxl9N2mFs66Mm+qvihJKXib9hQX+
	kmtrwziz1sW3rmGVGikCJtUuWT8idJjtOk2BPJqVOObn28XLlY7hMCg==
X-Received: by 2002:a05:6a00:3c86:b0:82f:5051:f022 with SMTP id d2e1a72fcca58-82f5051f702mr3913342b3a.32.1776159118697;
        Tue, 14 Apr 2026 02:31:58 -0700 (PDT)
X-Received: by 2002:a05:6a00:3c86:b0:82f:5051:f022 with SMTP id d2e1a72fcca58-82f5051f702mr3913312b3a.32.1776159118224;
        Tue, 14 Apr 2026 02:31:58 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c35194asm17321642b3a.20.2026.04.14.02.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 02:31:57 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        shawn.lin@rock-chips.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V3 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request support
Date: Tue, 14 Apr 2026 15:01:35 +0530
Message-Id: <20260414093135.660725-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
References: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA4OCBTYWx0ZWRfX5XvyWi5tqYv9
 r23/+Ex4kHSeGEJbX5vjjKaJnxbF+vrYxCwmgv5iMLc6850bZMelcxjPZNu29MmLIBBInwQh0Qr
 JWpFzlNdzxU7wnut2JwD9Rtsmx+92A0qV1UEprhUYezwc4wTjmAn/GZXsZDaRVaW5Kqr8W0uhtp
 p4RmC1MctbYIkvllMz8BsXQ9rsLWLULfaxQZwedMhZrFWB0T0EA3uyRVcc0qAxbWR/lgmAreJFC
 UNxdEt9kiHKSCbXOsK2RC+dihTrMwmKGopEQXnMfA0yFAj0yaK0HiNsm3mVk0IubV3JtOp3ibIB
 XivPBQZYzXl3sncjZmD0KyUUeF4TMa5YPEiANKUl+z+5SPdOhvcryqNc0LetThXbgY0eI1uJEZp
 mzX/n3IRhoJ0sfZJd1DsxtSaM0xfVrj/+3OkvkfTfNPUh+GndM6oE0q0BWo/FtgrojNc/lVlQ7Q
 FjA40/xKZY4h5+/m0kQ==
X-Authority-Analysis: v=2.4 cv=MahcfZ/f c=1 sm=1 tr=0 ts=69de098f cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=gce-7N_bzMkFAa6Kq10A:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: qhzvOJc_cr0NHp-yUjbpranGalXx6Ol8
X-Proofpoint-GUID: qhzvOJc_cr0NHp-yUjbpranGalXx6Ol8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140088

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

