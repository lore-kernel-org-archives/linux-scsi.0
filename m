Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8913E4C81
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 12:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781525572; cv=none; b=FmSEENTq21eS4hpybVnk4CHlFYIoxvcvgDpnZXSRBi3UT+BFA+7MzvyKEqjq9Iq11NhMn8ucefTZKJ+GtPi/L4njPBEUR5bj6r04t3IPnoJWU6GuEk4xmza3tWPkDsSyEK5OSeHS3rsmgbknWMhgslUtbob0t6I//wcfGxRnq0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781525572; c=relaxed/simple;
	bh=GsQoEQnPlKYnZPQmyrDFZUSt2mrMQVwGy2vgcNIQTZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fqU6G5lAkZ0cV9iTXZeZ2GZ8U3ta4+r293++s91VRgrUr+Zk2UrAIvJD+jSCJeslSR05LmbV11opTsyG0elThl6OChssch3L9GKsJpmqc0VaFCEgpnWtdTGvy5nkMLbHAxh1WkOhAohsH1cxyKJ4o6JlmZcTYjWkvtoofISHO4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jeM7KCim; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hQVkpjge; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jeM7KCim";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hQVkpjge"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FAoORt3956038
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 12:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6DrWIt30qa8JhqcqMonL+wcWL/FZS9HuUKd2HFVHsiA=; b=jeM7KCimtOWvqj47
	+EeRXB4p1cmlIowdf9n4/A69FM/UpeJlq1Ewxk+jFKJ2UDm/cgrwxb4dGKLpD3fV
	zv+Qhl+D2WzkbEF70QGKJ+7pAe0YKXKk20zKWoNHaRWmgSvSDG55Lwa+LsLkZe0L
	qFeuQ+mVYlWlHUy7HbOcx7VBHIPpPVxraVnntu+HwvByJyjEVrdh1r1gP6c6OcXV
	EGqrgEFyet0+CmRX6+qO2n8AB0aR4YDQTqqoK7J1nu1YXgU831NEmySKHdm1rFdV
	NBPUhsRdt1YNA+IhkR0ZbqmjNVdWKKOyXXNi2Z7pozlzCLsyS5GkX7LoCuyIoODm
	4pH+JQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eter00k29-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 12:12:50 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bf11699875so39458905ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 05:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781525569; x=1782130369; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6DrWIt30qa8JhqcqMonL+wcWL/FZS9HuUKd2HFVHsiA=;
        b=hQVkpjgeAQ6N2lcxzRM1a2FFgUCNA464D3Y8iadFx2yj1nJva9nAN8jt7KIK1J5meq
         B7pf6TuG6nAWxHxbGKyxjyIA2dFAq6P0ATR+qUoIBclC81at//kgM9O715KLUTnnmJgX
         Scda0W0rbazOdOBiFSfbCo/XQdN4G3m82IdIiqS50Hrq5cXZb6B+zvY6IqDx116yvVoP
         dNKOavMcVQQxCOMuSTSdXqSjc+3sm7VRzcQn2af2EMhd/zE2SMmUgPhI9L/INq5JGueD
         EsYv7/CoUs4Fao80C68P11yuR1v/cfRAxHP0W5kMh2E7HI/kkYbnXaZ9qTwJ2tPRkArO
         D7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781525569; x=1782130369;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6DrWIt30qa8JhqcqMonL+wcWL/FZS9HuUKd2HFVHsiA=;
        b=Am5+HqqcZzu0HAqYDPVGtIJGHi2O1DjM0GVODU+Hsw6ggt/TQ/lfD91qNpojKKIblQ
         +5lHI/u6ev5a8tXo7HyqXqSa03VtfwbZOWgNbwjAj+8Rpb/89vY6ZbE8cuCHYZYW68hk
         yBR/8AVcK80KSMwbnEVcpqd3CM+O4vXqw9vdoxlTqJ8Yt7dJmep4Ev4szTdVnIZqZ3iZ
         mMvBzn7U5lOCffjikzwoEoAD3CpAXJ/YUNwzE4YQZ2+G4hAi6W271qloghb1Ig2ZImz6
         0HOnnDAWuwgyyrZ9U2V8JOfZGkjNnZNpX0SgoswvdqBYNznLLCk606811pFdmkub7b47
         B+7Q==
X-Gm-Message-State: AOJu0YxsHsw04NS9Dymdb5YgYlGdK1AgxiIGdyYR9thqCBsDnkytTqzI
	nzU0e5Sm8f83SMS50fxo4nD/LBRdvbpmpMO0AZZTX5Y5iVVZoVS7lwiayFQV0YLK3v62iK+x3jk
	jvpZ6LcXSAcnlCpMzkqUlj2wJX7rdxqysNVrX2yy86S3vhXRCAD97CVfvXR2akWaW
X-Gm-Gg: Acq92OFPZtqkn58kJv/PVuMIBCGDkImp4PWkYjMBnFkD1PuHqTr2EvQ8/CVc84beVI2
	6ITLJeFzqyE6C6FW6KszzNDn8/9xcajKCCyplKiMqAaoYK+5DRW/NsnrB46B9eagweMSDC8LTrz
	67F3c7xnDPi+8V5tJlVz72tw1uuzE7l28JxzC8t7n9L79aucQ71G+viidwNqph/2Sxc8cmzb1c7
	QeDye21ZOo/Xg+7bt3fmfocBkYXJKU66LXX8euszhUW2v1Yid/rCdWVrCvPy4WvWp/UdiqU7GWS
	lAwIrsn/FyVvOFW3nOtXlK4S4+8VN7Ytcz1l204vrrvsoY64Co+9I6rCOL99NhXrYap69ro3FhY
	Md/oL0geJU3qG5FYI1XOP1QQpb53OGr7PaazjKIby0aDUiCslRIeKfSj3MVHQLMaSLCJgT+vx3V
	Ohu2NbOz4LKQ==
X-Received: by 2002:a17:902:ea07:b0:2b2:4fc1:f653 with SMTP id d9443c01a7336-2c42c819bf8mr95953155ad.3.1781525569453;
        Mon, 15 Jun 2026 05:12:49 -0700 (PDT)
X-Received: by 2002:a17:902:ea07:b0:2b2:4fc1:f653 with SMTP id d9443c01a7336-2c42c819bf8mr95952755ad.3.1781525568854;
        Mon, 15 Jun 2026 05:12:48 -0700 (PDT)
Received: from [10.133.33.44] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4327ac794sm100277845ad.46.2026.06.15.05.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 05:12:48 -0700 (PDT)
Message-ID: <41e340c6-f1a5-4541-8842-2bfad2ad90bf@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 20:12:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Krzysztof Kozlowski <krzk@kernel.org>, bvanassche@acm.org,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo <zhml@posteo.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260615085027.2102882-1-can.guo@oss.qualcomm.com>
 <20260615085027.2102882-2-can.guo@oss.qualcomm.com>
 <8ee6bfe0-71aa-4d3a-a583-f7495a86fc58@kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <8ee6bfe0-71aa-4d3a-a583-f7495a86fc58@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 55kM_vEc3pKkKa6EV_S_w0QbnloBfC42
X-Proofpoint-GUID: 55kM_vEc3pKkKa6EV_S_w0QbnloBfC42
X-Authority-Analysis: v=2.4 cv=UPzt2ify c=1 sm=1 tr=0 ts=6a2fec42 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=D4ZC7sO_Y8teBw1Q4O0A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDEyNyBTYWx0ZWRfX7bGTEtTupCZF
 JBXMly/3agFVo2vztJrMWlfMV53wupluCTEVhNLU8fqajuWAyQ/N6K+z20YzPzWZ4dU8mPx7e6w
 khDTwqAxUtfnZ2gpRfoQeQ4DoVHrinTDpE7gxV3tM9lQUgqKVLZBUlpQA44moJQH2qUdlSFers7
 241Myq5bs9ItO9JUbyCk5FLkuZbyFPZYzsdtTz2W/k9WZcejHLrz9d4D7rLYmNzU9GDn/BaDGrP
 qFIchg3oySYs6YbK0xhGEAkMaZ73qFnTTUpL+AMAmlyrZq00mNKcOEyRryTk2XkKzrdJ7wqxh1G
 zF1t/1WQBiQAEQUEiMXpWv3FdsHnRu25JMWJDCKaCSJD0zgUu9SohfXt76Tmel0JK2gwzeqQc+M
 dupF1+V8iqSj64KByL3y5jO3IGF4deSdK1sWqwy2qAxFOzr0jvD7c3qK8LUNhBoy8WLUocrl6y6
 vHfMJ1hV+3WvgfDTJ1w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDEyNyBTYWx0ZWRfX8E+F0+OkcKZb
 EhT74Cl6/wKwxVNseOUfb81sQMYW3EH66PO8a/Onw8wvdOI7Rpj879w8saeAx85sAnXtgYiHDH7
 sLlHO1sowq7wpnq1BocdKBk4kRJTMnw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150127



On 6/15/2026 7:26 PM, Krzysztof Kozlowski wrote:
> On 15/06/2026 10:50, Can Guo wrote:
>> UFS v5.0/UFSHCI v5.0 adds HS-G6 support (46.6 Gbps/lane) via UniPro
>> v3.0 and M-PHY v6.0. These specs define TX Equalization for all
>> High-Speed Gears (not only HS-G6) to compensate channel loss and
>> improve signal integrity at high speed.
>>
>> For HS-G6, M-PHY uses PAM4 1b1b line coding. Pre-Coding may also be
>> required depending on channel characteristics.
>>
>> Document vendor-neutral properties in ufs-common.yaml:
>> - txeq-preshoot-g[1-6]
>> - txeq-deemphasis-g[1-6]
>> - tx-precode-enable-g6
>>
>> Values are per-lane Host/Device tuples (2 values for x1, 4 values for
>> x2). PreShoot/DeEmphasis range from 0..7, and Precode is 0/1.
>>
>> These are board-specific signal-integrity tuning values. They depend on
>> channel SI/PHY characterization and validation (host PHY, device PHY,
>> package, and board routing), and are determined by HW/PHY designers.
>>
>> Although UFSHCI v5.0 supports TX Equalization Training via UniPro v3.0,
>> which allows host software to determine optimal TX Equalization at
>> runtime, static board-specific TX Equalization settings in the Device
>> Tree are still necessary because:
>> - TX Equalization Training is not supported for HS-G3 and below
>> - TX Equalization Training is disabled on some platforms
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   .../devicetree/bindings/ufs/ufs-common.yaml   | 55 +++++++++++++++++++
>>   1 file changed, 55 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> index ed97f5682509..145a6416e1df 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> @@ -105,6 +105,61 @@ properties:
>>         Restricts the UFS controller to rate-a or rate-b for both TX and
>>         RX directions.
>>   
>> +  tx-precode-enable-g6:
>> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
>> +    oneOf:
>> +      - items:
>> +          - description: Host_Lane0 precode
>> +          - description: Device_Lane0 precode
>> +      - items:
>> +          - description: Host_Lane0 precode
>> +          - description: Device_Lane0 precode
>> +          - description: Host_Lane1 precode
>> +          - description: Device_Lane1 precode
>> +    items:
>> +      enum: [0, 1]
>> +    description:
>> +      Static TX Precode enable values for HS-G6 only.
> My bad here, that was my mistake. I wanted matrix, but gave you array
> syntax. Proper code would be:
>
>    tx-precode-enable-g6:
>      $ref: /schemas/types.yaml#/definitions/uint32-matrix
>      minItems: 1
>      items:
>        - items:
>            - description: Host_Lane0 precode
>              enum: [0, 1]
>            - description: Device_Lane0 precode
>              enum: [0, 1]
>        - items:
>            - description: Host_Lane1 precode
>              enum: [0, 1]
>            - description: Device_Lane1 precode
>              enum: [0, 1]
>      description:
>        Static TX Precode enable values for HS-G6 only.
>
>
> I tested it with DTS and seems to work fine. Please use the same for
> other properties, but enum will be 0-7.
Sure, I will correct it and validate the same for the next version.

Thank you for helping me out.

Best Regards,
Can Guo.
>
> Best regards,
> Krzysztof

