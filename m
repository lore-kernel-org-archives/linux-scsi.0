Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792756557;
	b=VJ7ewWNziVv/OHVQcYIu7inZxoBgSgzQITqjkb2cHEQiBx9/PMsomQlLWM91lyVZFhBV
	 NxWvLofNP2c+nQOk7iY6153hT3aYTlDhebTAyAmfkrmKU0KoRCb0Cp4blWllkEHEDGl04
	 Gmt/fgB1J58FXNObUzSuWQfkd6eZ/CgSUDxpvnECJn1hQ8iqwk0ZV3v9526dxQLT4r6kT
	 5l3EaXCU+iBw7eZnid3SL5XFzDlHXUOzKZI/H+8m9VzXeF6zL4ztDZB3/dN3UilSSitzV
	 P+fZG69sGUqjlao5huHFoOWBA0b6BQ4GBbJA8n6S2DfpuZPfQ+RFojSNU25NcWzprtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792756557;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=0lfjro51D7Qg6x2xly6IGeYnaVRKofx4mi+Gn179GOg=;
	b=i/J1u1usxyF7wvYBxK5RyOSEexeGnJqQG6KK3AiCmHQ+185DdVDyMSmr4KV7ObM0ByZy
	 cc/afM0PoXaPJLaj9C2GLE6cXOvYn522e/znnmsj1R/LAXp0ceYNG17o96k2DJaWfabtx
	 s74fKexdqfTae7HJ3w9RndWaDMaQtu9Volu96q7HxFQ0z1evCGn3piwqte0q04n7bqUnh
	 xj967MCpCzVCWjbUwh1XSyCIIGTQqF5Zkd+VbXIqLX6Ly2CahIwu94ZWAjJds+cIFdYxm
	 Is7QuxLuxJ856UqMS1USfIxYi0NrK/b3oNrSxRzJ1Wo8w53CKNULXwyj8Sw7AFKWUyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cJKj8NvR;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cYaYOz3d;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49777606A31F
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:55:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49777606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cJKj8NvR;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cYaYOz3d
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAATSH2164232
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0lfjro51D7Qg6x2xly6IGeYnaVRKofx4mi+Gn179GOg=; b=cJKj8NvR2w+BX3vH
	+aQ4/rwe4iSgxxjXPyYptap1oi8ylQ+JWRjwFhCH4f9p/5hzCx84yZ5T8WByfr3e
	hQWOMHlXMxxAseNvApfRTki+4bd4EJdrAj3jXjQb8sQORdUov5EK7MjlkLWbTgwa
	QpiMarlh6BIUdOu0PEYscJ/j8oJSVXisuCa6qiy/kCYiGrbopZOO9f2Ms4l6NUYy
	TdsMKwQ+jb1mQHAsXNaTaIf7HMdv/DJqAaDoSWJ/RXOdbFCS86TyZo9VyVQKVWtH
	GPkL1L2LjaALQUBqeNw8dNZs6aE8f3UFbku/7kyiyq6P+IUCizodMfx4ZjYACj4h
	s3YbHA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfpahuyj9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:55:56 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93e58614290so17548185a.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 04:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792756555; x=1793361355; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0lfjro51D7Qg6x2xly6IGeYnaVRKofx4mi+Gn179GOg=;
        b=cYaYOz3dHrMA8QLUy+K0FHR8wkiPvoNdfuBbrASgNBtBKBjOkIF3JpmPeEBiWdsxUE
         hy/90shQOe91me6DwoBXoR284ZTCD5Sw2OP1HuYkAI8I95XSxhr58H8e2Mp8pTNlWuLk
         DSdTOcb4weaX/qPhFpTpvEwtRK/jTypBT8wuelV4XNc5i0ku8qTPL6KydsMLjDLrzGZd
         AiTUj+LJfScobF+l1eNK2FbFTiFDzy7lRKyk2wcsvH209mOMHLeGs2h5GFbb2Hli4K2P
         P8DV/K+8fx6LrDVrx6Wn7kcdovqlFMc/RYne3i2PtGIEhd8rOeT7QNkl3px5q42GJXcv
         Y1AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792756555; x=1793361355;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0lfjro51D7Qg6x2xly6IGeYnaVRKofx4mi+Gn179GOg=;
        b=fdGVFbVSnwMJd/iL+F6XkrLUL+iV+9DnctCXBWDSJ7+op9o8dB+OlbfxFpvuhoCwXD
         9Jl0kh5TXxycEHrOCjXKZb7Yc6dqF8uP52/1DiwR8v/TxFsMx1Y221VLvwfgfyhvxtUY
         nSio1L1TLkBqOZ+BmesUVuhwnG42ycGaTdYSh943UlY7Mpi9DAaDLOHQ9oOL2YrPNgDb
         GR73cqA/id/iGi0US/MPTli2RVIzJpsZDPxjB0tGdFpAQSyEcS2P1Y3J1uz/Ury/gwq3
         YLmS73PlCQ/ilsSzJOk4OhWCXaGgOJ+kf32ejRDpK6UA6Z6O5kVRIRX+qms7BI1RqhUO
         xfbQ==
X-Forwarded-Encrypted: i=1; AKwUvBzqZS4k+SslqKxy2261k+C+VU4H8OuKco5iLIAF8agt83613L4t9WVVbUMOs0jxaBYSVCWK1+x6upBr@vger.kernel.org
X-Gm-Message-State: AFq9FYKPmBYBiA62Ka4fdKgAYBDqL9BKzwOcJjhJoTHEP2A8cvmnc9jl
	ma+z6vPL61kjIIJOkBCxziMO3ePoDewBCf0kIwQUs7w21OPMD7W/Ic24LTsY304oOkCg8wQMGno
	WKMXcIZr10ZSYijvuJTDV1gU7LAmS2kKhaYVwzBp81c/BaH9Ohv2RvBVthfanabtL
X-Gm-Gg: AYBFou0G8L/Vh7ze4x1YjJngRs/8cuHHeZj5utiEgtwqhJqjnoAu5eRUYJN2t23++NR
	ejggE0CJTAisTbx7F1NpcXuoLJTr8NkKXR9Abgh38wNMg34QSQtqkno4rEZf9Crrk8XYrRz0WCm
	YXXNFhf6Nq8YkqdMeIdlZvifbf5xgQqurlGCCB8Gf0peX3BkLZ4tidAtZS7PMYo7aqF2e1NC1ee
	lN3vqRcuB/0Y5Xb2oiqdWCUNMQPxiO6sh/e1S9+70YARH7GZeOFoSXBzk0q3JoPw+bqBjGF3gyk
	MYju2HhWaQKPgM5pE3j3Y8z3Bub4D6Wbm7MG6wm6NBnqj4DDiGTk4D3wrLE6EP393q9Zq5Iebnb
	VIl7vXXM9DdufC0WyRTpRrw==
X-Received: by 2002:a05:620a:a8ca:10b0:93e:5a3f:ac13 with SMTP id af79cd13be357-93f6f54812fmr372791385a.0.1792756555396;
        Fri, 23 Oct 2026 04:55:55 -0700 (PDT)
X-Received: by 2002:a05:620a:a8ca:10b0:93e:5a3f:ac13 with SMTP id af79cd13be357-93f6f54812fmr372786685a.0.1792756554732;
        Fri, 23 Oct 2026 04:55:54 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5c4d67bsm95403966b.14.2026.10.23.04.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 04:55:53 -0700 (PDT)
Message-ID: <feb43c1a-9f1b-4181-b663-eab9e55e4831@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 13:55:49 +0200
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
Subject: Re: [PATCH v4 3/5] arm64: dts: qcom: glymur: Add UFS nodes
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
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
 <20261009-glymur_ufs_qcb_enablement-v4-3-9a6ce83195b7@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-3-9a6ce83195b7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA0NiBTYWx0ZWRfX2c3hWTc8pc0C
 i6JSlKz3fA0NPZlvWN2R+nPHO5rJyfFX2dMvP1xNs5V8A4BfVCiv94bInddbCmJUfzvsCYAh2kO
 fdP2OeAVqWH4n4srpC38Cb7nF3eP8C8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA0NiBTYWx0ZWRfX7KC9vaDPvDUD
 rhFqVBf6bio3I3jvutLEppQFAGfJM0EcEG49+A6eV0htB6MWeQ4me6teY4+KBpE86kHmQj1SFZj
 XsHm2EzV6L+9EsOkKdSCVTIiEsnnPOI4B8Mh3g41+5KHHZsDnlY9cid6Iy1EMQDtNw117Etp4zK
 pI1KKZqSwLCeO6fN+ImFtrLPZNCtWUkQBMJoAyF7QmTcN0H+mAgw6AvxDeR+THFlYbwqSiVi7Aw
 pNmaSOzP8mhp9X0TaAZlI68YU6UvLcuGz384uSMQRzfwBpPDl985B5jtAdOH0F86ANXGZniT3WT
 BRZ/XZYdS7lmciUPeywNK9xIfmBD9hG1cP6NpABDaMeHGq7ixzGZhSBHvbQoq1znXHfednLDmzU
 CKhqOMQYUo+Y1aCoMQTNL1renSV6LewlC2yjZlM/DaKC5D5UzOrXCpjRqc4VVVCToW4R1DEF2iM
 luLIMX32vKhMGis0Rnw==
X-Proofpoint-GUID: XY7c_crwWunFXbEkOZ8Lqi32Djp5JxHu
X-Authority-Analysis: v=2.4 cv=YIMKWhGx c=1 sm=1 tr=0 ts=6adb4b4c cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=BBNwevgwxSeHGHzN-EcA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: XY7c_crwWunFXbEkOZ8Lqi32Djp5JxHu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230046

On 10/9/26 12:35 PM, Pradeep P V K wrote:
> Add UFS PHY and UFS host controller nodes for Glymur SoC.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

[...]

> +				opp-201500000 {
> +					opp-hz = /bits/ 64 <201500000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <201500000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>;
> +					required-opps = <&rpmhpd_opp_svs_l1>;
> +				};

^ this should be svs, not svs_l1

Konrad
