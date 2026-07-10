Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DEE3F7869
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 11:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684733; cv=none; b=XswR8maFST3kl0Ep8Ya4KU2SoSjlZQOZKQR1qJNsUwb2Y6w0UmX8BIjb9jpc9WhIjy97ee/IHKY7+RmNSnt0BfT2oH+KiiI64RnP2q6t/C0TVTSWvrCs/i2L27GQtpYzTG2+thB09cRN7gjm04CJKSgJE9YyDsmkInaH3mFjYEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684733; c=relaxed/simple;
	bh=dhcU7WWKBrIptr2rO7avt84lEHu/1rHnhWGmRsyMsR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gW48BqETqRXYhoJZi/Jz+rbwce6VBaN/em6VTXGzhKmfeLtrXINJjPnEYuqE4N+EeKv2LnpQ6AgeyyvL8pbRZ6sU92THm6UaaS1F5RstPlNt6YxipenjaxNPaJaWb1CScYOMrT+P+kZb0UBZ6hr8QpI5OHOcdnNPw9CZ5FdTK0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JZw8oN3J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z3v2Nyqa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JZw8oN3J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z3v2Nyqa"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66AAmW18615136
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 11:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QhZGVhj2JUX5N9gykpa7/WpW7Rt12wQPaI5D4gJufLw=; b=JZw8oN3JhixbrBS0
	1v5RyfyxxtwfVFl4ROpDK9tkNggNao3e5OScqsx0HXo6IT7cE6+rFd717wfUK76F
	qdg2ywgtId4o7JqxLzgjksXIFE9V873l2ccFxxk6heFkigzg2xOC0h/NbJP3jiET
	eGwpiiyGDStfIXltrT1oVP4zLO6lqLRI4CVc5u5btbZ1HbcdPUHIzatjV7rJIs5G
	MhnSmrrjpvyOJ1PFFfKzoHaBMZfIs0m/StR3Q8GIl3HPt1e0h5c0NRo6Jkifd/3t
	m6S0IiIyuhHmTWA3Uzvugjeqcj8UsquNqtLENLKBVnD7PjIYoFEG92vV6BHc+b9o
	QZOrCw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fajte2x73-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 11:58:47 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso1383511a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 04:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783684727; x=1784289527; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhZGVhj2JUX5N9gykpa7/WpW7Rt12wQPaI5D4gJufLw=;
        b=Z3v2Nyqaq4E89CPGw8U8w/JVD1P0ZiR1TX2NbuLhwtEuJ2O/IaoCgQtWCH72U+1PYI
         EOvD8fQoizmsyp5Nm+YT+vhpGjQG7AkGWFKfzFbaW/1MPdqXRoyYXZbDya5cY2HPlywH
         3rfprTrNtbSel5BDgkV5TLOZoQKtFlbr4Q2Q4SaLSkMoxGG0QZz+y+HnTffTCd0gkGOE
         oc7X0KArKIi4HfxzomzFMpwpWyNdskMtmuXZeRCbZZYpnMTvhYkT9zdIFQ47UNAWrMHt
         wJlLHWBc7+TIxCml16sndhyV/GqmRhX+L3N6sV+eqojH1ZfOHo0OP6d44fj2nxb50o+/
         Q/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783684727; x=1784289527;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhZGVhj2JUX5N9gykpa7/WpW7Rt12wQPaI5D4gJufLw=;
        b=k85L7b1S5M62b8cRq9l8+wnYgum4sT1Ob3HgnWYpAgTUBS5uClAUV49N9GjAFp8S5l
         xdqiZcGUkRjhL8VjcetcD+IAI/Iki4yEcFKI5+hlWSni+PS0hs+xtKH6cJch725Uvqsl
         LX1siZu/v5JHtBbkEojy3CJ4bniNeTBTZj/9oIwBGL8ZmdaLLsUiLI4cNoil0fe0ZuSa
         W04INnKqGalJVp4pnqJh9BjqpymKM4EQKIDPJ9Df0oC+UMRZMJtwvuZt+92Z/ONtFNjP
         wk+HNIC7FGxEbsf8/WRlFowxd4bpiltt1EJgOVA8nNShgy9/z4X1fiPpYoEsYYJ2tP29
         KZLQ==
X-Forwarded-Encrypted: i=1; AHgh+RpJrwbSkLP8aFysUbCvGVU6qpEWw3fz+qTPLt/4zimkXtEJPwXjQQH6grsLL+A9fclwX34S4zee4mLY@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp336ukBhMZEWfUzN2pg1AFDyBTZXUtHQ0AonGrzb/OHiSBz9P
	3MgdXFRyNGuI5N6ib4UEGN6e6QNuHEyEXADh7I8gzZl5UW+8TxHXGenPAXznJ07g+1KvlzCwWCI
	KpPwSvzkYvXFdFumDlAFvytx5m/CV1y0D8fnDPHyfJcrqeFTciCTxTxRxLDjs81m6
X-Gm-Gg: AfdE7cmyE9J213h1TSKCYHZCnADXWc6SUo/hWjLydLDBu1cOS0pMcr1RTzdE+uNBr2/
	OIJPMr0r9/WjHZcXPl+Uz7FXDFQTU+FiwyNydkPTAJjsnHvW7jVxU+85SgQRgI7UeuZnZEtJjwu
	4D8jelrbSNVwRWYY+U/4ZFEzdPNIPBA8JNiUINyyQhDA+5+bH1FLx+vyzdt4tqegeDyrR52KoYi
	i026IaapozYBYn2cbOE+vpsZHxIj1A1nTJQQCqBVunQRfK0CBewjkUl4glBzRsaO/+BRFohUZlN
	GzU/iv6l8g2B7omhQGN9vss4FCbybg0lUfZhNSNSE0v4qT9SXM9BEiAZnBg0RxzCo8fpnMppT2+
	d6YJXgcGm9VVbHbcdil8qddmKtPSIllk6OCMF1mp6
X-Received: by 2002:a05:6a20:158e:b0:3bf:ee42:195 with SMTP id adf61e73a8af0-3c0bc90146amr13428413637.11.1783684726946;
        Fri, 10 Jul 2026 04:58:46 -0700 (PDT)
X-Received: by 2002:a05:6a20:158e:b0:3bf:ee42:195 with SMTP id adf61e73a8af0-3c0bc90146amr13428371637.11.1783684726291;
        Fri, 10 Jul 2026 04:58:46 -0700 (PDT)
Received: from [10.92.178.80] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b658a99afsm38927780c88.0.2026.07.10.04.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2026 04:58:45 -0700 (PDT)
Message-ID: <53bac441-a886-4007-9b25-ed8859fbc979@oss.qualcomm.com>
Date: Fri, 10 Jul 2026 17:28:38 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, alim.akhtar@samsung.com,
        bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20260615091242.1617492-1-palash.kambar@oss.qualcomm.com>
 <20260615091242.1617492-3-palash.kambar@oss.qualcomm.com>
 <tyvt6by2k7wxzds5n67fxpwiw5rwmtwjyluyyntjba7fjo3ri4@no5ay6hxntod>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <tyvt6by2k7wxzds5n67fxpwiw5rwmtwjyluyyntjba7fjo3ri4@no5ay6hxntod>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: twqoDwjudNgx5CipZEYow1pAGUYAQLtU
X-Proofpoint-ORIG-GUID: twqoDwjudNgx5CipZEYow1pAGUYAQLtU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDExOSBTYWx0ZWRfX/eTsZ027KP/b
 ZfBUibqstxC9CkK/puxpKNV7lPqFcZCyChYptu35S+HLLriPZEhqWQj7oA9dGzVWGFp6TsO3sM2
 vLrNGMfVOqbKAcYGjK3DroRDRROXbKxKYS7RIEPhMuJKVT8qutv5H4biXdC+cufMNJ9M3SVEjLL
 zBZw64OmPGvaWv7V9F81fuaYGJ5Br9QDMD19nbdVzT9AUAO/oUtejkHRFKO16zA5l8M7AW63tP5
 vc7wvkNv4bNVysEsZXeqzq8l2QfyHIp/+Z0S9Xy21yzfnJ1Pcigr4GoVZOW6m1GLXdMh4XTD1qu
 URChXfSUvGswwh3TB0k7j9LUhYtf6Pav6mpH+Ooix73p3IgeBrnVorqJMvMdmj83/O3qf7cGVkV
 JLO9asPBmBL4eUum7g0Vb+DrcvUCrcf7xq2Jg6RqY2Q6W7qx757kPbLvq397wWET0+jlQqv5/PG
 aaCx4jdsJNYwF1zh4pw==
X-Authority-Analysis: v=2.4 cv=N7MZ0W9B c=1 sm=1 tr=0 ts=6a50de77 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=7JFUvE9QZZRMEIWW0wYA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDExOSBTYWx0ZWRfX76tQKIqRUEGl
 ORX2B682rUJpyM8v9dxEo9sdAj/xwYxt89nYIMGrxzg5L+wt4mWsnDTlar6W8JCGIcJnRoW5HIt
 0hSjJUfDTDj2XeO1FKXfG2I3AkGDw48=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-10_03,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607100119



On 6/17/2026 11:30 AM, Manivannan Sadhasivam wrote:
> On Mon, Jun 15, 2026 at 02:42:42PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> Add the init sequence tables and config for the UFS QMP phy found in
>> the Hawi SoC.
>>
>> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> 
> - Mani
> 
>> ---
>>  .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
>>  .../qualcomm/phy-qcom-qmp-qserdes-com-v8.h    |  13 +-
>>  .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
>>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
>>  4 files changed, 212 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
>>
>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>> new file mode 100644
>> index 000000000000..e80d3dd6a190
>> --- /dev/null
>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
>> + */
>> +
>> +#ifndef QCOM_PHY_QMP_PCS_UFS_V7_H_
>> +#define QCOM_PHY_QMP_PCS_UFS_V7_H_
>> +
>> +/* Only for QMP V7 PHY - UFS PCS registers */
>> +#define QPHY_V7_PCS_UFS_PHY_START			0x000
>> +#define QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL		0x004
>> +#define QPHY_V7_PCS_UFS_SW_RESET			0x008
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
>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
>> index d8ac4c4a2c31..d416113bcb3c 100644
>> --- a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
>> @@ -1,6 +1,6 @@
>>  /* SPDX-License-Identifier: GPL-2.0 */
>>  /*
>> - * Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
>> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
>>   */
>>  
>>  #ifndef QCOM_PHY_QMP_QSERDES_COM_V8_H_
>> @@ -71,5 +71,16 @@
>>  #define QSERDES_V8_COM_ADDITIONAL_MISC			0x1b4
>>  #define QSERDES_V8_COM_CMN_STATUS			0x2c8
>>  #define QSERDES_V8_COM_C_READY_STATUS			0x2f0
>> +#define QSERDES_V8_COM_PLL_IVCO_MODE1				0xf8
>> +#define QSERDES_V8_COM_CMN_IETRIM				0xfc
>> +#define QSERDES_V8_COM_CMN_IPTRIM				0x100
>> +#define QSERDES_V8_COM_VCO_TUNE_CTRL				0x13c
>> +#define QSERDES_V8_COM_ADAPTIVE_ANALOG_CONFIG			0x268
>> +#define QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE0			0x26c
>> +#define QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE0		0x270
>> +#define QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE0			0x274
>> +#define QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE1			0x278
>> +#define QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE1		0x27c
>> +#define QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE1			0x280
>>  
>>  #endif
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
>> index 0f4ad24aa405..d4aca22c181e 100644
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
>> +	[QPHY_START_CTRL]		= QPHY_V7_PCS_UFS_PHY_START,
>> +	[QPHY_PCS_READY_STATUS]		= QPHY_V7_PCS_UFS_READY_STATUS,
>> +	[QPHY_SW_RESET]			= QPHY_V7_PCS_UFS_SW_RESET,
>> +	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL,
>> +};
>> +
>>  static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
>>  	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
>>  	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
>> @@ -1307,6 +1316,11 @@ static const struct regulator_bulk_data sm8750_ufsphy_vreg_l[] = {
>>  	{ .supply = "vdda-pll", .init_load_uA = 18300 },
>>  };
>>  
>> +static const struct regulator_bulk_data hawi_ufsphy_vreg_l[] = {
>> +	{ .supply = "vdda-phy", .init_load_uA = 324000 },
>> +	{ .supply = "vdda-pll", .init_load_uA = 27000 },
>> +};
>> +
>>  static const struct qmp_ufs_offsets qmp_ufs_offsets = {
>>  	.serdes		= 0,
>>  	.pcs		= 0xc00,
>> @@ -1325,6 +1339,15 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v6 = {
>>  	.rx2		= 0x1a00,
>>  };
>>  
>> +static const struct qmp_ufs_offsets qmp_ufs_offsets_v7 = {
>> +	.serdes		= 0,
>> +	.pcs		= 0x0400,
>> +	.tx		= 0x2000,
>> +	.rx		= 0x2000,
>> +	.tx2		= 0x3000,
>> +	.rx2		= 0x3000,
>> +};
>> +
>>  static const struct qmp_phy_cfg milos_ufsphy_cfg = {
>>  	.lanes			= 2,
>>  
>> @@ -1845,6 +1868,119 @@ static const struct qmp_phy_cfg sm8750_ufsphy_cfg = {
>>  
>>  };
>>  
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_serdes[] = {
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_SYSCLK_EN_SEL, 0xd9),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_CONFIG_1, 0x16),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_HSCLK_SEL_1, 0x11),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_HSCLK_HS_SWITCH_SEL_1, 0x00),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP_EN, 0x01),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP_CFG, 0x60),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO_MODE1, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IETRIM, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IPTRIM, 0x20),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_VCO_TUNE_MAP, 0x04),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_VCO_TUNE_CTRL, 0x40),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_ADAPTIVE_ANALOG_CONFIG, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_DEC_START_MODE0, 0x41),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_MODE0, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCTRL_MODE0, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_MODE0, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE0, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE0, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE0, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP1_MODE0, 0x7f),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP2_MODE0, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE1_MODE0, 0x92),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE2_MODE0, 0x1e),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_DEC_START_MODE1, 0x4c),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_MODE1, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCTRL_MODE1, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_MODE1, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE1, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE1, 0x18),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE1, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP1_MODE1, 0x99),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP2_MODE1, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xbe),
>> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
>> +};
>> +
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_tx[] = {
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_LANE_MODE_1, 0x0c),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX, 0x17),
>> +};
>> +
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_rx[] = {
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE2, 0x0c),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE4, 0x0c),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_SO_GAIN_RATE4, 0x04),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_EQ_OFFSET_ADAPTOR_CNTRL1, 0x14),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_PI_CONTROLS, 0x07),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_OFFSET_ADAPTOR_CNTRL3, 0x0e),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4, 0x02),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_FO_GAIN_RATE4, 0x1c),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_SO_GAIN_RATE4, 0x06),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_VGA_CAL_MAN_VAL, 0x8e),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_EQU_ADAPTOR_CNTRL4, 0x0f),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE_0_1_B4, 0xb8),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SA_B7, 0x66),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SA_B9, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SB_B7, 0x66),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SB_B9, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SA_B7, 0x66),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SA_B9, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SB_B7, 0x66),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SB_B9, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_SO_SATURATION, 0x1f),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_TERM_BW_CTRL0, 0xfa),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_DLL0_FTUNE_CTRL, 0x30),
>> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_SIGDET_CAL_TRIM, 0x77),
>> +};
>> +
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_pcs[] = {
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PCS_CTRL1, 0x42),
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
>> +};
>> +
>> +static const struct qmp_phy_init_tbl hawi_ufsphy_g5_pcs[] = {
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PLL_CNTL, 0x3b),
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x05),
>> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x05),
>> +};
>> +
>> +static const struct qmp_phy_cfg hawi_ufsphy_cfg = {
>> +	.lanes			= 2,
>> +
>> +	.offsets		= &qmp_ufs_offsets_v7,
>> +	.max_supported_gear	= UFS_HS_G5,
>> +
>> +	.tbls = {
>> +		.serdes		= hawi_ufsphy_serdes,
>> +		.serdes_num	= ARRAY_SIZE(hawi_ufsphy_serdes),
>> +		.tx		= hawi_ufsphy_tx,
>> +		.tx_num		= ARRAY_SIZE(hawi_ufsphy_tx),
>> +		.rx		= hawi_ufsphy_rx,
>> +		.rx_num		= ARRAY_SIZE(hawi_ufsphy_rx),
>> +		.pcs		= hawi_ufsphy_pcs,
>> +		.pcs_num	= ARRAY_SIZE(hawi_ufsphy_pcs),
>> +	},
>> +
>> +	.tbls_hs_overlay[0] = {
>> +		.pcs		= hawi_ufsphy_g5_pcs,
>> +		.pcs_num	= ARRAY_SIZE(hawi_ufsphy_g5_pcs),
>> +		.max_gear	= UFS_HS_G5,
>> +	},
>> +
>> +	.vreg_list		= hawi_ufsphy_vreg_l,
>> +	.num_vregs		= ARRAY_SIZE(hawi_ufsphy_vreg_l),
>> +	.regs			= ufsphy_v7_regs_layout,
>> +};
>> +
>>  static void qmp_ufs_serdes_init(struct qmp_ufs *qmp, const struct qmp_phy_cfg_tbls *tbls)
>>  {
>>  	void __iomem *serdes = qmp->serdes;
>> @@ -2259,6 +2395,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
>>  
>>  static const struct of_device_id qmp_ufs_of_match_table[] = {
>>  	{
>> +		.compatible = "qcom,hawi-qmp-ufs-phy",
>> +		.data = &hawi_ufsphy_cfg,
>> +	}, {
>>  		.compatible = "qcom,milos-qmp-ufs-phy",
>>  		.data = &milos_ufsphy_cfg,
>>  	}, {
>> -- 
>> 2.34.1
>>
> 

Hi Vinod,

Gentle reminder to integrate this patch.
Thanks.


