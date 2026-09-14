Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5D34718F0
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789394598; cv=none; b=hjMePRqxOfL4yG06V6SkkM9vkIAI6+xJihpPKx1KKNEJfpu8PmiWKJBCt7w5wztHe0aTp+Jp1LEvebnUs6JvCrkNejSk2X4xhwU+SUI82ZWL1ttFIWKbAd/GxrHtbmCwcTmXxZ/dmcZx+Qxjd8x5rLUPtgu5bF7E4mKXqehvG9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789394598; c=relaxed/simple;
	bh=veFrKTAc8vROn8LflcgK9hdghqncqe4wOIseyA6YVQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tz3PfHpcUWfyCGLXrrsGQb2YyOWGGFcY73cwKwzNrlw8Xwr2EwiLisBDOWuQjFOTURMx9OuZs5CzxNbds2tYK9XMUBdZqRBmkMxnAQbG9H8AcWD9roFIdkCiXgqfZDkmKplsHHxx/qtRmxSOjQywuz7r88VSSOTSsKeKFmBGPhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YBhRUMTc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eZCekMCL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YBhRUMTc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eZCekMCL"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED0W0K1025773
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=bJLwYSimBgZLHlMCLJs49ctc
	RaD6WjoWxoa1Bx4XulI=; b=YBhRUMTc1WezRos+cEr+2rhnWlYmqXw4Hy9YQP2R
	vaQiwLYmZUZ8Suz0/7BUDm28BYVZD4LtpMKwKYu0jF7ItWIo/5SSG0/LMCErm2oz
	Z7JhAYel1S8oqrf8uKWyIoPqgkNEoeZc/qDpcJGcWgP2OVlqkZVogaybUlB4CP4U
	lMtgTeLyBOoFxOt4V2T5F99G6i+F7XrteMdBre6o66LI3/QILsi79xxDvmZjVA7k
	o5NKQDPG0CVxpb35H7fdzqjKOMF9T9+zJjjzlWo8Am4TWi/SB0rdgwSEuhMa/jxG
	V4d/8e8dU6tv2JZzQHzpF92Fb9aRwr5QOglGBS/fdOpbgQ==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpdb5s85j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:03:15 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5c664499696so4232659e0c.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789394595; x=1789999395; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bJLwYSimBgZLHlMCLJs49ctcRaD6WjoWxoa1Bx4XulI=;
        b=eZCekMCLLzvwjyeC9n0dbUS2Gola20W+XnfkOcBfjSo08bjFqdry46ATbNuLe5XKPB
         XzmybGnqnuV5Xu1eBwkkYetRYkfkazs1MJzifQ2buZ2YS5DKBZvNKHY2AJbBVksW7Gow
         F2WHyUGjPy4MfzXBukaq/iv0o/lbUoR4vMkt8f9O65R64PvtGCgH9yaYS6LbY1s+C2cD
         1y+bW7fqyFNAYq4pteJ4eV/ekVe6JWsXz4TnQEc6d3feuSiU3k09LpKSGFn210wcBwR8
         4d7J4V6PEc6U8TxxbkAfFxfN+oVK93W31UvZK67ABCqRhn11gMml1n4j3mqea2Q0Au+J
         4p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789394595; x=1789999395;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bJLwYSimBgZLHlMCLJs49ctcRaD6WjoWxoa1Bx4XulI=;
        b=bx66KWJ4PQqtR13+qJhK2zhK9M1dCqL4IivyrhmPTlmGHAoqd06zrNPp3dln/nHDuk
         w2I81BNsPq7HWNF5EzQv3SjP54E2XZAVUdEPCZT2JJ1IjQWsvIO8qWnWYQ6fgBdThzuy
         EdDMi2WqLMSaTEavEntXLKHsyME5g6FgfdM8SeVLUofxriSQ06XukwaYAFohOmUSWUv7
         FggM5rp2F1uoe1wp067nkV2QvpUR+yAdjRiwiGhtn4PDJ97ckU4aqNkLedm/HZRdNNHm
         kV1IaRXUIxcxktzEARzQ1Oz8djEq7lb0AblJKZIj0u/D2xB/8K0O7+igigzPCOw/KRDp
         oOdw==
X-Forwarded-Encrypted: i=1; AKwUvBzFrNBuqrW7exn2d18ffWeaNgDWnnvuK+KpwMASA2eW08JveAMKMPIzNPaVI+saTHjNzHZ1DzbsmAnO@vger.kernel.org
X-Gm-Message-State: AFuF++kmQI2ppGOoOTlnSRDOOM7lo/hxB/jLPf1ojbaDpht7DW173cPq
	vlae00HYI6j8wV+WaQbrHTF/nFNkBZwyitxN9n7GSe7oS4+8bT4BBNJ2V9QHmJmkXYIuTn9Pn0j
	RKwO29oftWbfW/5Gk35RKjbz72bUcWhMXE9O6WgUNEDIQDH5wiUjBUIQLvYmG1f9E
X-Gm-Gg: AYBFou2c1oMTppUjOQ/+nfBlSuNV5gvPWiNA5WDRvKdNa4P1TNJJvQ5cla+VkuKDE+B
	EbuLx7iAyQSj1ND5VR1V6hJ2eAsWuwXWLxmFbV7xa2cTiONZPqBAwBPfM0PvnvAEGeAiB4WiStw
	0cakhfkzzdFtk/amqOvws7Kj/M0en8kTZbNRIGectWwg3/QYx5rcGCv5Do/ryFojVWIJFD/DD7k
	i4XrVXGgqRXIarAa/ygGxiqeFEf0xS5e+OrNhyTA93quDfuwUoB8Gqrtk5Y3lubzeToNzpqcwY5
	fSj1HP+G7LiRf74KBeqGR9DxxwR3o+rx+9oihV+xTJ90s1Hf8jjb0rQJ8TzKvmhj2BhKx0tfGDk
	iZJfc52ptJhJl2k4=
X-Received: by 2002:a05:6122:1055:b0:5c7:c898:9817 with SMTP id 71dfb90a1353d-5c974bbfa09mr1904970e0c.7.1789394594861;
        Mon, 14 Sep 2026 07:03:14 -0700 (PDT)
X-Received: by 2002:a05:6122:1055:b0:5c7:c898:9817 with SMTP id 71dfb90a1353d-5c974bbfa09mr1904778e0c.7.1789394593473;
        Mon, 14 Sep 2026 07:03:13 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.170.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb3602eesm25999064f8f.34.2026.09.14.07.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 07:03:12 -0700 (PDT)
Date: Mon, 14 Sep 2026 17:03:10 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
Subject: Re: [PATCH 5/5] phy: qcom-qmp-ufs: Add Glymur support
Message-ID: <bhwywy2ldrpwff4wxi3slisbggqt74pqz523ksanusssmpfvbn@ht7pp3fafw6p>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-5-b9fc5e2ee99a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-5-b9fc5e2ee99a@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDIwMCBTYWx0ZWRfX+mOA4dSqFtb6
 EzR9l+vz0lbnsy6cwfx3bVkoW4AKOCRH71MyQ+VT8QAdQY9NX7qlJgV9hIFJFnrzKxk+Cpf5+vT
 j7LIrXKQhO/JLInO+7heylskX3YhdCE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDIwMCBTYWx0ZWRfX/QY4+RhcpA5A
 flgKQ6fgUxKCi3XFrBc7HBoFG8wsH3Ia2R7i2K1NM0r8LpYb3T6W+W3I1QiChizsKWeKv5aF/S0
 4gnUJNSpfN+zlchj34zdBo1aNI04Fyv0hY7uQ85KtYsSguPkxBzjg7RysHm3o9WVjxlpLNg46Wi
 2+d9/Gf/1MFsTqdA7DJNTGA8BsmwTXX+mIWDvB4vw1Yo0eOcpth3j+qE29qNc46nZztl5NOfP3x
 YbyoUkcO8nb9fkR/O1rX48HF1oQBSIVNh0O7cBVCotQyjXSexVd1y4bEwFl9YdjZsayp1nO12N+
 OUwvJ5oQYVbxhj9f3NE4KF5hZK/Y73y/PwUVAM4dRdoSBaBZWp0veJbNuzF4MQrchUPqBz2ok/e
 COsjg1WW0uFJeZAzIWTFu+9B7J4l1aD/ZrJ2GQAyR/Vtfl92G5SLgaeBP1ODSj8tsZ6yzPXHyeS
 fbWyGS7cyEzu4JLQYTg==
X-Proofpoint-GUID: iRs9IVkzNojex52zNI_PT-cCfjzZkPEf
X-Authority-Analysis: v=2.4 cv=Ie4Symqa c=1 sm=1 tr=0 ts=6aa7fea3 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=po8fGBi+ks8MzcVQGuqtFQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=l9x3Jx16obnCIVmqrg4A:9 a=CjuIK1q_8ugA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-ORIG-GUID: iRs9IVkzNojex52zNI_PT-cCfjzZkPEf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140200

On 26-09-11 22:17:09, Pradeep P V K wrote:
> Add the init sequence tables and config for the UFS QMP phy found in
> the Glymur SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
