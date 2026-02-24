Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE0B39E16A
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 13:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771939912; cv=none; b=OQnXOJqpfBJNez3Kaa4VC6BjRqrTArUtJuWryrPg9kjBlqV/jmPi923tRrOoIU5YDQ5zve5W97G3h+vAFCbPlBvM7Ba6r9+Bv8dUUNnSdSRnun4oZMSFh49B22xoy1DaN7+jDDDjmGfUMBMu94Fcn2e0gwnHy+uuXhL8pOU+jaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771939912; c=relaxed/simple;
	bh=CyXybCP2CIrZVrNr/6Av/CKn/Tkw5kvvtvSdn1OVQfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAAFRcc8OtsOH30nC19yGNa2GqIs/Fc2s+dOYhBv7CeOx10RGrFHXqvvK8/hel15w5zMVzOnW4+0mZih4lD9bv5xcz7DWbXG6zSvCq60CVpG8+PAz/NHZe8khGJMN5epL5kreLVypy+8nrt1Tjy24FFTerjay46vDtvFVtyuUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Qafm+dss; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xa8UzC5A; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Qafm+dss";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xa8UzC5A"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OAFSnJ3324724
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 13:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gBLQ8De82Wd4XTyosqLd7sRYfu8OUMzWZSMfRzba/Sc=; b=Qafm+dssDOA9e77r
	RCmSPAPd7B86iAhjvAPwtiXfQqXkUbWo36P+TyOjY1zZmBt7NplA/2a22wv2lftp
	VB5x9cv4kVYAO2cLvFV0RSAeIUOrhPtHC7G5gTPnsvH5Axfj6pMIcEzJAQnRe+o2
	ix9+LCzgQOjUr7UZwd+Kbijzr2kwt1ecSidZ7CYzsAvn9Hn6mqVaAj+r/A5VtXG6
	lh6esIMnmd2HdbUTAxTEEC1ZSlmQplPRmad+NdignJxmK1XBgbJg2zGHTWRmCI+h
	cBHsMZYEpXPLdLY3ys1WuWTuVYEmR6z5vGAm41hi2E9LcvW0C1TTdnU6yKCjqiuf
	j1hGSg==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cgn8y4bsq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 13:31:49 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-5f5406916d4so1014236137.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 05:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771939909; x=1772544709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gBLQ8De82Wd4XTyosqLd7sRYfu8OUMzWZSMfRzba/Sc=;
        b=Xa8UzC5AU6kNMCbiB5blOeipvCZ83WDftz9/DInzu2R00qeMJf4XFLcI6oRmspV+lF
         WmIDpr2uilwd9QVgttVF1WgsBJW6OSGhn42VDpRvsC/MhhjDjm5umy3zRD6hL7hOY/W2
         1FO81mgkMxUzHazcfKO2rT+qPNkaBhWSkoqeSLtQuHtRm6nbNUpv+zAwgjGrMgsWSBda
         o3muM8fS/22c7AKa9T2/VyTNQuKEcLANKfIyImvtPW46cuTzdcvXd48fjFXRW6Xksutg
         +S0O4Zk3Vqlw0m2VtWTZx+ywvgv9GuDIvV5fL14mylKfqEFHQd58nyhIgHmXqE2TkfgT
         xyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771939909; x=1772544709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gBLQ8De82Wd4XTyosqLd7sRYfu8OUMzWZSMfRzba/Sc=;
        b=gtcvZrw1Nz7UteuBAbA4gQ2fpph9IJ6h3Jt78xnGIh/bhCbVZrDcmdGAOFDj9/4kiA
         vZtApUQ44UG2Q4Sj9w544dwMrAL3AruFbwh/joltg1XroShex5UaFs4JyZA6DZxB2eHu
         +dVrZLiElbRu5jqgxfddik7Ya++XAruWXgYn9GrG9ynnB8GSpn7Dz/iqcZzpeuEgGB26
         2pUYjBLqdUrcjKS3Y+nLGqH5muS+WJhLJj5IH47FOcshhF6EvmPZ4qgLuBvmKTjRlPSa
         4RhIQYW8ZK5XXWiwZEl8qr0OxAOK+nz02WJFIq6k1NZUGLdQx+0Enp24AW+XXNjSXwkh
         iF+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUh3JugoIJqVxuWWzWU+8zhgoPrzJ3V/3LFhE+DuWkwIk5b0BMO8dOF7wk4xJ8YkzfXVq6Outut4Bb@vger.kernel.org
X-Gm-Message-State: AOJu0YyuNUzLg2P6RvT0m9b4vjkP3z6Sq/PJ5OqQP8ls8Q5JRR5NqgZr
	192Ya7sGS/LtJ0++12OqxzZZRGn9WcQletZGAWrkhgrttecrdpn6585/iheSTmVOsIueD3x5Tyf
	P0PrgYxv2JuXwTwwpMh9w5dUv5k+4c9OaqtbPZLSIALmJ0k8CoKltDkktN5OuY89J
X-Gm-Gg: ATEYQzzpVeqpB9YyrWfphKVq/MHs4DXLoW2RAqVsXINz1a1nbddy5tAY59gx/Jifh0Z
	j4w0UzQtQs/vgJD3egRmqT+fx43ffjU96kTRTtTyeQfUFOv/g10XSQUfEOn+zTjHO1p41rKyKg4
	AdJX+3Gs/fxnmNigq0ztlR6VYocN7c8xR0BnnEgYJvdqQl0NSvmubZ8wpx2yQMYSn/cKcNl2ooT
	Z9GrY1LiD3xTQ5mFNncS31FvqLexCQS5RuL57T2b+Zi53C6jC+K1AjaJdkJ08rWeMd2UP02dABe
	dp8ipZg6TAFH3m/kS8yBzEgMXtRRuTko9s/7UGa3iSiWKtlhWxHwMvE23vc/2HW8Ilof6GNlnhX
	bwKrfcNzIn9aOTFNeMK/B9j2AluVADHBR2wY/gx0KFzFzQL351oIcIr5y328D+ZkWMCEcPBUIbX
	lXX2A=
X-Received: by 2002:a05:6102:50a7:b0:5eb:fc32:9361 with SMTP id ada2fe7eead31-5feb2c1c2bamr2329986137.0.1771939909170;
        Tue, 24 Feb 2026 05:31:49 -0800 (PST)
X-Received: by 2002:a05:6102:50a7:b0:5eb:fc32:9361 with SMTP id ada2fe7eead31-5feb2c1c2bamr2329968137.0.1771939908693;
        Tue, 24 Feb 2026 05:31:48 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5dcb2sm424792266b.6.2026.02.24.05.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 05:31:47 -0800 (PST)
Message-ID: <4bcf1512-a567-44a9-8a38-8976f65c00fa@oss.qualcomm.com>
Date: Tue, 24 Feb 2026 14:31:44 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
 <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
 <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
 <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
 <5bf31bf9-835b-4b87-a4d0-8452d516f13c@oss.qualcomm.com>
 <aZhCWMTi3seAbXo5@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aZhCWMTi3seAbXo5@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDEwNyBTYWx0ZWRfX86361jBbJy9U
 KsEnezjQ5HqGc4z0huOTmEO+HUpaPQIC7wPXvQztyeSlSLqNoHqoHHbzFFalkgPSGtDmaXAiAae
 fpb4tIs8Y/qRBkku3E/GJ3GpnCK2pmTxhxH42LsFiC4LQWRSEjhr0Drrqm6oemcGsDKTfmTSPrv
 QbnetOjucEQbia6DDdbatKHjjG7Emu6zf0vyWieYrwmFNGgRLfCz0wrTFq+87B4dpFlTDjD93pu
 CEv02d75AXv2yOjA7ivrexg1eJ8+dGIWYVSaCiX3CMonaDaVrTiQvs7sP0PU6YKqWULspwrqFx4
 X5VTzqWmPk14ndr8wIkRj5OldfbH6kbp8RleTmb0r+mwVzLEYTzf5/Foik+wPM2ywagEiD0Ipqk
 GyCjUDydvV8TPxw83ISX6XwEWAWWJUD5bD3p7e14EQ643bqnrPlyeCwQYW1xkR6VmMxILHVp8cu
 FLFadIADC1U3ao7CNkA==
X-Authority-Analysis: v=2.4 cv=edYwvrEH c=1 sm=1 tr=0 ts=699da845 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=zMuZoWC4Nr6WuNNbOkAA:9 a=QEXdDO2ut3YA:10 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-GUID: -8I5Mh2tpXs_FWkc4yupHby3Eb1ZlOAn
X-Proofpoint-ORIG-GUID: -8I5Mh2tpXs_FWkc4yupHby3Eb1ZlOAn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602240107

On 2/20/26 12:15 PM, Abhinaba Rakshit wrote:
> On Fri, Feb 20, 2026 at 10:42:58AM +0100, Konrad Dybcio wrote:
>> On 2/20/26 8:33 AM, Abhinaba Rakshit wrote:
>>> On Thu, Feb 19, 2026 at 03:20:31PM +0100, Konrad Dybcio wrote:
>>>> On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
>>>>> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
>>>>>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
>>>>>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>>>>>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>>>>>>>> Register optional operation-points-v2 table for ICE device
>>>>>>>>> and aquire its minimum and maximum frequency during ICE
>>>>>>>>> device probe.
>>>>
>>>> [...]
>>>>
>>>>>>> However, my main concern was for the corner cases, where:
>>>>>>> (target_freq > max && ROUND_CEIL)
>>>>>>> and
>>>>>>> (target_freq < min && ROUND_FLOOR)
>>>>>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
>>>>>>
>>>>>> I would argue that's expected behavior, if the requested rate can not
>>>>>> be achieved, the "set_rate"-like function should fail
>>>>>>
>>>>>>> Hence, I added the checks to make the API as generic/robust as possible.
>>>>>>
>>>>>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
>>>>>> play, but the latter never goes above the FMAX of the former
>>>>>>
>>>>>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
>>>>>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
>>>>>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
>>>>>> so I'm not sure _floor() is useful
>>>>>
>>>>> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
>>>>> and ice-clk >= storage-clk in case of scale_down.
>>>>
>>>> I don't quite understand the first case (ice <= storage for scale_up), could you
>>>> please elaborate?
>>>
>>> Here I basically mean to say is that, as you mentioned "we generally set
>>> storage_ctrl_rate == ice_clk_rate, but latter never goes above the FMAX of the former".
>>> I guess, the ideal way to handle this is to ensure using _floor when we want to scale_up.
>>> This ensures the ice_clk does not vote for more that what storage_ctrl is running on.
>>
>> Right, but what I was asking specifically is why we don't want that to happen
> 
> I would argue saying that, having ice_clk higher than storage_ctrl_clk does
> not makes sense, as it will not improve the throughput since the controller
> clock rate will still be a bottle-neck and it will surely drain more power.

Got it

Konrad
