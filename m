Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211513AFCE9
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787514483; cv=none; b=Zi0k5OZyLdUVE2FELp67SD+dMvOeYKMJVt+Hd/it1RPQS3bwmwx0j18qrf0IqhTcl/0JoeEvWdaU4OLRtwNHf3C9jwviArLY/XLnEk6LnC0kIIYnCb+Jw2G0DYm3bgV3/F5b3hABorChvULh7IkBbpSkHsrNsLtgWCFp9yo7G80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787514483; c=relaxed/simple;
	bh=gWTcQ2XEzDFY0k81S5RiN8Z8bxM3mkFS9yIkZIw67Js=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lYLDrXAqy+hRiIZa5DDC3B1SkQTS+56JBSvKri7PY6qzEj42GiVPAqgFu/JXQl86pAHSOf1eWmE105ntYQAu5mWoTLAKhCxjKWoyvjhHDltiP/txLvl4Jy/4344zkFtgIRlualb0pv8vaYbVaC8syT+1LqcMb/83FPPYIyaYaAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eeVwaun9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FGhhgQhz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eeVwaun9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FGhhgQhz"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67NG7iHN4134105
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LKlVcGWgJkDfbVp+WF3KzIUdL8c8AJrsPsM7RduI1+4=; b=eeVwaun9MIrnVxtv
	ffuENyvCvT5XqyDyy2RK5I4ZHo9Vs7up6lFqVTNVLlMJCSCA+AqBNnFX/j1Lmqum
	Uo5G69F07Zw9R+0KqrUHcF533qhxnF7fWTGEsXLaFF67P/QS0Fs7G0DBEy2VB4me
	ITPufWFzPzVr74YjR4c62APsyFuJcIDI94pFZvOxFnlTgn9Gh7zFtnXOvFieW6dg
	5qOyatLqA+NbStBkGoi7xHzBJi1MI0S9VXMtK5SoqQy4v/7bjmnEJQAhHPjABVGg
	aJHBp8xE7Xk7IYkxR/IJmjcSZ36eElritqUiJkq7fUtFvcT58a5F2Sm4mxSdjElL
	ZJwpqg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g7456vfpv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:47:59 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c856470fe9fso2073919a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 12:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787514478; x=1788119278; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LKlVcGWgJkDfbVp+WF3KzIUdL8c8AJrsPsM7RduI1+4=;
        b=FGhhgQhz3FilwCEe/v9LR8c069+xsD6uok1MGVO8hWzQ9buwhU8B20ufUAZXhd+zP2
         DqlrpisDwO+vOi4W+cBnuPtWRvjpdxuwnbyFsRdxkP2VY1ZTwt5kKpVgQCJifO2l5Jrs
         0SaGhCW2kYGL3AFEiE8BVT2RcL+DCnnzZrYlHnpGs5mxeU6jBbLyzQgfn8rfz62O0BmW
         W9z34xHkkxZRi/5VZ6Gbff3VAHgMucLdmkOISGB+2O2vTOrdHkyuuWUGRKo2H5oCYVt3
         pENACDpW6MpEyjEhmLGuwgkwMwKEOgKRUwUssCR2dDpaJTjZ/K9nd/W6U1MBDaqhTOY2
         TKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514478; x=1788119278;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LKlVcGWgJkDfbVp+WF3KzIUdL8c8AJrsPsM7RduI1+4=;
        b=mS+cPUF9YNZDhTd0y42r2cyqFwnimmWAq/t78OqQ6sfez98H30Bagt0Wxw0IWaVMSa
         rQLgntIpZaYm3jREABF1M+vpFNt7txFk/IWy1mz01UxDukOkXnIRj1P4UpycvmyTWsdD
         fsIeQFNnt6tyqnJOmjNBaFpt9hd+oSFGKTP5KZNYOgvzcebVkz5QYEwmGeQbxGXpOK3y
         dGdkJWOIIPF0Uq7y+I97cy3LDuUnFg6cPqUDmjHi4jwsSGYJgBAjtaSgTAk+Hdgissq1
         GkjKXLdA0Lp2DR8xqbrd4KyaFcm/tIMXAnBAOc4Api860qj7IoVwETxDk7SKzk9DTdvD
         WO2Q==
X-Forwarded-Encrypted: i=1; AHgh+RppBLUEU0x6qYOkr+KxVsxpO73QBQ09KF/2fPzLJQuGItbhVso4cNG+O8qcfXOz6CMe89cq4dQ62WEM@vger.kernel.org
X-Gm-Message-State: AFuF++ktges29Xi2/ATpEZzcGuUzEKjTXorJUNmK/KVgK4ILs381lQ25
	LEMkFMYY5YlVAUqWzMNUoorE0YUmKW6x77r86VVs4ijKDmjmlwkmhdx3QUFtFISd/rXMVvVaHSO
	6eNxLlPEDyXm7/Sf6/MhAhJ27P/T8/6FDO8sacIwFmCFauWjHQ83Gb+tfCnutcnLH
X-Gm-Gg: AR+sD12ZiCJEMuzA8wT4/Z6vR+n/HiTtMQaM0e+Osr7oxN6SQuqnlWsoFUk5ZtRZo9E
	VJNNaXzijv4mt2yHX0BbkXzQ/bkVyW5nwcjMwHX4w3Gs2ds+JiUOz2FGm/KgIBp6riac3LRUXT6
	cifL4jZSGUVTXvVqxBbKPKw1B3F21oAaqEyoEbBBq8NnGX/g3KMqSDA26MGy+IQmyHqhdQ1Io/6
	UlkIyyPSuDYcXeiVBifX7hjd8dqt6ZCRPhQS22mKj+RF0nDuIMMrh6vykAFEe68qzdIty00kS4k
	cWb2GTLt2PHE9BNLsuWT7pko9nuKzMJv5iC5Xn9x9W9WLRl8b0OWmbBhuJTsUMWKSK3YfaviVVe
	DR9pY8InQc8IxGi5W/lbo62gs6CsRGp00dxE1qg==
X-Received: by 2002:a05:6a21:710f:b0:3cb:d156:d362 with SMTP id adf61e73a8af0-3cd2fdae771mr40720129637.3.1787514478386;
        Sun, 23 Aug 2026 12:47:58 -0700 (PDT)
X-Received: by 2002:a05:6a21:710f:b0:3cb:d156:d362 with SMTP id adf61e73a8af0-3cd2fdae771mr40720074637.3.1787514477928;
        Sun, 23 Aug 2026 12:47:57 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f925190fsm32321623eec.31.2026.08.23.12.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:47:57 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 24 Aug 2026 01:17:39 +0530
Subject: [PATCH v12 2/6] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-enable-ice-clock-scaling-v12-2-09271f583dc6@oss.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIzMDE4MSBTYWx0ZWRfX2C/Pg74auxXs
 E3wum/6U0jZxXJCgwRdT8w4trvS/A6a9ycCsTDXZ1SvXYmtyK0fd5pqJrQeu2+tk+k1aGEWDrUy
 vGsTf7k1jvmqCgWcX9q6VKVW/OKGT8w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIzMDE4MSBTYWx0ZWRfX8q7z+9unSLCV
 wRp4tg98SFURpimq0IYEcBQe7knIsv6pMJ+euYdRgAxZvMmA+ik+fxvZKa2qOZRTXnUi80iYHu/
 /0A0bNvsWUiB+BDQNS0SDMe9bTEOOOxa3+Vx1QovoOm77RVNrnOrl2wVzb3cZ5ozbV7WAEZ3xfZ
 KbMENQr6ztbQUHa5lQBQ24TAMviu/8Gpu1LYiG0d3/pYsPj760wEWXjKfTyR1TbFBARvIPF9kDC
 TjKpN03B71mAupebPtl4YvF5v4NE8TDFZY8kw1AqMD+CwQs2uxjhjvBPmKB5rkqp3GpTcb3GIvF
 tqsD/Gn63zNTcUIxZFyMSBm5DRiVuVtTRN4t82iVHTDNEe+LYtveiy4wHrWheVpcI+28WUj4TPy
 7QbuVxUzzpQzQKM7czjmcoGs/8vzOwDXeYKUVK4KJW5j+MV/F5q9X6SoHaNXoCnqmGUcEtJDroK
 /N9KwUIv6tNBJyOg5WA==
X-Authority-Analysis: v=2.4 cv=RtL16imK c=1 sm=1 tr=0 ts=6a8b4e6f cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=yPCof4ZbAAAA:8 a=4vEl8bdWBwuQafGpEzkA:9
 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: gki9VWK6H16HPNWxAJKqmgv5GOPRGsSc
X-Proofpoint-GUID: gki9VWK6H16HPNWxAJKqmgv5GOPRGsSc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-23_06,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608230181

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

For scale_up operation ensure to pass ~round_ceil (round_floor)
and vice-versa for scale_down operations.

In case of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 291c4344876481461ab958f3048db5405bbead62..dc15d7806c7b677d6890cd4b077cae4f4d5c9a41 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -306,6 +306,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, round_ceil);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -340,6 +349,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1946,6 +1961,12 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 			return err;
 		}
 
+		err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
+		if (err && err != -EOPNOTSUPP) {
+			ufshcd_uic_hibern8_exit(hba);
+			return err;
+		}
+
 		ufs_qcom_icc_update_bw(host);
 		ufshcd_uic_hibern8_exit(hba);
 	}

-- 
2.34.1

