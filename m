Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B997728FA91
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771510600; cv=none; b=CqrLf0CW0wqxwHqun6Oa9qZ64RIeaYRQCNTShnq0EOHDmo3RdfmeYSgS45Frscpym58KEAS47g1CA8SV7r45nXwQKHMvV8Lg2/d4rx3c1bVQBDd35GNZSAY7Q5PVLmM9ZFDcLZb3OS/FmBhgY78DnnLBZtaf7cRfzO18f1hx9F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771510600; c=relaxed/simple;
	bh=HETJtyp/JHXsiMCimm8i4MBIY+1eT0ucGCYLZLoJtZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K0y32eHZNIGM32Y5dqN19F4m0Bg/XAkGC1jfwOgZT7hC7SAop5OJaceaeCIdfgVLCCF8OOqcHIf7fTRbl+SC8A3MaR5JemyjYc0zSn7gTCf1s4LzqikYdPN2KKcnN/jLkJbU6CjC+WU6HZF+uXKAkRYtpnbma1sqV0sk1WbVTlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MStE8fBt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OXH0nrA2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MStE8fBt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OXH0nrA2"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JBiqfv1925173
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eVTlPMAt7Z1bsoOzdrd3oAbIg8fsyWqJ8xySgQqtea4=; b=MStE8fBtZOUKUu9n
	vUMojD1crSoWkyPBexB8gFRzTnVcIxFjVxLFfjijQV7GdM7m+ywo2kZXF7QOgNxI
	NvubO/E4hPofPyPZQUnZUYudJ120aGrighx1bw2QQX5Gi5mdAhf14BMOLAatKpTF
	BF1BTHMV4nFcD/0QCdLACBj5DEWonKzDnRmoJ9cgijs9ezRsBgidRhEeTlxxrjOh
	RQQ4/ietCynJV33JpS+iejysbPud8ZooZzfoenKRbH74TwUk3PadCPuPVFvO0UD7
	MjyW03yGCE9ZINYsaUqWr3Y9PIMAyFBV14wFYSHKl8EIjAnh6xvSOKRwf7UGXWWU
	Ry3Ktg==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdqdg9xky-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:16:38 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-94ac6242928so226381241.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 06:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771510598; x=1772115398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eVTlPMAt7Z1bsoOzdrd3oAbIg8fsyWqJ8xySgQqtea4=;
        b=OXH0nrA2+93+e+K98A/G83O0xqSYC/u3kWsCVKVr+7q+ZvLPgFXC0dwYQJYT5hrAtq
         8QqzZoooC7zReOJi14J/Tol9Uldk02Mg27d6L1ZWPbqGTu/bXmGgwDgNbfhmGp6Pi/aY
         pv/W3ZkoIlCG6tfU6JBkVUM1ldCMWJVRxPvP2Z0wEe9o1KR8nieTS2HoZNRXprPWfriZ
         OGCb97ETl6hxg7xk8xov4tjYC1GPZRFfE43fOqNw0w1ngCtyyS5ZCZTM1tZ+KJmD8ImM
         gCUiL4dJNp/uCEYrJ+1opDtxxjYrqKkoHyz28MN7iPh7hpw1RwRme3sii/Cl1+2lQQ2y
         zZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771510598; x=1772115398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVTlPMAt7Z1bsoOzdrd3oAbIg8fsyWqJ8xySgQqtea4=;
        b=YF33+IdcOxAQ7y7xtjVwh1QLqC+TVDk3XC3/gNAnjboEtKobHIa6146vDR4aCD3zBT
         RxYEGs+nXAInWhkcQDTriXXVMgWP7aw3WhiQO1cQ41ma5ocd4wCJFtcg+Oh3X5tdeAK/
         eUz3JQfodGTgR5R3xNMmOAVlZhoB+LRpXVkyStP+5SD77w+pu6Ad/uq2bwFps5JzZwwr
         My3k4DVC8C6Kbxz0wSW0bpTH/BXi0hfv5SHyTrPcMjZX7g6RJ6sT57h7gkjqjlqv1Bqo
         jdOOQc3eNX18WcZO2s5q1CxsNgmMxmuHRcrquoeir8FhHfSzZoTT8ssiSpbyP9Tkbc2o
         jQnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw+cJcmU0eaoPbM+MnuDdq5ktlTMwhqNUmbiSmv3k3GpfGdbsOxUBaPrTh7oBewCwiJiyU3d29Omj2@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/wPCujjB4Qp1k+UtKUbs0ag35PlJY4Tt6qWMr7Yp8jjxTP66S
	6Ewfep/GU0S055XWv7WF7WFJqETCkBdGI4fboRB8jXqyMzXkiIZI6HC5h9GDPPNDKMSXpZR3j91
	zvmPouu/7JyQy368EjkUTFxhPkxhemDFe9k5cKwvRYDdcNTYylxl4FJLqMzNIx3jL
X-Gm-Gg: AZuq6aIsLHt04Qsi7POfr8etLCS020GkF5NOzFQ0MIh4spnEzlXyQ6nTLmSQ+ORqB3F
	wDiqxkoTwcgnRISkDT2R2I1afKFjjQAgaH0o+YZoUXYXd4QY8izZIlLeQEU30NxxYtIBt2iqmAD
	VNjS5DDbCI11j5IerkQXra9Tza+O1X0MBc6joCMBB8HoTepBNF+44qf0yDwjA/H7lMjWALQCsyj
	gEprDQfwNkfXb+EbYOjGjhEriyNDVRi3UEsPA1zSSCz4gyhhr0jjYNH5jYlT6KmRvm8yAYGQ6U6
	HKkgfiDU+eAKsjuF/x+XUPjlWR6PtBo9gZCDezJEptRkd1t8mB2oLCKBm4ahj4xS7pXtmySybvm
	KXS3MD8cgm4+g96Rc34CjbaioqkWmwJk3szrJiQUnIHKpnzRCmCaEoXudeOm/22hEVxIo9FZmL1
	r8gNY=
X-Received: by 2002:a05:6102:5087:b0:5f9:3927:4b1e with SMTP id ada2fe7eead31-5fe16f0e687mr4498230137.6.1771510597939;
        Thu, 19 Feb 2026 06:16:37 -0800 (PST)
X-Received: by 2002:a05:6102:5087:b0:5f9:3927:4b1e with SMTP id ada2fe7eead31-5fe16f0e687mr4498180137.6.1771510597414;
        Thu, 19 Feb 2026 06:16:37 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc7665563sm573056766b.47.2026.02.19.06.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:16:36 -0800 (PST)
Message-ID: <15495f8a-37b0-4768-9ee1-05fd6c70034e@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:16:33 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-2-0c5245117d45@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-2-0c5245117d45@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: LdJ4sXpPphs-znUROEENfagDqKK378Vc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzMCBTYWx0ZWRfXw9t0CqxWctgU
 ueTDN3kQ9Wlx9PRGr/HKvaaCDfmy7IwV1/rsNpMgcSgY7lijkL3z1oFGWKSX99drhm34WFhSKDX
 lwpibt7+dXK0C8gb/DNif1BwSSdPSXuGfNMmmo2hic1rGXddU/thVyb8c2RG3ulr64EUqb8hc6B
 e2gRK+KmQfC+IJb3XE+/6ZintJadcv0i7GkUKsSVkIl6S91b2ybcAvyzWo0jBREAPT7bRqJOZQs
 y6R8884crcN1t+gke0OEVqJxIhRLPOSoP61ANg9aeYyWHkuv5Oa6VJ2Pif+ams26RJmr+oDal8y
 aUsG7+mdGHuT5QkGOhsFigu1phu5qdY/IFJj2Pffrqv385p+ooApPh0xuUZ4gIQzG8IM0z4OAlJ
 d6C3Tkh6fsKGiGzKDIwfw3sZTlhitvNy6oO4xxOnatzR/p/BlF/bXfiKRGNcQjdtMVzQWL5l0z4
 AFqArPw43jJl7/ClU3g==
X-Proofpoint-GUID: LdJ4sXpPphs-znUROEENfagDqKK378Vc
X-Authority-Analysis: v=2.4 cv=W/M1lBWk c=1 sm=1 tr=0 ts=69971b47 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=jUDvDPFTW8JP9J0CQvoA:9 a=QEXdDO2ut3YA:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190130

On 2/19/26 10:39 AM, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> during device probe.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock based on the target frequency provided and if a valid
> OPP-table is registered. Use flags (if provided) to decide on
> the rounding of the clock freq against OPP-table. Disable clock
> scaling if OPP-table is not registered.
> 
> When an ICE-device specific OPP table is available, use the PM OPP
> framework to manage frequency scaling and maintain proper power-domain
> constraints.
> 
> Also, ensure to drop the votes in suspend to prevent power/thermal
> retention. Subsequently restore the frequency in resume from
> core_clk_freq which stores the last ICE core clock operating frequency.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

[...]

> +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> +		       unsigned int flags)

If you're not going to add more flags, 'bool round_ceil' would do just fine,
without introducing new custom defines

[...]

> +	/*
> +	 * Register the OPP table only when ICE is described as a standalone
> +	 * device node. Older platforms place ICE inside the storage controller
> +	 * node, so they don't need an OPP table here, as they are handled in
> +	 * storage controller.
> +	 */
> +	if (!is_legacy_binding) {
> +		/* OPP table is optional */
> +		err = devm_pm_opp_of_add_table(dev);
> +		if (err && err != -ENODEV) {
> +			dev_err(dev, "Invalid OPP table in Device tree\n");
> +			return ERR_PTR(err);
> +		}
> +		engine->has_opp = (err == 0);
> +
> +		if (!engine->has_opp)
> +			dev_info(dev, "ICE OPP table is not registered\n");

dev_warn(dev, "ICE OPP table is not registered, please update your DT")

Konrad
