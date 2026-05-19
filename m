Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B269F286891
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 04:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779164347; cv=none; b=WeDUzKunJh1EL9GFi5i324XIZU3MyW9QA8J5jDrCZKAvOqaDF1/D8BsSe9ChBLh7pNDUr3LN/TLYuQfFwf0yRswqvCrRNQnlA75+Sc+uFKx/y8ipYCHuiIZ9DQZ9MaoeLZ2sV+5ExgDswlYrFWHwLXD6YTv80cNYYNW1IArLxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779164347; c=relaxed/simple;
	bh=9CBVlFoOVTDsC5voXsZV5abYikkBO1yB1bpa9e9ZJmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7Q6HNBvfDpaLoK46eYDUn2rsZaUkzBQg15xsrTD0khxzWH8/BrvxiuTx7KZ0rUoEYQLzAty2g+ZkS1qnbpzZSYghh0pm98vv0/P/wC8lExtdcMlc3VLdTSQpuPK/s8d7+l/JbR1OawULOQe4VS2T5p6BJk5IeBn0IcWezPSjfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KCAyNbSB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JIhcVank; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KCAyNbSB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JIhcVank"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IId5Ic1250890
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 04:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lnM4NJyGEIyR+vmEiNA7vs8BcA5GFUvADg3Wqm9gRYI=; b=KCAyNbSBfZReNYVF
	vz7sxf76vtCmhc79euqJAitj8vWj9XRlzkl5jFBkpAY5zZhKlW5J0TA+BFzFVsFo
	25Heq5Zqrlt3qrLRfuccpthdG2zY5l/Okp9OZzgHF7sNXXCuKZKHxpTluKIsMUGT
	F/U7v+F3ZzcZVyxhUz1ZOQoeREF3+DmO9TZokfjFppiS+nb2BTH1jJv7ZQRWZL7W
	ZW7S0czYnBcAgYURq+h/nThQeCxjn+dcRyNmKR5Bkm6oWe5uNB8k0a1Px6ID/edw
	0ZhdGB52Ft0C/DM35ofvbCYXquopxhOD8bWFBWf1UMZqz1/yA4k3ad1p7U7K8038
	GlZn0A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e82c0k98p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 04:19:04 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-369467ab5bfso2809996a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 21:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779164344; x=1779769144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lnM4NJyGEIyR+vmEiNA7vs8BcA5GFUvADg3Wqm9gRYI=;
        b=JIhcVankG5gmbCNIvja/XKcoj9+vqPtgW0sBMfOldHG8+QZdjuqJpLeNPofrhY6iUg
         r6W3WmH8K0q0g2yHzyw39ysNUioqQInOZ1PXwLYMCizPnQPogCQJ/y2Q4wfpt1Z5eWhG
         17KWzNT3dYLQluzSYLQDKg+3Whimx1OmT5YAINPsh2x/1QSVC16iixQweF1/JbmDVNdp
         ZlrXAobeaCtdsZJ+3s/xIsMnRmg4zClt7NP3DXa+M1h5WfEJc467fjHUfOoGARLV2JoG
         H2qEtJwOBEfEBkOhehqGEB/kvtKWO5022TjZpXCmI1msRlUx35tQ4PzXM2uV1jjgqux2
         XoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779164344; x=1779769144;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lnM4NJyGEIyR+vmEiNA7vs8BcA5GFUvADg3Wqm9gRYI=;
        b=hLvtJx2MkCXZhjSu9YkIV7udonO0MnbotCwA2oY+FXMj0w7HYJKJ2VXhYetIPb70S4
         MeTCOdi8ktMVhw7x39smKnrOf5np1KmjvLYQybFfdhqqzyMQJXZo4qaD9pdYQyZf97vk
         ARVqqTVKdqZlYudl+QvhrTQAGXJpORhO9BzoWyInFvfCqXS38PAx/6kTF/bcc0iT6BPh
         4h3KMDwoLkZy0mpsn3Nq96otPBsXy31KO+fFpQ8dfNtpfkwfQqR77wy8j0rhIWP2NxFF
         ystmuweY+kNTQPUv4zaDgtz/c0UP4JWRgXYiuj9Gwc5fIZkgVXfheuj4i3JqZ0n8OXLH
         bV1A==
X-Forwarded-Encrypted: i=1; AFNElJ+oeKTpaOo22fVF634rM0Xx2Kf5nOB+Ed9wiC+td78yK9ZB9AYFcup5Rws995Wi2HppefLbBOkJcxeW@vger.kernel.org
X-Gm-Message-State: AOJu0YyE+f6OhurSr8hs/bpeWwpI1XdiPwyGrmtpYjska+VCCqK6fnfD
	VGrW98/9o+eELHtazxofmPl4w8JM/1JgRexqckuGjV5NyS/zI12xLI5YJvLS61DYNB4IvBUHPMD
	LgpzTHh1GZFbEMxf9qPuIhuckMY3Dy9vzEpv2/i04XsWStVHnL4IdVmcb4jyFaNw8
X-Gm-Gg: Acq92OGoskaeNl18u8FhhGfTWzLYBGZ6+rdkc4VClJiRRWS/RrAhnvUEbTFpCvzYRuo
	kPZDA2Ez4U9gFoVwnaSGNufK7fLhiOWHjj70Gh7JLDnFJVta7LCZACwRmrUdr86bheQl4x7HBBW
	0kHKmXUk/eWwHszyq5Mfj8f2Za42ESKDI1qAdKGWL6LjZEqsVjd/bVbtcGGHSFV5q57S12BhvXj
	nYD7bGYqib675T6FPLTYDid9WKrk3nhoVvI1iyaAaF+Wo4MUiYl2K4Jzysag8vSAyS9Q/mx3Eba
	SMlX3G+uQhGfY3hC5zAQL5p1ddJ4vXus1PuufKBVe3BnT0o6YEFiq6fJf8VE4Z6laIczQB0qIhi
	c6tg4NONfAlo6ouCvd1c8ZUk6ye7IzmVuYsTEWC47txJ9/WSJIw==
X-Received: by 2002:a17:90b:5284:b0:367:bc89:546e with SMTP id 98e67ed59e1d1-369519e5346mr17091069a91.12.1779164344094;
        Mon, 18 May 2026 21:19:04 -0700 (PDT)
X-Received: by 2002:a17:90b:5284:b0:367:bc89:546e with SMTP id 98e67ed59e1d1-369519e5346mr17091050a91.12.1779164343568;
        Mon, 18 May 2026 21:19:03 -0700 (PDT)
Received: from [10.92.181.2] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36951437316sm12725222a91.11.2026.05.18.21.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 21:19:03 -0700 (PDT)
Message-ID: <f12b1bd8-4cc7-493b-b1d1-262212bc3e44@oss.qualcomm.com>
Date: Tue, 19 May 2026 09:48:56 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 3/3] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        andersson@kernel.org, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
 <20260518165346.1732548-4-palash.kambar@oss.qualcomm.com>
 <c6hlbz44belq5l3ko23ijny22hxzei5fexk47hwselgn7onsbz@o7uwxlkvgtwt>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <c6hlbz44belq5l3ko23ijny22hxzei5fexk47hwselgn7onsbz@o7uwxlkvgtwt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDAzOCBTYWx0ZWRfX8n7sMOm3uYQV
 6B9l00jVE7vwH1hGhd6VrmkzlEAAXHnEFpTteOa5QlnyFb8jkZPHPBm5m3dbjQv5zkpB9TVAANS
 lpCh0PG5k8faUp14EonjEyPzvyHxACxH4jlc2/GXf5HO7Z1l1M+Ni+oyyg5+6nVzMiD03JIAH5J
 VSeeOwDmfIfTw1Wk3rOU/vG+eqT1dTwVR/U4yXi9maDO/4wa9tMHnuXtFSHCrneyGYPNr90RAx6
 6bTlt1owf5iV6FAncFUUlJo72WeiGl3ikoAsMP5Ip3og8uUUL7lkPOtGyGLxvaZZ4IpipIpIF+P
 A9nMO5lI9mISPxzCNjfH68MMTodYQb4sb7fuAUwWYIKIGofwisk4HDsKC0rychCojagCwBUsCNy
 MlRKCHlMNrFVRf3Y8VHBYIHfMSxKw6ckOO5qp98UXJaNuhfAoA9Oh/TGUn4BRAU++9YjhFOESoU
 /H1hrRN+EMQZRwabqJw==
X-Authority-Analysis: v=2.4 cv=A5Jc+aWG c=1 sm=1 tr=0 ts=6a0be4b8 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=B5rOy3ph_a5vLh5NyVAA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 62t3hAWWCfmxKc6OkJsodPQWKb8wL6tG
X-Proofpoint-ORIG-GUID: 62t3hAWWCfmxKc6OkJsodPQWKb8wL6tG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190038



On 5/18/2026 10:39 PM, Dmitry Baryshkov wrote:
> On Mon, May 18, 2026 at 10:23:46PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> Add the init sequence tables and config for the UFS QMP phy found in
>> the Hawi SoC.
>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>  .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  22 +++
>>  .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
>>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 140 ++++++++++++++++++
>>  3 files changed, 199 insertions(+)
>>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
>>
>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>> new file mode 100644
>> index 000000000000..bf914c752d22
>> --- /dev/null
>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>> @@ -0,0 +1,22 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
>> + */
>> +
>> +#ifndef QCOM_PHY_QMP_PCS_UFS_V7_H_
>> +#define QCOM_PHY_QMP_PCS_UFS_V7_H_
>> +
>> +/* Only for QMP V7 PHY - UFS PCS registers */
>> +
>> +#define QPHY_V7_PCS_UFS_PCS_CTRL1			0x01C
>> +#define QPHY_V7_PCS_UFS_PLL_CNTL			0x028
>> +#define QPHY_V7_PCS_UFS_TX_LARGE_AMP_DRV_LVL		0x02C
>> +#define QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY		0x060
>> +#define QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY		0x094
>> +#define QPHY_V7_PCS_UFS_LINECFG_DISABLE			0x140
>> +#define QPHY_V7_PCS_UFS_RX_SIGDET_CTRL2			0x150
>> +#define QPHY_V7_PCS_UFS_READY_STATUS			0x16c
>> +#define QPHY_V7_PCS_UFS_TX_MID_TERM_CTRL1		0x1b8
>> +#define QPHY_V7_PCS_UFS_MULTI_LANE_CTRL1		0x1c0
>> +
>> +#endif
>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
>> new file mode 100644
>> index 000000000000..5f923c3e64ec
>> --- /dev/null
>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
>> @@ -0,0 +1,37 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
>> + */
>> +
>> +#ifndef QCOM_PHY_QMP_QSERDES_TXRX_UFS_V8_H_
>> +#define QCOM_PHY_QMP_QSERDES_TXRX_UFS_V8_H_
>> +
>> +#define QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX		(0x34)
>> +#define QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX		(0x38)
>> +#define QSERDES_UFS_V8_TX_LANE_MODE_1				(0x80)
>> +#define QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE2			(0x1BC)
>> +#define QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE4			(0x1C4)
>> +#define QSERDES_UFS_V8_RX_UCDR_SO_GAIN_RATE4			(0x1DC)
>> +#define QSERDES_UFS_V8_RX_EQ_OFFSET_ADAPTOR_CNTRL1		(0x2C8)
>> +#define QSERDES_UFS_V8_RX_UCDR_PI_CONTROLS			(0x1E4)
>> +#define QSERDES_UFS_V8_RX_OFFSET_ADAPTOR_CNTRL3			(0x2D0)
>> +#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4	(0x120)
>> +#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_FO_GAIN_RATE4		(0xD4)
>> +#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_SO_GAIN_RATE4		(0xEC)
>> +#define QSERDES_UFS_V8_RX_VGA_CAL_MAN_VAL			(0x288)
>> +#define QSERDES_UFS_V8_RX_EQU_ADAPTOR_CNTRL4			(0x2B0)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE_0_1_B4			(0x324)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SA_B7			(0x3B4)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SA_B9			(0x3BC)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SB_B7			(0x3E0)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SB_B9			(0x3E8)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SA_B7			(0x40C)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SA_B9			(0x414)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SB_B7			(0x438)
>> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SB_B9			(0x440)
>> +#define QSERDES_UFS_V8_RX_UCDR_SO_SATURATION			(0xF4)
>> +#define QSERDES_UFS_V8_RX_TERM_BW_CTRL0				(0x1AC)
>> +#define QSERDES_UFS_V8_RX_DLL0_FTUNE_CTRL			(0x498)
>> +#define QSERDES_UFS_V8_RX_SIGDET_CAL_TRIM			(0x4d0)
>> +
>> +#endif
>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
>> index 771bc7c2ab50..a4801cf4b0fe 100644
>> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
>> @@ -29,9 +29,11 @@
>>  #include "phy-qcom-qmp-pcs-ufs-v4.h"
>>  #include "phy-qcom-qmp-pcs-ufs-v5.h"
>>  #include "phy-qcom-qmp-pcs-ufs-v6.h"
>> +#include "phy-qcom-qmp-pcs-ufs-v7.h"
>>  
>>  #include "phy-qcom-qmp-qserdes-txrx-ufs-v6.h"
>>  #include "phy-qcom-qmp-qserdes-txrx-ufs-v7.h"
>> +#include "phy-qcom-qmp-qserdes-txrx-ufs-v8.h"
>>  
>>  /* QPHY_PCS_READY_STATUS bit */
>>  #define PCS_READY				BIT(0)
>> @@ -84,6 +86,13 @@ static const unsigned int ufsphy_v6_regs_layout[QPHY_LAYOUT_SIZE] = {
>>  	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V6_PCS_UFS_POWER_DOWN_CONTROL,
>>  };
>>  
>> +static const unsigned int ufsphy_v7_regs_layout[QPHY_LAYOUT_SIZE] = {
>> +	[QPHY_START_CTRL]		= QPHY_V6_PCS_UFS_PHY_START,
>> +	[QPHY_PCS_READY_STATUS]		= QPHY_V7_PCS_UFS_READY_STATUS,
>> +	[QPHY_SW_RESET]			= QPHY_V6_PCS_UFS_SW_RESET,
>> +	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V6_PCS_UFS_POWER_DOWN_CONTROL,
> 
> Don't mix V6 and V7 registers. And why is it v7? The rest of the
> registers point out a v8 PHY.
> 
>> +};
>> +
>>  static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
>>  	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
>>  	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
>> @@ -1844,6 +1868,119 @@ static const struct qmp_phy_cfg sm8750_ufsphy_cfg = {
>>  
>>  };
>>  
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_serdes[] = {
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_HSCLK_SEL_1, 0x11),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_HSCLK_HS_SWITCH_SEL_1, 0x00),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP_EN, 0x01),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP_CFG, 0x60),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_IVCO, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_IVCO_MODE1, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_IETRIM, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_IPTRIM, 0x20),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_VCO_TUNE_MAP, 0x04),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_VCO_TUNE_CTRL, 0x40),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_ADAPTIVE_ANALOG_CONFIG, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_DEC_START_MODE0, 0x41),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_MODE0, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCTRL_MODE0, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_MODE0, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_ADAPTIVE_MODE0, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCCTRL_ADAPTIVE_MODE0, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_ADAPTIVE_MODE0, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP1_MODE0, 0x7f),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP2_MODE0, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE1_MODE0, 0x92),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE2_MODE0, 0x1e),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_DEC_START_MODE1, 0x4c),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_MODE1, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCTRL_MODE1, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_MODE1, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_ADAPTIVE_MODE1, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCCTRL_ADAPTIVE_MODE1, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_ADAPTIVE_MODE1, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP1_MODE1, 0x99),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP2_MODE1, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xbe),
>> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
> 
> Yep... If it is V8, use V8 registers. Even if they are they same.
> 
>> +};
>> +
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_tx[] = {
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_LANE_MODE_1, 0x0c),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX, 0x17),
> 
> And it's V8.
> 

Sure Dmitry, will update. Thanks.


>> +};
>> +
> 

