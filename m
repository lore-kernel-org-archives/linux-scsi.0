Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC715E97
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767104368; cv=none; b=eAOfJ7SlgGy2gCyFBDmRfQqHvtZM3SyqRxA1VS0CHQx9JnVBctxfj4l83iRw6tAUNCrVIDkLD1xq6qq8fOBvOWN/gDmMe51qhscPKRJHnir1nBh+R9BtWQedML2+ZKT0UfO1TAOQl8BcANQ1x2GyiB0JIXXzn03ri5ZM4DLvgIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767104368; c=relaxed/simple;
	bh=yNMRIHd/BkXo9jGKw4+k5G582exuDUZsMYg5DIWEM9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uhFG3aSWFxVR4mQpopNVzQECXZx6tp6B9bB7ZQmqvwbzOSe5QfHaY7cysSGH3UX5n1HYZQmu5TzHBpjyy+mysGk0JCM5s4q8BDCWXNmORt3kQjA6YJzYYAUdoDAMjEibPTOM9bcS0vcqXQDWyfuwE5daZj/FOwFi08buO1jLrwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a6dhvq4v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ea+HOBKz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a6dhvq4v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ea+HOBKz"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU5RxWU899679
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 14:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cPTeHY6D2tDelgP3xM1Pc/OjznKFogeL4V4q417yWBA=; b=a6dhvq4vwoL71RvO
	Xx16r31SQZltWRCLbLmFzf4JTNXca1MrLSxtJs9GMkwJ+CWc3kFIJoGSW4C9qrbo
	ED+bQo5ADE2GNta1CzaeO4E5D4sCcSlFi4sAg741QeUNXx6bNKteEPWCU7ESb6cx
	q3Dt3gVaFSiELxhw0xg0ZPN4ed+r8jIvqNWjL2Gc/MWiSmjOuQXnrS5jNjn6hyWG
	oSb3dGLWPDtaptw/TYaY6vVaEgobjh1c4zI/5z5uY0Ww/C0aJS4xY6REvJ56MnXd
	9DKB4WMsLaEu5QwxOOVsKNl5n4OjLSEatnL4kctfVtXYLH+qfbtp9xNpuRa0LD3R
	AueHrw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc8ky15xn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 14:19:25 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4f1aba09639so29961021cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 06:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767104365; x=1767709165; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cPTeHY6D2tDelgP3xM1Pc/OjznKFogeL4V4q417yWBA=;
        b=ea+HOBKzPuhQxNM2Vl7LR5LfqEkwydEASjUxbCcgMeMBmWx5ytqLAdrA8rbY41Nmgv
         QgqJsMzQdM9XpaZ1P/reKvfW8ZmPB8NsShr/+wxIvq59roEdm8tk0FnF2vuicPwBvYhE
         j6S3uzTl2E1oIUGYwf+TCpNDmhFO3SSa8X54UaeRA+xd/5Cfw0MHwGl0H8Wfwks18qRK
         eaKLpyOXV7Vl1M1iREs57UYlslhzASmpaKEUipTifowdGxd2YleoXKHeSym+eJ9wOLZ6
         Aljfw3KGts8quFZF7C+7R8Sopcmo8tJtb2Q9UpssmiGbpVyulkt2XbAwELDrH7PBM1Cu
         UIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767104365; x=1767709165;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cPTeHY6D2tDelgP3xM1Pc/OjznKFogeL4V4q417yWBA=;
        b=gpium3gXQylC2EE0DZmptBubvPkvRr5jS6xsU+3X3oGi5JPVQayQLtmqYVB5f/xEEZ
         WW3Kd34ij6dYAJBK7AqrVv0m+Tx0+OvlRln4CLay+3pRX5kWdBHAdhyYxy3uQ7X11GLw
         XLGVCmVQSNjrsk1WJmkOBm6l9ms9CdFEAdIP2I+DKUM6ZB/x2w2X0ExD4M9qtW+Ss+4b
         XSJo3hzPVEmZl8MCpPDaxZ1L+obO1NDFK7/TOkWOEuVXL0vL2PxmKO5yTCtUDSXSI8+z
         PBdTYyUGE9yr5KinpeGIWgpa3Y5+osU2eTwuKsAS12qbP2O+MhezYvac4AkkmZb4jJtw
         vD3g==
X-Forwarded-Encrypted: i=1; AJvYcCXJGPla6QtjpbYYpfapBOG03dKL9bL6Am1tGw9jJ0paDZ6dNaert/c/fUVcK/7GMwHlg0/ilTWFqrxY@vger.kernel.org
X-Gm-Message-State: AOJu0YxOseL4J7/EkW6Qp1VYUxKQxXpe4pP4Piz5knU+qlY1aeXzwaZk
	L8Zpnh/+QeuGbOAohuh66eK/FOJuFWoqez3UMeouDPhz7OanrEmWR/OHuOQqz0oZ5QVGbgZvgFK
	hcyhcVFyavs3bHMFuImtV5OT96zcVMCRiV4RXCCOAW4u5A+TlWecq/BTV5Hk1kIUI
X-Gm-Gg: AY/fxX4P5IB1RisqufXSBhn7mUHcjlOvJo+7jp5VNAqgOjQgTBN+k+hsg1crPHiDtrr
	3tlaoN5/8PjDP472Y31HX03zjK3DiC1SjH5KV7CmT/O2i5DNq2ak29l8UlgojaVvX6FimUr/Zqb
	+RJy/mT/vdjZfo6YUOMHqUSp7B14pReLJ5XxM2psK5l2mF08NPYbN7HFZGbB59DPbwagfsVEj05
	QGw4+lbHj8sSpj/C0k9uu5jX7FuAbdlmlmaGg5mdsYTzAmGbE4PsvO8X5PlhPg2c97EO6eEV/yt
	H0kkFKDNWGF2Xepo2kDSlMqdFnXR6IFiE7fFNnu4oKdLvX1i0G3NNwZ1hWMmvP3Db64hrDzAqFj
	VDKtkD+9d8A+OO8HY4q3lNyEejCfTm6WMUpZOC8RalWBp1DvCmtbbvzOGLMq2Gt47dQ==
X-Received: by 2002:a05:622a:6bc6:b0:4f4:b376:a689 with SMTP id d75a77b69052e-4f4b376a711mr273913391cf.4.1767104364768;
        Tue, 30 Dec 2025 06:19:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFx1y/8qUtGq6b+IQHmetUs2ly14xFse16BwCUC69fhJTx4dG27HSEMauwqQQpQxq7cqAa46Q==
X-Received: by 2002:a05:622a:6bc6:b0:4f4:b376:a689 with SMTP id d75a77b69052e-4f4b376a711mr273912991cf.4.1767104364135;
        Tue, 30 Dec 2025 06:19:24 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ddffd2sm3481865366b.33.2025.12.30.06.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 06:19:23 -0800 (PST)
Message-ID: <80529f8d-8db0-4b3c-b79e-8d5a3004241e@oss.qualcomm.com>
Date: Tue, 30 Dec 2025 15:19:21 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
To: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>,
        vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-5-pradeep.pragallapati@oss.qualcomm.com>
 <a33f5b15-d574-47c7-985d-f181c4784b98@oss.qualcomm.com>
 <a64f088b-8509-40cc-9f01-23c8b87a8f3c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <a64f088b-8509-40cc-9f01-23c8b87a8f3c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDEyOCBTYWx0ZWRfX34ck/VfVNNdu
 n+e+uKxymJbBIbdAkYBK3SezUdmrf32T1vCks6wnsB3uUH1lBtSKMZnrb6Vm/8laOThSJdDCrrq
 O+ahBMsTGCAt2iD8qcBtSVUikhm7R0ABoUTTkf0fmLj9v49I5AKvsGIfbTxlt7DChZdriZJHkmQ
 Yz6Om5GJ1bBGTj+mnw2hNZZ+oLuCo+n1xZYWw3oKixPbMq4Rv8UVXlnnDKmzkPil2Qo10NtTWeJ
 iUoOwBATcu1XL83CgAxgD8S1ZfE9q7muF8YtjfMkCO1rPiV5h+Iugptu4Tixz1hGU1aSzBFPIQC
 FnVEX2nhbH4/H8G1+K6xch2qgLK6wBeunpeRC9/T4i727cQKRtsAYd9MKp+hCY62z9nt8ebutZ1
 Wz3t6NeFdfd8sKc5lzPUOToFup0AYgei10uBILFkN+qEplzWhxuIfwG62Vw18Lt95+U/wOsOqiI
 envmZzlCCYhEP0/FFig==
X-Proofpoint-ORIG-GUID: 8Dn50FcDIdGOV2nS8nIw0PvxanNTScX0
X-Authority-Analysis: v=2.4 cv=BuuQAIX5 c=1 sm=1 tr=0 ts=6953df6d cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=QZSmA9GrXdfeW22t9VgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: 8Dn50FcDIdGOV2nS8nIw0PvxanNTScX0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-30_01,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512300128

On 12/30/25 9:58 AM, Pradeep Pragallapati wrote:
> 
> On 12/29/2025 5:47 PM, Konrad Dybcio wrote:
>> On 12/29/25 7:06 AM, Pradeep P V K wrote:
>>> Enable UFS for HAMOA-IOT-EVK board.
>>>
>>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>>> ---
>> [...]
>>
>>> +&ufs_mem_hc {
>>> +    reset-gpios = <&tlmm 238 GPIO_ACTIVE_LOW>;
>>> +
>>> +    vcc-supply = <&vreg_l17b_2p5>;
>>> +    vcc-max-microamp = <1300000>;
>> I think they should both be 1.2 A peak
>>
>> Konrad
> This (1.3 A) is as per Hamoa power grid, which is same as SM8550.

Please check again, I opened the power grid tab in the internal
documentation source that shall remain nameless and it said 1200 mA
for both regulators

Konrad
