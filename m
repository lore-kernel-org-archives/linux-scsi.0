Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662724;
	b=XFk0kOob/iyUaxhw8FmrFgFkTmrUd8H13cd7bYpZgGOTFC60B2YbtNAt52zPE15WVDox
	 4uD0z0arpw3mSUd89cMoAT0dXAD0wKibASDFixA5iCBOX3Y+NztOh7GdLHFIAe0A8SnJG
	 sK0gLDjL8O291125cs2v1RUlFnKCRjdkSUm466TsZCXGX0odNYCY3th2d5A6wYvrU5OkU
	 xR6htXit8oiCr98bntXmgZBeRFJj3iIlirWdgvvKCwvakIeIvQBWxSI7LQnavuEbX8xVj
	 egRzhJKXpsa5fPD5lTls67vsh1+DUUBYQy0bVua9DMzZ2ZZxKsi/NypDViT2qw5Y17Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662724;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ibZbAM6mxwTviQGJE6mRb86msHnx1wYpor8WMO/JeSc=;
	b=oIQ64Lq8EhsUltihieRnjRAA7WxoR7nJsfhWM8N+ZhWdPbnWGnxEVqbajxw4N7lAp1dk
	 dzq3tdy1IxGTIHHLEj6rIycofJflY+kGvdoq1ebfIr2xvYgm+PPeK1awHQkxwjmxzOpbO
	 lku+00UZsG+IirR4cmHCiqzXiYhlfM8w92z9KFm0cKUa8sj3xcSHMiJ4g9yN58QRTib7B
	 fjLmVzAegScMrPi/HDsCKU+z4uy26d9cr8x9JmkM1rZoqbJVzhmKt2UMHv8f2vwDVvo7k
	 Z1b/Xkq8741GQhAFDJkTdMf6Z+kAtU1fgPlUnyD7vNfVuJPZjVjzNRzu/n8h20vk1vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C7Xzwrny;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SmUBGrpg;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A38606A321
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11A38606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C7Xzwrny;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SmUBGrpg
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M708pT3517459
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ibZbAM6mxwTviQGJE6mRb8
	6msHnx1wYpor8WMO/JeSc=; b=C7Xzwrnyd9b9GwslpMsBv5OubS0kInrGpENouM
	O6O3cNuzljTdAxD09OxwUiu9GneqxHbEdsZjGn+jfoKED7NRGKTKE2fcQ6uk2aU4
	aHOx5/8peflJn1j+eN+OtdzZRFVnGN402bn2b01qb0jENTsOk8cFPAKUjrA9M4CF
	nS7R/CdRSOAi8y1VzfipC/szB5xyyTx0ARJsDnGY525C1AtpcvGwLttpLkH5wX4m
	EqH7G4D841pyLMsaPNtpE4lRa3bYiFa3bqh8MiIBBpVdm58gp93QijbUw3MKu+Ym
	d1QydRW2CzCnCszkW12IbKIYFmwBjD0AZ/iFiJJApc2T4O7w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93bhrnx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:52:02 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so4261359eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 02:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792662722; x=1793267522; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ibZbAM6mxwTviQGJE6mRb86msHnx1wYpor8WMO/JeSc=;
        b=SmUBGrpgJUf+Tq9+aT80UlaXIpb35ocvWF/8JPjhbZZwzP5H1GhnQn3w2vKhsVB9aW
         mwML6HYM43P939haimf0VL4Z/F3Snrw83eywgLTyx0w6tqQ9bOFfqjMmEhfqak4llGxa
         sUGAq017CS18nXPZz4rfLqj41UdNuxNsCcOL5CwRFYacvVjjz+lPIYBQPSg+KDC/UbIJ
         zxnHu8nxZr7BOp+G8ZeMhD4kSm0jq8qNpWTtmr+XaU8W/lJ3nN4gAYzhyOae8XpS2pPV
         zOAmzanlrWrLyi7kDs5ulX6mllRZVUr+Owr98kqBFzA1rZfC5aZD2n+6bRg8sq8d47hf
         2Tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792662722; x=1793267522;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ibZbAM6mxwTviQGJE6mRb86msHnx1wYpor8WMO/JeSc=;
        b=n0yzLCJWw7kCky4f4o8kfmBQn5nx0g8QWPu2mAK+Owp/tX6T3K2gsDgqKRsbvb9/cQ
         oILYMNxN1csIJPwTHUBr7t4m0PNXDWNqVxcnJKrL4M78ZdEr93f5k5edE+ba5duGshH6
         Ga3mXMzOSExEucasoeJjFRasS96pRJd4+UFVdG7rFvZ8JDHGABe1n+XLePlbmx6SBh+Z
         Tud8GRl55xCSFgCVbLgm9hQ5vLV36+IpelePjAfgOE4KSZis1c1qsVPci7cBiSCZz4uK
         Ya4zp172S68Vo8uEij1iAP8sInyUvvA0uCKMY2sUcvz5ya0AxZOQHOq1Vqbi73KIw5NW
         8a7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxEcLhe2JRPvhSP067XTj5gAI7JxkFHm8uVrnrkfTX1L0nDxVLBjVeSX5tSGU/gMU8BTYQ81GoccHn9@vger.kernel.org
X-Gm-Message-State: AFq9FYKQ4gpeGtjZK1LmJSQRvhU/cb7GG6dTFTaDGPKDqJHjV9w2ZJjv
	qJy+LzyrgCx3ziDsUrnQ/BTMQIt8ZRi1KWACo1n4uItDLQ9MmypKzQhwnjhvVtF+HEZFmiIKkzR
	kDjVqYEhGzDn8pe0gms/sDcJ6jkDJ/MZhrSUTbCPLeKRNE3n8qlNFskZHPJkahhjQ1BnzVl9i
X-Gm-Gg: AYBFou1ZlCtpv0juVrNCpQgScJCVj6T0keVvs24SnIETshxTdbNc/068ipEQYk241m9
	M/f43Kg70AckLy0sZP5XGSD9gyCbMAvGmBbQyaYZMTJMurZ6Ne2Z1h4vuZy1zruWJtXmuuQUyS4
	D7PjNLCzyud4P4Wv0yp9ID2pzopdo1mKJuuMDGMYgT6xq+y/x+hNL2AKMK5J2MhqLcKYiBjH4T1
	Fzy4AL/immYmAV8OgtrXqBFCBOIh/GfbAv0dkHdTFYDbu38gr1OhAHD0oiTSAAS1y8me5DxbJrq
	CA6/KLpV/yK1v6qafI0GkjZVLMdgRzCHE5xOfFSQqFlXOAgs/RGSTeR7OvlOCLYrPttn/N7PhBN
	qBwhlh7MwEpehHqACljdRbtxvpWIMZp6H
X-Received: by 2002:a05:7022:f512:b0:187:efba:9ba2 with SMTP id a92af1059eb24-190a84c55a9mr4905130c88.44.1792662721816;
        Thu, 22 Oct 2026 02:52:01 -0700 (PDT)
X-Received: by 2002:a05:7022:f512:b0:187:efba:9ba2 with SMTP id a92af1059eb24-190a84c55a9mr4905106c88.44.1792662721247;
        Thu, 22 Oct 2026 02:52:01 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e153519sm15742170eec.3.2026.10.22.02.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:52:00 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/3] ICE: Enable runtime PM support
Date: Thu, 22 Oct 2026 15:21:49 +0530
Message-Id: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALXc2WoC/yXMQQ6CMBBG4auQWduEDmqCVzGmocOPjpGCrRASw
 t2tsvwW762UEBWJLsVKEbMmHUKGPRQkjybcYbTNJi75bEtm85ahdypwY+8QGv+CqeTUsvV1jSN
 TDseITpf/9HrbnSb/hHx+J9q2L2ZT2vp2AAAA
X-Change-ID: 20261022-qcom_ice_pm_enable-3c5d21b99e42
To: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfX8HnUvYode6mO
 E/IFcx1d7OAO5dQNSJdAGg0rpoe2If7JNe1dkCmExZYEfU5dQTaIFmFyh+r/FZtHPmCX7kF1gO/
 Sp8HxRIT0eg6gYg6UzEe1eHnsw/Q+qWlBDr7zN+NAhAlqr5zTwzea9ZMbi5BLBgV0RhdgniRkmf
 cFyUqG9EHdKlG/UNUQ96d1WD28plOjmmIlq1il9PuETBJer3kMnrUlr/qmqX6Bx+cljhCrMnDaY
 OgdMsesbdgbqenxTmEmsuXMzBHznvrJgWGcqPZD+AIBGxslVJr3z1MUs0EXq6rFRyTQc8pdmhgO
 PqHkpbspFF5Y2euzqr9hj7Hl4Ev4H9weCHygNldXl1xqxC0ux+WwdrlokWsDlf7xkXWAyR2OlV5
 Gr78SK3Cjywhdec2L32xuczksWDnAFPNPJqQNaocD/35o7JVhtQEIWY5OQebzRjl5twOPGmAsz8
 tN6IJ4ZJ38sMVZ5fZzw==
X-Proofpoint-GUID: kYw2oeflL4Tq-wj1ObzaZZnREM8gVQMr
X-Proofpoint-ORIG-GUID: kYw2oeflL4Tq-wj1ObzaZZnREM8gVQMr
X-Authority-Analysis: v=2.4 cv=CMy/zhrD c=1 sm=1 tr=0 ts=6ad9dcc2 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=q2l7TY2mCMnZi5pTjLMA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfX5LmAf5B0IQVZ
 vG8jtZ3QhztFerrhU9QlTEskqygVnUSnI5IdK5JhKUNs76U/HF9Dosl3UchmsxlaUfOi2HTAF2K
 uicERS90sneBT/SRSMrMnNPoMrBRISk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 clxscore=1011 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220039

This series fixes ICE clock lifetime handling when ICE is modeled as a
standalone device and referenced by storage controllers through
qcom,ice.

Currently, ICE driver enables clocks during probe and keeps them
prepared after probe completes. This keeps the ICE clock voted even when
the storage controller is idle. Add runtime PM support to the ICE driver
so the standalone ICE device can enable clocks for probe-time register
access, then disable them and remain suspended while idle.

While enabling runtime PM in ice exposed couple of sequence bugs in
storage drivers(ufs and sdhci-msm) as any key programming call used to
go ice and never complaint as ice-clocks were always on.
Example, unclocked register access happened from ufs/mmc in
qcom_ice_program_key().

qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));

Fixing this issue require ice instance at early ufs/emmc probe so that
correct sequence is established and ice is ready to accept key program
calls from blk-crypto or any explicit storage operation.

Merge strategy:
Patch 1/3 and 2/3 are storage driver fixes and should be available
before patch 3/3 lands otherwise will result in bootup crash.

Validation:
Tested on shikra-evk, kodiak rb3-gen2 and sm8750-mtp.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (3):
      mmc: sdhci-msm: Enable ICE before enabling crypto support
      ufs: ufs-qcom: Enable ICE before enabling crypto support
      soc: qcom: ice: Add runtime PM support

 drivers/mmc/host/sdhci-msm.c |  21 ++-----
 drivers/soc/qcom/ice.c       | 139 ++++++++++++++++++++++++++++++++++++-------
 drivers/ufs/host/ufs-qcom.c  |  29 ++++++---
 3 files changed, 142 insertions(+), 47 deletions(-)
---
base-commit: 9a482184d910775cf648863148944945b74e2815
change-id: 20261022-qcom_ice_pm_enable-3c5d21b99e42

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

