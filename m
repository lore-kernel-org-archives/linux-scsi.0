Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22133A71A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590026; cv=none; b=Hf047TY3agFqYK+CNR6COLCief8TRRGZRtnHKUodVM2tcGGgMXwb8beukMxvN1pQ4Es5kR6JPRYzCCC66ZsNWbR/2TzwoJykOfxBrpwSrI6oL/bXlZOgFGvOGwww3IyNK07oKlCYMzzzCKzmen0bgtgoyKS34CvzRcsszjLs9xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590026; c=relaxed/simple;
	bh=e3TRfsvo3h7etqIQP7dqbHgjd/404D3QWc/LuJuSsiA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L9rVDqLEKpqF2ZBl44wO5k54lcLBESFAPunU1A3sTEo7xyEv8QKcB5b/iB+7E/Z/vhHCM5s+CHF4nYqQRQBaV7oPMpuCQJnlByLtrOBNL9W3/rjILEoDx0t78JMlVG6CwPEGQIW8flYwNOp6BOmFV4mcXjmU/2DGlu0zaSc08eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Nil4uXHc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YgUU5H0W; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Nil4uXHc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YgUU5H0W"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S6V8wv2953549
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+peXoFtKe85BwjRu+lZhP+ZBRPDUzqAfBEqGFaDyxhI=; b=Nil4uXHcabl/djks
	KozDwTq+1ko1tTPjsRgqoIClkS0+4wyY7M9SnBZSxra1N6cuyTjYqli1AxmVPopz
	4FPueqd/79OCjb8lPPOya8iXmvFcVmGrjrYdF97+2qITJnv0BFdKNyimwo9XNVHa
	pv6GcANdkmHpN2Jaa5o3UGEYkJIsRzORC/Met7oCU0OPLF8PHwa8v5cHp8cU8A5k
	Us5fwS8rXpIrd56JGhftDBbpIW5DmpYeBjYiadr9hpmFysUTJ+UUHpgDvx7dYeAZ
	hyJtqJaOkIh4r55zqfMgugukJU3k0mrtLZ/Y9/bl3ZpeTtJdnTnnZ7VkTL2qHWNm
	TjhWzw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4by4sjsxhv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:04 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0bae9acd4so46949035ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 00:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590023; x=1770194823; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+peXoFtKe85BwjRu+lZhP+ZBRPDUzqAfBEqGFaDyxhI=;
        b=YgUU5H0WSQCGurv3Ib+gc77AJZZRa6ih5eTB6Z2YvhcsVVjWyNpbKm5OhpbUfXcYcI
         w1CdQjUtLKeMa8gEIVj6hvvheOPtA6YBpZdFJXvtzHDgevFvXpEZulPXGkd28wYdN8re
         05+3N3rzR91t3VqE0ArOcaB7rutgx50KyvoeJcGCmWxtMOq8NwTfHkhV7X88GEKiXtH/
         uZQTSHLcJNTHqCLZq+iS3/LmY0R2wg6Mrt0vwtbVBJ/t/Suwx8CV+Pa5iHuC5BzJybzI
         JgYc+CXR9G7joiAU2PgN4OsQTOK0gJ9ni9yGI/fB94jpPHNXRVPGnzno+/hXhenBC5ic
         iTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590023; x=1770194823;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+peXoFtKe85BwjRu+lZhP+ZBRPDUzqAfBEqGFaDyxhI=;
        b=VKaOTEKGGsC5fGs/oS9Hpo79Dc93B6NsAaBId/3Pg4+LhbIOhC0SwCxg752UjBg9m3
         Ras8mIeh3xVb84dSl4ofqXAZ/Ze2qsj9AZblB2qKyW7nYDkfkvdDHKxcU6vYAb200wUW
         r84D6wPshe/xiGiy+TtENdAo7gnK4y5rcYG0xBra6nnn51jxGLLO0qra96UHiuwUhGb9
         NWBO0Hl16xuPHmJsK90bkOkpw2C/bIjyoUoBA2OVyJ9AXt9432B3EKKeDXwbCA2dltkL
         +LdqdjauuADbIccQ6+Zv2bEMxcFJWM9pY0RMKg2XCJLfkRqsNzVVQFr0EhyzWHmyggyU
         dOUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDyWS3wlHjJm6dkb8N7nyZ5AFuqEGXJXJTB7xAWwvtWOoLLsHMzc9LAenJ7k47vMf0wviwfHjxceX3@vger.kernel.org
X-Gm-Message-State: AOJu0YyA2rEf5bPkkeVHDnC2pPaJ3OtFImQsVdf9urU9FC0D+l5oP/LC
	L1VtsCyI47BkfwsuVg2TXvygdLAN3dnD/18MOnNxlFdaLmEWvJ0HSTWgmHu8yrf5F8T2TE0DC6j
	xFpm6ncYbzV3OIFb+2Pl2NWLv9mGT+cCnGJSxEnjMQqu2ch2QpdyITG1RnlDA/7/X
X-Gm-Gg: AZuq6aIg4pPboucsGl3WFSjZAEJ+ght0441ndxE6+jA3zd6hNsfLVzaI98OxJYfyKTR
	TnU3e1+rl4WGYoXju6xXtL4/FKsiLnck4Po5mNQ9Z9pkmGaomKZPEriZ2uCQ9b8nBi/sAQ3Vg4v
	UOMtOgo/R4mv2EVnqvM1s9tYFp8xmTSvpiC9tO14mmgKg7EG/1uqStYT5lNUD0F+qg06o7SFVNr
	zqumnf/brJuKD68QszK3Y8Z8ZCBc+oVGWrWLHXnIPlZLonTFRDnJQhHFy9M9dp7DGod0Kr25gX4
	hySxljNPcjfjqR9hfHlIpdYvc/vElGxj5PkFnx2+OYs8YM3ftRxby293n0qg3c8/SalazpiLOdY
	YodIG3UFqH160DTKqTAxEn2eltyQKbWdfzu1OWmESeEZYYp4=
X-Received: by 2002:a17:903:37d0:b0:2a2:d2e8:9f25 with SMTP id d9443c01a7336-2a870db7621mr49442045ad.33.1769590023171;
        Wed, 28 Jan 2026 00:47:03 -0800 (PST)
X-Received: by 2002:a17:903:37d0:b0:2a2:d2e8:9f25 with SMTP id d9443c01a7336-2a870db7621mr49441725ad.33.1769590022629;
        Wed, 28 Jan 2026 00:47:02 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:47:02 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:42 +0530
Subject: [PATCH v4 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-3-260141e8fce6@oss.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfXzzJ+j/VULnfV
 +GngUFvvNpwlZa7YRrwdfJAeKVMNgwvaB94O4oiuTDZvvEAKsWt5SlneCpWBewcYhaOvpBwwRMZ
 spWU4xSIKpJfQRY+YJJl9Y9pjHfRvfrX4ImvMSfMS3H7pUdkAmjBajhQP5jofW2W783B4ELlAzc
 LsMky7VZ2+jcF9orOTOxCGgR+X0XokcHPaoSpWkVMB1NRRZ67wCQrqGSEF4Y5cNKG4TeSDOAnir
 Jf/4lSs0x87ExJe6e/1g/hziGJ6EFDpGR8K4HZfqItEwXRwKDsSEHY4G+rVZXFMnfwVjAbHauCn
 uBVnBd4quEmdrOoZkuCuNUp54kTUChV7fll2aj/ehgKsWDYhRU0fkSaEuRL26OfK/rddlAHRAZK
 82S601WpCCKF9v+R4j+SU/zFl72aw7hpKrUxtzoevrk++N1FLT7+bYnpAQDTjn81fJCYhGb9F30
 +rxmz4P5XkcqAchDnZg==
X-Proofpoint-ORIG-GUID: rHfAPDBF2gsH1HNsI1Z0UX5DH_F6kcGG
X-Authority-Analysis: v=2.4 cv=KezfcAYD c=1 sm=1 tr=0 ts=6979cd08 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=lzHOrk3F_0XHYG_XrgYA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: rHfAPDBF2gsH1HNsI1Z0UX5DH_F6kcGG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280070

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..00cb9cde760380e7e4213095b9c66657a23b13ee 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool scale_up, unsigned int flags)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, scale_up, flags);
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
+				  bool scale_up, unsigned int flags)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,6 +1661,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, target_freq, scale_up, 0);
 
 		if (err) {
 			ufshcd_uic_hibern8_exit(hba);

-- 
2.34.1

