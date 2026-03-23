Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31B439DBF6
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774271650; cv=none; b=lE6fokwhrYUp74H+hl8k6hftk1wuqztzxnAViER/ddmcqFo8oGkcr25Mc7DiSEAe+0W2znHi7EVOF4KY7plMlIo+Idr1BhsD53/xW9zhyoYq2GGXsTwyiHD4INhKoi1+KJL2Q2YOvI4HwvgZv34NjQrsW0wnRyVigkTAinHoYQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774271650; c=relaxed/simple;
	bh=JPZsmS11+JwdkvRgHyF38obFN+XU7pSyJAFCM5N/iqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Waw/9MJR9HOPsdo/AUXphyhV1hCkdgzIMWTWHwC26FGZnZq3FMsGBOm0zo/Vky4oWOjSPo3r77CoqYR/hgscXEDYQTHAHutUcO+Yy3XNpKlzxoRlcHAK1KEQCgzwHoqgh60nHGVDDZm9+D9gx8woCA0YyXnglpAdLNqPMuZ5eEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OVF9Dm2P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hkE4ySYM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OVF9Dm2P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hkE4ySYM"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tVhF1627086
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 13:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hhOVnrszaNufwcUXa8iHOZ0yUXL4wPlq8WcC3t69bE0=; b=OVF9Dm2P5kwgGW+J
	0TTLCMd0o3w1s3bUSy85d4O4Wbkxcc0rFUTMkhLZN1mQ5l4YT/an3D/mlHHyHJyP
	A72HEVyCc4fqA2oSJdJQRgnr3Z12lzQ3B5EDFga64ticSlLaMKVmVcvMc0XqBn/2
	+ZcPZOu9v2DYC0xDhclpY5h2F8uT7lA6UKCfQWML7wswB0sOHC2DspfdzdXA1AFk
	GFiFtDQ1esj/8V95uFYrbE+ILkmbJImCqY9t209b0fV+9f19siSn+3HSKnZUcDQV
	UGtDyBgOT7vkt+vW0BWK7Qpy4W/Se+BwbtcpMjLrQoADkFt9b7wuU+XsrQDAyCKF
	dmf4Gg==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31jc14gw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 13:14:08 +0000 (GMT)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-79472373f48so885157b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774271647; x=1774876447; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hhOVnrszaNufwcUXa8iHOZ0yUXL4wPlq8WcC3t69bE0=;
        b=hkE4ySYMLPRzcqLxZvfcnnyroF9VEUj46fvY+hL2LBEiGuuLOzIap1yIaKbGUPRf87
         4nQrrVlMDt2KWq49s/FNIkz5YKQ9QULPdil8BzfetIEGk8gRABNyPAYP+QzkHkXc6Sa7
         F3u3Y2Cu71FIRhtZ2nowqBA8h+QMxicAa8ICa3Px5ul/rvJPJOLObyVcidRx/icXly4Y
         jMVDPkUsiBa81+Hda8tWeicSLk3yENv8uc1LR77GBMq7kKlGV+bG/es0tiifmzJmcToP
         mfEG8HHECCTLHEwQdnvP6OdelhP87qiPWGgwTx7d4lxbkcCMalb7XezfhCUd5lN+f0qx
         THlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774271647; x=1774876447;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hhOVnrszaNufwcUXa8iHOZ0yUXL4wPlq8WcC3t69bE0=;
        b=BfEw9xxMWI7iqcGN7QvJguKScdJulrgO6tGh+X+nT9Lk0OCm8325J9cxm76E0OOto0
         Q75cqsRz9BOnIzYYxob35mOgBAzXpyaKrLFQ3TtYCTFnb/uEQikP+9eXxR1Gf3QCyK+j
         PwZhvHE0xJbBFLZkWegjaO37ywRZi5OedzyOYDj3mciTHS+H5vCn4FdjaEFoHIhiMhAb
         yDc+CKAwg9bmPjcqN262CxZ/hZHFyPri+Tx8p1RbBCRvGE1GQoarWy0bRtmWDP+Dmvmv
         6e8BP662ULSz4F66bF2q3QKDPX9ObNrU21UEYohs/Lbsn5G1vZaqq44mFmLTTb31QFfk
         hu4A==
X-Forwarded-Encrypted: i=1; AJvYcCXbJQKPH2FWUSznZ1Q5YWDktP53jNtkviWj0xdTdztZ9WsiTZzqIQfoyCbbgYD2lcXf+AtibggBTYOm@vger.kernel.org
X-Gm-Message-State: AOJu0YxdSKMezQMO1IK8o740k09nF2Rm7FPYm4I47+d6UkEXv6MT3/VD
	uKJUgRWTflhPhcLrGdU0HWkHbI6DdcdfAHxUxLwEJIyf/EPQgPuX7+r8EVRzISB0ejFQyYSuLhX
	6PY67qCtcv2yOaVXNLmyQ6QoHL5W/ZWaJzwKObvPu00j2pKP2D7vZwp8MAVsdk6C0
X-Gm-Gg: ATEYQzw9VfRobO2FhTy0PftZcvV6anvzKxWscEcE759FxPY/8JeFUWCx9MXVEBh4zJ0
	XD3BC3OdZ+yF73EX+HO2cCqlZF/YiIUlRCUIJAFpSJrkwrKmmLkRrl+9j3z8L1HaObIlKcxxHDR
	h8cQgpFGAAaH8EvAZSKUro8Kh4GGWvIfqqp4oJUi5scIYUiL6txAsxG1nKKN9Wyhn4geRuV0nWD
	HcbjX2AvIRzMpCGMFqrUcSIwTC3ZJ7P5mtY7Swqn+temDVe0OEhCOMLU93bObwvs37GuOWy/dgY
	g7zqHjkqFNZ5oFbnUU5xjPT00bpB+p+lM1vJiRP7nNr46YzqaFa4ucORAAHlhPPpwlwILJN0aWb
	Et8eQ5S0l1McJB7oxpeIeuRcdCwrgikv6kDDTYqmO2H57s2jmsl7o
X-Received: by 2002:a05:690c:490b:b0:798:4f55:2c5e with SMTP id 00721157ae682-79a90bc9e54mr119543107b3.30.1774271647352;
        Mon, 23 Mar 2026 06:14:07 -0700 (PDT)
X-Received: by 2002:a05:690c:490b:b0:798:4f55:2c5e with SMTP id 00721157ae682-79a90bc9e54mr119542597b3.30.1774271646905;
        Mon, 23 Mar 2026 06:14:06 -0700 (PDT)
Received: from [10.217.219.69] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057b4ecsm58210727b3.35.2026.03.23.06.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 06:14:06 -0700 (PDT)
Message-ID: <a023320e-019f-4c01-a2d1-50c77109871f@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 18:44:02 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ufs: core: Configure only active lanes during link
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
References: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
 <20260311060912.3139257-2-palash.kambar@oss.qualcomm.com>
 <a1822226-0881-b692-9663-c0832c9212fd@rock-chips.com>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <a1822226-0881-b692-9663-c0832c9212fd@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fKc0HJae c=1 sm=1 tr=0 ts=69c13ca0 cx=c_pps
 a=72HoHk1woDtn7btP4rdmlg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=hTMk1fmUvmZNUCmr5HgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kA6IBgd4cpdPkAWqgNAz:22
X-Proofpoint-GUID: y-MaQthBracF0kxxH1XprocWMDvuyGuU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwMSBTYWx0ZWRfXw/ZJau+Cd0C7
 SxYGRgd4cgXpqFt77O7duZ1UGiK5EdHDpDhwvgv+7X94b6E0igVJ4r65B4QplbtNoyfbs8ft+KI
 O3o55Rp6p32VF5IS6OryPW1HfhEUwVAUdKNmIqBjCgJ0SftJGseQoaVX7smda67ABrq0wk6I1ot
 FKqKuu6jyuOUMWwUYgkA2Qe+90nCf8iSe2+AYz9NNRTcwt9J+8BXpCeUop8Wpmx1oXkkUhSavXw
 W+Ccfga24iUyCSK5MvVDq33SJmJgZXRzPJ4OpTcMn3WyPXJ+zstQrcg6eMF+DY4rOPeQBU/UKYH
 gfaq/nlB6hpULrQE0+AlCRWWqKVHEaV7XvRCALEYWH1jERxW0m/OApt4DFiZJAQvRjWLSs3ekHb
 vrwu6F34LwtIFvqtUXrC6wIXMJLn+IBDuqEoa4Zc9EfebuxVJQnvb3FqpNCt+eQQMzeiDrEG108
 KvdHK+m1cDx/ByGPrvw==
X-Proofpoint-ORIG-GUID: y-MaQthBracF0kxxH1XprocWMDvuyGuU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603230101



On 3/11/2026 12:23 PM, Shawn Lin wrote:
> Hi Palash
> 
> 在 2026/03/11 星期三 14:09, palash.kambar@oss.qualcomm.com 写道:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> The number of active lanes detected during UFS link startup can be
> 
> connected lanes(which is used in the code blow) or active lanes? There
> are different primitives in UniPro context.

Yes, I meant connected lanes, will fix comment.

> 
>> fewer than the lanes specified in the device tree. The current driver
>> logic attempts to configure all lanes defined in the device tree,
>> regardless of their actual availability. This mismatch may cause
>> failures during power mode changes.
>>
> 
> It sounds vague, how it causes failures, could you quote some clue from
> spec?

There was a negotiation mismatch for connected lanes during
link startup phase. So when host sends power mode change(PMC) after
UFS link startup, device returns a failure for PMC command with WR_ERROR_CAP
due to mismatch in the connected lane capability between host and device. 

> 
>> Hence, add check to identify only the lanes that were successfully
>> discovered during link startup, to warn on power mode change errors
>> caused by mismatched lane counts.
>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 31950fc51a4c..c956fab32932 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5035,6 +5035,42 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
>>   +static int ufshcd_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
>> +{
>> +    return ufshcd_dme_get(hba,
>> +                  UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), tx_lanes);
>> +}
>> +
>> +static int ufshcd_get_connected_rx_lanes(struct ufs_hba *hba, u32 *rx_lanes)
>> +{
>> +    return ufshcd_dme_get(hba,
>> +                  UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), rx_lanes);
>> +}
>> +
>> +static void ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +    int val = 0;
>> +
>> +    if (ufshcd_get_connected_tx_lanes(hba, &val))
>> +        return;
>> +
>> +    if (val != hba->lanes_per_direction) {
>> +        dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
>> +            hba->lanes_per_direction, val);
>> +        return;
>> +    }
>> +
>> +    val = 0;
>> +
>> +    if (ufshcd_get_connected_rx_lanes(hba, &val))
>> +        return;
>> +
>> +    if (val != hba->lanes_per_direction) {
>> +        dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
>> +            hba->lanes_per_direction, val);
>> +    }
>> +}
>> +
>>   /**
>>    * ufshcd_link_startup - Initialize unipro link startup
>>    * @hba: per adapter instance
>> @@ -5108,6 +5144,9 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>>               goto out;
>>       }
>>   +    /* Check successfully detected lanes */
>> +    ufshcd_validate_link_params(hba);
>> +
>>       /* Include any host controller configuration via UIC commands */
>>       ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
>>       if (ret)
>>

