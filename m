Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE0E2FC02B
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 11:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758801362; cv=none; b=rxuO0dQtC+9YMJMj0TZopjWAgVHp2Q3N4a2mPzQ2vHB/MQ5Dwx/9Bd5aogYMjDjm60nlaTH9EjTiwikswk8vLyAmIm9wn0aBZ+kj+Xb2mNm91uwl22a7ItG6GD9Bz9zOlhT4bBftMNXexXzD1ovxItOpLV8/nPpertOS1vWu4GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758801362; c=relaxed/simple;
	bh=yl52+8t16PBY6bibfVojwBzJQIRHVSQe2DfRABhpTfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fmPMfsYakn1rZZZ7b+BxM1afIp3mK86RZuviQxvWw2yMjuYMZca8yJPSRUfwgFdGXA/AZxyyJToCqdaE21UW9ZDn65GnuavnHehiV59IRNI90gy50kOsnpT4j7M3ZxnMasI/q17LEqs9QoLKLnciX2idpmFkIG0lwehBVWcHb98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ghK7Gy6U; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ghK7Gy6U"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P9XqB2024010
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 11:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BGho4vei24vHpadg3iVDOtkY/sdrfcEeDXVF20xwVL8=; b=ghK7Gy6U3dP69nus
	K1EkoylRUWcWiCXq0RJWUTUIDslnKTYIHtym5SsrlCV3DqbpJ0wmWG+Qwox+Rkqo
	RYHN7hqkRRN0CgBNpntNwi4aqvODBgLrJ9YOjIYqZRZvSWzL8cLJnNbbS36VvlzJ
	Emq8L3BY1a0PDv2NF3CvlLZbHu+MxBTVzEz7tSbBUWepAP9McKfal87L3qLf3yyN
	bJ5B3haiQ1PHNUle9LGPf90aKlFbeRvadOQLjp9ZcDnyvee23rnt5jm0mzWKbnR5
	t4ms2exDANoscV2QbpvVNnGKKtBtDa6zHwFDvhNgu64wwQ6Do9ARbw48SbsF+eaC
	NXjFrw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49bwp0f07j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 11:56:00 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-7c51f566163so2516506d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 04:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758801359; x=1759406159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGho4vei24vHpadg3iVDOtkY/sdrfcEeDXVF20xwVL8=;
        b=i1BaASpVA4Qm+JKVfVllc1qF4QB9Zo6bkyKaJehidJv2vYUHXVR52BjfiZ7+pwBhTO
         ARPlqQ1YO6H2KkUjGXypkblTSRKPcrDvZNMcJyW0tJq5mgeUsk9wUcoG08mw/RIM554f
         tD8r0LkiB7vps0/HCDqypWmRkQkwqHraStAdrHwwZoFxfEh6kpJIFa9MOB8aC9+FD2ME
         zHLVzGVK9pdYDREy+vgu3RS6L9p3CyWIs2dZSF0bDBdKE46TQB6jOGbUbl0iieXVHOPC
         bgdcS8IGEafrnbQngnTR0qntDKkrjz6dBthVJNK70i0OsB/FifHhBDPxfmIe1TlI0+zz
         tyTw==
X-Forwarded-Encrypted: i=1; AJvYcCVJe61VA51AOZ3NBg8qnakKRgYHhQEeDnzSbo4rdaA0X2TthHbAzJNmueVWJyrtP8usn70N8QQ0HJbN@vger.kernel.org
X-Gm-Message-State: AOJu0YwBSrJ05qPJ9LLgzAhc7dnNHjvLjjvj0uFA6gQYTJZRMCvcRFgo
	ZJC5EnoJeCpcNUc2PZTF+hkgBu+NLvfnhXNvXeE6L0hjtaxlBMrq5HGHnyhocyXbkpuHztYiZEx
	8wlb2EbvtY7TR/JmOq3PFviZvvqQYeIateTm1wIhF54iHHvjFBeoRX3uV73El66cj
X-Gm-Gg: ASbGncs0OqHmo34ujBsZg7AEc29jH9w8Qgdar1YTJDgiD2ZZMQi5FJPDhTT3DEGsruU
	9mz5tYJxjjhLNV47zHuRpLQ6DuZueNHjdJkqNi56xch7HKmCoRBsirLhTe1CkWb2ALjbLXLYATC
	bgVOUmoot0sxdbqmDHySbooSGmSMJqWQvk229DaWj7C4vFXSBPyxhd89D5RYQ3Sq903m/Mh1pTd
	uxb63+h/A57Wvh9YlC9RE+qCdNvqCqKitJyCjtLLZlasNInS9lTdsGEPuXX6/4JqEBf7zOHjqu6
	i8uc6622eZ9/sWnN/1YvJR5AVklOcDMwXZiiDJMEAzFFRGL2AQMQI3r3djkYEVYNlAiWsnMFPm5
	9dP7+2xuXt5ina+9WrOua1A==
X-Received: by 2002:ac8:5d08:0:b0:4d7:9039:2e87 with SMTP id d75a77b69052e-4da47c063ffmr28296781cf.1.1758801359225;
        Thu, 25 Sep 2025 04:55:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfws3DHjZ7NiFj2AF7AaqOeOE+RAgqdSMayjchEUwDWrTLQ8HNN+0mGYgmyc++RfEn9OQlxA==
X-Received: by 2002:ac8:5d08:0:b0:4d7:9039:2e87 with SMTP id d75a77b69052e-4da47c063ffmr28296531cf.1.1758801358755;
        Thu, 25 Sep 2025 04:55:58 -0700 (PDT)
Received: from [192.168.149.223] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353e5d168dsm160195466b.4.2025.09.25.04.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 04:55:58 -0700 (PDT)
Message-ID: <ee4f25d6-d04a-42fd-8b72-6b272e750b9c@oss.qualcomm.com>
Date: Thu, 25 Sep 2025 13:55:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dt-bindings: phy: Add QMP UFS PHY compatible for
 Kaanapali
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, aiqun.yu@oss.qualcomm.com,
        tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com,
        yijie.yang@oss.qualcomm.com
References: <20250924-knp-ufs-v1-0-42e0955a1f7c@oss.qualcomm.com>
 <20250924-knp-ufs-v1-2-42e0955a1f7c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250924-knp-ufs-v1-2-42e0955a1f7c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KNxaDEFo c=1 sm=1 tr=0 ts=68d52dd0 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=mUVx_TFFIgGiSlsxcIcA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: xIVH2OQXgCjzCzKfiv3V55ZkUC6uX0oj
X-Proofpoint-ORIG-GUID: xIVH2OQXgCjzCzKfiv3V55ZkUC6uX0oj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIzMDEzOCBTYWx0ZWRfX9uLlFBXyCjbE
 qAbthPWO4vcDkUtXrdMCmZHEOoGdFEnLo93L+qn5RVYOtcvq6xnbPiwD/v8SpyxxnngZOm+UDaD
 pVK2H81nzByxi9uJLzP2z79yWXNoI44bjbg/nb1jdijUXOJhcbJj8uGJp9B/RoD8QSeppdmJDkP
 sgyBPe75/GXXX+6FePJkks08/lbHCFqwAA3kGPIMptClze1sBH/xXIaaqlRNHugo5GG4JsRjCRk
 D5rAK+GSsSHDs7ATIa9IigpseK4LsQii/t3vV2/YM66EURzmbOggO89II/1jUSoiiSTgcmilolb
 5+7HFBUmY5B6VUiz+P7vvKbkqjFiPc8DeT0z+br1Nv+RwbaUGgfw/Bm+ImZpBzIR3KB7wrhuz/1
 Yv6aKDnP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509230138

On 9/25/25 1:29 AM, Jingyi Wang wrote:
> Document the QMP UFS PHY compatible for Qualcomm Kaanapali to support
> physical layer functionality for UFS found on the SoC. Use fallback to
> indicate the compatibility of the QMP UFS PHY on the Kaanapali with that
> on the SM8750.
> 
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---

I can confirm the SW expectations are identical, down to the programming
sequences (mostly, there's some minor adjustments that MAY be specific
to 8750/8750QRD, but IDK if that matters or if the docs haven't been
updated)

Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

