Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8170B31E847
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779698748; cv=none; b=MY9+sLkarJL4gzMAwQtx3Xmb8JAg8eD90gZcMDbSb9X2DHHyeDwYs15/zyBJdkzwpd+yETqmDFkq/zi5bJ/1d28AWAhVcnHv5mG8+E2Y6xJz8tLWpACRYw/hlqx+vThOBvMIbxqmukQkxiCBP13uEHZvz0rd1UBoAfkPbP0sB4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779698748; c=relaxed/simple;
	bh=eqUB+beeVwmV54p8GMWozUcJ8djAAGWZjc7y3WMmUk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5qCQ9jAJ1e2qDQFGg59PDL4UoBpCfJ6eBFprBEMRfu8lD8ISYVUsk8Hpzjryv7mNV7djdLArkoCPriyIIDcVF7yt34a8WIOwVE3V0PfdGNLqkVVVwOBzlf3IMVQfBUEbYFALdnq4790oioBUwZGFvRPmqoDUwuXPJ+1reKEXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UXvmyWvm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Era4YHSP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UXvmyWvm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Era4YHSP"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64P2au4D2261356
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=PUMbg6cDpe8XLBpHj57dSo1q
	TWRy4Xqw6/CpTC9UXPE=; b=UXvmyWvmt81bxpC3mmtVfd/pAqTjpQeDifowuZTP
	qDx/S+XeFBPKVw97IU3D05wQCd/TlnpWUiB3yDxdbJjhO6QVD2QAVdzuEdpA1hZy
	LV1NICTC/qKZMkejOx7C/pveMXc0qyrkGMuuOpfF8CpNDPGllPnQTeLuUq543Ur0
	LrOMQlV71aycQWRVtfwSEAxogQfEdkkIa9Dpqonc8o22qYtnedfcSm9glZ2HasN0
	qsDG8Te4h8W5iRDZVfEtzRCxoaUqcEQCJFe/J5J9XDlvQnYDTxvN4OzHFnLRuSkX
	ntnT0gcXbyUrxX1onwDaYkkws6XHESfocjA67/h+3usInQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb4aswvcs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:45:46 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-516dd6e4ed4so54216391cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 01:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779698746; x=1780303546; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PUMbg6cDpe8XLBpHj57dSo1qTWRy4Xqw6/CpTC9UXPE=;
        b=Era4YHSPpVRmT7+wwgqi3bGY+GZs+42P0W7HudoALijg8IQF9tE2X7TlYe4lNRy9Vn
         P+OshjhM7d77aLuJNAL6bPlLwTV2xg4mAbSEBzf+ppekYBHcK/Qusptq9b4TjlnCC7yn
         nKI7Ft5iCrnMl3hNUVEpXOEbcw9rM72hRxAJheRO6RrMboZMIkkohS90PVVDMDyzAsWE
         lP1A9NS1edT1KZY0W2yqry9UiUUXWP1QAlAf1VBuV1ePBVygqPDgWtTc3C6kKPQ/8D4b
         Hhgj81Fp+UaNH1Kq9AdOl8QXv6BFZmYe9qUATLIwYEo7R6lZGKxfWa5DTB8Ur2Ki5M8K
         SVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698746; x=1780303546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUMbg6cDpe8XLBpHj57dSo1qTWRy4Xqw6/CpTC9UXPE=;
        b=q8sWcbEWkSMr4LV6Ks+SZI4CLBc7uC8RI82PE2u9SLTi7IAmU+xJf4iLbaHGUq7cEH
         Kd5UowVWJUteGt+SoNnvV0pDYiF6CpXuWm8yFKIWGeLm8q+Ec57lKcj+k0UlCNGt6R0c
         NWX/IeswhOklrBK/5Yt2j+qiyd4ARFp2WjMnLHTZ2fRllXuufmu6hZZ0WgEGCRp4IDBN
         uMenoXyUvjTTAcrx/i0vqG5ogrNd5xL8ok5/QSLjZxQNs/Kly/0DagWNRTh1wTXihy6d
         aiVoxdzB6qFZBJageI2aW21kY6fzkwsxDl7ULsahoKfNAxn1aLonMntjk6vL+uE3QkB1
         5pcw==
X-Forwarded-Encrypted: i=1; AFNElJ//Fk8y4bZmqb3iOQIPAJcmls2ma+PUhzEfkwbH/YDFE05snLmIiq/6GyjReqLk5sCAAtuPD99JTNdy@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9eFOxydu2nj8tdRON9zlSok2HMESTnXdmxckAymY344PQbpl9
	PP4mF4EAhtYc3UROeprNpDdaNhS0QbXb3B8IzBoGVw9Aa7KLokeZis8ANaGCjJV+fCfsOL/0PAL
	Ae9T1hSNhwKTJHSCNX04z7rtss5gzzw+k8DVh9h0/bwk1wmhHY+C5ZyF2PN2C0Zo9
X-Gm-Gg: Acq92OH9ke664/a7hIdiMh2sPwDC3BaJNVXcpOpk7I9U57TisFI3OfYDJMz/qH3uXDG
	XY76N1tam7aMGFLskun4ShUBhUqzXpCMLyf4HH3aeZfC+u3OKWavfgz6Bg4J9hPHt1s/MCwcPqk
	SqyosAbkWyfoFsQT/uvU48AznpmVc4BE7ZzmnvPP4J0RlinU2ZvYPtLWQ1yFuA22RwWd3wJoH4+
	FTj/rM2CDUmSuRyeMSJ8AcDCXZd8YbDMxZKJWZthURITlbIMCsYVvmHeVW8n7T4KVGeInJ2TCOp
	idfFcungP+TF0AfHP7TlHgJdHuRRUX+GbbtAFwbwVoP6opDNYfUmjKye1/NEKDsIgWZ3BXKtIzm
	z3ZVhxZdMMHc7qYOLjANAr+pEKeJwLB2eps2wAHHSxe2Wdgh5pLRE7ZH7JzYOkwRQTm/LLiDWZN
	owS1zSAty3777aluRJbtlZCN3yEm/WfayMxWU=
X-Received: by 2002:ac8:5889:0:b0:516:d60f:6438 with SMTP id d75a77b69052e-516d60f72demr185991071cf.0.1779698745950;
        Mon, 25 May 2026 01:45:45 -0700 (PDT)
X-Received: by 2002:ac8:5889:0:b0:516:d60f:6438 with SMTP id d75a77b69052e-516d60f72demr185990851cf.0.1779698745535;
        Mon, 25 May 2026 01:45:45 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dcc43aabsm21943531fa.37.2026.05.25.01.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:45:43 -0700 (PDT)
Date: Mon, 25 May 2026 11:45:40 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 3/3] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Message-ID: <szzkygcwnrx2p54hbulzd3edhwzueaulhpyl35b762yo4enepu@zgzv6oxdocha>
References: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
 <20260522172716.820490-4-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522172716.820490-4-palash.kambar@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDA4OCBTYWx0ZWRfXxZZgfbizQJkI
 6KPfmrnrcPXEsyqT1RwnSvfQtd/sRfgCzmtaRO2QTbG+8jG9e/crOfTFtDElvVwRBfJ3OWDm0do
 byWSyrqHZOQr9TBaP/2oL2T/qtP+eWVjRVFtW+Wm2G+FzR15SjGNcRrOmVivWJ2LW8yAhtcLUQk
 hprLjxzgpKQr7ZkMY3srf8QF/HZErE0F3+OMcfKwuyNzpAT1pmxPZrd0ni3rXDhN0cdt0dWhvz+
 qekoYmbHSZYJYsilrj1qjEavJKGLUIDmBo42lErPbV+ezN+GNqL+YY1YYdAFfoFF66Lugujv3lz
 Z2AheS9TEoitq2a/Q+PTkNJwZ55yCDeKvcKlsNrc8kE71adyAz2MrZ2df9pngOPbvvpQtk5yQ/Y
 FuHFW7Uj71Qw86fSqOZbOIU9NIw4tZI0PiIIHnYquu0/1Xz8wZIc6LoUvagrRJ1Zu2qayczED3J
 OKPlnpo7FIDP93JTHew==
X-Proofpoint-ORIG-GUID: rBhn9ehAyp1OIIOnQHIaiAEbRN5ohkPW
X-Proofpoint-GUID: rBhn9ehAyp1OIIOnQHIaiAEbRN5ohkPW
X-Authority-Analysis: v=2.4 cv=c6ebhx9l c=1 sm=1 tr=0 ts=6a140c3a cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=9mNwicV8TSN3JMHTN9sA:9 a=CjuIK1q_8ugA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605250088

On Fri, May 22, 2026 at 10:57:16PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Add the init sequence tables and config for the UFS QMP phy found in
> the Hawi SoC.
> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> ---
>  .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
>  .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 140 ++++++++++++++++++
>  3 files changed, 201 insertions(+)
>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
> 
> @@ -1306,6 +1315,12 @@ static const struct regulator_bulk_data sm8750_ufsphy_vreg_l[] = {
>  	{ .supply = "vdda-pll", .init_load_uA = 18300 },
>  };
>  
> +static const struct regulator_bulk_data hawi_ufsphy_vreg_l[] = {
> +	{ .supply = "vdda-phy", .init_load_uA = 324000 },
> +	{ .supply = "vdda-pll", .init_load_uA = 27000 },
> +

Stray empty line

> +};
> +
>  static const struct qmp_ufs_offsets qmp_ufs_offsets = {
>  	.serdes		= 0,
>  	.pcs		= 0xc00,

-- 
With best wishes
Dmitry
