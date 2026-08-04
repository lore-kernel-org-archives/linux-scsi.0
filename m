Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C43E3815F0
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 11:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785844074; cv=none; b=MlisSDVn1/TDDlY60a8IGQ9w54/uAtmU33i/9PEriQRG/9ODh2rQrgZY7M5nTMWdkhbmMZQ9TRvI5IYNH7P1bNpS1a3hI1XBFhYsdyVeJXAEQNy9rs/EZ4gWM2vbQnm83iL3dPUEXV+FhR7U8QeKK09/I1jbEqxiMD1SZoIFIcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785844074; c=relaxed/simple;
	bh=G1A7cOuC43/fNsfoEkpiKhgkIubIHQ/o6++Z32Zkn/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHYM/pTKnZ6RtJyWiReh+L9VbWrB0M6EUc5ossPjbbNS1gq4jcumlB0J0VWpIryF78Tj2axTrfwUL2fmkLE/fJjQWda2IDc9YtPYAt1dyZ/zL7yd8W3EUEWBREMLoR0bQINMJkMY8KAl/dINn5+rdPubIFQTMf6LLm55oMkWB9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LOB5PI5A; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DCMVpxp5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LOB5PI5A";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DCMVpxp5"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748vVuU325561
	for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2026 11:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=5HlDOvlq5IfKTSd0JcK/ulBI
	iCb9/6O8tzxaTdb90oY=; b=LOB5PI5Ap3OC0Nxi7ryVDtoUHjKAVzD+2FKbF2/m
	vqgBBF/VCo488r1xdCfb4ux5netmBDqjhZuDK395Z9T8NBj4OGGPU6FVJ5CzHdIb
	uyqxvnJ4VX32z+buinVvLXh+IpJxgR7HPKBvCGAk7M5ZCm6SQ3ovhtuEHqI3/OYm
	7nD/fIIW8SnWULw+5leRyxgNErAe+KGXXh1D1MyXGhlCWWbtUwxykATlKqm3GaGc
	BXKbaKBE3Z9OwO+cUvpvAiRz3dTz8VQeTPdcJUgCIGZXS/wP7nXZeM61IMn03iBQ
	dzWyB4MvDw4KYeN0mxjJc7Auj4VCjP08iJKHoAzyBpT9CQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fud1dgmrh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 11:47:52 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-907a1e04111so60010046d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 04:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785844072; x=1786448872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5HlDOvlq5IfKTSd0JcK/ulBIiCb9/6O8tzxaTdb90oY=;
        b=DCMVpxp5OUunanUodNB9hI2LIvMCG40gitFv3QX+fwx40VLH1kjegWA4ntPQH5/G9+
         pKXiq0DCFFXVI3Ne6njxfLL671ZNCadUTbPIEv9F8sCRuDQYU5/e1xUp66+jxKkdCG7n
         y2IjzIP5NQl7PD6G8nIpaikX6L8CMbw3XZ/FA29ZXAPRC1gZgJHOyXTvOZdRYe5atTUq
         sBMUM/1+UjNYhKLU+29VH88qIDsqX8rVCAfjvZZmtzlUE2aoyo/vOLdiArW72K2OoQEx
         kCrRrn9mk1hDJ+zl/VWOCHtDFekwZD+8aoRcxF6mugd7ot34M/YFZeC5qbROXq+MlKoP
         GrUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785844072; x=1786448872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5HlDOvlq5IfKTSd0JcK/ulBIiCb9/6O8tzxaTdb90oY=;
        b=bRNW16xleLrFrqNFF8gzQ7KSY06WviLEWPXBGi5y+FOVaOdFXfHswmsy4evcR0xK4e
         QGbm7qIuyNwOhAv7eicW8Laiuc8GOXgTSQRzgb1wEXrvDgFszhF+9gEDHAuU23ANwSVB
         zkw9aX3eeFLSL0crDLMMQAuGiqfdHVEI/n/7sUqagwk2JxNe27bwKkZki47U5CusswkL
         nCIXaheXE47zsfDTgAtC3YjqTzpufzIWB9pxidSN3uB2yOYT0ANMMi9DXaFvZursH+em
         gIlBrer1mX8GmM3D37cGVUdrA8B8nEHK71iDMoXNuax20MKhnNoA+lK6iM2bsg86HM65
         PXmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpcixk982auxLXWnVIkdU+KJkd8SepEKDB5zGDz+51r4NgVHX3JURyF5gMjl5JO8kqjaGf5Y4uO8r73@vger.kernel.org
X-Gm-Message-State: AOJu0YwOs7XNB0j9FJEqcfin80KbCSvF/cc2/mBNQJhZhSMuL2pw8VPo
	dV1Uw54HxFISU9FaK5XGzr/OM10ZoZSaYnR0qhUrseJ7VVdsXwYG09rBd/y63FtTc01o/743OgC
	zJatf9wrqr54Vsppw7/VM4/l6vUZhByHb1j/6SxI9PdJT8sNmTYyR5NEtko1Lg5pa
X-Gm-Gg: AR+sD11PyLtLUAbfPce6w3Z3ExgLOGjLTrrN3puGQ76mv0GdKPn876AXwpoufZlp4zQ
	qbmZHS7Vjk/QJeY8pxyninnhJV7dvhFFaIOgvSOf4ipBwrKjM/MP2v8TepiacjO4XaAHI1UlGKv
	NnV/OcDVR3qbFXMoRT3ElsHRLKCjh5BYW8+/q/ME9ciW7TpGpb5mKspIUMjvUNjcLfwY42NlAgn
	fdlljw7eV6D8bg+nBfF+5fsuuwGFI0yJeDP4LV8W5Nt7yt9unRo11xF7NiuJMzaBt33xExFX/eu
	IqC0iyzkW+lIZdFHUtQRPf+4BShDVgu4ipAyO4eqrfLSwAkvmzdxcccSC7Mc+Z2l+gLK1pY6K8f
	mW5U29yYuzDKU4Q==
X-Received: by 2002:ac8:7fc9:0:b0:51c:16b3:351a with SMTP id d75a77b69052e-52b5666aeb9mr244779261cf.1.1785844071522;
        Tue, 04 Aug 2026 04:47:51 -0700 (PDT)
X-Received: by 2002:ac8:7fc9:0:b0:51c:16b3:351a with SMTP id d75a77b69052e-52b5666aeb9mr244778731cf.1.1785844070975;
        Tue, 04 Aug 2026 04:47:50 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.37.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd42d91b3sm45875069f8f.14.2026.08.04.04.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 04:47:50 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:47:47 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, luca.weiss@fairphone.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH v5 1/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Message-ID: <sxfku6f3ypfzr3m372522s2fclwlzbbxpmjdoxb2yixutaquzg@yxki5dpxjqde>
References: <20260803130852.1432714-1-palash.kambar@oss.qualcomm.com>
 <20260803130852.1432714-2-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803130852.1432714-2-palash.kambar@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: N4ZfGA1ksoVKKGfAuJtlqLkL-Md-Bxuq
X-Authority-Analysis: v=2.4 cv=SJRykuvH c=1 sm=1 tr=0 ts=6a71d168 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=Afnz6uBANMlDQL2PJxecKw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=fE2qAJjRsTh3fKKuPQ0A:9 a=CjuIK1q_8ugA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: N4ZfGA1ksoVKKGfAuJtlqLkL-Md-Bxuq
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5NCBTYWx0ZWRfX5lz4MdaZBXEC
 JstFChpbTXVzJkk495nTdU9FgD4MZu3Kc49ey8hvRcN2twAEcfmNzXVhiQMEncDy9+Rx5I5FdfN
 3lxMUUZEVd/sUp4m0awmhkfbz0FHszU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5NCBTYWx0ZWRfX4eJcZXIwPo/T
 C5k+xPfpJCwUxpmyfoUAaxlARr/HSk9fGNc2+DvnegM0qxfNLWgU3E23Gjk4WzOj6NJgJBe82/M
 tub18jFdAzjue77YCzppATHUP3QCkPWEsvOdJImC+6/A76RWrSSNqHRoLv4lPc7XcKq9Sc4V3Pf
 5+M0sHa4octFW/4V7UKI+7lwc+t9435o/YFtG+2gSKW1HUQ9lWkGSaOMy0If14335/uhxsekBd4
 Fd8fyaUve7ByiIdpH0xofAXOVYFC6X8E5vVZeeFzdmUjGxYb3nTYaJgtHteM5Mh2vGCzqBBhAx/
 EvK83QVuhi+kdULJQ6YHGNM/v7qOyxkNbtV62eSp1TYi7sYG6ZOAMeNenqD0J178IPvUPOsRe8q
 NXq9Ptlu4XQV1QimRFIwbX2cQ6ppZ+PfpI576iKJJjQVGoWpsUUtiptwV8Qec7TIBTxIelG7wkR
 TWCVq8KExtNjxqDLc6g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040094

On 26-08-03 18:38:51, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Add the init sequence tables and config for the UFS QMP phy found in
> the Hawi SoC.
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
