Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323BF2E92CD
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163639; cv=none; b=bZbPKLq5PRk6t9kPYvpKZvEnze7G1eT4uZHgCmpY3MOyXw2XIFiJ0xIIjPMIySG39qBxyNkWAg5c1N+UoTwkcoTAUSYWl1ofrNn2q8wUOZKIIpK5K2nl9+pRlqFfMMokzRAMdqINm9ehWbgtDGwscpDzfjPTvrU3kZ2NYGpawxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163639; c=relaxed/simple;
	bh=Ap12pS/VYNZzi+LFzsVIH4AZ1cc8jjs4WK2JMDR/2pU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UZe2TCV4MWlNPrCxQRsSMkN5bcmTox6m+xcdv3PKIz4oz5ggpeyf5sio6lIGOKBvv0JoeMg3u1kGgSL3VLeshwLUIaPqSlIUWKYeBlu9hA/+VB9My9LQ3CpU0GpAMzO8b8gSvafw2NhNl4zkUnh3xeew/KSia+IDR/l6GkH2db0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HToJcEMP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HToJcEMP"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DNQJZK021102
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8liDg8V8jJXUIuWDLIxvpQ4YE8ananmMfhqXJvLliEY=; b=HToJcEMPQ4HP4wB9
	t1OtzocbXVlWu/n6pFUkjBE+wINPkNrLU3/a3JzVZLWXXPp3bm68JTAVhluBEg7H
	J1udt41fqeIcopO4PQqVdOoXMfOA+kM1vKhJv1hF8WU7qT0166+yITvAvDU0qkiO
	+txbGDmFHuyK52G0r6QzMDYCi4geB8uOweR3LBYfWyMI7xIAuowZcf61zpqc0Eik
	5IYUffPL4fwkverXTj4TgvrhM0DUWMljx6efvouRIZtex4txsHc5buaeV9Al/cYI
	Vin0aTzjd3JzUmk/MBs900b7UwgHPwdncTG96WTa7YQx3eORBRTOlCom3gTYOn0J
	gtOAhw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48dw9syc2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:27:17 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b109cfd1edso2968521cf.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 02:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163636; x=1755768436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8liDg8V8jJXUIuWDLIxvpQ4YE8ananmMfhqXJvLliEY=;
        b=JAfXrtIm5hvCrDCh56ZMHefVTlt963xwZIUC8BEl6oM2M0X6dvWgdEabcLApfhN8TI
         KfABpJbE6/2HEqELOvrExklZYHhQkY5MHuiIDuV84m0i5J7ishX1HCM68wuBoxK55cf+
         N45JmM6KXZBwH96FtoTrfwZSGwwe2xYpnJnzrxRybAqgQOJpJX5XvOHp3ej7N25UkLB9
         KbYI/cjW8xdCOlznxiGJgu3+RsbJVhVxgHf8Nu9aKeLcUd137AJIqEx+pfjTnWGDanWb
         o2tki9OQYC5OBlrSSlFjWGEfK8SRyrWZwyvBblO+Pl7XfFnKEIAmyQS7oE8Vo+kQOhc4
         49NA==
X-Forwarded-Encrypted: i=1; AJvYcCWOW7hb8nsl004tDYeVah/B5pvLPlByaFsrXmBmtIhTCbvh51QSLd9n3mM6wp5Jp7HAKPLt6Mnbovnc@vger.kernel.org
X-Gm-Message-State: AOJu0YzZKOSyuqdgNgYaztViNqRh9mcRKSmZ74Cg9dfQZeng1+z+iemA
	OeoTRwyhIW/jkz0ZupqzLYBpDNUxzxBLp7I8zq9J3OroXaYhtkH8SRGEhgoB/2scda1iBanqOp7
	PF7rwNy2xm2Z1dT/fuJwj5iNvTEDMPcsDZ61LFHun5eEB+aN/0hxgNj/fn46OAgw5
X-Gm-Gg: ASbGncs+OzJf6RbhaZOulLorve+b0RBCEMUEYW+VXNozwjQlVGZ9pE63boeHdk+QbKs
	lP1tEGvyiXkRue/Oxqg8SpsbzvxIkqcwz4cJWT98H6wPbOSCfJ55RWeJVcPRt2YCPEYD8WJPaUT
	xmDOFalATVGXZtY3ouoI6QpI7CU4Q/mqhk4yp2xi/InAiavF//gQO+x4pRV/W6k1yLM+wpqAYE1
	O8btXAMPlMhtG3V27KZEZGoLwSrTzdTwTiJW+lICJMGrtQwIvcfUl+TkPyps3gI1QM02k5F8gIC
	90pI1SIvvxmnStkrka/4u1SjgGPkzRbe1XdA4egIj4YwMeOLpeWpC3Z4dJxcZRS7udJCF17Zkbz
	AqotjO1T1eQ92UlA8/A==
X-Received: by 2002:ad4:5fcc:0:b0:707:43a1:5b10 with SMTP id 6a1803df08f44-70adc06e445mr15766876d6.0.1755163636095;
        Thu, 14 Aug 2025 02:27:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9SwT7H/YCBwkzSO8UzX7j114raEKqqbTh+pISy8oflkO6NLP0NtoNDbBk/MM3LTCvC9zjmw==
X-Received: by 2002:ad4:5fcc:0:b0:707:43a1:5b10 with SMTP id 6a1803df08f44-70adc06e445mr15766726d6.0.1755163635640;
        Thu, 14 Aug 2025 02:27:15 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6176052d163sm17241998a12.48.2025.08.14.02.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:27:15 -0700 (PDT)
Message-ID: <0e1fbd77-b651-4614-adf9-d2f8e66abac2@oss.qualcomm.com>
Date: Thu, 14 Aug 2025 11:27:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Describe x1e80100 ufs
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>, marcus@nazgul.ch,
        kirill@korins.ky, vkoul@kernel.org, kishon@kernel.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        andersson@kernel.org, agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>
References: <20250814005904.39173-1-harrison.vanderbyl@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250814005904.39173-1-harrison.vanderbyl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=J+Wq7BnS c=1 sm=1 tr=0 ts=689dabf5 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=0dJSgm4hv7TTYW4Xl4AA:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: 7jUShE6sB8bRUnAU8Z3LYyljxQq9wPds
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDAxNSBTYWx0ZWRfX1jD+AfRul3ZA
 hotiu2rugUzS+mbRK/x7ZP3XULUEdVp4qOBbT9fl6KmGPZKVWQu8g1xFA3HC3e+dZUKoPbOLdc2
 n1Xth0lfUVHFl6T1nEYlBcKC2f9RkonEJDRcipI7TkZ0OfriU6xrlH4hMq2r66WKnDeZfIz+OpS
 4LTP9yoegsz4Cu3Hq3RYh2U9bABSEeVnUWN4bleKJ59MqX/kRgXUTQiXDmkRETkWhnMc8JXR3Eu
 WGTSi5GjGlAfPW+yJPctkHXQK+Fu5lXMJcd1RdieR4oOz3/BjHDXX/Oy4qRt/CglPkX3eJx8Yvy
 3sMps4fIctBC225a5cxwnK6dZIVWJ/2XVyMB6tgHFKcMi0ZJB1kdCRULp12yCQ3a4o/PXw/KXC8
 4/GxcaJO
X-Proofpoint-GUID: 7jUShE6sB8bRUnAU8Z3LYyljxQq9wPds
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 phishscore=0 suspectscore=0 spamscore=0 clxscore=1015 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508090015

On 8/14/25 2:59 AM, Harrison Vanderbyl wrote:
> Describes the UFS nodes for the x1e80100/x1p42100 chipset.
> 
> This is relevant to the following devices/patches:
> Surface Pro 12 Inch 
> HONOR MagicBook Art 14 
> Link: https://lore.kernel.org/r/871px910m1.wl-kirill@korins.ky/
> Samsung Galaxy Book4 Edge 
> Link: https://lore.kernel.org/r/p3mhtj2rp6y2ezuwpd2gu7dwx5cbckfu4s4pazcudi4j2wogtr@4yecb2bkeyms/

+Wesley I think you had it going on the Samsung laptop at one point, could
you compare the diff and maybe give it a test?

Konrad
