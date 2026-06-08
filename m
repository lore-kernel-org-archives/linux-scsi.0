Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EB53DDDB2
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 18:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943849; cv=none; b=HlkwgWnL7416KwshZQvwFIUTLIaAzr9eZ944cehrmpas2IfgbfGpbpC4xeVJXoOZ1OC2a7Y3lYL+T2yTqlmoDJvHDL8ggFytcjeSMAqLgHflGjpVK49+JfvfG34q2N/xGyY/c12jRqNSWLA3Ha2CG5y5SQRBWCsfW1fa/nqU7j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943849; c=relaxed/simple;
	bh=Gf04WEalx/FUQCjoE4Tim+odsuoobVmL7oDW5+HAgG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROUnOMtvCQ8A9xvzvgfngjyPbf77XwzM9iySI0uI7rPOGti12GtDvtLHb4FZMI6bCB8SOKjD3AI6RfnUeiYVPgZjS3i/lW7RPOBK2kZl2mfYRSJfOjm9Wjdl4MnNSrXs55VY50wqXCSR+XTtrDZPzodtROHxWaEL7yoliuZ22pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ve6KxcPd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hbipcLAe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ve6KxcPd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hbipcLAe"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658FFe8g4008673
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2026 18:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=nIZ1j2oO4hKk0sVO2Hu6TOAa
	KuhKzlRHmyJatc66WiA=; b=Ve6KxcPdZvl6B8I2F1YCoUs97rEowdCEDqmkApdl
	AvAFb+rdNQVgJrGInOIQZDLQeb0Va59EbdNWVN1qAwmswzh/aJf/LKpxZl2QHGmI
	QEUhvr/pdHKWEGtPQoQFjEeMDJTbTATeMCiYlzsxFwSu6yL5DjZ321dRKkNoQc1E
	TBLBYARUxglCCr55z7VpDZ1c857hMtwlqFYM7R6mdDY2VkDSMJpeXCl7FZf8Z0N7
	UmyIMbUTQ3bCPdh/CakIvYBSVXUtrQIsEmabCc4/XWhnb5b6SBjtMEUTbCMop8fa
	2QipVp6uHvplwQGH67lk+iAQGs/8vP4NE6nQxJElk/ggUg==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4entr0jq4q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 18:37:27 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-6cfc66167c4so1893432137.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 11:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780943847; x=1781548647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nIZ1j2oO4hKk0sVO2Hu6TOAaKuhKzlRHmyJatc66WiA=;
        b=hbipcLAeNVhUYhaQ0hRNUtdHc69IhOJkjsg3Kf9gdgXC/oGZbs+CXUfTs0aNPop2xU
         O6ci6IOgsC6hwXe87DaRnIrn7xNULuAOfFclvyzwZ4RxPfx1ZxzBh5J1xAbeYoq25B5x
         sMPt3KXTaNqppdOeJhph00oXvN15GLKv2qT/Tm/QyQfET04taqhgKUQgw/aLSsWp624K
         xayRwvOuZz+1FFRqrSSQhZDbOqsjwknxNnpnwEyBLrKUyFGZ6sNaYHs1NRd6nxw3bDL+
         71vUnzUJwCLDYlhYarvaW4F/nXXxdjbXx0kHV2ZoFh8O6iEP4L5L+J/30U62+AbbwPpc
         lm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780943847; x=1781548647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nIZ1j2oO4hKk0sVO2Hu6TOAaKuhKzlRHmyJatc66WiA=;
        b=S98SUgk5AXfVLQ96nLSKS/hJLDsM8Jgi1iiAni+WXDiNn66Jzi2X4MUBSmdwwJKg6t
         yUJmjZXSveYu8rI0A97oyHgH3TUU8pokNGk9Nz741gIgoDWJ+4SJEzotDlM3NGCa3j2V
         rBKUepEmv+329tZOqv02wi7NWYiqvZ48jr8tIV2MxUvK96RAYQ7/tOBMtwhRxQhh6xpG
         VwNh6GrkfNKbBJCyOPcaq8l0Ukt06W4O61EEgwPHaDWsHJV6+kwZEsty3rsleyeI7Owh
         5Gk5So0FyiTLvnQRsOOiPaKyjGwq3RfKUfjH8aihhIydhR5MVl5xZry2GcEUDBALrq+n
         emWg==
X-Forwarded-Encrypted: i=1; AFNElJ9OrwdJR4yTCwyGqtEeLBDcypIvjQ5Yu2DbXnqlHdbG6v7+r3JUZeercGmB2WTkoZh9OiGFk2qfNHeu@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb236gw3IRJj5tu+GZqZV8MluretuBF8RAv/rCS84SLi6VU5nb
	1xvZQNQO+FtWnq4vQoS7cRS1guxhxLRDJPbDqMaHT9nqBD/H0oEGquQDubTX4T8txTsR2ajCIol
	mjPo8vjuG4Kpdu97V1AtBBRqWWsVlBOJO7KkKYMb5CNh8QtHtqJ0239qXIfTF9doT
X-Gm-Gg: Acq92OHOlal3WxoIWMVi04DJ0KsOaF8mp4Zu9ZoFXY38MNjfB+4TkuMBF3LDBSN8N1D
	BqTibopuZ2po/lU9pf/KaQgg3w9bGeFzbI/jnoOZKeB9sFjmQJh/WodDE1el5eX80tPVtZyZnDE
	Hot8dXVxhj78YY2ib3bHPhql79GUX6UwH1QSJlpW23LNv6igJ+PTeZDGXIksjX+LBQHNQOrdAUb
	oz1a48fAorGsuYYRACTI8Sm81GIyk+jblzurVy7IHGq6VG6Mcr9JIzpOUDBXClS4ndmeGYxyXTo
	Tk4d+8VmwEaFBzpqE3AUA4KI5SLQMVXynfCHrY69Nxd+b1n9p1HoH56z2YMtFViHQrERJb++PEF
	Xwyp3pKOCiysambBgjVJHbZDVXp4cR4uvV4QayvCNMnvNKQPWtCaO1OSQgy3iBbtm2wsXml+dq3
	Z7uOOtH97ZvheaFD3i2KWgXcaqFo3G6FDpW+bKDr4vojeTaw==
X-Received: by 2002:a05:6102:442c:b0:631:81d6:e15c with SMTP id ada2fe7eead31-6feeeea7c1cmr7778969137.4.1780943846816;
        Mon, 08 Jun 2026 11:37:26 -0700 (PDT)
X-Received: by 2002:a05:6102:442c:b0:631:81d6:e15c with SMTP id ada2fe7eead31-6feeeea7c1cmr7778948137.4.1780943846371;
        Mon, 08 Jun 2026 11:37:26 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b992a66sm3938821e87.74.2026.06.08.11.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 11:37:25 -0700 (PDT)
Date: Mon, 8 Jun 2026 21:37:23 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH v3 3/3] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Message-ID: <25m2ts5lomrmmxkjc24t6ky633sb23ge5udg3z3rln2jaqrfh6@46xrntztb24p>
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
 <20260526090956.2340262-4-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526090956.2340262-4-palash.kambar@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE3NCBTYWx0ZWRfXzs4Im6bdWpKM
 +HEQNisWjqz4J1oYjUiOhU6zz11yuzvozw3onfiVV0cc49f/vjMJzwvcAJ1iuHdQGhdWH0apjNu
 qc973CX/iY0O23s2CKCdlvGG/v7PoaIKl8VT9csOTIvtiVj/akp+FwJIJYtV/uUaAJFB8epox1I
 1sQgefJhuiFw1rTgcN5iIwqfICmTads52J5/rs9BgJifLReBCOpRHoIWpt9m50eBvXZMRaKZ1HO
 bYfHBi5HSERqjbKDctgMKqAOrWGqrEov3qvP/KMginAFNDov0yI6xp6kh5hMOITi/uF6KUT2ZN+
 3Le/IQxn1TBGGIpec+nXfQ3XGqdQtx0pp512EfFuXS/oH1s1hR1P1KAYAMqJ/ThwgrYVsUTM+2R
 TxDtlDhTE2tIQ6T/mPH0AoE/Xi5FyIVN3etzt8pAfhUEnbDSze+kLjDnmh97Y6Xt615lA8hltT5
 xbxNuy6xALj0vNlLjfg==
X-Proofpoint-ORIG-GUID: LdRmPk6SS45JbfqmJDGaMZRA14D9i_wC
X-Proofpoint-GUID: LdRmPk6SS45JbfqmJDGaMZRA14D9i_wC
X-Authority-Analysis: v=2.4 cv=VowTxe2n c=1 sm=1 tr=0 ts=6a270be7 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=4nhpQrVHSdZsbWUMf4AA:9 a=CjuIK1q_8ugA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606080174

On Tue, May 26, 2026 at 02:39:56PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Add the init sequence tables and config for the UFS QMP phy found in
> the Hawi SoC.
> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> ---
>  .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
>  .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
>  3 files changed, 200 insertions(+)
>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
