Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05F3264F5
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773485119; cv=none; b=e07GzG5VxbNxNdbU71DlfynHXdt1b0O1qogXh0ibeuqMTudGwUQHSKMhGvL3qG/Frj2DkqVtYnbSS/lzLguQuLua9FTnwfocj6kIvTZTOh/NnKhqIGpt2QOXA1GGFcbP03BbD/Tjann+2mbaqpWWo6bKOHMzroVkhnFVchgZjOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773485119; c=relaxed/simple;
	bh=dhJodwRuccFNd4BDKZQxIQEih20GaEAW40C5OV03+7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rwzOxQYvnwmgSrEFbpen+znhJWjcWRjIeo7UNh8XmIzT5gush0Bk6sjUEmbN8wIkAiVuqNd8ATPIC2ELWMdwVgrTl/NziFO3xB3DjTIOgCItVgcyJp43wEeeLLsPCQBWIBHAqRYe9i5bN4ATKeXa/9Z2Fidjjn0U7ROdrfzxOAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GGHQ6LWw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XJABm7eA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GGHQ6LWw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XJABm7eA"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62E5QORY2995616
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j/zr7LBzIsDcMSBQLBzj1sDvax76GSzWWO1tIUNOSgg=; b=GGHQ6LWw6nak27zQ
	8QkHFTFO0RPwNSr+wzilQ8/yQy8f1BDDfDlm/jn70B1dHlRfmkvj29BKTHdnLyha
	58nShNabBMClPRRgGGCr1ZXfhgkVfRWTCc6j7NSvTxQtVBax9RUcWhaC5DpisQfL
	hF9f9Q3IXXOQ9ICfCiTU4WtL7kwiJY2Gzg6kwRQczybCwJsxDpFxH42fM2w18KA+
	7/kENhJ7SzPeToEcj/M5JcvSiQDQl/aMHw6h0il6ZDIOtUsZHEUt53BrQUawYPqm
	+meXE79CUiGfG6ZQqVWjfr2Llhi8Ex520lKtLmlcrrRMk8+2dwt3dhbCL9XaSemE
	5bTExQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cvyy5gkw3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:45:16 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae50463ba8so250344645ad.0
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 03:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773485116; x=1774089916; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j/zr7LBzIsDcMSBQLBzj1sDvax76GSzWWO1tIUNOSgg=;
        b=XJABm7eApHuirXIlyFnVphxluYTAKBz+eB1qhhooWK0UcrPs7ZDUVq8S0/qjQ3z2HZ
         bMKrLMd3436iRNtDpsuMoC1ZeJtHqWS7h3x+NNDPaGOq3HLiyfooHINLx2LvN1184Rq8
         6s8jRkzox8ZMqaFRlbevs+VRzWN2KwH2qTunNaHZ2jDFjw6F50pC7bqWsZofV1aBANbn
         KcVQpFfXDGqHLQfVr74nc7rpSEKLOS8tv8sA+Xv0oMpBe6gUlbLdVqYG8ktl8aOctUx5
         Kne9GVqja8JQnnSqIcDv+Mn0gzbxZJuojxCsS5ZCwi/pNBQAoeZyvIbW92nZcvgzTVSU
         cRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773485116; x=1774089916;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/zr7LBzIsDcMSBQLBzj1sDvax76GSzWWO1tIUNOSgg=;
        b=moTZjychYyqvtlEn4v01uz0GKgphnazgtHQm9d54HljBeXlpapypvEOJVEiuxTbC+o
         SsxtCSW0gi+tMzWcHFPJcBStwlQLihlxk1hALjMuzxlKMGauaoEoRPQKfslaxP1rT2IR
         NEHS0Uv+mfZhZRVV42bT/A4Jk83+1iHLzofHQybU+n3L4csuMU8Jjm6B8nsmEOD9ogeX
         w1WrIq1cU+0FW7bklIr1Vejuf30jq6RXRPWm3DYneaFp41uF07A1sumvLkb9P6CgvTSO
         E00L4XUMD+IxtE7uyVkHKk3F+9jz95S/h8X50pscOVUEFu+5J4P80utNAiHkm/0xzry1
         o6oQ==
X-Gm-Message-State: AOJu0YzBdNewv3q83J/zFB5r/EyX+BQvh091iqB0yPSOjRw8p43badRA
	DCbpk2rKZsFzyF7meJutEjfRjZDr+gU1pp9Y8Vp8VTdij2dXdohozcZUdTeQavBW211TE/mtN4W
	XNOR9X5/mdcl5IhUQgJNFunnE1WNsD1CS7gqJd/12OYqckpYieB5b4ntjZcg/xaW4D2xKCW7t
X-Gm-Gg: ATEYQzwheGIkD78Tpvx/KczAMSoYCrQTBder0d2K5fl3Rm+Dvf8HOhDh2qiFgpbfI9R
	hm9qbxm2RFbMDdM6w+vyLE5Hof+GAaXJB5KXG1ArjAD/p6oMKh6POy5ZRxW1mkzatOoIkoaQ18Q
	YJpRnE+jCDaGZrynhMPS2pDmoSdSMHGPeYF45s29++GcmNRbJWexh7pHe7NcHEOv83lFu9qGcgh
	PUqyjDq1YpJzgqWyPuEJKrMmzot+XdcAj3+nms6zibFL2FCA1DKwvbpToyqqZaWgDGFnRSQ7Mh0
	m28mWCLak1IqE6nCiEse+Twp2VTqEG0rjU2mAAyRowwLvPBBlIs6E+ZDcP15Bw6vt9CBovhRIOg
	ZJIa5B4uARir1cn2b0O4o1jflwt71MCaZJaowK8mA1RGbteAcexCA5gxyt52puAT1lfHke5K+38
	a1PhIG9LJ/sA==
X-Received: by 2002:a05:6a20:4305:b0:319:fc6f:8adf with SMTP id adf61e73a8af0-398ec9bb692mr6534576637.12.1773485115985;
        Sat, 14 Mar 2026 03:45:15 -0700 (PDT)
X-Received: by 2002:a05:6a20:4305:b0:319:fc6f:8adf with SMTP id adf61e73a8af0-398ec9bb692mr6534541637.12.1773485115390;
        Sat, 14 Mar 2026 03:45:15 -0700 (PDT)
Received: from [10.133.33.24] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb9966d9sm4006273a12.11.2026.03.14.03.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 03:45:15 -0700 (PDT)
Message-ID: <d537b40f-70d4-42f3-bed6-616da2489950@oss.qualcomm.com>
Date: Sat, 14 Mar 2026 18:45:11 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX
 Equalization via debugfs
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
 <bf64badf-161b-421a-a9e6-76e6679d5c9d@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <bf64badf-161b-421a-a9e6-76e6679d5c9d@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: wwQXgCm6xb5y2zNGewDYYWZA3FsQTqjY
X-Authority-Analysis: v=2.4 cv=QOxlhwLL c=1 sm=1 tr=0 ts=69b53c3c cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=xP6uJ3ps6HuU22G6_FsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: wwQXgCm6xb5y2zNGewDYYWZA3FsQTqjY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE0MDA4MyBTYWx0ZWRfX4ovYv8OvsCcx
 Q0pZH8x7yN4z729n831DHnrj3TXh9lCpxf3btOXhzuKEbkoWYoBiou+r93E81whiOYgNv1Gni+d
 9lhbV2e1SHMAGVVs7q9b8P+dC5CT8vM0p/hfMdX3y7ydRuhIlGWqZvqpI28mCJd+2+OJUoEmPsR
 4hK9+hyJohGLhBY9BIDjwjiRfKOfSqZQbTz4cDV1hd86wBOmnMBWljNSihOPS5UG/RpYLaG8sy3
 5OUkheVxBx1XwqiU/S9MQ672zt7bgUfFA/js8W5yL82nkbIROLRVWxyoOnZfsYBUWiP2Twup/i7
 azVw7Xx7/qA+FFiNMI495/sIYS4tQGtekOMFkpaMKrT+4ZTnGeaSJT+QlOKRb08sgWY8mSDKHV2
 jEjOtnyOm2eoYcC1/f4PLq+ldcE7EIjUWPkUAYhNTjAF7xNV7tXJd9i+h21IWCu6+0TC9YB20S0
 oAGm/UuTKlXQWJsG4RA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-14_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603140083

Hi Bart,

On 3/14/2026 6:30 AM, Bart Van Assche wrote:
> On 3/8/26 8:14 AM, Can Guo wrote:
>> Drastic environmental changes, such as significant temperature 
>> shifts, can
>> impact link signal integrity. In such cases, refreshing TX 
>> Equalization is
>> necessary to compensate for these environmental changes.
>>
>> Add a debugfs entry, 'tx_eq_ctrl', to allow userspace to manually 
>> trigger
>> the TX Equalization training (EQTR) procedure and apply the identified
>> optimal settings on the fly. These entries are created on a per-gear 
>> basis
>> for High Speed Gear 4 (HS-G4) and above, as TX EQTR is not supported for
>> lower gears.
>>
>> The 'tx_eq_ctrl' entry currently accepts the 'refresh' command to 
>> initiate
>> the procedure. The interface is designed to be scalable to support
>> additional commands in the future.
>>
>> Reading the 'tx_eq_ctrl' entry provides a usage hint to the user,
>> ensuring the interface is self-documenting.
>>
>> The ufshcd's debugfs folder structure will look like below:
>>
>> /sys/kernel/debug/ufshcd/*ufs*/
>> |--tx_eq_hs_gear1/
>> |  |--device_tx_eq_params
>> |  |--host_tx_eq_params
>> |--tx_eq_hs_gear2/
>> |--tx_eq_hs_gear3/
>> |--tx_eq_hs_gear4/
>> |--tx_eq_hs_gear5/
>> |--tx_eq_hs_gear6/
>>     |--device_tx_eq_params
>>     |--device_tx_eqtr_record
>>     |--host_tx_eq_params
>>     |--host_tx_eqtr_record
>>     |--tx_eq_ctrl
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufs-debugfs.c | 61 ++++++++++++++++++++++++++
>>   drivers/ufs/core/ufs-txeq.c    | 78 +++++++++++++++++++++++++++++++++-
>>   drivers/ufs/core/ufshcd-priv.h |  5 ++-
>>   drivers/ufs/core/ufshcd.c      |  7 +--
>>   4 files changed, 143 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufs-debugfs.c 
>> b/drivers/ufs/core/ufs-debugfs.c
>> index 6f7562846f5b..b3bb2c850ad2 100644
>> --- a/drivers/ufs/core/ufs-debugfs.c
>> +++ b/drivers/ufs/core/ufs-debugfs.c
>> @@ -383,9 +383,70 @@ static const struct file_operations 
>> ufs_tx_eqtr_record_fops = {
>>       .release    = single_release,
>>   };
>>   +static ssize_t ufs_tx_eq_ctrl_write(struct file *file, const char 
>> __user *buf,
>> +                    size_t count, loff_t *ppos)
>> +{
>> +    u32 gear = (u32)(uintptr_t)file->f_inode->i_private;
>> +    struct ufs_hba *hba = hba_from_file(file);
>> +    char kbuf[32];
>> +    int ret;
>> +
>> +    if (count >= sizeof(kbuf))
>> +        return -EINVAL;
>> +
>> +    if (copy_from_user(kbuf, buf, count))
>> +        return -EFAULT;
>> +
>> +    kbuf[count] = '\0';
>> +
>> +    if (!ufshcd_is_tx_eq_supported(hba))
>> +        return -EOPNOTSUPP;
>> +
>> +    if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
>> +        !hba->max_pwr_info.is_valid)
>> +        return -EBUSY;
>> +
>> +    if (!hba->ufs_device_wlun)
>> +        return -ENODEV;
>> +
>> +    if (sysfs_streq(kbuf, "refresh")) {
>> +        ret = ufs_debugfs_get_user_access(hba);
>> +        if (ret)
>> +            return ret;
>> +        ret = ufshcd_refresh_tx_eq(hba, gear);
>> +        ufs_debugfs_put_user_access(hba);
>> +    } else {
>> +        /* Unknown operation */
>> +        return -EINVAL;
>> +    }
>> +
>> +    return ret ? ret : count;
>> +}
>> +
>> +static int ufs_tx_eq_ctrl_show(struct seq_file *s, void *data)
>> +{
>> +    seq_puts(s, "write 'refresh' to refresh TX Equalization 
>> settings\n");
>> +    return 0;
>> +}
>
> In the above two functions, since the standard uses the terminology
> "TX equalization training", wouldn't it be more appropriate to use the
> word "retrain" instead of "refresh"?
I chose 'refresh' because the code conducts more than just retraining of 
TX EQ,
the code also carries out a Power Mode change after that, and only by 
doing a
Power Mode change, the new (optimal) TX EQ settings are really used by 
both Host
and Device.
>
>> +/**
>> + * ufshcd_refresh_tx_eq - Retrain TX Equalization and apply new 
>> settings
>
> Shouldn't the word "refresh" be changed into "retrain" to make the
> function name consistent with the one-line description of this function?
Here refresh = retrain TX EQ + a Power Mode change

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

