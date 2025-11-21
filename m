Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C653446BE
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721390; cv=none; b=ppIg1h7lr2bZph8qqLVrBCB5JsNdk3APZ0/cWC646xtRdZitk8QyxuSvzD7Jxrue1Tgs83U5rrFE0Lmx1GRY6yNhHEq0lqAwuDs3iWc4Nhw7DoyK10LG0aOfQTZ8dOn3mxPMlS0fWgAhguhTZTdiFvsd3X1c2RgYp9LE2RYtL6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721390; c=relaxed/simple;
	bh=0A3EpZQZ/3VF/riYcZPhzwUOYsocoTCYKiKNd4wGJ8o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=U3xZ5MOOXXlqU/2e6nNkMyGvJmAXFEtwwBp9Dmt+iDbdnnFZV9YgieDsIx4zR+rwwIxA7sqxf6ehUUha8Rgb3scuiEBsYzSN/v+Gom4Wr/tHc82SFncrMyhXM0aW/4HM+3YfHNZ1WBILNQMUY7o3PEgVUJAGvVpJoUM+dQLC/y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TAmPULLO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ACmc/9NA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TAmPULLO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ACmc/9NA"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AL9SYD83541425
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=c/YYXbS2yGm1NR91FtaYtc
	YdvhHxZruExaIiINfkI7Y=; b=TAmPULLO8kV2q2tmekrKQbL3cKekDGc+2HeZ3a
	73c4FraOgDdPg+JOKCu0tuGUZzSe/hdmnyiMfrYLsFl0Ye3TS7YyeKmQKyRj1XKG
	7/pYfvVg0o4fNtocGnuYbQ4FyzVD4HeNUdforEZHl7tBxapsyNMtv9UAWNm0W0ID
	yCYOzYqeIFU4wOdNRT1AK75l+GybzVFPTDvI2yuwJkYZIkaTXcCGG9H8fAd853KD
	vipo3XjsdJ5p+F9gXGTZjypD5wTAswGM6w1TrrxJQYRLwjT6VlnmMCaeaz7+qP9M
	nVd4q2AcTwYWEkZoJ0A7dkmb7jNpOK4yLaAw1cON7YL3mY8w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ajng007ct-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:26 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-343d73e159aso4119493a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 02:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763721386; x=1764326186; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c/YYXbS2yGm1NR91FtaYtcYdvhHxZruExaIiINfkI7Y=;
        b=ACmc/9NAm1jOgfJA9nvjKJruyPX9Mv9OQCP3aXUnjv8RvsfAp67NwGyNlTazV3Pkee
         wKq69PUhCz2EwlOtDd6yZpxtfEHu+s68vT0T5fmrk6M7c3oOngtuaAspOEHe52NxbMH/
         7tOJ2Yr9hUKEr7Se3AKTMy7sAVCqj0s6dsDsRrw7W2DwXde04e/deEN3BWsNE13f4cm0
         FkC4UwbNVMCWi1RyQOHa7774geTF7SL/cO+MWKFioCVtn5UZRqESJF7Zs0pmZTdm1CBk
         cgrWf5iWgcPsETIQFdG1QTpy3K3Z7jwdOMlot+xsyZoGIiAUQLLkAFoyR1cgXaaquBXg
         TG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763721386; x=1764326186;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/YYXbS2yGm1NR91FtaYtcYdvhHxZruExaIiINfkI7Y=;
        b=BAZZDCVAlAUgVwwM39X/YCWGe9Mtf4XOSkHMCbDzNRL2afi633uv6wr5tYcugeXm0o
         BPlmdcF0qRJVd8Jt5jetJJjnWIt52P12MdWMqU1b+Oskgfvvhl2AzIjIXygUUSAxXYyc
         tUwNUhUmrq2tqOtRI2V2pK4WLvxnbiN81E0g3pAznD8lkfuNllBslh/Xr41tol/mBR76
         bqPwPa7NjptXLNE8bXW6IOexuuu6J6JYQStEENlYVlelhMkWBvTdYOLCTkR11FHQVBcf
         /81QuKlCz2lnqgwdm9s1vV01LRmHA0xepLVjng6Sfo37/Zp0siSNNP/4krunsOIp5Fln
         XvLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUPhV3qemEic2qnt4Ud1ZIwzWyqPD8SERHFVg7lnwK/hQ+QOl7ho1ZGbz48VcD08yDE7QCUUaQIKcK@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfcb9cUPT9jUzqHVfTGL0x+zMbIDv6KYDvHR5un2QBbwMhex7Z
	ngXO3XhO7pXQUAzdahZf4KvAjWIf3ZMgCDrLWq5XNozB7UZcmzr7m8qEtIe8sTIYdwGemt5c0OH
	mh8JTbHFn1qeFwCRysJZbyZj676Y3b+Z2XFyNI8YUNOhzio99IhVSW+uzSFrLn08H
X-Gm-Gg: ASbGncvyTs8JDjSWTPGVSYHnoVnDPvqKpDCpj8rKLlBhU9BJyjD7Gz7b3Y1uep/a6YL
	lCH4Vm54pyyzaV9//t1cRAAhB9mzhfdttMo5Zw4kx7boLBgY/+2PjsAaSLFzDdrrHpcH85jfDYI
	5PyRXdiH3Fbv9uXCPLSWSI3/vFAQkd6wML3eKh3XnIVJDQxPUmqH1aFaP1kts2RkjPamA9L4tZV
	plY/wZRJzim7Si8FqNwP0FRdpXbTnPUCEsu8dJgMGwKM47HwpzBDAihTSIuhmC/X4HCyyB9ZTRv
	bBRJhoo4mP6dlL2PtjYGALYq6M+cDdGRLpJUQZA6tyxjuzmW0StHC0boi6MPv3EaA/bAtLoQKhx
	CNfi/WGynQoTUNMezC17oIj6Ip8RcxZZR0y/BK4lHIUJBdiM=
X-Received: by 2002:a17:90a:ec8f:b0:32b:65e6:ec48 with SMTP id 98e67ed59e1d1-34733e55f77mr1982310a91.8.1763721385815;
        Fri, 21 Nov 2025 02:36:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGg8evWjT38FXSh1jkEtQIwGVf79CscEpqyYJEKPGjYCWgoSXZgj8E1m9FIY7vWbTnfb52CBQ==
X-Received: by 2002:a17:90a:ec8f:b0:32b:65e6:ec48 with SMTP id 98e67ed59e1d1-34733e55f77mr1982286a91.8.1763721385398;
        Fri, 21 Nov 2025 02:36:25 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34727be2fa7sm5122890a91.6.2025.11.21.02.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 02:36:25 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v2 0/3] Enable ICE clock scaling
Date: Fri, 21 Nov 2025 16:06:03 +0530
Message-Id: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAJNAIGkC/32NQQ6CMBBFr2K6tqQtoQmuvIdhUcYpTCytdoRoC
 He34t7NT95fvLcKxkzI4nRYRcaFmFIsYI4HAaOLA0q6FhZGmUZroyRG1weUs2dJgBJCgptkcIH
 iIHtla3C+RutbURT3jJ5eu/7SFR6Jnym/99qiv+9PrJT+L160LGloG6ut6m1rz4m5eswuQJqmq
 ozotm37AO0PaO/PAAAA
X-Change-ID: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
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
X-Proofpoint-ORIG-GUID: GEpKCj5XNhC2QvyGlGaq4J363vRXuATB
X-Authority-Analysis: v=2.4 cv=R+UO2NRX c=1 sm=1 tr=0 ts=692040aa cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=QSgEqrcxAPkzhd_bmtkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: GEpKCj5XNhC2QvyGlGaq4J363vRXuATB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIxMDA4MSBTYWx0ZWRfX7e5+gm+Td0zA
 RS5O3HLb2+12TVnT76WQDIUqUbMxkQekzkMBdrU3a3xe57BnZc9twKM7fLC/I7XsUljIiMnaAE7
 mBS7iYJrRSDPw7ugVw5r+WsBZs+dcvNbe33SekfFNScv18l08HmUTo7vM5PB/79j3sOGwW+IYVp
 HhvtKiMteRZwVYy1JXMg7WyKFjx+/rvzoE/18sFuo5uEbxb/jRnLUdYWHsO6NfCyLlIiVEd6vUu
 DeUeTubVsAhbLO3NQQlnHPoKoKiZ0sAtbllAZ6054yTYnQapI/+XL34Xnqa4nM7HlKSug88YU0R
 hJNgKifATz+c6ciuRmsAib7i1LFLHY9KAoAkXNxhiNocmxgdl40e/PC4/UJA0S7lcUBLGQrgdf0
 koIbWMQ06S5lq5uUAyP9gojA/nMDAg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511210081

Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
using the OPP framework. During ICE device probe, the driver now attempts to
parse an optional OPP table from the ICE-specific device tree node to
determine minimum and maximum supported frequencies for DVFS-aware operations.
API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
controller driver in response to clock scaling requests, ensuring coordination
between ICE and host controller.

For MMC controllers that do not support clock scaling, the ICE clock frequency
is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
consistent operation.

For legacy targets where ICE is not represented as a separate DT node and is
integrated with the storage controller, the driver falls back to using the
storage controller’s OPP table to derive the min/max frequency range.

Dynamic clock scaling based on OPP tables enables better power-performance
trade-offs. By adjusting ICE clock frequencies according to workload and power
constraints, the system can achieve higher throughput when needed and
reduce power consumption during idle or low-load conditions.

The OPP table remains optional, absence of the table will not cause
probe failure. However, in the absence of an OPP table, ICE clocks will
remain at their default rates, which may limit performance under
high-load scenarios or prevent performance optimizations during idle periods.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Changes in v2:
- Use OPP-table instead of freq-table-hz for clock scaling.
- Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
- Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
- Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
- Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com

---
Abhinaba Rakshit (3):
      soc: qcom: ice: Add OPP-based clock scaling support for ICE
      ufs: host: Add ICE clock scaling during UFS clock changes
      soc: qcom: ice: Set ICE clk to TURBO on probe

 drivers/soc/qcom/ice.c      | 116 +++++++++++++++++++++++++++++++++++++++-----
 drivers/ufs/host/ufs-qcom.c |  15 ++++++
 include/soc/qcom/ice.h      |   1 +
 3 files changed, 121 insertions(+), 11 deletions(-)
---
base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

