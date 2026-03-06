Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BF738E133
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805954; cv=none; b=Nx1Bq04MNZHwdL5DwLtneZ1WWeYFVMkkKpYtTCArYVN+5NAGPkhLnAYlUq2JZuAkxWvRjqnuLOFOgP5BzE7UZaEKaEtVEsbur/cH8okbOCQaFQlsFN1Mq0XCEQcjjkmTmpElT8tID7evqNUr/gIK2qawkM7pWc8W76qk1R1FFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805954; c=relaxed/simple;
	bh=PoeET+qFa6pR0XKfw5tKjEtxRNaloT7k8RrQJIDBWjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IScoOL8mlZ/L8e/Wb9BvG0q9nd668q0CeBTweMQf3O38RLNSaTLClf3Cp/JmiyLwUOGqJVRuKdT33NMVTN6hUtslK+ZwadFGvA7hh5mnqwwiI0ExY1UGxGaFns71yNjMRq3DM1iAYnNXjtAugCS9GKr2LIasqvozCP6CmWXC+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WYg3ajWx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ebZ4qqtM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WYg3ajWx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ebZ4qqtM"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626BawZd864976
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 14:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U+VfUnExQBW7y3BidnhCqBz/4vBGXnsLYPZTfRBzDOc=; b=WYg3ajWxYC5Ou+vJ
	3t8tJd7Ts4aC24Xe//pdxy9F7B4kBIWetbNTPWll5QHD5jOgjO4OiLQKG8p7GH/8
	wz6Rjzs6x1zFcfAC7/YQBBMqqkG+ObKI2ik/hdpgtKo10hQ0W4+WzWfL85KRcfWI
	TuFa9Tv3HaWg0hsa7VODN22E8sYSuNsDBf7LILC7XrQssESF6einmdYB1XdYx6FI
	VrF8fHo8bpadiGDnquzI9WU9l+Dm6sM+wobyfZ72Jk0vlz4fUMpMQltcF94LHg6k
	IabH//dkv53UNmrZcjvhdwND4RDNUWJbsMD53EL9cDT9J5M3hgmdxruPT/WkF2ZW
	ss8DIg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqrf5sp2s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 14:05:51 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae4cdfc468so56836475ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 06:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772805950; x=1773410750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U+VfUnExQBW7y3BidnhCqBz/4vBGXnsLYPZTfRBzDOc=;
        b=ebZ4qqtMKC+YRNgbvli3ajUC5lx0n0uTkrUJi8NxXzVYza7vyZvJl5DOjoLo43RzVG
         NggUfHygWfd4An5QqN9kyhHD0i9uof7VvITH/20j0+VXR8CW18KqZ4uTQjQ3PT2ffEwi
         QJVJaaPcWbLlB53zGHdjyCOIzHJ68iVdtC/XgBafe2aE44SKHTYJzNz7V+n6jIjXAnar
         5B099Ci22pWeL0rmgzJO74n7SrRySqH537Vd1kW+LvUjbYe86W9MYvXAuTGn9DnmGD/3
         MHOKQTrRevqC68AhMpAo8KgSphocd0A6kfjcUwvNZhKfgE1ffRjbbSRgbEqEEQw6G4YC
         ioog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805950; x=1773410750;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+VfUnExQBW7y3BidnhCqBz/4vBGXnsLYPZTfRBzDOc=;
        b=FQxYk/H/MfVE1J9AsP0HHXEdghCbGLzTIAKail61xu1zFCqnX5wtgqp6gmiXhCjKif
         1iF5hGo5VqgB72dxCR5uIKRknAohp7RFznZ1iu65RRWI6dO4HFgHEmrjfO3ByKVIa578
         S9n+9q7SVnO4y1nuRxH8PtTsRN2oDDncn7gl3otgYvUPMgeA3K/hd9GttVyYYaQgpw68
         7AjX6RLq+adjobwdA+myanqUGytM3w/ibnwaooCGyEEIFe0qg7pftBIYRUSgZ1w9UziP
         LXUdsHymvXH7Ycb+azkN5Y4KP9XmQzVDz6VXQYqLDpGb00s6pcqfBGPIeeYewg/D3OQk
         HoJg==
X-Forwarded-Encrypted: i=1; AJvYcCWqyINhmqZIYgOKU9gDvrig14Ko/UEN3Kh2hmxxjwVOjdy92TPjO+iiKq+UcxwxgwRr+4yPaHG+RxKF@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgsvo2v3zJV/xOJj+j4/VGyA2Pj6NJVQHcceFKiupFtsU7WR/X
	vkdtFk9QaVGBZWsqRYvWmkgPROMrqo018RAPQYjr3O85rz8ix+fRy/FruvjXTaFJ3afvBbq+Dk+
	C3sgImouJAld7nyY4FR2aEa1FWtk8iAVchHkP97OvswtUIFyVfQTX3S62PYX1ZLeU
X-Gm-Gg: ATEYQzzWf3J0HsmM+MR/ixQD+thcIgn5yjRmYfE7/TCLvU1T+a4BiKl4cUONqsE6+JU
	SXNrp/rDBRup0PCOJL2BHfO08vGWI5CwnjSh2rsqV46ggWf62hQBOV8w6Iz+/Oy0yI9GDcF1lFf
	f9AkGJl9+e/pqi76Y/BpC1l51A80rynobUC3frf5JZVKmwGzt1BtoaeWvpzts0ozCNS5SiztIWZ
	1V+/+ZWofcjDtlXA+nfcefEJ0B2/i/HENNNqVfc5Kx7gJsyg6wI6CIbPL/6hezOVWdpb5i9dqGy
	sfJmma7M2gbpqFZYQisuZPbfTPpr0gpNIaopl7x92tqIKN/g5l1X5RmgTAKmPIXGt2FfDfcKZ1x
	VC1+pkb5aOjdIs6FrDShIMNIrnd2I0A2so9e4Yw9wmG2JsQ3uyQ5cUMC/9aKwRUFUVoZxLWJC5X
	Q/Gvt2MalJq8o=
X-Received: by 2002:a17:902:cccf:b0:2ae:805d:e0b5 with SMTP id d9443c01a7336-2ae824bbaafmr22917465ad.56.1772805950072;
        Fri, 06 Mar 2026 06:05:50 -0800 (PST)
X-Received: by 2002:a17:902:cccf:b0:2ae:805d:e0b5 with SMTP id d9443c01a7336-2ae824bbaafmr22917145ad.56.1772805949445;
        Fri, 06 Mar 2026 06:05:49 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f7864dsm22663795ad.49.2026.03.06.06.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 06:05:49 -0800 (PST)
Message-ID: <493da66e-3c3c-40af-8859-646c144acbdb@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 22:05:45 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] scsi: ufs: ufs-qcom: Implement vops
 apply_tx_eqtr_settings()
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-11-can.guo@oss.qualcomm.com>
 <uqhyyyt5spxggiyhzcrnlcl2noomkfybw5kieki4lde6kdaryt@ozdoxegemqpn>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <uqhyyyt5spxggiyhzcrnlcl2noomkfybw5kieki4lde6kdaryt@ozdoxegemqpn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 1cNzXPnTvlACA7RnWkyEBHRd8d9L3rQ3
X-Proofpoint-GUID: 1cNzXPnTvlACA7RnWkyEBHRd8d9L3rQ3
X-Authority-Analysis: v=2.4 cv=L+oQguT8 c=1 sm=1 tr=0 ts=69aadf3f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=cWpPSTlTcvdTqOXPF7sA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEzNSBTYWx0ZWRfX6Kv/fUwHz1dz
 8eBk2rSu4uOIZdHkBbuhQednxO3xpD0EtdD0O6BKsl1slvxutfp6a5b8pXLAHhwxptpR0jcMRbc
 qbcgRAMRj5bVEdPpdMtYz8kUgJjTd3ZCVuXYW+s92DXMzT/xtq5vxwgkuqhq3muIo9pSjZealpO
 wIcHtkFu1E45SPlso68B+lBqok1bXKT96Rkt/QdGKqAehYmNFqdfszXMEoX2IXXs1r5uoUJgcyV
 oD553eYn5pM4WUjPyujMJUzDJ1pTaR2gAA0wXcCUpElK3ntlaotWPOPOrkh7qLCna0VYXD1v6US
 UAZ2zK6cpltJZpL8Vt3Q+iUz6Yslwjcr0ajJ8xs/WkFH2czOFdlsCZbFsGwpV/2Q6JbpJtVK2xb
 KSJd0Pdj8MJ7e+kg2g+Vi5G5zCPPZ5qbBurUPuAGS4fnA/eghQEXCpjZ855HLNHLoKIjDVtkHhm
 wGsT9dewgSMRqaew5YA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060135



On 3/4/2026 11:41 PM, Manivannan Sadhasivam wrote:
> On Wed, Mar 04, 2026 at 05:53:12AM -0800, Can Guo wrote:
>> On some platforms, when Host Software triggers TX Equalization Training,
>> HW does not take TX EQTR settings programmed in PA_TxEQTRSetting, instead
>> HW takes TX EQTR settings from PA_TxEQG1Setting. Implement vops
>> apply_tx_eqtr_setting() to work around it by programming TX EQTR settings
>> to PA_TxEQG1Setting during TX EQTR procedure.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 33 +++++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufs-qcom.h |  2 ++
>>   2 files changed, 35 insertions(+)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index b8fa4670ddd6..89bea823a08b 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -2848,6 +2848,28 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>>   	return ret;
>>   }
>>   
>> +static int ufs_qcom_apply_tx_eqtr_settings(struct ufs_hba *hba,
>> +					   struct ufs_pa_layer_attr *pwr_mode,
>> +					   struct tx_eqtr_iter *h_iter,
>> +					   struct tx_eqtr_iter *d_iter)
>> +{
>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>> +	u32 setting = 0;
>> +	int lane, ret;
>> +
>> +	if (host->hw_ver.major != 0x7 || host->hw_ver.minor > 0x1)
>> +		return 0;
>> +
>> +	for (lane = 0; lane < h_iter->num_lanes; lane++) {
>> +		setting |= TX_HS_PRESHOOT_BITS(lane, h_iter->preshoot);
>> +		setting |= TX_HS_DEEMPHASIS_BITS(lane, h_iter->deemphasis);
>> +	}
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXEQG1SETTING), setting);
> nit: return ...
Sure Sir.

Thanks.
Can Guo.
>
> - Mani
>

