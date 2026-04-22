Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2143CF664
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776858184; cv=none; b=t64fbyLwMfJLNPlhLVymOYok4vuF9KX14JXtpbk6iKFCzqymdCf4etHY3V782c3Gi8zfX9aSzLeGKNJs+2JO0DkVrjx4ulMa7rGcKg+Ye65HqG7Kh/WZ2RwrLEkY3IVzyznzECUBI2kfYm9YMTEaezFnTtCF1f509tUSrSUg6/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776858184; c=relaxed/simple;
	bh=xpmmlN2U9IP/07c5/qTXUOmLu1m2Mith3UMXzkuawE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MvgT8nwipgCesosw4+8STYzGfw0NSrFsCnoSjcbXKGGViS5VdLHYFM6gOJl/GNf6WX3sNDK1UmGmhT4PRyfp+mInwKxKxYUx5oLsGKNce1XBWJQKQ1LV5clKvLQxjGV4pDNj3I5JmAJgSIP3ckakE5o62jdfSWbUJwFyeXsr44k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BMUWXQ6j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Rw/L8AQk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BMUWXQ6j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Rw/L8AQk"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MBeNVT2209053
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OmtyZ8ImtLYNrjmdyv9HZA5rCehvd27BE3LsxITC6VM=; b=BMUWXQ6j0ETp6V2D
	FfOeWhYnL/DHlBWtH6WqCCcLgCAW7IQDuJXDYi1OcEySpSmRgq5CMUeMVxzNWHe9
	QLlkTw8FohClP2ZEISb97bjhMBjE80Zx1BauCokLDNBD+8vshlpKWs/sgq0JZtNY
	MAJ7pDCmFKVKuoIebrQB5AAxSdl0ymjFi3g6qko57hleDh2lqkBuDrsc6Z2dUL3w
	w++3O8Z7uYC/1sGwPSI6EZPhJpfNSJjy4AXGneeDjKow5hZ/sj7s1I8ZKPwoOY3p
	zkOQrAzCTW5FB6D1vIbNzGb/5ovhxLBNVgj7661fR+D5GIjKwjN6DjyuFNTPOHGX
	bzCIyg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dpengb59w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:43:02 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35fc22424d9so10810598a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 04:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776858181; x=1777462981; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OmtyZ8ImtLYNrjmdyv9HZA5rCehvd27BE3LsxITC6VM=;
        b=Rw/L8AQkQ3UDBDMHzdyq+2ymCA915CJPmgpMJ+gOdkVAHKISoGUwD6e6zGfxj5XRx9
         cxrIXHpcwDhhIqwA5+L+KqRZGowImu05gDFNWNOzD9oI5/z9hfMkObnkcsJEVnqPNStX
         pN+L56XSxXNv3sYX9fYog1NbN3z/2rREU59YR3j815VG1OCRHBvSTJcqaWq8cRVdS1xX
         JxmEpmJamq20WpkeUBXsQgDxzi6Y2xdwfuxYrId25HrP4oehOYqqwe50CC+lfQeBzELA
         PS2b9enlER4U2A/K/rvrBhttwsxK6LKmK8HXHqH8pA34j+Td+6+cKrjrgjTVYbuQny3U
         EegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776858181; x=1777462981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmtyZ8ImtLYNrjmdyv9HZA5rCehvd27BE3LsxITC6VM=;
        b=Z7r+O5f5z1y3MXrX5lfIlLpL9HaNixeUZ3cGSJT8AuqZpzh76HgDrDS7IOt3pplHNN
         m8yc3ZUzDGcNfRPlCdS8AIX7u3Qyxru2cVIcMKRg/S+Pi2DPf7SKSvS8rn3/ff/VDsH5
         YI/o9N+cwc1FbfYNaVtYuNE9e0T7nOj0V1QE7ltKZJrhYA/ZTA7MalwGwjuMVXpMjZng
         kdrjzSufPjiK2/pcfYj192zX7VhV+3Nm7VxRHZER74KsuI+Q3G6GPGvfVwQbcb7uD9lK
         gb6xLcPLSNLjVh+zk3RuIkbTY566SfkRSM/9oj1vN6V88UNhkUB9H3Ncr/7Mue2f6Rnj
         fCxA==
X-Forwarded-Encrypted: i=1; AFNElJ/pWjpnXidk2PaoNXmMBzAbODYoQyJxqiaIzJVriDrS4pduJ5eedyuDXsTF+At+76qwLudKjtgRAxCe@vger.kernel.org
X-Gm-Message-State: AOJu0YykOfIiJ5SxGEHq9SPLn+pPf5E9DaWxZRQM5cyGmsCnG3fXM3GP
	fhDZ0x2NuMRnxF7Pjm5YK+iSYmRirIv+9QzZ29ssGGv31Y86xGzg4IHEMMDJpwBU18T1ZyKDX1H
	SvcHRfpf/lfxKPWsvjSo0kqFdknFOIjV3df3EA4UbmvxWKFeQWpNPBPPmwTWDZlkl
X-Gm-Gg: AeBDievPmU5kneHap+BYeHKeciD8tYqh9TmUBXZb1wx+ihg/smsOvE5Aa3dTiznMGg9
	3bBgNJJgvWCiqUFbvT/sQTC4iSs8WHdrUUp2UPek7reKr41pBi/cbuGSrG9QCEmUYSDvHq9agG5
	O0LWiQGewQ9GDCRBNzmIYGSZ6MJ38n7DuiD5hLMcz7uA4gwUIjc6OHOIoJzBeqcAxfZJWDnGdzb
	qfyuTdIq2EbMP/tWQvwG83KONf1vCe1f0EDx5PS5b04juv6UKlNdx8MsGrOyfXJzCAx6coeTJKd
	vADrKTHpKMXpBhiYVG9oINlC9a27rBoMHFg/XKVFJLlgTF8lHk5wfgrxr6vuyrCnwpi/pdDYZcQ
	paSiBowz+MzXikduwMBFByBN560rhAU2OAyOE9OGd/SlimrpmLakGz2HsR97E9vqK
X-Received: by 2002:a17:90b:562b:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-361403bdcfcmr23079170a91.4.1776858181248;
        Wed, 22 Apr 2026 04:43:01 -0700 (PDT)
X-Received: by 2002:a17:90b:562b:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-361403bdcfcmr23079141a91.4.1776858180728;
        Wed, 22 Apr 2026 04:43:00 -0700 (PDT)
Received: from [192.168.29.82] ([49.37.135.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36140fc575bsm16858965a91.4.2026.04.22.04.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 04:43:00 -0700 (PDT)
Message-ID: <544962be-22f1-4215-ad1f-21286798ed12@oss.qualcomm.com>
Date: Wed, 22 Apr 2026 17:12:53 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] ufs: core: Configure only active lanes during link
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        nitin.rawat@oss.qualcomm.com, shawn.lin@rock-chips.com
References: <20260417045602.3042928-1-palash.kambar@oss.qualcomm.com>
 <20260417045602.3042928-2-palash.kambar@oss.qualcomm.com>
 <zi5fjfyjwja2goouqesdpddyl243bjjpau232ik6fvvxed7kp3@egaolv3m3quq>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <zi5fjfyjwja2goouqesdpddyl243bjjpau232ik6fvvxed7kp3@egaolv3m3quq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMiBTYWx0ZWRfXwQn3VdWPQHWP
 709izBCDVC670IDq2687KF2oGGftBfUd/4ud4ZsDEFY9dGrbfXEl/8lPYYl/6dMN7EqvsLXn1HC
 80KzPrqB1uUyUtnj1iiBAYC5/ZxSm+1hYtEjvMXWTpUw/czdJqv3138XFoucrLxRK/DGUso1naq
 WFuhSHDV5RP2kaqesrdVsHWiNcpYeFdqFLUDpIEsKMXtDnZjkv/a6r+Pb22ODBeJ3Xvt0DVGdN1
 RkYx27iYQtHdRd4lW1WaXN6MPO2r1fSbG/gPnKyygY8fXGFwrxrWmF+cjD7UYOvtvnp509rd6Q1
 3PenCtC6KPX7mzAumYduGy1dpm/sTcuMQP3JZzns8UpiRBwj9mZ20Yytc3gVuDzf99hrZnSlgoK
 xuXNvkRwEIY8S3tAPXb6o+wvdJbtoh5PNVTEBkr60uvTCXy2gCwP4qA188z5tO3dlTJ2h23VQis
 jtquEXOPxPSRnIqy5nw==
X-Proofpoint-ORIG-GUID: spoH-50XdZCJiWoIEHeGqotkr1tuGGcM
X-Authority-Analysis: v=2.4 cv=RYygzVtv c=1 sm=1 tr=0 ts=69e8b446 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=+bqKbExyHclgz+xyRKw6tw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Db-oeYxN4i5GQM4S5YAA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: spoH-50XdZCJiWoIEHeGqotkr1tuGGcM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220112



On 4/20/2026 3:10 PM, Manivannan Sadhasivam wrote:
> On Fri, Apr 17, 2026 at 10:26:01AM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> The number of connected lanes detected during UFS link startup can be
>> fewer than the lanes specified in the device tree. The current driver
>> logic attempts to configure all lanes defined in the device tree,
>> regardless of their actual availability. This mismatch may cause
>> failures during power mode changes.
>>
>> Hence, Add a check during link startup to ensure that only the lanes
>> actually discovered are considered valid. If a mismatch is detected,
>> fail the initialization early, preventing the driver from entering
>> an unsupported configuration that could cause power mode transition
>> failures.
>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> One comment below. With that fixed,
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> 
>> ---
>>  drivers/ufs/core/ufshcd.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 31950fc51a4c..10f8d2b552be 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5035,6 +5035,40 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
>>  
>> +static int ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +	int ret, val;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>> +			     &val);
>> +	if (ret)
>> +		goto out;
> 
> Return 'ret' directly, here and below.
> 
>> +
>> +	if (val != hba->lanes_per_direction) {
>> +		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
>> +			hba->lanes_per_direction, val);
>> +		ret = -ENOLINK;
>> +		goto out;
>> +	}
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
>> +			     &val);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (val != hba->lanes_per_direction) {
>> +		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
>> +			hba->lanes_per_direction, val);
>> +		ret = -ENOLINK;
>> +		goto out;
>> +	}
>> +
>> +return 0;
> 
> Odd indent.
> 

Ok Mani, will address the comments.

> 

