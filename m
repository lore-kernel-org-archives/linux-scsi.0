Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DFE30F95E
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767157069; cv=none; b=RxcA3VPfqG2EmH933T/JVCBIxGAuwXpuczAWNw2lsqmtbQEZSTq1zuTqMQ8DbE8zPBUdyY6nMp9m3jqT3gz1tizFh0/lgywCK/P2q5vDYrEkmmxkpgfoJfn+wx7GJB1/BPKykXQzmdJ/TRGnV9vUWeTTNVwFvvUBAWm7jfGEHRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767157069; c=relaxed/simple;
	bh=11N6OQSNY0NxVICl7jq5B26SLD+8RpI05xpjBeX4ZA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYOgsGimcUmPVU0jNcHmdehpAjI/Om6SbufYR8mwBpmRbTM0BNJC7OEdetXgWKTjtIxZDu8iik008UxlilJGclE/JBlbNwmU95tkUq7xr4r/y7xZitWVx1tK5dfW9dByfSQc1+rr4lcdbFDAlEW32xculLxmQFBXvqFlThxQiZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CkwBUE7/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HwdBfMHN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CkwBUE7/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HwdBfMHN"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BUF9lIp900395
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aQSxS2/0ehc5s3u7Quzvg5mR1THJreuz1hnz19f3oio=; b=CkwBUE7/Pv+MF65J
	zy9GbRmhNWAr0rQlgVE0atsSuxNp7QNySBupzf0tcRChIsLpUlh7cDPQN40di3Rv
	0YR9WI4NXk8ejojJQCJKR6SkMnBOtZmJvyy8hJN+1jwgsbiXxi1S507uoUNthhvd
	VKlyVj3snxXAfPS6OsVdfsxLNHK5l8X8tl3/bRFooNKv4A9CfUD1j3oO2e2o8LhD
	Np0gZB5zQPVu+emUxHo3Re+b1PSRINW0ROSYupWim1CQdS3UCEimhV3alUjV6Q+S
	mtoOqxzL3FO9bhcdqQJanEl+YWhSGbhgcjdyJdXEPvEJmRzoY9c+5cFeisA81SlX
	bkEcsw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc8ky2pvm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:57:46 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so11936080b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 20:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767157066; x=1767761866; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQSxS2/0ehc5s3u7Quzvg5mR1THJreuz1hnz19f3oio=;
        b=HwdBfMHNgOg9ltd3PjKl5PeMs8oPJvEQpLnJUqN4m5noebtujgyQlUzlsiPL9qJjas
         meiLJNexnwO2RwRPC+mdhCG7Q6ERgAJMas7P/esynV36f+xILSZUJZKE0M679U1W8nFx
         PvFGeYsX2r5o58w5uCSNkE8xE06KUBWmIfq1XlpPg7uJMqnrwnqwlWMWvw/hK+quBqv3
         9eptOBSSw8gqVZvr/ZILM8AKj9Ksq8YIl7hf8oYfcSqPmVOf8zmMd3xhVj84spb2q9YX
         dkpnLRce0KMwPOZq/uOx9DkITFIy65IBcwR7E1VL7JV/jVWUOWB5OW65YTZQ8Vc4WIyk
         RYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767157066; x=1767761866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aQSxS2/0ehc5s3u7Quzvg5mR1THJreuz1hnz19f3oio=;
        b=Ah1VqRoXeTo7Bw3e3ds+XF/zwnIygfMXY5koeTbdgAF5A5wyX0AnLbxNx3dFl3jLXd
         8c4RsPK11Rnn9DZ8Y+hB/MwA1bJgiKpa6nevCqtoZih673gKvpcLy9yrqrX7rkE97Rt3
         UMcdNi6M3ANclHaeUaNGGBZa63MYBARW3VVKeHucFCl83FmbdgIZp5gLyZCW7iHqSZhT
         66VmojZo42cS7hOgQ+osTcSlxiQU5W1O/YZjtVtPW8XSefELNLzMb0xzGcnNwnkKua/q
         qU50A7yP3NnnKrbH0dK5d/RrtB5pt/I8WYYKMJdODE63u8M84i0JgfaDt5ubx3ggTcjx
         +lPA==
X-Forwarded-Encrypted: i=1; AJvYcCWCdJNSs/HcAUwtOpfL7vceD0cTxKlRM64oVTIpWY8vc/JfQnrXyjTty8b4ZwoozjlP0b/PNKu5tJgN@vger.kernel.org
X-Gm-Message-State: AOJu0YxucH5TMJTF9+rElv3D+ED+AaU3Ki0a9Omkcou0uZMsuYskaAaC
	OMa4HQaesNOaX7gnesABquAaGh0T0VXS2KITP/QNz4VQco+U5wqPHV8UlCZ989k9K5NnQPl1DWR
	EtNYhVI0vCWEpQ1tfRdtrfgccDsZgMw7uITICKRuXVbNZEVDDovRdBJsK6+agFIU+2GMkic4x
X-Gm-Gg: AY/fxX46qIyePlAz79ioMhfLcXhx7QR1Ai7NaaON+60Q5TF5pWVqNKdJ8CZMDLGpyg5
	WZld4bCcaINePX3WoIKx88+9P3H7tRK+Ljat5BUYQXN/g7qXBnWwmQ7UhwknvyB9m62tA/FPx+m
	kr+YyF9xkQj8t23bHKmrutR0KMa/YGLp23Pc70I7/hnWAxsVmdf8t+6nicBvX29YvZChwNBtprT
	joHZ81JBDbR2fay3zlkqy3x2nWRPIROFv75MDhbNJpeBsaUNEoEXooXStNljS2j7qKeTiMUh43t
	ZfKRyfzVuma11k4xnb2v/RPXQ9S0tcDSkDIYht7bjwqacFLf+oKUoTnXvWy9eHV08nCJS52Z3fr
	blQ7fgSNgp0QS/2aNviSCFuIdjIPja6qyvgMRE8mj
X-Received: by 2002:a05:6a20:e210:b0:366:14af:9bda with SMTP id adf61e73a8af0-376aa6eadd7mr30887179637.80.1767157065631;
        Tue, 30 Dec 2025 20:57:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFAvdaLtynEVCgaHZvw4QTID0gtW8i8EGlr+lVjjbmIhEK3xWUmcfReZ38cA/yRJtjHo0R8EA==
X-Received: by 2002:a05:6a20:e210:b0:366:14af:9bda with SMTP id adf61e73a8af0-376aa6eadd7mr30887164637.80.1767157065180;
        Tue, 30 Dec 2025 20:57:45 -0800 (PST)
Received: from [192.168.29.239] ([49.37.133.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c7263a3sm28803816a12.32.2025.12.30.20.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 20:57:44 -0800 (PST)
Message-ID: <c0e654d8-bb4a-4d4e-9d67-3664e6ea0aca@oss.qualcomm.com>
Date: Wed, 31 Dec 2025 10:27:28 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/3] dt-bindings: ufs: Document bindings for SA8255P
 UFS Host Controller
To: Krzysztof Kozlowski <krzk@kernel.org>, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251210155033.229051-1-ram.dwivedi@oss.qualcomm.com>
 <20251210155033.229051-3-ram.dwivedi@oss.qualcomm.com>
 <3813487a-4618-4c14-9536-cc9f721b12d1@kernel.org>
Content-Language: en-US
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
In-Reply-To: <3813487a-4618-4c14-9536-cc9f721b12d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzOSBTYWx0ZWRfX47SF4pAtf+so
 U8XzLNKAi3trj+2Zd3lAzV9Eg+BRG5YfaeqX4ufah8P7r5jWu0VpBF6sVduZYRfLJHdI2K7cN4c
 8fRvxWNwV3FV29RjycKLpiyDnrgL2i0Ia+kr66vEmy2OxSR7D/C9UE4mwlY5M61phIFZTTlXKDq
 QXlLwVWHD1IFQCzw5hTgnoVUWqL1ZvXRnKctGsSzzYIq/26t95+kP6ULyeWuflrGxUIYdqZb/On
 2aym3ueLBYcYcFen6b7BQErGkCfe0qsmgheE16xn6vH/eKwjUtPDQ1sbmQkgV/Z/HRJpMbbbyM1
 hNXnX5aJMqjzv3XU+IiWs0uR0dk74lGkjs6iBKXIansbTPrs4FFF0TlQZ7tJKTk3ADFIl8LF0Zs
 omuV9N390+L+WXYtRBh528hF4L978F7+ShBmeB4u3ZX1LdwGHikAcZJGsD5tCjTeLQdTE9n2OKH
 NbATnBtgMW0PsOXBiHg==
X-Proofpoint-ORIG-GUID: _gWkhmD0ViNHVvpHCwbxePM7P9hqlM_s
X-Authority-Analysis: v=2.4 cv=BuuQAIX5 c=1 sm=1 tr=0 ts=6954ad4a cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=+/UKhaqxHMWBDOh8pPecxQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=2JRC5SQJVUo4JS4EESgA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: _gWkhmD0ViNHVvpHCwbxePM7P9hqlM_s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512310039



On 11-Dec-25 12:04 PM, Krzysztof Kozlowski wrote:
> On 10/12/2025 16:50, Ram Kumar Dwivedi wrote:
>> +
>> +allOf:
>> +  - $ref: ufs-common.yaml
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +
>> +    soc {
>> +        #address-cells = <2>;
>> +        #size-cells = <2>;
> 
> Not much improved... Same comments. And if you repeat "we plan" or
> "something else is something else" than answer will be the same - that
> something else does not matter and we do not care about plans.
> 
> By useless disagreements you just postpone the acceptance of this
> patchset. Especially about such nits... patch could have been reviewed
> already :/

Hi Krzysztof,

I have changed it to single-cell addressing in latest patchset.

Thanks,
Ram.




> 
>> +
>> +        ufshc@1d84000 {
>> +            compatible = "qcom,sa8255p-ufshc";
>> +            reg = <0x0 0x01d84000 0x0 0x3000>;
> 
> 
> Best regards,
> Krzysztof

