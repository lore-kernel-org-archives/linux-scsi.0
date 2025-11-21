Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783D82FD7D3
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721396; cv=none; b=AUsa/FPilSyQwy23u6QMiXm+iRg572UDzZ9ScP4VXjemHM+mCQ0HlOcxCD9eGBJUK+2gFctRvjSTv1NrZYN3+1uMnNJ+duipsgBruTgrO9GEa5lCNTAdvX4YuvOKqh088q0U2Q/EJrzvNSdd0yfT+EiS2F9ULCVdt3AQERL6pi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721396; c=relaxed/simple;
	bh=42Oia7LlBi+H523Rmn2IIOy7T1zt6E32yOR956DWeLM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Yq0wkpYQ+RUUtHOaWr3UAC1WjizataGVY/txIChcmMrJR3JGgNNlVIH8n+O44IrrIKF8vfqkjBRWVswHb5UflelK9QpP0cfshAxbUtej+P25ZpR83AKc3mrB/j1pSgPsv3EZnVue7RBUcFCSkt5eNSBuG/MZ/d67NS9QUoIK6FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=I4V2CI6t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KwoC9oj1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="I4V2CI6t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KwoC9oj1"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ALAR9O02746941
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CAqEF9ipkGXaLh8o6lQtStQbpT65DW2PvBWxy9J0Ebs=; b=I4V2CI6tH46zktrr
	AMctmO70+V+tncBeTPb2fYgTUGa9SDDjafYAW15/DncqXiuxaWDnY+Bev2a6t1a5
	Ug/lX2b8L8xdRskXKq0pE8Xy0AXl+hsUJfaPSLqVqAjeTRPEBlgsrZQYtpPZX2mf
	FS9axJ3tTuBdNfhAEpKQvCksSTOAt8SM0k7knAL/1i+F5/3Gm57FT06hiV+VLTYS
	Eo6iHFei9NueZtgl3oPcSvvmWI81zb6PoHOGZYOhDUJ2UW8YPwIRDzvjwXkFu+nP
	5i/CNIQYm8OLrxM1Wg567DVTpLcPyTYkPipXMEOflRIvXgxLnTLQGLpx9MZkp0MN
	tQc/og==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ajgeh1aqs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:33 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29845b18d1aso49346375ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 02:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763721392; x=1764326192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAqEF9ipkGXaLh8o6lQtStQbpT65DW2PvBWxy9J0Ebs=;
        b=KwoC9oj1WK3O+Q8Ei3N987P8iw5Jhxodjsdd/XbWWCp8EswgPy+wC7zltCz5l4ZMPg
         q36pWEZmaNw0aZkGEBCuseX2K9kqIh3tPU1vRItr7IMJ0EAuR+6uvqwtga3hLPj+H0eq
         FQ7v8oEHW/UQKAh2RdKBbsYTjgqNqJLSxTfhDcb9E24RnjMjK9eNleCIXZBK3hucnxZ5
         /2AbdQHcNOriijwliPV3JEmn7ME9n81+aklJSHQRZQ8mKuLY63MgJfvwDIhDlsBOqw5d
         2XECAhFDPcjZ6Om9x8QqCZt0jWSA7QlZnySKNg3/s5jnHwt6N0i4GTuiUAWSAFoHDUZS
         kNRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763721392; x=1764326192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CAqEF9ipkGXaLh8o6lQtStQbpT65DW2PvBWxy9J0Ebs=;
        b=XZASvf7aJRhGBcnmgTmEmhQ+lpVPj4MKNHM6+8tQrq3iR8iYe4ENylt896mfWB0vWO
         28HsckP31TKLtYDeQhlwB/daVr04gsJ9e438c9QHZnR5JcFgWRvk0S9zAxeKlgpa2nTg
         ynQ4UHPltyL4EXZd1N95TyAxAPaF2S4HA31xm5wPE0kr39PbR7HfuxGqtmhBv9HkC8Ut
         X8vOysf6Wgy2qTu/yxTmBf5AUakgOVhbdHbu/k7jvPMvZHL+w+vs+rC2p9Y2slJnD+Gj
         hWj3jtCQVPghzq3E45rxJgq9aErXH4VcJ+Aekm5on4aI4xqUecomPVmkdqavV0lA+Qf7
         Kjig==
X-Forwarded-Encrypted: i=1; AJvYcCXSlCBQi83xL66orzMAHgeBqWaxWvj1OFUWi5JJUL3pbF4qTtefBJsOzvpm7VnpzahIc3dmVvrYGxX5@vger.kernel.org
X-Gm-Message-State: AOJu0YxAxn9Wq0y5T5OTbHoVrvEGtNskYPwlSGAnboi4Tc7RMTZG+xPa
	xwgmrGNt2zJjx1CDdDEVjBhqGlimHYa6sDBOjVGjg2OUSRxSsGbmnFcLSR5ReyrTfdwiJXp6YJ1
	O+xygpeBdJtSlWXrNTGaMAWJVBqAv+Cn3YCUr1Uct6wRafzsk74vFSmAPEEaP0PUc
X-Gm-Gg: ASbGnctAnrwDQGccb4Xu629InxxbrELnNDcpxIlUHYyriTFeDd1gNusUmOo59ujh1SS
	bYqWiYcdth9tBCL5IdDOp8E8SnIc8aVe2uvr/81tzNHJV6zml6yF8MFc1dc+yExvZflDdNKddB0
	tbOmQIXUgKcPRIjAqgd1pp4cG7YRYYseFlJVzQgLh/2NtvRtS64agU2rEM1AdzmjpN41Dh1gsUL
	mvYcIbTttwHXz5kXSjiGRMnNy3zXkUhZwtMt32CDsomI7dv3XQ/fGWp12rc58ixgFv34t7Mn8lG
	2Y52Widq40P27JmXi8lMczNpHZiP6BpsZ/TVx+auyTMvwlnnKqzyrmSNRJn0r94xpp6GplOj97p
	4vhcXWPACN6rTwGHRR01ORqcMPlb+hbfWSnFyW674PTBLels=
X-Received: by 2002:a17:903:17c3:b0:295:275d:21d8 with SMTP id d9443c01a7336-29b6c0b7a66mr27378925ad.0.1763721392276;
        Fri, 21 Nov 2025 02:36:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzI2I3tYOltXt6IQ+cQ7O0lEpR29UhlkbO4Q4v1RIxYR2odAeCBqzRY1eNhIS9gX6eXHxi9A==
X-Received: by 2002:a17:903:17c3:b0:295:275d:21d8 with SMTP id d9443c01a7336-29b6c0b7a66mr27378655ad.0.1763721391829;
        Fri, 21 Nov 2025 02:36:31 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34727be2fa7sm5122890a91.6.2025.11.21.02.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 02:36:31 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 21 Nov 2025 16:06:05 +0530
Subject: [PATCH v2 2/3] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251121-enable-ufs-ice-clock-scaling-v2-2-66cb72998041@oss.qualcomm.com>
References: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
In-Reply-To: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIxMDA4MSBTYWx0ZWRfX+yKhVO8/t1fh
 sjMirOlV3EPURYn5ObBYtv5D5VljtHDWbis2lBxpE+qncLb68Kk+gT5S6x5vFv8tBlxJqyE1RiK
 qjC3Eumdn9LPv3IouOHY6fx8rw/ySqOOenlrbQGFH2eI8MiHtP1KujSKB5zM7V1SBsrLTXwx3Dm
 jdjYJ4mmgomet5hE3PbxjPLwk1FP48N+cJ/xv76BVg8f5ZRPZe9N6pZMgzR6Dy7Ec1AZIyn6/YL
 ZSK3MDgeIrV3s+daFU3sJLTHSgD+dJcFcoz9sB8kh+Fbn1WE16Q+Hm8wJKtXcA8euaqg3IINw5y
 bOnnaAwwo9dGxHZaYqW/pcY3nBfWsbU30kImsrM4WIwiF2QmUWgjsNwKO45oBrezfADADrGUPAH
 XNe3LNVtne8wKSEbGuX0PdwuUJwXtg==
X-Proofpoint-GUID: rzzB8VbsaEeLGaY0h4G87jfFGY7XmMZ0
X-Authority-Analysis: v=2.4 cv=AubjHe9P c=1 sm=1 tr=0 ts=692040b1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=lzHOrk3F_0XHYG_XrgYA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: rzzB8VbsaEeLGaY0h4G87jfFGY7XmMZ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511210081

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..a60b60eb777a674fb4345fd393bde0eab3571a23 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,14 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, scale_up);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -339,6 +347,11 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,6 +1659,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, scale_up);
 
 		if (err) {
 			ufshcd_uic_hibern8_exit(hba);

-- 
2.34.1

