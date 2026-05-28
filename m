Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F8379C51
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 08:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779957668; cv=none; b=YHN90p33bQNQdSmZG79CCoMGWc6Qd2PCwPPtQLm9xWSfCM+sN0Qk2kcYze22VFtz22S3HkK1T+rCxBijIWfC5fUTRhuPDNfHNorsXZlTMVVHMMtyJbBRm6Jd4xrfkZXrDH5vHFsI8PwGgJCnhJecq4GMW+lO+s8FAJoL97ADN0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779957668; c=relaxed/simple;
	bh=yOdeBiRTRbxTsFz2vy4M1LjC+LxmTda9ET1VQT78ITQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HR7oEBmyF5HoQn5Wov0dld4aKCbOl1BSwHnieU2a1usWw7F0Y9V71JANYpke/CaK4onY7yADTa/MQWGHUor/Wsxa89sOuVGc3yeN11yPszVANmiGywwsUCvbFbCyDwjJMigVGq8OCVocg/Ol3oISbfYhQ66I9zxwi7r7ZWWarNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n0vNo9Qw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UQVLtv9V; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n0vNo9Qw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UQVLtv9V"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S73QJD125455
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 08:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0ir8R8Z/AozA5z1osME2QAEHkBduKOUZz705xr/MzPg=; b=n0vNo9Qwzui822Bh
	jCZnADR7zkmkLHk+XZ7twC29cpLOcUzZkKO3B1omQkP2DWoHgeyOHWCfpaawRQNV
	Od1K5u+7mkYbpQpeYUT/8jP1hqnt9QEjQTwTT8B5inzjOWy3LslYU+tP34gVhr+W
	WVGLOGRrkJcWNBxxzx0jSZjjlyGzBEmDLEA36urLrhEeu2pAayN/uWN3Swmk9Y0c
	YMuFDTv7RoS9gCyDmEenlrqPQhEpLF7lh55Trnak7EHgIGCINtTmgKcxm1VHSa3S
	kCyzth4cX8o/RJIyUvb7vbTWj6SXS8xGiZm+ujbEGXzfNq40ApsgbifroG9Vs0V5
	3k4BDA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7yaj1qq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 08:41:05 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c828f0f5c23so6326746a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 01:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779957665; x=1780562465; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ir8R8Z/AozA5z1osME2QAEHkBduKOUZz705xr/MzPg=;
        b=UQVLtv9VQ5Kj4ZwN6fUc+oKYk53fKPi9dS/nE/H18DBPVzhnIRUGUeBztbCB0HqxU2
         WQRcro3V+6r2m6UGGnIrc1n/qpfy12O5fU4GCNr3kuOzihYLjP8bBQ76zQ1b6eQf/asA
         8SbWAb+LdliUX4P2fAxZGuKuNh5Twhp1WGl0ULdjoiQSHdACMzZp/H0XlUAOAGcdtB7S
         b4VRml7taRTPrC8nnFf/qxKDTI/bHuRUUGW4yuuva0HdXElGzbcTjvplIyFNFfFovdns
         dO9qSFQ3Md6WGZfuj5G06TvjqskFYWv4F2JsDgCnRCgfgy4afso/2BwSCjVEdkIoQYIX
         ah0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779957665; x=1780562465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ir8R8Z/AozA5z1osME2QAEHkBduKOUZz705xr/MzPg=;
        b=F3gjeKnXJsLdHiae2gzIYHhEXEOCnaJUUBG+sgfDjcXwIuAbPkr/tBgSWSr4CS++7Y
         hpmcmFtIMF7GtommVWeYMiVlY9lWUZEx/v2GZ8oTToQY4+vMY2p5ze0ZO9+KJqW8FzW/
         /QtjrWdvUNAOKNM/PJqRFgLw1BnJn30DmLL9aT9/KxzaMYX8Pe6hjPl1PcZrIT0EROJR
         QJO3zNByK3CYc3GiuxjDrSj+bz6mEZU5a/pPILowlYla6DdFO3OnDM1bJa4YhIKWzUuy
         nNJ7ot/1O7mqw8hBb26ONnVNtqgwDcJq+km35Yu/kOvEfKlUQ4sM/nNXqilqFwAQbu1S
         z/2Q==
X-Forwarded-Encrypted: i=1; AFNElJ+z9ZLWKRvM+RrE8IqhQT+GDfLSRofrMXWnSA/jzw6xEyM4iTGVQRb4o89rGXk3IeQNcSexyq5QOx6K@vger.kernel.org
X-Gm-Message-State: AOJu0YxEW884RfODtFTgpSM34AuvAzPI9R6Nh4pZGa0Q8sCapyl4ozoc
	ZEYkhUA3BzAK5X+Y5WF4PxD8ZcV+kEHUVEPloxMgh0uTohdeC7BfQj8kWbPUrx5lB0jSVO35n19
	uPAcUzcZLIDNvYgKzqGMXI9F17IH24UTTuwMeFgac4vr+9k1n1c7jtgJI6EijTm5+5cvem75k
X-Gm-Gg: Acq92OGz6NR7xNcKGVNZLkVBi+JDwKsfQ441/gx2X0W8O3Dz4/+Ye5CsBmeG6DIK1SV
	58CPgtCAClon24wR3uGYYw2vf0HDp7vS7sgDMObYJetKHs9F6RsR46NQ+Z+Xl2R6O65+cP+aZ6E
	hj+8GpO664QLbBESXHr4OzcsCaUSjdFd8QvD3lxkTsPhh1vD4/FScqsX1F7yONZ7ZE7IdYUXYjB
	LEQt5Ux3r+4bl5FhzM8gNpcd2f3zLUGSLjLg0/JJ+xsXPGOAeWR6CwNo6uRzcUhI2v0W7zW6Gk0
	k0xtOFJi+FzxacKXbMwgWkm1H0u7CJa1D3AD1/Lly3l3FW8MLdThVhEZjKJaDy+Klpdr9imgOFO
	Ych2TC8NbZJBHMHFnPVUJCkYrXlu4e9kaT3ux76Zv/xLh0WETLLm77/vtKZhpc4W19M/X6uUg0T
	v3+BjFr4ARyFFlCZIMUvraGw==
X-Received: by 2002:a05:6a00:180a:b0:835:405a:7e72 with SMTP id d2e1a72fcca58-8415f141d5fmr24673868b3a.11.1779957665091;
        Thu, 28 May 2026 01:41:05 -0700 (PDT)
X-Received: by 2002:a05:6a00:180a:b0:835:405a:7e72 with SMTP id d2e1a72fcca58-8415f141d5fmr24673842b3a.11.1779957664542;
        Thu, 28 May 2026 01:41:04 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6e82bc6sm4207202b3a.8.2026.05.28.01.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 01:41:04 -0700 (PDT)
Message-ID: <330662df-b2e3-45df-a801-4e84573fa6ec@oss.qualcomm.com>
Date: Thu, 28 May 2026 16:40:59 +0800
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
 <mt2asdx4vnuxo3eodrc7dlfdtv3b5bpjfvxxglmncny36otfav@htri3l5q4ba3>
 <d57a0e9b-74f6-4472-842f-6479c7449cd8@oss.qualcomm.com>
 <35rqdgvdtf2jjjjdfajhhansmzzem2gllbw5olcopdmcdfdd3k@rqwlcht5uzsw>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <35rqdgvdtf2jjjjdfajhhansmzzem2gllbw5olcopdmcdfdd3k@rqwlcht5uzsw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ds1HozrKYrhhVkZv5gJz3Dd4MUZGlewB
X-Proofpoint-GUID: ds1HozrKYrhhVkZv5gJz3Dd4MUZGlewB
X-Authority-Analysis: v=2.4 cv=E/r9Y6dl c=1 sm=1 tr=0 ts=6a17ffa1 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=qO2SoHkUHa4WZMVLpLAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA4NiBTYWx0ZWRfX+MAT5J/Jgtml
 pfYNtsa8JkTDpohVgodjCjxsO3Vk7wCfS/zc+ickJtRSN+FiKgcB8Gol3paysr8akOexzpDuxzp
 Zhs20Eu4/KfYFUeFdmWdKMoBL0s/vdnIk9e9QgBN4MStafLVhgf1dStWOJINZuR40CVYnhOGjJW
 xsn9J0LPfmP/3V4C8aP755V7RR4DCJQYtbGXAJv00k+uO41V7xU/3UVRoixiXJHiFjhpmM3Ep/t
 fnFKJVNpZCnkBqE63Mj5Gkr+mMSoBXI5bWW/AsMf1LN2ZChCnw/J5RIo3WQZcYr/vacF0vce4xP
 n4DvCkm+ZTTAu+CYTzXgM4HDnkeCv/uhyEu3/FAiVxfiTVDxfbW+MJA0SoImw3F+eyoft6WXT+7
 i64oN/kErp2S1GuM69cV8q2thbCP0tHa4zagNFs/v3dmEp/fOaOMs/ybMFPd5FAJjjIRsIxH8Jq
 Qp8s+/ZSDvCxxUegXkg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280086



On 5/28/2026 4:16 PM, Manivannan Sadhasivam wrote:
> On Thu, May 28, 2026 at 03:24:37PM +0800, Can Guo wrote:
>>
>> On 5/28/2026 2:13 PM, Manivannan Sadhasivam wrote:
>>> On Wed, May 27, 2026 at 07:40:55AM -0700, Can Guo wrote:
>>>> Static TX Equalization settings and TX Precode enable indication from DT
>>>> properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
>>>> tx-precode-enable-g6 are board-specific baseline values. Values are
>>>> provided as per-lane tuples:
>>>>
>>>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>>>
>>>> Parse DT u32 properties with explicit range checks by using
>>>> of_property_count_u32_elems()/of_property_read_u32_array().
>>>>
>>>> When adaptive TX Equalization is used, these static settings are not final:
>>>>
>>>> - If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
>>>>     those retrieved settings override static DT settings.
>>>> - If retrieval is not available/valid, TX EQTR runs and trained settings
>>>>     override static DT settings.
>>>>
>>>> So static DT settings are a fallback and are intended for cases where
>>>> adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
>>>> remains the primary path when enabled.
>>>>
>>>> No behavior changes for platforms that do not provide these properties.
>>>>
>>>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>>>> ---
>>>>    drivers/ufs/core/ufs-txeq.c      |   4 +-
>>>>    drivers/ufs/host/ufshcd-pltfrm.c | 128 +++++++++++++++++++++++++++++++
>>>>    include/ufs/ufshcd.h             |   2 +
>>>>    3 files changed, 133 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>>>> index 4b264adfdf49..634ec039e129 100644
>>>> --- a/drivers/ufs/core/ufs-txeq.c
>>>> +++ b/drivers/ufs/core/ufs-txeq.c
>>>> @@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>>>    	}
>>>>    	params = &hba->tx_eq_params[gear - 1];
>>>> -	if (!params->is_valid || force_tx_eqtr) {
>>>> +	if (!params->is_valid || params->is_static || force_tx_eqtr) {
>>>>    		int ret;
>>>>    		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
>>>> @@ -1310,6 +1310,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>>>    		/* Mark TX Equalization settings as valid */
>>>>    		params->is_valid = true;
>>>>    		params->is_trained = true;
>>>> +		params->is_static = false;
>>>>    		params->is_applied = false;
>>>>    	}
>>>> @@ -1495,6 +1496,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
>>>>    	}
>>>>    	params->is_valid = true;
>>>> +	params->is_static = false;
>>> Maybe it's me, but I'm not able to understand how you want to apply these static
>>> EQ settings. In commit message you said, the static values should be used as a
>>> fallback, but you just check for 'params->is_static' while triggering
>>> ufshcd_tx_eqtr() which is supposed to perform adaptive TX EQ training. IMO, you
>>> don't need any check at all for applying static setting. If '(!params->is_valid
>>> || force_tx_eqtr)' condition is not satisfied, then the static setting should be
>>> used.
>> Thanks for the review.
>>
>> The distinction is between two different sources that can pre-populate
>> txeq_params with
>> is_valid set to true before ufshcd_config_tx_eq_settings() is called:
>>
>> 1. DT properties — parsed by ufshcd_pltfrm_parse_tx_eq_settings(),
>>      sets is_valid = true, is_static = true.
>> 2. UFS Attributes (qTxEQGnSettings/wTxEQGnSettingsExt) — retrieved by
>>      ufshcd_retrieve_tx_eq_settings() (introduced in the 2nd series),
>>      sets is_valid = true, is_static = false.
>>
>> Since both sources set is_valid = true, the is_valid flag alone cannot tell
>> them apart.
>> The is_static flag is the discriminator:
>>
>> - is_valid && is_static -> settings came from DT; they are a board-level
>> baseline.
>>    TX EQTR should still run to find optimal settings, which will then
>> overwrite the static ones.
>> - is_valid && !is_static -> settings came from UFS Attributes; they are
>> previously trained
> You use '&&' here, but '||' in the code. When you use '||', then I see no point
> for 'is_static' check.
The code is correct. My reply was explaining why the check is there, but not
explaining the check itself.

Original check in the code is (!params->is_valid || force_tx_eqtr).

Static TX EQ settings are valid, so '!params->is_valid' is false, TX 
EQTR would be skipped.

Update the check as (!params->is_valid || params->is_static || 
force_tx_eqtr) so TX EQTR
must run when static settings are provided.

Thanks,
Can Guo.
>
> - Mani
>

