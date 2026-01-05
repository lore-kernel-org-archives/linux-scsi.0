Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679BE31159C
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601018; cv=none; b=J5oH9oX2ijahc0gCzVJ8g313tBPD96IkkwDCzp4lmymBr2JXuX6CHEPqbO8dpDCUSl7KsupAgsaEQ1jJBo+8qf26AJu7ukC6QluLRHtqtHlFObZvylZ1zR4OR1z8t24SQU8Hc1131bHQzVBTx7idcaTaXh3NpnbOLWuVF2rXhQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601018; c=relaxed/simple;
	bh=H9aUv+PLL/BVXBiXpLMoneeBQKadXbm8uYfCo/k+wKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wzq+DsWzA41ZDIb9eGaSX4tAZe77Q3vCng3uyaOJ+0GGEJ/IoPIIz3TrjSAkIzDLVKJ18gUKlMpNzXvOT7iWTgQuaXKimCvXuqblg0DNy1n14kgEhvEAg5X9POh+xkccExxXTpo+8ANJ96RKRFVjzKvQSneePL3FwRzc5JeWqbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XbB9k9Aw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TzKjKviT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XbB9k9Aw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TzKjKviT"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604MqZ1n3867998
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 08:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	18YCrzwPnslDtu4eM53n+j4KlC4xTSp3NlQu11JmA68=; b=XbB9k9Awf9GqhO4a
	z6V8XueCPy1PhrktQj/sYEz07Mu2xic3Upzyht/H3t/ZYzp3OfNA3ugaIxhEJ4Om
	ETV5bSTL+M8vFCHMU+B/wRBE9T4KsFgFN5YQiTjalHc1Ykg7akzukbnEjLPiw1G3
	wvQy4sakpoPvKT1E93Y+yafUS+Zx4zJhEUCDw4a7TCvLnbQJuIW7jA53fMwOIwtB
	lt+G2sL0Mko41/BkLMP697zl1byKBAQPcehd+mL3rMWnyH6eEhfa7wmFrYEjtJIH
	6OAuMF1Ilh2Qazy1GnqOOrRgqqZD+MqZ35+6IeqcJyv9QRE2f1Q0ukmcmYanAMt7
	7ssw8Q==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bfyx0h6xm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 08:16:53 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a09845b7faso212275095ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767601013; x=1768205813; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=18YCrzwPnslDtu4eM53n+j4KlC4xTSp3NlQu11JmA68=;
        b=TzKjKviTEV15t3XeLltleVJu+ZYu1e7V0sJ95hkcI4ru2nDAuH7ouC5kPbjkxw2O5n
         Zlr8FVNIfHM87WiLcpzfZhh18yfb/U6+o4AQNrC85Nmn2kGXE2LxYbmt1b2RBI9M+NO8
         /nVf7y4vkgKznKA7ZJ9qk0E5rOne6jIdFNzB3+OR467PihUMCRFnuRVIO8+yFIgFtXBg
         mWVWZvXWiAW1cw+Obh+FTN+MoiK9gTd0xQSO/dVB4pqlQTuQ9xbwcLLdX36pu9G5NP24
         vxW5ZVqbGMxtS+MgCotF2ZuOCZKpulhehOTF9eZNfq8yexvFEBEiEI2XbZJKDTTXN2DJ
         Ojzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601013; x=1768205813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=18YCrzwPnslDtu4eM53n+j4KlC4xTSp3NlQu11JmA68=;
        b=NW4+tGc0+3+v6JQkbHaTvEQmWKD9R7cV/RQmD7ktbp2GeAVah6q4OVckt3tTo1PRz9
         oUJoDdjWYQ9RhPZE7g5jUiRUuiSAczy3Xy1uH/QfrNrUmIQ8bwSsL02WIq9kzP40l7KT
         OIOJNFXlp6IBrNe/oK2hGEFxpD5Xv4Su1i4ovSre/pXSIl25zuP3vPXx40gwzeXjUa5/
         Idf6lUet/n0Y456sLSR/J71+rkCTdxYsADFAR50iTDjB45gPmntrEIkARaCYoQo0Cfp3
         XaV8RFij8eCQ7Tqnbt2WS8cQzfTyJ9t2eYLNatq5shiog7u2KPq5gBATFIrPIv6LGzJM
         OFwA==
X-Forwarded-Encrypted: i=1; AJvYcCXHiWPcXUpp/NI/NBrjoIoiKtSgoK6MAN6Oa5pLN5VQV/+l8T3TdVbuAuh+ObGVkLpy9M9zyXu1jjFx@vger.kernel.org
X-Gm-Message-State: AOJu0YxiuEYKd4zB1iZmgKJYR16fwU7mk3BkErzFjSd1qjrvTLTqroAg
	7RagirSgwZ3U+qdUY88NBHtCfzyfpo4aR/0B6i0csW23id6csjtdHD3SjBs/f0qrvW7Ti8zvQUw
	2H/CLnJVbc0tPmfSFVYK2U10vdudyND3B9ImgwNqMWXrK6Zz8aoaxo9rZ2szWF5zo7J8j6Vnb
X-Gm-Gg: AY/fxX70rxDv0ChDCO/Zn6KdpHV/thG/OEtm/EzJHq3qAQJdtRdp8BUVqlnrXJqKwvu
	dd1XUv4lWNOmlwP+RHUYhgptWXDy5Kwr49uHqU0XQ71djTD+h+3Twq2F12guiRk/FTbaGdPvMBp
	/n026vxvGPSZv4aDpfyjCcEJkp/ga6aezyV+Ffz1TZtvyXxv1IJERwm1re7Idl76oa0gev8Tdji
	IMOjzQAicDIPVsQPEkDDGKYtNDeokPZYInYlRZrQNx3bZS92ua5K0mcTvMugfa4d3S9D/DbwZ/k
	02Wt/h41rY7GgqwYTBEpoLuN542NjbxvU2rA8OTak76RUM1xw6ZjqVO50WurBA9yCJ5sIvEnMpo
	RlJxDNstIxCGm37pr1GSYDBwg0vVvvTvJIVVc4Sj9ZN9O7BHCIMw=
X-Received: by 2002:a17:902:fc46:b0:2a0:9411:e8c0 with SMTP id d9443c01a7336-2a2f272bd84mr472738355ad.32.1767601012918;
        Mon, 05 Jan 2026 00:16:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF47iCpRyTshsyeLrz78/zIsz21oTS5Aj3RsHakwta124JthwB46ioZMbAIB4ET4fXUvBd3Og==
X-Received: by 2002:a17:902:fc46:b0:2a0:9411:e8c0 with SMTP id d9443c01a7336-2a2f272bd84mr472738045ad.32.1767601012449;
        Mon, 05 Jan 2026 00:16:52 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c5307c7sm41443575a12.28.2026.01.05.00.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 00:16:52 -0800 (PST)
Message-ID: <336fff92-c3b5-4214-9a78-56098769062d@oss.qualcomm.com>
Date: Mon, 5 Jan 2026 13:46:44 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/4] scsi: ufs: qcom: dt-bindings: Document UFSHC
 compatible for x1e80100
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-3-pradeep.pragallapati@oss.qualcomm.com>
 <20260102-logical-frigatebird-of-elegance-8abd82@quoll>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <20260102-logical-frigatebird-of-elegance-8abd82@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=CZYFJbrl c=1 sm=1 tr=0 ts=695b7376 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=TyPWlNIwSm5TisNF1W4A:9
 a=QEXdDO2ut3YA:10 a=i6qsmYmKKdoA:10 a=csto0wWSG80A:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA3MyBTYWx0ZWRfX3nE7OuAdOEcw
 D8Uc1xK/j/gu28Ior7WvymaHYiR4nGl1WgkmlCiQZ6V508mOwE0iPcMC0fjJQ2yM5l/AGlb9vHt
 uJSfZ15cLLHk/5tdhoRTrNiA/plNfjdB3jhglHQkaVMIGDSLjXsm4/wm27lETQu1cavo/XF4Dh2
 w7/be2PSqHtfnkzJyM/PNIwMRpqhCUNEjL37etkm59zsaKnxa/J6pelAw5ra1cL1XB3QRhoBjO8
 +/0O0Qx9wr04W7/OA/gg0Sb9buOh06dA/WrRsJfNF7utrnd3MRKwtBndJgozNJfVGzyeND4AXUQ
 028aa5vVfD9ev3hRIC2xwHSfS1IZ9OkM2zxlwrVBHcKW+S8syREH3JenfRw3WW7N3rHbl5+RMaz
 iFew92T3WnTHpaaTj04IVxS/4uv/PH6nKaKEGBI/7aIL5V5ZQ5CSA7g+5u0SUOAxZEVOPGUe96p
 7BwbVNQYf/9RnAixH0g==
X-Proofpoint-GUID: nEn1QGJKsD8JMq2xm5zoT1hD6EoWEG2A
X-Proofpoint-ORIG-GUID: nEn1QGJKsD8JMq2xm5zoT1hD6EoWEG2A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601050073



On 1/2/2026 4:56 PM, Krzysztof Kozlowski wrote:
> On Wed, Dec 31, 2025 at 03:49:49PM +0530, Pradeep P V K wrote:
>> Add the UFS Host Controller (UFSHC) compatible for Qualcomm x1e80100
>> SoC.  Use SM8550 as a fallback since x1e80100 shares compatibility
>> with SM8550 UFSHC, enabling reuse of existing support.
>>
> 
> Please use subject prefixes matching the subsystem. You can get them for
> example with 'git log --oneline -- DIRECTORY_OR_FILE' on the directory
> your patch is touching. For bindings, the preferred subjects are
> explained here:
> https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-patches.html#i-for-patch-submitters
> 
sure, i will update the subject prefix to directory path in my next 
patchset.
> 
> Best regards,
> Krzysztof
> 

