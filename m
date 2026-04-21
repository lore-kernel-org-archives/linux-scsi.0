Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC7364EAB
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 05:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776751144; cv=none; b=VINlkJJnQ+zmDBFzWEhh42LOgLwqYdNI8ZdbSUSBi1xjGQU+Ib1dU2A3erPYatjVFRMNeBQhf1IgobqGVw58mbZDI+KE6p/G4WF5QEfa2QZdfkn+/xzMfC2f42ama92f3E5wKbpX0gmULhjxZV2OuC8+wTEtqApXd9XlIkUYZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776751144; c=relaxed/simple;
	bh=g/CnjycFgb/w7TP6KvTEF3kp3w7+Ae5Ok2KVIGyAFS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbdvDhYykGlmWLLo0WBQpSAxivMhW7B3RBsltcAlYi9Pqi7EVJhE4ASgSqUZBfKUcwsT+Q1hfN/jWLnw4ShbVCmI7StW5Rs7hG/nqqs1G9fRBFlFou/c22c5aABo1W6UCmLmCN0wHaB9eB63KpkM0v0CVVjIN0pjqYn3fnxm5Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oyWCfznJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hY2jaFoD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oyWCfznJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hY2jaFoD"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63L5UiB71014344
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 05:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=PeWfUqzN8k4bN1hyibqxpIMf
	Lo4P6txvt15c1HjmL30=; b=oyWCfznJOlCpoLVqg7TNw9mxubIG3dcgiHoLOrId
	hM/cYoLeaIRmZqQ2oa2mLIXuRk+OcLWViPwogHccQcIzS5TvlqhA3AbhZhawLY7b
	5ztKvSHGwyOYF2+SxdVeGfDyXOD/L6fBsCkENd2suYCfjQY+5xa/jP5zEfwcO0dw
	AhUGjZCMACuGx25QrqjecCD5Hnrbc7nS78xNALtG80i0NNw/6CIPu9Y4revAuhEA
	y7URE2VD6BSD7SqlJpdhLDCWzYIr5iATnKhFUqP7/DTTT76dvxDio5z/9rFTf6Sb
	RWubMgPEPQ1C7Imr0tkRWzEdoIgx4b/UxvAlUaG+6AhvZA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnt901qdn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 05:59:00 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2ecc96a9aso36064385ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 22:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776751140; x=1777355940; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PeWfUqzN8k4bN1hyibqxpIMfLo4P6txvt15c1HjmL30=;
        b=hY2jaFoDAkXd7ZdnpT1mjUhm74I6IsdSoV/JG28wL7OerzsumPXVC4+/nmaMzQlUZL
         up9FyK7UpxISR5lXV0JXZV8iGpbCtcbuZtyh+GEG2LY9MPCvTh9Hcly8Ghk/NklbES0K
         rVmLfT9+L1uJ8Nu7FnyFCzVTbMvd0kXaNIWntualvmv5ferWz4ddS6S+8sMmk6SEmPzD
         ynCQmorcwPUz3bzVnMKpzOFTTq6DwNuQph4rMKTEZ93FMSrupTovftZRVBDG9qkwq+p1
         5JDg4Jhn2I+kAuJ1y7/GU1qb85s9iVdEsm/lyDHI0nJh8+1gIDUFjfdxrj8vO5R1WD95
         MdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776751140; x=1777355940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeWfUqzN8k4bN1hyibqxpIMfLo4P6txvt15c1HjmL30=;
        b=TEwVEBrR9t2vTUJ5cXap7fcMy2sJXYHu9DZzonV++BPudMhUFqU2Ig1Ao37MLSf3kN
         yXgZEbXXjfyZnKhKrlfRMdcnELM5eS3oEThLMtPeSfzKh1V9W1n8sk5IHvq78HUIMt6j
         BWoyqgf9u6+K1p8Dx6GEKZzi3SNykbJUVyG9sL9s5KHar0GhllgGgfS4QylH0SRPhJS0
         C+yYnx2VR1qOYPcCsOUhLBCZzeb2kEwI3HLcmJP65N89P5bmDfccPgeuyk1FgbsBWnMl
         u8LMv0lfqd7ZIk84AkoxZK9JeZKL3m+O+VkTSHMFTTa8RESm63kjrV5nsedojL76YlOc
         SsKg==
X-Forwarded-Encrypted: i=1; AFNElJ9zBreTdqD8iHqPDbkjeAfi3RFtgFrO/E6i3Xbigo34f3LTM8Hx4BuDTIX4If9a5cVmIVFxIyu10l0N@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3dE8r5rHtkQ8qnUJoWW13ZygfUADZHm9OiSf10uW8iTLsPX3j
	7U5//Fnc4nnygU92YFSB00jyUonHpuTV94B6SexIJQh7g6SIMH4NwNdN6/fUWQvOhY2BdD2t/Aq
	nII8AYu0l0QiAtSGRbG0ipBXKE6522nLJhuemojPExpM8jfda6oHrFmgLXn8ygqyW
X-Gm-Gg: AeBDieuUM3H0tafblskyQtcCHo3v2GUxdqHHegkODpcrQA5ODMOTp/6/iu3Y8c1salQ
	S9xNf4tIaMIWMSQKivUoiMxVq43uCQ+YmXTpYcVGVeHUz5n65+8y6ZqhsBDcVuCRPrCXNBW7aG/
	Vq3zAKaHXvRMX2gL1ueI6k4S9OkxwnON33Uz9pqh53tTRx66ulh01S20yqrLs/BeKOZ6vvyyuLw
	h1EbxdDrGz71ILqyxEOz/URWjoOgWqMkjW+bZWaTWvgAZaRPh3VID6ZzQ0i34bpJsuZ0Eg1dN6Y
	zi9dqBJDWn7e1Uyl4WqwZUGUOCpeyv7WJkJ3UTNuuTMFoKgmb1p0CWcrPR0E2F/EWoRgP0SiJnA
	tz5vdSlrc/ZXbzUP+S5Uww0gM/tixmOVpyPRodxyL9uCtzH29rysyqCO6ttSLNPsmQCxszQ==
X-Received: by 2002:a17:902:ce09:b0:2b4:5d87:a1fd with SMTP id d9443c01a7336-2b5f9fd21c5mr177240675ad.27.1776751139690;
        Mon, 20 Apr 2026 22:58:59 -0700 (PDT)
X-Received: by 2002:a17:902:ce09:b0:2b4:5d87:a1fd with SMTP id d9443c01a7336-2b5f9fd21c5mr177240255ad.27.1776751139098;
        Mon, 20 Apr 2026 22:58:59 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4049bsm112915165ad.77.2026.04.20.22.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 22:58:57 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:28:50 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 4/5] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE eMMC nodes
Message-ID: <aecSGmAWyzf04BIU@hu-arakshit-hyd.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-4-ca1129798606@oss.qualcomm.com>
 <cb6b19ff-811b-427e-a588-cb85c6854da8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb6b19ff-811b-427e-a588-cb85c6854da8@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=KfbidwYD c=1 sm=1 tr=0 ts=69e71224 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=FjpnKfaMezcxXxbuv6AA:9 a=CjuIK1q_8ugA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: WCR18kW3kAZH5tMY4tjTrCUsHglXse0D
X-Proofpoint-GUID: WCR18kW3kAZH5tMY4tjTrCUsHglXse0D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA1NiBTYWx0ZWRfXzgWe+/O5aTIC
 hKo/6aGP/QaGT+fgiZz7IOUGUK3hfSsX1Q2qciJDe4pYpFHk8aPrHaJ4dVfXFa2Lmh/Iw3xTaxn
 J3A1enUdqqt+J7k1YJw8JW0gIftk/bVWFm2jU2iZaN70xnjtVE/VawMKQVPHuWekhp6NVmuR403
 jRbTuQ8QTx9hLGXx2NTzremaq/qSOFhiQlNLiTkNHCMK6kMOJ7GSncLJkF+5Uou4MldBKOURQuT
 oFb2Fl2xiq4PzzmWP4zilw4JLgD+94MNS98rpDK+BVHSK/ky1EkmKvIdk8mvrpatTUGaMMSQ7/2
 y6HE2uHTbq5UszySdoVhlSivHgAcfHMYUfbmaxSF5UvIdLNo1rYdHD7LUJrhjqSGQCIbzSqsDAz
 pwFHfZ1GYuYC+1xJsYLFnBzte1g2NGfU52P2xYxjKDknHiNtWZpT5y2ap8OJzEjK7kDb4AYO9Ch
 sv2+ZZ9RUe0v3Jfb7NA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210056

On Fri, Apr 10, 2026 at 04:23:51PM +0530, Kuldeep Singh wrote:
> On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
> > Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> > an optional OPP-table.
> > 
> > Add OPP-table for ICE UFS and ICE eMMC device nodes for Kodiak
> > platform.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> > index c899a17026fd2a10ebc528a816629c88ee3bde5d..b0aa1970d42a3bb0b9d371e0e6cd09b8cd164dbe 100644
> > --- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> > @@ -1087,6 +1087,27 @@ sdhc_ice: crypto@7c8000 {
> >  			clock-names = "core",
> >  				      "iface";
> >  			power-domains = <&rpmhpd SC7280_CX>;
> > +
> > +			operating-points-v2 = <&ice_mmc_opp_table>;
> > +
> > +			ice_mmc_opp_table: opp-table {
> > +				compatible = "operating-points-v2";
> > +
> > +				opp-100000000 {
> > +					opp-hz = /bits/ 64 <100000000>;
> > +					required-opps = <&rpmhpd_opp_low_svs>;
> > +				};
> > +
> > +				opp-150000000 {
> > +					opp-hz = /bits/ 64 <150000000>;
> > +					required-opps = <&rpmhpd_opp_svs>;
> > +				};
> > +
> > +				opp-300000000 {
> > +					opp-hz = /bits/ 64 <300000000>;
> > +					required-opps = <&rpmhpd_opp_nom>;
> 
> As per hardware spec, 300MHz is supported by SVS_L1.

Sure, will update this in next patchset.

Abhinaba Rakshit
