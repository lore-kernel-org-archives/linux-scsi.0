Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069F2FFF8F
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 08:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767085131; cv=none; b=Kwo+52FhYS5VbAUpLzj+lN2oZlCWV8dbmqP3PZ7VCLAKiImk38Nq2XzIdNk9PufeH1kc6gh7gW0/k96FB0AO/B+m74dxi8NVctb9I2dmoIF4NWV/0NVkl2Y64wc6KmdOh/bosy8t+2z7IzTz4shZaZhmUFtW/wtB5uOkMzPjIYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767085131; c=relaxed/simple;
	bh=BhHOI7iI62+sqCnJnry0iDrBw02bx1UkNL8hPMV48oA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4vFZMN1RiyMwylJeSmEva74VtPMj/O+E6ShkiHwdx2G9h8edlrpBNguf3Z+UkvIEHXiFTHDVC96jRPi+GM526q49zaH/w905iGttkwro95h3YqXkf+469wEuyVTDMt0enJlbW6ui2ME7IQMITKbt69cnekUdsq+zP6VGLwsTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZQfeF0np; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BLAFId/b; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZQfeF0np";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BLAFId/b"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU1m1333818203
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 08:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZzRRO2mFcfrDlhW44h0g8PE60DyJAiXEqmg+unBXdow=; b=ZQfeF0npaiqCdEA+
	J/qlNaUYemTyvc6X+1TVFQ3uN2Kl+G7GZnITM5F5kSYh0gUhbA97xclccUTQEn39
	BH5rZvr1A2CiQmv/Yq/26LzlYVhbJf91zpVsHX0aGIffDD69nUllyxNkgb+25iJH
	S3ih8hZQluM8fIYQuxgpHsxMBk6qyyf/Byigu2w3x/zcG6nYMySXI1hAVqye8FZR
	CdE9B8wdl+916/ANniB2yuyDnxe0GwScJe53tncGsepvMXsd3okZAvZ5n6frWQJH
	5hIrmyACjHTUGzVoPd2+PtRugFzoJw+Ea9Sp0qwPVIa0h+mqCDVV7WsAXQm19RZ/
	//zPzw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bbc8yv02w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 08:58:48 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so11209571b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 00:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767085125; x=1767689925; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZzRRO2mFcfrDlhW44h0g8PE60DyJAiXEqmg+unBXdow=;
        b=BLAFId/bQBCUMS+rk/4rgT5ksnSoJ1epfkgN7MzqEqdc82qaYiDpbjjbt8jTmzMo9W
         cCOM/zGALqGkuZVkAZ6gATesEdMejJo0wrFh9IyI59ymuRfR8vpb4bE6u6mO4RcgyPON
         CzKTC3YMq+6CT0+U4aBKQRAAF5AFnjNlv9s6qKk8kqLLZvujMBH+z9/29pozWEDSeVS6
         tS+k1l56fRUzCTA738BQy93sTPLPoBAxv5Sdves3byMsI9Zoi4pwQpejLz/hDWuVJ7B2
         I/BsTG/Q1fluH+E2N4vm9fMS22dfJWQ8BiBmzZjJg06i3zAZmadPfKEjaZqPddYlLkXC
         sZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767085125; x=1767689925;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZzRRO2mFcfrDlhW44h0g8PE60DyJAiXEqmg+unBXdow=;
        b=jrBfYCdY025pKXlCRGeKTPZ2I46gmcEtJLJlMKE0ItooKo4FHiF9IYg6L7lHjbT6dA
         LgIFTvLn42xvSZlHur8EBxJSvJEyl/5lKXbm0emBrR5cWKGBKbLl6z8axWVKRu32qjuU
         hlCxPsFfAKhkfpFe7CI/Q98narpYV1RUCQ6GqZSTd8jbQyOrghDsE5i2lXpndz1X/CRG
         AnUnrwSiN4plqAYm31cPrnPTW4fODT9eNwX8chVZ0FOmykpjYt7OiH+sOsHJKZVB4O7J
         98JaG6SzYMLEhlpSSV4fXr2ysqkEriccXGNyZLRMGxLR+V1FDXu2vMjtZJXo+53qq1jt
         MDNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZYl/AWodfgbTnB+kIsQx4XlK97sqwAQ2GF/ytBNIvr97Ug3aL7Oo23P4z8cEBJ2ec1APxhtdTnvvy@vger.kernel.org
X-Gm-Message-State: AOJu0YxXPNhEAvYT52AfhfWj58fRp+/c9m/suFBACIg2o6KySU0LGT6K
	50i0a+vaYP4/3M09oXsEKW+c53IqtvGrFBmz0cWn1y/oovAs6j0c2PRDB+NbyfQGVTjKWqPPNyD
	O3M0g1cXWejxtoQatGMbc/AUG7fGhSmcvtPZSb1UxUAtoSQY+G9FihdTrIS3RH3tW
X-Gm-Gg: AY/fxX4ESdya30wyPlq75OItMs58cbJrI+o8ZdByKnrforXkWvSsjnhZdSDwdxY2Um3
	MvuwlvJ4rI72Ae+pD6wKX5grqa9SyCaDeLCyaRal9Ez3HxHqWtXCgMn/GGxOwwHuwl75C3DWB/x
	qg4PDY3o9pATOQxzE8huMQOy2zgLlD4G9GNxEDtculWuc1CCZJqI1ADwcJx16gb/Pd9fTPQKMJP
	D6OoBWjhkLTUmojamwgVJrn5PvCtUeRdCK6PEUlwmHbCC/Pktp0qbJjbtGZgSj30ufktJxT51Gz
	UjUEG/4RAosSSKuOc6HKuHCOSTb+LIC0Sh0XEcus0ul61rKhnPU/rwPKMJ5h/RQjdupBZE1166b
	kR6GrtypScwpHgd/57h2maLCx1thwSvxDQ3wIk5EZpAF2fapWyAc=
X-Received: by 2002:a05:6a00:2a0c:b0:7f7:6229:fbb5 with SMTP id d2e1a72fcca58-7ff655aea1fmr32215684b3a.25.1767085125512;
        Tue, 30 Dec 2025 00:58:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGa7RsFKxyM4k21LTeY+dre+G2lOAepGj4bj7KAmTkd98cHy7Z6N3u51V1b+McTti/W7cVjig==
X-Received: by 2002:a05:6a00:2a0c:b0:7f7:6229:fbb5 with SMTP id d2e1a72fcca58-7ff655aea1fmr32215664b3a.25.1767085124989;
        Tue, 30 Dec 2025 00:58:44 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e88cd71sm31685097b3a.64.2025.12.30.00.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 00:58:44 -0800 (PST)
Message-ID: <a64f088b-8509-40cc-9f01-23c8b87a8f3c@oss.qualcomm.com>
Date: Tue, 30 Dec 2025 14:28:38 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-5-pradeep.pragallapati@oss.qualcomm.com>
 <a33f5b15-d574-47c7-985d-f181c4784b98@oss.qualcomm.com>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <a33f5b15-d574-47c7-985d-f181c4784b98@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA4MCBTYWx0ZWRfX7MAl/mfppbdm
 HtxUFsFM9dsf5p+aJF9ZzcrWmF58tvfaMk3vD2aZRLgJETUTMu8UDReVyT0SCm7GGwioIFbvUal
 Ttm50p5Ji0jmw6BDHesCDChKlCivN55kMXWwx/G3mcg4kGK+96xpZBccKhVl93Vsxekoex6nNMV
 h/vEO4pIroxiUOz9ohkTEg8+MIPc5raYjEqaT3Wli/QtYPkqIkm7+ROWlSmNopn6lS4EODh+zr9
 HMWJrkn/07KVPYQGLd3kvL0vHamW13HiinLtNYfSrTuqkqRO2k+8sD6ocWS0stGX8K6Fxc3NIKW
 OctT2gzBvRgjFbiMcq/+421BghwTMfwfTStEXf66uq93vtOvzwnSB+Wd0S3f6CZJ2k0ZRO/AfWF
 5764EFgU0DSjQEOA2XbiYpvPiVZHfGK7w86mVyc6OPMzmF+qtIPMnncES6nQajhOJI+l2XFBdO1
 lZntAmFk34yupVii8LA==
X-Authority-Analysis: v=2.4 cv=cP7tc1eN c=1 sm=1 tr=0 ts=69539448 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=a9xO4-qOGlSrq4zDlYoA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: 82HLv-SHxmDzUjYCmB5jRyvk525HZpex
X-Proofpoint-GUID: 82HLv-SHxmDzUjYCmB5jRyvk525HZpex
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512300080


On 12/29/2025 5:47 PM, Konrad Dybcio wrote:
> On 12/29/25 7:06 AM, Pradeep P V K wrote:
>> Enable UFS for HAMOA-IOT-EVK board.
>>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
> [...]
>
>> +&ufs_mem_hc {
>> +	reset-gpios = <&tlmm 238 GPIO_ACTIVE_LOW>;
>> +
>> +	vcc-supply = <&vreg_l17b_2p5>;
>> +	vcc-max-microamp = <1300000>;
> I think they should both be 1.2 A peak
>
> Konrad
This (1.3 A) is as per Hamoa power grid, which is same as SM8550.
>> +	vccq-supply = <&vreg_l2i_1p2>;
>> +	vccq-max-microamp = <1200000>;
>> +
>> +	status = "okay";
>> +};
>> +
>>   &usb_1_ss0_dwc3_hs {
>>   	remote-endpoint = <&pmic_glink_ss0_hs_in>;
>>   };
