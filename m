Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD553264DF
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 07:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953245; cv=none; b=C+CLlZAAVXEkBlMw1nvX+U+RPTVT5cEHw1W096vFHe3BuFdwtCmfQVYQWsu1TqZiiuphzcrTBbaKFRGsC3gpJ6EdWgsw7+VbsXxkhJcY+MqWYIUykhHMbeqX00sIt9BiCDuQUn4Yx6vN/c+nHSPv/YjMa//pR/hxkzyoY697pYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953245; c=relaxed/simple;
	bh=pUFhRgZcU2TdETFDOoO8Bf0ioN6fFY+P5sMX83hBmFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ICNc2zTmQRfqR1dWKa8TSGBCtNXXGQiacaJ+nJ1qVLvV/Yj14iCsuT1wEfcwr7Dypq5qmVHxjSESk6I4azp1BcVpLb3vTlBtY0kU/VrnmuEsOgUidS7MovwKdJ9IDGBF5aGKlURWmv9lAwgPqPebLQHglLVES4BUfyHAhRu4kAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sv+szjd0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XTYChzVk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sv+szjd0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XTYChzVk"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S6hYX42754246
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 07:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZIJSHjPmbE5160eqXjRAxLmfKnGWp0tUz5Qubw7oeD0=; b=Sv+szjd0vOdMub+x
	yY5Agigy3+4nHmwrHUvV0MoPQlXQvlknQjH1xglhVnvN8X5EsA4EGt0G5GSRpnib
	JnXgXI5Znq44IEfo9P1opJqN1MF8FpV8pKJ2FiOA5a9+atH4jK7pfxhuw5PAMOdn
	0ompapT8CzxfTygCV85lRWpeIARFUSsDL6+sZvikZtArThNj+7qJYNxSurWJV7wp
	cIHpYf2bLGrMdqs/2JKXKbALS1HyElodYBjec6zKPt3ApSrgH3h187O1KucpnH8W
	okNx7BC36i23cxFpJspfIcBmJtC/4EIcuWRodBFGa77+VvqKqPaaHnbLogCEVTp/
	NgX0nw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7yc9sd9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 07:27:15 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c8292e18166so6157012a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 00:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779953234; x=1780558034; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZIJSHjPmbE5160eqXjRAxLmfKnGWp0tUz5Qubw7oeD0=;
        b=XTYChzVkW4MaPnzpm1BvKNzCzpDjoDS3i4m9PrVzyBsz0M5AX0bUN2CQW7mlFQwVfI
         s+1gmqfZcCQzowuiTRK6yMbtsr8lb+QxdYExC8FbBakiz+S3tlOeB9uclMdicfBxWQu0
         PsKP8WELYU1BMq62m6KnECRCdv7G2GddyEZ7wtO9aUe/BQGGVZBzJYFLWcV9YZHG7UN7
         q4UQhlM3ffuGKCX4qHiS5JqJQarCs6tDW1AfxdsREL7OqMPFEVY5GhwOUZ8cgGeI0w4H
         CMlq0l9dKx6r2RLpSSTdbyhLuc9XcnvNLgNIFbQ4Yz/YbxduDaRXblcB3Y3M7+7q/u6L
         g/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779953234; x=1780558034;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIJSHjPmbE5160eqXjRAxLmfKnGWp0tUz5Qubw7oeD0=;
        b=gjDX0PJUog3nvMPVnC5t9CbTT3q6ltv8zQ3y5XOa+k4Yh/N42eWosikPu4LzOSlRv0
         BX+sfaaoMLvW1ngNzphl3yN94y1yEQfSuJnGrEpZjCs1O0cJKUiCLXCPrzv76w9SN+72
         sN7EscuyTbCMATNW8iaJ1ucLF8Mtam16CRMEYw7mJSRPmlorNxL4LoiOffyrIUbeG/nO
         CZYuYZlq4ZKPQ0/gcOW2SwlIokfp3lc7/jADBfgVlJV6QKfAGb4sZDhnXuFWvkN17yKL
         MuSMkluFOPOwyY3qnoRTDSagVZNMi9kzPIUtjWSPl9xOeXkXrVfWS79IuTJ/rafYbcWa
         2YAA==
X-Forwarded-Encrypted: i=1; AFNElJ+xTQ8Xd7RUarxHUOHtieoAtO0RsSmQwQnUQ8EYIY1G0AXfnYBiJeS9S0HsQrK78Cu2R45GYqGS046e@vger.kernel.org
X-Gm-Message-State: AOJu0YzBVrTM32FNwJDoPi13mdJCIdUzAK5btyYY7FOfBziOXR0gg5xF
	7xGnnbBKW0BHUGLEWq7a8JYTPhGL6IMWxD8LdPpzsees3tbbbkD3u27yyF8CMC0ep7kjqSs2oRL
	8qWtud42tKdG7d77jfY7ikrV90/6X1aaS6hNsTpfnDpyXuYKRDvaqQqrHeTvw19lg
X-Gm-Gg: Acq92OFyFIB1sNO1/DyQUmnwNVo0j2lbN7hfMU4Z4SKXkmOWm5ljH18tCeD7s2lKU4g
	XBBH+uA564n08+uF32T1vkIXH9/o0r0SK+TDBGU/nNDMYAbb59lTQaVvtnb/zztZBAt19Fs5xNM
	f6Mgc0PLMvxlgFpsPz6puXMLhuAiLn5wIBDHIickrRVoQxXeu12h8msk0tKgeneWfikNv5FyoSI
	RBEzuN6nFssZlAj0dwgw6eU32xFBMGFtud4em811LPiIuAxtR3iewsNTzWfo1lzcbfuqW04CRv5
	a4pcSpuvSM1+eWx1zrufzqC6qVALKWun4en1MXEKZOWgDKp/MGuxI4TuFPlkWWgIu9zQLV2TJ76
	NFZ4F+2OTUR1YigBvpp2DmIzopWwAIY4IVRaHbD2DZOBZYTw2pi+lLk7gHoXy75fyus1hlHRXAf
	lhRK9UpEXqkNMdPk9jdJdWfg==
X-Received: by 2002:a17:903:1a70:b0:2b9:ec37:2977 with SMTP id d9443c01a7336-2beb06bf9d7mr284835825ad.38.1779953233979;
        Thu, 28 May 2026 00:27:13 -0700 (PDT)
X-Received: by 2002:a17:903:1a70:b0:2b9:ec37:2977 with SMTP id d9443c01a7336-2beb06bf9d7mr284835545ad.38.1779953233445;
        Thu, 28 May 2026 00:27:13 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b2cd6sm178086085ad.52.2026.05.28.00.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 00:27:12 -0700 (PDT)
Message-ID: <c8f16920-95e7-4aeb-a08d-cb4cb8a32483@oss.qualcomm.com>
Date: Thu, 28 May 2026 15:27:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
 <20260527144055.2758170-3-can.guo@oss.qualcomm.com>
 <z23icwga6qa4edt3amjx6jfl7uxmqqb7ipibxrqtpewguulfid@z4d7nj47mcu7>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <z23icwga6qa4edt3amjx6jfl7uxmqqb7ipibxrqtpewguulfid@z4d7nj47mcu7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=VOntWdPX c=1 sm=1 tr=0 ts=6a17ee53 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=YQh3IHUOoYMcq4u-F6gA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: KKKGuN_OWHZxJv50K1VBVfjJodIwkmQG
X-Proofpoint-ORIG-GUID: KKKGuN_OWHZxJv50K1VBVfjJodIwkmQG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA3MyBTYWx0ZWRfX86r9ZynhwJTR
 gwuaXeSQGlniarP8FXPa21RCh6DJocVmCMrRN6CbJL5QB+3NkAEc8HRMOSbBii0kN+KA94Yf3M9
 +z3HwJf6yNOuE6Sdea2ZdJ8R1mJycEcLdf19Bwl5Bgrif3CJzTEYEEQK3gzDyG7Q8ta0yqbR1oR
 vNIXtqMZzG7bGwjq20xFiQXfNyKcPw8HQw2LOS35q0x0vu3j294t/aIGH8E0Jmbf0WCcYuIgrea
 Dk9YDUQyoT2z5yf6IASd3QmU44pfSd0Fuyg+KgFPqL18WcwDmTPahY3jTq3nUp7v+MsXiwsZeWJ
 Em7Z6nlJXYbj0kt0djQP3Xzqdr8HshP8nZGFRw1nfVfPa3r5ROuWIbJru19vv90ASIcmFveH79m
 wGcCHxpqb2m8qYA9rP89CC7xk53fFPyilwTWKUzL/QKadg8ZTfQUmconz8BSbY7lPNoilcjAKaj
 rdP0qYVkWeZ5iGmt4uA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280073


On 5/28/2026 2:18 PM, Manivannan Sadhasivam wrote:
> On Wed, May 27, 2026 at 07:40:55AM -0700, Can Guo wrote:
>> Static TX Equalization settings and TX Precode enable indication from DT
>> properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
>> tx-precode-enable-g6 are board-specific baseline values. Values are
>> provided as per-lane tuples:
>>
>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>
>> Parse DT u32 properties with explicit range checks by using
>> of_property_count_u32_elems()/of_property_read_u32_array().
>>
>> When adaptive TX Equalization is used, these static settings are not final:
>>
>> - If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
>>    those retrieved settings override static DT settings.
>> - If retrieval is not available/valid, TX EQTR runs and trained settings
>>    override static DT settings.
>>
>> So static DT settings are a fallback and are intended for cases where
>> adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
>> remains the primary path when enabled.
>>
>> No behavior changes for platforms that do not provide these properties.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufs-txeq.c      |   4 +-
>>   drivers/ufs/host/ufshcd-pltfrm.c | 128 +++++++++++++++++++++++++++++++
>>   include/ufs/ufshcd.h             |   2 +
>>   3 files changed, 133 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>> index 4b264adfdf49..634ec039e129 100644
>> --- a/drivers/ufs/core/ufs-txeq.c
>> +++ b/drivers/ufs/core/ufs-txeq.c
>> @@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>   	}
>>   
>>   	params = &hba->tx_eq_params[gear - 1];
>> -	if (!params->is_valid || force_tx_eqtr) {
>> +	if (!params->is_valid || params->is_static || force_tx_eqtr) {
>>   		int ret;
>>   
>>   		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
>> @@ -1310,6 +1310,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>   		/* Mark TX Equalization settings as valid */
>>   		params->is_valid = true;
>>   		params->is_trained = true;
>> +		params->is_static = false;
>>   		params->is_applied = false;
>>   	}
>>   
>> @@ -1495,6 +1496,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
>>   	}
>>   
>>   	params->is_valid = true;
>> +	params->is_static = false;
>>   }
>>   
>>   void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
>> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
>> index c2dafb583cf5..2db2103a6ac0 100644
>> --- a/drivers/ufs/host/ufshcd-pltfrm.c
>> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
>> @@ -210,6 +210,132 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
>>   	}
>>   }
>>   
>> +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
>> +{
>> +	size_t sz = hba->lanes_per_direction * 2;
>> +	u32 lpd = hba->lanes_per_direction;
>> +	struct ufshcd_tx_eq_params *params;
>> +	u32 deemphasis[UFS_MAX_LANES * 2];
>> +	u32 precode_en[UFS_MAX_LANES * 2];
>> +	u32 preshoot[UFS_MAX_LANES * 2];
>> +	struct device *dev = hba->dev;
>> +	char prop_name[MAX_PROP_SIZE];
>> +	int i, err, count, gear, lane;
>> +
>> +	if (!lpd || lpd > UFS_MAX_LANES) {
>> +		dev_err(dev, "Invalid lanes-per-direction value (%u) provided\n", lpd);
>> +		return;
>> +	}
>> +
> 'lanes_per_direction' can be 0 for platforms that do not support deriving the
> lanes count from DT:
>
> https://lore.kernel.org/linux-scsi/20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6/
>
> You should just drop the err message to avoid spamming those platforms.
Good catch! Will do in next version.

Thanks,
Can Guo.
>
> - Mani
>
>> +	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
>> +		snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
>> +		count = of_property_count_u32_elems(dev->of_node, prop_name);
>> +		if (count <= 0)
>> +			continue;
>> +
>> +		if (count != sz) {
>> +			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
>> +				prop_name, count, sz);
>> +			continue;
>> +		}
>> +
>> +		err = of_property_read_u32_array(dev->of_node, prop_name, preshoot, sz);
>> +		if (err) {
>> +			dev_err(dev, "Failed to read %s property, %d\n",
>> +				prop_name, err);
>> +			continue;
>> +		}
>> +
>> +		for (i = 0; i < count; i++) {
>> +			if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
>> +				dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
>> +					preshoot[i], prop_name);
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (i != count)
>> +			continue;
>> +
>> +		snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
>> +		count = of_property_count_u32_elems(dev->of_node, prop_name);
>> +		if (count <= 0) {
>> +			dev_err(dev, "Missing required %s property\n", prop_name);
>> +			continue;
>> +		}
>> +
>> +		if (count != sz) {
>> +			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
>> +				prop_name, count, sz);
>> +			continue;
>> +		}
>> +
>> +		err = of_property_read_u32_array(dev->of_node, prop_name, deemphasis, sz);
>> +		if (err) {
>> +			dev_err(dev, "Failed to read %s property, %d\n",
>> +				prop_name, err);
>> +			continue;
>> +		}
>> +
>> +		for (i = 0; i < count; i++) {
>> +			if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
>> +				dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
>> +					deemphasis[i], prop_name);
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (i != count)
>> +			continue;
>> +
>> +		memset(precode_en, 0, sizeof(precode_en));
>> +		if (gear == UFS_HS_G6) {
>> +			snprintf(prop_name, MAX_PROP_SIZE, "tx-precode-enable-g%d", gear);
>> +			count = of_property_count_u32_elems(dev->of_node, prop_name);
>> +			if (count > 0) {
>> +				if (count != sz) {
>> +					dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
>> +						prop_name, count, sz);
>> +					continue;
>> +				}
>> +
>> +				err = of_property_read_u32_array(dev->of_node, prop_name,
>> +								 precode_en, sz);
>> +				if (err) {
>> +					dev_err(dev, "Failed to read %s property, %d\n",
>> +						prop_name, err);
>> +					continue;
>> +				}
>> +
>> +				for (i = 0; i < count; i++) {
>> +					if (precode_en[i] > 1) {
>> +						dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
>> +							precode_en[i], prop_name);
>> +						break;
>> +					}
>> +				}
>> +
>> +				if (i != count)
>> +					continue;
>> +			}
>> +		}
>> +
>> +		params = &hba->tx_eq_params[gear - 1];
>> +		for (lane = 0; lane < lpd; lane++) {
>> +			params->host[lane].preshoot = preshoot[lane * 2];
>> +			params->host[lane].deemphasis = deemphasis[lane * 2];
>> +			params->host[lane].precode_en = precode_en[lane * 2];
>> +
>> +			params->device[lane].preshoot = preshoot[lane * 2 + 1];
>> +			params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
>> +			params->device[lane].precode_en = precode_en[lane * 2 + 1];
>> +		}
>> +
>> +		params->is_valid = true;
>> +		params->is_static = true;
>> +	}
>> +}
>> +
>>   /**
>>    * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
>>    * @hba: per adapter instance
>> @@ -528,6 +654,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>>   
>>   	ufshcd_init_lanes_per_dir(hba);
>>   
>> +	ufshcd_parse_static_tx_eq_settings(hba);
>> +
>>   	err = ufshcd_parse_operating_points(hba);
>>   	if (err) {
>>   		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index f48d6416e299..c01824576472 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -359,6 +359,7 @@ struct ufshcd_tx_eqtr_record {
>>    * @is_valid: True if parameter contains valid TX Equalization settings
>>    * @is_applied: True if settings have been applied to UniPro of both sides
>>    * @is_trained: True if parameters obtained from TX EQTR procedure
>> + * @is_static: True if settings are static
>>    */
>>   struct ufshcd_tx_eq_params {
>>   	struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
>> @@ -367,6 +368,7 @@ struct ufshcd_tx_eq_params {
>>   	bool is_valid;
>>   	bool is_applied;
>>   	bool is_trained;
>> +	bool is_static;
>>   };
>>   
>>   /**
>> -- 
>> 2.34.1

