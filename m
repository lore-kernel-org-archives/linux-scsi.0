Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506353C2781
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 11:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775735095; cv=none; b=AOAsxvxqKwWroCaa9XKlqOJottIynrsAflDip+YbgxGBhSN3OIrNAHA898NAfQ4WJZHxFybzkjD43jf+NPSCmQ5yDHXeP3zfL0ghgkQDEWPpg0LHjI9s0wcOqnhWhuJLDPb7wWuWUO2zCxg5/o7CY3erBIlpBrg3j/9KQv6Xd7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775735095; c=relaxed/simple;
	bh=r7qPfewEvL1ex7EIGvFKR1XSzyLGar4cNMBb5ssyzo0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WvvBlWqjuqjnPUbb0mucczs3pdLHa3LlGz3nt1kfmu+uCR1zDX/f+21RL7CKIXYTPmBrEAbhZDDe+M/MZTqiyoXK2K4PtlQT0B6Hspr5bKeOfn75m5pJNI2hf6yq43Vdg2RBXnWZgZ5eGm7ybB23yy6sxNLF4PNrZ1mPtrjsNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JecxgGzS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CV9X3jH0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JecxgGzS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CV9X3jH0"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6399dTDf1727555
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2026 11:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	athUgV40rXKWfTnPETsxk5Mmpfz3yAeWPwL1URQCmwI=; b=JecxgGzShz71/oyB
	zByrO/+QjKaF0eAQv8Og2TkDeAzkSasAdAidl4UL4X1w4UHuXxH/yInxhQ42aaDc
	Flts/elyqQDYltA77gP1XoaWOV+hULKL/T5iLDQKauChdjzdGxH0k3ttL8T2DZLz
	6jAjOH4mSDiEt6fxK+2Rs60h569M9HIPRupcCOM1sdHxUH2zuAeIcJOIxUXv8X+g
	LqVpRHFfqfCVmNRVLEsFZdRGIUmvmB4mLjENIQtbW+q1w4QZR13ipgJyaCda+vfj
	yecsp9SWMBLAYSb1AjhOyNAdUxFINdv2wxH1XWP91wqAF4V85n4dcpwOe3iHco4s
	Soh1Mw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ddwcru15g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 11:44:53 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b0c96f5d9aso8117885ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 04:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775735092; x=1776339892; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=athUgV40rXKWfTnPETsxk5Mmpfz3yAeWPwL1URQCmwI=;
        b=CV9X3jH0lY+SEGPvyuLDvonUiCXkfWkqrWDKcOxAKx/pQttcvCBMinDINtMbuP1MhA
         in6wZLzxg1QyHqAXWRaBFj3hz9MKF3g4eYqb5/7/TBuPPEmIbLqubXssKopWLj3CCXjo
         0CLZsdopXHKH3SGwt67nwEBBqJ9/hAWcMJ/Hy7HQ1I3847AMMhmdfJArCyCc5plrJajc
         UiCEg7lQAQ3D9mBjVZ1SqWgvWa9m6hDpAG0DwPl64S0UHNySNe4w8LnnSADZ8aDJ+0rg
         DYJpht2B49NpgiAhNYmNaptjpZwFvHu30P3vNR/9/TpDb8Pbe1pzwwMvrkqL62NMKotf
         lzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775735092; x=1776339892;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=athUgV40rXKWfTnPETsxk5Mmpfz3yAeWPwL1URQCmwI=;
        b=NyoH5dhpx+VHtS4k28QlPBlCIep2gbSWXLzngZxeU8ZKYYBdColr7tP7nBpajbhY7Q
         WOHiGmJvh1TMJwk/ROyGYrt1GdYvdMQI9AN2pueN70c0yDSTfUEVyobhnTAZjaerg1c+
         wcxVETNRxIeqOckb02x3N6aMMBZQclie7z6RO+nOC86jR04jKTaBAKdoCikSUIq6tDhE
         mM2XMajsyvEws/9EmE4TF79TgpjWtmw42WymP3/0u8dmZDEjM76z45Cyfr0wrZeKucDA
         /YCa5QARQwMNTc/cV+hvEGMRViCZeK8OPJqD7sHEiRxSVGszig+88RCW2rrxI+7CGWIF
         a2hw==
X-Forwarded-Encrypted: i=1; AJvYcCWu0roubSxxNr7xHhXRjtBCV+W1/zbybsg+mX0vAVgzYRqIo6r28SxfFZDPJ0Y616/IH02cCuyM7R0R@vger.kernel.org
X-Gm-Message-State: AOJu0YyvTP8q+SoVK4XYA/7PEdXWPdAAEoLik2Xqqz6V84Ha4wbtaiH9
	Y2ZXUeQrbg8wmxBRgBHueTU79f8lXZi+DejpdIIRpUUvH2M3bToeywyylTOxitocfAFb1RYSk+D
	W/QkE+cz2xJOXIrLKOdziY+YhPHba0MLxHqFJfU7VDQKKrNsrzCz9atQA5IEs1u9b
X-Gm-Gg: AeBDievcnLggKv/jDaxlZbcKTynN9nIarKFIL2q95za6EMtGd0+kIysoZp0Tf9b9qzP
	fYagywNSx8PI03m9g0I1dw/N3IwPJyQ3JnufOwpc5r52i7lEq8iMLSh64orN4XBbOG9JEBJYNtD
	TZIF0mw23pCF0VbrwLicEv+LaNFltJ54oOTgP54JQp6W97vN6DszShOQ/DzCKlm6ARuTA0ex+3v
	aFeOWZ20NzgjmrlguGXNiHqshHbzOjPuP1ZPHHhA0C1b41+010tq8MIk8iJde1w9ypQNbrelO/C
	qmpLpD6jEcHj+vTHayNou6D8ihgz2/+bjPII4cDQaTQ0hBJgMjTiFBQevZex36P4FTDH1cO9AQW
	z4yV86bi3h1nGzTSdAZeDF7El2QAvRtBbcOC2I66krG24x49vW18hw8eB2vo=
X-Received: by 2002:a17:903:2f08:b0:2b0:67fa:dbf8 with SMTP id d9443c01a7336-2b2817e97b9mr257906375ad.41.1775735092178;
        Thu, 09 Apr 2026 04:44:52 -0700 (PDT)
X-Received: by 2002:a17:903:2f08:b0:2b0:67fa:dbf8 with SMTP id d9443c01a7336-2b2817e97b9mr257906035ad.41.1775735091639;
        Thu, 09 Apr 2026 04:44:51 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbd9fsm230957355ad.75.2026.04.09.04.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 04:44:51 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Apr 2026 17:14:09 +0530
Subject: [PATCH v8 2/5] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260409-enable-ice-clock-scaling-v8-2-ca1129798606@oss.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEwNSBTYWx0ZWRfXymBrIsG2Bdrg
 Lp7ur9nZFisKXZCbJLD3BF3EgPej4wG2iQQ0fPes5veRzKgqTOjT/0WIZ0J+yarm3paC3ex1R+I
 UNQatohdyHrjePSaqr9h7mcVq+eT2ncPti3j2HQtS+A8aLnNxslPts04P+jxFuj4nOrA0VanO5z
 brrylF3FnNRlO6SqIOl9kAb2HaThYxJg4+q/FzHMf88dokHQ1CXZl+miFIFnCBWNoE7nqLUnlyK
 +zKKseTMSFSN+IKJwG/tSl91D4X+2QnW9bYAkmlGYnWBP513PQ6SCrDSRF8Ytd/VEeaxKHKrtMu
 Pwm6qMkdbNcOgpsrsXlB3unYprrtsug4tvg4huB9SnVZP6GEiKGDdIXoeGEYcgr/W1nb4hdr+Av
 K/JBrMusGY+9B7Va9tSaNbY/HE3jFqmkXsjcxwUzFNGNM3Ta6jYFCoodyxHoxzEFBr3jkFAa7PQ
 t4pScZNEFAHYao10t2A==
X-Authority-Analysis: v=2.4 cv=SsWgLvO0 c=1 sm=1 tr=0 ts=69d79135 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-RVjIYUuWhs3u9hRN0oA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: R9mJGqfJu1a3omC7eHndN5tGxCSBYC8N
X-Proofpoint-ORIG-GUID: R9mJGqfJu1a3omC7eHndN5tGxCSBYC8N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604090105

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

For scale_up operation ensure to pass ~round_ceil (round_floor)
and vice-versa for scale_down operations.

Incase of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 375fd24ba458a7ef65d075ba98e5f99f4aa977c1..aceb2c42969b5d2dcddcddf0167f8824733998ec 100644
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
@@ -1743,12 +1758,17 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
-
 		if (err) {
 			ufshcd_uic_hibern8_exit(hba);
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

