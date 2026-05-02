Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E72309F1B
	for <linux-scsi@vger.kernel.org>; Sat,  2 May 2026 09:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777714265; cv=none; b=QjUIGXYlfQmADC+RJUlqZTed1U1ut9DhDyBjI5xYgii5kT7bJj3IOEs/vIw0GTI+1Bd27d6Q26GFBxuttGZ4tuCkqvB7WHGwWqSMj5qKd0isRg/C0DqztgSK/6GBKGtc2zfS0OCmTIfoYE2cw0lqRTpoPHCIAWnc1HphCZNF3NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777714265; c=relaxed/simple;
	bh=xRX75BknzTHEFfbnlqF9smlvZOl4ja24s2zhWM56E/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIAFGIJOcv0rBy+drMBpyBUUknWxNaLKMGW8Mt96Ont/CcfPg/M3CD219q9CML4lnywEe1dsm3lUqEIvnY3bFSc6QF0fVu4N6uMdTxDBH8UMTqYHwgu3JDyGPxl+Ic1INwPdNXadz0ZRD1YWh1Stz3RhnMjlxqKEKZjCK8ZNnyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S+sNZWvD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LKvIKsWg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S+sNZWvD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LKvIKsWg"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6424CNPq3220474
	for <linux-scsi@vger.kernel.org>; Sat, 2 May 2026 09:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LSOAj4tvsHr+n85jehybKgA/OiJ9DpUJ/wOoBoRMMVk=; b=S+sNZWvDd99c61Et
	qNklkvxUx02qEKPwmz14VBu+Swb2y0XPRQV98LXcvGxRcQ4yQBw2wqSDhu+JHnKT
	ruV7ge3QgsFRPhYEpfGJoIlOnC9Sg6QxnGdotFEb3C46q/FTS7Vj05WkBjFxnhtb
	EvqbqDz52K9rIM3fxV+i20UeAUPn7xhYNxuU/AG9Gy/flZGINhCWYUm8QkhEdPpl
	0GSMFl17JzuuF6OahIShSXw8Qw0JJZAMItmkrkoaLAJ1ISve7b6y3hTWJhYL0hvQ
	90EYkrybQRpVSN05gqp6VNC8JfHOhynRhZ151JEYtZG+C3B0nEeEf3hsJxDL4d4u
	RO5dXw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dwa1egg5r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 02 May 2026 09:31:03 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3594620fe97so6889577a91.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 May 2026 02:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777714263; x=1778319063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSOAj4tvsHr+n85jehybKgA/OiJ9DpUJ/wOoBoRMMVk=;
        b=LKvIKsWgHRx/jCZFvx26gpzuODdjA2nXy19E8hxHP26KX6HcYICHscFUEf4Z8snt2n
         i5PBSBul3wyWehxafFTXSZ7gZWrwWgW53fdDzVkGtFMYu3OCNrNSGhFz7zWB5WQ9Mynn
         s3S2+pp6CvuT+M5kBeYJhKvC2wC5H+sZwKSQ602VrurWp+cm2ND06SXc5b/b3u02jbu4
         whaGXpLHq2Bzl4t/XRvGk2wUh2/muSJFMom97IC6Snzv/AYgVIEKe1bG0fEeDzaLhpw1
         tXZ5BHiRFBPbvaC8Jfdhcl0NTmPzwNF0K7BxR5oI4t+N8ZQciV7e3nNXRS1+vU9tQXAi
         rmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777714263; x=1778319063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSOAj4tvsHr+n85jehybKgA/OiJ9DpUJ/wOoBoRMMVk=;
        b=l3dfzYCRgudAQ7Wccpk7NT6Zv0S6zfGpnHYVh/ympismkZDri1w9r/BvMy6+PjBQzV
         H4Jc8aFA2/wHWApkkHmYiC0j1DLKPtm6njDjnVaLyma4Uucw/Nus8i7XlaAJk02NsRVz
         Tu5HedrRH0kgeTFDuMFjJ5nLvCt94mpY5e+qz31kzz3DGIk/0IibENus8FIIVr7hL1Sq
         m2HUeo6HN3PHKI7Mbkkhm5A+dxfgGsyZHsSXime69Ok9lQ8deuTpC1IZDK5QAE98BJek
         sf7WBLSdyyMB9zD9SU4jrFzhvTdeWrBxwvt0Ul3xUCBF0/VSa5iVjV6AikAt8N1ytNNt
         v3jA==
X-Forwarded-Encrypted: i=1; AFNElJ8EDiQyJztPX1eOYl6NiYfMP0+5b5AVXlmaLYHPqNtXE1zKHdYpUMIpTQyorqq5FRz1qbSSl/Q42cpU@vger.kernel.org
X-Gm-Message-State: AOJu0YyzsTv0ntQn8nHx4h8FFvQvt0h3nCrQMGy5xQ1nkYIqdG6XI5sY
	4QzGM6Vmsju7mst7Sui53wXY1glqCl1UeGVKrIWeDNh29TP6hf0DogHH3WtieuMSELVBk4+xg+L
	UXreHzQFvJxvVokwAkWQfF4kjoI5nhWFbjFCRwMLClPt7UFNl770ocv/ioLNfTya0
X-Gm-Gg: AeBDievo2rOTaVghIB+yucUAT9IXOF68VLsAnOArt1hcGHISvdJMHSW9KWLfOeEzrUD
	xr3gVdQdIA3OJo0FDRMZ/eQ9qDsMxH7f2wCuKH2tm413Sv37xkrKIFEdqApdvXcdHfBbokguaLm
	FYGhlGWIzekzMiIJTd81KfYMGdNMQj3nNrTJ3JNzrRdefPxQAHytuU7Z2xf2Dk5mtl9W28xDAAN
	1NN8kJSE62Jd4EtDDbUSDD6yDix/mdkpW2pmDgYzEGZ0rzOEb25NGZJR/3GPpX4xbrN2wu8FtBs
	txoLzF6Gzan3ESxhbyxHGm8f+O4qrryp0YPpSFxJrQmBg27Hh3tnWPrStQzqvyt6FCssdgcN5AQ
	kxbrg2atExJaVGvLPk7NfeuJWUhk6eyo7DcwugkPQObh6g7Ra10Erg1FX2X3QT511pwWV7RPghR
	JnrFRY4oWIZUSDgFdCcAZN
X-Received: by 2002:a17:90b:5546:b0:35e:5aa5:ae38 with SMTP id 98e67ed59e1d1-3650cdd0233mr2699919a91.9.1777714262794;
        Sat, 02 May 2026 02:31:02 -0700 (PDT)
X-Received: by 2002:a17:90b:5546:b0:35e:5aa5:ae38 with SMTP id 98e67ed59e1d1-3650cdd0233mr2699893a91.9.1777714262273;
        Sat, 02 May 2026 02:31:02 -0700 (PDT)
Received: from [10.133.33.87] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9f0b21c4bsm19920335ad.29.2026.05.02.02.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 02:31:01 -0700 (PDT)
Message-ID: <3f649e2c-c6b6-4547-8920-23886074ef60@oss.qualcomm.com>
Date: Sat, 2 May 2026 17:30:35 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Conor Dooley <conor@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo
 <zhml@posteo.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
 <20260501134418.863432-2-can.guo@oss.qualcomm.com>
 <20260501-exhale-nutshell-3d80a8a2d791@spud>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <20260501-exhale-nutshell-3d80a8a2d791@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: c5W0l3iV1TrrIn-_OGeZlUmOcv0k6Ox6
X-Proofpoint-GUID: c5W0l3iV1TrrIn-_OGeZlUmOcv0k6Ox6
X-Authority-Analysis: v=2.4 cv=e7U2j6p/ c=1 sm=1 tr=0 ts=69f5c457 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=AGT6lJmRVMNxosRiLtkA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAyMDA5MyBTYWx0ZWRfX1xBdTgHV6Pie
 RAs8BAQOGYDlrOAf6Lpv2c/7FDkyg08EEEYlIjtTABhvgOE/qjm0wbXJI6TFN0k5yGYKDERlPao
 v4LfiEdCBgU2sTPmZAopmQgP8i5AxM4pzWDUAtUm6Sec22GwO/b0WAEyizDJ+2K+M11NbuQYxpP
 eG8J2C3N8TIZd6FBK+wwnDSoo6nIVY+GDGeBMYv7QCK/sshyJ9f0/3R4VQe+qt6G3K+XOAVUeRw
 c5ODyMzOV7mL2jvIvLsE5WvOa7zU+/j/sCQlF7PfbXW8+LM09Qc5Yy0yo6NBbblCD2cL1Xm0tiR
 H39PEzc0Mb0vq3oBqM++87usgK1Qf1v3Ed3DcTbfDSV8mCHq7Y4CKtWFPcUccSaPd/PYaFPCnux
 w+GSiy0wUdXNRcxsddk0Lb+E//GxtMjNQOXwacg+U98YpXARuubkSNDKuM84RJCZGSBOP4Ifnsi
 McDlO35QzETeeW8E5cw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-02_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605020093

Hi Conor,

On 5/2/2026 1:02 AM, Conor Dooley wrote:
> On Fri, May 01, 2026 at 06:44:17AM -0700, Can Guo wrote:
>> HW design team usually provides static TX Equalization settings based on
>> PCB board characteristics. These settings can be passed from the device
>> tree to configure the TX Equalization parameters (PreShoot, DeEmphasis,
>> and PreCodeEn) for Host and Device across different HS gears.
> I'm not familiar enough with ufs stuff to tell, but this commit message
> sounds very qcom specific, but this is being added to a common file.
> I'd like to see a lot more detail in the commit message, detailing why
> this is truly applicable across IP vendors.
Thanks for raising this point. I agree the current commit message is too 
narrow and I will
fix it in the next version.

This binding is intended to be vendor-neutral. The DT properties 
describe board-level
SI characterization data (per-gear/per-lane TX EQ values), not 
Qualcomm-specific controller
internals.

The tuple (PreShoot, DeEmphasis, PreCodeEn) is defined by the UFS link 
specs (MIPI UniPro
ver 3.0 & M-PHY ver 6.0), so the representation is generic and 
applicable to any UFS host
that supports TX EQ.

This is also consistent with existing kernel practice in PCIe, where 
board-provided Equalization
data is parsed from DT (see `of_pci_get_equalization_presets()` in 
`drivers/pci/of.c`).

I will update the commit message to explicitly describe this 
cross-vendor scope and to
clarify precedence: when adaptive TX EQ is enabled, DT static settings 
are fallback values
and can be overridden by retrieved/trained TX EQ settings.

Thanks,
Can Guo.
>
>> Add patternProperties for txeq-settings-g[1-6] to support specifying
>> static TX Equalization settings.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   Documentation/devicetree/bindings/ufs/ufs-common.yaml | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> index ed97f5682509..bc83948fc168 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> @@ -105,6 +105,17 @@ properties:
>>         Restricts the UFS controller to rate-a or rate-b for both TX and
>>         RX directions.
>>   
>> +patternProperties:
>> +  "^txeq-settings-g[1-6]$":
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> +    minItems: 6
>> +    maxItems: 12
>> +    description: |
>> +      Static TX Equalization settings for High Speed (HS) gears.
>> +      The settings are specified as an array of tuples (PreShoot, DeEmphasis, PrecodeEn).
>> +      The array must contain these tuples in the following order:
>> +      Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1].
>> +
>>   dependencies:
>>     freq-table-hz: [ clocks ]
>>     operating-points-v2: [ clocks, clock-names ]
>> -- 
>> 2.34.1
>>

