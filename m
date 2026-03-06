Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE50395DAE
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805873; cv=none; b=pgfuDYTe2Xy/jOb/tkxOpUeIfNWeuvTj9htAovaY2W8/iWRSufF989C7jUAWdlrzVSJ2NxkDN245xrChmmLiaM4rJZty8xOsfpLzTS1RZQbVSyvp7MlHGN+uV+oNIkKwDc6IelPIeLHFyWriqwansjqYNSnOsJUb/9si26f7eDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805873; c=relaxed/simple;
	bh=gzWRdhiiJk/A50wkWrD+sWFzRr6Iv58+3BeSPDw/dtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NEk6dE1kUPQ89wGT8K1/Y9GfqxM3Pm1n1J1Tun0jw4yqolE415Y0d/VT9PAlFXQJOMtuRspp5fd184MKmW8/36sBgJa1LOEoD4lIBUJ1En4j2b4hML/Zv5zowPAbapaH6vx7S80ZHOMprQlEvW1UyJxpRyCU5JA1oFe6Tqj/rpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KP1TZ6Ld; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LARKCkNk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KP1TZ6Ld";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LARKCkNk"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626BbfpB3727903
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 14:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pStvCmzej4+XrTdYZ9PsGbkCZ+yDayDX7pPj56xiM70=; b=KP1TZ6LdzYfX4dFZ
	ukVHWefA2LVRuBrxto/su72yxtT4jx+2g8w5PZOoq8WfKx6cVqTh5gUOU0ezyos5
	dY6iI+CuqfVowvW00wY/Q03jsWAG+sIyPPWcua44QCIthBZyW3EDF3x6TOGIVCxv
	bpUEg9jJOcOZFgWRqdL+sQwhV2ReslXt+FOeVljsgDAD6fc0USO/Yt9dO4bJwxId
	bsQEYFYLadXHebOfFxjPgEj+4MTlyMTVA2Jc1kGW89fVFZiW9eF87SI+5W+WT1uy
	YAULYY3yxRzJ9/qy2PwyttEonS8Us+eQY64k4NnK/MHH30vQv9B3xQQIiRqgDRb/
	NXqAkg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqgp431xw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 14:04:30 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35984ef203bso5786221a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 06:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772805869; x=1773410669; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pStvCmzej4+XrTdYZ9PsGbkCZ+yDayDX7pPj56xiM70=;
        b=LARKCkNkAboSyQGvxlaGhLu0BP69sJT3gMmoh4U8vcG9NOnhYqzWW9q6ezMuSCTMcO
         OBd0ZjpwlDEX6IwApXF+O5cegZpWqV2jQ5RVmSDyFgVclqLc7URLVlngaixhivbUYYTi
         GVlydBWMOe7rYsyavWD/TqaNmOjLs0HrdHwifIzl/m0VOuaUMHuBCwsuEOS18fvtsuhh
         +Rfuhhz4juN6UGUXT3Rd3I9gFhpQ5ce8F5OlFovTB/o8mw0HhLaEAjHP7B5masGT8sFj
         V+uxJk+M5hbtxYJgyy7Lha3cSBx7q4zxtw39f0vShTOoQ3ObACsiGMd4S7do2nqj7Wfd
         mzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805869; x=1773410669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pStvCmzej4+XrTdYZ9PsGbkCZ+yDayDX7pPj56xiM70=;
        b=AAUdTV6hEVny+MQJtfD/zRG7Ytuc3l2BbCIfD5DmN2uJ+S2JQq318xpvmenbhHwUV4
         eHLVm5NI55UXYDuPwRaQJZgNeJyfu6gnIb8gAx5iEYdB7ao1wQLdb31fYRh8xB6SVADJ
         cQO65TgHualQo4cQWGm3QwwyVe0orsD9PYIsNO3C2HWTYj3BQ0BKbp8n6/6XGTwDMq7l
         ExHcJjeE6r5/PxSAiZQ+ptPIiKYmZdlWwzcjPOH5vXqkBndKzm16H+ZNKgGnBC0bU4wu
         rOQlgMDSAw7iU/+BiVvlmW3Odl9cSaB1XQr7GDHKKvQQIEEpTLeRLnn3+cueVcRIFohi
         mtDw==
X-Forwarded-Encrypted: i=1; AJvYcCUOORbXk11yb9JpY7tT5o+bzDLWn9+t9N2DhLvV0oWl73lVdoAWQU853i8nlIaMeR+hGaK3EZl5ybA5@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd+/JoH3ep44+s1HMdiik/bVP7jt5etrpng6SaiFM/vwJFPpdn
	Rr5HmMTxL27SEFYpj3Nw8pabnfqpuCA6QKFfU3Rsm7LmO57VXvEoTuUZromXVanqADfxNEA9f0a
	IDPnqTisIn0DnpmP9dsu1iOsFKC1IeJ0ao6ls3B61sdcKzarGrgPa96kLkDcqPfBq
X-Gm-Gg: ATEYQzwpZy0FI8JQ8LyE4usA2e574ojd+YCaLwoEYdGujNd+z40i+DqWS4HGEoDDf7Y
	1WRSt27Ch+9Vy4bN0514HZa4RLOoWNAocO91PO9sHzGIdCAMqoebVDacyutLxrALYDn+VSafyL+
	TGyFCeKCkoduuUpdLSZxeuq1O4iinF62ZAaW1ZH4Rm+pPO2P134GgYa0q7qld3r8ljJ1I0kW/02
	TxcGuAIrRakFYgJ2PB3r/bmZiG7ilkTlCT1K41u7BmHFh2rbgHUqlHKiWNuOH3vRZ50JjEvBXnN
	bizg6PTBcefnOgF8Hzs0Z4ChHMLMvyXPOQbsv9xD1sCPr1kOreBlpBC4gUY12H5MTk9KGqF8Z7M
	y4EBLqjMBUFZgBnDZfPQaBBPQIbT+AluTPtB9zsqMje/b0wHxW7BPjO1rXqhiga5xPD6aKBdklQ
	aLhK2IYDis5E4=
X-Received: by 2002:a17:90b:28d0:b0:33b:b078:d6d3 with SMTP id 98e67ed59e1d1-359be314eb6mr2082034a91.23.1772805868928;
        Fri, 06 Mar 2026 06:04:28 -0800 (PST)
X-Received: by 2002:a17:90b:28d0:b0:33b:b078:d6d3 with SMTP id 98e67ed59e1d1-359be314eb6mr2081988a91.23.1772805868207;
        Fri, 06 Mar 2026 06:04:28 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0a709csm2257616a12.1.2026.03.06.06.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 06:04:27 -0800 (PST)
Message-ID: <ebf2ad3c-e75f-46d5-ae36-ad81f437ccc1@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 22:04:21 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] scsi: ufs: ufs-qcom: Implement vops get_rx_fom()
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-10-can.guo@oss.qualcomm.com>
 <ffijub727efmyhatukpqlridfdknwzbsc2dedeohx3snosxqzs@os7ddqrmziqd>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <ffijub727efmyhatukpqlridfdknwzbsc2dedeohx3snosxqzs@os7ddqrmziqd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: -Gy1ArHezyMWjrr2O5kw7zsdDAcHsuSI
X-Authority-Analysis: v=2.4 cv=LegxKzfi c=1 sm=1 tr=0 ts=69aadeee cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=0uF6H6XtDH4SaxNOm18A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEzNSBTYWx0ZWRfX49l1eZO5OSXD
 JiXLoVI9EocKOyvb+odmYzettNA522RtJBDxAQhnzs68m5rQyW+XdxgMJTgXaPOtGetNK9wB1Bl
 IEioHiUlkzHCJT+c9rnHpqmh8PQNgz1qrxtOhRyEIJ7vf3jb6lqAcQCkMK7TGZzVfzI9XwlEItJ
 RRW3tzKItD8UwH0LXYkYY4GwQTSW7y9gheriiYRW0k3ENjXPipBQx8o2JfXLhiuHcKwgQ6xXMj9
 SvtXjwTt1F8uWo932IhomquONG+mlu/CFl1zA97RcZxzruE111kTSWlJo3i1WfcxzixyaC+cUnO
 nYyX0vHqtlLbZUHQCXdFeeNGn4JyTA/IM1E9BWnH8ATd57HYGA11LmNgRp38v3BvUA0D4hNVMMu
 rLB4usu+6HLL+tF3rmXEepYX0oQReOQqWL0Nmq5DKkR3NhDMT+WdU8zgKbq6c5xjrAVXfKpPgWc
 OoblVE8BGZOs2E6ua4Q==
X-Proofpoint-GUID: -Gy1ArHezyMWjrr2O5kw7zsdDAcHsuSI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060135



On 3/4/2026 11:39 PM, Manivannan Sadhasivam wrote:
> On Wed, Mar 04, 2026 at 05:53:11AM -0800, Can Guo wrote:
>> On some platforms, host's M-PHY RX_FOM Attribute always reads 0, meaning
>> SW cannot rely on Figure of Merit (FOM) to identify the optimal TX
>> Equalization settings for device's TX Lanes. Implement the vops
>> ufs_qcom_get_rx_fom() such that SW can utilize the UFS Eye Opening Monitor
>> (EOM) to evaluate the TX Equalization settings for device's TX Lanes.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufs-txeq.c |   6 +-
>>   drivers/ufs/host/ufs-qcom.c | 315 ++++++++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufs-qcom.h |  42 +++++
>>   include/ufs/ufshcd.h        |   3 +
>>   include/ufs/unipro.h        |  16 ++
>>   5 files changed, 379 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>> index 2cd2d5156607..02c1a8479910 100644
>> --- a/drivers/ufs/core/ufs-txeq.c
>> +++ b/drivers/ufs/core/ufs-txeq.c
>> @@ -227,9 +227,8 @@ ufshcd_compose_tx_eq_setting(struct ufshcd_tx_eq_settings *settings,
>>    *
>>    * Returns 0 on success, negative error code otherwise
>>    */
>> -static int ufshcd_apply_tx_eq_settings(struct ufs_hba *hba,
>> -				       struct ufshcd_tx_eq_params *params,
>> -				       u32 gear)
>> +int ufshcd_apply_tx_eq_settings(struct ufs_hba *hba,
>> +				struct ufshcd_tx_eq_params *params, u32 gear)
>>   {
>>   	u32 setting;
>>   	int ret;
>> @@ -259,6 +258,7 @@ static int ufshcd_apply_tx_eq_settings(struct ufs_hba *hba,
>>   
>>   	return ret;
>>   }
>> +EXPORT_SYMBOL_GPL(ufshcd_apply_tx_eq_settings);
>>   
>>   /**
>>    * ufshcd_evaluate_fom - Update TX EQ params based on FOM results
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 1e074058f23d..b8fa4670ddd6 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -2534,6 +2534,320 @@ static int ufs_qcom_change_power_mode(struct ufs_hba *hba,
>>   	return ret;
>>   }
>>   
>> +static int ufs_qcom_host_eom_config(struct ufs_hba *hba, int lane, int v_step,
>> +				    int t_step, enum ufs_eom_eye_pos eye_pos,
>> +				    u32 target_test_count)
>> +{
>> +	u32 volt_step, timing_step;
>> +	int ret;
>> +
>> +	if (v_step > 127 || v_step < -127) {
>> +		dev_err(hba->dev, "Invalid EOM Voltage Step: %d\n", v_step);
>> +		return -EINVAL;
> -ERANGE
Done.
>
>> +	}
>> +
>> +	if (t_step > 63 || t_step < -63) {
>> +		dev_err(hba->dev, "Invalid EOM Timing Step: %d\n", t_step);
>> +		return -EINVAL;
> -ERANGE
Done.
>
>> +	}
>> +
>> +	if (v_step < 0)
>> +		volt_step = BIT(6) | (u32)(-v_step);
> What does BIT(6) correspond to? Create a define maybe?
Will do.
>
>> +	else
>> +		volt_step = (u32)v_step;
>> +
>> +	if (t_step < 0)
>> +		timing_step = BIT(6) | (u32)(-t_step);
>> +	else
>> +		timing_step = (u32)t_step;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_EYEMON_ENABLE,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     BIT(eye_pos) | BIT(6));
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to enable Host EOM on Lane %d: %d\n",
>> +			lane, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_EYEMON_TIMING_STEPS,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     timing_step);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to set Host EOM timing step on Lane %d: %d\n",
>> +			lane, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_EYEMON_VOLTAGE_STEPS,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     volt_step);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to set Host EOM voltage step on Lane %d: %d\n",
>> +			lane, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_EYEMON_TARGET_TEST_COUNT,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     target_test_count);
>> +	if (ret)
>> +		dev_err(hba->dev, "Failed to set Host EOM target test count on Lane %d: %d\n",
>> +			lane, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ufs_qcom_host_eom_may_stop(struct ufs_hba *hba, int lane,
>> +				      u32 target_test_count, u32 *err_count)
>> +{
>> +	u32 start, tested_count, error_count;
>> +	int ret;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_EYEMON_START,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     &start);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to get Host EOM start status on Lane %d: %d\n",
>> +			lane, ret);
>> +		return ret;
>> +	}
>> +
>> +	if (start & 0x1)
>> +		return -EAGAIN;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_EYEMON_TESTED_COUNT,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     &tested_count);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to get Host EOM tested count on Lane %d: %d\n",
>> +			lane, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_EYEMON_ERROR_COUNT,
>> +				UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +			     &error_count);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to get Host EOM error count on Lane %d: %d\n",
>> +			lane, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* EOM can stop */
>> +	if ((tested_count >= target_test_count - 3) || error_count > 0) {
>> +		*err_count = error_count;
>> +
>> +		/* Disable EOM */
>> +		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_EYEMON_ENABLE,
>> +					UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>> +				     0x0);
>> +		if (ret) {
>> +			dev_err(hba->dev, "Failed to disable Host EOM on Lane %d: %d\n",
>> +				lane, ret);
>> +			return ret;
>> +		}
>> +	} else {
>> +		return -EAGAIN;
>> +	}
>> +
>> +	return ret;
> return 0;
Done.
>> +}
>> +
>> +static int ufs_qcom_host_eom_scan(struct ufs_hba *hba, int num_lanes,
>> +				  const struct ufs_eom_coord *eom_coord,
>> +				  u32 target_test_count, u32 *err_count)
>> +{
>> +	bool eom_stopped[PA_MAXDATALANES] = { 0 };
>> +	enum ufs_eom_eye_pos eye_pos;
>> +	int lane, v_step, t_step, ret;
>> +	u32 setting;
>> +
>> +	if (!err_count || !eom_coord)
>> +		return -EINVAL;
>> +
>> +	if (target_test_count < 8) {
>> +		dev_err(hba->dev, "%s: Target test count (%u) too small for Host EOM\n",
>> +			__func__, target_test_count);
> No __func__ please.
Done.
>
>> +		return -EINVAL;
> -ERANGE
Done.
>
>> +	}
>> +
>> +	v_step = eom_coord->v_step;
>> +	t_step = eom_coord->t_step;
>> +	eye_pos = eom_coord->eye_pos;
>> +
>> +	for (lane = 0; lane < num_lanes; lane++) {
>> +		ret = ufs_qcom_host_eom_config(hba, lane, v_step, t_step,
>> +					       eye_pos, target_test_count);
>> +		if (ret) {
>> +			dev_err(hba->dev, "Failed to config Host EOM: %d\n",
>> +				ret);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Trigger a PACP_PWR_req to kick start EOM, but not to really change
>> +	 * the Power Mode.
>> +	 */
>> +	ret = ufshcd_uic_change_pwr_mode(hba, FAST_MODE << 4 | FAST_MODE);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to change power mode to kick start Host EOM: %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +
>> +more_burst:
>> +	/* Create burst on Host RX Lane. */
>> +	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_LOCALVERINFO), &setting);
>> +
>> +	for (lane = 0; lane < num_lanes; lane++) {
>> +		if (eom_stopped[lane])
>> +			continue;
>> +
>> +		ret = ufs_qcom_host_eom_may_stop(hba, lane, target_test_count,
>> +						 &err_count[lane]);
>> +		if (!ret) {
>> +			eom_stopped[lane] = true;
>> +		} else if (ret == -EAGAIN) {
>> +			/* Need more burst to excercise EOM */
>> +			goto more_burst;
>> +		} else {
>> +			dev_err(hba->dev, "Failed to stop Host EOM: %d\n", ret);
>> +			return ret;
>> +		}
>> +
>> +		dev_dbg(hba->dev, "%s: Host RX Lane %d EOM, v_step %d, t_step %d, error count %u\n",
>> +			__func__, lane, v_step, t_step, err_count[lane]);
>> +	}
>> +
>> +	return ret;
> return 0;
>
>> +}
>> +
>> +static int ufs_qcom_host_sw_rx_fom(struct ufs_hba *hba, int num_lanes, u32 *fom)
>> +{
>> +	const struct ufs_eom_coord *eom_coord = sw_rx_fom_eom_coords_g6;
>> +	u32 eom_err_count[PA_MAXDATALANES] = { 0 };
>> +	u32 curr_ahit;
>> +	int lane, i, ret;
>> +
>> +	if (!fom)
>> +		return -EINVAL;
>> +
>> +	/* Stop the auto hibernate idle timer */
>> +	curr_ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +	if (curr_ahit)
>> +		ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE), PA_NO_ADAPT);
>> +	if (ret) {
>> +		dev_err(hba->dev, "%s: Failed to select NO_ADAPT before starting Host EOM: %d\n",
>> +			__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	for (i = 0; i < SW_RX_FOM_EOM_COORDS; i++, eom_coord++) {
>> +		ret = ufs_qcom_host_eom_scan(hba, num_lanes, eom_coord, 0x3F,
>> +					     eom_err_count);
>> +		if (ret) {
>> +			dev_err(hba->dev, "%s: Failed to run Host EOM scan: %d\n",
>> +				__func__, ret);
>> +			break;
>> +		}
>> +
>> +		for (lane = 0; lane < num_lanes; lane++) {
>> +			/* Bad coordinates have no weights */
>> +			if (eom_err_count[lane])
>> +				continue;
>> +			fom[lane] += SW_RX_FOM_EOM_COORDS_WEIGHT;
>> +		}
>> +	}
>> +
>> +out:
>> +	/* Restore the auto hibernate idle timer */
>> +	if (curr_ahit)
>> +		ufshcd_writel(hba, curr_ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>> +			       struct ufs_pa_layer_attr *pwr_mode,
>> +			       struct tx_eqtr_iter *h_iter,
>> +			       struct tx_eqtr_iter *d_iter)
>> +{
>> +	struct ufshcd_tx_eq_params *params __free(kfree) =
>> +		kzalloc(sizeof(*params), GFP_KERNEL);
>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>> +	struct ufs_pa_layer_attr old_pwr_info;
>> +	u32 fom[PA_MAXDATALANES] = { 0 };
>> +	u32 gear = pwr_mode->gear_tx;
>> +	u32 rate = pwr_mode->hs_rate;
>> +	int lane, ret;
>> +
>> +	if (host->hw_ver.major != 0x7 || host->hw_ver.minor > 0x1 ||
>> +	    gear <= UFS_HS_G5 || !d_iter || !d_iter->is_new)
>> +		return 0;
>> +
>> +	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX)
>> +		return -EINVAL;
> -ERANGE
>
>> +
>> +	if (!params)
>> +		return -ENOMEM;
>> +
>> +	memcpy(&old_pwr_info, &hba->pwr_info, sizeof(struct ufs_pa_layer_attr));
>> +
>> +	memcpy(params, &hba->tx_eq_params[gear - 1], sizeof(struct ufshcd_tx_eq_params));
>> +	for (lane = 0; lane < d_iter->num_lanes; lane++) {
>> +		params->device[lane].preshoot = d_iter->preshoot;
>> +		params->device[lane].deemphasis = d_iter->deemphasis;
>> +	}
>> +
>> +	/* Use TX EQTR settings as Device's TX Equalization settings. */
>> +	ret = ufshcd_apply_tx_eq_settings(hba, params, gear);
>> +	if (ret) {
>> +		dev_err(hba->dev, "%s: Failed to apply TX EQ settings for HS-G%u: %d\n",
>> +			__func__, gear, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Force PMC to target HS Gear to use new TX Equalization settings. */
>> +	ret = ufs_qcom_change_power_mode(hba, pwr_mode, UFSHCD_PMC_POLICY_FORCE);
>> +	if (ret) {
>> +		dev_err(hba->dev, "%s: Failed to change power mode to HS-G%u, Rate-%s: %d\n",
>> +			__func__, gear, UFS_HS_RATE_STRING(rate), ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = ufs_qcom_host_sw_rx_fom(hba, d_iter->num_lanes, fom);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Failed to get Host SW FOM for Device TX Lane (PreShoot: %u, DeEmphasis: %u): %d\n",
>> +			d_iter->preshoot, d_iter->deemphasis, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Restore Device's TX Equalization settings. */
>> +	ret = ufshcd_apply_tx_eq_settings(hba, &hba->tx_eq_params[gear - 1], gear);
>> +	if (ret) {
>> +		dev_err(hba->dev, "%s: Failed to apply TX EQ settings for HS-G%u: %d\n",
>> +			__func__, gear, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Restore Power Mode. */
>> +	ret = ufs_qcom_change_power_mode(hba, &old_pwr_info, UFSHCD_PMC_POLICY_FORCE);
>> +	if (ret) {
>> +		dev_err(hba->dev, "%s: Failed to retore power mode to HS-G%u: %d\n",
>> +			__func__, old_pwr_info.gear_tx, ret);
>> +		return ret;
>> +	}
>> +
>> +	for (lane = 0; lane < d_iter->num_lanes; lane++)
>> +		d_iter->fom[lane] = fom[lane];
>> +
>> +	return ret;
> return 0;
Done.
> - Mani
>

