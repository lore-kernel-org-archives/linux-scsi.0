Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D430026B973
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 11:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795678; cv=none; b=LChSr5qeikJmHtLBN6ugz6XqDQj/k/ycAzVsgpWa2rpoqyQEBxTuwPHMBJYTtpWL+WC+Hwn9kh8FaW0o8L5S99U4EQBGqwDepmpMidn+tJ6a5cpDIoVJRsWrwzArDbqzZezAZ8h3oR+HkpURBzBbRwx43Qv9DZX2CM7K56UVWKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795678; c=relaxed/simple;
	bh=63vfcV8HzZBeQeBm+9/XeNyWSm+HWmcNtW7uzdAMD08=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=nQRkru0N0Z36iD/sCf8Qwl7QIdDujs35pOtccZCScdOQB9DSfV84JsQDAS30Rj7ssposaIsnSEhqZy2RxGSPRcp81dX3ZmYSMnur6cYWL3Drk+GmjHukQWJRpQ9eCUspiw1o2BG8lyOP4dQHZwwtBinlXRl50m23EPxUJflRUrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PHE/dTcE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bCJKth9w; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PHE/dTcE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bCJKth9w"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6269QGYq3121395
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 11:14:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ROs7foJ9C7wWq6029alq5/CQprIQotEEK0bAcQMfs6A=; b=PHE/dTcE/rhAlNPX
	FI+PMKYEx/eFcg3DZjtLutfucTOe3+vtNWzOZZasoLd8a3zQvb0zod+pm+kymH2N
	YgCXUjHyX/UuUt1Xu4Fkea8HG+M98JexkJF0rAACp1y2FG+N4Qhbzfr9ZqaSz0Bw
	rVUuEDSLOlKKGtG6FKpf9d1mYlwyCgQCAlFolfpdpRMob7Zcd6amBcWi+SifJFCk
	0YOKQIUfthqPUXNWwHx3tYJbrJJw/otP5nfafDoJsQOvjGWRTCkhhTqr9SD6ZkBF
	X2KVXnxn9Jcqh7sOFPwcgdLe6+/pIILSs3ksi0k7I1ahA00aZDlEVSc97afin/5k
	aP92yg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqv9u8ba6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 11:14:35 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae4f27033cso56497665ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 03:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772795674; x=1773400474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ROs7foJ9C7wWq6029alq5/CQprIQotEEK0bAcQMfs6A=;
        b=bCJKth9wHJTiYkmXZThYVxxm94RHCNu26S//COyvJazG5xFt6K824eNFldtzx+QVnJ
         /5/EzBukz1SEYaFggP5lO4EEzOmJr+I1C2y+dCNRe/zFbH/C8CUM8E1PAzsxWK8LtMc/
         NkVT/KVVCFo6e8ejnaBffubN/2sJkl2nlECib4tdQ3+T72qi7oc1e/JOmTF7Kx5HjiZY
         s9IVrZTaoM/nybEYhXWdkzBtW9Zzeigt8+893qAOwgpzX8QIDkaPnlsgxPOTsC/R0brn
         e4dU7oazzDPBrhcgQaIVjIT3XWdo1G3YXZV5OKmGLHIzBybGCWkSSTQR5hbsmm8v01EZ
         2X8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772795674; x=1773400474;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROs7foJ9C7wWq6029alq5/CQprIQotEEK0bAcQMfs6A=;
        b=wd87ZR9igOZn50Mazn5Y2XWf3kJQk10M1br7rydip+zDiWl4vFZ53quhlrHKri2KJs
         9RAkNOFJBHnc8oL9DpvwJtuL+bavPzrSxbWrnOMlixrdI1dhB8WYZkZAEYFClOS6Amcr
         THfgrYwoNjCw/H+cDsSe8O5dKL+UWG6mAo2J2IHN2Qi5UcvxYKfkWeA7Ii4Ji87pCAKr
         Ni0fusD4j2s5ECSR1fWr57hV0ZDpb9eS0rQ47SjVumSzu9AyX2MJIF9IEJ5EqLmCt5R+
         fI6J3lxOPk49j3+blrQg8Sb7IsJGTd0f5NAnbSsHZKXLF8Mz+ZwMiUUrbqrynduKPcyl
         6opg==
X-Forwarded-Encrypted: i=1; AJvYcCUAhkyjvB6+gjyWDMYn9JRGQPT/seIAPjRrR7narNMHQPmX1D0uI7ELVKs2EcU2huOqSde231MSNh6u@vger.kernel.org
X-Gm-Message-State: AOJu0YySv2V/nxf3R4ctTKKpeGdJ3MeQ5kJNSSpbsllpUAhr7a/gozmK
	YVW3Hk4WuUWePHVYLHUIVnmhh2q7dnq/SsasyWrLE9fDiDbUgi0OksHd495gRTRAzc+f0QmN3PE
	QZ9CYRaHyddHSvDMSunwdjFkeXrzj+jE8os3+G7FE9/LapPxucz0CZejecM2xQbRc
X-Gm-Gg: ATEYQzz9eptMyJ2j3wLmpTsM770qGcQoK6rNGEub9Bv0FqfJzs8oSTdbz2HmDjMbZJH
	1+5GcN/TAiTwcLQ1z9G74O7GKxWTqGn3GKwQm+HI6ag3YvuxlTcB1sVaD9BgFd04hsTsc6BS0Wd
	xq2s7l9PPg9rqvsGuH0F/IsE+IgFqzvgqKhnEdnItzgP9CRqWjTGK1INQVPYXWyCBpuFdnDU8Am
	sGAYuF100ZOJ4oBN+/ADnZv81UnGHt/C3iR30+UlW5z+F6/8Wv6+ITmCfNuTwMy0Bz/U7PIQqGR
	pc9wLemxuhynUp/QmRHTLK9sV6NCoB2RxzRWr2pSc/Dq0ChcTwEKRzQ4oLNMhTNZBGf0MXAjwKo
	FCZExbqrSY3wPtRq709zHqniLFVAcgoTcv3TDWZmnOnpQoG3kTF74axeWb6RhoJk9PPLcJYNFdZ
	hqKrtb+kutnIw=
X-Received: by 2002:a17:903:3bac:b0:2aa:e3c2:f925 with SMTP id d9443c01a7336-2ae82432967mr18614675ad.34.1772795674403;
        Fri, 06 Mar 2026 03:14:34 -0800 (PST)
X-Received: by 2002:a17:903:3bac:b0:2aa:e3c2:f925 with SMTP id d9443c01a7336-2ae82432967mr18614355ad.34.1772795673710;
        Fri, 06 Mar 2026 03:14:33 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e9c965sm16771595ad.32.2026.03.06.03.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 03:14:33 -0800 (PST)
Message-ID: <48d39a5e-b3ca-4cab-883b-33307fd85dce@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 19:14:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Can Guo <can.guo@oss.qualcomm.com>
Subject: Re: [PATCH v2 07/11] scsi: ufs: ufs-qcom: Fixup PAM-4 TX L0_L1_L2_L3
 adaptation pattern length
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-8-can.guo@oss.qualcomm.com>
 <5jri65eq7jc4p3bd2tcgvlgctqf4c2v4sthotkqvavp4rjyzha@hkhw7maeftq3>
Content-Language: en-US
In-Reply-To: <5jri65eq7jc4p3bd2tcgvlgctqf4c2v4sthotkqvavp4rjyzha@hkhw7maeftq3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEwNiBTYWx0ZWRfXxoERFolssYUS
 AF+sxdbpOdzgE8KIvxMw9RkgEQYf6DeB+p5zWjVxQYt2zka9z6pe503/RuHQ6HfleWhYUpV9cZ5
 Mr2+KkLYIF8yIkhKRWNkBZAPQxkGNWSkRXcWmc1NfvaQcnEa/u0vH+7BNUY8EAmU/sAS3QtNcCU
 e9FcH5FWE84e8w6qlPAJ1YrOCvDvYyhVqs4BgOfQGAhecjB48c0JH3izrlI5EkxKUu71BGbmRKM
 bHhU6ocHD1iO4K0xkzoqXffVUZ9vBD5o5oihwGrquSYoy87A9yZUuEM6jzM6+EvkvOWcNMNBy4D
 aEnkZuln9sNQUmyiabBT30y9CrjyCPyqbtwuEHyAiq8/nccuAd6FHe9UFwGMGuXL5ZdraSPVfhv
 JlXIClnyZOSfT+3htVBO57jXV9eEM3H95EpT8LDYczyjgEOfkQhjPm1d3uQ8Yh04DzxYSYjF7ut
 I8/VK61W423EyQgjS+w==
X-Proofpoint-ORIG-GUID: G2jawsUqbEHwuAW3XzxKXIynHGgP9zH9
X-Proofpoint-GUID: G2jawsUqbEHwuAW3XzxKXIynHGgP9zH9
X-Authority-Analysis: v=2.4 cv=eJoeTXp1 c=1 sm=1 tr=0 ts=69aab71b cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8 a=hWv5-68019lLMkcv5WcA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_03,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060106

Hi Mani,

On 3/4/2026 11:10 PM, Manivannan Sadhasivam wrote:
> On Wed, Mar 04, 2026 at 05:53:09AM -0800, Can Guo wrote:
>> If HS-G6 Power Mode change handshake is successful and outbound data Lanes
>> are expected to transmit ADAPT, M-TX Lanes shall be configured as
>>
>> if (Adapt Type == REFRESH)
>>    TX_HS_ADAPT_LENGTH_L0_L1_L2_L3 = PA_PeerRxHsG6AdaptRefreshL0L1L2L3.
>> else if (Adapt Type == INITIAL)
>>    TX_HS_ADAPT_LENGTH_L0_L1_L2_L3 = PA_PeerRxHsG6AdaptInitialL0L1L2L3.
>>
>> On some platforms, the ADAPT_L0_L1_L2_L3 duration on Host TX Lanes is only
>> a half of theoretical ADAPT_L0_L1_L2_L3 duration TADAPT_L0_L1_L2_L3 (in
>> PAM-4 UI) calculated from TX_HS_ADAPT_LENGTH_L0_L1_L2_L3.
>>
>> For such platforms, the workaround is to double the ADAPT_L0_L1_L2_L3
>> duration by uplifting TX_HS_ADAPT_LENGTH_L0_L1_L2_L3. UniPro initializes
>> TX_HS_ADAPT_LENGTH_L0_L1_L2_L3 during HS-G6 Power Mode change handshake,
>> it would be too late for SW to update TX_HS_ADAPT_LENGTH_L0_L1_L2_L3 post
>> HS-G6 Power Mode change. Update PA_PeerRxHsG6AdaptRefreshL0L1L2L3 and
>> PA_PeerRxHsG6AdaptInitialL0L1L2L3 post Link Startup and before HS-G6
>> Power Mode change, so that the UniPro would use the updated value during
>> HS-G6 Power Mode change handshake.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 175 ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 175 insertions(+)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 5eb12a999eb1..3a9279066192 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -1079,10 +1079,185 @@ static void ufs_qcom_override_pa_tx_hsg1_sync_len(struct ufs_hba *hba)
>>   		dev_err(hba->dev, "Failed (%d) set PA_TX_HSG1_SYNC_LENGTH\n", err);
>>   }
>>   
>> +/**
>> + * ufs_qcom_double_t_adapt_l0l1l2l3 - Create a new adapt that doubles the
>> + * adaptation duration TADAPT_L0_L1_L2_L3 derived from the old adapt.
>> + *
>> + * @old_adapt: Original ADAPT_L0_L1_L2_L3 capability
>> + *
>> + * ADAPT_length_L0_L1_L2_L3 formula from M-PHY spec:
>> + * if (ADAPT_range_L0_L1_L2_L3 == COARSE) {
>> + *   ADAPT_length_L0_L1_L2_L3 = [0, 12]
>> + *   ADAPT_L0_L1_L2_L3 = 215 x 2^ADAPT_length_L0_L1_L2_L3
>> + * } else if (ADAPT_range_L0_L1_L2_L3 == FINE) {
>> + *   ADAPT_length_L0_L1_L2_L3 = [0, 127]
>> + *   TADAPT_L0_L1_L2_L3 = 215 x (ADAPT_length_L0_L1_L2_L3 + 1)
>> + * }
>> + *
>> + * To double the adaptation duration TADAPT_L0_L1_L2_L3:
>> + * 1. If adapt range is COARSE (1'b1), new adapt = old adapt + 1.
>> + * 2. If adapt range is FINE (1'b0):
>> + *   a) If old adapt length is < 64, (new adapt + 1) = 2 * (old adapt + 1).
>> + *   b) If old adapt length is >= 64, set new adapt to 0x88 using COARSE
>> + *      range, because new adapt get from equation in a) shall exceed 127.
>> + *
>> + * Examples:
>> + * ADAPT_range_L0_L1_L2_L3 | ADAPT_length_L0_L1_L2_L3 | TADAPT_L0_L1_L2_L3 (PAM-4 UI)
>> + *		0			3			131072
>> + *		0			7			262144
>> + *		0			63			2097152
>> + *		0			64			2129920
>> + *		0			127			4194304
>> + *		1			8			8388608
>> + *		1			9			16777216
>> + *		1			10			33554432
>> + *		1			11			67108864
>> + *		1			12			134217728
>> + *
>> + * Return: new adapt.
>> + */
>> +static inline u32 ufs_qcom_double_t_adapt_l0l1l2l3(u32 old_adapt)
> No need of 'inline' keyword in a .c file. Same comment to other helpers.
OK.
>
> Also, can you change the '_l0l1l2l3' suffix to something like '_level' or
> '_length'?
>
There are many Adapt length attributes in M-PHY spec, their definitions 
are similar
but used for different purposes. To make sure we are capture the correct 
one,
let's use the full name
>> +{
>> +	u32 adapt_length = old_adapt & 0x7F;
> Please add a define for 0x75
Sure.
>
>> +	u32 new_adapt;
>> +
>> +	/* Adapt range == COARSE */
>> +	if (old_adapt & 0x80) {
> This one also.
Will do.
>
>> +		new_adapt = (adapt_length + 1) | 0x80;
>> +	} else {
>> +		if (adapt_length < 64)
> And this one.
Will do.
>
>> +			new_adapt = (adapt_length << 1) + 1;
>> +		else
>> +			new_adapt = 0x88;
>> +	}
>> +
>> +	return new_adapt;
>> +}
>> +
>> +static inline void ufs_qcom_limit_max_gear(struct ufs_hba *hba,
>> +					   enum ufs_hs_gear_tag gear)
>> +{
>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>> +	struct ufs_pa_layer_attr *pwr_info = &hba->max_pwr_info.info;
>> +	struct ufs_host_params *host_params = &host->host_params;
>> +
>> +	host_params->hs_tx_gear = gear;
>> +	host_params->hs_rx_gear = gear;
>> +	pwr_info->gear_tx = gear;
>> +	pwr_info->gear_rx = gear;
>> +
>> +	dev_warn(hba->dev, "Limited max gear of both sides to HS-G%d\n", gear);
> s/both sides/host and device
OK.
>
>> +}
>> +
>> +static void ufs_qcom_fixup_tx_adapt_l0l1l2l3(struct ufs_hba *hba)
>> +{
>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>> +	struct ufs_pa_layer_attr *pwr_info = &hba->max_pwr_info.info;
>> +	struct ufs_host_params *host_params = &host->host_params;
>> +	u32 adapt_l0l1l2l3, new_adapt, actual_adapt;
> Can you shorten adapt_l0l1l2l3?
As I explained above, I want to capture the precise Adapt attribute.
>
>> +	bool limit_speed = false;
>> +	int err;
>> +
>> +	if (host->hw_ver.major != 0x7 || host->hw_ver.minor > 0x1 ||
>> +	    host_params->hs_tx_gear <= UFS_HS_G5 ||
>> +	    pwr_info->gear_tx <= UFS_HS_G5)
>> +		return;
>> +
>> +	err = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3), &adapt_l0l1l2l3);
>> +	if (err)
>> +		goto out;
>> +
>> +	if (adapt_l0l1l2l3 > ADAPT_L0L1L2L3_LENGTH_MAX) {
>> +		dev_err(hba->dev, "PA_PeerRxHsG6AdaptInitialL0L1L2L3 value (0x%x) exceeds MAX.\n",
> Nit: remove full stop at the end
OK.
>
>> +			adapt_l0l1l2l3);
>> +		err = -EINVAL;
> -ERANGE
Sure.
>
>> +		goto out;
>> +	}
>> +
>> +	new_adapt = ufs_qcom_double_t_adapt_l0l1l2l3(adapt_l0l1l2l3);
>> +	dev_dbg(hba->dev, "Original PA_PeerRxHsG6AdaptInitialL0L1L2L3 value = 0x%x, new value = 0x%x\n",
>> +		adapt_l0l1l2l3, new_adapt);
>> +
>> +	/*
>> +	 * 0x8C is the max possible value allowed by UniPro v3.0 spec, some HWs
>> +	 * can accept 0x8D but some cannot.
>> +	 */
>> +	if (new_adapt <= ADAPT_L0L1L2L3_LENGTH_MAX ||
>> +	    (new_adapt == ADAPT_L0L1L2L3_LENGTH_MAX + 1 && host->hw_ver.minor == 0x1)) {
>> +		err = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3),
>> +				     new_adapt);
>> +		if (err)
>> +			goto out;
>> +
>> +		err = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3),
>> +				     &actual_adapt);
>> +		if (err)
>> +			goto out;
>> +
>> +		if (actual_adapt != new_adapt) {
>> +			limit_speed = true;
>> +			dev_warn(hba->dev, "Failed to update host PA_PeerRxHsG6AdaptInitialL0L1L2L3 to new value 0x%x, actual value = 0x%x\n",
> This goes beyond 100 column width. Please consider shortening up. Applies to
> other prints as well.
Will shorten them in next version.
>
>> +				 new_adapt, actual_adapt);
>> +		}
>> +	} else {
>> +		limit_speed = true;
>> +		dev_warn(hba->dev, "New PA_PeerRxHsG6AdaptInitialL0L1L2L3 value (0x%x) is too large!\n",
>> +			 new_adapt);
>> +	}
>> +
>> +	err = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTREFRESHL0L1L2L3), &adapt_l0l1l2l3);
>> +	if (err)
>> +		goto out;
>> +
>> +	if (adapt_l0l1l2l3 > ADAPT_L0L1L2L3_LENGTH_MAX) {
>> +		dev_err(hba->dev, "PA_PeerRxHsG6AdaptRefreshL0L1L2L3 value (0x%x) exceeds MAX.\n",
>> +			adapt_l0l1l2l3);
>> +		err = -EINVAL;
> -ERANGE
>
>> +		goto out;
>> +	}
>> +
>> +	new_adapt = ufs_qcom_double_t_adapt_l0l1l2l3(adapt_l0l1l2l3);
>> +	dev_dbg(hba->dev, "Original PA_PeerRxHsG6AdaptRefreshL0L1L2L3 value = 0x%x, new value = 0x%x\n",
>> +		adapt_l0l1l2l3, new_adapt);
>> +
>> +	/*
>> +	 * 0x8C is the max possible value allowed by UniPro v3.0 spec, some HWs
>> +	 * can accept 0x8D but some cannot.
>> +	 */
>> +	if (new_adapt <= ADAPT_L0L1L2L3_LENGTH_MAX ||
>> +	    (new_adapt == ADAPT_L0L1L2L3_LENGTH_MAX + 1 && host->hw_ver.minor == 0x1)) {
>> +		err = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTREFRESHL0L1L2L3),
>> +				     new_adapt);
>> +		if (err)
>> +			goto out;
>> +
>> +		err = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTREFRESHL0L1L2L3),
>> +				     &actual_adapt);
>> +		if (err)
>> +			goto out;
>> +
>> +		if (actual_adapt != new_adapt) {
>> +			limit_speed = true;
>> +			dev_warn(hba->dev, "Failed to update host PA_PeerRxHsG6AdaptRefreshL0L1L2L3 to new value 0x%x, actual value = 0x%x\n",
>> +				 new_adapt, actual_adapt);
>> +		}
>> +	} else {
>> +		limit_speed = true;
>> +		dev_warn(hba->dev, "New PA_PeerRxHsG6AdaptRefreshL0L1L2L3 value (0x%x) is too large!\n",
>> +			 new_adapt);
> I'm assuming it is safe to continue despite the warnings.
Yes, warning here is to give the reason as well as heads up that it is 
going to limit the max gear.

Thanks,
Can Guo.
>
> - Mani
>

