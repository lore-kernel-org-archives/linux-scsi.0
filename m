Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE50292B44
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773723; cv=none; b=j7Z2C/jHjekifwgMg/l7756D4rONjZGGFUQwm3UdxK5Jv5yPYH+xWpj6+kcnaJV2GA7BSvBYsLwFzhr0qS0wxWhghi3fe9icV3XJfNBeeKpmpn706iN7pvvuuXnDOJm7Ttkoq19h2CjqswxsTfrp7rrF5rnzTYWHWZkjjimKm50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773723; c=relaxed/simple;
	bh=G9guphynNXUW98iSs3mT8MBJcIn3lVTmI0QZS1vaxyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eCwJCZN5DDjY1h3lBK6A7day6SiCLD7lQNnopb4bcofWwJYUV+l6lnf8mg27sMciJP/sOTuCUH383VEggJ5LrxnlkANICxPYvc/PkWLJMNj0iYw97syOwF3FEYUM8XQpMO36elSbJrP6CvJKNgVKIqiRlZZlcuHEPVJOLoCLKng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mEl/JXNF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XuiEOSGd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mEl/JXNF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XuiEOSGd"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6074tkil805114
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2026 08:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=7/ORuAlUmALvoZXoH/iZ/MKI
	plEqAlG1ddTTqoZoxos=; b=mEl/JXNFxLJJvE6uxbB87fe1H11fXhwYZABqNSdQ
	fQZHlZA2lFzIujLrYni+emdMKWB7lomO5QM7nTIwDePkkHx04gkh/1z74aN68BBl
	n6lSD6YQJrHHBHeSyr9N8Xq5a0TL1d3fir8O7TDoK/flHn58qy7H6rlWu9awaWUd
	e0Lyh4RxC5c/G1imEB5MRiQR8oSEmsrUGr3gQgz2GMti3g1iqcYGZedS2TSAJpLx
	0jqNDf8AQGyhAjjGmha1HGfZAvoC8Gp656ixro/deU8BzzjMCVD9lLgMrpLuGkqw
	H0LhIegKAkE1Lnn6M1ixT9ewSIJFEl4wppR39PP+LY5L1Q==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh7t9j3vd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 08:15:20 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ee04f4c632so33564481cf.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 00:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767773719; x=1768378519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7/ORuAlUmALvoZXoH/iZ/MKIplEqAlG1ddTTqoZoxos=;
        b=XuiEOSGdfL69TM+K1UQczYp1LFWJ84CZftNWB/P+FF6154Kgb22VfERnZHlCtoBvGS
         M7pYv+6S4iC74sA7mIzs0FX8UXDemU0jTBWfDINxN/KJt1EkJbciAoazPn+Fv2YFsdBr
         K+Erowks7BPSAs1cs7RrpKHfrSK/nzH2uWJictYKcqY9klsgaXKU2rniCAgBypGZ4qL1
         uNBCRINpUerzsBcQp3Bs08JPiV6bCrfQOecKLSLSpyA2MNB9dgdJ1aTX0S5O2gr90hDN
         BsxEG7ZLNQpbZYIiOQIppi7NW7+gQY5KQ8CWRMmhWDBgdDiqXaKuvpqnh0KWkjHzbhfw
         QYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773719; x=1768378519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/ORuAlUmALvoZXoH/iZ/MKIplEqAlG1ddTTqoZoxos=;
        b=mRY8N9SaImWXVppu3WHviRnPnCFJrhBDyX1K2lOlnRi3ydoSEanU5W9DXzkPvBMywP
         1EAAV3e3n2IRrV/y7+7Oblpz+XZwFVxflKS1PlfpFQBm1rEsQApiC5Bsqoa7QswtpYQZ
         JUVwz2FqzOpNj3hZMN8D4nripIaFGbGZ2GwDdvjm+SgDak3o1EkahIRLsMc+UaxVzpNm
         J5l6uWOIkwL1u+9UAtNSusH6wL2UwrvTgzPhSqcMcckPIq7iboj4zYwhNHAC65Enuahb
         8tRTbIs8UhcGCC4voXdC0oHobqcdzb9SdPckC5JoTsGwLPdhUrpRR4X0xZt7nJBZdRzy
         4P6A==
X-Forwarded-Encrypted: i=1; AJvYcCWlHezzmq8YNhIfu+yV0GOW/TTm35qE/h7YZW3jdpP4pJ8oxhQnHkPwsso7SsutCXaBTWB2Q9thLI+/@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1HmOvnOhlthUht2vVTXsVXCJBunE1DmKhQjijJZs+RkxS7VS5
	NhKcYySPk1LxM0xPPW7P0XM+qitdzsPXuLYgGDtQy7gTf/y2HAMblW0P/bGRM+1saw78g3Zqmd6
	6DyL0MoCgq7PkQtoJPweqPluA9YnZ1Zh5exFSbzZKdquL02YfCOP6/PGJZAkr8XZO
X-Gm-Gg: AY/fxX6MpO3DQe87L3O54ujZehW5xPiTeT9ru7J22eKOLTRrdRLLlx+TJt5Zhjmn2m+
	A6iAAIr2MXio8UBCNrsBsX+ei1vEEax5ipfGW1et2RiNHKjrNICLkK0e8d6fTh/EM/0t8gz6ZU3
	3kXKqyd1I8LyY1Wi1de+58ysxz7PVUMortHPNw4XwhTnVrfYX9sQHREYydWoB0fzY8RE/2SWtUr
	yMnb0VNmvOUTpyA9F8r2/jPHHj7ZZWbz/kZgPrAcXw1HYjYxu4tpyeXp8N1cDeF9GcwbA6tou4m
	RkEia0vviH6mUL8x8OonNPHaA7Pu30owPRos4mP8KcPub5WMWi63zDWEeoalQdUY+LX839IpPJ+
	c/f5WXnKG0kRb8UVHhLCQStU6QKRQljo7WZOZ8BQqKXOOyxW4lCwxHfom3WGgCkbxCPE0rMnSzp
	vB4u+gdgv4zKlfL0dmujrqFCo=
X-Received: by 2002:a05:622a:4a18:b0:4ed:6e79:acf7 with SMTP id d75a77b69052e-4ffb499ba21mr20710631cf.41.1767773719517;
        Wed, 07 Jan 2026 00:15:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELXjesdvAHb2vIW4ryLhR0dlhPdZd4yFCCjpn7vN81UbkGeRCeU9w+cIz6186R1d9MNEBuTw==
X-Received: by 2002:a05:622a:4a18:b0:4ed:6e79:acf7 with SMTP id d75a77b69052e-4ffb499ba21mr20710341cf.41.1767773719150;
        Wed, 07 Jan 2026 00:15:19 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d699d2sm1125644e87.87.2026.01.07.00.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:15:18 -0800 (PST)
Date: Wed, 7 Jan 2026 10:15:16 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH 4/6] phy: qcom-qmp-ufs: Add Milos support
Message-ID: <aubnydfer7ffn4wfezrbdsw3jov4rimswwtxkwqb2ojdkvpvub@yxxqxcg4tlsc>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
X-Proofpoint-GUID: -F7bjf8xKvnPEtYgr9X5J5yZd83QRXR4
X-Authority-Analysis: v=2.4 cv=QfRrf8bv c=1 sm=1 tr=0 ts=695e1618 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=wMCEmTFnA80afR0hZ2sA:9 a=CjuIK1q_8ugA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2NiBTYWx0ZWRfX00oY5+prq3Nk
 BkaXeLhPslT5xAqCOcy+UXtp6fwOhojV+en9xmEbVomjQ9UVfIrYBXNoiW1Qrh29zjEokHY8Awf
 KKRtSYoQmpP8F90pOwhFv0DLScf5i7XT+R2Wcy4gYUaij3mp8OXrwT3WtlnR2YLY2jykmpfAo92
 aarl+0FNEqCzlOWcpgmEqhCjC2uGnRl0LWmfKu15X1HNbCspmPBWApjlDCnotVPjmElYQCT3pg5
 mjMwdQuFFADJBR3cPrwT9pkOppVKPVtjmNxbrO4rcdWqq74G9z15sXZ/t+q/2N8Fgt5NqwEwetG
 rNBsQ+m+wWh3QOcsU/CoCbea1Dm1DIpB+dzxKvnNfBWe/lWyYbIdTj8m786qdknODnYCPRfpWA+
 4Bc5O6ZcxRR3u0Bi7o7BzTz0C93t8SOHrqL+ReRm7UI78P47JGxnyEi8686pnTPFbKtQq/sCO1q
 bGQWop96y613NMLXceQ==
X-Proofpoint-ORIG-GUID: -F7bjf8xKvnPEtYgr9X5J5yZd83QRXR4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070066

On Wed, Jan 07, 2026 at 09:05:54AM +0100, Luca Weiss wrote:
> Add the init sequence tables and config for the UFS QMP phy found in the
> Milos SoC.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 96 +++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
