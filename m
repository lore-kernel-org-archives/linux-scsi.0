Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50F2342177
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772806459; cv=none; b=fVQ6Fl6eEi4sZHAcL6rVkDJh2KJjMlXQ6UA5a5d8XmiE+6sDL4qqE1NHzEXemKb7JRD3o9lf9LvqZb11gLX8gWjFw+pXZabQEsrizEL6Ea8r7X6KPgF2cyMBWvJNv9s8nsuUbKG0fHL85TizZwtCDucvmKq1qIMQFwT6JpaAZIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772806459; c=relaxed/simple;
	bh=XNPYR3m0tXWgerGqPtTIoMpQ2VWLBlrZrmXuNxzZSgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f2XVP0LhIHVfI9d5808vC4n1kqhaN3uJSQWf7gipqeaF8JvnMF56AzTft+ew079eGUnGt1chpw0cNBEgTV6UBTVF9PaO5MgjCjrXxyW3twxazoMsHltLnJtMcuC9QeIe7lzXyfXqY0eB/I0WC0iJA1eHwvYL006H3Q8kTNMd524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NcbHDJJQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CjkhfmkR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NcbHDJJQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CjkhfmkR"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626Bafjc1451166
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 14:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YXGlJMtwlNbzmIK4AsQF7tf4SFG4KHJRxXMi3UOORvw=; b=NcbHDJJQW/xr23HL
	K80Rd9I2mBgtFGG6KsJXj0GBODHAV0rflxvT7L8C5nCUBWJiXlc0zoaDinnMsUBY
	yAqd2+Tkq549Gv4CiHs9puYpOc9ouNp+H5R4Gup76+t4YUPEFA/Mcjrtt0mUp3H9
	/SfDOezBDmkAPM9Y6hcsKrNmFZQM8z83CQn+49TS4f8XoyvuPNe5qQ77X/tO/0AR
	fZgtdF17cN/B+qU5TEQtlDKXt5Xx5C8tEW0Cs39zIoBeLRkvEjxPeG78vG+nnBwe
	Bcd1QfDBBk845dUA2NWujogKmLFZMkjWBRbiK5Cpocsizo5YbA56GIVpFTGrFxYB
	yC2npw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqv9agupr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 14:14:17 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ae5031c6b1so51605035ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 06:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772806456; x=1773411256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXGlJMtwlNbzmIK4AsQF7tf4SFG4KHJRxXMi3UOORvw=;
        b=CjkhfmkRqWXMSceAMVW1j7hALWVJvcBCkvAsHkZKyL8dll11xUkVMyxzTnGXrqzEie
         gs8Xh7PisJiOIBCADQgjWJXTG/D1MRzBwDksDng01hj5uK8Cwe60iU0Q4kla7j1IEvc0
         8GG2Ik+VxFaA4pPhTZyPC0fJXsDJLGgYfrBTuokVp8XdUsIZ6C3CebrDK1TNEOpDhO45
         seJsbTcVj/dmwGnP/4o5jsBmhfaecOPyuB1WY2a32/bBH08zQiMWZroGCkvDJni+laVw
         yhplTWR29uDk+QuDsglHH/4EVioWqFisTEnAv+RmOFlpnLkE3snb2QuS+us1CTnUiGCw
         Pj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772806456; x=1773411256;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YXGlJMtwlNbzmIK4AsQF7tf4SFG4KHJRxXMi3UOORvw=;
        b=MsXaHl97uEEpUyunybGvoiNW9P9rCWjxm5ZE4ZgQcC4pDpuciHkCtQAtdb5AYw9jr8
         RaaCaUm8Ymmj/RZsaeBiGWmfBaNcBEHJ1lvh09kmghL6n2iI7JJTBZkDACaQgbADmDav
         LrLkivkh/r0QS53nW3acxSm5OWpR5lNy7iqH3jK2RY6QLW1NbNYu3lFqEfGk8AjnDiDi
         NakUPSj0lrv4QuxRSOvIp6L0QVuqzRvhsO+8Opw+TfHkJu9v+ab4DrHVZ5STaNCdA2mh
         qGqnZ8eI5Nns8CtTO/rzMzwKCfnS/9Pg8Enu68jg6lSdFe/hDtWwy9Y0B9/WnmGiI9oR
         DdZA==
X-Gm-Message-State: AOJu0Yxe3d2jQxgtE2dQqcINxxIMWsLS32sKCHHGXn4fuUzIZXAMj3FN
	xOzhA1jY7XQJ9qzJ4rxYVgrX42vsNinF6wMWB3rO1S8BodcpapmSfZ8JTGMY2zZ21NuQyIhl/XP
	aed9LLRVz1bxTpE2Y7Mng+DE5O0aVTTAiG5F3Aq+W5uRcSxMKQYf7gBQFBp0hpIqI
X-Gm-Gg: ATEYQzz1wlIMCaqvo66HBsrLvHQMI92euSxyis8ed1UnSgfr3BknDY0SrDd6QLEX2g8
	okp7iUEvPFMDDTm/m1Yzd3GwGmaYIvYJkE9XDvMENe7vrQA1jBLu3IkhbKWXe9qQCAub0HY0KVl
	TxCCwwJe8QhMgLSCqIlBjJXWdLKxOlczCesq3S8SGcRumRgbtTbtoAKJ2+uOeD2tWYg99D2fEYs
	H4MnYGoHetEGptLdB1zr/R8xfk6sYqb+oKJKfDV8Ilbn7kNPmmhou3/zMPfqXnyTtWcfOUJLkMG
	nPVILcXfxOmrfeOVHYOiokTktwA+juzSga9sOtXYdXu/QqBe7OCO0AgW471lV+MCepcCifFwW8q
	5mtPePcmoqkwtDB/S+Wyk7ZInacy+C5XQuU/IiAH+vDCvTMS6Z3cuMcM4jEXSdamgUfkuyLo6Lz
	eu+hjtMFemc3Q=
X-Received: by 2002:a17:903:1108:b0:2ae:5426:da46 with SMTP id d9443c01a7336-2ae82432d71mr25502725ad.29.1772806456434;
        Fri, 06 Mar 2026 06:14:16 -0800 (PST)
X-Received: by 2002:a17:903:1108:b0:2ae:5426:da46 with SMTP id d9443c01a7336-2ae82432d71mr25502415ad.29.1772806455714;
        Fri, 06 Mar 2026 06:14:15 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e585b3sm24906255ad.10.2026.03.06.06.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 06:14:15 -0800 (PST)
Message-ID: <072aa8b3-151f-4b6b-85c4-eb9c9f50b859@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 22:14:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] scsi: ufs: Add TX Equalization support for UFS
 5.0
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <e116e78ad9590f5845aaaf7d4e26833a7a0194d0.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <e116e78ad9590f5845aaaf7d4e26833a7a0194d0.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: K_fEyrzJbGGmfTi6RAemOHwJJ_2_D9cU
X-Proofpoint-ORIG-GUID: K_fEyrzJbGGmfTi6RAemOHwJJ_2_D9cU
X-Authority-Analysis: v=2.4 cv=G4wR0tk5 c=1 sm=1 tr=0 ts=69aae139 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=i1lnRYMTL1kKw9KRX74A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEzNiBTYWx0ZWRfX0bOQ9HlKUhA2
 0vWvd/WQ9CGsOaju4j4+yY+IA0gTUrQPy4C9B2cKBEBaksn+ZToC10NwZlYZ05wgB6unFrv8Vzf
 ntq+mstP+P4kNT1MRDubBfLedu7VCSKKfOM30iKuvNp1+bfyl+7KAzH0uGqvxvFWBBMH8RZ2RHE
 oj0Rra1nuYhAe4M+YRJDbs6CG3ffOLwVS7wMqH7onkLsZAO1a7V+CRBf9583aEL5Cx5RVipdhed
 0QTUTN1pZjReDmdyWuN4U85/B/KvUEzDjAY3S4Bf/aPOC0NE/n8BueH0gHsvd9g9fJHQMvwLQ7W
 mPKTWFpp8BhMNHVkTnv50YGFNqJoksx5fus3Lcd/edIDW9Tes40nESjjOqZP0mVfPheiquVFDw6
 /gBR0nhtJ5DuOEHhrffPbhY77kEtP6/1cf0YILx63Em7Npe3XOZd9IdSNAzmp+2DMaw0L4I+WO2
 ynoqsHIim8PllvGRNYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060136



On 3/5/2026 11:04 PM, Bean Huo wrote:
> Can,
>
> On Wed, 2026-03-04 at 05:53 -0800, Can Guo wrote:
>> Hi,
>>
>> The UFS 5.0 standard was published today,
> Myabe replace time sensitive wording “published today” with stable wording?
That is also my plan for next version, thanks!
>
>
>> introducing support for HS-G6
>> (23.2 Gbps per lane) through the new UniPro V3.0 interconnect layer and
>> M-PHY V6.0 physical layer specifications. To achieve reliable operation
>> at these higher speeds, UniPro V3.0 introduces TX Equalization and
>> Pre-Coding mechanisms that are essential for signal integrity.
>>
>> This patch series implements TX Equalization support in the UFS core
>> driver as specified in UFSHCI v5.0, along with the necessary vendor
>> operations and a reference implementation for Qualcomm UFS host
>> controllers.
>>
>> Background
>> ==========
>>
>> TX Equalization is a signal conditioning technique that compensates for
>> channel impairments at high data rates (HS-G4 through HS-G6). It works
>> by adjusting two key parameters:
>>
>> - PreShoot: Pre-emphasis applied before the main signal transition
>> - DeEmphasis: De-emphasis applied after the main signal transition
>>
>> UniPro V3.0 defines TX Equalization Training (EQTR) procedure to
>> automatically discover optimal TX Equalization settings. The EQTR
>> procedure:
>>
>> 1. Starts from the most reliable link state (HS-G1)
>> 2. Iterates through all possible PreShoot and DeEmphasis combinations
>> 3. Evaluates signal quality using Figure of Merit (FOM) measurements
>> 4. Selects the best settings for both host and device TX lanes
>>
> what happens when EQTR fails, mabye you have this comments in the patch.
This is a good question. In this version, once TX EQTR fails, 
ufshcd_config_pwr_mode()
would bail with error before calling ufshcd_change_power_mode(). But I 
am planning
to loosen it in next version, that is, if TX EQTR fails the TX 
Equalization settings will remain
unchanged and ufshcd_config_pwr_mode() would anyways go ahead change 
power mode.

Thanks,
Can Guo.
>
> Kind regards,
> Bean
>
>

