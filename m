Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471D2189BB0
	for <linux-scsi@vger.kernel.org>; Thu,  1 Jan 2026 19:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767294190; cv=none; b=YFKo0w+cn3238vwjNXiATGy7mnTYMNPyD9aIffMkvvz7WstPRVZrA4GOd39aIdBKu0//kl45K6PAnu+Cp3KHvkyc0L/EP4Wm7BW/iUk7ZZ3xpJ1ol5lacLEhWCC35Ngc/sBpXD8wEcX3QEQofdg2rHQQib5HizA0i1fcZzBDJlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767294190; c=relaxed/simple;
	bh=OUWnoWTNPdGbUGux2s2BxAMRUnlVB6mcFngLAWpA/PU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoSwo5nmIHyCqkYueeVWSqRskchUrMhCatBJXMAIXmOHVnEL1M9f6urPbGl5reGjYD2GLNGvUqokxOYjQGDXor5hu44UEkQ8KmcxjFbGs8/tCDE749fY2SB6gvBqPGbUo+XuFov5EA3cbHCvrWLH8MCg1aHbmn3o0Ee4+gmAd/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DVk5OCmg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=grW9bqdk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DVk5OCmg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="grW9bqdk"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 601Go4uX2553780
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jan 2026 19:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=+QMKwEVC7Suor+bYorU6lSsj
	bvDGk1qiJYr7KsqFwEQ=; b=DVk5OCmgh6we/gApUU0oj6gT4khXU52t75L5AuaW
	zGZIQptxgfMCq6VDx/pC4ailine5HN19W3s7r0i+Ou+C7rIw4/thOoTJ4uKFEJ9N
	gyRxHVG+WtkXI8gcBy9FqyYLrw2kbCl3ESUIiKhhp8PvYuU6pCXUE9Mab39TU2zd
	N7dAtKeLfLaLvQ9cHNQEo3N+zXb+/tYSbrFciu2nwm3k7V4iggRR9xSxLxymbhwI
	jOynhDD3Zy1p0qVdw/IP4dWX81sKWEdcrwbCZrj6M49Wh14nlcti43tDLGSxAjm8
	Xbum5Seu7LOxu/hJZMlAfx3J3WyeGljVOrz5CP0e43HJbA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bcy6aju93-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 01 Jan 2026 19:03:05 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4edb6a94873so226371621cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jan 2026 11:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767294184; x=1767898984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+QMKwEVC7Suor+bYorU6lSsjbvDGk1qiJYr7KsqFwEQ=;
        b=grW9bqdkNeMxDEAUaB+5uZf8vUpgfybNZYDnES+dU2ZBUwxr+hEXrCbmO8e2Yt3WLx
         xHz2yqqstwKYuGx0u/dNgpD5aAQtb0QimYUskqJ568sox7je3aqJugZHSYgp8dyohByy
         m1P8Jg9WkEBLzJlp4GOqANbAa48Dp2SCmQoP3+qVEinzrcnut3rQv3N10sz+ezff9JHj
         XM2Oh7Gw4bFlpVzww/wPVaptjaj3DCS88EE3yJE9X/1hGpFrTd8NJVjcKtqWRJ1RHCd8
         2PKfJKnW6D+EjWyMs4vk4DSZvI9gl2KHSPKRLSoagnvWMfuw1GH+u8AKQAbHVMJ56ZiP
         yBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767294184; x=1767898984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QMKwEVC7Suor+bYorU6lSsjbvDGk1qiJYr7KsqFwEQ=;
        b=ToyOeM0tn5TqH7KwAosnLea04P1WmQqbbrMIGpLN9EckRilf2cr3MtRoMcXt1NbYiy
         v15CZFKa1mj0bTHRf+lDSIC526qgA0kaTwTGE06YiVsGGjUGkuGCF3RSEUktgEdq7MlD
         a4770r7kRkNgScYRTBDF68LjIJnGofroHG0Qx+wkx6hnGDEGKa3cwla7VigXWp+Rf/mX
         xF3gY96VZnizFjCiM1AYmhtE6DpjhtWKDBl5y/c6vVg4JAejdAJMV/OodXLS+i8Havsx
         6qpAQmu8Z/PGEAml0eCh54K5tpSFGsV7xQsGmkma9roJo3b05nlOifyx2E1N26w7UMlS
         xzKg==
X-Forwarded-Encrypted: i=1; AJvYcCXnTiW8IJchLazq56NUIear6jlKDZGKhxeHyLETwX/Lc+P644voetzNr70skrvq9UXwzgH9Lt1ValKd@vger.kernel.org
X-Gm-Message-State: AOJu0YwzawWqNgSDsz3jLgpH2gp2AjcbmbF/Ax/4rt1mLaMCmITyaxhS
	/KWQRv5qarJqMhautG4jp1jZO7/weCtVnAjE3jQkzXb76ROFXPLd18QEgK1PLiUARlCmkyiQSvU
	KqJAcDvF7i4MU2pBB6apGndmxTMr9tMAOoylESOXsw7Il8KkQpo1KBJXsPJugmxy1
X-Gm-Gg: AY/fxX5x/JTYk6phgl4nqE8XuwE9w7bjVae/A1rpr5lzgRvBsUUEVVM1f1+tmQmDZpA
	ba1UvODL97JFVtW/2PgZpGomERp0ECDi9yKuTa20dn/6XBxv3QMmmVwNJbGuHtTMq/MJRmqIAXu
	T9r0vKELKOWNnoNgP50YtUkQZxLisgS5QvSd6zGUQvEvEb313khSvMbr4M6XiIGj7tS4OknSsTU
	bg7hPReKdyeIjAQaT/8wQGNVPIUpjzW8cM91xFCbPVEF4i3Jk1X/vuUgBRV+uiOVe4zqI61S0gB
	V1uDtgOTehDw2Duv5CXXKKsZvO79SLlRA/EqZGg+SaWXr0OCBJcAoAwtLiA33XoSoIBZxgXr1WV
	5JELkywO9C9F7DfdXwFZy
X-Received: by 2002:a05:622a:1b29:b0:4ee:18dd:1a1a with SMTP id d75a77b69052e-4f4abccee92mr592914661cf.13.1767294184270;
        Thu, 01 Jan 2026 11:03:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbz8D62YVcxQdedAk3k/DyH+ejsCG9KzvNP6zqm8qsDsaBqLCPblpAAvfwL/lYPOD5YCY0jA==
X-Received: by 2002:a05:622a:1b29:b0:4ee:18dd:1a1a with SMTP id d75a77b69052e-4f4abccee92mr592914251cf.13.1767294183805;
        Thu, 01 Jan 2026 11:03:03 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.7.10])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f18575sm4226918866b.54.2026.01.01.11.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 11:03:03 -0800 (PST)
Date: Thu, 1 Jan 2026 21:03:01 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH V2 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
Message-ID: <gq6twkddeshvonzuyl4jcp2bsy6wzsveed3figx4sxeatrr7qb@ulv3d7dust4j>
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-4-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231101951.1026163-4-pradeep.pragallapati@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: FQrWgxugybo2jIFP8LvUkfYqc4A3ej1w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAxMDE3MiBTYWx0ZWRfXxFkbnPjJTc+p
 +nNa2gfhPQ1yyBXYFe834JJUMrrz9/XsXgIbEAtXSNCcn9yLnBIDz7ZFQXM9GDSrxU8bcFW7fpf
 f/xKdkAK6BkUDcl3lNSftlnRlSXkk9KknwdOUWxLf7XG81k1bMwqEQmVqvLJbDO+8os8JAlBz9a
 X6taaKwwQqvu8eKcq1TwzZfaQOVW+gwV+QxhjO0fuxJtjpIeruxfcd4qxZ1vAfR1EkB36qPe0uX
 r/hRjvTJAGoI3AApChYMpf4ZTdza/y5xTUiE6gbRrYwyIuAx3fKCRIMOvlJ0Df3n4Yp5D0SsjP5
 2aY3GUhZPoAvTVtwa1wNkLn19e7N58RZU5psAoFlIMMUtBFjEQexmUrY9bEp8f9gnPA7GW2/Gty
 Ot9jT39HCI4QjmLKhVIcaDeOk3OFlcmb+Wlp2XFwRG2xrqDwjX3kox/IB4bg6Aat/9JvNeN2BpA
 H/4q9BDtYEYlYl1kMpQ==
X-Proofpoint-GUID: FQrWgxugybo2jIFP8LvUkfYqc4A3ej1w
X-Authority-Analysis: v=2.4 cv=J9GnLQnS c=1 sm=1 tr=0 ts=6956c4e9 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=hZ5Vz02otkLiOpJ15TJmsQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=P1SvqDdPwG-YsO9EcX4A:9
 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_07,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 spamscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601010172

On 25-12-31 15:49:50, Pradeep P V K wrote:
> Add UFS host controller and PHY nodes for x1e80100 SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
