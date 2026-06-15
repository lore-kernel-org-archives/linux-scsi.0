Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C85392C25
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 05:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781502683; cv=none; b=LAszfenRapVomIc8zes+N7NWZ4gmtfDme2c2s7o2jlbC9XJBfcFt+l6sz1emsel/T0RbxpMCd8vN4RCjixNazkdJ4YYA322+eliWhhtoZIXSrofCz5fq2KM9ld46DhPL8TCyEGtQGx++Pm/+MYGZUHXLSWKJPYyax4JVUb35GR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781502683; c=relaxed/simple;
	bh=THM7ahWJk71/LoSX2T6Z8VkcVT1plWm6lCU1L7btHiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZ7b5ZIYBeihFKZXWGCWoSpyiUfjHINn9+Zk9l/kZfbpsPdxCqPjwpaYFpgGkQLoo+TOq4swAbFESWHV9AXrxZKNKK+OUZwnuSAoHRNin/wLOpY5jydff8eGkknlnEpRwAiPj/USyQFJWbbAp0cPn+qB1HkNDGRcAnxo/UgFjm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R9li4ae+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EwW9w/c9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R9li4ae+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EwW9w/c9"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F1hrc32727525
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 05:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	13MV5+oGu9Y4QSitcFuhVSklhqqLnHoOgTil+bf8rdY=; b=R9li4ae+Vk/Iss32
	J4asgu/AaZCOoEjhYJJcZCAxfumUZuVwEJGGj5lRbQqIEWGI+lhZO+YPgph48OBn
	NdvFDGou6r/9QhLO1P8YsYDGh5O7Is1G/ZrrUObW9L4NkUeOsPo0MDazKvblf7rE
	zELvNJuMIrvx0z4hySPC7KXII04IWtoI+QfxYLXeBM08Wjt3xZhqskyAo+XpkMkR
	nyNXnhS9fCLVKktQpTmmhnJYBSDxXiH/zvwYWdBFXpE7bP9+bmW7hRg0+RejxzP0
	kow7P6sjaFHLBg9qL/0Ys1JwRLJ5oQFC2XsxeLVtHjaVbjMqMOgjy3rvPm0++9qX
	ofEbTQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4erye15su1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 05:51:21 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2c2b64850easo10542825ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2026 22:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781502681; x=1782107481; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=13MV5+oGu9Y4QSitcFuhVSklhqqLnHoOgTil+bf8rdY=;
        b=EwW9w/c9lSrf85qhKSU3PWQOlJa31q3HQVXx3/w3gQkr4cOMXSpSdctALtDy4dnkfD
         ZpPNa1MFXDq30rDBe07jQWuuDkA7U8htqFGdP2x+wgQQGBuusBKsmJsnSijv8keuT11W
         UdxQx6yLMUf1XiyIGJZJKx+BS/WbDN3mkJZb4ck4V4hKEc0FGnlmAtetQ+U52CO4SbJC
         ZyKWzOfYj7PPx/rY7qp07SMliJvhOrnEBE/p62v6QNCetAiXlP1LK6uJ3ppIZkXlh647
         3jih771OyTdjUI/lHiK/Jv/Wwqm8xMCo5mfJ0TZgNFO1hg4uAzJVPmA65zbuBTFXwsn5
         twig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781502681; x=1782107481;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=13MV5+oGu9Y4QSitcFuhVSklhqqLnHoOgTil+bf8rdY=;
        b=pXt+ldymrRnybZEdCI+0bwwHNCW/Qs6vunrUHSr4/axBA89MXVmYBCUHIIIsJJnnUh
         lHlZk4YdNQaMWGJd2IUz1Nc0HsqOWUsuf1VhGAH/3OmoX13eBIaexbblk7SMnwmkNHFY
         bQtcWiVLjWulf9k2xSU4f/dz/hjMcM82K7oCYSxlHoCUwIJfoiGKlF3d36niDLuLcq7l
         21PzBEl0iXvSBZx7d7z9vPTes2N0Djdpc69/dr4VvUKSP+A2WPRs7wRUWQkT3yR9azh0
         S9WcU/71gOp+pk3LV7xLtZTr/DEkeCTiwhU7TbL5hC9FRDCzbd+BhNyS4XHVFS+xr3ip
         aGUg==
X-Forwarded-Encrypted: i=1; AFNElJ8Mt4OzlW82i5JY83dzcpeX1R+5ipf9hK8exoSSIB2xacScl2dsbmoyoVHc7zWnmiQjl3iRrfZenDkP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6gin1JVy5plX8GZVFvb5qZRaFpgtuvMxxx1fQEJVKRe5WZ0I2
	f8pFS/925Tm13oFd0O6+47+58Dxj5ulMFVba4ansmUUmvCy08VUJwBwW7CBFU/rfJB2AnQFLdvh
	dqX51g+Fpw0k6TvfpaVF4zGSugCGEGJ49sVXdnOhclBI7KuiSogZPw8MtlVmUR+j+
X-Gm-Gg: Acq92OFmUH3i5oNncfnCuVbszhkEVsz9UqT5DlvTKn18LnYCjTH1rMBNV3Qm5mBdnZ1
	PsNoxE1VeEWFcLW4HkeiP34lgrSGxl5YXjdstBcXfck2nfIk76kHXAZ021jIPqSWC/5ejlZXayF
	5d81OzLn1tJ6rJwegRUWtkGncpW+03BpR1Kmdo4ATj0qGX55cTKJ5hu4zI35DE1bUqdTZlyPubU
	21kjUVWOZ/ZHJqfx7avF67FZ07+ruPFvXQofQV0/u+p/WgQ+Eua+EFpLxC8QVKvBTbPl4Dpjsc6
	Z6d/OEvZVvaj7NfOEq/1tpdY3PdYVDJM9xr6ST40xfaXBrFl9J9XpHmvHa6SdYrv/6ochFsqbSh
	K5gH2HRLPoNnQHPFdLsPpBS4bZiGpEs5d+J3++G7JXjjWdS1U0Z0l
X-Received: by 2002:a17:902:ebc7:b0:2bd:5ab:af95 with SMTP id d9443c01a7336-2c664082585mr114141665ad.0.1781502681074;
        Sun, 14 Jun 2026 22:51:21 -0700 (PDT)
X-Received: by 2002:a17:902:ebc7:b0:2bd:5ab:af95 with SMTP id d9443c01a7336-2c664082585mr114141265ad.0.1781502680609;
        Sun, 14 Jun 2026 22:51:20 -0700 (PDT)
Received: from [10.92.170.188] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432c8ce89sm89192275ad.57.2026.06.14.22.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2026 22:51:20 -0700 (PDT)
Message-ID: <1403607d-a277-4300-abe4-56648b3c2a1f@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 11:21:13 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
To: Vinod Koul <vkoul@kernel.org>
Cc: neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, mani@kernel.org, alim.akhtar@samsung.com,
        bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
 <20260526090956.2340262-4-palash.kambar@oss.qualcomm.com>
 <airUb6wT-I-7cOXK@vaman>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <airUb6wT-I-7cOXK@vaman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: eRoM3oqOPBZPurKWFHQ2lvhzacxD_JoL
X-Authority-Analysis: v=2.4 cv=MNlQXsZl c=1 sm=1 tr=0 ts=6a2f92d9 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=YxLorS6-WnmH7tsLkT0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA1OCBTYWx0ZWRfX+yZvPF41wmi/
 S2bRPitF90gkJ9I6rtDl/8E3sAbBNxGocxn2GP8KD8ve151hr4v7XZVfN87nRg4VtRmLBpf/Zm7
 dCUJ61uCyAJiw0jlkeAybYCDs4ElS+s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA1OCBTYWx0ZWRfX4EtN9MhAOHKf
 nkQEgk8oCcz+ZmPaFmpcV4vEoNJAzWpO3x7yMVCFnz6tQmmBBJ+G+uI6J1spZK3MEivZCXwFvmC
 R0c/N1kqqh/8+5pPrsUw9ev9JVdM2pnmxlGeDclHSs4xrRUjjuTl9m9gY+P9k6hBKR7fVlpI8qE
 mH1hX4ntj+qGXudhzm09dVc3ZGJX62nHrVu6AyRd8bu84Uef86wx9yU+Wz7BoGbmw17pNmnO+sV
 HaP9YS/JCVFBsYuvWMR9d2jjFXR7MJeYhyQEzWNzrPSksQ9/veCxb+9xZ2H3aKXPT3PukUZvUbR
 E2d1ldxGoN8c6rzj3iCN1PUZWgVbI9VZkM8E4goxGp63Z4L7VixLn3bJiErbrBnDa1eolK/ElPH
 HT8VoIvFf/eEysW+Z1cQGWYFZO/c4rElKuwpOLfPrBf5czsJoltc963ERAQgaTYdB1Kdz2TsWD7
 7bRmFJD5x1Ajoujq1Fg==
X-Proofpoint-ORIG-GUID: eRoM3oqOPBZPurKWFHQ2lvhzacxD_JoL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150058



On 6/11/2026 8:59 PM, Vinod Koul wrote:
> On 26-05-26, 14:39, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> Add the init sequence tables and config for the UFS QMP phy found in
>> the Hawi SoC.
> 
> This fails to build for me on phy/next
> 
> In file included from drivers/phy/qualcomm/phy-qcom-qmp-ufs.c:24:
> drivers/phy/qualcomm/phy-qcom-qmp-ufs.c:1878:26: error: ‘QSERDES_V8_COM_PLL_IVCO_MODE1’ undeclared here (not in a function); did you mean ‘QSERDES_V6_COM_PLL_IVCO_MODE1’?
>  1878 |         QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO_MODE1, 0x1f),
>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/phy/qualcomm/phy-qcom-qmp-common.h:22:27: note: in definition of macro ‘QMP_PHY_INIT_CFG’
>    22 |                 .offset = o,            \
>       |                           ^
> drivers/phy/qualcomm/phy-qcom-qmp-ufs.c:1879:26: error: ‘QSERDES_V8_COM_CMN_IETRIM’ undeclared here (not in a function); did you mean ‘QSERDES_V6_COM_CMN_IETRIM’?
>  1879 |         QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IETRIM, 0x07),
>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/phy/qualcomm/phy-qcom-qmp-common.h:22:27: note: in definition of macro ‘QMP_PHY_INIT_CFG’
>    22 |                 .offset = o,            \
> 
> And so on. Looks like QSERDES_V8_COM_PLL_IVCO_MODE1 etc are not define.
> Please rebase test and send again
> 

Hi Vinod,

Sure, will rebase and check. Thanks.
