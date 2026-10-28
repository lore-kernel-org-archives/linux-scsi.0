Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190471;
	b=dgDZgcTRzvc0a3w5878NLrBXk7+No3UDM5QzDsI14Z+gIg6CC9q3Kmw7FIZCSO87bIEg
	 5gI88L5Q/2kvvy0uTdCk1n75NP+T/vRMDkdylHwpuOPc9vwUnUouqJIKAoK8Qj1zXcuRQ
	 BS0VbygcQo+EusH2X2ydUOlDBtCBBkhucFY8SDRYgRca3sj9IbQ4xXSOJLbpjjLzv5V15
	 GMj32TMH/fEIE3VOkRMOdiqt/suz8pkSj/RAUfWbFqthME0vVQHaK/YAIq8qpGMmIiY+2
	 d46lk5j81G7Pz70FWuJ1ixMNoiqnayQTE+NGtnH9shFapG8VezR5JIzCcXUZxXO2fqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190471;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VSigMjbRxPUPU+y0wEyfEBMw1dQi5WR+SlH5DUgFnsY=;
	b=PuEdKsHd5KK+VQ3GHnyON6XtMvFYM1Gt7lc4ZlY2UDH5ELsD+nHbBd9C1jFLL42/DmQD
	 lmtkWfFa6i7xeM4atQCP9Jl7W8EzLosgzFaVxw+Kd+cEw3L6IXZuSXnasCTOZymAiTdiC
	 v3Q3U/uOQfSW/v0IVgkKTj23BGkVHEHhoy+1I1qeemQtFP5WDuynUBLG2yY2MxwB7Htb6
	 I5jcp3EGPJYdVBIm+x8lHeg0REr+hKq+aSUFfq3Nue7MAF7LEYo018/W4Ps+YNoqBS2KE
	 l/orhk/mfQ3+45g+WFqfBG+WKzSFdRYFzr6D0vlO0ywaq3DsDvLmBWSAKtjGIahl5ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nTzg8f1k;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Xni/YqZW";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C447606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C447606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nTzg8f1k;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Xni/YqZW
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBe6Iw1053363
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VSigMjbRxPUPU+y0wEyfEBMw1dQi5WR+SlH5DUgFnsY=; b=nTzg8f1k4cwxhaKx
	5fu60NUzGPhHwKZW1SnkcNjFlFcn5JydUt+hiRDcvRhDGu7StCF+gzSjUBLfP2nT
	O1w8Tfb4ueSXu9PIPwHj6TuSymEjfmMZwR3acfNEiQL44XYiRTAYXMQdKC8yz++X
	ORtxSuVofP6Gp3Tda8nP/hRxrQ2HhfSkjkajIuC5SwxD9LTLaz/l30Y8+irpTGAF
	3pllMWGSTWMBXwr1cgfbu1Y+SyHq+3mp+VQS6q5zpZVP/u+Kofo8ovBMaI5I0yU8
	Z9QgZZzaifv8pUUZmS+unC49ntSZu1qins2SF21iJ5+dm2dWrK/p/xJEaC+l4S2s
	qV7E+g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkbhw9bwd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:27:50 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f1440e081so20288985a.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793190470; x=1793795270; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VSigMjbRxPUPU+y0wEyfEBMw1dQi5WR+SlH5DUgFnsY=;
        b=Xni/YqZWlbkz34hpOf74UkWLJ0sry1b2YV+t0hCJsBVVasakAfKlXIfVeGb5r8509k
         P15D8QYwQAPCFW2ZSWAknXXFE+vXJq7Rh+RQ4xyZFjEkWaOCKZ1xV5uklUwIh6BFU+IZ
         iySB1GwMl6+Ri8XwPtHJnd/Vi2o+1zu8X3pjlFWT9GAjmHqHBTPQkt5x8qixmCq91c2N
         q92hQLH81D3KnfU458ntQxde7+cLekoM0lHCZ/Hxm6yGho97f06AXUbMyyY7G6mgvRCk
         tizEzf4DbrXwWlaxlY1fhEQFt8CFH+vct21u/KmJu01fs2b43r4wkTfVuaGKyDDLeiGS
         xSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793190470; x=1793795270;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VSigMjbRxPUPU+y0wEyfEBMw1dQi5WR+SlH5DUgFnsY=;
        b=TMZYeFCUdOFN7uuf3MjTQ+6Yaj+zNXwts2Su8QUwTqi5Nt+oaN8I4BkqyGwG/OAsCW
         83nw/PyHxpy7mhYm3STyQg2NX48WsOQLEAU4AzrFNHVgaxVrXBJkxkGyzRblUXSVWi+E
         bGwPtWaKGcBNLRLj9TFZkNNDFx1m2jNzHnjbq+07IzOa63iMDeAAwp6JWhzNjPd9IILt
         lMkQGsOd/NP57mmWyUlEYrPCTSTxgUQJ9+QDae+hfEejseKno14RYA+JpDEukA4G6Kn9
         nnyeifx91JgI2pdFmxm4n+7xyEtR6SCIQ0vyjh732zyIoPv6AN8PalnmrA/Ltc1woRIU
         ZZNA==
X-Forwarded-Encrypted: i=1; AKwUvBzak4D9QHtTou7CBGr6mYtCAeXeiDT0Hz3Sn5byKiRW/EzoznPnzW2ZITcKYT4SVsA2fGi/QJxrjC2W@vger.kernel.org
X-Gm-Message-State: AFq9FYJed2ADF4Ue7EXug7tFKFqGO+Thb4eCIyYQQI49uQOjCf+SZI2d
	TcUPd3XIKtYmZfX5M1j8/9aadRimEjBCd7d0bAvX0wln5GPdCfI9SCC3Xs70ddeLKm1B4fVMK7J
	3vF4fmMUBbfpme1ekGlmYxIogEDYdMW04wyNnE9G4Li+UDbLgSjO9bquLoOeyLhi7
X-Gm-Gg: AYBFou1e9sOP+JM3Vm9vvJ/RzmjrhJWToeM0o3DwuisWRrZnTMwcasP5t/PyjZBouEs
	+oKh7MOJxyPMD/o+qv7koqRHmv/xeeqPEJLBpaY3LECDw8Ud9s2/fUIf6BMhUHPjWk5rp23ZNYm
	T+Pg1J/4aW9izaduLKvhujtd8w8fRqmo0lbBZZwWhTvqPV3US+Gl+MPW6WYnxUUgb17WztgmsBI
	7DXw2JZgx+R9Z/Ch2QqN4FMq+56XAZRuS7wgPQv62kbhijjS5Qc7NWwOVSZ5Ukjy58YOR2EIG0l
	DNkLm8f4syCDuO58J6MvwODj0eErVI5sjYHj+32+oN1aiM5C7x3yQUP+jqgWkAaDUMrUXuzdxpH
	74qcc/j2eMhX8jpgedSag0N1m4xfmqbVZ9+dynhtSZA1ZnvdjCSOCE+40dYPeTYR+6dk+Z0E=
X-Received: by 2002:a05:620a:6d4d:b0:93f:211f:7ba4 with SMTP id af79cd13be357-94408d629aamr300069985a.5.1793190469720;
        Wed, 28 Oct 2026 05:27:49 -0700 (PDT)
X-Received: by 2002:a05:620a:6d4d:b0:93f:211f:7ba4 with SMTP id af79cd13be357-94408d629aamr300065285a.5.1793190469165;
        Wed, 28 Oct 2026 05:27:49 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd350b52sm594839066b.7.2026.10.28.05.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 05:27:46 -0700 (PDT)
Message-ID: <b4f6fe92-6d72-4987-8b87-b66e28e4678d@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 13:27:42 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] arm64: dts: qcom: glymur: Add UFS nodes
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
 <20261028-glymur_ufs_qcb_enablement-v5-1-09cda5e3bab3@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261028-glymur_ufs_qcb_enablement-v5-1-09cda5e3bab3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Rp4ChSMwOiv-Fo28L9VYRo1aZfJXtT6b
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfXxElGB7wWRvw9
 hF1O/8O0E4PMLl/AJK+GDMmU8v3kFlL4kq2qN+d4CSB/At0VX7kT8yHiBpGhIu+llS/MBviTEOD
 Um92XkRI/rHm/+vz0Mb6DDwexGWq46c=
X-Authority-Analysis: v=2.4 cv=V+joQuni c=1 sm=1 tr=0 ts=6ae1ea46 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=hjj8zCE6y8JCqPeTDGYA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: Rp4ChSMwOiv-Fo28L9VYRo1aZfJXtT6b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX6G14i7WVqeBn
 pOgzZrVU5SAzvtx3DAO/DmeeAzQpp72vXxaLUgJtNHWpj8rELj5Oepmn2MCEvsFEHZM1Cfu5zP+
 ZdNOEg2HxBTQCHt8tqeEq3vNvMpXZ44jfNqQOjM8/m4rcjzp1T3PvkGQqGRQL6VtItoR9zwZ/KT
 GkKU6v8c4oFlxcvaWZvQRYoLyDwjyyA0wYbbuosuy86rNgKUuBZC8s2RWqCL6l/Fh1JL2XxFU6g
 o+fGIPOkLsJQpttZXyLGL/9k9KOaB/T2wPgjvNjjsI4L805quwkFkgLvBJIfDXxlq/oQj766RJa
 CpATz/MVX2nIXudmSeaJAD81T1HorZOLRIffVfegU8RNbLyGeUy93D+O+Ui/teyiSmPgXPwWvKy
 iSxdDobZ7GGyVoAzA8OO3Lw/3jbrzVn5OeQOQUC4Z1JXotCmHNrctuv+XENbHdlpZzPbfmQIxjZ
 L8Ni/EzyWAS8/R7Lbeg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280049

On 10/28/26 1:24 PM, Pradeep P V K wrote:
> Add UFS PHY and UFS host controller nodes for Glymur SoC.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
