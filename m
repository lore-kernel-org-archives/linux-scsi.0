Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E9448D1B
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 13:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789736525; cv=none; b=FzodIjGZ+WKFDwaTNzBnv2GsurKPZh1a5f4eEm2uundLcYj+VL3RU9CmYtl2U52Yo35ChZUmDiwLw9DAXrjTg4jYJBOX6oCgsnN2pJfLDidcpT5XS3asX5UggtzTN70kiV9ZBAfrkhmVjId74ifjOqVpIOAwg8ki5AG5cJK7U5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789736525; c=relaxed/simple;
	bh=y1bPt6F5nrd5HOptM2+x7SSdZZR6HwyHNglhGdwATAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rh2IyfX+I12k6HBo54V6R4tQ5s6I58/LdUIIir5mjzoaNrU0yfr3IP96bQRfpmL1kg1cNuvEVrhdJUTviza5Dqy01nc8u+ySbHaHyUxJE17KCEdtWnILX+ScItJ6LBl6GbI/lIfLBdw2QMpl45BK5nuZpYhNkhKezC8n+Lc6Rd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gh5dBrNY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YBC9XPDi; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gh5dBrNY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YBC9XPDi"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ICuHxl4177493
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 13:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CKF+BfwHstfALzVlcYgGwDp+dczQ45u3j4MVRIZQmGY=; b=Gh5dBrNYIsC2hxXS
	6O8pqGCerH9URA9GezaB2NtNLgDy7tT81mqkbu+ZxArfztMFmlACeacbi6lnSU8J
	vJWjze88rAH9ZHt8vRcLhdH4kmbexlGUG2P5HIvCIWH5sr0F5hZYDAFUZ0Yqmony
	uelO/RAu+aZthmFXFS1GYiNvsF0H1fie0tqOIY4YKOxXrQlLTBQHjg9cVxHpdYCV
	JD3A5r8KSgZHxkCT/smqduSH5sKnXaDogP932RMBvEXymmdwwwwVgG0akofCdLS4
	XikZljYonIzJvn2vbQgZMFozQO3FYuRnwTycd69dc/bE3ywZBKFAz5su7fBgYm9G
	vvH0rg==
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grmv5m8cu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 13:02:02 +0000 (GMT)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-451b3cca625so197161fac.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789736522; x=1790341322; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CKF+BfwHstfALzVlcYgGwDp+dczQ45u3j4MVRIZQmGY=;
        b=YBC9XPDiPaCtsUBLt++1v7Y3OfiXdLweYOKXh4luKUe5l0mArUiMgnsynHMyE5pRf/
         7f50Oi7U2fBoUWLWOlOF96uPeoFz/ZacpCk/m0JHtGbb2SjPVkFyQT6LqH6sicAHRAXR
         OAQqWxqWjhjjGXfKAnQtozcfgyJC/SQjj6c83T3Bt894odFt6Uy3Fu2mUZwe18RuHFIQ
         QsZgMJTM8n+Y6RB9E0F2B0yqMbmMt5/phqy/klzPXez0vZ8JTD1vpr0bA2mqUvOkb3o4
         iss6nuaxBKYSuHi2hbZYfEe7bpedqgtkHP9+I3cKK7Lrhhr/iBo86ff/Te1B89voH6NU
         1tkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789736522; x=1790341322;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CKF+BfwHstfALzVlcYgGwDp+dczQ45u3j4MVRIZQmGY=;
        b=VdEjT5amnMbIUJ3LP1qbKAhoXbE7RnxC5CU7ewwr4+WYBo5Qmv9eywhnvejFtFzjiM
         ap8UmaLGBfQez9vGPnOsE4vqgUMQxS8NTyAF0WmEkrQx/Po2YwyhDS7V3QTRrnEiyp9/
         siGXRP6sSnrnP7ssdffCaAdvrUS08bIDPzOe7isSWYLjDKLqr7zFuBOgge9PYkao0GaX
         22jLN+Tl10V+qBOSPoYMF+/YIkc4ViysAcpxcOzm0mIOsfb+43GcbE6W0iygfX3pl/i1
         HIO0kWkZQiCXC5EmCkDJqLyMaAWun2mWYg2kvOMiw0EfhGFcGyIKw9drlJOF273DoIYW
         /+0A==
X-Forwarded-Encrypted: i=1; AKwUvBypQAGQ0hBFFh82TjmL853jfA6foUEwtBBIbsO3EjY368w6ttK4GKo01q0DWvMdVV27JbInmfQXmeCj@vger.kernel.org
X-Gm-Message-State: AFuF++lIEAcsruy5425WojGFnsYNdvHfHz7SNFcw6JXUVCBdupvigskM
	nuvPS720xguPan9j6AZapDzsHFE4rKiKvLXjWFVOCxeg1Jsv6Ugcj1K0+sxiNqBgE7IIwlS5Llp
	43NxF7zljSZpFQOI33rwqbBPDI0tMu+ZWqDzYJxAASZTCGOETh8h+pA0GFHJZ/E/f
X-Gm-Gg: AYBFou3ITdQ7/1fB7CkETrLXnYvw9f2bUMUrz7kyWBzfrl0QAVUHIPozuUnW2/W/lKk
	ht8sfPw7k8r6EJssFK/qE32eb+wKCqUpDwNzC8aF1fzBW+BLKzAW8XuBkWC8xIPCYoKrndVa5I8
	XIdTusrJDVFhM9VDUIxXc56SlXzfpPbMEEWvTKMA+2D9MaSH67vEmLCPUEzAhj5N3TLu3X2Qc6i
	PHLXRVq2FL4pfzpYi2XO8dtgyEkQQwXx+BOWb47INOmwZiXe+fdPCApym862M3wdDB+0I/nw5i9
	a2kuNLgPIZ4sqp3+XPEjBv43kruHcwJk7WVa2cVB4eZFkv98ZLmLI38VluQSu0vrciP5qkhxkVj
	dg/mRCUZbh7+XcAh30wy+Uw==
X-Received: by 2002:a4a:d857:0:b0:6bc:dd88:2782 with SMTP id 006d021491bc7-6cb1f3eb6camr1100939eaf.0.1789736521986;
        Fri, 18 Sep 2026 06:02:01 -0700 (PDT)
X-Received: by 2002:a4a:d857:0:b0:6bc:dd88:2782 with SMTP id 006d021491bc7-6cb1f3eb6camr1100874eaf.0.1789736521490;
        Fri, 18 Sep 2026 06:02:01 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa58f3236esm815027a12.9.2026.09.18.06.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 06:02:00 -0700 (PDT)
Message-ID: <1229ea97-9972-4cd3-9697-ab03c64c3fe1@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 15:01:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] arm64: dts: qcom: glymur-qcb: Enable UFS
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
        Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com>
 <20260918-glymur_ufs_qcb_enablement-v2-4-16619f7e36a6@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260918-glymur_ufs_qcb_enablement-v2-4-16619f7e36a6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE4NCBTYWx0ZWRfX6zTUXcTZat3W
 6CZVOr2tCQSstBfyH2xIDT5zF/0cx6y41RNS59cVNjNZPnOSCS3I4+WN0IodYME1Te/95qHUX41
 1Tqb42cl6VouVHKhhL4NeRlJGuUR4x4ZPKV3fnld/mqvSA9vhmVllnGHjDW90RV0JECsbcWcc9S
 BMo3SUWqX1YYuxosETwd9dbzXoSfU3ZDSMy5oVD4tomB0INaqV9Ucc8TFvisvI8u3peGN3E08N2
 R2xBOeDzB4QzhCE/Y4DL1qo5uoQU0vYp/haPVcp23bMehbc6d+lKc4yCIc3GYVWQua8PX84w6a1
 sV5p2B8JVo8zeU+rKmgyqRgqHEHt6JHqR2Xu/uQw8658QUTat6XkvfFYmTA/kF0RaFPqfnZc/gR
 US0bt2gCJCzwbLhkGAM+zM5reHcKA31BITuuKNICGpor3XNW0U6UWYXTf6bnLi6Q3nvwkQRcESe
 jppi/bxMwYt5waWLKTg==
X-Authority-Analysis: v=2.4 cv=E+5YNqdl c=1 sm=1 tr=0 ts=6aad364a cx=c_pps
 a=nSjmGuzVYOmhOUYzIAhsAg==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=BBNwevgwxSeHGHzN-EcA:9 a=QEXdDO2ut3YA:10
 a=1zu1i0D7hVQfj8NKfPKu:22
X-Proofpoint-ORIG-GUID: R5ai78J57LiUeH67RT4TXbYHFpZfxvwg
X-Proofpoint-GUID: R5ai78J57LiUeH67RT4TXbYHFpZfxvwg
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE4NCBTYWx0ZWRfX3T/n7Y0bKGcs
 AnliDh7laAQ0asavOdICgSSsS5LeQsfGeUVEkw4/Wz8ji4Phg+lqTluBmGLMAuvvgYKNJY3HNyr
 7eBJ7nIlwrfcERx1gxROVymB1Jeva8U=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180184

On 9/18/26 12:39 PM, Pradeep P V K wrote:
> Enable UFS for glymur-qcb board.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
