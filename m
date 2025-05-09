Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512D4223702
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 11:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790632; cv=none; b=kIyL6dg9SVlpb5HYzDYKzaFzsIJ+SahKHk8A2DqhZJBucj5qD1XibdCCG8WcteV1F9R+nMKYzscDGiubtfvgQHIpF1sFYUGjcNqLxhFRKfVGnYD9jeszns3QtTaPK0/OIoMC3vUVGcWfsFT8eJ91t5D2T60EK53O/KCykkKrsHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790632; c=relaxed/simple;
	bh=v3/X/EsQXza5RfDWmNFY/6SXCtBK2b8m4VMT4qW9eLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dtGyJ1ixBO7BEMOI895GcEuancoQAGJD78y79YDfWkNZbaWZDjN3dqe4N2LEbOAXttCqSZ9XNfDfGl12zRwm7VvpffWQaQbP3LCXPKHa7PpgMy6GR0ZokeUGIVgkGCCYB7nA0Oi51XKF+MCw/OTFQoGPgN2ynWjya4yGvQw5I+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gpxGwwOd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gpxGwwOd"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 549BPSC5011293
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2025 11:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jQYvA039xQOq1EAfq66VEyDGldlR86EFFJPP/2sBrOU=; b=gpxGwwOdLcT4VVU6
	mlpdKrnZHRbfbF1FwcU+0c8Lxzudb93lf33vs/czLEBQrYLhS/492C6UjHCR6uXm
	itHS37wugjgvMTSXsRxvoF2ib7+sPhEHzXsiqSHsvU9ntny7AQJHZvwWQdtZevfB
	4djbuBxMpJ8+PL3R6QSwCo3TpqIM4CIBb5u+eI3nZ4ad9ENHMZXYfupTWo3j5Ndu
	BrPHxFPi9+0dagym6txfQVFh6zdwBdkxbChjMK0zPeSwhc8yHya972+K+CUSq8dl
	TdOpJIK7K3/qNw66g3oGhuQXJojEVyiP0rp9mkbbR7UucHE8DsBfwVHTys9tQIMA
	ErQq3g==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnp7cjxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 11:37:10 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6f54fbf3a6cso2823346d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 04:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746790629; x=1747395429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jQYvA039xQOq1EAfq66VEyDGldlR86EFFJPP/2sBrOU=;
        b=r2TrqZCgjLRQvPURUpiyMSjJ64SD/LK6wVuaj1Gp5/e8mTU0IsVmXFFGb/zpzD6bl0
         p/Tb5LSMzJ5GnKEIPKK+ljLnhgM6isEnO90IXj0UfxBmLnEjK7haxUXP2thYyHLQ52zo
         glCCChn/C/Uf0ZeGDWydn5HAzuFcfZqZI3zRIe7dX9tqtiPLjfdicH7ji3tc1mEmZuSM
         4VF4tPoUlwhKBnpCPKCoLR332S5bG7W9HUgjgnEvyrxovZi1FAMxluVAxXIHvom5H9PD
         hJ+v+6mmvaLoWJpKSN7PRUYrp0qiZX9DaX9AHCxqkeRqTIQZAnFeFpWpH55mffoMZBQ3
         8F4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUzuEbJD80KvAOgGR4vx1FZ3bai6DYLY3u4kxsQzfgqavx0r7yGOoG2r30wlKpXD2LYub0gcVzHsUSi@vger.kernel.org
X-Gm-Message-State: AOJu0YyYnzn2k4tcZNkBNDqgcQRZF59f8KxcIz9D8ddijfEdvR0KTYsd
	hOphu4R/DfLM5bNtAyPLrW494IsRXb9d1WID2v/QSRlX+QMCUWXeuHo0jY/NESLlaZIKiwdwBgI
	JbpZiO8o5aUlZCGMa+lgjtlmx6h+xvjIfg/nTzOQHLuy4YAVmmOi81x/VZGtK
X-Gm-Gg: ASbGncte8wEIiouEJahT2H+Csn9Ma+3nfoERYF42vupiDqOlQX+IUNIiEDf/WCrENZ4
	tMxPwjCKzAvWc/4xcP04ZqslqC7TWi+dsH7oJrK09fWqeHFNb9ndnG87EkWv3uJ34xBEkt0d5zN
	rHp8L4VC0dq696HqyG4fD4uwagG51ic9r5YCRIFdhNF8tf15W51DmLDt4h8cz8Iv6QSUIgrk0r7
	XkfyV1IZPiFHlC4TRYR525HzNCfRG3jgzEwX99qVL2/s3nIo4odUu8q1D7MyKj5ma6mXFUp6bIT
	3MtONP+pXMG4iu+vCVjLFrx6siISPMU/K7oiYzpmLxO8RPzBk6v9I6KJCzmupPItbdU=
X-Received: by 2002:ad4:5f8c:0:b0:6f2:c10b:db04 with SMTP id 6a1803df08f44-6f6e479b1a0mr17500876d6.1.1746790629006;
        Fri, 09 May 2025 04:37:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEM61nHn0Kr2ns9tneLJwOSpfCca4k81zAOLbsRmIWWWiH1KtlKtWvlBuAwRRqu3Bq9s2A6g==
X-Received: by 2002:ad4:5f8c:0:b0:6f2:c10b:db04 with SMTP id 6a1803df08f44-6f6e479b1a0mr17500686d6.1.1746790628543;
        Fri, 09 May 2025 04:37:08 -0700 (PDT)
Received: from [192.168.65.105] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc9cbe516asm1260658a12.15.2025.05.09.04.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 04:37:08 -0700 (PDT)
Message-ID: <58d913b8-0715-41b0-883a-423f29cb5a8c@oss.qualcomm.com>
Date: Fri, 9 May 2025 13:37:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 10/11] scsi: ufs: qcom : Introduce phy_power_on/off
 wrapper function
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-11-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250503162440.2954-11-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDExMyBTYWx0ZWRfX35cnSL3MGMyR
 Wi0iPQ4yfO9dNW11K0+2lv8P++CTGsWhke731pqHqqH0wI1ebQaIvmwyhuzDeiwU3/WZZiqjzx1
 A2119ZNV9EIb0OQrNv/3ufzEn7YInRBH4f3qyxHmuMlRjQsEuN1QhtmupB7MHIzfJ0a4KkvZgbn
 FqEAnqOzkIZZ7PxoZPzMSOsglWl7gXPVlwjGPN8a2vDo/Z2xx0gHiB/MAai0btCWCUxi4egOHXh
 LdHwhj7KbgScNQSgvmnMo58E/zBkFVfzj2sADZW6O7QwwJahLxbAqV3PKBDh6SIUHcF5bYFqYLW
 T7+NznFTmI9ITQmEnR4cg4yZLS7J3rbA6D/mUuAip6uPelT4SJjOiaAcHrUiRLQxD6+mWohj8Oo
 CbVpeZWvy4+ou3b5GBkKdIOMtuCnbsfPezIGUzhNwd0OVFw0vfBscGe20CIHuF2+57+BBSi5
X-Proofpoint-GUID: paL7koxmlRusNvCKDYoqgiX4gF0gj5n0
X-Authority-Analysis: v=2.4 cv=B/G50PtM c=1 sm=1 tr=0 ts=681de8e6 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=Wi1UdT8OlrGSyUgSRKsA:9
 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: paL7koxmlRusNvCKDYoqgiX4gF0gj5n0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 mlxlogscore=696 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090113

On 5/3/25 6:24 PM, Nitin Rawat wrote:
> Introduce ufs_qcom_phy_power_on and ufs_qcom_phy_power_off wrapper
> functions with mutex protection to ensure safe usage of is_phy_pwr_on
> and prevent possible race conditions.
> 
> Co-developed-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---

The PHY framework does the same thing internally already, this seems
unnecessary

Konrad
