Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E96145FE0
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493982; cv=none; b=bhr5wz+EVHsQJz2U6N7JldbP5pjrOJ/U33hsYWzYsIO3cYLOJ9bqcYou0Kwfu/udITHYd8oR676/e5S81aeUGcykkMM5m1iriojL/oonHwvXySFlPGdWQ0p5QDEHMn04Z5upZ95I7SNy6CERy85V5cGuchSqpeKrrXeNPAlmpII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493982; c=relaxed/simple;
	bh=FdQaUHaIKGi8PX7kvnxnJG19Dokd/6H2sRexB/vQ9cw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FD6ZL5qID99q83Zu+RihftzA2k5RQJinHdtv6BZJSARL09kHhBCIkECJmxpNvD1QqnLPRkfDV1axLHNCIBsW3fI1n+y6zuFgLjcu9O05wMaFS/jrFyDcimbY3FmZ2S+ACjYbaRNbyEX2UqbhPtp7d+Qb7CgU3GMezf7XQk65tdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HB9PQt1z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jby3DwdE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HB9PQt1z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jby3DwdE"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J2vtY94024838
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uxM27KGWub9YOvIskp1G0Jb2ZU0MzfIFZFqQpkv+G8E=; b=HB9PQt1zsqp1Sn/y
	7SgyPZcRkFPJJOYU0ZdVMprNiMhj9Vt/23BMYurUsB1EGBRsyUDKOaGr/iboqtw5
	N8nBcmr15jqffwfYmEmzikhqEal9f/22hrHiU5mmy6FW6MnhqZCCdmJOhRhPkTwx
	2pyWN5QM8fDkILKv2jceqWPiwuJqjA4Qgv+a7Zc+o72CERO8wYo/+Vr8PhMclHFl
	O9ppkqjma23+B8cX0MgVNKWUfI5++C6u0zVCAX4ZCufKGx47AzF8f4HrWP//QWIT
	6FziYRxxRIPZKERTLQrJW6K0hisoBnIuiSe+3qErYXWGoxESUT989AsydstP6gWp
	aBFUcg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cd78c3xr2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:38 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c6e74e55d35so583335a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 01:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771493977; x=1772098777; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uxM27KGWub9YOvIskp1G0Jb2ZU0MzfIFZFqQpkv+G8E=;
        b=jby3DwdEdRx5GgVpncDNK2Z8qKNMb3PVAbM91u0vcq0KfYxMaa+cqXDYhs8mi/YsIu
         DfwBKUgPEhnwitIiTIfm/nOjMOQla125QVjPbzZPZlv/pMaPc33VwY/aIkH0RyGee0jo
         EXE1UCnSDxXU9/nZwIaPB/LjMynOHyyK/dmz7B2BraYNXzVETmBOiWuQMIYwd/pdFo+J
         uloeEIJBNu+hclKMxqE4oyU+8TdrDeaqWD2n92mNImCB8z3qJDwEnx8Xee4sTskyxNWV
         saYufVoBp0ydFgabxIJ4dOcTb35XwZvfzTq5qdH6egMpFDlm3J4p4cdhgnJiUhsoBNmH
         /CFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493977; x=1772098777;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uxM27KGWub9YOvIskp1G0Jb2ZU0MzfIFZFqQpkv+G8E=;
        b=GGY3NN1U7q1bWTSEHpiOAAhbK3KXDLI1v99K2eJAmgf/BNWBFrpiWN9XcMdbyIgg61
         LGwtLwsrjri+RpnyqqseGDfBryghEJ3t/pIRoZR9EI8gqA5t3Cfb3pstR6tKOnkJHrtH
         5TmnMxtWZzGpAyH53Y6E396I/vChg7sdUVTQuCy8tkjklcUq6AQSZj7j5v9GhNqraTFD
         0xgglgmp9Sl/4N8j3XwFsS0zJTpljOmGM3Hyl/VNfzX/PRZtWXnVj9pTKJXjHvRll+3E
         efqaZQhtUM1jyVBdalxV49UfOL+A7vkhB0PrfkmKThqCn17RPSLDkY81pn5isFXVoIaL
         b4ig==
X-Forwarded-Encrypted: i=1; AJvYcCWwSAeqMMQBQGF+AfO6c8NbC7plgKB1HhEiAblQhMBZ31YsYlUti52zAjsten77fIwZ/MjfQok6LXtk@vger.kernel.org
X-Gm-Message-State: AOJu0YwOelBaFbWlioCakOv6uXU9hWMLMK0P/WHAbxkC6UjI52SM+5ng
	mtsRqvWxguVN3kE84CqVlUSM2q4cjcd7+UwEySkrpMUpg+fKtpZ2AtZ1DJaRhh+7wy+TsZaiFiY
	1CtV9xpgAA05IOu2iuaYq3NUvEQhI8dbUoq/yGB9sj0lisKWk/BMaHwUpmdf9lnC6
X-Gm-Gg: AZuq6aLvfiSC9MPbr73pz4w8LnKq8HUAiIhjyvt6A3oYkoPfqMoV7MtjtzVhHkSMtxA
	Ykcx7sSfcRs8VQ46nzByUzl2flTzfdSG2r/kbo2FysjFdSG+LxlA3s44LcPEcN3UzYR1GAU0Nk0
	g1UfvqwS1iU1Pp7cwaC9iPi75Eg97BHFtXT1wsR1It+mjgTlwmLOkpTiy6FfbjVJWvDi992FoSt
	gRhiS1nlHp5Qd9NkpuKPpjryRIZ0DsIYcKByEJI5QtQIqE6GNxZK4I6ndTiCUzyuwSGMC163E5S
	jzy3crQE9wjwncvDHiLK8oF5HHQavrMjhruoNnkz0OARUKJgphv9LI4IYWshorh/DU9dDjfuBuo
	OOMy7t/3MPg0a0TijyEM3o6gIh/A6A5Akb9jyakY7yqltwOL3b+u1m2rYHAU=
X-Received: by 2002:a05:6a21:3991:b0:38d:f2a1:a43f with SMTP id adf61e73a8af0-394fc31ce77mr4241411637.42.1771493977081;
        Thu, 19 Feb 2026 01:39:37 -0800 (PST)
X-Received: by 2002:a05:6a21:3991:b0:38d:f2a1:a43f with SMTP id adf61e73a8af0-394fc31ce77mr4241380637.42.1771493976568;
        Thu, 19 Feb 2026 01:39:36 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2ac83sm17710250b3a.12.2026.02.19.01.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:39:36 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:09:15 +0530
Subject: [PATCH v6 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260219-enable-ufs-ice-clock-scaling-v6-3-0c5245117d45@oss.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: uIThYBHj7yV9tuF2K7ATwG5JikFlLhIw
X-Proofpoint-ORIG-GUID: uIThYBHj7yV9tuF2K7ATwG5JikFlLhIw
X-Authority-Analysis: v=2.4 cv=P5k3RyAu c=1 sm=1 tr=0 ts=6996da5a cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-RVjIYUuWhs3u9hRN0oA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NyBTYWx0ZWRfX81FGlqRdoQKJ
 7kCWcxFuOGXFQhfe8MDcGPVzbbJ5bVvm1vmwppSwiDvH/frkVFXhJ3VlQNmkyqaor33ks1lD9se
 b6p5NkAWnRtur2LrmvXJRmp/ajM3hUrmNTjtn3F8rA3P4+oKvred/mALu0YKYYSu3EU/mHX6lbY
 yusPgPVYNL3sCWiJkVBWpj5pMGPTjyTlqevsp2Wk81JCVZtLarY5qkigyuamkSht2tZDIJ7F8S8
 yRqCWyGijleX6j2rjQUrQKifc9uLctuj0K2ltdJyhK71gWLdXX58brqNARIx02uOq8v2JLJZIFI
 sh337c4Pk6i+zsoO8K+RCjhUXm1osaBWb3634Oiv+a/npFM6+8aPGavFYubBQgGIFb2QznSWCKO
 yqho1dVB1Uo7tvBMptlEpNRNEgCwsqShMe3nBLk/LgDWmH5DF8BZV79uTbP6lDjR+h5PPyhV44p
 HzeYufFd9pfLU6RHnuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190087

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

Incase of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..d85640028b567d2084683f237e3110c682a08ddb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  unsigned int flags)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, flags);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -339,6 +348,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  unsigned int flags)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,8 +1661,12 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, target_freq,
+						     scale_up ? ICE_CLOCK_ROUND_FLOOR
+							      : ICE_CLOCK_ROUND_CEIL);
 
-		if (err) {
+		if (err && err != -EOPNOTSUPP) {
 			ufshcd_uic_hibern8_exit(hba);
 			return err;
 		}

-- 
2.34.1

