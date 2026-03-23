Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA80B672
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774245958; cv=none; b=jEHBnYYugvyJVWo637Uqx1empHARM+3VOfTq1G7IiPNyy1VThl7nKfPZc5tCjgZZAq+NlOXez1FiJqqGrCF1ZfDWQx9vdemzskjOWWZNL3UUMlJ59q8HhkVi28AoY60+iJtCswORXVGYCM/RMHkypaw/33VsX9/WUk1ZzkJYLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774245958; c=relaxed/simple;
	bh=X6jm4KTiRkbHi1dA1yIDfVkI9Ydf0i5jJ6kgGd/ES2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wt87vxlPuOg8lC7e4ldm42lvICMfJ5r3sBTd24TD9vhOeiF1t3HUM2n8pObBPyeoLImdCeJfP/Qz42hcHyQ+JVH/HEyrnn5gS/ZCNPuQLTvlr29qmomrkCezjhwd3TqRFRC6dOFrGz/YoQtUc62mLtl7ZXzGDlcFP08uxLiHjkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E2H5cS8P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=df9cB9cu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E2H5cS8P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="df9cB9cu"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N424Y81586212
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VcVMAS/+scRv5IRNW01edaqPJBewwvfBt1i/PmT7i4w=; b=E2H5cS8Pn08nyb7x
	o9+G8CAPVqJL5ekrrUfPRl4rifq/A7afYT+dPHqTzZq9hCVYbOAUy1pl4ITcwnFm
	tzvIXM+o1A+ohjWP7etu5GD4aXhdst/m31bFb/fTinlOpJKxHW66p74w+ZYtSWV4
	64vxyrk6uwi4biwv3jaW0HLYAvnqIAqkC1GM5E5tmNnkCOgyhsXLFy/B7ss/yUOe
	Jif7W2oUmf8xavZezXWJu/2lmawDdoqFR+L6m0LmolXH6O+jH8kh9JVSmfvNHow0
	pRe5E9ldxrD5v50iaXODUiuqr51OGExyZgdos2S37oYjqF1tf1vl6oqiwjttjeFt
	casnhw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1jng3y9c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:05:56 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-829ba0e63e8so2243422b3a.2
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2026 23:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774245955; x=1774850755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VcVMAS/+scRv5IRNW01edaqPJBewwvfBt1i/PmT7i4w=;
        b=df9cB9cuaUTR9yMGO1tEQouH1uveWT50qdPk8iD5kSWOQoEESZvpGjqlqTYs1ZoDqW
         Z8wFazRy1zBPUVsUZIPEFjKKPkqEX5N8/o2lkuvEAGLP+zndXNhfMbmaAgQFHwCAD7Ny
         N6JddXSO+AsKS2PRGHkBzdXlhENPtFwkgpT6IdMnE7oK7JS/mdyHFTqqf7tLZGQ7St54
         7KizC3y9wVcDUOtmbokHuwe0H9a9IZ7BG326eZ3XNLN2tzxKvWXSuVA+IwPQJnFkLOsi
         5Nzv1EWoi1iH2f0der2fEMVf7Ngpx2OZoS1Z+ms8Ysv5mSIAyCnQKp/64p7Ri/i5U0j2
         9AZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774245955; x=1774850755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VcVMAS/+scRv5IRNW01edaqPJBewwvfBt1i/PmT7i4w=;
        b=I3VbU76/Ebtq3A9qR/4B8sBMVBp8t+P+OaT3CLSgSs+gTJD1nMvZCR0tdoyqbpVPyA
         Q7mmBHpWEPj2vO0mSaPpjYRQxZ8Apx2RH5JbbwUYrBOlNF9KPZsq7f2sB6HhzRb+VDrw
         T3qnR6+X+OQvKd/ur1RzgtTtD23UH+HcET5EnlaSSgv7qLUfTwIfEU2R4yXTWHiFyOtM
         +9+HK8wZWRZx52FjQ/UUGx+Uo1nM0nSx1kqB0+wbaBa8XfKcyH8olwQEv0PEg9sNFrlR
         W+hpriI/KtihyA9qxoOLGl7ROQ/NAH2XGG6vmA+hMF2qlz4am9S1weEkMQo7Np8Zjgol
         ZwnQ==
X-Gm-Message-State: AOJu0YwDx+JW49VBhToZIWZTEc/LJn16LJbOubtT/pZW3S22CRjwyQaD
	q/GcLuEXjpmTNVeVNT9ouQd371yZTO2uNxbOeSGftWS1hSPwUL4euvsg4jx4qjHRYnB97UD9zcF
	Ny6GzfHFJohihtuR+b72rMwmv8IvpqlUpUYXZAZZ5PgxkGFPnDTe/b+XRfZUYSaCr
X-Gm-Gg: ATEYQzz64HJxsCfBXpZ4bJCe+OZ8xnmgxFfrSZx97Ax3Uel9EPGws8BWvjEeLdTcbtO
	/Zxx8KWISC9V3nsyqmCXb9NzLn0zaypPxF1Bl9JpNB36HU6FJb82lgbEiekl6tm/IprPJNiXg5l
	Futsx/9Rj8bhPh6y+Avg6USXYs3XLU54zyAgO136Kb7NkcyZwrS/bHWS/TefosAiyI4hF08Kbcw
	UKg4WnNkpWxKhNvAVmoalgWcl5eu+LEDyvp+0dLv9lGTri5SdIHYbWHTgit8u+7d4VTba6zXzF2
	4VgNAybMpZ7LoOzqCKGUf+hfYP4zVi3tW3zcpcVtxlD7hEQeOI+lmH88E3ByQ+ZibHsGGbivZK/
	eJVdchCA/gxYcO/v97mrSTl+opnSYcMvasIrV6XQ6cWW3amdvQ7DwdDwb2MUNDx3gwoXdiiMCfh
	+G0d7p/2wRqsw=
X-Received: by 2002:a05:6a00:a803:b0:82c:251c:4df2 with SMTP id d2e1a72fcca58-82c251c6a1amr6766307b3a.11.1774245955184;
        Sun, 22 Mar 2026 23:05:55 -0700 (PDT)
X-Received: by 2002:a05:6a00:a803:b0:82c:251c:4df2 with SMTP id d2e1a72fcca58-82c251c6a1amr6766281b3a.11.1774245954650;
        Sun, 22 Mar 2026 23:05:54 -0700 (PDT)
Received: from [10.133.33.145] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409b455sm8313948b3a.28.2026.03.22.23.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:05:54 -0700 (PDT)
Message-ID: <011ee5ba-9516-44f8-9ad5-67bbe5d49d19@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:05:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] scsi: ufs: core: Add support for TX Equalization
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
 <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
 <69a998190901b3ec63899fd89de087db9f99382a.camel@iokpp.de>
 <652ce6ac83e1703b720a0402849e4d516abf0f25.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <652ce6ac83e1703b720a0402849e4d516abf0f25.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: iu6Xodx-BrkgBMi4v6gS6uf2ydAXrcRz
X-Authority-Analysis: v=2.4 cv=Q63fIo2a c=1 sm=1 tr=0 ts=69c0d844 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=JCywkKAKIASltTFmSr8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: iu6Xodx-BrkgBMi4v6gS6uf2ydAXrcRz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA0NCBTYWx0ZWRfXwIcEX3mDdOrx
 ECglZgelrkUmeNsSXDV1y5ZpuhvJQLJkXTK16ez5DdEpGuWwi7/ExAlJZBfyEjpfqPYOosHoL3o
 36Hr9QFNWLe1zHhnJrOJI0VdWDTV6k5cb93kza8Z0Wa3OETq5H5qwh7ukGGmeUIj8l6XHJzQdHN
 P7LEYK+n7DeSaaMfovr/ep/OxFXrKT3a5rEEMPqQKK8RbqUdN1pj9lUWT/2kkfnMMxZixL9NFGb
 ydX2xKc4WK1TMEPCOwTZtcMOc0vTwPUIMhXgByXZqYNhnQLXvtR2TYACTbK53Xqo9d4pPtGzGBi
 SJxgXEsfeqwSl3E60txisY5hsQLWBwl9v1AyDoBl4NN6O/Zyqes2c0bRCXS0xDj8QKttw5dDte2
 ox//IJ0rhIwONRdFaVvEQsH85lB6EGRMxS/35khqt3nMrAA3E5+gx8hhCZI7EDN7yWN8A+f4tSf
 WM3sTshlmOr0Nu1rGlA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230044



On 3/22/2026 10:26 PM, Bean Huo wrote:
> On Sun, 2026-03-22 at 10:48 +0100, Bean Huo wrote:
>>> +                       dev_err(hba->dev, "Failed to train TX Equalization
>>> for
>>> HS-G%u, Rate-%s: %d\n",
>>> +                               gear, ufs_hs_rate_to_str(rate), ret);
>>> +                       return ret;
>>> +               }
>>> +
>>> +               /* Mark TX Equalization settings as valid */
>>> +               params->is_valid = true;
>>> +               params->is_applied = false;
>> after eqtr completes here, the trained settings are only kept in memory. UFS
>> 5.0
>> introduced qTxEQGnSettings and wTxEQGnSettingsExt as persistent device
>> attributes for storing optimal TX EQ results across power cycles. should we
>> write back to these attributes after training, and read them on next boot to
>> skip EQTR if valid settings already exist? That would save the training
>> overhead
>> on every boot?
>
> I saw your next section properly positions qTxEQGnSettings/wTxEQGnSettingsExt
> persistent storage as a follow-up series in cover-letter, you can ignore this,
> let's address it next following patch.
You are welcome, Sir!

Thanks,
Can Guo.
>
> Kind regards,
> Bean
>   
>> Kind regards,
>> Bean

