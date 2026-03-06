Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D2330EF9A
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772804507; cv=none; b=H9v96T09B/lh1TDNxTjBU7V7d6qKpeQ57TT/ngKx43pfDs3k6l59yRXwE/uUJkoJfvlqSRuz6ST/FvbBVvZLD7Wnoi7a0KJ69Q5ycFizWGJNznjlu5R6Id0E1D3IMVRmXU4ETUgLIOrwoqHsKBicEMlxhhg89VOb2S7eotqLrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772804507; c=relaxed/simple;
	bh=GggzNaiW7iM2Ao7ECDXQbp/Mpe9x/2gcb82l1DPPWL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jk7A+7xVhbIWbapVUE+xCqKlvhOEIy8pZWSy+h4sUeJ7OzDPP3fo2km9G5F1FBxdIKxEWielKGHpsSNWeGRbSKJfyqJaZmOp9ciFAyTm8tUlNGgnFscXLXT0scYha6XF8+CmT6AwFtKjQsWOcon9qNThh8XXgZve9z+SnOpI0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e8Tao04s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aJm+xU1m; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e8Tao04s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aJm+xU1m"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626BahYk1451394
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 13:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GUkyRAUAgGTHMW7VwQaFnB6wTWyKA5z+MqCAPBAVXAI=; b=e8Tao04su1n6AGJJ
	NDav88NoTdOhmxMPqNLoekfjLJWZ5NY2saSItVKl71X7CA+m7i0tAHYtga3ioeZe
	mHFHDZ0Xmev9sbTItR0G4Mw2bQxT7lapFg13afEHRtdthk3RxUzUgQnBXrA6+ltN
	TQJJBQaT6BQCsU6pGnTJzzIfTjS/k+31w2xbsVRvrybfzt3zfN8nNh84kpoSpAux
	4AAOikojn6gRmUXk8tO1LeivnsYldkzpRlC0NbtNQXdv4TWk+V5zkoVrdD9bu9wH
	4Fs0AyGIxvlGCWuGFLkdeog+YDHqjWuecQQJck9h9kvKs70zK4MZOHLYTf+TVwHe
	aDD1SQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqv9agrnh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 13:41:43 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c737882b2easo1698980a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 05:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772804503; x=1773409303; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GUkyRAUAgGTHMW7VwQaFnB6wTWyKA5z+MqCAPBAVXAI=;
        b=aJm+xU1mPaOqflosvLm5BIZkPL/x5GQqD97vtz/X2qJhI/CrzGQSF+7i1qqxRjV3F0
         ECrBC+PPEZs1bmNybSzjoQEsRuxOC6vAaglKFcbIpNGAVZu9xpU5CAxXvdevA/w27caJ
         LdUVCoBzI2OHVaK/B6h0EgnYGEOxMzOps7lnVypIt3QrgFUIwjb07tCGrqAnSWs7XYzu
         LVbORetBKpREAztumvXWDxtaQ1ldm2vqjGBhbL47WDM2ZV+qJgSgbZQ9FqMHd4L4fBoD
         Rw6kAaiohwxS+yohLT5PFlcGCUUJQ0QacV3XfU6Zsn/sa88pverFfiE41EIyRpBASxrr
         TnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772804503; x=1773409303;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUkyRAUAgGTHMW7VwQaFnB6wTWyKA5z+MqCAPBAVXAI=;
        b=Z62JlrylAT7yEzSMvGp4nEkziNollzUC52+Cm/HFWnuahBICn3kFNIJBYQUeIcrZNp
         lOdAfryZyUf7Hs83kxXzndTOlTx+JHGW0tFb+VcGshtkqkFmfnvhQAx/84R6S/A2bzp3
         lB1kZn7qUzJqSxdktPgtDJ2AjlmDvFs6Z/YHaRF63ZSrKcybpuv6VLg3eA60G6cPGyZj
         YHXrkt3pYUzbL8LTIT29T97CrNeN5bw9k6OYIxjH3TCU/8Cwk6s+I2stSLCRh305bQtN
         dhTE9E8Fz5PHooVHqCthV98agIp0C57QRqltUNvviV81B4fIZzvLLw/52PZUeesOjfxg
         /6bw==
X-Forwarded-Encrypted: i=1; AJvYcCXqcJaIMqVYomPNb8sy7vKoQ/HWLX3uWu48hHEauVto5zpN7/fsH2LUGPnPtEblkUU35VwS1LawUGA6@vger.kernel.org
X-Gm-Message-State: AOJu0YzklXYiHuMATvxne0xuJMUgVdwJVa+k1iaMNWMfnP6fEkcqZHmA
	6f1/Xz8KRkogQCc0gvvzi3eyuQ8o+VT9yIhzsLJv3PUJ0RQFCERdGpZVvDd75K62n6Km0EGwePw
	IoaL3cuGTO0Ed8zDBuaK1i2DKxJ9DQQXX4FZURrP0/y7RF/ZK8sQba+9LkhLMzags
X-Gm-Gg: ATEYQzyiSC3DhYASqXYDZz5qCAejf2M0cr/OK/yU5cuFzTU9kK8PxHgfN8vk9CuuVik
	oubc2w7wfik9Uhk9w5pw9O7eYYJbgtR0dxdxTNIXu/vRmkhlQQQ5KmJsNsdx1K6rcuRYeCAaO7M
	Iib91AkFNmpPelELg7yFQsRLBL+jVNU1hktmOifgMP6yMPbPYdLyZR4WtBq8A3GYpyV4V1wYSHF
	/l7abE8vXOLn5gp4EwZizRscgAuUpa4zPQc7NzXvE73voVymyPk/lzaP8bhmCQqut3JvFN+kwIB
	EhSVFBm9cIXvo4zIHo4mJdSoQWXkYrAZvkI1KwyHviueUK2mNqKi2hot8BIYhJmkXHiLxDNZcQ3
	Qrkbd8iTXcYuUsy2HxJ4MasCc0F6LKbggR0zxYlw5JF1MvVhPEp/LJlkWp7F6bnGc8B+1hukhmE
	q/BW968K9v9GY=
X-Received: by 2002:a05:6a00:1f10:b0:81f:ac78:ed22 with SMTP id d2e1a72fcca58-829a2f4a0e5mr1988563b3a.37.1772804502736;
        Fri, 06 Mar 2026 05:41:42 -0800 (PST)
X-Received: by 2002:a05:6a00:1f10:b0:81f:ac78:ed22 with SMTP id d2e1a72fcca58-829a2f4a0e5mr1988534b3a.37.1772804502156;
        Fri, 06 Mar 2026 05:41:42 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48d3ccfsm1983502b3a.59.2026.03.06.05.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 05:41:41 -0800 (PST)
Message-ID: <64e7d659-12ee-443b-a45c-ca985951dec8@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 21:41:37 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] scsi: ufs: ufs-qcom: Implement vops
 tx_eqtr_notify()
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-9-can.guo@oss.qualcomm.com>
 <fpcbidjthsvsxszyqhd6qwydjilquq76pkexjcqiis5wzdplzx@6ap7gopmudqu>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <fpcbidjthsvsxszyqhd6qwydjilquq76pkexjcqiis5wzdplzx@6ap7gopmudqu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: sFA6QJU9WCGPsfiKptuVDFze7nALs3jU
X-Proofpoint-ORIG-GUID: sFA6QJU9WCGPsfiKptuVDFze7nALs3jU
X-Authority-Analysis: v=2.4 cv=G4wR0tk5 c=1 sm=1 tr=0 ts=69aad998 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=LtwGVnD4aPPzF9yLLxgA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEzMSBTYWx0ZWRfX1HyNZDBdj0yZ
 uMZKZk9VDTcnANVfEjSv9koXusIP3WF8GcyLLQZ7Geiu/4qm/pMKLoHGwrNO/R3FP1qwFvUaDm/
 TczPlcWGJMLeX0UHRNJxgELU8VTcD+S5dkuz55q14B8i+2ceyU3spEbnKbz95c5yUUnIe4Nwhjv
 /aK2FwtUgjXhZRdT3biA3lWoZG/Hu5tGotofYYyCvvFjzI2T8AQ+HQJ67muujCcN050WtAEWdNj
 42GtGMAu5baiGEgUjTvCEz+YN47P7z6yjxIsKEzaPTUww0HlI0XcrcR0d4Q4JUgzrDur9XsJFzc
 B3zqWfeBLGPrcza0j6tNUj0RhVpBmaz4XM2Wgctfh7AoHGtIsVr/UQV+GNFLX2oOljQ/vJdXvfU
 NWeiM6v8zexZbgEKSfKTPZt0jOAqvV1zptMOm24iTUxWTGtvqlzv9X/NcFDzY/R6cYmbzp6IiN0
 pqKE/cxBsMXkqaFaTyg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060131



On 3/4/2026 11:20 PM, Manivannan Sadhasivam wrote:
> On Wed, Mar 04, 2026 at 05:53:10AM -0800, Can Guo wrote:
>> On some platforms, HW does not support triggering TX EQTR from the most
>> reliable High-Speed (HS) Gear (HS Gear1), but only allows to trigger TX
>> EQTR for the target HS Gear from the same HS Gear. To work around the HW
>> limitation, implement vops tx_eqtr_notify() to change Power Mode to the
>> target TX EQTR HS Gear prior to TX EQTR procedure and change Power Mode
>> back to HS Gear1 (the most reliable gear) post TX EQTR procedure.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 63 +++++++++++++++++++++++++++++++++++++
>>   1 file changed, 63 insertions(+)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 3a9279066192..1e074058f23d 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -2512,6 +2512,68 @@ static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
>>   	return min_t(u32, gear, hba->max_pwr_info.info.gear_rx);
>>   }
>>   
>> +static int ufs_qcom_change_power_mode(struct ufs_hba *hba,
>> +				      struct ufs_pa_layer_attr *pwr_mode,
>> +				      enum ufshcd_pmc_policy pmc_policy)
>> +{
>> +	int ret;
>> +
>> +	ret = ufs_qcom_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
>> +	if (ret) {
>> +		dev_err(hba->dev, "Power change notify (PRE_CHANGE) failed: %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = ufshcd_change_power_mode(hba, pwr_mode, pmc_policy);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ufs_qcom_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
>> +
>> +	return ret;
> return 0;
This function should not exist, I will remove this function in next 
version.
>
>> +}
>> +
>> +static int ufs_qcom_tx_eqtr_notify(struct ufs_hba *hba,
>> +				   enum ufs_notify_change_status status,
>> +				   struct ufs_pa_layer_attr *pwr_mode)
>> +{
>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>> +	struct ufs_pa_layer_attr pwr_mode_hs_g1 = {
>> +		.gear_rx = UFS_HS_G1,
>> +		.gear_tx = UFS_HS_G1,
>> +		.lane_rx = pwr_mode->lane_rx,
>> +		.lane_tx = pwr_mode->lane_tx,
>> +		.pwr_rx = FAST_MODE,
>> +		.pwr_tx = FAST_MODE,
>> +		.hs_rate = pwr_mode->hs_rate,
>> +	};
>> +	u32 gear = pwr_mode->gear_tx;
>> +	u32 rate = pwr_mode->hs_rate;
>> +	int ret;
>> +
>> +	if (host->hw_ver.major != 0x7 || host->hw_ver.minor > 0x1)
>> +		return 0;
>> +
>> +	if (status == PRE_CHANGE) {
>> +		/* PMC to target HS Gear. */
>> +		ret = ufs_qcom_change_power_mode(hba, pwr_mode,
>> +						 UFSHCD_PMC_POLICY_DONT_FORCE);
>> +		if (ret)
>> +			dev_err(hba->dev, "%s: Failed to change power mode to target HS-G%u, Rate-%s: %d\n",
> Same comment as other patch. Goes over 100 column.
Will fix in next version.
>
>> +				__func__, gear, UFS_HS_RATE_STRING(rate), ret);
> Can we please not specify the function name in error log?
There are too many Power Mode changes in Qualcomm's TX EQTR procedure, I 
want to print
some hints to help pinpoint issues easier...

Thanks,
Can Guo.
>
> - Mani
>

