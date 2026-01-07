Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC742877DE
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773785; cv=none; b=NpRBgFLo+eEgTHhwP0hpuASiNcCVZWicpYTwFP4rp/GJJJut5gzazqrvuZcOA1tO5NKry30HJMlggZTIUYHdOCgGNJWqJouLkQJ/6+aGHRO1n/vYDiwCHpVsRNsDmsIhqz+RAcsGdYq95ZVYPpNUKvr51/GoFj1zmuVYamYXyM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773785; c=relaxed/simple;
	bh=b7llptmEDM1luO25/hrBZesC6P53tyMBBRiePAFHdsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lx8i+/qwXvf8rDjehkYB23mOHh8nFNv/QP2gSyVzIMYY0/IOXkEmgnolzciaEviHxyGM7BFai3v0law2MH2iokCcv70hYeqUoqw5GYet7fT4dQeojaUt4G8rFGQQRK9jtOez9Wagj4k9+fJP413iNZXOYweB+a5RS3Z0ApXaZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LR/cx1/g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V0Px4qEY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LR/cx1/g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V0Px4qEY"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6073Yb3l3888906
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2026 08:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=yBB2cmx9lnK1XlQC3aSe2Jwt
	16yLObyrRqpkJZ/2ddE=; b=LR/cx1/gvwPOxL+YejIBsjQdZ5fGh8Rc8g+gWJRP
	2idfmcVoG6tvuyNsbY4O3kV7FHwd0ModGGhnGTfUUA911Dbt6AUotxcj3WMDQvIZ
	Jp5j/1NOpneX9sPFOOxWkCYDdINnQbTo7m9O5dDCuGmp6j4WbhrArhnHinmqznXd
	gUNVQ3vwk09lVhrMmv/Zan4Byt1V4Lj9UwSvIH6X5EI3bcmDq3/6hvX7NOY+piZ2
	q7uY2FiKBf9IvgzYJh2DO72xT7GzRnKEaOw1wpI0K+N9JiopDqD2bCC4Qg+y0SaW
	jofwXJgS0CN4jeeZqsPERDqcAJ2Y4f2BGmBxd9MG942fVg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh6a0jg72-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 08:16:22 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88883a2cabbso76389326d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 00:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767773782; x=1768378582; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBB2cmx9lnK1XlQC3aSe2Jwt16yLObyrRqpkJZ/2ddE=;
        b=V0Px4qEYEnaNCxlzZaMNjjlQeH2zBz5wqR/J8fc6WZCLgnZ250GS43rczKda0vRKVd
         rEossb7CmczdPahyE9IVueO9IO15/DReNWAGF6CHeneRWCgGOElhZLUuqNvfU3fYYB9q
         bZhgNw9iCN37CjiTIB4bR8Oa1GAzTqXwy2f7yM5j6lmUZZIggSbVEmiHKU11p654QOje
         CpKgfBcOf7zEZALdlCqhrMT6zCgNId0VhWR7gaLKe/oQt7yWZOo9ucQBVREomEEtm1sd
         wDbTip2YUCJZrIrsEGkowsQZzBwt0U9pLg0Z5kNIKO2cZpgtPubb0iVCoF9FQfus8AnO
         p2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773782; x=1768378582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yBB2cmx9lnK1XlQC3aSe2Jwt16yLObyrRqpkJZ/2ddE=;
        b=kI9Gone0CqhWUgD3pvGxlrpJAUdXWCiEIroudPZ/hGnwfzXeGYzTptgKj8Ix4Os57q
         H4lFRc4d9Y+dnFqmjFsKU4L3a8EJkiM2tlZHRYjPvZic6Us5BY/Z7Me5M7vQSiWT6K5F
         U5WbYbOw/FEYk8gFfhBelyUIRlFTODqT9MO7wDnBJNgW3SfW4j7BIj6fvAV+5ff5ogSH
         4xd89FqjuPAAzK5vgCdQPJkv6nywwYGQ1zvx/wl6120hVrIkoho3fnlmbpjqyWFMFOnQ
         vR8GAij4WJgDeHH+o5Y3zSp5/LLTrfGxyBeqhksbV7Ssbh9gNFy3vcpoodkaYkJJn9AO
         y8ow==
X-Forwarded-Encrypted: i=1; AJvYcCWMH86TDx6hlhzRkNhBNBNXerQsGeVv0kpNUCrZ7qHG4JcfpA4tZbxgUK1R1sEyspvd+DEeK1L+ijKB@vger.kernel.org
X-Gm-Message-State: AOJu0YxY1X7N3xX90DpbwMejUztybgp75MksyonmClYze4MIb70o8RTR
	KeIZQ34xb3USJuW4bdPcEb8vhxy3Ymjb9P/cqm49DLjO4yjcyJ2VfNijtN6SNYGfwAMYVNrWiCu
	JmF5eTs0tICJsIQ8l72C6KJkZpjAivVRKy49aRDz792CXvoA3JQ+Esb3jPcbh9HoN
X-Gm-Gg: AY/fxX5je4OqKRGFZ/e4WorHw6KhsW76Qll+9PCBZeiHSgiNgQ6z3f9tGAqK2nuSzPe
	5cTn34u+yy2VXHtbrhH/Bh7rPCJd2+du7LuvROiSaWo9jtyvwq9jafrR0OyRlYwdfIlOeIjvGy3
	6+UpaDQ7LDiIPDPyVrMjPlRyjZOsb0luLqvvvJuEpA+FRYxPU+8dujObM3eKod3yD/d0ljdqkhi
	urWJGPzcVs2tyysTT+m6AHJxTranLRavUnJ1j2zEPq37m17ss920UAjoTrk4SkK9Ne8lC5p+Nfw
	9HdagrZmUG5EqizfE8DDZHPUzbohT9UnsR6+Rt2vyW+eT2qr0SyoXVGxh73JhIV4wpLiudTXCrx
	l73ahx1l2ZQu4Pyy5oa/RsUksIi+dFzINIzoXUe8loBzsXUbYX5a1UCzpV/pppqRdraUJnuSK00
	HgH2RiSbsiOpAgIhmKUoDXgYo=
X-Received: by 2002:a05:622a:209:b0:4f1:b9ec:f6a4 with SMTP id d75a77b69052e-4ffb48f03edmr21060591cf.33.1767773781762;
        Wed, 07 Jan 2026 00:16:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdihUJiADpylFeISDLyhuutWUXSisSGVWPGAH1SHUu+jl7zZy3/SG5e0+6NwqMIu0tpq9bRw==
X-Received: by 2002:a05:622a:209:b0:4f1:b9ec:f6a4 with SMTP id d75a77b69052e-4ffb48f03edmr21060371cf.33.1767773781370;
        Wed, 07 Jan 2026 00:16:21 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b731aa442sm75691e87.95.2026.01.07.00.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:16:20 -0800 (PST)
Date: Wed, 7 Jan 2026 10:16:18 +0200
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
Subject: Re: [PATCH 6/6] arm64: dts: qcom: milos-fairphone-fp6: Enable UFS
Message-ID: <plypx2dvl7hbfokvuoydzdgqhlgy5ch5j3wgsxtrgrjlce72tz@qubblpc6x2jh>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-6-6982ab20d0ac@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107-milos-ufs-v1-6-6982ab20d0ac@fairphone.com>
X-Proofpoint-ORIG-GUID: t8dEdwLgauIETBW0Su-lAWfATenIj2Ij
X-Proofpoint-GUID: t8dEdwLgauIETBW0Su-lAWfATenIj2Ij
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2NiBTYWx0ZWRfXw+XF/DVNTnP5
 OjSFUm80dKwzPLEQMxA+9pNlQBEZn2s2BoMleULn1IBHTxY260zt28E5Cijo5ic+xBrGKBulVdv
 nZYquBdIlpp8aJOpIR3IT3v0scfp3zqlw085c7NTx34f3U1+Ptqsrgaoz/1PULilyHrLAZklWr4
 VgHvEOXB7OBtllj7SPkztl90smYP9jcKERsmm4O6kQZ/uQIzk80lFI1/GKu80cS5XAmu4RkUi0h
 Q98/28CA812b3BLQC2ZUYq+88s/8jVLkX9P8AAo5VUaVh6RqVqXxvtfLCj1WEQVQ3HVt8E30gP2
 cgDPMWGgTQXAu6tbkrGFh7j/0KahRuI5Nt5Fq63ETAutOKOVFYpjMKmZnySgR5vVCTWYlwd0eGI
 k4/Ae5u9BoUWpdJMD1lxNSV6V04UTOqZZcDbGCvzF5jEdquyZqQ4fzGPxz8Y+tZVqyxO4Evt/r8
 SwECOwmMNuJ46NOFZBg==
X-Authority-Analysis: v=2.4 cv=MtdfKmae c=1 sm=1 tr=0 ts=695e1656 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=STFXn1ACf7ZPQ-DneOQA:9 a=CjuIK1q_8ugA:10
 a=zZCYzV9kfG8A:10 a=1HOtulTD9v-eNWfpl4qZ:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601070066

On Wed, Jan 07, 2026 at 09:05:56AM +0100, Luca Weiss wrote:
> Configure and enable the nodes for UFS, so that we can access the
> internal storage.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
