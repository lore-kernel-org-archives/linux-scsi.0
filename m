Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0F335C1BC
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152357; cv=none; b=fScyvtOsPSEWeCYIrXVj2/8wa2rPoAntVBkftyr2BGVlSHjBPoF0mGKn7pPFzSzs5Zzsbpg19lDEeJoxq9R8+fgyOCxu1sptpRhEW9w37SOjIcRtRQfcslpRb6reqFVSP2/VoLLQ6RDydrCLgVhKDqkyHhXpr0bMMhTGfWGlfog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152357; c=relaxed/simple;
	bh=42Oia7LlBi+H523Rmn2IIOy7T1zt6E32yOR956DWeLM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ujEvqtVOyER/XRYGqqIOxi1nrPT3QyLmj9/X6vyA8iMGXQLhv9QbqpLt7Vy1c7zp1lcCfHqSCYJUGwIlQcgcPcnXikOF2yrhwA8zMPxtvqaqhroTxDAPN0ouMReJRnx/LILxzr33L1gr9rPWVBqfq1+gaatKNHs4jPrd6QJ1nVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i2U5j4y5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UKTxxSqX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i2U5j4y5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UKTxxSqX"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N477NE3811168
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CAqEF9ipkGXaLh8o6lQtStQbpT65DW2PvBWxy9J0Ebs=; b=i2U5j4y5e34Rp0p1
	VUJ9iK+HIcAXwReO4m2dQRbSimKcbiG6bEH5EBlzXAqWIldWftIbvde+7wSYWN/D
	tCZa6OhVDYDn1JO2Wi3/u67OcsR+QLMubkoRz35j0m94W9xm2FwRUExNfMfwwfSB
	yu36lIhENLqsEYXx4kybda3EOwpkFmW2hAgJkiUn6eT3tcSeY47BfEi9aOUJVnf8
	zkaVMwjCYkZaDyd7nQyRLWsYVczAcELUd/D4DRPm8O9n8cFN+vM3OfV62CHE5qJN
	1GC9KcpI9c8AnYzYvc0lnvWpXonU8/CcodZellwJGhd14tB9ug4ucRorvlsVgA1S
	i4jNzA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bujq1bty4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:35 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a7a98ba326so19980245ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 23:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152354; x=1769757154; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAqEF9ipkGXaLh8o6lQtStQbpT65DW2PvBWxy9J0Ebs=;
        b=UKTxxSqXvtxL+VyQX30JU+SXD8eS1mgPAbGH+mapoGBNWMWDhEKjIu3Ctjn9lBtgcs
         FadXwyMjXhVCio5YHX6eh7ym4kxDbpqzySdBVuuUUZC4CY09GS47TRU+1b1FcA2le925
         oazP7oNqKgd3/jyxFg6Tnc4YILe505Sy0NvqIoHmQNJxh55RRzXu31k7qRg0P91lTzPI
         Idly6rd2E38td5k/GKNYMbJFSujTYzc5F2bMkhcTo0DiI/pvMT0qEEs/TMPRSeLDW4YO
         hStpsXZPpMXD07wlpA0ta4zjq7hjDuwdlkqYE7VByCAo8utk2XOrtl+6hL6qaUvGx94c
         h3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152354; x=1769757154;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CAqEF9ipkGXaLh8o6lQtStQbpT65DW2PvBWxy9J0Ebs=;
        b=qSto5hF9BiBcDfac7Q61daIiEponGIcuBkaOUn4WGZSUG10uYeuMTH19sC71BZIjvK
         3HGTrW2DWIHFaG7JUUS0h6ZQGO7LuPjuPC2moEduYQ14QRP7jhwviPT2dxVnkCXIeoXE
         S089C/NS57WtBUWVboJ/TL0jCTOZRpq5VhL2OR6Z6Uz4oT/MWiTZSGZKf4KGaLnHKgg4
         dmJ44n9DHYR+0oxMmiWRKIY51c/6avIwkWQcaQcf5xCJ/DYg/QGygn6hfR17Vv8yjisx
         K7ZGt3/lplj1N49TotyTEKBfGeZtzRPiTkcIoRklV4MRg0QMiILRtrhLrw+fsjUcpzI8
         O+gw==
X-Forwarded-Encrypted: i=1; AJvYcCUnHl5PAxMHmxSw6mGzYLc9lNqZzwU71PPoMZbiQpBfJPLKgUYcqFDKJ4sgJGI9Am0gfKaL97m//gJt@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyh6WLpl369RW0HXYgtFehdp6HeN4FoKF0qYv12zBdqwhDGjqX
	z3zuMS6Lvrr1vOKGsOUYf0AxbObH1zL/J1fbKHtx5JHHRMzWpM96P0KVc7vdZ0d0Rj8sEN2U0sb
	m6pV2RBfK8ajyulqOePSgUkSISbZqOT5IDcfcF15gjr0SS5oU4WlqPa9HMWKcRmlX
X-Gm-Gg: AZuq6aIepWQyPPbFqw2k+ZHqbgdWw/dfcpR5x3SHON5QwDaODHEJebmwXK0QIc6cmFr
	w/XKGqeEq6jhMFhlpUc4iAu8IUSi4/OgTclsnUZEAuEQH6KVkHu3dn82pcV7GDPgvrmopyMbGln
	961U7AqNAz3qztJits9Kz3ytfLTysjefZD/DseYqfdW6/W8+2VnD/4KphNKn9IxCCBVs8xTLkcJ
	jRdgjXk8GabrhG2jXBb1ecurEGR9FLLkgg7mjYK5UfTSRW8mRyoZmfU3SwGiFe3saPJuzo63wOE
	TTfXTcFXB7IHQBtLZLelEl45XakdbH1cWs2TcefYIsJ0mVY19b8L7zdHvFWKZt5jE1JEUN7umNY
	n6d/dXjGlYe3SruVLTlUgtR2QtSS+hkfOwySxraVR0sy66tU=
X-Received: by 2002:a17:902:e94d:b0:2a0:c92e:a378 with SMTP id d9443c01a7336-2a7fe75b8d7mr21800235ad.7.1769152354475;
        Thu, 22 Jan 2026 23:12:34 -0800 (PST)
X-Received: by 2002:a17:902:e94d:b0:2a0:c92e:a378 with SMTP id d9443c01a7336-2a7fe75b8d7mr21800085ad.7.1769152353970;
        Thu, 22 Jan 2026 23:12:33 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978e0sm11336775ad.62.2026.01.22.23.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:33 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:42:13 +0530
Subject: [PATCH v3 2/3] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-enable-ufs-ice-clock-scaling-v3-2-d0d8532abd98@oss.qualcomm.com>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
In-Reply-To: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: 7O_4BGRoPhYjXqvwxvA44cG_ifYrRw0-
X-Authority-Analysis: v=2.4 cv=O480fR9W c=1 sm=1 tr=0 ts=69731f63 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=lzHOrk3F_0XHYG_XrgYA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: 7O_4BGRoPhYjXqvwxvA44cG_ifYrRw0-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXzxvKCwxtFz12
 waEJnSnTUDixOek/x6FhWr6Zo473bsEXKb37y1WgwFO2fefA8T8xmFE8eRZConh1lruYo+sdwA8
 3ZxQpTHib82WUVAN1nv8DwToTTZEs188mMS9lUE2TbdOFt+dRSW2BiCrqWWANpHcUMEo2Ck/MDM
 Uw8dkj8PvgN7g6Z6jnjkgdHVgjWg01nrrGXbObuuYzmKHK5Y+2EQZ1796+FWnGkNBGF3WNv6kgj
 N7YUPvtOn/4I6xyTr4uWHQMBE4c+29L3oHz6afTm6zEJSNCcMaMOpzguiAwqg3buDmWeSj2YSqi
 c8lBYnUbuSQXEUUltjhrC0JTD9bZzP9k+wwQ84syGxNKQ/Jz7cW2bI64JpEH/3CgzwRuo+YDnp5
 VeGbWe0g8IW/Cj3YBTn5wcfo/04yRiGyC4MHBQJPMP/gGB387C/QWwgYAwm0S9GdOmVxFmTbRWY
 +AKs3bVfZEfZ6grmSsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601230054

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

