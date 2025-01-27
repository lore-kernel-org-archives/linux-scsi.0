Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C401FCFE5
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 10:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737973252; cv=none; b=iVIavjLMPV5QDoeG7NAD+ZLvBFi00gaq+/y6htsEx+/k+8GapHU3i/cMBjIVi0bIDSufLYix5Bj0F0OP6XgkZqpmEOiIVQigp1BI7hkDyYxvH3BevHCZ5GebJ8bXAKMXGVolmveNmKn6pWhLn0J2vp1cfmu/7D6sAMk/aaRn6Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737973252; c=relaxed/simple;
	bh=Hxw8IyGjQ5J3gtUl3IIP44BkHPVhF2xScdnF9smecmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4/CW+IcCXTPTgdjZuym0Onn7idwZ5fhj7wM+kwwXvab6h8PJHZLC1bf1kf7Xbt1Od4Gv+nevSJNkKEgxS7pEENGdwTLV0NneI3Oyd4u3Ky0nBtHE7bqqQ9qPrYqCz8uRdmRmYaksLva36yAYFD1IssBOTQXVvBebisq8FCSY3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jpMv7jNo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jpMv7jNo"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R4kQbi017979
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 10:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iRHY/8aTKLk5Axq/TaQ4eFvrRO/9DYyZjmqiQ/7+6XU=; b=jpMv7jNoRqDLEUbW
	JdFEZR1Q5XmRERgVr8OVhbMxQmEBVForyNHaKjSMz1+t8p4KhnvMdQ0ym5wGDA2i
	YdW4GLAlPh3d5FF0HtJ/IT/rXOH3MF+k4KLf/K0HD6yFuZzazaM/rbztt83f2MFT
	H4Myw5tS1Zcy1jlm3LW2FBpddicV6lkHabeKh6Q/oDF2mq469tuHhNXehUX1riWs
	9kjmeGVcM76NXoSv7QQMaeliBNYSM1zXBj8L+EMyhF+TnWFSvMpiEdjAAYqn2WCa
	AZ5PfAqR0SwvDBQjXRPpWp9tIgDLKoSqk04RwwhsQOYxTk4pE/xUKN/gnU9CDUBd
	LSzJ3g==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44e3dr0mg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 10:20:49 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-467a437e5feso12431641cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 02:20:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737973248; x=1738578048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRHY/8aTKLk5Axq/TaQ4eFvrRO/9DYyZjmqiQ/7+6XU=;
        b=EgPrwMzNs3apM1CclmFJJNhF1vKgDOzUnv8sTOpBK6J1IWMJNSz+yb8Op38aKySj+3
         rrJ+YWrcezatqrLqqJ/wWlpLrEwp9Lk/rwMUeNDwK/aFs8P4jsuUGJX5z6/vEAYjxokH
         eeuqeX5bwPNCzqZKQiTVnKedpoqOSwoAAavOh2uZI7tFuYDrjKCY510tkNvKVfGqutCP
         HmJOnxB4WiCBttIaKYlCw9Yu+a1sABKlVHuSdiYvu/ZhFPjPeXSdCofBUEbRvBRt5pZU
         UoQZwN9wO/3dI/RzamUxFO9ge5K+/1hgvskKOQ7zC7BBn47uHdCbUVw+d0zD/pGIidtK
         9New==
X-Forwarded-Encrypted: i=1; AJvYcCXE4vFYZh1JL5mtSLo6MPkyl+X9VIY52JXS+uGy6DrAEKoEo4VqhFqtW2H8IiNNXdcpTkiZqosDbFiw@vger.kernel.org
X-Gm-Message-State: AOJu0YyW1khW7rocJamiXO+Q4K5EEyWuTgtLh0gqpRuXlMUlHlSpzFyH
	m/Tp1AvosjxftdOezDcZad5hQku0uKUmTd7/JieAftnJ5j9RzwGHBKJOArJI2tSGTMH4Zc02e8D
	fbRBbmLi2HDFK1mrnVVVOu2Rz0yPfobUQdFkB3obghjDkZunq6293lFWRA2kA
X-Gm-Gg: ASbGncsCbtNAfNtneUefAgXyODZwW2Q/4C/9mRjSxn5SC6HrxSUcI235fow4SsUWFkt
	NiPBHtIdTpcxjWwJYvVUIRM/CMNnQgfQiztvYT8YkWdLev4k63PmHPbNFKGggMfhI1woCRhGwHt
	Adp7ElLDGW3TAl5Gk0+jdfA3aEYFKPW0XmGRYMo2Grn0WpH3MnAXAawFCLmM5/in8n7YS1Rh62B
	6aqcbMDgpJRVCbOMON0d25oJPuwE8RtHeMzH2Xuxgx4n8GswjHg9l+dG4HGL3Q45F5DuK4EnEMn
	FWczF5YGYrSJhY0qt6JX2TS6D9xMK3nf/+S+BB1MjZdPEDOG8mKRg/Xjnp0=
X-Received: by 2002:a05:620a:6884:b0:7b6:6b55:887a with SMTP id af79cd13be357-7be631f49cfmr2438125685a.6.1737973248516;
        Mon, 27 Jan 2025 02:20:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuECCNFGoubW/Ui1yA1XWf9mVhKR81xmqRhv+HGsGJHLDgTBaX/glpXBzB7yhX5w+9mKrFPQ==
X-Received: by 2002:a05:620a:6884:b0:7b6:6b55:887a with SMTP id af79cd13be357-7be631f49cfmr2438104185a.6.1737973248048;
        Mon, 27 Jan 2025 02:20:48 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186b319asm5333483a12.49.2025.01.27.02.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2025 02:20:47 -0800 (PST)
Message-ID: <f11012b5-f387-4144-a4f2-b9d629a4c53e@oss.qualcomm.com>
Date: Mon, 27 Jan 2025 11:20:44 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 QRD and MTP boards
To: Melody Olvera <quic_molvera@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
        Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Nitin Rawat <quic_nitirawa@quicinc.com>,
        Manish Pandey <quic_mapa@quicinc.com>
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <20250113-sm8750_ufs_master-v1-5-b3774120eb8c@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250113-sm8750_ufs_master-v1-5-b3774120eb8c@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 5zDMRvYByWSjpQ78-gtbsNSx_eKz2TXT
X-Proofpoint-GUID: 5zDMRvYByWSjpQ78-gtbsNSx_eKz2TXT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=711 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1011
 spamscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501270082

On 13.01.2025 10:46 PM, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Add UFS host controller and PHY nodes for SM8750 QRD and MTP boards.
> 
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
