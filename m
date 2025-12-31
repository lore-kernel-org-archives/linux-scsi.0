Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FE22A80D
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767182132; cv=none; b=Ct+bbxDoIMDcUo7DNOUFNPGYYt7tiM7xeMdptN5/7Cf/nzc7HNC7liGb5lcdM9QvkjWy0moP/+zLk/NenL+LbTpvQgHk3eL2Fl7rBE+5DDHmlwTFUxUq9WRjRBG/IcodqV+troMALchuHgqdrCXL/e1zFir5QwPFe/ptMilBlH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767182132; c=relaxed/simple;
	bh=YcnEwOIhio1pqk3VoTFvxX55HjCeJC0Ms1DLaK9GUv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EK3ovDSvEjmHPJ2BjuW+cLJJUlKkd3GMAm8BgNd4E6YTfsG0bWbhFXt8uhnyX6W3arK8U6AgRjRlyySudWaGJxUoIU6r58Iww/P+E1JQTiUn82Tv+l97mwmeIS3nBbE/Zrq1jvvZ+bO50j04X0k65dDCZ4eiqknG4noEj/twFRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eDCg2RiQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vn1TmqBy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eDCg2RiQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vn1TmqBy"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BVAjDAi3368823
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 11:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aRgAS+XV4NGIbS5AlOxK3JgWg3/RW+6Jpy0ZJY+OBdY=; b=eDCg2RiQIPCiD4/r
	OZgu/lfRh9HRoEAx1zkNlebLqf8IxPXFNEktnbGD5a5L1knj1WrfBY+6V2Pq1Zsc
	bFtWQOz7ttYHRKT8iz7j8QiKTNZlz2lLg82tvlzoi8sodrVtW697pS0jJCX0k45P
	oPZmqjTpAbB2rZeAc//aX9q8Ch6tXSkq8DyHWl2NzkWtxsPpe8oZzRgyBozHYh4e
	kY40fRnxD6xZNzhX7YiIn5T7AsGLzGrnuOcr4cPYhh9tPPZbExchWzbzLLCirjY5
	1Fe+crApel5VBpL0Msr7YuhHW80l1iShUvj64kCUCHERyS+5UamdJa9eONpsObhl
	ovdP6w==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bd2bb037v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 11:55:30 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b1be0fdfe1so446865485a.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 03:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767182130; x=1767786930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aRgAS+XV4NGIbS5AlOxK3JgWg3/RW+6Jpy0ZJY+OBdY=;
        b=Vn1TmqByj/rmQynNJY3nKrVuMmOVhDC/L1V4XZeCTCpXVeEoKFFJcke9K3oOGEwdaf
         0tkd3yVPWmb0L4TUW+iLwnP3xGA8MObrNZi52PfB1lf0o41Y07kpERJJb4pF26xOQlpr
         GUI2Zdacdlsyc1/QiX7NzsoHsmuZUbuPnC7xHs8ndbVBC8FVKbjfAgoRGwzjBXbcUlEb
         c3T6410EVhjPRFWDxE4KUpLDlKA5KdVtwScFwP1fEPaa0LbKH1wGehp1g4RCbI+Z/X7/
         aHI0UduL/rlj5V9Js5gTaK/8R6oBkyOWLdjguRneS2yxWOF8hVtpDh7NsRdeoVC08EmU
         u2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767182130; x=1767786930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aRgAS+XV4NGIbS5AlOxK3JgWg3/RW+6Jpy0ZJY+OBdY=;
        b=lLBSon91Jb9FjoIYWHH0ubFgQ/kzZ4nTvEcuzC13DHSF2Bn0I/Jr+gKEdcEtSpdan8
         s512WdNmn1VCI+Eh4L32ijVjDvSsjb6MrHuxT9aK2kGP/lepjYLxnJ2URMaxOr2KfawA
         fbMUklUm8MiWn6oywR6SD3qKoD3dqgRlTLXv4Dwqd44ywcXfiSNPPai0rtz/b1In0yVi
         z8AGjFmYP549Wm8Tg0d6qN9YL17VC4ELPATSTGE9LcWF7IDXQTh5vuMcrV3V67igQs9a
         6ahs/N4LU6Id00FCTYUpR0bdj92SyRaDlZPcpoAbDDfabeF2C3MnzWJpat1dwBJkQIUB
         w10A==
X-Forwarded-Encrypted: i=1; AJvYcCXqncNvM+aOuCWsMifsnFrOIUc5k4/4YKGSn06CnauyRzWvAHUZyz9bEB0VKc0WtMAD/YnsoNFMRMdD@vger.kernel.org
X-Gm-Message-State: AOJu0YxKi15tjnEqyINdFxX3K4Lz/9yeURiQzMhO5WCloXabwPHDsPSu
	lyOZAJ+9XwnTzoxv04vNda1kEisZ4E42E1Sig8T+JeXE9+zvhG2F4AIVaPOwcHU8vovIh0AZtSI
	ydPln2STHagqGJ1GBP01/n3vEJYYU4qvCxYL3C3mNr9FaJR5urL13Yd1gLJiprRN7
X-Gm-Gg: AY/fxX5m70UhwVUCZ5xZnKncE+ATKtweIwI4Y6VChplqg/FJTQdqD0k5gDFam3U+rAO
	N0H55DjnUW/WzsVcsoj53jqNLpVsudBKpdeZMDB9HjTXdk4b+b+c6B9J3vGD7STZWvmb9tL/4BB
	EKHMIJ2mk8jJTfNa6z8/5cyx5XioO3fS8pB6Q9XLJflQCuHdFlEWGXkYgeyLg4UFhY/NPqrMfAG
	JvQSw6l6PvaB4r+sNvOkE1m8pKKJnw4GU+/71VaUrNOGtn81ovFyK18Iz30C6nGX4T6Y3k77+s8
	wbpZLJRgJmzKHDpHAQvG4Yt/cHRP/XEClaXsRsHzHHVt1PilWImiZFBhiRtD+Ojs80x/TV5DFUH
	f9nPwEob5GPSxpuX/3nDOYu3uC0JKgh3g2GuGs3a2VXjyTol2wY/mjilGi0/kH4EJbQ==
X-Received: by 2002:a05:622a:110e:b0:4f1:ac43:8122 with SMTP id d75a77b69052e-4f4abcd2aa0mr417993511cf.1.1767182129655;
        Wed, 31 Dec 2025 03:55:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUEj0uHQJWKcVrybQ4kVXd/G8cMAoL8phJ7s4l4QL/dkGOzS3sg17A+M/DrhwRiYE8vhnPzg==
X-Received: by 2002:a05:622a:110e:b0:4f1:ac43:8122 with SMTP id d75a77b69052e-4f4abcd2aa0mr417993341cf.1.1767182129315;
        Wed, 31 Dec 2025 03:55:29 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f0b7bcsm4062214666b.49.2025.12.31.03.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 03:55:28 -0800 (PST)
Message-ID: <5490878e-8fe4-4493-bb57-e671ebd00318@oss.qualcomm.com>
Date: Wed, 31 Dec 2025 12:55:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-5-pradeep.pragallapati@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251231101951.1026163-5-pradeep.pragallapati@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: t_7x7Gon4xyWo1mnowBnoEZNz378YoYB
X-Proofpoint-ORIG-GUID: t_7x7Gon4xyWo1mnowBnoEZNz378YoYB
X-Authority-Analysis: v=2.4 cv=dMKrWeZb c=1 sm=1 tr=0 ts=69550f32 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=V-KO45gPXDKAuljG5boA:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDEwNSBTYWx0ZWRfX4PWbo/bVXat/
 a5rh3HDcz07fNiPjdq5HSLjQPz1VVI1Uldv/1iIL1q2PzCIjlnni61Km6qJvMAFFjET3gSa/0ig
 YDhYKH4bfu6SlFSe2tyj1sUXf0E6JdjbU+Fnd8mUsSmtnGrmkwtaSSOTaz+hlWyFkpVSELYWbPu
 oxs8fT3wVWW77aMFoB0KRPzDbVFKfn0zUjixeDEXJ7vD7YQp67r24gEwO1ht5UbZ0cqEYnioufF
 kITF/Gg3zMIofdCUuLQN/AhRZLwkjbgCZ7XB0TBf3k3XzZ28Gn/hB87hOBjqPkZH1TZIY7lzL9u
 ZNO90THgHIGzUFPPHAeLaz57QgwsJBah2IMxvTrCUdLSrNetbmS1Gc0W9FFfkTgBBYTtLciGNlR
 DomjpsfvZrFNuQuoEucCO7AjBQEB5PTPjzPx9n++/8D8mkIygiskw8aAibefviBa/t5WZgz+SCa
 q6YDDrFSKaKM6orYP2g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310105

On 12/31/25 11:19 AM, Pradeep P V K wrote:
> Enable UFS for HAMOA-IOT-EVK board.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
