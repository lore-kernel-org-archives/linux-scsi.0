Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C602C21C3
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 10:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768214224; cv=none; b=KZqx5m6JLobm2jrhVhX3XcMx/FkXjcjKNmWyOkoM22tK4B6sXi6rww/SwFXhn1oV977vukHajbzN4dx8o9mOctrRxRqrahP8PtGaSENQbwmeL+q6G66GkW5V/4is1L8QYCA7IkkSpmN+9oPa9EQvScfbUSlIOX8H8fBHZ+KB4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768214224; c=relaxed/simple;
	bh=QbgWNSzIoOhG5GoMkMznH/hM2py5f6Wj7h6jS4oFLmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XwkRq8yPmES6u6VGZNr+uu+uPUh4bSj1GdatarEHi4yeWZfDgmtbwCvolIMc4YRsehhzNvrtgSsFuxc2YV7DmMOm7ZSNzZRPZkaig+X+0dneF8IYykwxCHcAsGslop0B9wPG7qOn/TPbkLBnF4lMXb75eQrDW4abNdS8nku0mPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TjguIGn3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Kdg4QCyn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TjguIGn3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Kdg4QCyn"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C7Ofwa555266
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 10:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hfVyE9hj389TcKf1IZbtDL33a7k2ZEiOtmVjf86fe6I=; b=TjguIGn3WreHU2Ir
	o1FE4ShcE8WH3AdB0vNY8q3/Da3DZ6GuPr1nOFhm8YMdTKlE2E90hn1fk1YSezzI
	dVTl7//NOf3WTiAqqu6VfjLXzUTVkHBtwaR0/d0K+7lTEF4wNs8yuyYAGkLfRVgO
	9tZaJd6M9Yt3GxRdVJOzP9wyB/O8a5+tByY9n3Nzd3EztbdpHlYrYvDMaQ1XKQAj
	/PQyk3mMsslhhG7WRzrtbqgVVA/AZfz5EjWWqG0nR/kvMSkR02wV13cjuzDpg0zb
	Un85vRTU7+GrNfxqxr2FezvAboztz8BzLM8wgZ1+DAZ7wsgH1Bbudec5lgfnAX+a
	x6Zd6g==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bmvhw0n9y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 10:37:02 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ee05927208so22970671cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 02:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768214222; x=1768819022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hfVyE9hj389TcKf1IZbtDL33a7k2ZEiOtmVjf86fe6I=;
        b=Kdg4QCynZ1q7an9RD5DOkmlYOnr9zQq8TQZ0ZJyx2v786o41CfzMTy2iTWnx4wEs72
         RNnd3aWegTd4C4zuHcWyc0JPRf8wSS0r2L4T/e0FhbCn4wHsS7GcYx4MroR9u6sy/luj
         E0jRWLvEY7IzN0O4GJwSmY26+2eop9obySPLZux7ClVG2fBj9rkLEHoN6wSRVE+ZrtHk
         T6eTi32UcQ2nQ+jxQN5WLj2NE2swJNHxfkrXR0sEMn0Y1QCimaHTDJeUsj2Npek875sI
         KYay0cr/kKJOcfQ/Fya5VtG+Lzr/fyR7URAYMkkadUWkoYmBpiyXlZLD9WZOFf+2qRJC
         CCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768214222; x=1768819022;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfVyE9hj389TcKf1IZbtDL33a7k2ZEiOtmVjf86fe6I=;
        b=Q9xTqNgB0EJONEKgWR4Die3pI0YSRzXO4C7w2uWUQbZs4ZO8ZpfyMHO5ZGTHh0U3Sq
         lb9szdUNlcyARqqdsHthfWb/6q1zkTnDiw5T6salkZKfzity0DX44wat7Qkj85X2rSzU
         l8tWO7uIfT2GhOCGzJILHePf7RLrK3U1p3Q+t2EUSnl2tCtr5SK0f0GPmTmay019ri/8
         wteiLEjVSpI3syu0WWsmoSiQvubpk6TBZKw4jUfehLvbe0rfxx1ZRUPUNgvVEP+s3lEV
         eqbA3hr5G+0tOST4UGoYt6AjSoxZW+xJYN7sBPkd26Lqnuz4yZEhBeULwtUbTYtaZD30
         bO+g==
X-Forwarded-Encrypted: i=1; AJvYcCVbxIqgEjrRmh8A2wWWcNlH5H+VtWK6o8TW3m4k/pIMyHkgfRwTM/7lEIalNWNlrArR2l37snf8GeL3@vger.kernel.org
X-Gm-Message-State: AOJu0YwyozZZhMz8Am8DBL/TxYiUP4OJMNGKpIxBVLxfpz/nWQyZDieP
	t79hPZA5YYkuenCuBNmWMa0bpIK1jpB2d76FJeZyfWgD0WdzqNQ0OwB5mlkKV/JbpP1LFB1htBo
	mt0OHOGGD7DD6t8vT1XKGtnOL0ODzhR3ZuFSEESbivkV+VSTJweynJEP6iSaHZvkV
X-Gm-Gg: AY/fxX4fZkZRLwsT7YreS1qUTFd+CZEYHR2KLmw3CLlMjzBKdMB4V/8xPGEI+dbq9kz
	P8tRbpzcu31lA3JExim6YRNDr14s+5fNLeDnT4Qv1C1SBgvmIR+W5GEEd4Nq8rM0pqhyvus0YcT
	HUOC8+yPv0iDs/21FAvtfxZyoRJnalE2F0FjDOzQroKokvGQO3PaqekfqKM84q+sNg1AhlyPeLa
	gYtCodv8rHAvqao+04qeZenv/s8i11rz512ZLjoWCz6NyzxK6nct9czVg6KRSvc310XD3uiiRib
	ql8+2fjroFvlwO9KtMqZeJQMy9K9XxHwfl1/VN3Q/xi6f4eIdt5pLj3BIj4UhzLpFDO5ViZE6Ed
	8QjEaND/jHPXOX3EnDZqLQx69AEjqNhMdfb82FWGDvp7ZXq1NraY63is2ooNt60jx3Qs=
X-Received: by 2002:a05:622a:408:b0:4e6:eaff:3a4b with SMTP id d75a77b69052e-4ffb487595amr182682911cf.4.1768214221644;
        Mon, 12 Jan 2026 02:37:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwPXJrTbjQzQTcAzWAfSbG7+Ps1FzbEAnhMHNBzRiaoZEtHpgn0LcFOeGeJ2lQqXcP7SdxSg==
X-Received: by 2002:a05:622a:408:b0:4e6:eaff:3a4b with SMTP id d75a77b69052e-4ffb487595amr182682621cf.4.1768214221046;
        Mon, 12 Jan 2026 02:37:01 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86f1e95273sm664311266b.62.2026.01.12.02.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 02:37:00 -0800 (PST)
Message-ID: <534e88a9-6863-4494-a565-859eeae6fc9c@oss.qualcomm.com>
Date: Mon, 12 Jan 2026 11:36:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
 <20260106154207.1871487-4-pradeep.pragallapati@oss.qualcomm.com>
 <yq14ior5yey.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <yq14ior5yey.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDA4NCBTYWx0ZWRfX3PTCVTNH/zg0
 b++vs0N4MdsKAezCMupS9dcQQ0QhEsRe2hydHbhLkvibGhVFIDt9LfuwxzD1X6yqV9vvfm0ovon
 Qt6ddSi6q70OjgUo7wFiZwijg61ZEHRD7FH2RplqYMotpUG0nVjuGHXyd2EN3em2BQDncbUN+Fn
 /ORB03a9nTGTR+6g9a635/vUgYNQ8kvgrzwlBQA+lNZ9uHHrOr3tn7WCcvNtJUhDoJ5NTHDCt8s
 aYcj3j+5nuBJne4AXgefq/afvkDvealb++cCo2jF0iJigDzP0NxPWcJhQuHr++JcFmfDgyx2Nhi
 xRfXfSZ/Jtohi231i0/gqplbmM2AmwXhQORIkvJMtCWl0hbPrw5nYXgK4uKBwR4CmUggyJHvbAl
 Wug1Otd/o2487K/0CqTVhaVhTQdEzwVBrlTVdu0XW+H+earRphc1kGdWAQEzG9QKmUDTkzr9DMN
 TSS0dLByi6XSC0Hirnw==
X-Authority-Analysis: v=2.4 cv=JP02csKb c=1 sm=1 tr=0 ts=6964cece cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=8jcq0VWYKE_BtxzTVVYA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: aEPNrBYc-IF1yB8o61YyVqVRwbSsvIix
X-Proofpoint-ORIG-GUID: aEPNrBYc-IF1yB8o61YyVqVRwbSsvIix
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601120084

On 1/12/26 3:59 AM, Martin K. Petersen wrote:
> 
> Hi Pradeep!
> 
>> Add UFS host controller and PHY nodes for x1e80100 SoC.
> 
> This does not apply to 6.20/scsi-queue. Please rebase, thanks!

We're taking the dts patches through the qcom tree, that's always been
our intention and the default expectation for cross-subsystem merges for
years (we'll take these ones too)

Do contributors for other subarchs only send you the relevant bits (or
do you grab their dt changes too)? Do you have a specific preference
for any of these settings?

Konrad
