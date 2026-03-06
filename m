Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FAF2F8BC3
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772804032; cv=none; b=KgpiNMJTLIdxDsB9wHixFiTrP8x+I9EazjDdkCfhXJUCQqJZvc4+uyRV4Z1gfxcMjiIuZgTYO7B0W96hrpTzzMQgnoaGO+upQfkm5bvK9DBIgVpz9+tCxCgMuFpkbjX0Y8kTbPaMIeogAu6go5XcNM+9wCpmEzCnGkeWI+RxlHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772804032; c=relaxed/simple;
	bh=g4UsbzvhTYxaAE3At0jVq4iJk4NTD7B2R2kwPJZMhtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vh3Vm7+8tc4zIyShzxvHuKxnDcT9Wygfh6qK7uwB6j6Un7qp7VAecHDEnnkSqJw173SusKGLX3TQu/5fT7UCp2ePjdwCXNCNcelTUSlrrSJ2jnADySdYchyLVirbGUkm+VbE4+/gSLE3Yb204MOmez7y8/i9WWoSwVYjYWOPnAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mo1QIFLP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KuIkbRBZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mo1QIFLP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KuIkbRBZ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626Batnw4186262
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 13:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	czSs8U4CxUNoAoK8ugQbk+91u19ATbbbVF9YOUFqqPA=; b=mo1QIFLPo7Nuw7bj
	4+VrMIaa6f4WE98QFeFcoe4OwOtVaXctE+s4F78yTEk8PDaiJPskfKbUadAejPsT
	zjnjGOYVBUAC00ukXhlj9p1QeNxkhYQV8erQO6JOl6xT8EIdZ2TraIhzVjO2BRWE
	RRxkaQ1qNzidfW9o8kiCaKAhTBCiuR8OGCQMDs1SZD+OxIIH4+x/LDWccIbQeE/u
	dIyjMdwRSA97hhSSd5goSc4gMY+MOYBrQqS85Z4trjU9rQFuDuZ8/frFtfTlUa/k
	KbXupueQra8DOdVFWAf5qGR1gWi5ZrQMZX7fX8mjhUduWX+7UmCt65UszF5j6NBa
	ao7PCQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqruk9h07-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 13:33:50 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2aad5fec175so325343735ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 05:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772804029; x=1773408829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=czSs8U4CxUNoAoK8ugQbk+91u19ATbbbVF9YOUFqqPA=;
        b=KuIkbRBZ3EGDdQTA6eNeH3PknFF7Hr6rjLT6QaOWLLnFovuI/DahZxT4Tnaj5RmQl8
         f489MaKeO0U0FXWWs3BHAC/92qRUO8UPG5raezB1ljhLPudKL16+5ug6gtpypTgMpakP
         Czm2M5j4ufnQtis2n/6IBytw+4Neuso8PF+TurLQzw21pNNxXoQBP8K35uFY1g8XG/GL
         481uL8wT9JctOWXGOQIgR80alUGAefAG1LNOaHjy5sOgPh8BAaa1wSF+CwQRtzorrfpV
         XkTieq3fRJlNSEwBeUf+CAo1D5aeVBKKElpn3bJYRromHeupIuqrjNzIGB+KQ18yf02z
         Boag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772804029; x=1773408829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=czSs8U4CxUNoAoK8ugQbk+91u19ATbbbVF9YOUFqqPA=;
        b=SbTWy2NvBf6ZrHpKF/qc0omo0Hrh/N+P4Q+BgTyALXYpLALcjo6ue7V6C3Khd5XPd1
         dIWt7Iypgdpg8Q/LGI3NTQDYWTyiYuiq6bgzvk4v9Rpz15nrELwCE4vAxmK6dZEukUAy
         ks8ssj1qLsEN07yTBHuXxS/oNKfo6g5dSxvSiZHZQlO7gXLGk1rte/7hlVpPUCXkF5D0
         qsjahKEZLIedn73M1phmYgIkkTXli7A/8CcI1ds9yXIBhaYBSBmV1OOy9J+HTBUWSxKY
         s64TQbW4NqXjh335CsAUO3lyRxiDPW/h1An35AmGYyjbsKiiOGFX1owdwHAD76MOjPk4
         Yc7A==
X-Gm-Message-State: AOJu0YxBh5zL34wsQp9yMXAadUUJWHmMkHlqxfWbCONkG7vBl9rImf0r
	rUrWgf52auoi1bHgTCFfmPfz3dTMxoGnuF3vrV8A00jlXWIVLfTavriXG8PifmykRd86bwvu3dM
	h3gpXbxJgJMh2A4en/bCM7vXRpLwU8p7tlGUHFvlEQ3AAlNiWpdrQB3ie4Ed1g131
X-Gm-Gg: ATEYQzxf/gxl4t9GyTKTMOLKyfrlMKDwGUU70+oNBjUhl7+VL/9Ky1dUd438MACdCWt
	2zM6GvudiUYmsVJ7SzQtuL3Mm4DF4shvYU2F1WFZiXcrdIqHAthTJivA/0FEt6Z2YDDauA+tEoQ
	NDplBe+18qYQqSqsnnAOAHQf8mOWCwlWTGl2SJzzfe+vBNIB6emMEI6nyRWyX3j6K39BsIJb7mM
	bc8Rod3mZWoiMfgAIonYcHLuEIsCUHs8DPbuFuIC97DfdP4DbRJcwAHTUe8bomLFrU8LIi5w/vV
	MdAV+ftru1y/ZJd1GJDcmtXBg0HFZFaLIHQAySN3BAVcQG0yRY6aWHgCpA9tfHQVko4xTEINbDY
	ZkVZVe/rSE//DujRYib/s0Rq7BgkEzFxcJniNVanvSDVg7LMj62bFpJuUiJLiqPj/i2GGPXBlTN
	tqsZic4miJaps=
X-Received: by 2002:a17:903:182:b0:2ae:8077:b1c7 with SMTP id d9443c01a7336-2ae8242d3a5mr25683355ad.37.1772804029024;
        Fri, 06 Mar 2026 05:33:49 -0800 (PST)
X-Received: by 2002:a17:903:182:b0:2ae:8077:b1c7 with SMTP id d9443c01a7336-2ae8242d3a5mr25683035ad.37.1772804028540;
        Fri, 06 Mar 2026 05:33:48 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e57b1fsm28225645ad.12.2026.03.06.05.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 05:33:48 -0800 (PST)
Message-ID: <29ada0cc-709f-40eb-b399-cb870059c831@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 21:33:39 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] scsi: ufs: ufs-qcom: Implement vops
 tx_eqtr_notify()
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-9-can.guo@oss.qualcomm.com>
 <ce70f471d5c6bfd3c6ffcffe9c34a823e7b557b9.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <ce70f471d5c6bfd3c6ffcffe9c34a823e7b557b9.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEyOSBTYWx0ZWRfX3yZIDNLN9vFR
 BSXj4hYq8bKyXX0NGRMdfQo6FAGNitxL/xchE4GI14Tf2VS8mx9hl7rv2oUh8xFkpTGyMmeAXsm
 eBcrJXIh3qFdGkjtvKDsvoFuFrA53vs4MpCSBpY+UgxhDidc4o7YuwnycLDCQwyatlgmg2M9620
 gq4HSJZZWMP9l4QaPppEc+VeW9O2Kiwq1lJCArMvlx7Fm7yYICcZLaqarsq1PWLHX2QrbWDAkvp
 4SQuk3NgvUHPmV5jP1db8kNIfCDk8uTAPceBYayg1KbTSqWYcqXXbmzyDnz3ktY7JjqRboO7Ww6
 oucC2mKKqaMU1zqWpE3nKyvnhuOwodJBEN1sQ+jT27/on8PuOtGYQLeBnJ2UZDSPf/F3XQ6Tr5R
 RRapQBfIrswwf2pl6+neKXMxi6yBFpH5AFbda7FxzpmPYfwtbPW2O9wOVriDcxNy5LH9IivnClt
 kJw3ngrzIlI6975/YFg==
X-Proofpoint-ORIG-GUID: 4qEonoI6d0iiSVYeEsa0s4Mo-POP71zU
X-Authority-Analysis: v=2.4 cv=DvZbOW/+ c=1 sm=1 tr=0 ts=69aad7be cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=kjMh5VIOa_i923LlWvwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: 4qEonoI6d0iiSVYeEsa0s4Mo-POP71zU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060129

Hi Bean,

On 3/6/2026 5:17 AM, Bean Huo wrote:
> On Wed, 2026-03-04 at 05:53 -0800, Can Guo wrote:
>> freq)
>>          return min_t(u32, gear, hba->max_pwr_info.info.gear_rx);
>>   }
>>   
>> +static int ufs_qcom_change_power_mode(struct ufs_hba *hba,
>> +                                     struct ufs_pa_layer_attr *pwr_mode,
>> +                                     enum ufshcd_pmc_policy pmc_policy)
>> +{
>> +       int ret;
>> +
>> +       ret = ufs_qcom_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
>> +       if (ret) {
>> +               dev_err(hba->dev, "Power change notify (PRE_CHANGE) failed:
>> %d\n",
>> +                       ret);
>> +               return ret;
>> +       }
>> +
>> +       ret = ufshcd_change_power_mode(hba, pwr_mode, pmc_policy);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ufs_qcom_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
>> +
>> +       return ret;
>> +}
> seems Qcom UFS driver does duplicate notify now, above
> ufs_qcom_change_power_mode() does PRE/POST itself, then calls core
> ufshcd_change_power_mode() which already does PRE/POST, double side effects? or
> I am wrong?
You are right... I made a mistake when I cleaned up the code. Thanks for 
catching it.

Best Regards,
Can Guo.
>
> Kind regards,
> Bean
>

